var SelectedRow = -1; ///Modify By QW 2018-10-08 HISUI����
var rowid=0;
//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() {
	initButtonWidth();///Add By QW 2018-10-08 HISUI����:�޸İ�ť����
	setButtonText();///Add By QW 2018-10-08 HISUI����:��ť���ֹ淶
	InitUserInfo();
	InitEvent();	//��ʼ��
	KeyUp("Unit");
	disabled(true);//�һ�
	Muilt_LookUp("Unit");
	SetElement("ExType",GetElementValue("ExTypeDR"));
	changeExDesc();
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
	//hisui����:�Ŵ����غ󴥷� add by QW 2018-10-08 
	$('#ExDesc').lookup('options').onHidePanel= function(){
		ExDesc_Click();
	};
	///add by QW 2018-10-08 ������hisui���� ����/�ſ��Ŵ�
	$('#ExDesc').lookup('options').onBeforeShowPanel= function(){
 			return $("#ExDesc").lookup('options').hasDownArrow
	};

}
///add by QW 2018-10-08 
///������hisui���� �����б�onchange�¼�����
 $('#ExType').combobox({
    onChange: function () {
	   ExType_change();
    }
 })

function ExDesc_Click()
{
	if (GetElementValue("ExType")=="DHC-HIS")
	{
		///add by QW 2018-10-08
		///������hisui���� ����/�ſ��Ŵ�
		/// Modified BY QW20181029 �����:590075
		$("#ExDesc").lookup({hasDownArrow:true,disable:false})
	}
}


function ExType_change()
{
	SetElement("ExTypeDR",GetElementValue("ExType"));
	changeExDesc();
	SetElement("ExID","");
	SetElement("ExDesc","");
}

