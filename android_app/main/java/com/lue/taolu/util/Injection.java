package com.lue.taolu.util;

import android.content.SharedPreferences;
import android.support.annotation.NonNull;

import com.lue.taolu.data.DataRepository;
import com.lue.taolu.data.local.LocalDataSource;
import com.lue.taolu.data.remote.RemoteDataSource;
import com.lue.taolu.util.schedulers.*;

import android.content.Context;


import static com.google.common.base.Preconditions.checkNotNull;

/**
 * Created by snakepointid on 2018/1/12.
 */

public class Injection {


    public static DataRepository provideDataRepository(@NonNull Context context) {
        checkNotNull(context);
        SharedPreferences sp = context.getSharedPreferences(ConstantProvider.USER_INFO,0);
        return DataRepository.getInstance(
                LocalDataSource.getInstance(context,provideSchedulerProvider()),
                RemoteDataSource.getInstance(),
                sp.getString(ConstantProvider.USER_ID,null));
    }

    public static BaseSchedulerProvider provideSchedulerProvider() {
        return SchedulerProvider.getInstance();
    }
}