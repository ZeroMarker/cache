///UDHCJFFormat.js

var RefYjPrtFlag;
var RefFpPrtFlag;
var RefFpFlag;
var RefYjFlag;
var AbortYJprtFlag;
var AbortFpprtFlag;
var SelYjPaylFlag;
var DepositFlag;
var LinkDepositFlag;
var PatinFlag;
var PapnoFlag;
var Medicareflag;
var PatFeeConfirmFlag;
var UPPaymFlag;
var PrtFpMoreFlag;
var QFPrtFPFlag;
var UseStDate;
var InsuPayFlag;
var BankBackPayFlag;
var m_LocalIPAddress = "";
var FinalChargeCheckDepFlag;
///或取IP地址
document.write("<OBJECT id=locator classid=CLSID:76A64158-CB41-11D1-8B02-00600806D9B6 VIEWASTEXT></OBJECT> ")
document.write("<OBJECT id=foo classid=CLSID:75718C9A-F029-11d1-A1AC-00C04FB6C223></OBJECT>")

function DHCWebD_SetStatusTip() {
	window.defaultStatus = session['LOGON.USERCODE'] + "     " + session['LOGON.USERNAME'] + "    " + session['LOGON.GROUPDESC'];
	//top.document.title + "    " +
	var myStatusTip = "^" + session['LOGON.USERCODE'] + "     " + session['LOGON.USERNAME'] + "    " + session['LOGON.GROUPDESC'];
	var myary = top.document.title.split("^");
	top.document.title = myary[0] + "    " + myStatusTip;
	//window.status = session['LOGON.USERCODE']+"     "+session['LOGON.USERNAME'] + "    "+session['LOGON.GROUPDESC'];
}
function GetSpellCode(strInput) {
	var rtnStr = "-1";
	var DHCINSUBLL = new ActiveXObject("ApplociationFrameWork.FunCom");
	var rtnStr = DHCINSUBLL.GetChineseSpellCode(strInput);
	return rtnStr;
}

function getzyjfconfig() {
	var str;
	var str1;
	var str2;
	var str3;
	var zyjfconfigobj = document.getElementById('getzyjfconfig');
	if (zyjfconfigobj) {
		var encmeth = zyjfconfigobj.value;
	} else {
		var encmeth = '';
	}
	str = cspRunServerMethod(encmeth);
	RefYjPrtFlag = "Y";
	RefFpPrtFlag = "N";
	RefFpFlag = "N";
	RefYjFlag = "N";
	AbortYJprtFlag = "Y";
	AbortFpprtFlag = "Y";
	SelYjPaylFlag = "N";
	DepositFlag = "N";
	LinkDepositFlag = "N";
	PatinFlag = "N";
	PapnoFlag = "N";
	Medicareflag = "Y";
	UPPaymFlag = "N";
	PatFeeConfirmFlag = "N";
	PrtFpMoreFlag = "N";
	QFPrtFPFlag = "Y";
	UseStDate = "";
	InsuPayFlag = "Y";
	BankBackPayFlag = "Y";
	FinalChargeCheckDepFlag="N";
	if (str != "") {
		str3 = str.split("##");
		if (str3[0] != "") {
			str1 = str3[0].split("^");
			str2 = str1[0].split("@");
			RefYjPrtFlag = str2[1];
			str2 = str1[1].split("@");
			RefFpPrtFlag = str2[1];
			str2 = str1[2].split("@");
			RefFpFlag = str2[1];
			str2 = str1[3].split("@");
			RefYjFlag = str2[1];
			str2 = str1[4].split("@");
			AbortYJprtFlag = str2[1];
			str2 = str1[5].split("@");
			AbortFpprtFlag = str2[1];
			str2 = str1[6].split("@");
			SelYjPaylFlag = str2[1];
			str2 = str1[7].split("@");
			DepositFlag = str2[1];
			str2 = str1[8].split("@");
			LinkDepositFlag = str2[1];
			str2 = str1[9].split("@");
			PatinFlag = str2[1];
			str2 = str1[10].split("@");
			PapnoFlag = str2[1];
			str2 = str1[11].split("@");
			Medicareflag = str2[1];
			str2 = str1[12].split("@");
			UPPaymFlag = str2[1];
			str2 = str1[13].split("@");
			PatFeeConfirmFlag = str2[1];
			str2 = str1[14].split("@");
			PrtFpMoreFlag = str2[1];
			str2 = str1[15].split("@");
			QFPrtFPFlag = str2[1];
			str2 = str1[17].split("@");
			InsuPayFlag = str2[1];
			str2 = str1[18].split("@");
			BankBackPayFlag = str2[1];
		}
		if (str3[1] != "") {
			str1 = str3[1].split("^");
			UseStDate = str1[0];
			str2 = str1[1].split("@");
			FinalChargeCheckDepFlag = str2[1];
		}
	}
}

//add by zhl used to get sex by IDCard
function GetSexByIDCard(IDCard) {
	var len = IDCard.length;
	var sex = "";
	if ((!/^\d{17}(\d|x)$/i.test(IDCard)) && (!/^\d{15}$/i.test(IDCard))) {
		alert('IDCard is error');
		return "";
	}
	if (len == 18) {
		sex = IDCard.substr(16, 1) % 2 ? "man" : "woman";
	}
	if (len == 15) {
		sex = IDCard.substr(14, 1) % 2 ? "man" : "woman";
	}
	return sex;
}

