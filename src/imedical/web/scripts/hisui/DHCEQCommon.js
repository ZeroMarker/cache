///---------------------------
///Modified By ZY 2010-8-18
///新增函数:GetLookUpID_Table
///	    TTime_changehandler
///	    TDate_changehandler
///	    LookUpTableDate
///	    HiddenTblColumn	   
///---------------------------
///Modified By JDL 2010-8-18
///新增函数:ReadOnlyElements
///	    Standard_TableKeyUp
///	    GetColCaption
///	    SourceInfo
///	    HiddenObj	    	
///---------------------------
///修改?ZY 2009-10-28 ZY0013
///修改函数:GetModel,GetManuFactory,GetProvider
///新增函数:GetPYCode
///---------------------------
///Modified by JDL JDL0011
///Modified Method GetShortName
///------------------------------
var curUserID,curUserCode,curUserName,curLocID,curLocName  // add by zx 20181021 全局变量名改变
var EquipGlobalLen=95; //2009-11-16 党军 DJ0035
var errcode=1000;
var BElement   //=new array;
//Modified by JDL 修改样式表引用
//document.styleSheets[0].addImport("DHCEQStyle.css",0);
//document.write("<LINK REL='stylesheet' TYPE='text/css' HREF='../scripts/DHCEQStyle.css'></LINK>")
///modify by lmm 2018-08-01
///增加入参：vBuss 业务代码
function InitUserInfo(vBuss)
{
	var userInfo=getSessionIDByMap("userinfo",session['LOGON.USERID']).split("^");
	curUserID=userInfo[0];
	curUserCode=userInfo[1];
    curUserName=userInfo[2];
    var locInfo=getSessionIDByMap("deptinfo",session['LOGON.CTLOCID']).split("^");
    curLocID=locInfo[0]
    curLocName=locInfo[1]
    BElement=new Array;
    BElementDeclare();
    InitMessage(vBuss);
    GetDisabledElement();
    //菜单名传递
    
    var obj=document.getElementById("GetMenuName");
    if (obj)
    {
	    var GetMenuName=GetElementValue("GetMenuName")
	    var obj=document.getElementById("cEQTitle");
	    if ((obj)&&(GetMenuName!=""))
	    {
		    SetCElement("cEQTitle",GetMenuName)  //add by lmm 2018-08-13
	    }
    }
    /*
    var obj=document.getElementById("BUpdate");		//Add By DJ 2016-11-21
    if (obj)
    {
	    var innerHTMLStr=obj.innerHTML;
	    innerHTMLStr=innerHTMLStr.replace("更新","保存");
	    obj.innerHTML=innerHTMLStr
    }
    */   
}
function EQCommon_HiddenElement(name)
{
	var obj=document.getElementById(name);
	if (obj){	
	obj.style.visibility="hidden";
	//obj.style.display="none";
	}
}



function SetEnableStyle(obj,value)
{
	if (obj){
		if (obj.type=="checkbox") return;	//disabledField
		//obj.className= (value==true)?"EQDisabledINPUT":"EQEnabledINPUT";	//modified by czf	
		}		
}
function DisableLookup(name,value)
{
	DisableElement(name,value);
	DisableElement("ld"+GetElementValue("GetComponentID")+"i"+name,value);
}

function GetLookupName(name)
{
	return "ld"+GetElementValue("GetComponentID")+"i"+name
}

//modify by lmm 2018-02-01
function DisableBElement(vElementID,vValue)
{ 
	var obj=document.getElementById(vElementID);
	if (obj)
	{
		if (vValue==true)
		{
			//按钮灰化处理
			jQuery("#"+vElementID).linkbutton("disable")

			//解绑按钮事件
			//jQuery("#"+vElementID).unbind();
			//var ibtncss=jQuery("#"+vElementID).attr("class")
			//ibtncss=ibtncss+" l-btn-disabled"
			//jQuery("#"+vElementID).attr("class",ibtncss)
			
		}
		else
		{
			//按钮启用
			jQuery("#"+vElementID).linkbutton("enable")
			//ibtncss="hisui-linkbutton l-btn l-btn-small l-btn-disabled"
			//jQuery("#"+vElementID).attr("class",ibtncss)
		}
	}
}

function LinkDisable(evt) {
}

function SetDefaultValue(ename,evalue)
{
	var obj;
	obj=document.getElementById(ename);
	if (obj){
		if (!obj.disabled&obj.value=="") obj.value=evalue;	
		}
}

function SetCElement(ename,evalue)
{
	
	var obj;
	obj=document.getElementById(ename);

	if(obj)        
	{
		SetElement(ename,evalue)
	}
}
//modify by lmm 2018-02-01
function SetChkElement(vElementID,vValue)
{	
	
		var objType=jQuery("#"+vElementID).prop("type")
		var objClassInfo=jQuery("#"+vElementID).prop("class")
	if ((vValue=="1")||(vValue=="true")||(vValue=="Y"))
	{
		jQuery("#"+vElementID).checkbox("setValue",true);  
	}
	if ((vValue=="0")||(vValue=="false")||(vValue=="N")||(vValue==""))
	{
		jQuery("#"+vElementID).checkbox("setValue",false);
	}
	
	
		/*
	var obj;
	obj=document.getElementById(ename);
	if (obj)	
	{	
		if (evalue==1) 
			{obj.checked=1;	}
		else
			{obj.checked=0;	}
	}*/

}
//modify by lmm 2018-02-01
function GetCElementValue(vElementID)  
{
	
	var obj=document.getElementById(vElementID);
	if (obj) return jQuery("#"+vElementID).text();
	return ""
		
}

function GetChkElementValue(ename)
{
	var obj,evalue;
	evalue="";
	obj=document.getElementById(ename);
	if (obj)	{	evalue=obj.checked;	}
	return evalue;
}


///以下根据Look Up取设备常用项ID

function GetCatID(value)
{
	GetLookUpID('EquiCatDR',value);
}

function GetModelID(value)
{
	GetLookUpID('ModelDR',value);
}

function GetToDeptID(value)
{
		GetLookUpID('ToDeptDR',value);
	//('ToDeptDR',value);
}

function GetFromDeptID(value)
{	
	GetLookUpID('FromDeptDR',value);
}

function GetPurchaseTypeID(value)
{
	GetLookUpID('PurchaseTypeDR',value);	
}

function GetDepreMethodID(value)
{
	GetLookUpID('DepreMethodDR',value);	
}

function GetOriginID(value)
{
	GetLookUpID('OriginDR',value);	
}

function GetBuyTypeID(value)
{
	GetLookUpID('BuyTypeDR',value);	
}

function GetUseLocID(value)
{
	GetLookUpID('UseLocDR',value);
}

function GetManageLocID(value)
{
	GetLookUpID('ManageLocDR',value);	
}

function GetInstallLocID(value)
{
	GetLookUpID('InstallLocDR',value);	
}

function GetMaintUserID(value)
{
	GetLookUpID('MaintUserDR',value);	
}

function GetCountryID(value)
{
	GetLookUpID('CountryDR',value);	
}

function GetWorkLoadUnitID(value)
{
	GetLookUpID('WorkLoadUnitDR',value);	
}

function GetUnitID(value)
{
	GetLookUpID('UnitDR',value);	
}

function GetManuFactoryID(value)
{
	GetLookUpID('ManuFactoryDR',value);	
}

function GetProviderID(value)
{
	GetLookUpID('ProviderDR',value);	
}

function GetEquipStatusID(value)
{
	GetLookUpID('Status',value);	
}
///modify by lmm 2020-06-29
///增加回车赋值后跳转下一输入框
function GetLookUpID(ename,value)
{
	var val=value.split("^");
	var obj=document.getElementById(ename);
	if (obj)	{	obj.value=val[1];
	//modify by lmm 2020-07-01
		var event = event||window.event;
		if (event)
		{
			var keyCode=event.which||event.keyCode
			if (keyCode==13)
			{
				var vElementID=String(ename)
				if ($("#"+vElementID.substr(0,vElementID.length-2)).attr("id")!=undefined)
				{
					var vElementID=$("#"+vElementID.substr(0,vElementID.length-2)).attr("id")
					lookuptab(vElementID)
					tabflag=1
				}
			}	
		}
	}
	else {messageShow("","","",ename);}		
}

