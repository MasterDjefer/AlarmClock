package com.kdab.training;

import android.content.Context;
import android.content.Intent;
import android.util.Log;
import org.qtproject.qt5.android.bindings.QtService;

public class MyService extends QtService
{
    private static final String TAG = "QtAndroidService";

    @Override
    public void onCreate()
    {
        super.onCreate();
        Log.i(TAG, "Creating Service");
    }
    @Override
    public void onDestroy()
    {
        super.onDestroy();
        Log.i(TAG, "Destroying Service");
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId)
    {
        int ret = super.onStartCommand(intent, flags, startId);

        Log.i(TAG, "Running Service");

        return ret;
    }

    public static void startMyService(Context ctx)
    {
        ctx.startService(new Intent(ctx, MyService.class));
    }
}
