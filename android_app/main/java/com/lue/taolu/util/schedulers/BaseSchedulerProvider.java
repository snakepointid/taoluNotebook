package com.lue.taolu.util.schedulers;

/**
 * Created by snakepointid on 2018/1/12.
 */
import android.support.annotation.NonNull;

import io.reactivex.Scheduler;

public interface BaseSchedulerProvider {

    @NonNull
    Scheduler computation();

    @NonNull
    Scheduler io();

    @NonNull
    Scheduler ui();
}