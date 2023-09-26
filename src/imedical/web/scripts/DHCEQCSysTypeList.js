///--------------------------------------------
///Created By HZY 2011-7-22 . HZY0002
///--------------------------------------------
var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{
    InitUserInfo(); //系统参数
	InitEvent();		
	SetData(); //设置当前元素的值?
}
function InitEvent()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
}

function SetData()
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return ;
	var groupid=GetElementValue("GroupDR");
	var gbldata=cspRunServerMethod(encmeth,groupid);
	if (gbldata!="")
	{
		var list=gbldata.split("^");
		SetElement("RowID",list[0]); //rowid
		SetElement("GroupDR",list[1]); //
		SetElement("SysTypeDR",list[2]); //
		SetElement("Hold1",list[3]);//
		SetElement("Hold2",list[4]);//
		SetElement("Hold3",list[5]);//
		SetElement("SysType",list[7]);//
	}			
}

function CombinData()
{
	var combindata="";
	combindata=GetElementValue("RowID") ;
    combindata=combindata+"^"+GetElementValue("GroupDR") ;//
	combindata=combindata+"^"+GetElementValue("SysTypeDR") ;//
	combindata=combindata+"^"+GetElementValue("Hold1") ;//
	combindata=combindata+"^"+GetElementValue("Hold2") ;//
	combindata=combindata+"^"+GetElementValue("Hold3") ;//    
  	return combindata;
}

function BUpdate_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist);
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
	 	location.reload();
	}
	else
	{
		alertShow(t[result]);  
	}	
}

function disabled(value)//灰化
{
	InitEvent();
	DisableBElement("BUpdate",value)
}
	
function condition()//条件
{
	if (CheckMustItemNull()) return true;
	return false;
}

function GetSysType(value) 
{
	GetLookUpID("SysTypeDR",value)
}

document.body.onload = BodyLoadHandler;