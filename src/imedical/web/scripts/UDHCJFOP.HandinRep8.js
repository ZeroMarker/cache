////udhcOPHandin.RPQuery.JS
var path
var Guser=session['LOGON.USERID']

var MyPrtAry=new Array();
var MyAryIdx=0

function BodyLoadHandler(){
	var obj=document.getElementById("RepEncmeth");
	if (obj){
		var encmeth=obj.value;
	}
	var obj=document.getElementById("RepID");
	if (obj){
		var RepID=obj.value;
	}
	var prtobj=document.getElementById("BPrint");
	if (prtobj){
		prtobj.onclick=BPrint_Click;
	}
	
	if (encmeth!=""){
		var rtnvalue=(cspRunServerMethod(encmeth,RepID)) 
	}
	var rtnary=rtnvalue.split("^");
	//alert(rtnvalue)
	//alert(rtnary.length)
	if (rtnary.length<23){
		DHCWeb_DisBtn(prtobj);
	}else{
		WrtDoc(rtnary);
	}
	
}

function BPrintInvPark_Click(){
	for (var idx=0;idx<=MyAryIdx;idx=idx+1)
	{
		MyPrtAry[idx]="";
	}
	MyAryIdx=0;
	PrintClickGetVal(); 
	
}

function PrintClickGetVal()
{
	
	//(JSFunName, UserId, StartDate, StartTime, EndDate, EndTime, Flag)
	var StartDate, StartTime, EndDate, EndTime
	var obj=document.getElementById("StartDate");
	if (obj) StartDate=obj.value;
	var obj=document.getElementById("StartTime");
	if (obj) StartTime=obj.value;
	var obj=document.getElementById("EndDate");
	if (obj) EndDate=obj.value;
	var obj=document.getElementById("EndTime");
	if (obj) EndTime=obj.value;
    var Flag=""

	var obj=document.getElementById('getPrintParkInfo');
	if (obj) var encmeth=obj.value;	
	var Printinfo=cspRunServerMethod(encmeth,"WrtExcle",Guser,StartDate,StartTime,EndDate,EndTime,Flag);

}
function WrtExcle(val)
{
	 //alert("val"+val)
	 MyPrtAry[MyAryIdx]=val;
	 MyAryIdx=MyAryIdx+1;
	
}

function BPrint_Click()
{
	BPrintInvPark_Click();
	PrintClickHandlerBJZYY();
	
}

