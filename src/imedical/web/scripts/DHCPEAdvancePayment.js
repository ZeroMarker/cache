//Type 为C时.登记号的框用做代金卡的卡号来使用

function PrintReceipt()
{
	
	var CardNo="";
	var Cost="";
	var obj=GetObj("APCardNo");
	if (obj) {
		CardNo=obj.value;
	}
	var obj=GetObj("Fee");
	if (obj) {
		Cost=obj.value;
	}
	PrintAccSheet(CardNo,Cost);
}
function PrintAccSheet(CardNo,Cost){
	if (CardNo=="") return;
	if (Cost=="") return;
	
	var PayModeDR=21;
	var Type="";
	var obj=document.getElementById("Type");
	if (obj) Type=obj.value;
	var CurrentBalance=tkMakeServerCall("web.DHCPE.AdvancePayment","GetAPAmount",PayModeDR+"^"+Type,CardNo);
	var DateTime=tkMakeServerCall("web.DHCPE.Cashier","GetDateTimeStr");

	var Delim=String.fromCharCode(2);
	var TxtInfo="CardNo"+Delim+CardNo;
	var TxtInfo=TxtInfo+"^"+"Cost"+Delim+Cost;
	var TxtInfo=TxtInfo+"^"+"CurrentBalance"+Delim+CurrentBalance;
	var TxtInfo=TxtInfo+"^"+"DateTime"+Delim+DateTime;
	
	PrintBalance(TxtInfo);ElementEnble
	
}
// 打印体检支付卡余额
function PrintBalance(TxtInfo)
{
	DHCP_GetXMLConfig("InvPrintEncrypt","PEReceipt");
	var myobj=document.getElementById("ClsBillPrint");
	var Delim=String.fromCharCode(2);
	//var TxtInfoHosp=TxtInfo+"^"+"BottomRemark"+Delim+"(持卡人存根)";
	//DHCP_PrintFun(myobj,TxtInfoHosp,"");
	var TxtInfoPat=TxtInfo+"^"+"BottomRemark"+Delim+"(商户存根)";
	DHCP_PrintFun(myobj,TxtInfoPat,"");
}

function BodyLoadHandler(){
	var obj=GetObj("BSave");
	if (obj) obj.onclick=BSave_click;
    	var obj=GetObj("BChangeStatus");
    	if (obj) obj.onclick=BChangeStatus_click;
    	var obj=GetObj("RegNo");
    	if (obj) obj.onchange=RegNo_change;
    	var obj=GetObj("RegNo");
    	if (obj) obj.onkeydown=RegNo_keydown;
    	
    	var obj=GetObj("APCardNo");
    	if (obj) obj.onchange=RegNo_change;
    	var obj=GetObj("APCardNo");
    	if (obj) obj.onkeydown=RegNo_keydown;
    	
    	obj=document.getElementById("CardNo");
		if (obj) {
			obj.onchange=CardNo_Change;
		    obj.onkeydown=CardNo_keydown;
			}
			
		obj=document.getElementById("BClear");
		if (obj) {obj.onclick=BClear_Click;}
			
		obj=document.getElementById("BReadCard");
		if (obj) {obj.onclick=ReadCard_Click;}
		
		RegNo_change();
	
	    initialReadCardButton()
    	FillData(1)
    	ElementEnble();
		SetInvNo();
}
function SetInvNo()
{ 
	var userId=session['LOGON.USERID'];
	var ret=tkMakeServerCall("web.DHCPE.DHCPEPAY","getcurinvno",userId);
	
    var invNo=ret.split("^");
    if ((invNo[0]=="")||(invNo[1]==""))
    	{ alert(t['NoCorrectInv']); 
    	 		}
    	 		   
    if(invNo[2]!=""){var No=invNo[2]+""+invNo[0];}
    else {var No=invNo[0];}
    var obj=document.getElementById("CurInv");
    if(obj){obj.value=No;}
    
    return ;
}


