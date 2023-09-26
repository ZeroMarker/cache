///UDHCJFdeptsearch.js

var path, guser, gusername;
var curdate, flag;
var userflag;

function BodyLoadHandler() {
	guser = session['LOGON.USERID'];
	gusername = session['LOGON.USERNAME'];
	userflag = websys_$V("userflag");
	var userObj = websys_$("user");
	if (userObj){
		userObj.onkeyup = clearUser;
	}
	/*
	var prt = websys_$("Print");
	if (prt) {
		prt.onclick = Print_click;
	}
	initformat();
	*/
	
}

function initformat() {
	var userobj = websys_$("user");
	var useridobj = websys_$("userid");
	var Myobj = websys_$("Myid");
	if (Myobj) {
		var imgname = "ld" + Myobj.value + "i" + "user";
		var userobj1 = websys_$(imgname);
	}
	if (userflag == "0") {
		userobj.readOnly = true;
		userobj1.style.display = "none";
		userobj.value = gusername;
		useridobj.value = guser;
	} else {
		userobj.readOnly = false;
		userobj1.style.display = "";
		userobj.value = "";
		useridobj.value = "";
	}
}

function getuserid(value) {
	var myAry = value.split("^");
	DHCWebD_SetObjValueB("userid", myAry[1]);
}

function paymodelookup(value) {
	var myAry = value.split("^");
	DHCWebD_SetObjValueB("paymoderowid", myAry[1]);
}

function clearUser() {
	var user = websys_$V("user");
	if (user == ""){
		DHCWebD_SetObjValueB("userid", "");
	}
}

function UnloadHandler() {
	var encmeth = DHCWebD_GetObjValue("KillTmp");
	var mytmp = cspRunServerMethod(encmeth, guser, job);
}

document.body.onload = BodyLoadHandler;
document.body.onbeforeunload = UnloadHandler;
