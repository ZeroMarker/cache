/// DHCEQBuyPlanNew.js
/// 设备新采购计划功能
var selectrow=0;
///记录 设备 RowID处理重复选择RowID的问题
var ObjSources=new Array();
//最后一行数据元素的名字的后缀序号
var LastNameIndex;
//新增一行数据元素的名字的后缀序号
var NewNameIndex;

function BodyLoadHandler()
{
	InitUserInfo();
	InitPage();
	FillData();
	SetEnabled();
	InitEditFields(GetElementValue("ApproveSetDR"),GetElementValue("CurRole"));
	InitApproveButton();
	SetTableItem();
	SetDisplay();	
	Muilt_LookUp("PurchaseType^PurposeType^Currency^EquipType");
	KeyUp("PurchaseType^PurposeType^Currency^EquipType","N");
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
function FillData()
{
	var RowID=GetElementValue("RowID");
	if (RowID=="") return;
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	//alertShow(ReturnList)
	var sort=46;
	SetElement("PlanName",list[1]);
	SetElement("QuantityNum",list[2]);
	SetElement("TotalFee",list[3]);
	SetElement("Remark",list[4]);
	SetElement("PlanDate",list[5]);
	SetElement("Status",list[6]);
	SetElement("Hold1",list[7]);
	SetElement("Hold2",list[8]);
	SetElement("Hold3",list[9]);
	SetElement("Hold4",list[10]);
	SetElement("Hold5",list[11]);
	SetElement("EquipTypeDR",list[12]);
	SetElement("EquipType",list[sort+1]);
	SetElement("PlanNo",list[25]);
	SetElement("PlanType",list[26]);
	SetElement("PlanYear",list[27]);
	SetElement("PurchaseTypeDR",list[28]);
	SetElement("PurchaseType",list[sort+6]);
	SetElement("RejectReason",list[29]);
	SetChkElement("UrgencyFlag",list[33]);
	SetElement("BuyRemark",list[37]);
	SetElement("BuyStatus",list[38]);
	SetElement("Hold6",list[39]);
	SetElement("Hold7",list[40]);
	SetElement("Hold8",list[41]);
	SetElement("PurposeTypeDR",list[42]);
	SetElement("PurposeType",list[sort+9]);
	
	SetElement("ApproveSetDR",list[sort+11]);
	SetElement("NextRoleDR",list[sort+12]);
	SetElement("NextFlowStep",list[sort+13]);
	SetElement("ApproveStatu",list[sort+14]);
	SetElement("ApproveRoleDR",list[sort+15]);
	SetElement("CancelFlag",list[sort+16]);
	SetElement("CancelToFlowDR",list[sort+17]);
	SetElement("AuditOpinion",list[sort+20]);
	encmeth=GetElementValue("GetApproveByRource");
	var ApproveListInfo=cspRunServerMethod(encmeth,"2",RowID);
	
	FillEditOpinion(ApproveListInfo,"EditOpinion")
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
function SetDisplay()
{
	ReadOnlyCustomItem(GetParentTable("PlanName"),GetElementValue("Status"));
	ReadOnlyElements("PlanNo^QuantityNum^TotalFee^AuditOpinion",true)
}

function BClear_Clicked()
{
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyPlanNew&QXType=&Type=0&PlanType=0&WaitAD=off';
}

function BUpdate_Clicked()
{
	if (CheckNull()) return;
	var combindata=GetValueList(); 	//总单信息
  	var valList=GetTableInfo(); 	//明细信息
  	if (valList=="-1")  return; 	//明细信息有误
  	var DelRowid=tableList.toString();
  	var encmeth=GetElementValue("UpdateData");
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,combindata,valList,DelRowid);
	//alertShow(rtn)
	var list=rtn.split("^");
	if (list[1]!="0")
	{
		alertShow(EQMsg("操作异常!",list[1]));
	}
	else
	{
		if (list[0]>0)
		{
			//add by HHM 20150910 HHM0013
	    	//添加操作成功是否提示
	    	ShowMessage();
	    	//*************************
			///ZY0099
			window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyPlanNew&WaitAD=off&RowID='+list[0]+"&Type="+GetElementValue("Type")+"&PlanType="+GetElementValue("PlanType")+"&SaveFlag=Y";
		}
		else
		{
			alertShow(t["01"])
		}
	}
}

function BDelete_Clicked()
{
  	var encmeth=GetElementValue("DeleteData");
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,GetElementValue("RowID"));
	//alertShow(rtn)
	if (rtn<0)
	{
	    alertShow(rtn+"   "+t["01"]);
    }
    else
    {
		window.location.href= "websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyPlanNew&WaitAD=off&Type="+GetElementValue("Type")+"&PlanType="+GetElementValue("PlanType");
	}
}

