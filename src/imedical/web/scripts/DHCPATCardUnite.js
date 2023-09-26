document.body.onload = DocumentLoadHandler;
var e=event;
var SearchCardNoMode=document.getElementById("GetCardNoSearchMode").value
//var myPatType= DHCWebD_GetObjValue("PatType");
function DocumentLoadHandler()
{
	var obj;
	obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_click;
	obj=document.getElementById("OldRegNo");
	if (obj) obj.onkeydown=OldRegNo_keydown;
	if (obj) obj.onchange=OldRegNo_change;
	obj=document.getElementById("RegNo");
	if (obj) obj.onkeydown=RegNo_keydown;
	if (obj) obj.onchange=RegNo_change;
	//卡信息选择框
	obj=document.getElementById("OldCardInfo")
	if (obj) obj.multiple=true;
	obj=document.getElementById("CardInfo")
	if (obj) obj.multiple=true;
	//卡类型下拉框
	var mySessionStr=DHCWeb_GetSessionPara();
	DHCWebD_ClearAllListA("OldCardType");
	var encmeth=DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","OldCardType", mySessionStr);
	}
	DHCWebD_ClearAllListA("CardType");
	var encmeth=DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardType", mySessionStr);
	}
	
	obj=document.getElementById("OldCardType");
	if (obj) obj.multiple=false;
	if (obj) obj.size=1;
	obj=document.getElementById("CardType");
	if (obj) obj.multiple=false;
	if (obj) obj.size=1;
	
	//读卡
	var obj=document.getElementById("OldReadCard");
	if (obj) obj.onclick=OldReadCard_click;
	var obj=document.getElementById("ReadCard");
	if (obj) obj.onclick=ReadCard_click;
	//卡号
	obj=document.getElementById("OldCardNo");
	if (obj) obj.onkeydown=OldCardNo_keydown;
	if (obj) obj.onchange=OldCardNo_change;
	obj=document.getElementById("CardNo");
	if (obj) obj.onkeydown=CardNo_keydown;
	if (obj) obj.onchange=CardNo_change;
	//打印条码
	obj=document.getElementById("BPrintInfo");
	if (obj) obj.onclick=PatInfoPrint;
	//合并卡
	obj=document.getElementById("BCardUnite");
	if (obj) obj.onclick=BCardUnite_click;
	
	//未交费明细
	obj=document.getElementById("OldFeeDetail");
	if (obj) obj.onclick=OldFeeDetail_click;
	//未交费明细
	obj=document.getElementById("FeeDetail");
	if (obj) obj.onclick=FeeDetail_click;
	
	//病人类型已确认
	obj=document.getElementById("PatTypeAudit");
	if (obj) obj.onclick=PatTypeAudit_click;
	
	SetCopyClick();
	
	var RegNo=DHCWebD_GetObjValue("RegNo");
	var obj=document.getElementById("RegNo");
	obj.value=""
    SetListData(RegNo,"");
	var DeleteImgObj=document.getElementById("DeleteImg");
	if (DeleteImgObj){DeleteImgObj.onclick=DeleteImg_click;}
	
	//alert(ReadBankCardInfo("04","","CardType"))
}
function SetCopyClick()
{
	var buttonObj=document.all.tags("A");
	var buttonNum=buttonObj.length;
     	//alert(buttonNum)
     	//return false;
	for(var   i=0;i<buttonNum;i++)   
	{   
		var id=buttonObj[i].id;
		if (id.split("Copy").length>1)
		{
			buttonObj[i].onclick=CopyInfo;
		} 
	}


}
function CopyInfo()
{
	var eSrc=window.event.srcElement;
	var ElementName=eSrc.id.split("Copy")[1];
	var Str=DHCWebD_GetObjValue("Old"+ElementName);
	DHCWebD_SetObjValueA(ElementName,Str);
	return false;
}
function AuditInfo()
{
	var eSrc=window.event.srcElement;
	var ElementName=eSrc.id.split("Audit")[0];
	var Str=DHCWebD_GetObjValue(ElementName);
	DHCWebD_SetObjValueA("Old"+ElementName,Str);
	return false;
}
function PatTypeAudit_click()
{
	AuditInfo();
}
function OldFeeDetail_click()
{
	FeeDetail("Old");
}
function FeeDetail_click()
{
	FeeDetail("");
}
function FeeDetail(Type)
{
	var RegNo=DHCWebD_GetObjValue(Type+"RegNo");
	if (RegNo=="") 
	{
		alert("没有选择查看的人员");
		return false;
	}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPATCardUniteNoPayDetail"
			+"&RegNo="+RegNo+"&Days=";
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=yes,scrollbars=yes,resizable=yes,copyhistory=yes'
	var cwin=window.open(lnk,"_blank",nwin)
}

