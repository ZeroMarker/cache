////DHCOPFin.SHHS.USRFootINVRep.js

function bodyLoadHandler(){
	//alert("");
	
	var obj=document.getElementById("BtnPrint");
	if (obj){
		obj.onclick=BtnPrint_OnClick;
	}
}

function BtnPrint_OnClick(){
	PrintClickHandler();
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
	    var Template=TemplatePath+"HospOPSHHSFootINVQuery.xls";
	    
	    var TabObj=document.getElementById("tDHCOPFin_SHHS_USRFootINVRep");
		///if (isNaN(CashNUM)){CashNUM=0;}
		
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    var myRows=TabObj.rows.length;
	    var xlsrow=6;
	    var xlscol=5;
	    var xlsCurcol=0;
	    
	    for (var Row=1;Row<myRows;Row++){
			xlsrow=xlsrow+1;
			var listobj=document.getElementById("Noz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+1)=myval;
			var listobj=document.getElementById("TOperCodez"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+1)=myval;
			
			var listobj=document.getElementById("TOperNamez"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+2)=myval;
			
			var listobj=document.getElementById("TINVRangez"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+3)=myval;

			var listobj=document.getElementById("TINVNumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+4)=myval;
			
			var listobj=document.getElementById("TTolSumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+5)=myval;
			
			var listobj=document.getElementById("TCashSumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+6)=myval;
			
			var listobj=document.getElementById("TCheckSumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+7)=myval;
			
			var listobj=document.getElementById("TPOSumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+8)=myval;
			
			var listobj=document.getElementById("TPOSSumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+9)=myval;
			
			var listobj=document.getElementById("TYLSumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+10)=myval;
			
			var listobj=document.getElementById("TQFSumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+11)=myval;
			
			var listobj=document.getElementById("TFactSumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+12)=myval;
	    }
		var BDate=DHCWebD_GetObjValue("StDate");
		var EDate=DHCWebD_GetObjValue("EndDate");
		var encmeth=DHCWebD_GetObjValue("GetOtherInfo");
		var mystr=cspRunServerMethod(encmeth, BDate, EDate, "0");
		var myary=mystr.split("^");
		
		xlsheet.cells(3,3)=myary[0]
	   	///xlsheet.cells(47,3)=myary[2];
	   	xlsheet.cells(3,8)=session['LOGON.USERNAME'];
	   	
	   	gridlist(xlsheet,7,xlsrow,1,12)
	   	
	   	xlsheet.cells(xlsrow+2,3)=t["SHFH"];
	   	xlsheet.cells(xlsrow+2,5)=t["CN"];
	   	xlsheet.cells(xlsrow+2,8)=t["ZB"];
	   	
	    xlsheet.printout
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet=null
		window.setInterval("Cleanup();",1);
		
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


document.body.onload=bodyLoadHandler;

