////DHCOPFin.InsFoot.js


function bodyLoadHandler(){
	//alert("");
	
	var obj=document.getElementById("Refresh");
	if (obj){
		obj.onclick=Refresh_OnClick;
	}
	var obj=document.getElementById("Print");
	if (obj){
		obj.onclick=Print_OnClick;
	}

	///IntDoc();
}

function Print_OnClick(){
	PrintClickHandler();
}

function Refresh_OnClick(){
	//IntDoc();
	
	DelTabRow();
	
	var encmeth=DHCWebD_GetObjValue("GetListEncrypt");
	var BDate=DHCWebD_GetObjValue("BDate");
	var BTime=DHCWebD_GetObjValue("BTime");	
	var EDate=DHCWebD_GetObjValue("EDate");
	var ETime=DHCWebD_GetObjValue("ETime");	
	
	var mystr=cspRunServerMethod(encmeth,"WrtList", BDate, BTime, EDate, ETime);
	
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPFin.InsFoot";
	//window.location.href=lnk;
}

function IntDoc(){

	var obj=document.getElementById("BDate");
	if (obj){
		obj.readOnly=true;
	}
	
	var obj=document.getElementById("EDate");
	if (obj){
		obj.readOnly=true;
	}
	///
	var obj=document.getElementById("BTime");
	if (obj){
		obj.readOnly=true;
	}

	var obj=document.getElementById("ETime");
	if (obj){
		obj.readOnly=true;
	}
	
	//var encmeth=DHCWebD_GetObjValue("ReadDateEncrypt");
	//var mystr=cspRunServerMethod(encmeth);
	//var myary=mystr.split("^");
	
	//DHCWebD_SetObjValueA("BDate",myary[0]);
	//DHCWebD_SetObjValueA("BTime",myary[1]);	
	//DHCWebD_SetObjValueA("EDate",myary[2]);
	//DHCWebD_SetObjValueA("ETime",myary[3]);	
	
}

function DelTabRow(){
	var TabObj=document.getElementById("tDHCOPFin_InsFoot");
	while (TabObj.rows.length>2){
		TabObj.deleteRow(1);
		DHCWebD_ResetRowItems(TabObj);
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

function PrintClickHandler(){
	try {
		var GetPrescPath=document.getElementById("GetRepPath");
		if (GetPrescPath) {var encmeth=GetPrescPath.value} else {var encmeth=''};
		if (encmeth!="") {
			TemplatePath=cspRunServerMethod(encmeth);
		}
		///alert(TemplatePath);
		//var objtbl=document.getElementById('tUDHCPrescript_Print');
		//var rows=objtbl.rows.length;
		//var Rowid,OrderName,StartDate,SeqNo,DoseQty,DoseUOM,Priority,Status;
		//var Frequence,Instruction,Duration,PackQty,RecDep,Billed,Price,Sum,BillType;
        var BeginDate,EndDate;
        var CashSum,CheckSum,BankSum, TSum;
        var UserCode="";
		
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"HospOPFinQuery.xls";
	    
	    var TabObj=document.getElementById("tDHCOPFin_InsFoot");
		///if (isNaN(CashNUM)){CashNUM=0;}
		///myTotlNum=myTotlNum+parseFloat(CashNUM);
		
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    var myRows=TabObj.rows.length;
	    var xlsrow=5;
	    var xlscol=5;
	    var xlsCurcol=0;
	    
	    for (var Row=1;Row<myRows-1;Row++){
			xlsrow=xlsrow+1;
			var listobj=document.getElementById("Noz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+2)=myval;
			var listobj=document.getElementById("UserNamez"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+2)=myval;

			var listobj=document.getElementById("CashSumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+3)=myval;
			if (Row==myRows-2){
				var TCashSum=myval;
			}

			var listobj=document.getElementById("ChequesSumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+4)=myval;
			if (Row==myRows-2){
				var TCheckSum=myval;
			}
			
			var listobj=document.getElementById("BankSumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+5)=myval;
			if (Row==myRows-2){
				var TBankSum=myval;
			}
			
			var listobj=document.getElementById("Sumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+6)=myval;
			if (Row==myRows-2){
				var TTSum=myval;
			}
	    }
		
		var BDate=DHCWebD_GetObjValue("BDate");
		var EDate=DHCWebD_GetObjValue("EDate");
		var encmeth=DHCWebD_GetObjValue("GetOtherInfo");
		var mystr=cspRunServerMethod(encmeth, BDate, EDate, TTSum);
		var myary=mystr.split("^");
		
		xlsheet.cells(4,9)=myary[0];
	   	xlsheet.cells(31,3)=TCashSum;
	   	xlsheet.cells(31,6)=TCheckSum;
	   	xlsheet.cells(31,9)=TBankSum;
	   	xlsheet.cells(32,3)=TTSum;
	   	xlsheet.cells(33,10)=session['LOGON.USERNAME'];
	   	xlsheet.cells(29,8)=myary[1];
	   	xlsheet.cells(32,8)=myary[1];
	   	xlsheet.cells(34,3)=myary[2];
	   	
	    xlsheet.printout
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet=null
	} catch(e) {
		alert(e.message);
	};
}

document.body.onload=bodyLoadHandler;
