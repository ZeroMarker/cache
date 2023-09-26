// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
var objUser=document.getElementById('USERNAME');
var objPswd=document.getElementById('PASSWORD');
var objDept=document.getElementById('DEPARTMENT');
var objRound=document.getElementById('ROUND');
var btnLogon=document.getElementById('Logon');
var objDefaultDept=document.getElementById('ChangDefaultDept');
var objChangePsw = document.getElementById('CHANGEPASSWORD');
var objCHANGEADPASSWORD=document.getElementById("CHANGEADPASSWORD")
var objChangePinPsw = document.getElementById("ChangePINPassword");
var txtUser="";        
var evtTimer;
var evtName;
var doneInit=0;
var focusat=null;
function BodyLoadHandler(){
	//need to call websys_setfocus to wait for elapse time to override setfocus called from scripts_gen
	if ((objUser)&&(objUser.value=='')) {
		$('#USERNAME').focus();
	} else if ((objPswd)&&(objPswd.value=='')) {
		$('#PASSWORD').focus();
	} else if ((objDept)&&(objDept.value=='')&&(!objDept.readOnly)&&(!objDept.disabled)) {
		$('#DEPARTMENT').focus();
	} else if ((objRound)&&(objRound.value=='')&&(!objRound.readOnly)&&(!objRound.disabled)) {
		$('#ROUND').focus();
	} else if (btnLogon) {
		$('#Logon').focus();
	}
	if (objUser) objUser.onfocus = userFocus;
	if (objUser) objUser.onblur = clearDepartment;
	if (objUser) objUser.onkeydown = UserName_KeyDown;
	
	if (objPswd) objPswd.onkeydown = EnterPassword;
	if (objPswd) objPswd.onblur = PswdBlurHandler;
	if (objDept){
		DEPARTMENT_HISUILookUp();
		//objDept.onkeydown=DEPARTMENT_lookuphandler;
		//objDept.onclick=DEPARTMENT_lookuphandler;
		/*objDept.onmouseover = function(){
	      this.style.backgroundPosition = "0px ";
		}
	    objDept.onmouseout = function(){
	      this.style.backgroundPosition = "0px 0px";
	    }*/
	}
	txtUser = objUser.value;
	if (btnLogon) btnLogon.onclick = SetLogonClick;
	if (objChangePsw) objChangePsw.onclick = changePswClick;
	if (objChangePinPsw) objChangePinPsw.onclick = changePinPswClick;
	if (objDefaultDept) objDefaultDept.onclick=ChangeDefultDeptClick;
	$(document).on("keyup",function(e){		
		if(e.keyCode==115){
			objDept.fireEvent("onclick");
		}
	})
	$(window).on("resize",function(e){
		ipInfoFlex();
	});
	if ("undefined"==typeof cspFindXMLHttp){
		$(".tcq").html("<font color='red' size='3pt'>发现IIS缺少csp虚拟目录,请修复安装库.</font>");
		disableDep();
	};
	ipInfoFlex();
	if(typeof tipPasswordChange!="undefined"&&tipPasswordChange=="1"){
		
		if ($.messager){
			$.messager.confirm("提示","密码复杂度不满足系统要求，是否立即修改？",function(r){
				if (r){ChangePassword();}
			});
		}else{
			if(confirm("密码复杂度不满足系统要求，是否立即修改？")){
				ChangePassword();
			}
		}
	}
	//"undefined"!=typeof isIECore && !isIECore	
	if("undefined"!=typeof EnableLocalWeb && EnableLocalWeb==1){
		var json = CMgr.getVersion(); //mgr.invk();
		if ("string"==typeof json){
			json = JSON.parse(json);
		}
		if (json.status==404){
			installWebsysServer();
			return ;
		}
		if (json.status==200){
			if(json.rtn<CMgr.data[1]._version){
				installWebsysServer("upgrade");
			}
		}
			
		setIPMac();
	}
	setPageTitle();
}
function installWebsysServer(type){
	var html = "";
	if (type=='upgrade'){
		html = '<h3 style="color:#000000;width:290px;margin:0 auto;">客户端基础环境发现新版本</h3>'+
		'<lu><li><div>1. 客户端基础环境需要更新，请点击按钮下载最新安装包！<div>'
		+'<div><a href="../addins/plugin/WebsysServerSetup.msi" style="color:#fff;background-color: #3276b1;border-color: #285e8e;border-radius: 5px;padding: 0 25px;margin:5px 20px;width: 110px;height: 35px;line-height: 35px;display: block;">下载安装</a></div></li>'
		+'<li><div>2. 任务栏->医为客户端管理->右键->点击[退出]。</div>'
		+'<img style="height:150px;margin-left:20px;" src="../images/websys/install_websysserver_2.png"/></img>'
		+'</li>'
		+'<li><div>3. 安装已下载好的msi安装包</div></li>';
		+'</lu>';
	}else{
		html = '<h3 style="color:#000000;width:290px;margin:0 auto;">安装客户端基础环境</h3>'
		+'<lu><li><div>1. 客户端基础环境需要安装，请点击按钮下载最新安装包！<div>'
		+'<div><a href="../addins/plugin/WebsysServerSetup.msi" style="color:#fff;background-color: #3276b1;border-color: #285e8e;border-radius: 5px;padding: 0 25px;margin:5px 20px;width: 110px;height: 35px;line-height: 35px;display: block;">下载安装</a></div></li>'
		+'<li><div>2. 安装已下载好的msi安装包。</div>'
		+'</li>'
		+'<li><div>3. 安装完成后，重新进入登录界面</div></li>';
		+'</lu>';
	}
	showModal("#modalWin","",{content:html,height:'400',width:'500'}); 
}

