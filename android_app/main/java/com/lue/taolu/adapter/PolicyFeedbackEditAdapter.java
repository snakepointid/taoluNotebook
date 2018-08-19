package com.lue.taolu.adapter;

import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import com.lue.taolu.interf.IListener.PolicyItemListener;

public class PolicyFeedbackEditAdapter extends PolicyFeedbackAdapter {

    private PolicyItemListener mListener;

    public PolicyFeedbackEditAdapter(PolicyItemListener itemListener) {
        super();
        mListener = itemListener;
    }


    @Override
    public View getView(int i, View convertView, ViewGroup viewGroup) {

        View holderView = super.getView(i, convertView, viewGroup);

        final String policyOrFeedback = getItem(i);
        if (policyOrFeedback == null) {
            holderView.setOnClickListener(__ -> mListener.newPolicy());
        } else {
            holderView.setOnClickListener(__ -> mListener.changePolicy(i));
        }
        return holderView;
    }

    private final class ViewHolder {
        Button policyButton;
    }
}