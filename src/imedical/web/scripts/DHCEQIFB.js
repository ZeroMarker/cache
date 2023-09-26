/// 创    建:ZY  2010-03-26  No.ZY0019
/// 修改描述:设备招标管理功能
/// --------------------------------
/// modified by GR 2014-10-09 
/// 3286 设备招标管理-设备招标-删除所有设备项记录，第一条设备项来源未清空
/// 修改：清空设备项来源
/// 修改位置：ClearValue()
/// ------------------------------------------------------
/// modified by GR 2014-10-09 
/// 3288 设备招标管理-设备招标-删除所有设备项记录后，点击【设备项】放大镜，界面无响应
/// 修改：保留来源类型字段
/// 修改位置：ClearValue()
/// ------------------------------------------------------
/// add by GR 2014-10-09 增加时间相关正确性检验过程
/// 缺陷号3188 设备招标管理-设备招标-新增设备招标时，开标日期晚于投标截止日期可更新成功
/// 缺陷号3296 设备招标管理-设备招标-时间格式不正确，提示"操作异常 web.DHCEQIFB.1"
/// 缺陷原因：更新操作缺少相关检验过程
/// 新增函数IsValidTimeCheck()
/// -----------------------------------------------------------------------------
/// add by GR 2014-10-10 增加日期格式转换函数
/// 缺陷号3188[1] 设备招标管理-设备招标-新增设备招标时?开标日期晚于投标截止日期可更新成功
/// 缺陷原因:日期格式为日月年格式，不方便比较
/// 新增函数:changeDateformat()
/// ----------------------------------------------------------------------------------
var selectrow=0;
///记录 设备 RowID处理重复选择RowID的问题
var ObjSources=new Array();
//最后一行数据元素的名字的后缀序号
var LastNameIndex;
//新增一行数据元素的名字的后缀序号
var NewNameIndex;
//招标明细来源值
var CustomValue;	//格式:0^设备项&1^采购申请&2^采购计划

function BodyLoadHandler()
{
	if (GetElementValue("GetSourceType")==0)
	{
		CustomValue="2^采购计划" 
	}
	else if (GetElementValue("GetSourceType")==1)
	{
		CustomValue="0^设备项&2^采购计划" 
	}
	InitUserInfo();
	InitPage();
	FillData();
	SetEnabled();
	InitEditFields(GetElementValue("ApproveSetDR"),GetElementValue("CurRole"));
	InitApproveButton();
	SetTableItem();
	SetDisplay();
	Muilt_LookUp("Mode^BuyType^Agency^Currency");
	KeyUp("Mode^BuyType^Agency^Currency","N");
}

function SetEnabled()
{
	var Status=GetElementValue("Status");
	var Type=GetElementValue("Type");
	if (Status!="0")
	{
		SetElement("ReadOnly","1");
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		if (Status!="")
		{
			DisableBElement("BUpdate",true);
			DisableBElement("BAdd",true);
			DisableBElement("BClear",true);
		}
		else
		{
			SetElement("ReadOnly","0");
		}
	}
	if (Type==1)
	{
		SetElement("ReadOnly","1");
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAdd",true);
		DisableBElement("BClear",true);
	}
}
function FillData()
{
	var RowID=GetElementValue("RowID");
	if (RowID=="") return;
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	//alertShow(RowID)
	var sort=58;
	SetElement("RowID",list[0]);
	SetElement("PrjName",list[1]);
	SetElement("PrjIntro",list[2]);
	SetElement("No",list[3]);
	SetElement("ModeDR",list[4]);
	SetElement("Mode",list[sort+1]);
	SetElement("Tenderee",list[5]);
	SetElement("TendereeAddress",list[6]);
	SetElement("ConPerson",list[7]);
	SetElement("Tel",list[8]);
	SetElement("Fax",list[9]);
	SetElement("BuyFilePrice",list[10]);
	SetElement("BuyFileFromDate",list[11]);
	SetElement("BuyFileFromTime",list[12]);
	SetElement("BuyFileToDate",list[13]);
	SetElement("BuyFileToTime",list[14]);
	SetElement("BuyFilePlace",list[15]);
	SetElement("Deposit",list[16]);
	SetElement("AgencyDR",list[17]);
	SetElement("Agency",list[sort+2]);
	SetElement("AgencyTel",list[18]);
	SetElement("AgencyFax",list[19]);
	SetElement("AgencyConPerson",list[20]);
	SetElement("AnnouncementDate",list[21]);
	SetElement("AnnouncementMedia",list[22]);
	SetElement("ReservePrice",list[23]);
	SetElement("DisabuseDate",list[24]);
	SetElement("DeadlineDate",list[25]);
	SetElement("DeadlineTime",list[26]);
	SetElement("SubmissionPlace",list[27]);
	SetElement("OpenDate",list[28]);
	SetElement("OpenTime",list[29]);
	SetElement("OpenPlace",list[30]);
	SetElement("EvaluationCommittee",list[31]);
	SetElement("DeterminationDate",list[32]);
	SetElement("Condition",list[33]);
	SetElement("ManageLocDR",list[34]);
	SetElement("ManageLoc",list[sort+3])
	SetElement("BuyTypeDR",list[35]);
	SetElement("BuyType",list[sort+4])
	SetElement("Remark",list[36]);
	
	SetElement("AddUserDR",list[37]);
	SetElement("AddDate",list[38]);
	SetElement("AddTime",list[39]);
	SetElement("UpdateUserDR",list[40]);
	SetElement("UpdateDate",list[41]);
	SetElement("UpdateTime",list[42]);
	SetElement("Status",list[43]);
	SetElement("SubmitUserDR",list[44]);
	SetElement("SubmitDate",list[45]);
	SetElement("SubmitTime",list[46]);
	SetElement("AuditUserDR",list[47]);
	SetElement("AuditDate",list[48]);
	SetElement("AuditTime",list[49]);
	SetElement("Hold1",list[50]);
	SetElement("Hold2",list[51]);
	SetElement("Hold3",list[52]);
	SetElement("Hold4",list[53]);
	SetElement("Hold5",list[54]);
	SetElement("CurrencyDR",list[58]);
	SetElement("Currency",list[sort+5]);
	
	SetElement("ApproveSetDR",list[sort+7]);
	SetElement("NextRoleDR",list[sort+8]);
	SetElement("NextFlowStep",list[sort+9]);
	SetElement("ApproveStatu",list[sort+10]);
	SetElement("ApproveRoleDR",list[sort+11]);
	SetElement("CancelFlag",list[sort+12]);
	SetElement("CancelToFlowDR",list[sort+13]);
}

