package com.lue.taolu.data.local;

/**
 * Created by snakepointid on 2017/12/18.
 */

import android.support.annotation.NonNull;

import com.google.common.collect.Table;
import com.lue.taolu.bean.Share;
import com.lue.taolu.bean.Routine;
import com.google.common.base.Optional;
import com.lue.taolu.bean.Option;

import java.util.List;

import io.reactivex.Flowable;

public interface ILocalDataSource {

    Flowable<List<Routine>> getRoutines();

    Flowable<Optional<Routine>> getRoutine(@NonNull String createTime);

    Flowable<List<Routine>> searchRoutines(@NonNull String keyword);

    void saveRoutine(@NonNull Routine routine);

    void deleteRoutine(List<String> createTimes);

    void updateOption(Table<String, String, Integer> newOption);

    void updateKeywords(List<String> keywords);

    Flowable<Table<String, String, Integer>> cacheOptions(List<String> combinedKeys);

    Flowable<List<String>> getKeywordOption(@NonNull String type, @NonNull String keyword);

    Flowable<List<Option>> getOptionStat();

    void updateRoutine(@NonNull String createTime, @NonNull String col, @NonNull String col_val);

    Flowable<List<Share>> getShares();

    void updateShares(Share share);
}
