var SelectedRow = -1;///Modify By QW 2018-09-29 HISUI����
var rowid=0;
//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler()
{
	initButtonWidth();///Add By QW 2018-09-29 HISUI����:�޸İ�ť����
	setButtonText();///Add By QW 2018-09-29 HISUI����:��ť���ֹ淶
	InitUserInfo();
	InitEvent();	//��ʼ��
	KeyUp("Model^Unit^ServiceItem^ConsumableItem^ServDetItem^StoreLoc^SourceID");	//modified by ZY0282 20211110
	disabled(true);//�һ�
	Muilt_LookUp("Model^Unit^ServiceItem^ConsumableItem^ServDetItem^CycleUnit^StoreLoc^SourceID");	//modified by ZY0282 20211110
	SetElement("SourceType",GetElementValue("SourceTypeDR"));
	SetElement("QuantityType",GetElementValue("QuantityTypeDR"))
	EnableModel();
	fillData();
	TypeSelect();  //Modefied by zc 2014-11-04 zc0019
	//hisui����:��ʼ����Դ������ add by QW 2018-09-29
	if (GetElementValue("SourceTypeDR")==1)
	{
		singlelookup("SourceID","EM.L.Equip","",GetSourceID) 
	}else
	{
		singlelookup("SourceID","EM.L.GetMasterItem","",GetSourceID);
	}
	 //hisui����:��ʼ����Դ������ End by QW 2018-09-29
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
	val=val+"service=ServiceItem="+GetElementValue("ServiceItemDR")+"^";
	val=val+"consumableitem=ConsumableItem="+GetElementValue("ConsumableItemDR")+"^";
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
	//hisui����:�Ŵ����غ󴥷� add by QW 2018-09-29 
	$('#ConsumableItem').lookup('options').onHidePanel= function(){
		ConsumableItem_change();
	};
	///add by QW 2018-10-08 ������hisui���� ����/�ſ��Ŵ�
	$('#CycleUnit').lookup('options').onBeforeShowPanel= function(){
 			return $("#CycleUnit").lookup('options').hasDownArrow
	};
	
	///add by QW 2018-10-08 ������hisui���� ����/�ſ��Ŵ�
	$('#ServiceItem').lookup('options').onBeforeShowPanel= function(){
 			return $("#ServiceItem").lookup('options').hasDownArrow
	};
	
	///add by QW 2018-10-08 ������hisui���� ����/�ſ��Ŵ�
	$('#ServDetItem').lookup('options').onBeforeShowPanel= function(){
 			return $("#ServDetItem").lookup('options').hasDownArrow
	};
	
	///add by QW 2018-10-08 ������hisui���� ����/�ſ��Ŵ�
	$('#Unit').lookup('options').onBeforeShowPanel= function(){
 			return $("#Unit").lookup('options').hasDownArrow
	};
}

function ConsumableItem_change()
{
	SetElement("ConsumableItem","");      //modified by czf 386488
	SetElement("ConsumableItemDR","");
	SetElement("Unit","");
	SetElement("UnitDR","");
}

function SourceType_change() 
{
	SetElement("SourceTypeDR",GetElementValue("SourceType"))
	EnableModel()
	SetElement("SourceID","")
	SetElement("SourceIDDR","");
	SetElement("Model","");
	SetElement("ModelDR","");
}
///add by QW 2018-09-29 
///��������Ԫ�ز�����״̬δ�һ�
function EnableModel()
{
	if ((GetElementValue("SourceType")==1)||(GetElementValue("SourceType")==""))
	{
		///add by QW 2018-10-08 ������hisui���� ����/�ſ��Ŵ�
		$("#Model").lookup({hasDownArrow:false,readonly:true})
	}
	if (GetElementValue("SourceType")==2)
	{
		///add by QW 2018-10-08 ������hisui���� ����/�ſ��Ŵ�
		$("#Model").lookup({hasDownArrow:true,readonly:false})
	}
}

