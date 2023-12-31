///udhcOPCharge.js

var PrtXMLName="";		////XML Stream Mode Name

var mPrtINVFlag=1;		///Print Invoice Flag

var m_Version="";		///Control

var m_YBConFlag="0";     ////default not Connection YB

var m_CCMRowID="";

function BodyLoadHandler()	{
	var obj=document.getElementById("PayMode");
   	if (obj){
	   	obj.onchange=PayMode_OnChange;
	   	obj.multiple=false;
	   	obj.size=1;
   	}
	var obj=document.getElementById("Bank");
	if (obj){
		obj.size=1;
		obj.multiple=false;
	}
	
   	var obj=document.getElementById("Bill");
   	if (obj) obj.onclick=Bill_Click;
   	var obj=document.getElementById("Actualmoney");
   	if (obj) obj.onkeypress=Actualmoney_KeyPress;
	
	//
	IntDocument();
	var OPPatinfo=parent.frames["udhcOPPatinfo"];
    var PatientID=OPPatinfo.document.getElementById("PatientID");
	
   	////
   	var obj=document.getElementById("PatCal");
   	if (obj){
	   	obj.onclick=PatCal_OnClick;
   	}
	
	var encmeth=DHCWebD_GetObjValue("ReadOPBaseEncrypt");
	if (encmeth!=""){
		var myrtn=cspRunServerMethod(encmeth);
		var myary=myrtn.split("^");
		m_YBConFlag=myary[12];
		
		DHCWebD_SetObjValueA("RoundNum", myary[13]);
	}
	if (m_YBConFlag=="1"){
	    DHCWebOPYB_InitForm();
	}
	
	////var myobj=document.getElementById("TestButton");
	////myobj.onclick=mytest;
    document.onkeydown = document_OnKeyDown;
    
    OPCCharge_SetFocus();
    ///DHCWebD_SetStatusTip();
}

function document_OnKeyDown()
{
	var e=window.event;
	///alert(e.keyCode);
	parent.window.FrameShutCutKeyFrame(e);
	DHCWeb_EStopSpaceKey();
	
}


function OPCCharge_SetFocus(){
	var myDHCVersion=DHCWebD_GetObjValue("DHCVersion");
	switch (myDHCVersion){
		case "6":
			var myTotal=DHCWebD_GetObjValue("Total");
			myTotal=parseFloat(myTotal);
			if (myTotal!=0){
				DHCWeb_setfocus("Actualmoney");
			}
			break;
		default:
			
	}
}

function PatCal_OnClick(){
	////Calculate the Payor
	FootCalculate();
	///FootExpCalculate();
	return;
}

function PayMode_OnChange()
{
	/////Pay Mode change event
	var obj=document.getElementById("PayMode");
	if (obj){
		if (obj.options.length==0){
			return;
		}
		var myIdx=obj.options.selectedIndex;
		if (myIdx==-1){return;}
		var myary=obj.options[myIdx].value.split("^");
		if (myary[1]=="1"){
			SetPayInfoStatus(false);
		}else{
			SetPayInfoStatus(true);
		}
	}
	///BuildPayStr();
}

function Actualmoney_KeyPress(){
	var key=event.keyCode;
	if (key==13){
		var obj=document.getElementById("Actualmoney");
		var objb=document.getElementById("PatShareSum");
		if((!objb)||(objb.type=="hidden")){
			objb=document.getElementById("PatRoundSum");
		}
		var Resobj=document.getElementById("Change");
		DHCWeb_Calobj(obj,objb,Resobj,"-");
		var myChange=DHCWebD_GetObjValue("Change");
		if((isNaN(myChange))||(myChange=="")){
			myChange=0;
		}
		myChange=parseFloat(myChange);
		if (myChange<0){
			websys_setfocus("Actualmoney");
			alert(t["PrePayErr"]);
		}else{
			websys_setfocus("Bill");
		}
	}

}

