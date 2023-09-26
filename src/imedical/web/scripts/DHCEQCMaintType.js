///DHCEQCMaintType.js
var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{	
    InitUserInfo(); //ϵͳ����
	InitEvent();	
	disabled(true);//�һ�
	SetElement("Type",GetElementValue("TypeDR"))	//Add By DJ 2016-11-30
	//InitPageNumInfo("DHCEQMCManageType.ManageType","DHCEQMCManageType");	
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
	var obj=document.getElementById("BFind");// ����ţ�263606 csy 2016-09-29
	if (obj) obj.onclick=BFind_Click; // ����ţ�263606 csy 2016-09-29
	var obj=document.getElementById("Type");
	if (obj) obj.onchange=Type_Change;
}
function BClear_Click() 
{
	Clear();
	disabled(true);
}
function BAdd_Click() //����
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,"","",plist,'2');
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		alertShow(t[-3001]);
		return;
	}
	if (result>0)
	{
		alertShow("�����ɹ�");      //add by wy 2017-7-31
		location.reload();
	}
}

function BUpdate_Click()
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n")
	//alertShow("result:"+result)
	if(result=="")
	{
		alertShow(t[-3001]);
		return;
	}
	if (result>0)
	{ 
	alertShow("���³ɹ�");     //add by wy 2017-7-31
	location.reload();
	}
}
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID");
	combindata=combindata+"^"+GetElementValue("Code");
  	combindata=combindata+"^"+GetElementValue("Desc");
  	combindata=combindata+"^"+GetElementValue("Remark");
  	combindata=combindata+"^N";
  	combindata=combindata+"^"+GetElementValue("Type");
  	
  	return combindata;
}
function BDelete_Click()
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")
	{
		alertShow(t[-3001])
		return;
	}
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
	alertShow("ɾ���ɹ�!");  // add by kdf 2018-01-24 ����ţ�533666 
	location.reload();
	}
}

function BFind_Click()   // ����ţ�263606 csy 2016-09-29   start
{
	var val="&Code="+GetElementValue("Code")
	val=val+"&Desc="+GetElementValue("Desc")
	val=val+"&Type="+GetElementValue("Type")
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCMaintType'+val
	
} // ����ţ�263606 csy 2016-09-29   end



///ѡ�����д����˷���
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById("tDHCEQCMaintType");
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (SelectedRow==selectrow)
	{
		Clear();
		disabled(true);//�һ�
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
	}
	else
	{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);//���ú���
		disabled(false);//���һ�
	}
}
function Clear()
{
	SetElement("RowID","")
	SetElement("Code",""); 
	SetElement("Desc","");
	SetElement("Remark","");
	SetElement("Type","");
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	var list=gbldata.split("^");
	//alertShow("gbldata="+gbldata);
	SetElement("RowID",list[0]);
	SetElement("Code",list[1]);
	SetElement("Desc",list[2]);
	SetElement("Remark",list[3]);
	SetElement("Type",list[5]);
	SetElement("TypeDR",list[5]);
}

function disabled(value)//�һ�
{
	InitEvent();
	DisableBElement("BUpdate",value);
	DisableBElement("BDelete",value);
	DisableBElement("BAdd",!value);
}
function condition()//����
{
	if (CheckMustItemNull()) return true;
	/*
	if (CheckItemNull(0,"Code")) return true;
	if (CheckItemNull(0,"Desc")) return true;
	*/
	return false;
}
function Type_Change()
{
	SetElement("TypeDR",GetElementValue("Type"))
}
document.body.onload = BodyLoadHandler;
