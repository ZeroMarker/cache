/// 创建:ZY  2009-08-31   BugNo.:ZY0011
/// 描述:配件分类维护
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
	var obj=document.getElementById(GetLookupName("Cat"));
	if (obj) obj.onclick=Cat_Click;
}
function Cat_Click()
{
	var CatName=GetElementValue("Cat")
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCAccessoryCatTree&Type=SelectTree&CatName="+CatName;
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=360,height=460,left=150,top=150')
}
//点击表格项填充自由项,函数名称固定
var SelectedRow = 0;
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCEQCAccessoryCat'); //得到表格   t+组件名称
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; //当前选择行
	if (SelectedRow==selectrow)
	{	
		Clear();	
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		ChangeStatus(false);
	}
	else
	{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		if (rowid=="") return;
		SetElement("RowID",rowid);
		FillData(selectrow);
		ChangeStatus(true);
	}
}
function FillData(selectrow)
{
	var RowID=document.getElementById("TRowIDz"+selectrow).value;
	SetElement("RowID",RowID);
	var obj=document.getElementById("GetData");
	if (obj)
	{
		var encmeth=obj.value
	}
	else
	{
		var encmeth=""
	};
	var ReturnList=cspRunServerMethod(encmeth,"","",RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	SetElement("ParCatDR",list[0]);
	SetElement("Text",list[1]);
	SetElement("Desc",list[2]);
	SetElement("Remark",list[3]);
	SetElement("InvalidFlag",list[4]);
	SetElement("ParCat",list[8]);
}
//新增按钮点击函数
function BAdd_click()
{	
	if (CheckNull()) return;
	var Return=UpdateData("0");
	if (Return!=0)
	{
		alertShow(Return+"  "+t["-1000"]);
	}
	else
	{
		alertShow("新增成功!");
		//parent.frames["DHCEQCAccessoryCatTree"].ReloadNode(GetElementValue("ParCatDR"));
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
		alertShow(Return+"  "+t["-1000"]);
	}
	else
	{
		alertShow("保存成功!");
		//parent.frames["DHCEQCAccessoryCatTree"].ReloadNode(GetElementValue("ParCatDR"));
		window.location.reload();
	}
}
//删除按钮点击函数
function BDelete_click()
{
	var truthBeTold = window.confirm(t["-1001"]);
	if (!truthBeTold) return;	
	var Return=UpdateData("2");
	if (Return!=0)
	{
		alertShow(Return+"  "+t["-1000"]);
	}
	else
	{
		//parent.frames["DHCEQCAccessoryCatTree"].ReloadNode(GetElementValue("ParCatDR"));
		window.location.reload();
	}
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	return false;
}
function UpdateData(AppType)
{
	var encmeth=GetElementValue("upd");
	var val=GetElementValue("RowID");
	val=val+"^"+GetElementValue("ParCatDR");
	val=val+"^"+GetElementValue("Text");
	val=val+"^"+GetElementValue("Desc");
	val=val+"^"+GetElementValue("Remark");
	var Return=cspRunServerMethod(encmeth,"","",val,AppType);
	return Return;
} 
function ChangeStatus(Value)
{
	InitPage();
	DisableBElement("BUpdate",!Value);
	DisableBElement("BDelete",!Value);
	DisableBElement("BAdd",Value);
}
function Clear()
{
	SetElement("RowID","");
	SetElement("Text","");
	SetElement("Desc","");
	SetElement("ParCatDR","");
	SetElement("ParCat","");
	SetElement("Remark","");
	SetElement("InvalidFlag","");
}
document.body.onload = BodyLoadHandler;
