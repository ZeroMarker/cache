//***********************************
//add by HHM 20150922 HHM0021
//增加类组禁止访问类型
//
//*************************************
var onAfterRender = $.fn.datagrid.defaults.view.onAfterRender; //add by jyp 2018-09-06 Hisui改造：datagrid无法取单元格的值
var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{
	initButtonWidth()  ///add by jyp 2018-08-16 Hisui改造：添加initButtonWidth()方法控制按钮长度
    InitUserInfo(); //系统参数
	InitEvent();
	disabled(true);//灰化
}
function InitEvent()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
}
///modify by jyp 2018-09-06 Hisui改造：datagrid无法取单元格的值
function CombinData(item,num)
{
	//begin add by jyp 2018-09-06 Hisui改造：datagrid无法取单元格的值
	var ObjTJob=$('#tDHCEQETNotAccessSC').datagrid('getData');
	var RowID=""      //add hly 20190801
	if (ObjTJob.rows[num]["TRowID"])  RowID=ObjTJob.rows[num]["TRowID"];
	if (ObjTJob.rows[num]["TStatCatDR"])  TStatCatDR=ObjTJob.rows[num]["TStatCatDR"]
	
	//var RowID=GetElementValue('TRowIDz'+num);
	var EquipTypeDR=GetElementValue("EquipTypeDR");
	//var TStatCatDR=GetElementValue('TStatCatDRz'+num);
	//end add by jyp 2018-09-06 Hisui改造：datagrid无法取单元格的值
	//var TNotAccessFlag=GetChkElementValue('TNotAccessFlagz'+i);
	var TNotAccessFlag=item;
     		
    combindata="";
    combindata=RowID;
    combindata=combindata+"^"+EquipTypeDR;
    combindata=combindata+"^"+TStatCatDR
    combindata=combindata+"^";//DHC_EQETNotAccessSC中备注没存数据
    combindata=combindata+"^"+TNotAccessFlag;
    var encmeth=GetElementValue("GetUpDate");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,combindata,2);	
  	return gbldata;
}
//
///modify by jyp 2018-09-06 Hisui改造：datagrid无法取单元格的值
function BUpdate_Click() 
{
	var eSrc=window.event.srcElement;
	//var Objtbl=document.getElementById('tDHCEQETNotAccessSC');
	///modify by jyp 2018-09-06 Hisui改造：datagrid无法取单元格的值
	var Objtbl=$('#tDHCEQETNotAccessSC').datagrid('getRows')
	var Rows=Objtbl.length;
	for (var i=0;i<Rows;i++)
	{
		//var selobj=document.getElementById('TNotAccessFlagz'+i);
		var selobj=getColumnValue(i,"TNotAccessFlag")
		if (selobj)
		{
			//var TNotAccessFlag=GetChkElementValue('TNotAccessFlagz'+i);
			var result=CombinData(selobj,i);
		}
		else
		{
			//var TNotAccessFlag=GetChkElementValue('TNotAccessFlagz'+i);
			var result=CombinData(selobj,i);	
		}
	}
	///modify by jyp 2018-09-06 Hisui改造：datagrid无法取单元格的值
	if(result<0)
	{
		alertShow("操作失败！");
	}
	else
	{
		location.reload();
	}
}

///选择表格行触发此方法
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQETNotAccessSC');
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

}
function SetData(rowid)
{
	
}
function disabled(value)//灰化
{
	InitEvent();
	//DisableBElement("BUpdate",value)
	//DisableBElement("BDelete",value)	
	//DisableBElement("BAdd",!value)
}	
function condition()//条件
{
	if (CheckMustItemNull()) return true;
	return false;
}
function GetEquipType(value)
{
	var val=value.split("^");
	SetElement("EquipType",val[0]);
	SetElement("EquipTypeDR",val[1]);
}
document.body.onload = BodyLoadHandler;