///Lid
///验证数字如果是负数则颜色变红色
///指定文本框的onkeyup事件
function CheckNumber() {
	var key = event.keyCode;
	if ((!isNumeric(this.value)) && (key != 8) && (key != 13)) {
		if (this.value != "-") {
			//alert("您的输入有误请重新输入");
			this.select();
			this.value = "";
			this.focus();
			return;
		}
	} else {
		if (this.value < 0) {
			this.style.color = "red";
		} else {
			this.style.color = "black";
		}
	}
}

///Lid
///验证数字如果是负数则颜色变红色
function CheckNumber2(obj) {
	var key = event.keyCode;
	if (!isNumeric(obj.value) && (key != 8) && (key != 13)) {
		if (obj.value != "-") {
			alert("您的输入有误请重新输入");
			obj.select();
			obj.value = "";
			obj.focus();
			return;
		}
	} else {
		if (obj.value < 0) {
			obj.style.color = "red";
		} else {
			obj.style.color = "black";
		}
	}
}

/// ZhYW
/// 验证输入数字是否为正整数
/// 指定文本框的onkeyup事件
function CheckPositiveInteger() {
	var key = event.keyCode;
	if ((!isPositiveInteger(this.value)) && (key != 8) && (key != 13)) {
		//alert("您的输入有误请重新输入");
		this.select();
		this.value = "";
		this.focus();
		return;
	}
}

///Lid
///验证是否为小数
function isNumeric(strValue) {
	var objExp = /(^-?\d\d*\.\d*$)|(^-?\d\d*$)|(^-?\.\d\d*$)/;
	return objExp.test(strValue);
}

///Lid
///验证是否为整数
function isInteger(strValue) {
	var objExp = /(^-?\d\d*$)/;
	return objExp.test(strValue);
}

///验证是否为正数
function isPositiveNumber(strValue) {
	var objExp = /^(0|([1-9]\d*))(\.\d+)?$/;
	return objExp.test(strValue);
}

/// ZhYW
///验证是否正整数
function isPositiveInteger(strValue) {
	var objExp = /^[0-9]*[1-9][0-9]*$/;
	return objExp.test(strValue);
}

//Lid 2010-03-10 修改textbox获取焦点后文本框的样式,如果是数字右对齐文本左对齐
sfFocus = function () {
	var sfEls = document.getElementsByTagName("INPUT");
	for (var i = 0; i < sfEls.length; i++) {
		sfEls[i].onfocus = function () {
			this.className += " sffocus";
			this.style.textAlign = "left";
		}
		sfEls[i].onblur = function () {
			this.className = this.className.replace(new RegExp(" sffocus\\b"), "");
			if ((isNumeric(this.value))) {
				this.style.textAlign = "right";
			}
		}
	}
}

///Lid
///2010-03-22
///获取计算机名
function GetComputerName() {
	var WshNetwork = new ActiveXObject("WScript.NetWork");
	var computername = WshNetwork.ComputerName;
	return computername;
}

function GetSpellCodeNew(strInput) {
	var rtnStr = "-1";
	/*
	var GetCNCODE = document.getElementById('GetCNCODE');
	if (GetCNCODE) {
		var encmeth = GetCNCODE.value;
	} else {
		var encmeth = '';
	}
	var rtnStr = cspRunServerMethod(encmeth, strInput, "4", "");
	*/
	var rtnStr = tkMakeServerCall("web.UDHCJFCOMMON", "GetCNCODE", strInput, "4", "");
	return rtnStr;
}

/*
//获取客户端的IP地址，暂时不用，从后台获取
//IE的高级版本不好使
(function GetLocalIPAddress(){
var service = locator.ConnectServer();
var MACAddr="";
var IPAddr="";
var DomainAddr="";
var sDNSName="";
service.Security_.ImpersonationLevel=3;
service.InstancesOfAsync(foo,'Win32_NetworkAdapterConfiguration');

foo.attachEvent("OnCompleted",FooOnCompleted);
foo.attachEvent("OnObjectReady",FooOnObjectReady);


})();

function FooOnCompleted(hResult,pErrorObject,pAsyncContext){
//alert(unescape(MACAddr)+"   "+unescape(IPAddr)+"    "+unescape(sDNSName));
m_LocalIPAddress=unescape(MACAddr)+";"+unescape(IPAddr)+";"+unescape(sDNSName)
foo.detachEvent("FooOnObjectReady", FooOnObjectReady);
foo.detachEvent("OnCompleted", FooOnCompleted);

}
function FooOnObjectReady(objObject,objAsyncContext){
if(objObject.IPEnabled!=null&&objObject.IPEnabled!="undefined"&&objObject.IPEnabled==true){
if(objObject.MACAddress!=null&&objObject.MACAddress!="undefined")
MACAddr=objObject.MACAddress;
if(objObject.IPEnabled&&objObject.IPAddress(0)!=null&&objObject.IPAddress(0)!="undefined")
IPAddr=objObject.IPAddress(0);
if(objObject.DNSHostName!=null&&objObject.DNSHostName!="undefined")
sDNSName=objObject.DNSHostName;
}

}
*/
