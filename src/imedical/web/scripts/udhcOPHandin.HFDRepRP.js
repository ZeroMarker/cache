////udhcOPHandin.HFDRepRP.js

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
	var obj=document.getElementById("ParkDetail");
	if (obj){
		obj.onclick=ShowParkINVDetails;
	}

   	var obj=document.getElementById("PrePayDetail");
	if (obj){
		obj.onclick=PDFootDetail_Click;
	}

   var obj=document.getElementById("BillDetails");
   if (obj){
		obj.onclick=ShowINVDetails;
   }

   	var obj=document.getElementById("PatCal");
   	if (obj){
	   	obj.onclick=PatCal_OnClick;
   	}
	
	///alert(encmeth);
	if (encmeth!=""){
		var rtnvalue=(cspRunServerMethod(encmeth,RepID)) 
	}
	var rtnary=rtnvalue.split("^");
	if (rtnary.length<23){
		DHCWeb_DisBtn(prtobj);
	}else{
		WrtDoc(rtnary);
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

function BPrint_Click(){
	////PrintClickHandler();
	///PrintClickHandlerNBRep();
	PrintClickHandlerAHSLRep();
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


function PDFootDetail_Click()
{
	var Guser=DHCWebD_GetObjValue("UserRowID");
	if (Guser==""){
		var Guser=session['LOGON.USERID'];
	}
	
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
	///var sUser=document.getElementById("sUser");
	
	var uName=session['LOGON.USERNAME'];
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
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.ParkINVDetail&sUser="+sUser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
	////alert(lnk);
	var NewWin=open(lnk,"udhcOPHandin_ParkINVDetail","top=20,left=20,width=930,height=660,scrollbars=1");

}


function WrtDoc(rtnary){
	//write Document object
	////alert(rtnary);
	///alert(rtnary.length)
	var obj=document.getElementById("sUser");
	if (obj){
		obj.value=rtnary[0];
	}
	
	///StartDate
	DHCWebD_SetObjValueB("StartDate",rtnary[4]);
	////x HIS_StartTime                          His_starttime                 5      xx
	DHCWebD_SetObjValueB("StartTime", rtnary[5]);
	///alert(rtnary[5]);
	////x HIS_EndDate                            His_enddate                   6      xx
	DHCWebD_SetObjValueB("EndDate", rtnary[6]);
	////x HIS_EndTime                            His_endtime                   7      xx
	DHCWebD_SetObjValueB("EndTime", rtnary[7]);
	////HIS_Amount                             His_amount                    8 
	DHCWebD_SetObjValueB("TotalFee", rtnary[8]);
	////x HIS_User                               His_user                      9      xx
	////x His_Num                                His_Num                       10     xx
	
	////x HIS_RcptNO                             HIS_RcptNO                    11     xx
	DHCWebD_SetObjValueB("INVNOinfo",rtnary[11]);
	
	////x HIS_PatSum                             HIS_PatSum                    17     xx
	DHCWebD_SetObjValueB("HandSum", rtnary[17]);
	////HIS_CashNum                            HIS_CashNum                   18   
	DHCWebD_SetObjValueB("CashNUM", rtnary[18]);
	////HIS_CashSum                            HIS_CashSum                   19     x
	DHCWebD_SetObjValueB("CashSUM", rtnary[19]);
	////x HIS_CheckNum                           HIS_CheckNum                  20     x
	DHCWebD_SetObjValueB("CheckNUM", rtnary[20]);
	////x HIS_CheckSum                           HIS_CheckSum                  21     xk
	DHCWebD_SetObjValueB("CheckSUM", rtnary[21]);
	////x HIS_RefundNum                          HIS_RefundNum                 22     xx
	DHCWebD_SetObjValueB("RefundNUM", rtnary[22]);
	////x HIS_RefundSum                          HIS_RefundSum                 23     xx
	DHCWebD_SetObjValueB("RefundSUM", rtnary[23]);
	////x HIS_ParkNum                            HIS_ParkNum                   24     xx
	DHCWebD_SetObjValueB("CancelNUM", rtnary[24]);
	////x HIS_ParkSum                            HIS_ParkSum                   25     xx
	DHCWebD_SetObjValueB("CancelSUM", rtnary[25]);
	////x HIS_ParkINVInfo                        HIS_ParkINVInfo               26     xx
	DHCWebD_SetObjValueB("ParkINV", rtnary[26]);
	////x HIS_RefundINVInfo                      HIS_RefundINVInfo             27     xx
	DHCWebD_SetObjValueB("RefundINV", rtnary[27]);
	
	///HIS_StartDate
	
	////;Add more
	////>27   Write
	////x HIS_OterPayNum                         HIS_OterPayNum                28     xx
	DHCWebD_SetObjValueB("OtherNum", rtnary[28]);
	////x HIS_OterPaySum                         HIS_OterPaySum                29     xx
	DHCWebD_SetObjValueB("OtherSum", rtnary[29]);
	////x HIS_INVPrtNote                         HIS_Note3                     30     xx
	///rtnary[30]=""		////DHCWebD_SetObjValueB("");
	////x HIS_YBSum                               HIS_YBSum  for DHC_INVPRT t  31    
	DHCWebD_SetObjValueB("YBSum", rtnary[31]);
	///alert(rtnary[31]);
	////x HIS_CardNum                            HIS_CardNum                   32     xx	
	DHCWebD_SetObjValueB("CardNum",rtnary[32]);
	////x HIS_CardSum                            HIS_CardSum                   33     xx
	DHCWebD_SetObjValueB("CardSum",rtnary[33]);
	////x HIS_CardYBSum                          HIS_CardYBSum                 34 	
	DHCWebD_SetObjValueB("CardYBSum",rtnary[34]);
	if (isNaN(rtnary[33])){rtnary[33]=0;}
	if (isNaN(rtnary[34])){rtnary[34]=0}
	var myCardPaySum=parseFloat(rtnary[33])-parseFloat(rtnary[34]);
	DHCWebD_SetObjValueB("CardPaySum",myCardPaySum);
	////x HIS_CardRefNum                         HIS_CardRefNum                35     xx
	DHCWebD_SetObjValueB("CardRefNum", rtnary[35]);
	////x HIS_CardRefSum                         HIS_CardRefSum                36     xx
	DHCWebD_SetObjValueB("CardRefSum", rtnary[36]);
	////x HIS_CardYBRefSum                       HIS_CardYBRefSum              37     xx
	DHCWebD_SetObjValueB("CardYBRefSum", rtnary[37]);
	////x HIS_CardCashRefSum                     HIS_CardCashRefSum            38     xk
	DHCWebD_SetObjValueB("CardCashRefSum", rtnary[38]);
	////x HIS_CardParkNum                        HIS_CardParkNum               39     xx
	DHCWebD_SetObjValueB("CardParkNum", rtnary[39]);
	////x HIS_CardParkSum                        HIS_CardParkSum               40     xx
	DHCWebD_SetObjValueB("CardParkSum", rtnary[40]);
	////x HIS_CardYBParkSum                      HIS_CardYBParkSum             41     xx
	DHCWebD_SetObjValueB("CardYBParkSum", rtnary[41]);
	////HIS_CardCashParkSum 					 HIS_CardCashParkSum           42     x
	DHCWebD_SetObjValueB("CardCashParkSum", rtnary[42]);
	////x HIS_CardParkINVInfo                    HIS_CardParkINVInfo           43     xx
	DHCWebD_SetObjValueB("CardParkINVInfo", rtnary[43]);
	////x HIS_CardRefundINVInfo                  HIS_CardRefundINVInfo         44     xx
	DHCWebD_SetObjValueB("CardRefundINVInfo", rtnary[44]);
	////x HIS_PosNum --> HIS_CPPNum              HIS_PosNum                    45     
	DHCWebD_SetObjValueB("CPPNum", rtnary[45]);
	////HIS_PosSum   HIS_PosSum -->HIS_CPPSum        HIS_PosSum                    46     xx
	DHCWebD_SetObjValueB("CPPSum", rtnary[46]);
	////HIS_Note3     HIS_GetTotal                   HIS_Note3                     47     x
	DHCWebD_SetObjValueB("GetTotal", rtnary[47]);
	////x HIS_Note4   HIS_GiveTotal                  HIS_Note4                     48     x
	DHCWebD_SetObjValueB("GiveTotal", rtnary[48]);
	////x HIS_Note5   HIS_CashTotal                  HIS_Note5                     49     xk
	DHCWebD_SetObjValueB("CashTotal",rtnary[49]);
	////x HIS_Note6   HIS_CheckTotal                 HIS_Note6                     50     xx
	DHCWebD_SetObjValueB("CheckTotal",rtnary[50]);
	////x HIS_Note7   HIS_OtherTotal                 HIS_Note7                     51     xx
	DHCWebD_SetObjValueB("OtherTotal",rtnary[51]);
	
	////x HIS_Note8     HIS_PRDGetNum                HIS_Note8                     52     xx
	DHCWebD_SetObjValueB("PRDGetNum",rtnary[52]);
	////x HIS_Note9     HIS_PRDGetSum                HIS_Note9                     53     xx
	DHCWebD_SetObjValueB("PRDGetSum",rtnary[53]);
	////x HIS_Note10    HIS_PRDParkNum               HIS_Note10                    54     xx
	DHCWebD_SetObjValueB("PRDParkNum",rtnary[54]);
	////x HIS_Note11    HIS_PRDParkSum               HIS_Note11                    55     xx
	DHCWebD_SetObjValueB("PRDParkSum",rtnary[55]);
	////x HIS_Note12    HIS_PRDCashSum               HIS_Note12                    56    	
	DHCWebD_SetObjValueB("PRDCashSum",rtnary[56]);
	////x HIS_PRDCheckSum 							 HIS_PRDCheckSum	           57    	
	DHCWebD_SetObjValueB("PRDCheckSum",rtnary[57]);
	////  HIS_PRDOtherPaySum						 HIS_PRDOtherPaySum					58
	DHCWebD_SetObjValueB("PRDOtherPaySum",rtnary[58]);
	
}

function PrintDoc(){
	///
	
}

document.body.onload=BodyLoadHandler;
