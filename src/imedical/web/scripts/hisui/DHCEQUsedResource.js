var SelectedRow = -1; ///Modify By QW 2018-10-11 HISUI����
var rowid=0;
//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() {
	initButtonWidth();///Add By QW 2018-10-11 HISUI����:�޸İ�ť����
	setButtonText();///Add By QW 2018-10-11 HISUI����:��ť���ֹ淶
	InitUserInfo();
	InitEvent();	//��ʼ��
	KeyUp("Model^Loc^ResourceType^Uom^SourceID");
	SetElement("SourceTypeDR",1);
	SetChkElement("IsInputFlag",1);	
	SetEnable();
	Muilt_LookUp("Model^Loc^ResourceType^Uom^SourceID");
	fillData();
}

function fillData()
{
	var vData=GetElementValue("vData")
	if (vData!="")
	{
		var list=vData.split("^");
		for (var i=1; i<list.length; i++)
		{
			Detail=list[i].split("=");
			SetElement(Detail[0],Detail[1]);
			if (Detail[0]=="IsInputFlag")
			{
				SetChkElement(Detail[0],Detail[1]);
			}
		}
	}
	var val="";
	if (GetElementValue("SourceTypeDR")==1)
	{
		val=val+"equip=SourceID="+GetElementValue("SourceIDDR")+"^";
	}
	else
	{
		val=val+"masteritem=SourceID="+GetElementValue("SourceIDDR")+"^";
	}
	val=val+"resourcetype=ResourceType="+GetElementValue("ResourceTypeDR")+"^";
	val=val+"dept=Loc="+GetElementValue("LocDR")+"^";
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
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Click;
	var obj=document.getElementById("BAudit");
	if (obj) obj.onclick=BAudit_Click;
	var obj=document.getElementById("BCancelSubmit");
	if (obj) obj.onclick=BCancelSubmit_Click;
	var obj=document.getElementById("BCancel");
	if (obj) obj.onclick=BCancel_Click;
	///Add By QW 2018-10-11 HISUI����:�Ŵ����غ󴥷�
	$('#ResourceType').lookup('options').onHidePanel= function(){
		ReSourceType_change();
	};
	var obj=document.getElementById("Price");
	if (obj) obj.onchange=changeAmount;
	var obj=document.getElementById("Quantity");
	if (obj) obj.onchange=changeAmount;
	///Add By QW 2018-10-11 HISUI����:�Ŵ����غ󴥷�
	$('#SourceID').lookup('options').onHidePanel= function(){
		SourceID_change();
	};
}

function SourceID_change()
{
	//SetElement("SourceID","")          //modified by DJ 400996
	SetElement("SourceIDDR","")
	SetElement("Loc","")
	SetElement("LocDR","")
	SetElement("ModelDR","")
	SetElement("Model","")
}

function BSubmit_Click()
{
	rowid=GetElementValue("RowID");
	var encmeth=GetElementValue("UsedResourceOper");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,'','',rowid,'1'); //1:�ύ?2?ȡ���ύ?3:���, 4:����
	result=result.replace(/\\n/g,"\n")
	if (result>0) location.reload();
}

function BCancelSubmit_Click()
{
	rowid=GetElementValue("RowID");
	var encmeth=GetElementValue("UsedResourceOper");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,'','',rowid,'2');
	result=result.replace(/\\n/g,"\n")
	if (result>0) location.reload();
}

function BAudit_Click()
{
	rowid=GetElementValue("RowID");
	var encmeth=GetElementValue("UsedResourceOper");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,'','',rowid,'3'); 
	result=result.replace(/\\n/g,"\n")
	if (result>0) location.reload();
}

function BCancel_Click()
{
	rowid=GetElementValue("RowID");
	var encmeth=GetElementValue("UsedResourceOper");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,'','',rowid,'4'); 
	result=result.replace(/\\n/g,"\n")
	if (result>0) location.reload();
}

function ReSourceType_change()
{
	SetElement("Uom","");
	SetElement("UomDR","");
	SetElement("Price","");
	SetElement("Amount","");
}
///Add By QW 2018-10-10 hisui�����������
function BFind_Click()
{
	var val="&vData="
	val=val+"^SourceTypeDR="+GetElementValue("SourceTypeDR");
	val=val+"^SourceIDDR="+GetElementValue("SourceIDDR");
	val=val+"^ResourceTypeDR="+GetElementValue("ResourceTypeDR");
	val=val+"^Year="+GetElementValue("Year");
	val=val+"^Month="+GetElementValue("Month");
	val=val+"^ModelDR="+GetElementValue("ModelDR");
	val=val+"^LocDR="+GetElementValue("LocDR");
	//Modified By QW20190528 �����:898628
	val=val+"^IsInputFlag="+GetChkElementValue("IsInputFlag");
	val=val+"&QXType="+GetElementValue("QXType");
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQUsedResource"+val;
	//End By QW20190528 �����:898628
}

