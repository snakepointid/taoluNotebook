package com.lue.taolu.data.local;

/**
 * Created by snakepointid on 2017/12/18.
 */

import com.google.common.base.Optional;
import com.google.common.collect.HashBasedTable;
import com.google.common.collect.Table;
import com.lue.taolu.util.ConstantProvider;
import com.lue.taolu.util.MyTextUtil;
import com.lue.taolu.util.schedulers.BaseSchedulerProvider;
import com.squareup.sqlbrite2.BriteDatabase;
import com.squareup.sqlbrite2.SqlBrite;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.util.Log;

import java.util.List;

import io.reactivex.BackpressureStrategy;
import io.reactivex.Flowable;
import io.reactivex.functions.Function;

import com.lue.taolu.bean.*;
import com.lue.taolu.data.local.PersistenceContract.*;

import static com.google.common.base.Preconditions.checkNotNull;

public class LocalDataSource implements ILocalDataSource {
    private String TAG = "LocalDataSource";
    @Nullable
    private static LocalDataSource INSTANCE;

    @NonNull
    private final BriteDatabase mDatabaseHelper;


    @NonNull
    private Function<Cursor, Routine> mRoutineMapperFunction;

    @NonNull
    private Function<Cursor, Share> mShareMapperFunction;

    @NonNull
    private Function<Cursor, Option> mOptionMapperFunction;

    @NonNull
    private Function<Cursor, String> mKeywordOptionMapperFunction;


    @NonNull
    private Routine getRoutine(@NonNull Cursor c) {
        String createTime = c.getString(c.getColumnIndexOrThrow(RoutineEntry.COLUMN_NAME_TIME));
        String target = c.getString(c.getColumnIndexOrThrow(RoutineEntry.COLUMN_NAME_TARGET));
        String agent = c.getString(c.getColumnIndexOrThrow(RoutineEntry.COLUMN_NAME_AGENT));
        String outcome = c.getString(c.getColumnIndexOrThrow(RoutineEntry.COLUMN_NAME_OUTCOME));
        String process = c.getString(c.getColumnIndexOrThrow(RoutineEntry.COLUMN_NAME_PROCESS));
        String policyFeedback = c.getString(c.getColumnIndexOrThrow(RoutineEntry.COLUMN_NAME_POLICY_FEEDBACK));
        String duration = c.getString(c.getColumnIndexOrThrow(RoutineEntry.COLUMN_NAME_DURATION));
        String clickStream = c.getString(c.getColumnIndexOrThrow(RoutineEntry.COLUMN_NAME_CLICK_STREAM));
        String statusCode = c.getString(c.getColumnIndexOrThrow(RoutineEntry.COLUMN_NAME_STATUS_CODE));
        return new Routine(target, agent, policyFeedback, outcome, process, createTime, statusCode, duration, clickStream);
    }

    @NonNull
    private Option getOption(@NonNull Cursor c) {
        String key = c.getString(c.getColumnIndexOrThrow(OptionEntry.COLUMN_NAME_KEY));
        String query = c.getString(c.getColumnIndexOrThrow(OptionEntry.COLUMN_NAME_QUERY));
        int count = c.getInt(c.getColumnIndexOrThrow(OptionEntry.COLUMN_NAME_COUNT));
        return new Option(key, query, count);
    }

    private Share getShare(@NonNull Cursor c) {
        String routineInfo = c.getString(c.getColumnIndexOrThrow(ShareEntry.COLUMN_NAME_VALUE));
        String doULike = c.getString(c.getColumnIndexOrThrow(ShareEntry.COLUMN_NAME_LIKE));
        return new Share(routineInfo, doULike);
    }

    @NonNull
    public void updateShares(List<Share> shares) {
        //delete old table
        String selection = ShareEntry.COLUMN_NAME_LIKE + " != ?";
        String[] selectionArgs = {"-1"};
        mDatabaseHelper.delete(ShareEntry.TABLE_NAME, selection, selectionArgs);
        //insert new table
        int numb=0;
        for (Share share : shares) {
            ContentValues values = new ContentValues();
            values.put(ShareEntry.COLUMN_NAME_LIKE, share.getDoULike());
            values.put(ShareEntry.COLUMN_NAME_VALUE, share.getRoutineInfo());
            mDatabaseHelper.insert(ShareEntry.TABLE_NAME, values, SQLiteDatabase.CONFLICT_REPLACE);
            numb=numb+1;
            if(numb>ConstantProvider.SHARE_ROUTINES_NUMBER)
                break;
        }

    }