function IntDocument(){
	var obj=document.getElementById("PatShareSum");
	if (obj){
		obj.readOnly=true;
	}
	var obj=document.getElementById("CurDeptShare");
	if (obj){
		obj.readOnly=true;
	}
	//CurrentBillNo
	var obj=document.getElementById("ReceiptNO");
	if (obj){
		obj.readOnly=true;
	}
	var obj=document.getElementById("Change");
	if (obj){
		obj.readOnly=true;
	}
	
	GetReceiptNo();
	
	///Load SS_Group Pay Mode
	///DHCWeb_AddToListA
	///var obj=document.getElementById("PayModeEncrypt");
	DHCWebD_ClearAllListA("PayMode");
	var encmeth=DHCWebD_GetObjValue("PayModeEncrypt");
	var mygLoc=session['LOGON.GROUPID'];
	var myInsType=DHCWebD_GetObjValue("INSDR");
	var myExpStr="";
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","PayMode",mygLoc, myInsType, myExpStr);
	}
	DHCWebD_ClearAllListA("Bank");
	var encmeth=DHCWebD_GetObjValue("ReadBankEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","Bank");
	}
	
	////if CPP Set as Default PayMode
	var myCPPFlag=DHCWebD_GetObjValue("CPPFlag");
	if (myCPPFlag=="CPP"){
		DHCWeb_SetListDefaultValue("PayMode", myCPPFlag,"^",2)
	}
	
	PayMode_OnChange();
	
	///Load Base Config
	var encmeth=DHCWebD_GetObjValue("GSCFEncrypt");
	if (encmeth!=""){
		var myrtn=cspRunServerMethod(encmeth,mygLoc);
	}
	var myary=myrtn.split("^");
	if (myary[0]==0){
		///_"^"_GSRowID_"^"_FootFlag_"^"_RecLocFlag_"^"_PrtINVFlag
		///foot Flag
		var billobj=document.getElementById("Bill");
		if ((billobj)&&(myary[2]==0)){
			DHCWeb_DisBtn(billobj);
		}
		
		////Check Invoice PrtFlag
		mPrtINVFlag=myary[4];
		
		////Get PrtXMLName
		var myPrtXMLName=myary[10];
	}
	PrtXMLName=myPrtXMLName;
	DHCP_GetXMLConfig("InvPrintEncrypt",myPrtXMLName);		///INVPrtFlag
    ////����
}