function ClearComboData(ElementName)
{
	SetElement(ElementName+"DR","")
}
	
function GetDisabledElement()
{
	GetOneTypeDisabledElement( "input" );
	GetOneTypeDisabledElement( "textarea" );
}
function GetOneTypeDisabledElement(Name)
{
	var All = document.getElementsByTagName( Name );
	var Length = All.length;
	var BReturn=false;
	for(var I = 0; I < Length; I++)
	{
		if (All[I].disabled)
		{
			var Name=All[I].name;
			var obj=document.getElementById(Name);
			SetEnableStyle(obj,true)
		}
	}
}


function DisableAllTxt()
{
	var All = document.getElementsByTagName("input");
	var Length = All.length;
	for(var I = 0; I < Length; I++)
	{
		All[I].disabled=true;
	}
	All = document.getElementsByTagName("textarea");
	Length = All.length;
	for(var I = 0; I < Length; I++)
	{
		All[I].disabled=true;
	}
}

///根据状态判断那些按钮不能用
function SetDisableButton(status,needsubmit)
{
	if (status==0)	
	{
		if (needsubmit)
		{
			DisableBElement("BCancelSubmit",true);
			DisableBElement("BAudit",true);
		}
	}
	else if (status==1)		//提交
	{	
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
	}
	else if (status==2)   //审核
	{
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BAudit",true);
	}
}

function GetRowByColName(colname)
{
	var offset=colname.lastIndexOf("z");
	var row=colname.substring(offset+1);
	return row;
}


function SetEQStyle()
{
	document.styleSheets[0].addImport("DHCEQStyle.css",0);	
	var All = document.getElementsByTagName( "INPUT" );
	var Length = All.length;
	for(var I = 0; I < Length; I++)
	{
		try
		{
			if (All[I].type!="checkbox")
			{
				//All[I].style.border="none";
				All[I].className="EQINPUT";
				//All[I].style.width="16px";
			}
		}
		catch(e)
		{}
	}
}
///"Opinion_"+Role+"_"+Step
function PageInsertRows(ElementName,ValList)
{
	if (ValList=="") return;
	var Rows=+GetElementValue("BeginInsertRow");
	var ColSpanNum=+GetElementValue("ColSpanNum");
	var tbl=GetParentTable(ElementName);
	if (tbl)
	{
		OneRecord=ValList.split("^");
		for(var i = 0;i < OneRecord.length;i++)
		{
			var Row1=Rows - 1 ;
			var Row2=Rows;
			tbl.insertRow(Row2);
			tbl.rows[Row2].insertCell();
			tbl.rows[Row2].insertCell();
			tbl.rows[Row2].cells[0].align="right";
			tbl.rows[Row2].cells[0].vAlign="top";
			tbl.rows[Row2].cells[1].colSpan=ColSpanNum;
			Rows=Rows + 1;
			var val=OneRecord[i].split(",");
			tbl.rows[Row1].cells[0].innerHTML="<label id='cOpinion_"+val[1]+"_"+val[0]+"'  Style='HEIGHT: 24px'>"+val[2]+"</label>";
			tbl.rows[Row1].cells[1].innerHTML="<textarea id='Opinion_"+val[1]+"_"+val[0]+"' name='Opinion_"+val[1]+"_"+val[0]+"' class='textareabox-text' style='WIDTH: 700px; '></textarea>";	//modified by czf 20181119
			DisableElement('Opinion_'+val[1]+"_"+val[0],true);
		}
		tbl.deleteRow(Row2)	//modified by czf 20181119 删除插入的多余的行
	}
	
}
function FillApprovedOpinion(ValList)
{
	ValList=ValList.replace(/\\n/g,"\n");
	var OneList=ValList.split("^");
	for (var i=0;i<OneList.length;i++)
	{
		var OneRecord=OneList[i].split(",");
		var Role=OneRecord[0];
		var Step=OneRecord[1];
		var Opinion=OneRecord[2];
		var ElementName="Opinion_"+Role+"_"+Step;
		SetElement(ElementName,Opinion);
	}
}
function InitStyle(ElementName,Type)
{
	var ApproveSet=GetElementValue("ApproveSetDR");
	if (ApproveSet=="") return;
	var encmeth=GetElementValue("GetApproveFlow");
	var ValList=cspRunServerMethod(encmeth,ApproveSet);
	PageInsertRows(ElementName,ValList);
	var ApproveRole=GetElementValue("CurRole");
	var CurStep=GetElementValue("RoleStep");
	DisableElement("Opinion_"+ApproveRole+"_"+CurStep,false);
	var RowID=GetElementValue("RowID");
	var encmeth=GetElementValue("GetApproveByResource");
	var ValList=cspRunServerMethod(encmeth,Type,RowID);
	FillApprovedOpinion(ValList);	
}
///得到excel表格内容
function GetExcelValue(xlsheet,x,y)
{
	var obj=xlsheet.cells(x,y).value
	if (!obj) return ""
	return obj;
}
///
function BElementDeclare()
{
	//BElement=new Array;
	BElement[0]="BAdd";
	BElement[1]="BUpdate";
	BElement[2]="BDelete";
	BElement[3]="BSubmit";
	BElement[4]="BCancelSubmit";
	BElement[5]="BAudit";
	BElement[6]="BBillAudit" ;//
	BElement[7]="BInAudit";
	BElement[8]="BOutAudit";
	BElement[9]="BBAudit";
}
function BElementEnableByVal(val)
{
	if (val=="") return;
	var vallist=val.split("^");
	var i=vallist.length;
	for (var j=0;j<i;j++)
	{
		DisableBElement(BElement[vallist[j]],true);
	}
}

///回车键弹出选择窗口调用Muilt_LookUp传一个串例如"BuyLoc^Loc"
///在装载事件写上Muilt_LookUp("BuyLoc^Loc")即可
function Muilt_LookUp(Value)
{
	var value=Value.split("^");
	var i=0;
	for (i=0;i<value.length;i++)
	{
		var obj=document.getElementById(value[i]);
		if (obj) obj.onkeydown=KeyDown_LookUp;
	}
}
function KeyDown_LookUp()
{
	if (event.keyCode==13)
	{
		var eSrc=window.event.srcElement;
		var lobj=document.getElementById(GetLookupName(eSrc.id));
		if (lobj) lobj.click();
	}
}


///回车转换为Tab键?只需在装载事件调用该函数  eName为表格上的一个项的名字
function EnterToTab(eName)
{
	var obj=GetParentTable(eName);
	if (obj) obj.onkeydown=EnterKeyDown;
}
function EnterKeyDown()
{
		if (window.event.keyCode==13){
		 window.event.keyCode=9;}
}


function EquipInfo(rowid)
{
	//encmeth="TU/PDV2jI8pqO3SK9WkkGcX46dIH7L3XI/6zBxvbxrxIfH0bEOipcF6QBSHKapF8"
	encmeth="o2YB2UDOqqtibndaU_BYQP_Wal76ZurUfgxUXRuiRMYp0VF0LiikK8/RzNcxGIDp"
	var result=cspRunServerMethod(encmeth,'','',rowid);	
	//alertShow('a'+result+'b');
	var list=result.split("^");
	var sort=EquipGlobalLen;
	this.Name=list[0];
	this.ABCType=list[1];
}

function GetEquipOBJ(rowid,methodElement)
{
	if (methodElement=="") methodElement="GetOneEquip";
	var encmeth=GetElementValue(methodElement);
	var result=cspRunServerMethod(encmeth,'','',rowid);	
	var list=result.split("^");
	var sort=EquipGlobalLen;
	this.Name=list[0];
	this.ABCType=list[1];
	this.UseLocDR=list[18];
	this.UseLoc=list[sort+7]
	this.KeeperDR=list[65];
	this.Keeper=list[sort+25];
	this.MaintUserDR=list[39];
	this.MaintUser=list[sort+19];
	///messageShow("","","",this.MaintUserDR+" "+this.MaintUser);
}

