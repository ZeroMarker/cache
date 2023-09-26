/// Mozy	20151029	保修合同
var selectrow=0;
var ObjSources=new Array();
var LastNameIndex;
var NewNameIndex;
var CustomValue;	//格式:1^计划&2^招标
document.body.onload = BodyLoadHandler;

function BodyLoadHandler() 
{
	//alertShow("默认合同类型:保修")
	SetElement("ContractType",1);	//默认合同类型:保修
	InitUserInfo();
	InitPage();
	FillData();
	SetSourceType();
	SetEnabled();
	InitEditFields(GetElementValue("ApproveSetDR"),GetElementValue("CurRole"));
	InitApproveButton();
	SetTableItem('','','');
	SetDisplay();
	SetElement("Job",GetElementValue("TJobz1"));
	KeyUp("NeedHandler^Provider^PayType^SignLoc^ServicePro","N");
	Muilt_LookUp("NeedHandler^Provider^PayType^SignLoc^ServicePro","N");
	document.body.onunload = BodyUnloadHandler;
}
function SetEnabled()
{
	var Type=GetElementValue("Type");
	var Status=GetElementValue("Status");
	var ContractNoFlag=GetElementValue("ContractNoFlag");
	if (Status=="0")
	{
		DisableBElement("BCancelSubmit",true);
	}
	else if (Status=="1")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		//DisableBElement("BPicture",true);		//需求序号:	413725		Mozy	20170728	取消上传图片禁用设置
	}
	else if (Status=="2")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BCancelSubmit",true);
		//DisableBElement("BPicture",true);		//需求序号:	413725		Mozy	20170728	取消上传图片禁用设置
	}
	else if (Status=="")
	{
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
	}
	if (Type=="0")
	{
		DisableBElement("BCancelSubmit",true);
	}
	else
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAdd",true);
		//DisableBElement("BPicture",true);		//需求序号:	413725		Mozy	20170728	取消上传图片禁用设置
	}
	if (ContractNoFlag==1)
	{
		DisableElement("ContractNo",true)
		var obj=document.getElementById("cContractNo");
		if (obj) obj.className="";
	}
}

function FillData()
{
	var obj=document.getElementById("RowID");
	var RowID=obj.value;
	if ((RowID=="")||(RowID<1)){
		return;
	}
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	var sort=52;
	SetElement("ContractName",list[0]);
	SetElement("ContractNo",list[1]);
	SetElement("QuantityNum",list[2]);
	SetElement("TotalFee",list[3]);
	SetElement("PreFeeFee",list[4]);
	SetElement("PayedTotalFee",list[5]);
	SetElement("SignDate",list[6]);
	SetElement("SignLocDR",list[7]);
	SetElement("DeliveryDate",list[8]);
	SetElement("ArriveDate",list[9]);
	SetElement("StartDate",list[10]);
	SetElement("EndDate",list[11]);
	SetElement("ClaimPeriodNum",list[12]);
	SetElement("Service",list[13]);
	SetElement("PayTypeDR",list[14]);
	SetElement("PayItem",list[15]);
	SetElement("CheckStandard",list[16]);
	SetElement("ProviderDR",list[17]);
	SetElement("ProviderTel",list[18]);
	SetElement("ProviderHandler",list[19]);
	SetElement("BreakItem",list[20]);
	SetElement("NeedHandlerDR",list[21])
	SetElement("GuaranteePeriodNum",list[22]);
	SetElement("Status",list[23]);
	SetElement("Remark",list[24]);
	/*SetElement("AddUserDR",list[25]);
	SetElement("AddUser",list[sort+4]);
	SetElement("AddDate",list[26]);
	SetElement("AddTime",list[27]);
	SetElement("UpdateUserDR",list[28]);
	SetElement("UpdateUser",list[sort+5]);
	SetElement("UpdateDate",list[29]);
	SetElement("UpdateTime",list[30]);
	SetElement("AuditUserDR",list[31]);
	SetElement("AuditUser",list[sort+6]);
	SetElement("AuditDate",list[32]);
	SetElement("AuditTime",list[33]);*/
	SetElement("ArriveMonthNum",list[34]);
	SetElement("ServiceProDR",list[35]);;
	SetElement("ServiceHandler",list[36]);
	SetElement("ServiceTel",list[37]);
	SetElement("ContractType",list[38]);
	SetElement("ArriveItem",list[39]);
	SetElement("QualityItem",list[40]);
	SetElement("RejectReason",list[41]);
	/*
	SetElement("RefuseUserDR",list[42]);
	SetElement("RefuseDate",list[43]);
	SetElement("RefuseTime",list[44]);
	*/
	SetElement("IFBNo",list[45]);
	SetElement("CurrencyDR",list[46]);
	SetElement("Hold1",list[47]);
	SetElement("Hold2",list[48]);
	SetElement("Hold3",list[49]);
	SetElement("Hold4",list[50]);
	SetElement("Hold5",list[51]);
	
	SetElement("SignLoc",list[sort+0]);
	SetElement("PayType",list[sort+1]);
	SetElement("Provider",list[sort+2]);
	SetElement("NeedHandler",list[sort+3]);
	SetElement("ServicePro",list[sort+7]);
	
	SetElement("ApproveSetDR",list[sort+9]);
	SetElement("NextRoleDR",list[sort+10]);
	SetElement("NextFlowStep",list[sort+11]);
	SetElement("ApproveStatu",list[sort+12]);
	SetElement("ApproveRoleDR",list[sort+13]);
	SetElement("CancelFlag",list[sort+14]);
	SetElement("CancelToFlowDR",list[sort+15]);
	SetElement("Opinion",list[sort+18]);
	
	encmeth=GetElementValue("GetApproveByRource");
	var ApproveListInfo=cspRunServerMethod(encmeth,"8",RowID);
	
	FillEditOpinion(ApproveListInfo,"EditOpinion")
}

