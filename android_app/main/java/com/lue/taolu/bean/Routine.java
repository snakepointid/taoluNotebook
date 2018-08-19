package com.lue.taolu.bean;

/**
 * Created by snakepointid on 2017/12/17.
 */

import android.support.annotation.NonNull;
import android.text.TextUtils;
import android.util.Log;

import com.google.common.base.Objects;
import com.google.common.collect.Lists;
import com.lue.taolu.util.ConstantProvider;
import com.lue.taolu.util.MyDebugUtil;
import com.lue.taolu.util.MyTextUtil;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.UUID;
public class Routine {

    @NonNull
    private  String mTarget;
    @NonNull
    private final String mCreateTime;
    @NonNull
    private  List<String> mPolicyAndFeedback;
    @NonNull
    private  String mAgent;
    @NonNull
    private  String mOutcome;
    @NonNull
    private  String mStatusCode=ConstantProvider.ROUTINE_NOT_UPLOAD_CODE;
    @NonNull
    private  String mProcess="";
    @NonNull
    private  String mDuration;
    @NonNull
    private  String mClickStream="";


    public Routine() {
         mCreateTime = MyTextUtil.getTimeRightNow(ConstantProvider.CREATE_TIME_PATTERN);
         Log.e("time",mCreateTime);
         mPolicyAndFeedback = new ArrayList<>();
    }
    public Routine(@NonNull String target, @NonNull String agent,
                   @NonNull List<String>policyAndFeedback,
                   @NonNull String outcome,
                   @NonNull String process,
                   @NonNull String createTime,
                   @NonNull String statusCode,
                   @NonNull String duration,
                   @NonNull String clickStream
                   ) {

        mTarget = target;
        mAgent = agent;
        mOutcome=outcome;
        mProcess = process;
        mPolicyAndFeedback = policyAndFeedback;
        mCreateTime = createTime;
        mStatusCode=statusCode;
        mDuration = duration;
        mClickStream = clickStream;
    }

    public Routine(@NonNull String target, @NonNull String agent,
                   @NonNull String policyAndFeedbackString,
                   @NonNull String outcome,
                   @NonNull String process,
                   @NonNull String createTime,
                   @NonNull String statusCode,
                   @NonNull String duration,
                   @NonNull String clickStream
                   ) {

        mTarget = target;
        mAgent = agent;
        mOutcome=outcome;
        mProcess = process;
        mPolicyAndFeedback =  MyTextUtil.policyFeedbackString2Array(policyAndFeedbackString);
        mCreateTime = createTime;
        mStatusCode=statusCode;
        mDuration = duration;
        mClickStream = clickStream;

    }
    @NonNull
    public String getTarget() {
        return mTarget;
    }
    @NonNull
    public String getCreateTime(){return mCreateTime;}
    @NonNull
    public List<String> getPolicyAndFeedback() {
        return mPolicyAndFeedback;
    }
    @NonNull
    public String getAgent() {
        return mAgent;
    }
    @NonNull
    public String getOutcome() {
        return mOutcome;
    }
    @NonNull
    public String getProcess() {
        return mProcess;
    }
    @NonNull
    public String getStatusCode() {
        return mStatusCode;
    }
    @NonNull
    public String getDuration() {
        return mDuration;
    }
    @NonNull
    public String getClickStream() {
        return mClickStream;
    }

    public void setTarget(@NonNull String target){
        mTarget = target;
    }

    public void setAgent(@NonNull String agent){
        mAgent = agent;
    }

    public void setOutcome(@NonNull String outcome){
        mOutcome = outcome;
        long createTime = MyTextUtil.getTimeRightNow(ConstantProvider.CREATE_TIME_PATTERN,mCreateTime);
        long saveTime = new Date().getTime();
        mDuration = Float.toString((saveTime-createTime)/1000);
    }
    public void addClickStream(String click){
        mClickStream=mClickStream+click;
    }

    public void setProcess(@NonNull String process){
        mProcess = process;
    }

    public void addPolicyOrFeedback(@NonNull String token){
        if(mPolicyAndFeedback==null){
            mPolicyAndFeedback = new ArrayList<>();
        }
        mPolicyAndFeedback.add(token);
    }
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Routine routine = (Routine) o;
        return
                Objects.equal(mTarget, routine.mTarget) &&
                Objects.equal(mAgent, routine.mAgent)&&
                Objects.equal(mCreateTime, routine.mCreateTime);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(  mTarget, mAgent,mCreateTime);
    }

    @Override
    public String toString() {
        return TextUtils.join("_",mPolicyAndFeedback);

    }
    public boolean isEmpty(){
        return mAgent==null||mTarget==null||mPolicyAndFeedback.size()==0;
    }
    public String toBrief(){
        return TextUtils.join("->",mPolicyAndFeedback).replaceAll("@|#","");
    }
}
