/// DHCPEPreGTeam.Edit.js

var TFORM="tDHCPEPreGTeam_Edit";
function BodyLoadHandler() {
	

	var obj;
	var tobj=document.getElementById(TFORM)
	if (tobj) {
		tobj.ondblclick=ClicktblToSetTemplate;}

	//更新
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	
	//清除
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }
	
	//清除
	obj=document.getElementById("SaveTemplate");
	if (obj){ obj.onclick=SaveTemplate_click; }
	
	//适用性别 
	obj=document.getElementById("Sex_N");
	if (obj){ obj.onclick=Sex_click; }
	obj=document.getElementById("Sex_M");
	if (obj){ obj.onclick=Sex_click; }	
	obj=document.getElementById("Sex_F");
	if (obj){ obj.onclick=Sex_click; }		
	//婚姻状况
	obj=document.getElementById("Married_UM");
	if (obj){ obj.onclick=Married_click; }
	obj=document.getElementById("Married_M");
	if (obj){ obj.onclick=Married_click; }
	obj=document.getElementById("Married_N");
	if (obj){ obj.onclick=Married_click;}
	var obj=document.getElementById("GetVIP");
	if (obj) VIPNV=obj.value;  
	obj=document.getElementById("VIPLevel");	//	列表框时使用
	if (obj) {
		obj.value=VIPNV;
		obj.onchange=VIPLevel_Change;
	}
	
	var obj=document.getElementById("PatFeeType_DR_Name");
	if (obj){obj.onchange=PatFeeType_Change;}

	// PGT_AddOrdItem 公费加项 
	obj=document.getElementById("AddOrdItem");
	if (obj){ obj.onclick = AddOrdItem_click; }

	// PGT_AddOrdItemLimit 加项金额限制 
	obj=document.getElementById("AddOrdItemLimit");
	if (obj){ obj.onclick = AddOrdItemLimit_click; }

	// PGT_AddPhcItem 允许加药 
	obj=document.getElementById("AddPhcItem");
	//if (obj){ obj.onclick = AddPhcItem_click; }
	
	// PGT_AddPhcItemLimit 加药金额限制 
	obj=document.getElementById("AddPhcItemLimit");
	//if (obj){ obj.onclick = AddPhcItemLimit_click; }
	DHCP_GetXMLConfig("InvPrintEncrypt","OEItemPrint");  //Add 20080708
	
	 // PGT_Endangers
	obj=document.getElementById("HarmInfo");
	if (obj) {obj.ondblclick=HarmInfo_Click;}

	iniForm();
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

function VIPLevel_Change()
{
	obj=document.getElementById("VIPLevel");
	if (obj){
		
		var VIPLevel=obj.value;
		if (VIPLevel=="") return false;
		
		var VIPDesc=tkMakeServerCall("web.DHCPE.PreCommon","GetVIPDescBYLevel",VIPLevel)
		if(VIPDesc!="职业病"){
			obj=document.getElementById('HarmInfo');
			if(obj) obj.style.display="none";
			obj=document.getElementById('cHarmInfo');
			if(obj) obj.style.display="none";
			obj=document.getElementById('OMETypeDR');
			if(obj) obj.style.display="none";
			obj=document.getElementById('cOMETypeDR');
			if(obj) obj.style.display="none";
			}else{
			obj=document.getElementById('HarmInfo');
			if(obj) obj.style.display="inline";
			obj=document.getElementById('cHarmInfo');
			if(obj) obj.style.display="inline";
			obj=document.getElementById('OMETypeDR');
			if(obj) obj.style.display="inline";
			obj=document.getElementById('cOMETypeDR');
			if(obj) obj.style.display="inline";
			
			}
		

		var PatType=tkMakeServerCall("web.DHCPE.VIPLevel","GetPatFeeType",VIPLevel)
		if (PatType!=""){
			var obj=document.getElementById("PatFeeType_DR_Name");
			if (obj) obj.value=PatType;
		}
		var DefaultRoomPlace=tkMakeServerCall("web.DHCPE.RoomManagerEx","GetDefaultRoomPlace",VIPLevel,"G");
		obj=document.getElementById("RoomPlace");	//	列表框时使用
		if (obj) { obj.value=DefaultRoomPlace; }
	}
}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
	
}

