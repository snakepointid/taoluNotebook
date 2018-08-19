package com.lue.taolu.fragments.statistics;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.design.widget.Snackbar;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

import com.lue.taolu.R;
import com.lue.taolu.adapter.OptionStatisticsAdapter;
import com.lue.taolu.bean.Option;

import java.util.ArrayList;
import java.util.List;

import static com.google.common.base.Preconditions.checkNotNull;

/**
 * Created by snakepointid on 2017/12/16.
 */

public class StatisticsFragment extends Fragment implements StatisticsContract.View {

    private StatisticsContract.Presenter mPresenter;
    private OptionStatisticsAdapter mListAdapter;

    public StatisticsFragment() {
        // Requires empty public constructor
    }

    public static StatisticsFragment newInstance() {
        return new StatisticsFragment();
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mListAdapter = new OptionStatisticsAdapter(new ArrayList<Option>(0));

    }
    @Override
    public void onDestroy(){
        super.onDestroy();
        if(mPresenter!=null){
            mPresenter.onDestroy();
            mPresenter=null;
        }
    }
    @Override
    public void onResume() {
        super.onResume();
        mPresenter.subscribe();
    }

    @Override
    public void onPause(){
        super.onPause();
        mPresenter.unsubscribe();
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        View root = inflater.inflate(R.layout.fragment_statistics, container, false);

        ListView listView = root.findViewById(R.id.option_stat_list);
        listView.setAdapter(mListAdapter);

        SwipeRefreshLayout srf_statistic = root.findViewById(R.id.srf_statistic);
        srf_statistic.setEnabled(false);
        return root;
    }

    @Override
    public void showOptionStats(List<Option> options) {
        if(options.isEmpty()){
            showEmptyOptionsMessage();
        }
        mListAdapter.replaceData(options);
    }
    @Override
    public void setPresenter(@NonNull StatisticsContract.Presenter presenter){
        mPresenter = checkNotNull(presenter);
    }
    private void showEmptyOptionsMessage() {
        showMessage(getString(R.string.empty_options));
    }
    private void showMessage(String message) {
        Snackbar.make(getView(), message, Snackbar.LENGTH_LONG).show();
    }
}
