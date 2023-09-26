var SelectedRow = 0;
var rowid=0;

function BodyLoadHandler() 
{	
	InitUserInfo();
	InitStandardKeyUp();
	if (1==GetElementValue("ReadOnly"))
	{
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BDisuse",true);
	}
	InitButton(false);
	KeyUp("Affix^ManuFactory^Provider^Currency","N");
	Muilt_LookUp("Affix^ManuFactory^Provider^Currency^PartSpec");
	SetTableEvent(); // 262309 Add by BRB 2016-10-12  事件入口
}

function InitButton(isselected)
{
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Click;
	
	if (1==GetElementValue("ReadOnly"))	return;
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;	
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;	
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;		
	var obj=document.getElementById("BDisuse");
	if (obj) obj.onclick=BDisuse_Click;	
	if (GetElementValue("DisuseFlag")=="Y")
	{
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BDisuse",true);
	}
	else
	{
		DisableBElement("BAdd",isselected);
		DisableBElement("BUpdate",!isselected);
		DisableBElement("BDelete",!isselected);
		DisableBElement("BDisuse",!isselected);
	}
}

function Selected(selectrow)
{
	if (SelectedRow==selectrow)
	{
		Clear();
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		InitButton(false);
	}
	else
	{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		if (rowid=="") return;
		SetElement("RowID",rowid);
		SetData(rowid);
		InitButton(true);
	}
}

function BAdd_Click() 
{
	var newrowid=0;
	
	if (CheckMustItemNull()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var plist=CombinData();
	var result=cspRunServerMethod(encmeth,'','',plist,GetElementValue("CheckListDR"),'0');
	newrowid=result;
	if (newrowid>0)
	{
		var encmeth=GetElementValue("GetChangeAccountFlag");
		var flag=cspRunServerMethod(encmeth,newrowid);
		if (flag==0)
		{
			location.reload();
			return;
		}
		if (flag==1)
		{
			var truthBeTold = window.confirm("要调整设备原值吗?");
    		if (!truthBeTold)
    		{
				location.reload();
				return;
			}
		}
		var encmeth=GetElementValue("GetChangeAccount");
		var result=cspRunServerMethod(encmeth,newrowid);
		//alertShow(result);
		if (result=="") 
		{
			location.reload();
			return;
		}
		if (result>0)
		{
			var equipdr=GetElementValue("EquipDR");
			var str="dhceqchangeaccount.csp?RowID="+equipdr;
    		window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=680,left=120,top=0')
			location.reload();
		}
		else
		{
			location.reload();
		}
	}
}

function BUpdate_Click() 
{
	SaveData();
}

function BDisuse_Click()
{
	rowid=GetElementValue("RowID");
	if (rowid=="")	{
		alertShow(t['-3004']);
		return;
	}
	var truthBeTold = window.confirm(t['-3003']);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetDisuse");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var result=cspRunServerMethod(encmeth,'','',rowid,GetElementValue("Remark"));
	if (result==0)
	{	location.reload();	}
	else
	{	alertShow(t[result]);
	}
}

function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	if (rowid=="")	{
		alertShow(t['-3002']);
		return;
	}
	var truthBeTold = window.confirm(t['-3001']);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var result=cspRunServerMethod(encmeth,'','',rowid+"^"+GetElementValue("EquipDR"),GetElementValue("CheckListDR"),'1');
	if (result>0)
	{	location.reload();	}
}

function BClose_Click() 
{
	//window.close();
	CloseWindow();
}

function GetAffixID(value)
{
	GetLookUpID('AffixDR',value);
}

function CombinData()
{
	var GetManuFactoryOperMethod=GetElementValue("GetManuFactoryOperMethod");
	var GetProviderOperMethod=GetElementValue("GetProviderOperMethod");
	var RProvDR=GetProviderRowID(GetProviderOperMethod);
    if ((RProvDR<=0)&&(GetElementValue("Provider")!=""))
    {
	    alertShow("供应商登记错误!");
	    return -1;
    }
    var RManuDR=GetManuFactoryRowID(GetManuFactoryOperMethod);
    if ((RManuDR<=0)&&(GetElementValue("ManuFactory")!=""))
    {
	    alertShow("生产厂家登记错误!");
	    return -1;
    }
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("EquipDR") ;
  	combindata=combindata+"^"+GetElementValue("AffixDR") ;
  	combindata=combindata+"^"+GetElementValue("AffixCatDR") ;
  	combindata=combindata+"^"+GetElementValue("PartSpec") ;
  	combindata=combindata+"^"+GetElementValue("PartModel") ;
  	//combindata=combindata+"^"+GetElementValue("ManuFactoryDR") ;
  	combindata=combindata+"^"+RManuDR;
  	combindata=combindata+"^"+GetElementValue("QuantityNum") ;
  	combindata=combindata+"^"+GetElementValue("ReceiverDR") ;
  	combindata=combindata+"^"+GetElementValue("LeaveFacNo") ;
  	combindata=combindata+"^"+GetElementValue("LeaveDate") ;
  	combindata=combindata+"^"+GetElementValue("PriceFee") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetElementValue("CurrencyDR") ;
	//combindata=combindata+"^"+GetElementValue("ProviderDR") ;
	combindata=combindata+"^"+RProvDR;
	combindata=combindata+"^"+GetElementValue("Hold1");
	combindata=combindata+"^"+GetElementValue("Hold2");
	combindata=combindata+"^"+GetChkElementValue("Hold3");
	combindata=combindata+"^"+GetElementValue("LeaveFacNoInfo");
  	return combindata;
}

