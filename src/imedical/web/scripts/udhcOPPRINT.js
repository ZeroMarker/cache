///udhcOPPRINT.js
///
var TemplatePath=""

function gridlist(objSheet,row1,row2,c1,c2)//3,2+i,1,8
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
}

function SheetInRows(objSheet,CopyedRow){
	///objSheet.Rows().Insert
}

function printDaily()  
{//
	var xlApp,obook,osheet,xlsheet,xlBook
	var para,patname,patno,patdw,paymode,payamt,payamtdx	  
	Template=path+"JF_Daily.xls"
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet  
	  
	xlsheet.cells(4,2).value=
	xlsheet.printout
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet=null
}

function PrintClickHandlerSXXARep(){
	////XA JD KQYY
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
	    /////var Template=TemplatePath+"HospOPFoot.xls";
	    var Template=TemplatePath+"DHCHospOPXAYKFoot.xls";
	    var obj=document.getElementById("sUser");
	    if (obj){
		    var UserCode=obj.value;
	    }
	    
	    var obj=document.getElementById("CashNUM");
	    if (obj){CashNUM=obj.value}
	    
	    ////var obj=document.getElementById("HSDate");
	    var obj=document.getElementById("StartDate");
	    if (obj) {BeginDate=obj.value;}
	    if (myencmeth!=""){
		    BeginDate=cspRunServerMethod(myencmeth,BeginDate);
	    }
	    var obj=document.getElementById("StartTime");
	    if (obj)  BeginDate=BeginDate+" "+ obj.value;
	    
	    ///var obj=document.getElementById("HEDate");
	    var obj=document.getElementById("EndDate");
	    if (obj) EndDate=obj.value;
	    if (myencmeth!=""){
		    EndDate=cspRunServerMethod(myencmeth,EndDate);
	    }
	    var PDate=EndDate;
	    var obj=document.getElementById("EndTime");
	    if (obj) EndDate=EndDate+" "+obj.value;
	    
	    var obj=document.getElementById("TotalFee");
	    if (obj) TotalSum=obj.value;
	    
	    var obj=document.getElementById("HandSum");
	    if (obj) PatPaySum=obj.value;
	    
	    var obj=document.getElementById("PayorTotal");
	    if (obj) PayorSum=obj.value;
		
	    var obj=document.getElementById("INVNOinfo");
	    if (obj) INVInfo=obj.value;
		
	    var obj=document.getElementById("CancelNUM");
	    if (obj) ParkNum=obj.value;

	    var obj=document.getElementById("CancelSUM");
	    if (obj) ParkSum=obj.value;

	    var obj=document.getElementById("ParkINV");
	    if (obj) ParkINVInfo=obj.value;
		
	    var obj=document.getElementById("CheckNUM");
	    if (obj) CheckNum=obj.value;

	    var obj=document.getElementById("CheckSUM");
	    if (obj) CheckSum=obj.value;

	    var obj=document.getElementById("RefundNUM");
	    if (obj) RefundNum=obj.value;

	    var obj=document.getElementById("RefundSUM");
	    if (obj) RefundSum=obj.value;
	    
	    var obj=document.getElementById("RefundINV");
	    if (obj) RefundINVInfo=obj.value;
		
		//parseInt(TObj.style.height,10);
		if (isNaN(RefundNum)){RefundNum=0;}
		myTotlNum=myTotlNum+parseFloat(RefundNum);
		
		if (isNaN(CheckNum)){CheckNum=0;}
		myTotlNum=myTotlNum+parseFloat(CheckNum);
		
		if (isNaN(ParkNum)){ParkNum=0;}
		myTotlNum=myTotlNum+parseFloat(ParkNum);
		
		if (isNaN(CashNUM)){CashNUM=0;}
		myTotlNum=myTotlNum+parseFloat(CashNUM);
		
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    ///xlsheet.cells(4,7)=PDate;
	    xlsheet.cells(2,5)=BeginDate+"--"+EndDate;
	    
	    ////xlsheet.cells(8,9)=PayorSum;	
	    xlsheet.cells(4,3)=INVInfo;		
		var myCurDate=
		
	    xlsheet.cells(2,3)=UserCode;
		
		//
	    var myCurDate=DHCWebD_GetObjValue("CurDate");
	    xlsheet.cells(3,7)=myCurDate;
	    
	    var RepID="";
	    var obj=document.getElementById("RepID");
	    if (obj){
		    RepID=obj.value;
	   	}
	   	var myMaxRow=DHCWeb_GetTBRows("tudhcOPHandin_XAJDYKRep");
		///var myTbl=document.getElementById("tudhcOPHandin.XAJDYKRep");
		
		var myrow=1,mycol=1;
		var myPRows=10;
		var myBegRow=7;
	    for (var i=1;i<myMaxRow;i++){
		    var obj=document.getElementById("TTarNamez"+i);
			var myVal=DHCWebD_GetCellValue(obj)
			xlsheet.cells(myBegRow+i,2)=myVal;
		    var obj=document.getElementById("TTotalSumz"+i);
			var myVal=DHCWebD_GetCellValue(obj)
			xlsheet.cells(myBegRow+i,3)=myVal;
		    var obj=document.getElementById("TRefCashSumz"+i);
			var myVal=DHCWebD_GetCellValue(obj)
			xlsheet.cells(myBegRow+i,4)=myVal;
		    var obj=document.getElementById("TRefTCSumz"+i);
			var myVal=DHCWebD_GetCellValue(obj)
			xlsheet.cells(myBegRow+i,5)=myVal;
		    var obj=document.getElementById("TCashSumz"+i);
			var myVal=DHCWebD_GetCellValue(obj)
		    xlsheet.cells(myBegRow+i,6)=myVal;
		    var obj=document.getElementById("TTCSumz"+i);
			var myVal=DHCWebD_GetCellValue(obj)
			xlsheet.cells(myBegRow+i,7)=myVal;
			var obj=document.getElementById("TSumz"+i);
			var myVal=DHCWebD_GetCellValue(obj)
			xlsheet.cells(myBegRow+i,8)=myVal;
	    }
		gridlist(xlsheet,myBegRow,myBegRow+i-1,2,8);
	    var myCurRow=myBegRow+i;
	    var myCurRow=myCurRow+1;
	    xlsheet.cells(myCurRow,2)=t["PatPayPY"];
	    var myPY=DHCWebD_GetObjValue("PatPayPY");
	    xlsheet.cells(myCurRow,3)=myPY;
	    var myCurRow=myCurRow+1;
	    xlsheet.cells(myCurRow,2)=t["PayUser"];
	    xlsheet.cells(myCurRow,3)=UserCode;
	    xlsheet.cells(myCurRow,4)=t["FH"];
	    xlsheet.cells(myCurRow,6)=t["ZB"];
	    
	    xlsheet.printout
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet=null
	} catch(e) {
		alert(e.message);
	};
}


