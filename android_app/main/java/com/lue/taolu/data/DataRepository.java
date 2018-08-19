package com.lue.taolu.data;

/**
 * Created by snakepointid on 2017/12/18.
 */

import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.util.Log;

import com.google.common.base.Optional;
import com.google.common.collect.HashBasedTable;
import com.google.common.collect.Table;
import com.lue.taolu.algorithm.OptionAlgorithm;
import com.lue.taolu.bean.Share;
import com.lue.taolu.bean.Option;
import com.lue.taolu.bean.Routine;
import com.lue.taolu.data.local.LocalDataSource;
import com.lue.taolu.data.local.PersistenceContract;
import com.lue.taolu.data.remote.RemoteDataSource;
import com.lue.taolu.util.ConstantProvider;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import io.reactivex.Flowable;

import static com.google.common.base.Preconditions.checkNotNull;
import static com.lue.taolu.algorithm.OptionAlgorithm.getAgentKey;
import static com.lue.taolu.algorithm.OptionAlgorithm.getPolicyFeedbackKey;
import static com.lue.taolu.algorithm.OptionAlgorithm.getTargetKey;

public class DataRepository implements IDataSource {
    private String TAG = "DataRepository";
    @Nullable
    private static DataRepository INSTANCE = null;
    @Nullable
    private final String mUID;
    @NonNull
    private final LocalDataSource mLocalDataSource;

    @NonNull
    private final RemoteDataSource mRemoteDataSource;

    @Nullable
    private Map<String, Routine> mCachedRoutines;

    List<Share> mCachedShares;

    @Nullable
    private List<Routine> mCachedSubRoutines;
    @Nullable
    private Routine mRoutineToUpload;
    @Nullable
    private Map<String, List<Routine>> mCachedKeywordRoutines;

    @Nullable
    private Table<String, String, Integer> mCachedOptions;

    @NonNull
    private String mLastTarget = ConstantProvider.NULL_LAST_TARGET;

    // Prevent direct instantiation.
    private DataRepository(@NonNull LocalDataSource localDataSource, @NonNull RemoteDataSource remoteDataSource, @NonNull String UID) {
        mLocalDataSource = checkNotNull(localDataSource);
        mRemoteDataSource = checkNotNull(remoteDataSource);
        mUID = checkNotNull(UID);
        mCachedOptions = HashBasedTable.create();
        mCachedRoutines = new LinkedHashMap<>();

        mCachedKeywordRoutines = new LinkedHashMap<>();
    }


    public static DataRepository getInstance(@NonNull LocalDataSource localDataSource, @NonNull RemoteDataSource remoteDataSource, @NonNull String UID) {
        if (INSTANCE == null) {
            INSTANCE = new DataRepository(localDataSource, remoteDataSource, UID);
        }
        return INSTANCE;
    }

    public static void destroyInstance() {
        INSTANCE = null;
    }


    //TP
    @Override
    public Flowable<List<Routine>> getRoutines() {
        List<Routine> routines = new ArrayList(mCachedRoutines.values());
        if (routines.size() > 0) {
            mLastTarget = routines.get(routines.size() - 1).getTarget();
            Log.e(TAG, "last target:" + mLastTarget);
            return Flowable.just(routines);
        }
        return mLocalDataSource.getRoutines()
                .doAfterNext(rx_routines -> {
                    if (rx_routines.size() > 0) {
                        mLastTarget = rx_routines.get(rx_routines.size() - 1).getTarget();
                        Log.e(TAG, "last target:" + mLastTarget);
                        for (Routine routine : rx_routines) {
                            mCachedRoutines.put(routine.getCreateTime(), routine);
                            if (routine.getStatusCode().equals(ConstantProvider.ROUTINE_NOT_UPLOAD_CODE))
                                mRoutineToUpload = routine;
                        }
                    }
                });
    }

