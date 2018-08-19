package com.lue.taolu.fragments.shareroutine;

import com.lue.taolu.base.IPresenter;
import com.lue.taolu.base.IView;

/**
 * Created by snakepointid on 2017/12/16.
 */

public interface ShareRoutineContract {
    interface View extends IView<Presenter> {
        void showShare(String shareInfo);
    }
    interface Presenter extends IPresenter {
        void postInfo();

        void loadComments();
    }
}
