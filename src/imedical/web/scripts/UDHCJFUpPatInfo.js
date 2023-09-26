///UDHCJFUpPatInfo.js

var stdateobj, enddateobj, stdate1obj, enddate1obj;
var papmidobj, admidobj, useridobj, usernameobj;
var regnoobj, patnameobj, admsearchobj;
var stdate, enddate;

function BodyLoadHandler() {
	Guser = session['LOGON.USERID'];
	stdateobj = document.getElementById("stdate");
	enddateobj = document.getElementById("enddate");
	stdate1obj = document.getElementById("stdate1");
	enddate1obj = document.getElementById("enddate1");
	papmiidobj = document.getElementById("papmiid");
	admidobj = document.getElementById("admid");
	useridobj = document.getElementById("userid");
	regnoobj = document.getElementById("regno");
	patnameobj = document.getElementById("name");
	admsearchobj = document.getElementById("admsearch");
	usernameobj = document.getElementById("username");
	if (usernameobj){
		usernameobj.onkeydown = getuser;
		usernameobj.onkeyup = clearUser;
	}
	if (regnoobj.value == "") {
		papmiidobj.value = "";
	}
	admsearchobj.onkeydown = getadm;
	//papmiidobj.value = "";
	//useridobj.value = "";
	admidobj.value = "";
	if ((stdate1obj.value == "") || (enddate1obj.value == "")) {
		gettoday();
	}
	stdateobj.onkeydown = getstdate;
	enddateobj.onkeydown = getenddate;
	regnoobj.onkeydown = getpat;
}

function gettoday() {
	var stdatetimeobj = document.getElementById("getdatetime");
	if (stdatetimeobj) {
		var encmeth = stdatetimeobj.value;
	} else {
		var encmeth = '';
	}
	var stdatetime = cspRunServerMethod(encmeth);
	if (stdatetime != "") {
		var str1 = stdatetime.split("^");
		stdateobj.value = str1[0];
		enddateobj.value = str1[0];
		stdate1obj.value = str1[0];
		enddate1obj.value = str1[0];
	}
}

function getstdate() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		var mybirth = DHCWebD_GetObjValue("stdate");
		if ((mybirth == "") || ((mybirth.length != 8) && ((mybirth.length != 10)))) {
			var obj = document.getElementById("stdate");
			obj.className = 'clsInvalid';
			websys_setfocus("stdate");
			return websys_cancel();
		} else {
			var obj = document.getElementById("stdate");
			obj.className = 'clsvalid';
		}
		if ((mybirth.length == 8)) {
			var mybirth = mybirth.substring(0, 4) + "-" + mybirth.substring(4, 6) + "-" + mybirth.substring(6, 8);
			DHCWebD_SetObjValueA("stdate", mybirth);
		}
		var myrtn = DHCWeb_IsDate(mybirth, "-");
		if (!myrtn) {
			var obj = document.getElementById("stdate");
			obj.className = 'clsInvalid';
			websys_setfocus("stdate");
			return websys_cancel();
		} else {
			var obj = document.getElementById("stdate");
			obj.className = 'clsvalid';
		}
		var str1 = stdateobj.value.split("-");
		var str2 = str1[2] + "/" + str1[1] + "/" + str1[0];
		stdate1obj.value = str2;
		websys_setfocus('enddate');
	}
}

function getenddate() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		var mybirth = DHCWebD_GetObjValue("enddate");
		if ((mybirth == "") || ((mybirth.length != 8) && ((mybirth.length != 10)))) {
			var obj = document.getElementById("enddate");
			obj.className = 'clsInvalid';
			websys_setfocus("enddate");
			return websys_cancel();
		} else {
			var obj = document.getElementById("enddate");
			obj.className = 'clsvalid';
		}
		if ((mybirth.length == 8)) {
			var mybirth = mybirth.substring(0, 4) + "-" + mybirth.substring(4, 6) + "-" + mybirth.substring(6, 8);
			DHCWebD_SetObjValueA("enddate", mybirth);
		}
		var myrtn = DHCWeb_IsDate(mybirth, "-");
		if (!myrtn) {
			var obj = document.getElementById("enddate");
			obj.className = 'clsInvalid';
			websys_setfocus("enddate");
			return websys_cancel();
		} else {
			var obj = document.getElementById("enddate");
			obj.className = 'clsvalid';
		}
		var str1 = enddateobj.value.split("-");
		var str2 = str1[2] + "/" + str1[1] + "/" + str1[0];
		enddate1obj.value = str3;
	}
}

function getpat() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		if (regnoobj.value == "") {
			alert(t['01']);
			return;
		}
		var p1 = regnoobj.value;
		var getpatinfo = document.getElementById("getpatname");
		if (getpatinfo) {
			var encmeth = getpatinfo.value;
		} else {
			var encmeth = '';
		}
		var str = cspRunServerMethod(encmeth, p1);
		if (str != "") {
			var str1 = str.split("^");
			if (str1[0] == "-1") {
				alert(t['01']);
				return;
			} else if (str1[0] == "-2") {
				alert(t['02']);
				return;
			} else if (str1[0] == "0") {
				papmiidobj.value = str1[1];
				patnameobj.value = str1[2];
				regnoobj.value = str1[3];
			}
		}
		websys_setfocus('admsearch');
	}
}

function LookUpadmsearch(str) {
	var tmp1 = str.split("^");
	admsearchobj.value = tmp1[0];
	admidobj.value = tmp1[9];
}

function LookUpUser(str) {
	var obj = document.getElementById('userid');
	var tem = str.split("^");
	obj.value = tem[1];
}

function getuser() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		username_lookuphandler();
	}
}

function getadm() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		admsearch_lookuphandler();
	}
}

/**
* Creator: ZhYW
* CreatDate: 2018-01-19
* description: 清除操作员
*/
function clearUser() {
	var type = websys_$V("username");
	if (type == ""){
		DHCWebD_SetObjValueB("userid", "");
	}
}

document.body.onload = BodyLoadHandler;
