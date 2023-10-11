//设备单位
var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{
	//modified by cjt 20230212 需求号3221885 UI页面改造
	initPanelHeaderStyle();
	initButtonColor();
	InitUserInfo();
	InitEvent();	
	//KeyUp("Uom");	//清空选择
	disabled(true);//灰化
	SetComboboxRequired(); //hisui改造 add by MWZ 2018-08-28
	initButtonWidth(); //hisui改造 add by MWZ 2018-08-28
	setButtonText();	//HISUI改造 add by MWZ 2018-09-28
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
	var obj=document.getElementById("BFind"); // add by sjh SJH0042 2020-12-16 增加查询
	if (obj) obj.onclick=BFind_Click; 
}

// add by sjh SJH0042 2020-12-16 增加查询
function BFind_Click()
{
	if (!$(this).linkbutton('options').disabled){
		$('#tDHCEQCUOM').datagrid('load',{ComponentID:getValueById("GetComponentID"),Uomtype:getValueById("Uomtype"),Desc:getValueById("Desc"),Code:getValueById("Code"),Remark:getValueById("Remark")});
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
	messageShow("","","",t[-3001])
	return;
	}
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		alertShow("删除成功!")
		$('#tDHCEQCUOM').datagrid('reload'); 
		Clear();
		disabled(true);
	}	
}
//medified by myl 2260706  20211109
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
		messageShow("","","",t[-3001]);
		return
	}
	if (result>0)
	{
		$('#tDHCEQCUOM').datagrid('reload'); 
        $.messager.popover({msg:"保存成功",type:'success'});
		Clear();
		disabled(true)//反灰化
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
		messageShow("","","",t[-3001])
		return
		}
	if (result>0)
	{
		alertShow("操作成功!")
		$('#tDHCEQCUOM').datagrid('reload'); 
		Clear();
		disabled(true);
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

///modify by lmm 2018-08-17
///描述：hisui改造 更改值获取方式 并添加入参
///入参：index 行号
///      rowdata 行json数据
function SelectRowHandler(index,rowdata)
	{
		
	if (SelectedRow==index)	{
		Clear();
		disabled(true)//灰化		
		SelectedRow=-1;
		rowid=0;
		SetElement("RowID","");
		
		$('#tDHCEQCUOM').datagrid('unselectAll');  //add by kdf 
		
		}
	else{
		SelectedRow=index;
		rowid=rowdata.TRowID   //add by kdf
		SetData(rowid);//调用函数
		disabled(false)//反灰化
		}
}
function Clear()
{
	SetElement("Uom","");
	SetElement("UomDR","")
	SetElement("Uomtype","");
	SetElement("Desc","");
	SetElement("Code","");
	SetElement("Remark","");
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
