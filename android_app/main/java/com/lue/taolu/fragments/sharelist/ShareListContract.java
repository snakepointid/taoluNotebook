package com.lue.taolu.fragments.sharelist;

import com.lue.taolu.base.IPresenter;
import com.lue.taolu.base.IView;
import com.lue.taolu.bean.Share;

import java.util.List;

/**
 * Created by snakepointid on 2017/12/16.
 */

public interface ShareListContract {
    interface View extends IView<Presenter> {
        void showShares(List<Share> shares);
        void showNetInfo(String msg);
    }
    interface Presenter extends IPresenter {
        void loadShares();
        void updateShare(Share share);

    }
}
