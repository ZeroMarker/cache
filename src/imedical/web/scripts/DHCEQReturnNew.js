/// 创    建:ZY  2010-03-26  No.ZY0019
/// 修改描述:设备转移
/// --------------------------------
/// Modefied by zc 2014-9-15 ZC0006 
/// 增加单台标识TFlag的判断
///记录 设备 RowID?处理重复选择RowID的问题
var ObjSources=new Array();
//最后一行数据元素的名字的后缀序号
var LastNameIndex;
//新增一行数据元素的名字的后缀序号
var NewNameIndex;
//操作行号
var selectrow=0;

var Component="DHCEQReturnNew"

function BodyLoadHandler()
{
	InitUserInfo();
	InitPage();
	FillData();
	if (GetElementValue("OutTypeDR")!=1) Component="DHCEQOutStockNew"
	SetEnabled();
	InitEditFields(GetElementValue("ApproveSetDR"),GetElementValue("CurRole"));
	InitApproveButton();
	SetTableItem()
	SetDisplay()
	SetElement("Job",GetElementValue("TJobz1"));
	KeyUp("ReturnLoc^Provider^EquipType^StatCat^OutType^ToDept^UseLoc","N");
	Muilt_LookUp("ReturnLoc^Provider^EquipType^StatCat^OutType^ToDept^UseLoc");
	document.body.onunload = BodyUnloadHandler;
}

function SetEnabled()
{
	var Status=GetElementValue("Status");
	var WaitAD=GetElementValue("WaitAD");
	//状态为新增时,方可提交或删除
	//状态小于1时?方可增删改
	if (Status!="0")
	{
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BDeleteList",true);//270385 Add By BRB 2016-10-19 
		if (Status!="")
		{
			DisableBElement("BUpdate",true);
			DisableBElement("BAdd",true);
			DisableBElement("BClear",true);
		}
	}
	//审核后才可打印及生成转移单
	if (Status!="2")
	{
		DisableBElement("BPrint",true);
	}
	//非建单据菜单,不可更新等操作单据
	if (WaitAD!="off")
	{
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
	if ((RowID=="")||(RowID<1)){	return;	}
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	//alertShow(list)
	var sort=28;
	SetElement("ReturnNo",list[0]);
	SetElement("ReturnLocDR",list[1]);
	SetElement("ReturnLoc",list[sort+0]);
	SetElement("ProviderDR",list[2]);
	SetElement("Provider",list[sort+1]);
	SetElement("ReturnDate",list[3]);
	SetElement("MakerDR",list[4]);
	SetElement("Maker",list[sort+2]);
	SetElement("MakeDate",list[5]);
	SetElement("AckUserDR",list[6]);
	SetElement("AckUser",list[sort+3]);
	SetElement("AckDate",list[7]);
	SetElement("AckTime",list[8]);
	SetElement("BillAckUserDR",list[9]);
	SetElement("BillAckUser",list[sort+4]);
	SetElement("BillAckDate",list[10]);
	SetElement("BillAckTime",list[11]);
	SetElement("Status",list[12]);
	SetElement("Remark",list[13]);
	SetElement("EquipTypeDR",list[14]);
	SetElement("EquipType",list[sort+5]);
	SetElement("StatCatDR",list[15]);
	SetElement("StatCat",list[sort+6]);
	SetElement("OutTypeDR",list[16]);
	SetElement("OutType",list[sort+7]);
	SetElement("ToDeptDR",list[17]);
	SetElement("ToDept",list[sort+8]);
	SetElement("Hold1",list[18]);
	SetElement("Hold2",list[19]);
	SetElement("Hold3",list[20]);
	//alertShow(list[sort+8])
	SetElement("ApproveSetDR",list[sort+10]);
	SetElement("NextRoleDR",list[sort+11]);
	SetElement("NextFlowStep",list[sort+12]);
	SetElement("ApproveStatu",list[sort+13]);
	SetElement("ApproveRoleDR",list[sort+14]);
	SetElement("CancelFlag",list[sort+15]);
	SetElement("CancelToFlowDR",list[sort+16]);
	//2010-10-21 Add By DJ
	SetElement("UseLoc",list[sort+19]);
	SetElement("UseLocDR",list[23]);
}
function InitPage()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Clicked;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Clicked;
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Clicked;
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Clicked;
	var obj=document.getElementById("BPrintBar");
	if (obj) obj.onclick=BPrintBar_Clicked;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Clicked;
	var obj=document.getElementById("BOutPrint");
	if (obj) obj.onclick=BOutPrint_Clicked;
	if (opener)
	{
		var obj=document.getElementById("BClose");
		if (obj) obj.onclick=CloseWindow;
	}
	else
	{
		EQCommon_HiddenElement("BClose")
	}
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=AddClickHandler;
	var GetProviderOperMethod=GetElementValue("GetProviderOperMethod")
	// 0:放大镜选择模式 1:手工录入模式,并自动更新机型表 2:两种均可
	if (GetProviderOperMethod==1) 
	{
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iProvider").removeNode(true)
	}
}
function BClear_Clicked()
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+Component;
	lnk=lnk+"&Status=0&QXType=2&WaitAD=off"
	lnk=lnk+"&OutTypeDR="+GetElementValue("OutTypeDR")
	window.location.href=lnk;
}

