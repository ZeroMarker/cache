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
var Guser,usercode,username
var EquipGlobalLen=95; //2009-11-16 党军 DJ0035
var errcode=1000;
var BElement   //=new array;

//Modified by JDL 修改样式表引用
//document.styleSheets[0].addImport("DHCEQStyle.css",0);
document.write("<LINK REL='stylesheet' TYPE='text/css' HREF='../scripts/DHCEQStyle.css'></LINK>")

function InitUserInfo()
{
	Guser=session['LOGON.USERID'];
	usercode=session['LOGON.USERCODE'];
    username=session['LOGON.USERNAME'];
    BElement=new Array;
    BElementDeclare();
    InitMessage();
    GetDisabledElement();
    //菜单名传递
    var obj=document.getElementById("GetMenuName");
    if (obj)
    {
	    var GetMenuName=GetElementValue("GetMenuName")
	    var obj=document.getElementById("cEQTitle");
	    if ((obj)&&(GetMenuName!=""))
	    {
		    SetCElement("cEQTitle",GetMenuName)
	    }
    }    
}

function InitMessage()
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
}

function EQCommon_HiddenElement(name)
{
	var obj=document.getElementById(name);
	if (obj){	obj.style.visibility="hidden";}
}

function DisableElement(name,value)
{
	var obj=document.getElementById(name);
	if (obj){
		obj.disabled=value;	
		//SetEnableStyle(obj,value);	
		}
}

