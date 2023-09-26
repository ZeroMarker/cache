////DHCOPFin.Reps.BJJSTRepPrint.js

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
	var obj=document.getElementById("OPType");
	if (obj){
		obj.readOnly=true;
	}
	var myUserDR=DHCWebD_GetObjValue("UserDR");
	var myGroupDR=DHCWebD_GetObjValue("GroupDR");
	var myStDate=DHCWebD_GetObjValue("StDate");
	var myEndDate=DHCWebD_GetObjValue("EndDate");
	var mysttime=0;
	var myEndTime=0;
	var myHISRowID=DHCWebD_GetObjValue("HISRowID");
	var myEncrypt=DHCWebD_GetObjValue("ReadOEPINVEncrypt");
	if (myEncrypt!=""){
		////(hUser, stdate, sttime, EndDate, EndTime, GroupDR)
		var myInfo=cspRunServerMethod(myEncrypt, myHISRowID);
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
		DHCWebD_SetObjValueC("StDate",myTotAry[6]);
		DHCWebD_SetObjValueC("StTime",myTotAry[7]);
		DHCWebD_SetObjValueC("EndDate",myTotAry[8]);
		DHCWebD_SetObjValueC("EndTime",myTotAry[9]);
		DHCWebD_SetObjValueC("UserName",myTotAry[10]);
		
	}
}

function bPrint_OnClick(){
	PrintClickHandler();
}

function OEPPrint_OnClick(){
	OEPPrintClickHandler();
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
	    ///var Template=TemplatePath+"JSTOEPFootHZSubRep.xls";
	    var Template=TemplatePath+"JSTOEPFootOperDailyRep.xls";
	    
	    var TabObj=document.getElementById("tDHCOPFin_Reps_BJJSTRepPrint");
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
		var myOPTypeDesc=DHCWebD_GetObjValue("OPType");
		///xlsheet.cells(1,2)=myOPTypeDesc;
		
		var objtbl=document.getElementById("tDHCOPFin_Reps_BJJSTRepPrint");
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
		var myBTime=DHCWebD_GetObjValue("StTime");
		var myETime=DHCWebD_GetObjValue("EndTime");
		///var encmeth=DHCWebD_GetObjValue("GetOtherInfo");
		///var mystr=cspRunServerMethod(encmeth, BDate, EDate, 0);
		///var myary=mystr.split("^");
		///alert(mystr);
		xlsheet.cells(3,3)=BDate+" "+myBTime +" ---- "+EDate+" "+myETime;
	   	///xlsheet.cells(31,3)=TCashSum;
	   	///xlsheet.cells(31,6)=TCheckSum;
	   	///xlsheet.cells(31,9)=TBankSum;
	   	///xlsheet.cells(32,3)=TTSum;
	   	var myval=DHCWebD_GetObjValue("OEPINVInfo");
	   	xlsheet.cells(xlsrow+2,3)=myval;
	   	
	   	var myOEPParkINVNum=DHCWebD_GetObjValue("OEPParkINVNum");
	   	var myOEPRefINVNum=DHCWebD_GetObjValue("OEPRefINVNum");
	   	xlsheet.cells(xlsrow+5,3)=myOEPParkINVNum;
	   	xlsheet.cells(xlsrow+5,8)=myOEPRefINVNum;
	   	
	   	xlsheet.cells(xlsrow+7,3)=session['LOGON.USERNAME'];
		var myCurDate=DHCWebD_GetObjValue("CurDate");
	    xlsheet.cells(xlsrow+7,8)=myCurDate;
	    
	   	var myUserName=DHCWebD_GetObjValue("UserName");
	    xlsheet.cells(xlsrow+9,3)=myUserName;
	    
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
	    var Template=TemplatePath+"JSTOEPFootOperDailyRep.xls";
	    
	    var TabObj=document.getElementById("tDHCOPFin_Reps_BJJSTRepPrint");
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
		var myOPTypeDesc=DHCWebD_GetObjValue("OPType");
		xlsheet.cells(1,2)=myOPTypeDesc;
		
		var objtbl=document.getElementById("tDHCOPFin_Reps_BJJSTRepPrint");
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
		///var encmeth=DHCWebD_GetObjValue("GetOtherInfo");
		///var mystr=cspRunServerMethod(encmeth, BDate, EDate, 0);
		///var myary=mystr.split("^");
		///alert(mystr);
		xlsheet.cells(3,3)=BDate+" -- "+EDate;
	   	///xlsheet.cells(31,3)=TCashSum;
	   	///xlsheet.cells(31,6)=TCheckSum;
	   	///xlsheet.cells(31,9)=TBankSum;
	   	///xlsheet.cells(32,3)=TTSum;
	   	var myval=DHCWebD_GetObjValue("OEPINVInfo");
	   	xlsheet.cells(xlsrow+2,3)=myval;
	   	var myUserName=DHCWebD_GetObjValue("UserName");
	   	xlsheet.cells(xlsrow+5,3)=myUserName;
		var myCurDate=DHCWebD_GetObjValue("CurDate");
	    xlsheet.cells(xlsrow+5,8)=myCurDate;
	    
	    
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


