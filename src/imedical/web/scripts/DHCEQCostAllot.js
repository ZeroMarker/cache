var SelectedRow = 0;
var rowid=0;
//装载页面  函数名称固定
function BodyLoadHandler() {
	InitUserInfo();
	SetEquipName();
	disabled(true);
	InitEvent();	//初始化
	KeyUp("AllotLoc");
	Muilt_LookUp("AllotLoc");
	AllotType_Change();
}

function InitEvent()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("AllotType");
	if (obj) obj.onchange=AllotType_Change;
}

function BUpdate_Click()
{
	if (condition()) return;
	var AllotType=GetElementValue("AllotType")
	if (AllotType=="0")		//0:固定比例,1:工作量,2:面积,3:人数,4:床位,5:收入
	{
		var AllotRate=GetElementValue("AllotRate")
		if ((AllotRate<=0)||(AllotRate>100)||isNaN(AllotRate))
		{
			alertShow("请输入有效的分摊比例(%)")
			return
		}
	}
	else
	{
		var AllotValue=GetElementValue("AllotValue")
		if ((AllotValue<=0)||isNaN(AllotValue))
		{
			alertShow("请输入有效的分摊值")
			return
		}		
		if ((AllotType==1)||(AllotType==2)||(AllotType==5))
		{
			SetElement("AllotValue",parseFloat(AllotValue).toFixed(2))
		}
		else
		{
			if (AllotValue!=parseFloat(AllotValue).toFixed(0))
			{
				alertShow("人数或床位的分摊值必须为整数!")
				return
			}
		}
	}
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;	
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n")
	if(result<0) 
	{
		if ((result=="-1001")||(result=="-1002"))
		{
			alertShow(t[result])
		}
		else
		{
			alertShow(t["02"]);
		}
		return
	}
	if (result>0) location.reload();
}

function BDelete_Click()
{
	var rowid=GetElementValue("ListRowID");
	var truthBeTold = window.confirm(t["-4003"]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,'','',rowid,1);
	result=result.replace(/\\n/g,"\n")
	if(result<0) 
	{
		alertShow(t["02"]);
		return
	}
	if (result>0) location.reload();
}

function CombinData()
{
	var combindata="";
    combindata=GetElementValue("ListRowID") ;
	combindata=combindata+"^"+GetElementValue("Types");
	combindata=combindata+"^"+GetElementValue("EquipDR");
	combindata=combindata+"^"+GetElementValue("AllotLocDR");
	combindata=combindata+"^"+GetElementValue("AllotRate");
	combindata=combindata+"^"+GetElementValue("AllotType");
	combindata=combindata+"^"+GetElementValue("AllotValue");
	return combindata;
}

function condition()//条件
{
	if (CheckMustItemNull()) return true;
	return false;
}

function SetData(rowid)
{
	var encmeth=GetElementValue("GetList");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"转换为回车符
	var list=gbldata.split("^");
	SetElement("ListRowID",rowid);
	SetElement("AllotLocDR",list[0]);
	SetElement("AllotLoc",list[1]);
	SetElement("AllotRate",list[2]);
	SetElement("AllotType",list[3]);
	SetElement("AllotValue",list[4]);
}

function SetEquipName()
{
	var EquipDR=GetElementValue("EquipDR");
	if ((EquipDR=="")||(EquipDR<1)) 
	{
		return;	
	}
	var encmeth=GetElementValue("GetData");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var result=cspRunServerMethod(encmeth,'','',EquipDR);
	result=result.replace(/\\n/g,"\n");
	var list=result.split("^");
	SetElement("Equip",list[0]);
}

///选择表格行触发此方法
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCostAllot');//+组件名 就是你的组件显示 Query 结果的部分
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
		SetElement("ListRowID","");
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);//调用函数
		disabled(false)//反灰化
		}
}

function disabled(value)
{
	InitEvent();
	DisableBElement("BDelete",value);
	AllotType_Change()
}

function Clear()
{
	SetElement("ListRowID","");
	SetElement("AllotLoc","");
	SetElement("AllotLocDR","");
	SetElement("AllotRate","");
	SetElement("AllotType","0");
	SetElement("AllotValue","");
}

function GetAllotLoc(value)
{
	var user=value.split("^");
	var obj=document.getElementById("AllotLocDR");
	obj.value=user[1];
}

function AllotType_Change()
{
	var AllotType=GetElementValue("AllotType");
	if (AllotType=="0")
	{
		SetElement("AllotValue","");
		DisableBElement("AllotValue",true);
		DisableBElement("AllotRate",false);
	}
	else
	{
		SetElement("AllotRate","");
		DisableBElement("AllotValue",false);
		DisableBElement("AllotRate",true);
	}
}
//定义页面加载方法
document.body.onload = BodyLoadHandler;