function iniForm(){

	var SelRowObj;
	var obj;
	var iParRef,iChildSub="";
	obj=document.getElementById("OperType");
	if (obj && "Q"==obj.value) {}
	else{
		//更新
		obj=document.getElementById("Update");
		//if (obj){ obj.style.display="inline"; }
	    //清屏
		obj=document.getElementById("Clear");
		//if (obj){ obj.style.display="inline"; }	
		
		obj=document.getElementById("BNew");
		//if (obj){ obj.style.display="inline"; }			
	
	}
	    
	obj=document.getElementById('ParRefBox');
	if (obj) { iParRef=obj.value; }
	
	obj=document.getElementById('ParRef');
	if (""!=iParRef && obj) { obj.value=iParRef; }
	
	if (""==iParRef)
	{
		obj=document.getElementById("ParRef_Name");
	    if (obj) { obj.value=""; }
	    return false;
	}
	else
	{
		SelRowObj=document.getElementById('ParRefNameBox');	
		obj=document.getElementById('ParRef_Name');
		if (SelRowObj && obj) { obj.value=SelRowObj.value; }
	}
	Clear_click();
	obj=document.getElementById('DataBox');
	if (obj && ""!=obj.value) { 
		SetPatient_Sel(obj.value);
		websys_setfocus("Desc");
	}else{
		obj=document.getElementById('ParRefDataBox');
		if (obj && ""!=obj.value) { 
			SetParRefData(obj.value);
		}
	}
	obj=document.getElementById('VIPLevel');
	if (obj){
		var VIPLevel=obj.value;
		var VIPDesc=tkMakeServerCall("web.DHCPE.PreCommon","GetVIPDescBYLevel",VIPLevel)
		if(VIPDesc!="职业病"){
			obj=document.getElementById('HarmInfo');
			if(obj) obj.style.display="none";
			obj=document.getElementById('cHarmInfo');
			if(obj) obj.style.display="none";
			obj=document.getElementById('OMETypeDR');
			if(obj) obj.style.display="none";
			obj=document.getElementById('cOMETypeDR');
			if(obj) obj.style.display="none";
			}else{
			obj=document.getElementById('HarmInfo');
			if(obj) obj.style.display="inline";
			obj=document.getElementById('cHarmInfo');
			if(obj) obj.style.display="inline";
				obj=document.getElementById('OMETypeDR');
			if(obj) obj.style.display="inline";
			obj=document.getElementById('cOMETypeDR');
			if(obj) obj.style.display="inline";
			}
			
		} 


	
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

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];

}

function FindPatDetail(ID){
	var Instring=ID;

	var Ins=document.getElementById('GetDetail');
	if (Ins) { var encmeth=Ins.value} else {var encmeth=''};
	var flag=cspRunServerMethod(encmeth,'SetPatient_Sel','',Instring);

}
function SetAddItem(value) {
	var Data=value.split("^");
	var iLLoop=0;	
	
	var iAddOrdItem=false;
	//	公费加项	PGT_AddOrdItem	19
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
	//	加项金额限制	PGT_AddOrdItemLimit	20
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
	
	//	公费加项金额	PGT_AddOrdItemAmount	21
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
	
	//	允许加药	PGT_AddPhcItem	22
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
	
	//	加药金额限制	PGT_AddPhcItemLimit	23
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
			 
			//限制开药金额
			obj=document.getElementById("cAddPhcItemLimit");	
			if (obj) {obj.style.display="none"; }
			//开药金额
			 obj=document.getElementById("cAddPhcItemAmount"); 
			if (obj) {obj.style.display="none"; }

		}	

	}
	iLLoop=iLLoop+1;
	
	//	允许加药金额	PGT_AddPhcItemAmount	24
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

