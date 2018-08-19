package com.lue.taolu.algorithm;

import android.support.annotation.Nullable;
import android.text.TextUtils;

import com.google.common.collect.Lists;
import com.lue.taolu.bean.Routine;
import com.lue.taolu.util.ConstantProvider;
import com.lue.taolu.util.SetUtils;

import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by snakepointid on 2018/1/17.
 */

public class OptionAlgorithm {

    public static List<String> combineSortedOptions(List<List<String>>multiplySortedOptions){
        Map<String,String> sortedResult = new LinkedHashMap<>();
        List<String> ret = new ArrayList<>();
        for (List<String> sortedOptions:multiplySortedOptions){
            for(String query:sortedOptions){
                if(!sortedResult.containsKey(query)){
                    ret.add(query);
                    sortedResult.put(query,query);
                }
            }
        }
        return ret;
    }


    public static List<String> combineKeys(List<String> keys){
        int keySize = keys.size();
        if(keySize==0){
            return Collections.emptyList();
        }
        if(keySize==1){
            return keys;
        }
        List<String>keysRet = new ArrayList<>(keySize);
        for(int i=0;i<keySize-1;i++){
            String combineKey =TextUtils.join(ConstantProvider.KEY_COMBINE_CHAR,keys.subList(i,keySize));
            keysRet.add(combineKey);
        }
        keysRet.add(keys.get(keySize-1));
        if(keySize>2){
            keysRet.add(keys.get(keySize-2));
        }
        if(keySize>3){
            keysRet.add(keys.get(keySize-3));
        }
        return keysRet;
    }
    public static List<String> getSortedOptions(@Nullable Map<String,Integer> localOption){
        if (localOption.size()==0){
            return Collections.emptyList();
        }
        List<String> sortedOptionString = SetUtils.sortByValue(localOption);
        Collections.reverse(sortedOptionString);
        return sortedOptionString;
    }

//    public static List<String> getSortedOptions(@Nullable List<String> localOption){
//        if (localOption.size()==0){
//            return Collections.emptyList();
//        }
//        Map<String,Integer>optionMap =new LinkedHashMap<>(localOption.size());
//        for(String keyCount:localOption){
//            String []sep =keyCount.split(ConstantProvider.TEXT_COMBINE_CHAR);
//            optionMap.put(sep[0],Integer.parseInt(sep[1]));
//        }
//        return getSortedOptions(optionMap);
//    }

    public static List<String> getAgentKey(Routine routine){
        return OptionAlgorithm.combineKeys(Lists.newArrayList(routine.getTarget(),ConstantProvider.AGENT_LABEL));
    }
    public static List<String> getTargetKey(String lastTarget){

        return OptionAlgorithm.combineKeys(Lists.newArrayList(lastTarget,ConstantProvider.TARGET_LABEL)) ;
    }

    public static List<String> getPolicyFeedbackKey(Routine routine){
        List<String>policyAndFeedback = routine.getPolicyAndFeedback();
        int policySize = policyAndFeedback.size();
        List<String>keys=  Lists.newArrayList(routine.getAgent(),routine.getTarget());

        if(policySize==1){
            keys.add(policyAndFeedback.get(0));
        }
        if(policySize>1){
            keys.add(policyAndFeedback.get(policySize-2));
            keys.add(policyAndFeedback.get(policySize-1));
        }

        return OptionAlgorithm.combineKeys(keys);
    }

    public static List<String> getPolicyFeedbackKey(Routine routine,List<String>policyAndFeedback){
        int policySize = policyAndFeedback.size();
        List<String>keys=  Lists.newArrayList(routine.getAgent(),routine.getTarget());


        if(policySize==1){
            keys.add(policyAndFeedback.get(0));
        }
        if(policySize>1){
            keys.add(policyAndFeedback.get(policySize-2));
            keys.add(policyAndFeedback.get(policySize-1));
        }

        return OptionAlgorithm.combineKeys(keys);
    }


}
