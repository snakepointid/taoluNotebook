package com.lue.taolu.activity;
/**
 * Created by snakepointid on 2017/12/16.
 */

import android.os.Bundle;

import com.lue.taolu.R;
import com.lue.taolu.base.MyBaseActivity;
import com.lue.taolu.data.remote.RemoteDataSource;
import com.lue.taolu.fragments.login.LoginFragment;
import com.lue.taolu.fragments.login.LoginPresenter;
import com.lue.taolu.util.ActivityUtils;
import com.lue.taolu.util.Injection;

public class LoginActivity extends MyBaseActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        LoginFragment loginFragment =
                (LoginFragment) getSupportFragmentManager().findFragmentById(R.id.loginFrame);
        if (loginFragment == null) {
            // Create the fragment
            loginFragment = LoginFragment.newInstance();
            ActivityUtils.addFragmentToActivity(
                    getSupportFragmentManager(), loginFragment, R.id.loginFrame);
        }
        // Create the presenter
        new LoginPresenter(loginFragment, RemoteDataSource.getInstance(), Injection.provideSchedulerProvider());

    }
}
