var selectrow=0;
//最后一行数据元素的名字的后缀序号
var LastNameIndex;
//新增一行数据元素的名字的后缀序号
var NewNameIndex;

function BodyLoadHandler()
{
	InitUserInfo(); //系统参数
	FillData();
	InitEditFields(GetElementValue("ApproveSetDR"),GetElementValue("CurRole"));
	InitApproveButton();
	SetTableItem();
	SetEnabled();
	SetElement("Job",GetElementValue("TJobz1"));
	InitEvent();	
}

function SetEnabled()
{
	var Status=GetElementValue("Status");
	if (Status!="0")
	{
		DisableBElement("BSubmit",true);
		DisableBElement("BDelete",true);
		if(Status!="")
		{
			DisableBElement("BUpdate",true);
			DisableBElement("BAdd",true);
		}
	}
	if ((Status=="0")||(Status==""))
	{
		DisableBElement("BGetCostAllot",true);
		DisableBElement("BPrint",true);
	}
	if (Status>0)
	{ 
		SetElementsReadOnly("Type^RequestLoc^RequestUser^RequestDate^EquipType^Loc",true)
	}
}

function SetElementsReadOnly(val,flag)
{
	var List=val.split("^")
	for(var i = 0; i < List.length; i++)
	{
		DisableElement(List[i],flag);
		ReadOnlyElement(List[i],flag);
		if (document.getElementById(GetLookupName(List[i])))
		{
			DisableElement(GetLookupName(List[i]),flag);
		}
	}
}

function InitEvent()
{
	var obj=document.getElementById("Type");
	if (obj) obj.onchange=TypeToLoc;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Clicked;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Clicked;
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Clicked;
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=AddClickHandler;
	var obj=document.getElementById("BGetCostAllot");
	if (obj) obj.onclick=BGetCostAllot_Clicked;
	
}

function TypeToLoc()
{
	var value=GetElementValue("Type")
	if (value=="2") //更换
	{
		SetElement("LocType","0101");
		SetElement("RequestLocType","0102");
	}else if (value=="1") //销毁
	{
		SetElement("LocType","0101");
		SetElement("RequestLocType","0101");
	}
}

function FillData()
{
	var SwapDR=GetElementValue("RowID");
	if (SwapDR=="") return
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,SwapDR);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	var sort=25;
	SetElement("SwapNo",list[0]);
	SetElement("Type",list[1]);
	SetElement("LocDR",list[2]);
	SetElement("Loc",list[sort]);
	SetElement("RequestLocDR",list[3]);
	SetElement("RequestLoc",list[sort+1]);
	SetElement("RequestDate",list[4]);
	SetElement("RequestUserDR",list[5]);
	SetElement("RequestUser",list[sort+2]);
	SetElement("Status",list[9]);
	SetElement("EquipTypeDR",list[19]);
	SetElement("EquipType",list[sort+3]);
	//AIRowID_"^"_ApproveSetDR_"^"_NextRoleDR_"^"_NextFlowStep_"^"_ApproveStatu_"^"_ApproveRoleDR_"^"_CancelFlag_"^"_CancelToFlowDR_"^"_ApproveRole_"^"_NextRole
	SetElement("ApproveSetDR",list[sort+5]);
	SetElement("NextRoleDR",list[sort+6]);
	SetElement("NextFlowStep",list[sort+7]);
	SetElement("ApproveStatu",list[sort+8]);
	SetElement("ApproveRoleDR",list[sort+9]);
	SetElement("CancelFlag",list[sort+10]);
	SetElement("CancelToFlowDR",list[sort+11]);
}

function GetValueList()
{
	var combindata="";
  	combindata=GetElementValue("RowID");
  	combindata=combindata+"^"+GetElementValue("Type") ;
  	combindata=combindata+"^"+GetElementValue("LocDR") ;
  	combindata=combindata+"^"+GetElementValue("RequestLocDR") ;
	combindata=combindata+"^"+GetElementValue("RequestDate") ;
	combindata=combindata+"^"+GetElementValue("RequestUserDR") ;
	combindata=combindata+"^"+curUserID;
	combindata=combindata+"^"+GetElementValue("Job");
	combindata=combindata+"^"+GetElementValue("CancelToFlowDR");
	combindata=combindata+"^"+GetElementValue("ApproveSetDR");
	combindata=combindata+"^"+GetElementValue("EquipTypeDR");
	return combindata
}

