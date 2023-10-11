var SelectedRow = -1;
var rowid=0;
//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() {
	InitUserInfo();
	SetEquipName();
	SetMaintInfo();		//add by CZF0076 2020-02-26
	InitEvent();	//��ʼ��	disabled(true);
	disabled(true);		//modified by czf 1260025
	KeyUp("AllotLoc");
	Muilt_LookUp("AllotLoc");
	AllotType_Change();
	initButtonWidth()  //hisui���� add by lmm 2018-08-20 �޸Ľ��水ť���Ȳ�һ��
	SetElement("TotalFee",parent.$("#MRTotalFee").val()) 		//add by CZF0076
}
//modify by jyp 2018-08-17 hisui����:�����б�onchange�¼�����
function InitEvent()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	//begin modify by jyp 2018-08-17
	//var obj=document.getElementById("AllotType");
	//if (obj) obj.onchange=AllotType_Change;
	$("#AllotType").combobox({
		onSelect:function(){
			AllotType_Change();
		}		
	});
	//end modify by jyp 2018-08-17
}

function BUpdate_Click()
{
	if (condition()) return;
	var AllotType=GetElementValue("AllotType")
	if (AllotType=="0")		//0:�̶�����,1:������,2:���,3:����,4:��λ,5:����,6:�̶�ֵ
	{
		var AllotRate=GetElementValue("AllotRate")
		if ((AllotRate<=0)||(AllotRate>100)||isNaN(AllotRate))
		{
			alertShow("��������Ч�ķ�̯����(%)")
			return
		}
	}
	else if (AllotType=="6")
	{
		var AllotValue=GetElementValue("AllotValue")
		var TotalFee=GetElementValue("TotalFee")
		if (+AllotValue>+TotalFee)		//czf 2170967
		{
			alertShow("��ֵ̯���ܴ���ά�޷���!")
			return
		}
	}
	else
	{
		var AllotValue=GetElementValue("AllotValue")
		if ((AllotValue<=0)||isNaN(AllotValue))
		{
			alertShow("��������Ч�ķ�ֵ̯")
			return
		}		
		if ((AllotType==1)||(AllotType==2)||(AllotType==5))
		{
			SetElement("AllotValue",parseFloat(AllotValue).toFixed(2))
		}
		if (AllotType==6)	//add by CZF0076 2020-02-26
		{
			SetElement("AllotValue",parseFloat(AllotValue).toFixed(2))
		}
		else
		{
			if (AllotValue!=parseFloat(AllotValue).toFixed(0))
			{
				alertShow("������λ�ķ�ֵ̯����Ϊ����!")
				return
			}
		}
	}
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;	
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,'','',plist,'',GetElementValue("TotalFee"));
	result=result.replace(/\\n/g,"\n")
	if(result<0) 
	{
		if ((result=="-1001")||(result=="-1002")||(result=="-1003"))
		{
			messageShow("","","",t[result])
		}
		else
		{
			messageShow("","","",t["02"]);
		}
		return
	}
	if (result>0) location.reload();
}

function BDelete_Click()
{
	// modified by csj 20190827 ��Ч�t���õ���¼�
	if (!$(this).linkbutton('options').disabled){
		var rowid=GetElementValue("ListRowID");
		var truthBeTold = window.confirm(t["-4003"]);
	    if (!truthBeTold) return;
		var encmeth=GetElementValue("GetUpdate");
		if (encmeth=="") return;
		var result=cspRunServerMethod(encmeth,'','',rowid,1);
		result=result.replace(/\\n/g,"\n")
		if(result<0) 
		{
			messageShow("","","",t["02"]);
			return
		}
		if (result>0) location.reload();
	}

}

function CombinData()
{
	var combindata="";
    combindata=GetElementValue("ListRowID") ;
	combindata=combindata+"^"+GetElementValue("Types");
	combindata=combindata+"^"+GetElementValue("EquipDR");
	combindata=combindata+"^"+GetElementValue("AllotLocDR");
	combindata=combindata+"^"+GetElementValue("AllotRate");
	combindata=combindata+"^"+GetElementValue("AllotType");
	combindata=combindata+"^"+GetElementValue("AllotValue");
	combindata=combindata+"^"+GetElementValue("SourceID");
	return combindata;
}

function condition()//����
{
	if (CheckMustItemNull()) return true;
	return false;
}