function BClear_Click() 
{
	Clear();
	disabled(true);
}
function BDelete_Click() //ɾ��
{
	///modified by ZY0215 2020-04-02
	messageShow("confirm","","",t["-4003"],"",confirmFun,"")
}
///modified by ZY0215 2020-04-02
function confirmFun()
{
	rowid=GetElementValue("RowID");
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0) location.reload();	
}
function BUpdate_Click() //�޸�
{
	if (condition()) return;
	if (CheckInvalidData()) return;
	var curdate=new Date();
	var curyear=curdate.getFullYear();
	var curmonth=curdate.getMonth()+1;
	if ((GetElementValue("Year")<1900)||(GetElementValue("Year")>curyear))
	{
		alertShow("�����������!")
		return
	}
	if ((GetElementValue("Year")<curyear)&&((GetElementValue("Month")<=0)||(GetElementValue("Month")>12)))
	{
		alertShow("�·���������!")
		return
	}
	if ((GetElementValue("Year")==curyear)&&((GetElementValue("Month")<=0)||(GetElementValue("Month")>curmonth)))
	{
		alertShow("�·���������!")
		return
	}
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	changeAmount();
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,'','',plist);
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
	var curdate=new Date();
	var curyear=curdate.getFullYear();
	var curmonth=curdate.getMonth();
	if ((GetElementValue("Year")<1900)||(GetElementValue("Year")>curyear))
	{
		alertShow("�����������!")
		return
	}
	if ((GetElementValue("Year")<curyear)&&((GetElementValue("Month")<=0)||(GetElementValue("Month")>12)))
	{
		alertShow("�·���������!")
		return
	}
	if ((GetElementValue("Year")==curyear)&&((GetElementValue("Month")<=0)||(GetElementValue("Month")>curmonth)))
	{
		alertShow("�·���������!")
		return
	}
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	changeAmount();
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
    combindata=combindata+"^"+GetElementValue("Year") ;//��
    combindata=combindata+"^"+GetElementValue("Month") ;//��
	combindata=combindata+"^"+GetElementValue("SourceTypeDR") ;//��Դ����
  	combindata=combindata+"^"+GetElementValue("SourceIDDR") ; //��Դ��
  	combindata=combindata+"^"+GetElementValue("ResourceTypeDR") ; //��Դ
  	combindata=combindata+"^"+GetElementValue("Price") ; //����
  	combindata=combindata+"^"+GetElementValue("UomDR") ; //��λ
  	combindata=combindata+"^"+GetElementValue("Quantity") ; //����
  	combindata=combindata+"^"+GetElementValue("Amount") ; //���
  	combindata=combindata+"^"+GetElementValue("LocDR") ; //ʹ�ÿ���
  	combindata=combindata+"^"+GetElementValue("ModelDR") ; //����
  	combindata=combindata+"^"+GetElementValue("Remark") ; //��ע
  	combindata=combindata+"^"+GetChkElementValue("IsInputFlag") ; //�ֹ�¼���ʶ
  	return combindata;
}
///ѡ�����д����˷���
///Modify By QW 2018-10-11 HISUI���죺���ѡ���к󣬽����޷������������
///�����������index,rowdata�������������޸��ж��߼�
function SelectRowHandler(index,rowdata)
{
	if(index==SelectedRow)
    {
		Clear();	
		SetEnable();
		SelectedRow=-1;	
		SetElement("RowID","");
		$('#tDHCEQUsedResource').datagrid('unselectAll');
		return;
	 }
	SelectedRow=index;
	SetData(rowdata.TRowID);//���ú���
	SetEnable()//���һ�
}

function Clear()
{
	SetElement("RowID","")    //add hly 2019-10-15
	SetElement("SourceType","")
	SetElement("SourceTypeDR",1);
	SetElement("SourceID","")
	SetElement("SourceIDDR","");
	SetElement("Model","");
	SetElement("ModelDR","");
	SetElement("ResourceType","");
	SetElement("ResourceTypeDR","");
	SetElement("Remark","");
	SetElement("Uom","");
	SetElement("UomDR","");
	SetElement("Price","");
	SetElement("Amount","");
	SetElement("Quantity","");
	SetElement("Year","");
	SetElement("Month","");
	SetElement("Loc","");
	SetElement("LocDR","");
	SetElement("Status","");
	SetChkElement("IsInputFlag",1);
}
	
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	if (rowid=="") return;  //Add By QW20181029 �����:598737
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"ת��Ϊ�س���
	var list=gbldata.split("^");
	var flag=list[30]
	if (flag=="Y")
	{
		flag=1
	}
	else
	{
		flag=0
	}
	SetElement("RowID",list[0]); //rowid
	SetElement("Year",list[1]);
	SetElement("Month",list[2]);
	SetElement("SourceTypeDR",list[3]);
	SetElement("SourceIDDR",list[4]);
	SetElement("ResourceTypeDR",list[5])
	SetElement("Price",list[6]);
	SetElement("UomDR",list[7]);
	SetElement("Quantity",list[8]);
	SetElement("Amount",list[9]);
	SetElement("LocDR",list[10]);
	SetElement("ModelDR",list[14]);	
	SetElement("Status",list[18]);
	SetElement("Remark",list[29]);
	SetChkElement("IsInputFlag",flag);
	SetElement("SourceID",list[37]);
	SetElement("ResourceType",list[38])
	SetElement("Uom",list[39]);
	SetElement("Loc",list[40]);
	SetElement("Model",list[42]);
}

