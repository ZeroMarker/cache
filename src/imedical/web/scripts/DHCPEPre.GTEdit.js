/// DHCPEPreIADM.GTEdit.js
/// 创建时间		2006.10.20
/// 创建人		xuwm
/// 主要功能		供团体组成员修改预约信息?预约时间?
/// 			由DHCPEPreIADM.Team.UpdateBooking调用
/// 对应表		
/// 最后修改时间	
/// 最后修改人	
/// 完成
var TFORM="";
function BodyLoadHandler() {

	var obj;

	//更新
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	
	
	// PGADM_AddOrdItem 允许加项 
	obj=document.getElementById("AddOrdItem");
	if (obj){ obj.onclick = AddOrdItem_click; }

	// PGADM_AddOrdItemLimit 加项金额限制 
	obj=document.getElementById("AddOrdItemLimit");
	if (obj){ obj.onclick = AddOrdItemLimit_click; }

	// PGADM_AddPhcItem 允许加药 
	obj=document.getElementById("AddPhcItem");
	if (obj){ obj.onclick = AddPhcItem_click; }

	// PGADM_AddPhcItemLimit 加药金额限制 
	obj=document.getElementById("AddPhcItemLimit");
	if (obj){ obj.onclick = AddPhcItemLimit_click; }
	
	obj=document.getElementById("RowId");
	iniForm();
}

function iniForm(){
	
	var obj;
	
	obj=document.getElementById('DataBox');
	if (obj && ""!=obj.value) { 
		SetPatient_Sel(obj.value);
	}
		
}

//
function SetPatient_Sel(value) {
	var obj;
	var Data=value.split(";");
	
	//登记信息
	var PreIADMData=Data[1];
	if (""!=PreIADMData) { SetPreIADM(PreIADMData); }
	
}


//登记信息
function SetPreIADM(value){

	var obj;
	var Data=value.split("^");
	var iLLoop=0;	
	iRowId=Data[iLLoop];
	
	if ('0'==iRowId) { return false; }
		// 按钮 预约项目
		obj=document.getElementById("BNewItem");
		if (obj){ obj.disabled=false; }		
		
		// 保存金额
		//obj=document.getElementById("BSaveAmount");
		//if (obj){ obj.disabled=false; }		
	
	// 0
	obj=document.getElementById("RowId");
	if (obj) { obj.value=iRowId; }
	iLLoop=iLLoop+1;
	
	//预登记个人基本信息号 PIADM_PIBI_DR 1
	obj=document.getElementById("PIBI_RowId");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;	
	// 1.1
	obj=document.getElementById("PIBI_DR_Name");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;

	//对应团体的ADM PIADM_PGADM_DR 2
	obj=document.getElementById("PGADM_DR");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	if (Data[iLLoop]!="")
	{
		var encmeth=document.getElementById("GetGADMInfo");
		if (encmeth) encmeth=encmeth.value;
		var GADMInfo=cspRunServerMethod(encmeth,Data[iLLoop]);
		GADMInfo=GADMInfo.split("^");
		var obj;
		obj=document.getElementById("GStartDate");
		if (obj) obj.value=GADMInfo[0];
		obj=document.getElementById("GEndDate");
		if (obj) obj.value=GADMInfo[1];
		obj=document.getElementById("GDelayDate");
		if (obj) obj.value=GADMInfo[2];
	}
	iLLoop=iLLoop+1;
	
	// 对应团体 2.1
	//obj=document.getElementById("PGADM_DR_Name");
	//	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }	
	iLLoop=iLLoop+1;	

	//对应团体组ADM PIADM_PGTeam_DR 3
	obj=document.getElementById("PGTeam_DR");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	// 对应团体组 3.1
	//obj=document.getElementById("PGTeam_DR_Name");
	//	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }	
	iLLoop=iLLoop+1;	

	//预约体检日期开始 PIADM_PEDateBegin 4
	obj=document.getElementById("PEDateBegin");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	// 预约体检日期结束 PIADM_PEDateEnd 27
	obj=document.getElementById("PEDateEnd");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	//预约体检时间 PIADM_PETime 5
	obj=document.getElementById("PETime");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	// 预约接待人员 PIADM_PEDeskClerk_DR 6
	obj=document.getElementById("PEDeskClerk_DR");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	// 预约接待人员 6.1
	obj=document.getElementById("PEDeskClerk_DR_Name");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;	

	// PIADM_Status 7
	obj=document.getElementById("Status");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	

	//视同收费 PIADM_AsCharged 8
	obj=document.getElementById("AsCharged");
	if (obj && Data[iLLoop]) {
		if ("Y"==Data[iLLoop]) { obj.checked=true; }
		else { obj.checked=false; }
	}	
	iLLoop=iLLoop+1;
	var fillData
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
	
	// 个人报告发送	PIADM_IReportSend 25
	obj=document.getElementById("IReportSend");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	// 结算方式	PIADM_DisChargedMode 26
	obj=document.getElementById("DisChargedMode");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	//  PIADM_VIP 28
	obj=document.getElementById("VIP");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	//  PIADM_DelayDate 28
	obj=document.getElementById("DelayDate");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	
	
	//  PIADM_Remark 28
	obj=document.getElementById("Remark");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	// 业务员 PIADM_PEDeskClerk_DR 6
	obj=document.getElementById("Sales_DR");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	// 业务员 6.1
	obj=document.getElementById("Sales");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	
}
//验证是否为浮点数
function IsFloat(Value) {
	
	var reg;
	
	if(""==trim(Value)) { 
		//容许为空
		return true; 
	}else { Value=Value.toString(); }
	
	reg=/^((-?|\+?)\d+)(\.\d+)?$/;
	if ("."==Value.charAt(0)) {
		Value="0"+Value;
	}
	
	var r=Value.match(reg);
	if (null==r) { return false; }
	else { return true; }
}
function SetAddItem(value) {
	var Data=value.split("^");
	var iLLoop=0;	
	
	var iAddOrdItem=false;
	//	公费加项	PIADM_AddOrdItem	19
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
	//	加项金额限制	PIADM_AddOrdItemLimit	20
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
	
	//	公费加项金额	PIADM_AddOrdItemAmount	21
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
	
	//	允许加药	PIADM_AddPhcItem	22
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
	
	//	加药金额限制	PIADM_AddPhcItemLimit	23
	var iAddPhcItemLimit=false;
	obj=document.getElementById("AddPhcItemLimit");
	if (obj) {
		if (iAddPhcItem) {
			obj.style.display="inline"; // 可见
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
			if (obj) {obj.style.display="inline"; }
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
	
	//	允许加药金额	PIADM_AddPhcItemAmount	24
	obj=document.getElementById("AddPhcItemAmount");		
	if (obj) {
		if (iAddPhcItemLimit) {
			obj.style.display="inline";
			obj.disabled=false;
			
			obj.value=Data[iLLoop];
			
			obj=document.getElementById("cAddPhcItemAmount");
			if (obj) { obj.style.display="inline"; }		
		}
		else{
			obj.style.display="none";
			obj.disabled=true;
			obj.value="";
		}
	}
	
}
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];

}

