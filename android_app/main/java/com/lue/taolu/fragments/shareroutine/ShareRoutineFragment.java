package com.lue.taolu.fragments.shareroutine;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
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
import com.lue.taolu.util.ConstantProvider;
import com.lue.taolu.util.MyTextUtil;

import org.json.JSONException;
import org.json.JSONObject;

import static com.google.common.base.Preconditions.checkNotNull;

/**
 * Created by snakepointid on 2017/12/16.
 */

public class ShareRoutineFragment extends Fragment implements ShareRoutineContract.View {
    final private String TAG = "ShareRoutineFragment";

    private PolicyFeedbackAdapter mPolicyFeedbackAdapter;

    private TextView mTv_target;

    private TextView mTv_agent;

    private ImageView mIv_outcome;

    private Toolbar mToolbar;

    private EditText mEt_process;

    private TextView mTv_process_title;

    private TextView mTv_time_brief;

    private ShareRoutineContract.Presenter mPresenter;
    private TextView mTv_like_num;
    private TextView mTv_dislike_num;
    private TextView mTv_comment_num;
    private TextView mTv_follow_num;


    public static ShareRoutineFragment newInstance() {

        return new ShareRoutineFragment();

    }

    public ShareRoutineFragment() {
        // Requires empty public constructor
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        Log.e(TAG, "onCreate");
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View root = inflater.inflate(R.layout.fragment_share, container, false);

        //get views
        mTv_target = root.findViewById(R.id.tv_target);

        mTv_agent = root.findViewById(R.id.tv_agent);

        mIv_outcome = root.findViewById(R.id.iv_outcome);

        mEt_process = root.findViewById(R.id.et_process);

        mTv_process_title = root.findViewById(R.id.tv_process_title);

        mTv_time_brief = root.findViewById(R.id.tv_time_brief);

        mTv_like_num = root.findViewById(R.id.tv_like_num);

        mTv_dislike_num = root.findViewById(R.id.tv_dislike_num);

        mTv_comment_num = root.findViewById(R.id.tv_comment_num);

        mTv_follow_num = root.findViewById(R.id.tv_follow_num);

        mToolbar = root.findViewById(R.id.tb_menu_only);

        MyGridView routineGridView = root.findViewById(R.id.gv_routine_pad);

        mPolicyFeedbackAdapter = new PolicyFeedbackAdapter();

        routineGridView.setAdapter(mPolicyFeedbackAdapter);

        mPresenter.subscribe();

        setShareRoutineToolbar();

        return root;
    }


    @Override
    public void onDestroy() {
        super.onDestroy();
        if (mPresenter != null) {
            mPresenter.onDestroy();
            mPresenter = null;
        }
    }

    @Override
    public void setPresenter(@NonNull ShareRoutineContract.Presenter presenter) {
        mPresenter = checkNotNull(presenter);
    }

    @Override
    public void showShare(@NonNull String shareInfo) {
        JSONObject obj;
        try {
            obj = new JSONObject(shareInfo);
            mTv_target.setText(obj.getString("target").substring(1));

            mTv_agent.setText(obj.getString("agent").substring(1));

            if (obj.getString("outcome").equals(ConstantProvider.POSITIVE_OUTCOME)) {
                mIv_outcome.setImageResource(R.drawable.ic_happy_small);
            } else {
                mIv_outcome.setImageResource(R.drawable.ic_sad_small);

            }

            mTv_like_num.setText(obj.getString("likeNumber"));

            mTv_dislike_num.setText(obj.getString("dislikeNumber"));

            mTv_comment_num.setText(obj.getString("commentNumber"));

            mTv_follow_num.setText(obj.getString("followNumber"));

            mEt_process.setText(obj.getString("process"));

            mTv_process_title.setText(obj.getString("title"));

            mTv_time_brief.setText(obj.getString("create_time"));

            mPolicyFeedbackAdapter.replaceData(MyTextUtil.policyFeedbackString2Array(obj.getString("policy_feedback")));


        } catch (JSONException e) {
        }
    }

    private void setShareRoutineToolbar() {
        Log.e(TAG, "setShareRoutineToolbar");

        mToolbar.setNavigationIcon(R.drawable.ic_back_small);
        Log.e(TAG, "add menu");

        mToolbar.setNavigationOnClickListener(__ -> getActivity().finish());
        Log.e(TAG, "add menu");


    }

}