function BClear_Click(){
	
	location.reload();
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
	CardNoChangeApp("RegNo","CardNo","RegNo_change()","Clear_click()","0");
}

function ReadCard_Click()
{
	ReadCardApp("RegNo","RegNo_change()","CardNo");
	
}
function BSave_click()
{
	var encmeth=GetOneData("UpdateClass");
	if (encmeth=="")
	{
		AL(t['01']);
		return false;
	}
	var NoPrint="";
	var obj=GetObj("NoPrintFlag");
	if ((obj)&&(obj.checked)) NoPrint="Y"
	var RowID=GetOneData("RowID");
	
	if (RowID!="")
	{
		var InvID=GetOneData("CurInv");
		var InvID=tkMakeServerCall("web.DHCPE.DHCPECommon","GetInvnoNotZM",InvID);
		if (InvID=="")
		{
			AL(t["03"]);
			return false;
		}
		var Fee=GetOneData("Fee");
		if (Fee=="")
		{
			AL(t["05"]);
			return false;
		}
		var PayMode=GetOneData("PayModeDR");
		
		var CardInfo="";
		var CardInfo=GetOneData("No");
		var PayModeDesc=tkMakeServerCall("web.DHCPE.Cashier","GetPayModeDesc",PayMode);
		if((PayModeDesc.indexOf("银行卡")>=0)||(PayModeDesc.indexOf("支票")>=0)){

			if(CardInfo==""){
			alert("请输入银行卡号或支票号")
			return false;
			}
		}
		var Remark=GetOneData("Remark");
		var MRemark=GetOneData("MRemark");
		var PADM=GetOneData("PADM");
		var InStrings=RowID+"^"+Fee+"^"+InvID+"^"+PayMode+"^"+MRemark+"^"+NoPrint+"^"+PADM+"^"+CardInfo+"^"+Remark;
		var Type=GetOneData("Type")
		if (Type=="C")
		{
			var sName=GetOneData("Name")
			if (sName==""){
				alert("姓名不能为空");
				return false;
			}
			var sSex=GetOneData("Sex")
			var sAge=GetOneData("Age")
			InStrings=InStrings+"&"+sName+"^"+sSex+"^"+sAge
		}
		var ret=cspRunServerMethod(encmeth,"2",InStrings);
		var RetArr=ret.split("^");
		if (RetArr[0]!=0)
		{
			AL(RetArr[0]);
			return false;
		}
	}
	else
	{
		var RegNo=GetOneData("RegNo");
		var Type=GetOneData("Type");
		var CardNo="";
		if (Type!="C")
		{
			if (RegNo=="")
			{
				alert("登记号不能为空");
				return false;
			}
		}
		else
		{
			var CardNo=GetOneData("APCardNo");
			if (CardNo=="")
			{
				alert("卡号不能为空");
				return false;
			}
		}
		var Amount=GetOneData("Amount");
		var Status=GetOneData("Status");
		if (Status!="N")
		{
			AL(t["StatusErr"]);
			return false;
		}
		var Date=""
		var Time=""
		var User=""
		var Remark=GetOneData("Remark")
		var PassWord=GetOneData("PassWord")
		var Fee=GetOneData("Fee")
		
		var CardInfo="";
		var CardInfo=GetOneData("No");
		var PayMode=GetOneData("PayModeDR");
		//if((PayMode=="2")||(PayMode=="4")){
		var PayModeDesc=tkMakeServerCall("web.DHCPE.Cashier","GetPayModeDesc",PayMode);
		if((PayModeDesc.indexOf("银行卡")>=0)||(PayModeDesc.indexOf("支票")>=0)){

			if(CardInfo==""){
			alert("请输入银行卡号或支票号")
			return false;
			}
		}

		if (Fee!="")
		{
			var InvID=GetOneData("CurInv");
			var InvID=tkMakeServerCall("web.DHCPE.DHCPECommon","GetInvnoNotZM",InvID);
			if (InvID=="")
			{
				AL(t["03"]);
				return false;
			}
		}else  if (Fee=="")
		{
		
			if ((Type=="C")||(Type=="R"))
			{
			
				AL(t["05"]);
				return false;
			}
		}

		var PayMode=GetOneData("PayModeDR");
		var MRemark=GetOneData("MRemark");
		var PADM=GetOneData("PADM");
		var InStrings="^"+RegNo+"^"+CardNo+"^"+Type+"^"+Amount
					  +"^"+Status+"^"+Date+"^"+Time+"^"+User
					  +"^"+Remark+"^"+PassWord+"&"+Fee+"^"+InvID+"^"+PayMode+"^"+MRemark+"^"+NoPrint+"^"+PADM+"^"+CardInfo;
		if (Type=="C")
		{
			var sName=GetOneData("Name")
			if (sName==""){
				alert("姓名不能为空");
				return false;
			}
			var sSex=GetOneData("Sex")
			var sAge=GetOneData("Age")
			InStrings=InStrings+"&"+sName+"^"+sSex+"^"+sAge
		}
		var ret=cspRunServerMethod(encmeth,"1",InStrings);
		var RetArr=ret.split("^");
		if (RetArr[0]!=0)
		{
			AL(RetArr[0]);
			return false;
		}
	}
	PrintReceipt();
	SetOneData("Fee","")
	if (Fee!="")
	{
		var InvID=GetOneData("CurInv");
		PrintInv(InvID)
	}
	window.close();
	//AL(t["Sussess"])
}
function BChangeStatus_click()
{
	var encmeth=GetOneData("UpdateClass");
	if (encmeth=="")
	{
		AL(t['01']);
		return false;
	}
	var RowID=GetOneData("RowID");
	if (RowID=="")
	{
		AL(t["06"]);
		return false;
	}
	var Status=GetOneData("Status");
	var Remark=GetOneData("MRemark");
	var Strings=RowID+"^"+Status+"^"+Remark;
	var ret=cspRunServerMethod(encmeth,"3",Strings)
	var RetArr=ret.split("^");
	if (RetArr[0]!=0)
	{
		AL(RetArr[0]);
		return false;
	}
	AL(t["Sussess"])
	
}
function FillData(Flag)
{
	var RowID=GetOneData("RowID");
	if (RowID=="")
	{
		var obj=GetObj("BSave");
		if (obj) obj.innerText="新建";
		return false;
	}
	else
	{
		
		var obj=GetObj("BSave");		
		var Type=GetOneData("Type");
		if ((Type!="R")&&(Type!="C"))
		{
			if (obj) obj.style.display="none"; //"inline"
		}
		else
		{
			if (obj) obj.innerText="充值";
		}
	}
	var encmeth=GetOneData("GetDataClass");
	if (encmeth=="")
	{
		AL(t['01']);
		return false;
	}
	var Data=cspRunServerMethod(encmeth,RowID);
	var DataArr=Data.split("^");
	SetOneData("RegNo",DataArr[0]);
	var obj=GetObj("RegNo")
	if (obj) obj.disabled=true;
	SetOneData("APCardNo",DataArr[1]);
	SetOneData("Type",DataArr[2]);
	SetOneData("Amount",DataArr[3]);
	SetOneData("Status",DataArr[4]);
	SetOneData("Remark",DataArr[8]);
	if (obj) obj.disabled=true;
	SetOneData("PassWord",DataArr[9]);
	if (Flag==1)
	{
		FillPatientData()
	}
	
}
function GetObj(ObjID)
{
	var obj=document.getElementById(ObjID);
	return obj;
}
function AL(String)
{
	alert(String)
}

