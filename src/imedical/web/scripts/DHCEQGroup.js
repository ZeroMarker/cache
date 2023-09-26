//add by zx 20171107 ZX0047
//增加机组维护
//
var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{	
    InitUserInfo(); //系统参数
	InitEvent();	
	disabled(true);//灰化
}
function InitEvent()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
}

function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID");
	combindata=combindata+"^"+GetElementValue("Code");
	combindata=combindata+"^"+GetElementValue("Name");
  	combindata=combindata+"^"+GetElementValue("Desc");
  	combindata=combindata+"^"+GetElementValue("Remark");
  	combindata=combindata+"^"+GetElementValue("UpdateUserDR"); 
  	combindata=combindata+"^"+GetElementValue("UpdateDate");
  	combindata=combindata+"^"+GetElementValue("UpdateTime");
  	combindata=combindata+"^"+GetElementValue("FromDate");
  	combindata=combindata+"^"+GetElementValue("ToDate");
  	combindata=combindata+"^"+GetElementValue("InvalidFlag"); 
  	combindata=combindata+"^"+GetElementValue("Hold1"); 
  	combindata=combindata+"^"+GetElementValue("Hold2"); 
  	combindata=combindata+"^"+GetElementValue("Hold3"); 
  	return combindata;
}

function BUpdate_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	//alertShow("combindata="+plist)
	var result=cspRunServerMethod(encmeth,plist,"");
	//alertShow("result="+result)
	var list=result.split("^");
	//alertShow(list)
	if (list[1]!="0")
	{
		alertShow(EQMsg("操作异常!",list[1]));
	}
	else
	{
		if (list[0]>0)
		{   
		    alertShow("操作成功") //add by wy 2018-1-16
			location.reload();
		}
		else
		{
			alertShow(t["01"])
		}
	}
}
function BDelete_Click() 
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
	//alertShow(list)
	if (list[1]!="0")
	{
		alertShow(EQMsg("操作异常!",list[1]));
	}
	else
	{
		if (list[0]>0)
		{
			alertShow("操作成功")
			location.reload();
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
	var objtbl=document.getElementById('tDHCEQGroup');
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
function Clear()
{
	SetElement("RowID","")
	SetElement("Code",""); 
	SetElement("Name","");
	SetElement("Desc","");
	SetElement("Remark","");
	SetElement("UpdateUserDR","");
	SetElement("UpdateDate","");
	SetElement("UpdateTime","");
	SetElement("FromDate","");
	SetElement("ToDate","");
	SetElement("InvalidFlag","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	//alertShow(gbldata)
	var list=gbldata.split("^");
	SetElement("RowID",list[0])
	SetElement("Code",list[1]); 
	SetElement("Name",list[2]);
	SetElement("Desc",list[3]);
	SetElement("Remark",list[4]);
	SetElement("UpdateUserDR",list[5]);
	SetElement("UpdateDate",list[6]);
	SetElement("UpdateTime",list[7]);
	SetElement("FromDate",list[8]);
	SetElement("ToDate",list[9]);
	SetElement("InvalidFlag",list[10]);
	SetElement("Hold1",list[11]);
	SetElement("Hold2",list[12]);
	SetElement("Hold3",list[13]);
		
}
function disabled(value)//灰化
{
	InitEvent();
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
}	
function condition()//条件
{
	if (CheckMustItemNull()) return true;
	return false;
}

document.body.onload = BodyLoadHandler;