function Bill_Click()
{
	//zhaocz 
	//
	var billobj=document.getElementById("Bill");
	if (billobj){
		DHCWeb_DisBtn(billobj);
	}
	var rtn=DHCWebD_SaveOrder();
	if (!rtn){
		var billobj=document.getElementById("Bill");
		if (billobj){
			billobj.disabled=false;
			billobj.onclick=Bill_Click;
		}
		return;
	}
	
	//OPBillCharge
	//Paadminfo, Userid, UnBillOrdStr, Instype, PatPaySum, Payinfo, gloc	
	//Paadminfo
	//Userid
	//UnBillOrdStr
	//Instype
	//PatPaySum
	//Payinfo
	//gloc
	
	var Guser=session['LOGON.USERID'];
	var Guloc=session['LOGON.GROUPID'];
	var myLoadDR=session['LOGON.CTLOCID'];
	var rtn=CheckBill();
	
	if (!rtn){
		var billobj=document.getElementById("Bill");
		if (billobj){
			billobj.disabled=false;
			billobj.onclick=Bill_Click;
		}
		return;
	}
	
	var payobj=document.getElementById("PatShareSum");
	if (payobj){
		var patpaysum=payobj.value;
	}
	var insobj=document.getElementById("CurrentInsType");
	if (insobj){
		var curInsType=insobj.value;
	}
	
	//var unordobj=document.getElementById("OrdItemStr");
	//if (unordobj){
	//	var unordstr=unordobj.value;
	//}
	
	patdoc=parent.frames["udhcOPPatinfo"].document;
	paadmlist=patdoc.getElementById("PAADMList");
	var myAdmstr="";
	if (paadmlist){
		for (var i=0;i<paadmlist.length;i++){
			var myAdmValue=paadmlist.options[i].value;
			var myAdmAry=myAdmValue.split("^");
			myAdmstr=myAdmstr+myAdmAry[0]+"^";
		}
	}
	
	var myPayinfo=BuildPayStr();
	
	if (myPayinfo==""){
		///not default Pay mode
		return;
	}
	
	var unordstr=DHCWebD_GetUnBillStr();
	//alert(myAdmstr+":"+Guser+":"+unordstr+":"+curInsType+":"+patpaysum+":"+myPayinfo+":"+Guloc);
   	var billobj=document.getElementById("Bill");
	
	//return;
	
	///// Add Auto Add New Order Service
	var myAutoOrdInfo=AutoAddNewOrder(myAdmstr, unordstr, curInsType , 0);
	var payobj=document.getElementById("PatShareSum");
	if (payobj){
		var patpaysum=payobj.value;
	}
	////alert(patpaysum);
	
	////Exp String For Input:
	var myAccMRowID=DHCWebD_GetObjValue("AccMRowID")
	var myExpStr= Guloc+"^" + myLoadDR+"^"+myAccMRowID;
	myExpStr+="^Y";			////  Require Invoice="Y"   prior mast;
	myExpStr+="^F";			////Fair Type default=""
	var myval=DHCWebD_GetObjValue("Actualmoney");
	myExpStr+="^"+myval;
	var myval=DHCWebD_GetObjValue("Change");
	myExpStr+="^"+myval;
	var myTMPPatSum=DHCWebD_GetObjValue("PatShareSum");
	var myTMPRoundSum=DHCWebD_GetObjValue("PatRoundSum");
	var obj=document.getElementById("PatShareSum");
	var myOPErr=0;
	if((!obj)||(obj.type=="hidden")){
		var myOPErr=DHCWeb_CalobjA(myTMPRoundSum,myTMPPatSum,"-");
	}
	myExpStr+="^"+myOPErr;
	var myOperSum=0;
	
	////CSCF
	var myCFEncrypt=DHCWebD_GetObjValue("ReadSoundService");
	
	if (myCFEncrypt!=""){
		////myJSFunName , mySoundService , myValAry , mySessionStr , myCFExpStr
		var myJSFunName="DHCWCOM_SoundPriceService";
		var mySoundService="TotalFee";
		var myValAry=patpaysum+"^";
		var mySessionStr=DHCWeb_GetSessionPara();
		var myCFExpStr="";
		
		var rtnvalue=cspRunServerMethod(myCFEncrypt,myJSFunName , mySoundService , myValAry , mySessionStr , myCFExpStr)
		
	}
	
	var chargeObj=document.getElementById("OPBillFootEncrypt");
	
	if (chargeObj){
		var encmeth=chargeObj.value;
		var ReadInfoType=DHCWebD_GetObjValue("ReadInfoType");	///
		var OldINVRID="";
		var rtnvalue=cspRunServerMethod(encmeth,myAdmstr,Guser,unordstr,curInsType,patpaysum,myPayinfo,Guloc,"0",OldINVRID,ReadInfoType, myExpStr)
		//alert(rtnvalue)
		var myConAry=rtnvalue.split(String.fromCharCode(2));
		var billary=myConAry[0].split("^");
		var myPrtFlag=0;		////==1  no Print ;;
		if (myConAry.length>1){
			var myCtlAry=myConAry[1].split("^");
			myPrtFlag=parseInt(myCtlAry[0]);
		}
		if (myConAry.length>2){
			myOperSum=parseFloat(myConAry[2]);
		}else{
			if (isNaN(myOPErr)){myOPErr=0;}
			myOperSum=parseFloat(patpaysum)+parseFloat(myOPErr);	/////myOperSum=patpaysum;
			myOperSum=myOperSum.toFixed(2);
		}
		var myYBSum=0;
		
		///alert(rtnvalue);
		if (billary[0]=="0"){
			////Add YB InterFace
			var myYBINS=DHCWebD_GetObjValue("YBFlag");
			if ((m_YBConFlag=="1")&&((myYBINS=="1")||(myYBINS=="2"))){
				var myPLen=billary.length;
				var mytmpary=new Array();
				for (var i=1;i<myPLen;i++){
					if (billary[i]!=""){
						mytmpary[mytmpary.length]=billary[i];
					}
				}
				var myYBHand="";
				var myCPPFlag="";
				var myPRTStr=mytmpary.join("^");
				var myExpStr="N^"+session['LOGON.GROUPID']+"^";
				
				var myYBrtn=DHCWebOPYB_DataUpdate(myYBHand, myCPPFlag, myPRTStr, myExpStr);
				var myYBarry=myYBrtn.split("^");
				if (myYBarry[0]=="YBCancle"){
					////DHC_INVPRT Data Deleted By YB
					ClrDocWin(myAdmstr,"");
					return;
				}
				var myYBSum=parseFloat(myYBarry[1]);
				if (isNaN(myYBSum)){
					myYBSum=0;
				}
			}
			
			////// Service
			DHCOPChargeService(myConAry[0],"0");
			
			//	billary[1]=1
			///check is Clinic Fee or Other Fee
			var myRefFlag=DHCWebD_GetObjValue("ReloadFlag");
			
			switch (myRefFlag){
				case "2":
					///write Data to Opener windows
					////add Print XT  2006-06-21
					///BillPrintNew(myConAry[0]);
					BillPrintTaskListNew(myConAry[0]);
					alert(t["FootOK"]);
					var par_win = parent.window.opener;
					if (par_win){
						par_win.transINVStr(myConAry[0]);
					}
					parent.close();
					break;
				case "3":
					///write Data to Opener windows
					////add Print XT  2006-06-21
					///BillPrintNew(myConAry[0]);
					BillPrintTaskListNew(myConAry[0]);
					alert(t["FootOK"]);
					var par_win = parent.window.opener;
					if (par_win){
						par_win.transINVStr(myConAry[0]);
					}
					parent.close();
					break;
				default:
					if (myPrtFlag==0){
						////BillPrintNew(rtnvalue);
						////BillPrintNew(myConAry[0]);
						BillPrintTaskListNew(myConAry[0]);
						billobj.disabled=true;
						alert(t["FootOK1"]+(billary.length-2)+t["FootOK2"]);
					}else{
						////BillPrintNew(myConAry[0]);
						BillPrintTaskListNew(myConAry[0]);
						billobj.disabled=true;
						alert(t["FootOK"]);
					}
					//clear Document;
					myOperSum=+parseFloat(myOperSum)-parseFloat(myYBSum);
					////CalculateOPCash(myOperSum);
					
					ClrDocWin(myAdmstr,"");
			}
		}else{
			////alert(rtnvalue);
			billobj.disabled=false;
			var billobj=document.getElementById("Bill");
			if (billobj){
				billobj.disabled=false;
				billobj.onclick=Bill_Click;
			}
			alert(billary[0])
			switch (billary[0]){
				case "103":
					alert(t[billary[0]]);
					break;
				case "101":
					alert(t[billary[0]]);
					break;
				case "102":
					alert(t[billary[0]]);
					break;
				default:
				alert(t['FootFail']+rtnvalue);     ////
			}
		}

	}
}

