package com.lue.taolu.data.local;

/**
 * Created by snakepointid on 2017/12/18.
 */

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import com.lue.taolu.data.local.PersistenceContract.*;

public class RoutineDbHelper extends SQLiteOpenHelper {
    public static final int DATABASE_VERSION = 1;

    public static final String DATABASE_NAME = "taolu.db";

    private static final String TEXT_TYPE = " TEXT";

    private static final String CHAR_TYPE = " CHAR(6)";

    private static final String CODE_TYPE = " CHAR(1)";

    private static final String TIME_TYPE = " CHAR(20)";

    private static final String COUNT_TYPE = " INTEGER";

    private static final String FLOAT_TYPE = " REAL";

    private static final String COMMA_SEP = ",";

    private static final String PADDING = " ";

    private static final String SQL_CREATE_ROUTINE_ENTRIES =
            "CREATE TABLE IF NOT EXISTS" + PADDING +
                    RoutineEntry.TABLE_NAME + " (" +
                    RoutineEntry.COLUMN_NAME_TIME + TIME_TYPE + " PRIMARY KEY," +
                    RoutineEntry.COLUMN_NAME_TARGET + CHAR_TYPE + COMMA_SEP +
                    RoutineEntry.COLUMN_NAME_OUTCOME + CODE_TYPE + COMMA_SEP +
                    RoutineEntry.COLUMN_NAME_AGENT + CHAR_TYPE + COMMA_SEP +
                    RoutineEntry.COLUMN_NAME_CLICK_STREAM + TEXT_TYPE + COMMA_SEP +
                    RoutineEntry.COLUMN_NAME_PROCESS + TEXT_TYPE + COMMA_SEP +
                    RoutineEntry.COLUMN_NAME_DURATION + FLOAT_TYPE + COMMA_SEP +
                    RoutineEntry.COLUMN_NAME_STATUS_CODE + CODE_TYPE + COMMA_SEP +
                    RoutineEntry.COLUMN_NAME_POLICY_FEEDBACK + TEXT_TYPE + " )";

    private static final String SQL_CREATE_OPTION_ENTRIES =
            "CREATE TABLE IF NOT EXISTS" + PADDING +
                    OptionEntry.TABLE_NAME + " (" +
                    OptionEntry.COLUMN_NAME_KEY + TEXT_TYPE + COMMA_SEP +
                    OptionEntry.COLUMN_NAME_QUERY + CHAR_TYPE + COMMA_SEP +
                    OptionEntry.COLUMN_NAME_COUNT + COUNT_TYPE + COMMA_SEP +
                    " PRIMARY KEY(" + OptionEntry.COLUMN_NAME_KEY + COMMA_SEP + OptionEntry.COLUMN_NAME_QUERY + "))";


    private static final String SQL_CREATE_KEYWORD_ENTRIES =
            "CREATE TABLE IF NOT EXISTS" + PADDING +
                    KeywordEntry.TABLE_NAME + " (" +
                    KeywordEntry.COLUMN_NAME_KEY + CHAR_TYPE + " PRIMARY KEY," +
                    KeywordEntry.COLUMN_NAME_COUNT + COUNT_TYPE + " )";

    private static final String SQL_CREATE_SHARE_ENTRIES =
            "CREATE TABLE IF NOT EXISTS" + PADDING +
                    ShareEntry.TABLE_NAME + " (" +
                    ShareEntry.COLUMN_NAME_VALUE + TEXT_TYPE+ " PRIMARY KEY,"+
                    ShareEntry.COLUMN_NAME_LIKE+CODE_TYPE+ ")";

    public RoutineDbHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }

    public void onCreate(SQLiteDatabase db) {
        db.execSQL(SQL_CREATE_ROUTINE_ENTRIES);
        db.execSQL(SQL_CREATE_OPTION_ENTRIES);
        db.execSQL(SQL_CREATE_KEYWORD_ENTRIES);
        db.execSQL(SQL_CREATE_SHARE_ENTRIES);
    }

    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        // Not required as at version 1
    }

    public void onDowngrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        // Not required as at version 1
    }
}