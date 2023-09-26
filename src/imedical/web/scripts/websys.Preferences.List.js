// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var LEconn=document.getElementById("LEconn").value;

function getRow(eSrc) {
	while(eSrc.tagName != "TR") {if (eSrc.tagName == "TH") break; eSrc=eSrc.parentElement;}
	return eSrc;
}
function TableClickHandler(evt) {
	var eSrc=websys_getSrcElement(evt);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var objRow=getRow(eSrc); var idxRow=objRow.rowIndex;
	if (eSrc.id.substring(0,5)=="Editz") {
		var arrType=document.getElementById("edittypez"+idxRow).value.split("^");
		var type=arrType[0];
		var prefid=document.getElementById("IDz"+idxRow).value;
		if (type.indexOf("LAYOUT")==0) {
			var arrPARAMS=GetPARAMS(arrType[3],arrType[4]);
			var params = arrPARAMS["User.SSUser"] + '^' + session['LOGON.CTLOCID'] + '^' + prefid;
			websys_Pref_layout(arrType[1],LEconn,arrType[2],params);
			//websys_Pref_layout(arrType[1],LEconn,arrType[2],params,1);
		} else if (type.indexOf("COLUMNS")==0) {
			//websys_createWindow('websys.component.customiselayout.csp?ID='+arrType[1]+'&CONTEXT='+arrType[2]+'&PREFID='+prefid);
			//allow multiple windows for comparisons
			websys_lu('websys.component.customiselayout.csp?ID='+arrType[1]+'&CONTEXT='+arrType[2]+'&PREFID='+prefid,false);
		} else if (type.indexOf("ORDER")==0) {
			alert("you cannot yet edit for : ORDER FAVOURITES");
		} else if (type.indexOf("RBRESOURCE")==0) {
			alert("you cannot yet edit for : RBRESOURCE PREFERENCES");
		}
		return false;
	}
}

//function websys_Pref_layout(compid,sconn,context,params,allowBlankContext) {
function websys_Pref_layout(compid,sconn,context,params) {
	try {
		websys_webedit=null;
		websys_webedit=new ActiveXObject("trakWebedit3.trakweb");
		if (!params) params=session['LOGON.USERID'] + '^' + session['LOGON.CTLOCID'];
		//if ((!allowBlankContext)&&(context=='')) context=session['CONTEXT'];
		//alert(params+":"+context);
		websys_webedit.ShowLayout(params,compid,context,sconn);
		websys_webedit=null;
	}
	catch (e) {
		alert(unescape(t['XLAYOUTERR']));
	}
}

function GetPARAMS(type,id) {
	var arr=new Array();
	arr["User.SSUser"]="";arr["User.SSGroup"]="";arr["User.CTLoc"]="";arr["User.CTHospital"]="";arr["User.PACTrust"]="";arr["SITE"]="";
	arr[type]=id;
	if (arr["User.SSUser"]=="") arr["User.SSUser"]=session['LOGON.USERID'];
	return arr;
}

var tbl=document.getElementById("twebsys_Preferences_List");
if (tbl) tbl.onclick=TableClickHandler;