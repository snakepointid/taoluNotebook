package com.lue.taolu.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;

import com.lue.taolu.R;
import com.lue.taolu.util.ConstantProvider;

import java.util.ArrayList;
import java.util.List;

public class PolicyFeedbackAdapter extends BaseAdapter {

    private List<String> mPolicyFeedback;
    private String mAddTimes="1";
    private int mOneTimes=0;
    private int mFiveTimes=0;
    private boolean mLastAddOne=true;
    private boolean mMinusToAdd=false;

    public PolicyFeedbackAdapter() {
        mPolicyFeedback =  new ArrayList<>(0);
    }

    public void addData(String policyOrFeedback) {
        addItem(policyOrFeedback);
        notifyDataSetChanged();
    }

    public void replaceData(List<String> policyAndFeedback){
        mPolicyFeedback.clear();
        mAddTimes="1";
        mOneTimes=0;
        mFiveTimes=0;
        for(String policyOrFeedback:policyAndFeedback){
            addItem(policyOrFeedback);
        }
        notifyDataSetChanged();

    }

    private void addItem(String policyOrFeedback) {
        int curse = mPolicyFeedback.size();
        switch (mAddTimes){
            case "1":
                mPolicyFeedback.add(policyOrFeedback);
                mOneTimes=mOneTimes+1;
                if(mOneTimes==5){
                    mAddTimes="5";
                    mOneTimes=0;
                    mLastAddOne=true;
                }
                break;
            case "5":
                for(int i=0;i<4;i++){
                    mPolicyFeedback.add(null);
                }
                mPolicyFeedback.add(policyOrFeedback);
                mFiveTimes=mFiveTimes+1;
                if(mFiveTimes==2&&mLastAddOne){
                    mAddTimes="-1";
                    mFiveTimes=0;

                }else if(mFiveTimes==1&&mMinusToAdd){
                    mAddTimes="1";
                    mOneTimes=1;
                    mFiveTimes=0;
                    mMinusToAdd=false;
                }
                break;
            case "-1":
                mOneTimes=mOneTimes+1;
                mPolicyFeedback.set(curse-mOneTimes-1,policyOrFeedback);
                if(mOneTimes==4){
                    mAddTimes="1";
                    mMinusToAdd=true;
                }
                break;
            default:
                break;
        }
    }

    @Override
    public int getCount() {
        return mPolicyFeedback.size();
    }

    @Override
    public String getItem(int i) {
        return mPolicyFeedback.get(i);
    }

    @Override
    public long getItemId(int i) {
        return i;
    }

    @Override
    public View getView(int i, View convertView, ViewGroup viewGroup) {
        ViewHolder holder;

        if (convertView==null) {
            LayoutInflater inflater = LayoutInflater.from(viewGroup.getContext());
            convertView = inflater.inflate(R.layout.item_policy_feedback, viewGroup, false);
            holder = new ViewHolder();
            holder.policyButton = convertView.findViewById(R.id.bt_policyOrFeedback);
            convertView.setTag(holder);
        }else{
            holder = (ViewHolder) convertView.getTag();
        }

        final String policyOrFeedback = getItem(i);
        if(policyOrFeedback==null){
            convertView.setAlpha(0);
            return convertView;
        }
        convertView.setAlpha(1);

        if(policyOrFeedback.substring(0,1).equals(ConstantProvider.POLICY_SYMBOL)){
            holder.policyButton.setBackground(convertView.getResources().getDrawable(R.drawable.rect_policy));
        }else {
            holder.policyButton.setBackground(convertView.getResources().getDrawable(R.drawable.rect_feedback));
        }
        holder.policyButton.setText(policyOrFeedback.substring(1));
        return convertView;
    }
    private final class ViewHolder{
        Button policyButton;
    }
}