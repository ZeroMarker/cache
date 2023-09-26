// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var PatientID="";
var EpisodeID="";
var MultiOverrideOrdItemId="";

var objPatientID=document.getElementById("PatientID");
if (objPatientID) PatientID=objPatientID.value;
	
var objEpisodeID=document.getElementById("EpisodeID");
if (objEpisodeID) EpisodeID=objEpisodeID.value;

// global arrays for nested tables (42518)
var accomTblAry = new Array;
var multiOvrAry = new Array;

ListAccomOrder.prototype.accomSelectAry;
ListAccomOrder.prototype.accomDateAry;
ListAccomOrder.prototype.table;
ListAccomOrder.prototype.id;
ListAccomOrder.prototype.selected=false;

function ListAccomOrder() {
	this.accomSelectAry = new Array;
	this.accomDateAry = new Array;
}

ListAccomOrder.prototype.set = function(tblid,tbl)
{
	this.id=tblid;
	this.table=tbl;
	this.table.id=tblid; // change the id
	this.table.tCompName="ARPatientBill_ListAccomOrder"; // set tCompName
}

ListAccomOrder.prototype.reset = function()
{
	this.accomSelectAry = null;
	this.accomDateAry = null;
	this.accomSelectAry = new Array;
	this.accomDateAry = new Array;
	this.selected = false;
}

ListAccomOrder.prototype.getSelectedSize = function()
{
    var size = 0;
    for (var i in this.accomSelectAry) {
        if (this.accomSelectAry[i] != null) size ++;
    }
    return size;
}

/**
 *
 */
function BodyLoadHandler() {

	var tbl=document.getElementById("tARPatientBill_ListOrderBill");
	if (tbl) tbl.tCompName=tbl.id.substring(1,tbl.id.length);

	// 42518
	var i=0;
	var tables=document.getElementsByTagName('TABLE');
	for (var j=0; j<tables.length; j++) {
		if (tables[j].id.indexOf("tARPatientBill_ListAccomOrder")==0) {
			var tblid="tARPatientBill_ListAccomOrder_z"+(++i);
			accomTblAry[tblid]= new ListAccomOrder();
			accomTblAry[tblid].set(tblid,tables[j]);
		}
	}

	ARPatBillListOrderBill_Translate();

	CheckCancelBill();
	
	AssignAccomOverrideClickHandler();
	
	//Log 44308 PeterC 29/06/04: Disable the "Cancel Bill" link if already cancelled
	var ICobj=document.getElementById("IsCancel");
	if((ICobj)&&(ICobj.value!="")) {
		var CBobj=document.getElementById("CancelBill");
		if(CBobj) {
			CBobj.disabled=true;		
			CBobj.onclick=BlankClickHandler;
		}
	}

	//53880
	var eponhold=document.getElementById("EpisodeOnHold");
	if (eponhold.value=='Y') SetupEpisodeOnHold();
}

function SetupEpisodeOnHold() {
	//53880 - disable menu items
	var divarr=document.getElementsByTagName("div");
	for (var i=0; i <divarr.length;i++) {
		if (divarr[i] && divarr[i].id && divarr[i].id.indexOf("tbMenuItem")!=-1) {
			divarr[i].disabled=true;
		}
	}
}

//52587
function getAccomCheckBox(tbl,row) {

	var cell; var achild;
	if (tbl.rows[row]) {
		for (var i=0; i < tbl.rows[row].cells.length; i++) {
			cell=tbl.rows[row].cells[i];
			achild=cell.children["AccomSelectz"+row];
			if (achild && achild.nodeName=='INPUT' && achild.getAttribute('type')=='checkbox')
				return achild;
		}
	}
	return null;
}

//52587
function getCellValue(tbl,row,cellId) {

	var cell; var achild;
	if (tbl.rows[row]) {
		for (var i=0; i < tbl.rows[row].cells.length; i++) {
			cell=tbl.rows[row].cells[i];
			achild=cell.children[cellId];
			if (achild) {
				//alert(cellId + " found " + achild.nodeName + " " +achild.getAttribute('type'));
				if (achild.nodeName=='LABEL')
					return cell.innerText;
				else if (achild.nodeName=='INPUT' && achild.getAttribute('type')=='checkbox')
					return achild.checked;
				else
					return achild.value;
			}
		}
	}
	return '';
}

