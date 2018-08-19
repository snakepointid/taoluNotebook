package com.lue.taolu.fragments.sharelist;

/**
 * Created by snakepointid on 2017/12/16.
 */

import android.support.annotation.NonNull;
import android.util.Log;

import com.lue.taolu.bean.Share;
import com.lue.taolu.data.DataRepository;
import com.lue.taolu.util.schedulers.BaseSchedulerProvider;

import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.disposables.Disposable;

import static com.google.common.base.Preconditions.checkNotNull;

public class ShareListPresenter implements ShareListContract.Presenter {
    private final String TAG = "ShareListPresenter";
    private final BaseSchedulerProvider mSchedulerProvider;
    @NonNull
    private CompositeDisposable mCompositeDisposable;
    @NonNull
    private ShareListContract.View mShareView;
    @NonNull
    private DataRepository mDataRepository;

    public ShareListPresenter(@NonNull ShareListContract.View sessionView, @NonNull DataRepository dataRepository, @NonNull BaseSchedulerProvider schedulerProvider) {
        mShareView = checkNotNull(sessionView, "session View cannot be null!");
        mDataRepository = checkNotNull(dataRepository, "data cannot be null!");
        mSchedulerProvider = checkNotNull(schedulerProvider, "scheduler cannot be null!");
        mCompositeDisposable = new CompositeDisposable();
        mShareView.setPresenter(this);
    }

    @Override
    public void subscribe() {
        loadShares();
    }

    @Override
    public void unsubscribe() {
        mCompositeDisposable.clear();
    }

    @Override
    public void loadShares() {
        mCompositeDisposable.clear();
        Disposable disposable = mDataRepository
                .cacheShares()
                .subscribeOn(mSchedulerProvider.io())
                .observeOn(mSchedulerProvider.ui())
                .subscribe(
                        info -> {
                            if (info.length() > 0)
                                mShareView.showNetInfo(info);
                            getShares();
                        },
                        error -> mShareView.showNetInfo("网络加载异常，请稍后再试"));
        mCompositeDisposable.add(disposable);

    }

    @Override
    public void updateShare(Share share) {
        mCompositeDisposable.clear();
        Disposable disposable = mDataRepository
                .updateShare(share)
                .subscribeOn(mSchedulerProvider.io())
                .observeOn(mSchedulerProvider.ui())
                .subscribe(
                        info ->Log.e(TAG,info),
                        error ->Log.e(TAG,"出问题"));

        mCompositeDisposable.add(disposable);
    }

    private void getShares() {
        mShareView.showShares(mDataRepository.getShares());
    }

    @Override
    public void onDestroy() {
        mShareView = null;
    }


}