function InitPage()
{
	var obj=document.getElementById("ContractType");
	if (obj) obj.onchange=ContractType;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Clicked;	
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Clicked;	
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Clicked;	
	var obj=document.getElementById("BCancelSubmit");
	if (obj) obj.onclick=BCancelSubmit_Clicked;	
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=AddClickHandler;
	var obj=document.getElementById("BPicture");
	if (obj) obj.onclick=BPicture_Click;
}

function GetContractInfoList()
{
	var combindata="";
	combindata=GetElementValue("RowID") ;
	combindata=combindata+"^"+GetElementValue("ContractName") ;
	combindata=combindata+"^"+GetElementValue("ContractNo") ;
	combindata=combindata+"^"+GetElementValue("QuantityNum") ;
	combindata=combindata+"^"+GetElementValue("TotalFee") ;
	combindata=combindata+"^"+GetElementValue("PreFeeFee") ;
	combindata=combindata+"^"+GetElementValue("PayedTotalFee") ;
	combindata=combindata+"^"+GetElementValue("SignDate") ;
	combindata=combindata+"^"+GetElementValue("SignLocDR") ;
	combindata=combindata+"^"+GetElementValue("DeliveryDate") ;
	combindata=combindata+"^"+GetElementValue("ArriveDate") ;
	combindata=combindata+"^"+GetElementValue("StartDate") ;
	combindata=combindata+"^"+GetElementValue("EndDate") ;
	combindata=combindata+"^"+GetElementValue("ClaimPeriodNum") ;
	combindata=combindata+"^"+GetElementValue("Service") ;
	combindata=combindata+"^"+GetElementValue("PayTypeDR") ;
	combindata=combindata+"^"+GetElementValue("PayItem") ;
	combindata=combindata+"^"+GetElementValue("CheckStandard") ;
	combindata=combindata+"^"+GetElementValue("ProviderDR") ;
	combindata=combindata+"^"+GetElementValue("ProviderTel") ;
	combindata=combindata+"^"+GetElementValue("ProviderHandler") ;
	combindata=combindata+"^"+GetElementValue("BreakItem") ;
	combindata=combindata+"^"+GetElementValue("NeedHandlerDR") ;
	combindata=combindata+"^"+GetElementValue("GuaranteePeriodNum") ;
	combindata=combindata+"^"+GetElementValue("Status") ;
	combindata=combindata+"^"+GetElementValue("Remark") ;	
	/*
	combindata=combindata+"^"+GetElementValue("SubmitUserDR") ;
	combindata=combindata+"^"+GetElementValue("SubmitDate") ;
	combindata=combindata+"^"+GetElementValue("SubmitTime") ;
	combindata=combindata+"^"+GetElementValue("UpdateUserDR") ;
	combindata=combindata+"^"+GetElementValue("UpdateDate") ;
	combindata=combindata+"^"+GetElementValue("UpdateTime") ;
	combindata=combindata+"^"+GetElementValue("AuditUserDR") ;
	combindata=combindata+"^"+GetElementValue("AuditDate") ;
	combindata=combindata+"^"+GetElementValue("AuditTime") ;
	*/
	combindata=combindata+"^"+GetElementValue("ArriveMonthNum") ;
	combindata=combindata+"^"+GetElementValue("ServiceProDR") ;
	combindata=combindata+"^"+GetElementValue("ServiceHandler") ;
	combindata=combindata+"^"+GetElementValue("ServiceTel") ;
	combindata=combindata+"^"+GetElementValue("ContractType") ;
	combindata=combindata+"^"+GetElementValue("ArriveItem") ;
	combindata=combindata+"^"+GetElementValue("QualityItem") ;
	/*
	combindata=combindata+"^"+GetElementValue("RejectReason") ;
	combindata=combindata+"^"+GetElementValue("RefuseUserDR") ;
	combindata=combindata+"^"+GetElementValue("RefuseDate") ;
	combindata=combindata+"^"+GetElementValue("RefuseTime") ;
	*/
	combindata=combindata+"^"+GetElementValue("IFBNo") ;
	combindata=combindata+"^"+GetElementValue("CurrencyDR") ;
	combindata=combindata+"^"+GetElementValue("Hold1") ;
	combindata=combindata+"^"+GetElementValue("Hold2") ;
	combindata=combindata+"^"+GetElementValue("Hold3") ;
	combindata=combindata+"^"+GetElementValue("Hold4") ;
	combindata=combindata+"^"+GetElementValue("Hold5") ;
	combindata=combindata+"^"+GetElementValue("Job") ;

	return combindata;
}

