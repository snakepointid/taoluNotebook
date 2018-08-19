package com.lue.taolu.base;

/**
 * Created by snakepointid on 2017/12/16.
 */

public interface IPresenter {

    void subscribe();

    void unsubscribe();

    void onDestroy();
}