function setIPMac(){
	var rtn = getClientIP();
	if (rtn==404){
		installWebsysServer();
		return ;
	}
	if (rtn){
		var arr = rtn.split("^");
		document.getElementById("IPAddress").value= arr[0];
 		document.getElementById("DNSHostName").value= arr[1];
 		document.getElementById("MACAddr").value=arr[2];
 		$("#localipdiv").html(arr[0]);
 		$("#localmacdiv").html(arr[2]);
	}
}
function ipInfoFlex(){
	var box = $(".loginboxP_cq");
	if (box.length>0){
		var h = box.outerHeight();
		var o = box.offset();
		var ipTop = o.top+h+15;
		$(".ipInfo").css({top:ipTop,left:o.left}).animate({opacity:0.5},2000);
	}
}
function UserName_KeyDown(){
	var keyCode = window.event.keyCode;
	var objUser=document.getElementById('USERNAME');
	var objPswd=document.getElementById('PASSWORD');
	if (keyCode==13){		
		if ((objUser.value!="")&&(objPswd)) objPswd.focus();		
	}
	if((keyCode==8)|| (keyCode>=48&&keyCode<=57)||(keyCode>=65 && keyCode<=90)||(keyCode>=97 && keyCode<=122)){
		objDept.value = "";
		objPswd.value = "";
		$(".usernameinfo").html("");
	}
}
function EnterPassword(evt) {
  var k = websys_getKey(evt);
  var tabkeypressed = (k==9)||(k==13);
  if ((tabkeypressed)&&(objUser)&&(objUser.value!="")&&(objPswd)&&(objPswd.value!="")) {
		btnLogon.onclick();
  }
}