    @NonNull
    public void updateShares(Share share) {
        Log.e(TAG,"updateShares");
        ContentValues values = new ContentValues();
        values.put(ShareEntry.COLUMN_NAME_LIKE, share.getDoULike());
        String selection = ShareEntry.COLUMN_NAME_VALUE + " = ?";
        String[] selectionArgs = {share.getRoutineInfo()};
        mDatabaseHelper.update(ShareEntry.TABLE_NAME, values, selection, selectionArgs);
    }

    @NonNull
    private String getKeywordOption(@NonNull Cursor c) {
        return c.getString(c.getColumnIndexOrThrow(KeywordEntry.COLUMN_NAME_KEY));
    }


    // Prevent direct instantiation.
    private LocalDataSource(@NonNull Context context, @NonNull BaseSchedulerProvider schedulerProvider) {
        checkNotNull(context, "context cannot be null");
        RoutineDbHelper dbHelper = new RoutineDbHelper(context);
        SqlBrite sqlBrite = new SqlBrite.Builder().build();
        mDatabaseHelper = sqlBrite.wrapDatabaseHelper(dbHelper, schedulerProvider.io());
        mRoutineMapperFunction = this::getRoutine;
        mShareMapperFunction = this::getShare;
        mOptionMapperFunction = this::getOption;
        mKeywordOptionMapperFunction = this::getKeywordOption;
    }

    public static LocalDataSource getInstance(@NonNull Context context, @NonNull BaseSchedulerProvider schedulerProvider) {
        if (INSTANCE == null) {
            INSTANCE = new LocalDataSource(context, schedulerProvider);
        }
        return INSTANCE;
    }

    public static void destroyInstance() {

        INSTANCE = null;
    }


    //get routines relative results
    @Override
    public Flowable<List<Routine>> getRoutines() {
        String sql = String.format("SELECT * FROM %s", RoutineEntry.TABLE_NAME);
        Log.e(TAG, sql);
        return mDatabaseHelper.createQuery(RoutineEntry.TABLE_NAME, sql)
                .mapToList(mRoutineMapperFunction)
                .toFlowable(BackpressureStrategy.BUFFER);
    }

    @Override
    public Flowable<List<Routine>> searchRoutines(@NonNull String keyword) {
        String sql = "SELECT * FROM routines WHERE " + RoutineEntry.COLUMN_NAME_TARGET + " LIKE '%" + keyword + "%'"
                + " or " + RoutineEntry.COLUMN_NAME_AGENT + " LIKE '%" + keyword + "%'"
                + " or " + RoutineEntry.COLUMN_NAME_POLICY_FEEDBACK + " LIKE '%" + keyword + "%'";

        Log.e(TAG, sql);
        return mDatabaseHelper.createQuery(OptionEntry.TABLE_NAME, sql)
                .mapToList(mRoutineMapperFunction)
                .toFlowable(BackpressureStrategy.BUFFER);
    }

    @Override
    public Flowable<Optional<Routine>> getRoutine(@NonNull String createTime) {

        String sql = String.format("SELECT * FROM %s WHERE %s = ?", RoutineEntry.TABLE_NAME, RoutineEntry.COLUMN_NAME_TIME);
        return mDatabaseHelper.createQuery(RoutineEntry.TABLE_NAME, sql, createTime)
                .mapToOneOrDefault(cursor -> Optional.of(mRoutineMapperFunction.apply(cursor)), Optional.<Routine>absent())
                .toFlowable(BackpressureStrategy.BUFFER);
    }

    @Override
    public void saveRoutine(@NonNull Routine routine) {
        checkNotNull(routine);
        ContentValues values = new ContentValues();
        values.put(RoutineEntry.COLUMN_NAME_AGENT, routine.getAgent());
        values.put(RoutineEntry.COLUMN_NAME_POLICY_FEEDBACK, routine.toString());
        values.put(RoutineEntry.COLUMN_NAME_STATUS_CODE, routine.getStatusCode());
        values.put(RoutineEntry.COLUMN_NAME_TARGET, routine.getTarget());
        values.put(RoutineEntry.COLUMN_NAME_OUTCOME, routine.getOutcome());
        values.put(RoutineEntry.COLUMN_NAME_PROCESS, routine.getProcess());
        values.put(RoutineEntry.COLUMN_NAME_DURATION, routine.getDuration());
        values.put(RoutineEntry.COLUMN_NAME_CLICK_STREAM, routine.getClickStream());
        values.put(RoutineEntry.COLUMN_NAME_TIME, routine.getCreateTime());
        mDatabaseHelper.insert(RoutineEntry.TABLE_NAME, values, SQLiteDatabase.CONFLICT_REPLACE);
    }

