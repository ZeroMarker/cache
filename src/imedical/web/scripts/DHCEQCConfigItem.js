//设备配置项目
var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{	
    InitUserInfo();
	InitEvent();	
	KeyUp("ConfigItemCat")	//清空选择
	Muilt_LookUp("ConfigItemCat");
	disabled(true)//灰化
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
	if (encmeth=="")  return;
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
	if (encmeth==""){return;}
	var plist=CombinData(); //函数调用
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist);
		result=result.replace(/\\n/g,"\n")
	if(result==""){alertShow(t[-3001]);}
	if (result>0)
	{
		alertShow("更新成功!")
		location.reload();
	}	
}
function BAdd_Click() //增加
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth==""){return;}
	var plist=CombinData(); //函数调用
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n")
	if(result==""){alertShow(t[-3001])}
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
	combindata=combindata+"^"+GetElementValue("Code") ;//代码
  	combindata=combindata+"^"+GetElementValue("Desc") ; //描述
  	combindata=combindata+"^"+GetElementValue("Remark") ; //备注
  	combindata=combindata+"^"+GetElementValue("ConfigItemCatDR") ; //配置类型分类型
  	combindata=combindata+"^"+GetElementValue("ValueUnit") ; //单位
  	/*
  	var obj=document.getElementById("InvalidFlag")
  	if (obj.checked){var MainFlag="Y"}
  		else( MainFlag="N")
  	combindata=combindata+"^"+MainFlag; //无效标志
  	  */	
  	return combindata;
}
///选择表格行触发此方法
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCConfigItem');//+组件名 就是你的组件显示 Query 结果的部分
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
	SetElement("Code",""); 
	SetElement("Desc","");
	SetElement("Remark","");
	SetElement("ConfigItemCat","");
	SetElement("ValueUnit","");
	}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth==""){return;}
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n");
	var list=gbldata.split("^");
	//alertShow("list"+list);
	SetElement("RowID",list[0]); //rowid
	SetElement("Code",list[1]); //rowid
	SetElement("Desc",list[2]); //单位
	SetElement("Remark",list[3]);//类型
	SetElement("ConfigItemCat",list[4]); //单位代码
	SetElement("ValueUnit",list[5]);
	SetElement("ConfigItemCatDR",list[6])
}
function condition()//条件
{
	if (CheckMustItemNull()) return true;
	//if (CheckItemNull(0,"Code")) return true;
	return false;
}
function ConfigItemCatDR(value) // 单位
{
	//alertShow(value);
	var obj=document.getElementById("ConfigItemCatDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//alertShow(val[1]+"/"+val[2]);
}
function disabled(value)//灰化
{
	InitEvent();
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
}	
document.body.onload = BodyLoadHandler;