//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
function validateActionTransfer() {
	var eSrc=websys_getSrcElement(window.event.srcElement);
	while (eSrc.parentElement) {
		if (eSrc.tagName!="A") eSrc=eSrc.parentElement;
		if (eSrc.tagName=="A") break;
	}
	if (eSrc.id=="NewTransfer") {var origcode=transfer;}
	if (document.getElementById("VisitStatus").value=="A") {
		// cjb 16/07/2003 37169.  If any of the episodes have been coded, and the User clicks New, display the warning message
		if (objcoded1.value==1) {
			var objconfirm=t['NewCoded']
			if (confirm(objconfirm)){
				
				if (typeof origcode!="function") origcode=new Function(origcode);
				if(origcode()==false) return false;
				return false;
			}
		} else {
			if (typeof origcode!="function") origcode=new Function(origcode);
			if(origcode()==false) return false;
			return false;
		}
	} else {
		alert(t['NotAdmitted'])
		return false;
	}
	return true;
}

var transfer="";
var obj=document.getElementById("NewTransfer");
if (obj) {
	mandt=obj.onclick;
	transfer=obj.onclick;
	obj.onclick=validateActionTransfer;
}


var frm=document.forms["fPAAdmTransaction_Transfer_List"];
var tbl=document.getElementById("tPAAdmTransaction_Transfer_List");
var f1=document.getElementById("fPAAdmTransaction_Transfer_List");

var admType=document.getElementById("admType");
//if (admType&&admType.value!="I") { 
	//disableLinks()
	//for (var j=0;j<tbl.rows.length;j++) {
	    //tbl.rows[j].className="clsRowDisabled";
		//tbl.rows[j].selectenabled=0;
 // }
 //} 

try {if (tbl) tbl.onclick=SelectRowTrans;} catch(e) {}

// CJB 26699 05082002
// see PAAdmTransaction.Movement.List.js for comments

var objsent1="";
var objcoded1="";
var objmessage="";
var warned="";

var objcoded1=document.getElementById('Coded1');
var objsent1=document.getElementById('Sent1');

// build up the message to display
if (objsent1.value=="1") var objmessage=t['Sent']+"\n";
if (objcoded1.value=="1") var objmessage=objmessage+t['Coded']+"\n";
if (objmessage!="") var objmessage=objmessage+"\n"+t['SentCodedMsg'];

function SelectRowHandler(evt) {	
//var admType=document.getElementById("admType");
//if (admType&&admType.value!="I") { return false }
 var eSrc=websys_getSrcElement(evt);	
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);		
	var eSrcAry=eSrc.id.split("z");
	var rowObj=getRow(eSrc)
	var row=rowObj.rowIndex; 
	var currentlink=eSrc.href;
	var temp1=currentlink.split("&TWKFL");
	var temp2=currentlink.split("&ID");
	var url = temp1[0] + "&ID" + temp2[1];
	var VisitStatus=document.getElementById("VisitStatus");
	var WaitList=document.getElementById("PAADMWaitListDR");
	var objID=document.getElementById('TRANSRowID2z'+eSrcAry[1]);
	var FirstTransT=document.getElementById("FirstTransT");
	
	// *** Code in PAAdmTransaction.Movement.List.js has some functionality as the below plus more..
	// this works because the movement list loads after this list, will have to put it here aswell if we seperate the lists later..
	
	if (eSrcAry.length>1) {
		if ((eSrcAry[0]=="edit")||(eSrcAry[0]=="edit1")) {
		
			if ((objsent1.value=="1") || (objcoded1.value=="1")) {
				if (confirm(objmessage)){
					var warned="E";
					websys_createWindow(url+"&warned="+warned,"testname","top=80,left=180,width=420,height=400,scrollbars=yes,resizable=yes");
				}else{
					//alert(false)
				}
				//return false;
			} else {
				var objType1=document.getElementById('TransType1z'+eSrcAry[1]);
				
				if ((objType1.value=="B")&&(eSrcAry[0]=="edit")) {
					alert(t['PreAdmDelEdit']);
				} else {
					websys_createWindow(url,"testname","top=80,left=180,width=420,height=400,scrollbars=yes,resizable=yes");
				}
				//websys_createWindow(url,"testname","top=80,left=180,width=420,height=400,scrollbars=yes,resizable=yes");
				//return false; 
			}
			return false; 
  		}
		if (eSrcAry[0]=="delete1") {
			if ((objsent1.value=="1")||(objcoded1.value=="1")) {
				if (confirm(objmessage)){
					var warned="D"
					eSrc.href+="&warned="+warned
					return true;
				}else{
					return false;
				}
			}
			if ((WaitList)&&(WaitList.value!="")&&(FirstTransT)&&(objID)&&(FirstTransT.value==objID.value)) {
				alert(t["WaitListTCI"]);
				return false;
			}
			return true;
  		}
	} 
}

// CJB end 26699 05082002
function disableLinks() {
var fld=document.getElementsByTagName('A');
	for (var j=0; j<fld.length; j++) {
		fld[j].disabled=true;
		fld[j].onclick=LinkDisable;
		}
}
function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) { 
		return false;
	}
	return true;
}


