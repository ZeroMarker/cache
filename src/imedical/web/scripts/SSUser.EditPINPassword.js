// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
var timerenabled=true;
var AlertMessageObj = "";
var PwdIsContainWordAndNum = "N";  //Ĭ�ϲ�һ��Ҫ������ĸ������
function StayOnTop() {
	this.focus();
	if (timerenabled) {
		window.setTimeout(StayOnTop,500);
	}
}
function DisableOnTop() {
	timerenabled=false;
}
//refocusing doesn't seem to work correctly to allow input into field
//focus on first time load only
function ValidateUpdate(e) {
	var msg="";
	if (!fSSUser_EditPINPassword_submit()) return;
	var objNewPwd = document.getElementById('SSUSRPassword');
	var objConfirmPwd = document.getElementById('ConfirmPassword');
	var win = window.opener;
	if (win) {
		var objPwd = win.document.getElementById('PASSWORD');
		var objUsr = win.document.getElementById('USERNAME');
	}
	else var objPwd = null;
	if (objNewPwd) {
		if (!ValidPassword(objNewPwd.value)) return false;
		//msg += ValidateMinimumLength(objNewPwd.value);
		//make sure confirm password is the same as new password
		if ((objConfirmPwd) && (objNewPwd.value!=objConfirmPwd.value))  {
			msg+="\'" + t['ConfirmPassword'] + "\' " + t['InvalidConfirm'] + " \'" + t['SSUSRPassword'] + "\'\n";
			objConfirmPwd.value = "";
		}
		/* GR5/4/02 this needed to be commented as all checking of past passwords will now be
		done as part of the beforesave as they need to confirm the new password is different to ALL 
		previous passwords, not just the last.  this cant be done in JS.
		if ((objPwd) && (objNewPwd.value==objPwd.value)) {
			msg+="\'" + t['SSUSRPassword'] + "\' need to be different from original\n";
		}
		*/
		//KK:25/Jan/2002 LogNo:22396 Check if Username contains password and viceversa
		if ((objUsr)&&(objUsr.value!="")&&(objNewPwd.value!="")) {
			var TUsr=objUsr.value;
			var TPwd=objNewPwd.value;
			TUsr=TUsr.toLowerCase();
			TPwd=TPwd.toLowerCase();
			var inThere1=TUsr.indexOf(TPwd);
			var inThere2=TPwd.indexOf(TUsr);
			//alert(TUsr + "  -  " + TPwd);
			//alert(inThere1 + " ^ " + inThere2);
			if ((inThere1>=0) || (inThere2>=0)) msg+= "\'" + t['SSUSRPassword'] + "\' " + t['DifferentPassword'] + "\n";
		}
		if (msg != "") {
			alert(msg);
			return false;
		}
	}
	//����������ܳ��� 2014-10-11 add by wanghc 
	var password = objNewPwd.value;
	var repassword = objConfirmPwd.value;
	password = password.replace(/\t|\n|\s|\f|\r|\v/g,"");
	repassword = repassword.replace(/\t|\n|\s|\f|\r|\v/g,"");
	objNewPwd.value = dhc_cacheEncrypt(password);
	objConfirmPwd.value = dhc_cacheEncrypt(repassword);
	//alert(objNewPwd.value)
	//alert(password);
	//copy new password to original screen password to enable logon    //ֻ�޸�pin���룬������������
	//if ((objPwd) && (objNewPwd)) {
	//	objPwd.value = objNewPwd.value;
	//}
	return update1_click();
}
function PasswordChangeHandler(e) {
	var msg="";
	var eSrc=websys_getSrcElement(e);
	if ((eSrc)&&(eSrc.value!="")) {
		ValidPassword(eSrc.value);
	}	
}
///���� ǿ���� ��֤
function passwordKeyUpHandler(e){
	var eSrc=websys_getSrcElement(e);
	if ((eSrc)&&(eSrc.value!="")) {
		pwStrength(eSrc.value);
	}
}
//
function showPasswordMsg(msg){
	if (AlertMessageObj){
		 AlertMessageObj.innerHTML = msg;
	}
}
//���Ȳ���С��6,ͬʱ������ĸ������.
function ValidPassword(data) {
	var minlength = 0,flag = true;
	var obj = document.getElementById('SMCFPasswordMinLength');
	if (obj) minlength=obj.value;
	var pwdvalue=document.getElementById("SSUSRPassword").value;
 	if(pwdvalue==""){
		showPasswordMsg("<font color='red'>����Ϊ��</font>");
   		flag = false;
 	}
 	if ((pwdvalue!="")&&(pwdvalue.length<minlength)){
		showPasswordMsg("<font color='red'>���볤�Ȳ���С��"+minlength+"</font>");
		flag=false;
 	}
	if (PwdIsContainWordAndNum=="Y"){
	 	if (!(/[0-9]+/.test(data))){
		 	showPasswordMsg("<font color='red'>������Ҫ��������!</font>");
			flag=false;
	 	}
	 	if (!/[a-zA-Z]/.test(data)){
		 	showPasswordMsg("<font color='red'>������Ҫ������ĸ!</font>");
			flag=false;
	 	}
		var pattern = new RegExp("[`~!@#$^&*()=|{}':;',\\[\\].<>����/?~��@#������&*��������|{}��������������'�������� ]");
	 	if (!pattern.test(data))
		{
	��������showPasswordMsg("<font color='red'>������Ҫ��������!</font>");
			flag=false;
	����}
 	}
   	if (flag) {
	   	showPasswordMsg("<font color='#33CC00'>������д��ȷ!</font>");
	   	enableUpdate();
   		return flag;
   	}
 	return flag;
}
//����ǿ��
//�ж��������������
function CharMode(iN) {
	if (iN >= 48 && iN <= 57) //����
	return 1;
	if (iN >= 65 && iN <= 90) //��д
	return 2;
	if (iN >= 97 && iN <= 122) //Сд
	return 4;
	else return 8;
} 
//bitTotal����
//��������ģʽ
function bitTotal(num) {
	modes = 0;
	for (i = 0; i < 4; i++) {
		if (num & 1) modes++;
		num >>>= 1;
	}
	return modes;
} //����ǿ�ȼ���
function checkStrong(sPW) {
	if (sPW.length <= 4) return 0; //����̫��
	Modes = 0;
	for (i = 0; i < sPW.length; i++) { //����ģʽ
		Modes |= CharMode(sPW.charCodeAt(i));
	}
	return bitTotal(Modes);
} 
//��ʾ��ɫ
function pwStrength(pwd) {
	O_color = "#eeeeee";
	L_color = "#FF0000";
	M_color = "#FF9900";
	H_color = "#33CC00";
	if (pwd == null || pwd == '') {
		Lcolor = Mcolor = Hcolor = O_color;
	} else {
		S_level = checkStrong(pwd);
		switch (S_level) {
		case 0:
			Lcolor = Mcolor = Hcolor = O_color;
		case 1:
			Lcolor = L_color;
			Mcolor = Hcolor = O_color;
			break;
		case 2:
			Lcolor = Mcolor = M_color;
			Hcolor = O_color;
			break;
		default:
			Lcolor = Mcolor = Hcolor = H_color;
		}
	}
	document.getElementById("strength_L").style.background = Lcolor;
	document.getElementById("strength_M").style.background = Mcolor;
	document.getElementById("strength_H").style.background = Hcolor;
	return;
}
function disableUpdate(){
	var obj=document.getElementById('update1');
	if (obj) {
		obj.disabled = true;
		obj.onclick = function (){return false;};
	}
}
function enableUpdate(){
	var obj=document.getElementById('update1');
	if (obj) {
		obj.disabled = false;
		obj.onclick = ValidateUpdate;
	}
}
function ChangeBefore(){
	document.getElementById("SSUSRPassword").disabled=true;
	document.getElementById("ConfirmPassword").disabled=true;
	
	document.getElementById("OldPINPassword").onkeyup=function(){
		var OldPinServer=document.getElementById("OldPinServer").value;
		var OldPinInput=document.getElementById("OldPINPassword").value;
		var OldPinInput2=dhc_cacheEncrypt(OldPinInput);
		//console.log(OldPinServer+"*"+OldPinInput2);
		if(OldPinServer!=OldPinInput2){
			showPasswordMsg("<font color='red'>��PIN�������</font>");
			document.getElementById("SSUSRPassword").disabled=true;
			document.getElementById("ConfirmPassword").disabled=true;
			this.focus();
		}else{
			document.getElementById("SSUSRPassword").disabled=false;
			document.getElementById("ConfirmPassword").disabled=false;
			document.getElementById("SSUSRPassword").focus();
			showPasswordMsg("<font color='#33CC00'>����������</font>");
		}
	};
}
function bodyOnloadHandler(){
	ChangeBefore();    //�޸�֮ǰ����֤�������Ƿ���ȷ
	
	AlertMessageObj = document.getElementById("AlertMessage");
	var PwdIsContainWordAndNumObj = document.getElementById("PwdContainWordAndNum");
	if (PwdIsContainWordAndNumObj){
		PwdIsContainWordAndNum = PwdIsContainWordAndNumObj.value;
	}
	disableUpdate(); 
	var obj=document.getElementById('SSUSRPassword');
	if (obj) {
		obj.onblur = PasswordChangeHandler;
		obj.onchange = PasswordChangeHandler;
		obj.onkeyup = passwordKeyUpHandler;
	}
	this.focus();
	var obj = document.getElementById('SMCFPasswordMinLength');
	var msg = ""
	if (obj) msg = "���볤�Ȳ���С��"+obj.value;
	if (PwdIsContainWordAndNum=="Y") msg += ",ͬʱ������������ĸ."
	showPasswordMsg("<font color='#33CC00'>������������</font>");
}

//CF_SM��SMCF_PasswordMinLength
document.body.onload = bodyOnloadHandler;

document.body.onunload = function(){
	// ����� wanghc 2015-08-10 һ�û������޸���������,��X�˳�,��һ������ȥ�޸�����ʱ����ʾ�û�����
	// window.open("websys.close.csp","_self");
	return;
}
