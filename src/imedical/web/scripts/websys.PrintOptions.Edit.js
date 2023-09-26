// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
function LookupSelectPrinter(str){
	//alert(str);
	var lu = str.split("^");
	var obj=document.getElementById('Printer');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('device');
	//if (obj) obj.value=lu[1];
	if (obj) obj.value=str;
	var objRecipient=document.getElementById('Recipient');
	if (objRecipient) {
		objRecipient.value= "";
	}
}

var objPrint=document.getElementById('Print');
var objReprint=document.getElementById('Reprint');
var objReprintID=document.getElementById('ReprintID');
if (objReprintID) {
	if (objPrint) {
		if (objReprintID.value != "" ) {
			objPrint.onclick=LinkDisable
			objPrint.disabled = true;
		} else {
			objPrint.disabled = false;
			objPrint.onclick=PrintClickHander;
		}
	}
	if (objReprint) {
		if (objReprintID.value != "" ) {
			objReprint.disabled = false;
			objReprint.onclick=ReprintClickHander;
		} else {
			objReprint.disabled = true;
			objReprint.onclick=LinkDisable;
		}

	}
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}

function ReprintClickHander(){
	Reprint_click();
	return false;
}

function PrintClickHander(){
	var url="";
	var repcode="";
	var rtarget="";
	var javascriptfn="";
	var device="";
	var noofcopies=0;
	var params="";
	var tbl="";
	var objurl=document.getElementById('url');
	if (objurl) url=objurl.value;
	var objtarget=document.getElementById('rtarget');
	if (objtarget) rtarget=objtarget.value;
	var objjavascriptfn=document.getElementById('javascriptfn');
	if (objjavascriptfn) javascriptfn=objjavascriptfn.value;
	var objdev=document.getElementById('device');
	if (objdev) device=objdev.value;
	var objnoofcopies=document.getElementById('NumberofCopies');
	if (objnoofcopies) noofcopies=objnoofcopies.value;
	var objparams=document.getElementById('params');
	if (objparams) params=objparams.value;
	var objtbl=document.getElementById('tablename');
	if (objtbl) tbl=objtbl.value;
	//if (device!="") device=CreateDevicePath(device);
	//build the url
	url=unescape(url) + "&device=" + device + "&noofcopies=" + noofcopies ;

	//alert("2, url = " + url);

	if ((window.opener)&&(window.opener.parent.frames[1])){
		var win=window.opener.parent.frames[1];
		//alert("3, win : " + win.name);
		if (win) {
			var formwcdft=win.document.forms['fwebcommon_DateFromTo_Custom'];
			if ((formwcdft)&&(javascriptfn!="")) {
				//alert("noofcopies=" + noofcopies + " ^ device=" + device );
				formwcdft.elements["noofcopies"].value=noofcopies;
				formwcdft.elements["device"].value=device;
				//alert("device="+device);
				javascriptfn = "window.opener." + javascriptfn + "()";
				//alert("javascriptfn="+ javascriptfn);
				Print_click();
				eval(javascriptfn);
				return false;
			}

			// Log 56620 - AI - 04-01-2006 : Set the NoOfCopies and Device variables on component webcommon.Report.Custom.
			var formwcr=win.document.forms['fwebcommon_Report_Custom'];
			if ((formwcr)&&(javascriptfn!="")) {
				//alert("noofcopies=" + noofcopies + " ^ device=" + device );
				formwcr.elements["noofcopies"].value=noofcopies;
				formwcr.elements["device"].value=device;
				//alert("device="+device);
			}
			// end Log 56620
		}
	}

	//alert("4 : " + javascriptfn);

	if (javascriptfn!=""){
		//alert("5, tbl * params = " + tbl + " * " + params);

		//For PrintSelectedRowsHandler pass tablename,url,target,params
		if (tbl!=""){
			if (params!=""){
				javascriptfn=javascriptfn + "('" + tbl + "','" + url + "','" + rtarget + "'," + params + ");"
			}else{
				javascriptfn=javascriptfn + "('" + tbl + "','" + url + "','" + rtarget + "');"
			}
		}else{
		//For PassReportParameters pass url,target,params - called from webcommon.DateFromTo.Custom component.
			if (params!=""){
				javascriptfn=javascriptfn + "('" + url + "','" + rtarget + "'," + params + ");"
			}else{
				javascriptfn=javascriptfn + "('" + url + "','" + rtarget + "');"
			}
		}
		if (window.opener) javascriptfn = "window.opener." + javascriptfn;
		//alert("6, js function: "+javascriptfn);
		Print_click();
		eval(javascriptfn);
	}else{
		//alert("7, url = "+url);
		websys_createWindow(url,rtarget);
	}
	Print_click();
	return false;
}
