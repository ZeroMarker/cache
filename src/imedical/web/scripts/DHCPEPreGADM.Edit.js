/// 名称			DHCPEPreGADM.Edit.js
/// 创建时间		2006.06.13
/// 创建人			xuwm
/// 主要功能		预约?团体预约
/// 对应表		
/// 最后修改时间	
/// 最后修改人	
/// 完成

var TFORM="";

function BodyLoadHandler() {

	var obj;
	//alert("s")
	//更新
	obj=document.getElementById("Update");
	if (obj){ 
		obj.onclick = Update_click; 
		obj.disabled=true;
	}
	
	//团体信息/项目到入
	obj=document.getElementById("PreGImport");
	if (obj){ 
		obj.onclick = ReadInfo; 
		//obj.disabled=true;
	}
	//团体信息验证
	obj=document.getElementById("ImportCheck");
	if (obj){
		obj.onclick = CheckInfo; 
		//obj.disabled=true;
	}
	/*0405
	//人员分组
	obj=document.getElementById("BITeam");
	if (obj){ 
		obj.onclick = Update_click; 
		obj.disabled=true;
	}
	
	//团体分组
	obj=document.getElementById("BGTeam");
	if (obj){ 
		obj.onclick = Update_click; 
		obj.disabled=true;
	}*/
	
	//新建团体信息
	obj=document.getElementById("BNew");
	if (obj){ obj.onclick = NewGBaseInfo_click; }
	
	//查找
	obj=document.getElementById("BFind");
	if (obj){ obj.onclick = BFind_click; }
	
	//清除
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick = Clear_click; }
	
	//单位编码	PGBI_Code
	obj=document.getElementById('Code');
	if (obj) { obj.onchange = CodeChange; obj.onkeydown=Code_keydown;}
	
	////add
	//单位编码	PAPMINo
	obj=document.getElementById('PAPMINo');
	if (obj) { obj.onchange = PAPMINoChange;obj.onkeydown=PAPMINo_keydown; }
	
	// PGADM_AddOrdItem 允许加项 
	obj=document.getElementById("AddOrdItem");
	if (obj){ obj.onclick = AddOrdItem_click; }

	// PGADM_AddOrdItemLimit 加项金额限制 
	obj=document.getElementById("AddOrdItemLimit");
	if (obj){ obj.onclick = AddOrdItemLimit_click; }

	// PGADM_AddPhcItem 允许加药 
	obj=document.getElementById("AddPhcItem");
	//if (obj){ obj.onclick = AddPhcItem_click; }

	// PGADM_AddPhcItemLimit 加药金额限制 
	obj=document.getElementById("AddPhcItemLimit");
	//if (obj){ obj.onclick = AddPhcItemLimit_click; }
	
	// 默认体检截至日期与开始日期相同
	obj=document.getElementById('BookDateBegin');
	if (obj) { obj.onblur=BookDateBegin_blur; }
	
	obj=document.getElementById("CardNo");
	if (obj) {obj.onchange=CardNo_Change;
	//obj.onkeydown=CardNo_KeyDown;
	obj.onkeydown=CardNo_keydown;
	}
	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCard_Click;}

	var obj=document.getElementById("PatFeeType_DR_Name");
	if (obj){obj.onchange=PatFeeType_Change;}

	initialReadCardButton()
	SetDefault()
	iniForm();

	DHCP_GetXMLConfig("InvPrintEncrypt","OEItemPrint");
	//ModifyDelayDate();
	//UpdatePreAudit();
}
function PatFeeType_Change()
{
	
	obj=document.getElementById("VIPLevel");
	if (obj){
		var VIPLevel=obj.value;
		if (VIPLevel=="") return false;
	}
	
	var obj=document.getElementById("PatFeeType_DR_Name");
	if(obj){var PatFeeType=obj.value; }
	
	var PatType=tkMakeServerCall("web.DHCPE.VIPLevel","GetPatFeeType",VIPLevel);
	if (PatType!=PatFeeType){
		var flag=tkMakeServerCall("web.DHCPE.PreCommon","IsFeeTypeSuperGroup");
		if(flag=="1")
		{
			alert("不是超级权限,不允许修改体检类型")
			var obj=document.getElementById("PatFeeType_DR_Name");
			if(obj){ obj.value=PatType; }
			return false;
		}
		
	
 }
}

function CardNo_keydown(e)
{
	var key=websys_getKey(e);
	if (13==key) {
		CardNo_Change();
	}
}

function SetDefault()
{
	var ADMFeeType=""
	var obj=document.getElementById("GetADMFeeType");
	if (obj) {ADMFeeType=obj.value;}
	var obj=document.getElementById("PatFeeType_DR_Name");
	if (obj) {obj.value=ADMFeeType;}
}
function iniForm() {
	var obj;
	var LocID=session['LOGON.CTLOCID']
    obj=document.getElementById('AsCharged');
    if(obj) {
	var Default=document.getElementById("DefaultAsCharged");
	if (Default)
	{   
		if ((Default.value=="2")||(Default.value=="3")){obj.checked=true;}
		else{obj.checked=false;}
		
	} }
	
    AddOrdItem_click()
    AddPhcItem_click()
	obj=document.getElementById('ID');
	if (obj && ""!=obj.value) {
		obj=document.getElementById('DataBox');
		if (obj && ""!=obj.value) {
			SetPatient_Sel(obj.value);
			obj=document.getElementById("Update");
			if (obj){ obj.innerHTML="<img SRC='../images/websys/update.gif' BORDER='0'>更新(<u>U</u>)"; }
		}
	}

}
function CardNo_Change()
{
	CardNoChangeApp("PAPMINo","CardNo","PAPMINoChange()","Clear_click()","1");
}

function ReadCard_Click()
{
	ReadCardApp("PAPMINo","PAPMINoChange()","CardNo");
	
}

// ///////////////////////////////////////////////////////////////////////////////

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

function nextfocus() {
	var eSrc=window.event.srcElement;
	var key=websys_getKey(e);
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
}
// /////////////////////////////////////////////////////////////

//新建团体信息 未使用
function NewGBaseInfo_click() {
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreGBaseInfo.Edit"
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=400,height=450,left=100,top=100';
	var nw=window.open(lnk,"_blank",nwin);

}

// 提供给子窗口的返回函数 未使用
function NewWindowReturn(value) {
	
	var Data=value.split("^");
	
	var obj=document.getElementById('Desc');
	if (obj) { obj.value=Data[0]; }
	
	var iCode=Data[1];
	obj=document.getElementById('Code');
	if (obj) { obj.value=iCode; }
	
	ID="^"+iCode;	// PGADM_RowId(DHC_PE_PreGADM)+PGBI_Code(DHC_PE_PreGBaseInfo)
	
	FindPatDetail(ID);
	
}