    @Override
    public void updateRoutine(@NonNull String createTime, @NonNull String col, @NonNull String col_val) {
        ContentValues values = new ContentValues();
        values.put(col, col_val);
        String selection = RoutineEntry.COLUMN_NAME_TIME + " = ?";
        String[] selectionArgs = {createTime};
        mDatabaseHelper.update(RoutineEntry.TABLE_NAME, values, selection, selectionArgs);
    }


    @Override
    public Flowable<List<String>> getKeywordOption(@NonNull String label, @NonNull String keyword) {
        String sql = "SELECT * FROM keyword WHERE key LIKE '" + MyTextUtil.labelToSymbol(label) + "%" + keyword + "%'";
        Log.e(TAG, sql);
        return mDatabaseHelper.createQuery(OptionEntry.TABLE_NAME, sql)
                .mapToList(mKeywordOptionMapperFunction)
                .toFlowable(BackpressureStrategy.BUFFER);
    }


    @Override
    public void deleteRoutine(@NonNull List<String> createTimes) {
        String placeHolder = MyTextUtil.getPlaceHolder(createTimes.size());
        String[] values = createTimes.toArray(new String[createTimes.size()]);
        String sql = String.format("%s in (" + placeHolder + ")", RoutineEntry.COLUMN_NAME_TIME);
        mDatabaseHelper.delete(RoutineEntry.TABLE_NAME, sql, values);
    }

    @Override
    public Flowable<List<Share>> getShares() {

        String sql = String.format("SELECT * FROM %s", ShareEntry.TABLE_NAME);
        return mDatabaseHelper.createQuery(ShareEntry.TABLE_NAME, sql)
                .mapToList(mShareMapperFunction)
                .toFlowable(BackpressureStrategy.BUFFER);
    }

    @Override
    public Flowable<Table<String, String, Integer>> cacheOptions(List<String> combinedKeys) {
        String placeHolder = MyTextUtil.getPlaceHolder(combinedKeys.size());

        String[] values = combinedKeys.toArray(new String[combinedKeys.size()]);
        String sql = String.format("SELECT * FROM %s WHERE %s in (" + placeHolder + ")",
                OptionEntry.TABLE_NAME, OptionEntry.COLUMN_NAME_KEY);
        Log.e(TAG, sql);
        return mDatabaseHelper.createQuery(OptionEntry.TABLE_NAME, sql, values)
                .mapToList(mOptionMapperFunction)
                .map(options -> {
                    Table<String, String, Integer> optionTable = HashBasedTable.create();
                    for (Option option : options) {
                        optionTable.put(option.getKey(), option.getQuery(), option.getCount());
                    }
                    return optionTable;
                })
                .toFlowable(BackpressureStrategy.BUFFER);
    }

    @Override
    public Flowable<List<Option>> getOptionStat() {
        String sql = String.format("SELECT * FROM %s ", OptionEntry.TABLE_NAME);

        return mDatabaseHelper.createQuery(OptionEntry.TABLE_NAME, sql)
                .mapToList(mOptionMapperFunction)
                .toFlowable(BackpressureStrategy.BUFFER);
    }

    @Override
    public void updateOption(Table<String, String, Integer> newOptionStats) {

        for (Table.Cell newOptionStatCell : newOptionStats.cellSet()) {
            ContentValues values = new ContentValues();
            values.put(OptionEntry.COLUMN_NAME_KEY, newOptionStatCell.getRowKey().toString());
            values.put(OptionEntry.COLUMN_NAME_QUERY, newOptionStatCell.getColumnKey().toString());
            values.put(OptionEntry.COLUMN_NAME_COUNT, (Integer) newOptionStatCell.getValue());
            mDatabaseHelper.insert(OptionEntry.TABLE_NAME, values, SQLiteDatabase.CONFLICT_REPLACE);
        }
    }

    @Override
    public void updateKeywords(List<String> keywords) {
        for (String keyword : keywords) {
            ContentValues values = new ContentValues();
            values.put(KeywordEntry.COLUMN_NAME_KEY, keyword);
            values.put(KeywordEntry.COLUMN_NAME_COUNT, 1);
            mDatabaseHelper.insert(KeywordEntry.TABLE_NAME, values, SQLiteDatabase.CONFLICT_REPLACE);
        }
    }
}
