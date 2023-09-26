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
	var obj=document.getElementById("BFind"); //查找
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("BSelectAll"); //全选
	if (obj) obj.onclick=BSelectAll_Click;

	var obj=document.getElementById("BSubmit"); //提交
	if (obj) obj.onclick=BSubmit_Click;
	var obj=document.getElementById("BAudit"); //审核
	if (obj) obj.onclick=BSubmit_Click;
	var obj=document.getElementById("BDelete"); //删除
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BCancelSubmit"); //取消提交
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
		alertShow("请选择需要提交的记录!")
		return
	}
	//提交
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
		alertShow("请选择需要取消提交的记录!")
		return
	}
	//删除
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
		alertShow("请选择需要删除的记录!")
		return
	}
	//删除
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
	if (obj.innerText=="全选(当前页)")
	{
		obj.innerText="反选(当前页)"
		var flag=1
	}
	else
	{
		obj.innerText="全选(当前页)"
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

///选择表格行触发此方法
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
		//obj.innerText="反选(当前页)"
	}
	else
	{
		//obj.innerText="全选(当前页)"
	}
	*/
}

document.body.onload = BodyLoadHandler;