function GetValueList()
{
	var combindata="";
	combindata=GetElementValue("RowID") ;
	combindata=combindata+"^"+GetElementValue("ApproveSetDR") ;
	combindata=combindata+"^"+GetElementValue("CancelToFlowDR") ;
	combindata=combindata+"^"+GetElementValue("Job") ;
	combindata=combindata+"^"+Guser ;
  	combindata=combindata+"^"+GetElementValue("EditOpinion");
  	combindata=combindata+"^"+GetElementValue("RejectReason");
	return combindata;
}
function BUpdate_Clicked()
{
	var GetProviderOperMethod=GetElementValue("GetProviderOperMethod")
	if (GetElementValue("Provider")!="")
	{
		var RProvDR=GetProviderRowID(GetProviderOperMethod)
	    if (RProvDR<=0)
	    {
		    alertShow("供应商登记错误!")
		    return
	    }
	    else
	    {
		    SetElement("ProviderDR",RProvDR);
	    }
	}
	if (CheckNull()) return;
	var combindata=GetContractInfoList();
  	var valList=GetTableInfo();
  	if (valList=="-1")
  	{
	  	//Mozy	2017-11-10	468611		增加错误信息提示
	  	alertShow("明细记录数据异常.");
	  	return;
  	}
  	var DelRowid=tableList.toString()
  	var encmeth=GetElementValue("UpdateData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata,valList,DelRowid);
    if (Rtn>0)
    {
		ShowMessage();
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQContractForMaint&RowID='+Rtn+"&Type="+GetElementValue("Type")+"&QXType="+GetElementValue("QXType");
	}
    else
    {
	    alertShow(EQMsg("操作失败",Rtn))
    }
}

function BDelete_Clicked()
{	
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	var combindata=GetValueList();
  	var encmeth=GetElementValue("DeleteData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata);
	if (Rtn=="0")
    {
	    var Type=GetElementValue("Type");
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQContractForMaint&Type='+Type
	}
    else
    {
	    alertShow(EQMsg("操作失败",t[Rtn]))
    }
}
function BSubmit_Clicked()
{
	if (CheckNull()) return;
	var combindata=GetValueList();
  	var valList=GetTableInfo();
  	if (valList=="")
  	{
	  	alertShow(EQMsg("明细不能为空",""))
	  	return;
	}
  	var encmeth=GetElementValue("SubmitData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata);
	//alertShow(Rtn);
	if (Rtn>0)
    {
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQContractForMaint&RowID='+Rtn;
	}
    else
    {
	    alertShow(EQMsg("",t[Rtn]))
    }
}
function BCancelSubmit_Clicked()
{	
	var RejectReason=GetElementValue("RejectReason");
	if (RejectReason=="") 
	{
		alertShow('拒绝原因不能为空!');
		SetFocus("RejectReason")
		return;
	}
	var combindata=GetValueList();
  	var CurRole=GetElementValue("CurRole")
  	if (CurRole=="") return;
  	var encmeth=GetElementValue("CancelSubmitData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata,CurRole);
    if (Rtn>0)
    {
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQContractForMaint&RowID='+Rtn+"&QXType="+GetElementValue("QXType");
	}
    else
    {
	    alertShow(EQMsg("操作失败",t[Rtn]))
    }
}

function BApprove_Clicked()
{
	var EditOpinion=GetElementValue("EditOpinion");
	if (EditOpinion=="") 
	{
		alertShow('审批意见不能为空!');
		SetFocus("EditOpinion")
		return;
	}
	var combindata=GetValueList();
	var CurRole=GetElementValue("CurRole")
  	if (CurRole=="") return;
	var RoleStep=GetElementValue("RoleStep")
  	if (RoleStep=="") return;
  	
  	var objtbl=document.getElementById('tDHCEQContractForMaint');
	var EditFieldsInfo=ApproveEditFieldsInfo(objtbl);
	if (EditFieldsInfo=="-1") return;
	
  	var encmeth=GetElementValue("AuditData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata,CurRole,RoleStep,EditFieldsInfo);
    if (Rtn>0)
    {
	    window.location.reload();
	}
    else
    {
	    alertShow(EQMsg("操作失败",t[Rtn]))
    }
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	return false;
}
function GetNeedHandler (value)
{
    GetLookUpID("NeedHandlerDR",value);
}
function GetProvider (value)
{
    GetLookUpID("ProviderDR",value);
    var list=value.split("^");
    SetElement("ProviderHandler",list[4]);
    SetElement("ProviderTel",list[5]);
}
function GetPayType (value)
{
    GetLookUpID("PayTypeDR",value);
}
function GetSignLoc (value)
{
    GetLookUpID("SignLocDR",value);
}
function GetServicePro (value)
{
    GetLookUpID("ServiceProDR",value);
}

function SetTableItem(RowNo,SourceType,selectrow)
{
	var objtbl=document.getElementById('tDHCEQContractForMaint');
	var rows=objtbl.rows.length-1;
	if (RowNo=="")
	{
		for (var i=1;i<=rows;i++)
		{
			var TSourceID=document.getElementById("TSourceIDDRz"+i).value;
			var TSourceType=GetElementValue("TSourceTypeDRz"+i);
			ObjSources[i]=new SourceInfo(TSourceType,TSourceID);
			tableList[i]=0;
			var TRowID=GetElementValue("TRowIDz"+i);
			var TotalFlag=GetElementValue("TotalFlag")
			if (TRowID==-1)
			{				
				if ((TotalFlag==1)||(TotalFlag==2))
				{
					obj=document.getElementById("TRowz"+i);
					if (obj) obj.innerText="合计:"
					obj=document.getElementById("BDeleteListz"+i);
					if (obj) obj.innerText=""
					obj=document.getElementById("ContractConfigz"+i);
					if (obj) obj.innerText=""
					tableList[i]=-1;
					continue;
				}
			}
			ChangeRowStyle(objtbl.rows[i],TSourceType);		///改变一行的内容显示
		}
	}
	else
	{
		if (selectrow=='') selectrow=RowNo
		tableList[RowNo]=0;
		ChangeRowStyle(objtbl.rows[selectrow],SourceType);		///改变一行的内容显示
	}
}

///改变一行的内容显示
function ChangeRowStyle(RowObj,SourceType)
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
		
		if (colName=="TSourceType")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetElementValue("TSourceTypeDRz"+objindex);	
			html=CreatElementHtml(4,Id,objwidth,objheight,"KeyDown_Tab","SourceType_Change",CustomValue,"")
		}
		else if (colName=="TSourceID")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpSourceID","","","Standard_TableKeyUp")
		}
		else if (colName=="TContractArriveDate")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText
			html=CreatElementHtml(3,Id,objwidth,objheight,"LookUpTableDate","TDate_changehandler","","")
		}
		else if (colName=="TModel")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
			if ((GetElementValue("TSourceTypez"+objindex)==1))
			{
         		html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpModelNew","","","Standard_TableKeyUp")
			}
			else if ((GetElementValue("TSourceTypez"+objindex)==2))
			{
         		html=CreatElementHtml(0,Id,objwidth,objheight,"","","","")	
			}
			else if ((GetElementValue("TSourceTypez"+objindex)==3))
			{
         		html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpModelNew","","","Standard_TableKeyUp")	
			}
		}
		else if (colName=="TManuFactory")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
			if ((GetElementValue("TSourceTypez"+objindex)==1))
			{
         		html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpManuFactoryNew","","","Standard_TableKeyUp")
			}
			else if ((GetElementValue("TSourceTypez"+objindex)==2))
			{
         		html=CreatElementHtml(0,Id,objwidth,objheight,"","","","")	
			}
			else if ((GetElementValue("TSourceTypez"+objindex)==3))
			{
         		html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpManuFactoryNew","","","Standard_TableKeyUp")	
			}
		}
		else if (colName=="TPriceFee")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
			if ((GetElementValue("TSourceTypez"+objindex)==1))
			{
         		html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","TotalFee_Change")
			}
			else if ((GetElementValue("TSourceTypez"+objindex)==2))
			{
         		html=CreatElementHtml(0,Id,objwidth,objheight,"","","","")	
			}
			else if ((GetElementValue("TSourceTypez"+objindex)==3))
			{
         		html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","TotalFee_Change")
			}
		}
		else if (colName=="TQuantityNum")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
			if ((GetElementValue("TSourceTypez"+objindex)==1))
			{
         		html=CreatElementHtml(1,Id,objwidth,objheight,"","","","TotalFee_Change")
			}
			else if ((GetElementValue("TSourceTypez"+objindex)==2))
			{
         		html=CreatElementHtml(0,Id,objwidth,objheight,"","","","")	
			}
			else if ((GetElementValue("TSourceTypez"+objindex)==3))
			{
         		html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","TotalFee_Change")	
			}
		}
		else if (colName=="TRemark")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")	
		}
		else if (colName=="BDeleteList")
		{
			if (Status>0)
			{
				HiddenObj(colName+"z"+objindex,1)
				continue;
			}
			RowObj.cells[j].onclick=DeleteClickHandler;
		}
		else if (colName=="TCommonName")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		//document.getElementById(ColId).parentNode.firstChild.value=trim(value);
		if (html!="") RowObj.cells[j].innerHTML=html;
		if (value!="")
		{
		    if (RowObj.cells[j].firstChild.tagName=="LABEL")
		    {
			    value=trim(value);
			    RowObj.cells[j].firstChild.innerText=value;
			}
			else
		    {			    
			    if ((RowObj.cells[j].firstChild.tagName=="INPUT")&&(RowObj.cells[j].firstChild.type=="checkbox"))
			    {
				    if (value==true)
				    {
					    RowObj.cells[j].firstChild.checked=true;
				    }
				    else
				    {
					    RowObj.cells[j].firstChild.checked=false;
					}
				}
			    else
			    {
				    value=trim(value);
			    	RowObj.cells[j].firstChild.value=value;
			    }
		    }
		}
	}
}

