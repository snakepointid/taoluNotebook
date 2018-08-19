package com.lue.taolu.util;

import android.util.Log;

/**
 * Created by snakepointid on 2018/1/12.
 */

public class MyDebugUtil {

    public static void sleepWhile(String tag){
        try {
            Thread.sleep(ConstantProvider.SLEEP_TIME);
            Log.e(tag,"sleep:"+ConstantProvider.SLEEP_TIME/1000+" seconds");
        } catch (InterruptedException e) {
            Log.e(tag,"not sleep");

        }
    }
    public static void methodFinishLog(String className,String methodName){
        if(ConstantProvider.DEBUG_MODE){
            System.out.print("class:"+className+"\t"+"method:"+methodName+"\tdone");
        }
    }
}