///Modified By JDL 20150820 GetSpellCode作废，统一使用GetPYCode
///Creator:Mozy
///Date:2009-03-19
/// 转换成拼音码(即拼音的第一个字母)
function GetSpellCode(strInput)
{  
	var rtnStr="-1"
	var DHCEQPYObj = new ActiveXObject("HZ2PY.PinYinZH")
	var rtnStr=DHCEQPYObj.GetChineseSpellCode(strInput);
	return rtnStr;
}


///Creator:Jdl
///Date:2009-04-20
///根据元素名字获取元素值
///ename:元素名字
///etype:元素类型 1:INPUT/TEXTAREA 2:CheckBox  3:LABEL	4:SELECT
function GetElementValueNew(ename,etype)
{
	var evalue="";
	var obj=document.getElementById(ename);
	if (!etype) etype=""

	if (obj)
	{
		//messageShow("","","",obj.tagName);
		//messageShow("","","",obj.type);
		//SetElement("Loc",obj.tagName);
		if ((etype=="1")||(etype=="4"))
		{	evalue=obj.value;}
		else if (etype=="2")
		{	evalue=obj.checked;}
		else if (etype=="3") 
		{	evalue=obj.innerText;}
		else if (etype=="")
		{	
			if (obj.tagName=="TEXTAREA")
			{	evalue=obj.value;}
			else if (obj.tagName=="INPUT")
			{				
				if (obj.type=="checkbox")
				{	evalue=obj.checked}
				else
				{	evalue=obj.value;}
			}
			else if (obj.tagName=="LABEL")
			{	evalue=obj.innerText}
			else if (obj.tagName=="SELECT")
			{	evalue=obj.value}
		}
	}
	return evalue;
}



///统一设置某种类型的元素的样式
///ElementType?元素类型?如?*,TH,label,TABLE,INPUT等
///ClassName:样式需要定义在DHCEQStyle.css
function SetItemStyle(ElementType,ClassName)
{
	var All = document.getElementsByTagName(ElementType);
	var Length = All.length;
	for(var I = 0; I < Length; I++)
	{
		//messageShow("","","",All[I].style.fontSize);
		//All[I].style.fontSize="24pt";
		All[I].className=ClassName;
	}
}

///统一设置某种类型的元素的字体
///ElementType?元素类型?如?*,TH,label,TABLE,INPUT等
///Size:字体尺寸
function SetItemFontSize(ElementType,Size)
{
	var All = document.getElementsByTagName(ElementType);
	var Length = All.length;
	for(var I = 0; I < Length; I++)
	{
		//messageShow("","","",All[I].style.fontSize);
		All[I].style.fontSize=Size;
		//All[I].className=ClassName;
	}
}


///Creator:Jdl
///Date:2009-08-14
///根据元素名字设置元素值
///ename:元素名字
///etype:元素类型 1:INPUT/TEXTAREA 2:CheckBox  3:LABEL	4:SELECT
function SetElementValueNew(ename,evalue,etype)
{
	var obj=document.getElementById(ename);
	if (!etype) etype=""

	if (obj)
	{
		//messageShow("","","",obj.tagName);
		//messageShow("","","",obj.type);
		//SetElement("Loc",obj.tagName);
		if ((etype=="1")||(etype=="4"))
		{	obj.value=evalue;}
		else if (etype=="2")
		{	obj.checked=evalue;}
		else if (etype=="3") 
		{	obj.innerText=evalue;}
		else if (etype=="")
		{	
			if (obj.tagName=="TEXTAREA")
			{	obj.value=evalue;}
			else if (obj.tagName=="INPUT")
			{				
				if (obj.type=="checkbox")
				{	obj.checked=evalue}
				else
				{	obj.value=evalue;}
			}
			else if (obj.tagName=="LABEL")
			{	obj.innerText=evalue}
			else if (obj.tagName=="SELECT")
			{	obj.value=evalue}
		}
	}
}
///修改:ZY 2009-10-26 ZY0013
///描述:获取机型录入方式 0:放大镜 1:手工录入,并自动检测更新机型表
///Creator:党军
///Date:2009-08-14
///根据元素名字设置元素值
function GetModelRowID(type,i)
{
	var ModelName="Model";
	var ModelDRName="ModelDR"
	var ItemDRName="ItemDR"
	if ((i)&&(i!=""))
	{
		ModelName="T"+ModelName+"z"+i;
		ModelDRName="T"+ModelDRName+"z"+i;
		ItemDRName="T"+ItemDRName+"z"+i;
	}	
	
	if (GetElementValue(ModelDRName)!="")
	{
		return GetElementValue(ModelDRName)
	}
	else
	{
		if ((type==0)||(type==""))  return "";
		var Model=GetElementValue(ModelName);
		var ItemDR=GetElementValue(ItemDRName);
		var encmeth=GetElementValue("UpdModel");
		if ((Model=="")||(ItemDR=="")) return "";
		var rtn=cspRunServerMethod(encmeth,Model,ItemDR);
		return rtn
	} 
}
///新增:ZY 2009-10-26 ZY0013
///描述:获取机型录入方式 0:放大镜 1:手工录入,并自动检测更新机型表
function GetManuFactoryRowID(type,i)
{		
	var ManuFactoryName="ManuFactory"
	var ManuFactoryDRName="ManuFactoryDR"
	if ((i)&&(i!=""))
	{
		ManuFactoryName="T"+ManuFactoryName+"z"+i;
		ManuFactoryDRName="T"+ManuFactoryDRName+"z"+i;
	}	
	
 	if (GetElementValue(ManuFactoryDRName)!="")
 	{
  		return GetElementValue(ManuFactoryDRName)
 	}
 	else
 	{
	 	if ((type==0)||(type==""))  return "";
	 	var ManuFactory=GetElementValue(ManuFactoryName);
	 	if (ManuFactory=="") return "";
	 	var FirmType=3
	 	var val=GetPYCode(ManuFactory)+"^"+ManuFactory+"^^^"+FirmType;	//modified by CZF0093 2020-03-17
	 	//var encmeth=GetElementValue("UpdManuFactory");
	 	var encmeth=GetElementValue("UpdProvider");
		var rtn=cspRunServerMethod(encmeth,val);
  		return rtn
 } 
}
///新增:ZY 2009-10-26 ZY0013
///描述:获取供应商录入方式 0:放大镜 1:手工录入,并自动检测更新供应商表 2:
function GetProviderRowID(type,i)
{
	var ProviderName="Provider"
	var ProviderDRName="ProviderDR"
	if ((i)&&(i!=""))
	{
		ProviderName="T"+ProviderName+"z"+i;
		ProviderDRName="T"+ProviderDRName+"z"+i;
	}	

	if (GetElementValue(ProviderDRName)!="")
	{
		return GetElementValue(ProviderDRName)
	}
	else
	{
	 	if ((type==0)||(type==""))  return "";
	 	var Provider=GetElementValue(ProviderName);
	 	if (Provider=="") return "";
	 	var ProviderHandler=""		//2013-01-14 DJ begin
	 	var ProviderTel=""
	 	var obj=document.getElementById("ProviderHandler");
	 	if (obj)
	 	{
		 	ProviderHandler=GetElementValue("ProviderHandler");
	 	}
	 	var obj=document.getElementById("ProviderTel");
	 	if (obj)
	 	{
		 	ProviderTel=GetElementValue("ProviderTel");
	 	}
	 	var FirmType=2	
	 	var val=GetPYCode(Provider)+"^"+Provider+"^"+ProviderHandler+"^"+ProviderTel+"^"+FirmType;	//modified by CZF0093 2020-03-17
	 	var encmeth=GetElementValue("UpdProvider");
		var rtn=cspRunServerMethod(encmeth,val);
  		return rtn
	}
}
///20150825  Mozy0163	存放地点
///描述:获取存放地点录入方式 0:放大镜 1:手工录入,并自动检测更新供应商表 2:
function GetLocationRowID(type,i)
{
	var LocationName="Location"
	var LocationDRName="LocationDR"
	if ((i)&&(i!=""))
	{
		LocationName="T"+LocationName+"z"+i;
		LocationDRName="T"+LocationDRName+"z"+i;
	}
	
 	if (GetElementValue(LocationDRName)!="")
 	{
  		return GetElementValue(LocationDRName)
 	}
 	else
 	{
	 	if ((type==0)||(type=="")) return "";
	 	var Location=GetElementValue(LocationName);
	 	if (Location=="") return "";
	 	var val=GetPYCode(Location)+"^"+Location;
	 	var encmeth=GetElementValue("UpdLocation");
		var rtn=cspRunServerMethod(encmeth,val);
  		return rtn
	} 
}



