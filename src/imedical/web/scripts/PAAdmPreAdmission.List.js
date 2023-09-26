//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var tbl=document.getElementById("tPAAdmPreAdmission_List");
var f=document.getElementById("fPAAdmPreAdmission_List");

//JW:6/5/02 run class method from component instead of passing through csp's

/*function SelectRowHandler() {
	//alert("entering select row handler");
	//If Contacted Column was clicked then perform status update.
	//If In UK Column was clicked then perform status update.
	var eSrc=window.event.srcElement;
	//alert(eSrc.tagName);
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	//alert(eSrc.tagName);
	var eSrcAry=eSrc.id.split("z");
	if (eSrcAry.length>0) {
		if (eSrcAry[0]=="PAADMPatientContacted") {
			//alert("contact");
			var Stat=f.elements['Contactedz'+eSrcAry[1]].value;
			var ID=f.elements['IDz'+eSrcAry[1]].value;
			websys_createWindow('paadm.changecontacted.csp?ID='+ID,window.name,'');
			return false;
		}
		if (eSrcAry[0]=="PAADMOverseasVisitor") {
			//alert("inuk");
			var Stat=f.elements['InUKz'+eSrcAry[1]].value;
			var ID=f.elements['IDz'+eSrcAry[1]].value;
			websys_createWindow('paadm.changeinuk.csp?ID='+ID,window.name,'');
			return false;
		}
	}
}

function CheckContactedLinks() {
	for (var i=1;i<tbl.rows.length;i++) {
		var obj=document.getElementById('PAADMPatientContactedz'+i);
		//alert(i+":"+obj);
		var contacted=document.getElementById('Contactedz'+i);
		//alert(i+":"+contacted.value);
		if (contacted.value=="Y") {
			obj.disabled=true;
			//alert(i+": Disabled");
		}
	}
}*/

//document.body.onload=CheckContactedLinks;

function SelectRowHandler() {
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var eSrcAry=eSrc.id.split("z");
	var rowObj=getRow(eSrc);
	var row=rowObj.rowIndex;
	if (eSrcAry.length>0) {
		//alert(eSrcAry[0])
		//JW: opens in new window - should not go through workflow
		if (eSrcAry[0]=="PAADMAdmDate") {
			var currentlink=eSrc.href.split("?");
			//alert(currentlink)
			var temp1=currentlink[1].split("&TWKFL")
			var temp2=currentlink[1].split("&EpisodeID")
			var url = "paadm.edit.csp" + "?" + temp1[0] + "&EpisodeID" + temp2[1];
			//var url = "paadm.edit.csp" + "?" + currentlink[1];
			websys_lu(url,false,"width=700,height=700,left=10,top=10")
			return false;
		}
	}
}

function getRow(eSrc) {
	while(eSrc.tagName != "TR") {
		if (eSrc.tagName == "TH") break;
		eSrc=eSrc.parentElement;
	}
	return eSrc;
}

function setRowClass(rowObj) {
	if (rowObj.rowIndex!=selectedRowObj.rowIndex) {
		rowObj.className='clsRowSelected';
		if (selectedRowObj.rowIndex%2==0 && selectedRowObj.rowIndex>0) {cName="RowEven";} else {cName="RowOdd";}
		selectedRowObj.className=cName;
		selectedRowObj=rowObj;
	}
}


var frm=document.forms["fPAAdmPreAdmission_List"];
var tbl=document.getElementById("tPAAdmPreAdmission_List");

try {if (tbl) tbl.onclick=SelectRowAdm;} catch(e) {}
try {if (tbl) tbl.onKeyPress=SelectRowAdm;} catch(e) {}

//function BodyLoadHandler()
//{
 //alert("start");
// var numRows=tbl.rows.length;
 //alert(numRows-1);
//}

//document.body.onload=BodyLoadHandler;	
