package com.lue.taolu.activity;


import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.design.internal.BottomNavigationItemView;
import android.support.design.internal.BottomNavigationMenuView;
import android.support.design.widget.BottomNavigationView;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
import android.widget.ImageView;

import com.lue.taolu.R;
import com.lue.taolu.base.MyBaseActivity;
import com.lue.taolu.fragments.sharelist.ShareListFragment;
import com.lue.taolu.fragments.sharelist.ShareListPresenter;
import com.lue.taolu.fragments.routinelist.RoutineListFragment;
import com.lue.taolu.fragments.routinelist.RoutineListPresenter;
import com.lue.taolu.fragments.statistics.StatisticsFragment;
import com.lue.taolu.fragments.statistics.StatisticsPresenter;
import com.lue.taolu.util.ConstantProvider;
import com.lue.taolu.util.Injection;
import com.lue.taolu.util.MyTextUtil;

import java.lang.reflect.Field;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Created by snakepointid on 2017/12/16.
 */

public class HomeActivity extends MyBaseActivity {
    final private String TAG = "HomeActivity";

    private Map<String,Fragment> mFragments;

    private String mLastShowedFragment;

    private RoutineListFragment mRoutineListFragment;

    private StatisticsFragment mStatisticFragment;
    private ShareListFragment mShareListFragment;


    @Override
    protected void onCreate(Bundle savedInstanceState){
        Log.e(TAG,"onCreate");
        super.onCreate(savedInstanceState);
        initUserConfig();
        setContentView(R.layout.activity_home);
        mFragments = new LinkedHashMap<>();
        ImageView iv_add = findViewById(R.id.iv_add);
        iv_add.setOnClickListener(__->addRoutine());
        initBottomNavigationView();
        showRoutineList();
    }

    private void initUserConfig() {
        SharedPreferences sp = getSharedPreferences( ConstantProvider.USER_INFO,MODE_PRIVATE);
        SharedPreferences.Editor editor = sp.edit();
        if(sp.getString(ConstantProvider.USER_ID,null)==null){
            Log.e(TAG,"init uid");
            editor.putString(ConstantProvider.USER_ID, MyTextUtil.getUid());
        }
        if(sp.getString(ConstantProvider.INIT_TIME,null)==null){
            Log.e(TAG,"init createTime");
            editor.putString(ConstantProvider.INIT_TIME, MyTextUtil.getDateOrTime(ConstantProvider.CREATE_TIME_PATTERN));
        }
        editor.commit();
    }