function SaveData()
{
	if (CheckMustItemNull()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var plist=CombinData();
	var result=cspRunServerMethod(encmeth,'','',plist,GetElementValue("CheckListDR"),'0');
	newrowid=result;
	if (result>0)
		{	
			//add by HHM 20150910 HHM0013
			//添加操作成功是否提示
			ShowMessage();
			location.reload();
		}
	else
	{
		alertShow(t[-2201]+"  SQLCODE="+result);
	}
}

function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	var list=gbldata.split("^");
	var sort=29;
	//SetElement("EquipDR",list[0]);
	SetElement("Equip",list[sort+0]);
	SetElement("AffixDR",list[1]);
	SetElement("Affix",list[sort+1]);
	SetElement("AffixCatDR",list[2]);
	SetElement("AffixCat",list[sort+2]);
	SetElement("PartSpec",list[3]);
	SetElement("PartModel",list[4]);
	SetElement("ManuFactoryDR",list[5]);
	SetElement("ManuFactory",list[sort+3]);
	SetElement("QuantityNum",list[6]);
	SetElement("ReceiverDR",list[7]);
	SetElement("Receiver",list[sort+4]);
	SetElement("LeaveFacNo",list[8]);
	SetElement("LeaveDate",list[9]);
	SetElement("PriceFee",list[10]);
	SetElement("Remark",list[11]);
	SetElement("CurrencyDR",list[12]);
	SetElement("Currency",list[sort+5]);
	SetElement("DisuseFlag",list[13]);
	SetElement("ProviderDR",list[sort+6]);
	SetElement("Provider",list[sort+7]);
	SetElement("Hold1",list[24]);
	SetElement("Hold2",list[25]);
	SetChkElement("Hold3",list[26]);
	SetElement("LeaveFacNoInfo",list[sort+8]);
}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQAffix');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	Selected(selectrow);
}

function InitStandardKeyUp()
{
	var obj=document.getElementById("Equip");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("Affix");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("AffixCat");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("ManuFactory");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("Receiver");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("Currency");
	if (obj) obj.onkeyup=Standard_KeyUp;
}
function Clear()
{
	SetElement("RowID","");
	//SetElement("Equip","");
	//SetElement("EquipDR","");
	SetElement("Affix","");
	SetElement("AffixDR","");
	SetElement("AffixCat","");
	SetElement("AffixCatDR","");
	SetElement("PartSpec","");
	SetElement("PartModel","");
	SetElement("ManuFactory","");
	SetElement("ManuFactoryDR","");
	SetElement("QuantityNum","");
	SetElement("Receiver","");
	SetElement("ReceiverDR","");
	SetElement("LeaveFacNo","");
	SetElement("LeaveDate","");
	SetElement("PriceFee","");
	SetElement("Remark","");
	SetElement("Currency","");
	SetElement("CurrencyDR","");
	SetElement("DisuseFlag","");
	SetElement("ProviderDR","");
	SetElement("Provider","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetChkElement("Hold3","");
	SetElement("LeaveFacNoInfo","");
}

function GetCurrencyID(value)
{
	GetLookUpID('CurrencyDR',value);
}
function GetPartSpec(value)
{
	var val=value.split("^");	
	SetElement("PartSpec",val[1]);
	SetElement("PartModel",val[3]);
	SetElement("CurrencyDR",val[4]);
	SetElement("Currency",val[5]);
}
function SetTableEvent()//262309 Add by  BRB 2016-10-12 增加移除设备附件资金来源合计图标事件
{
	var objtbl=document.getElementById("tDHCEQAffix");
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	RowCount=lastrowindex;
	for (var i=1;i<=RowCount;i++)
	{
		var TRowID=GetElementValue("TRowIDz"+i)
		if (TRowID=="")
		{
			document.getElementById("TFundsz"+i).removeNode(true)
			document.getElementById("THold3z"+i).removeNode(true)			
		}
	}
}
document.body.onload = BodyLoadHandler;
