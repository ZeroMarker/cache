// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
var objUser=document.getElementById('USERNAME');
var objPswd=document.getElementById('PASSWORD');
var objDept=document.getElementById('DEPARTMENT');
var objRound=document.getElementById('ROUND');
var btnLogon=document.getElementById('Logon');
var objDefaultDept=document.getElementById('ChangDefaultDept');
var objChangePsw = document.getElementById('CHANGEPASSWORD');
var objCHANGEADPASSWORD=document.getElementById("CHANGEADPASSWORD")
var txtUser="";        
var evtTimer;
var evtName;
var doneInit=0;
var focusat=null;
function BodyLoadHandler(){
	//need to call websys_setfocus to wait for elapse time to override setfocus called from scripts_gen
	if ((objUser)&&(objUser.value=='')) {
		websys_setfocus('USERNAME');
	} else if ((objPswd)&&(objPswd.value=='')) {
		websys_setfocus('PASSWORD');
	} else if ((objDept)&&(objDept.value=='')&&(!objDept.readOnly)&&(!objDept.disabled)) {
		websys_setfocus('DEPARTMENT');
	} else if ((objRound)&&(objRound.value=='')&&(!objRound.readOnly)&&(!objRound.disabled)) {
		websys_setfocus('ROUND');
	} else if (btnLogon) {
		websys_setfocus('Logon');
	}
	//add by wuqk 2010-11-19 for change department
	if (objUser) objUser.onfocus = userFocus;
	if (objUser) objUser.onblur = clearDepartment;
	if (objUser) objUser.onkeydown = UserName_KeyDown;
	if (objPswd) objPswd.onkeydown = EnterPassword;
	if (objPswd) objPswd.onfocus = PswdFocusHandler;
	if (objPswd) objPswd.onblur = PswdBlurHandler;
	txtUser = objUser.value;
	if (btnLogon) btnLogon.onclick = SetLogonClick;
	if (objChangePsw) objChangePsw.onclick = changePswClick;
	if (objCHANGEADPASSWORD) objCHANGEADPASSWORD.onclick = changeADPswClick;
	if (objDefaultDept) objDefaultDept.onclick=ChangeDefultDeptClick;
	if(document.attachEvent){
		document.attachEvent("onkeyup",function(e){		
			if(websys_getKey(e)==115){
				objDept.fireEvent("onclick");
			}
		})
	}
	//输入层调整位置
	var dSSUserLogonObj = document.getElementById("dSSUserLogon");
	if (dSSUserLogonObj){
		if(document.body.offsetHeight<668){
			dSSUserLogonObj.style.marginTop = (668 - 415)/2;
		}else{
			dSSUserLogonObj.style.marginTop = (document.body.offsetHeight - 415)/2;
		}
	 	dSSUserLogonObj.style.marginRight = (document.body.offsetWidth/2 - 310-130);
	 	dSSUserLogonObj.style.display = "inline";
	 	//alert(dSSUserLogonObj.style.marginTop+""+dSSUserLogonObj.style.marginRight);
	}
}
function UserName_KeyDown(){
	if (window.event.keyCode==13){
		var objUser=document.getElementById('USERNAME');
		var objPswd=document.getElementById('PASSWORD');			
		if ((objUser.value!="")&&(objPswd)) objPswd.focus();		
	}
}
function EnterPassword(evt) {
  var k = websys_getKey(evt);
 
  var tabkeypressed = (k==9)||(k==13);
  if ((tabkeypressed)&&(objUser)&&(objUser.value!="")&&(objPswd)&&(objPswd.value!="")) {
	//if ((objDept)&&(objDept.value!=''))
		btnLogon.onclick();
	//may want to change department field
	//if ((objDept)&&((objDept.disabled)||(objDept.readOnly))) btnLogon.onclick(); //Logon_click();
  }
}
function PswdFocusHandler(){
	objPswd.className = "logininputf";
}
//2011-11-26
function PswdBlurHandler() {
	objPswd.className = "logininput";
	var tmpObj = document.getElementById("cPASSWORD");
	if (objPswd.value!=""){
		tmpObj.className = "loginlabel loginlabel-passwordb";
	}else{
		tmpObj.className = "loginlabel loginlabel-password";
	}
	if (objUser&&objPswd){
		if ((objUser.value!="")&&(objPswd.value!="")){
			btnLogon.onclick();
		}
	}
}
function DepartmentLookUp(str) {
 	var lu = str.split("^");
	var obj=document.getElementById('SSUSERGROUPDESC');
	if (obj) obj.value = lu[1];
	var obj=document.getElementById('Hospital');
	if (obj) obj.value = lu[2];
	var obj = document.getElementById("DEPARTMENTAlias");
	if (obj&&lu.length>3) obj.value = lu[3];
	setTimeout(function (){$('Logon').focus()},100);	
}
function Validate() {
	if ((objUser.value=='')||(objPswd.value=='') ) {
		alert('Please enter both:\nUsername\nPassword');
		if (f.USERNAME.value=='') {
			f.USERNAME.focus();
		} else {
			f.PASSWORD.focus();
		}
		event.cancelBubble;
		event.returnValue=false;
	}
}
function userFocus(){
	objUser.className = "logininputf";
	txtUser = objUser.value;
}
function SetLogonClick(evt) {
	islogon=1;
	var AuthRet , authErrCode ,authErrInfo , myflag;
	//增加密码加密程序 2014-10-10 add by wanghc 
	var password = document.getElementById("PASSWORD").value;
	password = password.replace(/\t|\n|\s|\f|\r|\v/g,"");
	if (password!="" && password.length!==32){ //加过密不再加
		document.getElementById("PASSWORD").value = hex_md5(dhc_cacheEncrypt(password));
	}
	myflag = Logon_click();
	return myflag;
}
function changePswClick () {
	if(objChangePsw && !objChangePsw.disabled) ChangePassword();
}
function changeADPswClick(){
	if(objCHANGEADPASSWORD && !objCHANGEADPASSWORD.disabled) ChangeADPassword();
}
function ChangeDefultDeptClick()
{
		if(objDefaultDept && !objDefaultDept.disabled) ChangeDefultDept();
}
function clearDepartment() {
	objUser.className = "logininput";
	var tmpObj = document.getElementById("cUSERNAME");
	if (objUser.value!=""){
		tmpObj.className = "loginlabel loginlabel-usernameb";
	}else{
		tmpObj.className = "loginlabel loginlabel-username";
	}
	if (txtUser != objUser.value){
		var obj=document.getElementById('SSUSERGROUPDESC');
		if (obj) obj.value = "";
		var obj=document.getElementById('Hospital');
		if (obj) obj.value = "";
		objDept.value = "";
		txtUser = objUser.value;
	}
}
//------- from scripts_gen-----
function Logon_click() {
	if (evtTimer) {
		setTimeout('Logon_click();',200)
	} else {
		websys_setfocus('Logon');
		var frm=document.fSSUserLogon;
		websys_isInUpdate=true;
		if (fSSUserLogon_submit()) {
			if ((objDept)&&(objDept.value!='')) {	
				var objDeptAlias = document.getElementById("DEPARTMENTAlias");
				var deptDesc = objDept.value;		
				if (objDeptAlias){
					var deptDesc = objDeptAlias.value+"-"+deptDesc;
				}		
				if( EnableCALogon && (!dhcsys_calogon(deptDesc).IsSucc)){
					return false;
				}
			}			
			var obj=document.getElementById('Logon');
			if (obj) {obj.disabled=true;obj.onclick=function() {return false};}			
			frm.TEVENT.value='d1473iLogon';
			var nowDate = new Date();
			var nowTime = nowDate.getHours()+":"+nowDate.getMinutes(); //到秒没意义
			nowDate = nowDate.getFullYear()+"-"+(nowDate.getMonth()+1)+"-"+nowDate.getDate();
			var o = document.getElementById("ClientDate");
			if (o) o.value = nowDate;
			var o = document.getElementById("ClientTime");
			if (o) o.value = nowTime;
			frm.submit();
		}
		return false;
	}
}

