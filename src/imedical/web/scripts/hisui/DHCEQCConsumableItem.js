var SelectedRow = -1; ///Modify By QW 2018-10-08 HISUI����
var rowid=0;
//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() {
	initButtonWidth();///Add By QW 2018-10-10 HISUI����:�޸İ�ť����
	setButtonText();///Add By QW 2018-10-10 HISUI����:��ť���ֹ淶
	InitUserInfo();
	InitEvent();	//��ʼ��
	KeyUp("Unit");
	disabled(true);//�һ�
	Muilt_LookUp("Unit");
	SetElement("ExType",GetElementValue("ExTypeDR"));
}

function InitEvent() //��ʼ��
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
}
///add by QW 2018-10-10
///������hisui���� �����б�onchange�¼�����
///Modified By QW20181026�����:724635
 $('#ExType').combobox({
    onSelect: function () {
	   ExType_Change();
    }
 })
function ExType_Change()
{
	SetElement("ExTypeDR",GetElementValue("ExType"));
	SetElement("ExID","")
}
///Add By QW 2018-10-08 hisui�����������
function BFind_Click()
{
	var val="&Code="+GetElementValue("Code");
	val=val+"&Desc="+GetElementValue("Desc");
	val=val+"&ExTypeDR="+GetElementValue("ExTypeDR");
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCConsumableItem"+val;
}

function BClear_Click() 
{
	Clear();
	disabled(true);
}
function BDelete_Click() //ɾ��
{
	///modified by ZY0215 2020-04-02
	messageShow("confirm","","",t[-4003],"",confirmFun,"")
}
///modified by ZY0215 2020-04-02
function confirmFun()
{
	rowid=GetElementValue("RowID");
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
	messageShow("","","",t["02"])
	return;
	}
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0) location.reload();	
}
function BUpdate_Click() //�޸�
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
  	if ((GetElementValue("ExType")!="")&&(GetElementValue("ExID")==""))
  	{
	  	alertShow("��������չID!")
	  	return
  	}
  	if (CheckInvalidData()) return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n")
	if(result=="") 
	{
		messageShow("","","",t["03"]);
		return
	}
	if (result>0) 
	{
		//add by HHM 20150910 HHM0013
		//��Ӳ����ɹ��Ƿ���ʾ
		ShowMessage();
		//****************************
		location.reload();	
	}
}
function BAdd_Click() //���
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
  	if ((GetElementValue("ExType")!="")&&(GetElementValue("ExID")==""))
  	{
	  	alertShow("��������չID!")
	  	return
  	}
  	if (CheckInvalidData()) return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		messageShow("","","",t["03"])
		return
	}
	if (result>0)location.reload();	
}

function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("Desc") ;//����
  	combindata=combindata+"^"+GetElementValue("Code") ; //����
  	combindata=combindata+"^"+GetElementValue("Price") ; //����
  	combindata=combindata+"^"+GetElementValue("UnitDR") ; //��λ
  	combindata=combindata+"^"+GetElementValue("ExTypeDR") ; //��չ����
  	combindata=combindata+"^"+GetElementValue("ExID") ; //��չID
	combindata=combindata+"^"+GetElementValue("ExDesc") ; //��չDesc
	combindata=combindata+"^"+GetElementValue("PayPrice") ; //�ۼ�

    //add by sjh 2020-01-20 start
	combindata=combindata+"^^^^^"+GetElementValue("ChargeType") ; //�շ�����
	combindata=combindata+"^"+GetElementValue("ExpenseType") ; //ҽ������
	combindata=combindata+"^"+GetElementValue("AdditionRate") ; //�ӳ���
	combindata=combindata+"^"+GetElementValue("BillItemNo") ; //�շ���Ŀ���
	combindata=combindata+"^"+GetElementValue("RegistrationNo") ; //ע��֤��
	combindata=combindata+"^"+GetElementValue("ExpenseRate") ; //ҽ����������
	combindata=combindata+"^"+GetElementValue("DisposableFlag") ; //�Ƿ�Ϊһ����
    //add by sjh 2020-01-20 end
  	return combindata;
}
///ѡ�����д����˷���
//Modify By QW 2018-10-10 HISUI���죺���ѡ���к󣬽����޷������������
///�����������index,rowdata�������������޸��ж��߼�
function SelectRowHandler(index,rowdata)
{
	if(index==SelectedRow)
    {
		Clear();	
		disabled(true)//�һ�
		SelectedRow=-1;	
		SetElement("RowID","");
		$('#tDHCEQCConsumableItem').datagrid('unselectAll');
		return;
	 }
	SelectedRow=index;
	SetData(rowdata.TRowID);//���ú���
	disabled(false);//���һ�
}

