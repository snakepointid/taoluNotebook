package com.lue.taolu.fragments.routinelist;

/**
 * Created by snakepointid on 2017/12/16.
 */

import android.support.annotation.NonNull;
import android.util.Log;

import com.lue.taolu.bean.Routine;
import com.lue.taolu.data.DataRepository;
import com.lue.taolu.util.schedulers.BaseSchedulerProvider;

import java.util.List;
import java.util.Map;

import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.disposables.Disposable;

import static com.google.common.base.Preconditions.checkNotNull;

public class RoutineListPresenter implements RoutineListContract.Presenter {
    private String TAG = "RoutineListPresenter";
    private final BaseSchedulerProvider mSchedulerProvider;
    @NonNull
    private CompositeDisposable mCompositeDisposable;
    @NonNull
    private RoutineListContract.View mRoutineView;
    @NonNull
    private DataRepository mDataRepository;

    public RoutineListPresenter(@NonNull RoutineListContract.View routineView, @NonNull DataRepository dataRepository, @NonNull BaseSchedulerProvider schedulerProvider){
        mRoutineView = checkNotNull(routineView, "routine View cannot be null!");
        mDataRepository = checkNotNull(dataRepository, "data cannot be null!");
        mSchedulerProvider = checkNotNull(schedulerProvider, "scheduler cannot be null!");
        mCompositeDisposable = new CompositeDisposable();
        mRoutineView.setPresenter(this);
    }

    @Override
    public void subscribe() {
        loadRoutines();
    }

    @Override
    public void unsubscribe() {
        mCompositeDisposable.clear();
    }



    @Override
    public void deleteRoutines(List<String> routineIds){
        mCompositeDisposable.clear();
        Disposable disposable = mDataRepository
                .deleteRoutine(routineIds)
                .subscribeOn(mSchedulerProvider.io())
                .observeOn(mSchedulerProvider.ui())
                .subscribe( routines ->  mRoutineView.showRoutineList(routines));
        mCompositeDisposable.add(disposable);
    }


    @Override
    public void searchRoutines(@NonNull String keyword){
        if(keyword.length()==0){
            loadRoutines();
            return;
        }
        mCompositeDisposable.clear();
        Disposable disposable = mDataRepository
                .searchRoutines(keyword)
                .subscribeOn(mSchedulerProvider.io())
                .observeOn(mSchedulerProvider.ui())
                .subscribe(routines ->mRoutineView.showRoutineList(routines));
        mCompositeDisposable.add(disposable);
    }
    @Override
    public void onDestroy(){
        mRoutineView=null;
    }
    private void loadRoutines() {
        Log.e(TAG,"loadRoutines");
        mCompositeDisposable.clear();
        Disposable disposable = mDataRepository
                .getRoutines()
                .subscribeOn(mSchedulerProvider.io())
                .observeOn(mSchedulerProvider.ui())
                .subscribe(
                        // onNext
                        routines -> {
                            mRoutineView.showRoutineList(routines);
                            uploadRoutine();
                        } );
        mCompositeDisposable.add(disposable);
    }
    private void uploadRoutine(){
        mCompositeDisposable.clear();
        Disposable disposable = mDataRepository
                .uploadRoutine()
                .subscribeOn(mSchedulerProvider.io())
                .observeOn(mSchedulerProvider.ui())
                .subscribe(
                        uploadSuccessInfo->Log.e(TAG,uploadSuccessInfo),
                        __->Log.e(TAG,"someThingWrongOnInternet"));
        mCompositeDisposable.add(disposable);
    }
}
