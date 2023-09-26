var selectrow=0;
var ObjSources=new Array();
//最后一行数据元素的名字的后缀序号
var LastNameIndex;
//新增一行数据元素的名字的后缀序号
var NewNameIndex;

document.body.onload = BodyLoadHandler;
function BodyLoadHandler() 
{
	InitUserInfo();
	InitPage();
	SetElement("InType",0);
	FillData();
	SetEnabled();
	SetElement("Job",GetElementValue("TJobz1"));
	InitEditFields(GetElementValue("ApproveSetDR"),GetElementValue("CurRole"));
	InitApproveButton();
	SetTableItem('','','');
	KeyUp("Loc^Provider^BuyUser^AccessoryType^BuyLoc");
	Muilt_LookUp("Loc^Provider^BuyUser^AccessoryType^BuyLoc")
}

function GetProvider (value)
{
    GetLookUpID("ProviderDR",value);
}
function GetAccessoryType (value)
{
    GetLookUpID("AccessoryTypeDR",value);
}
function GetLoc (value)
{
    GetLookUpID("LocDR",value);
}
function GetBuyLoc (value)
{
    GetLookUpID("BuyLocDR",value);
}
function GetBuyUser (value)
{
    GetLookUpID("BuyUserDR",value);
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
	//alertShow(ReturnList)
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	var sort=37
	SetElement("InDate",list[0]);
	SetElement("AccessoryTypeDR",list[1]);
	SetElement("AccessoryType",list[sort+0]);
	SetElement("LocDR",list[2]);
	SetElement("Loc",list[sort+1]);
	//SetElement("RejectReasonDR",list[2]);
	SetElement("RequestUserDR",list[3]);
	SetElement("RequestUser",list[sort+2]);
	SetElement("RequestDate",list[4]);
	SetElement("AInStockNo",list[5]);
	SetElement("InType",list[6]);
	SetElement("ProviderDR",list[7]);
	SetElement("Provider",list[sort+3]);
	SetElement("SourceID",list[8]);
	SetElement("BuyLocDR",list[9]);
	SetElement("BuyLoc",list[sort+4]);
	SetElement("BuyUserDR",list[10]);
	SetElement("BuyUser",list[sort+5]);
	SetElement("RejectReason",list[11]);
	SetElement("RejectUserDR",list[12]);
	SetElement("RejectUser",list[sort+6]);
	SetElement("RejectDate",list[13]);
	SetElement("RejectTime",list[14]);
	SetElement("Status",list[15]);
	SetElement("Remark",list[25]);
	SetElement("AuditUser",list[sort+9]);
	SetElement("AuditUserDR",list[22]);
	SetElement("AuditDate",list[23]);
	//ApproveSetDR_"^"_NextRoleDR_"^"_NextFlowStep_"^"_ApproveStatu_"^"_ApproveRoleDR_"^"_CancelFlag_"^"_CancelToFlowDR_"^"_ApproveRole_"^"_NextRole
	SetElement("ApproveSetDR",list[sort+12]);
	SetElement("NextRoleDR",list[sort+13]);
	SetElement("NextFlowStep",list[sort+14]);
	SetElement("ApproveStatu",list[sort+15]);
	SetElement("ApproveRoleDR",list[sort+16]);
	SetElement("CancelFlag",list[sort+17]);
	SetElement("CancelToFlowDR",list[sort+18]);
	SetElement("InvoiceNos",list[sort+21]);
	/*
	SetElement("Hold1",list[26]);
	SetElement("Hold2",list[27]);
	SetElement("Hold3",list[28]);
	SetElement("Hold4",list[29]);
	SetElement("Hold5",list[30]);
	*/
}

function InitPage()
{
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Clicked;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Clicked;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Clicked;
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Clicked;
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Clicked;
	
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=AddClickHandler;
	var GetProviderOperMethod=GetElementValue("GetProviderOperMethod")
	// 0:放大镜选择模式 1:手工录入模式,并自动更新机型表 2:两种均可
	if (GetProviderOperMethod==1) 
	{
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iProvider").removeNode(true)
	}
}

function GetValueList()
{
	var ValueList="";
	ValueList=GetElementValue("RowID");
	ValueList=ValueList+"^"+curUserID;
	ValueList=ValueList+"^"+GetElementValue("Remark");
	ValueList=ValueList+"^"+GetElementValue("AccessoryTypeDR");
	ValueList=ValueList+"^"+GetElementValue("ApproveSetDR");
	ValueList=ValueList+"^"+GetElementValue("RejectReasonDR");
	ValueList=ValueList+"^"+GetElementValue("CancelToFlowDR");
	ValueList=ValueList+"^"+GetElementValue("Job");
	return ValueList;
}