function Clear()
{
	SetElement("RowID","");  //add hly 2019-10-21 bug:1041273
	SetElement("Code","");
	SetElement("Desc","");
	SetElement("Price","")
	SetElement("Unit","");
	SetElement("UnitDR","");
	SetElement("ExType","");
	SetElement("ExTypeDR","");
	SetElement("ExID","");
	SetElement("ExDesc","");
	SetElement("PayPrice","")
	SetElement("IncItmID",""); //Add By QW20181029 �����:590106
	//add by sjh 2020-01-20 start
	SetElement("ChargeType","");
	SetElement("ExpenseType","");
	SetElement("AdditionRate","");
	SetElement("BillItemNo","");
	SetElement("RegistrationNo","");
	SetElement("ExpenseRate","");
	SetElement("DisposableFlag","");
	//add by sjh 2020-01-20 end
}
	
function SetData(rowid)
{
	if (rowid=="") return; //modified by ZY0248 2020-12-21
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"ת��Ϊ�س���
	var list=gbldata.split("^");

	SetElement("RowID",list[0]); //rowid
	SetElement("Desc",list[1]);
	SetElement("Code",list[2]);
	SetElement("UnitDR",list[4])
	SetElement("Price",list[3]);
	SetElement("ExTypeDR",list[5]);
	SetElement("ExID",list[6]);
	SetElement("ExDesc",list[8]);
	SetElement("Unit",list[21]); //modified by sjh SJH0031 2020-08-03
	SetElement("ExType",list[5]);
	SetElement("PayPrice",list[9]);
	//add by sjh 2020-01-20 start
	SetElement("ChargeType",list[14]);
	SetElement("ExpenseType",list[15]);
	SetElement("AdditionRate",list[16]);
	SetElement("BillItemNo",list[17]);
	SetElement("RegistrationNo",list[18]);
	SetElement("ExpenseRate",list[19]);
	SetElement("DisposableFlag",list[20]);
	//add by sjh 2020-01-20 end
}

function GetUnit(value) {
	var type=value.split("^");
	var obj=document.getElementById("UnitDR");
	obj.value=type[1];
}

function disabled(value)//�һ�
{
	InitEvent();
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
}
function condition()//����
{
	if (CheckMustItemNull()) return true;
	return false;
}
//Mozy0049	2011-3-30
function CheckInvalidData()
{
	if (IsValidateNumber(GetElementValue("Price"),1,1,0,1)==0)
	{
		alertShow("�����쳣,������.");
		//SetElement("Price","");
		return true;
	}
	return false;
}
//add by ZY  20140915 ZY0117
function GetIncItmInfo(value)
{
	var list=value.split("^");
	SetElement("Desc",list[0]);
	SetElement("Code",list[1]);
	SetElement("UnitDR",list[2])
	SetElement("Unit",list[3]);
	SetElement("Price",list[4]);
	SetElement("ExType",list[5]);
	SetElement("ExID",list[6]);
	SetElement("ExDesc",list[7]);
	SetElement("ExTypeDR",list[5]);
	
}
//����ҳ����ط���
document.body.onload = BodyLoadHandler;