function SetEnable()
{
	InitEvent();
	if (GetElementValue("Status")=="")
	{
		DisableBElement("BAdd",false)
		DisableBElement("BUpdate",true)
		DisableBElement("BDelete",true)	
		DisableBElement("BAudit",true)
		DisableBElement("BSubmit",true)
		DisableBElement("BCancel",true)
		DisableBElement("BCancelSubmit",true)
	}
	if (GetElementValue("Status")=="0")
	{
		DisableBElement("BAdd",true)
		DisableBElement("BUpdate",false)
		DisableBElement("BDelete",false)	
		DisableBElement("BAudit",true)
		DisableBElement("BSubmit",false)
		DisableBElement("BCancel",true)
		DisableBElement("BCancelSubmit",true)
	}
	if (GetElementValue("Status")=="1")
	{
		DisableBElement("BAdd",true)
		DisableBElement("BUpdate",true)
		DisableBElement("BDelete",true)	
		DisableBElement("BSubmit",true)
		DisableBElement("BAudit",false)
		DisableBElement("BCancel",true)
		DisableBElement("BCancelSubmit",false)
	}
	if (GetElementValue("Status")=="2")
	{
		DisableBElement("BUpdate",true)
		DisableBElement("BDelete",true)	
		DisableBElement("BAdd",true)
		DisableBElement("BAudit",true)
		DisableBElement("BSubmit",true)
		DisableBElement("BCancelSubmit",true)
		DisableBElement("BCancel",false)
	}
	if ((GetElementValue("Status")=="3")||(GetChkElementValue("IsInputFlag")==false))
	{
		DisableBElement("BUpdate",true)
		DisableBElement("BDelete",true)	
		DisableBElement("BAdd",true)
		DisableBElement("BAudit",true)
		DisableBElement("BSubmit",true)
		DisableBElement("BCancel",true)
		DisableBElement("BCancelSubmit",true)
	}
}

function GetSourceID(value) {
	var type=value.split("^");
	var obj=document.getElementById("SourceIDDR");
	obj.value=type[1];
	SetElement("LocDR",type[5]);
	SetElement("Loc",type[2]);
	SetElement("ModelDR",type[6]);
	SetElement("Model",type[7]);
}

function GetModel(value) {
	var type=value.split("^");
	var obj=document.getElementById("ModelDR");
	obj.value=type[1];
}

function GetResourceType(value)
{
	var type=value.split("^");
	var obj=document.getElementById("ResourceTypeDR");
	obj.value=type[1];
	SetElement("Uom",type[6]);
	SetElement("UomDR",type[5]);
	SetElement("Price",type[4]);
	changeAmount()
}

function GetLoc(value) {
	var type=value.split("^");
	var obj=document.getElementById("LocDR");
	obj.value=type[1];
}

function GetUom(value) {
	var type=value.split("^");
	var obj=document.getElementById("UomDR");
	obj.value=type[1];
}

function disabled(value)//�һ�
{
	InitEvent();
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
	DisableBElement("BAudit",value)
	DisableBElement("BSubmit",value)
	DisableBElement("BCancel",value)
	DisableBElement("BCancelSubmit",value)
}
function condition()//����
{
	if (CheckMustItemNull()) return true;
	return false;
}
function CheckInvalidData()
{
	if (IsValidateNumber(GetElementValue("Price"),1,1,0,1)==0)
	{
		alertShow("���������쳣,������.");
		//SetElement("Price","");
		return true;
	}
	if (IsValidateNumber(GetElementValue("Quantity"),1,0,0,1)==0)
	{
		alertShow("�����쳣,������.");
		//SetElement("Quantity","");
		return true;
	}
	return false;
}
function changeAmount()
{
	//������
	var Quantity=GetElementValue("Quantity")
	if (Quantity=="")
	{
		Quantity=0
	}
	var Price=GetElementValue("Price")
	if (Price=="")
	{
		Price=0
	}
	SetElement("Amount",accMul(Quantity,Price))  //add hly 2019-10-21 bug:1043038
}
//add hly 2019-10-21 bug:1043038
function accMul(arg1,arg2)
{
  var m=0,s1=arg1.toString(),s2=arg2.toString();
  try{m+=s1.split(".")[1].length}catch(e){}
  try{m+=s2.split(".")[1].length}catch(e){}
  return Number(s1.replace(".",""))*Number(s2.replace(".",""))/Math.pow(10,m)
}
//����ҳ����ط���
document.body.onload = BodyLoadHandler;
