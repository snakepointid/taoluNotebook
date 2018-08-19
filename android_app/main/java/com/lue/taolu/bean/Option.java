package com.lue.taolu.bean;

import android.support.annotation.NonNull;
import com.google.common.base.Objects;
/**
 * Created by snakepointid on 2017/12/21.
 */
public class Option {

    @NonNull
    private final String mKey;

    @NonNull
    private final String mQuery;

    @NonNull
    private int mCount;

    public Option(@NonNull String key, @NonNull String query, @NonNull int count ) {
        mKey = key;
        mQuery = query;
        mCount = count;
    }

    @NonNull
    public String getKey() {
        return mKey;
    }

    @NonNull
    public String getQuery() {
        return mQuery;
    }

    @NonNull
    public int getCount() {
        return mCount;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Option options = (Option) o;
        return Objects.equal(mKey, options.mKey) &&Objects.equal(mQuery, options.mQuery);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(mKey, mQuery);
    }
}