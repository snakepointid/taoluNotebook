package com.lue.taolu.fragments.login;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.design.widget.Snackbar;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;

import com.lue.taolu.R;

import static com.google.common.base.Preconditions.checkNotNull;

/**
 * Created by snakepointid on 2017/12/16.
 */

public class LoginFragment extends Fragment implements LoginContract.View {
    private LoginContract.Presenter mPresenter;
    private EditText et_userName, et_password;
    private SharedPreferences sp;
    private Button btn_login;

    public LoginFragment() {
        // Requires empty public constructor
    }

    public static LoginFragment newInstance() {
        return new LoginFragment();
    }

 
    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View root = inflater.inflate(R.layout.fragment_login, container, false);
        initView(root);
        return root;
    }
    private void initView(View container){
        et_userName = (EditText) container.findViewById(R.id.et_zh);
        et_password = (EditText) container.findViewById(R.id.et_mima);
        btn_login = (Button) container.findViewById(R.id.btn_login);
        sp = getActivity().getSharedPreferences("userInfo", Context.MODE_PRIVATE);
        //  自动填写
        et_userName.setText(sp.getString("USER_NAME", ""));
        et_password.setText(sp.getString("PASSWORD", ""));
        btn_login.setOnClickListener(__ -> mPresenter.openRoutinePage());
    }
    @Override
    public void onDestroy(){
        super.onDestroy();
        if(mPresenter!=null){
            mPresenter.onDestroy();
            mPresenter=null;
        }
    }
    @Override
    public void onPause() {
        super.onPause();
        mPresenter.unsubscribe();
    }
    @Override
    public void setPresenter(@NonNull LoginContract.Presenter presenter){
        mPresenter = checkNotNull(presenter);
    }

    @Override
    public void showRoutinePage(){
        getActivity().setResult(Activity.RESULT_OK);
        getActivity().finish();
    }
    @Override
    public void showSuccessfullyLoginMessage() {
        showMessage(getString(R.string.successfully_login_message));
    }
    @Override
    public void showFailedLoginMessage(){
        showMessage(getString(R.string.failure_login_message));
    }
    private void showMessage(String message) {
        Snackbar.make(getView(), message, Snackbar.LENGTH_LONG).show();
    }
    @Override
    public String getAccount(){
        return et_userName.getText().toString();
    }
    @Override
    public String getPassword(){
        return et_password.getText().toString();
    }
    @Override
    public void recordLogInfo(){
        SharedPreferences.Editor editor = sp.edit();
        editor.putString("USER_NAME", getAccount());
        editor.putString("PASSWORD",getPassword());
        editor.apply();
    }
}
