package com.lue.taolu.data.remote;

import android.util.Log;

import okhttp3.RequestBody;
import retrofit2.Retrofit;
import retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory;
import retrofit2.converter.gson.GsonConverterFactory;

/**
 * Created by snakepointid on 2018/2/5.
 */

public class ServiceGenerator {

    private static final String BASE_URL = "https://www.lue321.com/";

    private static Retrofit.Builder builder =
            new Retrofit.Builder()
                    .baseUrl(BASE_URL)
                    .addConverterFactory(GsonConverterFactory.create())
                    .addCallAdapterFactory(RxJava2CallAdapterFactory.create());
    private static Retrofit retrofit = builder.build();

    public static <S> S createService(
            Class<S> serviceClass ) {
        Log.e("remote","createService");
        return retrofit.create(serviceClass);
    }
}