function CalculateOPCash(OperSum)
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPCashCal&FootSum="+OperSum;
	var mymdinfo=window.showModalDialog(lnk,"udhcOPCashCal","scrollbars=no,resizable=no,top=100,left=100,width=530,height=460");
	
}

function ClrDocWin(myAdmstr,unordstr)
{
	///
	///
	var rtnvalue=0
	var encmeth=DHCWebD_GetObjValue("UnBillCountEncrypt");
	var mygLoc=session['LOGON.GROUPID'];
	var myRecDep=session['LOGON.CTLOCID'];
	var myExpStr=mygLoc+"^"+myRecDep;
	if (encmeth!=""){
		////alert(myAdmstr+"::"+unordstr+"::"+myExpStr);
		rtnvalue=cspRunServerMethod(encmeth,myAdmstr,unordstr,myExpStr)
	}
	if (rtnvalue==0){
		//
		DHCWebD_IntFeeAll();
	}else{
		//
		DHCWebD_IntFeeDoc();
	}
}

function BillPrintTaskListNew(INVstr){
	var myOldXmlName=PrtXMLName;
	
	var myTaskList=DHCWebD_GetObjValue("ReadPrtList");
	var myary=myTaskList.split(String.fromCharCode(1));
	
	if (myary[0]=="Y"){
		BillPrintTaskList(myary[1], INVstr)
		PrtXMLName = myOldXmlName;
		DHCP_GetXMLConfig("InvPrintEncrypt",PrtXMLName);		///INVPrtFlag
	}else{
		BillPrintNew(INVstr);
	}
	
	PrtXMLName = myOldXmlName;
}

function BillPrintTaskList(PrtTaskStr, INVstr){
	var myTListAry=PrtTaskStr.split(String.fromCharCode(2));
	for (var i=0;i<myTListAry.length;i++){
		if (myTListAry[i]!=""){
			var myStrAry=myTListAry[i].split("^");
			////myXmlName_"^"_myClassName_"^"_myMethodName_"^"_myPrintMode_"^"_HardEquipDR
			var myPrtXMLName=myStrAry[0];
			PrtXMLName=myPrtXMLName;
			var myClassName=myStrAry[1];
			var myMethodName=myStrAry[2];
			var myPrintMode=myStrAry[3];
			var myPrintDeviceDR=myStrAry[4];
			if ((myStrAry[3]=="")||(myStrAry[3]=="XML")){
				if (myPrtXMLName!=""){
					DHCP_GetXMLConfig("InvPrintEncrypt",myPrtXMLName);		///INVPrtFlag
					CommBillPrintNew(INVstr, myClassName, myMethodName);
				}
			}else if((myStrAry[3]=="BC")){
				OtherPrintDevice(INVstr, myClassName, myMethodName, myPrintDeviceDR);
			}
		}
	}
}

function OtherPrintDevice(INVstr,ClassName, MethodName, PrintDeviceDR)
{
	var myExpStr="";
	var encmeth=DHCWebD_GetObjValue("ReadOPDataOtherDeviceEncrypt");
	if (encmeth!=""){
		var Printinfo=cspRunServerMethod(encmeth,"DHCWCOM_OtherPrintDeviceEquip",ClassName, MethodName,PrintDeviceDR, INVstr, myExpStr);
	}
}

function CommBillPrintNew(INVstr,ClassName, MethodName){
	
	var INVtmp=INVstr.split("^");
	///
	///INVstr
	///for (var invi=1;invi<INVtmp.length;invi++)
	///{
		///if (INVtmp[invi]!=""){
			var beforeprint=document.getElementById('ReadCommOPDataEncrypt');
			if (beforeprint) {var encmeth=beforeprint.value} else {var encmeth=''};
			
			var PayMode=DHCWebD_GetObjValue("PayMode");
			var Guser=session['LOGON.USERID'];
			var sUserCode=session['LOGON.USERCODE'];
			var myExpStr="";
			var myPreDep=DHCWebD_GetObjValue("Actualmoney");
			var myCharge=DHCWebD_GetObjValue("Change");
			var myCurGroupDR=session['LOGON.GROUPID'];
			
			var myExpStr=myPreDep+"^"+myCharge+"^"+myCurGroupDR;
			//GetInvoicePrtDetail(JSFunName As %String,InvRowID, UseID , PayMode
			var Printinfo=cspRunServerMethod(encmeth,"InvPrintNew",ClassName, MethodName, PrtXMLName,INVstr, sUserCode, PayMode, myExpStr);
		///}
	///}
}

