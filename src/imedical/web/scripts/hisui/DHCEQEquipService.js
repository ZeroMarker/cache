var SelectedRow = -1; ///Modify By QW 2018-10-11 HISUI����
var rowid=0;
//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() {
	initButtonWidth();///Add By QW 2018-10-11 HISUI����:�޸İ�ť����
	setButtonText();///Add By QW 2018-10-11 HISUI����:��ť���ֹ淶
	InitUserInfo();
	InitEvent();	//��ʼ��
	KeyUp("Model^Service");
	disabled(true);//�һ�
	Muilt_LookUp("Model^Service");
	SetElement("SourceType",GetElementValue("SourceTypeDR"))
	EnableModel()
	fillData();
}

function fillData()
{
	var val="";
	if (GetElementValue("SourceTypeDR")==1)
	{
		val=val+"equip=SourceID="+GetElementValue("SourceIDDR")+"^";
	}
	else
	{
		val=val+"masteritem=SourceID="+GetElementValue("SourceIDDR")+"^";
	}
	val=val+"service=Service="+GetElementValue("ServiceDR")+"^";
	val=val+"model=Model="+GetElementValue("ModelDR");
	var encmeth=GetElementValue("GetDRDesc");
	var result=cspRunServerMethod(encmeth,val);
	var list=result.split("^");
	for (var i=1; i<list.length; i++)
	{
		var Detail=list[i-1].split("=");
		SetElement(Detail[0],Detail[1]);
	}
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
	//hisui����:�Ŵ󾵴���ǰ��Ӧ add by QW 2018-10-11 
	$('#Service').lookup('options').onBeforeShowPanel= function(){
		Service_change();
	};
	///add by QW 2018-10-11 ������hisui���� ����/�ſ��Ŵ�
	$('#Model').lookup('options').onBeforeShowPanel= function(){
 			return $("#Model").lookup('options').hasDownArrow
	};
}

///add by QW 2018-10-10
///������hisui���� �����б�onchange�¼�����
 $('#SourceType').combobox({
     onSelect:function () {
	   SourceType_change();
    },
     onChange:function () {
	   SourceID_Click();
    }
 })


function Service_change()
{
	SetElement("MinMinutes","");
	SetElement("MinutesPerTimes","");
	SetElement("MaxMinutes","");
	SetElement("ServiceDR","");
}

function SourceType_change()
{
	SetElement("SourceTypeDR",GetElementValue("SourceType"))
	EnableModel()
	SetElement("SourceID","")
	SetElement("SourceIDDR","");
	SetElement("Model","");
	SetElement("ModelDR","");
	SetElement("Service","");
	SetElement("ServiceDR","");
	SetElement("Remark","");
	SetElement("MinMinutes","");
	SetElement("MinutesPerTimes","");
	SetElement("MaxMinutes","");
}

function EnableModel()
{
	if ((GetElementValue("SourceType")==1)||(GetElementValue("SourceType")==""))
	{
		///add by QW 2018-10-10 ������hisui���� ����/�ſ��Ŵ�
		$("#Model").lookup({hasDownArrow:false,disable:true})
	}
	if (GetElementValue("SourceType")==2)
	{
		///add by QW 2018-10-10 ������hisui���� ����/�ſ��Ŵ�
		$("#Model").lookup({hasDownArrow:true,disable:false})
	}
}
///hisui����:�Ŵ󾵲��ܸ��ݲ�ͬ��ֵ���ò�ͬ��query Modified by QW 2018-10-11
function SourceID_Click()
{
	if (GetElementValue("SourceType")==1) //�豸
	{
		singlelookup("SourceID","EM.L.Equip","",GetSourceID);
	}
	if (GetElementValue("SourceType")==2) //�豸��
	{
		singlelookup("SourceID","EM.L.GetMasterItem","",GetSourceID);
	}
}