function BSubmit_Clicked()
{
	///ZY0099
	if (GetElementValue("SaveFlag")=="N")
	{
		alertShow("编辑设备项后请先保存信息再提交!");
		return;
	}
	var combindata=GetAuditData();
  	var valList=GetTableInfo();
  	if (valList=="-1") return;
  	if (valList=="")
  	{
	  	alertShow("无明细记录不可提交!");
	  	return;
  	}
  	var encmeth=GetElementValue("SubmitData");
  	if (encmeth=="") return;
  	//alertShow(combindata)
	var rtn=cspRunServerMethod(encmeth,combindata);
	if (rtn>0)
    {
	    window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyPlanNew&RowID='+rtn+"&WaitAD="+GetElementValue("WaitAD")+"&Type="+GetElementValue("Type")+"&PlanType="+GetElementValue("PlanType");
	}
    else
    {
	    alertShow(t[rtn]+"   "+t["01"]);
    }
}

function BCancelSubmit_Clicked() 
{
	if (CheckItemNull(2,"RejectReason")) return;
	var combindata=GetAuditData();
	var CurRole=GetElementValue("CurRole");
  	if (CurRole=="") return;
  	var encmeth=GetElementValue("CancelSubmitData");
  	if (encmeth=="") return;
  	//alertShow(combindata)
	var rtn=cspRunServerMethod(encmeth,combindata, CurRole);
    if (rtn>0)
    {
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyPlanNew&RowID='+rtn+"&WaitAD="+GetElementValue("WaitAD")+"&Type="+GetElementValue("Type")+"&PlanType="+GetElementValue("PlanType");
	}
    else
    {
	    alertShow(rtn+"   "+t["01"]);
    }
}

