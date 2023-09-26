//设备单位
var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{	    
    InitUserInfo();
	InitEvent();	
	//KeyUp("Uom");	//清空选择
	disabled(true);//灰化
	//Muilt_LookUp("Uom");
}
function InitEvent()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
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
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		alertShow("删除成功!")
		location.reload();
	}	
}
function BUpdate_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n");
	if(result<0) //modified by HHM 20150831 HHM0012
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
function BAdd_Click() //增加
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n")
	if(result<0) //modified by HHM 20150831 HHM0012
	{
		alertShow(t[-3001])
		return
		}
	if (result>0)
	{
		alertShow("操作成功!")
		location.reload();
	}	
}	
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("UomDR") ;//结果
  	combindata=combindata+"^"+GetElementValue("Uomtype") ; //类型
  	
  	//add By HHM 20150830 HHM0012
  	//DHC_EQCUOM表添加属性：UOM_Code,UOM_Desc,UOM_InvalidFlag,UOM_Remark
  	combindata=combindata+"^"+GetElementValue("Code") ; //代码
  	combindata=combindata+"^"+GetElementValue("Desc") ; //描述
  	combindata=combindata+"^"+GetElementValue("Remark") ; //备注
  	return combindata;
  	//************************************************************
}

///选择表格行触发此方法
function SelectRowHandler()
	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCUOM');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	{
		Clear();	
		disabled(true)//灰化	
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		SetElement("Desc","");      //需求号：396169 add by mwz 2017-06-27 start
		SetElement("Code","");
		SetElement("Remark","");
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);//调用函数
		disabled(false)//反灰化
		}
}
function Clear()
{
	SetElement("Uom","");
	SetElement("UomDR","")
	SetElement("Uomtype","");
	}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	var list=gbldata.split("^");
	SetElement("RowID",list[0]); //rowid
	SetElement("Uom",list[1]); //单位
	SetElement("Uomtype",list[2]);//类型
	SetElement("UomDR",list[3]); //单位代码
	
	//add By HHM 20150831 HHM0012
	SetElement("Code",list[4]); //代码
	SetElement("Desc",list[5]); //描述
	SetElement("Remark",list[6]); //备注
}

function UomDR(value) // 单位
{
	var obj=document.getElementById("UomDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
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
	/*
	if (CheckItemNull(1,"Uom")) return true;
	if (CheckItemNull(0,"Uomtype")) return true;
	*/
	return false;
}
document.body.onload = BodyLoadHandler;