// ///////////////////////////////////////////////////////////////////////////////
//输入编码 查找相应的信息
function Code_keydown(e) {
	
	var key=websys_getKey(e);
	//return true;
	if (13==key)
	{
		CodeChange();
	}
	
}
function CodeChange() {
	
	//var key=websys_getKey(e);
	//return true;
	//if (13==key)
	//{

		var obj;
		var iCode="";
		obj=document.getElementById('Code');
		if (obj && ""!=obj.value) 
		{ 
			iCode = obj.value;
		}
		else { return false; }		
		
		ID="^"+iCode;	// PGADM_RowId(DHC_PE_PreGADM)+PGBI_Code(DHC_PE_PreGBaseInfo)

		FindPatDetail(ID);
		
	//}
	
}
function GetSales(value) {
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;

		obj=document.getElementById("Sales");
		if (obj) { obj.value=aiList[0]; }


		obj=document.getElementById("Sales_DR");
		if (obj) { obj.value=aiList[1]; }

	}
}
///add
//输入ADM 查找相应的信息
function PAPMINo_keydown(e) {
	var key=websys_getKey(e);
	//return true;
	if (13==key){
		PAPMINoChange();}	
}
function PAPMINoChange() {
	//var key=websys_getKey(e);
	//return true;
	//if (13==key ||9==key){
		var obj=document.getElementById('PAPMINo')
		var iPAPMINo="";
		if (obj && ""!=obj.value) 
		{ 
			iPAPMINo = obj.value;
		}
		else { return false; }
		iPAPMINo = RegNoMask(iPAPMINo);
		obj.value=iPAPMINo
		var GetCodeMethodObj=document.getElementById("GetGCodeByADM")
		if (GetCodeMethodObj && ""!=GetCodeMethodObj.value) { 
			GetCodeMethod = GetCodeMethodObj.value;
		}
		else { return false; }
		var GCode=cspRunServerMethod(GetCodeMethod,iPAPMINo)	
		if (GCode=="") {Clear_click();return false;}
		ID="^"+GCode;
		FindPatDetail(ID);//}	
}
// 默认体检截至日期与开始日期相同
function BookDateBegin_blur() {

	var eSrc=document.getElementById('BookDateBegin');

	var obj=document.getElementById('BookDateEnd');
	if (obj && ""==obj.value) { obj.value=eSrc.value; }

}

// 点击团体组名称输入框的发大镜?按名称查找团体
//function SearchGList(value) 
function SearchGListAfter(value)
{

	var Data=value.split("^");

	var obj=document.getElementById('Desc');
	if (obj) { obj.value=Data[0]; }
	
	var iCode=Data[1];
	obj=document.getElementById('Code');
	if (obj) { obj.value=iCode; }

	ID="^"+iCode;	// PGADM_RowId(DHC_PE_PreGADM)+PGBI_Code(DHC_PE_PreGBaseInfo)

	FindPatDetail(ID);	
}

// ///////////////////////////////////////////////////////////////////////////////
function FindPatDetail(ID){

	var Instring=ID;

	var Ins=document.getElementById('GetDetail');

	if (Ins) { var encmeth=Ins.value} else {var encmeth=''};

	var flag=cspRunServerMethod(encmeth,'SetPatient_Sel','',Instring);

}

// 
function SetPatient_Sel(value) {

	Clear_click();

	var obj;
	var Data=value.split(";");
	
	var IsShowAlert=Data[2];
	if ("Y"==IsShowAlert) {
		// 团体已经预约
		//alert(t["info 02"]);
		if (!(confirm(t["info 02"]))){
			return false;
		}else{
			obj=document.getElementById("Update");
			if (obj){
				obj.innerHTML="<img SRC='../images/websys/update.gif' BORDER='0'>预约(<u>U</u>)";
			}
		}
	}
	
	//登记信息
	var PreGADMData=Data[1];
	if (""!=PreGADMData) { SetPreGADM(PreGADMData); }
	
	//团体信息
	var PreGBaseGnfoData=Data[0];
	if (""!=PreGBaseGnfoData) { SetPreGBaseInfo(PreGBaseGnfoData) }

		
}

