////DHCOPFin.WorkStatRep.js

function bodyLoadHandler(){
	//alert("");
	
	var obj=document.getElementById("Print");
	if (obj){
		obj.onclick=Print_OnClick;
	}
}

function Print_OnClick(){
	PrintClickHandler();
}

function WrtList(ListVal){
	var myary=ListVal.split("^");
	var TabObj=document.getElementById("tDHCOPFin_WorkStatRep");
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
	var TemplatePath="";
	try {
		var GetPrescPath=document.getElementById("GetRepPath");
		if (GetPrescPath) {var encmeth=GetPrescPath.value} else {var encmeth=''};
		if (encmeth!="") {
			TemplatePath=cspRunServerMethod(encmeth);
		}
		///alert(TemplatePath);
        var BeginDate,EndDate;
        var UserCode="";
		
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"HospOPWorkLoad.xls";
	    
	    var TabObj=document.getElementById("tDHCOPFin_WorkStatRep");
		///if (isNaN(CashNUM)){CashNUM=0;}
		///myTotlNum=myTotlNum+parseFloat(CashNUM);
		
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    var myRows=TabObj.rows.length;
	    var xlsrow=4;
	    var xlscol=5;
	    var xlsCurcol=0;
	    
	    for (var Row=1;Row<myRows;Row++){
			xlsrow=xlsrow+1;
			if (xlsrow>45){
				xlsrow=5;
				xlsCurcol=5;
			}
			
			var listobj=document.getElementById("Noz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+2)=myval;
			var listobj=document.getElementById("UserNamez"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+2)=myval;
			
			var listobj=document.getElementById("INVNumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+3)=myval;
			
			var listobj=document.getElementById("INVSumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+4)=myval;

			var listobj=document.getElementById("ParkNumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+5)=myval;
			
			var listobj=document.getElementById("ParkSumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+6)=myval;
	    }
		var BDate=DHCWebD_GetObjValue("BDate");
		var EDate=DHCWebD_GetObjValue("EDate");
		var encmeth=DHCWebD_GetObjValue("GetOtherInfo");
		var mystr=cspRunServerMethod(encmeth, BDate, EDate, "0");
		var myary=mystr.split("^");
		
		xlsheet.cells(3,8)=myary[0];
	   	xlsheet.cells(47,3)=myary[2];
	   	xlsheet.cells(47,10)=session['LOGON.USERNAME'];
	   	
	    xlsheet.printout
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet=null
	} catch(e) {
		alert(e.message);
	};
}

document.body.onload=bodyLoadHandler;
