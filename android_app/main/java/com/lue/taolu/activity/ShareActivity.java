package com.lue.taolu.activity;

import android.os.Bundle;
import android.util.Log;

import com.lue.taolu.R;
import com.lue.taolu.base.MyBaseActivity;
import com.lue.taolu.fragments.shareroutine.ShareRoutineFragment;
import com.lue.taolu.fragments.shareroutine.ShareRoutinePresenter;
import com.lue.taolu.util.ActivityUtils;
import com.lue.taolu.util.Injection;

/**
 * Created by snakepointid on 2018/3/8.
 */

public class ShareActivity extends MyBaseActivity {
    public static final String SHARE_ROUTINE_INFO = "shareRoutineInfo";

    final private String TAG = "ShareActivity";

    private String mShareRoutineInfo;

    private ShareRoutineFragment mShareRoutineFragment;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Log.e(TAG,"onCreate");

        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_share);

        mShareRoutineInfo = getIntent().getStringExtra(SHARE_ROUTINE_INFO);
        mShareRoutineFragment = ShareRoutineFragment.newInstance();
        ActivityUtils.addFragmentToActivity(getSupportFragmentManager(), mShareRoutineFragment, R.id.shareFrame);

        new ShareRoutinePresenter(
                mShareRoutineFragment,
                mShareRoutineInfo,
                Injection.provideDataRepository(getApplicationContext()),
                Injection.provideSchedulerProvider());
    }
}
