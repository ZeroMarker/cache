////DHCOPFin.XAJDYK.USEMRep.JS

function BodyLoadHandler(){
	var encmeth="";
	var obj=document.getElementById("RepEncmeth");
	if (obj){
		var encmeth=obj.value;
	}
	
	var prtobj=document.getElementById("BPrint");
	if (prtobj){
		prtobj.onclick=BPrint_Click;
	}
	var obj=document.getElementById("sUser");
	if (obj){
		obj.onchange=sUser_OnChange;
	}
	
	var myStartDate=DHCWebD_GetObjValue("StartDate");
	var myEndDate=DHCWebD_GetObjValue("EndDate");
	var myUserRowID=DHCWebD_GetObjValue("UserRowID");

   	var obj=document.getElementById("PatCal");
   	if (obj){
	   	obj.onclick=PatCal_OnClick;
   	}
	
	if ((encmeth!="")){
		var rtnvalue=(cspRunServerMethod(encmeth,myStartDate, myEndDate, myUserRowID));
		var rtnary=rtnvalue.split("^");
		WrtDoc(rtnary);
	}
}

function sUser_OnChange(){
	var mysUser=DHCWebD_GetObjValue("sUser");
	if (mysUser==""){
		DHCWebD_SetObjValueB("UserRowID","");
	}
	
}

function BPrint_Click(){
	PrintClickHandlerSXXARepRP();	
}

function WrtDoc(rtnary){
	//write Document object	
	DHCWebD_SetObjValueB("INVNOinfo",rtnary[0]);
	DHCWebD_SetObjValueB("TotalFee",rtnary[1]);
	DHCWebD_SetObjValueB("HandSum",rtnary[2]);
	
	var obj=document.getElementById("RPEncmeth");
	if (obj){
		var myEncrypt=obj.value;
		var myRMB="";
		myRMB=cspRunServerMethod(myEncrypt, rtnary[2]);
		var myPatPayPYobj=document.getElementById("PatPayPY");
		if (myPatPayPYobj){
			myPatPayPYobj.value=myRMB;
		}
	}

}

function SetAuditUserData(value){
	var myary=value.split("^");
	DHCWebD_SetObjValueB("sUser",myary[1]);
	DHCWebD_SetObjValueB("UserRowID",myary[2]);
}

function PatCal_OnClick(){
	////Calculate the Payor
	////FootCalculate();
	FootExpCalculate();
	return;
}

function FootExpCalculate()	{
	var myTotSum="";
	var obj=document.getElementById("HandSum");
	if (obj){
		myTotSum=obj.value;
	}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPCashExpCal&OperFootSum="+myTotSum;
	var NewWin=open(lnk,"udhcOPCashExpCal","scrollbars=no,resizable=no,top=100,left=100,width=800,height=460");
}


function PrintDoc(){
	///
}

function PrintClickHandlerSXXARepRP(){
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
	   	var myMaxRow=DHCWeb_GetTBRows("tDHCOPFin_XAJDYK_USEMRep");
		///var myTbl=document.getElementById("tudhcOPHandin.XAJDYKRep");
		
		var myrow=1,mycol=1;
		var myPRows=10;
		var myBegRow=7;
	    for (var i=1;i<=myMaxRow;i++){
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


document.body.onload=BodyLoadHandler;