    @Override
    public Flowable<List<Routine>> searchRoutines(@NonNull String keyword) {
        int i = keyword.length() - 1;
        for (; i > 0; i--) {
            if (keyword.charAt(i) == ',' || keyword.charAt(i) == '，') {
                break;
            }
        }
        String rightKeyword;
        if (i == 0)
            rightKeyword = keyword;
        else
            rightKeyword = keyword.substring(i + 1);
        String leftKeyword = keyword.substring(0, i);
        Log.e(TAG, " leftKeyword:" + leftKeyword + "rightKeyword:" + rightKeyword);

        if (leftKeyword.length() == 0 && rightKeyword.length() != 0)
            return mLocalDataSource.searchRoutines(rightKeyword)
                    .doAfterNext(routines -> mCachedSubRoutines = routines);
        else if (rightKeyword.length() == 0 && leftKeyword.length() != 0)

            return Flowable.just(mCachedKeywordRoutines.get(leftKeyword) == null ?
                    mCachedSubRoutines : mCachedKeywordRoutines.get(leftKeyword))
                    .doAfterNext(routines -> mCachedKeywordRoutines.put(leftKeyword, routines));

        else if (rightKeyword.length() != 0 && leftKeyword.length() != 0)
            return mLocalDataSource.searchRoutines(rightKeyword)
                    .map(routines -> filterRoutines(routines, mCachedKeywordRoutines.get(leftKeyword)))
                    .doAfterNext(routines -> mCachedSubRoutines = routines);
        else
            return Flowable.just(Collections.emptyList());
    }

    private List<Routine> filterRoutines(List<Routine> routines, @Nullable List<Routine> cacheRoutines) {
        if (cacheRoutines == null)
            return routines;
        List<Routine> ret = new ArrayList<>(cacheRoutines.size());
        Set<Routine> routineSet = new HashSet<>(cacheRoutines);
        for (Routine routine : routines) {
            if (routineSet.contains(routine))
                ret.add(routine);
        }
        return ret;
    }

    @Override
    public Flowable<Boolean> updateProcess(@NonNull String createTime, @NonNull String process) {
        return Flowable.just(true)
                .doAfterNext(__ -> {
                    String oldProcess = mCachedRoutines.get(createTime).getProcess();
                    if (!oldProcess.equals(process)) {
                        Log.e(TAG, "updateProcess");
                        mCachedRoutines.get(createTime).setProcess(process);
                        mLocalDataSource.updateRoutine(
                                createTime, PersistenceContract.RoutineEntry.COLUMN_NAME_PROCESS, process);
                    }
                });
    }

    @Override
    public Flowable<Optional<Routine>> getRoutine(@NonNull String createTime) {
        Routine routine = mCachedRoutines.get(createTime);

        if (routine != null) {
            return Flowable.just(Optional.of(routine));
        }
        return mLocalDataSource.getRoutine(createTime)
                .doOnNext(routineOptional -> {
                    if (routineOptional.isPresent()) {
                        Routine rx_routine = routineOptional.get();
                        mCachedRoutines.put(rx_routine.getCreateTime(), rx_routine);
                    }
                });
    }

    @Override
    public void saveRoutine(@NonNull Routine routine) {
        mRoutineToUpload = routine;
        mCachedRoutines.put(routine.getCreateTime(), routine);
        mLocalDataSource.saveRoutine(routine);
        updateOption(routine);
    }

    @Override
    public Flowable<String> uploadRoutine() {
        if (mRoutineToUpload == null)
            return Flowable.just("Everything up-to-date");

        return mRemoteDataSource.uploadRoutine(mRoutineToUpload, mUID)
                .map(ret -> {
                    Log.e(TAG, "mRoutineToUpload to save");
                    mLocalDataSource.updateRoutine(
                            mRoutineToUpload.getCreateTime(),
                            PersistenceContract.RoutineEntry.COLUMN_NAME_STATUS_CODE,
                            ConstantProvider.ROUTINE_UPLOAD_CODE);
                    mRoutineToUpload = null;
                    return ret;
                });
    }

    //TP
    @Override
    public Flowable<List<Routine>> deleteRoutine(@NonNull List<String> createTimes) {
        for (String createTime : createTimes) {
            mCachedRoutines.remove(createTime);
        }
        List<Routine> routines = new ArrayList(mCachedRoutines.values());
        return Flowable.just(routines)
                .doAfterNext(__ -> mLocalDataSource.deleteRoutine(createTimes));
    }

