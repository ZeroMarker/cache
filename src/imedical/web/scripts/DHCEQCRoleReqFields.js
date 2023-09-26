/// -------------------------------
/// 创建:ZY  2010-08-03   BugNo.:ZY0027
/// 描述:编辑字段
/// --------------------------------
var SelectedRow = 0;
var rowid=0;
//装载页面  函数名称固定
function BodyLoadHandler()
{
	InitUserInfo();
	InitEvent();	//初始化
	disabled(true);//灰化
  	KeyUp("Type")
  	Muilt_LookUp("Type");
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

function BAdd_Click()
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist,'0');
	result=result.replace(/\\n/g,"\n")
	if(result!=0)
	{
		alertShow(t[-1000])
		return
	}
	if (result==0)location.reload();
}

function BUpdate_Click()
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist,'2');
	result=result.replace(/\\n/g,"\n")
	//alertShow(result)
	if(result!=0)
	{
		alertShow(t[-1000])
		return
	}
	if (result==0)location.reload();	
}

function BDelete_Click()
{
	var plist=CombinData(); //函数调用
	var truthBeTold = window.confirm(t["-4003"]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,plist,'1');
	result=result.replace(/\\n/g,"\n")
	if(result!=0)
	{
		alertShow(t[-1000])
		return
	}
	if (result==0)location.reload();			
}

///选择表格行触发此方法
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCRoleReqFields');
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
	var gbldata=cspRunServerMethod(encmeth,rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"转换为回车符
	var list=gbldata.split("^");
	SetElement("RowID",rowid);
	//SetElement("ApproveFlowDR",list[0]);
	SetChkElement("MustFlag",list[13]);
	SetElement("Field",list[2])
	SetElement("Type",list[14])
	SetElement("TypeDR",list[3])
	SetElement("Position",list[4])
	SetElement("TableName",list[5])
	SetElement("Sort",list[6])
	SetChkElement("Hold1",list[7]);
	SetElement("Hold2",list[8])
	SetElement("Hold3",list[9])
	SetElement("Hold4",list[10])
	SetElement("Hold5",list[11])
}

function disabled(value)//灰化
{
	InitEvent();	
	DisableBElement("BAdd",!value)
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)
}

function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("ApproveFlowDR") ;
  	combindata=combindata+"^"+GetChkElementValue("MustFlag") ;
  	combindata=combindata+"^"+GetElementValue("Field") ;
  	combindata=combindata+"^"+GetElementValue("TypeDR") ;
  	combindata=combindata+"^"+GetElementValue("Position") ;
  	combindata=combindata+"^"+GetElementValue("TableName") ;
  	combindata=combindata+"^"+GetElementValue("Sort") ;
  	combindata=combindata+"^"+GetChkElementValue("Hold1") ;
  	combindata=combindata+"^"+GetElementValue("Hold2") ;
  	combindata=combindata+"^"+GetElementValue("Hold3") ;
  	combindata=combindata+"^"+GetElementValue("Hold4") ;
  	combindata=combindata+"^"+GetElementValue("Hold5") ;
  	return combindata;
}
function Clear()
{
	SetElement("RowID","");
	//SetElement("ApproveFlowDR","");
	SetChkElement("MustFlag","");
	SetElement("Field","")
	SetElement("Type","")
	SetElement("TypeDR","")
	SetElement("Position","")
	SetElement("TableName","")
	SetElement("Sort","")
	SetChkElement("Hold1","")
	SetElement("Hold2","")
	SetElement("Hold3","")
	SetElement("Hold4","")
	SetElement("Hold5","")
}
function condition()//条件
{
	if (CheckMustItemNull()) return true;	
	return false;
}
function GetTypeID(value)
{
	GetLookUpID("TypeDR",value);
}

document.body.onload = BodyLoadHandler;