function SetData(rowid)
{
	var encmeth=GetElementValue("GetList");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"ת��Ϊ�س���
	var list=gbldata.split("^");
	SetElement("ListRowID",rowid);
	SetElement("AllotLocDR",list[0]);
	SetElement("AllotLoc",list[1]);
	SetElement("AllotRate",list[2]);
	SetElement("AllotType",list[3]);
	SetElement("AllotValue",list[4]);
}

function SetEquipName()
{
	var EquipDR=GetElementValue("EquipDR");
	if ((EquipDR=="")||(EquipDR<1)) 
	{
		return;	
	}
	var encmeth=GetElementValue("GetData");
	if (encmeth=="")
	{
		messageShow("","","",t[-4001]);
		return;
	}
	var result=cspRunServerMethod(encmeth,'','',EquipDR);
	result=result.replace(/\\n/g,"\n");
	var list=result.split("^");
	SetElement("Equip",list[0]);
}

///ѡ�����д����˷���
///modify by jyp 2018-08-17 hisui����:datagrid��ѡ���¼��Ĳ��������仯���������ݲ����������
function SelectRowHandler(index,rowdata)
{
	if (index==SelectedRow)  {  //modify by jyp 2018-08-17 
		Clear();	
		disabled(true)//�һ�	
		SelectedRow=-1;
		rowid=0;
		SetElement("ListRowID","");
		$('#tDHCEQCostAllotNew').datagrid('unselectRow', index);	//add by csj 20190827 ȡ��ѡ��
	}
	else{
		SelectedRow=index;   //modify by jyp 2018-08-17 
		rowid=rowdata.TRowID   //modify by jyp 2018-08-17 
		SetData(rowid);//���ú���
		disabled(false)//���һ�
	}
}

function disabled(value)
{
	//InitEvent();  	//modify by wl 2019-8-30 
	DisableBElement("BDelete",value);
	AllotType_Change()
	var SourceID=GetElementValue("SourceID");		//add by CZF0076 2020-02-26
	var Status=GetElementValue("Status");
	// MZY0080	1891466		2021-06-03
	if (GetElementValue("ReadOnly")=="Y")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
	}
	else if ((SourceID=="")||(Status=="")||(Status==2))
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
	}
}

function Clear()
{
	SetElement("ListRowID","");
	SetElement("AllotLoc","");
	SetElement("AllotLocDR","");
	SetElement("AllotRate","");
	SetElement("AllotType","0");
	SetElement("AllotValue","");
}

function GetAllotLoc(value)
{
	var user=value.split("^");
	var obj=document.getElementById("AllotLocDR");
	obj.value=user[1];
}
//modify by jyp 2018-08-17 hisui����:��̬�������޸�
function AllotType_Change()
{
	var AllotType=GetElementValue("AllotType");
	if (AllotType=="0")
	{
		SetElement("AllotValue","");
		DisableElement("AllotValue",true);
		setItemRequire("AllotValue",false)    //add by jyp 2018-08-17 
		DisableElement("AllotRate",false);
		setItemRequire("AllotRate",true)      //add by jyp 2018-08-17 
	}
	else
	{
		SetElement("AllotRate","");
		DisableElement("AllotValue",false);
		setItemRequire("AllotValue",true)    //add by jyp 2018-08-17
		DisableElement("AllotRate",true);
		setItemRequire("AllotRate",false)     //add by jyp 2018-08-17
	}
}

//add by CZF0076 2020-02-26
function SetMaintInfo()
{
	var SourceID=GetElementValue("SourceID");
	var Types=GetElementValue("Types");
	if ((SourceID!="")) 
	{
		if (Types=="2")
		{
			var encmeth=GetElementValue("GetMaintData");
			if (encmeth=="") return;
			var ReturnList=cspRunServerMethod(encmeth,"","",SourceID,"","","");	
			ReturnList=ReturnList.replace(/\\n/g,"\n");
			var plist=ReturnList.split("@");
			list=plist[0].split("^");
			var sort=89;
		    SetElement("RequestNo",list[0]);
			SetElement("EquipName",list[sort+3]);
		    SetElement("UseLoc",list[sort+4]);
		    SetElement("TotalFee",list[59]);
		}
	}
}
//����ҳ����ط���
document.body.onload = BodyLoadHandler;
