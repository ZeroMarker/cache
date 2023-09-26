//招标代理机构表 DHCEQCIFBAgency.js
var SelectedRow = 0;
var SelectRow = 0;
var rowid=0;
var rows;
function BodyLoadHandler()
{
	InitUserInfo();
	InitEvent();
	disabled(true)//灰化
}
function InitEvent()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
	var obj=document.getElementById("BFind")
	if (obj) obj.onclick=BFind_Click;
}
function BAdd_Click() //增加
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth==""){return;}
	var plist=CombinData(); //函数调用
	//alertShow("plist="+plist);
	var result=cspRunServerMethod(encmeth,'','',plist,'0');
	result=result.replace(/\\n/g,"\n");
	if (result==-2001) alertShow(t[-3001]);
	if (result>0) location.reload();	
}
function BUpdate_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;	
	var plist=CombinData(); //函数调用
	//alertShow("plist="+plist);
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n");
	if (result==-2001) alertShow(t[-3002]);
	if (result>0) location.reload();
}
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID");//1
	combindata=combindata+"^"+GetElementValue("Code");//代码2
  	combindata=combindata+"^"+GetElementValue("Desc");//机构名称3
  	combindata=combindata+"^"+GetElementValue("Qualifications");//代理资质4
  	combindata=combindata+"^"+GetElementValue("Address");//地址5
  	combindata=combindata+"^"+GetElementValue("Tel");//电话6
  	combindata=combindata+"^"+GetElementValue("Fax");//传真7
  	combindata=combindata+"^"+GetElementValue("ConPerson");//联系人8
  	combindata=combindata+"^"+GetElementValue("FromDate");//有效期开始9
  	combindata=combindata+"^"+GetElementValue("ToDate");//有效期结束10
  	combindata=combindata+"^"+GetElementValue("Hold1");
  	combindata=combindata+"^"+GetElementValue("Hold2");
  	combindata=combindata+"^"+GetElementValue("Hold3");
  	combindata=combindata+"^"+GetElementValue("Hold4");
  	combindata=combindata+"^"+GetElementValue("Hold5");
  	return combindata;
}
function BFind_Click()
{
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCIFBAgency&Code="+GetElementValue("Code")+"&Desc="+GetElementValue("Desc");
}
function BClear_Click()
{
	Clear();
	disabled(true);
}
function BDelete_Click()
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") {return;}
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n");
	//alertShow("result"+result);
	if (result>0) {location.reload();}	
}
///选择表格行触发此方法
var SelectedRow = 0;
var rowid=0;
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCIFBAgency');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)
	{
		Clear();
		disabled(true)//灰化
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
	}
	else
	{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);//调用函数
		disabled(false)//反灰化
	}
}
function Clear()
{
	SetElement("RowID","");
	SetElement("Code","");//代码1
	SetElement("Desc","");//机构名称2
	SetElement("Qualifications","");//代理资质3
	SetElement("Address","");//地址4
	SetElement("Tel","");//电话5
	SetElement("Fax","");//传真6
	SetElement("ConPerson","");//联系人7
  	SetElement("FromDate","");//有效期开始8
  	SetElement("ToDate","");//有效期结束9
  	SetElement("Hold1","");
  	SetElement("Hold2","");
  	SetElement("Hold3","");
  	SetElement("Hold4","");
  	SetElement("Hold5","");
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth==""){return;}
	var gbldata=cspRunServerMethod(encmeth,rowid);
	gbldata=gbldata.replace(/\\n/g,"\n");
	//alertShow("gbldata="+gbldata);
	var list=gbldata.split("^");
	SetElement("RowID",list[0]);//rowid
	SetElement("Code",list[1]); //名称1
	SetElement("Desc",list[2]);//代码2
	SetElement("Qualifications",list[3]);//地址3
	SetElement("Address",list[4]);//地址4
	SetElement("Tel",list[5]);//电话5
	SetElement("Fax",list[6]);//传真6
	SetElement("ConPerson",list[7]);//联系人7
	SetElement("FromDate",list[8]);//有效期开始8
	SetElement("ToDate",list[9]);//有效期结束9
	SetElement("Hold1",list[11]);
  	SetElement("Hold2",list[12]);
  	SetElement("Hold3",list[13]);
  	SetElement("Hold4",list[14]);
  	SetElement("Hold5",list[15]);
}
function disabled(value)//反灰化
{
	InitEvent();
	DisableBElement("BAdd",!value);
	DisableBElement("BUpdate",value);
	DisableBElement("BDelete",value);
}	
function condition()
{
	if (CheckMustItemNull()) return true;
	/*if (CheckItemNull(0,"Name")) return true;
	if (CheckItemNull(0,"Code")) return true;*/
	return false;
}
document.body.onload = BodyLoadHandler;