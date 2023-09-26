/// DHCPESendMessage.js
/// 创建时间		2006.05.12
/// 创建人			xuwm
/// 主要功能		
/// 对应表		
/// 最后修改时间
/// 最后修改人	

var CurrentSel=0;
var objGSM;

function BodyLoadHandler() {
	
	var obj;

	obj=document.getElementById("btnSendMessage")
	if (obj) {
		obj.onclick=SendMessage_click;
		obj.disabled=true;
	}
	
	obj=document.getElementById('Message');
	if (obj) { obj.value="正在连接设备..."; }
	
	//obj=document.getElementById('GSM');
	//if (obj) { objGSM=obj; }
	//alert(obj);
	
	try {
    	objGSM=new ActiveXObject("DHCPEGSM.GSM");
	}
	catch (e) {
		alert("创建短信对象失败");
		return null;
	}
	
	if (objGSM) {
		var ret=objGSM.OpenGSM("Send");
		if (0!=ret) {
		alert("打开设备失败时发生错误:\n"+ret);
		obj=document.getElementById("btnSendMessage")
		if (obj) { obj.disabled=true; }
		
		obj=document.getElementById('Message');
		if (obj) { obj.value="设备初始化失败,不能发送短信"; }
		//return;
	  }else{
		obj=document.getElementById("btnSendMessage")
		if (obj) { obj.disabled=false; }
	  }
	  //objGSM=0;
	}	
	
	obj=document.getElementById('Message');
	if (obj) { obj.value=""; }
	
	iniForm();
	
	ShowCurRecord(1);
	
	
}
function BodyUnLoadHandler() {

	objGSM.CloseGSM();
	objGSM=nil;
}

function iniForm() {
	
	var obj;
	obj=document.getElementById('DataBox');
	if (obj && ""!=obj.value) { SetDataInfor(obj.value); }
	
	obj=document.getElementById('Mobile');
	if (obj && ""!=obj.value && objGSM) {
		obj=document.getElementById("btnSendMessage")
		if (obj) { obj.disabled=false; }	
	}

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
	var pattern=/^0{0,1}13|15|18[0-9]{9}$/;
	if(pattern.test(elem)){
		return true;
	}else{

	return false;
 	}
}
function SendMessage_click(){
	
	var  src=window.event.srcElement;
	if (src && src.disabled) { return false; }
	/*
		if (Update_click()) {
			alert("短信发送完毕");
			location.reload();
		}
		else { alert("短信发送失败"); }
	//return;
	*/
    var Mobile="",iMessage="";
	var obj;
	obj=document.getElementById("Mobile");
	if (obj && ""!=obj.value && isMoveTel(obj.value)) { 
		Mobile=obj.value; 
		
	}else {
		alert("无效手机号码!请检查后在发送.")
	}
	obj=document.getElementById("Message");
	if (obj) { iMessage=obj.value; }
	if (objGSM) { 
	  var ret=objGSM.SendMessage(Mobile,iMessage,"Send");
	  if ('0'==ret) {
		Update_click('S'); // Success||S 
		alert('发送成功');
		
	  }	  
	  else{
		alert('发送失败:'+ret); 
		Update_click('F');
		
	 }
	}
	location.reload(); 
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
// *******************************************************
//以便本页面的子页面有正确的传入参数
function ShowCurRecord(selectrow) {

	var SelRowObj;
	var obj;

	SelRowObj=document.getElementById('TRowId'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("RowId");
		if (obj) { obj.value=SelRowObj.value; }	
	}

}

function SelectRowHandler() {

	var eSrc=window.event.srcElement;

	var tForm="";
	
	var obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	
	var objtbl=document.getElementById(tForm);	
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
	if (selectrow==CurrentSel) {	    
		CurrentSel=0
		return;
	}

	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);

}

document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;