function InitPage()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Clicked;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Clicked;
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Clicked;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Clicked;
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=AddClickHandler;
}
function BClear_Clicked()
{
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQIFB&Status=0&QXType=2&Type=';
}

function BUpdate_Clicked()
{
	if(IsValidTimeCheck()) return;
	if (CheckNull()) return;
	var combindata=GetValueList(); 	//总单信息
  	var valList=GetTableInfo(); 	//明细信息
  	if (valList=="-1")  return; 	//明细信息有误
  	var DelRowid=tableList.toString();
  	var encmeth=GetElementValue("UpdateData");
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,combindata,valList,"0",DelRowid);
	//alertShow(rtn)
	var list=rtn.split("^");
	if (list[1]!="0")
	{
		alertShow("操作异常   "+list[1])
	}
	else
	{
		if (list[0]>0)
		{
			//添加操作成功是否提示
	   	 	ShowMessage();
	   	 	//****************************
			window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQIFB&RowID='+list[0]+"&Type=0";
		}
		else
		{
			alertShow(t["01"])
		}
	}
}

function BDelete_Clicked()
{
	var truthBeTold = window.confirm(t["-4003"]);
	if (!truthBeTold) return;
	var combindata=GetValueList();
  	var encmeth=GetElementValue("UpdateData");
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,combindata,"","1");
	//alertShow(rtn)
	var list=rtn.split("^");
	if (list[1]=="0")
    {
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQIFB&Type=';
	}
    else
    {
	    alertShow(rtn+"   "+t["01"]);
    }
}

function BSubmit_Clicked()
{
	var combindata=GetAuditData();
  	var valList=GetTableInfo();
  	if (valList=="-1")  return; 	//明细信息有误
  	if (valList=="")
  	{
	  	alertShow("无明细记录不可提交!");
	  	return
  	}
  	var encmeth=GetElementValue("SubmitData");
  	if (encmeth=="") return;
  	//alertShow(combindata)
	var rtn=cspRunServerMethod(encmeth,combindata);
	if (rtn>0)
    {
	    window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQIFB&RowID='+rtn+"&Type="+GetElementValue("Type")
	}
    else
    {
	    alertShow(t[rtn]+"   "+t["01"]);
    }
}

function BCancelSubmit_Clicked() 
{
	var combindata=GetAuditData();
  	var encmeth=GetElementValue("CancelSubmitData");
  	if (encmeth=="") return;
  	//alertShow(combindata)
  	//Modified by jdl 2011-3-17  jdl0073
	var Rtn=cspRunServerMethod(encmeth,combindata,GetElementValue("CurRole"));
	if (Rtn>0)
    {
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQIFB&RowID='+Rtn+'&Type=1';
	}
    else
    {
	    alertShow(Rtn+"   "+t["01"]);
    }
}

function BApprove_Clicked()
{
	var combindata=GetAuditData();
	var CurRole=GetElementValue("CurRole");
  	if (CurRole=="") return;
	var RoleStep=GetElementValue("RoleStep");
  	if (RoleStep=="") return;
  	var objtbl=document.getElementById('tDHCEQIFB');
	var EditFieldsInfo=ApproveEditFieldsInfo(objtbl);
	if (EditFieldsInfo=="-1") return;
  	var encmeth=GetElementValue("AuditData");
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,combindata,CurRole,RoleStep,EditFieldsInfo);
	//alertShow(EditFieldsInfo)
    if (rtn>0)
    {
	    window.location.reload();
	}
    else
    {
	    alertShow(t["01"]);
    }
}