function SourceType_Change()
{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCEQContractForMaint'); //得到表格   t+组件名称
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	selectrow=rowObj.rowIndex;								//当前选择行
	RowNo=GetTableCurRow();
	var TSourceType=GetElementValue("TSourceTypez"+RowNo)
	SetElement("TSourceTypeDRz"+RowNo,TSourceType);
	if (TSourceType==1)
	{
		SetTableItem(RowNo,"1",selectrow);		///计划
	}
	else if (TSourceType==2)
	{
		SetTableItem(RowNo,"2",selectrow);		///招标
	}
	else if (TSourceType==3)
	{
		SetTableItem(RowNo,"3",selectrow);		///设备项
	}
	selectrow=RowNo;
	Clear();
	SetFocusColumn("TSourceType",selectrow)
}

function AddClickHandler() {
	try 
	{
		var objtbl=document.getElementById('tDHCEQContractForMaint');
		var ret=CanAddRow(objtbl);
		if (ret)
		{
			NewNameIndex=tableList.length;
			AddRowToList(objtbl,LastNameIndex,NewNameIndex);
	    
			//设置默认的来源类型与上一行一致
			var PreSourceType=GetElementValue("TSourceTypez"+LastNameIndex);
			SetElement("TSourceTypez"+NewNameIndex,PreSourceType);
	    }
      return false;
	} 
	catch(e) 
	{};
}
function CanAddRow(objtbl)
{
	var rows=objtbl.rows.length;
	if (rows==1) return false;
	var TotalFlag=GetElementValue("TotalFlag")
	if (TotalFlag==2) rows=rows-1
	LastNameIndex=GetRowIndex(objtbl.rows[rows-1]);
	//var TSourceType=document.getElementById('TSourceTypez'+LastNameIndex).value
	//alertShow(GetElementValue('TSourceTypez'+LastNameIndex))
	if  (GetElementValue('TSourceTypez'+LastNameIndex)=="")
	{
		SetFocusColumn("TSourceType",LastNameIndex);
		return false;
	}
	if  (GetElementValue('TSourceIDz'+LastNameIndex)=="")
	{
		SetFocusColumn("TSourceID",LastNameIndex);  //modify by lmm 2017-08-02 371626
	 	return false;
	}
	return true;
}

