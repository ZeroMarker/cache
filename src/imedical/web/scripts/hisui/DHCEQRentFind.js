///Modified By HZY 2011-7-19. Bug HZY0006
///Description:�޸ĺ���BFind_Click?�����������ַ�����Ӹ�RequestNo����?��ʵ�ְ����뵥�Ų�ѯ�Ĺ���?

var selectRow=""
var tableList=new Array();
//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() 
{
	InitUserInfo();
	InitPage();
	HiddenElement();
	KeyUp("RequestLoc^FromLoc^Item");	//���ѡ��
	Muilt_LookUp("RequestLoc^FromLoc^Item"); //�س�ѡ��
	initButtonWidth();//add by csj 20180902 ����60��HISUIͳһ��ť���
}

function HiddenElement()
{
	EQCommon_HiddenElement("Time");
	if (GetElementValue("StatusDR")!="")
	{
		SetElement("Status",GetElementValue("StatusDR"))
	}
	var ColNameStr=""
	var ColIdStr=""
	var objtbl=document.getElementById('tDHCEQRentFind');//+�����
	var Type=GetElementValue("Type")
	var Status=GetElementValue("Status")
	if (Type=="Apply")
	{
		EQCommon_HiddenElement("BRent");
		EQCommon_HiddenElement("BReturn");
		EQCommon_HiddenElement("cWaitAD");	//add by csj 20190116
		$("#WaitAD").parent().empty()	//Mozy	1015142	2019-9-14
		//HiddenCheckBox("WaitAD"); 

		ColNameStr=("TStartDate^TStartTime^TRentManager^TLocReceiver^TRentStatus^TRentStatusRemark^TReturnManager^TLocReturn^TReturnDate^TReturnTime^TReturnStatus^TReturnStatusRemark^TTotalFee^TSelect") //TWorkLoad^ɾ�� modified by csj 20180907
	}
	else if (Type=="Rent")
	{
		EQCommon_HiddenElement("BAdd");
		EQCommon_HiddenElement("BReturn");
		ColNameStr=("TRequestUser^TPlanBeginDate^TPlanBeginTime^TPlanEndDate^TPlanEndTime^TReturnManager^TLocReturn^TReturnDate^TReturnTime^TReturnStatus^TReturnStatusRemark^TTotalFee")	 //TWorkLoad^ɾ�� modified by csj 20180907
		ColIdStr=("TEquip^TStartDate^TStartTime^TRentManager^TLocReceiver^TRentStatus^TRentStatusRemark")
	}
	else if (Type=="Return")
	{
		EQCommon_HiddenElement("BAdd");
		EQCommon_HiddenElement("BRent");
		ColNameStr=("TRequestUser^TPlanBeginDate^TPlanBeginTime^TPlanEndDate^TPlanEndTime^TStartDate^TStartTime^TRentManager^TLocReceiver^TRentStatus^TRentStatusRemark")				
		ColIdStr=("TReturnManager^TLocReturn^TReturnDate^TReturnTime^TReturnStatus^TReturnStatusRemark^TTotalFee") //TWorkLoad^ɾ�� modified by csj 20180907
	}
	else if (Type=="LocReturn")
	{
		EQCommon_HiddenElement("BAdd");
		EQCommon_HiddenElement("BRent");
		ColNameStr=("TRequestUser^TPlanBeginDate^TPlanBeginTime^TPlanEndDate^TPlanEndTime^TStartDate^TStartTime^TRentManager^TLocReceiver^TRentStatus^TRentStatusRemark")				
		ColIdStr=("TReturnManager^TLocReturn^TReturnDate^TReturnTime^TReturnStatus^TReturnStatusRemark^TTotalFee") //TWorkLoad^ɾ�� ���У� modified by csj 20180907
	}
	else if (Type=="Find")
	{
		EQCommon_HiddenElement("BAdd");
		EQCommon_HiddenElement("BRent");
		EQCommon_HiddenElement("BReturn");
		EQCommon_HiddenElement("cWaitAD");	//add by csj 20190116
		$("#WaitAD").parent().empty()	//Mozy	1015142	2019-9-14
		//HiddenCheckBox("WaitAD"); 
		ColNameStr=("TRequestUser^TPlanBeginDate^TPlanBeginTime^TPlanEndDate^TPlanEndTime^TRentManager^TReturnManager^TSelect")				
	}
	if (ColNameStr!="")
	{
		var list=ColNameStr.split("^");
		var num=list.length;
		for (var i=0;i<num;i++)
		{
			var ColName=list[i];
			HiddenTblColumn("tDHCEQRentFind",ColName); //modified by csj 20180907 ��̬���������
		}
	}
}

