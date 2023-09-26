// DHCEQCUserRole.js
var SelectedRow = -1;
var SelectRow = 0;
var rowid=0;
var rows;
function BodyLoadHandler()
{
	initButtonWidth()  //hisui���� add by kdf 2018-10-16
	InitUserInfo();
	InitEvent();
	disabled(true);
//add by HHM 20150909 HHM0014
//���ƶ�����־�����۱�־Ĭ��ѡ��
	SetChkElement("IndependentFlag",1);
	SetChkElement("EvaluationFlag",1);
}
function InitEvent()
{
	var obj=document.getElementById("EvaluationOrder");
	if (obj) obj.onchange=EvaluationOrder_Change;
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	
//add by HHM 20150901 HHM0014
//��Ӹ�ѡ��ѡ�����
//*******************************************
	var obj=document.getElementById("MPEvaluationFlag");
	if (obj) obj.onclick=MPEvaluationFlage_CheckClick;
	var obj=document.getElementById("IndependentFlag");
	if (obj) obj.onclick=IndependentFlag_CheckClick;
//************************************************
	Muilt_LookUp("SourceType^Role^EquipType^Hospital");
	KeyUp("SourceType^Role^EquipType^Hospital","N");
}
function EvaluationOrder_Change()
{
	var EvaluationOrder=GetElementValue("EvaluationOrder");
	if (!(parseInt(EvaluationOrder)==EvaluationOrder))
  	{
   		 alertShow("����˳������д����");
   		 SetElement("EvaluationOrder","");
   		 return;
  	}
}
function BAdd_Click() //����
{
	var SourceTypeDR=GetElementValue("SourceTypeDR");
	var RoleDR=GetElementValue("RoleDR");
	var EvaluationOrder=GetElementValue("EvaluationOrder");
	if (SourceTypeDR=="")
	{
		alertShow("��ѡ��ҵ������!")
		return
	}
	if (RoleDR=="")
	{
		alertShow("��ѡ���ɫ!")
		return
	}
	if (EvaluationOrder=="")
	{
		alertShow("����������˳��!")
		return
	}
//add by HHM 20150908 HHM0014
//���ͬҵ������˳�����ظ�
	var Flag=CheckedEvaluationOrder();
	if(Flag==1) return;
//*********************************
	if(condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth==""){return;}
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,plist,'0');
	result=result.replace(/\\n/g,"\n");
	if (result>0) 
	{
		location.reload();	
	}
	else
	{
		messageShow("","","",t[result]);
	}
}
function BUpdate_Click() 
{
	var SourceTypeDR=GetElementValue("SourceTypeDR");
	var RoleDR=GetElementValue("RoleDR");
	var EvaluationOrder=GetElementValue("EvaluationOrder");
	if (SourceTypeDR=="")
	{
		alertShow("��ѡ��ҵ������!")
		return
	}
	if (RoleDR=="")
	{
		alertShow("��ѡ���ɫ!")
		return
	}
	if (EvaluationOrder=="")
	{
		alertShow("����������˳��!")
		return
	}
//add by HHM 20150908 HHM0014
//��������������Ƿ��ظ�
	var Flag=CheckedEvaluationOrder()
	if(Flag==1) return;
//**********************************
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;	
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,plist,'0');
	result=result.replace(/\\n/g,"\n");
	if (result>0)
	{
		location.reload();	
	}
	else
	{
		messageShow("","","",t[result]);
	}
}
//add by HHM 20150901 HHM0014
//��Ӹ�ѡ��ѡ�����
function MPEvaluationFlage_CheckClick()
{
	var obj=document.getElementById("MPEvaluationFlag");
	if (obj.checked==true)
	{
		SetChkElement("IndependentFlag",1);	
	}
	
}
function IndependentFlag_CheckClick()
{
	var obj=document.getElementById("IndependentFlag");
	if (obj.checked==false)
	{
		SetChkElement("MPEvaluationFlag",0);	
	}	
}
//********************************************************
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID");//1
	combindata=combindata+"^"+GetElementValue("SourceTypeDR");//��Դ����
  	combindata=combindata+"^"+GetElementValue("RoleDR");//�û�
  	combindata=combindata+"^"+GetElementValue("HospitalDR");//ҽԺ
  	combindata=combindata+"^"+GetElementValue("EquipTypeDR");//����
  	combindata=combindata+"^"+GetChkElementValue("EvaluationFlag");//���۱�־
  	combindata=combindata+"^"+GetElementValue("CheckClass");//�鿴����
  	combindata=combindata+"^"+GetElementValue("EvaluationOrder");//����˳��
  	combindata=combindata+"^"+GetElementValue("MPEvaluationFlag");//���۱�־
  	combindata=combindata+"^"+GetElementValue("IndependentFlag");//������־
  	combindata=combindata+"^"+GetElementValue("hold1");//
  	combindata=combindata+"^"+GetElementValue("hold2");//
  	combindata=combindata+"^"+GetElementValue("hold3");//
  	combindata=combindata+"^"+GetElementValue("hold4");//
  	combindata=combindata+"^"+GetElementValue("hold5");//  	
  	return combindata;
}