function BApprove_Clicked()
{
	if (CheckItemNull(2,"EditOpinion")) return;
	var combindata=GetAuditData();
	var CurRole=GetElementValue("CurRole");
  	if (CurRole=="") return;
	var RoleStep=GetElementValue("RoleStep");
  	if (RoleStep=="") return;
  	var objtbl=document.getElementById('tDHCEQBuyPlanNew');
	var EditFieldsInfo=ApproveEditFieldsInfo(objtbl);
	if (EditFieldsInfo=="-1") return;
  	var encmeth=GetElementValue("AuditData");
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,combindata,CurRole,RoleStep,EditFieldsInfo);
	//alertShow(rtn)
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
	combindata=combindata+"^"+GetElementValue("PlanName");
	combindata=combindata+"^"+GetElementValue("QuantityNum");
	combindata=combindata+"^"+GetElementValue("TotalFee");
	combindata=combindata+"^"+GetElementValue("Remark");
	combindata=combindata+"^"+GetElementValue("PlanDate");
	combindata=combindata+"^"+GetElementValue("Hold1");
	combindata=combindata+"^"+GetElementValue("Hold2");
	combindata=combindata+"^"+GetElementValue("Hold3");
	combindata=combindata+"^"+GetElementValue("Hold4");
	combindata=combindata+"^"+GetElementValue("Hold5");
	combindata=combindata+"^"+GetElementValue("EquipTypeDR");
	combindata=combindata+"^"+GetElementValue("PlanType");
	combindata=combindata+"^"+GetElementValue("PlanYear");
	combindata=combindata+"^"+GetElementValue("PurchaseTypeDR");
	combindata=combindata+"^"+GetChkElementValue("UrgencyFlag");
	combindata=combindata+"^"+GetElementValue("BuyRemark");
	combindata=combindata+"^"+GetElementValue("BuyStatus");
	combindata=combindata+"^"+GetElementValue("Hold6");
	combindata=combindata+"^"+GetElementValue("Hold7");
	combindata=combindata+"^"+GetElementValue("Hold8");
	combindata=combindata+"^"+GetElementValue("PurposeTypeDR");
	
	return combindata;
}
function GetTableInfo()
{
	//alertShow(tableList.toString())
	var rows=tableList.length;
	var valList="";
	for(var i=1;i<rows;i++)
	{
		//alertShow(rows+"   第"+i+"行  "+tableList[i])
		if (tableList[i]=="0") //等于0表示页面显示记录
		{
			var TRow=GetElementValue("TRowz"+i);
			var TRowID=GetElementValue("TRowIDz"+i);
			var TItem=GetElementValue("TItemz"+i);
			//start by csj 20181203
			var TItemDR=GetElementValue("TItemDRz"+i);
			if (TItemDR=="")
			{
				alertShow("第"+TRow+"行未选择设备!!!")
				return -1
			}			
			var TModel=GetElementValue("TModelz"+i);
			if (TModel!="")
			{
				var ItemDR=TItemDR;
				var encmeth=GetElementValue("UpdModel");
				var RModelDR=cspRunServerMethod(encmeth,TModel,ItemDR);
			    if (RModelDR<=0)
			    {
				    alertShow("规格型号登记错误!")
				    return
			    }
			    else
			    {
				    SetElement("TModelDRz"+i,RModelDR)
			    }
			}
			//end by csj 20181204
			var TModelDR=GetElementValue("TModelDRz"+i);
			var TManuFactoryDR=GetElementValue("TManuFactoryDRz"+i);
			var	TPriceFee=GetElementValue("TPriceFeez"+i);
			var TQuantityNum=GetElementValue("TQuantityNumz"+i);
			var TTotalFee=GetElementValue("TTotalFeez"+i);
			var	TRemark=GetElementValue("TRemarkz"+i);
			var	TBuyRequestListDR=GetElementValue("TBuyRequestListDRz"+i);
			var	TExecNum=GetElementValue("TExecNumz"+i);
			var	CurrencyDR=GetElementValue("CurrencyDR");
			var TEquipCatDR=GetElementValue("TEquipCatDRz"+i);
			var TArriveNum=GetElementValue("TArriveNumz"+i);
			var TArriveDate=GetElementValue("TArriveDatez"+i);
			var THold3=GetElementValue("THold3z"+i);
			var THold1=GetElementValue("THold1z"+i)
			var THold2=GetElementValue("THold2z"+i)
			var THold4=GetElementValue("THold4z"+i)
			var THold5=GetElementValue("THold5z"+i)
			var TCommonName=GetElementValue("TCommonNamez"+i) //2013-06-24 DJ0118
			if (CheckInvalidData(i)) return -1;
			if(valList!="") {valList=valList+"&";}
			valList=valList+TRowID+"^"+TItem+"^"+TModelDR+"^"+TManuFactoryDR+"^^"+TPriceFee+"^"+TQuantityNum+"^"+TTotalFee+"^"+TRemark+"^"+TBuyRequestListDR+"^"+TExecNum+"^"+CurrencyDR+"^"+TEquipCatDR+"^"+TArriveNum+"^"+TItemDR+"^"+TArriveDate+"^"+THold3+"^"+THold1+"^"+THold2+"^"+THold4+"^"+THold5+"^"+TCommonName;  //2013-06-24 DJ0118
		}
	}
	return valList;
}
function GetAuditData()
{
	var ValueList="";
	ValueList=GetElementValue("RowID");
	ValueList=ValueList+"^"+curUserID;
	ValueList=ValueList+"^"+GetElementValue("CancelToFlowDR");
	ValueList=ValueList+"^"+GetElementValue("EditOpinion");
	ValueList=ValueList+"^"+GetElementValue("RejectReason");
	
	return ValueList;
}

