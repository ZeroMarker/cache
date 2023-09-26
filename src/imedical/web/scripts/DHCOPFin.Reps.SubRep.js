////DHCOPFin.Reps.SubRep.js

////BJSST Hospital  Reports

var m_CatItem=new Array();

function BodyLoadHandler()
{
	////
	
	var obj=document.getElementById("bPrint");
	if (obj){
		obj.onclick=bPrint_OnClick;
	}
	var obj=document.getElementById("OEPPrint");
	if (obj){
		obj.onclick=OEPPrint_OnClick;
	}
	
	IntDoc();
}

function IntDoc()
{
	var myCode="";
	var obj=document.getElementById("OPTypeDesc");
	if(obj){
		obj.readOnly=true;
	}
	
	var myCode=DHCWebD_GetObjValue("OPType");
	if(myCode!=""){
		var obj=document.getElementById("OPTypeDesc");
		if (obj){
			obj.value=t[myCode];
		}
	}
	
	var myUserDR=DHCWebD_GetObjValue("UserDR");
	var myGroupDR=DHCWebD_GetObjValue("GroupDR");
	var myStDate=DHCWebD_GetObjValue("StDate");
	var myEndDate=DHCWebD_GetObjValue("EndDate");
	var mysttime=0;
	var myEndTime=0;
	
	var myEncrypt=DHCWebD_GetObjValue("ReadOEPINVEncrypt");
	if (myEncrypt!=""){
		////(hUser, stdate, sttime, EndDate, EndTime, GroupDR)
		var myInfo=cspRunServerMethod(myEncrypt, myUserDR, myStDate, mysttime, myEndDate, myEndTime, myGroupDR);
		var myINVAry=myInfo.split(String.fromCharCode(1));
		var myTotInfo=myINVAry[0];
		var myTotAry=myTotInfo.split("^");
		////Num  Info
		DHCWebD_SetObjValueC("OEPINVNum",myTotAry[0]);
		DHCWebD_SetObjValueC("OEPINVInfo",myTotAry[1]);
		DHCWebD_SetObjValueC("OEPParkINVNum",myTotAry[2]);
		DHCWebD_SetObjValueC("OEPParkINVInfo",myTotAry[3]);
		DHCWebD_SetObjValueC("OEPRefINVNum",myTotAry[4]);
		DHCWebD_SetObjValueC("OEPRefINVInfo",myTotAry[5]);
	}
}

function bPrint_OnClick(){
	PrintClickHandler();
}

function OEPPrint_OnClick(){
	OEPPrintClickHandler();
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

function OEPPrintClickHandler(){
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
	    var Template=TemplatePath+"JSTOEPFootHZSubRep.xls";
	    
	    var TabObj=document.getElementById("tDHCOPFin_Reps_SubRep");
		///if (isNaN(CashNUM)){CashNUM=0;}
		///myTotlNum=myTotlNum+parseFloat(CashNUM);
		
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    var myRows=TabObj.rows.length;
	    var xlsrow=4;
	    var xlscol=1;
	    var xlsCurcol=1;
	    ///
		var myOPTypeDesc=DHCWebD_GetObjValue("OPTypeDesc");
		xlsheet.cells(1,2)=myOPTypeDesc;
		
		var objtbl=document.getElementById("tDHCOPFin_Reps_SubRep");
		var Rows=objtbl.rows.length;
		var firstRow=objtbl.rows[0];
		///alert(firstRow);
		var RowItems=firstRow.all;
	    
	    for (var Row=1;Row<myRows;Row++){
			xlsrow=xlsrow+1;
			var listobj=document.getElementById("FinRefSumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,2)=myval;
			var listobj=document.getElementById("FinItemz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,5)=myval;
			
			var listobj=document.getElementById("FinGetSumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,8)=myval;
	    }
		
		gridlist(xlsheet,5,xlsrow,2,10)
		
		var BDate=DHCWebD_GetObjValue("StDate");
		var EDate=DHCWebD_GetObjValue("EndDate");
		var encmeth=DHCWebD_GetObjValue("GetOtherInfo");
		var mystr=cspRunServerMethod(encmeth, BDate, EDate, 0);
		var myary=mystr.split("^");
		///alert(mystr);
		xlsheet.cells(3,3)=myary[0];   ////+" -- "+myary[2];
	   	///xlsheet.cells(31,3)=TCashSum;
	   	///xlsheet.cells(31,6)=TCheckSum;
	   	///xlsheet.cells(31,9)=TBankSum;
	   	///xlsheet.cells(32,3)=TTSum;
		
		var myval=DHCWebD_GetObjValue("OEPParkINVNum");
		xlsheet.cells(xlsrow+2,3)=myval;

		var myval=DHCWebD_GetObjValue("OEPRefINVNum");
		xlsheet.cells(xlsrow+2,8)=myval;
		
	   	xlsheet.cells(xlsrow+4,3)=session['LOGON.USERNAME'];
		var myCurDate=DHCWebD_GetObjValue("CurDate");
	    xlsheet.cells(xlsrow+4,8)=myCurDate;
	    
	    xlsheet.printout
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet=null
	} catch(e) {
		alert(e.message);
	};
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
	    var Template=TemplatePath+"JSTOPFootSubItemRep.xls";
	    
	    var TabObj=document.getElementById("tDHCOPFin_Reps_SubRep");
		///if (isNaN(CashNUM)){CashNUM=0;}
		///myTotlNum=myTotlNum+parseFloat(CashNUM);
		
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    var myRows=TabObj.rows.length;
	    var xlsrow=4;
	    var xlscol=1;
	    var xlsCurcol=1;
	    ///
		var myOPTypeDesc=DHCWebD_GetObjValue("OPTypeDesc");
		xlsheet.cells(1,2)=myOPTypeDesc;
		
		var objtbl=document.getElementById("tDHCOPFin_Reps_SubRep");
		var Rows=objtbl.rows.length;
		var firstRow=objtbl.rows[0];
		///alert(firstRow);
		var RowItems=firstRow.all;
	    
	    for (var Row=1;Row<myRows;Row++){
			xlsrow=xlsrow+1;
			var listobj=document.getElementById("FinRefSumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,2)=myval;
			var listobj=document.getElementById("FinItemz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,5)=myval;
			
			var listobj=document.getElementById("FinGetSumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,8)=myval;
	    }
		
		gridlist(xlsheet,5,xlsrow,2,10)
		
		var BDate=DHCWebD_GetObjValue("StDate");
		var EDate=DHCWebD_GetObjValue("EndDate");
		var encmeth=DHCWebD_GetObjValue("GetOtherInfo");
		var mystr=cspRunServerMethod(encmeth, BDate, EDate, 0);
		var myary=mystr.split("^");
		///alert(mystr);
		xlsheet.cells(3,3)=myary[0]+" -- "+myary[2];
	   	///xlsheet.cells(31,3)=TCashSum;
	   	///xlsheet.cells(31,6)=TCheckSum;
	   	///xlsheet.cells(31,9)=TBankSum;
	   	///xlsheet.cells(32,3)=TTSum;
	   	xlsheet.cells(xlsrow+2,3)=session['LOGON.USERNAME'];
		var myCurDate=DHCWebD_GetObjValue("CurDate");
	    xlsheet.cells(xlsrow+2,8)=myCurDate;
	    
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

