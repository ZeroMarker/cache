var SelectedRow = -1;	//HISUI���� modified by czf 20180929
var rowid=0;
//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();	//��ʼ��
	DisableBElement("BDelete",true);
	initButtonWidth()  //hisui���� add by czf 20180929
	initButtonColor();//cjc 2023-01-18 ���ü��������ť��ɫ
	initPanelHeaderStyle();//cjc 2023-01-17 ��ʼ�����������ʽ
}

function InitEvent() //��ʼ��
{
	//modified by ZY0303 20220615 2709599  ����Ժ����մ���
	// 20140410  Mozy0126
	Muilt_LookUp("Provider^EquipType^Hospital");
	KeyUp("Provider^EquipType^Hospital");
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	//add by csj 20190906 ����ţ�1020586
	$('#BFind').click(function(){
		if (!$(this).linkbutton('options').disabled){
			$('#tDHCEQOCREquipDelete').datagrid('load',{ComponentID:getValueById("GetComponentID"),QXType:getValueById("QXType"),Equip:getValueById("Equip"),ProviderDR:getValueById("ProviderDR"),EquipTypeDR:getValueById("EquipTypeDR"),StartDate:getValueById("StartDate"),EndDate:getValueById("EndDate"),HospitalDR:getValueById("HospitalDR")}); //Modified By QW20210629 BUG:QW0131
			SetElement("RowID","");
			DisableBElement("BDelete",true);
		}
	});
	//Add By QW20210629 BUG:QW0131 Ժ�� begin
	var HosCheckFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990051");
	if(HosCheckFlag=="0")
	{
		hiddenObj("cHospital",1);
		hiddenObj("Hospital",1);
	}
	//Add By QW20210629 BUG:QW0131 Ժ�� end
}

function BDelete_Click() //ɾ��
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t["-4003"]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	var result=cspRunServerMethod(encmeth,rowid);
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		location.reload();
	}
	else
	{
		if (result==-99)
		{
			alertShow("��ǰ���յ�������������ϸ��������¼!");
		}
		if (result==-98)
		{
			alertShow("��ǰ���յ�����ϸ��¼!");
		}
		messageShow("","","",t["01"]);
	}
}
///ѡ�����д����˷���
///HISUI���� modified by czf 20180929
function SelectRowHandler(index,rowdata)
{
	if (index==SelectedRow)
	{
		DisableBElement("BDelete",true);
		SelectedRow=-1;
		rowid=0;
		SetElement("RowID","");
		$('#tDHCEQOCREquipDelete').datagrid('unselectAll');		// MZY0056	1528180		2020-09-29	�����ѡ��
	}
    else
    {
		SelectedRow=index;
		rowid=rowdata.TRowID;
		SetElement("RowID",rowid);
		DisableBElement("BDelete",false);
		InitEvent();
	}
}

/*
///ѡ�����д����˷���
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQOCREquipDelete');//+����� ������������ʾ Query ����Ĳ���
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	{
		DisableBElement("BDelete",true);
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetElement("RowID",rowid);
		DisableBElement("BDelete",false);
		InitEvent();
		}
}*/
// 20140410  Mozy0126
function GetProvider(value)
{
	GetLookUpID("ProviderDR",value);
}
function GetEquipType(value)
{
	GetLookUpID("EquipTypeDR",value);
}
//Add By QW20210629 BUG:QW0131 Ժ��
function GetHospital(value)
{
	GetLookUpID("HospitalDR",value); 			
}
//����ҳ����ط���
document.body.onload = BodyLoadHandler;
