package com.lue.taolu.fragments.sharelist;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.app.AlertDialog;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;
import android.widget.TextView;

import com.lue.taolu.R;
import com.lue.taolu.activity.ShareActivity;
import com.lue.taolu.adapter.ShareAdapter;
import com.lue.taolu.bean.Share;

import java.util.ArrayList;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

import static com.google.common.base.Preconditions.checkNotNull;

/**
 * Created by snakepointid on 2017/12/16.
 */

public class ShareListFragment extends Fragment implements ShareListContract.View {
    final private String TAG = "ShareListFragment";

    private ShareListContract.Presenter mPresenter;
    private ShareAdapter mListAdapter;
    private Toolbar mToolbar;

    public ShareListFragment() {
        // Requires empty public constructor
    }

    @NonNull
    public static ShareListFragment newInstance() {
        return new ShareListFragment();
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        Log.e(TAG, "onCreate");
        super.onCreate(savedInstanceState);
        initAdapter();
    }

    @Override
    public void onResume() {
        Log.e(TAG, "onResume");
        super.onResume();
    }

    @Override
    public void onPause() {
        super.onPause();
        mPresenter.unsubscribe();
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        Log.e(TAG, "onCreateView");

        View root = inflater.inflate(R.layout.fragment_share_list, container, false);
        mToolbar = root.findViewById(R.id.tb_editable);
        ListView listView = root.findViewById(R.id.routine_list);
        listView.setAdapter(mListAdapter);
        setRefresh(root);
        setShareRoutineListToolbar();
        mPresenter.subscribe();
        return root;
    }

    public void showNetInfo(String msg) {
        final AlertDialog.Builder build = new AlertDialog.Builder(getActivity(), R.style.alert_dialog);
        AlertDialog dlg = build.create();
        View dialogView = getLayoutInflater().inflate(R.layout.alert_dialog, null);
        TextView tv_msg = dialogView.findViewById(R.id.tv_msg);
        tv_msg.setText(msg);
        dlg.setView(dialogView);
        dlg.setCanceledOnTouchOutside(true);
        dlg.show();

        final Timer timer = new Timer();
        timer.schedule(new TimerTask() {
            public void run() {
                dlg.dismiss();
            }
        }, 1000, 1);
    }

    private void setRefresh(View root) {
        SwipeRefreshLayout srf_routine_list = root.findViewById(R.id.srf_routine_list);
        srf_routine_list.setColorSchemeResources(
                R.color.colorAccent,
                R.color.colorPrimary,
                R.color.colorPrimaryDark);

        srf_routine_list.setOnRefreshListener(() -> {
            mPresenter.loadShares();
            srf_routine_list.setRefreshing(false);
        });
    }

    @Override
    public void showShares(List<Share> shares) {
        mListAdapter.replaceData(shares);
    }

    @Override
    public void setPresenter(@NonNull ShareListContract.Presenter presenter) {
        mPresenter = checkNotNull(presenter);
    }


    private void initAdapter() {
        mListAdapter = new ShareAdapter(new ArrayList<>(0), shareInfo -> showShareDetail(shareInfo));
    }

    private void showShareDetail(String shareInfo) {
        Log.e(TAG,"showShareDetail");
        Intent intent = new Intent(getContext(), ShareActivity.class);
        Log.e(TAG,"intent");
        if (shareInfo != null) {
            intent.putExtra(ShareActivity.SHARE_ROUTINE_INFO, shareInfo);
            Log.e(TAG,"startActivity");
            startActivity(intent);
        }
    }

    private void setShareRoutineListToolbar() {
        Log.e(TAG, "setShareRoutineToolbar");

        mToolbar.setNavigationIcon(R.drawable.ic_share_list);
        Log.e(TAG, "add menu");

        mToolbar.setNavigationOnClickListener(__ -> mPresenter.loadShares());
        Log.e(TAG, "add menu");

        mToolbar.getMenu().clear();
        Log.e(TAG, "add menu");

        getActivity().getMenuInflater().inflate(R.menu.menu_share_routine, mToolbar.getMenu());

        mToolbar.setOnMenuItemClickListener(menuItem -> {
            switch (menuItem.getItemId()) {
                case R.id.share_follow:

                    break;
                case R.id.share_self:

                    break;
                default:
                    break;
            }
            return true;
        });
    }
}
