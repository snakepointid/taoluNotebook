package com.lue.taolu.adapter;


import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.CheckBox;
import android.widget.ImageView;
import android.widget.TextView;

import com.lue.taolu.R;
import com.lue.taolu.base.MyGridView;
import com.lue.taolu.bean.Routine;
import com.lue.taolu.interf.IListener.RoutineItemListener;
import com.lue.taolu.util.ConstantProvider;
import com.lue.taolu.util.MyTextUtil;

import java.util.Collections;
import java.util.List;

import static com.google.common.base.Preconditions.checkNotNull;
public class RoutineListAdapter extends BaseAdapter {
    private String TAG="RoutineListAdapter";

    private List<Routine> mRoutines;
    private RoutineItemListener mListener;
    private boolean mCheckBoxFlag=false;
    private boolean mBriefInfo=true;


    public RoutineListAdapter(List<Routine> routines, RoutineItemListener itemListener) {
            setList(routines);
            mListener = itemListener;

    }

        public void replaceData(List<Routine> routines) {
            setList(routines);
            notifyDataSetChanged();
        }
        public void reverseData(){
            Collections.reverse(mRoutines);
            notifyDataSetChanged();
        }
        public void setCheckBoxInVisible(){
            mCheckBoxFlag=false;
            notifyDataSetChanged();
        }
        public void briefDetailSwitch(){
            mBriefInfo=mBriefInfo?false:true;
            notifyDataSetChanged();
        }
        private void setList(List<Routine> routines) {
            mRoutines = checkNotNull(routines);
        }

        @Override
        public int getCount() {
            return mRoutines.size();
        }

        @Override
        public Routine getItem(int i) {
            return mRoutines.get(i);
        }

        @Override
        public long getItemId(int i) {
            return i;
        }

        @Override
        public View getView(int i, View convertView, ViewGroup viewGroup) {
            ViewHolder holder;
            Log.e(TAG,"getView"+i);
            final Routine routine = getItem(i);
            if (convertView==null) {
                Log.e(TAG,"inflater"+i);
                LayoutInflater inflater = LayoutInflater.from(viewGroup.getContext());
                convertView = inflater.inflate(R.layout.item_routine_brief, viewGroup, false);
                holder = new ViewHolder();
                holder.targetText = convertView.findViewById(R.id.tv_target_brief);
                holder.timeText = convertView.findViewById(R.id.tv_time_brief);
                holder.agentText = convertView.findViewById(R.id.tv_agent_brief);
                holder.outcomeImg = convertView.findViewById(R.id.iv_outcome_brief);
                holder.checkBox = convertView.findViewById(R.id.cb_delete_brief);
                holder.policyBrief= convertView.findViewById(R.id.tv_policy_feedback_brief);
                holder.policyDetail = convertView.findViewById(R.id.gv_policy_feedback_detail);
                convertView.setTag(holder);
            }else{
                holder = (ViewHolder) convertView.getTag();
            }

            if(routine.getOutcome().equals(ConstantProvider.POSITIVE_OUTCOME)){
                holder.outcomeImg.setImageResource(R.drawable.ic_happy_small);
            }else{
                holder.outcomeImg.setImageResource(R.drawable.ic_sad_small);
            }
            holder.targetText.setText(routine.getTarget().substring(1));
            holder.timeText.setText(MyTextUtil.getDateOrTime(routine.getCreateTime()));
            holder.agentText.setText(routine.getAgent().substring(1));
            if(mBriefInfo){
                holder.policyDetail.setVisibility(View.GONE);
                holder.policyBrief.setVisibility(View.VISIBLE);
                String process = routine.getProcess();
                if(process.length()>5)
                    holder.policyBrief.setText(process);
                else
                    holder.policyBrief.setText(routine.toBrief());
            }else{
                holder.policyDetail.setVisibility(View.VISIBLE);
                holder.policyBrief.setVisibility(View.GONE);
                PolicyFeedbackAdapter policyFeedbackAdapter=(PolicyFeedbackAdapter)holder.policyDetail.getAdapter();
                if(policyFeedbackAdapter==null){
                    Log.e(TAG,"setAdapter"+i);
                    policyFeedbackAdapter= new PolicyFeedbackAdapter();
                    holder.policyDetail.setAdapter(policyFeedbackAdapter);
                }
                policyFeedbackAdapter.replaceData(routine.getPolicyAndFeedback());
            }
            if(mCheckBoxFlag){
                holder.checkBox.setVisibility(View.VISIBLE);
                holder.checkBox.setOnCheckedChangeListener((v,checkedFlag)->mListener.onCheck(checkedFlag,routine.getCreateTime()));
                convertView.setOnClickListener(__ -> holder.checkBox.performClick());
            }else{
                holder.checkBox.setVisibility(View.GONE);
                convertView.setOnClickListener(__ -> mListener.onClick(routine));
                convertView.setOnLongClickListener(__->{
                    mCheckBoxFlag=true;
                    notifyDataSetChanged();
                    mListener.onLongClick();
                    return true;});
            }
            return convertView;
        }
        private final class ViewHolder{
            TextView targetText;
            TextView timeText;
            TextView agentText;
            ImageView outcomeImg;
            TextView policyBrief;
            CheckBox checkBox;
            MyGridView policyDetail;
        }
    }