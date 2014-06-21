package com.grad.project;

import android.os.Bundle;
import android.app.Activity;
import android.content.Context;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.TextView;
import android.widget.ImageButton;
import android.widget.EditText;

import java.net.Socket;
import java.io.IOException;
import java.io.OutputStream;

public class missionActivity extends Activity implements OnClickListener{

	private EditText editTextIPAddress_3;
	private TextView textViewStatus_3;
	
	private ImageButton buttonConnect_3;
	private ImageButton buttonClose_3;
	
	private ImageButton button_linetracing;
	private ImageButton button_linetracing_end;
	private ImageButton button_penalty;

	private InputMethodManager imm;
	private String server = "192.168.43.219";
	private int port = 8090;
	private Socket socket;
	private OutputStream outs;
	private Thread rcvThread;
	public logger logger;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_mission);
		
		
		editTextIPAddress_3 = (EditText)this.findViewById(R.id.editTextIPAddress_3);
		editTextIPAddress_3.setText(server);
		imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
				
		textViewStatus_3 = (TextView)this.findViewById(R.id.textViewStatus_3);
		textViewStatus_3.setText("Graduation Project");
		
		logger = new logger(textViewStatus_3);
		
		
		buttonConnect_3 = (ImageButton)this.findViewById(R.id.buttonConnect_3);
		buttonClose_3   = (ImageButton)this.findViewById(R.id.buttonClose_3);
		
		button_linetracing		= (ImageButton)this.findViewById(R.id.button_linetracing);
		button_linetracing_end	= (ImageButton)this.findViewById(R.id.button_linetracing_end);
		button_penalty			= (ImageButton)this.findViewById(R.id.button_penalty);			
		
		buttonConnect_3.setOnClickListener(this);
		buttonClose_3.setOnClickListener(this);
		
		button_linetracing.setOnClickListener(this);
		button_linetracing_end.setOnClickListener(this);
		button_penalty.setOnClickListener(this);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}
	
	public void onBackPressed() {
		if(socket!=null)
		{
			exitFromRunLoop();
			try{
				socket.close();
				socket = null;
				logger.log("Closed!");
				rcvThread = null;
			} catch (IOException e){
				logger.log("Fail to close");
				e.printStackTrace();
			}
		}
		super.onBackPressed();
	 }
	
	@Override
	public void onClick(View arg0) {
		if(arg0 == buttonConnect_3)
		{
			imm.hideSoftInputFromWindow(editTextIPAddress_3.getWindowToken(), 0);
			
			try{
				if(socket!=null)
				{
					socket.close();
					socket = null;
				}
				
				server = editTextIPAddress_3.getText().toString();
				socket = new Socket(server, port);
				outs = socket.getOutputStream();

				rcvThread = new Thread(new rcvthread(logger, socket));
    		    rcvThread.start();
    		    
				String flag = "imchai\n";
				outs.write(flag.getBytes("UTF-8"));
    		    
				logger.log("Connected");
			} catch (IOException e){
				logger.log("Fail to connect");
				e.printStackTrace();
			}
		}
		
		if(arg0 == buttonClose_3)
		{
			imm.hideSoftInputFromWindow(editTextIPAddress_3.getWindowToken(), 0);
			
			if(socket!=null)
			{
				exitFromRunLoop();
				try{
					socket.close();
					socket = null;
					logger.log("Closed!");
					rcvThread = null;
					
				} catch (IOException e){
					logger.log("Fail to close");
					e.printStackTrace();
				}
			}
		}
		
		if(arg0 == button_linetracing || arg0 == button_linetracing_end || 
				arg0 == button_penalty)
		{
			String sndOpkey = "";
			
			// Need to Numbering
			if(arg0 == button_linetracing)		sndOpkey = "m1";
			if(arg0 == button_linetracing_end)	sndOpkey = "m3";
			if(arg0 == button_penalty)			sndOpkey = "m2";

			try{
				outs.write(sndOpkey.getBytes("UTF-8"));
				outs.flush();
			} catch (IOException e){
				logger.log("Fail to send");
				e.printStackTrace();
			}
		}		
	}
	
    void exitFromRunLoop(){
    	try {
    		String sndOpkey = "";
    		outs.write(sndOpkey.getBytes("UTF-8"));
    		outs.flush();
    	} catch (IOException e) {
			logger.log("Fail to send");
			e.printStackTrace();
    	}
    }
}