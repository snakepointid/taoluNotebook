package com.lue.taolu.fragments.detail;

import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.lue.taolu.R;
import com.lue.taolu.adapter.PolicyFeedbackAdapter;
import com.lue.taolu.base.MyGridView;
import com.lue.taolu.bean.Routine;
import com.lue.taolu.util.ConstantProvider;

import static com.google.common.base.Preconditions.checkNotNull;

/**
 * Created by snakepointid on 2017/12/16.
 */

public class RoutineDetailFragment extends Fragment implements RoutineDetailContract.View {
    final private String TAG = "RoutineDetailFragment";

    private PolicyFeedbackAdapter mPolicyFeedbackAdapter;

    private TextView mTv_target;

    private TextView mTv_agent;

    private ImageView mIv_outcome;

    private Toolbar mToolbar;

    private EditText mEt_process;

    private TextView mTv_process_title;

    private TextView mTv_time_brief;

    private RoutineDetailContract.Presenter mPresenter;

    private String mCreateTime;

    public static RoutineDetailFragment newInstance() {

        return new RoutineDetailFragment();

    }

    public RoutineDetailFragment() {
        // Requires empty public constructor
    }
    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        Log.e(TAG,"onCreate");
        super.onCreate(savedInstanceState);
    }
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View root = inflater.inflate(R.layout.fragment_routine_show, container, false);

        //get views
        mTv_target = root.findViewById(R.id.tv_target);

        mTv_agent = root.findViewById(R.id.tv_agent);

        mIv_outcome = root.findViewById(R.id.iv_outcome);

        mEt_process = root.findViewById(R.id.et_process);

        mTv_process_title = root.findViewById(R.id.tv_process_title);

        mTv_time_brief = root.findViewById(R.id.tv_time_brief);

        mToolbar = root.findViewById(R.id.tb_menu_only);

        MyGridView routineGridView = root.findViewById(R.id.gv_routine_pad);

        mPolicyFeedbackAdapter = new PolicyFeedbackAdapter();

        routineGridView.setAdapter(mPolicyFeedbackAdapter);

        mPresenter.subscribe();

        setRoutineDetailToolbar();

        return root;
    }
    @Override
    public void onResume() {
        Log.e(TAG,"onResume");
        super.onResume();
    }
    @Override
    public void onPause() {
        super.onPause();
        mPresenter.unsubscribe();
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
    public void setPresenter(@NonNull RoutineDetailContract.Presenter presenter) {
        mPresenter = checkNotNull(presenter);
    }

    @Override
    public void showRoutine(@NonNull Routine routine){
        Log.e(TAG,"showRoutine");
        mCreateTime = routine.getCreateTime();
        mTv_target.setText(routine.getTarget().substring(1));
        mTv_agent.setText(routine.getAgent().substring(1));
        if(routine.getOutcome().equals(ConstantProvider.POSITIVE_OUTCOME)){
            mIv_outcome.setImageResource(R.drawable.ic_happy_small);
        }else{
            mIv_outcome.setImageResource(R.drawable.ic_sad_small);
        }

        mPolicyFeedbackAdapter.replaceData(routine.getPolicyAndFeedback());

        String process = routine.getProcess();
        Log.e(TAG,"getProcess");

        if(process.length()>0){
            mTv_process_title.setText(R.string.routine_process_title);
            mTv_time_brief.setText(routine.getCreateTime());
            mEt_process.setText(process);
        }
    }
    public void updateProcess(){
        mPresenter.updateProcess(mCreateTime,mEt_process.getText().toString());
        getActivity().finish();
    }
    private void setRoutineDetailToolbar(){
        Log.e(TAG,"setRoutineDetailToolbar");

        mToolbar.setNavigationIcon(R.drawable.ic_back_small);

        mToolbar.setNavigationOnClickListener(__->updateProcess());
        Log.e(TAG,"set updateProcess listener");

        mToolbar.getMenu().clear();

        getActivity().getMenuInflater().inflate(R.menu.menu_routine,mToolbar.getMenu());

        mToolbar.setOnMenuItemClickListener(menuItem -> {
            switch (menuItem.getItemId()) {
                case R.id.add_process:
                    InputMethodManager imm =
                            (InputMethodManager) getActivity()
                                    .getSystemService(getActivity().INPUT_METHOD_SERVICE);
                    if(!mEt_process.isFocusable()){
                        menuItem.setIcon(R.drawable.ic_finish_small);
                        Log.e(TAG,"setImageResource ic_finish_small");

                        mEt_process.setFocusable(true);
                        mEt_process.setFocusableInTouchMode(true);
                        mEt_process.requestFocus();
                        mEt_process.setSelection(mEt_process.getText().length());
                        imm.showSoftInput(mEt_process, InputMethodManager.SHOW_FORCED);
                    }else{
                        menuItem.setIcon(R.drawable.ic_pencil_tb);
                        Log.e(TAG,"setImageResource ic_pencil_tb");

                        mEt_process.clearFocus();
                        mEt_process.setFocusable(false);
                        imm.hideSoftInputFromWindow(getActivity().getWindow().getDecorView().getWindowToken(), 0);
                    }
                    break;
                default:
                    break;
            }
            return true;
        });

    }

}