function TransDisableToReadOnly(tagName)
{	
	var All = document.getElementsByTagName(tagName);
	var Length = All.length;
	for(var I = 0; I < Length; I++)
	{
		if (All[I].disabled)
		{
			if ((All[I].type!="checkbox")&&(All[I].tagName!="A"))
			{			
				All[I].disabled=false;
				All[I].readOnly=true;
				//All[I].className= "EQReadOnlyINPUT";
			}
		}
	}	
}

function InitLast()
{
	TransDisableToReadOnly("*");
}

///add by jdl 2009-9-21
///增加日期文本框回车后弹出日期选择窗
///定义时,元素的onkeydown事件定义为此方法即可
function LookUpDate()
{
	if (event.keyCode==13)
	{
		var obj=window.event.srcElement
		if (!obj) return;
		var objID=obj.id;
		if (!IsValidDate(obj)) return;
		var url='websys.lookupdate.csp?ID='+objID+'&STARTVAL=';
		url += '&DATEVAL=' + escape(obj.value);
		var tmp=url.split('%');
		url=tmp.join('%25');
		websys_lu(url,1,'top=200,left=200,width=370,height=230');
		return websys_cancel();
	}
}

//如果有图标和元素在同一列里,要调整元素的宽度
function AdjustWidth(objwidth,offsetwidth)
{
  if (objwidth!="")
  {
  	 var objwidtharr=objwidth.split("px");
  	 var objwidthnum=objwidtharr[0];
  	 if (offsetwidth)
  	 {
	  	 objwidthnum=objwidthnum-offsetwidth;
  	 }
  	 else
  	 {
	  	 objwidthnum=objwidthnum-20;
	 }
  	 objwidth=objwidthnum+"px"
  }
	return objwidth
}

function ChangeRowStyleTest(RowObj)
{
	var html;
	for (var j=0;j<RowObj.cells.length;j++) 
	{
    	if (!RowObj.cells[j].firstChild) {continue} 
		var Id=RowObj.cells[j].firstChild.id;
		var arrId=Id.split("z");
		var objindex=arrId[1];
		var objwidth=RowObj.cells[j].style.width;
		var objheight=RowObj.cells[j].style.height;
		if (arrId[0]=="TEquip")
		{
         	html=CreatElementHtml(2,Id,objwidth,objheight,"","")
         	//messageShow("","","",html);
         	RowObj.cells[j].innerHTML=html;
		}
		else if (arrId[0]=="TUseYearsNum")
		{
			html=CreatElementHtml(1,Id,objwidth,objheight,"","")
         	//messageShow("","","",html);
         	RowObj.cells[j].innerHTML=html;
		}
		else if (arrId[0]=="TStatCat")
		{
			html=CreatElementHtml(4,Id,objwidth,objheight,"","ChangeTest","1^器械专用设备&2^器械一般设备")
         	//messageShow("","","",html);
         	RowObj.cells[j].innerHTML=html;
		}
	}
}

function ChangeTest()
{
	alertShow("Change");
}

/// add by lmm 2019-09-01
/// 描述:hisui界面实现回车下一个输入框 
/// 备注:文本框,下拉框,下拉列表,日期框,时间框中实现,大文本框不支持
/// modify by lmm 2020-06-29 去除lookup回车下一输入框事件
function Muilt_Tab()
{
	muilt_Tab()		
}

function KeyDown_Tab()
{
	if (event.keyCode==13)
	{
		window.event.keyCode=9
	}
}
///Function:Funds	2012-2-16 生成资金来源信息
///新增:2009-11-19 党军 DJ0036
///描述:获取当前列表中的当前行号
function GetTableCurRow()
{
	var eSrc=window.event.srcElement;
	if (!eSrc) return "";
	
	//Modified by jdl 2011-01-29 JDL0069
	if ((eSrc.tagName=="IMG")&&(eSrc.id==""))
	{
		var TDesc=eSrc.parentElement.id.split("z");
	}
	else
	{
		var TDesc=eSrc.id.split("z");		
	}	
	
	var currow=TDesc[TDesc.length-1];
	return currow
}

///Add by Mozy
///控制数字输入
function NumberPressHandler(e)
{
	try
	{
		keycode=websys_getKey(e);
	}
	catch(e)
	{
		keycode=websys_getKey();
	}
	if (((keycode>47)&&(keycode<58))||(keycode==46))
	{
	}else
	{
		window.event.keyCode=0;
		return websys_cancel();
	}
}

//检察是否为空 Type?1指向型  CName为提示信息
function CheckItemNull(Type,Name,CName)
{
	var CValue=GetCElementValue("c"+Name);
	if (CName!=""&&CName!=null) {var CValue=CName;}
	if (Type=="1") //含有DR
	{
		if ((GetElementValue(Name+"DR"))=="")
		{
			SetFocus(Name);		
			messageShow("","","",CValue+t[-4005]);
			return true;
		}
	}
	else
	{
		if ((GetElementValue(Name))=="")
		{
			SetFocus(Name);
			messageShow("","","",CValue+t[-4005]);
			return true;
		}
	}
	return false;
}
///Add by Mozy
///调到下一个焦点
function SetFocusColumn(ColName,Row)
{
	var obj=document.getElementById(ColName+"z"+Row);
	if (obj){websys_setfocus(ColName+"z"+Row)};
}

///Add by JDL 2010-8-9
///创建SourceType,SourceID信息对象
function SourceInfo(SourceType,SourceID)
{
	this.SourceType=SourceType;
	this.SourceID=SourceID;
}


function Standard_TableKeyUp()
{
	var eSrc=window.event.srcElement;
	if (!eSrc) return;
	var Id=eSrc.id
	var offset=Id.lastIndexOf("z");
	var index=Id.substring(offset+1);
	var colName=Id.substring(0,offset);	
	var obj=document.getElementById(colName+"DRz"+index);
	if (obj) obj.value="";	
}

///设置一串元素的只读属性
///names:元素名称串,以"^"分割
///value:只读为true,否则为false
function ReadOnlyElements(names,value)
{
	var nameList=names.split("^")
	for (i=0;i<nameList.length;i++)
	{
		ReadOnlyElement(nameList[i],value);
	}	
}

///新增:2010-05-23 党军
///描述:检测设备分类是否分类正确, 0:正确, -1:错误
function CheckEquipCat(EquipCatRowID)
{
	if (EquipCatRowID=="") return 0;
	var encmeth=GetElementValue("CheckEquipCat");
	var rtn=cspRunServerMethod(encmeth,EquipCatRowID);
	if (rtn=="") return -1;
	return rtn
}

