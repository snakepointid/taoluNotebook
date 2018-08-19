package com.lue.taolu.util;

import android.support.annotation.NonNull;
import android.util.Log;
import android.widget.ListView;

import com.google.common.collect.Lists;
import com.lue.taolu.algorithm.OptionAlgorithm;
import com.lue.taolu.bean.Routine;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by snakepointid on 2018/1/12.
 */

public class MyTextUtil {

    public static String regString(@NonNull String string){
        return string.replaceAll(ConstantProvider.STRING_REG,"");
    }
    public static boolean validString(@NonNull String string){
        Matcher m= Pattern.compile(ConstantProvider.STRING_REG).matcher(string);
        return m.matches();
    }

    public static String getDateOrTime(String createTime){
        String createYear = createTime.substring(0,4);
        String createDate = createTime.substring(5,10);
        String createHour = createTime.substring(11,16);
        String today = new SimpleDateFormat(ConstantProvider.TODAY_TIME_PATTERN).format(new Date());

        if(!today.substring(0,4).equals(createYear)){
            return createYear;
        }else if(!today.substring(5).equals(createDate)){
            return createDate;
        }else {
            return createHour;
        }
    }

    public static String labelToSymbol(String label){
        switch (label){
            case ConstantProvider.TARGET_LABEL:
                return ConstantProvider.TARGET_SYMBOL;
            case ConstantProvider.AGENT_LABEL:
                return ConstantProvider.AGENT_SYMBOL;
            case ConstantProvider.POLICY_LABEL:
                return ConstantProvider.POLICY_SYMBOL;
            case ConstantProvider.FEEDBACK_LABEL:
                return ConstantProvider.FEEDBACK_SYMBOL;
            default:
                return ConstantProvider.FAKE_SYMBOL;
        }

    }
    public static String getTimeRightNow(String format){
        return new SimpleDateFormat(format).format(new Date());
    }

    public static long getTimeRightNow(String format,String time){
        Date timeDate=null;
        SimpleDateFormat sdf = new SimpleDateFormat(format);
        try  {
            timeDate = sdf.parse(time);
        } catch (ParseException pe)  {
        }
        return timeDate.getTime();
    }

    public static String getPlaceHolder(int size){
        String placeHolder = "?";
        for(int i=0;i<size-1;i++){
            placeHolder=placeHolder+",?";
        }
        return placeHolder;
    }

    public static String getUid(){
        return UUID.randomUUID().toString().replace("-","");
    }
    public static List<String>policyFeedbackString2Array(String policyAndFeedbackString){
        return Arrays.asList(policyAndFeedbackString.split("_"));
    }
}
