// Copyright (c) 2004 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var param1="";
var param2="";
var param3="";

var objPatId=document.getElementById("PatientID");
var objEpId=document.getElementById("EpisodeID");

function BodyLoadHandler() {

	var objBill=document.getElementById("Bill");
	if (objBill) {
		if (objEpId && objEpId.value!="") {
 			objBill.onclick=BillClickHandler;
		}
		else {
			objBill.disabled=true;
		}
	}
}

function SelectRowHandler(evt) {
	var tbl=document.getElementById("tARPatBill_BestPlanList");
	var f = document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var col="Selectz";

	var eSrc=websys_getSrcElement(evt);
	var rowObj=getRow(eSrc);
	var selRow=rowObj.rowIndex;
	
	// because of nested tables we need to adjust to reflect the correct row
	if (selRow!=1) selRow=selRow-parseInt(selRow/2);

	// can only select one row at a time, clear previous selections
	for (var i=1;i<tbl.rows.length;i++) {
		if (f.elements[col+i] && f.elements[col+i].checked && !f.elements[col+i].disabled) {
			if (i!=selRow) {
				f.elements[col+i].checked = false;
			}
		}
	}
}

function BillClickHandler(e) {

	var selected=0;
	var tbl=document.getElementById("tARPatBill_BestPlanList");
	var f = document.getElementById("f" + tbl.id.substring(1,tbl.id.length));

	selected = CheckSelectedRow(f,tbl,"Selectz");

	if (selected==0) {
		alert(t['NO_ROW_SELECTED']);
		return false;
	}
	var objRank=document.getElementById("RankStrz"+selected);
	var RankingParam="";
	if (objRank) RankingParam=objRank.value;

	param1=objEpId.value;
	param2=objPatId.value;
	param3=RankingParam;

	var objHiddenBill=document.getElementById("HiddenBill");
	if (objHiddenBill) objHiddenBill.onclick=objHiddenBill.onchange;
	if (objHiddenBill) objHiddenBill.click();
}

function HiddenBill_changehandler(encmeth) {
	//alert(encmeth+" "+param1+" "+param2+" "+param3);

	var retStr=cspRunServerMethod(encmeth,param1,param2,param3);

	var errMsg = parseMarkup(retStr,"<ERR>");
	if ((errMsg!="") && (errMsg!=null)) {
		alert(errMsg);
		return false;
	}

	var epNo = parseMarkup(retStr,"<OK>");
	if (epNo!="") alert("Episode " + epNo + " " + t['BILLED_OK']);
}

function parseMarkup(str,tag) {

	var endtag="</"+tag.substring(1,tag.length);

	if (str.search(tag)!= -1) {
		var i=str.indexOf(tag);
		var j=str.indexOf(endtag);
		var value = str.substring(i+ tag.length,j);
		return value;
	}
	return null;	
}

function PrintSelectedQuotesHandler(tblname,lnk,newwin) {

	var QuoteID=document.getElementById("QuoteID").value;
	var EpisodeID=document.getElementById("EpisodeID").value;

	if (tblname=="") {
		var eSrc=websys_getSrcElement();
		if(eSrc) var tbl=getTableName(eSrc);
	} else {
		var tbl=document.getElementById(tblname);
	}
	var f = document.getElementById("f"+tbl.id.substring(1,tbl.id.length));

	var selRow = CheckSelectedRow(f,tbl,"Selectz");
	if (selRow==0) {
		alert(t['NO_ROW_SELECTED']);
	} 
	else {
		if (newwin=="TRAK_hidden") {
			var hiddenwin=window.open('',newwin);
			with (hiddenwin) {
				document.writeln('<HTML><HEAD></HEAD><BODY>');
				document.writeln('<FORM name="HFORM" id="HFORM" method="POST" action="' + lnk + '">');
				document.writeln('<INPUT NAME="MULTI" VALUE="1">');
				document.writeln('<INPUT NAME="MULTIITEMS" VALUE="EpisodeID,QuoteID,ItmRowID,ItmPayorKey">');
				document.writeln('<INPUT NAME="EpisodeID" VALUE="' + EpisodeID + '">');
				document.writeln('<INPUT NAME="QuoteID" VALUE="' + QuoteID + '">');

				if ((f.elements["ItmRowIDz"+selRow].value!="") && (f.elements["ItmPayorKeyz"+selRow].value!="")) 
				{
					document.writeln('<INPUT NAME="ItmRowID" VALUE="' + f.elements["ItmRowIDz"+selRow].value + '">');
					document.writeln('<INPUT NAME="ItmPayorKey" VALUE="' + f.elements["ItmPayorKeyz"+selRow].value + '">');
				}

				document.writeln('</FORM><SCR'+'IPT>');
				document.writeln('window.HFORM.submit();');
				document.writeln('</SCR'+'IPT></BODY></HTML>');
				document.close();
			}
		} 
		else {
			if ((f.elements["ItmRowIDz"+selRow].value!="") && (f.elements["ItmPayorKeyz"+selRow].value!="")) {
				PassReportParametersForPreview(lnk,newwin,EpisodeID,QuoteID,f.elements["ItmRowIDz"+selRow].value,f.elements["ItmPayorKeyz"+selRow].value);
			}
		}
	}
	return false;
}

function CheckSelectedRow(f,tbl,col) {
	var found=0;
	for (var ic=1;ic<tbl.rows.length;ic++) {
		if (f.elements[col+ic] && f.elements[col+ic].checked && !f.elements[col+ic].disabled) {
			found=ic;
			break;
		}
	}

	return found;
}


document.body.onload=BodyLoadHandler;