package com.lue.taolu.interf;

import com.lue.taolu.bean.Share;
import com.lue.taolu.bean.Routine;

/**
 * Created by snakepointid on 2017/12/16.
 */

public interface IListener {

    interface RoutineItemListener{
        void onClick(Routine routine);
        void onCheck(boolean checkedFlag,String routineId);
        void onLongClick();
    }

    interface OptionItemListener{
        void onClick(String item,String position);
    }

    interface PolicyItemListener{
        void newPolicy();

        void changePolicy(int position);
    }

    interface shareListListener{
        void onClick(String shareInfo);
    }
}