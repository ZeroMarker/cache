var SelectedRow = 0;
var rowid=0;
//装载页面  函数名称固定
function BodyLoadHandler() {
	InitEvent();	//初始化
	KeyUp("Loc");
	Muilt_LookUp("Loc");
	ChangeStatus("")
}
function InitEvent() //初始化
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
}

function BUpdate_Click() //修改
{
	if (condition()) return;
	var RowID=GetElementValue("RowID");
	var val=CombinData();
	var encmeth=GetElementValue("UpdateData");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,"1",val);
	if(result=="-1") 
	{
		alertShow("当月分摊成本已经录入!");
		return
	}
	else
	{		
		location.reload();
	}
}

function BSubmit_Click()
{
	rowid=GetElementValue("RowID");
	if (rowid=="")
	{
		alertShow("选择要提交的信息!")
		 return;
	}
	var encmeth=GetElementValue("SubmitData");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,rowid);
	if (result==0) location.reload();
}

function BDelete_Click() //删除
{
	rowid=GetElementValue("RowID");
	if (rowid=="")
	{
		alertShow("选择要删除的信息!")
		 return;
	}
	var truthBeTold = window.confirm("确定要删除吗?");
    if (!truthBeTold) return;
	var SubmitFlag=GetElementValue("SubmitFlag");
	var encmeth=GetElementValue("UpdateData");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,'0',rowid);
	if (result==0) location.reload();	
}
function CombinData()
{
	var combindata="";
	combindata=GetElementValue("RowID") ;//ID
    combindata=combindata+"^"+GetElementValue("LocDR") ;//科室
  	combindata=combindata+"^"+GetElementValue("Year") ; //年
  	combindata=combindata+"^"+GetElementValue("Month") ; //月
  	combindata=combindata+"^"+GetElementValue("GYCost") ; //资源
  	combindata=combindata+"^"+GetElementValue("GLCost") ; //来源名
  	combindata=combindata+"^"+GetElementValue("YFCost") ; //资源
  	combindata=combindata+"^"+GetElementValue("ZJCost") ; //单价
  	combindata=combindata+"^"+GetElementValue("Person") ; //单位
  	combindata=combindata+"^"+GetElementValue("InCome") ; //数量
  	combindata=combindata+"^"+GetElementValue("SubmitFlag") ; //提交标志
  	return combindata;
}
function Clear()
{
	SetElement("Year","");
	SetElement("Month","");
	SetElement("GYCost","");
	SetElement("GLCost","");
	SetElement("YFCost","");
	SetElement("ZJCost","");
	SetElement("InCome","");
	SetElement("Person","");
	SetElement("Loc","");
	SetElement("LocDR","");
}
///选择表格行触发此方法
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQLocCost');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	{
		Clear();
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		}
	else{
		SelectedRow=selectrow;
		SetElement("RowID",GetElementValue("TRowIDz"+SelectedRow));
		SetElement("Loc",GetElementValue("TLocz"+SelectedRow));
		SetElement("LocDR",GetElementValue("TLocDRz"+SelectedRow));
		SetElement("Year",GetElementValue("TYearz"+SelectedRow));
		SetElement("Month",GetElementValue("TMonthz"+SelectedRow));
		SetElement("GYCost",GetElementValue("TGYCostz"+SelectedRow));
		SetElement("GLCost",GetElementValue("TGLCostz"+SelectedRow));
		SetElement("YFCost",GetElementValue("TYFCostz"+SelectedRow));
		SetElement("ZJCost",GetElementValue("TZJCostz"+SelectedRow));
		SetElement("Person",GetElementValue("TPersonz"+SelectedRow));
		SetElement("InCome",GetElementValue("TInComez"+SelectedRow));
		}
	ChangeStatus(GetElementValue("RowID"))
	InitEvent()
}

function GetLocID(value) {
	var type=value.split("^");
	SetElement("LocDR",type[1]);
}
function condition()//条件
{
	if (CheckMustItemNull()) return true;
	return false;
}
function ChangeStatus(rowid)
{
	if (rowid=="")
	{
		DisableBElement("BSubmit",true)
		DisableBElement("BDelete",true)	
		DisableBElement("BUpdate",false)		
		SetElement("SubmitFlag","")		
		return;
	} 
	var encmeth=GetElementValue("GetLocCostStatus");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,rowid);
	if (result=="Y")
	{
		SetElement("SubmitFlag",result)
		DisableBElement("BUpdate",true)
		DisableBElement("BSubmit",true)
		DisableBElement("BDelete",false)	
		alertShow("本月分摊成本已经提交!")
	}
	else
	{
		SetElement("SubmitFlag","")
		DisableBElement("BUpdate",false)
		DisableBElement("BSubmit",false)
		DisableBElement("BDelete",false)		
	}
	return;
}
//定义页面加载方法
document.body.onload = BodyLoadHandler;