///add by QW 2018-09-29 
///������hisui���� ���������б����¶����豸����������
 $("#SourceType").combobox({
    onChange: function () {
	    SourceType = $("#SourceType").combobox('getValue');
	    SetElement("SourceTypeDR",GetElementValue("SourceType"))
	    if (SourceType==1){  
			singlelookup("SourceID","EM.L.Equip","",GetSourceID);
		}
		else if (SourceType==2)
		{
			singlelookup("SourceID","EM.L.GetMasterItem","",GetSourceID);
		}
    }
    ,onSelect: function () {SourceType_change();}
 })
///add by QW 2018-09-29 
///������hisui���� �����б�onchange�¼�����
 $('#Type').combobox({
    onSelect: function () {
	   TypeSelect();
    }
 })

///add by QW 2018-09-29 
///������hisui���� �����б�onchange�¼�����
 $('#QuantityType').combobox({
    onSelect: function () {
	   QuantityType_change();
    }
 })


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
	if (CheckInvalidData()) return;
	if (CheckTypeSelect())  return;  //Modefied by zc 2014-11-04 zc0019
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,'','',plist,'2','0');
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
	if (CheckInvalidData()) return;
	if (CheckTypeSelect())  return;   //Modefied by zc 2014-11-04 zc0019
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,'','',plist,'2','0');
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
    combindata=GetElementValue("RowID");
	combindata=combindata+"^"+GetElementValue("SourceTypeDR");//��Դ����
  	combindata=combindata+"^"+GetElementValue("SourceIDDR"); //��Դ��
  	combindata=combindata+"^"+GetElementValue("ServiceItemDR"); //����
  	combindata=combindata+"^"+GetElementValue("ConsumableItemDR"); //����
  	combindata=combindata+"^"+GetElementValue("UnitDR"); //��λ
  	combindata=combindata+"^"+GetElementValue("Quantity"); //����
  	combindata=combindata+"^"+GetElementValue("ModelDR"); //����
  	combindata=combindata+"^"+GetElementValue("QuantityTypeDR"); //��������
  	combindata=combindata+"^"+GetElementValue("ServDetItemDR"); //ϸ��Ŀ
  	combindata=combindata+"^"+GetElementValue("MonthStatFlag"); 
  	combindata=combindata+"^"+GetElementValue("CycleNum"); //ά������
  	combindata=combindata+"^"+GetElementValue("CycleUnitDR");
  	combindata=combindata+"^"+GetElementValue("Type"); //����
  	combindata=combindata+"^"+GetElementValue("Hold1") ;	//SICSubType
	combindata=combindata+"^"+GetElementValue("Hold2") ;	//SICSubKey
	combindata=combindata+"^"+GetElementValue("StoreLocDR") ;	//StoreLocDR  ԭHold3
	combindata=combindata+"^"+GetElementValue("Hold4") ;
	combindata=combindata+"^"+GetElementValue("Hold5") ;
	combindata=combindata+"^"+GetElementValue("BussType") ; //add by sjh 2020-01-20
  	return combindata;
}
///ѡ�����д����˷���
//Modify By QW 2018-09-29 HISUI���죺���ѡ���к󣬽����޷������������
///�����������index,rowdata�������������޸��ж��߼�
function SelectRowHandler(index,rowdata)
{
	if(index==SelectedRow)
    {
		Clear();	
		disabled(true)//�һ�
		SelectedRow=-1;	
		SetElement("RowID","");
		$('#tDHCEQCServiceConsumable').datagrid('unselectAll');
		return;
	 }
	SelectedRow=index;
	SetData(rowdata.TRowID);//���ú���
	disabled(false);//���һ�
}

