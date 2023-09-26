/// DHCPESendMessage.js
/// ����ʱ��		2006.05.12
/// ������			xuwm
/// ��Ҫ����		
/// ��Ӧ��		
/// ����޸�ʱ��
/// ����޸���	

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
	if (obj) { obj.value="���������豸..."; }
	
	//obj=document.getElementById('GSM');
	//if (obj) { objGSM=obj; }
	//alert(obj);
	
	try {
    	objGSM=new ActiveXObject("DHCPEGSM.GSM");
	}
	catch (e) {
		alert("�������Ŷ���ʧ��");
		return null;
	}
	
	if (objGSM) {
		var ret=objGSM.OpenGSM("Send");
		if (0!=ret) {
		alert("���豸ʧ��ʱ��������:\n"+ret);
		obj=document.getElementById("btnSendMessage")
		if (obj) { obj.disabled=true; }
		
		obj=document.getElementById('Message');
		if (obj) { obj.value="�豸��ʼ��ʧ��,���ܷ��Ͷ���"; }
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
///�ж��ƶ��绰
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
			alert("���ŷ������");
			location.reload();
		}
		else { alert("���ŷ���ʧ��"); }
	//return;
	*/
    var Mobile="",iMessage="";
	var obj;
	obj=document.getElementById("Mobile");
	if (obj && ""!=obj.value && isMoveTel(obj.value)) { 
		Mobile=obj.value; 
		
	}else {
		alert("��Ч�ֻ�����!������ڷ���.")
	}
	obj=document.getElementById("Message");
	if (obj) { iMessage=obj.value; }
	if (objGSM) { 
	  var ret=objGSM.SendMessage(Mobile,iMessage,"Send");
	  if ('0'==ret) {
		Update_click('S'); // Success||S 
		alert('���ͳɹ�');
		
	  }	  
	  else{
		alert('����ʧ��:'+ret); 
		Update_click('F');
		
	 }
	}
	location.reload(); 
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
// *******************************************************
//�Ա㱾ҳ�����ҳ������ȷ�Ĵ������
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