function PrintClickHandlerSDDTSYRep(){
	///SXDTSYYY  Hospital
	
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
	    var Template=TemplatePath+"DHCOPHandinRep.xls";
	    
	    var obj=document.getElementById("sUser");
	    if (obj){
		    var UserCode=obj.value;
	    }
	    
	    var obj=document.getElementById("CashNUM");
	    if (obj){CashNUM=obj.value}
	    
	    var obj=document.getElementById("StartDate");
	    if (obj) {BeginDate=obj.value;}
	    if (myencmeth!=""){
		    BeginDate=cspRunServerMethod(myencmeth,BeginDate);
	    }
	    var obj=document.getElementById("StartTime");
	    if (obj)  BeginDate=BeginDate+" "+ obj.value;
	    
	    var obj=document.getElementById("EndDate");
	    if (obj) EndDate=obj.value;
	    if (myencmeth!=""){
		    EndDate=cspRunServerMethod(myencmeth,EndDate);
	    }
	    var PDate=EndDate;
	    var obj=document.getElementById("EndTime");
	    if (obj) EndDate=EndDate+" "+obj.value;
	    
	    var obj=document.getElementById("TotalFee");
	    if (obj) TotalSum=obj.value;
	    
	    var obj=document.getElementById("HandSum");
	    if (obj) PatPaySum=obj.value;
	    
	    var obj=document.getElementById("PayorTotal");
	    if (obj) PayorSum=obj.value;

	    var obj=document.getElementById("INVNOinfo");
	    if (obj) INVInfo=obj.value;
		
	    var obj=document.getElementById("CancelNUM");
	    if (obj) ParkNum=obj.value;
		
	    var obj=document.getElementById("CancelSUM");
	    if (obj) ParkSum=obj.value;
		
	    var obj=document.getElementById("ParkINV");
	    if (obj) ParkINVInfo=obj.value;
		
	    var obj=document.getElementById("CheckNUM");
	    if (obj) CheckNum=obj.value;
		
	    var obj=document.getElementById("CheckSUM");
	    if (obj) CheckSum=obj.value;
		
	    var obj=document.getElementById("RefundNUM");
	    if (obj) RefundNum=obj.value;
		
	    var obj=document.getElementById("RefundSUM");
	    if (obj) RefundSum=obj.value;
	    
	    var obj=document.getElementById("RefundINV");
	    if (obj) RefundINVInfo=obj.value;
		
		if (isNaN(RefundNum)){RefundNum=0;}
		
		myTotlNum=myTotlNum+parseFloat(RefundNum);
		
		if (isNaN(CheckNum)){CheckNum=0;}
		
		if (isNaN(ParkNum)){ParkNum=0;}
		
		myTotlNum=myTotlNum+parseFloat(ParkNum);
		
		if (isNaN(CashNUM)){CashNUM=0;}
		
		var myCashSUM=DHCWebD_GetObjValue("CashSUM");
		if (isNaN(myCashSUM)){myCashSUM=0.00;}
		
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
		xlsheet.cells(3,3)=UserCode;
	    xlsheet.cells(3,5)=BeginDate+t["Tip"]+EndDate;	
		
	    xlsheet.cells(4,2)=INVInfo;
		var myTNum=GetINVNum();
		xlsheet.cells(5,6)=myTNum;
		
	    xlsheet.cells(14,3)=TotalSum;
	    var myencrypt=DHCWebD_GetObjValue("TransRMB");
	    var myRMB="";
	   	if (myencrypt!=""){
		   	var myRMB=cspRunServerMethod(myencrypt,TotalSum);
	   	}
	    xlsheet.cells(15,3)=myRMB;
	    
	    var mySelfCashPaySum=0;
	    var PatPaySum=parseFloat(PatPaySum);
	    var mySelfCashPaySum=parseFloat(myCashSUM);
	    var myYBSelfPay=DHCWebD_GetObjValue("YBSelfPay");
	    if (isNaN(myYBSelfPay)){myYBSelfPay=0;}
	    var mySelfCashPaySum=mySelfCashPaySum+parseFloat(myYBSelfPay);
	    
	    xlsheet.cells(18,5)=mySelfCashPaySum.toFixed(2);
	    var myRMB="";
	   	if (myencrypt!=""){
		   	var myRMB=cspRunServerMethod(myencrypt,mySelfCashPaySum);
	   	}
	    xlsheet.cells(19,5)=myRMB;
	    
	    xlsheet.cells(7,3)=myCashSUM;
	    xlsheet.cells(7,4)=CashNUM;
		
		var myYBSelfPay=DHCWebD_GetObjValue("YBSelfPay");
	    xlsheet.cells(7,6)=myYBSelfPay;
	    var myYBINVNum=DHCWebD_GetObjValue("YBINVNum");
	    xlsheet.cells(7,7)=myYBINVNum;
	    var myYBCardPay=DHCWebD_GetObjValue("YBCardPay");
	    xlsheet.cells(8,6)=myYBCardPay;
		
		
		var myXRYBSUM=DHCWebD_GetObjValue("XRYBSum");
	    xlsheet.cells(8,3)=myXRYBSUM;
	    var XRYBNUM=DHCWebD_GetObjValue("XRYBNum");
	    xlsheet.cells(8,4)=XRYBNUM;
	    
	    if (isNaN(myXRYBSUM)){myXRYBSUM=0;}
		var myJZXJSum=parseFloat(myXRYBSUM);
		
		var myCPPSUM=DHCWebD_GetObjValue("CPPSum");
	    xlsheet.cells(9,3)=myCPPSUM;
	    var CPPNUM=DHCWebD_GetObjValue("CPPNum");
	    xlsheet.cells(9,4)=CPPNUM;
	    
	    if (isNaN(myCPPSUM)){myCPPSUM=0;}
		myJZXJSum=myJZXJSum+parseFloat(myCPPSUM);
		
		var myGFJZSum=DHCWebD_GetObjValue("GFJZSum");
	    xlsheet.cells(10,3)=myGFJZSum;
	    var myval=DHCWebD_GetObjValue("GFJZNum");
	    xlsheet.cells(10,4)=myval;

	    if (isNaN(myGFJZSum)){myGFJZSum=0;}
		myJZXJSum=myJZXJSum+parseFloat(myGFJZSum);
		xlsheet.cells(16,4)=myJZXJSum.toFixed(2);
		
		myYBCardPay=parseFloat(myYBCardPay);
		xlsheet.cells(17,4)=myYBCardPay.toFixed(2);
		
		var myCheckSUM=DHCWebD_GetObjValue("CheckSUM");
	    xlsheet.cells(11,3)=myCheckSUM;
		////if (isNaN(myCheckSUM)){myCheckSUM=0;}
		xlsheet.cells(16,6)=myCheckSUM;
		
	    var myval=DHCWebD_GetObjValue("CheckNUM");
	    xlsheet.cells(11,4)=myval;
		
		var myval=DHCWebD_GetObjValue("TJSum");
	    xlsheet.cells(12,3)=myval;
	    var myval=DHCWebD_GetObjValue("TJNum");
	    xlsheet.cells(12,4)=myval;
		
		var myHTDWSum=DHCWebD_GetObjValue("HTDWSum");
	    xlsheet.cells(13,3)=myHTDWSum;
	    xlsheet.cells(17,6)=myHTDWSum;
	    var myval=DHCWebD_GetObjValue("HTDWNum");
	    xlsheet.cells(13,4)=myval;	   	
	    
		var myXXNum=parseInt(CashNUM)+parseInt(CheckNum);
		var myXXSum=parseFloat(myCashSUM)+parseFloat(CheckSum);
		myTotlNum=myTotlNum+parseInt(myXXNum);
		
		//
		xlsheet.cells(20,3)=ParkINVInfo+""+RefundINVInfo;	
		var myval=parseInt(ParkNum)+parseInt(RefundNum);
		xlsheet.cells(23,4)=myval.toFixed(0);
		var myval=parseFloat(ParkSum)+parseFloat(RefundSum);
		xlsheet.cells(23,6)=myval.toFixed(2);
	    
	    xlsheet.cells(25,3)=UserCode;
	    //	    
	    xlsheet.cells(25,7)=PDate;
		
	    xlsheet.printout
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet=null
	} catch(e) {
		alert(e.message);
	};
}


