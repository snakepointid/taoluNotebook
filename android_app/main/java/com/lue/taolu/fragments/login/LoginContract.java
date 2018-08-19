package com.lue.taolu.fragments.login;

import com.lue.taolu.base.IView;
import com.lue.taolu.base.IPresenter;
/**
 * Created by snakepointid on 2017/12/16.
 */

public interface LoginContract {
    interface View extends IView<Presenter>{

        void showFailedLoginMessage();

        void showRoutinePage();

        void showSuccessfullyLoginMessage();

        String getAccount();

        String getPassword();

        void recordLogInfo();

    }
    interface Presenter extends IPresenter{

        void openRoutinePage();

    }
}
