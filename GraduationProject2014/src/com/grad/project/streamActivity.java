package com.grad.project;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.charset.Charset;

import org.opencv.highgui.*;
import org.opencv.*;
import org.opencv.android.Utils;
import org.opencv.core.Mat;

import android.os.Bundle;
import android.os.Handler;
import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;

import static com.googlecode.javacv.cpp.opencv_core.*;
import static com.googlecode.javacv.cpp.opencv_highgui.*;
import static com.googlecode.javacv.cpp.opencv_legacy.*;

public class streamActivity extends Activity implements OnClickListener{
	
	private EditText editTextIPAddress_4;
	private TextView textViewStatus_4;
	
	private ImageButton buttonConnect_4;
	private ImageButton buttonClose_4;

	private InputMethodManager imm;
	private String server = "192.168.1.100";
	private int port = 8090;
	private Socket socket;
	private DataInputStream is;
	private DataOutputStream os;
	private Handler hd;
	private OutputStream outs;
	private Thread rcvThread;
	public logger logger;
	
	private final int sizeBuf = 160*120*3;
	private String rcvData = "Error";
	private byte[] rcvBuf = new byte[sizeBuf];
	private int rcvBufSize;
	
	int flag = 1;
	
	ImageView iv;
	
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_stream);

		editTextIPAddress_4 = (EditText)this.findViewById(R.id.editTextIPAddress_4);
		editTextIPAddress_4.setText(server);
		imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
				
		textViewStatus_4 = (TextView)this.findViewById(R.id.textViewStatus_4);
		textViewStatus_4.setText("Graduation Project");
		
		logger = new logger(textViewStatus_4);
		
		buttonConnect_4 = (ImageButton)this.findViewById(R.id.buttonConnect_4);
		buttonClose_4   = (ImageButton)this.findViewById(R.id.buttonClose_4);
		iv				= (ImageView)this.findViewById(R.id.ImgView);
		
		buttonConnect_4.setOnClickListener(this);
		buttonClose_4.setOnClickListener(this);
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
	public void onClick(View arg0){
		if(arg0 == buttonConnect_4)
		{
			imm.hideSoftInputFromWindow(editTextIPAddress_4.getWindowToken(), 0);
			
			try{
				if(socket!=null)
				{
					socket.close();
					socket = null;
				}
				
				server = editTextIPAddress_4.getText().toString();
				socket = new Socket(server, port);
				
				outs = socket.getOutputStream();
				InputStream is = socket.getInputStream();
				BufferedReader br = new BufferedReader(new InputStreamReader(is));
				
				logger.log("Connected");
				
				String flag_str = "stream\n";
				outs.write(flag_str.getBytes("UTF-8"));
				
				rcvBufSize = socket.getInputStream().read(rcvBuf);
				rcvData = new String(rcvBuf, 0, rcvBufSize, "UTF-8");
				
				byte[] bytebuf = rcvData.getBytes();
				Bitmap bmp = BitmapFactory.decodeByteArray(bytebuf, 0, rcvBufSize);
				iv.setImageBitmap(bmp);
				
				/*
				IplImage iimg = new IplImage();
				iimg.create(new CvSize(160, 120), 8, 3);
				iimg.imageData().get(rcvData.getBytes());
				*/
				
						
				/*
				while(flag == 1){
					try{
						rcvBufSize = socket.getInputStream().read(rcvBuf);
						rcvData = new String(rcvBuf, 0, rcvBufSize, "UTF-8");
						
						byte[] bytebuf = rcvData.getBytes();
						
						Bitmap bitmap = BitmapFactory.decodeByteArray(bytebuf, 0, rcvBufSize);
						iv.setImageBitmap(bitmap);
						
						logger.log("" + bytebuf);
						
						if(rcvData.compareTo("")==0){
							flag = 0;
						}
					}
					catch (IOException e){
						e.printStackTrace();
					}
				}
				*/
						
				/*
				while(true)
				{
					logger.log("Receiving...");
					// Socket Receive
					String msg = br.readLine();
					// Change Received data
					int length = rcvData.length();
					
					tempBuffer = rcvData.getBytes();
					byte[] obj = new byte[160*120*3];

					int last = index + length;
					int tmpIndex = 0;
					for(int i=index; i<last; i++){
						if(i >= 160*120*3){
							// bgr to rgb
							for (int j = 0; j < 160*120*3; j += 3){
								byte tmp = obj[j];
								obj[j] = obj[j + 2];
								obj[j + 2] = obj[j];
							}
							
							bmp = BitmapFactory.decodeByteArray(obj, 0, 160 * 120 * 3);
							iv.setImageBitmap(bmp);
						
							i = 0;
							last = last % (160*120*3);
						}
						
						obj[i] = tempBuffer[tmpIndex++];
						
					}
					index += length;
					if(index >= (160*120*3)){
						index = index %(160*120*3);
					}
				}*/
				
			} catch (IOException e){
				logger.log("Fail to connect");
				e.printStackTrace();
			}
		}
		
		if(arg0 == buttonClose_4)
		{
			imm.hideSoftInputFromWindow(editTextIPAddress_4.getWindowToken(), 0);
			
			if(socket!=null)
			{
				exitFromRunLoop();
				try{
					socket.close();
					socket = null;
					logger.log("Closed!");
					flag = 0;
					
				} catch (IOException e){
					logger.log("Fail to close");
					e.printStackTrace();
				}
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
