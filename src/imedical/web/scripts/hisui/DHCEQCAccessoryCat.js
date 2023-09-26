/// 创建:ZY  2009-08-31   BugNo.:ZY0011
/// 描述:配件分类维护
/// add by wjt 2019-02-26
function BodyLoadHandler()
{
	InitPage();
	ChangeStatus(false);
	InitUserInfo();
	initButtonWidth(); 
	//InitButton();		Mozy003003	1246525		2020-3-27	注释
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
	var str="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCAccessoryCatTree&Type=SelectTree&CatName="+CatName;
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=360,height=460,left=150,top=150')
}
//点击表格项填充自由项,函数名称固定
var SelectedRow = -1;
function SelectRowHandler(rowIndex,rowData)
{
/* 	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCEQCAccessoryCat'); //得到表格   t+组件名称
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; //当前选择行 */
	if (SelectedRow==rowIndex)
	{
		Clear();	
		SelectedRow=-1;
		rowid=0;
		SetElement("RowID","");
		ChangeStatus(false);
	}
	else
	{
		SelectedRow=rowIndex;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		//if (rowid=="") return;
		rowid=rowData.TRowID;
		//SetElement("RowID",rowid);
		FillData(rowData.TRowID);
		ChangeStatus(true);
	}
}
function FillData(RowID)
{
	//var RowID=document.getElementById("TRowIDz"+selectrow).value;
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
	// Mozy003003	1246529		2020-3-27
	if (Return>0)
	{
		messageShow('alert','error','错误提示','代码或名称重复!');
	}
	else if (Return==0)
	{
		messageShow("","","",t["04"]);
		//parent.frames["DHCEQCAccessoryCatTree"].ReloadNode(GetElementValue("ParCatDR"));
		window.location.reload();
	}
	else
	{
		messageShow('alert','error','错误提示',t["-1000"]);
	}
}
//更新按钮点击函数
function BUpdate_click()
{
	if (CheckNull()) return;
	var Return=UpdateData("1");
	// Mozy003003	1246529		2020-3-27
	if (Return>0)
	{
		messageShow('alert','error','错误提示','代码或名称重复!');
	}
	else if (Return==0)
	{
		messageShow("","","",t["04"]);
		//parent.frames["DHCEQCAccessoryCatTree"].ReloadNode(GetElementValue("ParCatDR"));
		window.location.reload();
	}
	else
	{
		messageShow('alert','error','错误提示',t["-1000"]);
	}
}
//删除按钮点击函数
function BDelete_click()
{
	messageShow("confirm","","",t["-1001"],"",ConfirmOpt,DisConfirmOpt);	// Mozy003006		2020-04-03
}
// Mozy003006		2020-04-03
function ConfirmOpt()
{
	var Return=UpdateData("2");
	if (Return!=0)
	{
		//alertShow(Return+"  "+t["-1000"]);
		messageShow("","","",t["-1001"]);
	}
	else
	{
		//parent.frames["DHCEQCAccessoryCatTree"].ReloadNode(GetElementValue("ParCatDR"));
		window.location.reload();
	}
}
function DisConfirmOpt()
{
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
