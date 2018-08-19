package com.lue.taolu.fragments.edit;

/**
 * Created by snakepointid on 2017/12/16.
 */

import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.util.Log;

import com.lue.taolu.bean.Routine;
import com.lue.taolu.data.DataRepository;
import com.lue.taolu.util.ConstantProvider;
import com.lue.taolu.util.MyDebugUtil;
import com.lue.taolu.util.schedulers.BaseSchedulerProvider;

import java.util.List;

import io.reactivex.disposables.CompositeDisposable;

import static com.google.common.base.Preconditions.checkNotNull;

public class RoutineEditPresenter implements RoutineEditContract.Presenter {
    final private String TAG = "RoutineEditPresenter";

    @NonNull
    private final DataRepository mDataRepository;

    private final BaseSchedulerProvider mSchedulerProvider;

    private RoutineEditContract.View mRoutineEditView;
    @NonNull
    private CompositeDisposable mOptionCompDisposable;

    public RoutineEditPresenter(
            @NonNull DataRepository dataRepository,
            @NonNull RoutineEditContract.View routineEditView,
            @NonNull BaseSchedulerProvider schedulerProvider) {
        mDataRepository = checkNotNull(dataRepository);
        mRoutineEditView = checkNotNull(routineEditView);
        mSchedulerProvider = checkNotNull(schedulerProvider);
        mOptionCompDisposable = new CompositeDisposable();
        mRoutineEditView.setPresenter(this);
    }

    @Override
    public void subscribe() {

    }

    @Override
    public void onDestroy() {
        mRoutineEditView = null;
    }

    @Override
    public String getLastTarget() {
        return mDataRepository.getLastTarget();
    }

    @Override
    public void unsubscribe() {
        mOptionCompDisposable.clear();
    }

    @Override
    public void saveRoutine(@NonNull String outcome) {
        Routine routine = mRoutineEditView.getRoutine();
        routine.setOutcome(outcome);
        mDataRepository.saveRoutine(routine);
    }

    private void loadOptions(@NonNull List<String> combinedKeys) {
        Log.e(TAG, "load options");
        mOptionCompDisposable.clear();
        mOptionCompDisposable.add(mDataRepository
                .getOptions(combinedKeys)
                .subscribeOn(mSchedulerProvider.io())
                .observeOn(mSchedulerProvider.ui())
                .subscribe(option_strings ->
                        mRoutineEditView.showOptions(option_strings)));
    }

    @Override
    public void cacheOptions(@NonNull List<String> combinedKeys) {
        mOptionCompDisposable.clear();
        mOptionCompDisposable.add(mDataRepository
                .cacheOptions(combinedKeys)
                .subscribeOn(mSchedulerProvider.io())
                .observeOn(mSchedulerProvider.ui())
                .subscribe(__ -> loadOptions(combinedKeys))
        );
    }

    @Override
    public void loadKeywordOptions(@NonNull String type, @NonNull String keyword) {

        mOptionCompDisposable.clear();
        mOptionCompDisposable.add(mDataRepository
                .getKeywordOptions(type, keyword)
                .subscribeOn(mSchedulerProvider.io())
                .observeOn(mSchedulerProvider.ui())
                .subscribe(option_strings
                        -> mRoutineEditView.showOptions(option_strings)));
    }


}
