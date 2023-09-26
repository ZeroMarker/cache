//modified by GR 2014-09-24 
//缺陷号3037 取消选择，界面下方部分信息未清空
//缺陷号3038 取消选择后再次选择该条记录，界面下方未显示该条记录信息
//修改位置SelectRowHandler()
//---------------------------------------------------------------------------------------
//装载页面  函数名称固定
function BodyLoadHandler() {
	InitPage();
	ChangeStatus(false);
	InitUserInfo();
	KeyUp("ParCat^SpecialType^DepreMethod","N"); //2009-08-12 党军 DJ0025
	Muilt_LookUp("ParCat^SpecialType^DepreMethod"); //2009-08-12 党军 DJ0025
	SetElement("YearsNum",GetElementValue("ParYeasNum"));
	SetElement("Remark",GetElementValue("ParRemark"));
	initButtonWidth()  //hisui改造 add by lmm 2018-08-20
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
///hisui改造 modified by kdf 2018-02-24 
///入参：index 行号
///      rowdata 行json数据
///选中行的index应该从0开始,更改逻辑判断
var SelectedRow = -1;
function SelectRowHandler(index,rowdata){
	if (index==SelectedRow){
		Clear();
		SelectedRow= -1;
		ChangeStatus(false);
		$('#tDHCEQCEquipeCat').datagrid('unselectAll'); 
		return;
		}
		
	ChangeStatus(true);
	FillData(rowdata.TRowID);    
    SelectedRow = index;
}

///hisui改造 add by kdf 2018-02-24
///修改传入参数
function FillData(RowID)
{
	//var RowID=document.getElementById("TRowIDz"+selectrow).value;    //hisui改造 modify by lmm 2018-08-17
	SetElement("RowID",RowID);

	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,"","",RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");

	list=ReturnList.split("^");
	SetElement("Code",list[0]);
	SetElement("Desc",list[1]);
	SetElement("ParCatDR",list[2]);
	SetElement("ParCat",list[3]);
	SetElement("Remark",list[4]);
	SetElement("SpecialTypeDR",list[5]);
	SetElement("SpecialType",list[6]);
	SetElement("YearsNum",list[7]);
	SetChkElement("EquipNoFlag",list[8]);
	SetElement("DepreMethodDR",list[9]); //2009-08-12 党军 begin DJ0025
	SetElement("DepreMethod",list[10]);
	SetElement("Hold2",list[11]);
	SetElement("ExtendCode",list[12]); //2009-08-12 党军 end
	SetElement("Hold2Desc",list[13]);		// MZY0030	1340074		2020-06-01
}
//新增按钮点击函数
function BAdd_click()
{	
	if (CheckNull()) return;
	/*
	var Desc=GetElementValue("Desc");
	if(!Desc){
		alertShow('名称不能为空！');
		return ;
		};*/
		
	var Return=UpdateData("0");
	if (Return!=0)
	{
		//messageShow("","","",Return+"  "+t["01"]);
	}
	else
	{
		alertShow("操作成功!");
		window.location.reload();  //hisui改造 modify by lmm 2018-08-17
		parent.frames["DHCEQCEquipCatTree"].ReloadNode(GetElementValue("ParCatDR"));
		
	}
	
}
//更新按钮点击函数
function BUpdate_click()
{
	if (CheckNull()) return;
	
	var Desc=GetElementValue("Desc");
	if(!Desc){
		alertShow('名称不能为空！');
		return ;
		};
		
	var Return=UpdateData("1");
	if (Return!=0)
	{
		messageShow("","","",Return+"  "+t["01"]);
	}
	else
	{
		alertShow("操作成功!");
		window.location.reload();
		parent.frames["DHCEQCEquipCatTree"].ReloadNode(GetElementValue("ParCatDR"));  //hisui改造 modify by lmm 2018-08-17
		
		
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
		messageShow("","","",Return+"  "+t["01"]);
	}
	else
	{	
		alertShow("删除成功!")
		window.location.reload();  //hisui改造 modify by lmm 2018-08-17
		parent.frames["DHCEQCEquipCatTree"].ReloadNode(GetElementValue("ParCatDR"));
			
	}
}

///add by kdf 2018-02-24
///描述：hisui改造 提取清空函数
function Clear()
{
	SetElement("Code","");
	SetElement("Desc","");
	//SetElement("ParCatDR","");
	//SetElement("ParCat","");
	SetElement("Remark","");
	SetElement("SpecialTypeDR","");
	SetElement("SpecialType","");
	SetElement("YearsNum","");
	SetChkElement("EquipNoFlag","");
	SetElement("DepreMethodDR",""); 
	SetElement("DepreMethod","");
	SetElement("Hold2","");
	SetElement("Hold2Desc","");		// MZY0030	1340074		2020-06-01
	SetElement("ExtendCode","");
	SetElement("RowID","");
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
	var Code=GetElementValue("Code");
	var Desc=GetElementValue("Desc");
	var ParCat=GetElementValue("ParCatDR");
	var Remark=GetElementValue("Remark");
	var SpecialType=GetElementValue("SpecialTypeDR");
	var YearsNum=GetElementValue("YearsNum")
	var EquipNoFlag=GetChkElementValue("EquipNoFlag");
	var DepreMethod=GetElementValue("DepreMethodDR"); //2009-08-12 党军 begin DJ0025
	if (GetElementValue("Hold2Desc")=="") SetElement("Hold2","");		// MZY0030	1340074		2020-06-01
	var Hold2=GetElementValue("Hold2");
	var ExtendCode=GetElementValue("ExtendCode");
	var Return=cspRunServerMethod(encmeth,"","",AppType,RowID,Code,Desc,ParCat,Remark,SpecialType,YearsNum,EquipNoFlag,DepreMethod,Hold2,ExtendCode); //2009-08-12 党军 end DJ0025
	return Return;
} 
function ChangeStatus(Value)
{
	InitPage();
	DisableBElement("BUpdate",!Value);
	DisableBElement("BDelete",!Value);
	DisableBElement("BAdd",Value);
}
function GetSpecialType(value)
{
    GetLookUpID("SpecialTypeDR",value);
}
function GetDepreMethodID(value) //2009-08-12 党军 DJ0025
{
	GetLookUpID("DepreMethodDR",value);
}
// MZY0030	1340074		2020-06-01
function GetFinanceType(value)
{
	var val=value.split("^");
	SetElement("Hold2",val[0]);
	SetElement("Hold2Desc",val[2]);
}

//定义页面加载方法
document.body.onload = BodyLoadHandler;