function GetTableInfo()
{
	var rows=tableList.length
	var valList="";
	for(var i=1;i<rows;i++)
	{
		if (tableList[i]=="0") //等于0表示页面显示记录
		{
			var TRow=GetCElementValue("TRowz"+i);
			var TRowID=GetElementValue('TRowIDz'+i);
			var TMasterItem=GetElementValue('TMasterItemz'+i);
			if (TMasterItem=="")
			{
				alertShow("第"+TRow+"行未选择被服!")
				return "-1"			
			}
			var TMasterItemDR=GetElementValue('TMasterItemDRz'+i);
			var TInStockListDR=GetElementValue('TInStockListDRz'+i);
			var TModelDR=GetElementValue('TModelDRz'+i);
			if ((TMasterItemDR=="")&&(TModelDR==""))
			{
				alertShow("第"+TRow+"行明细为空,请检查!")
				return "-1"
			}
			var TQuantityNum=parseInt(GetElementValue('TQuantityNumz'+i));
			if ((TQuantityNum=="")||(TQuantityNum<=0))
			{
				alertShow("第"+TRow+"行数量输入有误,请检查!")
				return "-1"
			}
			if (GetElementValue('TQuantityNumz'+i)!=TQuantityNum)
			{
				alertShow("第"+TRow+"行数量不正确,不能为小数!");
				SetFocusColumn("TQuantityNum",i)
				return "-1";
			}
			var TSupplementNum=parseInt(GetElementValue('TSupplementNumz'+i));
			if ((TSupplementNum=="")||(TSupplementNum<=0))
			{
				alertShow("第"+TRow+"行数量输入有误,请检查!")
				return "-1"
			}
			if (GetElementValue('TSupplementNumz'+i)!=TSupplementNum)
			{
				alertShow("第"+TRow+"行数量不正确,不能为小数!");
				SetFocusColumn("TSupplementNum",i)
				return "-1";
			}
			var THold2=GetElementValue("THold2z"+i);
			var THold3=GetElementValue("THold3z"+i);
			var THold4=GetElementValue("THold4z"+i);
			var THold5=GetElementValue("THold5z"+i);
			var TManuFactoryDR=GetElementValue('TManuFactoryDRz'+i);
			var TOriginalFee=GetElementValue('TOriginalFeez'+i);
			var TUnitDR=GetElementValue('TUnitDRz'+i);
			var TLocationDR=GetElementValue('TLocationDRz'+i);
			var TRowIDS=GetElementValue('TRowIDSz'+i);
			if(valList!="") {valList=valList+"&";}
			valList=valList+TRow+"^"+TRowID+"^"+TMasterItemDR+"^"+TModelDR+"^"+TQuantityNum+"^"+TSupplementNum+"^"+THold2+"^"+THold3+"^"+THold4+"^"+THold5;		
			valList=valList+"^"+TInStockListDR+"^"+TManuFactoryDR+"^"+TOriginalFee+"^"+TUnitDR+"^"+TLocationDR+"^"+TMasterItem+"^"+TRowIDS
		}
	}
	return  valList
}

function BGetCostAllot_Clicked() 
{
	var SwapDR=GetElementValue("RowID");
	if (SwapDR=="") return
	var lnk= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQSwapListDetail&SwapDR='+SwapDR;
   	window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}

function BUpdate_Clicked()
{
	if (CheckNull()) return;
	var combindata=GetValueList(); //总单信息
  	var valList=GetTableInfo(); //明细信息
  	if (valList=="-1")  return; //明细信息有误
  	var DelRowid=tableList.toString()
  	var encmeth=GetElementValue("UpdateData")
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,combindata,valList,DelRowid);
	var list=rtn.split("^");
	if ((list[1]!="")&&(list.length>1))
	{
		alertShow("第"+list[0]+"行"+list[1])
	}
	else
	{
		if (list[0]>0)
		{
			window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQSwapNew&RowID='+rtn;
		}
		else
		{
			if (list[0]=="-1015")
			{
				alertShow(t[list[0]])
			}
			else
			{
				alertShow(t["01"])
			}
		}
	}
}

