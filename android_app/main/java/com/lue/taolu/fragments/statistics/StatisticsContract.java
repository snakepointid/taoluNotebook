package com.lue.taolu.fragments.statistics;

import com.lue.taolu.base.IPresenter;
import com.lue.taolu.base.IView;
import com.lue.taolu.bean.Option;

import java.util.List;

/**
 * Created by snakepointid on 2017/12/16.
 */

public interface StatisticsContract {
    interface View extends IView<Presenter> {

        void showOptionStats(List<Option> options);

    }
    interface Presenter extends IPresenter {


    }
}