///新增:2010-07-08 ZY
///modified by csj 2018-09-07 HIUSI动态隐藏datagrid输出列 Objtbl改为datagrid名称id
///描述:JS页面操作实现隐藏Table的列
///入参：Objtbl 组件名id
///      ColName 列名id
function HiddenTblColumn(Objtbl,ColName)
{
	$HUI.datagrid("#"+Objtbl).hideColumn(ColName);
}
///add by jdl 2010-7-15
///增加列表中日期文本框回车后弹出日期选择窗
///定义时,元素的onkeydown事件定义为此方法即可
///调用此函数时要定义?列名_lookupSelect(dateval)?事件和selectRow变量
function LookUpTableDate(vClickEventFlag)
{
	var eValue;
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		var obj=window.event.srcElement
		if (!obj) return;
		var objID=obj.id;
		var offset=objID.lastIndexOf("z");
		selectRow=objID.substring(offset+1);
		objID=objID.substring(0,offset);
		if(obj.tagName=="IMG")
		{
			objID=objID.substring(3,offset);
			obj=document.getElementById(objID+"z"+selectRow);
		}
		eValue=obj.value;
		if (!IsValidDate(obj)) return;
		var url='websys.lookupdate.csp?ID='+obj.id+'&STARTVAL=';	//需求号:262030 add by kdf 2016-09-28
		url += '&DATEVAL=' + escape(eValue);
		var tmp=url.split('%');
		websys_lu(url,1,'top=200,left=200,width=370,height=230');
		return websys_cancel();
	}
}

///add by zy 2010-7-15
///增加列表中日期文本框onchange事件
///定义时,元素的onchange事件定义为此方法即可
function TDate_changehandler(e) 
{
	var eSrc=websys_getSrcElement(e);
	if (!IsValidDate(eSrc)) {
		eSrc.className='clsInvalid';
		websys_setfocus(eSrc.id);
		return  websys_cancel();
	} 
	else 
	{
		eSrc.className='';
	}
}

///add by zy 2010-7-15
///增加列表中日期文本框onchange事件
///定义时,元素的onchange事件定义为此方法即可
function TTime_changehandler(e) 
{
	var eSrc=websys_getSrcElement(e);
	if (!IsValidTime(eSrc)) {
		eSrc.className='clsInvalid';
		websys_setfocus(eSrc.id);
		return websys_cancel();
	}
	else
	{
		eSrc.className='';
	}
}

///add by zy 2010-7-15
///增加列表中放大镜的赋值
function GetLookUpID_Table(ename,value)
{	
	var val=value.split("^");
	var obj=document.getElementById(ename);
	if (obj)	
	{
		obj.value=val[1];
	}
	else 
	{
		messageShow("","","",ename);
	}
	var offset=ename.lastIndexOf("z");
	var Index=ename.substring(offset+1);
	var ColName=ename.substring(0,offset-2);
	ename=ColName+"z"+Index
	var obj=document.getElementById(ename);
	if (obj)	
	{
		obj.value=val[0];
	}
	else 
	{
		messageShow("","","",ename);
	}
}

///修改:ZY 2010-08-27
///描述:获取凭证录入方式 0:放大镜 1:手工录入,并自动检测更新机型表
///Creator:zy
///Date:2010-08-27
///根据元素名字设置元素值
function GetCertificateRowID(type,i)
{
	var CertificateNo="Certificate";
	var CertificateDRName="CertificateDR"
	if ((i)&&(i!=""))
	{
		CertificateNo="T"+CertificateNo+"z"+i;
		CertificateDRName="T"+CertificateDRName+"z"+i;
	}	
	
	if (GetElementValue(CertificateDRName)!="")
	{
		return GetElementValue(CertificateDRName)
	}
	else
	{
		if ((type==0)||(type==""))  return "";
		var CertificateNo=GetElementValue(CertificateNo);
		var encmeth=GetElementValue("UpdCertificate");
		if (CertificateNo=="") return "";
		var rtn=cspRunServerMethod(encmeth,CertificateNo);
		return rtn
	} 
}
///add by zy 2010-7-28
///增加取listbox的值
///type: 1 value  2 text
function GetSelectedElementValue(name,type)
{
	var value="";
	var obj=document.getElementById(name);
	for (var i=0;i<obj.options.length;i++)
	{
		if (obj.options[i].selected!=true) continue;
		if (value!="") value=value+",";
		if (type==1)
		{	value=value+obj.options[i].value;}
		else
		{	value=value+obj.options[i].text;}
	}
	return value;
}
/// Add By DJ 2010-10-22
/// 描述:判断设备类组是否选择最末级
/// 返回值:0:否 1:是 2:非最末级时提示但不限制
function CheckEqCatIsEnd(CatID)
{
	if (CatID=="") return 1
	var encmeth=GetElementValue("CheckEqCatIsEnd");
	if (encmeth=="") return 1;
	var result=cspRunServerMethod(encmeth,CatID);
	return result
}

///Add By JDL 2011-03-10
///设备管理通用消息提示
function EQMsg(Desc,Code)
{
	var MsgInfo="";
	if (Desc!="") MsgInfo=Desc;
	if (MsgInfo!="")
	{
		MsgInfo=MsgInfo+"  详细:";
	}
	if (t[Code])
	{
		MsgInfo=MsgInfo+t[Code];
	}
	else
	{
		MsgInfo=MsgInfo+Code;
	}
	return MsgInfo;
}

///Add by jdl 2011-3-22
///判断是否为数字
///入参?NumStr验证的字符串
///		AllowEmpty:是否允许为空
///		AllowDecimal?是否允许小数
///		AllowNegative?是否允许负数
///		AllowZero:是否允许零
///	返回值?0:无效
///			1:有效
function IsValidateNumber(NumStr,AllowEmpty,AllowDecimal,AllowNegative,AllowZero)
{
	if (NumStr=="")
	{
		if (AllowEmpty=="1")
		{
			return "1";
		}
		else
		{
			return "0";
		}
	}
	if (isNaN(NumStr)) return "0";
	//判断是否负数
	if ((NumStr<0)&&(AllowNegative!="1")) return "0";
	//判断是否整数
	if ((parseInt(NumStr)!=NumStr)&&(AllowDecimal!="1")) return "0";
	if ((parseFloat(NumStr)==0)&&(AllowZero=="0")) return "0";
	return "1";	
}

///add by jdl 2011-7-13 
function ReplaceTitle(FromStr,ToStr)
{
	var All = document.getElementsByTagName( "label" );
	var Length = All.length;
	var ReplaceNum=0;
	if (FromStr=="") return;
	var FromList=FromStr.split("^");
	var FromLen=FromList.length;
	var ToList=ToStr.split("^");
	
	for(var I = 0; I < Length; I++)
	{
		if (All[I].id.indexOf("c")!=0) continue;
		var OldStr=All[I].innerText;
		///messageShow("","","",All[I].id);		
		for(var J = 0; J < Length; J++)
		{
			var NewStr=OldStr.replace(FromList[J],ToList[J]);
			if (NewStr!=OldStr)
			{
				All[I].innerText=NewStr;
				ReplaceNum=ReplaceNum+1;
			}
		}
	}
	
	var All = document.getElementsByTagName( "TABLE" );
	var Length = All.length;
	for(var K = 0; K < Length; K++)
	{
		if (!All[K]) continue;
		if (!All[K].tHead) continue;
		if (!All[K].tHead.children[0]) continue;
		var head=All[K].tHead.children[0];
		var Length=head.children.length;
		for(var I = 0; I < Length; I++)
		{
			///messageShow("","","",head.children[I].innerText);
			var OldStr=head.children[I].innerText;		
			for(var J = 0; J < Length; J++)
			{
				var NewStr=OldStr.replace(FromList[J],ToList[J]);
				if (NewStr!=OldStr)
				{
					head.children[I].innerText=NewStr;
					ReplaceNum=ReplaceNum+1;
				}
			}
		}
	}
	///messageShow("","","",ReplaceNum);
	return ReplaceNum;	
}