function SetParRefData(value) {

	var obj;
	var fillData;
	var Data=value.split("^");
	var iLLoop=4;	
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
	iLLoop=iLLoop+3;
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
	if (obj) { obj.value=fillData; obj.disabled=true}
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];

	// PGADM_IReportSend 个人报告发送 27
	obj=document.getElementById("IReportSend");
	if (obj) { obj.value=fillData; obj.disabled=true}
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];

	// PGADM_DisChargedMode 结算方式 28
	obj=document.getElementById("DisChargedMode");
	if (obj) { obj.value=fillData;} //obj.disabled=true
	iLLoop=iLLoop+3;
	fillData=Data[iLLoop];
    
    //VIP
    obj=document.getElementById("VIPLevel");
	//if (obj) { obj.value=fillData; }
		iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
    
    iLLoop=iLLoop+9;
    fillData=Data[iLLoop];

    //默认团体就诊类别
    obj=document.getElementById("PatFeeType_DR_Name");
	if (obj) { obj.value=fillData; }
	
	var VIPLevel="";
	obj=document.getElementById("VIPLevel");
	if (obj) { VIPLevel=obj.value; }
	var DefaultRoomPlace=tkMakeServerCall("web.DHCPE.RoomManagerEx","GetDefaultRoomPlace",VIPLevel,"G");
	obj=document.getElementById("RoomPlace");	//	列表框时使用
	if (obj) { obj.value=DefaultRoomPlace; }
	
	return true

}

function SetPatient_Sel(value) {
	var obj;
	var Data=value.split("^");
	//alert("value:"+value)
	var iLLoop=0;
	iRowId=Data[iLLoop];
	if ("0"==iRowId){
		return false;
	}
	
	//团体ADM	PGT_ParRef	1
	obj=document.getElementById("ParRef");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
		
	//	PGT_RowId
	obj=document.getElementById("RowId");
	if (obj) { obj.value=Data[iLLoop]; } 
	iLLoop=iLLoop+1;
	//	PGT_ChildSub 3
	obj=document.getElementById("ChildSub");
	if (obj) { obj.value=Data[iLLoop]; } 
	iLLoop=iLLoop+1;
	
	//分组名称	PGT_Desc 4
	obj=document.getElementById("Desc");
	if (obj) { obj.value=Data[iLLoop]; } 
	iLLoop=iLLoop+1;
	
	//	PGT_BookDateBegin	21
	obj=document.getElementById("BookDateBegin");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	//	PGT_BookDateEnd	22
	obj=document.getElementById("BookDateEnd");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	//预约时间 PGT_BookTime 23
	obj=document.getElementById("BookTime");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	// PGT_PEDeskClerk_DR 24
	obj=document.getElementById("PEDeskClerk_DR");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	var strLine="";
	//	公费加项	PGT_AddOrdItem	12
	strLine=strLine+Data[iLLoop]+"^"; 
	iLLoop=iLLoop+1;	

	//	加项金额限制	PGT_AddOrdItemLimit	13
	strLine=strLine+Data[iLLoop]+"^"; 
	iLLoop=iLLoop+1;
	
	//	公费加项金额	PGT_AddOrdItemAmount	14
	strLine=strLine+Data[iLLoop]+"^"; 
	iLLoop=iLLoop+1;	
	
	//	允许加药	PGT_AddPhcItem	15
	strLine=strLine+Data[iLLoop]+"^"; 
	iLLoop=iLLoop+1;	
	
	//	加药金额限制	PGT_AddPhcItemLimit	16
	strLine=strLine+Data[iLLoop]+"^"; 
	iLLoop=iLLoop+1;

	//	允许加药金额	PGT_AddPhcItemAmount	17
	strLine=strLine+Data[iLLoop]+"^"; 
	iLLoop=iLLoop+1;
	SetAddItem(strLine);
	
	//性别	PGT_Sex 5
	obj=document.getElementById("Sex");
	if (obj) { 
		obj.value=Data[iLLoop];
		SetSex("");
		SetSex(Data[iLLoop]);
	} 

	iLLoop=iLLoop+1;
	//年龄上限	PGT_UpperLimit 6
	obj=document.getElementById("UpperLimit");
	if (obj) { obj.value=Data[iLLoop]; } 

	iLLoop=iLLoop+1;
	//年龄下限	PGT_LowerLimit 7
	obj=document.getElementById("LowerLimit");
	if (obj) { obj.value=Data[iLLoop]; } 

	iLLoop=iLLoop+1;
	//婚姻状况	PGT_Married 8
	obj=document.getElementById("Married");
	if (obj) { 
		//obj.value=Data[iLLoop]; 
		SetMarried("");
		SetMarried(Data[iLLoop]);
	} 
   
	iLLoop=iLLoop+4;
	
	//团体名称	PGT_LowerLimit 7
	obj=document.getElementById("ParRef_Name");
	if (obj) { obj.value=Data[iLLoop]; } 
	iLLoop=iLLoop+1;
	
	//	团体报告发送	PGT_GReportSend	18
	obj=document.getElementById("GReportSend");
	if (obj) { obj.value=Data[iLLoop]; obj.disabled=true;}
	iLLoop=iLLoop+1;	
	
	//	个人报告发送	PGT_IReportSend	19
	obj=document.getElementById("IReportSend");
	if (obj) { obj.value=Data[iLLoop]; obj.disabled=true;}
	iLLoop=iLLoop+1;	
	
	//	结算方式	PGT_DisChargedMode	20
	obj=document.getElementById("DisChargedMode");
	if (obj) { obj.value=Data[iLLoop];} //obj.disabled=true;
	iLLoop=iLLoop+1;	
	// PGT_PEDeskClerk_DR_Name 24.1
	obj=document.getElementById("PEDeskClerk_DR_Name");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	obj=document.getElementById("VIPLevel");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	obj=document.getElementById("TeamLevel");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	obj=document.getElementById("PatFeeType_DR_Name");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	var NoInclude=""
	NoInclude=Data[iLLoop];
	if (NoInclude=="1"){
		obj=document.getElementById("NoIncludeGroup");
		if (obj) obj.checked=true;
	}
	
	iLLoop=iLLoop+1;
	//检查种类
	obj=document.getElementById("OMETypeDR");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	var RoomPlace=""
	RoomPlace=Data[iLLoop];
	obj=document.getElementById("RoomPlace");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//危害因素
	obj=document.getElementById("HarmInfo");
	if (obj) { 
	    Str=Data[iLLoop];
	    obj.value=tkMakeServerCall("web.DHCPE.OccupationalDisease","SetEndanger2",Str);
	}

}