function InitPage()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("BRent");
	if (obj) obj.onclick=BRent_Click;
	var obj=document.getElementById("BReturn");
	if (obj) obj.onclick=BRent_Click;
	var obj=document.getElementById("BClear");		//Mozy	984437	2019-8-5
	if (obj) obj.onclick=BClear_Click;
}

//modified by csj 20181012 HISUI���� ���������Ϊ����
function BAdd_Click()
{
	var val="&Type="+GetElementValue("Type")
	val=val+"&QXType="+GetElementValue("QXType")
	val=val+"&RequestLocDR="+GetElementValue("RequestLocDR")
	val=val+"&RequestUserDR="+GetElementValue("User")
	val=val+"&PlanBeginDate="+GetElementValue("EndDate")
	val=val+"&PlanBeginTime="+GetElementValue("Time")
	url='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQRent'+val
	showWindow(url,"�豸���޵�","","15row","icon-w-paper","modal","","","large",BFind_Click)	//modified by lmm 2020-06-04 UI
}

//modified by csj 20190116 �첽��ˢ�¼��ز�ѯ���
function BFind_Click()
{
	if (!$(this).linkbutton('options').disabled){
		var WaitAD="0";	
		if (GetElementValue("WaitAD")) WaitAD="checked";
		$('#tDHCEQRentFind').datagrid('load',{ComponentID:getValueById("GetComponentID"),QXType:getValueById("QXType"),vQXType:getValueById("vQXType"),Type:getValueById("Type"),RequestLocDR:getValueById("RequestLocDR"),FromLocDR:getValueById("FromLocDR"),ItemDR:getValueById("ItemDR"),StatusDR:getValueById("Status"),BeginDate:getValueById("BeginDate"),EndDate:getValueById("EndDate"),RequestNo:getValueById("RequestNo"),ApproveRole:getValueById("ApproveRole"),Action:getValueById("Action"),WaitAD:WaitAD});
	}
}

function BRent_Click()
{
  	var Type=GetElementValue("Type")
  	var StatusDR=GetElementValue("Status")
  	if (Type=="Rent")
  	{
	  	if (StatusDR!="1")
	  	{
			alertShow("��ǰ״̬���ܽ��!")
			return
		}
	}
	else if (Type=="Return")
	{
		if (StatusDR!="2")
	  	{
			alertShow("��ǰ״̬���ܹ黹!")
			return
		}
	}
  	var valList=GetTableInfo()
  	if (valList=="-1") return
  	if (valList=="")
  	{
	  	alertShow("����ѡ��Ҫ�������豸!")
	  	return
  	}
  	var encmeth=GetElementValue("upd")
  	if (encmeth=="") return;
	var Return=cspRunServerMethod(encmeth,valList,Type);
    if (Return==0)
    {
		var val="&Type="+GetElementValue("Type")
		val=val+"&StatusDR="+GetElementValue("Status")
		val=val+"&RequestLocDR="+GetElementValue("RequestLocDR")
		val=val+"&RequestLoc="+GetElementValue("RequestLoc")
		val=val+"&FromLocDR="+GetElementValue("FromLocDR")
		val=val+"&FromLoc="+GetElementValue("FromLoc")
		val=val+"&ItemDR="+GetElementValue("ItemDR")
		val=val+"&Item="+GetElementValue("Item")
		val=val+"&BeginDate="+GetElementValue("BeginDate")
		val=val+"&EndDate="+GetElementValue("EndDate")
		val=val+"&Type="+GetElementValue("Type")
		val=val+"&User="+GetElementValue("User")
		val=val+"&Time="+GetElementValue("Time")
		val=val+"&QXType="+GetElementValue("QXType")
		val=val+"&vQXType="+GetElementValue("vQXType")
	    window.location.href= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQRentFind'+val;
	}
    else
    {
	    messageShow("","","",Return+"   "+t["01"]);
    }
}

function GetRequestLocID(value)
{
	GetLookUpID("RequestLocDR",value);
}

function GetFromLocID(value)
{
	GetLookUpID("FromLocDR",value);
}

function GetItemID(value)
{
	GetLookUpID("ItemDR",value);
}