///Add By QW 2018-10-10 hisui�����������
function BFind_Click()
{
	var val="&SourceTypeDR="+GetElementValue("SourceTypeDR");
	val=val+"&SourceIDDR="+GetElementValue("SourceIDDR");
	val=val+"&ModelDR="+GetElementValue("ModelDR");
	val=val+"&ServiceDR="+GetElementValue("ServiceDR");
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQEquipService"+val;
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
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0) location.reload();	
}
function BUpdate_Click() //�޸�
{
	if (condition()) return;
	if (CheckInvalidData()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,plist);
	result=result.replace(/\\n/g,"\n")
	if(result=="") 
	{
	messageShow("","","",t["03"]);
	return
	}
	if (result>0) location.reload();	
}
function BAdd_Click() //���
{
	if (condition()) return;
	if (CheckInvalidData()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,plist,'2');
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
	combindata=combindata+"^"+GetElementValue("SourceTypeDR") ;//��Դ����
  	combindata=combindata+"^"+GetElementValue("SourceIDDR") ; //��Դ��
  	combindata=combindata+"^"+GetElementValue("ModelDR") ; //����
  	combindata=combindata+"^"+GetElementValue("ServiceDR") ; //����
  	combindata=combindata+"^"+GetElementValue("MinMinutes") ; //��С������
  	combindata=combindata+"^"+GetElementValue("MinutesPerTimes") ; //ÿ�η�����
  	combindata=combindata+"^"+GetElementValue("MaxMinutes") ; //��������  
  	combindata=combindata+"^"+GetElementValue("Remark") ; //��չID
  	return combindata;
}
///ѡ�����д����˷���
//Modify By QW 2018-10-11 HISUI���죺���ѡ���к󣬽����޷������������
///�����������index,rowdata�������������޸��ж��߼�
function SelectRowHandler(index,rowdata)
{
	if(index==SelectedRow)
    {
		Clear();	
		disabled(true)//�һ�
		SelectedRow=-1;	
		SetElement("RowID","");
		$('#tDHCEQEquipService').datagrid('unselectAll');
		return;
	 }
	SelectedRow=index;
	SetData(rowdata.TRowID);//���ú���
	disabled(false);//���һ�
}

function Clear()
{
	setElement("RowID","")  //add hly 2019-10-15
	SetElement("SourceType","");
	SetElement("SourceTypeDR","");
	SetElement("SourceID","")
	SetElement("SourceIDDR","");
	SetElement("Model","");
	SetElement("ModelDR","");
	SetElement("Service","");
	SetElement("ServiceDR","");
	SetElement("Remark","");
	SetElement("MinMinutes","");
	SetElement("MinutesPerTimes","");
	SetElement("MaxMinutes","");
}
	
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"ת��Ϊ�س���
	var list=gbldata.split("^");
	SetElement("RowID",list[0]); //rowid
	SetElement("SourceTypeDR",list[1]);
	SetElement("SourceIDDR",list[2]);
	SetElement("ModelDR",list[3])
	SetElement("ServiceDR",list[4]);
	SetElement("MinMinutes",list[5]);
	SetElement("MinutesPerTimes",list[6]);
	SetElement("MaxMinutes",list[7]);	
	SetElement("Remark",list[8]);
	SetElement("SourceType",list[1]);
	SetElement("SourceID",list[11]);
	SetElement("Model",list[12])
	SetElement("Service",list[13]);
	EnableModel()
}

function GetService(value) {
	var type=value.split("^");
	var obj=document.getElementById("ServiceDR");
	obj.value=type[1];
	SetElement("MinMinutes",type[5]);
	SetElement("MinutesPerTimes",type[6]);
	SetElement("MaxMinutes",type[7]);
}
///add by QW 2018-10-11
///������hisui���� ���������б����¶����豸����������
function GetSourceID(item) {
	SourceType = $("#SourceType").combobox('getValue')
	if(SourceType==1)
	{
		SetElement('SourceIDDR',item.TRowID)
		SetElement('SourceID',item.TName)
		// Add By Qw20181025 �����:725075
		SetElement('Model',item.TModel)
		SetElement('ModelDR',item.TModelDR)
		//End By Qw20181025 �����:725075
	}
	else if(SourceType==2)
	{
		SetElement('SourceIDDR',item.TRowID)
		SetElement('SourceID',item.TName)
	}
}

function GetModel(value) {
	var type=value.split("^");
	var obj=document.getElementById("ModelDR");
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
function CheckInvalidData()
{
	if (IsValidateNumber(GetElementValue("MinMinutes"),1,0,0,1)==0)
	{
		alertShow("��С�������쳣,������.");
		//SetElement("MinMinutes","");
		return true;
	}
	if (IsValidateNumber(GetElementValue("MaxMinutes"),1,0,0,1)==0)
	{
		alertShow("���������쳣,������.");
		//SetElement("MaxMinutes","");
		return true;
	}
	if (IsValidateNumber(GetElementValue("MinutesPerTimes"),1,0,0,1)==0)
	{
		alertShow("ÿ�η������쳣,������.");
		//SetElement("MinutesPerTimes","");
		return true;
	}
	return false;
}
//����ҳ����ط���
document.body.onload = BodyLoadHandler;
