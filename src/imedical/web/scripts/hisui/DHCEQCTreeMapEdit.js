//装载页面  函数名称固定
var SelectedRow = -1; //hisui改造 add by kdf 2018-10-16
var rowid=0;

function BodyLoadHandler() 
{
	initButtonWidth()  //hisui改造 add by kdf 2018-10-16
	InitUserInfo();
	InitPage();
	KeyUp("ParTree^CurTree");	//清空选择	
	Muilt_LookUp("ParTree^CurTree");
	ChangeStatus(false);
	
}

function InitPage()
{
	var BUobj=document.getElementById("BUpdate");
	if (BUobj) BUobj.onclick=BUpdate_click;
	var BDobj=document.getElementById("BDelete");
	if (BDobj) BDobj.onclick=BDelete_click;	
	var BDobj=document.getElementById("CurTree");
	if (BDobj) BDobj.onkeydown=ChangeTreeInfo;	
	var obj=document.getElementById("ld"+GetElementValue("GetComponentID")+"iCurTree");
	if (obj) obj.onclick=Tree_Click;
}

//更新按钮点击函数
function BUpdate_click()
{
	if (CheckNull()) return;
	var RowID=GetElementValue("RowID");
	var OldParTreeDR=""
	if (RowID!="")
	{
		var encmeth=GetElementValue("GetOldParTree");
		if (encmeth=="") return;
		var result=cspRunServerMethod(encmeth,RowID);
		OldParTreeDR=result.replace(/\\n/g,"\n")
	}
	var Return=UpdateData("1");
	var List=Return.split("^");
	if (List[0]=="")
	{
		messageShow("","","",List[1]);
	}
	else
	{
		if (List[0]!=0)
		{
			messageShow("","","",List[0]+"  "+t["01"]);
			return
		}
		parent.frames["DHCEQCTreeMap"].ReloadNode(GetElementValue("ParTreeDR"));
		if (OldParTreeDR!="")
		{
			parent.frames["DHCEQCTreeMap"].ReloadNode(OldParTreeDR);
		}
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
		messageShow("","","",Return+"  "+t["01"]);
	}
	else
	{
		parent.frames["DHCEQCTreeMap"].ReloadNode(GetElementValue("ParTreeDR"));
		window.location.reload();
	}
}

function UpdateData(AppType)
{
	var encmeth=GetElementValue("upd");
	var RowID=GetElementValue("RowID");
	
	var combindata=GetElementValue("ParTreeDR")
	combindata=combindata+"^"+GetElementValue("CurTreeDR")
	combindata=combindata+"^"+GetElementValue("Remark")
   
	var Return=cspRunServerMethod(encmeth,AppType,RowID,combindata);
	return Return;
}

function CheckNull()
{
	if (CheckMustItemNull()) return true;
	return false;
}

///选择表格行触发此方法
///modify by by kdf 2018-10-16
///描述：hisui改造 更改值获取方式 并添加入参
///入参：index 行号
///      rowdata 行json数据
function SelectRowHandler(index,rowdata)
{
	if (SelectedRow==index)	{
		ClearData();
		disabled(true)//灰化 需求号：730410  add by kdf 2018-10-24
		$('#tDHCEQCTreeMapEdit').datagrid('unselectAll'); 		
		SelectedRow=-1;
		SetElement("RowID","");
		}
	else{
		SelectedRow=index;
		rowid=rowdata.TRowID	
		FillData(rowid);
		disabled(false);//反灰化 需求号：730410  add by kdf 2018-10-24
		
		}
}

/// 需求号：730410  add by kdf 2018-10-24
/// 选中列后 取消删除按钮的灰化状态
function disabled(value)//灰化
{
	DisableBElement("BDelete",value);
}

function FillData(rowid)
{
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,rowid);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	SetElement("RowID",rowid);
	SetElement("ParTree",list[13]);
	SetElement("ParTreeDR",list[3]);
	SetElement("CurTree",list[12]);
	SetElement("CurTreeDR",list[2]);
	SetElement("Remark",list[5]);
}

function ChangeStatus(Value)
{
	InitPage();
	var ParTreeDR=GetElementValue("ParTreeDR");
	if (ParTreeDR=="0") //根节点不可编辑
	{
		SetElement("ParTree","设备级别树");
		DisableElement("ParTree",true);
		DisableElement("CurTree",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iParTree").style.visibility="hidden"
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iCurTree").style.visibility="hidden"
	}
	else
	{
		SetElement("ParTreeDR",ParTreeDR);
		var encmeth=GetElementValue("GetTreeDesc");
		if (encmeth=="") return;
		var result=cspRunServerMethod(encmeth,ParTreeDR);
		result=result.replace(/\\n/g,"\n")
		SetElement("ParTree",result);
		DisableBElement("BDelete",!Value);
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iParTree").style.visibility=""
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iCurTree").style.visibility=""
	}
}

function ClearData()
{
	SetElement("CurTree","")
	SetElement("CurTreeDR","")
	SetElement("Remark","")
}

function GetParTree(value)
{
	var obj=document.getElementById("ParTreeDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
}

function GetTree(value)
{
	var val=value.split("^");	
	var obj=document.getElementById("CurTree");
	if (obj) obj.value=val[0];
	var obj=document.getElementById("CurTreeDR");
	if (obj) obj.value=val[1];
}

function ChangeTreeInfo()
{
	if (event.keyCode==13)
	{
		Tree_Click();
	}
}

function Tree_Click()
{
	var Type=GetElementValue("Type");
	if (Type==1) //科室级别树
	{
		LookUpCTLoc("GetTree","'',CurTree");
	}
}

//定义页面加载方法
document.body.onload = BodyLoadHandler;
