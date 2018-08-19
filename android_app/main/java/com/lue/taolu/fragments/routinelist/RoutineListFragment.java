package com.lue.taolu.fragments.routinelist;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.Toolbar;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ListView;

import com.google.common.collect.Lists;
import com.lue.taolu.R;
import com.lue.taolu.activity.RoutineActivity;
import com.lue.taolu.adapter.RoutineListAdapter;
import com.lue.taolu.bean.Routine;
import com.lue.taolu.interf.IListener.RoutineItemListener;

import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import static com.google.common.base.Preconditions.checkNotNull;

/**
 * Created by snakepointid on 2017/12/16.
 */

public class RoutineListFragment extends Fragment implements RoutineListContract.View {
    final private String TAG = "RoutineListFragment";

    private RoutineListContract.Presenter mPresenter;
    private RoutineListAdapter mListAdapter;
    private Map<String, String> mRoutineIdsToDelete;
    private Toolbar mToolbar;

    public RoutineListFragment() {
        // Requires empty public constructor
    }

    @NonNull
    public static RoutineListFragment newInstance() {
        return new RoutineListFragment();
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        Log.e(TAG, "onCreate");
        mRoutineIdsToDelete = new LinkedHashMap<>(0);
        super.onCreate(savedInstanceState);
        initAdapter();
    }

    @Override
    public void onResume() {
        Log.e(TAG, "onResume");
        super.onResume();
        mPresenter.subscribe();
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

        View root = inflater.inflate(R.layout.fragment_routine_list, container, false);

        ListView listView = root.findViewById(R.id.routine_list);
        listView.setAdapter(mListAdapter);

        mToolbar = root.findViewById(R.id.tb_editable);
        setRoutineListToolbar();
        setToolbarMenuListener();
        return root;
    }

    @Override
    public void showRoutineList(List<Routine> routines) {
        if (!routines.isEmpty()) {
            Collections.reverse(routines);
        }
        mListAdapter.replaceData(routines);
    }

    @Override
    public void setPresenter(@NonNull RoutineListContract.Presenter presenter) {
        mPresenter = checkNotNull(presenter);
    }

    private void showRoutineDetail(Routine routine) {
        Intent intent = new Intent(getContext(), RoutineActivity.class);
        if (routine != null) {
            String createTime = routine.getCreateTime();
            intent.putExtra(RoutineActivity.ROUTINE_CREATE_TIME, createTime);
        }
        startActivity(intent);
    }

    private void initAdapter() {
        mListAdapter = new RoutineListAdapter(new ArrayList<Routine>(0), new RoutineItemListener() {
            @Override
            public void onClick(Routine routine) {
                showRoutineDetail(routine);
            }

            @Override
            public void onLongClick() {
                setRoutineSelectableToolbar();
            }

            @Override
            public void onCheck(boolean checkedFlag, String routineId) {
                if (checkedFlag) {
                    mRoutineIdsToDelete.put(routineId, "yes");
                } else {
                    mRoutineIdsToDelete.remove(routineId);
                }
            }
        });
    }

    private void setRoutineSelectableToolbar() {
        mToolbar.setNavigationIcon(R.drawable.ic_cancel_small);
        mToolbar.setNavigationOnClickListener(__ -> {
            mListAdapter.setCheckBoxInVisible();
            setRoutineListToolbar();
        });
        mToolbar.getMenu().clear();
        getActivity().getMenuInflater().inflate(R.menu.menu_routine_list_select, mToolbar.getMenu());


    }

    private void setRoutineListToolbar() {
        mToolbar.setNavigationIcon(R.drawable.ic_sorting_small);
        mToolbar.setNavigationOnClickListener(__ -> mListAdapter.reverseData());
        mToolbar.getMenu().clear();
        getActivity().getMenuInflater().inflate(R.menu.menu_routine_list, mToolbar.getMenu());
    }

    private void setToolbarMenuListener() {
        EditText et_search_pad = mToolbar.findViewById(R.id.et_search_pad);

        et_search_pad.addTextChangedListener(
                new TextWatcher() {
                    @Override
                    public void beforeTextChanged(CharSequence s, int start, int count, int after) {

                    }

                    @Override
                    public void afterTextChanged(Editable s) {

                    }

                    @Override
                    public void onTextChanged(CharSequence s, int start, int before, int count) {
                        String keyword = s.toString();
                        mPresenter.searchRoutines(keyword);
                        if(keyword.length()==0)
                            et_search_pad.setCursorVisible(false);
                        else
                            et_search_pad.setCursorVisible(true);
                    }
                });


        mToolbar.setOnMenuItemClickListener(menuItem -> {
            switch (menuItem.getItemId()) {
                case R.id.list_combine:
                    mListAdapter.briefDetailSwitch();
                    break;
                case R.id.list_delete:
                    mPresenter.deleteRoutines(Lists.newArrayList(mRoutineIdsToDelete.keySet()));
                    mRoutineIdsToDelete = new LinkedHashMap<>();
                    mListAdapter.setCheckBoxInVisible();
                    setRoutineListToolbar();
                    break;
                default:
                    break;
            }
            return true;
        });
    }

}
