var SelectedRow = 0;
var rowid=0;
//装载页面  函数名称固定
function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();	//初始化
	disabled(true);//灰化
	KeyUp("CheckItem^CheckResult");	//清空选择
	Muilt_LookUp("CheckItem^CheckResult");
}

function InitEvent() //初始化
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
}

function BDelete_Click() //删除
{
	rowid=GetElementValue("OCIRowID");
	var truthBeTold = window.confirm(t["-4003"]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
	alertShow(t["01"])
	return;
	}
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0) location.reload();	
}
function BUpdate_Click() //修改
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n")
	if(result=="") 
	{
	alertShow(t["02"]);
	return
	}
	if (result>0) location.reload();	
}
function BAdd_Click() //添加
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		alertShow(t["01"])
		return
	}
	if (result>0)location.reload();	
}

function CombinData()
{
	var combindata="";
	var Flag=GetChkElementValue("NormalFlag"); //2009-08-06 党军 begin DJ0022
	if (Flag==false)
	{
		Flag="N"
	}
	else
	{
		Flag="Y"
	} //2009-08-06 党军 end
    combindata=GetElementValue("OCIRowID") ;//行号
    combindata=combindata+"^"+GetElementValue("RowID") ;//批量验收RowID
	combindata=combindata+"^"+GetElementValue("CheckItemDR") ;//验收项目
	combindata=combindata+"^"+GetElementValue("CheckContent") ; //验收内容
  	combindata=combindata+"^"+GetElementValue("CheckResultDR") ; //验收结果
  	combindata=combindata+"^"+GetElementValue("CheckResultRemark") ; //验收结果备注
  	combindata=combindata+"^"+GetElementValue("User") ; //验收人员
  	combindata=combindata+"^"+GetElementValue("Date") ; //验收日期
  	combindata=combindata+"^"+GetElementValue("Time") ; //验收时间
  	combindata=combindata+"^"+Flag ; //验收时间 2009-08-06 党军 DJ0022
  	return combindata;
}
///选择表格行触发此方法
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQOpenCheckItem');//+组件名 就是你的组件显示 Query 结果的部分
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
		SetElement("OCIRowID","");
		location.reload();
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
	SetElement("OCIRowID",list[0]); //OCIRowid
	SetElement("CheckItemDR",list[1]); //验收项目DR
	SetElement("CheckItem",list[2]); //验收项目
	SetElement("CheckContent",list[3]);//验收内容
	SetElement("CheckResultDR",list[4]);//验收结果DR
	SetElement("CheckResult",list[5]); //验收结果
	SetElement("CheckResultRemark",list[6]); //验收结果备注
	SetElement("User",list[7]); //验收人员
	SetElement("Date",list[8]); //验收日期
	SetElement("Time",list[9]); //验收时间
	SetChkElement("NormalFlag",list[10]); //正常标识 //2009-08-06 DJ0022
}

function Clear()
{
	SetElement("OCIRowid","");
	SetElement("CheckItem","");
	SetElement("CheckItemDR","")
	SetElement("CheckResult","");
	SetElement("CheckResultDR","");
	SetElement("CheckContent","");
	SetElement("User","");
	SetElement("CheckResultRemark","");
	SetChkElement("NormalFlag","Y"); //2009-08-06 党军 DJ0022
}

function disabled(value)//灰化
{
	InitEvent();
	DisableBElement("BUpdate",value)

	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
}

function condition()//条件
{
	if (CheckMustItemNull()) return true;
	return false;
}

function GetCheckResult(value) {
	var user=value.split("^");
	var obj=document.getElementById("CheckResultDR");
	obj.value=user[1];
}

function GetCheckItem(value) {
	var type=value.split("^");
	var obj=document.getElementById("CheckItemDR");
	obj.value=type[1];
}
//定义页面加载方法
document.body.onload = BodyLoadHandler;
