package com.lue.taolu.fragments.detail;

import android.support.annotation.NonNull;


import com.lue.taolu.base.IPresenter;
import com.lue.taolu.base.IView;
import com.lue.taolu.bean.Routine;

/**
 * Created by snakepointid on 2017/12/16.
 */

public interface RoutineDetailContract {

    interface View extends IView<Presenter> {

        void showRoutine(@NonNull Routine routine);
    }

    interface Presenter extends IPresenter {
        void updateProcess(@NonNull String routineId,@NonNull String process);
    }
}
