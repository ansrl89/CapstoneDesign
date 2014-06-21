package com.grad.project;

import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageButton;

public class MainActivity extends Activity {

	@Override
	public void onCreate(Bundle savedInstanceState){
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		ImageButton button2 =(ImageButton)findViewById(R.id.remote_button);
		button2.setOnClickListener(new OnClickListener()
		{
			public void onClick(View v){
				Intent intent=new Intent(MainActivity.this, teleopclient.class);
				startActivity(intent);
			}
		});
		
		ImageButton button3 = (ImageButton)findViewById(R.id.kookmin_button);
		button3.setOnClickListener(new OnClickListener()
		{
			public void onClick(View v){
				Intent intent=new Intent(MainActivity.this, EntertainmentActivity.class);
				startActivity(intent);
			}
		});
		
		ImageButton button4 = (ImageButton)findViewById(R.id.mission_button);
		button4.setOnClickListener(new OnClickListener()
		{
			public void onClick(View v){
				Intent intent=new Intent(MainActivity.this, missionActivity.class);
				startActivity(intent);
			}
		});
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

}