function GetValueList()
{
	var combindata="";
  	combindata=GetElementValue("RowID");
	combindata=combindata+"^"+GetElementValue("PrjName");
	combindata=combindata+"^"+GetElementValue("PrjIntro");
	combindata=combindata+"^"+GetElementValue("No");
	combindata=combindata+"^"+GetElementValue("ModeDR");
	combindata=combindata+"^"+GetElementValue("Tenderee");
	combindata=combindata+"^"+GetElementValue("TendereeAddress");
	combindata=combindata+"^"+GetElementValue("ConPerson");
	combindata=combindata+"^"+GetElementValue("Tel");
	combindata=combindata+"^"+GetElementValue("Fax");
	combindata=combindata+"^"+GetElementValue("BuyFilePrice");
	combindata=combindata+"^"+GetElementValue("BuyFileFromDate");
	combindata=combindata+"^"+GetElementValue("BuyFileFromTime");
	combindata=combindata+"^"+GetElementValue("BuyFileToDate");
	combindata=combindata+"^"+GetElementValue("BuyFileToTime");
	combindata=combindata+"^"+GetElementValue("BuyFilePlace");
	combindata=combindata+"^"+GetElementValue("Deposit");
	combindata=combindata+"^"+GetElementValue("AgencyDR");
	combindata=combindata+"^"+GetElementValue("AgencyTel");
	combindata=combindata+"^"+GetElementValue("AgencyFax");
	combindata=combindata+"^"+GetElementValue("AgencyConPerson");
	combindata=combindata+"^"+GetElementValue("AnnouncementDate");
	combindata=combindata+"^"+GetElementValue("AnnouncementMedia");
	combindata=combindata+"^"+GetElementValue("ReservePrice");
	combindata=combindata+"^"+GetElementValue("DisabuseDate");
	combindata=combindata+"^"+GetElementValue("DeadlineDate");
	combindata=combindata+"^"+GetElementValue("DeadlineTime");
	combindata=combindata+"^"+GetElementValue("SubmissionPlace");
	combindata=combindata+"^"+GetElementValue("OpenDate");
	combindata=combindata+"^"+GetElementValue("OpenTime");
	combindata=combindata+"^"+GetElementValue("OpenPlace");
	combindata=combindata+"^"+GetElementValue("EvaluationCommittee");
	combindata=combindata+"^"+GetElementValue("DeterminationDate");
	combindata=combindata+"^"+GetElementValue("Condition");
	combindata=combindata+"^"+GetElementValue("ManageLocDR");
	combindata=combindata+"^"+GetElementValue("BuyTypeDR");
	combindata=combindata+"^"+GetElementValue("Remark");
	combindata=combindata+"^"+GetElementValue("Hold1");
	combindata=combindata+"^"+GetElementValue("Hold2");
	combindata=combindata+"^"+GetElementValue("Hold3");
	combindata=combindata+"^"+GetElementValue("Hold4");
	combindata=combindata+"^"+GetElementValue("Hold5");
	combindata=combindata+"^"+GetElementValue("CurrencyDR");
	
	combindata=combindata+"^"+GetElementValue("CancelToFlowDR");
	combindata=combindata+"^"+GetElementValue("ApproveSetDR");
	
	return combindata;
}
function GetAuditData()
{
	var ValueList="";
	ValueList=GetElementValue("RowID");
	ValueList=ValueList+"^"+curUserID;
	ValueList=ValueList+"^"+GetElementValue("CancelToFlowDR");
	
	return ValueList;
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	return false;
}
function GetBuyTypeDR (value)
{
    GetLookUpID("BuyTypeDR",value);
}
function GetAgencyDR (value)
{
    GetLookUpID("AgencyDR",value);
}

function SetTableItem()
{
	var objtbl=document.getElementById('tDHCEQIFB');
	var rows=objtbl.rows.length-1;
	for (var i=1;i<=rows;i++)
	{
		var TBagNo=document.getElementById("TBagNoz"+i).innerHTML;  //列表数组初始化
		var TRowID=GetElementValue("TRowIDz"+i);
		var TotalFlag=GetElementValue("TotalFlag");
		
		var TSourceType=GetElementValue("TExtendTypeDRz"+i);
		var TSourceID=GetElementValue("TExtendIDz"+i);
		ObjSources[i]=new SourceInfo(TSourceType,TSourceID);
		if (GetElementValue("Status")==""){     //add by czf 2016-11-16 需求号：278321
			HiddenObj("TBListz"+i,true);
		}
		if (TRowID==-1)
		{
			obj=document.getElementById("TRowz"+i);
			if (obj) obj.innerText="";
			obj=document.getElementById("BDeleteListz"+i);
			if (obj) obj.innerText="";
			obj=document.getElementById("TBListz"+i);
			if (obj)
			{
				obj.innerText="";
				HiddenObj("TBListz"+i,true);
			}
			tableList[i]=-1
			continue;
		}
		tableList[i]=0
		ChangeRowStyle(objtbl.rows[i]);		///改变一行的内容显示
	}
}

