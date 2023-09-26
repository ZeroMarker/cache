////DHCOPFin.USRRepFootQList.js

function BodyLoadHandler(){
	var obj=document.getElementById("Print");
	if (obj){
		obj.onclick=Print_Click;
	}

	var obj=document.getElementById("PrintRep");
	if (obj){
		obj.onclick=PrintClickHandlerHZRep;
	}
	
	
	IntDoc();
	
	
}

function IntDoc(){
	var objtbl=document.getElementById("tDHCOPFin_USRRepFootQList");
	var Rows=objtbl.rows.length;
	var xlsrow=5;
	var xlsCurcol=1;
	var myRows=Rows;
	
	if(myRows>0){
		var listobj=document.getElementById("TTMPGID1z1");
		var myval=DHCWebD_GetCellValue(listobj);
		var obj=document.getElementById("TMPGID");
		if (obj){
			obj.value=myval;
		}
	}
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
	    var Template=TemplatePath+"HospINVStat.xls";
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
		xlsheet.cells(4,7)=BeginDate+" --- " +EndDate;	
		///xlsheet.cells(6,3)=EndDate;
		var objtbl=document.getElementById("tDHCOPFin_USRRepFootQList");
		var Rows=objtbl.rows.length;
		var xlsrow=5;
		var xlsCurcol=1;
		var myRows=Rows;
		
		var myData="Begin";
		var myEncrypt=DHCWebD_GetObjValue("ReadPrtData");
		var myTMPGID=DHCWebD_GetObjValue("TMPGID");
		var myIdx="";
		while ((myData!="")&&(myEncrypt!=""))
		{
			myData=cspRunServerMethod(myEncrypt,myTMPGID,myIdx);
			var myary=myData.split("^");
			myIdx=myary[0];
			
			xlsrow=xlsrow+1;
			//var listobj=document.getElementById("TUserNamez"+Row);
			//var myval=DHCWebD_GetCellValue(listobj);
			myval=myary[11];
			xlsheet.cells(xlsrow,xlsCurcol+1)=myval;
			
			//var listobj=document.getElementById("INVRangez"+Row);
			//var myval=DHCWebD_GetCellValue(listobj);
			myval=myary[12];
			xlsheet.cells(xlsrow,xlsCurcol+2)=myval;
			
			//var listobj=document.getElementById("ReceiptNumz"+Row);
			///var myval=DHCWebD_GetCellValue(listobj);
			myval=myary[13];
			xlsheet.cells(xlsrow,xlsCurcol+6)=myval;
			
			///var listobj=document.getElementById("INVSumz"+Row);
			///var myval=DHCWebD_GetCellValue(listobj);
			myval=myary[5];
			xlsheet.cells(xlsrow,xlsCurcol+7)=myval;			
			
	    }
		
		gridlist(xlsheet,6,xlsrow,2,8)
		
	    xlsheet.printout
	    xlBook.Close (savechanges=false);
	    
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	} catch(e) {
		alert(e.message);
	};
}