function BUpdate_Clicked()
{
	var GetProviderOperMethod=GetElementValue("GetProviderOperMethod")
	if (GetProviderOperMethod=="") SetElement("GetProviderOperMethod", "0");
	if (CheckNull()) return;
	var combindata=GetValueList();
  	var valList=GetTableInfo();
  	if (valList=="-1")  return;
  	var DelRowid=tableList.toString()
  	var encmeth=GetElementValue("UpdateData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata,valList,DelRowid);
	var list=Rtn.split("^");
	if ((list[1]!="")&&(list.length>1))
	{
		alertShow("第"+list[0]+"行"+list[1])
	}
	else
	{
		if (list[0]>0)
		{
			var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+Component;
			lnk=lnk+"&WaitAD=off&RowID="+Rtn
			lnk=lnk+"&OutTypeDR="+GetElementValue("OutTypeDR")
			//add by HHM 20150910 HHM0013
			//添加操作成功是否提示
			ShowMessage();
			//****************************
			window.location.href=lnk;
		}
		else
		{
			if (list[0]=="-1015") //2011-10-31 DJ DJ0098
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
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	var combindata=GetValueList();
  	var encmeth=GetElementValue("DeleteData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata);
	if (Rtn==0)
    {
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+Component;
		lnk=lnk+"&WaitAD=off&QXType="+GetElementValue("QXType")
		lnk=lnk+"&OutTypeDR="+GetElementValue("OutTypeDR")
		window.location.href=lnk;
	}
    else
    {
	    alertShow(Rtn+"   "+t["01"]);
    }
}

function BPrint_Clicked()
{
	var id=GetElementValue("RowID")
	if (""!=id) PrintReturn(id);
}

function BOutPrint_Clicked()
{
	var id=GetElementValue("RowID")
	if (""!=id) PrintOutStock(id);
}

function BCancelSubmit_Clicked() 
{
	var combindata=GetValueList();
  	var encmeth=GetElementValue("CancelSubmitData")
  	if (encmeth=="") return;
  	//Modified by jdl 2011-3-9  jdl0073
	var Rtn=cspRunServerMethod(encmeth,combindata,GetElementValue("CurRole"));
    if (Rtn>0)
    {
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+Component;
		lnk=lnk+"&RowID="+Rtn
		lnk=lnk+"&OutTypeDR="+GetElementValue("OutTypeDR")
		window.location.href=lnk;
	}
    else
    {
	    alertShow(Rtn+"   "+t["01"]);
    }
}
function BSubmit_Clicked()
{
	if (CheckNull()) return;
	//退货单据提示是否冲减明细记录累计折旧 DJ0137
	var AutoCancelDepre=0
	if (GetElementValue("OutTypeDR")==1)
	{
		var RowID=GetElementValue("RowID");
	    if (RowID=="") return;
		var encmeth=GetElementValue("LastStepFlag");
		if (encmeth=="") return
		var NextFlowStep=GetElementValue("NextFlowStep");
		var NextRoleDR=GetElementValue("NextRoleDR");
		var LastStepFlag=cspRunServerMethod(encmeth,"15",RowID,NextFlowStep,NextRoleDR);
		if (LastStepFlag=="Y")
		{
		    var encmeth=GetElementValue("CheckReturnDepre");
			if (encmeth=="") return;
			var CheckResult=cspRunServerMethod(encmeth,RowID);
			if (CheckResult=="-1")
			{
				var truthBeTold = window.confirm("明细设备中当月存在折旧,是否冲减?");
				if (truthBeTold)
				{
					AutoCancelDepre=1
				}
			}
			if (CheckResult=="-2")
			{
				var truthBeTold = window.confirm("明细设备中存在多个月份折旧,是否冲减?");
				if (truthBeTold)
				{
					AutoCancelDepre=1
				}
			}
		}
	}
	
	var combindata=GetValueList();
  	var valList=GetTableInfo();
  	if (valList=="")
  	{
	  	alertShow(t["-1003"])
	  	return;
	}
  	var encmeth=GetElementValue("SubmitData")
  	if (encmeth=="") return;
  	
	///alertShow(combindata);
  	///SetElement("Remark",combindata);
  	///return;  
	var Rtn=cspRunServerMethod(encmeth,combindata,AutoCancelDepre);	//DJ0137
	if (Rtn>0)
    {
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+Component;
		lnk=lnk+"&RowID="+Rtn
		lnk=lnk+"&QXType="+GetElementValue("QXType")
		lnk=lnk+"&WaitAD="+GetElementValue("WaitAD")
		lnk=lnk+"&OutTypeDR="+GetElementValue("OutTypeDR")
		window.location.href=lnk;
	}
    else
    {
	    if (isNaN(Rtn)) //2011-05-27 DJ
	    {
		    alertShow(Rtn+"   "+t["01"]);
	    }
	    else
	    {
		    alertShow(t[Rtn]+"   "+t["01"]);
	    }
    }
}

/////////////////////////////////////////////////////////
function BApprove_Clicked()
{
	//退货单据提示是否冲减明细记录累计折旧 DJ0137
	var ReturnDepreFlag=GetElementValue("ReturnDepreFlag");
	if (ReturnDepreFlag=="") ReturnDepreFlag=1
	var AutoCancelDepre=0
	if ((GetElementValue("OutTypeDR")==1)&&(ReturnDepreFlag!=0))
	{
		var RowID=GetElementValue("RowID");
	    if (RowID=="") return;
		var encmeth=GetElementValue("LastStepFlag");
		if (encmeth=="") return
		var NextFlowStep=GetElementValue("NextFlowStep");
		var NextRoleDR=GetElementValue("NextRoleDR");
		var LastStepFlag=cspRunServerMethod(encmeth,"15",RowID,NextFlowStep,NextRoleDR);
		if (LastStepFlag=="Y")
		{
		    var encmeth=GetElementValue("CheckReturnDepre");
			if (encmeth=="") return;
			var CheckResult=cspRunServerMethod(encmeth,RowID);
			if ((CheckResult=="-1")&&(ReturnDepreFlag==1))
			{
				var truthBeTold = window.confirm("明细设备中当月存在折旧,是否冲减?");
				if (truthBeTold)
				{
					AutoCancelDepre=1
				}
			}
			if ((CheckResult=="-2")&&(ReturnDepreFlag==1))
			{
				var truthBeTold = window.confirm("明细设备中存在多个月份折旧,是否冲减?");
				if (truthBeTold)
				{
					AutoCancelDepre=1
				}
			}
			if (ReturnDepreFlag==2)
			{
				AutoCancelDepre=1
			}
		}
	}	
	var combindata=GetValueList();
	var CurRole=GetElementValue("CurRole")
  	if (CurRole=="") return;
	var RoleStep=GetElementValue("RoleStep")
  	if (RoleStep=="") return;
  	var objtbl=document.getElementById('t'+Component);
	var EditFieldsInfo=ApproveEditFieldsInfo(objtbl);
  	if (EditFieldsInfo=="-1") return;
  	var encmeth=GetElementValue("AuditData")
  	if (encmeth=="") return;
  	
  	///alertShow(combindata+"&"+CurRole+"&"+RoleStep+"&"+EditFieldsInfo);
  	///SetElement("Remark",combindata+"&"+CurRole+"&"+RoleStep+"&"+EditFieldsInfo);
  	///return;  
	var Rtn=cspRunServerMethod(encmeth,combindata,CurRole,RoleStep,EditFieldsInfo,AutoCancelDepre);	//DJ0137
    if (Rtn>0)
    {
	    window.location.reload();
	}
    else
    {
	    if (isNaN(Rtn)) //2011-05-27 DJ
	    {
		    alertShow(Rtn+"   "+t["01"]);
	    }
	    else
	    {
		    alertShow(t[Rtn]+"   "+t["01"]);
	    }
    }
}
/////////////////////////////////////////////////////////

function GetValueList()
{
	var combindata="";
  	combindata=GetElementValue("RowID") ;				//1
  	combindata=combindata+"^"+GetElementValue("ReturnLocDR") ;	//2
  	combindata=combindata+"^"+GetElementValue("ProviderDR") ;	//3
  	combindata=combindata+"^"+GetElementValue("ReturnDate") ;	//4
  	combindata=combindata+"^"+GetElementValue("Remark") ;	//5
  	combindata=combindata+"^"+GetElementValue("EquipTypeDR") ;	//6
  	combindata=combindata+"^"+GetElementValue("StatCatDR") ;  		//7
  	combindata=combindata+"^"+GetElementValue("OutTypeDR") ;	//8
  	combindata=combindata+"^"+GetElementValue("ToDeptDR") ;	//9
  	combindata=combindata+"^"+GetElementValue("Hold1") ;	//10
  	combindata=combindata+"^"+GetElementValue("Hold2") ;	//11
  	combindata=combindata+"^"+GetElementValue("Hold3") ;	//12
	combindata=combindata+"^"+curUserID;	//13
	combindata=combindata+"^"+GetElementValue("CancelToFlowDR");	//14
	combindata=combindata+"^"+GetElementValue("ApproveSetDR");	//15
	combindata=combindata+"^"+GetElementValue("Job");
	combindata=combindata+"^"+GetElementValue("UseLocDR");
  	return combindata;
}

function CheckNull()
{
	if (CheckMustItemNull("Provider")) return true;
	var obj=document.getElementById("cProvider");
	if ((obj)&&(obj.className=="clsRequired"))
	{
		if (GetElementValue("GetProviderOperMethod")==0)
		{
			if (CheckItemNull(1,"Provider")==true) return true;
		}
		else
		{
			if (CheckItemNull("","Provider")==true) return true;
		}		
	}
	return false;
}
function ProviderDR (value)
{
    GetLookUpID("ProviderDR",value);
}
function ReturnLocDR (value)
{
    GetLookUpID("ReturnLocDR",value);
}
function GetUseLocDR (value)
{
    GetLookUpID("UseLocDR",value);
}
function GetStatCat (value)
{
    GetLookUpID("StatCatDR",value);
}
function GetEquipType (value)
{
    GetLookUpID("EquipTypeDR",value);
}

function GetToDept(value)
{
	GetLookUpID("ToDeptDR",value);
}

function GetOutType(value)
{
	GetLookUpID("OutTypeDR",value);
}

function BPrintBar_Clicked()
{
	DHCEQStoreMovePrintBar()
}
function SetTableItem()
{
  	var objtbl=document.getElementById('t'+Component);
	var rows=objtbl.rows.length-1;
	for (var i=1;i<=rows;i++)
	{	
		var InStockListDR=GetElementValue("TInStockListDRz"+i);
		var TEquipDR=GetElementValue("TEquipDRz"+i);
		if (InStockListDR!="") 
		{
			ObjSources[i]=new SourceInfo("1",InStockListDR);  //1,入库单;2,设备
		}
		else if (TEquipDR!="")
		{
			ObjSources[i]=new SourceInfo("2",TEquipDR);  //1,入库单;2,设备
		}
		else
		{
			//Add By JDL 2011-08-18 JDL0090
			ObjSources[i]=new SourceInfo("","");  //1,入库单;2,设备
		}
		
		if(tableList[i]!="0") tableList[i]=0;
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
				obj=document.getElementById("TEquipListz"+i);
				if (obj)
				{
					obj.innerText=""
					DisableBElement("TEquipListz"+i,true);
					HiddenObj("TEquipListz"+i,1)
				}
				tableList[i]=-1;
				continue;
			}
		}
		ChangeRowStyle(objtbl.rows[i]);		///改变一行的内容显示
	}
}

///改变一行的内容显示
function ChangeRowStyle(RowObj)
{
  	var objtbl=document.getElementById('t'+Component);
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
		if (colName=="TEquip")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id);
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpInStockList","","","KeyupEquip")
		}
		else if (colName=="TFlag")
		{
			value=GetCElementValue(Id)
			html=CreatElementHtml(5,Id,objwidth,objheight,"","","","")
		}
		else if (colName=="TRemark")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id);
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TReturnReason")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id);
			html=CreatElementHtml(2,Id,objwidth,objheight,"ReturnReason","","","Standard_TableKeyUp")
		}
		else if (colName=="TReturnQtyNum")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id);
         	html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","TotalFee_Change")
			//数量
			var objTQuantityNum=GetElementValue(Id);;
			if(objTQuantityNum)
			{
				objTQuantityNum.onkeypress=NumberPressHandler
			}
		}
		else if (colName=="TDealFee")
		{
			value=GetCElementValue(Id);
			if (GetElementValue("OutTypeDR")==1)
			{
				HiddenTblColumn(objtbl,"TDealFee");
			}
			else
			{
				if (CheckUnEditField(Status,colName)) continue;				
				html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
			}
		}
		else if (colName=="TInvoiceNo")
		{
			value=GetCElementValue(Id);
			if (GetElementValue("OutTypeDR")!=1)
			{
				HiddenTblColumn(objtbl,"TInvoiceNo");
			}
			else
			{
				if (CheckUnEditField(Status,colName)) continue;
				//html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
			}
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
		else if (colName=="TEquipList")
		{
			RowObj.cells[j].onclick=EquipListClick;
		}
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

function TotalFee_Change()
{
	selectrow=GetTableCurRow();
	//begin add by jyp 2018-03-13 552228
	if(GetElementValue('TInStockListDRz'+selectrow)="")
	{
		return;
	}
	//end add by jyp 2018-03-13 552228
	var TReturnFee=GetElementValue("TReturnFeez"+selectrow)
	var TReturnQtyNum=parseInt(GetElementValue("TReturnQtyNumz"+selectrow))
	var TReturnNum=parseInt(GetElementValue("TReturnNumz"+selectrow))
	if((TReturnQtyNum>TReturnNum)||(TReturnQtyNum<1)||(isNaN(TReturnQtyNum)))
	{
		alertShow("数量无效!")
		SetElement('TReturnQtyNumz'+selectrow,'');
		return
	}
	var TFlag=GetElementValue("TFlagz"+selectrow)
	if(TFlag==true)
	{
		if((TReturnQtyNum>1))
		{
			alertShow("数量无效!")
			SetElement('TReturnQtyNumz'+selectrow,'');
			return;
		}
	}
	
	var TotalFee=TReturnQtyNum*TReturnFee
	if (TotalFee<=0)
	{
		SetElement('TTotalFeez'+selectrow,'');
	}
	else
	{
		SetElement('TTotalFeez'+selectrow,TotalFee.toFixed(2));
	}
	SumList_Change()
	UpListEQRowIDS(selectrow)	//Add By DJ 2017-11-20
}

function ClearValue()
{
	selectrow=GetTableCurRow();
	SetElement('TEquipz'+selectrow,"");
	SetElement('TEquipDRz'+selectrow,"");
	SetElement('TInStockListDRz'+selectrow,"");
	SetElement('TModelz'+selectrow,"");
	SetElement('TManuFactoryz'+selectrow,"");
	SetElement('TQuantityNumz'+selectrow,"");
	SetElement('TRemarkz'+selectrow,"");
	SetElement('TReturnNumz'+selectrow,"");
	SetElement('TReturnQtyNumz'+selectrow,"");
	SetElement('TReturnFeez'+selectrow,"");
	SetElement('TInvoiceNoz'+selectrow,"");
	SetElement('TInvoiceNoDRz'+selectrow,"");
	SetElement('TTotalFeez'+selectrow,"");
	SetElement('TReturnReasonz'+selectrow,"");
	SetElement('TReturnReasonDRz'+selectrow,"");
	SetElement('TDealFeez'+selectrow,"");
	if (GetElementValue("TotalFlag")!=0)
	{
		SumList_Change();
	}
}
function LookUpInStockList(vClickEventFlag)
{
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		if (CheckNull()) return;
		selectrow=GetTableCurRow();
		//Add By DJ 2017-11-20 获取当前页当前行的行标,Job及所有明细清单.
		var AllListInfo=selectrow+"="+GetElementValue("Job")+"="+GetAllListInfo()
		SetElement("AllListInfo",AllListInfo)
		// Mozy0095		2013-03-27
		LookUp("","web.DHCEQStoreMoveNew:GetInStockList","GetInStockList","TRowIDz"+selectrow+",ReturnLocDR,EquipTypeDR,StatCatDR,StockStatus,ProviderDR,ListType,TEquipz"+selectrow+",'',UseLocDR,TFlagz"+selectrow+",'',AllListInfo");
	}
}
function GetInStockList(value)
{
	var list=value.split("^")
	var Length=ObjSources.length
	
	//Modified By JDL 2011-08-17 JDL0090
	var LastSourceType=ObjSources[selectrow].SourceType //变动之前的SourceType
	var LastSourceID=ObjSources[selectrow].SourceID //变动之前的SourceID
	
	if (list[2]==0)
	{
		for (var i=0;i<Length;i++)
		{
			if ((tableList[i]=="0")&&(ObjSources[i].SourceType=="2")&&(ObjSources[i].SourceID==list[1])&&(selectrow!=i)) //add by zx 2015-01-05
			{
				var ObjTRow=document.getElementById("TRowz"+i);
				if (ObjTRow)  var TRow=ObjTRow.innerText;
				alertShow("选择行与第"+(TRow)+"行是重复的设备!")
				return;
			}
		}
		ObjSources[selectrow]=new SourceInfo("2",list[1]);
		list[2]=""
	}
	else
	{
		for (var i=0;i<Length;i++)
		{
			if ((tableList[i]=="0")&&(ObjSources[i].SourceType=="1")&&(ObjSources[i].SourceID==list[2])&&(selectrow!=i))
			{
				var ObjTRow=document.getElementById("TRowz"+i);
				if (ObjTRow)  var TRow=ObjTRow.innerText;
				alertShow("选择行与第"+(TRow)+"行是重复的入库单!")
				return;
			}
		}
		ObjSources[selectrow]=new SourceInfo("1",list[2]);
	}
	SetElement('TEquipz'+selectrow,list[0]);
	SetElement('TEquipDRz'+selectrow,list[1]);
	SetElement('TInStockListDRz'+selectrow,list[2]);
	//SetElement('TModelDRz'+selectrow,list[3]);
	SetElement('TModelz'+selectrow,list[4]);
	//SetElement('TManuFactoryDRz'+selectrow,list[5]);
	SetElement('TManuFactoryz'+selectrow,list[6]);
	//SetElement('TUnitDRz'+selectrow,list[7]);
	//SetElement('TUnitz'+selectrow,list[8]);
	SetElement('TReturnNumz'+selectrow,list[9]);
	SetElement('TReturnQtyNumz'+selectrow,list[9]);
	SetElement('TReturnFeez'+selectrow,list[10]);
	SetElement('TTotalFeez'+selectrow,(list[9]*list[10]).toFixed(2));
	SetElement('TInvoiceNoz'+selectrow,list[13]);
	
	//Modified By JDL 2011-08-17 JDL0090 有变化则清掉临时Global记录
	if ((LastSourceType!=ObjSources[selectrow].SourceType)||(LastSourceID!=ObjSources[selectrow].SourceID))
	{
		SetTEMPEQ(selectrow)
	}
	
	SumList_Change()
	var obj=document.getElementById("TEquipz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
	UpListEQRowIDS(selectrow)	//Add By DJ 2017-11-20
}

function ReturnReason(vClickEventFlag)
{
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		if (CheckNull()) return;
		selectrow=GetTableCurRow();
		LookUpReturnReason("GetReturnReason","TReturnReasonz"+selectrow);
	}
}
function GetReturnReason(value)
{
	var list=value.split("^")
	SetElement('TReturnReasonz'+selectrow,list[0]);
	SetElement('TReturnReasonDRz'+selectrow,list[1]);
	var obj=document.getElementById("TReturnReasonz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}

function AddClickHandler() {
	try 
	{
  		var objtbl=document.getElementById('t'+Component);
		var ret=CanAddRow(objtbl);
		if (ret)
		{
			NewNameIndex=tableList.length;
	    	AddRowToList(objtbl,LastNameIndex,NewNameIndex);
	    	/// Add by JDL 2011-08-24 JDL0092
	    	ObjSources[NewNameIndex]=new SourceInfo("","");
	    	
	    	var TEquipList=document.getElementById("TEquipListz"+NewNameIndex); //选择设备
			if (TEquipList)	TEquipList.onclick=EquipListClick;
	    }
	    //begin add by jyp 2018-03-12 544959
	    else
	    {
		    alertShow("上一行设备名称为空!")   
		}
		//end add by jyp 2018-03-12 544959
        return false;
	} catch(e) {};
}
function CanAddRow(objtbl)
{
	var rows=objtbl.rows.length;
    if (rows==1) return false;
	var TotalFlag=GetElementValue("TotalFlag")
	if (TotalFlag==2) rows=rows-1
	LastNameIndex=GetRowIndex(objtbl.rows[rows-1]);
	if  (GetElementValue('TEquipz'+LastNameIndex)=="")
	{
		SetFocusColumn("TEquip",LastNameIndex);
		return false;
	}
	return true;
}

function DeleteClickHandler() {
	var truthBeTold = window.confirm(t["-4003"]);
	if (!truthBeTold) return;
	try
	{
  		var objtbl=document.getElementById('t'+Component);
		var rows=objtbl.rows.length;
		selectrow=GetTableCurRow();
		
		var TotalFlag=GetElementValue("TotalFlag")
		
		var TRowID=GetElementValue('TRowIDz'+selectrow);
		tableList[selectrow]=TRowID;
		var delNo=GetElementValue("TRowz"+selectrow);
		
		if (((TotalFlag==0)&&(rows<=2))||((rows<=3)&&((TotalFlag==1)||(TotalFlag==2))))
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
			//SetElement("Job","")		//Modify DJ 2015-09-10 DJ0163
		} 
		else
		{
	    	var eSrc=window.event.srcElement;
			var rowObj=getRow(eSrc);
			objtbl.deleteRow(rowObj.rowIndex);
		}
		ResetNo(selectrow,delNo);
	    SumList_Change();
	} catch(e) {};
}

function GetTableInfo()
{
  	var objtbl=document.getElementById('t'+Component);
	var rows=tableList.length
	var valList="";
	for(var i=1;i<rows;i++)
	{
		if (tableList[i]=="0")
		{
			var TRow=GetCElementValue("TRowz"+i);
			var TRowID=GetElementValue('TRowIDz'+i);
			var TInStockListDR=GetElementValue('TInStockListDRz'+i);
			var TEquip=GetElementValue('TEquipz'+i);
			if (TEquip=="")
			{
				alertShow("第"+TRow+"行,选择设备不能为空")
				SetFocusColumn("TEquip",i)
				return "-1"
			}
			var TEquipDR=GetElementValue('TEquipDRz'+i);				
			if ((TEquipDR=="")&&(TInStockListDR==""))
			{
				alertShow("第"+TRow+"行明细为空,请检查!")
				return "-1"
			}
			var TReturnQtyNum=GetElementValue('TReturnQtyNumz'+i);
			if ((TReturnQtyNum=="")||(parseInt(TReturnQtyNum)<=0))
			{
				alertShow("第"+TRow+"行数量不正确!");
				SetFocusColumn("TReturnQtyNum",i)
				return "-1";
			}
			//Modified by JDL 2011-12-15  JDL0105 数量不能为小数
			if (parseInt(TReturnQtyNum)!=TReturnQtyNum)
			{
				alertShow("第"+TRow+"行数量不正确,不能为小数!");
				SetFocusColumn("TReturnQtyNum",i)
				return "-1";
			}
			var TReturnFee=GetCElementValue('TReturnFeez'+i);
			var TInvoiceNo=GetCElementValue('TInvoiceNoz'+i);
			var TReturnReasonDR=GetElementValue('TReturnReasonDRz'+i);
			var TRemark=GetElementValue('TRemarkz'+i);
			var TDealFee=GetElementValue('TDealFeez'+i);
			var THold1=GetElementValue("THold1z"+i);
			var THold2=GetElementValue("THold2z"+i);
			var THold3=GetElementValue("THold3z"+i);
			if(valList!="") {valList=valList+"&";}
			valList=valList+i+"^"+TRowID+"^"+TInStockListDR+"^"+TEquipDR+"^"+TReturnQtyNum+"^"+TReturnFee+"^"+TInvoiceNo+"^"+TReturnReasonDR+"^"+TRemark;
			valList=valList+"^"+TDealFee+"^"+THold1+"^"+THold2+"^"+THold3;
		}
	}
	return  valList
}

function SetDisplay()
{
	ReadOnlyCustomItem(GetParentTable("ReturnNo"),GetElementValue("Status"));
	ReadOnlyElement("ReturnNo",true)
}

function SumList_Change()
{
	var length=tableList.length
	var Num=0
	var Fee=0
	for (var i=1;i<=length;i++)
	{
		if (tableList[i]=="0")
		{
			//Modified by JDL 2011-12-15  JDL0105 金额转换丢失小数			
			var TReturnFee=parseFloat(GetElementValue("TReturnFeez"+i))
			var TReturnQtyNum=parseInt(GetElementValue("TReturnQtyNumz"+i))
			if ((isNaN(TReturnFee))||(isNaN(TReturnQtyNum))) continue;
			var TotalFee=TReturnFee*TReturnQtyNum
			SetElement('TTotalFeez'+i,TotalFee.toFixed(2));
			Num=Num+TReturnQtyNum
			Fee=Fee+TotalFee
		}
		else if (tableList[i]==-1)
		{
			var index=i
		}
	}
	SetElement('TReturnQtyNumz'+index,Num);
	SetElement('TTotalFeez'+index,Fee.toFixed(2));
}

function ResetNo(delindex,delno)
{
	var len=tableList.length;
	var nextNo=delno;
	for (var i=delindex;i<len;i++) 
	{
		if (tableList[i]=="0")
		{			
			SetElement("TRowz"+i,nextNo);
			nextNo=parseInt(nextNo)+1;			
		}
	}	
}

function EquipListClick()
{
	selectrow=GetTableCurRow();
	var InStockListDR=GetElementValue("TInStockListDRz"+selectrow)
	var EquipDR=GetElementValue("TEquipDRz"+selectrow)
	if ((InStockListDR=="")&&(EquipDR=="")) return
	var ReturnQtyNum=GetElementValue("TReturnQtyNumz"+selectrow)
	if (ReturnQtyNum=="") return
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQUpdateEquipsByList";
	lnk=lnk+"&SourceID="+InStockListDR
	lnk=lnk+"&QuantityNum="+ReturnQtyNum
	lnk=lnk+"&Job="+GetElementValue("Job")
	lnk=lnk+"&index="+selectrow
	lnk=lnk+"&MXRowID="+GetElementValue("TRowIDz"+selectrow)
	if (GetElementValue("UseLocDR")=="")
	{
		lnk=lnk+"&StoreLocDR="+GetElementValue("ReturnLocDR")
	}
	else
	{
		lnk=lnk+"&StoreLocDR="+GetElementValue("UseLocDR")
	}
	lnk=lnk+"&Status="+GetElementValue("Status")
	lnk=lnk+"&Type=2"
	lnk=lnk+"&EquipID="+EquipDR
   	window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}
///明细记录发生变化时清空之前选择记录(批量记录)对应设备RowID串
function SetTEMPEQ(index)
{
	var InStockListDR=GetElementValue("TInStockListDRz"+index)
	if (InStockListDR=="") return
	var QuantityNum=GetElementValue("TReturnQtyNumz"+index)
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

function KeyupEquip()
{
	selectrow=GetTableCurRow();
	SetElement('TEquipDRz'+selectrow,"");
	SetElement('TEquipz'+selectrow,"");  //add by jyp 2018-03-14 552228
	SetElement('TInStockListDRz'+selectrow,"");
}
function BodyUnloadHandler()
{
	var Job=GetElementValue("Job")
  	var encmeth=GetElementValue("KillTEMPEQ")
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,Job);	//2=减少
}
//Add By DJ 2017-11-20
function UpListEQRowIDS(selectrow)
{
	//更新明细记录选择设备登记
	var encmeth=GetElementValue("UpListEQRowIDS");
	if (encmeth=="") return
	var EquipDR=GetElementValue("TEquipDRz"+selectrow)
	var MXRowID=GetElementValue("TRowIDz"+selectrow)
	if (GetElementValue("UseLocDR")=="")
	{
		var StoreLocDR=GetElementValue("ReturnLocDR")
	}
	else
	{
		var StoreLocDR=GetElementValue("UseLocDR")
	}
	var InStockListDR=GetElementValue("TInStockListDRz"+selectrow)
	var ReturnQtyNum=GetElementValue("TReturnQtyNumz"+selectrow)
	var Job=GetElementValue("Job")
	var MXInfo=EquipDR+"^2^"+MXRowID+"^"+StoreLocDR+"^"+InStockListDR+"^"+ReturnQtyNum+"^"+Job+"^"+selectrow
	var result=cspRunServerMethod(encmeth,MXInfo);
}
//Add By DJ 2017-11-20
function GetAllListInfo()
{
  	var objtbl=document.getElementById('t'+Component);
	var rows=tableList.length
	var valList="";
	for(var i=1;i<rows;i++)
	{
		if (tableList[i]=="0")
		{
			var TRowID=GetElementValue('TRowIDz'+i);
			if(valList!="")	{valList=valList+"&";}
			valList=valList+i+"^"+TRowID;
		}
	}
	return valList
}
document.body.onload = BodyLoadHandler;