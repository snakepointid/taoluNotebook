package com.lue.taolu.data;

import android.support.annotation.NonNull;

import com.google.common.base.Optional;
import com.lue.taolu.bean.Share;
import com.lue.taolu.bean.Option;
import com.lue.taolu.bean.Routine;

import java.util.List;

import io.reactivex.Flowable;

import static com.google.common.base.Preconditions.checkNotNull;

/**
 * Created by snakepointid on 2018/1/19.
 */

public interface IDataSource {

    Flowable<List<Routine>> getRoutines();

    Flowable<Optional<Routine>> getRoutine(@NonNull String createTime) ;

    Flowable<List<Routine>> searchRoutines(@NonNull String keyword);

    void saveRoutine(@NonNull Routine routine) ;

    Flowable<String> uploadRoutine();

    Flowable<List<Routine>> deleteRoutine(List<String> createTimes) ;

    Flowable<List<String>>getOptions(List<String> keys);

    Flowable<List<String>>getKeywordOptions(@NonNull String type,@NonNull String keyword);

    Flowable<Boolean> cacheOptions(@NonNull List<String> keys);

    Flowable<List<Option>> getOptionStat();

    String getLastTarget();

    Flowable<Boolean> updateProcess(@NonNull String createTime,@NonNull String process);

    Flowable<String> cacheShares();

    List<Share> getShares();

    Flowable<String>updateShare(Share share);
}
