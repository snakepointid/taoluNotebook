package com.lue.taolu.data.remote;

import java.util.List;
import java.util.Map;

import io.reactivex.Flowable;
import retrofit2.http.Field;
import retrofit2.http.FieldMap;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.Query;

/**
 * Created by snakepointid on 2018/2/4.
 */

public interface ApiService {

    @FormUrlEncoded
    @POST("/save_routine.php")
    Flowable<String> saveRoutine(@FieldMap Map<String, String> routine);

    @FormUrlEncoded
    @POST("/update_share_user_interact.php")
    Flowable<String> updateShare(@FieldMap Map<String, String> info);

    @GET("/mock_share_routines.php")
    Flowable<List<String>> cacheShares();
}