function Clear()
{
	SetElement("RowID","");  //add hly 2019-10-21 bug:1041273
	SetElement("SourceType","");
	SetElement("SourceTypeDR","");
	SetElement("SourceID","")
	SetElement("SourceIDDR","");
	SetElement("Model","");
	SetElement("ModelDR","");
	SetElement("ServiceItem","");
	SetElement("ServiceItemDR","");
	SetElement("Unit","");
	SetElement("UnitDR","");
	SetElement("ConsumableItem","");
	SetElement("ConsumableItemDR","");
	SetElement("Quantity","");
	// Mozy	2010-11-22
	SetElement("ServDetItemDR","");		// ϸ��
	SetElement("ServDetItem","");
	SetElement("QuantityTypeDR","");	// ��������
	SetElement("QuantityType","");
	SetElement("Type","");    //Modefied by zc 2014-11-04 zc0019 begin
	SetElement("TypeDR","");
	SetElement("CycleUnit","");
	SetElement("CycleUnitDR","");
	SetElement("CycleNum","");
	SetElement("MonthStatFlag","");   //Modefied by zc 2014-11-04 zc0019  end
	SetElement("BussType","");//add by sjh 2020-01-20
	SetElement("StoreLocDR","");	//czf 1915092
	SetElement("StoreLoc","");
}
	
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"ת��Ϊ�س���
	var list=gbldata.split("^");
	///modified by ZY0237 ��ṹ�������ֶΣ�Ԫ��ȡֵҲҪ����һ��䡣
	SetElement("RowID",list[0]); //rowid
	SetElement("SourceTypeDR",list[1]);
	SetElement("SourceIDDR",list[2]);
	SetElement("ServiceItemDR",list[3]);
	SetElement("ConsumableItemDR",list[4]);
	SetElement("UnitDR",list[5]);
	SetElement("Quantity",list[6]);
	SetElement("ModelDR",list[7]);
	SetElement("SourceType",list[1]);
	SetElement("SourceID",list[21]);
	SetElement("ServiceItem",list[22]);
	SetElement("ConsumableItem",list[23]);
	SetElement("Unit",list[24]);
	SetElement("Model",list[25]);
	EnableModel();
	// Mozy	2010-11-22
	SetElement("QuantityTypeDR",list[8]);	// ��������
	SetElement("QuantityType",list[8]);
	SetElement("ServDetItemDR",list[9]);	// ϸ��
	SetElement("ServDetItem",list[27]);
	SetElement("MonthStatFlag",list[10]);   //Modefied by zc 2014-11-04 zc0019  begin
	SetElement("CycleNum",list[11]);
	SetElement("CycleUnitDR",list[12]);
	SetElement("CycleUnit",list[28]);
	SetElement("Type",list[13]);   //Modefied by zc 2014-11-04 zc0019  end
	SetElement("BussType",list[19]); //BussType  add by sjh 2020-01-20
	SetElement("StoreLocDR",list[16]);	//czf 1915092
	SetElement("StoreLoc",list[29]);
	EnableUnit();
	TypeSelect();   //Modefied by zc 2014-11-04 zc0019
}

function GetServiceItem(value)
{
	var type=value.split("^");
	var obj=document.getElementById("ServiceItemDR");
	obj.value=type[1];
}
///add by QW 2018-09-29 
///������hisui���� ���������б����¶����豸����������
function GetSourceID(item)
{
	SourceType = $("#SourceType").combobox('getValue')
	if(SourceType==1)
	{
		SetElement('SourceIDDR',item.TRowID)
		SetElement('SourceID',item.TName)
		// Add By Qw20181025 �����:725075
		SetElement("Model",item.TModel);
		SetElement("ModelDR",item.TModelDR);
		//End By Qw20181025 �����:725075
	}
	else if(SourceType==2)
	{
		SetElement('SourceIDDR',item.TRowID)
		SetElement('SourceID',item.TName)
	}
}

function GetModel(value)
{
	var type=value.split("^");
	var obj=document.getElementById("ModelDR");
	obj.value=type[1];
}

function GetUnit(value)
{
	var type=value.split("^");
	var obj=document.getElementById("UnitDR");
	obj.value=type[1];
}

