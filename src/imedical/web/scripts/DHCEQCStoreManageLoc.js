/// -------------------------------
/// 创建:ZY  2010-07-26  BugNo.ZY0025
/// 描述:被管理科室明细
/// --------------------------------
var SelectedRow = 0;
function BodyLoadHandler()
{
	document.body.scroll="no";
	ID=GetElementValue("ID");
	InitUserInfo();
	InitEvent();
	KeyUp("Loc");
	//Muilt_LookUp("Loc");   //modified by kdf 2018-03-05 需求号：548421
	disabled(true);
}

function InitEvent() //初始化
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
}

function BAdd_Click() //2010-07-01 党军 begin
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist);
	var rtn=result.replace(/\\n/g,"\n")
	result=rtn.split("^")
	if(result[0]=="")
	{
		alertShow(result[1])
		return
	}
	if (result[0]>0)
	{
		alertShow("操作成功!")
		location.reload();
	}
	else
	{
		alertShow("操作失败!")
	}
}

function BUpdate_Click() //2010-07-01 党军
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist);
	var rtn=result.replace(/\\n/g,"\n")
	result=rtn.split("^")
	if(result[0]=="")
	{
		alertShow(result[1])
		return
	}
	if (result[0]>0)
	{
		alertShow("更新成功!")
		location.reload();
	}
	else
	{
		alertShow("操作失败!")
	}
}

function BDelete_Click()
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t["-4003"]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		alertShow("删除成功!")
		location.reload();
	}
}

function BFind_Click()
{
	var val="&ID="+GetElementValue("ID");
	val=val+"&LocDR="+GetElementValue("LocDR");
	val=val+"&Loc="+GetElementValue("Loc");
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCStoreManageLoc"+val;
}

function BClear_Click() 
{
	Clear();
	disabled(true);
}

///选择表格行触发此方法
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCStoreManageLoc');//+组件名 就是你的组件显示 Query 结果的部分
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
		SetElement("RowID","");
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);//调用函数
		disabled(false)//反灰化
		}
}

function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"转换为回车符
	var list=gbldata.split("^");
	SetElement("RowID",rowid);
	SetElement("StoreLocDR",list[0]); //科室
	SetElement("StoreLoc",list[9]); //科室
	SetElement("LocDR",list[1]); //科室
	SetElement("Loc",list[10]); //科室
	SetElement("Remark",list[2]); //备注
	SetElement("Hold1",list[3]); //
	SetElement("Hold2",list[4]); //
	SetElement("Hold3",list[5]); //
	SetElement("Hold4",list[6]); //
	SetElement("Hold5",list[7]); //
}

function disabled(value)//灰化
{
	InitEvent();
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
}

function Clear()
{
	SetElement("RowID","");
	SetElement("Loc","");
	SetElement("LocDR","");
	SetElement("Remark","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
}

function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;
	combindata=combindata+"^"+GetElementValue("ID") ;//科室类型
  	combindata=combindata+"^"+GetElementValue("LocDR") ; //类型
  	combindata=combindata+"^"+GetElementValue("Remark") ; //备注
  	combindata=combindata+"^"+GetElementValue("Hold1") ; //
  	combindata=combindata+"^"+GetElementValue("Hold2") ; //
  	combindata=combindata+"^"+GetElementValue("Hold3") ; //
  	combindata=combindata+"^"+GetElementValue("Hold4") ; //
  	combindata=combindata+"^"+GetElementValue("Hold5") ; //
  	return combindata;
}

function GetLoc(value)
{
	GetLookUpID("LocDR",value);
}

function condition()//条件
{
	if (CheckMustItemNull()) return true;	
	return false;
}

document.body.onload = BodyLoadHandler;