function LookUpEquip()
{
	if (event.keyCode==13||event.keyCode==0)
	{
		selectRow=GetTableCurRow();
		LookUp("","web.DHCEQRent:GetEquipByItem","GetEquipID","TEquipz"+selectRow+","+"TItemDRz"+selectRow+","+"TFromLocDRz"+selectRow+","+"TModelDRz"+selectRow);
	}
}
function GetEquipID(value)
{
	var val=value.split("^");
	for (var i=1;i<tableList.length;i++)
	{
		if ((val[1]==tableList[i])&&(selectRow!=i))
		{
			alertShow("���뵥���"+i+"�����뵥������ͬһ�豸!")
			return
		}
	}
	var obj=document.getElementById("TEquipDRz"+selectRow);
	if (obj)
	{
		obj.value=val[1];	
		tableList[selectRow]=val[1];
	}
	else 	{		alertShow("TEquipDRz"+selectRow);	}
	var obj=document.getElementById("TEquipz"+selectRow);
	if (obj){obj.value=val[0];	}
	else 	{		alertShow("TEquipz"+selectRow);	}
	var obj=document.getElementById("TNoz"+selectRow);
	if (obj){obj.innerText=val[2];	}
}

function LookUpRentManager()
{
	if (event.keyCode==13||event.keyCode==0)
	{
		selectRow=GetTableCurRow();
		LookUpUser("GetRentManagerID",",TRentManagerz"+selectRow)
	}
}
function GetRentManagerID(value)
{
	GetLookUpID_Table("TRentManagerDRz"+selectRow,value);
}
function LookUpReturnManager()
{
	if (event.keyCode==13||event.keyCode==0)
	{
		selectRow=GetTableCurRow();
		LookUpUser("GetReturnManagerID",",TReturnManagerz"+selectRow)
	}
}
function GetReturnManagerID(value)
{
	GetLookUpID_Table("TReturnManagerDRz"+selectRow,value);
}
function LookUpLocReceiver()
{
	if (event.keyCode==13||event.keyCode==0)
	{
		selectRow=GetTableCurRow();
		LookUpUser("GetLocReceiverID",",TLocReceiverz"+selectRow)
	}
}

function GetLocReceiverID(value)
{
	GetLookUpID_Table("TLocReceiverDRz"+selectRow,value);
}

function LookUpLocReturn()
{
	if (event.keyCode==13||event.keyCode==0)
	{
		selectRow=GetTableCurRow();
		LookUpUser("GetLocReturnID",",TLocReturnz"+selectRow)
	}
}
function GetLocReturnID(value)
{
	GetLookUpID_Table("TLocReturnDRz"+selectRow,value);
}

function TStartDate_lookupSelect(dateval)
{
	var obj=document.getElementById('TStartDatez'+selectRow);
	obj.value=dateval;
}
function TReturnDate_lookupSelect(dateval)
{
	var obj=document.getElementById('TReturnDatez'+selectRow);
	obj.value=dateval;
}

function LookUpUser(jsfunction,paras)
{
	LookUp("","web.DHCEQFind:EQUser",jsfunction,paras);
}
///ѡ�����д����˷���
function SelectRowHandler()
	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQRentFind');//+�����
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (selectRow==selectrow)
	{
		selectRow=0;
	}
	else
	{
		selectRow=selectrow;
	}
}