///改变一行的内容显示
function ChangeRowStyle(RowObj)
{
	var Status=GetElementValue("Status");
	for (var j=0;j<RowObj.cells.length;j++)
	{
		if (!RowObj.cells[j].firstChild) {continue}
    	var value=""
    	var html=""
		var Id=RowObj.cells[j].firstChild.id;
		var offset=Id.lastIndexOf("z");
		var colName=Id.substring(0,offset);
		var objindex=Id.substring(offset+1);
		var objwidth=RowObj.cells[j].style.width;
		var objheight=RowObj.cells[j].style.height;
		var ReadOnly=GetElementValue("ReadOnly");   //add by mwz 需求号：467332
		//var objwidth="60px";
		//var objheight="22px";
		
		if (colName=="TBagNo")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","","NumberPressHandler");
		}
		else if (colName=="TItem")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpTItem","","","")
		}
		else if (colName=="TQuantity")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","SumList_Change","NumberPressHandler")
		}/*
		else if (colName=="TUnit")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpTUnit","","","")
		}*/
		else if (colName=="TManuFactory")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpTManuFactory","","","")
		}
		else if (colName=="TModel")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpTModel","","","")
		}
		else if (colName=="TArg")
		{
			//alertShow(Status)
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TExtendType")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetElementValue(Id)
			value=GetElementValue("TExtendTypeDRz"+objindex);
			html=CreatElementHtml(4,Id,objwidth,objheight,"","ExtendType_Change",CustomValue,"","")
		}/*
		else if (colName=="TExtendID")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpTExtendID","","","")
		}*/
		else if (colName=="TWinPrice")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","SumList_Change","NumberPressHandler")
		}
		else if (colName=="TRemark")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TListVendor")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpTListVendor","","","")
		}
		else if (colName=="TListManuFactory")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpTListManuFactory","","","")
		}
		else if (colName=="TListModel")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpTListModel","","","")
		}
		else if (colName=="TListArg")
		{
			/* Modified By JDL 20150901 招标无法保存的问题
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
         	*/
		}
		else if (colName=="TListPrice")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","","NumberPressHandler")
		}
		/*
		else if (colName=="TAmount")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(2,Id,objwidth,objheight,"","ClearValue","","")
		}*/
		else if (colName=="BDeleteList")  		 //add by mwz 需求号：467332
		{
			if ((Status>0)||(ReadOnly==1))
			{
				HiddenObj(colName+"z"+objindex,1)
				continue;
			}
			RowObj.cells[j].onclick=DeleteClickHandler;
		}
		else if (colName=="TBList")
		{
			RowObj.cells[j].onclick=VenderListClick;
		}
		else if (colName=="TCommonName")	//2013-06-24 DJ0118
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		if (html!="")
		{
			///Modified by JDL 20151014
			RowObj.cells[j].firstChild.outerHTML=html;
			//RowObj.cells[j].innerHTML=html;
		}
		if (value!="")
		{
         	value=trim(value);
		    if (RowObj.cells[j].firstChild.tagName=="LABEL")
		    {
			    RowObj.cells[j].firstChild.innerText=value;
			}
			else if (RowObj.cells[j].firstChild.tagName=="checkbox")
		    {
			    RowObj.cells[j].firstChild.checked=value;
			}
			else
		    {
			    RowObj.cells[j].firstChild.value=value;
		    }
         	RowObj.cells[j].firstChild.value=trim(value);
		}
	}
}

function LookUpTItem(vClickEventFlag)
{
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		if (CheckNull()) return;
		selectrow=GetTableCurRow();
		var TExtendType=GetElementValue('TExtendTypez'+selectrow);
		if (TExtendType=="") return;
		if (TExtendType==0)  		//无扩展类型
		{
			LookUp("","web.DHCEQCMasterItem:GetMasterItem","GetTItemID",",,TItemz"+selectrow);
		}
		else if (TExtendType==1)  	//采购申请
		{
			LookUp("","web.DHCEQBuyRequestList:GetBuyRequestListByItem","GetTExtendIDID","TItemz"+selectrow);
		}
		else if (TExtendType==2)	//采购计划
		{
			LookUp("","web.DHCEQBuyPlanNew:GetBuyPlanList","GetTExtendIDID","TItemz"+selectrow+",'1',RowID");
		}
	}
}