//登记信息
function SetPreGADM(value) {
	var obj;
	var fillData;
	var Data=value.split("^");
	var iLLoop=0;	
	iRowId=Data[iLLoop];
	var CurDate="",GReportSend="AC",IReportSend="IS"
	obj=document.getElementById("CurDate");
	if (obj) CurDate=obj.value;
	obj=document.getElementById("BookDateBegin");
	if (obj) obj.value=CurDate;
	obj=document.getElementById("BookDateEnd");
	if (obj) obj.value=CurDate;
	obj=document.getElementById("GReportSend");
	if (obj) obj.value=GReportSend;
	obj=document.getElementById("IReportSend");
	if (obj) obj.value=IReportSend;
	//视同收费 PIADM_AsCharged
	obj=document.getElementById("AsCharged");
	if (obj) { 
	var Default=document.getElementById("DefaultAsCharged");
	if (Default)
	{
		if ((Default.value=="2")||(Default.value=="3")){obj.checked=true;}
		else{obj.checked=false;}
		
	}}
		

	if ('0'==iRowId) { return true; }
	
	// 按钮"团体信息/项目到入"可用
	obj=document.getElementById("PreGImport");
	if (obj){ obj.disabled=false; }
	
	//团体ADM 0
	obj=document.getElementById("PGADM_RowId");
	if (obj) { obj.value=iRowId; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_PGBI_DR	预团体客户RowId 2
	obj=document.getElementById("PGBI_RowId");
	//obj=document.getElementById("PGBI_DR");
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	obj=document.getElementById("PIBI_DR_Code");
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	obj=document.getElementById("PIBI_DR_Name");
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_BookDateBegin	预约日期 4
	obj=document.getElementById("BookDateBegin");
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	// PGADM_BookDateEnd 29
	obj=document.getElementById("BookDateEnd");
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	// PGADM_BookTime	预约时间 5
	obj=document.getElementById("BookTime");
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_AuditUser_DR	预约接待人员 16
	obj=document.getElementById("PEDeskClerk_DR");
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	obj=document.getElementById("PEDeskClerk_DR_Name");
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	// PGADM_Status	状态 8
	obj=document.getElementById("Status");
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
		
	// PGADM_AsCharged	视同收费 3
	obj=document.getElementById("AsCharged");
	if (obj) {
		if (fillData=="Y"){obj.checked=true;
		}
		else{obj.checked=false;
		}
		}
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	var strLine=""
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	SetAddItem(strLine);
	
	// PGADM_GReportSend 团体报告发送 26
	obj=document.getElementById("GReportSend");
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];

	// PGADM_IReportSend 个人报告发送 27
	obj=document.getElementById("IReportSend");
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];

	// PGADM_DisChargedMode 结算方式 28
	obj=document.getElementById("DisChargedMode");
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	// PGADM_DelayDate
	obj=document.getElementById("DelayDate");
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	// PGADM_Remark	备注 6
	obj=document.getElementById("Remark");
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	var obj=document.getElementById('PAPMINo');
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+3;
	fillData=Data[iLLoop];
	// PGADM_PEDeskClerk_DR 预约接待人员 15
	obj=document.getElementById("Sales_DR");
	if (obj) {obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// 15.1
	obj=document.getElementById("Sales");
	if (obj) {obj.value=fillData; }
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_AuditUser_DR	业务员 31
	obj=document.getElementById("Type");
	if (obj) {obj.value=fillData; }
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_AuditUser_DR	业务员 32
	obj=document.getElementById("GetReportDate");
	if (obj) {obj.value=fillData; }
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_AuditUser_DR	业务员 33
	obj=document.getElementById("GetReportTime");
	if (obj) {obj.value=fillData; }
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_AuditUser_DR	业务员 33
	obj=document.getElementById("PayType");
	if (obj) {obj.value=fillData; }
	
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_AuditUser_DR	业务员 33
	obj=document.getElementById("Percent");
	if (obj) {obj.value=fillData; }
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// 	就诊类别 用于取计费价格
	obj=document.getElementById("PatFeeType_DR_Name");
	if (obj) {obj.value=fillData; }
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// 	合同ID
	obj=document.getElementById("ContractID");
	if (obj) {obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// 	合同名称
	obj=document.getElementById("Contract");
	if (obj) {obj.value=fillData; }
	return true

}
function SetAddItem(value) {
	var Data=value.split("^");
	var iLLoop=0;	
	
	var iAddOrdItem=false;
	//	允许加项	PGADM_AddOrdItem	19
	obj=document.getElementById("AddOrdItem");
	if (obj) {
		if ("Y"==Data[iLLoop]) {
			obj.checked=true;
			iAddOrdItem=true;
			
		}
		else { 
			obj.checked=false;
			iAddOrdItem=false;
		}
				
	}
	iLLoop=iLLoop+1;	
	
	var iAddOrdItemLimit=false;
	//	加项金额限制	PGADM_AddOrdItemLimit	20
	obj=document.getElementById("AddOrdItemLimit");
	if (obj) { 
		if (iAddOrdItem) {
			obj.style.display="inline"; // 可见
			obj.disabled=false;
			if ("Y"==Data[iLLoop]) {
				obj.checked=true;
				iAddOrdItemLimit=true;
			}
			else {
				obj.checked=false;
				iAddOrdItemLimit=false;
			}
			
			obj=document.getElementById("cAddOrdItemLimit");	
			if (obj) {obj.style.display="inline"; }	
		}
		else {
			obj.style.display="none";
			obj.disabled=true;
			
			obj.checked=false;
			iAddOrdItemLimit=false;
			
			obj=document.getElementById("cAddOrdItemLimit");	
			if (obj) {obj.style.display="none"; }				
		}
	}
	iLLoop=iLLoop+1;	
	
	//	允许加项金额	PGADM_AddOrdItemAmount	21
	obj=document.getElementById("AddOrdItemAmount");
	if (obj) {
		if (iAddOrdItemLimit) {
			obj.style.display="inline"; // 可见
			obj.disabled=false;
			
			obj.value=Data[iLLoop];
			
			obj=document.getElementById("cAddOrdItemAmount");	
			if (obj) {obj.style.display="inline"; }
		}
		else{
			obj.style.display="none"; // 可见
			obj.disabled=true;
			
			obj.value="";
			
			obj=document.getElementById("cAddOrdItemAmount");	
			if (obj) {obj.style.display="none"; }
		}
		
	}
	iLLoop=iLLoop+1;	
	
	//	允许加药	PGADM_AddPhcItem	22
	var iAddPhcItem=false;
	obj=document.getElementById("AddPhcItem");
	if (obj) {
		if ("Y"==Data[iLLoop]) {
			obj.checked=true;
			iAddPhcItem=true;
		}
		else {
			obj.checked=false;
			iAddPhcItem=false
		}

	}
	iLLoop=iLLoop+1;	
	
	//	加药金额限制	PGADM_AddPhcItemLimit	23
	var iAddPhcItemLimit=false;
	obj=document.getElementById("AddPhcItemLimit");
	if (obj) {
		if (iAddPhcItem) {
			//obj.style.display="inline"; // 可见
			obj.disabled=false;
			
			if ("Y"==Data[iLLoop]) {
				obj.checked=true;
				iAddPhcItemLimit=true;
				
			}
			else {
				obj.checked=false;
				iAddPhcItemLimit=false;
			}
			
			obj=document.getElementById("cAddPhcItemLimit");	
			//if (obj) {obj.style.display="inline"; }
		}
		else{
			obj.style.display="none"; 
			obj.disabled=true;
			
			obj.checked=false;
			iAddPhcItemLimit=false;
			
			obj=document.getElementById("cAddPhcItemLimit");	
			if (obj) {obj.style.display="none"; }
		}	

	}
	iLLoop=iLLoop+1;
	
	//	允许加药金额	PGADM_AddPhcItemAmount	24
	obj=document.getElementById("AddPhcItemAmount");		
	if (obj) {
		if (iAddPhcItemLimit) {
			//obj.style.display="inline";
			obj.disabled=false;
			
			obj.value=Data[iLLoop];
			
			obj=document.getElementById("cAddPhcItemAmount");
			//if (obj) { obj.style.display="inline"; }		
		}
		else{
			obj.style.display="none";
			obj.disabled=true;
			obj.value="";
		}
	}
	
}


//团体信息
function SetPreGBaseInfo(value) {

	var obj;
	var Data=value.split("^");
	var iLLoop=0;

	var iRowId=Data[iLLoop];	

	iLLoop=iLLoop+1;
	
	if ("0"==iRowId) {	//未找到记录
	

		//单位编码	PGBI_Code	1
		obj=document.getElementById('Code');
		if (obj) { obj.value=Data[iLLoop]; }
	
		iLLoop=iLLoop+1;
		//描    述	PGBI_Desc	2
		obj=document.getElementById('Desc');
		if (obj) { obj.value=Data[iLLoop]; }
		return false;
	}

	//更新
	obj=document.getElementById("Update");
	if (obj){ obj.disabled=false; }
	
	
	//更新
	obj=document.getElementById("Update");
	if (obj){ obj.disabled=false; }
	
	obj=document.getElementById('PGBI_RowId');
	if (obj) { obj.value=iRowId; }		

	//单位编码	PGBI_Code	1
	obj=document.getElementById('Code');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//描    述	PGBI_Desc	2
	obj=document.getElementById('Desc');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//地    址	PGBI_Address	3
	obj=document.getElementById('Address');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//邮政编码	PGBI_Postalcode	4
	obj=document.getElementById('Postalcode');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//联系人	PGBI_Linkman	5
	obj=document.getElementById('Linkman');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//业务银行	PGBI_Bank	6
	obj=document.getElementById('Bank');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//帐    号	PGBI_Account	7
	obj=document.getElementById('Account');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//联系电话1	PGBI_Tel1	8
	obj=document.getElementById('Tel1');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//联系电话2	PGBI_Tel2	9
	obj=document.getElementById('Tel2');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//电子邮件	PGBI_Email	10
	obj=document.getElementById('Email');
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+3;
	//电子邮件	PGBI_PAPMINo	10
	obj=document.getElementById('PAPMINo');
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+2;
	//	CardNo	10
	obj=document.getElementById('CardNo');
	if (obj) { obj.value=Data[iLLoop]; }
	
	return true;
}


// ///////////////////////////////////////////////////////////////////////////////
// 设置新的父窗体预约记录
function SetParentID(Data) {
	parent.SetGADM(Data);
}

// 导入团体的信息
function GImport_click(){
		var Imp;
		var iUpdateUserDR="",iRowId="",iDesc="";
		var obj;

		obj=document.getElementById("PGADM_RowId");
		if (obj) { iRowId=obj.value; }
		if (""==iRowId) { return ; }
		obj=document.getElementById('Desc');
		if (obj) { iDesc=obj.value; }
		
		iUpdateUserDR=session['LOGON.USERID']; // 操作人
		
		Imp= new ActiveXObject("DHCPEIMPGInfor.PEGInfo");
		
		//alert(Imp)
		Imp.Import(iRowId,iDesc,iUpdateUserDR,"");
		
		//Imp=null;
		
}

// 从子页面 项目预约 设置应收近金额
function SetAmount(Amount){
	var iAccountAmount="";
	
	var obj=document.getElementById("AccountAmount");
	if (obj) { 
		iAccountAmount=obj.value;
		obj.value=Amount;
	}
	
}

function Update_click() {
	
	var eSrc=window.event.srcElement;
	if (eSrc.disabled) { return false; }
	Update();
	
}
function Update() {
	var iRowId="";
	var iPGBIDR="", iAsCharged="", iBookDateBegin="", iBookDateEnd="", iBookTime="", iRemark="", 
		iContractNo="", iStatus="",
		iAccountAmount="", iDiscountedAmount="", iFactAmount="",
		iAuditUserDR="", iAuditDate="", 
		iUpdateUserDR="", iUpdateDate="", 
		iPEDeskClerkDR="", iSaleAmount="",
		iChargedStatus="", iChargedStatusDesc="", 
		iCheckedStatus="", iCheckedStatusDesc="", 
		iAddOrdItem="", iAddOrdItemLimit="", iAddOrdItemAmount="", 
		iAddPhcItem="", iAddPhcItemLimit="", iAddPhcItemAmount="", 
		iGReportSend="", iGReportSendDesc="", 
		iIReportSend="", iIReportSendDesc="",
		iDisChargedMode="", iDisChargedModeDesc="",iDelayDate="",Sales="",
		Type="",GetReportDate="",GetReportTime="",PayType="",Percent=""
		DietFlag="1",GiftFlag="0",PatFeeType="",Contract="";
	    var obj;

	// PGADM_RowId	团体ADM 1
	obj=document.getElementById("PGADM_RowId");
	if (obj) { iRowId=obj.value; }
	
	// PGADM_PGBI_DR	预团体客户RowId 2
	obj=document.getElementById("PGBI_RowId");
	//obj=document.getElementById("PGBI_DR");
	if (obj) { iPGBIDR=obj.value; }
	
	// PGADM_BookDateBegin	预约日期 4
	obj=document.getElementById("BookDateBegin");
	if (obj) { iBookDateBegin=obj.value; }
	
	// PGADM_BookDateEnd 29
	obj=document.getElementById("BookDateEnd");
	if (obj) { iBookDateEnd=obj.value; }
	
	// PGADM_BookTime	预约时间 5
	obj=document.getElementById("BookTime");
	if (obj) {
		if ('clsInvalid'==obj.className) { 
			//alert("无效时间格式");
			alert(t["Err 04"]);
			return false;
		}
		iBookTime=obj.value;
	}
	

	// PGADM_AuditUser_DR	预约接待人员 16
	obj=document.getElementById("PEDeskClerk_DR");
	if (obj) { iPEDeskClerkDR=obj.value; }	

	// PGADM_Status	状态 8
	obj=document.getElementById("Status");
	if (obj) { 
		iStatus=obj.value;
		if (("PREREG"!=iStatus)&&(""!=iRowId)) {
			//alert("不是预登记登记状态?不能修改")
			//alert(t['Err 05']);
			//return false;			
		}
	}
		
	// PGADM_AsCharged	视同收费 3
	obj=document.getElementById("AsCharged");
	if (obj && obj.checked) { iAsCharged="Y"; }
	else { iAsCharged="N"; }
	
	// PGADM_AddOrdItem 允许加项 20
	obj=document.getElementById("AddOrdItem");
	if (obj && obj.checked) { iAddOrdItem='Y'; }
	else { iAddOrdItem='N';}
	
	// PGADM_AddOrdItemLimit 加项金额限制 21
	obj=document.getElementById("AddOrdItemLimit");
	if (obj && obj.checked) { iAddOrdItemLimit='Y'; }
	else { iAddOrdItemLimit='N';}

	// PGADM_AddOrdItemAmount 允许加项金额 22
	obj=document.getElementById("AddOrdItemAmount");
	if (obj) { iAddOrdItemAmount=obj.value; }

	// PGADM_AddPhcItem 允许加药 23
	obj=document.getElementById("AddPhcItem");
	if (obj && obj.checked) { iAddPhcItem='Y'; }
	else { iAddPhcItem='N';}

	// PGADM_AddPhcItemLimit 加药金额限制 24
	obj=document.getElementById("AddPhcItemLimit");
	if (obj && obj.checked) { iAddPhcItemLimit='Y'; }
	else { iAddPhcItemLimit='N';}

	//  PGADM_AddPhcItemAmount允许加药金额 25
	obj=document.getElementById("AddPhcItemAmount");
	if (obj) { iAddPhcItemAmount=obj.value; }
	
	// PGADM_GReportSend 团体报告发送 26
	obj=document.getElementById("GReportSend");
	if (obj) { iGReportSend=obj.value; }

	// PGADM_IReportSend 个人报告发送 27
	obj=document.getElementById("IReportSend");
	if (obj) { iIReportSend=obj.value; }

	// PGADM_DisChargedMode 结算方式 28
	obj=document.getElementById("DisChargedMode");
	if (obj) { iDisChargedMode=obj.value; }

	// PGADM_DelayDate
	obj=document.getElementById("DelayDate");
	if (obj) { iDelayDate=obj.value; }
	
	// PGADM_Remark	备注 29
	obj=document.getElementById("Remark");
	if (obj) { iRemark=obj.value; }
	//输入数据验证
	if (""==iPGBIDR) {
		//alert("Please entry all information.");
		alert(t['01']);
		return false;
	}
	//输入数据验证
	if (""==iBookDateBegin) {
		//alert("Please entry all information.");
		alert(t['08']);
		websys_setfocus('BookDateBegin');
		return false;
	}
	//输入数据验证
	if (""==iBookDateEnd) {
		//alert("Please entry all information.");
		alert(t['08']);
		websys_setfocus('BookDateEnd');
		return false;
	}
	//输入数据验证
	if (""==iGReportSend) {
		//alert("Please entry all information.");
		alert(t['Err 10']);
		websys_setfocus('GReportSend');
		return false;
	}
	//输入数据验证
	if (""==iIReportSend) {
		//alert("Please entry all information.");
		alert(t['Err 10']);
		websys_setfocus('IReportSend');
		return false;
	}
	//输入数据验证
	if (("Y"==iAddOrdItemLimit)&&(""==iAddOrdItemAmount)) {
		//alert("Please entry all information.");
		alert(t['Err 09']);
		websys_setfocus('AddOrdItemAmount');
		return false;
	}
	if (("Y"==iAddPhcItemLimit)&&(""==iAddPhcItemAmount)) {
		//alert("Please entry all information.");
		alert(t['Err 09']);
		websys_setfocus('AddPhcItemAmount');
		return false;
	}
	// PGADM_AuditUser_DR	业务员 30
	obj=document.getElementById("Sales_DR");
	if (obj) { Sales=obj.value; }
	
	
	// 类型	业务员 31
	obj=document.getElementById("Type");
	if (obj) { Type=obj.value; }
	
	// 取报告日期	业务员 32
	obj=document.getElementById("GetReportDate");
	if (obj) { GetReportDate=obj.value; }
	
	// 取报告时间	业务员 33
	obj=document.getElementById("GetReportTime");
	if (obj) { GetReportTime=obj.value; }
	
	// 付款类型	业务员 33
	obj=document.getElementById("PayType");
	if (obj) { PayType=obj.value; }	
	
	// 百分比	业务员 33
	obj=document.getElementById("Percent");
	if (obj) { Percent=obj.value; }	
	// 就餐标志	业务员 33
	obj=document.getElementById("DietFlag");
	if (obj&&!obj.checked) { DietFlag="0"; }	
	//赠品标志	业务员 33
	obj=document.getElementById("GiftFlag");
	if (obj&&obj.checked) { GiftFlag="1" ;}
	//var GiftFlag="@@@@"
	//就诊类型用于取价格
	obj=document.getElementById("PatFeeType_DR_Name");		
	if (obj) { PatFeeType=obj.value; }
	
	//所属合同
	obj=document.getElementById("ContractID");		
	if (obj) { Contract=obj.value; }
	
	/*
	//输入数据验证
	if (""==iBookTime) {
		//alert("Please entry all information.");
		alert(t['09']);
		websys_setfocus('BookTime');
		return false;
	}
	*/
	var Instring= trim(iRowId)					// 1
				+"^"+trim(iPGBIDR)				// 2	PGADM_PGBI_DR	预团体客户
				+"^"+trim(iBookDateBegin)		// 3	PGADM_BookDateBegin	预约日期
				+"^"+trim(iBookDateEnd)			// 4	PGADM_BookDateEnd
				+"^"+trim(iBookTime)			// 5	PGADM_BookTime	预约时间
				+"^"+trim(iPEDeskClerkDR)		// 6	PGADM_PEDeskClerk_DR	预约接待人员
				+"^"+trim(iStatus)				// 7	PGADM_Status	状态
				+"^"+trim(iAsCharged)			// 8	PGADM_AsCharged	视同收费
				+"^"+trim(iAddOrdItem)			// 9	PGADM_AddOrdItem 允许加项
				+"^"+trim(iAddOrdItemLimit)		// 10	PGADM_AddOrdItemLimit 加项金额限制
				+"^"+trim(iAddOrdItemAmount)	// 11	PGADM_AddOrdItemAmount 允许加项金额
				+"^"+trim(iAddPhcItem)			// 12	PGADM_AddPhcItem 允许加药
				+"^"+trim(iAddPhcItemLimit)		// 13	PGADM_AddPhcItemLimit 加药金额限制
				+"^"+trim(iAddPhcItemAmount)	// 14	PGADM_AddPhcItemAmount允许加药金额
				+"^"+trim(iGReportSend)			// 15	PGADM_GReportSend 团体报告发送
				+"^"+trim(iIReportSend)			// 16	PGADM_IReportSend 个人报告发送
				+"^"+trim(iDisChargedMode)		// 17	PGADM_DisChargedMode 结算方式
				+"^"+trim(iDelayDate)           // 18	PGADM_DelayDate 延期日期
				+"^"+trim(iRemark)				// 19	PGADM_Remark	备注	
				+"^"+trim(Sales)
				+"^"+trim(Type)
				+"^"+trim(GetReportDate)
				+"^"+trim(GetReportTime)
				+"^"+trim(PayType)
				+"^"+trim(Percent)
				+"^"+trim(DietFlag)
				+"^"+trim(GiftFlag)
				+"^"+trim(PatFeeType)
				+"^"+trim(Contract)
				;
	//alert("Instring :"+Instring);
	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring)
	if (flag=="Err Date")
	{
		alert(t["Err Date"]);
		return false;
	}
	
	if (flag=="Err HomeDate")
	{
		alert(t["Err HomeDate"]);
		return false;
	}

	if (""==iRowId) { //插入操作 返回 RowId
		var Rets=flag.split("^");
		flag=Rets[0];
		
		// PGADM_RowId	团体ADM 1
		obj=document.getElementById("PGADM_RowId");
		if (obj) { obj.value=Rets[1]; }
	}

	if ('0'==flag) {
		//alert("Update Success!");
		if (""==iRowId) { alert(t['info 01']); }
		else { alert(t['info 04']); }
	
		// 团体信息/项目到入
		obj=document.getElementById("PreGImport");
		if (obj){ obj.disabled=false; }	
			
		if (""==iRowId) { //刷新页面
		
			obj=document.getElementById("PGADM_RowId");
			if (obj) { obj.value=Rets[1]; }
			
			//描    述	PGBI_Desc
			obj=document.getElementById('Desc');
			if (obj) { iDesc=obj.value; }
			
			var lnk="dhcpepregadm.edit.csp?"
			+"ParRef="+Rets[1]
			+"&ParRefName="+""
			+"&OperType="+"E"
			;
         
			SetParentID(
				Rets[1]
				+"^"+iDesc+"^"
				+iBookDateBegin
				+"^"+iBookTime
				+"^"+"E"
				
			);
			
			return false;
		}

		return false;
	}
	else if ('Err 02'==flag) {
		alert(t['Err 02']);
		return false;		
	}
	else if ('Err 05'==flag) {
		//alert("不是预登记登记状态?不能修改")
		alert(t['Err 05']);
		return false;		
	}		
	else {
		//alert("Insert error.ErrNo="+flag);
		alert(t['02']+flag);
		
		return false;
	}

	//刷新页面
	//location.reload(); 
	return true;
}