function ARPatientBill_ListAccomOrder_SelectRowHandler(evt) {

	var eSrc=websys_getSrcElement(evt);
	var rowObj=getRow(eSrc);
	var selRow=rowObj.rowIndex;
	var tbl=getTable(eSrc);

	var aDate=getCellValue(tbl,selRow,"AccomDateToz"+selRow);

	//alert("tbl " + tbl.id);

	if (getCellValue(tbl,selRow,"AccomSelectz"+selRow))
	{ 
		// if checkbox is checked
		if (MultiOverrideOrdItemId!="" && MultiOverrideOrdItemId!=getCellValue(tbl,selRow,"AccomOrderItemIDz"+selRow)) {
			//alert("diff list selected");
			for (var i in accomTblAry) {
				if (accomTblAry[i].id!=tbl.id) {					
					for (var j in accomTblAry[i].accomSelectAry) {
						if (accomTblAry[i].accomSelectAry[j]!=null)
							accomTblAry[i].accomSelectAry[j].checked=false;
					}
					accomTblAry[i].reset();
				}
			}
		}

		accomTblAry[tbl.id].accomSelectAry["AccomSelectz"+selRow]=getAccomCheckBox(tbl,selRow);
		accomTblAry[tbl.id].selected=true;
		if (aDate!="") accomTblAry[tbl.id].accomDateAry[aDate]=aDate;
		MultiOverrideOrdItemId=getCellValue(tbl,selRow,"AccomOrderItemIDz"+selRow);
	}
	else {
		if (aDate!="") accomTblAry[tbl.id].accomDateAry[aDate]=null;
		accomTblAry[tbl.id].accomSelectAry["AccomSelectz"+selRow].checked=false;
		accomTblAry[tbl.id].accomSelectAry["AccomSelectz"+selRow]=null;
		if (accomTblAry[tbl.id].getSelectedSize()==0) MultiOverrideOrdItemId="";
	}
}

/**
 *  log 42518,52587
 */
function AssignAccomOverrideClickHandler() {
	
	var selIdx=0;
	var fld=document.getElementsByTagName('A');
	//alert("A " + fld.length);
	for (var j=0; j<fld.length; j++) {
		if (fld[j].id.indexOf("MultiOverride")==0) {
			multiOvrAry[selIdx]=fld[j];
			multiOvrAry[selIdx].onclick = AccomOverrideClickHandler;
			selIdx++;
		}
	}
}

/**
 *  log 42518,52587
 */
function AccomOverrideClickHandler(e) {

	var SelOverrideDates="";

	for (var i in accomTblAry) {
		if (accomTblAry[i].selected) {
			for (var j in accomTblAry[i].accomDateAry) {
				if (accomTblAry[i].accomDateAry[j]!=null)
					SelOverrideDates+=accomTblAry[i].accomDateAry[j]+"|";
			}
		}
	}

	//alert(SelOverrideDates);

	var url="websys.default.csp?WEBSYS.TCOMPONENT=ARChargesOverride.Edit&PatientID="+PatientID;
	url += "&IsAccomOrder=Y&OEOrderItemID="+MultiOverrideOrdItemId+"&EpisodeID="+EpisodeID+"&PatientBanner=1";
	url += "&SelOverrideDates="+SelOverrideDates;

	//alert(url);
        //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
	websys_createWindow(url,'child2','top=20,left=60,width=600,height=480,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');

	return false;
}

function BlankClickHandler() {
	return false;
}


