package com.lue.taolu.activity;


import android.os.Bundle;
import android.util.Log;

import com.lue.taolu.R;
import com.lue.taolu.base.MyBaseActivity;
import com.lue.taolu.fragments.detail.RoutineDetailFragment;
import com.lue.taolu.fragments.detail.RoutineDetailPresenter;
import com.lue.taolu.fragments.edit.RoutineEditFragment;
import com.lue.taolu.fragments.edit.RoutineEditPresenter;
import com.lue.taolu.util.ActivityUtils;
import com.lue.taolu.util.Injection;

/**
 * Created by snakepointid on 2017/12/16.
 */

public class RoutineActivity extends MyBaseActivity {
    public static final String ROUTINE_CREATE_TIME = "createTime";

    final private String TAG = "RoutineActivity";

    private String mCreateTime;
    private RoutineEditFragment mRoutineEditFragment;
    private RoutineDetailFragment mRoutineDetailFragment;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Log.e(TAG,"onCreate");

        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_routine);

        mCreateTime  = getIntent().getStringExtra(ROUTINE_CREATE_TIME);
        if(mCreateTime==null){
            showEditFragment();
        }else {
            showDetailFragment();
        }

    }

    public void showEditFragment(){
        mRoutineEditFragment = RoutineEditFragment.newInstance();
        ActivityUtils.addFragmentToActivity(getSupportFragmentManager(),mRoutineEditFragment, R.id.editFrame);

        new RoutineEditPresenter(
                Injection.provideDataRepository(getApplicationContext()),
                mRoutineEditFragment,
                Injection.provideSchedulerProvider());
    }
    private void showDetailFragment(){
        mRoutineDetailFragment  = RoutineDetailFragment.newInstance();

        ActivityUtils.addFragmentToActivity(getSupportFragmentManager(),mRoutineDetailFragment, R.id.editFrame);

        new RoutineDetailPresenter(mCreateTime,
                Injection.provideDataRepository(getApplicationContext()),
                mRoutineDetailFragment,
                Injection.provideSchedulerProvider());
    }


    @Override
    public void onBackPressed() {
        if(mRoutineEditFragment!=null){
            mRoutineEditFragment.cancelRoutine();
        }else{
            mRoutineDetailFragment.updateProcess();
        }
    }

}
