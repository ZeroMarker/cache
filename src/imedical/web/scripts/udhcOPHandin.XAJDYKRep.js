////udhcOPHandin.XAJDYKRep.js

var path
var Guser

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
   DHCWeb_DisBtn(obj);
   var obj=document.getElementById("BillDetails");
   obj.onclick=ShowINVDetails

   	////
   	var obj=document.getElementById("PatCal");
   	if (obj){
	   	obj.onclick=PatCal_OnClick;
   	}
   	
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


function BPrint_Click()
{
	PrintClickHandlerSXXARep();
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

function RemoveRows()
{
	var myMaxRow=DHCWeb_GetTBRows("tudhcOPHandin_XAJDYKRep");
	
	var tablistobj=document.getElementById("tudhcOPHandin_XAJDYKRep");
	for (var Idx=1;Idx<myMaxRow;Idx++){
		tablistobj.deleteRow(1);
	}
	DHCWebD_ResetRowItems(tablistobj);
	
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
	///alert(mytmpary);
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
	///1	HIS_RowID
	///2	HIS_Date
	///3	HIS_Time
	///
	///HIS_StartDate	4
	var obj=document.getElementById("StartDate");
	myList[4]=obj.value;	
	
	///HIS_StartTime	5
	var obj=document.getElementById("StartTime");
	myList[5]=obj.value;
	
	////6	HIS_EndDate
	var obj=document.getElementById("EndDate");
	myList[6]=obj.value;
	
	///7	HIS_EndTime
	var obj=document.getElementById("EndTime");
	myList[7]=obj.value;
	
	///8	HIS_Amount
	var obj=document.getElementById("TotalFee");
	myList[8]=obj.value;
	
	///9	HIS_User
	myList[9]=session['LOGON.USERID'];
	///10	His_Num
	///
	
	///11	HIS_RcptNO
	myList[11]=DHCWebD_GetObjValue("INVNOinfo");
	
	///12	HIS_Confirm
	///13	 HIS_Collect
	///14	HIS_INSFootDate
	///15	 HIS_INSFootTime
	///16	 HIS_INSFootUser
	///17	HIS_PatSum
	myList[17]=DHCWebD_GetObjValue("HandSum");
	///18	HIS_CashNum
	myList[18]=DHCWebD_GetObjValue("CashNUM");
	///19	HIS_CashSum
	myList[19]=DHCWebD_GetObjValue("CashSUM");
	///20	HIS_CheckNum
	myList[20]=DHCWebD_GetObjValue("CheckNUM");
	///21	HIS_CheckSum
	myList[21]=DHCWebD_GetObjValue("CheckSUM");
	///22	HIS_RefundNum
	myList[22]=DHCWebD_GetObjValue("RefundNUM");
	
	///23	HIS_RefundSum
	myList[23]=DHCWebD_GetObjValue("RefundSUM");
	
	///24	HIS_ParkNum
	myList[24]=DHCWebD_GetObjValue("CancelNUM");
	
	///25	HIS_ParkSum
	myList[25]=DHCWebD_GetObjValue("CancelSUM");
	
	///26	HIS_ParkINVInfo
	myList[26]=DHCWebD_GetObjValue("ParkINV");
	
	///27	HIS_RefundINVInfo
	myList[27]=DHCWebD_GetObjValue("RefundINV");
	///28	HIS_OterPayNum
	///29	 HIS_OterPaySum
	///.....
	
	
	//
	if (isNaN(myList[18])){
		myList[10]=0
	}else{
		myList[10]=parseFloat(myList[18])
	}
	
	if (isNaN(myList[20])){
	}else{
		myList[10]=myList[10]+parseFloat(myList[20])
	}
	
	////HIS_Note3	61
	myList[61]="U";
	
	FootInfo=myList.join("^")
	///alert(FootInfo);
	return FootInfo;
}
function BQuery_Click()
{
	///
   var obj=document.getElementById("BQuery");
   DHCWeb_DisBtn(obj);
	RemoveRows();
	
	var Enddobj=document.getElementById("EndDate");
	var Endtobj=document.getElementById("EndTime");
	var encmeth=''
	var obj=document.getElementById("GetHandsum");
	if (obj) {
		encmeth=obj.value
	}
	if (encmeth!=""){
		////,Enddobj.value,Endtobj.value
		var rtn=(cspRunServerMethod(encmeth,'SetHandsum','SetListQ',Guser)) 
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

function SetListQ(TARData){
	var myary=TARData.split("^");
	///Add Row for Current Data
	
	var myTblObj=document.getElementById("tudhcOPHandin_XAJDYKRep");
	if (myTblObj){
		DHCWebD_AddTabRow(myTblObj);
		var myMaxRow=DHCWeb_GetTBRows("tudhcOPHandin_XAJDYKRep");
		if (isNaN(myMaxRow)){myMaxRow=0;}
		var myCurRow=myMaxRow-1;
		var obj=document.getElementById("Noz"+myCurRow);
		DHCWebD_SetListValueA(obj,myary[0]);
		var obj=document.getElementById("TTarNamez"+myCurRow);
		DHCWebD_SetListValueA(obj,myary[1]);
		var obj=document.getElementById("TTotalSumz"+myCurRow);
		DHCWebD_SetListValueA(obj,myary[2]);
		var obj=document.getElementById("TRefCashSumz"+myCurRow);
		DHCWebD_SetListValueA(obj,myary[3]);
		var obj=document.getElementById("TRefTCSumz"+myCurRow);
		DHCWebD_SetListValueA(obj,myary[4]);
		
		var obj=document.getElementById("TRefChequeSumz"+myCurRow);
		DHCWebD_SetListValueA(obj,myary[5]);
		var obj=document.getElementById("TRefSTCSumz"+myCurRow);
		DHCWebD_SetListValueA(obj,myary[6]);
		var obj=document.getElementById("TRefYLSumz"+myCurRow);
		DHCWebD_SetListValueA(obj,myary[7]);
		
	
		var obj=document.getElementById("TCashSumz"+myCurRow);
		DHCWebD_SetListValueA(obj,myary[8]);
		var obj=document.getElementById("TTCSumz"+myCurRow);
		DHCWebD_SetListValueA(obj,myary[9]);
		var obj=document.getElementById("TChequeSumz"+myCurRow);
		DHCWebD_SetListValueA(obj,myary[10]);
		var obj=document.getElementById("TSTCSumz"+myCurRow);
		DHCWebD_SetListValueA(obj,myary[11]);
		var obj=document.getElementById("TYLSumz"+myCurRow);
		DHCWebD_SetListValueA(obj,myary[12]);

		var obj=document.getElementById("TSumz"+myCurRow);
		DHCWebD_SetListValueA(obj,myary[13]);
		
	}
}

function SetHandsum(value)
{	
	var Split_Value=value.split("^");
	var stdateobj=document.getElementById("StartDate");
	var sttimeobj=document.getElementById("StartTime");
	var invnoobj=document.getElementById("INVNOinfo");
	var cashnumobj=document.getElementById("CashNUM");
	var cashsumobj=document.getElementById("CashSUM");
	var checknumobj=document.getElementById("");
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
	
	DHCWebD_SetObjValueB("INVNOinfo",Split_Value[2]);
	DHCWebD_SetObjValueB("CashNUM",Split_Value[3]);
	DHCWebD_SetObjValueB("CashSUM",Split_Value[10]);
	DHCWebD_SetObjValueB("CheckNUM",Split_Value[4]);
	DHCWebD_SetObjValueB("CheckSUM",Split_Value[11]);
	DHCWebD_SetObjValueB("CancelNUM",Split_Value[5])
	
	DHCWebD_SetObjValueB("CancelSUM",Split_Value[6]);
	DHCWebD_SetObjValueB("RefundNUM",Split_Value[7]);
	DHCWebD_SetObjValueB("RefundSUM", Split_Value[8]);
	
	///
	HandSumobj.value=Split_Value[9];
	DHCWebD_SetObjValueB("CashTotal",Split_Value[10]);
	DHCWebD_SetObjValueB("CheckTotal",Split_Value[11]);
	
	DHCWebD_SetObjValueB("GetTotal", Split_Value[12]);
	DHCWebD_SetObjValueB("GiveTotal",Split_Value[13]);
	DHCWebD_SetObjValueB("ChargeNUM",Split_Value[14]);
	
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
	
	DHCWebD_SetObjValueB("PatPayPY",Split_Value[21]);
	
	var sUser=document.getElementById("sUser");
	
	var username=session['LOGON.USERNAME'];
	sUser.value=username;
}

function BClear_Click(){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.XAJDYKRep";
	window.location.href=lnk;
}

function transINVStr(myINVStr)
{
	alert(myINVStr);
	alert("DD");
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