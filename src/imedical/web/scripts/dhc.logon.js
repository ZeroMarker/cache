// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
var objUser=document.getElementById('USERNAME');
var objPswd=document.getElementById('PASSWORD');
var objDept=document.getElementById('DEPARTMENT');
var objDeptLookup=document.getElementById('DEPARTMENTLookup');
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
	} else if ((objDeptLookup)&&(objDeptLookup.value=='')&&(!objDeptLookup.readOnly)&&(!objDeptLookup.disabled)) {
		$('#DEPARTMENTLookup').focus();
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
	if (objDeptLookup){
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
			var obj = document.getElementById("DEPARTMENTLookup");
			if (obj) obj.fireEvent("onclick"); //value="";
			//objDept.fireEvent("onclick");
		}
	})
	
	if ("undefined"==typeof cspFindXMLHttp){
		$(".tcq").html("<font color='red' size='3pt'>����IISȱ��csp����Ŀ¼,���޸���װ��.</font>");
		disableDep();
	};
	if(typeof tipPasswordChange!="undefined"&&tipPasswordChange=="1"){
		
		if ($.messager){
			$.messager.confirm("��ʾ","���븴�ӶȲ�����ϵͳҪ���Ƿ������޸ģ�",function(r){
				if (r){ChangePassword();}
			});
		}else{
			if(confirm("���븴�ӶȲ�����ϵͳҪ���Ƿ������޸ģ�")){
				ChangePassword();
			}
		}
	}
	//"undefined"!=typeof isIECore && !isIECore	
	if (detectOS().indexOf("Windows")==-1){ //��Window
		EnableLocalWeb = undefined;
		document.getElementById("IPAddress").value= "2.2.2.2";
 		document.getElementById("DNSHostName").value= "LinuxTest";
 		document.getElementById("MACAddr").value="E8:D0:FC:E2:54:95";
		$("#localipdiv").html("2.2.2.2");
 		$("#localmacdiv").html("E8:D0:FC:E2:54:95");
	}
	if("undefined"!=typeof EnableLocalWeb && EnableLocalWeb==1){
		CMgr.clear();
		CMgr.timeout=500;
		CMgr.notReturn =1;
		CMgr.getVersion(function(json){
			if ("string"==typeof json){
				json = JSON.parse(json);
			}
			if (json.status==404){
				//$.messager.popover({msg:'����ҽΪ�ͻ����Ƿ���������',type: 'error',style: {top:10,left:document.body.clientWidth/2 - 150,}});
				//location.href='RunWebsysServer://1'
				installWebsysServer();
				return ;
			}
			if (json.status==200){
				if(json.rtn<CMgr.data[1]._version){
					installWebsysServer("upgrade");
				}
			}
			setIPMac();
			loadDHCWebBrowser();
		}); 
		//mgr.invk();
	}
	setPageTitle();
	var CAUserCertCodeObjVal = document.getElementById("CAUserCertCode").value;
	if (CAUserCertCodeObjVal==""){
	    if(ShowCALogonType!="") LogonTypeBtnClick(ShowCALogonType);
	}
	var deplookup = document.getElementById("DEPARTMENTLookup");
	if (deplookup.value!="") showCareUserInfo(HospCodeNo,document.getElementById('Hospital').value);
	var isWideScreenObj = document.getElementById("IsWideScreen");
	if (screen.availWidth/screen.availHeight>2.33 && isWideScreenObj){
		isWideScreenObj.value = 1;
	}

}
/*�����Ƿ���ҽΪ�����*/
function hasDHCWebBrowser (){
	if (typeof cefbound != "undefined") {return true;}
	var arr = [];
	arr.push('set workingDir=%path%');
	arr.push('set targetPath=%path%\test.exe');
	arr.push('set lnkPath=%~dp0\TEST.lnk');
	arr.push('set SCRIPT="%TEMP%\\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"');
	arr.push('@echo off');
	arr.push('echo Function vbs_Test >> %SCRIPT%');
	arr.push('echo 	curPathBrowser="" >> %SCRIPT%');
	arr.push('echo 	Set fso = createobject("Scripting.FileSystemObject") >> %SCRIPT%');
	arr.push('echo 	fso.DeleteFile "%TEMP%\\DHCWebBrowserPath.txt",true >> %SCRIPT%'); //��ɾ���ļ����ѿͻ���pluginĿ¼��������������ݷ�ʽɾ��������ΪҽΪ���������
	arr.push('echo 	curPath = fso.GetFile(Wscript.ScriptFullName).ParentFolder.ParentFolder.ParentFolder.Path >> %SCRIPT%');
	arr.push('echo 	Set WshShell=CreateObject("WScript.Shell") >> %SCRIPT%');
	arr.push('echo 	strDesktop = WshShell.SpecialFolders("Desktop") >> %SCRIPT%');
	arr.push('echo 	For Each item In fso.GetFolder(strDesktop).Files >> %SCRIPT%');
	arr.push('echo 		If fso.GetExtensionName(item)="lnk" Then >> %SCRIPT%');
	arr.push('echo 			Set itemShellLink=WshShell.CreateShortcut(strDesktop ^& "\\" ^& item.Name)		 >> %SCRIPT%');	
	arr.push('echo 			if instr(itemShellLink.TargetPath,"DHCWebBrowser49.exe")^>0 then >> %SCRIPT%');
	arr.push('echo 				curPathBrowser = itemShellLink.TargetPath >> %SCRIPT%');
	arr.push('echo 				Set myFile = fso.CreateTextFile("%TEMP%\\DHCWebBrowserPath.txt",true) >> %SCRIPT%');
	arr.push('echo 				myFile.WriteLine(curPathBrowser) >> %SCRIPT%');
	arr.push('echo 				myFile.Close >> %SCRIPT%');
	arr.push('echo 				Exit For >> %SCRIPT%');
	arr.push('echo 			End if >> %SCRIPT%');
	arr.push('echo 		itemShellLink = null >> %SCRIPT%');
	arr.push('echo 		End If >> %SCRIPT%');
	arr.push('echo 	Next >> %SCRIPT%');
	arr.push('echo 	vbs_Test = curPathBrowser >> %SCRIPT%');
	arr.push('echo End Function >> %SCRIPT%');
	arr.push('echo vbs_Test() >> %SCRIPT%');
	arr.push('cscript /nologo %SCRIPT%');
	arr.push('del %SCRIPT%');
	arr.push('set /p pathStr=< "%TEMP%\\DHCWebBrowserPath.txt"');
	arr.push('echo %pathStr%');
	var str = arr.join('\n');
	var obj = CmdShell.Run(str);   // CmdShell.Run(" ")
	if (obj && obj.rtn && obj.rtn.indexOf("DHCWebBrowser")>-1) {
		return true;
	}
	return false;
}
function loadDHCWebBrowser(){
	lasterDHCWebBrowser = 0;
	
	if (hasDHCWebBrowser()){
		if( "undefined"!=typeof DHCWebBrowserPatch){
			setTimeout(function(){
				if (0==lasterDHCWebBrowser){
					$.messager.progress({title: "��ʾ",msg: '��������ҽΪ�����',text: '������...'});
				}
			},300);
			DHCWebBrowserPatch.timeout=500000;
			DHCWebBrowserPatch.notReturn=1;
			DHCWebBrowserPatch.cmd("makelnk.vbs",function(){
				lasterDHCWebBrowser = 1;
				$.messager.progress("close");
			});
		}
	}else{
		if("undefined"!=typeof DHCWebBrowser){
			setTimeout(function(){
				if (0==lasterDHCWebBrowser){
					$.messager.progress({title: "��ʾ",msg: '��������ҽΪ�����',text: '������...'});
				}
			},1000);
			DHCWebBrowser.timeout=500000;
			DHCWebBrowser.notReturn=1;
			DHCWebBrowser.cmd("makelnk.vbs",function(){
				lasterDHCWebBrowser = 1;
				$.messager.progress("close");
			});
		}
	}
}
function installWebsysServer(type){
	var html = "";
	var os = navigator.platform;  
    var userAgent = navigator.userAgent;  
	var setupFileName = "WebsysServerSetup.msi";
	if (os.indexOf("Win")>-1){
		var rg = /(Windows [3-5])|(Windows NT [3-5])/; /*5=xp,6.1=win7,6.4=win10*/
		if (rg.test(userAgent)){
			setupFileName = "WebsysServerSetup3.5_x86.msi"
		}
	}
	if (type=='upgrade'){
		if (CMgr){
			$.messager.progress({title: "��ʾ",msg: '���������м��',text: '������...'});
			CMgr.clear();
			CMgr.notReturn=0;
			CMgr.ass = "WebsysServerSetup";
			CMgr.cls = "WebsysServerSetup";
			// cmd("setup.exe /passive /norestart") �ᰲװ��C:\Windows\SysWOW64\config\systemprofile\AppData\Local\MediWay
			// cmd("setup.exe /qb /norestart")  ��/passiveһ��û�в������棬���ᰲװ������Ŀ¼��
			// cmd("setup.exe /qr /norestart") �ᰲװ�����汾,���ܸ�����ǰ�汾
			// cmd("setup.exe /qf /norestart") ��ȫ���˹���һ��
			CMgr.cmd("make.bat",function(){
				$.messager.progress("close");
			});
		}
		return ;
	}else{
		html = '<h3 style="color:#000000;width:290px;margin:0 auto;padding:20px;font-size: 16px;">��װ�ͻ��˻�������</h3>'
		+'<lu style="padding:20px;display: block;"><li><div>1. �ͻ��˻���������Ҫ��װ��������ť�������°�װ����<div>'
		+'<div><a href="../addins/plugin/'+setupFileName+'" style="color:#fff;background-color: #3276b1;border-color: #285e8e;border-radius: 5px;padding: 0 25px;margin:5px 20px;width: 110px;height: 35px;line-height: 35px;display: block;">���ذ�װ</a></div></li>'
		+'<li><div>2. ��װ�����غõ�msi��װ��</div></li>'
		+'<li><div>�� ��������װ��,���<a href="#" onclick="location.href=\'RunWebsysServer://1\';return false;" style="color: #fff;background-color: #3276b1;border-color: #285e8e;border-radius: 5px;padding: 0 10px;margin: 5px 10px;height: 24px;line-height: 24px;display: inline-block;text-decoration: none;">���й������</a></div></li>'
		+'<li><div>�ɹ������ͻ��˹�������,���½����¼���漴��</div></li>'
		+'</lu>';
	}
	websys_showModal({title:'',content:html,height:'340',width:'500'}); 
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
		var obj = document.getElementById("DEPARTMENTLookup");
		if (obj) obj.value="";
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
		if ((objUser.value!="")&&(objPswd.value!="")&&(objDeptLookup.value=="")){ // ���ӿ���������Ϊ��[3496594]
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
	objUser.value = objUser.value.trim();
	txtUser = objUser.value;
}
///���븴�Ӷ�
function calPwdComplexity(password){
	var pwdcpl=document.getElementById("PwdComplexity");
	//1.������ �޸����� �ɹ��� ������ֱ����������� 32λ�����¼��㸴�Ӷ� ֱ���ύ���ǲ����� ����ǰ�����벻һ��Ҫ��Ϊ����
	if (password!=PwdLastPwd) pwdcpl.value="valid";  //��ֹ�޸������ ֱ�ӵ�¼ ��ʾ������
	//2. SetLogonClick�����д������� �˷���Ҳ��������  ��һ������Ϊ1 ������Ҫ��  ���ܺ��Ϊ32λ �ڶ��ν��˷��� �����ж�Ϊ�� �����Ӷȼ�Ϊ���� ��ʱ�ύ���Զ���ȥ��
	PwdLastPwd=e7(password); //hex_md5(dhc_cacheEncrypt(password));  //��ֹ���δ������µ�����
	if (password!="" && (password.length%32>0)){

		if(typeof uniUserPwdComplexityCfg=='object' && typeof validPasswordComplexity=='function') { //�µ�ͳһ���븴�Ӷ���֤ 2023-02-07
			var validRet=validPasswordComplexity(password,uniUserPwdComplexityCfg);
			if(validRet===true) { //��֤ͨ��
				pwdcpl.value="valid";
				return;	
			}else{
				pwdcpl.value="invalid";
				return;
			}
		}

		
		if (PwdMinLength>=0 && password.length<PwdMinLength){   //���Ȳ���
			pwdcpl.value="invalid";
			return;
		}
		if(PwdContainWordAndNum=="Y"){
			if (!(/[0-9]+/.test(password))){   //û������
				pwdcpl.value="invalid";
				return;
			}
			if (!/[a-zA-Z]/.test(password)){  //û��ĸ
				pwdcpl.value="invalid";
				return;
			}
		}
		if(!!PasswordOtherValid){
			if (strictComplex(PasswordOtherValid, password) != ""){  //����У��
				pwdcpl.value="invalid";
				return;
			}
		}
		pwdcpl.value="valid";
		return;	
	}
}

function strictComplex(reg, str) {
	var arr = reg.split("|");
	var x = arr[0] ? arr[0] : "";
	var y = arr[1] ? arr[1] : "";
	var z = arr[2] ? arr[2] : "";
    if(x == "1" && sequentialString(str)) {
        return "���� ����>= 3������������ĸ������";
    }
    if(y == "1" && repeatString(str)) {
        return "���� ����ABAB��ABCABC����ĸ������";
    }
    var temp = str.toLowerCase();
    if(z == "1" && temp.indexOf("password") > -1) {
        return "���� ����password";
    }
    return "";
}
/**
 * �Ƿ�������3���ַ� ����>=3������������ĸ������
 * @param str ԭ�ַ�
 * @returns true ������3���ַ�
 */
 function sequentialString(str) {
    var arr = str.split('');
    for (var i = 2; i < arr.length; i++) {
        if(arr[i] == arr[i - 2] && arr[i - 2] == arr[i - 1]) {
            return true;
        }
    }
    for (var i = 2; i < arr.length; i++) {
        if(Math.abs(arr[i].charCodeAt() - arr[i - 1].charCodeAt()) == 1 && Math.abs(arr[i - 1].charCodeAt() - arr[i - 2].charCodeAt()) == 1 ) {
            return true;
        }
    }
    return false;
}

/**
 * ����ABAB��ABCABC����ĸ������
 * @param str ԭ�ַ�
 * @returns true ��
 */
function repeatString(str) {
    var arr = str.split('');
    for (var i = 3; i < arr.length; i++) {
        if(arr[i] == arr[i - 2] && arr[i - 1] == arr[i - 3]) {
            return true;
        }
    }
    for (var i = 5; i < arr.length; i++) {
        if(arr[i] == arr[i - 3] && arr[i - 1] == arr[i - 4] && arr[i - 2] == arr[i - 5]) {
            return true;
        }
    }
    return false;
}

function SetLogonClick(evt) {
	islogon=1;
	var AuthRet , authErrCode ,authErrInfo , myflag;
	//����������ܳ��� 2014-10-10 add by wanghc 
	var username = document.getElementById("USERNAME").value;
	var password = document.getElementById("PASSWORD").value;
	password = password.replace(/\t|\n|\s|\f|\r|\v/g,"");
	calPwdComplexity(password); //���㸴�Ӷ� �ı�PwdComplexityԪ�ص�ֵ
	if (password!="" && (password.length%32>0)){ //�ӹ��ܲ��ټ�
		var sid = "123456789";
		if (document.forms[0].RSID){
			document.forms[0].RSID.value = document.forms[0].TPAGID.value;
			sid = document.forms[0].RSID.value;
		}
		var k = FIXKEY+(sid-1),l=sid.length;
		document.getElementById("PASSWORD").value = e7(password,k.slice(l));
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
	if (!objUser.value) {
		objUser.focus();
		return false;
	}
	if (txtUser != objUser.value){
		var obj=document.getElementById('SSUSERGROUPDESC');
		if (obj) obj.value = "";
		var obj=document.getElementById('Hospital');
		if (obj) obj.value = "";
		var obj=document.getElementById('DEPARTMENTLookup');
		if (obj) obj.value = "";
		var obj=document.getElementById('DEPARTMENT');
		if (obj) obj.value = "";
		var obj=document.getElementById('UserPost');
		if (obj) obj.value = "";
		var obj=document.getElementById('UserPostId');
		if (obj) obj.value = "";
		disableDep();
		txtUser = objUser.value;
	}
}
//------- from scripts_gen-----
function Logon_click() {
	objUser.value = objUser.value.trim();
	if (!objUser.value) {
		objUser.focus();
		return false;
	}
	if (!objPswd.value) {
		objPswd.focus();
		return false;
	}
	var objv = $("#MACAddr").val();
	if (objv=="" && !websys_isIE){
		location.reload();
		return ;
	}
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
			// 2680245 ��ͬ�û���ͬ����ֻ����һ���Ự����
			var groupDesc = document.getElementById("SSUSERGROUPDESC").value;
			var hospDesc = document.getElementById('Hospital').value;
			var LogInfo = tkMakeServerCall("web.DHCSSUserLogonLog","GetLogIdByUserLoc",txtUser, deptDesc, groupDesc)
			if (LogInfo.indexOf("ILLEGAL VALUE>zDecrypt+2^websys.Page")==-1){  // ϵͳ��ʱ
				var LogInfoArr = LogInfo.split("^")
				if(0!=LogInfoArr[0] && LogInfoArr.length>2){
					if(confirm(txtUser+"�Ѿ���"+LogInfoArr[1]+"��¼��ϵͳ!�ỰID:"+LogInfoArr[2]+"����ȷ���滻��¼?")){
						tkMakeServerCall("web.DHCSSUserLogonLog","Force",LogInfoArr[0]);
					}else{
						//window.location.href="websys.closesession.csp?relogon=1";
						return ;
					}
				}
				// ������Ժ--����ȵ�¼HIS�û� �� �ٵ�¼CA��CertNo��CACertCodeΪ�ա���ֱ��CA��¼��ѡ���ҵ�¼����Դ���
				// ������ɽ�޸ĳɻص�֧��Chromeϵ�����
				//if( EnableCALogon==1){
					session['LOGON.USERCODE'] = txtUser;
					var ret = dhcsys_getcacert({
						modelCode:"HISLogon",
						callback:function(cartn){
							if (cartn.IsSucc){
								if (cartn.ContainerName=="") {
									// Loc Disable CA 
								}else{
									if ("object"== typeof cartn && cartn.IsCAReLogon){
										caToInput(cartn);
										SetLogonClick();
									}	
								}
							 }else {
								return false;
							 }
						},
						isHeaderMenuOpen:false,
						SignUserCode:txtUser,
						notLoadCAJs:1,
						loc:deptDesc,
						hospDesc:document.getElementById('Hospital').value,
						groupDesc:groupDesc,
						caInSelfWindow:1
					},"",0,0); //dhcsys_calogon(deptDesc,txtUser,"",0,function(cartn){	
					if ("object"==typeof ret && ret.IsSucc==false){
						return false;
					}
				//}
			}else{
				$.messager.popover({msg: '��¼����ʱЧ,�����������¼��',type: 'alert'});
				objUser.value="";
				objPswd.value="";
			}	
		}
		var obj=document.getElementById('Logon');
		if (obj) {obj.disabled=true;obj.onclick=function() {return false};}			
		frm.TEVENT.value='d1473iLogon';
		var nowDate = new Date();
		var nowTime = nowDate.getHours()+":"+nowDate.getMinutes(); //����û����
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
	if (window.EnablePostLogon==1){
		$('#DEPARTMENTLookup').val(rowData['AccPost']);
	}else{
		$('#DEPARTMENTLookup').val(rowData['Loc']);
	}
	var obj=document.getElementById('SSUSERGROUPDESC');
	if (obj) obj.value = rowData["Group"];
	var obj=document.getElementById('Hospital');
	if (obj) obj.value = rowData['HOSPDesc'];
	var obj = document.getElementById("DEPARTMENTAlias");
	if (obj) obj.value = rowData['LocAlias'];
	var obj = document.getElementById("DEPARTMENT");
	if (obj) obj.value = rowData['Loc'];
	// ��λ
	$('#UserPost').val(rowData['AccPost']);
	$('#UserPostId').val(rowData['AccPostId']);
	showCareUserInfo(rowData['HospInsuCode'],rowData['HOSPDesc']);
	setTimeout(function (){$('#Logon').focus()},100);
    $('#HospDescShort1').text("");
	if (typeof(IsShowHospDescShort1) != "undefined" && IsShowHospDescShort1 != null && IsShowHospDescShort1 == 1 && !!rowData['HospDescShort1']) $('#HospDescShort1').text(rowData['HospDescShort1']);
}
function DEPARTMENTLoad(e){
	var target = document.getElementById("DEPARTMENTLookup");
	var kh = $("#DEPARTMENTLookup").lookup("options").keyHandler;
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
            var q = $("#DEPARTMENTLookup").lookup("options").queryParams;
            var inL = $('#inLoc').length>0?$('#inLoc').val().toUpperCase():"";
			var inG = $('#inGroup').length>0?$('#inGroup').val().toUpperCase():"";
			var inP = $('#inAccPost').length>0?$('#inAccPost').val().toUpperCase():"";
            if (q.Department==inL && q.Group==inG){
	            kh.enter.call(target, e);
            }else{
            	$("#DEPARTMENTLookup").lookup("grid").datagrid("load");
            }
            return false;
        default:
        	$("#DEPARTMENTLookup").lookup("grid").datagrid("load");
	}
}
//----lookup component
function DEPARTMENT_HISUILookUp(){
	var username = document.getElementById('USERNAME').value;
	if ($("#DEPARTMENTLookup").val()!="" && !$("#DEPARTMENTLookup").hasClass("disabledField")){
		var tb = '';
		if ('undefined'==typeof EnablePostLogon || EnablePostLogon!=1){
			tb = '<div><table><tr><td style="padding:5px;"><label class="r-label">'+$g("����")+'</label></td><td><input id="inLoc" class="textbox" style="margin-right:20px;"></td><td><label class="r-label">'+$g("��ȫ��")+'</label></td><td><input id="inGroup" class="textbox"></td></tr></table></div>';
		}else{
			tb = '<div><table><tr><td style="padding:5px;"><label class="r-label">'+$g("��λ")+'</label></td><td><input id="inAccPost" class="textbox" style="margin-right:20px;"></td></tr></table></div>';
		}
		$("#DEPARTMENTLookup").lookup({
			forceFocus:false,striped:true,
			toolbar:tb,
			singleSelect:true,panelWidth:500,panelHeight:320,
			className:"web.SSUserOtherLogonLoc",
			queryName:"LookUpSelectedUserByUHD",
			onSelect:DepartmentHisuiSelect,
			url:$URL+"?ClassName=web.SSUserOtherLogonLoc&QueryName=LookUpSelectedUserByUHD",
			queryParams:{User:websys_escape(document.getElementById('USERNAME').value), hospital:"", Department:"",Group:"",IP:document.getElementById("IPAddress").value},
			pagination:true,idField:"Loc",textField:"Loc",
			onColumnsLoad:function(cm){
				if ('undefined'==typeof EnablePostLogon || EnablePostLogon!=1){
					for (var i=0;i<cm.length;i++){
						if(cm[i]['field']=="AccPost" || cm[i]['field']=="AccPostId" ){
							cm[i].hidden=true;
						}
						if(cm[i]['field']=="Group" || cm[i]['field']=="Loc"  || cm[i]['field']=="HOSPDesc" ){
							cm[i].hidden=false;
						}
					}
				}else{ // SHOW post 
					for (var i=0;i<cm.length;i++){
						if(cm[i]['field']=="Group" || cm[i]['field']=="Loc"  || cm[i]['field']=="LocAlias" ){
							cm[i].hidden=true;
						}
						if(cm[i]['field']=="AccPost" || cm[i]['field']=="HOSPDesc"){
							cm[i].hidden=false;
						}
					}
				}
				
			},
			onLoadSuccess:function(data){
				$("#locgrid").datagrid("selectRow",0);
				$("#inLoc,#inGroup,#inAccPost").off("keydown").on("keydown",function(e){setTimeout(function(){DEPARTMENTLoad(e);},10);});
			},
			onBeforeLoad:function(param){
				var inL = $('#inLoc').length>0?$('#inLoc').val().toUpperCase():"";
				var inG = $('#inGroup').length>0?$('#inGroup').val().toUpperCase():"";
				var inP = $('#inAccPost').length>0?$('#inAccPost').val().toUpperCase():"";
				param.Department=inL;
				param.Group=inG;
				param.ReqPost = inP;
				param.IP = document.getElementById("IPAddress").value;
				var qp = $(this).lookup('options').queryParams;
				qp.Department=inL;
				qp.Group=inG;
				qp.ReqPost = inP;
				qp.IP = document.getElementById("IPAddress").value;
			},
			onBeforeShowPanel: function () {
				if ($($.hisui.globalContainerSelector).is(':visible')) return false;
				if ($(this).hasClass("disabledField")) return false;
				if ($(this).prop("readonly")) return false;
			}
			/*,
			onShowPanel:function(){
				var l = (document.documentElement.clientWidth -500)/2;
				var t = (document.documentElement.clientHight - 320)/2;
				$($.hisui.globalContainerSelector).css({top:t,left:l});
				$.hisui.fixPanelTLWH = function(){}
			}*/
		}).on("click",function(){
			if (!$($.hisui.globalContainerSelector).is(':visible')) {
				if (!$(this).hasClass("disabledField") && !$(this).prop("readonly")) {
					$(this).lookup("showPanel");
				}
			}
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
function LogonTypeBtnClick(type,venderCode){
	dhcsys_showcaLogon(type,1,1,"",function(ret){
		if ("object"== typeof ret && ret.IsSucc==true){
			caToInput(ret,1);
			SetLogonClick();
			return ;
		}else if ("undefined"==typeof ret){ 
			return {"IsSucc":false,"ContainerName":""} 
		};
	},{notLoadCAJs:1,venderCode:venderCode});
	return ;
}
function caToInput(ret,flag){
	if (ret.IsSucc && ret.UserName!=""){
		var o = document.getElementById("ContainerName");
		if (o) o.value = ret.ContainerName;
		o = document.getElementById("CALogonType");
		if (o) o.value = ret.CALogonType;
		o = document.getElementById("CAUserCertCode");
		if (o) o.value = ret.CAUserCertCode; 
		o = document.getElementById("CACertNo");
		if (o) o.value = ret.CACertNo; 
		if (o) o = document.getElementById("CAToken");
		if (o) o.value = ret.CAToken;
		if (flag==1){
			o = document.getElementById("USERNAME");
			if (o) o.value =ret.UserName; 
			o = document.getElementById("PASSWORD");
			if (o) o.value="123abcABC******";
		}
	}
}
function detectOS() {
	if (typeof cefbound != "undefined") return "Windows";
	var sUserAgent = navigator.userAgent;
	var isWin = (navigator.platform == "Win32") || (navigator.platform == "Windows");
	var isMac = (navigator.platform == "Mac68K") || (navigator.platform == "MacPPC") || (navigator.platform == "Macintosh") || (navigator.platform == "MacIntel");
	if (isMac) return "MacOS";
	var isUnix = (navigator.platform == "X11") && !isWin && !isMac;
	if (isUnix) return "Unix";
	var isLinux = (String(navigator.platform).indexOf("Linux") > -1);
	if (isLinux) return "Linux";
	if (isWin) {
		var isWin2K = sUserAgent.indexOf("Windows NT 5.0") > -1 || sUserAgent.indexOf("Windows 2000") > -1;
		if (isWin2K) return "Windows2000";
		var isWinXP = sUserAgent.indexOf("Windows NT 5.1") > -1 || sUserAgent.indexOf("Windows XP") > -1;
		if (isWinXP) return "WindowsXP";
		var isWin2003 = sUserAgent.indexOf("Windows NT 5.2") > -1 || sUserAgent.indexOf("Windows 2003") > -1;
		if (isWin2003) return "Windows2003";
		var isWinVista= sUserAgent.indexOf("Windows NT 6.0") > -1 || sUserAgent.indexOf("Windows Vista") > -1;
		if (isWinVista) return "Windows Vista";
		var isWin7 = sUserAgent.indexOf("Windows NT 6.1") > -1 || sUserAgent.indexOf("Windows 7") > -1;
		if (isWin7) return "Windows7";
		var isWin10 = sUserAgent.indexOf("Windows NT 10") > -1 || sUserAgent.indexOf("Windows 10") > -1;
		if (isWin10) return "Windows10";
		var isWin11 = sUserAgent.indexOf("Windows NT 11") > -1 || sUserAgent.indexOf("Windows 11") > -1;
		if (isWin11) return "Windows11";
		
	}
	return "other";
}
document.body.onload=BodyLoadHandler;