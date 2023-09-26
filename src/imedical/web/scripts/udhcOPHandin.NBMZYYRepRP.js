////udhcOPHandin.NBMZYYRepRP.JS

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
		var rtnvalue=(cspRunServerMethod(encmeth,RepID));
	}
	var rtnary=rtnvalue.split("^");
	if (rtnary.length<23){
		DHCWeb_DisBtn(prtobj);
	}else{
		WrtDoc(rtnary);
	}
	////Wrt Pay Mode
	
	var encmeth=DHCWebD_GetObjValue("ReadRefPMEncrypt");
	if (encmeth!=""){
		var rtnvalue=(cspRunServerMethod(encmeth,RepID));
		var myary=rtnvalue.split("^");
		WrtPayModeDoc(myary);
	}
   var obj=document.getElementById("BDetail");
   if (obj) obj.onclick=ShowDetails; 
   
   var obj=document.getElementById("BillDetails");
   obj.onclick=ShowINVDetails

}

function ShowDetails()
{
	var Enddobj=document.getElementById("EndDate");
	var Endtobj=document.getElementById("EndTime");
	var stdateobj=document.getElementById("StartDate");
	var StartTime=document.getElementById("StartTime");
	///var sUser=document.getElementById("sUser");
	
	var uName=DHCWebD_GetObjValue("sUser");
	if (uName==""){
		var uName=session['LOGON.USERNAME'];
	}
	///var sUser=session['LOGON.USERID'];
	
	var sUser=DHCWebD_GetObjValue("UserRowID");
	if (sUser==""){
		var sUser=session['LOGON.USERID'];
	}
	
	var Enddate=Enddobj.value;
	var EndTime=Endtobj.value;
	var StDate=stdateobj.value;
	var StTime=StartTime.value;
	
	var StTime="";
	var obj=document.getElementById("StartTime");
	if (obj){
		StTime=obj.value;
	}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.Details&hUser="+sUser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate+"&StartTime=" +StTime ;
	///alert(lnk);
	var NewWin=open(lnk,"udhcOPHandDetails_Details","top=20,left=20,width=930,height=660,scrollbars=1");
}

function ShowINVDetails()
{
	var Enddobj=document.getElementById("EndDate");
	var Endtobj=document.getElementById("EndTime");
	var stdateobj=document.getElementById("StartDate");
	var StartTime=document.getElementById("StartTime");
	var sUser=document.getElementById("sUser");
	
	var uName=DHCWebD_GetObjValue("sUser");
	if (uName==""){
		var uName=session['LOGON.USERNAME'];
	}
	///var sUser=session['LOGON.USERID'];
	
	var sUser=DHCWebD_GetObjValue("UserRowID");
	if (sUser==""){
		var sUser=session['LOGON.USERID'];
	}
	
	var Enddate=Enddobj.value;
	var EndTime=Endtobj.value;
	var StDate=stdateobj.value;
	var StTime=StartTime.value;
	
	var StTime="";
	var obj=document.getElementById("StartTime");
	if (obj){
		StTime=obj.value;
	}

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.INVDetail&sUser="+sUser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
	////alert(lnk);
	var NewWin=open(lnk,"udhcOPHandDetails","top=20,left=20,width=930,height=660,scrollbars=1");
}

function BPrint_Click(){
	////PrintClickHandler();
	PrintClickHandlerNBRep();
}

function WrtPayModeDoc(rtnary){
	//s myParkInfo=myPCashNum_"^"_myPCashSum_"^"_myPCheckNum_"^"_myPCheckSum_"^"_myPPOSNum
	//s myParkInfo=myParkInfo_"^"_myPPOSSum_"^"_myPJZNum_"^"_myPJZSum_"^"_myPYBSum
	//s myParkInfo=myParkInfo_"^"_myPOtherNum_"^"_myPOtherSum

	DHCWebD_SetObjValueB("RefCashNum",rtnary[0]);
	DHCWebD_SetObjValueB("RefCashSum",rtnary[1]);
	DHCWebD_SetObjValueB("RefCheckNum",rtnary[2]);
	DHCWebD_SetObjValueB("RefCheckSum",rtnary[3]);
	DHCWebD_SetObjValueB("RefCredCardNum",rtnary[4]);
	DHCWebD_SetObjValueB("RefCredCardSum",rtnary[5]);
	DHCWebD_SetObjValueB("RefJZNum",rtnary[6]);
	DHCWebD_SetObjValueB("RefJZSum",rtnary[7]);
	DHCWebD_SetObjValueB("RefYBTCSum",rtnary[8]);
	DHCWebD_SetObjValueB("RefOtherNum",rtnary[9]);
	DHCWebD_SetObjValueB("RefOtherSum",rtnary[10]);
}

function WrtDoc(rtnary){
	//write Document object
	///alert(rtnary);
	///alert(rtnary.length)
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
	
	var obj=document.getElementById("CredCardNum");
	if (obj){
		if (isNaN(rtnary[45])||(rtnary[45]=="")){rtnary[45]=0;}
		obj.value=rtnary[45];
	}
	
	var obj=document.getElementById("CredCardSum");
	if (obj){
		if (isNaN(rtnary[46])||(rtnary[46]=="")){rtnary[46]=0;}
		obj.value=parseFloat(rtnary[46]).toFixed(2);
	}
	
	var obj=document.getElementById("OtherNum");
	if (obj){
		if (isNaN(rtnary[28])||(rtnary[28]=="")){rtnary[28]=0;}
		obj.value=rtnary[28];
	}
	
	var obj=document.getElementById("OtherSum");
	if (obj){
		if (isNaN(rtnary[29])||(rtnary[29]=="")){rtnary[29]=0}
		obj.value=parseFloat(rtnary[29]).toFixed(2);
	}

	var obj=document.getElementById("JZNum");
	if (obj){
		if (isNaN(rtnary[52])||(rtnary[52]=="")){rtnary[52]=0;}
		obj.value=rtnary[52];
	}
	
	var obj=document.getElementById("JZSum");
	if (obj){
		if (isNaN(rtnary[53])||(rtnary[53]=="")){rtnary[53]=0;}
		////alert(parseFloat(rtnary[53]).toFixed(2));
		obj.value=parseFloat(rtnary[53]).toFixed(2);
	}
	
	var obj=document.getElementById("YBTCSum");
	if (obj){
		if (isNaN(rtnary[31])||(rtnary[31]=="")){rtnary[31]=0;}
		obj.value=parseFloat(rtnary[31]).toFixed(2);
	}
	
}

function PrintDoc(){
	///
	
}

document.body.onload=BodyLoadHandler;