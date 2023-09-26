////DHCOPFin.PRT.RefundSate.js

function BodyLoadHandler(){
	var obj=document.getElementById("Print");
	if (obj){
		obj.onclick=Print_Click;
	}
	
	IntDoc();
	
	
}

function IntDoc(){
	
}

function Print_Click(){
	PrintClickHandlerINVRep();
}


function PrintClickHandlerINVRep(){
	///AHSLYY  Hospital  INV State
	try {
		var GetPrescPath=document.getElementById("GetRepPath");
		if (GetPrescPath) {var encmeth=GetPrescPath.value} else {var encmeth=''};
		if (encmeth!="") {
			TemplatePath=cspRunServerMethod(encmeth);
		}
		///alert(TemplatePath);
        var BeginDate,EndDate,TotalSum,PatPaySum,PayorSum;
		var ParkINVInfo,ParkSum,ParkNum;
	    var RefundINVInfo,RefundSum,RefundNum,CheckSum,CheckNum;
        var INVInfo;
        var UserCode="";
        var myTotlNum=0;
        var CashNUM=0;
        var myencmeth="";
        
        var obj=document.getElementById("DateTrans");
        if (obj){
	        myencmeth=obj.value;
        }
        
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCHospPRTRefundSate.xls";
	    var UserCode=""
	    var obj=document.getElementById("sUser");
	    if (obj){
		    var UserCode=obj.value;
	    }
	    
	    ////var obj=document.getElementById("HSDate");
	    var obj=document.getElementById("StDate");
	    if (obj) {BeginDate=obj.value;}
	    if (myencmeth!=""){
		    BeginDate=cspRunServerMethod(myencmeth,BeginDate);
	    }
	    
	    ///var obj=document.getElementById("HEDate");
	    var obj=document.getElementById("EndDate");
	    if (obj) EndDate=obj.value;
	    if (myencmeth!=""){
		    EndDate=cspRunServerMethod(myencmeth,EndDate);
	    }
		var obj=document.getElementById("CurDate");
		if (obj){
			var PDate=obj.value;
		}
		
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.cells(4,4)=PDate;
		xlsheet.cells(4,8)=BeginDate+" --- " +EndDate;	
		///xlsheet.cells(6,3)=EndDate;
		var objtbl=document.getElementById("tDHCOPFin_PRT_RefundSate");
		var Rows=objtbl.rows.length;
		var xlsrow=5;
		var xlsCurcol=1;
		var myRows=Rows;
		
		for (var Row=1;Row<myRows;Row++)
		{
			xlsrow=xlsrow+1;
			var listobj=document.getElementById("Noz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+1)=myval;
			
			var listobj=document.getElementById("ParkPrtNoz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+2)=myval;
			
			var listobj=document.getElementById("TCardNoz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+3)=myval;
			
			var listobj=document.getElementById("TPatNamez"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+4)=myval;			

			var listobj=document.getElementById("TRefReasonz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+5)=myval;			
			var listobj=document.getElementById("TRefDateTimez"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+6)=myval;			
			var listobj=document.getElementById("TRefItemDescz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+7)=myval;			

			var listobj=document.getElementById("TSumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+8)=myval;			

			var listobj=document.getElementById("TAuditUserz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+9)=myval;			

			var listobj=document.getElementById("TAuditLocz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+10)=myval;			
			
	    }
		
		gridlist(xlsheet,6,xlsrow,2,11)
		
	    xlsheet.printout
	    xlBook.Close (savechanges=false);
	    
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
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