function GetTItemID(value)
{
	var list=value.split("^");
	SetElement('TItemz'+selectrow,list[0]);
	SetElement('TItemDRz'+selectrow,list[1]);
	SetElement('TUnitz'+selectrow,list[6]);
	SetElement('TUnitDRz'+selectrow,list[5]);
	SetElement('TCommonNamez'+selectrow,list[0]);	//2013-06-24 DJ0118
	//alertShow(GetElementValue('TItemDRz'+selectrow)+";"+selectrow+";"+value)
	var obj=document.getElementById("TItemz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}
function LookUpTUnit(vClickEventFlag)
{
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		if (CheckNull()) return;
		selectrow=GetTableCurRow();
		LookUp("","web.DHCEQCUOM:GetUOM","GetTUnitID","TUnitz"+selectrow+",UnitType");
	}
}
function GetTUnitID(value)
{
	var list=value.split("^");
	SetElement('TUnitz'+selectrow,list[0]);
	SetElement('TUnitDRz'+selectrow,list[1]);
	var obj=document.getElementById("TUnitz"+selectrow);
	if (obj) websys_nextfocusElement(obj); 
}
function LookUpTManuFactory(vClickEventFlag)
{
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		if (CheckNull()) return;
		selectrow=GetTableCurRow();
		LookUp("","web.DHCEQCManufacturer:LookUp","GetTManuFactoryID","TManuFactoryz"+selectrow);
	}
}
function GetTManuFactoryID(value)
{
	var list=value.split("^");
	SetElement('TManuFactoryz'+selectrow,list[0]);
	SetElement('TManuFactoryDRz'+selectrow,list[1]);
	var obj=document.getElementById("TManuFactoryz"+selectrow);
	if (obj) websys_nextfocusElement(obj); 
}
function LookUpTModel(vClickEventFlag)
{
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		if (CheckNull()) return;
		selectrow=GetTableCurRow();
		LookUp("","web.DHCEQCModel:GetModel","GetTModelID","TItemDRz"+selectrow+",TModelz"+selectrow);
	}
}
function GetTModelID(value)
{
	var list=value.split("^");
	SetElement('TModelz'+selectrow,list[0]);
	SetElement('TModelDRz'+selectrow,list[1]);
	var obj=document.getElementById("TModelz"+selectrow);
	if (obj) websys_nextfocusElement(obj); 
}

function LookUpTListVendor(vClickEventFlag)
{
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		if (CheckNull()) return;
		selectrow=GetTableCurRow();
		LookUp("","web.DHCEQCVendor:GetVendor","GetTListVendorID","TListVendorz"+selectrow);//modified by CSJ 2017-11-13 "TListVendor"少"z"造成供应商无法检索 需求号：474797
	}
}
function GetTListVendorID(value)
{
	var list=value.split("^");
	SetElement('TListVendorz'+selectrow,list[0]);
	SetElement('TListVendorDRz'+selectrow,list[1]);
	var obj=document.getElementById("TListVendorz"+selectrow);
	if (obj) websys_nextfocusElement(obj); 
}
function LookUpTListManuFactory(vClickEventFlag)
{
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		if (CheckNull()) return;
		selectrow=GetTableCurRow();
		LookUp("","web.DHCEQCManufacturer:LookUp","GetTListManuFactoryID","TListManuFactoryz"+selectrow);
	}
}
function GetTListManuFactoryID(value)
{
	var list=value.split("^");
	SetElement('TListManuFactoryz'+selectrow,list[0]);
	SetElement('TListManuFactoryDRz'+selectrow,list[1]);
	var obj=document.getElementById("TListManuFactoryz"+selectrow);
	if (obj) websys_nextfocusElement(obj); 
}
function LookUpTListModel(vClickEventFlag)
{
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		if (CheckNull()) return;
		selectrow=GetTableCurRow();
		LookUp("","web.DHCEQCModel:GetModel","GetTListModelID","TItemDRz"+selectrow+",TListModelz"+selectrow);
	}
}

function GetTListModelID(value)
{
	var list=value.split("^");
	SetElement('TListModelz'+selectrow,list[0]);
	SetElement('TListModelDRz'+selectrow,list[1]);
	var obj=document.getElementById("TListModelz"+selectrow);
	if (obj) websys_nextfocusElement(obj); 
}