/// Add By HZY 2012-02-24 HZY0023
/// 描述:获取研究课题录入方式 0:放大镜选择模式 1:手工录入模式,并自动更新研究课题表 2:两种均可
function GetIssueRowID(type,i)
{
	var IssueName="Issue"
	var IssueDRName="IssueDR"
	if ((i)&&(i!=""))
	{
		IssueName="T"+IssueName+"z"+i;
		IssueDRName="T"+IssueDRName+"z"+i;
	}	

	if (GetElementValue(IssueDRName)!="")
	{
		return GetElementValue(IssueDRName)
	}
	else
	{
	 	if ((type==0)||(type==""))  return "";
	 	var Issue=GetElementValue(IssueName);
	 	if (Issue=="") return "";
	 	var val=GetPYCode(Issue)+"^"+Issue;
	 	var encmeth=GetElementValue("UpdIssue");
		var rtn=cspRunServerMethod(encmeth,val);
  		return rtn
	}
}

function GetLookupNameT(name)
{
	return "lt"+GetElementValue("GetComponentID")+"i"+name
}
/// Mozy0103	20130716
function GetFileNameToTXT()
{
	try 
	{
		// Scripting.FileSystemObject
		var xls = new ActiveXObject("Excel.Application");
		var fName = xls.GetSaveAsFilename("","文本文档(*.txt),*.txt");
		if (fName==false)
		{
			fName="";
		}
		return fName;
	}
	catch(e)
	{
		messageShow("","","",e.message);
		return "";
	}
}

/*
//var websys_windows=new Array();GR0026 新窗口打开模态窗口
function websys_createWindow(url, wname, features) {
	if ((url.indexOf("websys.csp?")==0)&&(websys_locked())) url+="&TLOCKED=1";
	if (typeof features != 'undefined') {
		features=features.toUpperCase();
		if (features.indexOf('STATUS=')==-1) features="status,"+features;
		if (features.indexOf('SCROLLBARS=')==-1) features="scrollbars,"+features;
		if (features.indexOf('RESIZABLE=')==-1) features="resizable,"+features;
	}
	if (url.indexOf("DHCEQMWindow=1")>0)
	{
		var scrWidth = screen.availWidth; var scrHeight = screen.avaiHeight; 
		window.showModalDialog(url,'',"dialogWidth=" + scrWidth + ";dialogHeight="+ scrHeight);
		
		location.reload();
	}
	else
	{		
		websys_windows[wname]=window.open(url, wname, features);
		websys_windows[wname].focus();
		return websys_windows[wname];
	}
}
*/


///Add By JDL 20150820 JDL0139
///描述:根据组件定义中的元素的数据类型，进行判断元素值是否有效。
///		当前处理了Float类型的数据。	
///		返回值：true有非法，false无非法数据
function CheckItemValueIllegal()
{	
	var GetItemDataTypeInfo=GetElementValue("GetItemDataTypeInfo");
	if (GetItemDataTypeInfo!="")
	{
		var ItemInfos=GetItemDataTypeInfo.split('&');
		for (var i=0;i<ItemInfos.length;i++)
		{
			var ItemInfo=ItemInfos[i];
			if (ItemInfo!="")
			{
				var Item=ItemInfo.split('=');
				var ItemName=Item[0];
				var DataType=Item[1];
				//目前仅验证数字的有效性
				if (DataType.indexOf("Float")>=0)
				{
					var Value=GetElementValue(ItemName);
					if ((Value!="")&&(isNaN(Value)))
					{
						var CValue=GetCElementValue("c"+ItemName);
						if (""==CValue) CValue=ItemName;
						SetFocus(ItemName);
						messageShow("","","",t[-4008]+CValue+"!");
						return true;
					}
				}
			}
		}
	}	
	return false;	
}

//add By HHM 2015-08-24 HHM0001
///描述:弹出窗口设置大小
///modify by lmm 2018-07-30
///增加入参：vtitle 弹框标题  
function SetWindowSize(url,vDefaultFlag,vWidth,vHeight,vTop,vLeft,vtitle,vModal,vIsTopZindex,vContent)
{
	//add by lmm 2018-07-30 begin
	if (1==vDefaultFlag)
	{
		///modified by zy 2018-12-26 ZY0182
		if ((vWidth=="")||(typeof(vWidth)=="undefined")) var vWidth=window.screen.width*0.7;         //弹出窗口的宽度;
		if ((vHeight=="")||(typeof(vHeight)=="undefined")) var vHeight=window.screen.height*0.7;      //弹出窗口的高度;
		if ((vtitle=="")||(typeof(vtitle)=="undefined"))  var vtitle="固定资产系统"
	}
	//modify by lmm 2018-12-12 begin
	var icon="icon-w-paper"
	var showtype="modal"
	showWindow(url,vtitle,vWidth,vHeight,icon,showtype)  
	//modify by lmm 2018-12-12 end
	/*
	if (vModal=="")  //true
	{
		if (vtitle=="")  var vtitle="_blank"
		//var features="toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes"
		//websys_createWindow(url,vtitle,features)
		websys_lu(url,false,'width=1080,height=650,left=130,top=3,hisui=true')
		//websys_lu(url,false,'width='+vWidth+',height='+vHeight+',left=130,top=3,hisui=true')
	}
	else
	{
		var options={
				url:url,
				title:vtitle,
				width:vWidth,
				height:vHeight,
				modal:vModal,
				content:vContent,
				isTopZindex:false,
				iconCls:'icon-w-paper'   //modify by lmm 2018-11-19
			}		
		websys_showModal(options);
	}
	//add by lmm 2018-07-30 end
	*/
	
	
	
	
	
	
	
	
  	//var vTop = (window.screen.height-30-vHeight)/2;       //获得窗口的垂直位置;
	//var vLeft = (window.screen.width-10-vWidth)/2;        //获得窗口的水平位置;
}

function GetTableName()
{
	var TableName="";
	var All = document.getElementsByTagName( "TABLE" );
	var Length = All.length;
	for(var K = 0; K < Length; K++)
	{
		if (All[K].id!="")
		{
			TableName=All[K].id;
			break;
		}
	}
	return TableName;
}

///Add By DJ 2016-07-21
///描述:获取品牌录入方式 0:放大镜 1:手工录入,并自动检测更新供应商表 2:
function GetBrandRowID(type,i)
{
	var BrandName="Brand"
	var BrandDRName="BrandDR"
	if ((i)&&(i!=""))
	{
		BrandName="T"+BrandName+"z"+i;
		BrandDRName="T"+BrandDRName+"z"+i;
	}
	
 	if (GetElementValue(BrandDRName)!="")
 	{
  		return GetElementValue(BrandDRName)
 	}
 	else
 	{
	 	if ((type==0)||(type=="")) return "";
	 	var Brand=GetElementValue(BrandName);
	 	if (Brand=="") return "";
	 	var val=GetPYCode(Brand)+"^"+Brand;
	 	var encmeth=GetElementValue("UpdBrand");
		var rtn=cspRunServerMethod(encmeth,val);
  		return rtn
	} 
}
/**
*拆分一组字符串
*2017-07-19
*JYP
*可以将AKB222,AKB235~40拆分为AKB222,AKB235，AKB236，AKB237，AKB238，AKB239，AKB240
*入参：String：要拆分的字符串   
*      StringSeparator：字符串分割符
*      BreakUpSeparator:拆分字符串分割符
*返回值：StringNew：拆解后的字符串组
**/
function StringBreakUp(String,StringSeparator,BreakUpSeparator)
{	
	var List=String.split(StringSeparator);                                   //将字符串按StringSeparator分割开
	var BreakList=""
	var StringNew=""
	for(
			var i=0;i<=List.length-1;i++){
			var listStart=List[i].split(BreakUpSeparator);                      //将分割后的每一个字符串再按照BreakUpSeparator分割开
			var listBegin=listStart[0];                                         //被拆分的字符串的开始部分
			var listEnd=listStart[1];                               			//被拆分的字符串的结束部分
			if((listStart.length>1)){                                           //判断分割后的字符串如果有两段进入拆分程序	
				var BreakList=BreakUp(listBegin,listEnd,StringSeparator);
				if (BreakList=="")                                              //拆分不成功返回拆分前的格式
				{
					BreakList=ConnectionString(listBegin,listEnd,BreakUpSeparator);
				}	
				StringNew=ConnectionString(StringNew,BreakList,StringSeparator);
		    }
		    else
		    {
				StringNew=ConnectionString(StringNew,List[i],StringSeparator);
			}
		}
	return StringNew
}
/**
*拆分一组字符串
*2017-04-15
*JYP
*将两个符合相应规则的字符串(ack35,40)拆解成一组字符串(ack35,ack36,ack37,ack38,ack39,ack40)
*入参：StringBefore：拆解前的起始字符串   
*      StringAfter：拆解前的结束字符串
*返回值：String：拆解后的字符串组
**/
function BreakUp(StringBefore,StringAfter,StringSeparator)
{	
	var StringStart=StringBefore.substr(StringBefore.length-StringAfter.length)       //开始字符
	var Stringprefix=StringBefore.substr(0,StringBefore.length-StringAfter.length)    //前缀
	var ListString=""                                                                 //拆分后的每个字符串
	var String=""
	for(var j=0;j<=StringAfter-StringStart;j++){
		ListString=parseInt(StringStart)+j;
		ListString=ListString.toString()
		for(var k=ListString.length;k<StringAfter.length;k++){
			ListString="0"+ListString                                                 //字符串转换后补零
		}
        String=ConnectionString(String,Stringprefix+ListString,StringSeparator)
	}
	return String
}
/**
*连接两个字符串
*2017-04-15
*JYP
*将两个字符串加分割连接成一个字符串，
*入参：StringBefore：在前的字符串(StringA)
*      StringAfter：在后的字符串(StringB)
*      Separator：分隔符(,)
*返回值：AfterConnectionString：连接后的字符串(StringA,StringB)
**/
function ConnectionString(StringBefore,StringAfter,Separator)
{	
    var AfterConnectionString
	if(StringBefore=="")
	{
		AfterConnectionString=StringAfter
	}
	else
	{
		AfterConnectionString=StringBefore+Separator+StringAfter
	}
   return AfterConnectionString
}

