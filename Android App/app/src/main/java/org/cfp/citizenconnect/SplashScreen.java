package org.cfp.citizenconnect;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.NonNull;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.Toast;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;

import org.cfp.citizenconnect.Model.DataSet;
import org.cfp.citizenconnect.Model.User;

import io.realm.RealmResults;

import static org.cfp.citizenconnect.CitizenConnectApplication.realm;
import static org.cfp.citizenconnect.Model.DataSet.getDataSet;
import static org.cfp.citizenconnect.MyUtils.isDeviceOnline;
import static org.cfp.citizenconnect.MyUtils.mSnakbar;

/**
 * Created by shahzaibshahid on 26/01/2018.
 */

public class SplashScreen extends Activity {
    ProgressBar progressBar;

    User user;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.splash_layout);
        progressBar = findViewById(R.id.progressBar);
        user = User.getUserInstance(realm);
        getResultsFromApi();
    }

    public boolean isObjectExist() {
        RealmResults<DataSet> sets = realm.where(DataSet.class).findAll();
        return sets.size() > 0;
    }

    private class DownloadFilesTask extends AsyncTask<Void, Void, Void> {

        @Override
        protected void onPreExecute() {
            Toast.makeText(SplashScreen.this, getString(R.string.in_progress_msg),
                    Toast.LENGTH_LONG).show();
        }

        @Override
        protected Void doInBackground(Void... voids) {

            getDataSet(response -> {
                        runOnUiThread(() -> {
                            Toast.makeText(SplashScreen.this,
                                    getString(R.string.completed_msg), Toast.LENGTH_LONG).show();

                            progressBar.setVisibility(View.GONE);
                        });

                        final Handler handler = new Handler();
                        handler.postDelayed(SplashScreen.this::launchMainActivity, 2000);


                    },
                    error -> launchMainActivity());
            return null;
        }

        @Override
        protected void onPostExecute(Void result) {
        }

    }

    private void launchMainActivity() {
        final Handler handler = new Handler();
        handler.postDelayed(() -> {
            startActivity(new Intent(SplashScreen.this, MainActivity.class));
            finish();
        }, 500);

    }

    @Override
    protected void onActivityResult(
            int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

                    getResultsFromApi();

    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions,
                                           @NonNull int[] grantResults) {

            getResultsFromApi();

    }

    public void getResultsFromApi() {

      if (!isDeviceOnline(SplashScreen.this)) {
            mSnakbar(getString(R.string.no_internet_msg), null, 5000, 1,
                    findViewById(R.id.coordinator), null);
            progressBar.setVisibility(View.GONE);
        } else {
            if (isObjectExist()) {
                progressBar.setVisibility(View.GONE);
                launchMainActivity();
            } else {
                progressBar.setVisibility(ProgressBar.VISIBLE);
                new DownloadFilesTask().execute();
         }
        }
    }


}