    @Override
    public void onDestroy(){
        Log.e(TAG, "onDestroy");
        super.onDestroy();
    }
    private void initBottomNavigationView(){
        BottomNavigationView bottomNavigationView =  findViewById(R.id.navigation_view);
        BottomNavigationViewHelper.disableShiftMode(bottomNavigationView);
        bottomNavigationView.setOnNavigationItemSelectedListener(item->{
            switch (item.getItemId()) {
                case R.id.list_routines:
                    showRoutineList();
                    break;
                case R.id.share_routines:
                    showShares();
                    break;
                case R.id.add_routine:
                    addRoutine();
                    break;
                case R.id.mine:
                    showStatistics();
                    break;
                case R.id.account:
                    login();
                    break;
                default:
                    return false;
            }
            return true;
        });
    }
    private void addRoutine(){
        Intent intent = new Intent(this, RoutineActivity.class);
        startActivity(intent);
    }
    private void login(){
        Intent intent = new Intent(this, LoginActivity.class);
        startActivity(intent);
    }
    private void showRoutineList(){
        String fragmentTag = "routineFragment";

        if(mLastShowedFragment==fragmentTag){
            return;
        }
        FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
        if(mRoutineListFragment ==null){
            mRoutineListFragment = RoutineListFragment.newInstance();
            // Create the presenter
            new RoutineListPresenter(
                    mRoutineListFragment,
                    Injection.provideDataRepository(getApplicationContext()),
                    Injection.provideSchedulerProvider());
            mFragments.put(fragmentTag, mRoutineListFragment);
            Log.e(TAG,"showRoutineList:init routineFragment");
        }
        if(mLastShowedFragment!=null){
            transaction.hide(mFragments.get(mLastShowedFragment));
            Log.e(TAG,"showRoutineList:hide statisticFragment");
        }
        if(!mRoutineListFragment.isAdded()){
            transaction.add(R.id.contentFragment, mRoutineListFragment);
            Log.e(TAG,"showRoutineList:add routineFragment");
        }
        transaction.show(mRoutineListFragment).commit();
        Log.e(TAG,"showRoutineList:show routineFragment");

        mLastShowedFragment=fragmentTag;

    }
    private void showStatistics(){
        String fragmentTag = "statisticFragment";

        if(mLastShowedFragment==fragmentTag){
            return;
        }

        FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();

        if(mStatisticFragment==null){
            mStatisticFragment = StatisticsFragment.newInstance();
            new StatisticsPresenter(
                    mStatisticFragment,
                    Injection.provideDataRepository(getApplicationContext()),
                    Injection.provideSchedulerProvider());
            mFragments.put(fragmentTag,mStatisticFragment);
            Log.e(TAG,"showStatistic:init statisticFragment");
        }
        if(mLastShowedFragment!=null){
            transaction.hide(mFragments.get(mLastShowedFragment));
            Log.e(TAG,"showStatistic:hide routineFragment");
        }
        if(!mStatisticFragment.isAdded()){
            transaction.add(R.id.contentFragment,mStatisticFragment);
            Log.e(TAG,"showStatistic:add statisticFragment");
        }
        transaction.show(mStatisticFragment).commitAllowingStateLoss();
        Log.e(TAG,"showStatistic:show statisticFragment");

        mLastShowedFragment=fragmentTag;
    }
    private void showShares(){
        String fragmentTag = "shareFragment";

        if(mLastShowedFragment==fragmentTag){
            return;
        }

        FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();

        if(mShareListFragment ==null){
            mShareListFragment = ShareListFragment.newInstance();
            new ShareListPresenter(
                    mShareListFragment,
                    Injection.provideDataRepository(getApplicationContext()),
                    Injection.provideSchedulerProvider());
            mFragments.put(fragmentTag, mShareListFragment);
            Log.e(TAG,"showShareList:init shareFragment");
        }
        if(mLastShowedFragment!=null){
            transaction.hide(mFragments.get(mLastShowedFragment));
            Log.e(TAG,"showShareList:hide routineFragment");
        }
        if(!mShareListFragment.isAdded()){
            transaction.add(R.id.contentFragment, mShareListFragment);
            Log.e(TAG,"showShareList:add shareFragment");
        }
        transaction.show(mShareListFragment).commitAllowingStateLoss();
        Log.e(TAG,"showShareList:show shareFragment");

        mLastShowedFragment=fragmentTag;
    }

    @SuppressLint("RestrictedApi")
    private static class BottomNavigationViewHelper {
        static void disableShiftMode(BottomNavigationView view) {
            BottomNavigationMenuView menuView = (BottomNavigationMenuView) view.getChildAt(0);
            try {
                Field shiftingMode = menuView.getClass().getDeclaredField("mShiftingMode");
                shiftingMode.setAccessible(true);
                shiftingMode.setBoolean(menuView, false);
                shiftingMode.setAccessible(false);
                for (int i = 0; i < menuView.getChildCount(); i++) {
                    BottomNavigationItemView item = (BottomNavigationItemView) menuView.getChildAt(i);
                    item.setShiftingMode(false);
                    item.setChecked(item.getItemData().isChecked());
                }
            } catch (NoSuchFieldException e) {
                Log.e("BNVHelper", "Unable to get shift mode field", e);
            } catch (IllegalAccessException e) {
                Log.e("BNVHelper", "Unable to change value of shift mode", e);
            }
        }
    }
}
