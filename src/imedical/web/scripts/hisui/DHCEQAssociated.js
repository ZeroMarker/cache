/// Add by Mozy 2009-08-20
var SelectedRow = -1;  //hisui改造 modified by kdf 2018-12-14
var rowid = 0;
function BodyLoadHandler() 
{
	
	InitUserInfo();
	InitPage();	
	FillData();
	SetDisable(true);
	initButtonWidth();  //hisui改造 add by kdf 2018-12-14 初始化界面按钮

}
///初始化页面
function InitPage()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BUpdate_Click;	
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;		
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Click;
}
///填充数据
function FillData()
{
	var rowid=GetElementValue("ParEquipDR");
	if(rowid==0){DisableElement("ChildEquip",true)} //add by kdf 2018-12-24 需求号：783424
	if ((rowid=="")||(rowid<1)) return;
	var encmeth=GetElementValue("GetEquipData");
	var result=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=result.replace(/\\n/g,"\n");
	var list=gbldata.split("^");
	SetElement("ParEquip",list[0]);
	SetElement("ParEquipNo",list[70]);
}

function BUpdate_Click() 
{
	var encmeth=GetElementValue("GetUpdate");
	if (CheckSaveData()) return;
	var plist=CombinData();
	var result=cspRunServerMethod(encmeth,plist);
	if (result>0)
	{
		SetElement("RowID",result);
		parent.frames["DHCEQAssociatedTree"].ReloadNode(GetElementValue("ParEquipDR"));
		window.location.reload();
	}
	else
	{
		alertShow(result+"   "+t[result]);
	}	
}
function BDelete_Click()
{
	if (GetElementValue("RowID")=="")
	{
		alertShow(t['04']);
		return;
	}
	var encmeth=GetElementValue("GetUpdate");
	var result=cspRunServerMethod(encmeth,GetElementValue("RowID"));
	//alertShow(GetElementValue("RowID")+"     "+result);
	if (result>=0)
	{
		Clear();
		parent.frames["DHCEQAssociatedTree"].ReloadNode(result);
		window.location.reload();
		SetDisable(true);
	}
	else
	{
		alertShow(t[result]);
	}
}

function BClose_Click() 
{
	window.close();
}

function CombinData()
{
	var combindata="";
	combindata=GetElementValue("RowID");
	if(GetElementValue("RowID")=="") SetElement("FromDate",GetCurrentDate());
  	combindata=combindata+"^"+GetElementValue("ParEquipDR");
  	combindata=combindata+"^"+GetElementValue("ChildEquipDR");
  	combindata=combindata+"^"+GetElementValue("Remark");
  	combindata=combindata+"^"+GetChkElementValue("InvalidFlag");
  	//if(GetChkElementValue("InvalidFlag")==true)	SetElement("ToDate",GetCurrentDate());
  	combindata=combindata+"^"+GetElementValue("FromDate");
	combindata=combindata+"^"+GetElementValue("ToDate");
	combindata=combindata+"^"+GetElementValue("Hold1");
  	combindata=combindata+"^"+GetElementValue("Hold2");
  	combindata=combindata+"^"+GetElementValue("Hold3");
  	combindata=combindata+"^"+GetElementValue("Hold4");
  	combindata=combindata+"^"+GetElementValue("Hold5");
  	combindata=combindata+"^"+curUserID;
  	
 	return combindata;
}
//modified by csj 2020-03-13 需求号：1227460
function SetDisable(value)
{
	var ReadOnly=getElementValue("ReadOnly");
	InitPage();
	DisableBElement("BAdd",!value||ReadOnly==1);
	DisableBElement("BUpdate",value||ReadOnly==1);
	DisableBElement("BDelete",value||ReadOnly==1);
}

///选择表格行触发此方法
///modify by kdf 2018-12-14
///描述：hisui改造 更改值获取方式 并添加入参
///入参：index 行号
///      rowdata 行json数据
function SelectRowHandler(index,rowdata)
{
	if (SelectedRow==index)
	{
		Clear();
		SetDisable(true);
		SelectedRow=-1;
		rowid=0;
		$('#tDHCEQAssociated').datagrid('unselectAll'); 
	}
	else
	{
		SelectedRow=index;
		ChildEquipDR=rowdata.TChildEquipDR;
		rowid=rowdata.TRowID;  
		SetElement("RowID",rowid);
		SetData(ChildEquipDR,rowid);					//调用函数
		SetDisable(false);								//反灰化
	}
}
function Clear()
{
	SetElement("RowID","");
	SetElement("ChildEquipDR","");
	SetElement("ChildEquip","");
	SetElement("ChildEquipNo","");
	SetElement("Remark","");
	SetChkElement("InvalidFlag",0);
	SetElement("FromDate","");
	SetElement("ToDate","");
	
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
}
function SetData(EquipRowID,rowid)
{
	var encmeth=GetElementValue("GetEquipData");
	var result=cspRunServerMethod(encmeth,'','',EquipRowID);
	var gbldata=result.replace(/\\n/g,"\n");
	var list=gbldata.split("^");
	SetElement("ChildEquipDR",EquipRowID);
	SetElement("ChildEquip",list[0]);
	SetElement("ChildEquipNo",list[70]);
	
	encmeth=GetElementValue("GetAssociatedData");
	if (encmeth=="") return;
	result=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=result.replace(/\\n/g,"\n");
	var lista=gbldata.split("^");
	//alertShow("gbldata="+gbldata)
	SetElement("Remark",lista[2]);
	SetChkElement("InvalidFlag",lista[12]);
	SetElement("FromDate",lista[13]);
	SetElement("ToDate",lista[14]);
	
	SetElement("Hold1",lista[15])
	SetElement("Hold2",lista[16])
	SetElement("Hold3",lista[17])
	SetElement("Hold4",lista[18])
	SetElement("Hold5",lista[19])
}
function GetChildEquip(value)
{
	var ReturnList=value.split("^")
	SetElement("ChildEquip",ReturnList[0]);
	SetElement("ChildEquipDR",ReturnList[1]);
	SetElement("ChildEquipNo",ReturnList[3]);
}

function CheckSaveData()
{
	if (CheckMustItemNull()) return true;
	//if (CheckItemNull(0,"Code")) return false;

	return false;
}

document.body.onload = BodyLoadHandler;