function ExtendType_Change()
{
	selectrow=GetTableCurRow();
	//alertShow(selectrow+"---"+GetElementValue("TExtendTypez"+selectrow))
	SetElement("TExtendIDz"+selectrow,"");
	SetElement("TItemz"+selectrow,"");
	SetElement("TItemDRz"+selectrow,"");
	SetElement("TModelz"+selectrow,"");
	SetElement("TModelDRz"+selectrow,"");
	SetElement("TQuantityz"+selectrow,"");
	SetElement("TWinPricez"+selectrow,"");
	SetElement("TAmountz"+selectrow,"");
	SetElement("TManuFactoryz"+selectrow,"");
	SetElement("TManuFactoryDRz"+selectrow,"");
	SetElement("TUnitz"+selectrow,"");
	SetElement("TUnitDRz"+selectrow,"");
	
	SetElement("TExtendTypeDRz"+selectrow,GetElementValue("TExtendTypez"+selectrow));
}
/*
function LookUpTExtendID(value)
{
	if (event.keyCode==13||event.keyCode==0)
	{
		if (CheckNull()) return;
		selectrow=GetTableCurRow();
		var TExtendType=GetElementValue('TExtendTypez'+selectrow);
		if (TExtendType==1)  		//采购申请
		{
			LookUp("","web.DHCEQBuyRequestList:GetBuyRequestListByItem","GetTExtendIDID","TExtendIDz"+selectrow);
		}
		else if (TExtendType==2)	//采购计划
		{
			LookUp("","web.DHCEQBuyPlanList:GetBuyPlanListByItem","GetTExtendIDID","TExtendIDz"+selectrow);
		}
	}
}*/
function GetTExtendIDID(value)
{
	//ClearValue();
	var list=value.split("^");
	var Length=ObjSources.length;
	for (var i=1;i<Length;i++)
	{
		//alertShow(i+"&"+tableList[i]+"&"+ObjSources[i].SourceType+"&"+ObjSources[i].SourceID+"&"+list[0]);
		if ((tableList[i]=="0")&&(ObjSources[i].SourceType=="2")&&(ObjSources[i].SourceID==list[0])&&(selectrow!=i))
		{
			alertShow("选择的采购计划明细与第"+GetCElementValue("TRowz"+i)+"行重复!")
			return;
		}
	}
	SetElement('TExtendIDz'+selectrow,list[0]);
	SetElement('TExtendNamez'+selectrow,list[3]);
	SetElement('TItemz'+selectrow,list[1]);
	SetElement('TItemDRz'+selectrow,list[11]);
	SetElement('TQuantityz'+selectrow,list[9]);
	SetElement('TWinPricez'+selectrow,list[8]);
	SetElement('TAmountz'+selectrow,list[8]*list[9]);
	SetElement('TModelz'+selectrow,list[5]);
	SetElement('TModelDRz'+selectrow,list[4]);
	SetElement('TManuFactoryz'+selectrow,list[7]);
	SetElement('TManuFactoryDRz'+selectrow,list[6]);
	
	SetElement('TUnitDRz'+selectrow,list[12]);
	SetElement('TUnitz'+selectrow,list[13]);
	SetElement('TCommonNamez'+selectrow,list[16]); 	//2013-06-24 DJ0118
	
	
	//alertShow(selectrow+"&"+GetElementValue("TExtendTypeDRz"+selectrow)+"&"+list[0]);
	ObjSources[selectrow]=new SourceInfo(GetElementValue("TExtendTypez"+selectrow),list[0]);
	var obj=document.getElementById("TExtendIDz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
	SumList_Change() 
}
function AddClickHandler()
{
	try
	{
		var objtbl=document.getElementById('tDHCEQIFB');
		var ret=CanAddRow(objtbl);
		if (ret)
		{
			NewNameIndex=tableList.length;
	    	AddRowToList(objtbl,LastNameIndex,NewNameIndex);
			ObjSources[NewNameIndex]=new SourceInfo("","");
	    	var TBList=document.getElementById("TBListz"+NewNameIndex);
			if (TBList)	TBList.onclick=VenderListClick;
			SetElement("TExtendTypeDRz"+NewNameIndex,GetElementValue("TExtendTypez"+NewNameIndex));
	    }
	} catch(e) {};
}
//检测是否可以增加新记录
function CanAddRow(objtbl)
{
	var rows=objtbl.rows.length;
    if (rows==1) return false;
	var TotalFlag=GetElementValue("TotalFlag") //合计行设置参数值
	if (TotalFlag==2) rows=rows-1
	LastNameIndex=GetRowIndex(objtbl.rows[rows-1]);
	var TBagNo=GetElementValue("TBagNoz"+LastNameIndex)
	var TItemDR=GetElementValue("TItemDRz"+LastNameIndex)
	var TQuantity=GetElementValue("TQuantityz"+LastNameIndex)
	var TListVendorDR=GetElementValue("TListVendorDRz"+LastNameIndex)
	if  (TBagNo=="")
	{
		alertShow("包号不能为空")   //add by wy 2018-2-11
		SetFocusColumn("TBagNo",LastNameIndex);
		return false;
	}
	
	return true;
}

function DeleteClickHandler()
{
	var truthBeTold = window.confirm(t["-4003"]);
	if (!truthBeTold) return;
	try
	{
		var objtbl=document.getElementById('tDHCEQIFB');
		var rows=objtbl.rows.length;
		selectrow=GetTableCurRow();
		var TotalFlag=GetElementValue("TotalFlag");
		var TRowID=GetElementValue('TRowIDz'+selectrow);
		tableList[selectrow]=TRowID;
		//判断是否删除仅剩的1行记录
		if (((TotalFlag==0)&&(rows<=2))||((rows<=3)&&((TotalFlag==1)||(TotalFlag==2))))
		{
			//Modified by jdl 2011-01-28 JDL0068
			//修改删除仅剩的一行后,编辑保存数据异常,无法保存的问题
			tableList[selectrow]=0;
			if (TRowID!="")
			{
				SetElement('TRowIDz'+selectrow,"");				
				tableList[tableList.length]=TRowID;
			}
			ClearValue();
		}
		else
		{
			DeleteTabRow(objtbl,selectrow);
			if (TotalFlag!=0)
			{
				SumList_Change();
			}
		}
	} catch(e) {};
}
function DeleteTabRow(objtbl,selectrow)
{
	var rows=objtbl.rows.length;
	if (rows>2)
	{
		var eSrc=window.event.srcElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;
		objtbl.deleteRow(selectrow);
	}
}
function GetTableInfo()
{
	//alertShow(tableList.toString())
	var rows=tableList.length;
	var valList="";
	for(var i=1;i<rows;i++)
	{
		//alertShow(rows+"   第"+i+"行  "+tableList[i])
		var TRow=GetCElementValue("TRowz"+i);
		if (tableList[i]=="0") //等于0表示页面显示记录
		{
			var TItemDR=GetElementValue("TItemDRz"+i);
			//alertShow("第"+i+"行  设备ID: "+TItemDR)
			if (TItemDR=="")
			{
				alertShow("第"+TRow+"行未选择设备!!!")
				return -1			
			}
			var TRowID=GetElementValue("TRowIDz"+i);
			var TBagNo=GetElementValue("TBagNoz"+i);
			if (TBagNo=="")
			{
				alertShow("第"+TRow+"行必填项包号不能为空,请检查!")
				return "-1"
			}
			var TUnitDR=GetElementValue("TUnitDRz"+i);
			var TQuantity=GetElementValue("TQuantityz"+i);
			var TManuFactoryDR=GetElementValue("TManuFactoryDRz"+i);
			var TModelDR=GetElementValue("TModelDRz"+i);
			var TArg=GetElementValue("TArgz"+i);
			var	ExtendType=GetElementValue("TExtendTypez"+i);
			if (ExtendType=="")
			{
				alertShow("第"+TRow+"行来源类型为空,请检查!")
				return "-1"
			}
			var	ExtendID=GetElementValue("TExtendIDz"+i);
			var	WinPrice=GetElementValue("TWinPricez"+i);
			var	Remark=GetElementValue("TRemarkz"+i);
			if(valList!="") {valList=valList+"&";}
			valList=valList+TRowID+"^"+TBagNo+"^"+TItemDR+"^"+TUnitDR+"^"+TQuantity+"^"+TManuFactoryDR+"^"+TModelDR+"^"+TArg+"^"+ExtendType+"^"+ExtendID+"^"+WinPrice+"^"+Remark;
			
			var TListRowID=GetElementValue("TListRowIDz"+i);
			var	VendorDR=GetElementValue("TListVendorDRz"+i);
			if (VendorDR=="")
			{
				alertShow("第"+TRow+"行供应商为空,请检查!")
				return "-1"
			}
			var	ListManuFactoryDR=GetElementValue("TListManuFactoryDRz"+i);
			var	ListModelDR	=GetElementValue("TListModelDRz"+i);
			var	ListArg=GetElementValue("TListArgz"+i);
			var	Price=GetElementValue("TListPricez"+i);
			var	Amount=trim(GetElementValue("TAmountz"+i));
			var	CandidacySeq=GetElementValue("TListCandidacySeqz"+i);
			var	Score=GetElementValue("TListScorez"+i);
			var	ListRemark=GetElementValue("TListRemarkz"+i);
			var TCommonName=GetElementValue("TCommonNamez"+i)	//2013-06-24 DJ0118
			if (CheckInvalidData(i)) return -1;
			valList=valList+"^"+TListRowID+"^"+VendorDR+"^"+ListManuFactoryDR+"^"+ListModelDR+"^"+ListArg+"^"+Price+"^"+Amount+"^"+CandidacySeq+"^"+Score+"^"+ListRemark+"^"+TCommonName; //2013-06-24 DJ0118
		}
	}
	return valList;
}

function SumList_Change()
{
	var length=tableList.length
	var Num=0
	var Fee=0
	var index=""
	for (var i=1;i<length;i++)
	{
		if (tableList[i]==0)
		{
			var TQuantity=+GetElementValue("TQuantityz"+i);
			var TWinPrice=+GetElementValue("TWinPricez"+i);
			//Mozy0049	2011-3-30
			SetElement('TAmountz'+i,"");
			if (IsValidateNumber(TQuantity,0,0,0,0)==0)
			{
				//alertShow("设备数量数据异常,请修正.");
				//SetElement("TQuantityz"+i,"");
				return -1;
			}
			if (IsValidateNumber(TWinPrice,0,1,0,1)==0)
			{
				//alertShow("设备中标价格数据异常,请修正.");
				//SetElement("TWinPricez"+i,"");
				return -1;
			}
			var TotalFee=TQuantity*TWinPrice;
			SetElement('TAmountz'+i,TotalFee.toFixed(2));
			Num=Num+TQuantity;
			Fee=Fee+TotalFee;
		}
		if (tableList[i]==-1)
		{
			index=i;
		}
	}
	SetElement('TQuantityz'+index,Num);
	SetElement('TAmountz'+index,Fee.toFixed(2));
}
function VenderListClick()
{
	selectrow=GetTableCurRow();
	var TRowID=GetElementValue("TRowIDz"+selectrow);
	if (TRowID=="") return;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQIFBList";
	lnk=lnk+"&IFBBagDR="+TRowID+"&ReadOnly="+GetElementValue("ReadOnly");
   	window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
}

function GetModeDR(value)
{
	var list=value.split("^");
	//alertShow(value)
	SetElement("Mode",list[0]);
	SetElement("ModeDR",list[1]);
}
function GetCurrencyDR(value)
{
	GetLookUpID("CurrencyDR",value);
}
function SetDisplay()
{
	ReadOnlyCustomItem(GetParentTable("PrjName"),GetElementValue("Status"));
}
function ClearValue()
{
	SetElement('TRowIDz'+selectrow,"");
	SetElement('TBagNoz'+selectrow,"");
	//SetElement('TExtendTypez'+selectrow,""); //modified by GR 2014-10-09 保留来源类型字段 缺陷号3288
	SetElement('TExtendNamez'+selectrow,"") // modified by GR 2014-10-09 清空TExtendNamez1字段 3286
	SetElement('TExtendIDz'+selectrow,"");
	SetElement('TItemz'+selectrow,"");
	SetElement('TItemDRz'+selectrow,"");
	SetElement('TModelz'+selectrow,"");
	SetElement('TModelDRz'+selectrow,"");
	SetElement('TManuFactoryz'+selectrow,"");
	SetElement('TManuFactoryDRz'+selectrow,"");
	SetElement('TQuantityz'+selectrow,"");
	SetElement('TWinPricez'+selectrow,"");
	SetElement('TAmountz'+selectrow,"");
	SetElement('TUnitz'+selectrow,"");
	SetElement('TUnitDRz'+selectrow,"");
	SetElement('TArgz'+selectrow,"");
	SetElement('TRemarkz'+selectrow,"");
	SetElement('TListRowIDz'+selectrow,"");
	SetElement('TListVendorDRz'+selectrow,"");
	SetElement('TListVendorz'+selectrow,"");
	SetElement('TListManuFactoryDRz'+selectrow,"");
	SetElement('TListManuFactoryz'+selectrow,"");
	SetElement('TListModelDRz'+selectrow,"");
	SetElement('TListModelz'+selectrow,"");
	SetElement('TListArgz'+selectrow,"");
	SetElement('TListPricez'+selectrow,"");
	SetElement('TListCandidacySeqz'+selectrow,"");
	SetElement('TListScorez'+selectrow,"");
	SetElement("TCommonNamez"+selectrow,"");	//2013-06-24 DJ0118
}
function CheckInvalidData(i)
{
	if (IsValidateNumber(GetElementValue("TQuantityz"+i),0,0,0,0)==0)
	{
		alertShow("设备数量数据异常,请修正.");
		//SetElement("TQuantityz"+i,"");
		return true;
	}
	if (IsValidateNumber(GetElementValue("TWinPricez"+i),0,1,0,1)==0)
	{
		alertShow("设备中标价格数据异常,请修正.");
		//SetElement("TWinPricez"+i,"");
		return true;
	}
	/*if (IsValidateNumber(GetElementValue("TListPricez"+i),0,1,0,1)==0)
	{
		alertShow("设备单价数据异常,请修正.");
		//SetElement("TListPricez"+i,"");
		return true;
	}*/
	return false;
}
function IsValidTimeCheck()  //add by GR 2014-10-09 增加时间格式及顺序正确性检验 缺陷号3188
{
	var BuyFileFromTime=document.getElementById('BuyFileFromTime');
	if (!IsValidTime(BuyFileFromTime)) {alertShow("购买标书开始时间不正确"); return true}
	var BuyFileToTime=document.getElementById('BuyFileToTime');
	if (!IsValidTime(BuyFileToTime)) {alertShow("购买标书结束时间不正确"); return true}
	var OpenTime=document.getElementById('OpenTime');
	if (!IsValidTime(OpenTime)) {alertShow("开标时间不正确"); return true}
	var DeadlineTime=document.getElementById('DeadlineTime');
	if (!IsValidTime(DeadlineTime)) {alertShow("投标截至时间不正确"); return true}
	
	var OpenDate=document.getElementById('OpenDate');
	var DeadlineDate=document.getElementById('DeadlineDate');
	if (changeDateformat(OpenDate.value)>changeDateformat(DeadlineDate.value))
	{
		alertShow("截至日期不能早于开标日期");
		return true
	}
				
	var BuyFileFromDate=document.getElementById('BuyFileFromDate');
	var BuyFileToDate=document.getElementById('BuyFileToDate');
	if ((""!=BuyFileFromDate.value)&&(""!=BuyFileToDate.value))
	{
		if (changeDateformat(BuyFileFromDate.value)>changeDateformat(BuyFileToDate.value))
		{
			alertShow("购买标书开始日期不能晚于购买标书结束日期");
			return true
		}
	}
	
	return false
	}
function changeDateformat(Date)         //add by GR 2014/10/10 增加将日月年格式转化为年月日格式的函数 缺陷号3188[1]
{
	var date=Date.split("/")
	var temp=date[2]+"/"+date[1]+"/"+date[0];   //日期格式变换
	return temp;
}
document.body.onload = BodyLoadHandler;