////UDHCAccCol.USECardColQuery.js

function BodyLoadHandler(){
	var obj=document.getElementById("Print");
	if (obj){
		obj.onclick=PrintClickHandlerHZRepOLD;
	}
	
	
}

function PrintClickHandlerHZRepOLD(){
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
	    var Template=TemplatePath+"HospAccCardStat.xls";
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
	    xlsheet.cells(4,3)=PDate;
	    xlsheet.cells(4,6)=session["LOGON.USERNAME"];
		xlsheet.cells(5,3)=BeginDate+"---" +EndDate;	
		///xlsheet.cells(6,3)=EndDate;
		var objtbl=document.getElementById("tUDHCAccCol_USECardColQuery");
		var Rows=objtbl.rows.length;
		var xlsrow=7;
		var xlsCurcol=1;
		var myRows=Rows;
		
		for (var Row=1;Row<myRows;Row++)
		{
			xlsrow=xlsrow+1;

			var listobj=document.getElementById("Noz"+Row);
			if (listobj){
				var myval=DHCWebD_GetCellValue(listobj);
				xlsheet.cells(xlsrow,xlsCurcol+1)=myval;
				////alert(xlsrow);
			}
			var listobj=document.getElementById("TOperNamez"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+2)=myval;
			
			var listobj=document.getElementById("TNNumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+3)=myval;

			var listobj=document.getElementById("TLNumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+4)=myval;
			
			var listobj=document.getElementById("TENumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+5)=myval;
	    }
		
		gridlist(xlsheet,8,xlsrow,2,6)
		
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




document.body.onload=BodyLoadHandler;