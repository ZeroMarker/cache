//装载页面  函数名称固定
function BodyLoadHandler() 
{
	
	InitPage();
	ChangeStatus(false);
	InitUserInfo();
}

function InitPage(){
	var BAobj=document.getElementById("BAdd");
	if (BAobj) BAobj.onclick=BAdd_click;
	var BUobj=document.getElementById("BUpdate");
	if (BUobj) BUobj.onclick=BUpdate_click;
	var BDobj=document.getElementById("BDelete");
	if (BDobj) BDobj.onclick=BDelete_click;	
}
//点击表格项填充自由项,函数名称固定
var SelectedRow = 0;
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	
	var objtbl=document.getElementById('tDHCEQCTreeEdit'); //得到表格   t+组件名称
	
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; //当前选择行
	// Mozy	2010-12-16
    var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)
	{
		ClearData();	
		ChangeStatus(false)//灰化	
		SelectedRow=0;
	}
	else
	{
		SelectedRow=selectrow;
		ChangeStatus(true);
		FillData(selectrow);
	}
}
function FillData(selectrow)
{
	var RowID=document.getElementById("TRowIDz"+selectrow).value;
	SetElement("RowID",RowID);
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,"","",RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	
	list=ReturnList.split("^");
	SetElement("Type",list[0]);
	SetElement("Code",list[1]);
	SetElement("Desc",list[2]);
	SetElement("ParTreeDR",list[3]);
	SetElement("ExCode",list[4]);
	SetElement("Remark",list[5]);
	SetElement("Hold1",list[6]);
	SetElement("Hold2",list[7]);
	SetElement("Hold3",list[8]);
	SetElement("Hold4",list[9]);
	SetElement("Hold5",list[10]);
	SetElement("Hold6",list[11]);
	SetElement("Hold7",list[12]);
	SetElement("Hold8",list[13]);
	SetElement("Hold9",list[14]);
	SetElement("Hold10",list[15]);
}
//新增按钮点击函数
function BAdd_click()
{	
	if (CheckNull()) return;
	var Return=UpdateData("0");
	if (Return!=0)
	{
		alertShow(Return+"  "+t["01"]);
	}
	else
	{
		parent.frames["DHCEQCTree"].ReloadNode(GetElementValue("ParTreeDR"));
		alertShow("操作成功!")
		window.location.reload();
	}
	
}
//更新按钮点击函数
function BUpdate_click()
{
	if (CheckNull()) return;
	var Return=UpdateData("1");
	if (Return!=0)
	{
		alertShow(Return+"  "+t["01"]);
	}
	else
	{
		parent.frames["DHCEQCTree"].ReloadNode(GetElementValue("ParTreeDR"));
		alertShow("更新成功!")
		window.location.reload();
	}
}
//删除按钮点击函数
function BDelete_click()
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	
	var Return=UpdateData("2");
	if (Return!=0)
	{
		alertShow(Return+"  "+t["01"]);
	}
	else
	{
		parent.frames["DHCEQCTree"].ReloadNode(GetElementValue("ParTreeDR"));
		alertShow("删除成功!")
		window.location.reload();
	}
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	//if (CheckItemNull(2,"Desc")) return true;
	return false;
}
function UpdateData(AppType)
{
	var encmeth=GetElementValue("upd");
	var RowID=GetElementValue("RowID");
	
	var combindata=GetElementValue("TreeType")
	combindata=combindata+"^"+GetElementValue("Code")
	combindata=combindata+"^"+GetElementValue("Desc")
	combindata=combindata+"^"+GetElementValue("ParTreeDR")
	combindata=combindata+"^"+GetElementValue("ExCode")
	combindata=combindata+"^"+GetElementValue("Remark")
	combindata=combindata+"^"+GetElementValue("Hold1")
	combindata=combindata+"^"+GetElementValue("Hold2")
	combindata=combindata+"^"+GetElementValue("Hold3")
	combindata=combindata+"^"+GetElementValue("Hold4")
	combindata=combindata+"^"+GetElementValue("Hold5")
	combindata=combindata+"^"+GetElementValue("Hold6")
	combindata=combindata+"^"+GetElementValue("Hold7")
	combindata=combindata+"^"+GetElementValue("Hold8")
	combindata=combindata+"^"+GetElementValue("Hold9")
	combindata=combindata+"^"+GetElementValue("Hold10")
   
	var Return=cspRunServerMethod(encmeth,"","",AppType,RowID,combindata);
	return Return;
}

function ChangeStatus(Value)
{
	InitPage();
	DisableBElement("BUpdate",!Value);
	DisableBElement("BDelete",!Value);
	DisableBElement("BAdd",Value);
}

function ClearData()
{
	SetElement("RowID","")
	SetElement("Type","")
	SetElement("Code","")
	SetElement("Desc","")
	SetElement("ParTreeDR","")
	SetElement("ExCode","")
	SetElement("Remark","")
	SetElement("Hold1","")
	SetElement("Hold2","")
	SetElement("Hold3","")
	SetElement("Hold4","")
	SetElement("Hold5","")
	SetElement("Hold6","")
	SetElement("Hold7","")
	SetElement("Hold8","")
	SetElement("Hold9","")
	SetElement("Hold10","")
}

//定义页面加载方法
document.body.onload = BodyLoadHandler;