function Update_click() {
	var obj,OneData="",DataStr="";
	var iParRef="",iRowId="",iChildSub,iDesc;
	//团体ADM	PGT_ParRef
	obj=document.getElementById("ParRef");
	if (obj) { OneData=obj.value; } 
	if (""==OneData) {
		//alert("无效团体");
		alert(t['01']);
		return false;		
	}
	iParRef=OneData
	DataStr=OneData
	OneData=""
	
	//	PGT_RowId
	obj=document.getElementById("RowId");
	if (obj) { OneData=obj.value; } 
	iRowId=OneData
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//	PGT_ChildSub
	obj=document.getElementById("ChildSub");
	if (obj) { OneData=obj.value; } 
	iChildSub=OneData
	DataStr=DataStr+"^"+OneData
	OneData=""

	//分组名称	PGT_Desc
	obj=document.getElementById("Desc");
	if (obj) { OneData=obj.value; } 
	if (""==OneData) {
		//alert("Please entry all information.");
		alert(t['01']);
		websys_setfocus("Desc");
		return false;		
	}
	iDesc=OneData
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// PGT_BookDateBegin 29
	obj=document.getElementById("BookDateBegin");
	if (obj) { OneData=obj.value; } 
	DataStr=DataStr+"^"+OneData
	OneData=""

	// PGT_BookDateEnd 30
	obj=document.getElementById("BookDateEnd");
	if (obj) { OneData=obj.value; } 
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//预约时间 PGT_BookTime
	obj=document.getElementById("BookTime");
	if (obj) { OneData=obj.value; } 
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//预约接待员 PGT_PEDeskClerk_DR
	obj=document.getElementById("PEDeskClerk_DR");
	if (obj) { OneData=obj.value; } 
	DataStr=DataStr+"^"+OneData
	OneData=""	
	
	// PGT_AddOrdItem 公费加项 20
	obj=document.getElementById("AddOrdItem");
	if (obj && obj.checked) { OneData='Y'; }
	else { OneData='N';}
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// PGT_AddOrdItemLimit 加项金额限制 21
	obj=document.getElementById("AddOrdItemLimit");
	if (obj && obj.checked) { OneData='Y'; }
	else { OneData='N';}
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// PGT_AddOrdItemAmount 公费加项金额 22
	obj=document.getElementById("AddOrdItemAmount");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// PGT_AddPhcItem 允许加药 23
	obj=document.getElementById("AddPhcItem");
	if (obj && obj.checked) { OneData='Y'; }
	else { OneData='N';}
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// PGT_AddPhcItemLimit 加药金额限制 24
	obj=document.getElementById("AddPhcItemLimit");
	if (obj && obj.checked) { OneData='Y'; }
	else { OneData='N';}
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//  PGT_AddPhcItemAmount允许加药金额 25
	obj=document.getElementById("AddPhcItemAmount");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//性别	PGT_Sex
	//obj=document.getElementById("Sex");
	//if (obj) { iSex=obj.value; } 
	OneData=GetSex();
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//年龄上限	PGT_UpperLimit
	obj=document.getElementById("UpperLimit");
	if (obj) { OneData=obj.value; }
	if (!(IsFloat(OneData))) {
		//alert("年龄上限格式非法");
		alert(t['Err 03']);
		websys_setfocus("UpperLimit");		
		return false;
	}
	//DataStr=DataStr+"^"+OneData
	DataStr=DataStr+"^"+trim(OneData)
	OneData=""

	//年龄下限	PGT_LowerLimit
	obj=document.getElementById("LowerLimit");
	if (obj) { OneData=obj.value; }
	if (!(IsFloat(OneData))) {
		//alert("年龄下限格式非法");
		alert(t['Err 04']);
		websys_setfocus("LowerLimit");		
		return false;
	}
	//DataStr=DataStr+"^"+OneData
	DataStr=DataStr+"^"+trim(OneData)
	OneData=""

	//婚姻状况	PGT_Married
	//obj=document.getElementById("Married");
	//if (obj) { iMarried=obj.value; } 
	OneData=GetMarried();
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//VIP等级
	obj=document.getElementById("VIPLevel");
	if (obj) { OneData=obj.value;
	var VIPID=obj.value; }
	 var VIPLevelDesc=tkMakeServerCall("web.DHCPE.VIPLevel","GetVIPDescByID",VIPID);
	DataStr=DataStr+"^"+OneData
	OneData=""
	 
	// 分组等级 20100701
	obj=document.getElementById("TeamLevel");
	if (obj) { OneData=obj.value; } 
	DataStr=DataStr+"^"+OneData
	OneData=""
    //就诊费用类别 用于计费价格
    obj=document.getElementById("PatFeeType_DR_Name");
	if (obj) { OneData=obj.value; } 
	DataStr=DataStr+"^"+OneData
	//是否包含在团体
	OneData=""
	obj=document.getElementById("NoIncludeGroup");
	if (obj&&obj.checked) { OneData=1; } 
	DataStr=DataStr+"^"+OneData;
	//结算方式
	OneData=""
	obj=document.getElementById("DisChargedMode");
	if (obj) { OneData=obj.value;}
	DataStr=DataStr+"^"+OneData;
	//危害因素
	OneData=""
	OneData=GetEndangers();
	if(VIPLevelDesc=="职业病"){
	if (""==OneData) {
		obj=document.getElementById("HarmInfo")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("危害因素不能为空");
		return false;
	}
	}

	DataStr=DataStr+"^"+OneData;
	
	//检查种类
	OneData=""
	obj=document.getElementById("OMETypeDR");
	if (obj) { OneData=obj.value; } 
	if(VIPLevelDesc=="职业病"){ 
	 if (""==OneData) {
		obj=document.getElementById("OMETypeDR")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("检查种类不能为空");
		return false;
	}
	}

	DataStr=DataStr+"^"+OneData;

   //检查位置
	OneData=""
	obj=document.getElementById("RoomPlace");
	if (obj) { OneData=obj.value;}
	DataStr=DataStr+"^"+OneData;
	
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
			opener.NewWondowReturn("1"+"^"+iParRef+"^"+iRowId+"^"+iChildSub+"^"+iDesc);
			close();
		}
		
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
function GetEndangers() {
    var obj="";
    obj=document.getElementById("HarmInfo");
	if (obj) { DataStr=obj.value; } 
    var Ins=document.getElementById('GetEndanger');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,DataStr)
	return flag;
}
function HarmInfo_Click()
{
	var RowId=""
	obj=document.getElementById("RowId");
	if (obj) {RowId=obj.value;}
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEOccuBaseTeaminfo.Endanger"
			+"&RowId="+RowId
	var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=680,height=400,left=150,top=150';
	window.open(lnk,"_blank",nwin)
}


