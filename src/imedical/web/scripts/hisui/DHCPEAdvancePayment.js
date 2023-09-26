
//名称	DHCPEAdvancePayment.js
//功能	预缴金/代金卡管理
//组件	DHCPEAdvancePayment 	
//创建	2019.04.03
//创建人  xy
//Type 为C时.登记号的框用做代金卡的卡号来使用

function BodyLoadHandler(){
	
		var obj=GetObj("BSave");
		if (obj) obj.onclick=BSave_click;
		
    	var obj=GetObj("BChangeStatus");
    	if (obj) obj.onclick=BChangeStatus_click;
    	
    	
       $("#RegNo").keydown(function(e) {
			if(e.keyCode==13){
				RegNo_change();
			}
			
        });
    	
    	$("#APCardNo").keydown(function(e) {
			if(e.keyCode==13){
				RegNo_change();
			}
			
        });

		 $("#CardNo").keydown(function(e) {
			if(e.keyCode==13){
				CardNo_Change();
			}
			
        });
    	
		
		//清屏	
		obj=document.getElementById("BClear");
		if (obj) {obj.onclick=BClear_Click;}
		
		//读卡  	
		obj=document.getElementById("BReadCard");
		if (obj) {obj.onclick=ReadCardClickHandler;}
		
		
		$("#CardType").combobox({
			onSelect:function(){
			CardType_change();	
		}
	    });
		
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
    	{ messageShow("","","",t['NoCorrectInv']); 
    	 		}
    	 		   
    if(invNo[2]!=""){var No=invNo[2]+""+invNo[0];}
    else {var No=invNo[0];}
    var obj=document.getElementById("CurInv");
    if(obj){obj.value=No;}
    
    return ;
}


function BClear_Click(){
		  
	  setValueById("RegNo","");
	  setValueById("APCardNo","");
	  setValueById("Name","");
	  setValueById("Sex","");
	  setValueById("Age","");
	  setValueById("Amount","");
	  setValueById("Remark","");
	  setValueById("MRemark","");
	  setValueById("InvName",""); 
	  setValueById("Fee",""); 
	  setValueById("CardNo",""); 
	  setValueById("No","");


}


function CardNo_Change()
{
	var obj=document.getElementById("CardNo"); 
	if (obj){ var myCardNo=obj.value;}
	if (myCardNo=="") return;
		var myrtn=DHCACC_GetAccInfo("",myCardNo,"","PatInfo",CardTypeCallBack);
		return false;
	
}

//读卡
function ReadCardClickHandler(){
	
	var myrtn=DHCACC_GetAccInfo7(CardTypeCallBack);
}

function CardTypeCallBack(myrtn){
   var myary=myrtn.split("^");
   
   var rtn=myary[0];
	switch (rtn){
		case "0": //卡有效有帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#CardNo").focus().val(CardNo);
			$("#RegNo").val(PatientNo);
			$("#CardTypeNewID").val(CardTypeNewID);
			FillPatientData();
	        ElementEnble();
			event.keyCode=13; 
			break;
		case "-200": //卡无效
			$.messager.alert("提示","卡无效","info",function(){$("#CardNo").focus();});
			break;
		case "-201": //卡有效无帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#CardNo").focus().val(CardNo);
			$("#RegNo").val(PatientNo);
			$("#CardTypeNewID").val(CardTypeNewID);
			FillPatientData();
	        ElementEnble();
			event.keyCode=13;
			break;
		default:
	}
}

