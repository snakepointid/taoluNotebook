package com.lue.taolu.data.local;

/**
 * Created by snakepointid on 2017/12/18.
 */
import android.provider.BaseColumns;

public class PersistenceContract {
    private PersistenceContract() {}
    public static abstract class RoutineEntry implements BaseColumns {
        public static final String TABLE_NAME = "routines";
        public static final String COLUMN_NAME_TIME= "create_time";
        public static final String COLUMN_NAME_TARGET = "target";
        public static final String COLUMN_NAME_OUTCOME = "outcome";
        public static final String COLUMN_NAME_PROCESS = "process";
        public static final String COLUMN_NAME_AGENT = "agent";
        public static final String COLUMN_NAME_DURATION = "duration";
        public static final String COLUMN_NAME_CLICK_STREAM = "click_stream";
        public static final String COLUMN_NAME_STATUS_CODE = "status_code";
        public static final String COLUMN_NAME_POLICY_FEEDBACK = "policy_feedback";
    }
    public static abstract class OptionEntry implements BaseColumns {
        public static final String TABLE_NAME = "options";
        public static final String COLUMN_NAME_KEY = "key";
        public static final String COLUMN_NAME_QUERY = "query";
        public static final String COLUMN_NAME_COUNT = "count";
    }

    public static abstract class KeywordEntry implements BaseColumns {
        public static final String TABLE_NAME = "keyword";
        public static final String COLUMN_NAME_KEY = "key";
        public static final String COLUMN_NAME_COUNT = "count";
    }

    public static abstract class ShareEntry implements BaseColumns {
        public static final String TABLE_NAME = "share";
        public static final String COLUMN_NAME_VALUE = "value";
        public static final String COLUMN_NAME_LIKE = "do_u_like";
    }
}