/**
*2018-06-26
*lmm
*设置下拉列表必填项
**/
function SetComboboxRequired(Names)
{
	if ((Names!="")&&(Names!=undefined))		//modified by czf 20181101
	{
		var name=Names.split("^")
		for (var i=0;i<name.length;i++)
		{
			var Requireflag=$("#c"+name[i]).find("span").html()
			if (Requireflag="*")
			{
				$("#"+name[i]).attr("data-required",true).attr("title","必填项");
			}
		}
	}
	else{
		$('.hisui-combobox').each(function(ind,item){
			var id = $(this).attr("id");
			if (id!="")
			{
				var Requireflag=$("#c"+id).find("span").html()
				if (Requireflag="*")
				{
					$("#"+id).attr("data-required",true).attr("title","必填项");
				}
			}
			
		});
	}
}

//modify by lmm 2018-07-25
function ReadOnlyElement(name,value)
{
	
	var obj=document.getElementById(name);
	if (obj)
	{
		disableElement(name,value)
	}
}
///替换首字母方法 开始行
function DisableElement(name,value)   
{
	disableElement(name,value)
}


//modify by lmm 2018-02-01
//type:class  按钮：checkbox:hisui-checkbox 多行输入框：textarea:textareabox-text hidden
//            下拉框：text:combogrid-f/datebox-f/hisui-validatebox validatebox-text// 
///modify by lmm 2020-06-29 组件增加放大镜回车赋值后进入下一输入框
function SetElement(vElementID,vValue)
{
	setElement(vElementID,vValue)
	var event = window.event||event
	//modify by lmm 2020-07-01
	if(event)
	{
		var keyCode=event.which||event.keyCode
		if (keyCode==13)
		{
			var vElementID=String(vElementID)
			if(vElementID.lastIndexOf("_")>=0)
			{
				var vElementID=$("#"+vElementID.substr(0,vElementID.lastIndexOf("_"))).attr("id")	
			}		
			else if ($("#"+vElementID.substr(0,vElementID.length-2)).attr("id")!=undefined)
			{
				var vElementID=$("#"+vElementID.substr(0,vElementID.length-2)).attr("id")
			}
			lookuptab(vElementID)
			tabflag=1
		}
	}
	
	
	
	/*
	var result=""
	var obj=document.getElementById(vElementID);
	if (obj)
	{
		var objType=jQuery("#"+vElementID).prop("type")
		var objClassInfo=jQuery("#"+vElementID).prop("class")
		
		//alertShow("vElementID"+vElementID+"objType"+objType+"objClassInfo"+objClassInfo)
		if (objType=="checkbox")
		{
			if ((vValue=="1")||(vValue==true)||(vValue=="Y"))
			{
				jQuery("#"+vElementID).checkbox("setValue",true);  
			}
			if ((vValue=="0")||(vValue==false)||(vValue=="N")||(vValue==""))
			{
				jQuery("#"+vElementID).checkbox("setValue",false);
			}
		}
		else if (objType=="select-one")
		{
			//jQuery("#"+vElementID).combobox("setText",vValue);
			jQuery("#"+vElementID).combobox("setValue",vValue);
			//alertShow("ss"+jQuery("#"+vElementID).combobox("getValue"))
		}
		else if (objType=="text")
		{
			
			if (objClassInfo.indexOf("combogrid")>=0)   //combogrid
			{
				jQuery("#"+vElementID).combogrid('setText',vValue);
				jQuery("#"+vElementID).combogrid('setValue',vValue); 
			}
			else if (objClassInfo.indexOf("datebox-f")>=0)
			{
				jQuery("#"+vElementID).datebox('setValue',vValue)  
			}
			else if (objClassInfo.indexOf("combobox")>=0)
			{
				jQuery("#"+vElementID).combobox('setValue',vValue);
			}
			//else if (objClassInfo.indexOf("lookup")>=0)
			//{
				//alertShow("aaa:"+vValue)
				//jQuery("#"+vElementID).lookup('setText',vValue);
				//jQuery("#"+vElementID).lookup('setValue',vValue);
			//}
			else
			{
				//alertShow("vValue"+vValue)
				jQuery("#"+vElementID).val(vValue)  
			}
			
		}
		else  //hidden areatext
		{
			//add by lmm 2018-07-20 begin
			if (objClassInfo.indexOf("linkbutton")>=0)
			{
				jQuery("#"+vElementID).linkbutton({text:vValue})
			}
			else
			{
				jQuery("#"+vElementID).val(vValue)  
			}
			//add by lmm 2018-07-20
		}
	}*/
}

//modify by lmm 2018-02-01
function GetElementValue(vElementID)
{
	return getElementValue(vElementID)
	/*
	var result=""
	var obj=document.getElementById(vElementID);
	if (!obj) return ""
	var objType=jQuery("#"+vElementID).prop("type")  //prop
	//alertShow("vElementID"+vElementID+"objType"+objType+"objClassInfo"+objClassInfo)
	var objClassInfo=jQuery("#"+vElementID).prop("class")
	//下拉列表标签判断
	var tabs = document.getElementsByTagName( "select" );
	var Length = tabs.length;	
	
	if (objType=="checkbox")
	{
		//result=jQuery("#"+vElementID).is(':checked')
		result=jQuery("#"+vElementID).checkbox("getValue",true);
	}
	else if (objType=="select-one")
	{
		//alertShow("objClassInfo"+objClassInfo+"^vElementID"+vElementID+"objType"+objType)
		result=jQuery("#"+vElementID).combobox("getValue");
		//alertShow("resultGET"+result)
	}
	else if (objType=="text")
	{
		//var objClass=objClassInfo.split(" ")
		//var objType=objClass[0].split("-")
		if (objClassInfo.indexOf("combogrid")>=0)
		{
			result=jQuery("#"+vElementID).combogrid("getText");
		}
		else if (objClassInfo.indexOf("datebox-f")>=0)
		{
			result=jQuery("#"+vElementID).datebox('getText');
		}
		else if (objClassInfo.indexOf("combobox")>=0)
		{
			result=jQuery("#"+vElementID).combobox("getValue");
		}
		else
		{
			result=jQuery("#"+vElementID).val()
				
		}
		
	}
	else  //textarea,text,hidden
	{
			result=jQuery("#"+vElementID).val()
		

	}
	return result*/
}
function CheckMustItemNull(Strs)
{
	return checkMustItemNull(Strs)
}
///获取该元素所在的Table
function GetParentTable(ename)
{
	return getParentTable(ename)
}

