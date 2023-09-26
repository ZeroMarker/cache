var CurrentSel=0;
function BodyLoadHandler(){
	//var obj=GetObj("BFind");
   //if (obj) obj.onclick=BFind_click;
    var obj=GetObj("RegNo");
    if (obj) obj.onkeydown=RegNo_keydown;
    
    obj=document.getElementById("CardNo");
	if (obj) {
		obj.onchange=CardNo_Change;
		obj.onkeydown=CardNo_keydown;
	}
	
	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCard_Click;}
	
	obj=document.getElementById("BRePrintBalance");
	if (obj) {obj.onclick=BRePrintBalance_click;}
	
	//原号重打发票
	obj=document.getElementById("BRePRintInv");
	if (obj) {obj.onclick=PrintCurInv;}

	
	var CardType="R";
	obj=document.getElementById("CardType");
	if (obj) CardType=obj.value;
	if (CardType=="C")
	{
		obj=document.getElementById("cRegNo");
		if (obj) obj.innerText="代金卡号";
	}
	if(CardType=="R")
	{
		obj=document.getElementById("RegNo");
		if(obj) {
			var regNo=obj.value;
			obj.value=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",regNo);
		}
		 obj=document.getElementById("BRePrintBalance");
		if (obj) obj.style.display="none";

	}

	//initialReadCardButton()
}

function PrintCurInv()
{
	if (CurrentSel==0) return false;
	var InvID="",DetailType="";
	obj=document.getElementById("TSourceNoz"+CurrentSel);
	if (obj) InvID=obj.innerText;
	if (InvID=="") return false;
	obj=document.getElementById("TTypez"+CurrentSel);
	if (obj) DetailType=obj.innerText;
	if ((DetailType!="开户")&&(DetailType!="交预缴金")) return false;
	PrintInv(InvID);
}
function PrintInv(InvID)
{
	var encmeth=GetOneData("GetInvoiceInfo")
	var TxtInfo=cspRunServerMethod(encmeth,InvID,"1")
	var ListInfo=cspRunServerMethod(encmeth,InvID,"2")
	if (TxtInfo=="") return
	///xml print requird
	DHCP_GetXMLConfig("InvPrintEncrypt","PEInvPrint");
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);
}

function CardNo_keydown(e)
{
	var key=websys_getKey(e);
	if (13==key) {
		CardNo_Change();
	}
}

function CardNo_Change()
{
	CardNoChangeApp("RegNo","CardNo","BFind_click()","Clear_click()","0");
}
function ReadCard_Click()
{
	ReadCardApp("RegNo","BFind_click()","CardNo");
	
}
/*
function BFind_click()
{
	var RegNo=GetOneData("RegNo");
	var Name=GetOneData("Name");
	var Status=GetOneData("Status");
	var BeginDate=GetOneData("BeginDate");
	var EndDate=GetOneData("EndDate");
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEAdvancePayment.Find"
			+"&RegNo="+RegNo
			+"&Name="+Name
			+"&Status="+Status
			+"&BeginDate="+BeginDate
			+"&EndDate="+EndDate;
	location.href=lnk; 
    return false;
}
*/
function GetObj(ObjID)
{
	var obj=document.getElementById(ObjID);
	return obj;
}
function AL(String)
{
	alert(String)
}


function GetOneData(ElementName)
{
	var DataStr="";
	var obj=GetObj(ElementName);
	if (obj) DataStr=obj.value;
	return DataStr;
}

function RegNo_keydown(e)
{
	var key=websys_getKey(e);
	if ( 13==key) {
		BFind_click();
	}
}
function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (CurrentSel==selectrow)
	{
		CurrentSel=0;
	}
	else
	{
		CurrentSel=selectrow;
	}

}

function BRePrintBalance_click()
{
	if (CurrentSel==0) return false;
	var Delim=String.fromCharCode(2);
	var obj,CardNO,Amt,ReAmt,Date,Time,DateTime;
	
	
	
	var HosName=""
	//var HosName=tkMakeServerCall("web.DHCPE.DHCPEUSERREPORT","GetHospitalName");
    var HosName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",session['LOGON.HOSPID'])
	if(HosName.indexOf("[")>-1){var HosName=HosName.split("[")[0];}

	obj=document.getElementById("TDJCardNoz"+CurrentSel);
	if (obj) CardNO=obj.innerText;
	var TxtInfo="CardNo"+Delim+CardNO;
	obj=document.getElementById("TAmountz"+CurrentSel);
	//if (obj) Amt=0-obj.innerText;
	if(obj){
		Amt=obj.innerText;
		if(Amt>0){Amt=0;}
		else{Amt=-Amt;}  
	}
	var TxtInfo=TxtInfo+"^"+"Cost"+Delim+Amt;
	obj=document.getElementById("TRemainAmountz"+CurrentSel);
	if (obj) ReAmt=obj.innerText;
	var TxtInfo=TxtInfo+"^"+"CurrentBalance"+Delim+ReAmt;
	obj=document.getElementById("TDatez"+CurrentSel);
	if (obj) Date=obj.innerText;
	obj=document.getElementById("TTimez"+CurrentSel);
	if (obj) Time=obj.value;
	DateTime=Date+" "+Time;
	var TxtInfo=TxtInfo+"^"+"DateTime"+Delim+DateTime;
	var TxtInfo=TxtInfo+"^"+"DateTime"+Delim+DateTime+"^"+"HosName"+Delim+HosName;
	PrintBalance(TxtInfo);
}
function PrintBalance(TxtInfo)
{
	//alert("TxtInfo=="+TxtInfo);
	DHCP_GetXMLConfig("InvPrintEncrypt","PEINVPRTBalance");
	var myobj=document.getElementById("ClsBillPrint");
	var Delim=String.fromCharCode(2);
	var TxtInfoHosp=TxtInfo+"^"+"BottomRemark"+Delim+"(持卡人存根)";
	DHCP_PrintFun(myobj,TxtInfoHosp,"");
	var TxtInfoPat=TxtInfo+"^"+"BottomRemark"+Delim+"(商户存根)";
	DHCP_PrintFun(myobj,TxtInfoPat,"");
}
document.body.onload = BodyLoadHandler;