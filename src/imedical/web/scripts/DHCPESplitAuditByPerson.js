function BodyLoadHandler() {
	
	var obj;	
	//��ť ���
	obj=document.getElementById("BSplit");
	if (obj){ obj.onclick=BSplit_click; }

	//��ť ����
	obj=document.getElementById("BClose");
	if (obj){ obj.onclick=BClose_click; }
	
}

function BSplit_click()
{
	var selectIds=GetSelectIds();
	alert(selectIds);
	var encmeth=GetCtlValueById('GetSplitData',1);        
	var flag=cspRunServerMethod(encmeth,selectIds)
	if (isNaN(flag)==true)
	{	alert("���ʧ��?"+"  error="+flag)		}
	else
	{
		opener.parent.frames["DHCPEPreAuditPay"].location.reload();	
		window.close();
	}	
}

function GetSelectIds()
{
	var tbl=document.getElementById('tDHCPESplitAuditByPerson');//ȡ���Ԫ��?����
	var row=tbl.rows.length;
	var selectIds="";
	for (var iLLoop=1;iLLoop<row;iLLoop++) {
		obj=document.getElementById('TSelect'+'z'+iLLoop);
		if (obj) {			
			if (obj.checked==true) 
			{
				obj=document.getElementById('TPreIAdmId'+'z'+iLLoop);
				if ((obj)&&(obj.value!=""))	selectIds=selectIds+obj.value+",";
			}
		}
	}
	return selectIds;
}

function BClose_click()
{
	window.close();
}


document.body.onload = BodyLoadHandler;