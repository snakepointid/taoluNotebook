package com.lue.taolu.fragments.login;

/**
 * Created by snakepointid on 2017/12/16.
 */

import android.support.annotation.NonNull;
import android.util.Log;

import com.lue.taolu.data.remote.RemoteDataSource;
import com.lue.taolu.util.schedulers.BaseSchedulerProvider;

import io.reactivex.disposables.CompositeDisposable;

import static com.google.common.base.Preconditions.checkNotNull;

public class LoginPresenter implements LoginContract.Presenter {
    private final String TAG = "LoginPresenter";
    @NonNull
    private LoginContract.View mLoginView;
    private final BaseSchedulerProvider mSchedulerProvider;

    @NonNull
    private RemoteDataSource mRemoteDataSource;
    private CompositeDisposable mCompositeDisposable;

    public LoginPresenter(@NonNull LoginContract.View loginView, @NonNull RemoteDataSource remoteDataSource, @NonNull BaseSchedulerProvider schedulerProvider) {
        mLoginView = checkNotNull(loginView, "loginView cannot be null!");
        mRemoteDataSource = checkNotNull(remoteDataSource, "loginView cannot be null!");
        mLoginView.setPresenter(this);
        mCompositeDisposable = new CompositeDisposable();
        mSchedulerProvider = checkNotNull(schedulerProvider, "scheduler cannot be null!");

    }

    @Override
    public void openRoutinePage() {


    }

    @Override
    public void onDestroy() {
        mLoginView = null;
    }

    @Override
    public void subscribe() {

    }

    @Override
    public void unsubscribe() {
        mCompositeDisposable.clear();
    }


}