function BDelete_Clicked()
{
	var truthBeTold = window.confirm(t["-4003"]);
	if (!truthBeTold) return;
	var combindata=GetValueList();
  	var encmeth=GetElementValue("DeleteData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata);
	if (Rtn==0)
    {
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQSwapNew&RowID=';
	}
    else
    {
	    alertShow(Rtn+"   "+t["01"]);
    }
}

function BCancelSubmit_Clicked() 
{
	var combindata=GetValueList();
  	var encmeth=GetElementValue("CancelSubmitData")
  	if (encmeth=="") return;
  	//Modified by jdl 2011-3-9  jdl0073
	var rtn=cspRunServerMethod(encmeth,combindata,GetElementValue("CurRole"));
    if (rtn>0)
    {
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQSwapFind';
	}
    else
    {
	    alertShow(rtn+"   "+t["01"]);
    }
}

function BSubmit_Clicked()
{
	var SwapDR=GetElementValue("RowID");
	if (SwapDR=="") return
	if (CheckNull()) return;
	var combindata=GetValueList();
  	var valList=GetTableInfo();
  	if (valList=="-1") return
  	if (valList=="")
  	{
	  	alertShow("无明细记录不可保存!")
	  	return
  	}
  	var encmeth=GetElementValue("SubmitData")
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,combindata,valList);
	if (rtn>0)
    {
	    window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQSwapNew&RowID='+rtn;
	}
    else
    {
	    if (isNaN(rtn))
	    {
		    alertShow(rtn+"   "+t["01"]);
	    }
	    else
	    {
		    alertShow(t[rtn]+"   "+t["01"]);
	    }
    }
}

function BApprove_Clicked()
{
	var combindata=GetValueList();
	var valList=GetTableInfo();
	var CurRole=GetElementValue("CurRole")
  	if (CurRole=="") return;
	var RoleStep=GetElementValue("RoleStep")
  	if (RoleStep=="") return;
  	var objtbl=document.getElementById('tDHCEQSwapNew');
	var EditFieldsInfo=ApproveEditFieldsInfo(objtbl);
	if (EditFieldsInfo=="-1") return;
	
	//alertShow(EditFieldsInfo);
	//return;
	
  	var encmeth=GetElementValue("AuditData")
  	if (encmeth=="") return;
  	
	var Rtn=cspRunServerMethod(encmeth,combindata,valList,CurRole,RoleStep,EditFieldsInfo);
    if (Rtn>0)
    {
	    window.location.reload();
	}
    else
    {
	    alertShow(Rtn);
    }
}

function AddClickHandler()
{
	try 
	{
		var objtbl=document.getElementById('tDHCEQSwapNew');
		var ret=CanAddRow(objtbl);
		if (ret)
		{
			NewNameIndex=tableList.length;
	    	AddRowToList(objtbl,LastNameIndex,NewNameIndex);
	    	var TEquipList=document.getElementById("TEquipListz"+NewNameIndex); //出厂编号
			if (TEquipList)	TEquipList.onclick=EquipListClick;
	    }
	} catch(e) {};
}

//检测是否可以增加新记录
function CanAddRow(objtbl)
{
	var rows=objtbl.rows.length;
    if (rows==1) return false;
	LastNameIndex=GetRowIndex(objtbl.rows[rows-1]);
	var TMasterItem=GetElementValue("TMasterItemz"+LastNameIndex)
	if  (TMasterItem=="")
	{
		SetFocusColumn("TMasterItem",LastNameIndex);
		return false;
	}
	return true;
}

