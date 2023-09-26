////PrintHandle
////UDHCACFinBR.CommPrintExcel.js

////Print Excel Result For Fin
////


function PrintClickHandlerAHSLRep(){
	///AHSLYY  Hospital
	
	try {
		var GetPrescPath=document.getElementById("GetRepPath");
		if (GetPrescPath) {var encmeth=GetPrescPath.value} else {var encmeth=''};
		if (encmeth!="") {
			TemplatePath=cspRunServerMethod(encmeth);
		}
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
	    var Template=TemplatePath+"HospAccHZ.xls";
		
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
		var myPFBLastDate=DHCWebD_GetObjValue("PFBLastDate");
	    if (myencmeth!=""){
		    //myPFBLastDate=cspRunServerMethod(myencmeth,myPFBLastDate);
	    }
		
		var myPFBLastTime=DHCWebD_GetObjValue("PFBLastTime");
	    xlsheet.cells(4,4)=myPFBLastDate+" "+myPFBLastTime;
		
		var myPFBCurrentDate=DHCWebD_GetObjValue("PFBCurrentDate");
		var myPFBCurrentTime=DHCWebD_GetObjValue("PFBCurrentTime");
	    if (myencmeth!=""){
		    //myPFBCurrentDate=cspRunServerMethod(myencmeth,myPFBCurrentDate);
	    }
	    var myval=(myPFBCurrentTime.toString());
		xlsheet.cells(5,4)=myPFBCurrentDate+" " +myval; 		////myPFBCurrentTime.toString();
		
		var myLastPDLeft=DHCWebD_GetObjValue("LastPDLeft");
		xlsheet.cells(7,4)=myLastPDLeft;
		
		var myPDIncomeSum=DHCWebD_GetObjValue("PDIncomeSum");
		xlsheet.cells(7,8)=myPDIncomeSum;
		var myPDReturnSum=DHCWebD_GetObjValue("PDReturnSum");
		xlsheet.cells(8,4)=myPDReturnSum;
		var myAccPaySum=DHCWebD_GetObjValue("AccPaySum");
		xlsheet.cells(8,8)=myAccPaySum;
		var myPDLeft=DHCWebD_GetObjValue("PDLeft");
		xlsheet.cells(9,8)=myPDLeft;
		
		//
	    var UserCode=session['LOGON.USERCODE'];
	    var myUserName=session['LOGON.USERNAME'];
	    xlsheet.cells(3,8)=myUserName;
	    ///
	    xlsheet.printout
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet=null
	} catch(e) {
		alert(e.message);
	};
}