function Clear_click() {
	var obj;
	
	//团体ADM	PGT_ParRef
	//obj=document.getElementById("ParRef");
	//if (obj) { obj.value=""; } 
	//obj=document.getElementById("ParRef_Name");
	//if (obj) { obj.value=""; } 

	//	PGT_RowId
	obj=document.getElementById("RowId");
	if (obj) { obj.value=""; } 

	//	PGT_ChildSub
	obj=document.getElementById("ChildSub");
	if (obj) { obj.value=""; } 

	//分组名称	PGT_Desc
	obj=document.getElementById("Desc");
	if (obj) { obj.value=""; } 
	
	//性别	PGT_Sex
	obj=document.getElementById("Sex");
	if (obj) { obj.value=""; } 
	SetSex("");
	SetSex("N");
	
	//年龄上限	PGT_UpperLimit
	obj=document.getElementById("UpperLimit");
	if (obj) { obj.value=""; }
	
	//年龄下限	PGT_LowerLimit
	obj=document.getElementById("LowerLimit");
	if (obj) { obj.value=""; }
	
	//婚姻状况	PGT_Married
	obj=document.getElementById("Married");
	if (obj) { obj.value=""; } 
	SetMarried("");
	SetMarried("M");
	
	//操作员	PGT_UpdateUser_DR
	obj=document.getElementById("UpdateUser_DR");
	if (obj) { obj.value=""; } 
	obj=document.getElementById("UpdateUser_DR_Name");
	if (obj) { obj.value=""; } 
	
	//日期	PGT_UpdateDate
	obj=document.getElementById("UpdateDate");
	if (obj) { obj.value=""; }
	websys_setfocus("Desc");
	
	obj=document.getElementById('ParRefDataBox');
	if (obj && ""!=obj.value) { 
		SetParRefData(obj.value);		
	}	
	var obj=document.getElementById("GetVIP");
	if (obj) VIPNV=obj.value; 
	obj=document.getElementById("VIPLevel");	//	列表框时使用
	if (obj) { obj.value=VIPNV; }
	
	var DefaultRoomPlace=tkMakeServerCall("web.DHCPE.RoomManagerEx","GetDefaultRoomPlace",VIPNV,"G");
	obj=document.getElementById("RoomPlace");	//	列表框时使用
	if (obj) { obj.value=DefaultRoomPlace; }
}

