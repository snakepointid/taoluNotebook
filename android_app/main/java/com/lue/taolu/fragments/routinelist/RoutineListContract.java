package com.lue.taolu.fragments.routinelist;

import android.support.annotation.NonNull;

import com.lue.taolu.base.IPresenter;
import com.lue.taolu.base.IView;
import com.lue.taolu.bean.Routine;

import java.util.List;
import java.util.Map;

import io.reactivex.Flowable;

/**
 * Created by snakepointid on 2017/12/16.
 */

public interface RoutineListContract {
    interface View extends IView<Presenter> {

        void showRoutineList(List<Routine> routines);

    }
    interface Presenter extends IPresenter {

        void deleteRoutines(List<String>routineIds);

        void searchRoutines(@NonNull String keyword);

    }
}