function SetEnableStyle(obj,value)
{
	if (obj){
		if (obj.type=="checkbox") return;//disabledField
		obj.className= (value==true)?"EQDisabledINPUT":"EQEnabledINPUT";		
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

function DisableBElement(name,value)
{
	var obj=document.getElementById(name);
	if (obj){
		obj.disabled=value;
		obj.className= (value==true)?"EQDisabledBUTTON":"i-btn";		//Add By DJ 2016-09-13
		if (value)	{obj.onclick=LinkDisable;}
		}
}

function LinkDisable(evt) {
}

function SetElement(ename,evalue)
{
	/*
	var obj;
	obj=document.getElementById(ename);
	if (obj)	{	obj.value=evalue;	}
	*/
	SetElementValueNew(ename,evalue,"")
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
	if (obj)	{	obj.innerText=evalue;	}
}

function SetChkElement(ename,evalue)
{
	var obj;
	obj=document.getElementById(ename);
	if (obj)	
	{	
		if (evalue==1) 
			{obj.checked=1;	}
		else
			{obj.checked=0;	}
	}
}

function GetElementValue(ename)
{
	/*
	var obj,evalue;
	evalue="";
	obj=document.getElementById(ename);
	if (obj)
	{
		evalue=obj.value;
		//if (evalue==null)  evalue=obj.innerText;
	}
	return evalue;
	*/
	var evalue=GetElementValueNew(ename,"")
	return evalue;
}

function GetCElementValue(ename)
{
	var obj,evalue;
	evalue="";
	obj=document.getElementById(ename);
	if (obj)
	{
		evalue=obj.innerText;
		//if (evalue=="") evalue=obj.value;
	}
	return evalue;
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

function GetLookUpID(ename,value)
{
	var val=value.split("^");
	var obj=document.getElementById(ename);
	if (obj)	{	obj.value=val[1];}
	else {alert(ename);}		
}

function Standard_KeyUp()
{
	var eSrc=window.event.srcElement;
	var objDR=document.getElementById(eSrc.id+"DR");
	objDR.value="";	
}


function KeyUp(Value,showmsg)
{
	var value=Value.split("^")
	var i=0;
	for (i=0;i<value.length;i++)
	{
		var obj=document.getElementById(value[i]);
		if (obj) {obj.onchange=Standard_KeyUp;}
		else{
			if (showmsg!="N") alert(value[i])}
	}
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

function CheckMustItemNull(Strs)
{
	var All = document.getElementsByTagName( "label" );
	var Length = All.length;
	var BReturn=false;
	for(var I = 0; I < Length; I++)
	{
		if (All[I].className=="clsRequired")
		{
			var Name=All[I].id.substr(1);
			if (Strs!=null)
			{
				if (StrIsInStrs(Strs,Name,"^")) continue;
			}
			var obj=document.getElementById(Name+"DR");
			if (obj)
			{
				var BReturn=CheckItemNull("1",Name);
				if (!BReturn) BReturn=CheckItemNull("2",Name);
			}
			else
			{
				var BReturn=CheckItemNull("2",Name);
			}
		}
		if (BReturn) break;
	}
	
	///Add By JDL 20150820 JDL0139 在验证必填项时，增加验证数字类型数据的有效性
	if (!BReturn)
	{
		BReturn=CheckItemValueIllegal();
	}
	
	return BReturn;
}

//检察是否为空 Type?1指向型  CName为提示信息
function CheckItemNull(Type,Name,CName)
{
	var CValue=GetCElementValue("c"+Name);
	if (CName!=""&&CName!=null) {var CValue=CName;}
	if (Type=="1") //含有DR
	{
		if (trim(GetElementValue(Name+"DR"))=="")
		{
			SetFocus(Name);
			alert(CValue+t[-4005]);
			return true;
		}
	}
	else
	{
		if (trim(GetElementValue(Name))=="")
		{
			SetFocus(Name);
			alert(CValue+t[-4005]);
			return true;
		}
	}
	return false;
}
///设置控件焦点
function SetFocus(Name)
{
	try
	{
		var obj=document.getElementById(Name)
		if (obj) obj.focus()
	}
	catch(e)
	{
		//alert(e.message)
	}
}
///去掉两端空格
function trim(s)
{ 
	return s.replace(/(^\s*)|(\s*$)/g, ""); 
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

function GetCurrentDate()
{
   var d, s="";           
   d = new Date();                           // 创建对象Date
   s += d.getDate() + "/";                   // 获取日
   s += (d.getMonth() + 1) + "/";            // 获取月份
   s += d.getYear();                         // 获取年份
   return(s);                                // 返回日期
}
function GetRowByColName(colname)
{
	var offset=colname.lastIndexOf("z");
	var row=colname.substring(offset+1);
	return row;
}

/*****************************************************
取指定对象的x坐标
*****************************************************/
function getx(e){
  var l=e.offsetLeft;
  while(e=e.offsetParent){
    l+=e.offsetLeft;
    }
  return(l);
  }
/*****************************************************
取指定对象的y坐标
*****************************************************/
function gety(e){
  var t=e.offsetTop;
  while(e=e.offsetParent){
    t+=e.offsetTop;
    }
  return(t);
  }

///获取该元素所在的Table
function GetParentTable(ename)
{
	var obj=document.getElementById(ename);
	if (!obj) return null;
	while(obj!=null)
	{
		obj=obj.parentElement;
		if ((obj)&&(obj.tagName.toUpperCase()=="TABLE")) return obj;
	}
	return null;
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
			tbl.rows[Row1].cells[1].innerHTML="<textarea id='Opinion_"+val[1]+"_"+val[0]+"' name='Opinion_"+val[1]+"_"+val[0]+"' style='WIDTH: 740px; HEIGHT: 40px'></textarea>";
			DisableElement('Opinion_'+val[1]+"_"+val[0],true);
		} 
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
///得到保存文件路径  Add 2007-01-11
function GetFileName()
{
	try 
	{
		var xls = new ActiveXObject("Excel.Application");   
		var fName = xls.GetSaveAsFilename("","Excel File(*.xls),*.xls")
		if (fName==false)
		{
		 fName=""
		}
		return fName
	}
	catch(e)
	{
		/*
		alert("name: " + e.name + 
		"description:"+e.description+
    "message: " + e.message + 
    "lineNumber: " + e.lineNumber + 
    "fileName: " + e.fileName + 
    "stack: " + e.stack);
    */
		alert(e.message);
		return "";
	}
}
///把18/01/2007转为2007年1月18日
function ChangeDateFormat(DateStr)
{
	if (DateStr=="") return "";
	var DateList=DateStr.split("/");
	var NewDateStr=DateList[2]+"年"+DateList[1]+"月"+DateList[0]+"日";
	return NewDateStr;
}

///把18/01/2007转为2007年1月18日
function FormatDate(DateStr,FromFormat,ToFormat)
{
	if (DateStr=="") return "";
	var year,month,day		
	var DateList=DateStr.split("/");
	year=DateList[2];
	month=DateList[1];
	day=DateList[0]
	if(year.length==2) year="19"+year;
	var NewDateStr=year+"-"+month+"-"+day;
	return NewDateStr;
}

///Modified by JDL 2009-06-4  JDL0011
/// 按照指定分隔符?截取后半段字符,重新编写?处理含有多个分割符的情况
///把"xyk-西药库"转为"西药库"
function GetShortName(NameStr,SplitStr)
{
	var strnew=""
	var list=NameStr.split(SplitStr)
	for (var i=0;i<list.length;i++)
 	{
	 	var mid=list.length/2;
	 	mid=parseInt(mid);
	 	if (i>mid-1)
	 	{
		 	if (""!=strnew) strnew=strnew+SplitStr;
		 	strnew=strnew+list[i]
		}
 	}
	return strnew;
}

///判断Str是否在Strs里面 在true 否false
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

function IncludeJs($script){
   var script = document.createElement('script');
   script.src = "../scripts/" + $script;
   script.type = 'text/javascript';
   var head = document.getElementsByTagName('head').item(0);
   head.appendChild(script);
}


function EquipInfo(rowid)
{
	//encmeth="TU/PDV2jI8pqO3SK9WkkGcX46dIH7L3XI/6zBxvbxrxIfH0bEOipcF6QBSHKapF8"
	encmeth="o2YB2UDOqqtibndaU_BYQP_Wal76ZurUfgxUXRuiRMYp0VF0LiikK8/RzNcxGIDp"
	var result=cspRunServerMethod(encmeth,'','',rowid);	
	alert('a'+result+'b');
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
	///alert(this.MaintUserDR+" "+this.MaintUser);
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
		//alert(obj.tagName);
		//alert(obj.type);
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

///Add by DJ 2009-05-20  DJ0002
///数据打包及解析
function PackageData(value)
{
 	var ElementName=value.split("^")
 	var valuestr=""
 	for (var i=0;i<ElementName.length;i++)
 	{
  		var obj=document.getElementById(ElementName[i])
  		if (obj)
  		{
   			valuestr=valuestr+"^"+ElementName[i]+"="+GetElementValueNew(ElementName[i],"");
  		}
 	}
 	return valuestr
}


///Add by JDL 2009-06-24  JDL0019
///数据解析,根据元素名称从数据包里获取数据
function GetValueByName(value,name)
{
	var List=value.split("^");
	var ElementInfo,ElementName,ElementValue;
	ElementValue="";
	for (var i=0;i<List.length;i++)
	{
		ElementInfo=List[i];
		ElementInfo=ElementInfo.split("=");
		ElementName=ElementInfo[0];
		ElementValue=ElementInfo[1];
		if (ElementName==name) return ElementValue;
	}
	return ElementValue;
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
		//alert(All[I].style.fontSize);
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
		//alert(All[I].style.fontSize);
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
		//alert(obj.tagName);
		//alert(obj.type);
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
	 	var val=GetPYCode(ManuFactory)+"^"+ManuFactory;
	 	var encmeth=GetElementValue("UpdManuFactory");
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
	 	var val=GetPYCode(Provider)+"^"+Provider+"^"+ProviderHandler+"^"+ProviderTel;
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

///Modified By JDL 20150820 GetSpellCode作废，统一使用GetPYCode
/// 取消用动态库转换拼音码，调用后台方法，生成拼音码
///-------------------------------------------------
///新增:ZY 2009-10-26 ZY0013
///转换成拼音码
function GetPYCode(strInput)
{
	var encmeth=GetElementValue("GetPYMethod");
	if (encmeth=="") return "";
	var rtnStr=cspRunServerMethod(encmeth,strInput,'4','','U');
	return rtnStr;
	/*
	var DHCHZ2PY = new ActiveXObject("HZ2PY.PinYinZH")
	var rtnStr=DHCHZ2PY.HZ2PYT(strInput);
	return rtnStr;
	*/	
}

function TransDisableToReadOnly(tagName)
{	
	var All = document.getElementsByTagName(tagName);
	var Length = All.length;
	for(var I = 0; I < Length; I++)
	{
		if (All[I].disabled)
		{
			//alert(All[I].tagName);
			//alert(All[I].type);
			if ((All[I].type!="checkbox")&&(All[I].tagName!="A"))
			{			
				All[I].disabled=false;
				All[I].readOnly=true;
				All[I].className= "EQReadOnlyINPUT";
			}
		}
	}	
}

function InitLast()
{
	TransDisableToReadOnly("*");
}

function ReadOnlyElement(name,value)
{
	var obj=document.getElementById(name);
	if (obj)
	{
		obj.readOnly=value;
		if (value)
			{	obj.className= "EQReadOnlyINPUT";}
		else
			{	obj.className="";}
	}
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

function CloseWindow()
{
	if (window.parent)
	{
		window.parent.close();
	}
	else
	{
		window.close();
	}
}
///创建界面元素
///type:类型 0标签  1文本框  2带放大镜的文本框  3日期  4下拉框
///listInfo:当类型为下拉框时?下拉框信息 value1^text1&value2^text2.......
function CreatElementHtml(type,id,width,height,keydownEvent,changeEvent,listInfo,keyupEvent,keypressEvent)
{
	var html;
	html="";	
	var Style="";
		var ComponentItemInfo=GetElementValue("GetComponentItemInfo");
		if (ComponentItemInfo!="")
		{
			var offset=id.lastIndexOf("z");
			var objindex=id.substring(offset+1);
			var colName=id.substring(0,offset);
			var DataType=GetDataByName(ComponentItemInfo,colName,"&","=")
			if (DataType=="%Library.Float") Style=" ; TEXT-ALIGN: right; padding-right:2px "
		}
	if (!keypressEvent) keypressEvent=""; 	//ZY0055 2011-2-15
	if (0==type)
	{
		html="<label id=\""+id+"\" name=\""+id+ "\" style=\"WIDTH:" + width + " ;HEIGHT:" + height + Style +"\" value=\"\">"
	}
	else if (1==type)
	{
		html="<input type=text id=\""+id+"\" name=\""+id+ "\" style=\"WIDTH:" + width + " ;HEIGHT:" + height + Style +"\" value=\"\"";
		if (keyupEvent!="")
		{html=html+" onkeyup=\""+keyupEvent+"()\"";}
		if (keydownEvent!="")
		{html=html+" onkeydown=\""+keydownEvent+"()\"";}
		if (changeEvent!="")
		{html=html+" onchange=\""+changeEvent+"()\"";}
		if (keypressEvent!="")
		{html=html+" onkeypress=\""+keypressEvent+"()\"";}
		html=html+">"
	}
	else if (2==type)
	{
		width=AdjustWidth(width);
		html="<input type=text id=\""+id+"\" name=\""+id+ "\" style=\"WIDTH:" + width + " ;HEIGHT:" + height +"\" value=\"\"";
		if (keyupEvent!="")
		{html=html+" onkeyup=\""+keyupEvent+"()\"";}
		if (keydownEvent!="")
		{html=html+" onkeydown=\""+keydownEvent+"()\"";}
		if (changeEvent!="")
		{html=html+" onchange=\""+changeEvent+"()\"";}
		html=html+">"
		var IMGId="ldi"+id;
		html=html+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookup.gif\"";
		if (keydownEvent!="")
		{html=html+" onclick=\""+keydownEvent+"(1)\"";}
		html=html+">"
	}
	else if (3==type)
	{
		width=AdjustWidth(width,25);
		html="<input type=text id=\""+id+"\" name=\""+id+ "\" style=\"WIDTH:" + width + " ;HEIGHT:" + height +"\" value=\"\"";
		if (keydownEvent!="")
		{html=html+" onkeydown=\""+keydownEvent+"()\"";}
		if (changeEvent!="")
		{html=html+" onchange=\""+changeEvent+"()\"";}
		html=html+">"
		var IMGId="ldi"+id;
		html=html+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookupdate.gif\"";
		if (keydownEvent!="")
		{html=html+" onclick=\""+keydownEvent+"(1)\"";}
		html=html+">"
	}
	else if (4==type)
	{
		html="<select name=\""+id+"\" id=\""+id+"\" style=\"WIDTH:"+width+" ;HEIGHT:"+height+"\""
		if (keydownEvent!="")
		{html=html+" onkeydown=\""+keydownEvent+"()\"";}		
		if (changeEvent!="")
		{html=html+" onchange=\""+changeEvent+"()\"";}
		html=html+">"
		var list=listInfo.split("&")
		for (var Row=0;Row<list.length;Row++)
		{
			var option=list[Row].split("^");
			html=html+"<option value="+option[0]+">"+option[1]+"</option>"
		}
		html=html+"</select>"
	}
	else if (5==type)
	{
		html="<input type=checkbox id=\""+id+"\" name=\""+id+ "\" style=\"WIDTH:" + width + " ;HEIGHT:" + height +"\" value=\"\"";
		if (keyupEvent!="")
		{html=html+" onkeyup=\""+keyupEvent+"()\"";}
		if (changeEvent!="")
		{html=html+" onchange=\""+changeEvent+"()\"";}	
		if (keydownEvent!="")
		{html=html+" onclick=\""+keydownEvent+"()\"";}
		html=html+">"
	}
	return html;
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
         	//alert(html);
         	RowObj.cells[j].innerHTML=html;
		}
		else if (arrId[0]=="TUseYearsNum")
		{
			html=CreatElementHtml(1,Id,objwidth,objheight,"","")
         	//alert(html);
         	RowObj.cells[j].innerHTML=html;
		}
		else if (arrId[0]=="TStatCat")
		{
			html=CreatElementHtml(4,Id,objwidth,objheight,"","ChangeTest","1^器械专用设备&2^器械一般设备")
         	//alert(html);
         	RowObj.cells[j].innerHTML=html;
		}
	}
}

function ChangeTest()
{
	alert("Change");
}

///新增:2009-11-12 党军
///描述:JS页面操作实现回车执行Tab键功能,Value传入参数格式为"BuyLoc^Loc"
///备注:此功能仅执行文本框元素
function Muilt_Tab(Value)
{
	var value=Value.split("^");
	var i=0;
	for (i=0;i<value.length;i++)
	{
		var obj=document.getElementById(value[i]);
		if (obj) obj.onkeydown=KeyDown_Tab;
	}
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

///Add by Mozy
///调到下一个焦点
function SetFocusColumn(ColName,Row)
{
	var obj=document.getElementById(ColName+"z"+Row);
	if (obj){websys_setfocus(ColName+"z"+Row)};
}

///Add by JDL 2010-8-3
///Show or hide object
///objID:
///hidden: 0 show ,  1 hidden
function HiddenObj(objID,hidden) 
{
	var obj=document.getElementById(objID);
	if (obj)
	{
		if (hidden==0)
		{
			obj.style.display=""
		}
		else
		{
			obj.style.display="none"
		}
	}
}

///Add by JDL 2010-8-9
///创建SourceType,SourceID信息对象
function SourceInfo(SourceType,SourceID)
{
	this.SourceType=SourceType;
	this.SourceID=SourceID;
}

///需要在组件上定义GetColCaption?s val=##Class(%CSP.Page).Encrypt($lb("web.DHCEQCommon.GetColumnCaption"))
///					GetComponentID?s val=##class(web.DHCEQCommon).GetComponentID("DHCEQInStockNew")
function GetColCaption(colName)
{
	var encmeth=GetElementValue("GetColCaption")
  	if (encmeth=="") return;
  	var ComponentID=GetElementValue("GetComponentID");  	
	var Caption=cspRunServerMethod(encmeth,ComponentID,colName);
	//alert(Caption+"&"+ComponentID+"&"+colName);
	return Caption;
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
///描述:JS页面操作实现隐藏Table的列
function HiddenTblColumn(Objtbl,ColName) 
{
	if (ColName=="") return;
	var ComponentID=GetElementValue("GetComponentID");
	if (ComponentID=="") return;
	var encmeth=GetElementValue("GetColumnID");
	if (encmeth=="") return;
	var ColID=cspRunServerMethod(encmeth,ComponentID,ColName);
	if (ColID=="")  return
	var Obj=document.getElementById(ColID)		//Modify DJ 2015-09-21 DJ0165
	if (Obj)
	{
		document.getElementById(ColID).style.display="none";
		var rows=Objtbl.rows.length;
		var i=0;
		for (i=1;i<rows;i++)
		{
			document.getElementById(ColName+"z"+i).parentElement.style.display="none";
		}
	}
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
		alert(ename);
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
		alert(ename);
	}
}
function DateDiff(sDate1, sDate2) 
{ //sTime1和sTime2是18/12/2002格式  
	if ((sDate1=="")||(sDate2=="")) return 0
    var aDate, oDate1, oDate2, iDays;   
    aDate = sDate1.split("/");
    oDate1 = new Date(aDate[2],aDate[1]-1,aDate[0]);
    aDate = sDate2.split("/");   
    oDate2 = new Date(aDate[2],aDate[1]-1,aDate[0]);   
       
    iDays = parseInt(Math.abs(oDate1 - oDate2) / 1000 / 60 / 60 /24).toFixed(0);     
    if((oDate1 - oDate2)<0)
    {
        return -iDays;
    }   
    return iDays;  
}
function TimeDiff(sTime1, sTime2) 
{ //sDate1和sDate2是10:59格式     
	if ((sTime1=="")||(sTime2=="")) return 0
    var aTime, oTime1, oTime2, iHours;   
    aTime = sTime1.split(":");
    oTime1 = new Time(aTime[0],aTime[1]);
    aTime = sTime2.split(":");   
    oTime2 = new Time(aTime[0],aTime[1]); 
    iHours=((oTime1.Hour - oTime2.Hour)+(oTime1.Minute - oTime2.Minute)/ 60).toFixed(0)
    if((iHours)<0)
    {
        return parseInt(iHours);
    }
    iHours = parseInt(Math.abs(iHours));
    return iHours;
}
///创建时间对象
function Time(hour,minute)
{
	this.Hour=hour;
	this.Minute=minute;
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
		///alert(All[I].id);		
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
			///alert(head.children[I].innerText);
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
	///alert(ReplaceNum);
	return ReplaceNum;	
}

///add by jdl 2011-12-9 JDL0104
///从IDs中移除指定ID,IDs的分隔符默认为","
function RemoveIDFromIDs(IDs,ID,SplitStr)
{
	if (IDs=="") return IDs;
	if (SplitStr=="") SplitStr=",";
	IDs=SplitStr+IDs+SplitStr;
	ID=SplitStr+ID+SplitStr;
	IDs=IDs.replace(ID,SplitStr);
	IDs=IDs.substring(1,IDs.length - 1);
	if (IDs==SplitStr) IDs="";
	return IDs;
}

///add by jdl 2011-12-9 JDL0104
///从IDs中移除指定ID,IDs的分隔符默认为","
function AddIDToIDs(IDs,ID,SplitStr)
{
	if (IDs=="") return ID;
	if (SplitStr=="") SplitStr=",";
	IDs=SplitStr+IDs+SplitStr;
	if (IDs.indexOf(SplitStr+ID+SplitStr)<0)
	{					
		IDs=IDs+ID+SplitStr;
	}
	IDs=IDs.substring(1,IDs.length - 1);
	return IDs;
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
		alert(e.message);
		return "";
	}
}

/// 故障类型	20150112  Mozy0149
function GetFaultTypeRowID(type,i)
{
	var FaultTypeName="FaultType";
	var FaultTypeDRName="FaultTypeDR";
	if ((i)&&(i!=""))
	{
		FaultTypeName="T"+FaultTypeName+"z"+i;
		FaultTypeDRName="T"+FaultTypeDRName+"z"+i;
	}
	
 	if (GetElementValue(FaultTypeDRName)!="")
 	{
  		return GetElementValue(FaultTypeDRName);
 	}
 	else
 	{
	 	if ((type==0)||(type=="")) return "";
	 	var FaultType=GetElementValue(FaultTypeName);
	 	if (FaultType=="") return "";
	 	var val="^"+FaultType;
	 	var encmeth=GetElementValue("UpdFaultType");
		var rtn=cspRunServerMethod(encmeth,val);
  		return rtn;
 	}
}
/// 故障原因	20150112  Mozy0149
function GetFaultReasonRowID(type,i)
{
	var FaultReasonName="FaultReason";
	var FaultReasonDRName="FaultReasonDR";
	if ((i)&&(i!=""))
	{
		FaultReasonName="T"+FaultReasonName+"z"+i;
		FaultReasonDRName="T"+FaultReasonDRName+"z"+i;
	}
	
 	if (GetElementValue(FaultReasonDRName)!="")
 	{
  		return GetElementValue(FaultReasonDRName);
 	}
 	else
 	{
	 	if ((type==0)||(type=="")) return "";
	 	var FaultReason=GetElementValue(FaultReasonName);
	 	if (FaultReason=="") return "";
	 	var val="^"+FaultReason;
	 	var encmeth=GetElementValue("UpdFaultReason");
		var rtn=cspRunServerMethod(encmeth,val);
  		return rtn;
 	}
}
/// 解决方法	20150112  Mozy0149
function GetDealMethodRowID(type,i)
{
	var DealMethodName="DealMethod";
	var DealMethodDRName="DealMethodDR";
	if ((i)&&(i!=""))
	{
		DealMethodName="T"+DealMethodName+"z"+i;
		DealMethodDRName="T"+DealMethodDRName+"z"+i;
	}
	
 	if (GetElementValue(DealMethodDRName)!="")
 	{
  		return GetElementValue(DealMethodDRName);
 	}
 	else
 	{
	 	if ((type==0)||(type=="")) return "";
	 	var DealMethod=GetElementValue(DealMethodName);
	 	if (DealMethod=="") return "";
	 	var val="^"+DealMethod;
	 	var encmeth=GetElementValue("UpdDealMethod");
		var rtn=cspRunServerMethod(encmeth,val);
  		return rtn;
 	}
}
///新增:ZC 2015-02-02 ZC0019
///描述:获取故障现象录入方式 0:放大镜 1:手工录入,并自动检测更新故障现象表
function GetFaultCaseRowID(type,i)
{		
	var FaultCaseName="FaultCase"
	var FaultCaseDRName="FaultCaseDR"
	if ((i)&&(i!=""))
	{
		FaultCaseName="T"+FaultCase+"z"+i;
		FaultCaseDRName="T"+FaultCaseDRName+"z"+i;
	}	
	
 	if (GetElementValue(FaultCaseDRName)!="")
 	{
  		return GetElementValue(FaultCaseDRName)
 	}
 	else
 	{
	 	if ((type==0)||(type==""))  return "";
	 	var FaultCase=GetElementValue(FaultCaseName);
	 	if (FaultCase=="") return "";
	 	var val=GetPYCode(FaultCase)+"^"+FaultCase;
	 	var encmeth=GetElementValue("UpdFaultCase");
		var rtn=cspRunServerMethod(encmeth,val);
  		return rtn
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

///Add By DJ 2015-08-07
///描述:根据列名获取信息串中的列值
///参数:vStrInfo   格式:列1=值1&列2=值2&列3=值3&列4=值4&
///		vFiledName  列名
///		vRecordFlag 列与列之间分割符"&"
///		vFiledFlag  列名与列值之间分隔符"="
function GetDataByName(vStrInfo,vFiledName,vRecordFlag,vFiledFlag)
{
	if (vStrInfo=="")	return ""
	var FiledStr=vStrInfo.split(vRecordFlag)
	for (var i=0;i<FiledStr.length;i++)
	{
		var OneFiledStr=FiledStr[i]
		if (OneFiledStr!="")
		{
			var FiledInfo=OneFiledStr.split(vFiledFlag)
			var FiledName=FiledInfo[0]
			var FiledValue=FiledInfo[1]
			if (FiledName==vFiledName)
			{
				return FiledValue
			}
		}
	}
}
///Add By DJ 2015-08-17 DJ0156
///描述:设置前台页面记录显示背景色
function SetBackGroupColor(vComponentTableName)
{
  var Objtbl=document.getElementById(vComponentTableName);
  var Rows=Objtbl.rows.length;
  if(Rows==1) return
  for (var i=1;i<Rows;i++)
  {
	var selobj=document.getElementById('TBackGroupColorz'+i); 
	if (GetElementValue('TBackGroupColorz'+i)!="")
	{
		Objtbl.rows(i).style.backgroundColor=GetElementValue('TBackGroupColorz'+i);
	}
  }
}

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
						alert(t[-4008]+CValue+"!");
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
function SetWindowSize(url,vDefaultFlag,vWidth,vHeight,vTop,vLeft)
{
	if (1==vDefaultFlag)
	{
		vWidth=980;
		vHeight=650
		vTop=3;
		vLeft=130;
	}
	window.open(url,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+vWidth+',height='+vHeight+',left='+vLeft+',top='+vTop);		//Modify HHM 2015-08-21 HHM0001
}
///add by zy 2015-9-22
///数字金额转大写金额
///num  数字型
function ChineseNum(num) 
{
	num=num.toFixed(2)
	if (!/^(0|[1-9]\d*)(\.\d+)?$/.test(num))  return "数据非法";
	var unit = "千百拾亿千百拾万千百拾元角分";
	var str = ""; 
	num += "00";
	var p = num.indexOf('.');
	if (p >= 0) 
	{
		num = num.substring(0, p) + num.substr(p+1, 2);
		unit = unit.substr(unit.length - num.length);
	}	
	for (var i=0; i < num.length; i++)
	{
		str += '零壹贰叁肆伍陆柒捌玖'.charAt(num.charAt(i)) + unit.charAt(i);
		///alert(str+"&"+num.charAt(i)+"&"+unit.charAt(i))
	}
	return str.replace(/零(千|百|拾|角)/g, "零").replace(/(零)+/g, "零").replace(/零(万|亿|元)/g, "$1").replace(/(亿)万|壹(拾)/g, "$1$2").replace(/^元零?|零分/g, "").replace(/元$/g, "元整");
} 
//add by HHM 20150910 HHM0013
//添加业务单据操作成功，是否提示
function ShowMessage(msg)
{
	if ((!msg)||(""==msg))
	{
		msg="操作成功！"
	}
	var rtn=GetElementValue("GetSuccessMsg");
	if(rtn=="1") {	alert(msg);	}
}
/// 20150918  Mozy0166	隐藏表格图标，多用于隐藏合计行图标
/// ComponentName:	组件名
/// val:	对应元素值为空则隐藏该图标
/// Item:	图标所在的元素名
function HiddenTableIcon(ComponentName,val,Item)
{
	if ((ComponentName=="")||(val=="")||(Item=="")) return;
	ComponentName="t"+ComponentName;
	var objtbl=document.getElementById(ComponentName);
	var rows=objtbl.rows.length-1;
	for (var i=1;i<=rows;i++)
	{
		if (GetElementValue(val+"z"+i)=="")
		{
			obj=document.getElementById(Item+"z"+i);
			if (obj) obj.innerText=""
		}
	}
}

//处理奇数行背景色20160111
function SetOddColor(componentName)
{
	//var objtbl=document.getElementById('tDHCEQMCEmergencyLevel');
	componentName=GetTableName();
	if (componentName=="") return;
	var objtbl=document.getElementById(componentName);
	var rows=objtbl.rows.length;
	for (i=1;i<rows;i++)
	{
		if ((i%2)==1)
		{
			objtbl.rows[i].style.backgroundColor='#fff'
		}
		else
		{
			objtbl.rows[i].style.backgroundColor='#DFFFDF'
		}
	}	
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