/////udhcOPHandin.NBMZYYRep.js

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
   ////if (obj) obj.onclick=BPrint_Click;
   
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
	PrintClickHandlerNBRep();
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
	////alert(mytmpary);
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
	myList[18]=DHCWebD_GetObjValue("CredCardNum");
	myList[19]=DHCWebD_GetObjValue("CredCardSum");
	myList[20]=DHCWebD_GetObjValue("OtherNum");
	myList[21]=DHCWebD_GetObjValue("OtherSum");
	
	////
	myList[22]=DHCWebD_GetObjValue("JZNum");
	myList[23]=DHCWebD_GetObjValue("JZSum");
	myList[24]=DHCWebD_GetObjValue("YBTCSum");
	///myList[25]=DHCWebD_GetObjValue("");
	///myList[26]=DHCWebD_GetObjValue("");
	///myList[27]=DHCWebD_GetObjValue("");
	
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
	
	var obj=document.getElementById("CredCardNum");
	if (obj){
		obj.value=Split_Value[21];
	}
	var obj=document.getElementById("CredCardSum");
	if (obj){
		obj.value=Split_Value[22];
	}
	var obj=document.getElementById("OtherNum");
	if (obj){
		obj.value=Split_Value[23];
	}
	var obj=document.getElementById("OtherSum");
	if (obj){
		obj.value=Split_Value[24];
	}
	
	////
	////25--29
	///s ret=ret_"^"_myJZNum_"^"_$fn(myJZSum,"",2)_"^"_$fn(myYBTCSum,"",2)_"^"_myRefCashNum_"^"_$fn(myRefCashSum,"",2)
	///30--33
	///s ret=ret_"^"_myRefCheckNum_"^"_$fn(myRefCheckSum,"",2)_"^"_myRefPOSNum_"^"_$fn(myRefPOSSum,"",2)
	///34--38
	///s ret=ret_"^"_myRefJZNum_"^"_$fn(myRefJZSum,"",2)_"^"_$fn(myRefYBSum,"",2)_"^"_myRefOtherNum_"^"_$fn(myRefOtherSum,"",2)
	DHCWebD_SetObjValueA("JZNum",Split_Value[25]);
	DHCWebD_SetObjValueA("JZSum",Split_Value[26]);
	DHCWebD_SetObjValueA("YBTCSum",Split_Value[27]);
	DHCWebD_SetObjValueA("RefCashNum",Split_Value[28]);
	DHCWebD_SetObjValueA("RefCashSum",Split_Value[29]);
	DHCWebD_SetObjValueA("RefCheckNum",Split_Value[30]);
	DHCWebD_SetObjValueA("RefCheckSum",Split_Value[31]);
	DHCWebD_SetObjValueA("RefCredCardNum",Split_Value[32]);
	DHCWebD_SetObjValueA("RefCredCardSum",Split_Value[33]);
	DHCWebD_SetObjValueA("RefJZNum",Split_Value[34]);
	DHCWebD_SetObjValueA("RefJZSum",Split_Value[35]);
	DHCWebD_SetObjValueA("RefYBTCSum",Split_Value[36]);
	DHCWebD_SetObjValueA("RefOtherNum",Split_Value[37]);
	DHCWebD_SetObjValueA("RefOtherSum",Split_Value[38]);
	
	var sUser=document.getElementById("sUser");
	
	var username=session['LOGON.USERNAME'];
	sUser.value=username;
}

function BClear_Click(){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin";
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