///Add by JDL 2010-8-3
///Show or hide object
///objID:
///hidden: 0 show ,  1 hidden
function HiddenObj(objID,hidden) 
{
	hiddenObj(objID,hidden)
}

/// 20150918  Mozy0166	隐藏表格图标，多用于隐藏合计行图标
/// ComponentName:	组件名
/// val:	对应元素值为空则隐藏该图标
/// Item:	图标所在的元素名
//modify by lmm 2018-02-01
function HiddenTableIcon(ComponentName,val,Item)
{  
	hiddenTableIcon(ComponentName,val,Item)
	
}
///设置控件焦点
function SetFocus(Name)
{
	setFocus(Name)
}

///Add By DJ 2015-08-17 DJ0156
///描述:设置前台页面记录显示背景色
//modify by lmm 2018-02-01
function SetBackGroupColor(vComponentTableName)
{ 
	setBackgroundColor(vComponentTableName)
}
///Modified By JDL 20150820 GetSpellCode作废，统一使用GetPYCode
/// 取消用动态库转换拼音码，调用后台方法，生成拼音码
///-------------------------------------------------
///新增:ZY 2009-10-26 ZY0013
///转换成拼音码
function GetPYCode(strInput)
{
	return getPYCode(strInput)
}


///需要在组件上定义GetColCaption?s val=##Class(%CSP.Page).Encrypt($lb("web.DHCEQCommon.GetColumnCaption"))
///					GetComponentID?s val=##class(web.DHCEQCommon).GetComponentID("DHCEQInStockNew")
function GetColCaption(colName)
{
	return getColCaption(colName)
}
function InitMessage(vBuss)
{
	t[0]="操作成功";
	//-1到-500为SQL Error Code
	t[-104]="有无效字段,无法插入数据!";
	t[-105]="有无效字段,无法更新数据!";
	//-10000到-12000为SQL Error Code
	
	//-1001到-1999为操作类返回失败代码?定义在message中
	//-2001到-2999为操作类返回失败代码?为通用代码定义在这里
	t[-2001]="无法找到该记录!";
	t[-2002]="该记录尚未提交,无法审核!";
	
	t[-2005]="该设备已经报废,不能操作!";	
	
	t[-2011]="该记录已经提交,无法修改!";
	t[-2012]="该记录已经提交,无法删除!";
	t[-2013]="该记录不能提交,请检查状态!";
	t[-2014]="该记录不是提交状态,不能取消提交!";
	
	t[-2015]="该记录状态不符合,不能执行操作!";
	
	t[-2021]="该记录已经审核,无法修改!";
	t[-2022]="该记录已经审核,无法删除!";
	t[-2023]="该记录已经审核,不能再审核!";
	
	t[-2101]="不能操作,请检查该记录状态!";
	t[-2102]="请先配置好单号生成规则!"

	t[-2200]="操作成功!";
	t[-2201]="操作失败!";
	t[-2210]="更新操作成功!";
	t[-2211]="更新操作失败!";
	t[-2220]="提交操作成功!";
	t[-2221]="提交操作失败!";
	t[-2230]="审批操作成功!";
	t[-2231]="审批操作失败!";
	t[-2240]="取消提交操作成功!";
	t[-2241]="取消提交操作失败!";
	//-3001到-3999为页面处理提示代码?定义在message中
	//-4001到-4999为页面处理提示代码?为通用代码定义在这里
	t[-4001]="没有设置处理方法!";
	t[-4002]="请选择要操作的记录!";
	t[-4003]="您确认要删除该记录吗?";
	t[-4004]="请先选择设备!";
	t[-4005]="不能为空!";
	t[-4006]="特殊设备不唯一,不能提交"
	t[-4007]="没有审批设置"
	t[-4008]="请输入有效的"
	initMessage(vBuss)
}
///add by lmm 2018-09-12
///描述：按钮文字重新赋值
function setButtonText(vExcludesids)
{
	
	$(".hisui-linkbutton").each(function(){
		var id=$(this).attr("id");
		if ((","+vExcludesids+",").indexOf(","+id+",")==-1)
		{
			if (getValueById(id)=="增加")
			{
				jQuery("#"+id).linkbutton({text:"新增"})	
			}
			else if ((getValueById(id)=="修改")||(getValueById(id)=="更新"))
			{
				jQuery("#"+id).linkbutton({text:"保存"})	
			}
			//add by lmm 2019-11-22 begin LMM0050	
			else if (getValueById(id)=="取消提交")
			{
				jQuery("#"+id).linkbutton({text:"退回"})	
			}	
			//add by lmm 2019-11-22 end LMM0050	
		}	

		
	})
}
///add by lmm 2018-09-18
///描述：根据单据状态设置按钮灰化
///入参：status：单据状态 0：新增 1：提交 2：审核 空为未建单据
///modify by lmm 2018-10-23 新增单据不隐藏删除按钮
function hideButton(status)
{
	
	if (status=="")
	{
		hiddenObj("BAudit",1);
		hiddenObj("BCancelSubmit",1);
		hiddenObj("BCancel",1); 
		hiddenObj("BDelete",1);	
		hiddenObj("BSubmit",1); 
	}
	else if (status==0)
	{
		hiddenObj("BAudit",1);
		hiddenObj("BCancelSubmit",1);
		hiddenObj("BCancel",1); 	
	}
	else if (status==1)
	{
		hiddenObj("BSubmit",1); 
		hiddenObj("BUpdate",1);
		hiddenObj("BDelete",1);	
	}
	else if (status==2)
	{
		hiddenObj("BCancelSubmit",1);
		hiddenObj("BAudit",1);
		hiddenObj("BSubmit",1); 
		hiddenObj("BUpdate",1);
		hiddenObj("BDelete",1);	
		
	}
	
}

/*
 * description 人员、科室统一转换;需要用到session转换的组件增加GetSessionIDByMap元素
 * param type session值类型 sessionID:session值id
 * author zouxuan 2018-08-13
 * return 组内对照表id
*/
function getSessionIDByMap(type,sessionID)
{
	var result=tkMakeServerCall("web.DHCEQCommon","getMapIDBySource",type,sessionID)
	return result;
}

/*
 * description 判断Str是否在Strs里面 在true 否false
 * add by czf 20181211
*/
function StrIsInStrs(Strs,Str,Split)
{
	var OneStr="";
	var StrArray=Strs.split(Split);
	var i=StrArray.length;
	for (var j=0;j<i;j++)
	{
		OneStr=StrArray[j];
		if (OneStr==Str) return true;
	}
	return false;
}

/*
 * 设置edittile的表格margin-bottom属性为8px
 * add by czf 20181211
*/
function SetTableMarginbottom()
{
	$('td[class="edittitle"]').each(function(){
		var obj = $(this);
		var tabobj=obj.closest("table");
		if(tabobj){
			tabobj.attr('style','margin-bottom:8px;')
		}
	})
}
//"1:YYYY-MM-DD"
//"11:YYYY年MM月DD日"
//"12:dd/mm/yyyy"
//"2:0.00"
//"3:短名称根据-截取
//"4:文本格式?主要处理如设备编号等科学记数法显示的问题?
function ColFormat(val,format)
{
	if (format=="1")
	{
		return FormatDate(val,"","");
	}
	else if (format=="2")
	{
		val=val*100;
		val=Math.round(val,2);
		val=val/100;
		val=val.toFixed(2);
		return val;
	}
	else if (format=="3")
	{
		val=GetShortName(val,"-");
		return val;
	}
	else
	{
		return val
	}
	
}