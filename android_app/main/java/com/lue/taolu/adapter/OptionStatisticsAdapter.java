package com.lue.taolu.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.lue.taolu.R;
import com.lue.taolu.bean.Option;

import java.util.List;

import static com.google.common.base.Preconditions.checkNotNull;

public class OptionStatisticsAdapter extends BaseAdapter {

        private List<Option> mOptions;
        public OptionStatisticsAdapter(List<Option>options) {
            setList(options);
        }

        public void replaceData(List<Option>options) {
            setList(options);
            notifyDataSetChanged();
        }

        private void setList(List<Option>options) {
            mOptions = checkNotNull(options);
        }

        @Override
        public int getCount() {
            return mOptions.size();
        }

        @Override
        public Option getItem(int i) {
            return mOptions.get(i);
        }

        @Override
        public long getItemId(int i) {
            return i;
        }

        @Override
        public View getView(int i, View view, ViewGroup viewGroup) {
            View rowView = view;
            if (rowView == null) {
                LayoutInflater inflater = LayoutInflater.from(viewGroup.getContext());
                rowView = inflater.inflate(R.layout.item_option_stats, viewGroup, false);
            }

            final Option option = getItem(i);

            TextView tv_key = rowView.findViewById(R.id.tv_key);
            TextView tv_query = rowView.findViewById(R.id.tv_query);
            TextView tv_count = rowView.findViewById(R.id.tv_count);

            tv_key.setText(option.getKey());
            tv_query.setText(option.getQuery());
            tv_count.setText(Integer.toString(option.getCount()));
            return rowView;
        }
    }