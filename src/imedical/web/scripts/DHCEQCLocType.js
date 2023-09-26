/// -------------------------------
/// 创建:ZY  2009-07-06  BugNo.ZY0004
/// 描述:科室类型设置
/// --------------------------------
var SelectedRow = 0;
var rowid=0;
var LocTypeStr="";	
var IDStr="";
//装载页面  函数名称固定
function BodyLoadHandler()
{
	//document.body.scroll="no";	//2013-11-11 Mozy0112 恢复滚动条
	LocTypeStr=GetElementValue("LocType");
	IDStr=GetElementValue("ID");
	InitUserInfo();
	InitEvent();	//初始化
	KeyUp("Loc");	//清空选择
	disabled(true);//灰化
	Muilt_LookUp("Loc");
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

function BAdd_Click()
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,'','',plist);
	var rtn=result.replace(/\\n/g,"\n")
	result=rtn.split("^")
	if(result[0]=="")
	{
		if (result[1]!="")
		{
			alertShow("警告!["+result[1]+"]中已经存在该科室记录!操作失败!")
			return
		}
		alertShow(t[1])
		return
		}
	if (result[0]>0)
	{
		alertShow("操作成功!")
		location.reload();
	}	
}

function BUpdate_Click()
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,'','',plist);
	var rtn=result.replace(/\\n/g,"\n")
	result=rtn.split("^")
	if(result[0]=="") 
	{
		if (result[1]!="")
		{
			alertShow("警告!["+result[1]+"]中已经存在该科室记录!操作失败!")
			return
		}
	alertShow(t[2]);
	return
	}
	if (result[0]>0)
	{
		alertShow("更新成功!")
		location.reload();
	}	
}

function BDelete_Click()
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t["-4003"]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
	alertShow(t[3])
	return;
	}
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
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
	val=val+"&FromDate="+GetElementValue("FromDate")
	val=val+"&ToDate="+GetElementValue("ToDate")
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCLocType"+val;
}

function BClear_Click() 
{
	Clear();
	//location.reload();  //Modify by zc 2014-09-05 zc0004
	disabled(true);
}

///选择表格行触发此方法
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCLocType');//+组件名 就是你的组件显示 Query 结果的部分
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
	SetElement("RowID",list[0]); //rowid
	SetElement("LocType",list[1]); //科室类型
	SetElement("Loc",list[2]); //科室
	SetElement("LocDR",list[3]); //科室id	
	SetElement("FromDate",list[4]);//开始时间
	SetElement("ToDate",list[5]); //结束时间
	SetElement("Remark",list[6]); //备注
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
	//SetElement("ID","");
	SetElement("Loc","");
	SetElement("LocDR","");
	SetElement("FromDate","");
	SetElement("ToDate","")
	SetElement("Remark","");
}

function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;
	combindata=combindata+"^"+GetElementValue("ID") ;//科室类型
  	combindata=combindata+"^"+GetElementValue("LocDR") ; //类型
  	combindata=combindata+"^"+GetElementValue("FromDate") ; //开始时间
  	combindata=combindata+"^"+GetElementValue("ToDate") ; //结束时间按
  	combindata=combindata+"^"+GetElementValue("Remark") ; //备注
  	return combindata;
}

function GetLoc(value)
{
	var obj=document.getElementById("LocDR");
	var val=value.split("^");
	if (obj) obj.value=val[1];
}

function condition()//条件
{
	if (CheckMustItemNull()) return true;	
	return false;
}

document.body.onload = BodyLoadHandler;
