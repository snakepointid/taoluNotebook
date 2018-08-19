package com.lue.taolu.adapter;


import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.lue.taolu.R;
import com.lue.taolu.bean.Share;
import com.lue.taolu.interf.IListener.shareListListener;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;

import static com.google.common.base.Preconditions.checkNotNull;

public class ShareAdapter extends BaseAdapter {

    private List<Share> mShares;
    private shareListListener mlistener;


    public ShareAdapter(List<Share> shares,shareListListener listener) {
        mShares =  checkNotNull(shares);
        mlistener = checkNotNull(listener);
    }

    public void replaceData(List<Share> shares) {
        mShares = checkNotNull(shares);
        notifyDataSetChanged();
    }

    @Override
    public int getCount() {
        return mShares.size();
    }

    @Override
    public Share getItem(int i) {
        return mShares.get(i);
    }

    @Override
    public long getItemId(int i) {
        return i;
    }

    @Override
    public View getView(int i, View convertView, ViewGroup viewGroup) {
        ViewHolder holder;
        final Share share = getItem(i);
        if (convertView == null) {
            LayoutInflater inflater = LayoutInflater.from(viewGroup.getContext());
            convertView = inflater.inflate(R.layout.item_share, viewGroup, false);
            holder = new ViewHolder();
            holder.target = convertView.findViewById(R.id.tv_target);
            holder.title = convertView.findViewById(R.id.tv_title);
            holder.process = convertView.findViewById(R.id.tv_process);
            holder.likeNumber = convertView.findViewById(R.id.tv_like_num);
            holder.dislikeNumber = convertView.findViewById(R.id.tv_dislike_num);
            holder.commentNumber = convertView.findViewById(R.id.tv_comment_num);
            holder.followNumber = convertView.findViewById(R.id.tv_follow_num);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        JSONObject obj;
        try {
            obj = new JSONObject(share.getRoutineInfo());
            holder.target.setText("#" + obj.getString("target").substring(1) + "#");
            holder.process.setText(obj.getString("process"));
            holder.title.setText(obj.getString("title"));
            holder.likeNumber.setText(obj.getString("likeNumber"));
            holder.dislikeNumber.setText(obj.getString("dislikeNumber"));
            holder.commentNumber.setText(obj.getString("commentNumber"));
            holder.followNumber.setText(obj.getString("followNumber"));
            convertView.setOnClickListener(__->mlistener.onClick(share.getRoutineInfo()));
        } catch (JSONException e) {
            mShares.remove(i);
            notifyDataSetChanged();
        }
        return convertView;
    }


    private final class ViewHolder {
        TextView target;

        TextView title;

        TextView process;

        TextView likeNumber;

        TextView dislikeNumber;

        TextView commentNumber;

        TextView followNumber;

    }
}