function PrintClickHandlerHZRep(){
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
	    var Template=TemplatePath+"HospFinPreDStat.xls";
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
	    xlsheet.cells(4,8)=session["LOGON.USERNAME"];
		xlsheet.cells(4,10)=BeginDate+"---" +EndDate;	
		///xlsheet.cells(6,3)=EndDate;
		var objtbl=document.getElementById("tDHCOPFin_USRRepFootQList");
		var Rows=objtbl.rows.length;
		var xlsrow=5;
		var xlsCurcol=1;
		var myRows=Rows;
		


		var myData="Begin";
		var myEncrypt=DHCWebD_GetObjValue("ReadPrtData");
		var myTMPGID=DHCWebD_GetObjValue("TMPGID");
		var myIdx="";

		///for (var Row=1;Row<myRows;Row++)
		
		while ((myData!="")&&(myEncrypt!=""))
		{
			myData=cspRunServerMethod(myEncrypt,myTMPGID,myIdx);
			var myary=myData.split("^");
			myIdx=myary[0];
			
			xlsrow=xlsrow+1;
			
			///var listobj=document.getElementById("RepIDz"+Row);
			///if (listobj){
			///	var myval=DHCWebD_GetCellValue(listobj);
			//}
			myval=myary[2];
			xlsheet.cells(xlsrow,xlsCurcol+1)=myval;
			
			///var listobj=document.getElementById("TUserNamez"+Row);
			///var myval=DHCWebD_GetCellValue(listobj);
			myval=myary[11];
			xlsheet.cells(xlsrow,xlsCurcol+2)=myval;
			
			///var listobj=document.getElementById("INVRangez"+Row);
			///var myval=DHCWebD_GetCellValue(listobj);
			myval=myary[12];
			xlsheet.cells(xlsrow,xlsCurcol+3)=myval;
			
			///var listobj=document.getElementById("ReceiptNumz"+Row);
			///if (listobj){
			///	var myval=DHCWebD_GetCellValue(listobj);
			///}
			myval=myary[13];
			xlsheet.cells(xlsrow,xlsCurcol+4)=myval;
			
			///var listobj=document.getElementById("INVSumz"+Row);
			///if (listobj){
			///	var myval=DHCWebD_GetCellValue(listobj);
			///}
			
			myval=myary[5];
			xlsheet.cells(xlsrow,xlsCurcol+5)=myval;
			
			///var listobj=document.getElementById("GetPDSumz"+Row);
			///var myval=DHCWebD_GetCellValue(listobj);
			myval=myary[9];
			xlsheet.cells(xlsrow,xlsCurcol+6)=myval;
			
			//var listobj=document.getElementById("RefundPDSumz"+Row);
			//var myval=DHCWebD_GetCellValue(listobj);
			myval=myary[10];
			xlsheet.cells(xlsrow,xlsCurcol+7)=myval;
			
			///var listobj=document.getElementById("PatSumz"+Row);
			///var myval=DHCWebD_GetCellValue(listobj);
			myval=myary[6];
			xlsheet.cells(xlsrow,xlsCurcol+8)=myval;
			
			///var listobj=document.getElementById("BegFDTz"+Row);
			///var myval=DHCWebD_GetCellValue(listobj);
			myval=myary[7];
			xlsheet.cells(xlsrow,xlsCurcol+9)=myval;
			
			///var listobj=document.getElementById("EndFDTz"+Row);
			///var myval=DHCWebD_GetCellValue(listobj);
			myval=myary[8];
			xlsheet.cells(xlsrow,xlsCurcol+10)=myval;
			
			///var listobj=document.getElementById("INSFootUserz"+Row);
			///var myval=DHCWebD_GetCellValue(listobj);
			myval=myary[15];
			xlsheet.cells(xlsrow,xlsCurcol+11)=myval;
			
	    }
		
		gridlist(xlsheet,6,xlsrow,2,12)
		
	    xlsheet.printout
	    xlBook.Close (savechanges=false);
	    
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	} catch(e) {
		alert(e.message);
	};
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
	    var Template=TemplatePath+"HospFinPreDStat.xls";
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
	    xlsheet.cells(4,6)=session["LOGON.USERNAME"];
		xlsheet.cells(4,8)=BeginDate+"---" +EndDate;	
		///xlsheet.cells(6,3)=EndDate;
		var objtbl=document.getElementById("tDHCOPFin_USRRepFootQList");
		var Rows=objtbl.rows.length;
		var xlsrow=5;
		var xlsCurcol=1;
		var myRows=Rows;
		
		for (var Row=1;Row<myRows;Row++)
		{
			xlsrow=xlsrow+1;

			var listobj=document.getElementById("RepIDz"+Row);
			if (listobj){
				var myval=DHCWebD_GetCellValue(listobj);
				xlsheet.cells(xlsrow,xlsCurcol+1)=myval;
				////alert(xlsrow);
			}
			var listobj=document.getElementById("TUserNamez"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+2)=myval;
			
			var listobj=document.getElementById("INVSumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+3)=myval;

			var listobj=document.getElementById("GetPDSumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+4)=myval;
			
			var listobj=document.getElementById("RefundPDSumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+5)=myval;
			
			var listobj=document.getElementById("PatSumz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+6)=myval;
			
			var listobj=document.getElementById("BegFDTz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+7)=myval;
			
			var listobj=document.getElementById("EndFDTz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+8)=myval;
			
			var listobj=document.getElementById("INSFootUserz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+9)=myval;
	    }
		
		gridlist(xlsheet,6,xlsrow,2,10)
		
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

function UnloadHandler(){
	
	var myEncrypt=DHCWebD_GetObjValue("DELPRTTMPDATA");
	var myTMPGID=DHCWebD_GetObjValue("TMPGID");
	if (myEncrypt!=""){
		var mytmp=cspRunServerMethod(myEncrypt, myTMPGID);
	}
}


document.body.onload = BodyLoadHandler;

document.body.onunload =UnloadHandler;