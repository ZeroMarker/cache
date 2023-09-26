
//名称	DHCPEAPAC.Find.js
//功能	预缴金/代金卡明细查询
//组件	DHCPEAPAC.Find 	
//创建	2018.08.17
//创建人  xy

function BodyLoadHandler(){
	
	var obj=GetObj("BFind");
   if (obj) obj.onclick=BFind_click;
   
    var obj=GetObj("RegNo");
    if (obj) obj.onkeydown=RegNo_keydown;
    
    obj=document.getElementById("CardNo");
	if (obj) {
		obj.onchange=CardNo_Change;
		obj.onkeydown=CardNo_keydown;
	}
	
	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCard_Click;}
	
	//重打凭条
	obj=document.getElementById("BRePrintBalance");
	if (obj) {obj.onclick=BRePrintBalance_click;}
	
	//原号重打发票
	obj=document.getElementById("BRePRintInv");
	if (obj) {obj.onclick=PrintCurInv;}

	
	$("#CardType").combobox({
		onSelect:function(){
		CardType_change();	
		}
	});

	SetButtonDisabl();
}

function SetButtonDisabl()
{
	CardType=getValueById("CardType");
	if (CardType=="C")
	{
		obj=document.getElementById("cRegNo");
		if (obj) obj.innerText="代金卡号";
		 obj=document.getElementById("BRePrintBalance"); 
		if (obj)  { DisableBElement("BRePrintBalance",false);}
	}
	if(CardType=="R")
	{
		obj=document.getElementById("RegNo");
		if(obj) {
			var regNo=obj.value;
			obj.value=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",regNo);
		}
		 obj=document.getElementById("BRePrintBalance"); 
		if (obj) { DisableBElement("BRePrintBalance",true);}

	}	
}
function CardType_change()
{
	SetButtonDisabl();
}


function BFind_click()
{
	
	var iName=getValueById("Name");
	
	var iType=getValueById("Type");
	
	var iCardType=getValueById("CardType");
	
	var iBeginDate=getValueById("BeginDate");
	
	var iEndDate=getValueById("EndDate");
	
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	iRegNo=getValueById("RegNo");
	if(iCardType=="R"){
	if (iRegNo.length<RegNoLength&&iRegNo.length>0) { iRegNo=RegNoMask(iRegNo);}
	}
	
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEAPAC.Find"
			+"&RegNo="+iRegNo
			+"&Name="+iName
			+"&Type="+iType
			+"&BeginDate="+iBeginDate
			+"&EndDate="+iEndDate
			+"&CardType="+iCardType
			;
			//messageShow("","","",lnk)
	location.href=lnk; 
    
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

function GetObj(ObjID)
{
	var obj=document.getElementById(ObjID);
	return obj;
}
function AL(String)
{
	messageShow("","","",String)
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

var selectrow=-1;
function SelectRowHandler(index,rowdata) {
	selectrow=index;
	if(index==selectrow)
	{		
	}else
	{
		selectrow=-1;
	}
}

function PrintCurInv()
{

	if (selectrow==-1) return false;
	var InvID="",DetailType="";
	var objtbl=$("#tDHCPEAPAC_Find").datagrid('getRows');
	var InvID=objtbl[selectrow].TSourceNo	
	if (InvID=="") return false;
	var DetailType=objtbl[selectrow].TType	
	if ((DetailType!="开户")&&(DetailType!="交预缴金")) return false;
	PrintInv(InvID);
}

function PrintInv(InvID)
{
	var encmeth=GetOneData("GetInvoiceInfo")
	var TxtInfo=cspRunServerMethod(encmeth,InvID,"1")
	var ListInfo=cspRunServerMethod(encmeth,InvID,"2")
	//messageShow("","","",TxtInfo)
	//messageShow("","","",ListInfo)
	if (TxtInfo=="") return
	///xml print requird
	DHCP_GetXMLConfig("InvPrintEncrypt","PEInvPrint");
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);
}

function BRePrintBalance_click()
{
	if (selectrow==-1) return false;
	var Delim=String.fromCharCode(2);
	var CardNO,Amt,ReAmt,Date,Time,DateTime;
	
	var HosName=""
    var HosName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",session['LOGON.HOSPID'])
	if(HosName.indexOf("[")>-1){var HosName=HosName.split("[")[0];}
    
    var objtbl=$("#tDHCPEAPAC_Find").datagrid('getRows');
	var CardNO=objtbl[selectrow].TDJCardNo;
	var TxtInfo="CardNo"+Delim+CardNO;
	
	var Amt=objtbl[selectrow].TAmount;
	if(Amt>0){Amt=0;}
	else{Amt=-Amt;}  
	var TxtInfo=TxtInfo+"^"+"Cost"+Delim+Amt;
	
	var ReAmt=objtbl[selectrow].TRemainAmount;
	var TxtInfo=TxtInfo+"^"+"CurrentBalance"+Delim+ReAmt;
	
	var Date=objtbl[selectrow].TDate;
	var Time=objtbl[selectrow].TTime;
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
	//alert("TxtInfoHosp:"+TxtInfoHosp)
	DHCP_PrintFun(myobj,TxtInfoHosp,"");
	var TxtInfoPat=TxtInfo+"^"+"BottomRemark"+Delim+"(商户存根)";
	//alert("TxtInfoPat:"+TxtInfoPat)
	DHCP_PrintFun(myobj,TxtInfoPat,"");
}
document.body.onload = BodyLoadHandler;