function changeExDesc()
{
	if ((GetElementValue("ExType")=="DHC-LIS")||(GetElementValue("ExType")=="DHC-RIS"))
	{
		DisableElement("ExType",true)
		///add by QW 2018-10-08 
		///������hisui���� ����/�ſ��Ŵ�
		$("#ExDesc").lookup({hasDownArrow:false,disable:true}) 
	}
	if (GetElementValue("ExType")=="DHC-HIS")
	{
		DisableElement("ExType",false)
		///add by QW 2018-10-08 
		///������hisui���� ����/�ſ��Ŵ�
		$("#ExDesc").lookup({hasDownArrow:true,disable:false})
	}
	if (GetElementValue("ExType")=="")
	{
		DisableElement("ExType",false)
		///add by QW 2018-10-08 
		///������hisui���� ����/�ſ��Ŵ�
		$("#ExDesc").lookup({hasDownArrow:false,disable:false})
	}
}
///Add By QW 2018-10-08 hisui�����������
function BFind_Click()
{
	var val="&Code="+GetElementValue("Code");
	val=val+"&Desc="+GetElementValue("Desc");
	val=val+"&ExTypeDR="+GetElementValue("ExTypeDR");
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCServiceItem"+val;
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
	if (CheckInvalidData()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
  	if ((GetElementValue("ExType")!="")&&(GetElementValue("ExID")==""))
  	{
	  	alertShow("��ѡ����չ����!")
	  	return
  	}
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n")
	//modified by ZY0286 ����ֵ����
	if (result>0)
	{
		//add by HHM 20150910 HHM0013
		//��Ӳ����ɹ��Ƿ���ʾ
		ShowMessage();
		//****************************
		location.reload();	
	}
	else
	{
		///modified by ZY0257 20210325
		if(result=="-1001") 
		{
			messageShow("","","",t[-1001]);
			return
		}
		else
		{
			messageShow("","","",t["03"]);
			return
		}
	}
}
function BAdd_Click() //���
{
	if (condition()) return;
	if (CheckInvalidData()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
  	if ((GetElementValue("ExType")!="")&&(GetElementValue("ExID")==""))
  	{
	  	alertShow("��ѡ����չ����!")
	  	return
  	}
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n")
	//modified by ZY0286 ����ֵ����
	if (result>0)
	{
		//add by HHM 20150910 HHM0013
		//��Ӳ����ɹ��Ƿ���ʾ
		ShowMessage();
		//****************************
		location.reload();	
	}
	else
	{
		alertShow("������Ϣ:"+t[result]);
		return
	}
}

function CombinData()
{
	var combindata="";
	///modified by ZY0257 20210325
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("Desc") ;//����
  	combindata=combindata+"^"+GetElementValue("Code") ; //����
  	combindata=combindata+"^"+GetElementValue("UnitDR") ; //��λ
  	combindata=combindata+"^"+GetElementValue("Price") ; //����
  	combindata=combindata+"^"+GetElementValue("ExType") ; //��չ����
  	combindata=combindata+"^"+GetElementValue("ExID") ; //��չID
  	combindata=combindata+"^"+GetElementValue("Remark") ; //��չID
  	combindata=combindata+"^"+GetElementValue("ImportFlag") ; //�����ʶ///modified by ZY0257 20210325
  	combindata=combindata+"^"+GetElementValue("MinMinutes") ; //��С������
  	combindata=combindata+"^"+GetElementValue("MinutesPerTimes") ; //ÿ�η�����
  	combindata=combindata+"^"+GetElementValue("MaxMinutes") ; //��������
  	combindata=combindata+"^^^"+GetElementValue("ExDesc") ; //��չ����
	///modified by ZY0257 20210325
  	var SingleFlag=getElementValue("SingleFlag")
  	if (SingleFlag==false)
  	{
	  	SingleFlag="N"
	}
	else
	{
	  	SingleFlag="Y"
	}
  	combindata=combindata+"^"+SingleFlag; //��һʹ��
  	return combindata;
}
///ѡ�����д����˷���
//Modify By QW 2018-10-08 HISUI���죺���ѡ���к󣬽����޷������������
///�����������index,rowdata�������������޸��ж��߼�
function SelectRowHandler(index,rowdata)
{
	if(index==SelectedRow)
    {
		Clear();	
		disabled(true)//�һ�
		SelectedRow=-1;	
		SetElement("RowID","");
		$('#tDHCEQCServiceItem').datagrid('unselectAll');
		return;
	 }
	SelectedRow=index;
	SetData(rowdata.TRowID);//���ú���
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
	SetElement("ExTypeDR","");     //modified by czf 386456
	SetElement("ExID","");
	SetElement("Remark","");
	SetElement("MinMinutes","");
	SetElement("MinutesPerTimes","");
	SetElement("MaxMinutes","");
	SetElement("ImportFlag",0);	///modified by ZY0257 20210325
	SetElement("ExDesc","");
	setElement("SingleFlag",0);	///modified by ZY0257 20210325
	changeExDesc();
}
	
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"ת��Ϊ�س���
	var list=gbldata.split("^");
	var flag=list[8]
	if (flag=="Y")
	{
		flag=1
		DisableElement("ExType",true)
		DisableBElement("BAdd",true)
		DisableBElement("BUpdate",false)
		DisableBElement("BDelete",true)
		///add by QW 2018-10-08 
		///������hisui���� ����/�ſ��Ŵ�
		/// Modified BY QW20181029 �����:590075
		$("#ExDesc").lookup({hasDownArrow:false,disable:true})
		///modified by ZY0257 20210325
		disableElement("Code",true)
		disableElement("Desc",true)
		disableElement("Price",true)
		disableElement("Unit",true)
		disableElement("ExDesc",true)
	}
	else
	{

		if ((list[5]=="DHC-HIS")||(list[5]==""))
		{
			DisableElement("ExType",false)
			DisableBElement("BAdd",true)
			DisableBElement("BUpdate",false)
			DisableBElement("BDelete",false)
			///add by QW 2018-10-08 
			///������hisui���� ����/�ſ��Ŵ�
			/// Modified BY QW20181029 �����:590075
			$("#ExDesc").lookup({hasDownArrow:true,disable:false})
			///modified by ZY0257 20210325
			disableElement("Code",false)
			disableElement("Desc",false)
			disableElement("Price",false)
			disableElement("Unit",false)
			disableElement("ExDesc",false)
		}
		else
		{
			DisableElement("ExType",true)
			DisableBElement("BAdd",true)
			DisableBElement("BUpdate",true)
			DisableBElement("BDelete",true)
			///add by QW 2018-10-08 
		    ///������hisui���� ����/�ſ��Ŵ�
		    /// Modified BY QW20181029 �����:590075
			$("#ExDesc").lookup({hasDownArrow:false,disable:true})
		}
		flag=0
	}
	SetElement("RowID",list[0]); //rowid
	SetElement("Desc",list[1]);
	SetElement("Code",list[2]);
	SetElement("UnitDR",list[3])
	SetElement("Price",list[4]);
	SetElement("ExType",list[5]);
	SetElement("ExTypeDR",list[5]);   //add by mwz 2017-11-17�����468808
	SetElement("ExID",list[6]);
	SetElement("Remark",list[7]);
	SetElement("ImportFlag",list[8]);	///modified by ZY0257 20210325
	SetElement("MinMinutes",list[9]);
	SetElement("MinutesPerTimes",list[10]);
	SetElement("MaxMinutes",list[11]);
	///modified by ZY0257 20210325
	SetElement("ExDesc",list[14]);
	setElement("SingleFlag",list[15]);	///modified by ZY0257 20210325
	SetElement("Unit",list[16]);	///modified by ZY0259 20210420
	
	InitEvent();
}

function GetUnit(value) {
	var type=value.split("^");
	var obj=document.getElementById("UnitDR");
	obj.value=type[1];
}

//modified by ZY0286
function disabled(value)//�һ�
{
	InitEvent();
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
	///modified by ZY0257 20210325
	disableElement("Code",!value)
	disableElement("Desc",!value)
	disableElement("Price",!value)
	disableElement("Unit",!value)
	DisableElement("ExType",!value)
	disableElement("ExDesc",!value)
	if (value==true)
	{
		var obj=document.getElementById("BAdd");
		if (obj) obj.onclick=BAdd_Click;
		//hisui����:�Ŵ����غ󴥷� add by QW 2018-10-08 
		$('#ExDesc').lookup('options').onHidePanel= function(){
			ExDesc_Click();
		};
		///add by QW 2018-10-08 ������hisui���� ����/�ſ��Ŵ�
		$('#ExDesc').lookup('options').onBeforeShowPanel= function(){
	 			return $("#ExDesc").lookup('options').hasDownArrow
		};
	}
	else
	{
		var obj=document.getElementById("BUpdate");
		if (obj) obj.onclick=BUpdate_Click;
		var obj=document.getElementById("BDelete");
		if (obj) obj.onclick=BDelete_Click;
	}
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
function GetExDesc(value)
{
	var type=value.split("^");
	var obj=document.getElementById("ExDesc");
	obj.value=type[0];
	var obj=document.getElementById("ExID");
	obj.value=type[1];
}

//����ҳ����ط���
document.body.onload = BodyLoadHandler;