function CommBillPrintNewSigle(INVstr,ClassName, MethodName){
	
	var INVtmp=INVstr.split("^");
	///
	///INVstr
	for (var invi=1;invi<INVtmp.length;invi++)
	{
		if (INVtmp[invi]!=""){
			var beforeprint=document.getElementById('ReadCommOPDataEncrypt');
			if (beforeprint) {var encmeth=beforeprint.value} else {var encmeth=''};
			
			var PayMode=DHCWebD_GetObjValue("PayMode");
			var Guser=session['LOGON.USERID'];
			var sUserCode=session['LOGON.USERCODE'];
			var myExpStr="";
			var myPreDep=DHCWebD_GetObjValue("Actualmoney");
			var myCharge=DHCWebD_GetObjValue("Change");
			var myCurGroupDR=session['LOGON.GROUPID'];
			
			var myExpStr=myPreDep+"^"+myCharge+"^"+myCurGroupDR;
			//GetInvoicePrtDetail(JSFunName As %String,InvRowID, UseID , PayMode
			var Printinfo=cspRunServerMethod(encmeth,"InvPrintNew",ClassName, MethodName, PrtXMLName,INVtmp[invi], sUserCode, PayMode, myExpStr);
		}
	}
}

function BillPrintNew(INVstr){
	if (PrtXMLName==""){
		////not alert to Print
		return;
	}
	var INVtmp=INVstr.split("^");
	///
	///INVstr
	for (var invi=1;invi<INVtmp.length;invi++)
	{
		if (INVtmp[invi]!=""){
			var beforeprint=document.getElementById('getSendtoPrintinfo');
			if (beforeprint) {var encmeth=beforeprint.value} else {var encmeth=''};
			
			var PayMode=DHCWebD_GetObjValue("PayMode");
			var Guser=session['LOGON.USERID'];
			var sUserCode=session['LOGON.USERCODE'];
			var myExpStr="";
			var myPreDep=DHCWebD_GetObjValue("Actualmoney");
			var myCharge=DHCWebD_GetObjValue("Change");
			var myCurGroupDR=session['LOGON.GROUPID'];
			
			var myExpStr=myPreDep+"^"+myCharge+"^"+myCurGroupDR;
			//GetInvoicePrtDetail(JSFunName As %String,InvRowID, UseID , PayMode
			var Printinfo=cspRunServerMethod(encmeth,"InvPrintNew",PrtXMLName,INVtmp[invi], sUserCode, PayMode, myExpStr);
		}
	}
}


function InvPrintNew(TxtInfo,ListInfo)
{
	////
	////DHCP_PrintFun(encmeth,PObj,inpara,inlist)
	var beforeprint=document.getElementById('TestPrint');
	if (beforeprint) {var encmeth=beforeprint.value} else {var encmeth=''};
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
}

function BuildPayStr()
{
	////;IPM_PayMode_DR^IPM_CMBank_DR^IPM_CardChequeNo
	////;IPM_Card_DR^IPM_Unit^ChequeDate^PayAccNO
	var myPayStr="";
	///PayMode
	var obj=document.getElementById("PayMode");
	var billobj=document.getElementById("PMInfoDesc");
	if (obj){
		var myIdx=obj.selectedIndex;
		if (myIdx<0){
			alert(t["NoDefPayMode"]);
			return "";
		}
		var mypvalue=obj.options[myIdx].value;
		var myary=mypvalue.split("^");
		myPayStr=myary[0];
		switch(myary[1]){
			case "1":
				///Requst Pay Info
				var myBankDR=DHCWeb_GetListBoxValue("Bank");
				var myBankAry=myBankDR.split("^");
				myBankDR=myBankAry[0];
				var myCheqNo=DHCWebD_GetObjValue("CheckNO");
				var ChequeDate=DHCWebD_GetObjValue("ChequeDate");
				var PayAccNO=DHCWebD_GetObjValue("PayAccNO");
				
				myPayStr=myPayStr+"^"+ myBankDR +"^"+myCheqNo+"^^^"+ChequeDate+"^"+PayAccNO;
				break;
			case "0":
				///
				myPayStr=myPayStr+"^^^^";
				break;
			default:
				myPayStr=myPayStr+"^^^^";
		}		
	}
	return myPayStr;
}

