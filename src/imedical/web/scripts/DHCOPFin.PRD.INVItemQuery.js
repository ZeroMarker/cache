////DHCOPFin.PRD.INVItemQuery.js

var m_CatItem=new Array();

function BodyLoadHandler()
{
	InitialCAT();
	////
	///ReadFootSum();
	
	var obj=document.getElementById("Print");
	if (obj){
		obj.onclick=Print_OnClick;
	}
}

function Print_OnClick(){
	PrintClickHandler();
}

function ReadFootSum(){
	var myBDate=DHCWebD_GetObjValue("StDate");
	var myEDate=DHCWebD_GetObjValue("EndDate");
	var encmeth=DHCWebD_GetObjValue("ReadSumEncrypt");
	if (encmeth!=""){
		var myrtn=cspRunServerMethod(encmeth,myBDate, myEDate);
		////0_"^"_myCashSum_"^"_myCheckSum_"^"_myCredPaySum_"^"_myOtherPaySum_"^"_myTSum
		var mystr=myrtn.split("^");
		DHCWebD_SetObjValueB("AcCashSum",mystr[1]);
		DHCWebD_SetObjValueB("AcCheckSum",mystr[2]);
		DHCWebD_SetObjValueB("CredCardSum",mystr[3]);
		DHCWebD_SetObjValueB("OtherPayMode",mystr[4]);
		DHCWebD_SetObjValueB("TotSum",mystr[5]);
		DHCWebD_SetObjValueB("ItemLen",mystr[6])
		///alert(mystr[6]);
		///
	}
}

function InitialCAT()
{
	///unescape
	var obj=document.getElementById("uName");
	if (obj){
		////alert(obj.value);
		obj.value=unescape(obj.value);
	}
	var catobj=document.getElementById("getOPCAT");
	if (catobj) {var encmeth=catobj.value} else {var encmeth=''};
	var catinfo=cspRunServerMethod(encmeth);
	var objtbl=document.getElementById("tDHCOPFin_PRD_INVItemQuery");
	var Rows=objtbl.rows.length;
	var firstRow=objtbl.rows[0];
	///alert(firstRow);
	var RowItems=firstRow.all;
	///alert(catinfo);
	var cattmp =catinfo.split("^");
	var catnum=cattmp.length;
	for (var i=1;i<=catnum;i++)
	{
		var ColName="cat"+i;
		for (var j=0;j<RowItems.length;j++) 
		{
			if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH'))
			{
				RowItems[j].innerHTML=cattmp[i-1];
			}
		}
	}
	
	for (var i=catnum+1;i<=20;i++){
		HiddenTblColumn(objtbl,"cat"+i,i);
	}
}

function HiddenTblColumn(tbl,ColName,ColIdx){
	///
	///
	var row=tbl.rows.length;
	var firstRow=tbl.rows[0];
	var RowItems=firstRow.all;
	
	for (var j=0;j<RowItems.length;j++) {
		///alert(RowItems[j].childNodes.length);
		///if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH')) {
		if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH')) {
			RowItems[j].style.display="none";
		} else {
		}
	}

	row=row-1;
	for (var j=1;j<row+1;j++) {
		var sLable=document.getElementById("TCAT"+ColIdx+'z'+j);
		var sTD=sLable.parentElement;
		sTD.style.display="none";
	}
}

function AddTblColumn(tbl,CopeName)	{
	///
	///
	var row=tbl.rows.length;
	var firstRow=tbl.rows[0];
	var RowItems=firstRow.all;
	
	var mylen=RowItems.length;
	var lastcolobj=RowItems[mylen-1];
	
	var newcolobj=lastcolobj.cloneNode(true);

	newcolobj=firstRow.appendChild(newcolobj);
	newcolobj.id=mylen;
	newcolobj.innerHTML="Else"
	for (var j=1;j<row;j++) {
		var sLable=document.getElementById("TCAT11z"+j);
		var sTD=sLable.parentElement;
		var otRowObj=tbl.rows[j];
		var newcolobj=sTD.cloneNode(true);
		
		newcolobj=otRowObj.appendChild(newcolobj);
	}
}

function WrtList(ListVal){
	var myary=ListVal.split("^");
	var TabObj=document.getElementById("tDHCOPFin_InsFoot");
	var bodylistOPOE=window.document;
	DHCWebD_AddTabRow(TabObj)
	var Row=TabObj.rows.length-2;
	
	var listobj=document.getElementById("Noz"+Row);
	DHCWebD_SetListValueA(listobj,myary[0]);
	var listobj=document.getElementById("UserNamez"+Row);
	DHCWebD_SetListValueA(listobj,myary[1]);
	var listobj=document.getElementById("CashSumz"+Row);
	DHCWebD_SetListValueA(listobj,myary[2]);
	var listobj=document.getElementById("ChequesSumz"+Row);
	DHCWebD_SetListValueA(listobj,myary[3]);
	var listobj=document.getElementById("BankSumz"+Row);
	DHCWebD_SetListValueA(listobj,myary[4]);
	var listobj=document.getElementById("Sumz"+Row);
	DHCWebD_SetListValueA(listobj,myary[5]);
	
	bodylistOPOE.scrollTop=bodylistOPOE.scrollHeight-bodylistOPOE.clientHeight-35;
	
}