function ARPatBillListOrderBill_Translate(e) {

	var tbl=document.getElementById("tARPatientBill_ListOrderBill");

	for (var i=1; i<tbl.rows.length; i++) {

		var objGST=document.getElementById("HidGSTz"+i);
		var GSTO=document.getElementById("GSTz"+i);
		if ((GSTO)&&(GSTO.innerText=="OUTTOT")) GSTO.innerText="";
		if (objGST) {
			var tot=objGST.value;
			if ((tot!="")&&(tot=="OUTTOT")) {
			
				if(tbl) {
					var tblLen=(tbl.rows.length)-1;
					var cell,cell1,cell2,row,cellbefore="";
					var index1,index2=1000000;
					var objPat=document.getElementById("PatTotalz"+i);
					var PayObj=document.getElementById("PayorTotalz"+i);
					if(objPat) cell1=websys_getParentElement(objPat);
					if(PayObj) cell2=websys_getParentElement(PayObj);
					if(cell1) index1=cell1.cellIndex;
					if(cell2) index2=cell2.cellIndex;

					if((index1<index2)&&(index1!=1000000)) cell=cell1
					else if(index2!=1000000) {cell=cell2;}
					if(cell) {
						row=websys_getParentElement(cell);
						if(tbl.rows[row.rowIndex].cells[cell.cellIndex-1]) tbl.rows[row.rowIndex].cells[cell.cellIndex-1].innerText=t['OUTTOT'];
					}
				}
			}
		}
	}
}

function ARPatientBill_ListOrderBill_SelectRowHandler(evt) {
	if (top.frames['eprmenu']) {
		var eSrc=websys_getSrcElement(evt);
		if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
		var rowObj=getRow(eSrc);
		var row=rowObj.rowIndex;
		if (eSrc.id.substring(0,15)=="ARChOverrideIDz") {
			websys_lu(eSrc.href,false,"top=20,left=60,width=600,height=480");
			return false;
		}
	}
}

//AJI 37343 
function OEStatusFilterLookupSelect(str) {	
	var lu=str.split("^");	
	var objOrdStatus=document.getElementById('OEStatus');
	if (objOrdStatus) objOrdStatus.value=lu[1]; //get the code
	//alert(objOrdStatus.value);
}

//37343 
function BillGroupFilterLookupSelect(str) {
	var lu=str.split("^");
	var objBillGroup=document.getElementById('BillGroupID');
	if (objBillGroup) objBillGroup.value=lu[1]; // get the id
}

//Log 51144 - 01.09.2006 - Get Billing Sub-group ID
function BillSubGroupLookupSelect(str) {
	var lu=str.split("^");
	var objBillSubGroup=document.getElementById('BillSubGrpID');
	if (objBillSubGroup) objBillSubGroup.value=lu[1]; // get the id
}

