package com.lue.taolu.adapter;

import java.util.List;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.TextView;

import com.lue.taolu.interf.IListener.OptionItemListener;
import com.lue.taolu.R;
import com.lue.taolu.util.ConstantProvider;
import com.lue.taolu.util.VibrateHelp;

import static com.google.common.base.Preconditions.checkNotNull;

public class OptionAdapter extends BaseAdapter {

    private List<String> mOptionStrings;
    private OptionItemListener mListener;

    public OptionAdapter(List<String> optionStrings, OptionItemListener itemListener) {
        setList(optionStrings);
        mListener = itemListener;
    }

    public void replaceData(List<String> optionStrings) {
        setList(optionStrings);
        notifyDataSetChanged();
    }

    private void setList(List<String> optionStrings) {
        mOptionStrings = checkNotNull(optionStrings);
    }

    @Override
    public int getCount() {
        return mOptionStrings.size();
    }

    @Override
    public String getItem(int i) {
        return mOptionStrings.get(i);
    }

    @Override
    public long getItemId(int i) {
        return i;
    }

    @Override
    public View getView(int i, View convertView, ViewGroup viewGroup) {
        ViewHolder holder;

        if (convertView == null) {
            LayoutInflater inflater = LayoutInflater.from(viewGroup.getContext());
            convertView = inflater.inflate(R.layout.item_option, viewGroup, false);
            holder = new ViewHolder();
            holder.tv_option = convertView.findViewById(R.id.tv_option);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        final String option = getItem(i);


        if (option.substring(0, 1).equals(ConstantProvider.FEEDBACK_SYMBOL)) {
            holder.tv_option.setBackground(convertView.getResources().getDrawable(R.drawable.rect_feedback));
        } else {
            holder.tv_option.setBackground(convertView.getResources().getDrawable(R.drawable.rect_policy));
        }
        holder.tv_option.setText(option.substring(1));

        convertView.setOnClickListener(__ -> {
            VibrateHelp.vSimple(holder.tv_option.getContext(), ConstantProvider.VIBRATE_TIME);
            mListener.onClick(option, String.valueOf(i));
        });
        return convertView;
    }

    private final class ViewHolder {
        TextView tv_option;
    }
}