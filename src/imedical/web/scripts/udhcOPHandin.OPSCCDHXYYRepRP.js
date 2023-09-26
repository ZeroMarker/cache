////udhcOPHandin.OPSCCDHXYYRepRP.js

var path
var Guser
var m_ReportsXmlData="";
var m_INVPRTReportsXmlData="";
var m_PDReportsXmlData="";
var m_APIReportsXmlData ="";
var m_CardReportsXmlData = "";
var m_CatXmlData="";

function BodyLoadHandler()
{
	
   Guser=session['LOGON.USERID'];
   var obj=document.getElementById("BClear");
   if (obj) obj.onclick=BClear_Click; 
   ///var obj=document.getElementById("BQuery");
   ///if (obj) obj.onclick=BQuery_Click; 
   ///var obj=document.getElementById("BHandin");
   
   var obj=document.getElementById("BDetail");
   if (obj) obj.onclick=ShowDetails; 
   var obj=document.getElementById("BPrint");
   //DHCWeb_DisBtn(obj);
   if (obj){
	   obj.onclick=BPrint_Click;
   }
   
   var obj=document.getElementById("BillDetails");
   if (obj){
		obj.onclick=ShowINVDetails
   }
	var obj=document.getElementById("ParkDetail");
	if (obj){
		obj.onclick=ShowParkINVDetails;
	}
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
   	var obj=document.getElementById("PrePayDetail");
	if (obj){
		obj.onclick=PDFootDetail_Click;
	}
	
	BQuery_Click();
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


function BPrint_Click()
{
	///PrintClickHandler();
	var myRepID=DHCWebD_GetObjValue("RepID");
	if (myRepID==""){
		return;
	}
	
	PrintClickHandlerComm("HospOPSDHXDYYYFoot.xls", myRepID);
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

function PDFootDetail_Click()
{
	var Guser=session['LOGON.USERID'];
	var myStartDate="StartDate"
	var myStartDate=DHCWebD_GetObjValue("StartDate");
	
	var myStartTime=DHCWebD_GetObjValue("StartTime");
	var myEndDate=DHCWebD_GetObjValue("EndDate");
	var myEndTime=DHCWebD_GetObjValue("EndTime");
	
	var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccPDDetail&USERID='+Guser;
	str+="&StDate="+myStartDate+"&StTime="+myStartTime+"&EndDate="+myEndDate+"&EndTime="+myEndTime;
	
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=780,height=520,left=0,top=0')
	//location.href='websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccPDDetail&USERID='+Guser+'&FOOTID=0';
}

function ShowParkINVDetails(){
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

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.ParkINVDetail&sUser="+Guser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
	////alert(lnk);
	var NewWin=open(lnk,"udhcOPHandin_ParkINVDetail","top=20,left=20,width=930,height=660,scrollbars=1");

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

function BQuery_Click()
{
	///
   ///var obj=document.getElementById("BQuery");
   //DHCWeb_DisBtn(obj);
	RemoveRows();
	
	//var Enddobj=document.getElementById("EndDate");
	//var Endtobj=document.getElementById("EndTime");
	
	var myRepID=DHCWebD_GetObjValue("RepID");
	var encmeth=''
	var obj=document.getElementById("GetHandsum");
	if (obj) {
		encmeth=obj.value
	}
	
	if (encmeth!=""){
		////,Enddobj.value,Endtobj.value
		var rtn=(cspRunServerMethod(encmeth,'SetHandsum','SetListQ',myRepID,"")) 
		///
	}
}

function bReportCancle_OnClick()
{
	var myRepID=DHCWebD_GetObjValue("RepID");
	var encmeth=''
	var obj=document.getElementById("CancleRepEncrypt");
	if (obj) {
		encmeth=obj.value
	}
	
	if (encmeth!=""){
		////,Enddobj.value,Endtobj.value
		var rtn=(cspRunServerMethod(encmeth, myRepID,"")) 
		///
		
		if (rtn=="0"){
			DHCWeb_DisBtnA("bReportCancle");
			alert("报表撤销成功!");
		}else
		{
			alert("报表撤销失败,请重试!");
		}
	}	
}

function bReCalculate_OnClick()
{
	var myRepID=DHCWebD_GetObjValue("RepID");
	var encmeth='';
	var obj=document.getElementById("RepReCalculateEncrypt");
	if (obj) {
		encmeth=obj.value
	}
	
	if (encmeth!=""){
		////,Enddobj.value,Endtobj.value
		var rtn=(cspRunServerMethod(encmeth, myRepID,"")) 
		///
		
		if (rtn=="0"){
			DHCWeb_DisBtnA("bReCalculate");
			alert("报表重新计算成功!");
			var myref="";
			var myRepID=DHCWebD_GetObjValue("RepID");
			var mysUser=DHCWebD_GetObjValue("sUser");
			var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.OPSCCDHXYYRepRP&RepID="+myRepID+"&UserRowID="+mysUser;
			window.location.href=lnk;
		}else
		{
			alert("报表重新计算失败,请重试!");
		}
	}
}

function RemoveRows()
{
	var myMaxRow=DHCWeb_GetTBRows("tudhcOPHandin_OPSCCDHXYYRepRP");
	
	var tablistobj=document.getElementById("tudhcOPHandin_OPSCCDHXYYRepRP");
	for (var Idx=1;Idx<myMaxRow;Idx++){
		tablistobj.deleteRow(1);
	}
	DHCWebD_ResetRowItems(tablistobj);
	
}


function SetListQ(TARData){
	var myary=TARData.split("^");
	///Add Row for Current Data
	var myTblObj=document.getElementById("tudhcOPHandin_OPSCCDHXYYRepRP");
	if (myTblObj){
		
		DHCWebD_AddTabRow(myTblObj);
		var myMaxRow=DHCWeb_GetTBRows("tudhcOPHandin_OPSCCDHXYYRepRP");
		if (isNaN(myMaxRow)){myMaxRow=0;}
		var myCurRow=myMaxRow-1;
		var obj=document.getElementById("TTypeDescz"+myCurRow);
		DHCWebD_SetListValueA(obj,myary[0]);
		var obj=document.getElementById("TCashz"+myCurRow);
		DHCWebD_SetListValueA(obj,myary[1]);
		var obj=document.getElementById("TCheckz"+myCurRow);
		DHCWebD_SetListValueA(obj,myary[2]);
		var obj=document.getElementById("TBankCardz"+myCurRow);
		DHCWebD_SetListValueA(obj,myary[3]);
		var obj=document.getElementById("TYBPayz"+myCurRow);
		DHCWebD_SetListValueA(obj,myary[4]);
		var obj=document.getElementById("TDBZHz"+myCurRow);
		DHCWebD_SetListValueA(obj,myary[5]);
		var obj=document.getElementById("THTJZz"+myCurRow);
		DHCWebD_SetListValueA(obj,myary[6]);
		
		var obj=document.getElementById("TBLJZz"+myCurRow);
		DHCWebD_SetListValueA(obj,myary[7]);
		var obj=document.getElementById("TTotalz"+myCurRow);
		DHCWebD_SetListValueA(obj,myary[8]);
		
	}
}

////SpecialInfo

function SetHandsum(value, CatXmlData, SpecialInfo)
{
	
	m_CatXmlData=CatXmlData
	m_ReportsXmlData = value;
	
	SetPatInfoByXML(value);
	
	///HISReportStatus
	///
	var myary=SpecialInfo.split("^");
	
	///can cancle
	if ((myary[0]!="C")&&(myary[1]!="Y")){
		var obj=document.getElementById("bReportCancle");
		if(obj){
			obj.disabled = false;
			obj.onclick = bReportCancle_OnClick;
		}
	}else{
		DHCWeb_DisBtnA("bReportCancle");
	}
	
	if (myary[0]=="C"){
		var obj=document.getElementById("bReCalculate");
		if(obj){
			obj.disabled = false;
			obj.onclick = bReCalculate_OnClick;
		}
	}else{
		DHCWeb_DisBtnA("bReCalculate");
	}
	
}

function SetPatInfoByXML(XMLStr)
{
	///XMLStr ="<PatInfo>"+XMLStr;
	///XMLStr +="</PatInfo>";
	XMLStr ="<?xml version='1.0' encoding='gb2312'?>"+XMLStr
	
	var xmlDoc=DHCDOM_CreateXMLDOM();
	xmlDoc.async = false;
	xmlDoc.loadXML(XMLStr);
	if(xmlDoc.parseError.errorCode != 0) 
	{ 
		alert(xmlDoc.parseError.reason); 
		return; 
	}
	var nodes = xmlDoc.documentElement.childNodes; 
	for(var i=0; i<nodes.length; i++) 
	{
		var myItemName=nodes(i).nodeName;
		var myItemValue= nodes(i).text;
		
		DHCWebD_SetObjValueXMLTrans(myItemName, myItemValue);
		
	}
	delete(xmlDoc);
}


function SetHandsumOld(value)
{
	///alert(value);
	var myary=value.split(String.fromCharCode(3));
	///First  Main  myary[0]
	var myMInfo=myary[0].split("^");
	DHCWebD_SetObjValueB("INVNOinfo",myMInfo[0]);
	
	DHCWebD_SetObjValueB("TotalFee",myMInfo[5]);
	
	DHCWebD_SetObjValueB("HandSum",myMInfo[6]);
	////var HandSumobj=document.getElementById("");
	
	DHCWebD_SetObjValueB("GetTotal",myMInfo[7]);
	
	DHCWebD_SetObjValueB("GiveTotal",myMInfo[8]);
	
	DHCWebD_SetObjValueB("CashTotal",myMInfo[9]);

	DHCWebD_SetObjValueB("CheckTotal",myMInfo[10]);
	
	DHCWebD_SetObjValueB("OtherTotal",myMInfo[11]);
	
	DHCWebD_SetObjValueB("YBSum",myMInfo[12]);
	
	////Cash Invoice Info
	var Split_Value=myary[1].split("^");
	var stdateobj=document.getElementById("StartDate");
	var sttimeobj=document.getElementById("StartTime");
	var cashnumobj=document.getElementById("CashNUM");
	var cashsumobj=document.getElementById("CashSUM");
	var checknumobj=document.getElementById("CheckNUM");
	var checksumobj=document.getElementById("CheckSUM");
	var cancelnumobj=document.getElementById("CancelNUM");
	var cancelsumobj=document.getElementById("CancelSUM");
	var refundnumobj=document.getElementById("RefundNUM");
	var refundsumobj=document.getElementById("RefundSUM");
	var jybsobj=document.getElementById("ChargeNUM");
	stdateobj.value=Split_Value[0];
	sttimeobj.value=Split_Value[1];
	cashnumobj.value=Split_Value[3];
	cashsumobj.value=Split_Value[10]
	checknumobj.value=Split_Value[4];
	checksumobj.value=Split_Value[11];
	cancelnumobj.value=Split_Value[5];
	cancelsumobj.value=Split_Value[6];
	refundnumobj.value=Split_Value[7];
	refundsumobj.value=Split_Value[8];
	///
	jybsobj.value=Split_Value[14];
	///
	DHCWebD_SetObjValueB("EndDate",Split_Value[15])
	DHCWebD_SetObjValueB("EndTime",Split_Value[16])
	
	var obj=document.getElementById("PayorTotal");
	if (obj){
		obj.value=Split_Value[18];
	}
	DHCWebD_SetObjValueB("RefundINV",Split_Value[19]);
	
	DHCWebD_SetObjValueB("ParkINV",Split_Value[20]);
	
	///myCPPNum_"^"_$fn(myCPPSum,"",2)_"^"_myOtherNum_"^"_$fn(myOtherSum,"",2)  ;21--24
	DHCWebD_SetObjValueB("CPPNum",Split_Value[21]);
	DHCWebD_SetObjValueB("CPPSum",Split_Value[22]);
	DHCWebD_SetObjValueB("OtherNum",Split_Value[23]);
	DHCWebD_SetObjValueB("OtherSum",Split_Value[24]);
	
	var username=session['LOGON.USERNAME'];
	////sUser.value=username;
	DHCWebD_SetObjValueB("sUser",username);
	
	////Card Invoice Info   myary[2]
	////alert(myary[2]);
	///	s myNINfo=AccNTotSum_"^"_AccNNum_"^"_AccNINVInfo_"^"_AccNCardPaySum_"^"_AccNYBPaySum_"^"_AccNRefSum_"^"_AccNCashSum
	///
	
	var myAccAry=myary[2].split(String.fromCharCode(4))
	var myINVInfo=myAccAry[1].split("^");
	
	DHCWebD_SetObjValueB("CardSum",myINVInfo[0]);
	DHCWebD_SetObjValueB("CardNum",myINVInfo[1]);
	DHCWebD_SetObjValueB("CardNormalINVInfo",myINVInfo[2]);
	DHCWebD_SetObjValueB("CardPaySum",myINVInfo[3]);
	DHCWebD_SetObjValueB("CardYBSum",myINVInfo[4]);
	
	/// Refund Info
	////s myRefInfo=AccRefTotSum_"^"_AccRefundNum_"^"_AccRefundINVInfo_"^"_AccRefCardPaySum
	////s myRefInfo=myRefInfo_"^"_AccRefYBPaySum_"^"_AccRefRefSum_"^"_AccRefCashSum
	var myRefINVInfo=myAccAry[3].split("^");
	DHCWebD_SetObjValueB("CardRefSum",myRefINVInfo[0]);
	DHCWebD_SetObjValueB("CardRefNum",myRefINVInfo[1]);
	DHCWebD_SetObjValueB("CardRefundINVInfo",myRefINVInfo[2]);
	DHCWebD_SetObjValueB("CardYBRefSum",myRefINVInfo[4]);
	DHCWebD_SetObjValueB("CardCashRefSum",myRefINVInfo[6]);
	
	////Park Info
	////s myParkInfo=AccParkTotSum_"^"_AccParkNum_"^"_AccParkINVInfo_"^"_AccParkCardPaySum
	////s myParkInfo=myParkInfo_"^"_AccParkYBPaySum_"^"_AccParkRefSum_"^"_AccParkCashSum
	var myParkINVInfo=myAccAry[2].split("^");
	DHCWebD_SetObjValueB("CardParkSum",myParkINVInfo[0])
	DHCWebD_SetObjValueB("CardParkNum",myParkINVInfo[1])
	DHCWebD_SetObjValueB("CardParkINVInfo",myParkINVInfo[2])
	DHCWebD_SetObjValueB("CardYBParkSum",myParkINVInfo[4])
	DHCWebD_SetObjValueB("CardCashParkSum",myParkINVInfo[6])
	////DHCWebD_SetObjValueB("",myParkINVInfo[0])
	
	////;s myInfo=mypdnum_"^"_pdsum_"^"_refundnum_"^"_refundsum
	////;s myInfo=myInfo_"^"_cashsum_"^"_chequesum_"^"_othersum
	////Pre Deposit Info
	var myPRDINfo=myary[3].split("^");
	DHCWebD_SetObjValueB("PRDGetNum",myPRDINfo[0])
	DHCWebD_SetObjValueB("PRDGetSum",myPRDINfo[1])
	DHCWebD_SetObjValueB("PRDParkNum",myPRDINfo[2])
	DHCWebD_SetObjValueB("PRDParkSum",myPRDINfo[3])
	DHCWebD_SetObjValueB("PRDCashSum",myPRDINfo[4])
	DHCWebD_SetObjValueB("PRDCheckSum",myPRDINfo[5])
	DHCWebD_SetObjValueB("PRDOtherPaySum",myPRDINfo[6])
	
	///CPPPRTINVSum    CPP  PRT  INV  Sum
	var myCPPPRTINVSum=myary[5];
	DHCWebD_SetObjValueB("CPPPRTINVSum",myCPPPRTINVSum);
	
	
}

function BClear_Click(){
	///PrintClickHandlerComm("HospOPSDHXDYYYFoot.xls", 20);
	///return;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.OPSCCDHXYYRep";
	window.location.href=lnk;
}

function transINVStr(myINVStr)
{
	alert(myINVStr);
	
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