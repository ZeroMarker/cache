function BodyLoadHandler() 
{	
	InitUserInfo();
	InitPage();
	KeyUp("Provider","N");
	Muilt_LookUp("Provider");
	SetElement("Status",GetElementValue("StatusDR"));
	SetEnabled();
	//SetTableEvent();
	//EditFieldsInit();
}
function InitPage()
{
	var obj=document.getElementById("BFind"); //����
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("BSelectAll"); //ȫѡ
	if (obj) obj.onclick=BSelectAll_Click;

	var obj=document.getElementById("BSubmit"); //�ύ
	if (obj) obj.onclick=BSubmit_Click;
	var obj=document.getElementById("BAudit"); //���
	if (obj) obj.onclick=BSubmit_Click;
	var obj=document.getElementById("BDelete"); //ɾ��
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BCancelSubmit"); //ȡ���ύ
	if (obj) obj.onclick=BCancelSubmit_Click;
}
function BFind_Click()
{
	var Flag=GetElementValue("OperatorFlag")
	var val="&ProviderDR="+GetElementValue("ProviderDR");
	val=val+"&Provider="+GetElementValue("Provider");
	val=val+"&No="+"";
	val=val+"&PStartDate="+"";
	val=val+"&PEndDate="+"";
	val=val+"&PayStartDate="+"";
	val=val+"&PayEndDate="+"";
	val=val+"&SourceTypeDR="+"";
	val=val+"&Status="+GetElementValue("Status");
	val=val+"&OperatorFlag="+Flag;
	val=val+"&PayRecordNo="+GetElementValue("PayRecordNo");
	val=val+"&QXType="+"";
	val=val+"&ApproveRole="+"";
		
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQPayRequestCollect"+val;
	
}

function SetEnabled()
{
	var OperatorFlag=GetElementValue("OperatorFlag")
	if (OperatorFlag=="2")
	{
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("Status",true)
	}
	if (OperatorFlag=="3")
	{
		DisableBElement("BSubmit",true)
		DisableBElement("BDelete",true)
		DisableBElement("Status",true)
	}
}

function BSubmit_Click()
{
	var QXType=GetElementValue("QXType")
	var eSrc=window.event.srcElement;
	var Objtbl=document.getElementById('tDHCEQPayRequestCollect');
	var Rows=Objtbl.rows.length;
	var Count=0
	var isAudit=0
	var CurRole=""
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TOperatorz'+i);
		if (selobj.checked) { Count=1 }
	}
	if (Count==0)
	{
		alertShow("��ѡ����Ҫ�ύ�ļ�¼!")
		return
	}
	//�ύ
	if (QXType=="1")
	{
		isAudit=1
		CurRole=GetElementValue("ApproveRole");
	  	if (CurRole=="") return;
	}
	var encmeth=GetElementValue("SubmitData")
  	if (encmeth=="") return;
  	var ErrorStr=""
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TOperatorz'+i);
		if (selobj.checked)
		{
			var RowID=GetElementValue("TRowIDz"+i)
			var RoleStep=1  //GetElementValue("TRoleStepz"+i);
			var EditFieldsInfo=""
			if (QXType=="1")
			{
				var objtbl=document.getElementById('tDHCEQPayRequestCollect');
				EditFieldsInfo=ApproveEditFieldsInfo(objtbl,i);
				if (EditFieldsInfo=="-1") return;
			}
			var Rtn=cspRunServerMethod(encmeth,RowID,CurRole,RoleStep,EditFieldsInfo,isAudit);
			alertShow(Rtn)
			if (Rtn<0)
			{
				if (ErrorStr=="")
				{
					ErrorStr=GetElementValue("TItemz"+i)+"="+Rtn
				}
				else
				{
					ErrorStr=ErrorStr+" , "+GetElementValue("TItemz"+i)+"="+Rtn
				}
			}
			
		}
	}
	if (ErrorStr!="")
	{
		alertShow(ErrorStr)
	}
	BFind_Click();
	
}
function BCancelSubmit_Click()
{
	var eSrc=window.event.srcElement;
	var Objtbl=document.getElementById('tDHCEQPayRequestCollect');
	var Rows=Objtbl.rows.length;
	var Count=0
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TOperatorz'+i);
		if (selobj.checked) { Count=1 }
	}
	if (Count==0)
	{
		alertShow("��ѡ����Ҫȡ���ύ�ļ�¼!")
		return
	}
	//ɾ��
	var encmeth=GetElementValue("CancelData")
  	if (encmeth=="") return;
  	var ErrorStr=""
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TOperatorz'+i);
		if (selobj.checked)
		{
			var RowID=GetElementValue("TRowIDz"+i)
			var Rtn=cspRunServerMethod(encmeth,RowID);
			if (Rtn<0)
			{
				if (ErrorStr=="")
				{
					ErrorStr=GetElementValue("TItemz"+i)+"="+Rtn
				}
				else
				{
					ErrorStr=ErrorStr+" , "+GetElementValue("TItemz"+i)+"="+Rtn
				}
			}
		}
	}
	if (ErrorStr!="")
	{
		alertShow(ErrorStr)
	}
	BFind_Click();
	
}
function BDelete_Click()
{
	
	var eSrc=window.event.srcElement;
	var Objtbl=document.getElementById('tDHCEQPayRequestCollect');
	var Rows=Objtbl.rows.length;
	var Count=0
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TOperatorz'+i);
		if (selobj.checked) { Count=1 }
	}
	if (Count==0)
	{
		alertShow("��ѡ����Ҫɾ���ļ�¼!")
		return
	}
	//ɾ��
	var encmeth=GetElementValue("DeleteData")
  	if (encmeth=="") return;
  	var ErrorStr=""
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TOperatorz'+i);
		if (selobj.checked)
		{
			var RowID=GetElementValue("TRowIDz"+i)
			var Rtn=cspRunServerMethod(encmeth,RowID);
			alertShow(Rtn)
			if (Rtn<0)
			{
				if (ErrorStr=="")
				{
					ErrorStr=GetElementValue("TItemz"+i)+"="+Rtn
				}
				else
				{
					ErrorStr=ErrorStr+" , "+GetElementValue("TItemz"+i)+"="+Rtn
				}
			}
		}
	}
	if (ErrorStr!="")
	{
		alertShow(ErrorStr)
	}
	BFind_Click();

}
function GetProviderID(value)
{
	GetLookUpID('ProviderDR',value);	
}
function BSelectAll_Click()
{
	var obj=document.getElementById("BSelectAll")
	if (obj.innerText=="ȫѡ(��ǰҳ)")
	{
		obj.innerText="��ѡ(��ǰҳ)"
		var flag=1
	}
	else
	{
		obj.innerText="ȫѡ(��ǰҳ)"
		var flag=0
	}
	var eSrc=window.event.srcElement;
	var Objtbl=document.getElementById('tDHCEQPayRequestCollect');
	var Rows=Objtbl.rows.length;
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TOperatorz'+i);
		selobj.checked=flag;
	}
}

///ѡ�����д����˷���
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var Objtbl=document.getElementById('tDHCEQPayRequestCollect');
	var Rows=Objtbl.rows.length;
	var Count=0
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TOperatorz'+i);
		if (selobj.checked)
		{
			Count=Count+1
		}
	}
	/*
	var obj=document.getElementById("BSelectAll")
	if (Count==(Rows-1))
	{
		//obj.innerText="��ѡ(��ǰҳ)"
	}
	else
	{
		//obj.innerText="ȫѡ(��ǰҳ)"
	}
	*/
}

document.body.onload = BodyLoadHandler;