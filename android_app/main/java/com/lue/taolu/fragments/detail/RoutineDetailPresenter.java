package com.lue.taolu.fragments.detail;

/**
 * Created by snakepointid on 2017/12/16.
 */

import android.support.annotation.NonNull;
import android.support.annotation.Nullable;

import com.lue.taolu.data.DataRepository;
import com.lue.taolu.util.MyDebugUtil;
import com.lue.taolu.util.schedulers.BaseSchedulerProvider;

import io.reactivex.disposables.CompositeDisposable;

import static com.google.common.base.Preconditions.checkNotNull;

public class RoutineDetailPresenter implements RoutineDetailContract.Presenter {

    @NonNull
    private final DataRepository mDataRepository;

    @NonNull
    private  RoutineDetailContract.View mRoutineDetailView;

    private final BaseSchedulerProvider mSchedulerProvider;

    @Nullable
    private String mRoutineId;

    @NonNull
    private CompositeDisposable mRoutineCompDisposable;


    public RoutineDetailPresenter(@Nullable String routineId,
                                @NonNull DataRepository dataRepository,
                                @NonNull RoutineDetailContract.View routineDetailView,
                                @NonNull BaseSchedulerProvider schedulerProvider) {
        mRoutineId = routineId;
        mDataRepository = checkNotNull(dataRepository);
        mRoutineDetailView = checkNotNull(routineDetailView);
        mSchedulerProvider = checkNotNull(schedulerProvider);
        mRoutineCompDisposable = new CompositeDisposable();
        mRoutineDetailView.setPresenter(this);
    }

    @Override
    public void subscribe() {
        loadRoutine();
    }

    @Override
    public void unsubscribe() {
        mRoutineCompDisposable.clear();
    }
    @Override
    public void onDestroy(){
        mRoutineDetailView=null;
    }

    private void loadRoutine() {
        mRoutineCompDisposable.clear();
        mRoutineCompDisposable.add(mDataRepository
                .getRoutine(mRoutineId)
                .subscribeOn(mSchedulerProvider.io())
                .observeOn(mSchedulerProvider.ui())
                .subscribe(
                        // onNext
                        routineOptional -> {
                            if (routineOptional.isPresent()) {
                                mRoutineDetailView.showRoutine(routineOptional.get());
                            }
                        } )
        );
    }

    public void updateProcess(@NonNull String routineId,@NonNull String process){
        mRoutineCompDisposable.clear();
        mRoutineCompDisposable.add(mDataRepository
                .updateProcess(routineId,process)
                .subscribeOn(mSchedulerProvider.io())
                .observeOn(mSchedulerProvider.ui())
                .subscribe());
    }

}
