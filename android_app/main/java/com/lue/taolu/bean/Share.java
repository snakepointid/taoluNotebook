package com.lue.taolu.bean;

/**
 * Created by snakepointid on 2017/12/17.
 */

import android.support.annotation.NonNull;

import com.google.common.base.Objects;

public class Share {

    @NonNull
    private String mRoutineInfo;

    @NonNull
    private String mDoULike;


    private String mExplorationId;


    public Share(@NonNull String routineInfo,
                 @NonNull String doULike) {

        mRoutineInfo = routineInfo;
        mDoULike = doULike;

    }

    @NonNull
    public String getRoutineInfo() {
        return mRoutineInfo;
    }

    @NonNull
    public String getDoULike() {
        return mDoULike;
    }

    @NonNull
    public String getExplorationId() {
        return mExplorationId;
    }
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Share share = (Share) o;
        return Objects.equal(mRoutineInfo, share.mRoutineInfo);
    }
    @NonNull
    public void setDoULike(String doULike) {
        mDoULike=doULike;
    }

    @NonNull
    public void setExplorationId(String explorationId) {
        mExplorationId=explorationId;
    }
}
