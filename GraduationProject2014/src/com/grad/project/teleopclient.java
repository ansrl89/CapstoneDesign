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

public class teleopclient extends Activity implements OnClickListener{

	private EditText editTextIPAddress;
	private TextView textViewStatus;
	
	private ImageButton buttonConnect;
	private ImageButton buttonClose;
	private ImageButton buttonUp;
	private ImageButton buttonLeftTurn;
	private ImageButton buttonRightTurn;
	private ImageButton buttonLeft;
	private ImageButton buttonRight;
	private ImageButton buttonStop;
	private ImageButton buttonStairUp;
	private ImageButton buttonStairDown;
	private ImageButton buttonKickLeft;
	private ImageButton buttonKickRight;
	
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
		setContentView(R.layout.activity_remote);
		
		editTextIPAddress = (EditText)this.findViewById(R.id.editTextIPAddress);
		editTextIPAddress.setText(server);
		imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
				
		textViewStatus = (TextView)this.findViewById(R.id.textViewStatus);
		textViewStatus.setText("Graduation Project");
		
		logger = new logger(textViewStatus);
		
		buttonConnect   = (ImageButton)this.findViewById(R.id.buttonConnect);
		buttonClose     = (ImageButton)this.findViewById(R.id.buttonClose);
		
		buttonUp        = (ImageButton)this.findViewById(R.id.buttonUp);
		buttonLeftTurn  = (ImageButton)this.findViewById(R.id.buttonLeftTurn);
		buttonRightTurn = (ImageButton)this.findViewById(R.id.buttonRightTurn);
		buttonLeft		= (ImageButton)this.findViewById(R.id.buttonLeft);		
		buttonRight     = (ImageButton)this.findViewById(R.id.buttonRight);
		buttonStop      = (ImageButton)this.findViewById(R.id.buttonStop);
		
		buttonStairUp 	= (ImageButton)this.findViewById(R.id.buttonStairUp);
		buttonStairDown	= (ImageButton)this.findViewById(R.id.buttonStairDown);
		buttonKickLeft	= (ImageButton)this.findViewById(R.id.buttonLeftKick);
		buttonKickRight	= (ImageButton)this.findViewById(R.id.buttonRightKick);
		
		buttonConnect.setOnClickListener(this);
		buttonClose.setOnClickListener(this);
		
		buttonUp.setOnClickListener(this);
		buttonLeftTurn.setOnClickListener(this);
		buttonRightTurn.setOnClickListener(this);
		buttonLeft.setOnClickListener(this);
		buttonRight.setOnClickListener(this);
		buttonStop.setOnClickListener(this);
		
		buttonStairUp.setOnClickListener(this);
		buttonStairDown.setOnClickListener(this);
		buttonKickLeft.setOnClickListener(this);
		buttonKickRight.setOnClickListener(this);
		
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
		if(arg0 == buttonConnect)
		{
			imm.hideSoftInputFromWindow(editTextIPAddress.getWindowToken(), 0);
			
			try{
				if(socket!=null)
				{
					socket.close();
					socket = null;
				}
				
				server = editTextIPAddress.getText().toString();
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
		
		if(arg0 == buttonClose)
		{
			imm.hideSoftInputFromWindow(editTextIPAddress.getWindowToken(), 0);
			
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
		
		if(arg0 == buttonUp || arg0 == buttonLeftTurn || 
		   arg0 == buttonRightTurn || arg0 == buttonLeft || arg0 == buttonRight
		   || arg0 == buttonStop || arg0 == buttonStairUp || arg0 == buttonStairDown
		   || arg0 == buttonKickLeft || arg0 == buttonKickRight)
		{
			String sndOpkey = "0";
			
			if(arg0 == buttonUp)	    sndOpkey = "2";
			if(arg0 == buttonLeftTurn)	sndOpkey = "4";
			if(arg0 == buttonRightTurn)	sndOpkey = "6";
			if(arg0 == buttonLeft)	    sndOpkey = "22";
			if(arg0 == buttonRight)		sndOpkey = "24";
			if(arg0 == buttonStop)	    sndOpkey = "26";

			if(arg0 == buttonStairUp)	sndOpkey = "27";
			if(arg0 == buttonStairDown)	sndOpkey = "23";
			if(arg0 == buttonKickLeft)	sndOpkey = "15";
			if(arg0 == buttonKickRight)	sndOpkey = "20";

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
