//add by zx 20171107 ZX0047
//设备机组维护明细
//
var SelectedRow = 0;
var rowid=0;
var length=0; //用于排序，存在DHC_EQGroupList中的GL_Sort字段
function BodyLoadHandler() 
{
	InitPage();
	InitUserInfo();
	disabled(true);//灰化
}
function InitPage()
{
	var obj=document.getElementById("Badd");
	if (obj) obj.onclick=BUpdate_click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_click;
}

function BUpdate_click()
{
	if (!CheckData())
	{
		alertShow("收入分摊比例,支出占比必须大于零!");
		return;
	}
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist,"");
	var list=result.split("^");
	if (list[1]!="0")
	{
		alertShow(EQMsg("操作异常!",list[1]));
	}
	else
	{
		if (list[0]>0)
		{   
			alertShow("操作成功")
			window.location.reload();   //add by wy 2017-12-21
			
		}
		else
		{
			alertShow(t["01"])
		}
	}	
}
function BDelete_click()
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
		alertShow(t[-3002])
		return;
	}
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n")
	//alertShow(result)
	var list=result.split("^");
	if (list[1]!="0")
	{
		alertShow(EQMsg("操作异常!",list[1]));
	}
	else
	{
		if (list[0]>0)
		{
			alertShow("删除成功")      
			window.location.reload();       //add by wy 2017-12-21
		}
		else
		{
			alertShow(t["01"])
		}
	}	
}
///选择表格行触发此方法
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQGroupList');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	
	{
		Clear();
		disabled(true);//灰化	
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
	}
	else
	{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);//调用函数
		disabled(false);//反灰化
	}
}
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID");
	combindata=combindata+"^"+GetElementValue("GroupDR");
	combindata=combindata+"^"+GetElementValue("EquipDR");
  	combindata=combindata+"^"+GetChkElementValue("MainFlag");
  	combindata=combindata+"^"+GetElementValue("Sort");
  	combindata=combindata+"^"+GetElementValue("Remark");
  	combindata=combindata+"^"+GetElementValue("FromDate");
  	combindata=combindata+"^"+GetElementValue("ToDate");
  	combindata=combindata+"^"+GetElementValue("IncomeRate");
  	combindata=combindata+"^"+GetElementValue("ExpendRate");
  	combindata=combindata+"^"+GetElementValue("UpdateDate"); 
  	combindata=combindata+"^"+GetElementValue("UpdateTime");
  	combindata=combindata+"^"+GetElementValue("UpdateUserDR");
  	combindata=combindata+"^"+GetElementValue("InvalidFlag");
  	combindata=combindata+"^"+GetElementValue("Hold1"); 
  	combindata=combindata+"^"+GetElementValue("Hold2"); 
  	combindata=combindata+"^"+GetElementValue("Hold3"); 
  	combindata=combindata+"^"+GetElementValue("Hold4"); 
  	combindata=combindata+"^"+GetElementValue("Hold5");
  	return combindata;
}

function Clear()
{
	SetElement("RowID","")
	SetElement("EquipDR","");
	SetElement("EqName",""); 
	SetChkElement("MainFlag","");
	SetElement("Sort","");
	SetElement("Remark","");
	SetElement("FromDate","");
	SetElement("ToDate","");
	SetElement("IncomeRate","");
	SetElement("ExpendRate","");
	SetElement("UpdateDate","");
	SetElement("UpdateTime","");
	SetElement("UpdateUserDR","");
	SetElement("InvalidFlag","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	//alertShow("gbldata="+gbldata)
	var list=gbldata.split("^");
	SetElement("RowID",list[0]);
	SetElement("GroupDR",list[1]);
	SetElement("Name",list[2]);
	SetElement("EquipDR",list[3]); 
	SetElement("EqName",list[4]);
	SetChkElement("MainFlag",list[5]);
	SetElement("Sort",list[6]);
	SetElement("Remark",list[7]);
	SetElement("FromDate",list[8]);
	SetElement("ToDate",list[9]);
	SetElement("IncomeRate",list[10]);
	SetElement("ExpendRate",list[11]);
	SetElement("UpdateDate",list[12]);
	SetElement("UpdateTime",list[13]);
	SetElement("UpdateUserDR",list[14]);
	SetElement("InvalidFlag",list[15]);
	SetElement("Hold1",list[16]);
	SetElement("Hold2",list[17]);
	SetElement("Hold3",list[18]);
	SetElement("Hold4",list[19]);
	SetElement("Hold5",list[20]);
}
function disabled(value)//灰化
{
	InitPage();
	DisableBElement("BUpdate",value);
	DisableBElement("BDelete",value);	
	DisableBElement("BAdd",!value);
}	
function condition()//条件
{
	if (CheckMustItemNull()) return true;
	return false;
}
function CheckData()
{
	var IncomeRate=GetElementValue("IncomeRate");
	var ExpendRate=GetElementValue("ExpendRate");
	if((IncomeRate!="")&&(IncomeRate<=0)) return false;
	if((ExpendRate!="")&&(ExpendRate<=0)) return false;
	return true;
}
function GetEquip(value)
{
	var list=value.split("^")
	SetElement("EquipDR",list[1]);
	SetElement("EqName",list[0]);
}
document.body.onload = BodyLoadHandler;