function SetTableItem()
{
	var objtbl=document.getElementById('tDHCEQBuyPlanNew');
	var rows=objtbl.rows.length-1;
	for (var i=1;i<=rows;i++)
	{
		var TSourceType=GetElementValue("TSourceTypeDRz"+i);
		var TSourceID="";
		if (TSourceType=="1")
		{
			TSourceID=GetElementValue("TBuyRequestListDRz"+i);
		}
		else
		{
			TSourceID=GetElementValue("TItemDRz"+i);
		}
		ObjSources[i]=new SourceInfo(TSourceType,TSourceID);
		var TRowID=GetElementValue("TRowIDz"+i);
		if (TRowID==-1)
		{
			obj=document.getElementById("BDeleteListz"+i);
			if (obj) obj.innerText="";
			
			///ZY0099
			obj=document.getElementById("BItemEditz"+i);
			if (obj) obj.innerText="";
			
			obj=document.getElementById("TBListz"+i);
			if (obj)
			{
				obj.innerText="";
				DisableBElement("TBListz"+i,true);
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
		var ReadOnly=GetElementValue("ReadOnly");   //add by mwz 需求号：467314
		//var objwidth="60px";
		//var objheight="22px";
		
		if (colName=="TSourceType")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetElementValue("TSourceTypeDRz"+objindex);
			html=CreatElementHtml(4,Id,objwidth,objheight,"","TSourceType_Change","0^设备项&1^采购申请","","");
		}
		else if (colName=="TItem")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpTItem","","","Standard_TableKeyUp")	//2013-11-11 Mozy0112 值重置
		} 
		else if (colName=="TModel")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpTModel","","","Standard_TableKeyUp")	//2013-11-11 Mozy0112 值重置
		}
		else if (colName=="TManuFactory")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpTManuFactory","","","Standard_TableKeyUp")	//2013-11-11 Mozy0112 值重置
		}
		else if (colName=="TPriceFee")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","SumList_Change","NumberPressHandler")
		}
		else if (colName=="TQuantityNum")
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
		else if (colName=="TExecNum")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","","NumberPressHandler")
		}
		else if (colName=="TArriveNum")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","","NumberPressHandler")
		}
		else if (colName=="TArriveDate")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(3,Id,objwidth,objheight,"LookUpTableDate","TDate_changehandler","","","")
		}
		else if (colName=="THold1")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="THold2")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="THold3")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="THold4")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="THold5")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="BDeleteList")  		 //add by mwz 需求号：467314
		{
			if ((Status>0)||(ReadOnly==1))
			{
				HiddenObj(colName+"z"+objindex,1)
				continue;
			}
			RowObj.cells[j].onclick=DeleteClickHandler;
		}
		else if (colName=="BItemEdit")		///ZY0099
		{
			if (Status>0)
			{
				HiddenObj(colName+"z"+objindex,1)
				continue;
			}
			RowObj.cells[j].onclick=ItemClickHandler;
		}
		else if (colName=="TCommonName")	//2013-06-24 DJ0118
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
         	html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		if (html!="") RowObj.cells[j].innerHTML=html;
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
		var TSourceType=GetElementValue("TSourceTypez"+selectrow);
		if (TSourceType==0)  		//设备项
		{
			LookUp("","web.DHCEQCMasterItem:GetMasterItem","GetTItemID","EquipTypeDR,,TItemz"+selectrow);
		}
		else if (TSourceType==1)  	//采购申请
		{
			LookUp("","web.DHCEQBuyPlanNew:GetBuyRequestListByItem","GetTBuyRequestDR","RowID,TItemz"+selectrow);
		}
	}
}
function GetTItemID(value)
{
	var list=value.split("^");
	SetElement('TItemz'+selectrow,list[0]);
	SetElement('TItemDRz'+selectrow,list[1]);
	SetElement('TEquipCatDRz'+selectrow,list[3]);
	SetElement('TEquipCatz'+selectrow,list[4]);
	SetElement('TCommonNamez'+selectrow,list[0]);	//2013-06-24 DJ0118
	ObjSources[selectrow]=new SourceInfo(GetElementValue("TSourceTypeDRz"+selectrow),list[0]);
	SumList_Change();
	var obj=document.getElementById("TItemz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}
function GetTBuyRequestDR(value)
{
	ClearValue();
	var TotalFlag=GetElementValue("TotalFlag")
	var list=value.split("^")
	var Length=ObjSources.length
	for (var i=1;i<Length;i++)
	{
		//alertShow(ObjSources[i].SourceType+"&"+ObjSources[i].SourceID+"&"+list[1]);
		if ((tableList[i]=="0")&&(ObjSources[i].SourceType=="1")&&(ObjSources[i].SourceID==list[1])&&(selectrow!=i))
		{
			alertShow("选择的采购申请明细与第"+GetCElementValue("TRowz"+i)+"行重复!")
			return;
		}
	}
	// 0		1		2			3		4		5		6			7		8			9			10		11		12		13		14
	// TName,TRowID,TBuyRequestDR,TPrjName,TModelDR,TModel,TManuFacDR,TManuFac,TPriceFee,TQuantityNum,TItemDR,TUnitDR,TUnit,TEquipCatDR,TEquipCat
	SetElement('TItemz'+selectrow,list[0]);
	SetElement('TBuyRequestListDRz'+selectrow,list[1]);
	SetElement('TBuyRequestDRz'+selectrow,list[2]);
	SetElement('TSourceIDz'+selectrow,list[3]);
	SetElement('TModelDRz'+selectrow,list[4]);
	SetElement('TModelz'+selectrow,list[5]);
	SetElement('TManuFactoryDRz'+selectrow,list[6]);
	SetElement('TManuFactoryz'+selectrow,list[7]);
	SetElement('TPriceFeez'+selectrow,list[8]);
	SetElement('TQuantityNumz'+selectrow,list[9]);
	SetElement('TItemDRz'+selectrow,list[10]);
	SetElement('TTotalFeez'+selectrow,list[8]*list[9]);
	SetElement('TEquipCatDRz'+selectrow,list[13]);
	SetElement('TEquipCatz'+selectrow,list[14]);
	SetElement('TCommonNamez'+selectrow,list[17]); //2013-06-24 DJ0118
	SumList_Change();
	ObjSources[selectrow]=new SourceInfo(GetElementValue("TSourceTypeDRz"+selectrow),list[10]);
	var obj=document.getElementById("TBuyRequestz"+selectrow);
	if (obj) websys_nextfocusElement(obj); 
}
function TSourceType_Change()
{
	selectrow=GetTableCurRow();
	//alertShow(selectrow+"---"+GetElementValue("TBuyRequestz"+selectrow))
	SetElement("TBuyRequestListDRz"+selectrow,"");
	SetElement("TBuyRequestDRz"+selectrow,"");
	SetElement("TSourceIDz"+selectrow,"");
	SetElement("TItemz"+selectrow,"");
	SetElement("TItemDRz"+selectrow,"");
	SetElement("TModelz"+selectrow,"");
	SetElement("TModelDRz"+selectrow,"");
	SetElement("TQuantityNumz"+selectrow,"");
	SetElement("TPriceFeez"+selectrow,"");
	SetElement("TTotalFeez"+selectrow,"");
	SetElement("TManuFactoryz"+selectrow,"");
	SetElement("TManuFactoryDRz"+selectrow,"");
	SetElement("TExecNumz"+selectrow,"");
	SetElement("TArriveNumz"+selectrow,"");
	SetElement("TArriveDatez"+selectrow,"");
	SetElement("TRemarkz"+selectrow,"");
	var TSourceType=GetElementValue("TSourceTypez"+selectrow)
	SetElement("TSourceTypeDRz"+selectrow,TSourceType);
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
			//Mozy0049	2011-3-30
			SetElement("TTotalFeez"+i,"");
			var TQuantityNum=+GetElementValue("TQuantityNumz"+i);
			var TPriceFee=+GetElementValue("TPriceFeez"+i);
			if (IsValidateNumber(TQuantityNum,0,0,0,0)==0) continue;
			if (IsValidateNumber(TPriceFee,0,1,0,1)==0) continue;
			var TotalFee=TQuantityNum*TPriceFee;
			SetElement("TTotalFeez"+i,TotalFee.toFixed(2));
			Num=Num+TQuantityNum;
			Fee=Fee+TotalFee;
		}
		if (tableList[i]==-1)
		{
			index=i;
		}
	}
	SetElement("TQuantityNumz"+index,Num);
	SetElement("TTotalFeez"+index,Fee.toFixed(2));
	SetElement("QuantityNum",Num);
	SetElement("TotalFee",Fee.toFixed(2));
}
function DeleteClickHandler()
{
	var truthBeTold = window.confirm(t["-4003"]);
	if (!truthBeTold) return;
	try
	{
		var objtbl=document.getElementById('tDHCEQBuyPlanNew');
		var rows=objtbl.rows.length;
		selectrow=GetTableCurRow();
		var TotalFlag=GetElementValue("TotalFlag");
		var TRowID=GetElementValue('TRowIDz'+selectrow);
		tableList[selectrow]=TRowID;
		//判断是否删除仅剩的1行记录
		if (((TotalFlag==0)&&(rows<=2))||((rows<=3)&&((TotalFlag==1)||(TotalFlag==2))))
		{
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
///ZY0099
function ItemClickHandler()
{
	var objtbl=document.getElementById('tDHCEQBuyPlanNew');
	selectrow=GetTableCurRow();
	var ItemMode=GetElementValue('ItemMode');
	ItemMode=1
	var TItem=GetElementValue('TItemz'+selectrow);
	var Code=GetPYCode(TItem)
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCMasterItem&Desc='+TItem+'&Code='+Code+'&ItemMode='+ItemMode+'&Index='+selectrow;
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');	//
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
function AddClickHandler()
{
	try
	{
		var objtbl=document.getElementById('tDHCEQBuyPlanNew');
		var ret=CanAddRow(objtbl);
		if (ret)
		{
			NewNameIndex=tableList.length;
	    	AddRowToList(objtbl,LastNameIndex,NewNameIndex);
			ObjSources[NewNameIndex]=new SourceInfo("","");
			//设置默认的来源类型与上一行一致
			var PreSourceType=GetElementValue("TSourceTypez"+LastNameIndex);
			SetElement("TSourceTypez"+NewNameIndex,PreSourceType);
	    }
	} catch(e) {};
}
//检测是否可以增加新记录
function CanAddRow(objtbl)
{
	var rows=objtbl.rows.length;
	if (rows==1) return false;
	var TotalFlag=GetElementValue("TotalFlag") 		//合计行设置参数值
	if (TotalFlag==2) rows=rows-1
	LastNameIndex=GetRowIndex(objtbl.rows[rows-1]);
	var TRow=GetElementValue("TRowz"+LastNameIndex)
	var TItemDR=GetElementValue("TItemDRz"+LastNameIndex)
	var TQuantityNum=GetElementValue("TQuantityNumz"+LastNameIndex)
	if  (TRow=="")
	{
		SetFocusColumn("TRow",LastNameIndex);
		return false;
	}
	return true;
}
function ClearValue()
{
	SetElement("TBuyRequestListDRz"+selectrow,"");
	SetElement("TBuyRequestDRz"+selectrow,"");
	SetElement("TBuyRequestz"+selectrow,"");
	SetElement("TSourceIDz"+selectrow,"");
	SetElement("TItemz"+selectrow,"");
	SetElement("TItemDRz"+selectrow,"");
	SetElement("TModelz"+selectrow,"");
	SetElement("TModelDRz"+selectrow,"");
	SetElement("TQuantityNumz"+selectrow,"");
	SetElement("TPriceFeez"+selectrow,"");
	SetElement("TTotalFeez"+selectrow,"");
	SetElement("TManuFactoryz"+selectrow,"");
	SetElement("TManuFactoryDRz"+selectrow,"");
	SetElement("TExecNumz"+selectrow,"");
	SetElement("TArriveNumz"+selectrow,"");
	SetElement("TArriveDatez"+selectrow,"");
	SetElement("TRemarkz"+selectrow,"");
	SetElement("TCommonNamez"+selectrow,"");	//2013-06-24 DJ0118
	SumList_Change();
}

function CheckNull()
{
	if (CheckMustItemNull()) return true;
	return false;
}
function CheckInvalidData(i)
{
	if (IsValidateNumber(GetElementValue("TPriceFeez"+i),0,1,0,1)==0)
	{
		alertShow("设备单价数据异常,请修正.");
		//SetElement("TPriceFeez"+i,"");
		return true;
	}
	if (IsValidateNumber(GetElementValue("TQuantityNumz"+i),0,0,0,0)==0)
	{
		alertShow("设备数量数据异常,请修正.");
		//SetElement("TQuantityNumz"+i,"");
		return true;
	}
	/*if (IsValidateNumber(GetElementValue("TExecNumz"+i),0,0,0,0)==0)
	{
		alertShow("设备执行数量数据异常,请修正.");
		//SetElement("TExecNumz"+i,"");
		return true;
	}*/
	/*if (IsValidateNumber(GetElementValue("TArriveNumz"+i),0,0,0,0)==0)
	{
		alertShow("设备到货数量数据异常,请修正.");
		//SetElement("TArriveNumz"+i,"");
		return true;
	}*/
	return false;
}
function GetPurchaseType(value)
{
	var list=value.split("^");
	//alertShow(value)
	SetElement("PurchaseType",list[0]);
	SetElement("PurchaseTypeDR",list[1]);
}
function GetPurposeType(value)
{
	var list=value.split("^");
	//alertShow(value)
	SetElement("PurposeType",list[0]);
	SetElement("PurposeTypeDR",list[1]);
}
function GetEquipType(value)
{	
	GetLookUpID("EquipTypeDR",value);
}
function GetCurrencyDR(value)
{
	GetLookUpID("CurrencyDR",value);
}
function TArriveDate_lookupSelect(dateval)
{
	var obj=document.getElementById('TArriveDatez'+selectRow);
	obj.value=dateval;
}

document.body.onload = BodyLoadHandler;