    @Override
    public Flowable<List<String>> getOptions(List<String> combinedKeys) {
        return Flowable
                .fromIterable(combinedKeys)
                .map(combinedKey ->
                        OptionAlgorithm.getSortedOptions(mCachedOptions.row(combinedKey)))
                .toList().toFlowable()
                .map(multiSortedOptions
                        -> OptionAlgorithm.combineSortedOptions(multiSortedOptions));

    }

    @Override
    public Flowable<Boolean> cacheOptions(@NonNull List<String> combinedKeys) {
        List<String> notCachedKeys = new ArrayList<>(combinedKeys.size());
        for (String combinedKey : combinedKeys) {
            if (!mCachedOptions.containsRow(combinedKey)) {
                Log.e(TAG, "not contain key:" + combinedKey);
                notCachedKeys.add(combinedKey);
            }
        }
        if (notCachedKeys.size() < 1)
            return Flowable.just(true);
        return mLocalDataSource.cacheOptions(notCachedKeys)
                .map(optionTable -> {
                    Log.e(TAG, "cache options");
                    mCachedOptions.putAll(optionTable);
                    return true;
                });
    }

    @Override
    public Flowable<String> cacheShares() {
        Log.e(TAG, "cacheShares");
        if (mCachedShares == null) {
            return mLocalDataSource.getShares()
                    .map( shares -> {
                                mCachedShares = shares;
                                return "";
                            });
        } else {
            return mRemoteDataSource.cacheShares()
                    .map(jsons -> {
                        for (String json : jsons) {
                            mCachedShares.add(new Share(json, "0"));
                        }
                        return "推荐系统更新了" + jsons.size() + "条数据";
                    });
        }
    }

    @Override
    public Flowable<String> updateShare(Share share) {
        Log.e(TAG, "updateShare");
        return mRemoteDataSource.updateShare(share, mUID)
                .doFinally(() -> mLocalDataSource.updateShares(share));
    }

    @Override
    public List<Share> getShares() {
        Log.e(TAG, "getShares");

        if (mCachedShares == null || mCachedShares.size() == 0) {
            Log.e(TAG, "return empty list");


            return Collections.emptyList();

        }
        return mCachedShares;
    }

    @Override
    public Flowable<List<Option>> getOptionStat() {
        return mLocalDataSource.getOptionStat();
    }


    @Override
    public Flowable<List<String>> getKeywordOptions(@NonNull String label, @NonNull String keyword) {
        return mLocalDataSource.getKeywordOption(label, keyword);
    }

    @Override
    public String getLastTarget() {
        return mLastTarget;
    }

    private void updateOption(Routine routine) {
        Table<String, String, Integer> updatedOptions = HashBasedTable.create();
        List<String> keywords = new ArrayList<>();
        String query = routine.getTarget();
        for (String key : getTargetKey(mLastTarget)) {
            Integer count = mCachedOptions.get(key, query);
            count = (count == null) ? 1 : count + 1;
            updatedOptions.put(key, query, count);
            Log.e(TAG, "key:" + key + " query:" + query);

        }
        query = routine.getAgent();
        for (String key : getAgentKey(routine)) {
            Integer count = mCachedOptions.get(key, query);
            count = (count == null) ? 1 : count + 1;
            updatedOptions.put(key, query, count);
            Log.e(TAG, "key:" + key + " query:" + query);

        }
        List<String> policyAndFeedback = routine.getPolicyAndFeedback();
        for (int i = 0; i < policyAndFeedback.size(); i++) {
            query = policyAndFeedback.get(i);
            for (String key : getPolicyFeedbackKey(routine, policyAndFeedback.subList(0, i))) {
                Integer count = mCachedOptions.get(key, query);
                count = (count == null) ? 1 : count + 1;
                updatedOptions.put(key, query, count);
                Log.e(TAG, "key:" + key + " query:" + query);
            }
        }

        keywords.add(routine.getAgent());
        keywords.add(routine.getTarget());
        for (String policy : policyAndFeedback) {
            keywords.add(policy);
        }
        mLocalDataSource.updateOption(updatedOptions);
        mLocalDataSource.updateKeywords(keywords);
    }
}