function BSave_click()
{
	var Type=getValueById("CardType");
	if(Type==""){
		$.messager.alert("提示","请选择体检卡类型","info");
		return false
	
	}
	var encmeth=GetOneData("UpdateClass")
	if (encmeth=="")
	{
		alert("没有获取数据方法")
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
			$.messager.alert("提示","没有发票,不能充值","info");
			return false;
		}
		var Fee=GetOneData("Fee");
		if (Fee=="")
		{
			$.messager.alert("提示","充值金额不能为空","info");
			return false;
		}
		
		var PayMode=getValueById("PayModeDR");
		var CardInfo="";
		var CardInfo=GetOneData("No");
		var PayModeDesc=tkMakeServerCall("web.DHCPE.Cashier","GetPayModeDesc",PayMode);
		if((PayModeDesc.indexOf("银行卡")>=0)||(PayModeDesc.indexOf("支票")>=0)){

			if(CardInfo==""){
			$.messager.alert("提示","请输入银行卡号或支票号","info");
			return false;
			}
		}
		var Remark=GetOneData("Remark");
		var MRemark=GetOneData("MRemark");
		var PADM=GetOneData("PADM");
		var InStrings=RowID+"^"+Fee+"^"+InvID+"^"+PayMode+"^"+MRemark+"^"+NoPrint+"^"+PADM+"^"+CardInfo+"^"+Remark;
		//var Type=GetOneData("Type")
		var Type=getValueById("CardType");
		if (Type=="C")
		{
			var sName=GetOneData("Name")
			if (sName==""){
				$.messager.alert("提示","姓名不能为空","info");	
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
			alert(RetArr[0]);
			return false;
		}
	}
	else
	{
		var RegNo=GetOneData("RegNo");
		
		var Type=getValueById("CardType");
		var CardNo="";
		if (Type!="C")
		{
			if (RegNo=="")
			{
				$.messager.alert("提示","登记号不能为空","info");
				return false;
			}
		}
		else
		{
			var CardNo=GetOneData("APCardNo");
			if (CardNo=="")
			{
				$.messager.alert("提示","卡号不能为空","info");
				return false;
			}
		}
		var Amount=GetOneData("Amount");
		var Status=getValueById("Status");
		if (Status!="N")
		{
			$.messager.alert("提示","不是可用的状态","info");
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
		var PayMode=getValueById("PayModeDR");
		//if((PayMode=="2")||(PayMode=="4")){
		var PayModeDesc=tkMakeServerCall("web.DHCPE.Cashier","GetPayModeDesc",PayMode);
		if((PayModeDesc.indexOf("银行卡")>=0)||(PayModeDesc.indexOf("支票")>=0)){

			if(CardInfo==""){
				$.messager.alert("提示","请输入银行卡号或支票号","info");
				return false;
			}
		}

		if (Fee!="")
		{
			var InvID=GetOneData("CurInv");
			var InvID=tkMakeServerCall("web.DHCPE.DHCPECommon","GetInvnoNotZM",InvID);
			if (InvID=="")
			{
				$.messager.alert("提示","没有发票,不能充值","info");
				return false;
			}
		}else  if (Fee=="")
		{
		
			if ((Type=="C")||(Type=="R"))
			{
				$.messager.alert("提示","充值金额不能为空","info");
				return false;
			}
		}

		var PayMode=getValueById("PayModeDR");
		var MRemark=GetOneData("MRemark");
		var PADM=GetOneData("PADM");
		var InStrings="^"+RegNo+"^"+CardNo+"^"+Type+"^"+Amount
					  +"^"+Status+"^"+Date+"^"+Time+"^"+User
					  +"^"+Remark+"^"+PassWord+"&"+Fee+"^"+InvID+"^"+PayMode+"^"+MRemark+"^"+NoPrint+"^"+PADM+"^"+CardInfo;
		if (Type=="C")
		{
			var sName=GetOneData("Name")
			if (sName==""){
				$.messager.alert("提示","姓名不能为空","info");
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
			alert(RetArr[0])
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
	websys_showModal("close");
	//window.close();
	
}
function BChangeStatus_click()
{
	var encmeth=GetOneData("UpdateClass");
	if (encmeth=="")
	{
		alert("没有获取数据方法")
		return false;
	}
	var RowID=GetOneData("RowID");
	if (RowID=="")
	{
		$.messager.alert("提示","没有要修改的记录","info");
		return false;
	}
	var Status=getValueById("Status");
	var Remark=GetOneData("MRemark");
	var Strings=RowID+"^"+Status+"^"+Remark;
	var ret=cspRunServerMethod(encmeth,"3",Strings)
	var RetArr=ret.split("^");
	if (RetArr[0]!=0)
	{
		$.messager.alert("提示",RetArr[0],"info");
		return false;
	}
	alert("操作完成");
	ElementEnble();
	
}
function FillData(Flag)
{
	var RowID=GetOneData("RowID");
	if (RowID=="")
	{
		SetCElement("BSave","新建");
		return false;
	}
	else
	{
		
		var obj=GetObj("BSave");		
		var Type=getValueById("CardType");
		if ((Type!="R")&&(Type!="C"))
		{
			 if (obj)DisableBElement("BSave",true);
		
		}
		else
		{	
		     if (obj)DisableBElement("BSave",false);
			SetCElement("BSave","充值");
			
		}
	}
	var encmeth=GetOneData("GetDataClass");
	if (encmeth=="")
	{
		alert("没有获取数据方法")
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
	var Type=getValueById("CardType");
	var CurrentBalance=tkMakeServerCall("web.DHCPE.AdvancePayment","GetAPAmount",PayModeDR+"^"+Type,CardNo);
	var DateTime=tkMakeServerCall("web.DHCPE.Cashier","GetDateTimeStr");

	var Delim=String.fromCharCode(2);
	var TxtInfo="CardNo"+Delim+CardNo;
	var TxtInfo=TxtInfo+"^"+"Cost"+Delim+Cost;
	var TxtInfo=TxtInfo+"^"+"CurrentBalance"+Delim+CurrentBalance;
	var TxtInfo=TxtInfo+"^"+"DateTime"+Delim+DateTime;
	
	PrintBalance(TxtInfo);
	
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
function GetObj(ObjID)
{
	var obj=document.getElementById(ObjID);
	return obj;
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

function FillPatientData()
{
	
	var encmeth=GetOneData("GetPatientClass");
	if (encmeth=="")
	{
		alert("没有获取数据方法")
		return false;
	}
	
	var Type=getValueById("CardType");
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
	//alert(Data)
	if (Type!="C")
	{
		if (Data=="")
		{
			alert("无效的登记号");
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
		setValueById("Status",DataArr[6]);
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


function RegNo_change()
{
	var Type=getValueById("CardType");
	if(Type==""){
		//$.messager.alert("提示","请选择体检卡类型","info");
		alert("请选择体检卡类型");
		return false;
	}
	FillPatientData();
	ElementEnble();
	
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


function CardType_change()
{
	ElementEnble();
	BClear_Click();
}
function ElementEnble()
{
	
	var Type=getValueById("CardType");
	if(Type=="R"){
		var obj=GetObj("BChangeStatus");
		if(obj){DisableBElement("BChangeStatus",true);}

	}else{
		var obj=GetObj("BChangeStatus");
		if(obj){DisableBElement("BChangeStatus",false);}
		var Status=getValueById("Status");
		if (Status!="N")
		{
			var obj=GetObj("BSave");
		    if(obj){DisableBElement("BSave",true);}
			
		}else{
			var obj=GetObj("BSave");
		    if(obj){DisableBElement("BSave",false);}
		}
	}

	if ((Type!="R")&&(Type!="C"))
	{
		var obj=GetObj("Fee");
		if (obj) obj.disabled=true;
		var obj=GetObj("PayModeDR");
		if (obj) obj.disabled=true;
		
	}else{
		var obj=GetObj("Fee");
		if (obj) obj.disabled=false;
		var obj=GetObj("PayModeDR");
		if (obj) obj.disabled=false;
	}
	
	var obj=GetObj("cRegNo");
	if (obj)
	{
		if (Type=="C")
		{
			obj.innerText="代金卡号";
			obj=GetObj("CardNo");
			if (obj) obj.style.display="none";
			obj=GetObj("cCardNo");
			if (obj) obj.style.display="none";
			obj=GetObj("CardTypeNew");
			if (obj) obj.style.display="none";
			obj=GetObj("cCardTypeNew");
			if (obj) obj.style.display="none";
			obj=GetObj("RegNo");
			if (obj) obj.style.display="none";
			var obj=GetObj("Name");
			if (obj) obj.disabled=false;
			var obj=GetObj("Sex");
			if (obj) obj.disabled=false;
			var obj=GetObj("Age");
			if (obj) obj.disabled=false;
			obj=GetObj("APCardNo");
			if (obj) obj.style.display="inline";
			obj=GetObj("BReadCard");
			if(obj){DisableBElement("BReadCard",true);}
		}
		else
		{
	
			obj.innerText="登记号";
			obj=GetObj("CardNo");
			if (obj) obj.style.display="inline";
			obj=GetObj("cCardNo");
			if (obj) obj.style.display="inline";
			obj=GetObj("CardTypeNew");
			if (obj) obj.style.display="inline";
			obj=GetObj("cCardTypeNew");
			if (obj) obj.style.display="inline";
			
			obj=GetObj("RegNo");
			if (obj) {obj.style.display="inline";
			obj.disabled=false;
			}
			var obj=GetObj("Name");
			if (obj) obj.disabled=true;
			var obj=GetObj("Sex");
			if (obj) obj.disabled=true;
			var obj=GetObj("Age");
			if (obj) obj.disabled=true;
			obj=GetObj("APCardNo");
			if (obj) obj.style.display="none";
			obj=GetObj("BReadCard");
			if(obj){DisableBElement("BReadCard",false);}
			
		}
	}
}

document.body.onload = BodyLoadHandler;