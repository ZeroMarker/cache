//YYB  2007-05-18
//UDHCJFOP.Handin8

var path
var Guser

var MyPrtAry=new Array();
var MyAryIdx=0


function BodyLoadHandler()
{
   Guser=session['LOGON.USERID'];
   var obj=document.getElementById("BClear");
   if (obj) obj.onclick=BClear_Click; 
   var obj=document.getElementById("BQuery");
   if (obj) obj.onclick=BQuery_Click; 
   var obj=document.getElementById("BHandin");
   DHCWeb_DisBtn(obj);
   var obj=document.getElementById("BDetail");
   if (obj) obj.onclick=ShowDetails; 
   var obj=document.getElementById("BPrint");
   if (obj) obj.onclick=BPrint_Click;
   DHCWeb_DisBtn(obj);
   var obj=document.getElementById("BPrintInvPark");
   if (obj) obj.onclick=BPrintInvPark_Click;
   
   
   var obj=document.getElementById("BillDetails");
   obj.onclick=ShowINVDetails

   	////
   	var obj=document.getElementById("PatCal");
   	if (obj){
	   	obj.onclick=PatCal_OnClick;
   	}
   	///if (obj) obj.onclick=BPrint_Click;
   	var obj=document.getElementById("Test");
   	if (obj){
	   	obj.onclick=ReLoadDD;
   	}
   	document.onkeydown = DHCWeb_EStopSpaceKey;
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
	   // alert(Template)
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
	    if (myencmeth!="") {
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
		
		if (isNaN(CashNUM)){CashNUM=0;}
		myTotlNum=myTotlNum+parseFloat(CashNUM);
		
		if (isNaN(RefundNum)){RefundNum=0;}
		myTotlNum=myTotlNum+parseFloat(RefundNum);
		
		if (isNaN(CheckNum)){CheckNum=0;}
		myTotlNum=myTotlNum+parseFloat(CheckNum);
		
		
		
		if (isNaN(ParkNum)){ParkNum=0;}
		//myTotlNum=myTotlNum+parseFloat(ParkNum);
		
		
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

function ShowDetails()
{
	var Enddobj=document.getElementById("EndDate");
	var Endtobj=document.getElementById("EndTime");
	var stdateobj=document.getElementById("StartDate");
	var StartTime=document.getElementById("StartTime");
	var sUser=document.getElementById("sUser");
	
	var uName=sUser.value
	var Enddate=Enddobj.value;
	var EndTime=Endtobj.value;
	var StDate=stdateobj.value;
	var StTime=StartTime.value;
	
	var StTime="";
	var obj=document.getElementById("StartTime");
	if (obj){
		StTime=obj.value;
	}
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.Details&hUser="+Guser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate+"&StartTime=" +StTime ;
	////alert(lnk);
	var NewWin=open(lnk,"udhcOPHandDetails_Details","top=20,left=20,width=930,height=660,scrollbars=1");
}

function ShowINVDetails()
{
	var Enddobj=document.getElementById("EndDate");
	var Endtobj=document.getElementById("EndTime");
	var stdateobj=document.getElementById("StartDate");
	var StartTime=document.getElementById("StartTime");
	var sUser=document.getElementById("sUser");
	
	var uName=sUser.value
	var Enddate=Enddobj.value;
	var EndTime=Endtobj.value;
	var StDate=stdateobj.value;
	var StTime=StartTime.value;

	var StTime="";
	var obj=document.getElementById("StartTime");
	if (obj){
		StTime=obj.value;
	}

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.INVDetail&sUser="+Guser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
	////alert(lnk);
	var NewWin=open(lnk,"udhcOPHandDetails","top=20,left=20,width=930,height=660,scrollbars=1");
}


function BHandin_Click()
{
	var handencobj=document.getElementById("HandinEncmeth");
	if (handencobj) {var encmeth=handencobj.value} else {var encmeth=''};
	
	///,myenddate,myendtime,mystdate,mysttime,myinvNote,myInvNum
	var myinfo=BuildFootInfo();
	
	var myrtn=confirm(t['03']);
	if (myrtn==false){
		return;
	}
	
	if (encmeth!=""){
		var rtn=(cspRunServerMethod(encmeth,Guser,myinfo)) 
	}
	var mytmpary=rtn.split("^");
	//alert(mytmpary);
	if (mytmpary[0]=="0") {
		alert(t["01"]);
		var obj=document.getElementById("BHandin");
		DHCWeb_DisBtn(obj);
		var obj=document.getElementById("RepID");
		if (obj){
			obj.value=mytmpary[1];
			///alert(obj.value);
		}
		////enable Printer button
		////
   		var Pobj=document.getElementById("BPrint");
   		if (Pobj){ 
   			Pobj.disabled=false;
   			Pobj.onclick=BPrint_Click;
   		}
	}else{
		alert(t["02"]);	  ///
	}
}

function BuildFootInfo(){
	var FootInfo="";
	var myList=new Array;
	
	///HIS_StartDate
	var obj=document.getElementById("StartDate");
	myList[0]=obj.value;	

	var obj=document.getElementById("StartTime");
	myList[1]=obj.value;
	
	var obj=document.getElementById("EndDate");
	myList[2]=obj.value;
	
	var obj=document.getElementById("EndTime");
	myList[3]=obj.value;
	
	///
	var obj=document.getElementById("TotalFee");
	myList[4]=obj.value;
	
	//var obj=document.getElementById("");
	//myList[5]=obj.value;

	var obj=document.getElementById("INVNOinfo");
	myList[6]=obj.value;
	
	var obj=document.getElementById("HandSum");
	myList[7]=obj.value;
	
	var obj=document.getElementById("CashNUM");
	myList[8]=obj.value;
	
	var obj=document.getElementById("CashSUM");
	myList[9]=obj.value;
	
	var obj=document.getElementById("CheckNUM");
	myList[10]=obj.value;
	
	//
	if (isNaN(myList[8])){
		myList[5]=0
	}else{
		myList[5]=parseFloat(myList[8])
	}
	if (isNaN(myList[10])){
	}else{
		myList[5]=myList[5]+parseFloat(myList[10])
	}	

	var obj=document.getElementById("CheckSUM");
	myList[11]=obj.value;
	
	var obj=document.getElementById("RefundNUM");
	myList[12]=obj.value;
	
	var obj=document.getElementById("RefundSUM");
	myList[13]=obj.value;
	
	var obj=document.getElementById("CancelNUM");
	myList[14]=obj.value;
	
	var obj=document.getElementById("CancelSUM");
	myList[15]=obj.value;
	
	var obj=document.getElementById("ParkINV");
	myList[16]=obj.value;
	
	var obj=document.getElementById("RefundINV");
	if (obj){
		myList[17]=obj.value;
	}else{
		myList[17]=""
	}
	
	FootInfo=myList.join("^")
	///alert(FootInfo);
	return FootInfo;
}

function BQuery_Click()
{
	///
   var obj=document.getElementById("BQuery");
   DHCWeb_DisBtn(obj);
	
	var Enddobj=document.getElementById("EndDate");
	var Endtobj=document.getElementById("EndTime");
	var encmeth=''
	var obj=document.getElementById("GetHandsum");
	if (obj) {
		encmeth=obj.value
	}
	if (encmeth!=""){
		////,Enddobj.value,Endtobj.value
		var rtn=(cspRunServerMethod(encmeth,'SetHandsum','',Guser)) 
		///
   		var obj=document.getElementById("BHandin");
		if (rtn==0){
   			if (obj){
	   			obj.disabled=false;
	   			obj.onclick=BHandin_Click;
	   			///
   				var Pobj=document.getElementById("BPrint");
   				if (Pobj){ 
   					//Pobj.disabled=false;
   					///Pobj.onclick=BPrint_Click;
   				}
	   		} 
		}else{
   			DHCWeb_DisBtn(obj);
   			var Pobj=document.getElementById("BPrint");
   			DHCWeb_DisBtn(Pobj);
		}
	}
   
   var obj=document.getElementById("BQuery");
   if (obj) {
	   obj.disabled=false;
	   obj.onclick=BQuery_Click; 
   }
   
}

function SetHandsum(value)
{
	///alert(value)
	var Split_Value=value.split("^");
	var stdateobj=document.getElementById("StartDate");
	var sttimeobj=document.getElementById("StartTime");
	var invnoobj=document.getElementById("INVNOinfo");
	var cashnumobj=document.getElementById("CashNUM");
	var cashsumobj=document.getElementById("CashSUM");
	var checknumobj=document.getElementById("CheckNUM");
	var checksumobj=document.getElementById("CheckSUM");
	var cancelnumobj=document.getElementById("CancelNUM");
	var cancelsumobj=document.getElementById("CancelSUM");
	var refundnumobj=document.getElementById("RefundNUM");
	var refundsumobj=document.getElementById("RefundSUM");
	var HandSumobj=document.getElementById("HandSum");
	var ssumobj=document.getElementById("GetTotal");
	var tsumobj=document.getElementById("GiveTotal");
	var xjobj=document.getElementById("CashTotal");
	var zpobj=document.getElementById("CheckTotal");
	var jybsobj=document.getElementById("ChargeNUM");
	stdateobj.value=Split_Value[0];
	sttimeobj.value=Split_Value[1];
	invnoobj.value=Split_Value[2];
	cashnumobj.value=Split_Value[3];
	cashsumobj.value=Split_Value[10]
	checknumobj.value=Split_Value[4];
	checksumobj.value=Split_Value[11];
	cancelnumobj.value=Split_Value[5];
	cancelsumobj.value=Split_Value[6];
	refundnumobj.value=Split_Value[7];
	refundsumobj.value=Split_Value[8];
	///
	HandSumobj.value=Split_Value[9];
	xjobj.value=Split_Value[10];
	zpobj.value=Split_Value[11];
	ssumobj.value=Split_Value[12];
	tsumobj.value=Split_Value[13];
	jybsobj.value=Split_Value[14];
	///
	
	var obj=document.getElementById("EndDate");
	if (obj){
		obj.value=Split_Value[15];
	}

	var obj=document.getElementById("EndTime");
	if (obj){
		obj.value=Split_Value[16];
	}
	
	var obj=document.getElementById("TotalFee");
	if (obj){
		obj.value=Split_Value[17];
	}

	var obj=document.getElementById("PayorTotal");
	if (obj){
		obj.value=Split_Value[18];
	}

	var obj=document.getElementById("RefundINV");
	if (obj){
		obj.value=Split_Value[19];
	}

	var obj=document.getElementById("ParkINV");
	if (obj){
		obj.value=Split_Value[20];
	}

	var obj=document.getElementById("AllDrugFee");
	if (obj){
		obj.value=Split_Value[21];
	}


	var obj=document.getElementById("AllMedFee");
	if (obj){
		obj.value=Split_Value[22];
	}
	
	var obj=document.getElementById("CashInfo");
	if (obj){
		obj.value=Split_Value[23]+"^"+Split_Value[24]+"^"+Split_Value[25]+"^"+Split_Value[26]+"^"+Split_Value[27]+"^"+Split_Value[28];
	}
	//alert("CashInfo"+obj.value)
	var obj=document.getElementById("ChequeInfo");
	if (obj){
		obj.value=Split_Value[29]+"^"+Split_Value[30]+"^"+Split_Value[31]+"^"+Split_Value[32]+"^"+Split_Value[33]+"^"+Split_Value[34];
	}
	
	//alert(parseFloat("-100.30")+parseFloat("-100.20"));
	xjobj.value=parseFloat(Split_Value[24])+parseFloat(Split_Value[28]);
	zpobj.value=parseFloat(Split_Value[30])+parseFloat(Split_Value[34]);

	//alert("ChequeInfo"+obj.value)
	var obj=document.getElementById("ZGBankInfo");
	if (obj){
		obj.value=Split_Value[37]+"^"+Split_Value[38]+"^"+Split_Value[39]+"^"+Split_Value[40]+"^"+Split_Value[41]+"^"+Split_Value[42];
	}
	//alert("ZGBankInfo"+obj.value)
	var obj=document.getElementById("BJBankInfo");
	if (obj){
		obj.value=Split_Value[43]+"^"+Split_Value[44]+"^"+Split_Value[45]+"^"+Split_Value[46]+"^"+Split_Value[47]+"^"+Split_Value[48];
	}
	//alert("BJBankInfo"+obj.value)
	var obj=document.getElementById("OtherInfo");
	if (obj){
		obj.value=Split_Value[49]+"^"+Split_Value[50]+"^"+Split_Value[51]+"^"+Split_Value[52]+"^"+Split_Value[53]+"^"+Split_Value[54];
	}
	//alert("OtherInfo"+obj.value)


	var obj=document.getElementById("BankCardNum");
	if (obj){
		obj.value=Split_Value[55];
	}
	
		var obj=document.getElementById("BankCardSum");
	if (obj){
		obj.value=Split_Value[56];
	}
	
		var obj=document.getElementById("QTNum");
	if (obj){
		obj.value=Split_Value[57];
	}
	
		var obj=document.getElementById("QTSum");
	if (obj){
		obj.value=Split_Value[58];
	}
	
	var obj=document.getElementById("CardTotal");
	if (obj){
		obj.value=Split_Value[59];
	}
	
	var obj=document.getElementById("OtherTotal");
	if (obj){
		obj.value=Split_Value[60];
	}

	var sUser=document.getElementById("sUser");
	
	var username=session['LOGON.USERNAME'];
	sUser.value=username;
}

function BClear_Click(){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOP.Handin8 ";
	window.location.href=lnk;
}

function transINVStr(myINVStr)
{
	alert(myINVStr);
	alert("DD");
}
function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
}

function ReLoadDD()
{
	var lnk="udhcopbillif.csp?PatientIDNo=6&CardNo=00000006";
	var NewWin=open(lnk,"udhcopbillif","scrollbars=yes,resizable=yes,top=6,left=6,width=1000,height=680");
}


function UnloadHandler(){
	///
	var obj=document.getElementById("KillTmp");
	if (obj){
		var encmeth=obj.value;
		if (encmeth!=""){
			cspRunServerMethod(encmeth);
		}
	}
}

document.body.onload = BodyLoadHandler;

document.body.onunload =UnloadHandler;