///OK
function DeleteClickHandler() {
	var truthBeTold = window.confirm(t["-4003"]);
	if (!truthBeTold) return;
	try
	{
		var objtbl=document.getElementById('tDHCEQContractForMaint');
		var rows=objtbl.rows.length;
		selectrow=GetTableCurRow();
		var TotalFlag=GetElementValue("TotalFlag")
		var TRowID=GetElementValue('TRowIDz'+selectrow);
		tableList[selectrow]=TRowID;
		var delNo=GetElementValue("TRowz"+selectrow);
		if (((TotalFlag==0)&&(rows<=2))||((rows<=3)&&((TotalFlag==1)||(TotalFlag==2))))
		{
			tableList[selectrow]=0;
			if (TRowID!="")
			{
				SetElement('TRowIDz'+selectrow,"");				
				tableList[tableList.length]=TRowID;
			}
			Clear();
		} 
		else
		{
	    var eSrc=window.event.srcElement;
			var rowObj=getRow(eSrc);
			objtbl.deleteRow(rowObj.rowIndex);
		}
		ResetNo(selectrow,delNo);
	    SumList_Change();
	} 
	catch(e) 
	{};
}

///整理该方法
function GetTableInfo()
{
    var objtbl=document.getElementById('tDHCEQContractForMaint');
	var rows=tableList.length
	var valList="";
	for(var i=1;i<rows;i++)
	{
		if (tableList[i]=="0")
		{
			var TRow=GetCElementValue("TRowz"+i);
			var TRowID=GetElementValue("TRowIDz"+i);
			var TSourceType=GetElementValue("TSourceTypez"+i);
			var TSourceID=GetElementValue("TSourceIDz"+i);
			var TSourceIDDR=GetElementValue("TSourceIDDRz"+i);
			if (TSourceIDDR=="") return -1;		//Mozy	2017-11-10	468611		增加明细来源为空判断
			//Mozy	2017-10-11 462084	修正对规格型号和生产厂商重新生成的操作
			var TModelDR=GetElementValue("TModelDRz"+i);
			var TManuFactoryDR=GetElementValue("TManuFactoryDRz"+i);
			/*var TModelDR=GetModelRowID(GetElementValue("GetModelOperMethod"),i)
			if ((TModelDR<=0)&&(GetElementValue("TModelz"+i)!=""))
		    {
			    alertShow("规格型号登记错误!")
			    return
		    }
			var TManuFactoryDR=GetManuFactoryRowID(GetElementValue("GetManuFactoryOperMethod"),i)
			if ((TManuFactoryDR<=0)&&(GetElementValue("TManuFactoryz"+i)!=""))
		    {
			    alertShow("生产厂家登记错误!")
			    return
		    }*/
			var TTotalFee=GetCElementValue("TTotalFeez"+i);
			var TRemark=GetElementValue("TRemarkz"+i);
			var TContractArriveDate=GetElementValue("TContractArriveDatez"+i);
			var TItemDR=GetElementValue("TItemDRz"+i);
			if (TSourceType!=2)//计划,设备项
			{
				var TQuantityNum=GetElementValue("TQuantityNumz"+i);
				var TPriceFee=GetElementValue("TPriceFeez"+i);
			}
			else //招标
			{
				var TQuantityNum=GetCElementValue("TQuantityNumz"+i);
				var TPriceFee=GetCElementValue("TPriceFeez"+i);				
			}
			var THold1=GetElementValue("THold1z"+i);
			var THold2=GetElementValue("THold2z"+i);
			var THold3=GetElementValue("THold3z"+i);
			var THold4=GetElementValue("THold4z"+i);
			var THold5=GetElementValue("THold5z"+i);
			var THold6=GetElementValue("THold6z"+i);
			var TCommonName=GetElementValue("TCommonNamez"+i);
			if (CheckInvalidData(TQuantityNum,TPriceFee,TRow)) return -1;
			if(valList!="") {valList=valList+"&";}			
			valList=valList+TRow+"^"+TRowID+"^"+TSourceType+"^"+TSourceID+"^"+TSourceIDDR+"^"+TModelDR+"^"+TManuFactoryDR+"^"+TPriceFee+"^"+TQuantityNum+"^"+TTotalFee+"^"+TRemark+"^"+TContractArriveDate+"^"+TItemDR+"^"+THold1+"^"+THold2+"^"+THold3+"^"+THold4+"^"+THold5+"^"+THold6+"^"+TCommonName; //2013-06-24 DJ0118
		}
	}
	return  valList
}
function SetDisplay()
{	
	ReadOnlyCustomItem(GetParentTable("ContractNo"),GetElementValue("Status"));
}