function GetConsumableItem(value)
{
	var type=value.split("^");
	var obj=document.getElementById("ConsumableItemDR");
	obj.value=type[1];
	SetElement("UnitDR",type[3]);
	SetElement("Unit",type[5]);
}
// Mozy	2010-11-19
function GetServDetItem(value)
{
	var type=value.split("^");
	var obj=document.getElementById("ServDetItemDR");
	obj.value=type[1];
}
///add by QW 2018-09-29 
///��������Ԫ�ز�����״̬δ�һ�
function EnableUnit()
{
	// ������
	if ((GetElementValue("QuantityType")==1)||(GetElementValue("QuantityType")==""))
	{
		///add by QW 2018-10-08 ������hisui���� ����/�ſ��Ŵ�
		$("#Unit").lookup({hasDownArrow:true,readonly:false}) //Modified By QW20181024 �����:725075
	}
	// �����
	if (GetElementValue("QuantityType")==2)
	{
		///add by QW 2018-10-08 ������hisui���� ����/�ſ��Ŵ�
		$("#Unit").lookup({hasDownArrow:false,readonly:true})
	}
	SetElement("QuantityTypeDR",GetElementValue("QuantityType"))
}
function QuantityType_change()
{
	EnableUnit();
	//modified by ZY0282 20211110
	//SetElement("Unit","");
	//SetElement("UnitDR","");
}
//Modefied by zc 2014-11-04 zc0019
function TypeSelect()
{
	var Type=GetElementValue("Type");
	if(Type=="1")  //ʹ��
	{
		///add by QW 2018-10-29 �����:719198
		$("#MonthStatFlag").checkbox("disable");
		SetElement("MonthStatFlag","");
		DisableElement("CycleNum",true);
		///add by QW 2018-10-08 ������hisui���� ����/�ſ��Ŵ�
		$("#CycleUnit").lookup({hasDownArrow:false,readonly:true})
		///add by QW 2018-10-08 ������hisui���� ����/�ſ��Ŵ�
		$("#ServiceItem").lookup({hasDownArrow:true,readonly:false,disable:false})
		///add by QW 2018-10-08 ������hisui���� ����/�ſ��Ŵ�
		$("#ServDetItem").lookup({hasDownArrow:true,readonly:false,disable:false})
	}
	else if(Type=="2")  //�ʿ�
	{
		///add by QW 2018-10-29 �����:719198
		$("#MonthStatFlag").checkbox("enable");
		SetElement("MonthStatFlag","Y");
		DisableElement("CycleNum",false);
		///add by QW 2018-10-08 ������hisui���� ����/�ſ��Ŵ�
		$("#CycleUnit").lookup({hasDownArrow:true,readonly:false})
		///add by QW 2018-10-08 ������hisui���� ����/�ſ��Ŵ�
		$("#ServiceItem").lookup({hasDownArrow:false,readonly:true,disable:true})
		///add by QW 2018-10-08 ������hisui���� ����/�ſ��Ŵ�
		$("#ServDetItem").lookup({hasDownArrow:false,readonly:true,disable:true})
	}
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
	if (!GetElementValue("MonthStatFlag"))
	{
		if ((GetElementValue("ServiceItemDR")=="")&&(GetElementValue("ServDetItemDR")==""))
		{
			messageShow("","","",t["04"]);
			return true;
		}
	}
	if ((GetElementValue("QuantityType")==1)&&(GetElementValue("UnitDR")==""))
	{
		alertShow("���������ݵĵ�λ����Ϊ��!");
		return true;
	}
	return false;
}
function CheckInvalidData()
{
	if (IsValidateNumber(GetElementValue("Quantity"),1,1,0,1)==0)		//czf 1915083 2021-05-22
	{
		alertShow("�����쳣,������.");
		//SetElement("Quantity","");
		return true;
	}
	return false;
}
//Modefied by zc 2014-11-04 zc0019
function CheckTypeSelect()
{
	var Type=GetElementValue("Type");
	if(Type==1)
	{
		if ((GetElementValue("ServiceItemDR")=="")&&(GetElementValue("ServDetItemDR")==""))      //modify by lmm 2017-03-25 353590
		{
			messageShow("","","",t["04"]);
			return true;
		}
	}
	if(Type==2)
	{
		if(GetElementValue("SourceType")=="")
		{
			alertShow("��Դ���Ͳ���Ϊ��");
			return true ;
		}
		if(GetElementValue("SourceID")=="")
		{
			alertShow("��Դ������Ϊ��");
			return true;
		}
		if(GetElementValue("CycleNum")=="")
		{
			alertShow("ά�����ڲ���Ϊ��");
			return true;
		}
		if(GetElementValue("CycleUnit")=="")
		{
			alertShow("���ڵ�λ����Ϊ��");
			return true;
		}
	}
	return false;
}
//add by zy 20141120 ZY0117
function GetCycleUnit(value) 
{
	GetLookUpID("CycleUnitDR",value);
}

function GetStoreLoc(value)
{
	GetLookUpID("StoreLocDR",value);
}
//����ҳ����ط���
document.body.onload = BodyLoadHandler;
