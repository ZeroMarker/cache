//设备机型
var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{
	//document.body.scroll="no";
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
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
}
function BClear_Click() 
{
	Clear();
	disabled(true);
}
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;
	combindata=combindata+"^"+GetElementValue("Code") ;
  	combindata=combindata+"^"+GetElementValue("Desc") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetChkElementValue("InvalidFlag") ;
  	combindata=combindata+"^"+GetElementValue("EQType") ;
  	combindata=combindata+"^"+GetChkElementValue("EQFlag") ;
  	combindata=combindata+"^"+GetElementValue("MinPrice") ;
  	combindata=combindata+"^"+GetElementValue("MaxPrice") ;
  	combindata=combindata+"^"+GetElementValue("Hold1") ;
	//add by zy zy0114 2014-07-31
  	if (GetElementValue("Hold2Desc")=="")
  	{
		SetElement("Hold2","");
	}
  	combindata=combindata+"^"+GetElementValue("Hold2") ;
  	combindata=combindata+"^"+GetElementValue("Hold3") ;
  	combindata=combindata+"^"+GetElementValue("Hold4") ;
  	combindata=combindata+"^"+GetElementValue("Hold5") ;
  	return combindata;
}
function BUpdate_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist,"");
	if(result=="") 
	{
		alertShow(t[-3001]);
		return
	}
	if (result>0)
	{
		alertShow("操作成功!")
		location.reload();
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
		alertShow(t[-3001])
		return;
	}
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		alertShow("删除成功!")
		location.reload();
	}	
}
///选择表格行触发此方法
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCStatCat');
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
	SetElement("Desc","");
	SetElement("Remark","");
	SetElement("InvalidFlag","");
	SetElement("EQType","");
	SetElement("EQFlag","");
	SetElement("MinPrice","");
	SetElement("MaxPrice","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
	//add by zy zy0114 2014-07-31
	SetElement("Hold2Desc","");
	SetElement("Hold4Desc","");
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	var list=gbldata.split("^");
	SetElement("RowID",list[0])
	SetElement("Code",list[1]); 
	SetElement("Desc",list[2]);
	SetElement("Remark",list[3]);
	SetElement("InvalidFlag",list[4]);
	SetElement("EQType",list[5]);
	SetElement("EQFlag",list[6]);
	SetElement("MinPrice",list[7]);
	SetElement("MaxPrice",list[8]);
	SetElement("Hold1",list[9]);
	SetElement("Hold2",list[10]);
	SetElement("Hold3",list[11]);
	SetElement("Hold4",list[12]);
	SetElement("Hold5",list[13]);
	//add by zy zy0114 2014-07-31
	SetElement("Hold2Desc",list[14]);
	SetElement("Hold4Desc",list[15]);
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
//add by zy zy0114 2014-07-31
function GetWJWTypeID(value)
{
	var val=value.split("^");
	SetElement("Hold2",val[1]);
	SetElement("Hold2Desc",val[0]);
}
//add by HHM 20150917 HHM0021
function GetFinanceType(value)
{
	var obj=document.getElementById("Hold4");
	var val=value.split("^");	
	if (obj) obj.value=val[0];
	var obj=document.getElementById("Hold4Desc");
	var val=value.split("^");	
	if (obj) obj.value=val[2];
}
document.body.onload = BodyLoadHandler;