function SetOneData(ElementName,DataStr)
{
	var obj=GetObj(ElementName);
	if (obj)
	{
		obj.value=DataStr;
	}
}
function GetOneData(ElementName)
{
	var DataStr="";
	var obj=GetObj(ElementName);
	if (obj) DataStr=obj.value;
	return DataStr;
}
function RegNo_change()
{
	FillPatientData();
	
}
function FillPatientData()
{
	var encmeth=GetOneData("GetPatientClass");
	if (encmeth=="")
	{
		AL(t['01']);
		return false;
	}
	var Type=GetOneData("Type");
	if (Type!="C")
	{
		var RegNo=GetOneData("RegNo");
	
	}
	else
	{
		var RegNo=GetOneData("APCardNo");
	}
	if (RegNo=="") return;
	var Data=cspRunServerMethod(encmeth,RegNo,Type);
	if (Type!="C")
	{
		if (Data=="")
		{
			AL(t['02'])
			return false;
		}
		var DataArr=Data.split("^");
		SetOneData("RegNo",DataArr[0]);
		SetOneData("Name",DataArr[1]);
		SetOneData("Age",DataArr[2]);
		SetOneData("Sex",DataArr[3]);
		SetOneData("CardNo",DataArr[4]);
		if (DataArr[5]!="")
		{
			SetOneData("RowID",DataArr[5]);
			FillData(0);
		}
	}
	else
	{
		if (Data=="")
		{
			return false;
		}
		var DataArr=Data.split("^");
		SetOneData("RegNo",DataArr[0]);
		SetOneData("Name",DataArr[1]);
		SetOneData("Age",DataArr[2]);
		SetOneData("Sex",DataArr[3]);
		SetOneData("CardNo",DataArr[4]);
		if (DataArr[5]!="")
		{
			SetOneData("RowID",DataArr[5]);
			FillData(0);
		}
	}
	var Fee=GetOneData("Fee");
	if (Fee=="")
	{
		websys_setfocus("Fee");
	}
	else
	{
		websys_setfocus("BSave");
	}
	return true;
}
function RegNo_keydown(e)
{
	var key=websys_getKey(e);
	if ( 13==key) {
		FillPatientData();
	}
}
function PrintInv(InvID)
{
	var encmeth=GetOneData("GetInvoiceInfo")
	var InvName=GetOneData("InvName");
	var TxtInfo=cspRunServerMethod(encmeth,InvID,"1",InvName)
	var ListInfo=cspRunServerMethod(encmeth,InvID,"2",InvName)
	if (TxtInfo=="") return
	///xml print requird
	DHCP_GetXMLConfig("InvPrintEncrypt","PEInvPrint");
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);
}