function SearchGList(value) {
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;

		obj=document.getElementById("ParRef_Name");
		if (obj) { obj.value=aiList[0]; }

		obj=document.getElementById("ParRef");
		if (obj) { obj.value=aiList[2]; }

	}
}

function nextfocus() {
	var eSrc=window.event.srcElement;
	var key=websys_getKey(e);
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
}
document.body.onload = BodyLoadHandler;



// **************  对性别特殊处理   ********************
function GetSex() {	
	var obj;

	obj=document.getElementById("Sex_M");
	if (obj){ if (obj.checked) { return "M"; } }
	
	obj=document.getElementById("Sex_F");
	if (obj){ if (obj.checked) { return "F"; } }
	
	obj=document.getElementById("Sex_N");
	if (obj){ if (obj.checked) { return "N"; } }
	
	return "N";
	
}

function SetSex(value) {
	
	var obj;
	
	if (""==value) {		 		
		obj=document.getElementById("Sex_N");
		if (obj){ obj.checked=false; }
		obj=document.getElementById("Sex_M");
		if (obj){ obj.checked=false; }
		obj=document.getElementById("Sex_F");
		if (obj){ obj.checked=false; }
		return false;				
	}
	
	if ("M"==value) {
	
		obj=document.getElementById("Sex_M");
		if (obj) { obj.checked=true; }  
	}
	else {
		if ("F"==value) {
		obj=document.getElementById("Sex_F");
		if (obj){ obj.checked=true; }  
		}
		else {
			if ("N"==value) {
				obj=document.getElementById("Sex_N");
				if (obj){ obj.checked=true; } 
			}
			else{  //默认
				obj=document.getElementById("Sex_N");
				if (obj){ obj.checked=true; }  			
			}
		}
	}  
}
function Sex_click() {
	var obj;

	srcElement = window.event.srcElement;

	SetSex("");

	obj=srcElement;
	obj.checked=true;
}