function Update_click() {
	var iPEDate="", iPETime=""
	var obj,DataStr="",OneData="",iRowId
	obj=document.getElementById("RowId");
	if (obj) { OneData=obj.value; }
	iRowId=OneData
	DataStr=OneData
	OneData=""
	//预登记个人基本信息号 PIADM_PIBI_DR 1
	obj=document.getElementById("PIBI_RowId");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	//对应团体的ADM PIADM_PGADM_DR 2
	obj=document.getElementById("PGADM_DR");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	//对应组ADM PIADM_PGTeam_DR 3
	obj=document.getElementById("PGTeam_DR");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	//预约体检日期开始 PIADM_PEDateBegin 4
	obj=document.getElementById("PEDateBegin");
	if (obj) { OneData=obj.value; }
	if (""==OneData) {
		//alert("Please entry all information.");
		alert(t['08']);
		websys_setfocus('PEDateBegin');
		return false;
	}
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// 预约体检日期结束 PIADM_PEDateEnd 4
	obj=document.getElementById("PEDateEnd");
	if (obj) { OneData=obj.value; }
	if (""==OneData) {
		//alert("Please entry all information.");
		alert(t['08']);
		websys_setfocus('PEDateEnd');
		return false;
	}
	iPEDate=OneData
	DataStr=DataStr+"^"+OneData
	OneData=""
	//预约体检时间 PIADM_PETime
	obj=document.getElementById("PETime");
	if (obj) {
		if ('clsInvalid'==obj.className) { 
			//alert("无效时间格式");
			alert(t["Err 04"]);
			return false;
		}
		OneData=obj.value;
	}
	iPETime=OneData
	DataStr=DataStr+"^"+OneData
	OneData=""
	//预约接待人员 PIADM_PEDeskClerk_DR
	obj=document.getElementById("PEDeskClerk_DR");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	// PIADM_Status
	//obj=document.getElementById("Status");
	//if (obj) { OneData=obj.value; }
	OneData="PREREG"
	DataStr=DataStr+"^"+OneData
	OneData=""
	//视同收费 PIADM_AsCharged
	obj=document.getElementById("AsCharged");
	if (obj && obj.checked) { OneData="Y"; }
	else { OneData="N"; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	// 允许加项	PIADM_AddOrdItem
	obj=document.getElementById("AddOrdItem");
	if (obj && obj.checked) { OneData="Y"; }
	else { OneData="N"; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// 加项金额限制	PIADM_AddOrdItemLimit
	obj=document.getElementById("AddOrdItemLimit");
	if (obj && obj.checked) { OneData="Y"; }
	else { OneData="N"; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// 允许加项金额	PIADM_AddOrdItemAmount
	obj=document.getElementById("AddOrdItemAmount");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// 允许加药	PIADM_AddPhcItem
	obj=document.getElementById("AddPhcItem");
	if (obj && obj.checked) { OneData="Y"; }
	else { OneData="N"; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// 加药金额限制	PIADM_AddPhcItemLimit
	obj=document.getElementById("AddPhcItemLimit");
	if (obj && obj.checked) { OneData="Y"; }
	else { OneData="N"; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// 允许加药金额	PIADM_AddPhcItemAmount
	obj=document.getElementById("AddPhcItemAmount");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	// 个人报告发送	PIADM_IReportSend
	obj=document.getElementById("IReportSend");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// 结算方式	PIADM_DisChargedMode
	obj=document.getElementById("DisChargedMode");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// 	PIADM_VIP
	obj=document.getElementById("VIP");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//延期日期 PIADM_DelayDate
	//obj=document.getElementById("DelayDate");
	//if (obj) { iDelayDate=obj.value; }
	OneData="";
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//备注 PIADM_Remark
	obj=document.getElementById("Reamrk");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	
	obj=document.getElementById("Sales_DR");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',DataStr)
	if (flag=="Err Date")
	{
		alert(t["Err Date"]);
		return false;
	}
	if ('0'==flag) {
		//alert("Update Success!");
		alert(t['info 01']);
		if (opener) {
			// 调用父窗口 DHCPEPreGTeam.List 的返回函数
			opener.ChilidWindowReturn(iRowId+"^"+iPEDate+"^"+iPETime);
			close();
		}
		
	}else if('100'==flag) {
		alert(t['Err 100']);
		close();
	}
	else if('Err 05'==flag) {
		alert(t['Err 05']);
		close();
	}	
	else {
		//alert("Insert error.ErrNo="+flag);
		alert(t['02']+flag);
		close();
		return false;
	}

	//刷新页面
	//location.reload(); 
	return true;
}

function nextfocus() {
	var eSrc=window.event.srcElement;
	var key=websys_getKey(e);
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
}
//  允许加项(PIADM_AddOrdItem)
function AddOrdItem_click() {
	//var src=window.event.srcElement;
	var src=document.getElementById("AddOrdItem");
	var obj;

	if (src.checked) {
		// PIADM_AddOrdItemLimit 加项金额限制 
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
		// PIADM_AddOrdItemLimit 加项金额限制 
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
// PIADM_AddOrdItemLimit 加项金额限制 
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
// PIADM_AddPhcItem 允许加药 
function AddPhcItem_click() {
	//var src=window.event.srcElement;
	var src=document.getElementById("AddPhcItem");
	var obj;
	
	if (src.checked) {
		// PIADM_AddPhcItemLimit 加药金额限制 
		obj=document.getElementById("AddPhcItemLimit");
		if (obj){
			obj.style.display = "inline" ;
			obj.disabled=false;
			obj.checked=true;
		}
		obj=document.getElementById("cAddPhcItemLimit");
		if (obj){ obj.style.display = "inline" ; }
		
		// PIADM_AddPhcItemAmount	允许加药金额
		obj=document.getElementById("AddPhcItemAmount");
		if (obj){
			obj.style.display="inline";
			obj.disabled=false;
			obj.value="";
		}
		obj=document.getElementById("cAddPhcItemAmount");
		if (obj){ obj.style.display = "inline" ; }
		
		websys_setfocus("AddPhcItemAmount");
		
	}
	else{
		// PIADM_AddPhcItemLimit 加药金额限制 
		obj=document.getElementById("AddPhcItemLimit");
		if (obj){
			obj.style.display = "none" ;
			obj.disabled=true;
			obj.checked=false;
		}
		obj=document.getElementById("cAddPhcItemLimit");
		if (obj){ obj.style.display = "none" ; }
		
		// PIADM_AddPhcItemAmount	允许加药金额
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
// PIADM_AddPhcItemLimit 加药金额限制 
function AddPhcItemLimit_click() {
	//alert("AddPhcItemLimit_click"+src.id)
	//var src=window.event.srcElement;
	var src=document.getElementById("AddPhcItemLimit");
	var obj;
	
	if (src.checked) {
		// PIADM_AddPhcItemAmount	允许加药金额
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
		// PIADM_AddPhcItemAmount	允许加药金额
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

function UpdatePreAudit()
{
	var Type="I";
	var obj;
	obj=document.getElementById("RowId");
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
  //换组
function UpdateTeam()
{   var obj;
	obj=document.getElementById("RowId");
	if (obj){ var ID=obj.value;}
	else{return false;}
	if (ID=="") return false;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEChangeTeam.Edit&id="+ID;
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





function ModifyDelayDate()
{
	var Type="Pre";
	var obj;
	obj=document.getElementById("RowId");
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
document.body.onload = BodyLoadHandler;
