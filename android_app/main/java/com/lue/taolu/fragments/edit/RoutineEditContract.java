package com.lue.taolu.fragments.edit;

import android.support.annotation.NonNull;
import android.support.annotation.Nullable;

import com.lue.taolu.base.IPresenter;
import com.lue.taolu.base.IView;
import com.lue.taolu.bean.Routine;

import java.util.List;

/**
 * Created by snakepointid on 2017/12/16.
 */

public interface RoutineEditContract {

    interface View extends IView<Presenter> {

        void showOptions(@NonNull List<String> options);

        Routine getRoutine();

    }

    interface Presenter extends IPresenter {

        void saveRoutine(@NonNull String outcome);

        void cacheOptions(@NonNull List<String> keys);

        void loadKeywordOptions(@NonNull String type,@NonNull String keyword);

        String getLastTarget();
    }
}
