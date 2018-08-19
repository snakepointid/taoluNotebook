package com.lue.taolu.data.remote;


import android.support.annotation.NonNull;
import android.util.Log;

import com.lue.taolu.bean.Share;
import com.lue.taolu.bean.Routine;
import com.lue.taolu.data.local.PersistenceContract.RoutineEntry;
import com.lue.taolu.util.ConstantProvider;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import io.reactivex.Flowable;

/**
 * Created by snakepointid on 2018/2/5.
 */

public class RemoteDataSource {
    private final String TAG = "RemoteDataSource";

    private static RemoteDataSource INSTANCE;
    // Prevent direct instantiation.
    private RemoteDataSource( ) {
    }

    public static RemoteDataSource getInstance(  ) {
        if (INSTANCE == null) {
            INSTANCE = new RemoteDataSource();
        }
        return INSTANCE;
    }

    public Flowable<String> uploadRoutine(@NonNull Routine routine,@NonNull String UID){
        Map<String,String> map = new LinkedHashMap<>();
        Log.e(TAG,UID);
        map.put(ConstantProvider.USER_ID,UID);
        map.put(RoutineEntry.COLUMN_NAME_TARGET,routine.getTarget());
        map.put(RoutineEntry.COLUMN_NAME_AGENT,routine.getAgent());
        map.put(RoutineEntry.COLUMN_NAME_OUTCOME,routine.getOutcome());
        map.put(RoutineEntry.COLUMN_NAME_TIME,routine.getCreateTime());
        map.put(RoutineEntry.COLUMN_NAME_DURATION,routine.getDuration());
        map.put(RoutineEntry.COLUMN_NAME_CLICK_STREAM,routine.getClickStream());
        map.put(RoutineEntry.COLUMN_NAME_POLICY_FEEDBACK,routine.toString());
        return ServiceGenerator.createService(ApiService.class).saveRoutine(map);
    }

    public Flowable<List<String>> cacheShares(){
        return ServiceGenerator
                .createService(ApiService.class)
                .cacheShares();
    }

    public Flowable<String> updateShare(Share share, String UID){
        Map<String,String> map = new LinkedHashMap<>();
        map.put("user_id",UID);
        map.put("exploration_uid", share.getExplorationId());
        map.put("like", share.getDoULike());
        Log.e(TAG,"updateShare");
        return ServiceGenerator
                .createService(ApiService.class)
                .updateShare(map);
    }
}
