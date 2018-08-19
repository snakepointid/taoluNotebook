package com.lue.taolu.fragments.edit;

import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.design.widget.BottomSheetDialog;
import android.support.v4.app.Fragment;
import android.support.v7.app.AlertDialog;
import android.support.v7.widget.Toolbar;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.TextView;

import com.lue.taolu.R;
import com.lue.taolu.adapter.OptionAdapter;
import com.lue.taolu.adapter.PolicyFeedbackAdapter;
import com.lue.taolu.adapter.PolicyFeedbackEditAdapter;
import com.lue.taolu.base.MyGridView;
import com.lue.taolu.bean.Routine;
import com.lue.taolu.interf.IListener;
import com.lue.taolu.util.ConstantProvider;
import com.lue.taolu.util.MyTextUtil;
import com.lue.taolu.util.VibrateHelp;

import java.util.ArrayList;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

import static com.google.common.base.Preconditions.checkNotNull;
import static com.lue.taolu.algorithm.OptionAlgorithm.getAgentKey;
import static com.lue.taolu.algorithm.OptionAlgorithm.getPolicyFeedbackKey;
import static com.lue.taolu.algorithm.OptionAlgorithm.getTargetKey;


/**
 * Created by snakepointid on 2017/12/16.
 */

public class RoutineEditFragment extends Fragment implements RoutineEditContract.View {
    final private String TAG = "RoutineEditFragment";

    private PolicyFeedbackAdapter mPolicyFeedbackAdapter;

    private TextView mTv_target;

    private TextView mTv_agent;

    private Toolbar mToolbar;

    private RoutineEditContract.Presenter mPresenter;

    private OptionAdapter mOptionAdapter;

    private TextView mTv_inputType;

    private EditText mEt_option;

    private Routine mRoutine;

    private boolean mTargetModifiable = false;

    private boolean mAgentModifiable = false;

    public static RoutineEditFragment newInstance() {
        return new RoutineEditFragment();
    }

    public RoutineEditFragment() {
        // Requires empty public constructor
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        Log.e(TAG, "onCreate");
        super.onCreate(savedInstanceState);
        mRoutine = new Routine();
        initAdapter();
        showOptionDialog();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View root = inflater.inflate(R.layout.fragment_routine_edit, container, false);

        root.setOnClickListener(__ -> showOptionDialog());

        View v_showOp = root.findViewById(R.id.v_showOp);

        v_showOp.setOnClickListener(__ -> showOptionDialog());

        mTv_target = root.findViewById(R.id.tv_target);

        mTv_agent = root.findViewById(R.id.tv_agent);

        mToolbar = root.findViewById(R.id.tb_menu_only);

        MyGridView routineGridView = root.findViewById(R.id.gv_routine_pad);

        mPolicyFeedbackAdapter = new PolicyFeedbackEditAdapter(new IListener.PolicyItemListener() {
            @Override
            public void newPolicy() {
                showOptionDialog();
            }

            @Override
            public void changePolicy(int position) {

            }
        });

        routineGridView.setAdapter(mPolicyFeedbackAdapter);

        setRoutineEditToolbar();

        return root;
    }



    public void cancelRoutine() {
        if (mRoutine.isEmpty()) {
            getActivity().finish();
        } else {
            showCancelDialog();
        }
    }

    private void showCancelDialog() {
        final AlertDialog.Builder build = new AlertDialog.Builder(getActivity());
        AlertDialog dlg = build.create();
        build.setTitle(R.string.edit_cancel_dialog);
        dlg.setCanceledOnTouchOutside(false);
        build.setPositiveButton("确认", (d, w) -> getActivity().finish());
        build.setNegativeButton("取消", (d, w) -> dlg.cancel());
        build.show();
    }

