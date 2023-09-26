///DHCOPFin.BJJSTYY.FootINVCAV.js

function BodyLoadHandler(){
	var obj=document.getElementById("BtnPrint");
	if (obj){
		obj.onclick=BtnPrint_Click;
	}

	var obj=document.getElementById("PrintRep");
	if (obj){
		obj.onclick=PrintClickHandlerHZRep;
	}
	
	
	IntDoc();
	
}

function IntDoc(){
	var objtbl=document.getElementById("tDHCOPFin_BJJSTYY_FootINVCAV");
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

function BtnPrint_Click(){
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
	    var Template=TemplatePath+"DHCBJJSTHospOPINVFootCFV.xls";
	    var UserCode=""
	    var obj=document.getElementById("sUser");
	    if (obj){
		    var UserCode=obj.value;
	    }
	    
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
		xlsheet.cells(5,3)=BeginDate+" --- " +EndDate;	
		
		var objtbl=document.getElementById("tDHCOPFin_BJJSTYY_FootINVCAV");
		var Rows=objtbl.rows.length;
		var xlsrow=6;
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
			
			////"No:%String,OperName:%String,INVNum:%String,INVRepNo:%String,
			////INVSum:%String,TMPGID:%String,INVParkInfo:%String,
			////INVRefInfo:%String"
			xlsrow=xlsrow+1;
			myval=myary[1];
			xlsheet.cells(xlsrow,xlsCurcol+1)=myval;
			
			myval=myary[2];
			xlsheet.cells(xlsrow,xlsCurcol+2)=myval;
			
			myval=myary[3];
			xlsheet.cells(xlsrow,xlsCurcol+3)=myval;
			
			myval=myary[4];
			xlsheet.cells(xlsrow,xlsCurcol+4)=myval;
			
			myval=myary[7];
			xlsheet.cells(xlsrow,xlsCurcol+5)=myval;

			myval=myary[8];
			xlsheet.cells(xlsrow,xlsCurcol+6)=myval;
			
	    }
		
		gridlist(xlsheet,7,xlsrow,2,7)
		
		xlsheet.cells(xlsrow+2,3)="制表人:";
		xlsheet.cells(xlsrow+2,3+1)=session['LOGON.USERNAME'];
		
		var myval=DHCWebD_GetObjValue("CurDate");
		xlsheet.cells(xlsrow+2,6)="制表日期:"+myval;
		
		xlsheet.cells(xlsrow+3,3)="审核人:";
		
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

document.body.onbeforeunload=UnloadHandler;

///document.body.onunload =UnloadHandler;