function CheckBill(){
	//
	var chkobj=document.getElementById("Total");
	var rtn=true;
	if (chkobj){
		if ((chkobj.value=="")){
			rtn=false;
		}else{
			var mytol=parseFloat(chkobj.value);
			if (mytol==0){
				//rtn=false;
			}
		}
	}else{rtn=false;}
	if (rtn==false){
		alert(t['NoOrdFoot']);  ///
		return rtn;
	}
	
	m_Version=DHCWebD_GetObjValue("DHCVersion");
	switch(m_Version){
		case "1":
			////HF  SL  Hospital  Check;
			var myTotal=DHCWebD_GetObjValue("Total");
			myTotal=parseFloat(myTotal);
			if (myTotal>500){
				if (confirm(t["HFChBigTip"])==true){
					rtn=false;
				}
			}
			break;
		default:
		
	}
	if (rtn==false){
		return rtn;
	}
	
	//
	var obj=document.getElementById("PayMode");
	
	var billobj=document.getElementById("PMInfoDesc");
	if (obj){
		var myPCount=obj.options.length;
		if (myPCount==0){
			alert(t["NoPayMode"]);
			rtn=false;
			return rtn;
		}
		///CTPMRowID^RPFlag^CTPMCode^INVPrtFlag		
		var myIdx=obj.selectedIndex;
		if (myIdx<0)                           
		{
			alert(t["NoPayModeSelected"]);
			rtn=false;
			return rtn;
		}
		var myary=obj.options[myIdx].value.split("^");
		
		var myRefFlag=DHCWebD_GetObjValue("ReloadFlag");
		
		if (((myRefFlag=="2")||(myRefFlag=="3"))&&(myary[2]!="CPP")){
			alert(t["OnlyCPP"]);
			rtn=false;
			return rtn;
		}
		///var myPrtFlag=myary[3];
		///Check Pay Info
		switch(myary[1]){
			case "0":
				
				break;
			case "1":
				///Require Pay Info
				var myCheckNO=DHCWebD_GetObjValue("CheckNO");
				if (myCheckNO==""){
					alert(t['InCheckNo']);     ////
					websys_setfocus("CheckNO");
					return false;
				}
				break;
		}
		
		////CPP  Get AdmStrInfo 
		patdoc=parent.frames["udhcOPPatinfo"].document;
		paadmlist=patdoc.getElementById("PAADMList");
		var myTmpAdmstr="";
		if (paadmlist){
			for (var i=0;i<paadmlist.length;i++){
				var myAdmValue=paadmlist.options[i].value;
				var myAdmAry=myAdmValue.split("^");
				myTmpAdmstr=myTmpAdmstr+myAdmAry[0]+"^";
			}
		}
		var mytmpexpstr=myTmpAdmstr+String.fromCharCode(2);
		//Check For Card Pay
		switch(myary[2]){
			case "CPP":
				///Check  AccInfo for Pay
				var myPatSum=DHCWebD_GetObjValue("PatShareSum");
				var objb=document.getElementById("PatShareSum");
				if((!objb)||(objb.type=="hidden")){
					var myPatSum=DHCWebD_GetObjValue("PatRoundSum");
				}
				var myCardNo=DHCWebD_GetObjValue("CardNo");
				;
				m_Version=DHCWebD_GetObjValue("DHCVersion");
				switch(m_Version){
					case "0":
						///User for BJJST Hosp
						var myrtn=DHCACC_CheckMCFPayExp(myPatSum,myCardNo, mytmpexpstr);
						var mytmpary=myrtn.split("^");
						var mytmpleft=mytmpary[5];
						if (isNaN(mytmpleft)){mytmpleft=0;}
						mytmpleft=parseFloat(mytmpleft);
						if (mytmpleft<0){
							alert(t["AssertTip"]);
						}
						break;
					case "3":
						////User for No Card SXDT Three Hosp
						var myrtn=DHCACC_CheckMCFPayFNoCard(myPatSum,myCardNo);
						break;
					case "7":
					    var OPPatinfo=parent.frames["udhcOPPatinfo"];
                        var CardTypeDefine=OPPatinfo.document.getElementById("CardTypeDefine");
					    var myoptval=CardTypeDefine.value
					    
						var myary=myoptval.split("^");
						var myCardTypeDR=myary[0];
						m_CCMRowID=myary[14];
						
						var myrtn=DHCACC_CheckMCFPay(myPatSum,myCardNo,myTmpAdmstr,myCardTypeDR);
						
						break;	
					case "12":
					    var OPPatinfo=parent.frames["udhcOPPatinfo"];
                        var CardTypeDefine=OPPatinfo.document.getElementById("CardTypeDefine");
					    var myoptval=CardTypeDefine.value
						var myary=myoptval.split("^");
						var myCardTypeDR=myary[0];
						m_CCMRowID=myary[14];
						var myrtn=DHCACC_CheckMCFPay(myPatSum,myCardNo,myTmpAdmstr,myCardTypeDR);
						
						break;	
					default:
						var myrtn=DHCACC_CheckMCFPay(myPatSum,myCardNo);
						break;
				}
				var myary=myrtn.split("^");
				if (myary[0]==0){
					rtn=true;
					///Get Active Account RowID
					var myAccRowID=myary[1];
					DHCWebD_SetObjValueA("AccMRowID",myAccRowID);
				}else{
					rtn=false;
					var mystr=""
					if (myary[4]!="0"){
						var mystr=t["BalTip"]+myary[4];
					}
					alert(t[myary[0]]+""+mystr);
					return rtn;
				}
				break;
			default:
			
		}
	}
	if (rtn==false){
		alert(t['InCheckNo']);     ////
		return rtn;
	}
	
	var obj=document.getElementById("ReceiptNO");
	if (obj){
		if ((obj.value=="")&&(mPrtINVFlag==1)){
			rtn=false;
			alert(session['LOGON.USERNAME']+t['NoINVTip']);    /////
			return rtn;
		}
	}
	return rtn;
	
}

