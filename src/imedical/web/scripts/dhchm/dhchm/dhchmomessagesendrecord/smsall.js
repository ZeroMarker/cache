
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
	if (obj) { obj.value="���������豸..."; }
	*/
	
	//obj=document.getElementById('GSM');
	//if (obj) { objGSM=obj; }
	//alert(obj);
	
	try {
    	objGSM=new ActiveXObject("DHCPEGSM.GSM");
	}
	catch (e) {
		ExtTool.alert("","�������Ŷ���ʧ��");
		return null;
	}
	
	if (objGSM) {
		var ret=objGSM.OpenGSM("Send");
		if (0!=ret) {
		ExtTool.alert("","���豸ʧ��ʱ��������:\n"+ret);
		return null;
		/*
		obj=document.getElementById("btnSendMessage")
		if (obj) { obj.disabled=true; }
		
		obj=document.getElementById('Message');
		if (obj) { obj.value="�豸��ʼ��ʧ��,���ܷ��Ͷ���"; }
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
///�ж��ƶ��绰
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
	//Ϊ����׼���������ݴ�
	var TheOBJ = ExtTool.StaticServerObject("web.DHCHM.MessageSend");
	var iMessage="";
	var SendList="";Valuestr="";
    //  var User = session['LOGON.USERID'];
    //  ;
     // User=1;
     
     
    //alert(SendType);
  
   //   iMessage=TheMainobj.MSMMessageDetail.getValue();
   //   if (iMessage=="") { ExtTool.alert("","����д��������!");return;}
   //   var SendList="";
   //   var Valuestr=iMessage+"^"+TheMainobj.MSMRemark.getValue()+"^"+User;
   
	//����Ϊ��Ϣ����
	 var Mobile="",iMessage="",flag="";
	 var row;
	 var rs=TheMainobj.GridPanelMS.getSelectionModel().getSelections();
   if (rs==""){
   	//ExtTool.alert("","����ʧ��,�����б�Ϊ��!");return;
   	};

   Ext.each(rs,function()
   {
       	  row=this;  
       	  Mobile=this.get("vMobilePhone");
       	  iMessage=this.get("vMessage");
       	 //alert(Mobile+iMessage);
      	  //���ŷ���
       	  if (Mobile!="" && isMoveTel(Mobile)) 
       	  {   
       	  		if (objGSM) 
	            { 
	             var ret=objGSM.SendMessage(Mobile,iMessage,"Send");
	             if ('0'==ret) 
	             {
	     
	                 flag="S";
		              row.set("vResult",'���ͳɹ�');
		           }	  
	             else
	             {
		             flag="F";
		             row.set("vResult",'����ʧ��:'+ret); 
	    
		            }
	            }
       	  	
       	  }
       	  else
       	  {
       	  	//alert("��Ч�ֻ�����!������ڷ���.");
       	  	 flag="F";
       	  	 row.set("vResult","��Ч�ֻ�����!������ڷ���."); 
       	  };
       	  //���ŷ��ͽ���
       	
       	 TheMainobj.GridPanelMS.getView().refresh();  
       	 
       	 //���ݷ������Ϊ�������������б�
          if (SendList!="") SendList=SendList+"#"; 
       	  SendList=SendList+row.get("OQEId")+"^"+Mobile+"^"+flag;
        //����    
       
  }
   )//ѭ������
//alert(SendList);
   //���·��ͼ�¼ N ��F ����Ϊ S F
   
      try{     
		     var ret = TheOBJ.CMessageSendUpdateStatus(Valuestr,SendList);
		    
		   }catch(err)
		   {
		   	  // ExtTool.alert("","���ŷ���״̬���´���: "+err.description);
		   	};	
		     //alert(ret);
		     if(ret<0) 
         {
		      // ExtTool.alert("��ʾ","���ŷ���״̬����ʧ�ܣ�");
		       return;
		     }else{
			     // ExtTool.alert("��ʾ","���ŷ���״̬���³ɹ���");
			   }
			   

}

function Update_click(status) {
	//alert('Update_click'+status);
	var SMSType="SM", //ShortMessage||SM-����Ϣ
		user = session['LOGON.USERID'], 
		//status = "F", //Failed||F-����ʧ��
		ReceiveType = "", //I-����

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
	
	var Instring=trim(SMSType)			// 1 SM_Type	��Ϣ����
				+"^"+trim(iReceiveID)	// 2 SM_ReceiveID	������Ϣ��
				+"^"+trim(imobile)		// 3 SM_Mobile	�ƶ��绰
				+"^"+trim(receivename)	// 4 SM_ReceiveName	������
				+"^"+trim(remark)		// 5 SM_Remark	��ע
				+"^"+trim(ReceiveType)	// 6 SM_ReceiveType	���շ�����
				+"^"+trim(user)			// 7 SM_SendUser_DR	������Ϣ��
				+"^"+trim(status)		// 8 SM_Status	����״̬
				
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