// **************  对性别特殊处理   ********************
function GetMarried() {	
	var obj;

	obj=document.getElementById("Married_UM");
	if (obj){ if (obj.checked) { return "UM"; } }
	
	obj=document.getElementById("Married_M");
	if (obj){ if (obj.checked) { return "M"; } }
	
	obj=document.getElementById("Married_N");
	if (obj){ if (obj.checked) { return "N"; } }
		
	return "N";
}

function SetMarried(value) {
	
	var obj;
	
	if (""==value) {		 		
		obj=document.getElementById("Married_UM");
		if (obj){ obj.checked=false; }
		obj=document.getElementById("Married_M");
		if (obj){ obj.checked=false; }
		obj=document.getElementById("Married_N");
		if (obj){ obj.checked=false; }		
		
		return false;				
	}
	
	obj=document.getElementById("Married_UM");
	if (("UM"==value || "Unmarried"==value)&& obj) { 
		obj.checked=true;
		return true;
	}
	
	obj=document.getElementById("Married_M");
	if (("M"==value || "Married"==value) && obj) {
		obj.checked=true;
		return true;
	}

	obj=document.getElementById("Married_N");
	if (("N"==value || "No"==value) && obj) {
		obj.checked=true;
		return true;
	}

}

function Married_click() {
	var obj;

	srcElement = window.event.srcElement;

	SetMarried("");

	obj=srcElement;
	obj.checked=true;
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
//  公费加项(PGT_AddOrdItem)
function AddOrdItem_click() {
	//var src=window.event.srcElement;
	var src=document.getElementById("AddOrdItem");
	var obj;

	if (src.checked) {
		// PGT_AddOrdItemLimit 加项金额限制 
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
		// PGT_AddOrdItemLimit 加项金额限制 
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
// PGT_AddOrdItemLimit 加项金额限制 
function AddOrdItemLimit_click() {
	//var src=window.event.srcElement;
	var src=document.getElementById("AddOrdItemLimit");
	var obj;
	if (src.checked) {
		obj=document.getElementById("AddOrdItemAmount");
		if (obj){
			obj.style.display = "inline" ;
			obj.disabled=false;
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
// PGT_AddPhcItem 允许加药 
function AddPhcItem_click() {
	//var src=window.event.srcElement;
	var src=document.getElementById("AddPhcItem");
	var obj;
	
	if (src.checked) {
		// PGT_AddPhcItemLimit 加药金额限制 
		obj=document.getElementById("AddPhcItemLimit");
		if (obj){
			obj.style.display = "inline" ;
			obj.disabled=false;
			obj.checked=true;
		}
		obj=document.getElementById("cAddPhcItemLimit");
		if (obj){ obj.style.display = "inline" ; }
		
		// PGT_AddPhcItemAmount	允许加药金额
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
		// PGT_AddPhcItemLimit 加药金额限制 
		obj=document.getElementById("AddPhcItemLimit");
		if (obj){
			obj.style.display = "none" ;
			obj.disabled=true;
			obj.checked=false;
		}
		obj=document.getElementById("cAddPhcItemLimit");
		if (obj){ obj.style.display = "none" ; }
		
		// PGT_AddPhcItemAmount	允许加药金额
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
// PGT_AddPhcItemLimit 加药金额限制 
function AddPhcItemLimit_click() {
	//alert("AddPhcItemLimit_click"+src.id)
	//var src=window.event.srcElement;
	var src=document.getElementById("AddPhcItemLimit");
	var obj;
	
	if (src.checked) {
		// PGT_AddPhcItemAmount	允许加药金额
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
		// PGT_AddPhcItemAmount	允许加药金额
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
function SaveTemplate_click()
{
	var obj;
	var InStr,iDesc,iAgeUp,iAgeDown,iSex,iMarried;
	var ret=1;
	obj=document.getElementById('Desc');
	if (obj) iDesc=obj.value;
	obj=document.getElementById('LowerLimit');
	//if (obj) iAgeUp=obj.value;
	if (obj) iAgeDown=obj.value;
	obj=document.getElementById('UpperLimit');
	//if (obj) iAgeDown=obj.value;
	if (obj) iAgeUp=obj.value;
	//性别
	obj=document.getElementById('Sex_M');
	if (obj&&obj.checked) iSex="M";
	obj=document.getElementById('Sex_F');
	if (obj&&obj.checked) iSex="F";
	obj=document.getElementById('Sex_N');
	if (obj&&obj.checked) iSex="N";
	obj=document.getElementById('Married_M');
	if (obj&&obj.checked) iMarried='M';
	obj=document.getElementById('Married_UM');
	if (obj&&obj.checked) iMarried='UM';
	obj=document.getElementById('Married_N');
	if (obj&&obj.checked) iMarried='N';
	
	InStr=iDesc+'^'+iAgeUp+'^'+iAgeDown+'^'+iSex+'^'+iMarried;
	
	ret=tkMakeServerCall("web.DHCPE.PreGTeam","GTeamTempSet",InStr,"","Set"); 
	if (ret==0){
		alert(t['info 01'])
		}
	else{
		alert(t['Err 05'])
		}
	//alert(location)
	location.reload();
}
function ClicktblToSetTemplate()
{
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	
	var iDesc,iAgeUp,iAgeDown,iSex,iMarried;
	iDesc=document.getElementById("TDesc"+'z'+selectrow).innerText;
	document.getElementById('Desc').value=iDesc;
	iAgeUp=document.getElementById("TAgeFrom"+'z'+selectrow).innerText;
	//document.getElementById('LowerLimit').value=iAgeUp;
	document.getElementById('UpperLimit').value=iAgeUp;
	iAgeDown=document.getElementById("TAgeTo"+'z'+selectrow).innerText;
	//document.getElementById('UpperLimit').value=iAgeDown;
	document.getElementById('LowerLimit').value=iAgeDown;
	//iSex=document.getElementById("TSex"+'z'+selectrow).innerText;
	iSex=document.getElementById("TSex"+'z'+selectrow).value;
	switch(iSex){
		case 'M':
		document.getElementById('Sex_M').checked=true;
		document.getElementById('Sex_F').checked=false;
		document.getElementById('Sex_N').checked=false;
		break;
		case 'F':
		document.getElementById('Sex_M').checked=false;
		document.getElementById('Sex_F').checked=true;
		document.getElementById('Sex_N').checked=false;
		break;
		case 'N':
		document.getElementById('Sex_M').checked=false;
		document.getElementById('Sex_F').checked=false;
		document.getElementById('Sex_N').checked=true;
		break;
		default:
		break;
		}
	//iMarried=document.getElementById("THouse"+'z'+selectrow).innerText;
	iMarried=document.getElementById("THouse"+'z'+selectrow).value;
	switch(iMarried){
		case 'M':
		document.getElementById('Married_M').checked=true;
		document.getElementById('Married_UM').checked=false;
		document.getElementById('Married_N').checked=false;
		break;
		case 'UM':
		document.getElementById('Married_M').checked=false;
		document.getElementById('Married_UM').checked=true;
		document.getElementById('Married_N').checked=false;
		break;
		case 'N':
		document.getElementById('Married_M').checked=false;
		document.getElementById('Married_UM').checked=false;
		document.getElementById('Married_N').checked=true;
		break;
		default:
		break;		
		}
}
function DelGTeamTemp()
{
	var eSrc=window.event.srcElement;
	var ID=eSrc.id;
	ret=tkMakeServerCall("web.DHCPE.PreGTeam","GTeamTempSet","",ID,"Del"); 
	location.reload();
	
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