function GetReceiptNo(){
	//
	var receipNOobj=document.getElementById('GetreceipNO');
	if (receipNOobj) {var encmeth=receipNOobj.value} else {var encmeth=''};
	var Guser=session['LOGON.USERID'];
	var myPINVFlag="Y";
	var myGroupDR=session['LOGON.GROUPID'];
	var myExpStr=Guser+"^"+myPINVFlag+"^"+myGroupDR;
	if (cspRunServerMethod(encmeth,"SetReceipNO","",myExpStr)!='0') {
		alert(t['05'])
		//
		return
	}	
}

function SetReceipNO(value) {
	var myary=value.split("^");
	var ls_ReceipNo=myary[0];
	var obj=document.getElementById("ReceiptNO");
	if (obj){
		obj.value=ls_ReceipNo;
	}
	DHCWebD_SetObjValueA("INVLeftNum",myary[2]);
	///change the Txt Color
	if (myary[1]!="0"){
		obj.className='clsInvalid';
	}
	
}

function DHCWeb_WPPrintNew(Printinfo){
	var teststr="\\\\192.168.1.10\\TrakCareP5\\web\\config.xml";
	var teststr="E:\\config.xml";
	var pathobj=document.getElementById("TemplatePath");
	var pathstr=pathobj.value;
	pathstr=pathstr+"config.xml";
	//alert(Printinfo+"^^^"+pathstr);
	var myobj=document.getElementById("ClsBillPrint");
	//var rtn=myobj.ToPrint(pathstr,Printinfo);
	var rtn=0;
	return rtn;
}

function SetINVNOstr(value)
{
	var invstrobj=document.getElementById('INVNOstr');
	invstrobj.value=value;
}
 
function SetARRCP(value) {
	var obj=document.getElementById('ARRCPRowid');
	obj.value=value;
}

function SetPayInfoStatus(SFlag)
{
	var obj=document.getElementById("CheckNO");
	if (obj){
		obj.disabled=SFlag;
	}
	var obj=document.getElementById("Bank");
	if (obj){
		obj.disabled=SFlag;
	}
	var obj=document.getElementById("ChequeDate");
	if (obj){
		obj.disabled=SFlag;
	}
	var obj=document.getElementById("PayUnit");
	if (obj){
		obj.disabled=SFlag;
	}
	var obj=document.getElementById("PayAccNO");
	if (obj){
		obj.disabled=SFlag;
	}
	var obj=document.getElementById("Note");
	if (obj){
		obj.disabled=SFlag;
	}
}


function SetINVRowid(value)
{
	var invidobj=document.getElementById('INVRowid');
	invidobj.value=value;
}

function GetNewarpbl(value)
{
	if (value!="")
	{
		var eSrc=window.event.srcElement;
		var objtbl=document.getElementById('tudhcOPCharge');
		var rowObj=getRow(eSrc);
	   var selectrow=rowObj.rowIndex;
		SelRowObj=document.getElementById('Tarpblno'+selectrow);
      SelRowObj.innerText=value;
	}
}
function savepres(value)
{
	var Split_Value=value.split("||");
	presinfo=Split_Value[0]
	phwinfo=Split_Value[1]
}
function SetOrderinfo(value)
{
	var ordtmpobj=document.getElementById('EveryOrder');
	ordtmpobj.value=value	
	Addtabrow();	
}
function SPatinfo(value)
{        
	///alert(value);
	var SplitValue=value.split("^");
	var objPARowid=document.getElementById('PARowid');
	var objName=document.getElementById('PatientName');
	if (objPARowid)
	   {objPARowid.value=unescape(SplitValue[0]);	}
	if (objName)
	   {objName.value=unescape(SplitValue[1]);	}
}

function FootCalculate()	{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPCashCal";
	var NewWin=open(lnk,"udhcOPCashCal","scrollbars=no,resizable=no,top=100,left=100,width=530,height=460");
}

function FootExpCalculate()	{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPCashExpCal&OperFootSum=";
	var NewWin=open(lnk,"udhcOPCashExpCal","scrollbars=no,resizable=no,top=100,left=100,width=800,height=460");
}