function ElementEnble()
{
	var Type=GetOneData("Type");

	if(Type=="R"){
		var obj=GetObj("BChangeStatus");
		if(obj){
			obj.disabled=true;
			obj.style.display="none";
		}
		var obj=GetObj("Status");
		if(obj){
			obj.disabled=true;
			obj.style.display="none";
		}
		var obj=GetObj("cStatus");
		if(obj){
			obj.disabled=true;
			obj.style.display="none";
		}


	}

	if ((Type!="R")&&(Type!="C"))
	{
		var obj=GetObj("Fee");
		if (obj) obj.disabled=true;
		var obj=GetObj("PayModeDR");
		if (obj) obj.disabled=true;
		
	}
	var obj=GetObj("cTitle");
	if (obj)
	{
		if (Type=="I") obj.innerText="贵宾卡";
		if (Type=="O") obj.innerText="折扣卡";
		if (Type=="C") obj.innerText="代金卡";
	}
	var obj=GetObj("cRegNo");
	if (obj)
	{
		if (Type=="C")
		{
			obj.innerText="代金卡号";
			obj=GetObj("BReadCard");
			if (obj) obj.style.display="none";
			obj=GetObj("CardNo");
			if (obj) obj.style.display="none";
			obj=GetObj("cCardNo");
			if (obj) obj.style.display="none";
			obj=GetObj("RegNo");
			if (obj) obj.style.display="none";
			var obj=GetObj("Name");
			if (obj) obj.disabled=false;
			var obj=GetObj("Sex");
			if (obj) obj.disabled=false;
			var obj=GetObj("Age");
			if (obj) obj.disabled=false;
		}
		else
		{
			obj=GetObj("APCardNo");
			if (obj) obj.style.display="none";
		}
	}
}

document.body.onload = BodyLoadHandler;