// ///////////////////////////////////////////////////////////////////////////////
//清除输入的信息
function Clear_click() {

	//更新
	obj=document.getElementById("Update");
	if (obj){ obj.disabled=true; }
	
	// 团体信息/项目到入
	obj=document.getElementById("PreGImport");
	if (obj){ obj.disabled=true; }
	
	//人员分组
	obj=document.getElementById("BITeam");
	if (obj){ obj.disabled=true; }
	
	//团体分组
	obj=document.getElementById("BGTeam");
	if (obj){ obj.disabled=true; }
	
	PreGADM_Clear_click();
	PreGBaseInfo_Clear_click();

}
//登记信息
function PreGADM_Clear_click() {

	var obj;	
	    
	// PGADM_RowId	 团体ADM 0
	obj=document.getElementById("PGADM_RowId");
	if (obj) {obj.value=""; }
	
	// PGADM_PGBI_DR	 预团体客户RowId 1
	obj=document.getElementById("PGBI_DR");
	if (obj) {obj.value=""; }
	// PGADM_PGBI_DR_Name	 预团体客户RowId 1.1
	//obj=document.getElementById("PGBI_DR_Name");
	//if (obj) {obj.value=""; }
	
	// PGADM_AsCharged	 视同收费 2
	//obj=document.getElementById("AsCharged");
	//if (obj) { obj.checked=false; }
	obj=document.getElementById("AsCharged");
	if (obj) { 
	var Default=document.getElementById("DefaultAsCharged");
	if (Default)
	{
		if ((Default.value=="1")||(Default.value=="3")){obj.checked=true;}
		else{obj.checked=false;}
		
	}}
	
	
	// PGADM_BookDateBegin	 预约日期 3
	obj=document.getElementById("BookDate");
	if (obj) {obj.value=""; }
	
	// PGADM_BookTime	 预约时间 4
	obj=document.getElementById("BookTime");
	if (obj) {obj.value=""; }
	
	// PGADM_Remark	 备注 5
	obj=document.getElementById("Remark");
	if (obj) {obj.value=""; }
	
	// PGADM_ContractNo	 合同编号 6
	obj=document.getElementById("ContractNo");
	if (obj) {obj.value=""; }
	
	// PGADM_Status	 状态 7
	obj=document.getElementById("Status");
	if (obj) {obj.value=""; }
	
	// PGADM_AccountAmount	 应收金额 8
	obj=document.getElementById("AccountAmount");
	if (obj) {obj.value=""; }
	
	//PGADM_DiscountedAmount	 打折后金额 9
	obj=document.getElementById("DiscountedAmount");
	if (obj) {obj.value=""; }
	
	// PGADM_FactAmount	 最终金额 10
	obj=document.getElementById("FactAmount");
	if (obj) {obj.value=""; }
	
	// PGADM_AuditUser_DR	 审核人 11
	obj=document.getElementById("AuditUser_DR");
	if (obj) {obj.value=""; }
	//obj=document.getElementById("AuditUser_DR_Name");
	//if (obj) {obj.value=""; }
		
	// PGADM_AuditDate	 审核日期 12
	obj=document.getElementById("AuditDate");
	if (obj) {obj.value=""; }
	
	// PGADM_UpdateUser_DR	 更改人 13
	obj=document.getElementById("UpdateUser_DR");
	if (obj) {obj.value=""; }
	//PGADM_UpdateUser_DR_Name	 	
	//obj=document.getElementById("UpdateUser_DR_Name");
	//if (obj) {obj.value=""; }
		
	// PGADM_UpdateDate	 更改日期 14
	obj=document.getElementById("UpdateDate");
	if (obj) {obj.value=""; }	
	
	
	// PGADM_PEDeskClerk_DR 预约接待人员 15
	obj=document.getElementById("PEDeskClerk_DR");
	if (obj) {obj.value=""; }
	
	// 15.1
	obj=document.getElementById("PEDeskClerk_DR_Name");
	if (obj) {obj.value=""; }
		
	// PGADM_SaleAmount	销售金额 16
	obj=document.getElementById("SaleAmount");
	if (obj) { obj.value=""; }
	
	
	//	收费状态	PGADM_ChargedStatus	17
	obj=document.getElementById("ChargedStatus");
	if (obj) { obj.value=""; }	
	
	//	收费状态	PGADM_ChargedStatus_Name	17.1
	obj=document.getElementById("ChargedStatus_Name");
	if (obj) { obj.value=""; }	
	
	//	审核状态	PGADM_CheckedStatus	18
	obj=document.getElementById("CheckedStatus");
	if (obj) { obj.value=""; }
	
	//	审核状态	PGADM_CheckedStatus_Name	18.1
	//obj=document.getElementById("CheckedStatus_Name");
	//if (obj) { obj.value=""; }
	
	//	允许加项	PGADM_AddOrdItem	19
	obj=document.getElementById("AddOrdItem");
	if (obj) { obj.checked=false; }
	
	//	加项金额限制	PGADM_AddOrdItemLimit	20
	obj=document.getElementById("AddOrdItemLimit");
	if (obj) {
		obj.style.display="none";
		obj.checked=false;
	}
	
	//	允许加项金额	PGADM_AddOrdItemAmount	21
	obj=document.getElementById("AddOrdItemAmount");
	if (obj) {
		obj.style.display="none";
		obj.value="";	
	}
	
	//	允许加药	PGADM_AddPhcItem	22
	obj=document.getElementById("AddPhcItem");
	if (obj) { obj.checked=false; }	
	
	//	加药金额限制	PGADM_AddPhcItemLimit	23
	obj=document.getElementById("AddPhcItemLimit");
	if (obj) { 
		obj.checked=false;
		obj.style.display="none";
	}
	
	//	允许加药金额	PGADM_AddPhcItemAmount	24
	obj=document.getElementById("AddPhcItemAmount");
	if (obj) {
		obj.style.display="none";
		obj.value="";	
	}
	
	//	团体报告发送	PGADM_GReportSend	25
	obj=document.getElementById("GReportSend");
	if (obj) { obj.value=""; }	
	
	//	团体报告发送	PGADM_GReportSend_Name	25.1
	//obj=document.getElementById("GReportSend_Name");
	//if (obj) { obj.value=""; }	
	
	//	个人报告发送	PGADM_IReportSend	26
	obj=document.getElementById("IReportSend");
	if (obj) { obj.value=""; }

	//	个人报告发送	PGADM_IReportSend_Name	26.1
	//obj=document.getElementById("IReportSend_Name");
	//if (obj) { obj.value=""; }

	//	结算方式	PGADM_DisChargedMode	27
	obj=document.getElementById("DisChargedMode");
	if (obj) { obj.value="GD"; }
	
	//	结算方式	PGADM_DisChargedMode_Name	27.1
	//obj=document.getElementById("DisChargedMode_Name");
	//if (obj) { obj.value=""; }

	// PGADM_BookDateEnd	 28
	obj=document.getElementById("BookDateEnd");
	if (obj) {obj.value=""; }
	
	// PGADM_PEDeskClerk_DR 预约接待人员 15
	obj=document.getElementById("Sales_DR");
	if (obj) {obj.value=""; }
	
	// 15.1
	obj=document.getElementById("Sales");
	if (obj) {obj.value=""; }
	
	// 15.1
	obj=document.getElementById("Type");
	if (obj) {obj.value=""; }
	
	// 15.1
	obj=document.getElementById("GetReportDate");
	if (obj) {obj.value=""; }
	
	// 15.1
	obj=document.getElementById("GetReportTime");
	if (obj) {obj.value=""; }
	
	// 15.1
	obj=document.getElementById("PayType");
	if (obj) {obj.value=""; }
	
	// 15.1
	obj=document.getElementById("Percent");
	if (obj) {obj.value=""; }
	
}
//团体信息
function PreGBaseInfo_Clear_click() {

	var obj;	
	    
	//			PGBI_RowId
	obj=document.getElementById("PGBI_RowId");
	if (obj) {obj.value=""; }

	//单位编码	PGBI_Code
	obj=document.getElementById('Code');
	if (obj) { obj.value=''; }

	//描    述	PGBI_Desc
	obj=document.getElementById('Desc');
	if (obj) { obj.value=''; }

	//地    址	PGBI_Address
	obj=document.getElementById('Address');
	if (obj) { obj.value=''; }

	//邮政编码	PGBI_Postalcode
	obj=document.getElementById('Postalcode');
	if (obj) { obj.value=''; }

	//联系人	PGBI_Linkman
	obj=document.getElementById('Linkman');
	if (obj) { obj.value=''; }

	//业务银行	PGBI_Bank
	obj=document.getElementById('Bank');
	if (obj) { obj.value=''; }

	//帐    号	PGBI_Account
	obj=document.getElementById('Account');
	if (obj) { obj.value=''; }

	//联系电话1	PGBI_Tel1
	obj=document.getElementById('Tel1');
	if (obj) { obj.value=''; }

	//联系电话2	PGBI_Tel2
	obj=document.getElementById('Tel2');
	if (obj) { obj.value=''; }

	//电子邮件	PGBI_Email
	obj=document.getElementById('Email');
	if (obj) { obj.value=''; }

}
// /////////////////////////////////////////////////////////////
// 选择接待人
function SearchUser(value) {

	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;

		obj=document.getElementById("PEDeskClerk_DR_Name");
		if (obj) { obj.value=aiList[0]; }


		obj=document.getElementById("PEDeskClerk_DR");
		if (obj) { obj.value=aiList[1]; }

	}
}
//  允许加项(PGADM_AddOrdItem)
function AddOrdItem_click() {
	//var src=window.event.srcElement;
	var src=document.getElementById("AddOrdItem");
	var obj;

	if (src.checked) {
		// PGADM_AddOrdItemLimit 加项金额限制 
		obj=document.getElementById("AddOrdItemLimit");
		if (obj){
			obj.style.display = "inline" ;
			obj.disabled=false;
			obj.checked=true;
		}
		obj=document.getElementById("cAddOrdItemLimit");
		if (obj){ obj.style.display = "inline" ; }
		
		obj=document.getElementById("AddOrdItemAmount");
		if (obj){
			obj.style.display="inline";
			obj.disabled=false;
			obj.value="";
		}
		obj=document.getElementById("cAddOrdItemAmount");
		if (obj){ obj.style.display = "inline" ; }
		
		websys_setfocus("AddOrdItemAmount");
	}
	else{
		// PGADM_AddOrdItemLimit 加项金额限制 
		obj=document.getElementById("AddOrdItemLimit");
		if (obj){
			obj.style.display = "none" ;
			obj.disabled=true;
			obj.checked=false;
		}
		obj=document.getElementById("cAddOrdItemLimit");
		if (obj){ obj.style.display = "none" ; }
		
		obj=document.getElementById("AddOrdItemAmount");
		if (obj){
			obj.style.display = "none" ;
			obj.disable=true;
			obj.value="";
		}
		obj=document.getElementById("cAddOrdItemAmount");
		if (obj){ obj.style.display = "none" ; }
	}

}
// PGADM_AddOrdItemLimit 加项金额限制 
function AddOrdItemLimit_click() {
	//var src=window.event.srcElement;
	var src=document.getElementById("AddOrdItemLimit");
	var obj;
	if (src.checked) {
		obj=document.getElementById("AddOrdItemAmount");
		if (obj){
			obj.style.display = "inline" ;
			obj.disable=false;
			obj.checked=true;
		}
		obj=document.getElementById("cAddOrdItemAmount");
		if (obj){ obj.style.display = "inline" ; }
		
		websys_setfocus("AddOrdItemAmount");
	}
	else{
		obj=document.getElementById("AddOrdItemAmount");
		if (obj){
			obj.style.display="none";
			obj.value="";
		}
		obj=document.getElementById("cAddOrdItemAmount");
		if (obj){ obj.style.display = "none" ; }
			
	}
	
}
// PGADM_AddPhcItem 允许加药 
function AddPhcItem_click() {
	//var src=window.event.srcElement;
	var src=document.getElementById("AddPhcItem");
	var obj;
	
	if (src.checked) {
		// PGADM_AddPhcItemLimit 加药金额限制 
		obj=document.getElementById("AddPhcItemLimit");
		if (obj){
			//obj.style.display = "inline" ;
			obj.disabled=false;
			obj.checked=true;
		}
		obj=document.getElementById("cAddPhcItemLimit");
		//if (obj){ obj.style.display = "inline" ; }
		
		// PGADM_AddPhcItemAmount	允许加药金额
		obj=document.getElementById("AddPhcItemAmount");
		if (obj){
			//obj.style.display="inline";
			obj.disabled=false;
			obj.value="";
		}
		obj=document.getElementById("cAddPhcItemAmount");
		//if (obj){ obj.style.display = "inline" ; }
		
		websys_setfocus("AddPhcItemAmount");
		
	}
	else{
		// PGADM_AddPhcItemLimit 加药金额限制 
		obj=document.getElementById("AddPhcItemLimit");
		if (obj){
			obj.style.display = "none" ;
			obj.disabled=true;
			obj.checked=false;
		}
		obj=document.getElementById("cAddPhcItemLimit");
		if (obj){ obj.style.display = "none" ; }
		
		// PGADM_AddPhcItemAmount	允许加药金额
		obj=document.getElementById("AddPhcItemAmount");
		if (obj){
			obj.style.display="none";
			obj.disabled=true;
			obj.value="";
		}
		obj=document.getElementById("cAddPhcItemAmount");
		if (obj){ obj.style.display = "none" ; }	
	}
	
}
//修改预约延期日期 Type "Item","Pre";ID  预约ID
function ModifyDelayDate()
{
	var Type="Item";
	var obj;
	obj=document.getElementById("PGADM_RowId");
	if (obj){ var ID=obj.value;}
	else{return false;}
	if (ID=="") return false;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreModifyDelayDate"
			+"&ID="+ID+"&Type="+Type;
	
	var wwidth=250;
	var wheight=150;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
}
//弹出审核单据信息  Type "G","I";CRMADM  预约ADM;GIADM  到达后ADM;RowID  审核纪录ID
function UpdatePreAudit()
{
	var Type="G";
	var obj;
	obj=document.getElementById("PGADM_RowId");
	if (obj){ var ID=obj.value;}
	else{return false;}
	if (ID=="") return false;
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreAudit.Edit"
	//		+"&CRMADM="+ID+"&ADMType="+Type+"&GIADM=";
	var lnk="dhcpepreaudit.csp?CRMADM="+ID+"&ADMType="+Type+"&GIADM="+"&RowID=";
	var wwidth=800;
	var wheight=500;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
}

