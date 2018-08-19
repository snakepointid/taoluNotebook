package com.lue.taolu.fragments.shareroutine;

/**
 * Created by snakepointid on 2017/12/16.
 */

import android.support.annotation.NonNull;

import com.lue.taolu.data.DataRepository;
import com.lue.taolu.util.schedulers.BaseSchedulerProvider;

import io.reactivex.disposables.CompositeDisposable;

import static com.google.common.base.Preconditions.checkNotNull;

public class ShareRoutinePresenter implements ShareRoutineContract.Presenter {
    private final String TAG = "ShareListPresenter";
    private final BaseSchedulerProvider mSchedulerProvider;
    @NonNull
    private ShareRoutineContract.View mShareView;
    @NonNull
    private String mShareInfo;
    @NonNull
    private DataRepository mDataRepository;
    @NonNull
    private CompositeDisposable mCompositeDisposable;
    public ShareRoutinePresenter(@NonNull ShareRoutineContract.View shareView,
                                 @NonNull String shareInfo,
                                 @NonNull DataRepository dataRepository,
                                 @NonNull BaseSchedulerProvider schedulerProvider) {
        mShareView = checkNotNull(shareView, "share View cannot be null!");
        mShareInfo = checkNotNull(shareInfo, "share info  cannot be null!");
        mDataRepository = checkNotNull(dataRepository, "data cannot be null!");
        mSchedulerProvider = checkNotNull(schedulerProvider, "scheduler cannot be null!");
        mCompositeDisposable = new CompositeDisposable();
        mShareView.setPresenter(this);
    }

    @Override
    public void subscribe() {
        mShareView.showShare(mShareInfo);
    }

    @Override
    public void unsubscribe() {
        mCompositeDisposable.clear();
    }

    @Override
    public void postInfo() {

    }
    @Override
    public void loadComments(){

    }
    @Override
    public void onDestroy() {
        mShareView = null;
    }


}
