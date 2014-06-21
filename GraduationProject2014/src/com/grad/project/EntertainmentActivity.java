package com.grad.project;

import android.os.Bundle;
import android.app.Activity;
import android.content.Context;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.TextView;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.EditText;

import java.net.Socket;
import java.io.IOException;
import java.io.OutputStream;

public class EntertainmentActivity extends Activity implements OnClickListener{

	private EditText editTextIPAddress_2;
	private TextView textViewStatus_2;
	
	private ImageButton buttonConnect_2;
	private ImageButton buttonClose_2;
	private ImageButton button_1;
	private ImageButton button_2;
	private ImageButton button_3;
	private ImageButton button_4;
	private ImageButton button_5;
	private ImageButton button_6;
	private ImageButton button_7;
	private ImageButton button_8;
	private ImageButton button_9;
	private ImageButton button_10;
	private ImageButton button_11;
	private ImageButton button_12;
	private ImageButton button_all;
	
	private Button button_disco;
	private Button button_yell;

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
		setContentView(R.layout.activity_entertainment);
		
		editTextIPAddress_2 = (EditText)this.findViewById(R.id.editTextIPAddress_2);
		editTextIPAddress_2.setText(server);
		imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
				
		textViewStatus_2 = (TextView)this.findViewById(R.id.textViewStatus_2);
		textViewStatus_2.setText("Graduation Project");
		
		logger = new logger(textViewStatus_2);
		
		buttonConnect_2 = (ImageButton)this.findViewById(R.id.buttonConnect_2);
		buttonClose_2   = (ImageButton)this.findViewById(R.id.buttonClose_2);
		
		button_1        = (ImageButton)this.findViewById(R.id.button_1);
		button_2        = (ImageButton)this.findViewById(R.id.button_2);		
		button_3        = (ImageButton)this.findViewById(R.id.button_3);
		button_4        = (ImageButton)this.findViewById(R.id.button_4);		
		button_5        = (ImageButton)this.findViewById(R.id.button_5);
		button_6        = (ImageButton)this.findViewById(R.id.button_6);		
		button_7        = (ImageButton)this.findViewById(R.id.button_7);
		button_8        = (ImageButton)this.findViewById(R.id.button_8);		
		button_9        = (ImageButton)this.findViewById(R.id.button_9);
		button_10       = (ImageButton)this.findViewById(R.id.button_10);		
		button_11       = (ImageButton)this.findViewById(R.id.button_11);
		button_12       = (ImageButton)this.findViewById(R.id.button_12);
		button_all		= (ImageButton)this.findViewById(R.id.button_all);
	
		button_disco	= (Button)this.findViewById(R.id.button_disco);
		button_yell		= (Button)this.findViewById(R.id.button_yell);
		
		buttonConnect_2.setOnClickListener(this);
		buttonClose_2.setOnClickListener(this);
		
		button_1.setOnClickListener(this);
		button_2.setOnClickListener(this);
		button_3.setOnClickListener(this);
		button_4.setOnClickListener(this);
		button_5.setOnClickListener(this);
		button_6.setOnClickListener(this);
		button_7.setOnClickListener(this);
		button_8.setOnClickListener(this);
		button_9.setOnClickListener(this);
		button_10.setOnClickListener(this);
		button_11.setOnClickListener(this);
		button_12.setOnClickListener(this);
		button_all.setOnClickListener(this);
		
		button_disco.setOnClickListener(this);
		button_yell.setOnClickListener(this);
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
		if(arg0 == buttonConnect_2)
		{
			imm.hideSoftInputFromWindow(editTextIPAddress_2.getWindowToken(), 0);
			
			try{
				if(socket!=null)
				{
					socket.close();
					socket = null;
				}
				
				server = editTextIPAddress_2.getText().toString();
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
		
		if(arg0 == buttonClose_2)
		{
			imm.hideSoftInputFromWindow(editTextIPAddress_2.getWindowToken(), 0);
			
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
		
		if(arg0 == button_1 || arg0 == button_2 || arg0 == button_3 || arg0 == button_4 || 
				arg0 == button_5 || arg0 == button_6 || arg0 == button_7 || arg0 == button_8 || 
		   arg0 == button_9 || arg0 == button_10 || arg0 == button_11 || arg0 == button_12 ||
		   arg0 == button_all || arg0 == button_disco || arg0 == button_yell)
		{
			String sndOpkey = "0";
			
			// Need to Numbering
			if(arg0 == button_1)	    sndOpkey = "46";
			if(arg0 == button_2)		sndOpkey = "47";
			if(arg0 == button_3)		sndOpkey = "48";
			if(arg0 == button_4)	    sndOpkey = "49";
			if(arg0 == button_5)		sndOpkey = "50";
			if(arg0 == button_6)	    sndOpkey = "51";
			if(arg0 == button_7)	    sndOpkey = "52";
			if(arg0 == button_8)		sndOpkey = "53";
			if(arg0 == button_9)		sndOpkey = "54";
			if(arg0 == button_10)	    sndOpkey = "55";
			if(arg0 == button_11)		sndOpkey = "56";
			if(arg0 == button_12)	    sndOpkey = "57";
			if(arg0 == button_all)		sndOpkey = "45";
			
			if(arg0 == button_disco)	sndOpkey = "43";
			if(arg0 == button_yell)		sndOpkey = "44";

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