    private void showInvalidInputDialog() {
        final AlertDialog.Builder build = new AlertDialog.Builder(getActivity(), R.style.alert_dialog);
        AlertDialog dlg = build.create();
        View dialogView = getLayoutInflater().inflate(R.layout.alert_dialog, null);
        TextView tv_msg = dialogView.findViewById(R.id.tv_msg);
        tv_msg.setText(R.string.invalid_input);
        dlg.setView(dialogView);
        dlg.setCanceledOnTouchOutside(true);
        dlg.show();

        final Timer timer = new Timer();
        timer.schedule(new TimerTask() {
            public void run() {
                dlg.cancel();
            }
        }, 1000, 1);
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

    @Override
    public Routine getRoutine() {
        return mRoutine;
    }

    @Override
    public void showOptions(@NonNull List<String> options) {
        mOptionAdapter.replaceData(options);
    }

    @Override
    public void setPresenter(@NonNull RoutineEditContract.Presenter presenter) {
        mPresenter = checkNotNull(presenter);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (mPresenter != null) {
            mPresenter.onDestroy();
            mPresenter = null;
        }
    }

    private void showTarget(String target) {
        Log.e(TAG, "showTarget");
        mTargetModifiable = false;
        mTv_target.setText(target.substring(1));
        mRoutine.setTarget(target);
        showInputHint();
        mTv_target.setOnClickListener(__ -> changeTarget());
    }

    private void changeTarget() {
        mTargetModifiable = true;
        showOptionDialog();
    }

    private void showAgent(String agent) {
        mAgentModifiable = false;
        mTv_agent.setText(agent.substring(1));
        mRoutine.setAgent(agent);
        showInputHint();
        mTv_agent.setOnClickListener(__ -> changeAgent());
    }

    private void changeAgent() {
        mAgentModifiable = true;
        showOptionDialog();
    }

    private void showPolicyOrFeedback(@NonNull String policyOrFeedback) {
        mPolicyFeedbackAdapter.addData(policyOrFeedback);
        mRoutine.addPolicyOrFeedback(policyOrFeedback);
        mTv_inputType.performClick();
        showInputHint();
    }

    private void initAdapter() {
        mOptionAdapter = new OptionAdapter(
                new ArrayList<>(0), (option, position) -> {
            if (mEt_option.getText().length() > 0)
                mRoutine.addClickStream(ConstantProvider.CLICK_CODE_KEYWORD_OPTION);
            else if (position.length() > 1)
                mRoutine.addClickStream(ConstantProvider.CLICK_CODE_REFRESH_OPTION);
            else
                mRoutine.addClickStream(position);
            setClickInputStream(option);
        });
    }

    private void clearEditBox() {
        if (mEt_option.getText().length() > 0)
            mEt_option.setText("");
    }

    public void showOutcomeDialog() {
        Log.e(TAG, "showOutcomeDialog");
        if (mRoutine.isEmpty()) {
            getActivity().finish();
        } else {
            final AlertDialog outcomeDialog = new AlertDialog.Builder(getActivity()).create();

            View dialogView = getLayoutInflater().inflate(R.layout.dialog_outcome, null);
            ImageView iv_happy = dialogView.findViewById(R.id.iv_happy);
            ImageView iv_sad = dialogView.findViewById(R.id.iv_sad);
            iv_happy.setOnClickListener(__ -> {
                mPresenter.saveRoutine(ConstantProvider.POSITIVE_OUTCOME);
                outcomeDialog.cancel();
                getActivity().finish();
            });
            iv_sad.setOnClickListener(__ -> {
                mPresenter.saveRoutine(ConstantProvider.NEGATIVE_OUTCOME);
                outcomeDialog.cancel();
                getActivity().finish();
            });
            outcomeDialog.setView(dialogView);
            outcomeDialog.getWindow()
                    .setBackgroundDrawable(new ColorDrawable(android.graphics.Color.TRANSPARENT));
            outcomeDialog.show();
        }
    }

    private void showOptionDialog() {
        Log.e(TAG, "showOptionDialog");

        final BottomSheetDialog optionDialog = new BottomSheetDialog(getActivity());

        View dialogView = getLayoutInflater().inflate(R.layout.dialog_option, null);

        mTv_inputType = dialogView.findViewById(R.id.tv_inputType);

        mEt_option = dialogView.findViewById(R.id.et_option);

        GridView optionsGridViewTop = dialogView.findViewById(R.id.gv_options_top);

        optionsGridViewTop.setAdapter(mOptionAdapter);

        optionDialog.setContentView(dialogView);

        optionDialog.show();

        optionDialog.getDelegate()
                .findViewById(android.support.design.R.id.design_bottom_sheet)
                .setBackgroundColor(getResources().getColor(R.color.transparent));

        optionDialog.setOnCancelListener(__ -> {
            mAgentModifiable = false;
            mTargetModifiable = false;
        });

        setKeyEnterListener();

        setPolicyAndFeedbackSwitcher();

        showInputHint();

    }

    private void setPolicyAndFeedbackSwitcher() {
        mTv_inputType.setOnClickListener(__ -> {
            if (isPolicyInput()) {
                feedbackHint();
            } else if (isFeedbackInput()) {
                policyHint();
            }
            VibrateHelp.vSimple(getActivity(), ConstantProvider.VIBRATE_TIME);
        });
    }

    private void showInputHint() {
        if (isTargetEditable()) {
            targetHint();
            mPresenter.cacheOptions(getTargetKey(mPresenter.getLastTarget()));
        } else if (isAgentEditable()) {
            agentHint();
            mPresenter.cacheOptions(getAgentKey(mRoutine));
        } else if (isFeedbackInput()) {
            feedbackHint();
            mPresenter.cacheOptions(getPolicyFeedbackKey(mRoutine));
        } else {
            policyHint();
            mPresenter.cacheOptions(getPolicyFeedbackKey(mRoutine));
        }
        clearEditBox();
    }

    private void feedbackHint() {
        mTv_inputType.setText(ConstantProvider.FEEDBACK_LABEL);
        mEt_option.setHint("请输入" + mRoutine.getAgent().substring(1) + "的" + ConstantProvider.FEEDBACK_LABEL);
    }

    private void policyHint() {
        mTv_inputType.setText(ConstantProvider.POLICY_LABEL);
        mEt_option.setHint("请输入" + mRoutine.getTarget().substring(1) + "的" + ConstantProvider.POLICY_LABEL);
    }

    private void agentHint() {
        mTv_inputType.setText(ConstantProvider.AGENT_LABEL);
        mEt_option.setHint("请输入" + mRoutine.getTarget().substring(1) + "的" + ConstantProvider.AGENT_LABEL);
    }

    private void targetHint() {
        mTv_inputType.setText(ConstantProvider.TARGET_LABEL);
        mEt_option.setHint("请输入你的目标");
    }

    private boolean isTargetEditable() {
        return mRoutine.getTarget() == null || mTargetModifiable;
    }

    private boolean isAgentEditable() {
        return mRoutine.getAgent() == null || mAgentModifiable;
    }

    private boolean isPolicyInput() {
        return mTv_inputType.getText().toString().equals(ConstantProvider.POLICY_LABEL);
    }

    private boolean isFeedbackInput() {
        return mTv_inputType.getText().toString().equals(ConstantProvider.FEEDBACK_LABEL);
    }

    private void setEnterInputStream(String inputString) {
        VibrateHelp.vSimple(getActivity(), ConstantProvider.VIBRATE_TIME);

        if (MyTextUtil.validString(inputString)) {
            showInvalidInputDialog();
            return;
        }
        mRoutine.addClickStream(ConstantProvider.CLICK_CODE_ENTER);
        if (isTargetEditable()) {
            showTarget(ConstantProvider.TARGET_SYMBOL + inputString);
        } else if (isAgentEditable()) {
            showAgent(ConstantProvider.AGENT_SYMBOL + inputString);
        } else if (isPolicyInput()) {
            showPolicyOrFeedback(ConstantProvider.POLICY_SYMBOL + inputString);
        } else {
            showPolicyOrFeedback(ConstantProvider.FEEDBACK_SYMBOL + inputString);
        }
    }

    private void setClickInputStream(String inputString) {
        if (isTargetEditable()) {
            showTarget(inputString);
        } else if (isAgentEditable()) {
            showAgent(inputString);
        } else {
            showPolicyOrFeedback(inputString);
        }
    }

    private void setKeyEnterListener() {
        mEt_option.setOnKeyListener((__, keyCode, event) -> {
            if (keyCode == KeyEvent.KEYCODE_ENTER && event.getAction() == KeyEvent.ACTION_DOWN) {
                String inputString = mEt_option.getText().toString();
                setEnterInputStream(inputString);
                return true;
            }
            return false;
        });

        mEt_option.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                String keyword = s.toString();
                if (keyword.length() > 0) {
                    mPresenter.loadKeywordOptions(mTv_inputType.getText().toString(), MyTextUtil.regString(keyword));
                } else {
                    showInputHint();
                }
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });
    }

    private void setRoutineEditToolbar() {
        mToolbar.setNavigationIcon(R.drawable.ic_finish_small);

        mToolbar.setNavigationOnClickListener(__ -> showOutcomeDialog());

        mToolbar.getMenu().clear();
    }


}