try {
	var obj=document.getElementById('Logon');
	if (obj) obj.onclick=Logon_click;
} catch(e) { alert(e.number + ' ' + e.description) };

function fSSUserLogon_submit() {
  var msg='';
  if (msg!='') {
    alert(msg);
    websys_setfocus(focusat.name);
    return false;
  } else {
    return true;
  }
}

//----lookup component
var DEPARTMENTzLookupGrid;
function DEPARTMENT_lookuphandler(e) {
	
	if (evtName=='DEPARTMENT') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var obj = document.getElementById('DEPARTMENT');
	if (obj && obj.className !== 'logininput-dep') return ;
	var type = websys_getType(e);
	var key = websys_getKey(e);
	
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		var dept = obj.value;
		var depAliObj = document.getElementById('DEPARTMENTAlias');
		if(depAliObj){
			dept = depAliObj.value+"-"+dept;
		}
		var url='websys.lookup.csp';
		url += '?ID=d1473iDEPARTMENT&CONTEXT=Kweb.SSUserOtherLogonLoc:LookUpSelectedUserByUHD';
		url += "&TLUJSF=DepartmentLookUp&resizeColumn=0";
		var obj=document.getElementById('USERNAME');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		//var obj=document.getElementById('Hospital');
		//if (obj) url += "&P2=" + websys_escape(obj.value);
		url += "&P2=&P3=";
		websys_lu(url,1,{height:330,width:450});
		//websys_lu("websys.lookup.csp?ID=d1iDEPARTMENT&CONTEXT=Kweb.SSUserOtherLogonLoc:LookUpSelectedUserByUHD&TLUJSF=DepartmentLookUp&P1="+$V("USERNAME")+"&P2="+$V("Hospital")+"&P3=",1);
		/*if(DEPARTMENTzLookupGrid&&DEPARTMENTzLookupGrid.store) {
			DEPARTMENTzLookupGrid.searchAndShow();
		}else {
			DEPARTMENTzLookupGrid = new dhcc.icare.Lookup({
				lookupListComponetId: 1872,
				lookupPage: "logon",
				lookupName: 'DEPARTMENT',
				listClassName: 'web.SSUserOtherLogonLoc',	//'web.SSUserOtherLogonLoc', ByUHD
				listQueryName: 'LookUpSelectedUserByUHD',
				displayCM:["Loc","Group","HOSPDesc"],
				listProperties: [function (){return $V("EmployeeNo")=="" ? ($V("USERNAME")):($V('EmployeeNo'));},''],  // EmployeeNo USERNAME ,function(){return $V("DEPARTMENT")}
				listeners:{"selectRow":DepartmentLookUp}
				//resizeColumn:true,
				//pageSize: 10
			});
		}*/
		return websys_cancel();
	}
}
var obj=document.getElementById('DEPARTMENT');
if (obj) {
	obj.onkeydown=DEPARTMENT_lookuphandler;
	obj.onclick=DEPARTMENT_lookuphandler;
	obj.onmouseover = function(){
      this.style.backgroundPosition = "0px ";
	}
    obj.onmouseout = function(){
      this.style.backgroundPosition = "0px 0px";
    }
}
function DEPARTMENT_lookupsel(value) {
	try {
		var obj=document.getElementById('DEPARTMENT');
		if (obj) {
  			obj.value=unescape(value);
			//if (obj.readOnly) {obj.className='clsReadOnly'} else {obj.className=''}
			if (doneInit) websys_nexttab('3',obj.form);
		}
	} catch(e) {};
}
function DEPARTMENT_changehandler(encmeth) {
	evtName='DEPARTMENT';
	if (doneInit) { evtTimer=window.setTimeout("DEPARTMENT_changehandlerX('"+encmeth+"');",200); }
	else { DEPARTMENT_changehandlerX(encmeth); evtTimer=""; }
}
function DEPARTMENT_changehandlerX(encmeth) {
	if (evtTimer) {
		window.clearTimeout(evtTimer);
		evtName='';
		evtTimer='';
	}
	var obj=document.getElementById('DEPARTMENT');
	//if (obj.value!='') {
		var tmp=document.getElementById('USERNAME');
		if (tmp) {var p1=tmp.value } else {var p1=''};
		var p2='';
		var tmp=document.getElementById('DEPARTMENT');
		if (tmp) {var p3=tmp.value } else {var p3=''};
		if (cspHttpServerMethod(encmeth,'DEPARTMENT_lookupsel','DepartmentLookUp',p1,p2,p3)=='0') {
			//obj.className = obj.className+' clsInvalid';
			websys_setfocus('DEPARTMENT');
			return websys_cancel();
		}
	//}
	//if (obj.readOnly) {obj.className='clsReadOnly'} else {obj.className=''}
}
document.body.onload=BodyLoadHandler;