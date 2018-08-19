package com.lue.taolu.util;

import android.content.Context;
import android.os.Vibrator;

/**
 * Created by snakepointid on 2018/1/14.
 */

public class VibrateHelp {
    private static Vibrator vibrator;

    /**
     * 简单震动
     * @param context     调用震动的Context
     * @param millisecond 震动的时间，毫秒
     */
    @SuppressWarnings("static-access")
    public static void vSimple(Context context, int millisecond) {
        vibrator = (Vibrator) context.getSystemService(context.VIBRATOR_SERVICE);
        vibrator.vibrate(millisecond);
    }
}
