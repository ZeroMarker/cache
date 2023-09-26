//add by zx 20171107 ZX0047
//增加机组维护
//
var SelectedRow = -1; ///Modify By QW 2018-10-11 HISUI改造
var rowid=0;
function BodyLoadHandler() 
{		
	initButtonWidth();///Add By QW 2018-10-11  HISUI改造:修改按钮长度
	setButtonText();///Add By QW 2018-10-11  HISUI改造:按钮文字规范
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
	//messageShow("","","",list)
	if (list[1]!="0")
	{
		messageShow("","","",EQMsg("操作异常!",list[1]));
	}
	else
	{
		if (list[0]>0)
		{   
			//modify hly 2019-11-26 bug:1100992
		    messageShow("","","",t[0]) 
			location.replace(location);
		}
		else
		{
			messageShow("","","",t["01"])
		}
	}
}
function BDelete_Click() 
{
	///modified by ZY0215 2020-04-02
	messageShow("confirm","","",t[-4003],"",confirmFun,"")
}
///modified by ZY0215 2020-04-02
function confirmFun()
{
	rowid=GetElementValue("RowID");
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
		messageShow("","","",t[-3002])
		return;
	}
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n")
	//messageShow("","","",result)
	var list=result.split("^");
	//messageShow("","","",list)
	if (list[1]!="0")
	{
		messageShow("","","",EQMsg("操作异常!",list[1]));
	}
	else
	{
		if (list[0]>0)
		{
			//modify hly 2019-11-26 bug:1100992
		    messageShow("","","",t[0]) 
			location.replace(location);
		}
		else
		{
			messageShow("","","",t["01"])
		}
	}
}
///选择表格行触发此方法
///Modify By QW 2018-10-11 HISUI改造：点击选择行后，界面无法正常填充数据
///解决方法传入index,rowdata两个参数，并修改判断逻辑
function SelectRowHandler(index,rowdata)
{
	if(index==SelectedRow)
    {
		Clear();	
		disabled(true)//灰化
		SelectedRow=-1;	
		SetElement("RowID","");
		$('#tDHCEQGroup').datagrid('unselectAll');
		return;
	 }
	SelectedRow=index;
	SetData(rowdata.TRowID);//调用函数
	disabled(false);//反灰化
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
	//messageShow("","","",gbldata)
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
