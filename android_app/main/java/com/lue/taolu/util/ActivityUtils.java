package com.lue.taolu.util;

/**
 * Created by snakepointid on 2017/12/16.
 */

import android.support.annotation.NonNull;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;

import com.lue.taolu.R;
import com.lue.taolu.fragments.edit.RoutineEditFragment;

import static com.google.common.base.Preconditions.checkNotNull;

/**
 * This provides methods to help Activities load their UI.
 */
public class ActivityUtils {

    /**
     * The {@code fragment} is added to the container view with id {@code frameId}. The operation is
     * performed by the {@code fragmentManager}.
     *
     */
    public static void addFragmentToActivity(@NonNull FragmentManager fragmentManager,
                                             @NonNull Fragment fragment, int frameId) {
        checkNotNull(fragmentManager);
        checkNotNull(fragment);

        FragmentTransaction transaction = fragmentManager.beginTransaction();
        Fragment oldFragment = (Fragment) fragmentManager.findFragmentById(R.id.editFrame);
        if(oldFragment==null){
            transaction.add(frameId, fragment);
        }else{
            transaction.replace(frameId, fragment);
        }
        transaction.commit();
    }
}
