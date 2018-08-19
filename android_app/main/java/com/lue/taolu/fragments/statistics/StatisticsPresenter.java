package com.lue.taolu.fragments.statistics;

/**
 * Created by snakepointid on 2017/12/16.
 */

import android.support.annotation.NonNull;

import com.lue.taolu.data.DataRepository;
import com.lue.taolu.util.schedulers.BaseSchedulerProvider;

import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.disposables.Disposable;

import static com.google.common.base.Preconditions.checkNotNull;

public class StatisticsPresenter implements StatisticsContract.Presenter {
    private final BaseSchedulerProvider mSchedulerProvider;
    @NonNull
    private CompositeDisposable mCompositeDisposable;
    @NonNull
    private StatisticsContract.View mStatisticsView;
    @NonNull
    private DataRepository mDataRepository;

    public StatisticsPresenter(@NonNull StatisticsContract.View sessionView, @NonNull DataRepository dataRepository, @NonNull BaseSchedulerProvider schedulerProvider){
        mStatisticsView = checkNotNull(sessionView, "session View cannot be null!");
        mDataRepository = checkNotNull(dataRepository, "data cannot be null!");
        mSchedulerProvider = checkNotNull(schedulerProvider, "scheduler cannot be null!");
        mCompositeDisposable = new CompositeDisposable();
        mStatisticsView.setPresenter(this);
    }

    @Override
    public void subscribe() {
        loadOptionStats();
    }

    @Override
    public void unsubscribe() {
        mCompositeDisposable.clear();
    }

    private void  loadOptionStats() {
        mCompositeDisposable.clear();
        Disposable disposable = mDataRepository
                .getOptionStat()
                .subscribeOn(mSchedulerProvider.io())
                .observeOn(mSchedulerProvider.ui())
                .subscribe(
                        // onNext
                        options -> {
                            mStatisticsView.showOptionStats(options);
                        } );

        mCompositeDisposable.add(disposable);
    }
    @Override
    public void onDestroy(){
        mStatisticsView=null;
    }


}