function BodyUnloadHandler()
{
	var Job=GetElementValue("Job")
  	var encmeth=GetElementValue("KillTEMPEQ")
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,Job);
}

function LookUpSourceID(vClickEventFlag)
{
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		if (CheckNull()) return;
		selectrow=GetTableCurRow();
		var ObjTSourceType=document.getElementById('TSourceTypez'+selectrow);
		if (ObjTSourceType)
		{
			var TSourceType=ObjTSourceType.value
			//alertShow(TSourceType)
			if (TSourceType==1)	//入库明细
			{
				//LookUp("","web.DHCEQBuyPlanNew:GetBuyPlanList","GetBuyPlanList","TSourceIDz"+selectrow+",'2',RowID");
				LookUp("","web.DHCEQStoreMoveNew:GetInStockList","GetInStockList","TRowIDz"+selectrow+",FromLocDR,EquipTypeDR,StatCatDR,StockStatus,ProvderDR,ListType,TEquipz"+selectrow+",'','',TFlagz"+selectrow);
			}
			else if (TSourceType==2)	//设备台帐
			{
				////Mozy	2017-10-11 462084	取消选择设备供应商的限制
				//LookUp("","web.DHCEQEquip:GetShortEquip","GetEquip","TSourceIDz"+selectrow+",'','','','','','','',ProviderDR");
				LookUp("","web.DHCEQEquip:GetShortEquip","GetEquip","TSourceIDz"+selectrow);
			}	
		}
	}
}
function GetInStockList(value)
{
	Clear();
	var list=value.split("^")
	var Length=ObjSources.length
	for (var i=1;i<Length;i++)
	{
		//alertShow(ObjSources[i].SourceType+"&"+ObjSources[i].SourceID+"&"+list[0]);
		if ((tableList[i]=="0")&&(ObjSources[i].SourceType=="1")&&(ObjSources[i].SourceID==list[0])&&(selectrow!=i))
		{
			alertShow("选择的入库明细与第"+GetCElementValue("TRowz"+i)+"行重复!")
			return;
		}
	}
	var Length=ObjSources.length
	SetElement('TSourceIDDRz'+selectrow,list[0]);
	SetElement('TSourceIDz'+selectrow,list[1]);
	SetElement('TModelDRz'+selectrow,list[4]);
	SetElement('TModelz'+selectrow,list[5]);
	SetElement('TManuFactoryDRz'+selectrow,list[6]);
	SetElement('TManuFactoryz'+selectrow,list[7]);
	SetElement('TPriceFeez'+selectrow,list[8]);
	SetElement('TQuantityNumz'+selectrow,list[9]);
	SetElement('TTotalFeez'+selectrow,list[10]);
	SetElement('TItemDRz'+selectrow,list[11]);
	SetElement('TUnitz'+selectrow,list[13]);
	SetElement('TCommonNamez'+selectrow,list[16]);
	SumList_Change();
	ObjSources[selectrow]=new SourceInfo("1",list[0]);
	var obj=document.getElementById("TSourceIDz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}

function GetEquip(value)
{
	Clear();
	var Length=ObjSources.length
	for (var i=1;i<Length;i++)
	{
		if ((tableList[i]=="0")&&(ObjSources[i].SourceType=="1")&&(ObjSources[i].SourceID==list[0])&&(selectrow!=i))
		{
			alertShow("选择的设备与第"+GetCElementValue("TRowz"+i)+"行重复!")
			return;
		}
	}
	var list=value.split("^");
	//Name,RowID,UseLoc,No,LeaveFactoryNo,UseLocDR,ModelDR,Model,EquipTypeDR,EquipType,ManuFactoryDR,ManuFactory,UnitDR,Unit,OriginalFee
	SetElement('TSourceIDz'+selectrow,list[3]);
	SetElement('TSourceIDDRz'+selectrow,list[1]);
	SetElement('TCommonNamez'+selectrow,list[0]);
	SetElement('TModelDRz'+selectrow,list[6]);
	SetElement('TModelz'+selectrow,list[7]);
	SetElement('TManuFactoryDRz'+selectrow,list[10]);
	SetElement('TManuFactoryz'+selectrow,list[11]);
	SetElement('TQuantityNumz'+selectrow,1);
	SetElement('TUnitDRz'+selectrow,list[12]);
	SetElement('TItemDRz'+selectrow,list[16]);//add by wy 2017-9-27
	SetElement('TUnitz'+selectrow,list[13]); 
	SetElement('TPriceFeez'+selectrow,list[14]);
	SetElement('TTotalFeez'+selectrow,list[14]);
	SumList_Change();
	ObjSources[selectrow]=new SourceInfo("2",list[1]);
	var obj=document.getElementById("TSourceIDz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}

function LookUpModelNew(vClickEventFlag)
{
	selectrow=GetTableCurRow();
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		LookUpModel("GetModel","TSourceIDDRz"+selectrow+",TModelz"+selectrow);
	}
}

function GetModel(value)
{
	var list=value.split("^")
	SetElement('TModelz'+selectrow,list[0]);
	SetElement('TModelDRz'+selectrow,list[1]);
	var obj=document.getElementById("TModelz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}

function LookUpManuFactoryNew(vClickEventFlag)
{
	selectrow=GetTableCurRow();
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		LookUpManuFactory("GetManuFactory","TManuFactoryz"+selectrow);
	}
}

function GetManuFactory(value)
{
	var list=value.split("^")
	SetElement('TManuFactoryz'+selectrow,list[0]);
	SetElement('TManuFactoryDRz'+selectrow,list[1]);
	var obj=document.getElementById("TManuFactoryz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}

function TotalFee_Change()
{
	selectrow=GetTableCurRow();
	var TPriceFee=+GetElementValue("TPriceFeez"+selectrow);
	var TQuantityNum=+GetElementValue("TQuantityNumz"+selectrow);
	if (IsValidateNumber(TQuantityNum,0,0,0,0)==0)
	{
		//alertShow("设备数量数据异常,请修正.");
		SetFocusColumn("TQuantityNum",selectrow);
		return -1;
	}
	if (IsValidateNumber(TPriceFee,0,1,0,1)==0)
	{
		//alertShow("设备原值数据异常,请修正.");
		SetFocusColumn("TPriceFee",selectrow);
		return -1;
	}
	var TotalFee=TPriceFee*TQuantityNum
	if (TotalFee<=0)
	{
		SetElement('TTotalFeez'+selectrow,'');
	}
	else
	{
		SetElement('TTotalFeez'+selectrow,TotalFee.toFixed(2));
	}
	
	SumList_Change();
}

function SumList_Change()
{	
	var length=tableList.length
	var Num=0
	var Fee=0
	for (var i=1;i<length;i++)
	{
		if (tableList[i]=="0")
		{
			var TPriceFee=+GetElementValue("TPriceFeez"+i);
			var TQuantityNum=+GetElementValue("TQuantityNumz"+i);
			if (IsValidateNumber(TQuantityNum,0,0,0,0)==0)
			{
				//alertShow("设备数量数据异常,请修正.");
				SetFocusColumn("TQuantityNum",i);
				return -1;
			}
			if (IsValidateNumber(TPriceFee,0,1,0,1)==0)
			{
				//alertShow("设备原值数据异常,请修正.");
				SetFocusColumn("TPriceFee",i);
				return -1;
			}
			var TotalFee=TPriceFee*TQuantityNum;
			Num=Num+TQuantityNum;
			Fee=Fee+TotalFee;
		}
		else if (tableList[i]==-1)
		{
			var index=i
		}
	}
	SetElement('TQuantityNumz'+index,Num);
	SetElement('TTotalFeez'+index,Fee.toFixed(2));
}

function Clear()
{
	SetElement("TSourceIDz"+selectrow,"");
	SetElement("TSourceIDDRz"+selectrow,"");
	SetElement("TModelz"+selectrow,"");
	SetElement("TModelDRz"+selectrow,"");
	SetElement("TManuFactoryz"+selectrow,"");
	SetElement("TManuFactoryDRz"+selectrow,"");
	SetElement("TQuantityNumz"+selectrow,"");
	SetElement("TTotalFeez"+selectrow,"");
	SetElement("TRemarkz"+selectrow,"");
	SetElement("TContractArriveDatez"+selectrow,"");
	SetElement("TItemDRz"+selectrow,"");
	SetElement("TQuantityNumz"+selectrow,"");
	SetElement("TPriceFeez"+selectrow,"");
	SetElement("THold1z"+selectrow,"");
	SetElement("THold2z"+selectrow,"");
	SetElement("THold3z"+selectrow,"");
	SetElement("THold4z"+selectrow,"");
	SetElement("THold5z"+selectrow,"");
	SetElement("THold6z"+selectrow,"");
	SetElement("TCommonNamez"+selectrow,"");
}
function CheckInvalidData(TQuantityNum,TPriceFee,TRow)  
{
	if (IsValidateNumber(TQuantityNum,0,0,0,0)==0)
	{
		alertShow("第"+TRow+"行设备数量数据异常,请修正.");
		//SetFocusColumn("TQuantityNum",i)
		return true;
	}
	if (IsValidateNumber(TPriceFee,0,1,0,1)==0)
	{
		alertShow("第"+TRow+"行设备单价数据异常,请修正.");
		//SetFocusColumn("TPriceFee",i)
		return true;
	}
	return false;
}

function TContractArriveDate_lookupSelect(dateval)
{
	var obj=document.getElementById('TContractArriveDatez'+selectRow);
	obj.value=dateval;
}
function BPicture_Click()
{
	var value=GetElementValue("ContractType");
	//需求序号:	413725		Mozy	20170728	增加ReadOnly参数设置上传操作禁用
	var Status=+GetElementValue("Status");
	var RowID=GetElementValue("RowID");      
	if (RowID=="")    ///add by mwz 20170508   需求号: 371767
	  {
		alertShow("请先更新数据");
		return
	  }
	var ReadOnly=0;
	if (Status>0)
	{
		ReadOnly=1;
	}
	if (value==0)
	{
		var str='dhceq.process.picturemenu.csp?&CurrentSourceType=5&CurrentSourceID='+GetElementValue("RowID")+'&Status='+status+'&ReadOnly='+ReadOnly;
	}
	else         //modified by czf 需求号：360948
	{
		var str='dhceq.process.picturemenu.csp?&CurrentSourceType=95&CurrentSourceID='+GetElementValue("RowID")+'&Status='+status+'&ReadOnly='+ReadOnly;
	}
	window.open(str,'_blank','left='+ (screen.availWidth - 1150)/2 +',top='+ ((screen.availHeight>750)?(screen.availHeight-750)/2:0) +',width=1150,height=750,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes');
}

function SetSourceType()
{
	var value=GetElementValue("ContractType");
	//alertShow(value)
	if (value=="0")
	{
		//采购
		//20150918  Mozy0166	合同设备选择方式 0:不用计划 1:必须计划 2:二者都可以
		if (GetElementValue("GetSourceType")==0)
		{
			CustomValue="2^招标&3^设备项";
		}
		else if (GetElementValue("GetSourceType")==1)
		{
			CustomValue="1^计划&2^招标";
		}
		else
		{
			CustomValue="1^计划&2^招标&3^设备项";
		}
	}else
	{
		//保修
		//CustomValue="1^入库明细&2^设备";
		CustomValue="2^设备";
	}
}
function ContractType()
{
	SetSourceType();
	SetTableItem('','','');
}
document.body.onload = BodyLoadHandler;