function BCardUnite_click()
{
	var obj;
	var OldRegNo="",RegNo="",SelectCard="",Amount="";
	obj=document.getElementById("OldAmount");
	if (obj) Amount=obj.value;
	if ((Amount!="")&&(Amount!=0)){
		alert("被合并的账户不是空,不允许被合并");
		return false;
	}
	
	obj=document.getElementById("OldRegNo");
	if (obj) OldRegNo=obj.value;
	if (OldRegNo==""){
		alert("被合并信息不能为空");
		return false;
	}
	obj=document.getElementById("RegNo");
	if (obj) RegNo=obj.value;
	if (RegNo==""){
		alert("合并到信息不能为空");
		return false;
	}
	if (parseFloat(RegNo)==parseFloat(OldRegNo)){
		alert("被合并的信息和合并到的信息不能相同");
		return false;
	}
	var OldPatType=DHCWebD_GetObjValue("OldPatType");
	var PatType=DHCWebD_GetObjValue("PatType");
	if (Trim(OldPatType)!=Trim(PatType)) {
		alert("被合并的[病人类型]和合并到的[病人类型]不一致,不允许合并,请修改或复制.");
		return false;
	}
	
	var flag=tkMakeServerCall("web.DHCPATCardUnite","CanUnite",OldRegNo,RegNo);
	if (flag!=""){
		alert(flag);
		return false;
	}
	
	var OldName=DHCWebD_GetObjValue("OldName");
	var OldSex=DHCWebD_GetObjValue("OldSex");
	var OldBirth=DHCWebD_GetObjValue("OldBirth");
	var Name=DHCWebD_GetObjValue("Name");
	var Sex=DHCWebD_GetObjValue("Sex");
	var Birth=DHCWebD_GetObjValue("Birth");
	var ConfirmInfo="";
	if (OldName!=Name){
		ConfirmInfo="姓名"
	}
	if (OldSex!=Sex){
		if (ConfirmInfo==""){
			ConfirmInfo="性别"
		}else{
			ConfirmInfo=ConfirmInfo+",性别"
		}
	}
	if (OldBirth!=Birth){
		if (ConfirmInfo==""){
			ConfirmInfo="出生日期"
		}else{
			ConfirmInfo=ConfirmInfo+",出生日期"
		}
	}
	if (ConfirmInfo!=""){
		ConfirmInfo=ConfirmInfo+"不相同,不能继续合并."
		//if (!confirm(ConfirmInfo)) return false;
		alert(ConfirmInfo);
		return false;
	}
	var OldCardInfo=GetSelect("OldCardInfo","innerText")
	var CardInfo=GetSelect("CardInfo","innerText")
	if (OldCardInfo!="") SelectCard=OldCardInfo;
	if (CardInfo!=""){
		if (SelectCard!=""){
			SelectCard=SelectCard+"^"+CardInfo;
		}else{
			SelectCard=CardInfo;
		}
	}
	if (SelectCard==""){
		alert("没有选择被合并和合并到的卡信息,请选择.");
		return false;
	}
	
	//flag  1  有相同的卡类型不能合并
	var flag=tkMakeServerCall("web.DHCPATCardUnite","CheckCardType",SelectCard);
	if (flag==1){
		alert("合并的卡类型,存在相同的卡类型");
		return false;
	}
	SelectCard="";
	var OldCardInfo=GetSelect("OldCardInfo","value");
	var CardInfo=GetSelect("CardInfo","value");
	if (OldCardInfo!="") SelectCard=OldCardInfo;
	if (CardInfo!=""){
		if (SelectCard!=""){
			SelectCard=SelectCard+"^"+CardInfo;
		}else{
			SelectCard=CardInfo;
		}
	}
	if (!(confirm("确实要把登记号'"+OldRegNo+"'中的信息合并到登记号'"+RegNo+"'中吗?"))) {  return false; }
	var OldMedicalNo=DHCWebD_GetObjValue("OldMedicalNo");
	var MedicalNo=DHCWebD_GetObjValue("MedicalNo");
	if ((MedicalNo=="")&&(OldMedicalNo!="")) MedicalNo=OldMedicalNo;  //自动保存病案号
	var PatType=DHCWebD_GetObjValue("PatType");
	PatType=PatType.split(";")[0];
	var YBCode=DHCWebD_GetObjValue("YBCode");
	
	var CredType=GetElementValue("CredType","1");
	var Marital=GetElementValue("Marital","1");
	var Tel=GetElementValue("Tel","0");
	var Mobile=GetElementValue("Mobile","0");
	var MedicalUnionNo=GetElementValue("MedicalUnionNo","0");
	
	var Country=GetElementValue("Country","1");
	var Nation=GetElementValue("Nation","1");
	var ProvinceHome=GetElementValue("ProvinceHome","1");
	var CityHome=GetElementValue("CityHome","1");
	var ProvinceBirth=GetElementValue("ProvinceBirth","1");
	
	var CityBirth=GetElementValue("CityBirth","1");
	var AreaBirth=GetElementValue("AreaBirth","1");
	var CompanyPostCode=GetElementValue("CompanyPostCode","0");
	var ProvinceHouse=GetElementValue("ProvinceHouse","1");
	var Cityhouse=GetElementValue("Cityhouse","1");
	
	var AreaHouse=GetElementValue("AreaHouse","1");
	var PostCodeHouse=GetElementValue("PostCodeHouse","0");
	var Province=GetElementValue("Province","1");
	var City=GetElementValue("City","1");
	var Area=GetElementValue("Area","1");
	
	var Address=GetElementValue("Address","0");
	var Zip=GetElementValue("Zip","0");
	var Vocation=GetElementValue("Vocation","1");
	var Company=GetElementValue("Company","0");
	var OfficeTel=GetElementValue("OfficeTel","0");
	
	var ForeignName=GetElementValue("ForeignName","0");
	var Relation=GetElementValue("Relation","1");
	var ForeignAddress=GetElementValue("ForeignAddress","0");
	var ForeignPhone=GetElementValue("ForeignPhone","0");
	var ForeignIDCard=GetElementValue("ForeignIDCard","0");
	var PoliticalLevel=GetElementValue("PoliticalLevel","1");
	var SecretLevel=GetElementValue("SecretLevel","1");
	var IDCard=GetElementValue("IDCard","0"); //证件号码
	var OtherInfo=MedicalNo+"^"+PatType+"^"+YBCode;
	OtherInfo=OtherInfo+"^"+CredType+"^"+Marital+"^"+Tel+"^"+Mobile+"^"+MedicalUnionNo+"^"+Country+"^"+Nation
	OtherInfo=OtherInfo+"^"+ProvinceHome+"^"+CityHome+"^"+ProvinceBirth+"^"+CityBirth+"^"+AreaBirth+"^"+CompanyPostCode+"^"+ProvinceHouse
	OtherInfo=OtherInfo+"^"+Cityhouse+"^"+AreaHouse+"^"+PostCodeHouse+"^"+Province+"^"+City+"^"+Area+"^"+Address
	OtherInfo=OtherInfo+"^"+Zip+"^"+Vocation+"^"+Company+"^"+OfficeTel+"^"+ForeignName+"^"+Relation+"^"+ForeignAddress
	OtherInfo=OtherInfo+"^"+ForeignPhone+"^"+ForeignIDCard+"^"+PoliticalLevel+"^"+SecretLevel+"^"+IDCard
	var flag=tkMakeServerCall("web.DHCPATCardUnite","CardUnite",OldRegNo,RegNo,SelectCard,OtherInfo,session['LOGON.HOSPID']);
	if (flag!=""){
		alert("更新失败,错误信息为:"+flag);
		return false;
	}else{
		alert("调整卡信息完成");
		location.reload();
	}
	
	
}
function GetElementValue(ElementName,DRFlag)
{
	ElementValue=DHCWebD_GetObjValue(ElementName);
	if (DRFlag=="1") ElementValue=ElementValue.split(";")[0];
	return ElementValue;
}
function OldCardNo_keydown()
{
	var Key=websys_getKey(e);
	if ((13==Key)) {
		ChangeCardNOLong("Old")
		SetCardNoData("Old");
	}
}
function OldCardNo_change()
{
	SetCardNoData("Old");
}
function CardNo_keydown()
{
	var Key=websys_getKey(e);
	if ((13==Key)) {
		ChangeCardNOLong("")
		SetCardNoData("");
	}
}
function CardNo_change()
{
	SetCardNoData("");
}
function SetCardNoData(Type)
{
	var CardNo="";
	var obj=document.getElementById(Type+"CardNo");
	if (obj) CardNo=obj.value;
	if (CardNo=="") return false;
	var myoptval=GetSelect(Type+"CardType","value");
	var myary=myoptval.split("^");
	var myCardTypeDR=myary[0];
	//PC 根据卡号找卡类型  卡号不自动补0
	//if(SearchCardNoMode=="PC") {
		var myrtn=DHCACC_GetAccInfo(myCardTypeDR,CardNo,"","PatInfo");
		var myary=myrtn.split("^");
		var rtn=myary[0];
		switch (rtn){
			case "0":
			  var RegNo=myary[5];
			  var NewCardTypeRowId=myary[8];
			  //通过卡号去找卡找到卡类型
			   var obj=document.getElementById(Type+"CardType")
			   if(myCardTypeDR!=NewCardTypeRowId){
				   for(var i=0;i<obj.length;i++){
					   var CardTypeID=obj[i].value.split("^")[0]
					   if(CardTypeID==NewCardTypeRowId){
						   obj.selectedIndex = i;
					   }
				   }
			   }
			case "-200":
				alert("无效卡");
				var RegNo=""
				websys_setfocus(Type+"CardNo");
				break;
			case "-201": //卡有效无帐户
			   var RegNo=myary[5];
			   var NewCardTypeRowId=myary[8];
			   var obj=document.getElementById(Type+"CardType")
			   if(myCardTypeDR!=NewCardTypeRowId){
				   for(var i=0;i<obj.length;i++){
					   var CardTypeID=obj[i].value.split("^")[0]
					   if(CardTypeID==NewCardTypeRowId){
						   obj.selectedIndex = i;
					   }
				   }
			   }
			   break;
			   default:
		}
	/*}else{
		
		var RegNo=tkMakeServerCall("web.DHCPATCardUnite","GetRegNoByCardNo",myCardTypeDR,CardNo);
		if (RegNo==""){
			alert("无效的卡号");
			return false;
		}
	}*/
	if(RegNo==""){
		return false;
	}
	var obj=document.getElementById(Type+"RegNo");
	if (obj) obj.value=RegNo;
	SetListData(RegNo,Type);
}
function OldReadCard_click()
{
	ReadCard("Old");
}
function ReadCard_click()
{
	ReadCard("");
}
function ReadCard(Type)
{
	var myoptval=GetSelect(Type+"CardType","value");
	var myary=myoptval.split("^");
	var myCardTypeDR=myary[0];
	var rtn=DHCACC_GetAccInfo(myCardTypeDR,myoptval);     //其它项目读卡取患者信息?卡信息?账户信息
	var ReturnArr=rtn.split("^");
	if (ReturnArr[0]=="-200")
	{
		 alert("无效的卡");
		 return false;
	}
	var obj=document.getElementById(Type+"RegNo")
	if (obj)
	{
		 obj.value=ReturnArr[5];
		 SetData(Type)
		 obj=document.getElementById(Type+"CardNo");
		 if (obj) obj.value=ReturnArr[1];
	 	
	}
}
function GetSelect(SelectElement,Type)
{
	var result="";
	var obj=document.getElementById(SelectElement);
	var len=obj.options.length;
	for (var i=0;i<len;i++)
	{
		if (Type=="innerText")
		{
			if (obj.options[i].selected) result=result+"^"+obj.options[i].innerText.split("^")[0];
		}else{
			if (obj.options[i].selected) result=result+"^"+obj.options[i].value;
		}
	}
	if (result!="") result=result.substring(1);
	return result;	
}
function OldRegNo_keydown()
{
	var Key=websys_getKey(e);
	if ((13==Key)) {
		ChangePatNOLong();
		SetData("Old");
	}
}
function RegNo_keydown()
{
	var Key=websys_getKey(e);
	if ((13==Key)) {
		ChangePatNOLong();
		SetData("");
	}
}
function OldRegNo_change()
{
	SetData("Old");
}
function RegNo_change()
{
	SetData("");
}
function SetData(Type)
{
	var RegNo="";
	var obj=document.getElementById(Type+"RegNo");
	if (obj) RegNo=obj.value;
	if (RegNo=="") return false;
	SetListData(RegNo,Type)
}
function SetListData(RegNo,Type)
{
	if (RegNo=="") return false;
	var obj=document.getElementById(Type+"CardInfo");
	var length=obj.length
	for (i=0;i<length;i++)
	{
		obj.remove(0);
	}
	var Data=tkMakeServerCall("web.DHCPATCardUnite","GetPatInfoByRegNo",RegNo);
	if (Data=="") {alert("没有对应的有效信息");return false;}
	var DataArr=Data.split("^");
	if (DataArr.length<40){alert("对应的有效信息查询错误");return false}
	DHCWebD_SetObjValueA(Type+"Name",DataArr[0]);
	DHCWebD_SetObjValueA(Type+"Sex",DataArr[1]);
	DHCWebD_SetObjValueA(Type+"Birth",DataArr[2]);
	DHCWebD_SetObjValueA(Type+"IDCard",DataArr[3]);
	DHCWebD_SetObjValueA(Type+"MedicalNo",DataArr[4]);
	
	DHCWebD_SetObjValueA(Type+"PatType",DataArr[5]);
	//PatCode  6
	DHCWebD_SetObjValueA(Type+"Amount",DataArr[7]);
	DHCWebD_SetObjValueA(Type+"YBCode",DataArr[8]);
	DHCWebD_SetObjValueA(Type+"Remark",DataArr[9]);
	
	DHCWebD_SetObjValueA(Type+"CredType",DataArr[10]);
	DHCWebD_SetObjValueA(Type+"Marital",DataArr[11]);
	DHCWebD_SetObjValueA(Type+"Tel",DataArr[12]);
	DHCWebD_SetObjValueA(Type+"Mobile",DataArr[13]);
	DHCWebD_SetObjValueA(Type+"MedicalUnionNo",DataArr[14]);
	
	DHCWebD_SetObjValueA(Type+"Country",DataArr[15]);
	DHCWebD_SetObjValueA(Type+"Nation",DataArr[16]);
	DHCWebD_SetObjValueA(Type+"ProvinceHome",DataArr[17]);
	DHCWebD_SetObjValueA(Type+"CityHome",DataArr[18]);
	DHCWebD_SetObjValueA(Type+"ProvinceBirth",DataArr[19]);
	
	DHCWebD_SetObjValueA(Type+"CityBirth",DataArr[20]);
	DHCWebD_SetObjValueA(Type+"AreaBirth",DataArr[21]);
	DHCWebD_SetObjValueA(Type+"CompanyPostCode",DataArr[22]);
	DHCWebD_SetObjValueA(Type+"ProvinceHouse",DataArr[23]);
	DHCWebD_SetObjValueA(Type+"Cityhouse",DataArr[24]);
	
	DHCWebD_SetObjValueA(Type+"AreaHouse",DataArr[25]);
	DHCWebD_SetObjValueA(Type+"PostCodeHouse",DataArr[26]);
	DHCWebD_SetObjValueA(Type+"Province",DataArr[27]);
	DHCWebD_SetObjValueA(Type+"City",DataArr[28]);
	DHCWebD_SetObjValueA(Type+"Area",DataArr[29]);
	
	DHCWebD_SetObjValueA(Type+"Address",DataArr[30]);
	DHCWebD_SetObjValueA(Type+"Zip",DataArr[31]);
	DHCWebD_SetObjValueA(Type+"Vocation",DataArr[32]);
	DHCWebD_SetObjValueA(Type+"Company",DataArr[33]);
	DHCWebD_SetObjValueA(Type+"OfficeTel",DataArr[34]);
	
	DHCWebD_SetObjValueA(Type+"ForeignName",DataArr[35]);
	DHCWebD_SetObjValueA(Type+"Relation",DataArr[36]);
	DHCWebD_SetObjValueA(Type+"ForeignAddress",DataArr[37]);
	DHCWebD_SetObjValueA(Type+"ForeignPhone",DataArr[38]);
	DHCWebD_SetObjValueA(Type+"ForeignIDCard",DataArr[39]);
	DHCWebD_SetObjValueA(Type+"PoliticalLevel",DataArr[40]);
	DHCWebD_SetObjValueA(Type+"SecretLevel",DataArr[41]);
	//if (obj) obj.value=DataArr[5];
	var obj=document.getElementById(Type+"CardInfo");
	var Data=tkMakeServerCall("web.DHCPATCardUnite","GetAllCardInfoByRegNo",RegNo);
	if (Data=="") return false;
	var Char_2=String.fromCharCode(2);
	var Char_1=String.fromCharCode(1);
	var OneStr=Data.split(Char_1);
	var j=OneStr.length;
	for (i=0;i<j;i++)
	{
		var OnePurpose=OneStr[i].split(Char_2);
		var ID=OnePurpose[0];
		var Desc=OnePurpose[1];
		var myListIdx=obj.length;
		obj.options[myListIdx]=new Option(Desc, ID);
	}
	
}
function BFind_click()
{
	DeleteImg_click()
	var name=DHCWebD_GetObjValue("QName");
	var birth=DHCWebD_GetObjValue("QDob");
	var InMedicareNo=DHCWebD_GetObjValue("QMedicalNo");
	var InsuranceNo=DHCWebD_GetObjValue("QYBCode");
	var CredNo=DHCWebD_GetObjValue("QID");
	var RegNo=DHCWebD_GetObjValue("RegNo");
	if(birth.length==8){
	  birth=birth.substring(0,4)+"-"+birth.substring(4,6)+"-"+birth.substring(6,8);
	}
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCPATCardUnite&Name="+name+"&BirthDay="+birth+"&InMedicareNo="+InMedicareNo+"&InsuranceNo="+InsuranceNo+"&CredNo="+CredNo+"&RegNo="+RegNo+"&EmMedicare=^Unite";
	//win=open(lnk,"FindPatBase","scrollbars=1,top=150,left=1,width=1000,height=400");
	window.location.href=lnk;
	
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCPATCardUnite');
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;	
	var rowObj=getRow(eSrc);	
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var ElementName=eSrc.id;
	var regNo="";
	var obj=document.getElementById("TRegNoz"+selectrow);
	if (obj) regNo=obj.innerText;
	if (ElementName.split("z"+selectrow)[0]=="TOldInfo"){
		if (eSrc.checked){
			DHCWebD_SetObjValueA("OldRegNo",regNo);
			SetListData(regNo,"Old");
			obj=document.getElementById("TInfoz"+selectrow);
			if (obj) obj.disabled=true;
			for (var i=1;i<rows;i++)
			{
				if (i==selectrow) continue;
				obj=document.getElementById("TInfoz"+i);
				if (obj) obj.disabled=false;
				obj=document.getElementById("TOldInfoz"+i);
				if (obj) obj.checked=false;
			}
		}else{
			obj=document.getElementById("TInfoz"+selectrow);
			if (obj) obj.disabled=false;
			 DeleteCardMesage("Old")
		}
	}else if(ElementName.split("z"+selectrow)[0]=="TInfo"){
		if (eSrc.checked){
			DHCWebD_SetObjValueA("RegNo",regNo);
			SetListData(regNo,"");
			obj=document.getElementById("TOldInfoz"+selectrow);
			if (obj) obj.disabled=true;
			//被合并勾选后，其他行被合并勾选的要取消
			for (var i=1;i<rows;i++)
			{
				if (i==selectrow) continue;
				obj=document.getElementById("TOldInfoz"+i);
				if (obj) obj.disabled=false;
				obj=document.getElementById("TInfoz"+i);
				if (obj) obj.checked=false;
			}
			//--------end---------
		}else{
			obj=document.getElementById("TOldInfoz"+selectrow);
			if (obj) obj.disabled=false;
			DeleteCardMesage("")	
		}
	}
}
function PatInfoPrint()
{
	var PatInfoXMLPrint="PatInfoPrint";
	var Char_2="\2";
	//var InMedicare=DHCWebD_GetObjValue("InMedicare");
	//var Name=DHCWebD_GetObjValue("Name");
	var RegNo=DHCWebD_GetObjValue("RegNo");
	var Data=tkMakeServerCall("web.DHCPATCardUnite","GetPatInfoByRegNo",RegNo);
	if (Data=="") return false;
	var DataArr=Data.split("^");
	var Name=DataArr[0];
	var InMedicare=DataArr[4];
	var TxtInfo="TPatName"+Char_2+"姓  名"+"^Name"+Char_2+Name+"^TRegNo"+Char_2+"病人ID"+"^RegNo"+Char_2+RegNo
	if (InMedicare!="") TxtInfo=TxtInfo+"^TMedicareNo"+Char_2+"病案号"+"^MedicareNo"+Char_2+InMedicare;
	var ListInfo="";
	DHCP_GetXMLConfig("DepositPrintEncrypt",PatInfoXMLPrint);
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);
}
function Trim(str)
{
	return str.replace(/[\t\n\r ]/g, "");
}
function ChangeCardNOLong(TypeIn)
{
	//if(SearchCardNoMode!="TC") return false;
	var CardNo=""
	var objCardNo=document.getElementById(TypeIn+"CardNo");
	if (objCardNo){CardNo=objCardNo.value;}
	var myoptval=GetSelect(TypeIn+"CardType","value");
	var myary=myoptval.split("^");
	var CardNoLength=myary[17];
	if (CardNo!='') {
		if ((CardNo.length<CardNoLength)&&(CardNoLength!=0)) {
			for (var i=(CardNoLength-CardNo.length-1); i>=0; i--) {
				CardNo="0"+CardNo;
			}
		}
	}
	if (objCardNo){objCardNo.value=CardNo}
	return CardNo;
}
function ChangePatNOLong()
{
	var m_PatientNoLength=""
	if (document.getElementById("PatientNoLen")){
		m_PatientNoLength=document.getElementById("PatientNoLen").value;
	}
	if (m_PatientNoLength=="") return;
	var OldRegNoObj=document.getElementById("OldRegNo");
	var RegNoObj=document.getElementById("RegNo");
	if (OldRegNoObj.value!="")
	{
		if ((OldRegNoObj.value.length<m_PatientNoLength)&&(m_PatientNoLength!=0)) {
			for (var i=(m_PatientNoLength-OldRegNoObj.value.length-1); i>=0; i--) {
				OldRegNoObj.value="0"+OldRegNoObj.value;
			}
		}
	}
	if (RegNoObj.value!="")
	{
		if ((RegNoObj.value.length<m_PatientNoLength)&&(m_PatientNoLength!=0)) {
			for (var i=(m_PatientNoLength-RegNoObj.value.length-1); i>=0; i--) {
				RegNoObj.value="0"+RegNoObj.value;
			}
		}
	}
}
function DeleteImg_click()
{
 DeleteCardMesage("Old")
 DeleteCardMesage("")	
}
function DeleteCardMesage(Type)
{
	
	var obj=document.getElementById(Type+"CardInfo");
	var length=obj.length
	for (i=0;i<length;i++)
	{
		obj.remove(0);
	}
	DHCWebD_SetObjValueA(Type+"CardNo","");
	DHCWebD_SetObjValueA(Type+"RegNo","");
	DHCWebD_SetObjValueA(Type+"Name","");
	DHCWebD_SetObjValueA(Type+"Sex","");
	DHCWebD_SetObjValueA(Type+"Birth","");
	DHCWebD_SetObjValueA(Type+"IDCard","");
	DHCWebD_SetObjValueA(Type+"MedicalNo","");
	
	DHCWebD_SetObjValueA(Type+"PatType","");
	//PatCode  6
	DHCWebD_SetObjValueA(Type+"Amount","");
	DHCWebD_SetObjValueA(Type+"YBCode","");
	DHCWebD_SetObjValueA(Type+"Remark","");
	
	DHCWebD_SetObjValueA(Type+"CredType","");
	DHCWebD_SetObjValueA(Type+"Marital","");
	DHCWebD_SetObjValueA(Type+"Tel","");
	DHCWebD_SetObjValueA(Type+"Mobile","");
	DHCWebD_SetObjValueA(Type+"MedicalUnionNo","");
	
	DHCWebD_SetObjValueA(Type+"Country","");
	DHCWebD_SetObjValueA(Type+"Nation","");
	DHCWebD_SetObjValueA(Type+"ProvinceHome","");
	DHCWebD_SetObjValueA(Type+"CityHome","");
	DHCWebD_SetObjValueA(Type+"ProvinceBirth","");
	
	DHCWebD_SetObjValueA(Type+"CityBirth","");
	DHCWebD_SetObjValueA(Type+"AreaBirth","");
	DHCWebD_SetObjValueA(Type+"CompanyPostCode","");
	DHCWebD_SetObjValueA(Type+"ProvinceHouse","");
	DHCWebD_SetObjValueA(Type+"Cityhouse","");
	
	DHCWebD_SetObjValueA(Type+"AreaHouse","");
	DHCWebD_SetObjValueA(Type+"PostCodeHouse","");
	DHCWebD_SetObjValueA(Type+"Province","");
	DHCWebD_SetObjValueA(Type+"City","");
	DHCWebD_SetObjValueA(Type+"Area","");
	
	DHCWebD_SetObjValueA(Type+"Address","");
	DHCWebD_SetObjValueA(Type+"Zip","");
	DHCWebD_SetObjValueA(Type+"Vocation","");
	DHCWebD_SetObjValueA(Type+"Company","");
	DHCWebD_SetObjValueA(Type+"OfficeTel","");
	
	DHCWebD_SetObjValueA(Type+"ForeignName","");
	DHCWebD_SetObjValueA(Type+"Relation","");
	DHCWebD_SetObjValueA(Type+"ForeignAddress","");
	DHCWebD_SetObjValueA(Type+"ForeignPhone","");
	DHCWebD_SetObjValueA(Type+"ForeignIDCard","");
	DHCWebD_SetObjValueA(Type+"PoliticalLevel","");
	DHCWebD_SetObjValueA(Type+"SecretLevel","");
}