function PrintClickHandlerBJZYY(){
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
	    var Template=TemplatePath+"JFOP_BJZYYDailyRep.xls";
	    //alert(Template)
	    var obj=document.getElementById("sUser");
	    if (obj){
		    var UserCode=obj.value;
	    }
	    
	    var obj=document.getElementById("CashNUM");
	    if (obj){CashNUM=obj.value}
	    
	    ////var obj=document.getElementById("HSDate");
	    var obj=document.getElementById("StartDate");
	    if (obj) {BeginDate=obj.value;}
	    
		/*
	    if (myencmeth!=""){
		    BeginDate=cspRunServerMethod(myencmeth,BeginDate);
	    }
	    	alert('hfklsadfjl')
		*/
	    var obj=document.getElementById("StartTime");
	    if (obj)  BeginDate=BeginDate+" "+ obj.value;
	    
	  
	    ///var obj=document.getElementById("HEDate");
	    var obj=document.getElementById("EndDate");
	    if (obj) EndDate=obj.value;
	     /*
	    if (myencmeth!="") {
		    EndDate=cspRunServerMethod(myencmeth,EndDate);
	    }
	    */
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
		
		if (isNaN(CashNUM)){CashNUM=0;}
		myTotlNum=myTotlNum+parseFloat(CashNUM);
		
		if (isNaN(RefundNum)){RefundNum=0;}
		myTotlNum=myTotlNum+parseFloat(RefundNum);
		
		if (isNaN(CheckNum)){CheckNum=0;}
		//myTotlNum=myTotlNum+parseFloat(CheckNum);
		
		if (isNaN(ParkNum)){ParkNum=0;}
		//myTotlNum=myTotlNum+parseFloat(ParkNum);
		
		//if (isNaN(CashNUM)){CashNUM=0;}
		//myTotlNum=myTotlNum+parseFloat(CashNUM);
		
		var obj=document.getElementById("BankCardNum");
	    if (obj) var myBankCardNum=obj.value;
		
		if (isNaN(myBankCardNum)){myBankCardNum=0;}
		myTotlNum=myTotlNum+parseFloat(myBankCardNum);
		
		
		var obj=document.getElementById("QTNum");
	    if (obj) var myQTNum=obj.value;
		
		if (isNaN(myQTNum)){myQTNum=0;}
		myTotlNum=myTotlNum+parseFloat(myQTNum);
		
		
		
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	   
	   	var GetTotal=""
	    var obj=document.getElementById("GetTotal");
	    if (obj) GetTotal=obj.value;
	    var GiveTotal=""
	    var obj=document.getElementById("GiveTotal");
	    if (obj) GiveTotal=obj.value;
	   
	    var AllDrugFee=""
	    var obj=document.getElementById("AllDrugFee");
	    if (obj) AllDrugFee=obj.value;
	    var AllMedFee=""
	    var obj=document.getElementById("AllMedFee");
	    if (obj) AllMedFee=obj.value;
	    
	    var CurDate=""
	    var obj=document.getElementById("CurDate");
	    if (obj) CurDate=obj.value;

	    
	    var CashInfo=""
	    var ChequeInfo=""
	    var obj=document.getElementById("CashInfo");
	    if (obj) CashInfo=obj.value;
	    var obj=document.getElementById("ChequeInfo");
	    if (obj) ChequeInfo=obj.value;
	     var obj=document.getElementById("ZGBankInfo");
	    if (obj) ZGBankInfo=obj.value;
	     var obj=document.getElementById("BJBankInfo");
	    if (obj) BJBankInfo=obj.value;
	     var obj=document.getElementById("OtherInfo");
	    if (obj) OtherInfo=obj.value;
	   
	   
	    //alert("CashInfo"+CashInfo)
	    //alert("ChequeInfo"+ChequeInfo)
	    var myCashAry=CashInfo.split("^");
	    var myChequeAry=ChequeInfo.split("^");
	     var myZGBankAry=ZGBankInfo.split("^");
	      var myBJBankAry=BJBankInfo.split("^");
	       var myOtherAry=OtherInfo.split("^");

	    {
		    xlsheet.cells(2,7)=BeginDate+"--"+EndDate;
		    xlsheet.cells(3,3)=session['LOGON.USERCODE'];
		    xlsheet.cells(3,5)=session['LOGON.USERNAME'];
		    xlsheet.cells(3,8)=myTotlNum	//CashNUM+CheckNum;
		    xlsheet.cells(3,10)=PatPaySum;
		
		    xlsheet.cells(4,3)=TotalSum;
		    xlsheet.cells(4,5)=PayorSum;
		    xlsheet.cells(4,8)=GetTotal;
		    xlsheet.cells(4,10)=GiveTotal;
		    
		    xlsheet.cells(5,5)=AllDrugFee;
		    xlsheet.cells(5,9)=AllMedFee;
	
	 		xlsheet.cells(7,4)=myCashAry[0];
		    xlsheet.cells(7,5)=myCashAry[1];
		    xlsheet.cells(7,7)=myCashAry[4];
		    xlsheet.cells(7,8)=myCashAry[5];
		    xlsheet.cells(7,9)=myCashAry[2];
		    xlsheet.cells(7,10)=myCashAry[3];
		    
		    xlsheet.cells(8,4)=myChequeAry[0];
		    xlsheet.cells(8,5)=myChequeAry[1];
		    xlsheet.cells(8,7)=myChequeAry[4];
		    xlsheet.cells(8,8)=myChequeAry[5];
		    xlsheet.cells(8,9)=myChequeAry[2];
		    xlsheet.cells(8,10)=myChequeAry[3];

	 			xlsheet.cells(9,4)=myZGBankAry[0];
		    xlsheet.cells(9,5)=myZGBankAry[1];
		    xlsheet.cells(9,7)=myZGBankAry[4];
		    xlsheet.cells(9,8)=myZGBankAry[5];
		    xlsheet.cells(9,9)=myZGBankAry[2];
		    xlsheet.cells(9,10)=myZGBankAry[3];

			xlsheet.cells(10,4)=myBJBankAry[0];
		    xlsheet.cells(10,5)=myBJBankAry[1];
		    xlsheet.cells(10,7)=myBJBankAry[4];
		    xlsheet.cells(10,8)=myBJBankAry[5];
		    xlsheet.cells(10,9)=myBJBankAry[2];
		    xlsheet.cells(10,10)=myBJBankAry[3];

			xlsheet.cells(11,4)=myOtherAry[0];
		    xlsheet.cells(11,5)=myOtherAry[1];
		    xlsheet.cells(11,7)=myOtherAry[4];
		    xlsheet.cells(11,8)=myOtherAry[5];
		    xlsheet.cells(11,9)=myOtherAry[2];
		    xlsheet.cells(11,10)=myOtherAry[3];


	 		xlsheet.cells(12,4)=parseInt(myCashAry[0])+parseInt(myChequeAry[0])+parseInt(myZGBankAry[0])+parseInt(myBJBankAry[0])+parseInt(myOtherAry[0]);
		    xlsheet.cells(12,5)=parseFloat(myCashAry[1])+parseFloat(myChequeAry[1])+parseFloat(myZGBankAry[1])+parseFloat(myBJBankAry[1])+parseFloat(myOtherAry[1]);
		    xlsheet.cells(12,7)=parseInt(myCashAry[4])+parseInt(myChequeAry[4])+parseInt(myZGBankAry[4])+parseInt(myBJBankAry[4])+parseInt(myOtherAry[4]);
		    xlsheet.cells(12,8)=parseFloat(myCashAry[5])+parseFloat(myChequeAry[5])+parseFloat(myZGBankAry[5])+parseFloat(myBJBankAry[5])+parseFloat(myOtherAry[5]);
		    xlsheet.cells(12,9)=parseInt(myCashAry[2])+parseInt(myChequeAry[2])+parseInt(myZGBankAry[2])+parseInt(myBJBankAry[2])+parseInt(myOtherAry[2]);
		    xlsheet.cells(12,10)=parseFloat(myCashAry[3])+parseFloat(myChequeAry[3])+parseFloat(myZGBankAry[3])+parseFloat(myBJBankAry[3])+parseFloat(myOtherAry[3]);
			
			xlsheet.cells(13,4)=INVInfo;
			
			xlsheet.cells(14,4)=session['LOGON.USERNAME'];
		    xlsheet.cells(14,7)="";
		    xlsheet.cells(14,9)=CurDate;
	    
		}
	    {//print Refund Detail
		   	var xlsrow=18
		   	xlsheet.cells(xlsrow+1,7)=BeginDate+"--"+EndDate;;
		   	xlsrow=xlsrow+2
		   	for (var Row=0;Row<MyAryIdx;Row++)
		    {
				xlsrow=xlsrow+1;
				var ary=MyPrtAry[Row].split("^");
		    	for (var j=0;j<ary.length;j++)
		    	{
			    	xlsheet.cells(xlsrow,j+2)=ary[j];
			    }
		    }
			gridlist(xlsheet,21,xlsrow,2,10);
			xlsrow=xlsrow+1	
							
			xlsheet.cells(xlsrow,2)=t["fu"];
			xlsheet.cells(xlsrow,3)=t["zbr"];
			xlsheet.cells(xlsrow,4)=session['LOGON.USERNAME'];
		    xlsheet.cells(xlsrow,6)=t["shr"];
		    xlsheet.cells(xlsrow,7)="";
		    xlsheet.cells(xlsrow,8)=t["bt"];
		    xlsheet.cells(xlsrow,9)=CurDate;
			
		}
	   
	   // xlsheet.cells(26,3)=myTotlNum.toFixed(0);		
	    
	    /*
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
		alert("CatData:"+CatData)
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
		*/	    
	    xlsheet.printout;
	    xlsheet.printout;
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet=null
	} catch(e) {
		alert(e.message);
	};
}