function BUpdate_Clicked()
{
	var GetProviderOperMethod=GetElementValue("GetProviderOperMethod")
	if (GetProviderOperMethod=="") SetElement("GetProviderOperMethod", "0");
	var RProvDR=GetProviderRowID(GetProviderOperMethod)	//Mozy	1006718	2019-8-28
    if ((RProvDR<=0)&&(GetElementValue("Provider")!=""))
    {
	    alertShow("供应商登记错误!"+RProvDR)
	    return
    }
	if (CheckNull()) return;
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("InDate") ;
  	combindata=combindata+"^"+GetElementValue("AccessoryTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("LocDR") ;
  	combindata=combindata+"^"+curUserID;//RequestUserDR
  	combindata=combindata+"^"+GetElementValue("RequestDate") ;
  	combindata=combindata+"^"+GetElementValue("AInStockNo") ;
  	combindata=combindata+"^"+GetElementValue("InType") ;
  	combindata=combindata+"^"+RProvDR	//GetElementValue("ProviderDR") ;	//Mozy	1006718	2019-8-28
  	combindata=combindata+"^"+GetElementValue("SourceID") ;
  	combindata=combindata+"^"+GetElementValue("BuyLocDR") ;
  	combindata=combindata+"^"+GetElementValue("BuyUserDR") ;
  	combindata=combindata+"^"+GetElementValue("Status") ;
  	combindata=combindata+"^"+curUserID;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	var valList=GetTableInfo();
  	if (valList=="-1")  return;
  	var DelRowid=tableList.toString()
  	var encmeth=GetElementValue("Update")
  	if (encmeth=="") return;
  	//alertShow(valList)
	var Rtn=cspRunServerMethod(encmeth,combindata,valList,DelRowid);
	
	if (Rtn>0)
    {
		//添加操作成功是否提示
		alertShow("保存成功!");
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAInStock&RowID='+Rtn+"&WaitAD=off";
	}
    else
    {
	    alertShow(EQMsg(t["01"],Rtn));
    }
}
function BPrint_Clicked()
{
	var id=GetElementValue("RowID");
	if (""!=id)
	{
		PrintAInStore(id);
	}
	else
	{
		alertShow("无记录!");
	}
}

function BClear_Clicked()
{
	var QXType=GetElementValue("QXType");
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAInStock&QXType='+QXType+'&WaitAD=off';
}

function BDelete_Clicked()
{
	var truthBeTold = window.confirm(t["-4003"]);
	if (!truthBeTold) return;
	var combindata=GetValueList();
  	var encmeth=GetElementValue("DeleteData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata);
	if (Rtn=="0")
    {
	    var WaitAD=GetElementValue("WaitAD");
	    var QXType=GetElementValue("QXType");
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAInStock&QXType='+QXType+"&WaitAD="+WaitAD;
	}
    else
    {
	    alertShow(t[Rtn]+"   "+t["01"]);
    }
}

function BSubmit_Clicked()
{
	if (CheckNull()) return;
	var combindata=GetValueList();
  	var valList=GetTableInfo();
  	if (valList=="")
  	{
	  	alertShow(t["-1003"])
	  	return;
	}
	
	var objtbl=document.getElementById('tDHCEQAInStock');
	var rows=tableList.length
	for(var i=1;i<rows;i++)
	{
		if (tableList[i]=="0")
		{
			var TManagementFlag=GetElementValue("TManagementFlagDRz"+i);
			if(TManagementFlag=="1")
			{
				var SourceID=GetElementValue("TAInStockDRz"+i);
				var AccessoryDR=GetElementValue("TItemDRz"+i);
				var job=GetElementValue("Job");
				//alertShow(job)
				var MXRowID=GetElementValue("TRowIDz"+i);
				var encmeth=GetElementValue("GetSerialNoInfo")
				if (encmeth=="") return;
				var Ret=cspRunServerMethod(encmeth,MXRowID,SourceID,AccessoryDR,job);
				if (Ret=="")
				{
					var truthBeTold = window.confirm("第"+i+"行为序列号管理,是否需要输入序列号")	//Modify DJ 2014-09-11
					if (truthBeTold) return;
				}
			}
			else{
				var TBatchNo=GetElementValue("TBatchNoz"+i)
				/*	Modify DJ 2014-09-10
				if  (TBatchNo=="")
				{
					alertShow("批号管理,请补充第"+i+"行批号!")
					return;	
				}
				*/	
			}
		}
	}
	var rowid=GetElementValue("RowID");
  	var encmeth=GetElementValue("SubmitData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata);
	if (Rtn>0)
    {
	    var WaitAD=GetElementValue("WaitAD");
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAInStock&RowID='+Rtn+"&WaitAD="+WaitAD;
	}
    else
    {
	    alertShow(t[Rtn]+"   "+t["01"]);
    }
}
function BCancelSubmit_Clicked() // 反提交
{
	var combindata=GetValueList();
  	var encmeth=GetElementValue("CancelSubmitData")
  	if (encmeth=="") return;
  	var obj=document.getElementById("RejectReason"); 
  	var CancelReason=GetElementValue("RejectReason");
  	if ((obj)&&(CancelReason==""))
  	{
	  	alertShow("取消原因为空,不能进行取消.");
	  	return;
  	}
  	combindata=combindata+"^"+CancelReason;
	var Rtn=cspRunServerMethod(encmeth,combindata,GetElementValue("CurRole"));
    if (Rtn>0)
    {
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAInStock&RowID='+Rtn+"&QXType="+GetElementValue("QXType")+"&CurRole="+GetElementValue("CurRole");  //modified by kdf 2017-11-16 需求号：479842。
	}
    else
    {
	    alertShow(Rtn+"   "+t["01"]);
    }
}

function AddClickHandler() {
	try 
	{
		var objtbl=document.getElementById('tDHCEQAInStock');
		var ret=CanAddRow(objtbl);
		if (ret)
		{
			NewNameIndex=tableList.length;
	    	AddRowToList(objtbl,LastNameIndex,NewNameIndex);
	    	
	    	var TSerialNo=document.getElementById("TSerialNoz"+NewNameIndex); //序列号
			if (TSerialNo)	TSerialNo.onclick=SerialNoClickHandler;
			//设置默认的来源类型与上一行一致
			var PreSourceType=GetElementValue("TSourceTypez"+LastNameIndex);
			SetElement("TSourceTypez"+NewNameIndex,PreSourceType);
			var PreSourceType=GetElementValue("TModelz"+LastNameIndex);
			SetElement("TModelz"+NewNameIndex,"");  //add by mwz 20180222 需求号542166
			SetElement('TSerialFlagz'+NewNameIndex,"");		//Add By DJ 2016-12-05
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
	var TSourceType=document.getElementById('TSourceTypez'+LastNameIndex).value
	if  (GetElementValue('TSourceTypez'+LastNameIndex)=="")
	{
		SetFocusColumn("TSourceType",LastNameIndex);
		return false;
		
	}
	if  (GetElementValue('TSourceIDz'+LastNameIndex)=="")
	{
		// Mozy	2016-1-18	自动添加一行时不做过滤
		//SetFocusColumn("TDesc",LastNameIndex);
	 	//return false;
	}
	return true;
}

function GetTableInfo()
{
    var objtbl=document.getElementById('tDHCEQAInStock');
	var rows=tableList.length
	var valList="";
	var TJob=GetElementValue("Job");
	for(var i=1;i<rows;i++)
	{
		if (tableList[i]=="0")
		{
			var TRow=GetCElementValue("TRowz"+i);
			var TRowID=GetElementValue("TRowIDz"+i);
			var TDesc=GetElementValue("TDescz"+i);
			var TCode=GetElementValue("TCodez"+i);
			var TItemDR=GetElementValue("TItemDRz"+i);	
			var TBaseUOMDR=GetElementValue("TBaseUOMDRz"+i);	
			var TManuFactoryDR=GetManuFactoryRowID(GetElementValue("GetManuFactoryOperMethod"),i)			
			var TManuFactory=GetElementValue("TManuFactoryz"+i);
			var TModel=GetElementValue("TModelz"+i);
			var TPrice=GetElementValue("TPricez"+i);
			var TBaseUOMDR=GetElementValue("TBaseUOMDRz"+i);
			var TRemark=GetElementValue("TRemarkz"+i);
			var TSourceID=GetElementValue("TSourceIDz"+i);
			var TProDate=GetElementValue("TProDatez"+i);
			var TExpiryDate=GetElementValue("TExpiryDatez"+i);
			var TBatchNo=GetElementValue("TBatchNoz"+i);
			var TManagementFlag=GetElementValue("TManagementFlagDRz"+i);
			//需求序号:	418216		Mozy	20170731	无明细记录不能进行更新
			if (TSourceID=="")
			{
				alertShow("第"+TRow+"行,请选择正确的配件或配件项")
				SetFocusColumn("TDesc",i)
				return "-1"
			}
			var TInvoiceNos=GetElementValue("TInvoiceNosz"+i);
			if (TInvoiceNos=="") TInvoiceNos=GetElementValue("InvoiceNos");
			var TSourceType=GetElementValue("TSourceTypez"+i);
			///配置项
			if (TSourceType==1)
			{
				var TQuantityNum=GetElementValue("TQuantityNumz"+i);
			}
			else
			{
				var TQuantityNum="";				
			}			
			if ((TQuantityNum=="")||(TQuantityNum<=0))
			{
				alertShow("第"+TRow+"行数量不正确!");
				SetFocusColumn("TQuantityNum",i)
				return "-1";
			}
			/*/数量不能为小数	//201702-04	Mozy
			if (parseInt(TQuantityNum)!=TQuantityNum)
			{
				alertShow("第"+TRow+"行数量不正确,不能为小数!");
				SetFocusColumn("TQuantityNum",i)
				return "-1";
			}*/
			var THold1=GetElementValue("THold1z"+i);
			var THold2=GetElementValue("THold2z"+i);
			var THold3=GetElementValue("THold3z"+i);
			var THold4=GetElementValue("THold4z"+i);
			var THold5=GetElementValue("THold5z"+i);
			//var THold6=GetElementValue("THold6z"+i);
			//var THold7=GetElementValue("THold7z"+i);
			if(valList!="") {valList=valList+"&";}			
			valList=valList+TRow+"^"+TRowID+"^"+TDesc+"^"+TItemDR+"^"+TManuFactoryDR+"^"+TModel+"^"+TPrice+"^"+TBaseUOMDR+"^"+TRemark+"^"+TSourceID+"^"+TInvoiceNos+"^"+TSourceType+"^"+TProDate+"^"+TExpiryDate+"^"+TQuantityNum+"^"+TBatchNo+"^"+TManagementFlag+"^"+TCode;
			valList=valList+"^"+THold1+"^"+THold2+"^"+THold3+"^"+THold4+"^"+THold5	//+"^"+THold6+"^"+THold7;
		}
	}
	return  valList+"##"+TJob
}

function SetEnabled()
{
	var WaitAD=GetElementValue("WaitAD");
	var Status=GetElementValue("Status");
	//状态为新增时,方可提交或删除
	//状态小于1时方可增删改
	//alertShow(WaitAD+":"+Status)
	if (Status!="0")
	{
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		if (Status!="")
		{
			DisableBElement("BUpdate",true);
			DisableBElement("BAdd",true);
			DisableBElement("BClear",true);  ///modify by lmm 349147
		}
	}
	//更新后才可打印及生成转移单
	if (Status=="")
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
		//DisableBElement("BClear",true);
	}
}

function SetTableItem(RowNo,SourceType,selectrow)
{
	var objtbl=document.getElementById('tDHCEQAInStock');
	var rows=objtbl.rows.length-1;
	if (RowNo=="")
	{
		for (var i=1;i<=rows;i++)
		{
			var TSourceID=document.getElementById("TSourceIDz"+i).value;
			var TSourceType=GetElementValue("TSourceTypeDRz"+i);
			ObjSources[i]=new SourceInfo(TSourceType,TSourceID);
			tableList[i]=0;
			var TRowID=document.getElementById("TRowIDz"+i).value;
			var TotalFlag=GetElementValue("TotalFlag");
			if (TRowID==-1)
			{
				if ((TotalFlag==1)||(TotalFlag==2))
				{
					obj=document.getElementById("TRowz"+i);
					if (obj) obj.innerText="合计:"
					obj=document.getElementById("BDeleteListz"+i);
					if (obj) obj.innerText=""
					obj=document.getElementById("TSerialNoz"+i);
					if (obj) obj.innerText=""
					obj=document.getElementById("BMRequestz"+i);
					if (obj) obj.innerText="";
					tableList[i]=-1;
					document.getElementById("TQuantityNumz"+i).style.color="#ff8000";
					document.getElementById("TQuantityNumz"+i).style.fontWeight=900;
					document.getElementById("TTotalFeez"+i).style.color="#ff8000";
					document.getElementById("TTotalFeez"+i).style.fontWeight=900;
					continue;
				}
			}
			ChangeRowStyle(objtbl.rows[i],SourceType);		///改变一行的内容显示
			//document.getElementById("TQuantityNumz"+i).style.color="red";
	    	document.getElementById("TQuantityNumz"+i).style.color="#0000ff";
	   		document.getElementById("TQuantityNumz"+i).style.fontWeight=900;
			document.getElementById("TPricez"+i).style.color="#0000ff";
	   		document.getElementById("TPricez"+i).style.fontWeight=900;
			document.getElementById("TInvoiceNosz"+i).style.color="#ff8000";
	   		document.getElementById("TInvoiceNosz"+i).style.fontWeight=900;
			document.getElementById("TTotalFeez"+i).style.fontWeight=900;
		}
	}
	else
	{
		if (selectrow=='') selectrow=RowNo
		tableList[RowNo]=0;
		ChangeRowStyle(objtbl.rows[selectrow],SourceType);	///改变一行的内容显示
	}
}

///改变一行的内容显示
function ChangeRowStyle(RowObj,SourceType)
{
	var Status=GetElementValue("Status");
	
	CurRole=GetElementValue("CurRole")    //modified by kdf 2017-11-16 需求号：479842
	
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
	   
	   	if (colName=="TSourceType")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetElementValue("TSourceTypeDRz"+objindex);	
			html=CreatElementHtml(4,Id,objwidth,objheight,"KeyDown_Tab","SourceType_Change","1^配件项","") //1^配件项&2^验收单
		}
		else if (colName=="TManagementFlag")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetElementValue("TManagementFlagDRz"+objindex);	
			html=CreatElementHtml(4,Id,objwidth,objheight,"KeyDown_Tab","ManagementFlag_Change","0^批号管理&1^序列号管理","") //0^批号管理&1^序列号管理
		}
		else if (colName=="TInvoiceNos")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TBatchNo")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","SetDisable_TBatchNo","","")
		}
		else if (colName=="TRemark")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TModel")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")	
		}
		else if (colName=="TAInStockDR")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TManuFactory")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
			html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpManuFactoryNew","","","Standard_TableKeyUp")		
		}
		else if (colName=="TBaseUOM")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
			html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpBaseUOMNew","","","")		
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
		else if (colName=="TDesc")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpAccessoryNew","","","SourceIDKeyUp")
		}
		else if (colName=="TSerialFlag")
		{
			value=GetCElementValue(Id);
			html=CreatElementHtml(5,Id,objwidth,objheight,"","","","")	// 5 ClickCheckBox
			//RowObj.cells[j].firstChild.disabled=true;	
		}
		/*else if (colName=="TPrice")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
			if ((GetElementValue("TSourceTypez"+objindex)==2))
			{
         		html=CreatElementHtml(0,Id,objwidth,objheight,"","","","")
			}
			else
			{
         		html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","TotalFee_Change")	
			}
			var objTSourceType=document.getElementById(Id);
			if(objTSourceType)
			{
				objTSourceType.onkeypress=NumberPressHandler
			}
		}*/
		else if (colName=="TProDate")
		{
			if (CheckUnEditField(Status,colName)) continue;
			
			value=GetCElementValue(Id);
         	html=CreatElementHtml(3,Id,objwidth,objheight,"LookUpTableDate","TDate_changehandler","","","")
		}
		else if (colName=="TExpiryDate")
		{
			if (CheckUnEditField(Status,colName)) continue;
			
			value=GetCElementValue(Id);
         	html=CreatElementHtml(3,Id,objwidth,objheight,"LookUpTableDate","TDate_changehandler","","","")
		}
		else if (colName=="BDeleteList")
		{
			if ((Status>0)||(CurRole))   //modified by kdf 2017-11-16 需求号：479842。增加CurRole当前角色的判断
			{
				HiddenObj(colName+"z"+objindex,1)
				continue;
			}
			RowObj.cells[j].onclick=DeleteClickHandler;
		}
		else if (colName=="TSerialNo")
		{
			RowObj.cells[j].onclick=SerialNoClickHandler;
		}
		else if (colName=="THold1")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="THold2")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		/// 设置维修单链接可视性
		obj=document.getElementById("BMRequestz"+objindex);
		if ((obj)&&(GetElementValue("TMRRowIDz"+objindex)=="")) obj.innerText="";
		
		if (html!="") RowObj.cells[j].innerHTML=html;
	    if (value!="")
	    {
		    value=trim(value);
		    if (RowObj.cells[j].firstChild.tagName=="LABEL")
		    {
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
				    if (colName=="TSerialFlag")
					{
					    RowObj.cells[j].firstChild.disabled=true;
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

function TProDate_lookupSelect(dateval)
{
	var obj=document.getElementById('TProDatez'+selectRow);
	obj.value=dateval;
}

function TExpiryDate_lookupSelect(dateval)
{
	var obj=document.getElementById('TExpiryDatez'+selectRow);
	obj.value=dateval;
}
function SetDisable_TBatchNo() //modify BY:GBX 2014年8月11日10:18:58
{
	RowNo=GetTableCurRow();
	var TManagementFlag=GetElementValue("TManagementFlagDRz"+RowNo)
	if (TManagementFlag==1)
	{
		alertShow("序列号管理,不需要批号!")
		SetElement("TBatchNoz"+RowNo,"");
		return
	}
}

function ManagementFlag_Change()  //modify BY:GBX 2014年8月8日15:18:18  GBX0019
{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCEQAInStock'); //得到表格   t+组件名称
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	selectrow=rowObj.rowIndex;								//当前选择行
	RowNo=GetTableCurRow();
	var TManagementFlag=GetElementValue("TManagementFlagDRz"+RowNo)
	SetElement("TManagementFlagDRz"+RowNo,TManagementFlag);
	if (TManagementFlag==1)
	{
		SetElement("TBatchNoz"+RowNo,"");
	}
	selectrow=RowNo;
	SetFocusColumn("TManagementFlag",selectrow)
}
function SourceType_Change()
{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCEQAInStock'); //得到表格   t+组件名称
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	selectrow=rowObj.rowIndex;								//当前选择行
	RowNo=GetTableCurRow();
	var TSourceType=GetElementValue("TSourceTypez"+RowNo)
	SetElement("TSourceTypeDRz"+RowNo,TSourceType);
	if (TSourceType==1)
	{
		SetTableItem(RowNo,"1",selectrow);		///改变一行的内容显示
	}
	else if (TSourceType==2)
	{
		SetTableItem(RowNo,"2",selectrow);		///改变一行的内容显示
	}
	selectrow=RowNo;
	Clear();
	SetFocusColumn("TSourceType",selectrow)
}

function Clear()
{
	//SetElement('TAccessoryz'+selectrow,"");
	SetElement('TModelz'+selectrow,"");  //add by mwz 20180222 需求号542166
	SetElement('TManuFactoryz'+selectrow,"");
	SetElement('TManuFactoryDRz'+selectrow,"");
	SetElement('TBaseUOMz'+selectrow,"");
	SetElement('TBaseUOMDRz'+selectrow,"");
	SetElement('TQuantityNumz'+selectrow,"");
	SetElement('TPricez'+selectrow,"");
	SetElement('TProDatez'+selectrow,"");
	SetElement('TExpiryDatez'+selectrow,"");
	SetElement('TInvoiceNosz'+selectrow,"");
	SetElement('TRemarkz'+selectrow,"");
	//SetElement('TMaxInStickNumz'+selectrow,"");
	SetElement('TTotalFeez'+selectrow,"");	//Modify DJ 2014-09-09 begin
	SetElement('TUnitDRz'+selectrow,"");
	SetElement('TUnitz'+selectrow,"");
	SetElement('TItemDRz'+selectrow,"");
	SetElement('TSourceIDz'+selectrow,"");
	SetElement('TDescz'+selectrow,"");
	SetElement('TCodez'+selectrow,"");
	SetElement('TSerialFlagz'+selectrow,"");	//Modify DJ 2014-09-09 End
}

function DeleteClickHandler() 
{
	var truthBeTold = window.confirm(t["-4003"]);
	if (!truthBeTold) return;
	try
	{
		var objtbl=document.getElementById('tDHCEQAInStock');
		var rows=objtbl.rows.length;
		selectrow=GetTableCurRow();
		var TotalFlag=GetElementValue("TotalFlag")
		var TRowID=GetElementValue('TRowIDz'+selectrow);
		tableList[selectrow]=TRowID;
		
		var delNo=GetElementValue("TRowz"+selectrow);

		if (((TotalFlag==0)&&(rows<=2))||((rows<=3)&&((TotalFlag==1)||(TotalFlag==2))))
		{
			//修改删除仅剩的一行后?编辑保存数据异常?无法保存的问题
			tableList[selectrow]=0;
			if (TRowID!="")
			{
				SetElement('TRowIDz'+selectrow,"");				
				tableList[tableList.length]=TRowID;
			}
			Clear();
			//SetElement("Job","")			 
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

function LookUpManuFactoryNew(vClickEventFlag)
{	
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		if (CheckNull()) return;
		selectrow=GetTableCurRow();
		LookUp("","web.DHCEQCManufacturer:LookUp","GetManuFactory","TManuFactoryz"+selectrow);
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

function LookUpBaseUOMNew(vClickEventFlag)
{	
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		if (CheckNull()) return;
		selectrow=GetTableCurRow();
		LookUp("","web.DHCEQCUOM:GetUOM","GetBaseUOM","TBaseUOMz"+selectrow+",UnitType");
	}
}
function GetBaseUOM(value)
{
	var list=value.split("^")
	SetElement('TBaseUOMz'+selectrow,list[0]);
	SetElement('TBaseUOMDRz'+selectrow,list[1]);
	var obj=document.getElementById("TBaseUOMz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}


function LookUpAccessoryNew(vClickEventFlag)
{
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		if (CheckNull()) return;
		selectrow=GetTableCurRow();
		var ObjTSourceType=document.getElementById('TSourceTypez'+selectrow);
		if (ObjTSourceType)
		{
			var TSourceType=ObjTSourceType.value
			if (TSourceType==1)
			{
				//LookUpAccessory("GetAccessory",",TDescz"+selectrow+",,AccessoryTypeDR");
				LookUp("","web.DHCEQCAccessory:GetAccessoryNew","GetAccessoryNew","TDescz"+selectrow+",AccessoryTypeDR");	// Mozy	2016-10-21
			}
			else if (TSourceType==2)
			{
				//LookUpOpenCheck();
			}	
		}
	}
}
function LookUpAccessory(jsfunction,paras)
{
	LookUp("","web.DHCEQCAccessory:GetAccessory",jsfunction,paras);
}
function GetAccessory(value)
{
	Clear();
	AddClickHandler();
	var TotalFlag=GetElementValue("TotalFlag");
	//alertShow(value)
	var list=value.split("^");
	var Length=ObjSources.length;
	for (var i=1;i<Length;i++)
	{
		if ((tableList[i]=="0")&&(ObjSources[i].SourceType=="1")&&(ObjSources[i].SourceID==list[0])&&(selectrow!=i))
		{
			alertShow("选择的配件项与第"+GetCElementValue("TRowz"+i)+"行重复!")
			return;
		}
	}
	if (list[4]!="") SetElement('TModelz'+selectrow,list[4]);	// 规格非空才填充
	SetElement('TDescz'+selectrow,list[2]);
	SetElement('TCodez'+selectrow,list[1]);
	SetElement('TItemDRz'+selectrow,list[0]);
	SetElement('TSourceIDz'+selectrow,list[0]);
	SetElement('TPricez'+selectrow,list[8]);
	///增加单位和生产厂商的赋值  BY:GBX
	SetElement('TBaseUOMz'+selectrow,list[5]);
	SetElement('TBaseUOMDRz'+selectrow,list[6]);
	
	SetElement('TManuFactoryz'+selectrow,list[28]);
	SetElement('TManuFactoryDRz'+selectrow,list[29]);
	SetElement('THold1z'+selectrow,list[74]);
	SetElement('THold2z'+selectrow,list[75]);
	///管理方式赋值
	if ((list[37])== "Y" )
	{
		SetElement('TManagementFlagDRz'+selectrow,1);
		SetElement('TSerialFlagz'+selectrow,1);
		//alertShow(GetElementValue('TManagementFlagDRz'+selectrow))
	}
	else 
	{
		SetElement('TManagementFlagDRz'+selectrow,0);
		SetElement('TSerialFlagz'+selectrow,0);
		//alertShow(GetElementValue('TManagementFlagDRz'+selectrow))
	}
	ObjSources[selectrow]=new SourceInfo("1",list[0]);
	var obj=document.getElementById("TDescz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}
function GetAccessoryNew(value)
{
	///Clear();
	//AddClickHandler();
	var TotalFlag=GetElementValue("TotalFlag");
	// TRowID,TRow,TCode,TDesc,TShortDesc,TModel,TBaseUOM,TBaseUOMDR,TCurBPrice,TCat,TManuFactory,TManuFactoryDR,THold1,THold2,THold3,THold4,THold5
	var list=value.split("^");
	var Length=ObjSources.length;
	for (var i=1;i<Length;i++)
	{
		if ((tableList[i]=="0")&&(ObjSources[i].SourceType=="1")&&(ObjSources[i].SourceID==list[0])&&(selectrow!=i))
		{
			alertShow("选择的配件项与第"+GetCElementValue("TRowz"+i)+"行重复!")
			return;
		}
	}
	if ((list[5]!="")&&(list[5]!="/")) SetElement('TModelz'+selectrow,list[5]);
	SetElement('TDescz'+selectrow,list[3]);
	SetElement('TCodez'+selectrow,list[2]);
	SetElement('TItemDRz'+selectrow,list[0]);
	SetElement('TSourceIDz'+selectrow,list[0]);
	if (list[8]>0) SetElement('TPricez'+selectrow,list[8]);
	SetElement('TBaseUOMz'+selectrow,list[6]);
	SetElement('TBaseUOMDRz'+selectrow,list[7]);
	SetElement('TManuFactoryz'+selectrow,list[10]);
	SetElement('TManuFactoryDRz'+selectrow,list[11]);
	SetElement('THold1z'+selectrow,list[12]);
	SetElement('THold2z'+selectrow,list[13]);
	//需求: 282773	Mozy	20161111
	SetElement('TSerialFlagz'+selectrow,list[18]*1);		//Add By DJ 2016-12-05
	if (list[18]==0)
	{
		SetElement('TManagementFlagDRz'+selectrow,0);
	}
	else
	{
		SetElement('TManagementFlagDRz'+selectrow,1);
	}
	ObjSources[selectrow]=new SourceInfo("1",list[0]);
	var obj=document.getElementById("TDescz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}
function TotalFee_Change()
{
	selectrow=GetTableCurRow();
	var TPrice=GetElementValue("TPricez"+selectrow)
	var TQuantityNum=GetElementValue("TQuantityNumz"+selectrow)
	var TotalFee=TPrice*TQuantityNum
	if (TotalFee<=0)
	{
		SetElement('TTotalFeez'+selectrow,'');
	}
	else
	{
		SetElement('TTotalFeez'+selectrow,TotalFee.toFixed(2));
	}
	SumList_Change()
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
			var TPrice=parseFloat(GetElementValue("TPricez"+i))
			var TQuantityNum=parseFloat(GetElementValue("TQuantityNumz"+i))
			if ((isNaN(TPrice))||(isNaN(TQuantityNum))) continue;
			var TotalFee=TPrice*TQuantityNum
			Num=Num+TQuantityNum
			Fee=Fee+TotalFee
		}
		else if (tableList[i]==-1)
		{
			var index=i
		}
	}
	SetElement('TQuantityNumz'+index,Num.toFixed(2));	//201702-04	Mozy
	SetElement('TTotalFeez'+index,Fee.toFixed(2));
}
function SourceIDKeyUp()
{
	var eSrc=window.event.srcElement;
	if (!eSrc) return;
	var Id=eSrc.id
	var offset=Id.lastIndexOf("z");
	var index=Id.substring(offset+1);
	SetElement("TSourceIDz"+index,"");
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

function SerialNoClickHandler()
{
	selectrow=GetTableCurRow();
	var InStockListDR=GetElementValue("TAInStockDRz"+selectrow)
	var AccessoryDR=GetElementValue("TItemDRz"+selectrow)
	var ManagementFlag=GetElementValue("TManagementFlagDRz"+selectrow)
	if (ManagementFlag=="0")
	{
		alertShow("非序列号管理,不需输入序列号")
		return
	}
	if ((InStockListDR=="")||(AccessoryDR==""))
	{
		alertShow("请先更新入库单")
		return
	}
	var QuantityNum=GetElementValue("TQuantityNumz"+selectrow)
	if (QuantityNum=="") 
	{
		alertShow("数量为空")
	 	return
	}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQUpdateAccessorySerialNo";
	lnk=lnk+"&SourceID="+InStockListDR
	lnk=lnk+"&QuantityNum="+QuantityNum
	lnk=lnk+"&index="+selectrow
	lnk=lnk+"&MXRowID="+GetElementValue("TRowIDz"+selectrow)
	lnk=lnk+"&Status="+GetElementValue("Status")
	lnk=lnk+"&AccessoryDR="+AccessoryDR
	lnk=lnk+"&Job="+GetElementValue("Job")
	var Job=GetElementValue("Job")
   	window.open(lnk,'_blank','toolbar=no,location=no,directories=no,Status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=600,height=300,left=120,top=0')
}

function BApprove_Clicked()
{
	var combindata=GetValueList();
	var CurRole=GetElementValue("CurRole")
  	if (CurRole=="") return;
	var RoleStep=GetElementValue("RoleStep")
  	if (RoleStep=="") return;
  	
  	var objtbl=document.getElementById('tDHCEQAInStock');
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
	    alertShow(t[Rtn]);
    }
}

function PrintAInStore(AinStoreid)
{
	if (AinStoreid=="")
	{
		alertShow("无记录!");
		return;
	}
	var encmetha=GetElementValue("fillData");
	if (encmetha=="") return;
	var ReturnList=cspRunServerMethod(encmetha,AinStoreid);
	//alertShow(ReturnList);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var lista=ReturnList.split("^");
	var encmeth=GetElementValue("GetList");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,AinStoreid);
	//alertShow(gbldata);
	var list=gbldata.split(GetElementValue("SplitNumCode"));
	var Listall=list[0];
	rows=list[1];
	//rows=rows-1;
	var PageRows=8;
	var Pages=parseInt(rows / PageRows);
	var ModRows=rows%PageRows; //最后一页行数
	if (ModRows==0) {Pages=Pages-1;}
	
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	try {
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQAInStockSP.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var sort=37;
	    	xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"));
	    	xlsheet.cells(2,2)=xlsheet.cells(2,2)+GetShortName(lista[sort+3],"-"); //供货商
	    	xlsheet.cells(2,6)=ChangeDateFormat(lista[0]);	//入库日期
	    	xlsheet.cells(2,8)=xlsheet.cells(2,8)+lista[5]; //入库单号
	    	//xlsheet.cells(3,2)=xlsheet.cells(3,2)+lista[sort+0];
	    	//xlsheet.cells(3,6)=GetShortName(lista[sort+1],"-");//库房
	   		var OnePageRow=PageRows;
	   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	    	for (var j=1;j<=OnePageRow;j++)
			{
				var Lists=Listall.split(GetElementValue("SplitRowCode"));
				var Listl=Lists[i*PageRows+j];
				var List=Listl.split("^");
				var Row=3+j;
				if (List[0]=="合计") Row=11;
				xlsheet.cells(Row,2)=List[0];//配件名称
				xlsheet.cells(Row,4)=List[2];//型号
				xlsheet.cells(Row,5)=List[3];//单位
				xlsheet.cells(Row,6)=List[4];//数量
				xlsheet.cells(Row,7)=List[5];//原值
				xlsheet.cells(Row,8)=List[6];//金额
				xlsheet.cells(Row,9)=List[7];//发票号
				//xlsheet.cells(Row,9)=List[1];//生产厂商
	    	}
	    	xlsheet.cells(12,3)=xlsheet.cells(12,3)+lista[sort+5];	//采购员
	    	xlsheet.cells(12,9)="制单人:"+curUserName; //制单人		Mozy	2019-6-6	923457
	    	xlsheet.cells(13,9)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页";
			if (lista[25]!="") xlsheet.cells(13,2)="备注:"+lista[25];
			
	    	var obj = new ActiveXObject("PaperSet.GetPrintInfo");
		    var size=obj.GetPaperInfo("DHCEQInStock");
		    if (0!=size) xlsheet.PageSetup.PaperSize = size;
	    	xlsheet.printout; 	//打印输出
	    	//xlApp.Visible=true
    		//xlsheet.PrintPreview();
	    	//xlBook.SaveAs("D:\\InStock"+i+".xls");
	    	xlBook.Close (savechanges=false);
	    	
	    	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
	/// Mozy	2016-6-15
	var encmeth=GetElementValue("SaveOperateLog");
	if (encmeth=="") return;
	cspRunServerMethod(encmeth,"^A01^"+AinStoreid,1);
}
