//�б��������� DHCEQCIFBAgency.js
var SelectedRow = 0;
var SelectRow = 0;
var rowid=0;
var rows;
function BodyLoadHandler()
{
	InitUserInfo();
	InitEvent();
	disabled(true)//�һ�
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
function BAdd_Click() //����
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth==""){return;}
	var plist=CombinData(); //��������
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
	var plist=CombinData(); //��������
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
	combindata=combindata+"^"+GetElementValue("Code");//����2
  	combindata=combindata+"^"+GetElementValue("Desc");//��������3
  	combindata=combindata+"^"+GetElementValue("Qualifications");//��������4
  	combindata=combindata+"^"+GetElementValue("Address");//��ַ5
  	combindata=combindata+"^"+GetElementValue("Tel");//�绰6
  	combindata=combindata+"^"+GetElementValue("Fax");//����7
  	combindata=combindata+"^"+GetElementValue("ConPerson");//��ϵ��8
  	combindata=combindata+"^"+GetElementValue("FromDate");//��Ч�ڿ�ʼ9
  	combindata=combindata+"^"+GetElementValue("ToDate");//��Ч�ڽ���10
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
///ѡ�����д����˷���
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
		disabled(true)//�һ�
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
	}
	else
	{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);//���ú���
		disabled(false)//���һ�
	}
}
function Clear()
{
	SetElement("RowID","");
	SetElement("Code","");//����1
	SetElement("Desc","");//��������2
	SetElement("Qualifications","");//��������3
	SetElement("Address","");//��ַ4
	SetElement("Tel","");//�绰5
	SetElement("Fax","");//����6
	SetElement("ConPerson","");//��ϵ��7
  	SetElement("FromDate","");//��Ч�ڿ�ʼ8
  	SetElement("ToDate","");//��Ч�ڽ���9
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
	SetElement("Code",list[1]); //����1
	SetElement("Desc",list[2]);//����2
	SetElement("Qualifications",list[3]);//��ַ3
	SetElement("Address",list[4]);//��ַ4
	SetElement("Tel",list[5]);//�绰5
	SetElement("Fax",list[6]);//����6
	SetElement("ConPerson",list[7]);//��ϵ��7
	SetElement("FromDate",list[8]);//��Ч�ڿ�ʼ8
	SetElement("ToDate",list[9]);//��Ч�ڽ���9
	SetElement("Hold1",list[11]);
  	SetElement("Hold2",list[12]);
  	SetElement("Hold3",list[13]);
  	SetElement("Hold4",list[14]);
  	SetElement("Hold5",list[15]);
}
function disabled(value)//���һ�
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