//�豸�۾����ñ��ѯ
var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{
	document.body.scroll="no";
	KeyUp("EquipName^DepreMethod")	
	Muilt_LookUp("EquipName^DepreMethod");
	var obj=document.getElementById("BFind");//����
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("BAdd");//����
	if (obj) obj.onclick=BAdd_Click;
	//RowidLink();//rowid����
}

function BAdd_Click()
{
	parent.location.href="dhceqdepreset.csp";
}
function BFind_Click()
{
var DepreMethodDR=GetElementValue("DepreMethodDR")
var EquipNameDR=GetElementValue("EquipNameDR")
parent.frames["DHCEQDepreSetList"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDepreSetList&EquipNameDR='+EquipNameDR+'&DepreMethodDR='+DepreMethodDR;
//parent.ocation.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDepreSetList&EquipNameDR='+EquipNameDR+'&DepreMethodDR='+DepreMethodDR;
	}
///ѡ�����д����˷���
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQDeviceMap');//+����� ������������ʾ Query ����Ĳ���
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	{
		document.all["BAdd"].style.display="inline";
		Clear();	
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		}
	else{
		document.all["BAdd"].style.display="none";//����
		SelectedRow=selectrow;
		rowid=GetCElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);//���ú���
		}
}
function Clear()
{
	SetElement("Omdr",""); 
	SetElement("Uomtype","");
	}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="")return;var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	var list=gbldata.split("^");
	//alertShow("list"+list);
	SetElement("RowID",list[0]); //rowid
	SetElement("Equip",list[1]); //�豸
	SetElement("Device",list[2]);//����
	SetElement("DeviceSource",list[3]);//�豸��Դ
	SetElement("Remark",list[4]);//��ע
	SetElement("AddUser",list[5]);//������
	SetElement("AddDate",list[6]);//��������
	SetElement("AddTime",list[7]);//����ʱ��
	SetElement("UpdateUser",list[8]);//������
	SetElement("UpdateDate",list[9]);//��������
	SetElement("UpdateTime",list[10]);//����ʱ��
}
function EquipNameDR(value)//�豸����
{
	//alertShow(value);
	var obj=document.getElementById("EquipNameDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//alertShow(val[1]);
}
function DepreMethodDR(value)//�۾ɷ���
{
	//alertShow(value);
	var obj=document.getElementById("DepreMethodDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//alertShow(val[1])
}
document.body.onload = BodyLoadHandler;