function EquipTypeDR(value) //
{
	//messageShow("","","",value);
	var obj=document.getElementById("EquipTypeDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//messageShow("","","",val[1]+"/"+val[2]);
}
function BDelete_Click()
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") {return;}
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n");
	if (result>0) location.reload();	
	else
	{
		messageShow("","","",t[result]);
	}
}
///ѡ�����д����˷���
// modified by kdf 2018-10-17 hisui-����
//modify by wl 2020-02-18 WL0049ɾ�������ʵ�Ĭ�Ͽ���
function SelectRowHandler(index,rowdata)
{
	if (SelectedRow==index)
	{
		Clear();
		disabled(true)//�һ�
		SelectedRow=-1;
		$('#tDHCEQCEvaluation').datagrid('unselectAll');  //hisui���� add by kdf 2018-10-17
		rowid=0;
		SetElement("RowID","");
//add by HHM 20150909 HHM0014
//���ƶ�����־�����۱�־Ĭ��ѡ��
		SetChkElement("EvaluationFlag",1);
	}
	else
	{
		SelectedRow=index;
		rowid=rowdata.TRowID ; 
		SetData(rowid);//���ú���
		disabled(false)//���һ�
	}
}

function disabled(value)
{
	InitEvent();
	DisableBElement("BAdd",!value);
	DisableBElement("BUpdate",value);
	DisableBElement("BDelete",value);
}
function Clear()
{
	SetElement("RowID","");
	SetElement("SourceTypeDR","");
	SetElement("SourceType","");
	SetElement("RoleDR","");
	SetElement("Role","");
	SetElement("HospitalDR","");
	SetElement("Hospital","");
	SetElement("EquipTypeDR","");
	SetElement("EquipType","");
	SetElement("EvaluationFlag","");
	SetElement("EvaluationOrder","");
	SetElement("MPEvaluationFlag","");
	SetElement("IndependentFlag","");
}

function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth==""){return;}
	var gbldata=cspRunServerMethod(encmeth,rowid);
	gbldata=gbldata.replace(/\\n/g,"\n");
	//alertShow("gbldata="+gbldata);
	var list=gbldata.split("^");
	var sort=17+1    // hisui-���� modified by kdf 2018-10-17
	SetElement("RowID",list[0]);//rowid
	SetElement("SourceTypeDR",list[1]);
	SetElement("SourceType",list[sort+0]); //��Դ����1
	
	SetElement("RoleDR",list[2]);
	SetElement("Role",list[sort+1]);
	
	SetElement("HospitalDR",list[3]);
	SetElement("Hospital",list[sort+2]);
	
	SetElement("EquipTypeDR",list[4]);
	SetElement("EquipType",list[sort+3]);
	
	SetElement("EvaluationOrder",list[7]);
	SetElement("CheckClass",list[6]);
	
	if (list[5]=="0")   //modify by wl 2020-02-18 WL0049
	{	SetChkElement("EvaluationFlag",0);	}
	else
	{	SetChkElement("EvaluationFlag",1);	}
	
	if (list[8]=="N")
	{	SetChkElement("MPEvaluationFlag",0);	}
	else
	{	SetChkElement("MPEvaluationFlag",1);	}
	if (list[9]=="N")
	{	SetChkElement("IndependentFlag",0);	}
	else
	{	SetChkElement("IndependentFlag",1);	}
	
	
}

function GetRole(value)
{
	//messageShow("","","",value)
	var type=value.split("^");
	var obj=document.getElementById("RoleDR");
	obj.value=type[1];
}
function GetBussType(value)
{
	var type=value.split("^");
	var obj=document.getElementById("SourceTypeDR");
	obj.value=type[1];
}

function Source_keydown()
{
	if (event.keyCode==13)
	{
		Source_Click();
	}
}
function Source_Click()
{
	//messageShow("","","",GetElementValue("SourceType"));
	if (GetElementValue("SourceType")==2) //��ȫ��
	{
		LookUpGroup("GetSourceDR","Source");
	}
	if (GetElementValue("SourceType")==1) //�û���
	{
		LookUpCTUser("GetSourceDR","Source");
	}
}
function GetHospital(value)
{
	///messageShow("","","",value);
	var obj=document.getElementById("HospitalDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
}
function condition()//����
{
	if (CheckMustItemNull()) return true;
	return false;
}
///�ж�����˳���Ƿ����ظ�������ֵ: 0 ���ظ�   1 ���ظ�
function CheckedEvaluationOrder()
{
	var EvaluationOrder=GetElementValue("EvaluationOrder");
	var SourceTypeDR=GetElementValue("SourceTypeDR");
	if (EvaluationOrder=="")        //add by czf 2016-10-10  ����ţ�266040
	{
		alertShow("����д����˳��");
		return 1
	}
	if (!(parseInt(EvaluationOrder)==EvaluationOrder))
  	{
   		 alertShow("����˳������д����");
   		 return 1
  	}
    var rowid=GetElementValue("RowID");
    //messageShow("","","",rowid);
    var encmeth=GetElementValue("CheckedEvaluationOrder")
    var result=cspRunServerMethod(encmeth,SourceTypeDR,EvaluationOrder,rowid);
    result=result.replace(/\\n/g,"\n");
  	//messageShow("","","",result);
    if (result==1)
    {
	    alertShow("����˳�����ظ�,��ȷ��!");
	    return 1;
    }
    return 0;
}
document.body.onload = BodyLoadHandler;