function DHCSoundPrice(Instruction){
	var myXmlStr="<SPrice><Instruction>"+myFootSum+"J</Instruction><Instruction>W</Instruction></SPrice>";
	var myEquipDR=DHCWebD_GetObjValue("EquipDR");
	var myXmlStr=XMLStr;			///"<SPrice><Instruction>W</Instruction><Instruction>12Z</Instruction></SPrice>";
	DHCWCOM_SoundQuotePrice(myEquipDR,myXmlStr);
	///SoundPrice(myXmlStr);
}

function AutoAddNewOrder(Paadminfo, UnBillOrdStr, Instype , SFlag)
{
	////Auto Add New Order Function
	////myExpStr
	////(Paadminfo, UnBillOrdStr, Instype , SFlag , SessionStr, ExpStr)
	var myNOrdInfo="";
	var mySessionStr=DHCWeb_GetSessionPara();
	var myExpStr="";
	var myEncrypt=DHCWebD_GetObjValue("AutoAddNewOrdEncrypt");
	if (myEncrypt!=""){
		////myrtn_$c(1)_OrdRowIDStr_$c(1)_Fair
		var myNOrdInfo=cspRunServerMethod(myEncrypt,Paadminfo,UnBillOrdStr,Instype, SFlag,mySessionStr, myExpStr)
	}
	
	////Deal with Fee
	var myOrdAry=myNOrdInfo.split(String.fromCharCode(1));
	if (myOrdAry[0]=="0"){
		////Fee: myOrdAry[2]=^^^
		////OEORISum_"^"_OEORIDiscSum_"^"_OEORIInsSum_"^"_OEORIPatSum
		var myFeeAry=myOrdAry[2].split("^");
		var myAddPatSum=myFeeAry[3];
		if (isNaN(myAddPatSum)) {myAddPatSum=0;}
		var myPatSum=DHCWebD_GetObjValue("PatShareSum");
		if (isNaN(myPatSum)){myPatSum=0;}
		myPatSum=DHCWeb_CalobjA(myPatSum,myAddPatSum,"+");
		DHCWebD_SetObjValueB("PatShareSum",myPatSum);
		////
		var myAddRoundSum=DHCWebD_GetObjValue("PatRoundSum");
		var myPatRoundSum=DHCWeb_CalobjA(myAddRoundSum,myAddPatSum,"+");
		DHCWebD_SetObjValueB("PatRoundSum",myPatRoundSum);
		
	}
	return myNOrdInfo;
}

function AutoDeleteNewOrder(AutoNOrdInfo)
{
	////Auto Delete New Order by Order RowID Str
	////
	////myrtn_$c(1)_OrdRowIDStr_$c(1)_Fair
	var myOrdAry=AutoNOrdInfo.split(String.fromCharCode(1));
	if (myOrdAry[0]=="0"){
		////Del
		
	}else{
		
	}
}

function DHCOPChargeService(PRTRowIDStr, SFlag)
{
	var myXmlStr="<ConditionDefine>";
	myXmlStr +="<PRTRowIDStr>";
	myXmlStr += PRTRowIDStr;
	myXmlStr += "</PRTRowIDStr>";
	myXmlStr +="<SFlag>";
	myXmlStr +=SFlag;
	myXmlStr += "</SFlag>";
	myXmlStr += "<ServiceName>OPCharge</ServiceName>";
	myXmlStr += "</ConditionDefine>";
	
	var myExpStr="";
	//// Charge Service
	var myEncrypt=DHCWebD_GetObjValue("ChargeServiceEncrypt");
	if (myEncrypt!=""){
		////myrtn_$c(1)_OrdRowIDStr_$c(1)_Fair
		
		var myrtn=cspRunServerMethod(myEncrypt,myXmlStr, myExpStr)
		
	}
	
}

function AccAddDeposit(){
	///CardNo
	///AccRowID
	///
	var myAccRowID=DHCWebD_GetObjValue("");
	var myPatOrdSum=DHCWebD_GetObjValue("");
	var myAccDepFlag=1;
	var myCardNo=DHCWebD_GetObjValue("CardNo");
	
	var lnk='websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccAddDeposit&AccountID='+myAccRowID;
	lnk+='&CardNo='+myCardNo+'&RegNo='+'&PatName='+"&AccDepFlag="+myAccDepFlag;
	lnk+="&PatFactPaySum="+myPatOrdSum;
	
	var NewWin=open(lnk,"UDHCAccAddDeposit","scrollbars=no,resizable=no,top=100,left=100,width=800,height=460");
	
}

function mytest(){
	myframe=parent.frames["DHCOPOEOrdInput"];
	
	try{
		var beforeprint=document.getElementById('TestPrint');
		if (beforeprint) {var encmeth=beforeprint.value} else {var encmeth=''};
		var myobj=document.getElementById("ClsBillPrint");
		DHCP_mytest(encmeth,"test1",myobj);
		
		return ;
		
	}catch(e){
		alert(e.message);
		return;
	}
	
	//return rtn;

}

document.body.onload = BodyLoadHandler;