// PGADM_AddPhcItemLimit 加药金额限制 
function AddPhcItemLimit_click() {
	//alert("AddPhcItemLimit_click"+src.id)
	//var src=window.event.srcElement;
	var src=document.getElementById("AddPhcItemLimit");
	var obj;
	
	if (src.checked) {
		// PGADM_AddPhcItemAmount	允许加药金额
		obj=document.getElementById("AddPhcItemAmount");
		if (obj){
			obj.disabled = false;
			obj.value="";
			obj.style.display = "inline" ;
		}
		obj=document.getElementById("cAddPhcItemAmount");
		if (obj){ obj.style.display = "inline" ; }
		websys_setfocus("AddPhcItemAmount");
	}
	else{
		// PGADM_AddPhcItemAmount	允许加药金额
		obj=document.getElementById("AddPhcItemAmount");
		if (obj){
			obj.disabled = true;
			obj.value="";
			obj.style.display = "none" ;
		}
		obj=document.getElementById("cAddPhcItemAmount");
		if (obj){ obj.style.display = "none" ; }		
	}

}
function UpdateAsCharged()
{
	var Type="G";
	
	var obj;
	obj=document.getElementById("Status");
	//if ((obj)&&(obj.value!="PREREG")) {alert(t["Err 02"]); return;}
	obj=document.getElementById("PGADM_RowId");
	if (obj){ var ID=obj.value;}
	else{return false;}
	if (ID=="") return false;
	obj=document.getElementById("UpdateAsCharged");
	if (obj) var encmeth=obj.value;
	var Return=cspRunServerMethod(encmeth,ID,Type)
	if (Return==""){alert("Status Err");}
	else if (Return=="SQLErr"){alert("Update Err");}
	else{alert("Update Success!");}
}