function WrtDoc(rtnary){
	//write Document object
	//alert(rtnary)
	var obj=document.getElementById("sUser");
	if (obj){
		obj.value=rtnary[0];
	}
	
	///StartDate
	var obj=document.getElementById("StartDate");
	if (obj){
		obj.value=rtnary[4];
	}

	var obj=document.getElementById("StartTime");
	if (obj){
		obj.value=rtnary[5];
	}

	var obj=document.getElementById("EndDate");
	if (obj){
		obj.value=rtnary[6];
	}

	var obj=document.getElementById("EndTime");
	if (obj){
		obj.value=rtnary[7];
	}
	
	//
	var obj=document.getElementById("TotalFee");
	if (obj){
		obj.value=(rtnary[8]);
	}

	var obj=document.getElementById("INVNOinfo");
	if (obj){
		obj.value=rtnary[11];
	}

	var obj=document.getElementById("HandSum");
	if (obj){
		obj.value=rtnary[17];
	}

	var obj=document.getElementById("CashNUM");
	if (obj){
		obj.value=rtnary[18];
	}

	var obj=document.getElementById("CashSUM");
	if (obj){
		obj.value=rtnary[19];
	}

	var obj=document.getElementById("CheckNUM");
	if (obj){
		obj.value=rtnary[20];
	}

	var obj=document.getElementById("CheckSUM");
	if (obj){
		obj.value=rtnary[21];
	}

	var obj=document.getElementById("RefundNUM");
	if (obj){
		obj.value=rtnary[22];
	}

	var obj=document.getElementById("RefundSUM");
	if (obj){
		obj.value=rtnary[23];
	}

	var obj=document.getElementById("CancelNUM");
	if (obj){
		obj.value=rtnary[24];
	}

	var obj=document.getElementById("CancelSUM");
	if (obj){
		obj.value=rtnary[25];
	}

	var obj=document.getElementById("ParkINV");
	if (obj){
		obj.value=rtnary[26];
	}

	var obj=document.getElementById("RefundINV");
	if (obj){
		obj.value=rtnary[27];
	}
	
	///
	if (isNaN(rtnary[8])){
		var paysum=0;
	}else{
		var paysum=parseFloat(rtnary[8]);
	}
	////
	if (!isNaN(rtnary[17])){
		paysum=paysum-parseFloat(rtnary[17]);
	}
	
	var mypaysum=paysum.toFixed(2);
	
	var obj=document.getElementById("PayorTotal");
	if (obj){
		obj.value=mypaysum;
	}
	
	var obj=document.getElementById("AllDrugFee");
	if (obj){
		obj.value=rtnary[68];
	}
	var obj=document.getElementById("AllMedFee");
	if (obj){
		obj.value=rtnary[69];
	}
	
	var obj=document.getElementById("GetTotal");
	if (obj){
		obj.value=rtnary[70];
	}
	var obj=document.getElementById("GiveTotal");
	if (obj){
		obj.value=rtnary[71];
	}
	var obj=document.getElementById("CashTotal");
	if (obj){
		obj.value=rtnary[72];
	}
	var obj=document.getElementById("CheckTotal");
	if (obj){
		obj.value=rtnary[73];
	}
	var obj=document.getElementById("CashInfo");
	if (obj){
		obj.value=rtnary[74]+"^"+rtnary[75]+"^"+rtnary[76]+"^"+rtnary[77]+"^"+rtnary[78]+"^"+rtnary[79];

	}
	
	var obj=document.getElementById("ChequeInfo");
	if (obj){
		obj.value=rtnary[80]+"^"+rtnary[81]+"^"+rtnary[82]+"^"+rtnary[83]+"^"+rtnary[84]+"^"+rtnary[85];
	}
	
	var obj=document.getElementById("ZGBankInfo");
	if (obj){
		obj.value=rtnary[86]+"^"+rtnary[87]+"^"+rtnary[88]+"^"+rtnary[89]+"^"+rtnary[90]+"^"+rtnary[91];
	}

	var obj=document.getElementById("BJBankInfo");
	if (obj){
		obj.value=rtnary[92]+"^"+rtnary[93]+"^"+rtnary[94]+"^"+rtnary[95]+"^"+rtnary[96]+"^"+rtnary[97];
	}
	
	var obj=document.getElementById("OtherInfo");
	if (obj){
		obj.value=rtnary[98]+"^"+rtnary[99]+"^"+rtnary[100]+"^"+rtnary[101]+"^"+rtnary[102]+"^"+rtnary[103];
	}
	
	var obj=document.getElementById("CashTotal");
	if (obj){
		obj.value=parseFloat(rtnary[75])+parseFloat(rtnary[79]);
	}
	var obj=document.getElementById("CheckTotal");
	if (obj){
		obj.value=parseFloat(rtnary[81])+parseFloat(rtnary[85]);
	}

	var obj=document.getElementById("BankCardNum");
	if (obj){
		obj.value=rtnary[104];
	}
	
		var obj=document.getElementById("BankCardSum");
	if (obj){
		obj.value=rtnary[105];
	}
	
		var obj=document.getElementById("QTNum");
	if (obj){
		obj.value=rtnary[106];
	}
	
		var obj=document.getElementById("QTSum");
	if (obj){
		obj.value=rtnary[107];
	}
	
	var obj=document.getElementById("CardTotal");
	if (obj){
		obj.value=rtnary[108];
	}
	
	var obj=document.getElementById("OtherTotal");
	if (obj){
		obj.value=rtnary[109];
	}


	
	
	
	
	

}

function PrintDoc(){
	///
	
	
}

document.body.onload=BodyLoadHandler;