function DelTabRow(){
	var TabObj=document.getElementById("tDHCOPFin_ItemColQuery");
	while (TabObj.rows.length>2){
		TabObj.deleteRow(1);
		DHCWebD_ResetRowItems(TabObj);
	}
	
}

function PrintClickHandler(){
	try {
		var GetPrescPath=document.getElementById("GetRepPath");
		if (GetPrescPath) {var encmeth=GetPrescPath.value} else {var encmeth=''};
		if (encmeth!="") {
			TemplatePath=cspRunServerMethod(encmeth);
		}
        var BeginDate,EndDate;
        var CashSum,CheckSum,BankSum, TSum;
        var UserCode="";
		
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"HospOPFinItemQuery.xls";
	    
	    var TabObj=document.getElementById("tDHCOPFin_ItemColQuery");
		///if (isNaN(CashNUM)){CashNUM=0;}
		///myTotlNum=myTotlNum+parseFloat(CashNUM);
		
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    var myRows=TabObj.rows.length;
	    var xlsrow=5;
	    var xlscol=5;
	    var xlsCurcol=1;
	    var myItemLen=DHCWebD_GetObjValue("ItemLen");
	    if (isNaN(myItemLen)){
		    myItemLen=0;
	    }
	    myItemLen=parseInt(myItemLen);
	    ///
		var catobj=document.getElementById("getOPCAT");
		if (catobj) {var encmeth=catobj.value} else {var encmeth=''};
		var catinfo=cspRunServerMethod(encmeth);
		var objtbl=document.getElementById("tDHCOPFin_ItemColQuery");
		var Rows=objtbl.rows.length;
		var firstRow=objtbl.rows[0];
		///alert(firstRow);
		var RowItems=firstRow.all;
		///alert(catinfo);
		var cattmp =catinfo.split("^");
	    for (myidx=0;myidx<myItemLen;myidx++){
		    xlsheet.cells(xlsrow,4+myidx)=cattmp[myidx];
	    }
	    xlsheet.cells(xlsrow,4+myItemLen)=t["HJ"];
	    xlsheet.cells(xlsrow,5+myItemLen)=t["JZSR"];
	    xlsheet.cells(xlsrow,6+myItemLen)=t["SKSR"];
	    
	    for (var Row=1;Row<myRows;Row++){
			xlsrow=xlsrow+1;
			var listobj=document.getElementById("UserNamez"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+1)=myval;
			var listobj=document.getElementById("RepRowIDz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+2)=myval;
			
			for (var itmIdx=1;itmIdx<=myItemLen;itmIdx++){
				var listobj=document.getElementById("TCAT"+itmIdx.toString()+"z"+Row);
				var myval=DHCWebD_GetCellValue(listobj);
				xlsheet.cells(xlsrow,xlsCurcol+2+itmIdx)=myval;
			}
			
			var listobj=document.getElementById("TSumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+3+myItemLen)=myval;
			
			var listobj=document.getElementById("InsSumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+4+myItemLen)=myval;

			var listobj=document.getElementById("PatShareSumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+5+myItemLen)=myval;
			
	    }
		
		gridlist(xlsheet,5,xlsrow,2,xlsCurcol+5+myItemLen)
		
		var BDate=DHCWebD_GetObjValue("StDate");
		var EDate=DHCWebD_GetObjValue("EndDate");
		var encmeth=DHCWebD_GetObjValue("GetOtherInfo");
		var mystr=cspRunServerMethod(encmeth, BDate, EDate, 0);
		var myary=mystr.split("^");
		///alert(mystr);
		xlsheet.cells(4,4)=myary[0];
	   	///xlsheet.cells(31,3)=TCashSum;
	   	///xlsheet.cells(31,6)=TCheckSum;
	   	///xlsheet.cells(31,9)=TBankSum;
	   	///xlsheet.cells(32,3)=TTSum;
	   	xlsheet.cells(4,12)=session['LOGON.USERNAME'];
	   	///xlsheet.cells(29,8)=myary[1];
	   	///xlsheet.cells(32,8)=myary[1];
	   	xlsheet.cells(4,18)=myary[2];
	   	
	   	xlsheet.cells(xlsrow+2,3)=t["AcCashSum"];
	   	var myval=DHCWebD_GetObjValue("AcCashSum");
	   	xlsheet.cells(xlsrow+2,4)=myval;
	   	xlsheet.cells(xlsrow+2,5)=t["AcCheckSum"];
	   	var myval=DHCWebD_GetObjValue("AcCheckSum");
	   	xlsheet.cells(xlsrow+2,6)=myval;
	   	xlsheet.cells(xlsrow+2,7)=t["CredCardSum"];
	   	var myval=DHCWebD_GetObjValue("CredCardSum");
	   	xlsheet.cells(xlsrow+2,8)=myval;
	   	xlsheet.cells(xlsrow+2,9)=t["OtherPayMode"];
	   	var myval=DHCWebD_GetObjValue("OtherPayMode");
	   	xlsheet.cells(xlsrow+2,10)=myval;
	   	xlsheet.cells(xlsrow+2,13)=t['TotSum']
	   	var myval=DHCWebD_GetObjValue("TotSum");
	   	xlsheet.cells(xlsrow+2,14)=myval;
	   	
	    xlsheet.printout
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet=null
	} catch(e) {
		alert(e.message);
	};
}

function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
}

document.body.onload = BodyLoadHandler;