function SetTableItem()
{
	var objtbl=document.getElementById('tDHCEQSwapNew');
	var rows=objtbl.rows.length-1;
	for (var i=1;i<=rows;i++)
	{
		var TRow=document.getElementById("TRowz"+i).innerHTML;  //列表数组初始化			
		var TRowID=GetElementValue("TRowIDz"+i);
		//var TotalFlag=GetElementValue("TotalFlag")
		if (TRowID==-1)
		{
			obj=document.getElementById("BDeleteListz"+i);
			if (obj) obj.innerText=""
			obj=document.getElementById("TEquipListz"+i);
			if (obj)
			{
				obj.innerText=""
				DisableBElement("TEquipListz"+i,true);
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
		var html="";
		var value="";

    	if (!RowObj.cells[j].firstChild) {continue}
    	
		var Id=RowObj.cells[j].firstChild.id;
		
		var offset=Id.lastIndexOf("z");
		var objindex=Id.substring(offset+1);
		var colName=Id.substring(0,offset);
		
		var objwidth=RowObj.cells[j].style.width;
		var objheight=RowObj.cells[j].style.height;
		if (colName=="TMasterItem")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpInStockList","","","KeyupEquip")
		}
		else if (colName=="TModel")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpModelNew","","","Standard_TableKeyUp")	
		}
		else if (colName=="TQuantityNum")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
         	html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","TotalFee_Change")	
						
			//数量
			var objTQuantityNum=document.getElementById(Id);
			if(objTQuantityNum)
			{
				objTQuantityNum.onkeypress=NumberPressHandler
			}
		}
		else if (colName=="TSupplementNum")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
         	html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","TotalFeeA_Change")	
						
			//数量
			var objTQuantityNum=document.getElementById(Id);
			if(objTQuantityNum)
			{
				objTQuantityNum.onkeypress=NumberPressHandler
			}
		}
		else if (colName=="TEquipList")
		{
			RowObj.cells[j].onclick=EquipListClick;
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
		if (html!="") RowObj.cells[j].innerHTML=html;
	    if (value!="")
	    {
		    value=trim(value);
		    if (RowObj.cells[j].firstChild.tagName=="LABEL")
		    {
			    RowObj.cells[j].firstChild.innerText=value;
			}
			else if ((RowObj.cells[j].firstChild.tagName=="INPUT")&&(RowObj.cells[j].firstChild.type=="checkbox"))
		    {
			    RowObj.cells[j].firstChild.checked=value;
			}
			else
		    {
			    RowObj.cells[j].firstChild.value=value;
		    }
	    }
	}
}

//明细删除功能
function DeleteClickHandler()
{
	var truthBeTold = window.confirm(t["-4003"]);
	if (!truthBeTold) return
	try
	{
		var objtbl=document.getElementById('tDHCEQSwapNew');
		var rows=objtbl.rows.length;
		selectrow=GetTableCurRow();
		
		var TRowID=GetElementValue('TRowIDz'+selectrow);
		tableList[selectrow]=TRowID	
		var delNo=GetElementValue("TRowz"+selectrow);
		//判断是否删除仅剩的1行记录
		if (rows<=3) 
		{
			//Modified by jdl 2011-01-28 JDL0068
			//修改删除仅剩的一行后?编辑保存数据异常?无法保存的问题
			tableList[selectrow]=0;
			if (TRowID!="")
			{
				SetElement('TRowIDz'+selectrow,"");				
				tableList[tableList.length]=TRowID;
			}
			ClearValue()
			SetElement("Job","")
		}
		else
		{
			DeleteTabRow(objtbl,selectrow);
			SumList_Change();
		}
	    ResetNo(selectrow,delNo) //重新产生新的序号
	} catch(e) {};
}
function DeleteTabRow(objtbl,selectrow)
{
	var rows=objtbl.rows.length;
	if (rows>2)
	{
		var eSrc=window.event.srcElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex; //当前选择行
		objtbl.deleteRow(selectrow);
	}
}

function EquipListClick()
{
	selectrow=GetTableCurRow();
	var InStockListDR=GetElementValue("TInStockListDRz"+selectrow)
	var MasterItemDR=GetElementValue("TMasterItemDRz"+selectrow)
	if ((InStockListDR=="")&&(MasterItemDR=="")) return
	var QuantityNum=GetElementValue("TQuantityNumz"+selectrow)
	if (QuantityNum=="") return
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQUpdateEquipsByList";
	lnk=lnk+"&SourceID="+InStockListDR
	lnk=lnk+"&QuantityNum="+QuantityNum
	lnk=lnk+"&Job="+GetElementValue("Job")
	lnk=lnk+"&index="+selectrow
	lnk=lnk+"&MXRowID="+GetElementValue("TRowIDz"+selectrow)
	lnk=lnk+"&StoreLocDR="+GetElementValue("RequestLocDR")
	lnk=lnk+"&Status=2"//+GetElementValue("Status")
	lnk=lnk+"&Type=4"
	lnk=lnk+"&EquipID="+GetElementValue("TRowIDSz"+selectrow)
   	window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}