function PatItemPrint() {
	obj=document.getElementById("PGADM_RowId");
	if (obj){ CRMId=obj.value; }
	if (CRMId=="") return;
	var DietFlag="TRUE"
	var Diet=document.getElementById('DietFlag');
	if (Diet) DietFlag=Diet.checked;
	
	var Ins=document.getElementById('GetAdmListBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,CRMId,"G");
	if (value=="") return;
	var AdmList=value.split("^");
	var i=AdmList.length;
	for (var iLLoop=0;iLLoop<i;iLLoop++)
	{
		var ID=AdmList[iLLoop]
		var Instring=ID+"^"+DietFlag+"^CRM";
		var Ins=document.getElementById('GetOEOrdItemBox');
		if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
		var value=cspRunServerMethod(encmeth,'','',Instring);
		Print(value);
	}
	
}
function PrintRisRequest() {
	obj=document.getElementById("PGADM_RowId");
	if (obj){ CRMId=obj.value; }
	if (CRMId=="") return;
	var DietFlag="TRUE"
	var Diet=document.getElementById('DietFlag');
	if (Diet) DietFlag=Diet.checked;
	
	var Ins=document.getElementById('GetAdmListBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,CRMId,"G");
	if (value=="") return;
	var AdmList=value.split("^");
	var i=AdmList.length;
	for (var iLLoop=0;iLLoop<i;iLLoop++)
	{
		var ID=AdmList[iLLoop]
		PrintRisRequestApp(ID,"","PreIADM")
	}
	
}
function PrintReportRJ()
{
	obj=document.getElementById("PGADM_RowId");
	if (obj){ CRMId=obj.value; }
	if (CRMId=="") return;
	var DietFlag="TRUE"
	var Diet=document.getElementById('DietFlag');
	if (Diet) DietFlag=Diet.checked;
	
	var Ins=document.getElementById('GetAdmListBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,CRMId,"G");
	if (value=="") return;
	var AdmList=value.split("^");
	var i=AdmList.length;
	for (var iLLoop=0;iLLoop<i;iLLoop++)
	{
		var ID=AdmList[iLLoop]
		PrintReportRJApp(ID,"PreIADM");
	}
	
}
function ContractFindAfter(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	//alert(Arr)
	var obj=document.getElementById("Contract");
	if (obj) obj.value=Arr[2];
	var obj=document.getElementById("ContractID");
	if (obj) obj.value=Arr[0];
}

function UpdatePreAudit()
{
	alert("团体费用请在团体预约查询界面查看");
	return false;
}

document.body.onload = BodyLoadHandler;