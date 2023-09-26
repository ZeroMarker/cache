////UDHCACFinBR.AccUnFootQuery.js

function DocumentLoadHandler() {
	var obj=document.getElementById("Clear");
	if (obj){
		obj.onclick=Refresh;
	}
	var obj=document.getElementById("Print");
	if (obj){
		obj.onclick=Print_Click;
	}
	
	IntDoc();
	
}

function IntDoc(){
	var objtbl=document.getElementById("tUDHCACFinBR_AccUnFootQuery");
	var Rows=objtbl.rows.length;
	var xlsrow=5;
	var xlsCurcol=1;
	var myRows=Rows;
	
	if(myRows>1){
		var listobj=document.getElementById("TTMPGID1z1");
		var myval=DHCWebD_GetCellValue(listobj);
		
		var obj=document.getElementById("TMPGID");
		if (obj){
			obj.value=myval;
		}
	}
}

function Print_Click(){
	///Print UnFoot Account  Hospital  INV State
	//try {
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
	    var Template=TemplatePath+"HospOPAccUnFootRep.xls";
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
	    xlsheet.cells(4,7)=PDate;
	    xlsheet.cells(5,3)=session["LOGON.USERNAME"];
		xlsheet.cells(5,7)=BeginDate+"--"+EndDate;	
		///xlsheet.cells(6,3)=EndDate;
		var objtbl=document.getElementById("tUDHCACFinBR_AccUnFootQuery");
		var Rows=objtbl.rows.length;
		var xlsrow=6;
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
			//ÐòºÅWL
			myval=myary[0];
			xlsheet.cells(xlsrow,xlsCurcol+1)=myval;
			
			///var listobj=document.getElementById("TUserNamez"+Row);
			///var myval=DHCWebD_GetCellValue(listobj);
			//»¼ÕßÐÕÃû
			myval=myary[3];
			xlsheet.cells(xlsrow,xlsCurcol+2)=myval;
			//¿¨ºÅ
			///var listobj=document.getElementById("INVRangez"+Row);
			///var myval=DHCWebD_GetCellValue(listobj);
			myval=myary[17];
			xlsheet.cells(xlsrow,xlsCurcol+3)=myval;
			
			///var listobj=document.getElementById("ReceiptNumz"+Row);
			///if (listobj){
			///	var myval=DHCWebD_GetCellValue(listobj);
			///}
			//Ô¤½»½ð
			myval=myary[5];
			xlsheet.cells(xlsrow,xlsCurcol+4)=myval;
			
			///var listobj=document.getElementById("INVSumz"+Row);
			///if (listobj){
			///	var myval=DHCWebD_GetCellValue(listobj);
			///}
			//ÍËÔ¤½»½ð
			myval=myary[6];
			xlsheet.cells(xlsrow,xlsCurcol+5)=myval;
			
			///var listobj=document.getElementById("GetPDSumz"+Row);
			///var myval=DHCWebD_GetCellValue(listobj);
			//¿¨Ïû·Ñ¶î
			myval=myary[7];
			xlsheet.cells(xlsrow,xlsCurcol+6)=myval;
			
			//var listobj=document.getElementById("RefundPDSumz"+Row);
			//var myval=DHCWebD_GetCellValue(listobj);
			//ÕË»§Óà¶î
			myval=myary[8];
			xlsheet.cells(xlsrow,xlsCurcol+7)=myval;
			
	    }
		
		gridlist(xlsheet,7,xlsrow,1,8)
		
	    xlsheet.printout
	    xlBook.Close (savechanges=false);
	    
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	//} catch(e) {
	//	alert(e.message);
	//};
}

function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1-1, c1), objSheet.Cells(row2-1,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1-1, c1), objSheet.Cells(row2-1,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1-1, c1), objSheet.Cells(row2-1,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1-1, c1), objSheet.Cells(row2-1,c2)).Borders(4).LineStyle=1; 
}


function Refresh(){
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCACFinBR.AccUnFootQuery";
}

document.body.onload=DocumentLoadHandler;