///明细记录发生变化时清空之前选择记录(批量记录)对应设备RowID串
function SetTEMPEQ(index)
{
	var MasterItemDR=GetElementValue("TMasterItemDRz"+index)
	if (MasterItemDR=="") return
	var ModelDR=GetElementValue("TModelDRz"+index)
	if (ModelDR=="") return
	var QuantityNum=GetElementValue("TQuantityNumz"+index)
	if (QuantityNum=="") return
	var val=GetElementValue("Job")
	val=val+"^"+index
	val=val+"^"+GetElementValue("TRowIDz"+index)
  	var encmeth=GetElementValue("SetTEMPEQ")
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,val);
	if (rtn>0)
	{
		SetElement("Job",rtn)
	}
}

function GetRowIDSNum(i)
{
	//selectrow=GetTableCurRow()
	var QuantityNum=GetElementValue("TQuantityNumz"+i)
	if (QuantityNum=="") return;
	var MasterItemDR=GetElementValue("TMasterItemDRz"+i)
	if (MasterItemDR=="") return;
	var ModelDR=GetElementValue("TModelDRz"+i)
	var RequestLocDR=GetElementValue("RequestLocDR")
	if (RequestLocDR=="") return;
	var EquipTypeDR=GetElementValue("EquipTypeDR")
	if (EquipTypeDR=="") return;
	var encmeth=GetElementValue("GetRowIDS")
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,QuantityNum,MasterItemDR,ModelDR,RequestLocDR,EquipTypeDR);
	SetElement("TRowIDSz"+i,rtn)
}

function TotalFee_Change()
{
	selectrow=GetTableCurRow();
	var TQuantityNum=parseInt(GetElementValue("TQuantityNumz"+selectrow))
	var TSupplementNum=parseInt(GetElementValue("TSupplementNumz"+selectrow))
	if (TQuantityNum<0)
	{
		SetElement('TQuantityNumz'+selectrow,'');
	}
	else
	{
		SetElement('TQuantityNumz'+selectrow,TQuantityNum);
		SetElement('TSupplementNumz'+selectrow,TQuantityNum);
	}
	GetRowIDSNum(selectrow)
	SumList_Change();
}

function TotalFeeA_Change()
{
	selectrow=GetTableCurRow();
	var TSupplementNum=parseInt(GetElementValue("TSupplementNumz"+selectrow))
	if (TSupplementNum<0)
	{
		SetElement('TSupplementNumz'+selectrow,'');
	}
	else
	{
		SetElement('TSupplementNumz'+selectrow,TSupplementNum);
	}	
	SumList_Change();
}

function SumList_Change()
{
	var length=tableList.length
	var TotalQty=0
	var TotalSmt=0
	var index=""
	for (var i=0;i<length;i++)
	{
		if (tableList[i]=="0")
		{
			var TSupplementNum=parseInt(GetElementValue("TSupplementNumz"+i))
			var TQuantityNum=parseInt(GetElementValue("TQuantityNumz"+i))
			if ((isNaN(TSupplementNum))||(isNaN(TQuantityNum))) continue;
			TotalQty=TotalQty+TQuantityNum
			TotalSmt=TotalSmt+TSupplementNum
		}
		else if (tableList[i]==-1)
		{
			var index=i
		}
	}
	SetElement('TQuantityNumz'+index,TotalQty);
	SetElement('TSupplementNumz'+index,TotalSmt);
}