function PswdBlurHandler() {
	if (objUser&&objPswd){
		if ((objUser.value!="")&&(objPswd.value!="")){
			btnLogon.onclick();
		}
	}
}
function DepartmentLookUp(str) {
 	var lu = str.split("^");
	if (objDept) objDept.value = lu[0];
	var obj=document.getElementById('SSUSERGROUPDESC');
	if (obj) obj.value = lu[1];
	var obj=document.getElementById('Hospital');
	if (obj) obj.value = lu[2];
	var obj = document.getElementById("DEPARTMENTAlias");
	if (obj&&lu.length>3) obj.value = lu[3];
	setTimeout(function (){$('#Logon').focus()},100);	
}
function Validate() {
	if ((objUser.value=='')||(objPswd.value=='') ) {
		if (objUser.value=='') {
			objUser.focus();
		} else {
			objPswd.focus();
		}
		event.cancelBubble;
		event.returnValue=false;
	}
}
function userFocus(){
	txtUser = objUser.value;
}
///密码复杂度
function calPwdComplexity(password){
	var pwdcpl=document.getElementById("PwdComplexity");
	//1.不满足 修改密码 成功后 新密码直接填入密码框 32位不重新计算复杂度 直接提交还是不满足 所以前后密码不一致要改为满足
	if (password!=PwdLastPwd) pwdcpl.value="valid";  //防止修改密码后 直接登录 提示不满足
	//2. SetLogonClick方法有触发两次 此方法也会是两次  第一次密码为1 不满足要求  加密后变为32位 第二次进此方法 上面判断为真 将复杂度记为满足 此时提交就自动过去了
	PwdLastPwd=hex_md5(dhc_cacheEncrypt(password));  //防止二次触发导致的跳过
	if (password!="" && password.length!==32){
		if (PwdMinLength>=0 && password.length<PwdMinLength){   //长度不够
			pwdcpl.value="invalid";
			return;
		}
		if(PwdContainWordAndNum=="Y"){
			if (!(/[0-9]+/.test(password))){   //没有数字
				pwdcpl.value="invalid";
				return;
			}
			if (!/[a-zA-Z]/.test(password)){  //没字母
				pwdcpl.value="invalid";
				return;
			}
		}
		pwdcpl.value="valid";
		return;	
	}
}
function SetLogonClick(evt) {
	islogon=1;
	var AuthRet , authErrCode ,authErrInfo , myflag;
	//增加密码加密程序 2014-10-10 add by wanghc 
	var password = document.getElementById("PASSWORD").value;
	password = password.replace(/\t|\n|\s|\f|\r|\v/g,"");
	calPwdComplexity(password); //计算复杂度 改变PwdComplexity元素的值
	if (password!="" && password.length!==32){ //加过密不再加
		document.getElementById("PASSWORD").value = hex_md5(dhc_cacheEncrypt(password));
	}
	myflag = Logon_click();
	return myflag;
}
function changePswClick () {
	if(objChangePsw && !objChangePsw.disabled) ChangePassword();
}
function changePinPswClick () {
	if(objChangePinPsw && !objChangePinPsw.disabled) ChangePinPassword();
}
function ChangeDefultDeptClick(){
	if(objDefaultDept && !objDefaultDept.disabled) ChangeDefultDept();
}
function clearDepartment() {
	if (txtUser != objUser.value){
		var obj=document.getElementById('SSUSERGROUPDESC');
		if (obj) obj.value = "";
		var obj=document.getElementById('Hospital');
		if (obj) obj.value = "";
		disableDep();
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
		txtUser = objUser.value;
		websys_isInUpdate=true;
		if ((objDept)&&(objDept.value!='')) {	
			var objDeptAlias = document.getElementById("DEPARTMENTAlias");
			var deptDesc = objDept.value;		
			if ( (objDeptAlias)&&(objDeptAlias.value!="") ){
				deptDesc = objDeptAlias.value+"-"+deptDesc;
			}
			if( EnableCALogon==1 && (!dhcsys_calogon(deptDesc,txtUser).IsSucc)){
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
		
		return false;
	}
}

try {
	var obj=document.getElementById('Logon');
	if (obj) obj.onclick=Logon_click;
} catch(e) { alert(e.number + ' ' + e.description) };


function DepartmentHisuiSelect(rowIndex,rowData){
	var obj=document.getElementById('SSUSERGROUPDESC');
	if (obj) obj.value = rowData["Group"];
	var obj=document.getElementById('Hospital');
	if (obj) obj.value = rowData['HOSPDesc'];
	var obj = document.getElementById("DEPARTMENTAlias");
	if (obj) obj.value = rowData['LocAlias'];	
	setTimeout(function (){$('#Logon').focus()},100);
}
function DEPARTMENTLoad(e){
	var target = document.getElementById("DEPARTMENT");
	var kh = $("#DEPARTMENT").lookup("options").keyHandler;
	switch (e.keyCode) {
        case 38:
            kh.up.call(target, e);
            break;
        case 40:
            kh.down.call(target, e);
            break;
        case 37:
            kh.left.call(target, e);
            break;
        case 39:
            kh.right.call(target, e);
            break;
        case 33:
            kh.pageUp.call(target, e);
            break;
        case 34:
            kh.pageDown.call(target, e);
            break;
        case 13:
            e.preventDefault();
            kh.enter.call(target, e);
            return false;
        default:
        	$("#DEPARTMENT").lookup("grid").datagrid("load");
	}
}
//----lookup component
function DEPARTMENT_HISUILookUp(){
	if ($("#DEPARTMENT").val()!="" && !$("#DEPARTMENT").hasClass("disabledField")){
		$("#DEPARTMENT").lookup({
			forceFocus:false,
			toolbar:'<div><table><tr><td style="padding:5px;"><label class="r-label">科室</label></td><td><input id="inLoc" class="textbox" style="margin-right:20px;"></td><td><label class="r-label">安全组</label></td><td><input id="inGroup" class="textbox"></td></tr></table></div>',
			singleSelect:true,panelWidth:500,panelHeight:320,
			className:"web.SSUserOtherLogonLoc",
			queryName:"LookUpSelectedUserByUHD",
			onSelect:DepartmentHisuiSelect,
			url:$URL+"?ClassName=web.SSUserOtherLogonLoc&QueryName=LookUpSelectedUserByUHD",
			queryParams:{User:websys_escape(document.getElementById('USERNAME').value), hospital:"", Department:"",Group:"",IP:document.getElementById("IPAddress").value},
			pagination:true,idField:"Loc",textField:"Loc",
			onLoadSuccess:function(data){
				$("#locgrid").datagrid("selectRow",0);
				$("#inLoc,#inGroup").off("keyup").on("keyup",DEPARTMENTLoad);
			},
			onBeforeLoad:function(param){
				var inL = $('#inLoc').val().toUpperCase();
				var inG = $('#inGroup').val().toUpperCase();
				param.Department=inL;
				param.Group=inG;
			}
		}).on("click",function(){
			if (!$($.hisui.globalContainerSelector).is(':visible')) $("#DEPARTMENT").lookup("showPanel");
		}).on("keydown",function(e){
			if (e.keyCode==13 || e.keyCode==9 ){
			}else{
				e.preventDefault();
				e.stopPropagation();
				return websys_cancel();
			}
		});
	}
}
var DEPARTMENTzLookupGrid;
function DEPARTMENT_lookuphandler(e) {
	if (evtName=='DEPARTMENT') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var obj = document.getElementById('DEPARTMENT');
	if (obj && !$(obj).hasClass("disabledField")){
		var type = websys_getType(e);
		var key = websys_getKey(e);
		if ((type=='click')||((type=='keydown')&&(key==117))) {
			var dept = obj.value;
			var depAliObj = document.getElementById('DEPARTMENTAlias');
			if((depAliObj)&&(depAliObj.value!="")){
				dept = depAliObj.value+"-"+dept;
			}
			var url='websys.lookup.csp';
			url += '?ID=d1473iDEPARTMENT&CONTEXT=Kweb.SSUserOtherLogonLoc:LookUpSelectedUserByUHD';
			url += "&TLUJSF=DepartmentLookUp&resizeColumn=0";
			var obj=document.getElementById('USERNAME');
			if (obj) url += "&P1=" + websys_escape(obj.value);
			//var obj=document.getElementById('Hospital');
			//if (obj) url += "&P2=" + websys_escape(obj.value);
			url += "&P2=&P3=&P5="+document.getElementById("IPAddress").value+"&TBAR=科室:P3,安全组:P4";
			websys_lu(url,1,{height:280,width:450});
			return websys_cancel();
		}
	}
}

document.body.onload=BodyLoadHandler;