function PrintClickHandlerAHSLRep(){
	///AHSLYY  Hospital
	
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
	    var Template=TemplatePath+"HospOPFoot.xls";
	    
	    var obj=document.getElementById("sUser");
	    if (obj){
		    var UserCode=obj.value;
	    }
	    
	    var obj=document.getElementById("CashNUM");
	    if (obj){CashNUM=obj.value}
	    
	    ////var obj=document.getElementById("HSDate");
	    var obj=document.getElementById("StartDate");
	    if (obj) {BeginDate=obj.value;}
	    if (myencmeth!=""){
		    BeginDate=cspRunServerMethod(myencmeth,BeginDate);
	    }
	    var obj=document.getElementById("StartTime");
	    if (obj)  BeginDate=BeginDate+" "+ obj.value;
	    
	    ///var obj=document.getElementById("HEDate");
	    var obj=document.getElementById("EndDate");
	    if (obj) EndDate=obj.value;
	    if (myencmeth!=""){
		    EndDate=cspRunServerMethod(myencmeth,EndDate);
	    }
	    var PDate=EndDate;
	    var obj=document.getElementById("EndTime");
	    if (obj) EndDate=EndDate+" "+obj.value;
	    
	    var obj=document.getElementById("TotalFee");
	    if (obj) TotalSum=obj.value;
	    
	    var obj=document.getElementById("HandSum");
	    if (obj) PatPaySum=obj.value;
	    
	    var obj=document.getElementById("PayorTotal");
	    if (obj) PayorSum=obj.value;

	    var obj=document.getElementById("INVNOinfo");
	    if (obj) INVInfo=obj.value;
		
	    var obj=document.getElementById("CancelNUM");
	    if (obj) ParkNum=obj.value;

	    var obj=document.getElementById("CancelSUM");
	    if (obj) ParkSum=obj.value;

	    var obj=document.getElementById("ParkINV");
	    if (obj) ParkINVInfo=obj.value;
		
	    var obj=document.getElementById("CheckNUM");
	    if (obj) CheckNum=obj.value;

	    var obj=document.getElementById("CheckSUM");
	    if (obj) CheckSum=obj.value;

	    var obj=document.getElementById("RefundNUM");
	    if (obj) RefundNum=obj.value;

	    var obj=document.getElementById("RefundSUM");
	    if (obj) RefundSum=obj.value;
	    
	    var obj=document.getElementById("RefundINV");
	    if (obj) RefundINVInfo=obj.value;
		
		//parseInt(TObj.style.height,10);
		if (isNaN(RefundNum)){RefundNum=0;}
		myTotlNum=myTotlNum+parseFloat(RefundNum);
		
		if (isNaN(CheckNum)){CheckNum=0;}
		////myTotlNum=myTotlNum+parseFloat(CheckNum);
		
		if (isNaN(ParkNum)){ParkNum=0;}
		myTotlNum=myTotlNum+parseFloat(ParkNum);
		
		if (isNaN(CashNUM)){CashNUM=0;}
		///myTotlNum=myTotlNum+parseFloat(CashNUM);
		
		var myCashSUM=DHCWebD_GetObjValue("CashSUM");
		if (isNaN(myCashSUM)){myCashSUM=0.00;}
		var myCredCardNum=DHCWebD_GetObjValue("CredCardNum");
		if (isNaN(myCredCardNum)){myCredCardNum=0;}
		var myCredCardSum=DHCWebD_GetObjValue("CredCardSum");
		if (isNaN(myCredCardSum)){myCredCardSum=0.00;}
		var myOtherNum=DHCWebD_GetObjValue("OtherNum");
		if (isNaN(myOtherNum)){myOtherNum=0;}
		var myOtherSum=DHCWebD_GetObjValue("OtherSum");
		if (isNaN(myOtherSum)){myOtherSum=0.00}
		
		
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.cells(4,7)=PDate;
		xlsheet.cells(5,3)=BeginDate+"  ---  " +EndDate;	
		///xlsheet.cells(6,3)=EndDate;	
		
		var myval=DHCWebD_GetObjValue("HandSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(6,3)= myval;
		var myval=DHCWebD_GetObjValue("TotalFee");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(7,3)=myval;
		
		xlsheet.cells(8,3)=INVInfo;
		
		var myval=DHCWebD_GetObjValue("CashNUM");
		if(isNaN(myval)){myval=0;}
		xlsheet.cells(11,3)=myval;
		
		var myval=DHCWebD_GetObjValue("CashSUM");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(11,7)=myval;

		var myval=DHCWebD_GetObjValue("CheckNUM");
		if(isNaN(myval)){myval=0;}
		xlsheet.cells(13,3)=myval;

		var myval=DHCWebD_GetObjValue("CheckSUM");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(13,7)=myval;
		
		var myval=DHCWebD_GetObjValue("CancelNUM");
		if(isNaN(myval)){myval=0;}
		xlsheet.cells(15,3)=myval;

		var myval=DHCWebD_GetObjValue("CancelSUM");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(15,7)=myval;
		
		xlsheet.cells(16,3)=DHCWebD_GetObjValue("ParkINV");
		
		var myval=DHCWebD_GetObjValue("RefundNUM");
		if(isNaN(myval)){myval=0;}
		xlsheet.cells(17,3)=myval;

		var myval=DHCWebD_GetObjValue("RefundSUM");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(17,7)=myval;
		
		xlsheet.cells(18,3)=DHCWebD_GetObjValue("RefundINV");
		
		
		xlsheet.cells(21,3)=DHCWebD_GetObjValue("CardNum");
		
		var myval=DHCWebD_GetObjValue("CardSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(21,7)=myval;

		var myval=DHCWebD_GetObjValue("CardYBSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(22,4)=myval;
		var myval=DHCWebD_GetObjValue("CardPaySum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(22,7)=myval;

		xlsheet.cells(23,3)=DHCWebD_GetObjValue("CardRefNum");
		var myval=DHCWebD_GetObjValue("CardRefSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(23,7)=myval;

		var myval=DHCWebD_GetObjValue("CardCashRefSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(24,3)=myval;
		var myval=DHCWebD_GetObjValue("CardYBRefSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(24,7)=myval;
		
		xlsheet.cells(25,3)=DHCWebD_GetObjValue("CardRefundINVInfo");

		xlsheet.cells(26,3)=DHCWebD_GetObjValue("CardParkNum");
		var myval=DHCWebD_GetObjValue("CardParkSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(26,7)=myval;

		var myval=DHCWebD_GetObjValue("CardCashParkSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(27,3)=myval;
		var myval=DHCWebD_GetObjValue("CardYBParkSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(27,7)=myval;

		xlsheet.cells(28,3)=DHCWebD_GetObjValue("CardParkINVInfo");


		xlsheet.cells(30,3)=DHCWebD_GetObjValue("PRDGetNum");
		var myval=DHCWebD_GetObjValue("PRDGetSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(30,7)=myval;

		xlsheet.cells(31,3)=DHCWebD_GetObjValue("PRDParkNum");
		var myval=DHCWebD_GetObjValue("PRDParkSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(31,7)=myval;

		var myval=DHCWebD_GetObjValue("PRDCashSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(32,3)=myval;
		var myval=DHCWebD_GetObjValue("PRDCheckSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(32,7)=myval;
		var myval=DHCWebD_GetObjValue("PRDOtherPaySum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(33,4)=myval;
		
		//
	    ////xlsheet.cells(26,3)=myTotlNum.toFixed(0);		
	    xlsheet.cells(36,8)=UserCode
	    //
	    var myRepID=DHCWebD_GetObjValue("RepID");
	    xlsheet.cells(4,3)=myRepID
	    
	    ///var obj=document.getElementById("RCatEncmeth");
		///if (obj) {var encmeth=obj.value} else {var encmeth=''};
		///if (encmeth!="") {
		///	var CatData=cspRunServerMethod(encmeth,RepID);
		///}
		
		///var myCatAry=CatData.split("^");
		///var myrow=1,mycol=1;
		///var myPRows=10;
		///var myBegRow=11;
	    ///for (var i=0;i<myCatAry.length;i++){
		///    mycol=parseInt(i/myPRows);
		///    myrow=i-mycol*myPRows;
		///    var myDataAry=myCatAry[i].split(String.fromCharCode(2));
		///    xlsheet.cells(myBegRow+myrow,2+mycol*4)=myDataAry[0];
		///    xlsheet.cells(myBegRow+myrow,4+mycol*4)=myDataAry[1];
	    ///}
		
	    xlsheet.printout
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet=null
	} catch(e) {
		alert(e.message);
	};
}



function PrintClickHandlerNBRep(){
	///NBMZYY  Hospital
	
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
	    var Template=TemplatePath+"HospOPFoot.xls";
	    
	    var obj=document.getElementById("sUser");
	    if (obj){
		    var UserCode=obj.value;
	    }
	    
	    var obj=document.getElementById("CashNUM");
	    if (obj){CashNUM=obj.value}
	    
	    ////var obj=document.getElementById("HSDate");
	    var obj=document.getElementById("StartDate");
	    if (obj) {BeginDate=obj.value;}
	    if (myencmeth!=""){
		    BeginDate=cspRunServerMethod(myencmeth,BeginDate);
	    }
	    var obj=document.getElementById("StartTime");
	    if (obj)  BeginDate=BeginDate+" "+ obj.value;
	    
	    ///var obj=document.getElementById("HEDate");
	    var obj=document.getElementById("EndDate");
	    if (obj) EndDate=obj.value;
	    if (myencmeth!=""){
		    EndDate=cspRunServerMethod(myencmeth,EndDate);
	    }
	    var PDate=EndDate;
	    var obj=document.getElementById("EndTime");
	    if (obj) EndDate=EndDate+" "+obj.value;
	    
	    var obj=document.getElementById("TotalFee");
	    if (obj) TotalSum=obj.value;
	    
	    var obj=document.getElementById("HandSum");
	    if (obj) PatPaySum=obj.value;
	    
	    var obj=document.getElementById("PayorTotal");
	    if (obj) PayorSum=obj.value;

	    var obj=document.getElementById("INVNOinfo");
	    if (obj) INVInfo=obj.value;
		
	    var obj=document.getElementById("CancelNUM");
	    if (obj) ParkNum=obj.value;

	    var obj=document.getElementById("CancelSUM");
	    if (obj) ParkSum=obj.value;

	    var obj=document.getElementById("ParkINV");
	    if (obj) ParkINVInfo=obj.value;
		
	    var obj=document.getElementById("CheckNUM");
	    if (obj) CheckNum=obj.value;

	    var obj=document.getElementById("CheckSUM");
	    if (obj) CheckSum=obj.value;

	    var obj=document.getElementById("RefundNUM");
	    if (obj) RefundNum=obj.value;

	    var obj=document.getElementById("RefundSUM");
	    if (obj) RefundSum=obj.value;
	    
	    var obj=document.getElementById("RefundINV");
	    if (obj) RefundINVInfo=obj.value;
		
		//parseInt(TObj.style.height,10);
		if (isNaN(RefundNum)){RefundNum=0;}
		myTotlNum=myTotlNum+parseFloat(RefundNum);
		
		if (isNaN(CheckNum)){CheckNum=0;}
		////myTotlNum=myTotlNum+parseFloat(CheckNum);
		
		if (isNaN(ParkNum)){ParkNum=0;}
		myTotlNum=myTotlNum+parseFloat(ParkNum);
		
		if (isNaN(CashNUM)){CashNUM=0;}
		///myTotlNum=myTotlNum+parseFloat(CashNUM);
		
		var myCashSUM=DHCWebD_GetObjValue("CashSUM");
		if (isNaN(myCashSUM)){myCashSUM=0.00;}
		var myCredCardNum=DHCWebD_GetObjValue("CredCardNum");
		if (isNaN(myCredCardNum)){myCredCardNum=0;}
		var myCredCardSum=DHCWebD_GetObjValue("CredCardSum");
		if (isNaN(myCredCardSum)){myCredCardSum=0.00;}
		var myOtherNum=DHCWebD_GetObjValue("OtherNum");
		if (isNaN(myOtherNum)){myOtherNum=0;}
		var myOtherSum=DHCWebD_GetObjValue("OtherSum");
		if (isNaN(myOtherSum)){myOtherSum=0.00}
		
		
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.cells(4,7)=PDate;
	    xlsheet.cells(5,3)=BeginDate;	
	    xlsheet.cells(6,3)=EndDate;	
	    
	    xlsheet.cells(8,3)=TotalSum;	
	    xlsheet.cells(8,6)=PatPaySum;	
		
	    xlsheet.cells(36,3)=TotalSum;
	    xlsheet.cells(36,6)=PatPaySum;
	    
	    xlsheet.cells(9,3)=INVInfo;
	    
	    xlsheet.cells(10,3)=CashNUM;
	    xlsheet.cells(10,7)=myCashSUM;
	    xlsheet.cells(11,3)=CheckNum;		
	    xlsheet.cells(11,7)=CheckSum;		
		xlsheet.cells(12,3)=myCredCardNum;
		xlsheet.cells(12,7)=myCredCardSum;
		
		var myJZNum=DHCWebD_GetObjValue("JZNum");
		if (isNaN(myJZNum)){myJZNum=0;}
		xlsheet.cells(13,3)=myJZNum;
		var myJZSum=DHCWebD_GetObjValue("JZSum");
		if (isNaN(myJZSum)){myJZSum=0;}
		xlsheet.cells(13,7)=myJZSum;
		
		var myYBTCSum=DHCWebD_GetObjValue("YBTCSum");
		if (isNaN(myYBTCSum)){myYBTCSum=0;}
		xlsheet.cells(14,7)=myYBTCSum;
		
		xlsheet.cells(15,3)=myOtherNum;
		xlsheet.cells(15,7)=myOtherSum;
		
		var myXXNum=parseInt(CashNUM)+parseInt(CheckNum)+parseInt(myCredCardNum)+parseInt(myOtherNum)+parseInt(myJZNum);
		var myXXSum=parseFloat(myCashSUM)+parseFloat(CheckSum)+parseFloat(myCredCardSum)+parseFloat(myOtherSum)+parseFloat(myJZSum)+parseFloat(myYBTCSum);
		xlsheet.cells(16,3)=myXXNum;
		xlsheet.cells(16,7)=myXXSum;
		myTotlNum=myTotlNum+parseInt(myXXNum);
		
		//
	    xlsheet.cells(23,3)=ParkNum;		
	    xlsheet.cells(23,7)=ParkSum;	
	    xlsheet.cells(24,3)=ParkINVInfo;	
	    xlsheet.cells(25,3)=RefundNum;		
	    xlsheet.cells(25,7)=RefundSum;		
	    xlsheet.cells(26,3)=RefundINVInfo;		
	    
	    var myRefCashNum=DHCWebD_GetObjValue("RefCashNum");
	    xlsheet.cells(28,3)=myRefCashNum;
	    var myRefCashSum=DHCWebD_GetObjValue("RefCashSum");
	    xlsheet.cells(28,7)=myRefCashSum
		
		var myRefCheckNum=DHCWebD_GetObjValue("RefCheckNum");
	    xlsheet.cells(29,3)=myRefCheckNum
	    var myRefCheckSum=DHCWebD_GetObjValue("RefCheckSum");
	    xlsheet.cells(29,7)=myRefCheckSum
		
		var myRefCredCardNum=DHCWebD_GetObjValue("RefCredCardNum");
	    xlsheet.cells(30,3)=myRefCredCardNum
	    var myRefCredCardSum=DHCWebD_GetObjValue("RefCredCardSum");
	    xlsheet.cells(30,7)=myRefCredCardSum
	    
	    var myRefJZNum=DHCWebD_GetObjValue("RefJZNum");
	    xlsheet.cells(31,3)=myRefJZNum;
	    var myRefJZSum=DHCWebD_GetObjValue("RefJZSum");
	    xlsheet.cells(31,7)=myRefJZSum;
		
		var myRefYBTCSum=DHCWebD_GetObjValue("RefYBTCSum");
	    xlsheet.cells(32,7)=myRefYBTCSum;
		
		var myRefOtherNum=DHCWebD_GetObjValue("RefOtherNum");
	    xlsheet.cells(33,3)=myRefOtherNum;
	    var myRefOtherSum=DHCWebD_GetObjValue("RefOtherSum");
	    xlsheet.cells(33,7)=myRefOtherSum;
	    
	    xlsheet.cells(34,8)=UserCode;		
	    xlsheet.cells(34,3)=myTotlNum.toFixed(0);		
		
		var myTCashSum=0;
		var myYHSum=0;
		var myCashSUM=DHCWebD_GetObjValue("CashSUM");
		myCashSUM=parseFloat(myCashSUM);
		if (isNaN(myCashSUM)){myCashSUM=0;}
		var myRefCashSum=DHCWebD_GetObjValue("RefCashSum");
		myRefCashSum=parseFloat(myRefCashSum);
		if (isNaN(myRefCashSum)){myRefCashSum=0;}
		if (isNaN(TotalSum)){TotalSum=0;}
		if (isNaN(PatPaySum)){PatPaySum=0;}
		
		myTCashSum=(myCashSUM+myRefCashSum);
		myTCashSum=parseFloat(myTCashSum);
		myYHSum=(TotalSum-PatPaySum);
		myYHSum=parseFloat(myYHSum);
		
	    xlsheet.cells(37,3)=myTCashSum.toFixed(2);
	    xlsheet.cells(37,6)=myYHSum.toFixed(2);
	    
	    //
	    var myRepID=DHCWebD_GetObjValue("RepID");
	    xlsheet.cells(4,3)=myRepID
	    
	    ///var obj=document.getElementById("RCatEncmeth");
		///if (obj) {var encmeth=obj.value} else {var encmeth=''};
		///if (encmeth!="") {
		
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
		///alert(TemplatePath);
		//var objtbl=document.getElementById('tUDHCPrescript_Print');
		//var rows=objtbl.rows.length;
		//var Rowid,OrderName,StartDate,SeqNo,DoseQty,DoseUOM,Priority,Status;
		//var Frequence,Instruction,Duration,PackQty,RecDep,Billed,Price,Sum,BillType;
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
	    var Template=TemplatePath+"HospOPFoot.xls";
	    
	    var obj=document.getElementById("sUser");
	    if (obj){
		    var UserCode=obj.value;
	    }
	    
	    var obj=document.getElementById("CashNUM");
	    if (obj){CashNUM=obj.value}
	    
	    ////var obj=document.getElementById("HSDate");
	    var obj=document.getElementById("StartDate");
	    if (obj) {BeginDate=obj.value;}
	    if (myencmeth!=""){
		    BeginDate=cspRunServerMethod(myencmeth,BeginDate);
	    }
	    var obj=document.getElementById("StartTime");
	    if (obj)  BeginDate=BeginDate+" "+ obj.value;
	    
	    ///var obj=document.getElementById("HEDate");
	    var obj=document.getElementById("EndDate");
	    if (obj) EndDate=obj.value;
	    if (myencmeth!=""){
		    EndDate=cspRunServerMethod(myencmeth,EndDate);
	    }
	    // +add by shd 2017-02-14 获取当前时间
		var date = new Date();
		var year=date.getFullYear(); 
		var month=date.getMonth()+1; 
		var day=date.getDate();
		var CurrDate=year+"-"+month+"-"+day
		// +end;
	    var PDate=CurrDate;
	    var obj=document.getElementById("EndTime");
	    if (obj) EndDate=EndDate+" "+obj.value;
	    
	    var obj=document.getElementById("TotalFee");
	    if (obj) TotalSum=obj.value;
	    
	    var obj=document.getElementById("HandSum");
	    if (obj) PatPaySum=obj.value;
	    
	    var obj=document.getElementById("PayorTotal");
	    if (obj) PayorSum=obj.value;

	    var obj=document.getElementById("INVNOinfo");
	    if (obj) INVInfo=obj.value;
		
	    var obj=document.getElementById("CancelNUM");
	    if (obj) ParkNum=obj.value;

	    var obj=document.getElementById("CancelSUM");
	    if (obj) ParkSum=obj.value;

	    var obj=document.getElementById("ParkINV");
	    if (obj) ParkINVInfo=obj.value;
		
	    var obj=document.getElementById("CheckNUM");
	    if (obj) CheckNum=obj.value;

	    var obj=document.getElementById("CheckSUM");
	    if (obj) CheckSum=obj.value;

	    var obj=document.getElementById("RefundNUM");
	    if (obj) RefundNum=obj.value;

	    var obj=document.getElementById("RefundSUM");
	    if (obj) RefundSum=obj.value;
	    
	    var obj=document.getElementById("RefundINV");
	    if (obj) RefundINVInfo=obj.value;
		
		//parseInt(TObj.style.height,10);
		if (isNaN(RefundNum)){RefundNum=0;}
		myTotlNum=myTotlNum+parseFloat(RefundNum);
		
		if (isNaN(CheckNum)){CheckNum=0;}
		myTotlNum=myTotlNum+parseFloat(CheckNum);
		
		if (isNaN(ParkNum)){ParkNum=0;}
		myTotlNum=myTotlNum+parseFloat(ParkNum);
		
		if (isNaN(CashNUM)){CashNUM=0;}
		myTotlNum=myTotlNum+parseFloat(CashNUM);
		
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.cells(4,7)=PDate;
	    xlsheet.cells(5,3)=BeginDate;	
	    xlsheet.cells(6,3)=EndDate;	
	    
	    xlsheet.cells(8,3)=TotalSum;	
	    xlsheet.cells(8,6)=PatPaySum;	
	    xlsheet.cells(8,9)=PayorSum;	
	    xlsheet.cells(9,3)=INVInfo;		
	    xlsheet.cells(10,3)=CheckNum;		
	    xlsheet.cells(10,7)=CheckSum;		

		//
	    xlsheet.cells(21,3)=ParkNum;		
	    xlsheet.cells(21,7)=ParkSum;	
	    xlsheet.cells(22,3)=ParkINVInfo;	
	    xlsheet.cells(23,3)=RefundNum;		
	    xlsheet.cells(23,7)=RefundSum;		
	    xlsheet.cells(24,3)=RefundINVInfo;		
	    
	    xlsheet.cells(26,8)=UserCode;		
	    xlsheet.cells(26,3)=myTotlNum.toFixed(0);		
	    
	    //
	    var CatData="";
	    var RepID="";
	    var obj=document.getElementById("RepID");
	    if (obj){
		    RepID=obj.value;
	   	}
	    var obj=document.getElementById("RCatEncmeth");
		if (obj) {var encmeth=obj.value} else {var encmeth=''};
		if (encmeth!="") {
			var CatData=cspRunServerMethod(encmeth,RepID);
		}
		
		var myCatAry=CatData.split("^");
		var myrow=1,mycol=1;
		var myPRows=10;
		var myBegRow=11;
	    for (var i=0;i<myCatAry.length;i++){
		    mycol=parseInt(i/myPRows);
		    myrow=i-mycol*myPRows;
		    var myDataAry=myCatAry[i].split(String.fromCharCode(2));
		    xlsheet.cells(myBegRow+myrow,2+mycol*4)=myDataAry[0];
		    xlsheet.cells(myBegRow+myrow,4+mycol*4)=myDataAry[1];
	    }
			    
	    xlsheet.printout
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet=null
	} catch(e) {
		alert(e.message);
	};
}

function PrintSubCatClickHandler(){
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
        var BeginDate,EndDate,TotalSum,PatPaySum,PayorSum;
		var ParkINVInfo,ParkSum,ParkNum;
	    var RefundINVInfo,RefundSum,RefundNum,CheckSum,CheckNum;
        var INVInfo;
        
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"HospOPFoot.xls";
	    
	    var obj=document.getElementById("StartDate");
	    if (obj) {BeginDate=obj.value;}
	    var obj=document.getElementById("StartTime");
	    if (obj)  BeginDate=BeginDate+" "+ obj.value;
	    
	    var obj=document.getElementById("EndDate");
	    if (obj) EndDate=obj.value;
	    var PDate=EndDate;
	    var obj=document.getElementById("EndTime");
	    if (obj) EndDate=EndDate+" "+obj.value;
	    
	    var obj=document.getElementById("TotalFee");
	    if (obj) TotalSum=obj.value;
	    
	    var obj=document.getElementById("HandSum");
	    if (obj) PatPaySum=obj.value;
	    
	    var obj=document.getElementById("PayorTotal");
	    if (obj) PayorSum=obj.value;

	    var obj=document.getElementById("INVNOinfo");
	    if (obj) INVInfo=obj.value;
		
	    var obj=document.getElementById("CancelNUM");
	    if (obj) ParkNum=obj.value;

	    var obj=document.getElementById("CancelSUM");
	    if (obj) ParkSum=obj.value;

	    var obj=document.getElementById("ParkINV");
	    if (obj) ParkINVInfo=obj.value;
		
	    var obj=document.getElementById("CheckNUM");
	    if (obj) CheckNum=obj.value;

	    var obj=document.getElementById("CheckSUM");
	    if (obj) CheckSum=obj.value;

	    var obj=document.getElementById("RefundNUM");
	    if (obj) RefundNum=obj.value;

	    var obj=document.getElementById("RefundSUM");
	    if (obj) RefundSum=obj.value;
	    
	    var obj=document.getElementById("RefundINV");
	    if (obj) RefundINVInfo=obj.value;
		
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.cells(4,7)=PDate;
	    xlsheet.cells(5,3)=BeginDate;	//开始时间
	    xlsheet.cells(6,3)=EndDate;	//结束时间
	    xlsheet.cells(8,3)=TotalSum;	//总金额
	    xlsheet.cells(8,6)=PatPaySum;	//实收额
	    xlsheet.cells(8,9)=PayorSum;	//公费金额
	    xlsheet.cells(9,3)=INVInfo;		//票据号码
	    xlsheet.cells(31,3)=ParkNum;		///废票人次
	    xlsheet.cells(31,7)=ParkSum;	///废票金额
	    xlsheet.cells(32,3)=ParkINVInfo;	//废票号码
	    xlsheet.cells(33,3)=CheckNum;		///支票人次
	    xlsheet.cells(33,7)=CheckSum;		///支票金额
	    xlsheet.cells(34,3)=RefundNum;		///退票人次(红冲)
	    xlsheet.cells(34,7)=RefundSum;		///退票金额(红冲)
	    xlsheet.cells(35,3)=RefundINVInfo;		///退票号码(红冲)
	    
	    //写子类?
	    var CatData="";
	    var obj=document.getElementById("RSubCatEncmeth");
		if (obj) {var encmeth=obj.value} else {var encmeth=''};
		if (encmeth!="") {
			var CatData=cspRunServerMethod(encmeth);
		}
		
		var myCatAry=CatData.split("^");
		var myrow=1,mycol=1;
		var myPRows=20;
	    for (var i=0;i<myCatAry.length;i++){
		    mycol=parseInt(i/myPRows);
		    myrow=i-mycol*myPRows;
		    var myDataAry=myCatAry[i].split(String.fromCharCode(2));
		    xlsheet.cells(11+myrow,2+mycol*4)=myDataAry[0];
		    xlsheet.cells(11+myrow,4+mycol*4)=myDataAry[1];
	    }
	    
	    xlsheet.printout
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet=null
	} catch(e) {
		alert(e.message);
	};
}

function PrintClickHandlerBJJSTYYRep(){
	///BJJSTYY  Hospital
	
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
	    var Template=TemplatePath+"BJJSTHospOPFoot.xls";
	    
	    var obj=document.getElementById("sUser");
	    if (obj){
		    var UserCode=obj.value;
	    }
	    
	    var obj=document.getElementById("CashNUM");
	    if (obj){CashNUM=obj.value}
	    
	    ////var obj=document.getElementById("HSDate");
	    var obj=document.getElementById("StartDate");
	    if (obj) {BeginDate=obj.value;}
	    if (myencmeth!=""){
		    BeginDate=cspRunServerMethod(myencmeth,BeginDate);
	    }
	    var obj=document.getElementById("StartTime");
	    if (obj)  BeginDate=BeginDate+" "+ obj.value;
	    
	    ///var obj=document.getElementById("HEDate");
	    var obj=document.getElementById("EndDate");
	    if (obj) EndDate=obj.value;
	    if (myencmeth!=""){
		    EndDate=cspRunServerMethod(myencmeth,EndDate);
	    }
	    var PDate=EndDate;
	    var obj=document.getElementById("EndTime");
	    if (obj) EndDate=EndDate+" "+obj.value;
	    
	    var obj=document.getElementById("TotalFee");
	    if (obj) TotalSum=obj.value;
	    
	    var obj=document.getElementById("HandSum");
	    if (obj) PatPaySum=obj.value;
	    
	    var obj=document.getElementById("PayorTotal");
	    if (obj) PayorSum=obj.value;

	    var obj=document.getElementById("INVNOinfo");
	    if (obj) INVInfo=obj.value;
		
	    var obj=document.getElementById("CancelNUM");
	    if (obj) ParkNum=obj.value;

	    var obj=document.getElementById("CancelSUM");
	    if (obj) ParkSum=obj.value;

	    var obj=document.getElementById("ParkINV");
	    if (obj) ParkINVInfo=obj.value;
		
	    var obj=document.getElementById("CheckNUM");
	    if (obj) CheckNum=obj.value;

	    var obj=document.getElementById("CheckSUM");
	    if (obj) CheckSum=obj.value;

	    var obj=document.getElementById("RefundNUM");
	    if (obj) RefundNum=obj.value;

	    var obj=document.getElementById("RefundSUM");
	    if (obj) RefundSum=obj.value;
	    
	    var obj=document.getElementById("RefundINV");
	    if (obj) RefundINVInfo=obj.value;
		
		//parseInt(TObj.style.height,10);
		if (isNaN(RefundNum)){RefundNum=0;}
		if ((RefundNum=="")){RefundNum=0;}
		myTotlNum=myTotlNum+parseFloat(RefundNum);
		
		if (isNaN(CheckNum)){CheckNum=0;}
		////myTotlNum=myTotlNum+parseFloat(CheckNum);
		
		if (isNaN(ParkNum)){ParkNum=0;}
		if ((ParkNum=="")){ParkNum=0;}
		myTotlNum=myTotlNum+parseFloat(ParkNum);
		
		if (isNaN(CashNUM)){CashNUM=0;}
		///myTotlNum=myTotlNum+parseFloat(CashNUM);
		
		var myCashSUM=DHCWebD_GetObjValue("CashSUM");
		if (isNaN(myCashSUM)){myCashSUM=0.00;}
		var myCredCardNum=DHCWebD_GetObjValue("CredCardNum");
		if (isNaN(myCredCardNum)){myCredCardNum=0;}
		var myCredCardSum=DHCWebD_GetObjValue("CredCardSum");
		if (isNaN(myCredCardSum)){myCredCardSum=0.00;}
		var myOtherNum=DHCWebD_GetObjValue("OtherNum");
		if (isNaN(myOtherNum)){myOtherNum=0;}
		var myOtherSum=DHCWebD_GetObjValue("OtherSum");
		if (isNaN(myOtherSum)){myOtherSum=0.00}
		
		
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.cells(4,8)=PDate;
		xlsheet.cells(5,4)=BeginDate+"  ---  " +EndDate;	
		///xlsheet.cells(6,3)=EndDate;	
		
		var myval=DHCWebD_GetObjValue("HandSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(6,4)= myval;
		
		///Add
		var myCashSum=DHCWebD_GetObjValue("CashSUM");
		if(isNaN(myCashSum)){myCashSum=0;}
		if((myCashSum)==""){myCashSum=0;}
		var myPRTCSum=DHCWebD_GetObjValue("PRDCashSum");
		if(isNaN(myPRTCSum)){myPRTCSum=0;}
		if((myPRTCSum=="")){myPRTCSum=0;}
		var myval=parseFloat(myCashSum)+parseFloat(myPRTCSum);
		var myval=DHCWebD_GetObjValue("CashTotal");
		if ((isNaN(myval))||(myval=="")){
			myval=0;
		}
		xlsheet.cells(8,4)=myval ;
		
		var myCheckSum=DHCWebD_GetObjValue("CheckSUM");
		if(isNaN(myCheckSum)){myCheckSum=0;}
		if((myCheckSum=="")){myCheckSum=0;}
		var myPRDCheckSum=DHCWebD_GetObjValue("PRDCheckSum");
		if(isNaN(myPRDCheckSum)){myPRDCheckSum=0;}
		if((myPRDCheckSum=="")){myPRDCheckSum=0;}
		var myval=parseFloat(myCheckSum)+parseFloat(myPRDCheckSum);
		
		var myval=DHCWebD_GetObjValue("CheckTotal");
		if ((isNaN(myval))||(myval=="")){
			myval=0;
		}
		xlsheet.cells(8,7)=myval ;
		
		var myval=DHCWebD_GetObjValue("BankInSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(8,9)= myval;
		
		var myval=DHCWebD_GetObjValue("TotalFee");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(10,4)=myval;
		
		xlsheet.cells(11,4)=INVInfo;
		
		var myval=DHCWebD_GetObjValue("CashNUM");
		xlsheet.cells(14,4)=myval;

		var myval=DHCWebD_GetObjValue("CashSUM");
		xlsheet.cells(14,8)=myval;
		
		var myval=DHCWebD_GetObjValue("CheckNUM");
		xlsheet.cells(16,4)=myval;

		var myval=DHCWebD_GetObjValue("CheckSUM");
		xlsheet.cells(16,8)=myval;
		
		var myval=DHCWebD_GetObjValue("BankCardNum");
		xlsheet.cells(17,4)=myval;
		
		var myval=DHCWebD_GetObjValue("BankCardSum");
		xlsheet.cells(17,8)=myval;

		var myval=DHCWebD_GetObjValue("CancelNUM");
		xlsheet.cells(18,4)=myval;

		var myval=DHCWebD_GetObjValue("CancelSUM");
		xlsheet.cells(18,8)=myval;

		var myval=DHCWebD_GetObjValue("ParkINV");
		xlsheet.cells(19,4)=myval;

		var myval=DHCWebD_GetObjValue("RefundNUM");
		xlsheet.cells(20,4)=myval;

		var myval=DHCWebD_GetObjValue("RefundSUM");
		xlsheet.cells(20,8)=myval;
		
		var myval=DHCWebD_GetObjValue("RefundINV");
		xlsheet.cells(21,4)=myval;

		var myval=DHCWebD_GetObjValue("SARSNum");
		xlsheet.cells(24,4)=myval;
		var myval=DHCWebD_GetObjValue("SARSSum");
		xlsheet.cells(24,8)=myval;
		
		var myval=DHCWebD_GetObjValue("SARSRefNum");
		xlsheet.cells(25,4)=myval;
		var myval=DHCWebD_GetObjValue("SARSRefSum");
		xlsheet.cells(25,8)=myval;
		
		xlsheet.cells(28,4)=DHCWebD_GetObjValue("PRDGetNum");
		var myval=DHCWebD_GetObjValue("PRDGetSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(28,8)=myval;

		xlsheet.cells(29,4)=DHCWebD_GetObjValue("PRDParkNum");
		var myval=DHCWebD_GetObjValue("PRDParkSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(29,8)=myval;

		var myval=DHCWebD_GetObjValue("PRDCashSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(31,4)=myval;
		var myval=DHCWebD_GetObjValue("PRDCheckSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(31,8)=myval;
		///Bank Card Pay
		var myval=DHCWebD_GetObjValue("PRDBankCardSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(32,4)=myval;
		
		var myval=DHCWebD_GetObjValue("PRDOtherPaySum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(32,8)=myval;
		
		
		xlsheet.cells(33,4)=DHCWebD_GetObjValue("CardNum");
		
		var myval=DHCWebD_GetObjValue("CardSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(33,8)=myval;
		
		var myval=DHCWebD_GetObjValue("CardYBSum");
		if(isNaN(myval)){myval=0.00;}
		///xlsheet.cells(22,4)=myval;
		var myval=DHCWebD_GetObjValue("CardPaySum");
		if(isNaN(myval)){myval=0.00;}
		///xlsheet.cells(22,7)=myval;
		
		xlsheet.cells(34,4)=DHCWebD_GetObjValue("CardRefNum");
		var myval=DHCWebD_GetObjValue("CardRefSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(34,8)=myval;

		var myval=DHCWebD_GetObjValue("CardCashRefSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(35,4)=myval;
		var myval=DHCWebD_GetObjValue("CardYBRefSum");
		if(isNaN(myval)){myval=0.00;}
		///xlsheet.cells(24,7)=myval;
		
		xlsheet.cells(36,4)=DHCWebD_GetObjValue("CardRefundINVInfo");
		
		xlsheet.cells(37,4)=DHCWebD_GetObjValue("CardParkNum");
		var myval=DHCWebD_GetObjValue("CardParkSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(37,8)=myval;

		var myval=DHCWebD_GetObjValue("CardCashParkSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(38,4)=myval;
		var myval=DHCWebD_GetObjValue("CardYBParkSum");
		if(isNaN(myval)){myval=0.00;}
		
		xlsheet.cells(39,4)=DHCWebD_GetObjValue("CardParkINVInfo");
		
		//
	    ////xlsheet.cells(26,3)=myTotlNum.toFixed(0);		
	    xlsheet.cells(42,3)=UserCode
	    //
		
	    xlsheet.printout
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet=null
	} catch(e) {
		alert(e.message);
	};
}

function PrintClickHandlerBJJSTYYFinTotalRep(){
	///BJJSTYY  Hospital For Finance  Total Reports
	
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
	    var Template=TemplatePath+"BJJSTHospOPFoot.xls";
	    
	    var obj=document.getElementById("sUser");
	    if (obj){
		    var UserCode=obj.value;
	    }
	    
	    var obj=document.getElementById("CashNUM");
	    if (obj){CashNUM=obj.value}
	    
	    ////var obj=document.getElementById("HSDate");
	    var obj=document.getElementById("StartDate");
	    if (obj) {BeginDate=obj.value;}
	    if (myencmeth!=""){
		    BeginDate=cspRunServerMethod(myencmeth,BeginDate);
	    }
	    var obj=document.getElementById("StartTime");
	    if (obj)  BeginDate=BeginDate+" "+ obj.value;
	    
	    ///var obj=document.getElementById("HEDate");
	    var obj=document.getElementById("EndDate");
	    if (obj) EndDate=obj.value;
	    if (myencmeth!=""){
		    EndDate=cspRunServerMethod(myencmeth,EndDate);
	    }
	    var PDate=EndDate;
	    var obj=document.getElementById("EndTime");
	    if (obj) EndDate=EndDate+" "+obj.value;
	    
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.cells(4,8)=PDate;
		xlsheet.cells(5,4)=BeginDate+"  ---  " +EndDate;	
		///xlsheet.cells(6,3)=EndDate;	
		
		///Add
		
		
		xlsheet.cells(39,4)=DHCWebD_GetObjValue("CardParkINVInfo");
		
		//
	    ////xlsheet.cells(26,3)=myTotlNum.toFixed(0);		
	    xlsheet.cells(42,3)=UserCode
	    //
		
	    xlsheet.printout
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet=null
	} catch(e) {
		alert(e.message);
	};
}


function PrintClickHandlerSHHSYY(){
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
	    var Template=TemplatePath+"HospOPSHHSFoot.xls";
	    
	    var obj=document.getElementById("sUser");
	    if (obj){
		    var UserCode=obj.value;
	    }
	    
	    var obj=document.getElementById("CashNUM");
	    if (obj){CashNUM=obj.value}
	    
	    ////var obj=document.getElementById("HSDate");
	    var obj=document.getElementById("StartDate");
	    if (obj) {BeginDate=obj.value;}
	    if (myencmeth!=""){
		    BeginDate=cspRunServerMethod(myencmeth,BeginDate);
	    }
	    var obj=document.getElementById("StartTime");
	    if (obj)  BeginDate=BeginDate+" "+ obj.value;
	    
	    ///var obj=document.getElementById("HEDate");
	    var obj=document.getElementById("EndDate");
	    if (obj) EndDate=obj.value;
	    if (myencmeth!=""){
		    EndDate=cspRunServerMethod(myencmeth,EndDate);
	    }
	    var PDate=EndDate;
	    var obj=document.getElementById("EndTime");
	    if (obj) EndDate=EndDate+" "+obj.value;
	    
	    var obj=document.getElementById("TotalFee");
	    if (obj) TotalSum=obj.value;
	    
	    var obj=document.getElementById("HandSum");
	    if (obj) PatPaySum=obj.value;
	    
	    var obj=document.getElementById("PayorTotal");
	    if (obj) PayorSum=obj.value;

	    var obj=document.getElementById("INVNOinfo");
	    if (obj) INVInfo=obj.value;
		
	    var obj=document.getElementById("CancelNUM");
	    if (obj) ParkNum=obj.value;

	    var obj=document.getElementById("CancelSUM");
	    if (obj) ParkSum=obj.value;

	    var obj=document.getElementById("ParkINV");
	    if (obj) ParkINVInfo=obj.value;
		
	    var obj=document.getElementById("CheckNUM");
	    if (obj) CheckNum=obj.value;

	    var obj=document.getElementById("CheckSUM");
	    if (obj) CheckSum=obj.value;

	    var obj=document.getElementById("RefundNUM");
	    if (obj) RefundNum=obj.value;

	    var obj=document.getElementById("RefundSUM");
	    if (obj) RefundSum=obj.value;
	    
	    var obj=document.getElementById("RefundINV");
	    if (obj) RefundINVInfo=obj.value;
		
		//parseInt(TObj.style.height,10);
		if (isNaN(RefundNum)){RefundNum=0;}
		myTotlNum=myTotlNum+parseFloat(RefundNum);
		
		if (isNaN(CheckNum)){CheckNum=0;}
		myTotlNum=myTotlNum+parseFloat(CheckNum);
		
		if (isNaN(ParkNum)){ParkNum=0;}
		myTotlNum=myTotlNum+parseFloat(ParkNum);
		
		if (isNaN(CashNUM)){CashNUM=0;}
		myTotlNum=myTotlNum+parseFloat(CashNUM);
		
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.cells(4,3)=session['LOGON.USERCODE'];
	    xlsheet.cells(4,7)=UserCode;
	    
	    xlsheet.cells(5,3)=BeginDate;	
	    xlsheet.cells(5,7)=PDate;
	    xlsheet.cells(6,3)=EndDate;	
	    
	    xlsheet.cells(8,3)=TotalSum;	
	    //xlsheet.cells(8,6)=PatPaySum;	
	    ///xlsheet.cells(8,9)=PayorSum;	
	    xlsheet.cells(9,3)=INVInfo;		
	    ///xlsheet.cells(10,3)=CheckNum;		
	    ///xlsheet.cells(10,7)=CheckSum;		
		
		//
	    xlsheet.cells(21,3)=ParkNum;		
	    xlsheet.cells(21,7)=ParkSum;	
	    xlsheet.cells(22,3)=ParkINVInfo;	
	    xlsheet.cells(23,3)=RefundNum;		
	    xlsheet.cells(23,7)=RefundSum;		
	    xlsheet.cells(24,3)=RefundINVInfo;		
	    
	    xlsheet.cells(26,3)=myTotlNum.toFixed(0);		
	    //
	    var CatData="";
	    var RepID="";
	    var obj=document.getElementById("RepID");
	    if (obj){
		    RepID=obj.value;
	   	}
	    var obj=document.getElementById("RCatEncmeth");
		if (obj) {var encmeth=obj.value} else {var encmeth=''};
		if (encmeth!="") {
			var CatData=cspRunServerMethod(encmeth,RepID);
		}
		
		var myCatAry=CatData.split("^");
		var myrow=1,mycol=1;
		var myPRows=10;
		var myBegRow=11;
	    for (var i=0;i<myCatAry.length;i++){
		    mycol=parseInt(i/myPRows);
		    myrow=i-mycol*myPRows;
		    var myDataAry=myCatAry[i].split(String.fromCharCode(2));
		    xlsheet.cells(myBegRow+myrow,2+mycol*4)=myDataAry[0];
		    xlsheet.cells(myBegRow+myrow,4+mycol*4)=myDataAry[1];
	    }
		var myRMBencmeth=DHCWebD_GetObjValue("TransRMB");
		
		var myval=DHCWebD_GetObjValue("TotalFee");
		xlsheet.cells(25,3)=myval;
	   	if (myRMBencmeth!=""){
		   	var myRMB=cspRunServerMethod(myRMBencmeth,myval);
		   	xlsheet.cells(25,7)=myRMB;
	   	}
		
		var myval=DHCWebD_GetObjValue("JZSum");
		xlsheet.cells(26,3)=myval;
	   	if (myRMBencmeth!=""){
		   	var myRMB=cspRunServerMethod(myRMBencmeth,myval);
		   	xlsheet.cells(26,7)=myRMB;
	   	}
		
		var myval=DHCWebD_GetObjValue("FBWCSum");
		xlsheet.cells(27,3)=myval;
	   	if (myRMBencmeth!=""){
		   	var myRMB=cspRunServerMethod(myRMBencmeth,myval);
		   	xlsheet.cells(27,7)=myRMB;
	   	}
		
		var myval=DHCWebD_GetObjValue("HandSum");
		xlsheet.cells(28,3)=myval;
	   	if (myRMBencmeth!=""){
		   	var myRMB=cspRunServerMethod(myRMBencmeth,myval);
		   	xlsheet.cells(28,7)=myRMB;
	   	}
		
		var myval=DHCWebD_GetObjValue("ACASHSum");
		xlsheet.cells(30,3)=myval;
		var myval=DHCWebD_GetObjValue("ACheckSum");
		xlsheet.cells(30,7)=myval;
		var myval=DHCWebD_GetObjValue("POSum");
		xlsheet.cells(31,3)=myval;
		var myval=DHCWebD_GetObjValue("POSSum");
		xlsheet.cells(31,7)=myval;
		var myval=DHCWebD_GetObjValue("YLSum");
		xlsheet.cells(32,3)=myval;
		
		///Read Ref  INV Info

	    var obj=document.getElementById("ReadParkINVEncrypt");
		if (obj) {var encmeth=obj.value} else {var encmeth=''};
		if (encmeth!="") {
			var CatData=cspRunServerMethod(encmeth,RepID);
			var myCatAry=CatData.split(String.fromCharCode(2));
			var myrow=1,mycol=1;
			var myPRows=10;
			var myPCols=2;
			var myBegRow=36;
		    for (var i=0;i<myCatAry.length;i++){
			    myrow=parseInt(i/myPCols);
			    mycol=i-parseInt(myrow*myPCols);
			    var myDataAry=myCatAry[i].split("^");
			    xlsheet.cells(myBegRow+myrow,2+mycol*4)=myDataAry[0];
			    xlsheet.cells(myBegRow+myrow,4+mycol*4)=myDataAry[1];
		    }
		}
		
	    xlsheet.printout
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet=null
	} catch(e) {
		alert(e.message);
	};
}

function PrintClickHandlerComm(ReportName, RepRowID){
	///
	
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
	    ///var Template=TemplatePath+"HospOPSDHXDYYYFoot.xls";
	    
	    var Template=TemplatePath+ReportName;
	    
	    var obj=document.getElementById("sUser");
	    if (obj){
		    var UserCode=obj.value;
	    }
	    var encmeth=DHCWebD_GetObjValue("ReadRepPrintEncrypt");
	    
	    var myPRTInfo=cspRunServerMethod(encmeth, RepRowID);
	    
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    
	    
	    var myTLAry=myPRTInfo.split(String.fromCharCode(3));
	    var myCellAry=myTLAry[0].split(String.fromCharCode(1));
	    for (var myIdx=0;myIdx<myCellAry.length;myIdx++){
		    var myAry=myCellAry[myIdx].split("^");
		    var myX=myAry[0];
		    var myY=myAry[1];
		    var myVal=myAry[2];
		    if ((!isNaN(myX))&&(!isNaN(myY))){
			    myX=parseFloat(myX);
			    myY=parseFloat(myY);
			    xlsheet.cells(myX, myY)=myVal;
			    if(xlsheet.cells(myX, myY).wrapText){
			    	///xlsheet.cells(myX, myY).entireRow.autoFit();
			    }
		    }
		    
	    }
	    if(myTLAry.length>1){
		    
	    }
	    
		///xlsheet.cells(6,3)=EndDate;	
	    xlsheet.printout
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet=null
	} catch(e) {
		alert(e.message);
	};
}

function PrintClickHandlerCDHXYYRepOld(){
	///CDHXYY  Hospital
	
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
	    var Template=TemplatePath+"HospOPSDHXDYYYFoot.xls";
	    
	    var obj=document.getElementById("sUser");
	    if (obj){
		    var UserCode=obj.value;
	    }
	    
	    var obj=document.getElementById("CashNUM");
	    if (obj){CashNUM=obj.value}
	    
	    ////var obj=document.getElementById("HSDate");
	    var obj=document.getElementById("StartDate");
	    if (obj) {BeginDate=obj.value;}
	    if (myencmeth!=""){
		    BeginDate=cspRunServerMethod(myencmeth,BeginDate);
	    }
	    var obj=document.getElementById("StartTime");
	    if (obj)  BeginDate=BeginDate+" "+ obj.value;
	    
	    ///var obj=document.getElementById("HEDate");
	    var obj=document.getElementById("EndDate");
	    if (obj) EndDate=obj.value;
	    if (myencmeth!=""){
		    EndDate=cspRunServerMethod(myencmeth,EndDate);
	    }
	    var PDate=EndDate;
	    var obj=document.getElementById("EndTime");
	    if (obj) EndDate=EndDate+" "+obj.value;
	    
	    var obj=document.getElementById("TotalFee");
	    if (obj) TotalSum=obj.value;
	    
	    var obj=document.getElementById("HandSum");
	    if (obj) PatPaySum=obj.value;
	    
	    var obj=document.getElementById("PayorTotal");
	    if (obj) PayorSum=obj.value;

	    var obj=document.getElementById("INVNOinfo");
	    if (obj) INVInfo=obj.value;
		
	    var obj=document.getElementById("CancelNUM");
	    if (obj) ParkNum=obj.value;

	    var obj=document.getElementById("CancelSUM");
	    if (obj) ParkSum=obj.value;

	    var obj=document.getElementById("ParkINV");
	    if (obj) ParkINVInfo=obj.value;
		
	    var obj=document.getElementById("CheckNUM");
	    if (obj) CheckNum=obj.value;

	    var obj=document.getElementById("CheckSUM");
	    if (obj) CheckSum=obj.value;

	    var obj=document.getElementById("RefundNUM");
	    if (obj) RefundNum=obj.value;

	    var obj=document.getElementById("RefundSUM");
	    if (obj) RefundSum=obj.value;
	    
	    var obj=document.getElementById("RefundINV");
	    if (obj) RefundINVInfo=obj.value;
		
		//parseInt(TObj.style.height,10);
		if (isNaN(RefundNum)){RefundNum=0;}
		myTotlNum=myTotlNum+parseFloat(RefundNum);
		
		if (isNaN(CheckNum)){CheckNum=0;}
		////myTotlNum=myTotlNum+parseFloat(CheckNum);
		
		if (isNaN(ParkNum)){ParkNum=0;}
		myTotlNum=myTotlNum+parseFloat(ParkNum);
		
		if (isNaN(CashNUM)){CashNUM=0;}
		///myTotlNum=myTotlNum+parseFloat(CashNUM);
		
		var myCashSUM=DHCWebD_GetObjValue("CashSUM");
		if (isNaN(myCashSUM)){myCashSUM=0.00;}
		var myCredCardNum=DHCWebD_GetObjValue("CredCardNum");
		if (isNaN(myCredCardNum)){myCredCardNum=0;}
		var myCredCardSum=DHCWebD_GetObjValue("CredCardSum");
		if (isNaN(myCredCardSum)){myCredCardSum=0.00;}
		var myOtherNum=DHCWebD_GetObjValue("OtherNum");
		if (isNaN(myOtherNum)){myOtherNum=0;}
		var myOtherSum=DHCWebD_GetObjValue("OtherSum");
		if (isNaN(myOtherSum)){myOtherSum=0.00}
		
		
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.cells(4,7)=PDate;
		xlsheet.cells(5,3)=BeginDate+"  ---  " +EndDate;	
		///xlsheet.cells(6,3)=EndDate;	
		
		var myval=DHCWebD_GetObjValue("HandSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(6,3)= myval;
		var myval=DHCWebD_GetObjValue("TotalFee");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(7,3)=myval;
		
		xlsheet.cells(8,3)=INVInfo;
		
		var myval=DHCWebD_GetObjValue("CashNUM");
		if(isNaN(myval)){myval=0;}
		xlsheet.cells(11,3)=myval;
		
		var myval=DHCWebD_GetObjValue("CashSUM");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(11,7)=myval;

		var myval=DHCWebD_GetObjValue("CheckNUM");
		if(isNaN(myval)){myval=0;}
		xlsheet.cells(13,3)=myval;

		var myval=DHCWebD_GetObjValue("CheckSUM");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(13,7)=myval;
		
		var myval=DHCWebD_GetObjValue("CancelNUM");
		if(isNaN(myval)){myval=0;}
		xlsheet.cells(15,3)=myval;

		var myval=DHCWebD_GetObjValue("CancelSUM");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(15,7)=myval;
		
		xlsheet.cells(16,3)=DHCWebD_GetObjValue("ParkINV");
		
		var myval=DHCWebD_GetObjValue("RefundNUM");
		if(isNaN(myval)){myval=0;}
		xlsheet.cells(17,3)=myval;

		var myval=DHCWebD_GetObjValue("RefundSUM");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(17,7)=myval;
		
		xlsheet.cells(18,3)=DHCWebD_GetObjValue("RefundINV");
		
		
		xlsheet.cells(21,3)=DHCWebD_GetObjValue("CardNum");
		
		var myval=DHCWebD_GetObjValue("CardSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(21,7)=myval;

		var myval=DHCWebD_GetObjValue("CardYBSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(22,4)=myval;
		var myval=DHCWebD_GetObjValue("CardPaySum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(22,7)=myval;

		xlsheet.cells(23,3)=DHCWebD_GetObjValue("CardRefNum");
		var myval=DHCWebD_GetObjValue("CardRefSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(23,7)=myval;

		var myval=DHCWebD_GetObjValue("CardCashRefSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(24,3)=myval;
		var myval=DHCWebD_GetObjValue("CardYBRefSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(24,7)=myval;
		
		xlsheet.cells(25,3)=DHCWebD_GetObjValue("CardRefundINVInfo");

		xlsheet.cells(26,3)=DHCWebD_GetObjValue("CardParkNum");
		var myval=DHCWebD_GetObjValue("CardParkSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(26,7)=myval;

		var myval=DHCWebD_GetObjValue("CardCashParkSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(27,3)=myval;
		var myval=DHCWebD_GetObjValue("CardYBParkSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(27,7)=myval;

		xlsheet.cells(28,3)=DHCWebD_GetObjValue("CardParkINVInfo");


		xlsheet.cells(30,3)=DHCWebD_GetObjValue("PRDGetNum");
		var myval=DHCWebD_GetObjValue("PRDGetSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(30,7)=myval;

		xlsheet.cells(31,3)=DHCWebD_GetObjValue("PRDParkNum");
		var myval=DHCWebD_GetObjValue("PRDParkSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(31,7)=myval;

		var myval=DHCWebD_GetObjValue("PRDCashSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(32,3)=myval;
		var myval=DHCWebD_GetObjValue("PRDCheckSum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(32,7)=myval;
		var myval=DHCWebD_GetObjValue("PRDOtherPaySum");
		if(isNaN(myval)){myval=0.00;}
		xlsheet.cells(33,4)=myval;
		
		//
	    ////xlsheet.cells(26,3)=myTotlNum.toFixed(0);		
	    xlsheet.cells(36,8)=UserCode
	    //
	    var myRepID=DHCWebD_GetObjValue("RepID");
	    xlsheet.cells(4,3)=myRepID
	    
	    xlsheet.printout
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet=null
	} catch(e) {
		alert(e.message);
	};
}
 