function GetTableInfo()
{
	var objtbl=document.getElementById('tDHCEQRentFind');
	var rows=objtbl.rows.length;
	var valList="";
	for(var i=1;i<rows;i++)
	{
		var TSelect=GetChkElementValue('TSelectz'+i);
		if (TSelect==false) continue
		var TRowID=GetElementValue('TRowIDz'+i);
		var TEquipDR=GetElementValue('TEquipDRz'+i);
		if (TEquipDR=="")
		{				
			alertShow("��"+i+"���豸����Ϊ��")
			return "-1"
		}
		if (GetElementValue("Type")=="Rent")  //�������
		{
			var TValue1=GetElementValue('TStartDatez'+i);
			if (TValue1=="")
			{
				alertShow("��"+i+"�п�ʼʱ�䲻��Ϊ��")
				return "-1"
			}
			var TValue2=GetElementValue('TStartTimez'+i);
			var TValue3=GetElementValue('TRentManagerDRz'+i);
			if (TValue3=="")
			{
				alertShow("��"+i+"�н�������˲���Ϊ��")
				return "-1"
			}
			var TValue4=GetElementValue('TLocReceiverDRz'+i);
			if (TValue4=="")
			{
				alertShow("��"+i+"�п��ҽ����˲���Ϊ��")
				return "-1"
			}
			var TValue5=GetElementValue('TRentStatusz'+i);
			if (TValue5=="")
			{
				alertShow("��"+i+"�н���豸״̬����Ϊ��")
				return "-1"
			}
			var TValue6=GetElementValue('TRentStatusRemarkz'+i);
			var ColStr=TValue1+"^"+TValue2+"^"+TValue3+"^"+TValue4+"^"+TValue5+"^"+TValue6
		}
		else if (GetElementValue("Type")=="Return")  //�黹����
		{
			var TValue1=GetElementValue('TReturnDatez'+i);
			if (TValue1=="")
			{
				alertShow("��"+i+"�й黹���ڲ���Ϊ��")
				return "-1"
			}
			var TValue2=GetElementValue('TReturnTimez'+i);
			var TValue3=GetElementValue('TReturnManagerDRz'+i);
			if (TValue3=="")
			{
				alertShow("��"+i+"�й黹�����˲���Ϊ��")
				return "-1"
			}
			var TValue4=GetElementValue('TLocReturnDRz'+i);
			if (TValue4=="")
			{
				alertShow("��"+i+"�п��ҹ黹�˲���Ϊ��")
				return "-1"
			}
			var TValue5=GetElementValue('TReturnStatusz'+i);
			if (TValue5=="")
			{				
				alertShow("��"+i+"�й黹�豸״̬����Ϊ��")
				return "-1"
			}
			var TValue6=GetElementValue('TReturnStatusRemarkz'+i);
			var TValue7=GetElementValue('TWorkLoadz'+i);
			if (TValue7=="")
			{				
				alertShow("��"+i+"���豸����������Ϊ��")
				return "-1"
			}
			var TValue8=GetElementValue('TTotalFeez'+i);
			if (TValue8=="")
			{
				alertShow("��"+i+"���ܷ��ò���Ϊ��")
				return "-1"
			}
			var ColStr=TValue1+"^"+TValue2+"^"+TValue3+"^"+TValue4+"^"+TValue5+"^"+TValue6+"^"+TValue7+"^"+TValue8;
		}
		if(valList!="") {valList=valList+"@";}
		valList=valList+TRowID+"^"+TEquipDR+"^"+ColStr
	}
	return  valList
}

function Select_Click()
{
	selectRow=GetTableCurRow();
	var TSelect=document.getElementById("TSelectz"+selectRow).checked
	if (tableList[selectRow]=="") return
	for (var i=1;i<tableList.length;i++)
	{
		if ((tableList[selectRow]==tableList[i])&&(selectRow!=i))
		{
			if (TSelect==true)
			{
				alertShow("���뵥���"+i+"�����뵥������ͬһ�豸!")
				DisableBElement("TSelectz"+i,true)
			}
			if (TSelect==false)
			{
				DisableBElement("TSelectz"+i,false)
				var TSelect=document.getElementById("TSelectz"+i)
				if (TSelect) TSelect.onclick=Select_Click;
			}	
		}
	}
}
///add by csj 2019-01-16
///������hisui���� ���ع�ѡ��
///��Σ�name ��ѡ��id
function HiddenCheckBox(name)
{
	$("#"+name).parent(".hischeckbox_square-blue").css("display","none");
}
//Mozy	984437	2019-8-19
//modified by wl 2019-09-18 1029492 ��������
function BClear_Click()
{
	//location.reload();
	//return
	setElement("StoreMoveNo","");
	setElement("Name","");
	setElement("AccessoryType","");
	setElement("AccessoryTypeDR","");
	setElement("StartDate","");
	setElement("EndDate","");
	setElement("MoveType","");
	setElement("MoveTypeID","");
	setElement("FromLoc","");
	setElement("FromLocDR","");
	setElement("ToLoc","");
	setElement("ToLocDR","");
	setElement("ShortDesc","");
	setElement("Reciver","");
	setElement("ReciverDR","");
	setElement("StatusDR","");
	setElement("Status","");
	setElement("BeginDate","");
	setElement("RequestLoc","");
	setElement("RequestNo","");
	setElement("Item","");
}
//����ҳ����ط���
document.body.onload = BodyLoadHandler;
