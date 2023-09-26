
function SMSSend(obj)
{
	BodyLoadHandler();
	BodyUnLoadHandler();
	
	
   //====================================================================
  function BodyLoadHandler() {
	
	var obj;
/*
	obj=document.getElementById("btnSendMessage")
	if (obj) {
		obj.onclick=SendMessage_click;
		obj.disabled=true;
	}
	
	obj=document.getElementById('Message');
	if (obj) { obj.value="正在连接设备..."; }
	*/
	
	//obj=document.getElementById('GSM');
	//if (obj) { objGSM=obj; }
	//alert(obj);
	
	try {
    	objGSM=new ActiveXObject("DHCPEGSM.GSM");
	}
	catch (e) {
		ExtTool.alert("","创建短信对象失败");
		return null;
	}
	
	if (objGSM) {
		var ret=objGSM.OpenGSM("Send");
		if (0!=ret) {
		ExtTool.alert("","打开设备失败时发生错误:\n"+ret);
		return null;
		/*
		obj=document.getElementById("btnSendMessage")
		if (obj) { obj.disabled=true; }
		
		obj=document.getElementById('Message');
		if (obj) { obj.value="设备初始化失败,不能发送短信"; }
		return;
	  }else{
		obj=document.getElementById("btnSendMessage")
		if (obj) { obj.disabled=false; }
	   */
	  }
	  //objGSM=0;
	}	
	/*
	obj=document.getElementById('Message');
	if (obj) { obj.value=""; }
	*/
	//alert('su');
	//iniForm();
	
	//ShowCurRecord(1);
	
	SendMessage_click();
	//TheSMSobj.SMSWin.setVisible(false);
}
function BodyUnLoadHandler() {

	objGSM.CloseGSM();
	objGSM=null;
}
function iniForm() {
	/*
	var obj;
	obj=document.getElementById('DataBox');
	if (obj && ""!=obj.value) { SetDataInfor(obj.value); }
	
	obj=document.getElementById('Mobile');
	if (obj && ""!=obj.value && objGSM) {
		obj=document.getElementById("btnSendMessage")
		if (obj) { obj.disabled=false; }	
	}
 */
}

function SetDataInfor(value) {
	var obj;
	if ((""==value)&&("^"==value)) { return false; }
	var Data=value.split("^");
	//Clear_click();
	
	obj=document.getElementById('Mobile');
	if (obj && ""!=Data[0]) {
		obj.value=Data[0];
	}
	
	obj=document.getElementById('ReceiveName');
	if (obj && ""!=Data[1]) { obj.value=Data[1]; }
	
	obj=document.getElementById('Message');
	if (obj && ""!=Data[2]) { obj.value=Data[2]; }
}

function trim(s) {
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
///判断移动电话
function isMoveTel(elem){
	if (elem=="") return true;
	var pattern=/^0{0,1}13|15[0-9]{9}$/;
	if(pattern.test(elem)){
		return true;
	}else{

	return false;
 	}
}
function SendMessage_click(){
	//为保存准备发送内容串
	var TheOBJ = ExtTool.StaticServerObject("web.DHCHM.MessageSend");
	var iMessage="";
	var SendList="";Valuestr="";
    //  var User = session['LOGON.USERID'];
    //  ;
     // User=1;
     
     
    //alert(SendType);
  
   //   iMessage=TheMainobj.MSMMessageDetail.getValue();
   //   if (iMessage=="") { ExtTool.alert("","请填写短信内容!");return;}
   //   var SendList="";
   //   var Valuestr=iMessage+"^"+TheMainobj.MSMRemark.getValue()+"^"+User;
   
	//以下为消息发送
	 var Mobile="",iMessage="",flag="";
	 var row;
	 var rs=TheMainobj.GridPanelMS.getSelectionModel().getSelections();
   if (rs==""){
   	//ExtTool.alert("","发送失败,发送列表为空!");return;
   	};

   Ext.each(rs,function()
   {
       	  row=this;  
       	  Mobile=this.get("vMobilePhone");
       	  iMessage=this.get("vMessage");
       	 //alert(Mobile+iMessage);
      	  //单号发送
       	  if (Mobile!="" && isMoveTel(Mobile)) 
       	  {   
       	  		if (objGSM) 
	            { 
	             var ret=objGSM.SendMessage(Mobile,iMessage,"Send");
	             if ('0'==ret) 
	             {
	     
	                 flag="S";
		              row.set("vResult",'发送成功');
		           }	  
	             else
	             {
		             flag="F";
		             row.set("vResult",'发送失败:'+ret); 
	    
		            }
	            }
       	  	
       	  }
       	  else
       	  {
       	  	//alert("无效手机号码!请检查后在发送.");
       	  	 flag="F";
       	  	 row.set("vResult","无效手机号码!请检查后在发送."); 
       	  };
       	  //单号发送结束
       	
       	 TheMainobj.GridPanelMS.getView().refresh();  
       	 
       	 //根据发送情况为保存制作发送列表
          if (SendList!="") SendList=SendList+"#"; 
       	  SendList=SendList+row.get("OQEId")+"^"+Mobile+"^"+flag;
        //结束    
       
  }
   )//循环结束
//alert(SendList);
   //更新发送记录 N 和F 更新为 S F
   
      try{     
		     var ret = TheOBJ.CMessageSendUpdateStatus(Valuestr,SendList);
		    
		   }catch(err)
		   {
		   	  // ExtTool.alert("","短信发送状态更新错误: "+err.description);
		   	};	
		     //alert(ret);
		     if(ret<0) 
         {
		      // ExtTool.alert("提示","短信发送状态更新失败！");
		       return;
		     }else{
			     // ExtTool.alert("提示","短信发送状态更新成功！");
			   }
			   

}

function Update_click(status) {
	//alert('Update_click'+status);
	var SMSType="SM", //ShortMessage||SM-短消息
		user = session['LOGON.USERID'], 
		//status = "F", //Failed||F-发送失败
		ReceiveType = "", //I-个人

		iReceiveID = "", imobile = "", receivename = "", message="", 
		remark = ""
		;
	    
	var obj;
	
	obj=document.getElementById("ReceiveID");
	if (obj) { iReceiveID=obj.value; }
	
	obj=document.getElementById("ReceiveType");
	if (obj) { ReceiveType=obj.value; }

	obj=document.getElementById("ReceiveName");
	if (obj) { receivename=obj.value; }
	
	obj=document.getElementById("Mobile");
	if (obj) { imobile=obj.value; }
	
	obj=document.getElementById("Message");
	if (obj) { message=obj.value; }

	if (""==imobile) { return false; }
	var Ins=document.getElementById('GetSaveData');
	if (Ins) { var encmeth=Ins.value; } 
	else { var encmeth=''; };
	
	var Instring=trim(SMSType)			// 1 SM_Type	消息类型
				+"^"+trim(iReceiveID)	// 2 SM_ReceiveID	接收消息方
				+"^"+trim(imobile)		// 3 SM_Mobile	移动电话
				+"^"+trim(receivename)	// 4 SM_ReceiveName	接收人
				+"^"+trim(remark)		// 5 SM_Remark	备注
				+"^"+trim(ReceiveType)	// 6 SM_ReceiveType	接收方类型
				+"^"+trim(user)			// 7 SM_SendUser_DR	发送消息人
				+"^"+trim(status)		// 8 SM_Status	发送状态
				
				; 
	//alert(Instring+"^"+message)

	var flag=cspRunServerMethod(encmeth,'','',Instring,message);
	
		var Data=flag.split("^");
		flag=Data[0];
		
 	if ('0'==flag) { return true; }
	else{
		//alert("Insert error.ErrNo="+flag)
		//alert(t['02']+flag);
	}

}
   //====================================================================
}