function LookUpInStockList(vClickEventFlag)
{
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		if (CheckNull()) return;
		selectrow=GetTableCurRow();
		//LookUpMasterItem("GetMasterItem","EquipTypeDR,StatCatDR,TMasterItemz"+selectrow);
		//RowID_"^"_FromLocDR_"^"_EquipTypeDR_"^"_StatCatDR_"^"_StockStatus_"^"_ProviderDR_"^"_ListType_"^"_Equip_"^"_InStockNo_"^"_UseLocDR_"^"_TFlag
		//LookUp("","web.DHCEQStoreMoveNew:GetInStockList","GetInStockList","TRowIDz"+selectrow+",RequestLocDR,EquipTypeDR,StatCatDR,'1',ProvderDR,'1',TEquipz"+selectrow+",'','','false'");
		LookUp("","web.DHCEQSwapNew:GetLocMasterItemQty","GetInStockList","TRowIDz"+selectrow+",RequestLocDR,EquipTypeDR,TMasterItemz"+selectrow)
	}
}

function GetInStockList(value)
{
	var list=value.split("^")
	var Length=tableList.length
	for (var i=1;i<Length;i++)
	{
		if ((tableList[i]=="0")&&(GetElementValue("TMasterItemDRz"+i)==list[3])&&(GetElementValue("TModelDRz"+i)==list[4])&&(selectrow!=i))
		{
			var TRow=GetCElementValue("TRowz"+i);
			alertShow("当前选择行与明细中第"+(TRow)+"行重复!")
			return;
		}
	}
	//单台设备时InstockListDR应为空
	if (list[2]==0)
	{
		list[2]=""
	}
	SetElement('TMasterItemz'+selectrow,list[0]);
	SetElement('TMasterItemDRz'+selectrow,list[3]);
	//SetElement('TInStockListDRz'+selectrow,list[2]);
	SetElement('TModelDRz'+selectrow,list[4]);
	SetElement('TModelz'+selectrow,list[1]);
	SetElement('TSupplementNumz'+selectrow,list[2]);
	SetElement('TQuantityNumz'+selectrow,list[2]);
	

	
	//明细记录发生变化时清空当前记录(批量记录)对应设备RowID串
	if ((GetElementValue("TMasterItemDRz"+selectrow)!=list[3])||(GetElementValue("TModelDRz"+selectrow)!=list[4]))
	{
		SetTEMPEQ(selectrow)
	}
	//alertShow(GetElementValue("TInStockListDRz"+selectrow))
	GetRowIDSNum(selectrow)
	SumList_Change();
	var obj=document.getElementById("TMasterItemz"+selectrow);
	if (obj) websys_nextfocusElement(obj); 
}

function KeyupEquip()
{
	selectrow=GetTableCurRow();
	SetElement('TMasterItemDRz'+selectrow,"");
	SetElement('TModelDRz'+selectrow,"");
}
/*
function GetMasterItem(value)
{
	Clear()
	var list=value.split("^")
	var Length=selectrow

	for (var i=1;i<Length;i++)
	{
		if ((tableList[i]=="0")&&(GetElementValue("TMasterItemDRz"+i)==list[1])&&(selectrow!=i))
		{
			alertShow("选择的设备项与第"+GetCElementValue("TRowz"+i)+"行重复!")
			return;
		}
	}
	SetElement('TMasterItemz'+selectrow,list[0]);
	SetElement('TMasterItemDRz'+selectrow,list[1]);
	var obj=document.getElementById("TMasterItemz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}

function KeyupMasterItem()
{
	selectrow=GetTableCurRow();
	SetElement('TMasterItemDRz'+selectrow,"");
}
*/
function LookUpModelNew(vClickEventFlag)
{
	selectrow=GetTableCurRow();
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		LookUpModel("GetModel","TMasterItemDRz"+selectrow+",TModelz"+selectrow);
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


function CheckNull()
{
	if (CheckMustItemNull()) return true;
	return false;
}

function Clear()
{
	
}

function GetEquipType (value)
{
    GetLookUpID("EquipTypeDR",value);
}


function GetRequestUser (value)
{
    GetLookUpID("RequestUserDR",value);
}

function GetRequestLoc (value)
{
    GetLookUpID("RequestLocDR",value);
}

function GetLoc (value)
{
    GetLookUpID("LocDR",value);
}

document.body.onload = BodyLoadHandler;