function CheckCancelBill() {
	
	var objTransType = document.getElementById('BillTransType'); //56373,58552 - disable if it's a credit note/refund
	var objBR = document.getElementById('BillRowIDz1');
	if ((objBR&&objBR.value=="")||(objTransType&&objTransType.value=="CREF")||(objTransType&&objTransType.value=="REF")) {
		var objCB=document.getElementById('CancelBill');
		if (objCB) {
			objCB.disabled=true;
			objCB.onclick=LinkDisable;
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

function PrintSelectedRowsHandler(tblname,lnk,newwin) {
	//alert(tblname);
	var found=0;
	if (tblname=="") {
		var eSrc=websys_getSrcElement();
		if(eSrc) var tbl=getTableName(eSrc);
	} else {
		var tbl=document.getElementById(tblname);
	}
	//if (tbl=="") tbl=document.getElementById("tARPatientBill_ListOrderBill");
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
	//HitCount var required to force Crystal Web Server to rerun query - see KnowledgeBase Article c2002771
	//Log 19666
	var HitCount=Math.round(Math.random() * 1000)
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
	} else {
		if (newwin=="TRAK_hidden") {
			//alert(newwin);
			var hiddenwin=window.open('',newwin);
			with (hiddenwin) {
				//alert("in hidden win");
				document.writeln('<HTML><HEAD></HEAD><BODY>');
				document.writeln('<FORM name="HFORM" id="HFORM" method="POST" action="' + lnk + '">');
				document.writeln('<INPUT NAME="MULTI" VALUE="1">');
				document.writeln('<INPUT NAME="MULTIITEMS" VALUE="PatientID,BillRowID">');
				// for each row selected
				for (i in aryfound) {
					var row=aryfound[i];
					// check for specific values - these values must be hidden in the component
					if (!f.elements["PatientIDz"+row]) continue;
					if (!f.elements["BillRowIDz"+row]) continue;
					if ((f.elements["BillRowIDz"+row].value!="")&&(f.elements["PatientIDz"+row].value!="")) {
						document.writeln('<INPUT NAME="PatientID" VALUE="' + f.elements["PatientIDz"+row].value + '">');
						document.writeln('<INPUT NAME="BillRowID" VALUE="' + f.elements["BillRowIDz"+row].value + '">');
					}
				}
				//Log 63924 - 08.06.2007 - to prevent stack overflow error
				//document.writeln('</FORM><SCR'+'IPT>');
				//document.writeln('window.HFORM.submit();');
				//document.writeln('</SCR'+'IPT></BODY></HTML>');
				document.writeln('</FORM></BODY></HTML>');
				document.close();
				document.HFORM.submit();	
				// End Log 63924 
			}
		}
	}
	return false;
}

//PeterC 13/12/2004 Log:47678
function PartialInvoiceSelectedRowsHandler(tblname,lnk,newwin) {
	var found=0;
	if (tblname=="") {
		var eSrc=websys_getSrcElement();
		if(eSrc) var tbl=getTableName(eSrc);
	} else {
		var tbl=document.getElementById(tblname);
	}
	var PartialInvoiceItemList="";
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
	//HitCount var required to force Crystal Web Server to rerun query - see KnowledgeBase Article c2002771
	//Log 19666
	var HitCount=Math.round(Math.random() * 1000)
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
	} else {
		if (newwin=="TRAK_hidden") {
			var hiddenwin=window.open('',newwin);
			with (hiddenwin) {
				document.writeln('<HTML><HEAD></HEAD><BODY>');
				document.writeln('<FORM name="HFORM" id="HFORM" method="POST" action="' + lnk + '">');
				document.writeln('<INPUT NAME="MULTI" VALUE="1">');
				document.writeln('<INPUT NAME="MULTIITEMS" VALUE="PartialInvoiceItemList">');
				// for each row selected
				for (i in aryfound) {
					var row=aryfound[i];
					var BillRowID,OEOrderItemID,objRowSel,selobj,arrfld="";				
					// check for specific values - these values must be hidden in the component
					if ((f.elements["BillTypez"+row])&&(f.elements["BillTypez"+row].value!="I")&&(f.elements["BillTypez"+row].value!="P")) {
						alert(t['PRNT_INVOICES']);
						return false;
					}
					if (f.elements["Selectz"+row]) selobj=f.elements["Selectz"+row];
					objRowSel=getRow(selobj);
					if (objRowSel) {
						arrfld=objRowSel.getElementsByTagName('INPUT');
						for (var j=0; j<arrfld.length; j++) {
							if (arrfld[j].id.indexOf("BillRowIDz")==0) {
								BillRowID=arrfld[j].value;
							}
							if (arrfld[j].id.indexOf("OEOrderItemIDz")==0) {
								OEOrderItemID=arrfld[j].value;
							}
						}
						if (BillRowID=="") continue;
						if (OEOrderItemID=="") continue;
						if ((BillRowID!="")&&(OEOrderItemID!="")) {
							PartialInvoiceItemList=PartialInvoiceItemList+OEOrderItemID+","+BillRowID+"^";
						}
					}
				}
				document.writeln('<INPUT NAME="PartialInvoiceItemList" VALUE="' + PartialInvoiceItemList + '">');
				document.writeln('</FORM><SCR'+'IPT>');
				document.writeln('window.HFORM.submit();');
				document.writeln('</SCR'+'IPT></BODY></HTML>');
			}
		}
	}
	return false;
}

function BodyUnLoadHandler() {
	if (window.opener && window.opener.parent.frames[2]){
		var win=window.opener.parent.frames[2];
		if (win) {
			if (win.name=="ListAll") win.treload('websys.csp');
		}
	}
	return true;
}

function check_closed()
{
	//Log 49893 16/02/05 PeterC: Make sure the system close all the child windows
	websys_closeWindows();

	if (document.all) {
		//var top=self.screenTop;
		//if (top>9000) 
		//Log 61699 - 23.11.2006 - need this so that ARPatientBill.ListOrderBill will not close when next/previous links are clicked
		if (window.event) {
           if (window.event.clientY < 0) {
				BodyUnLoadHandler();
			}
		}	
	}
}

document.body.onload=BodyLoadHandler;
document.body.onunload = check_closed;


