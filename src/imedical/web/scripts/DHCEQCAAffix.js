//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() {
	InitEvent();	//��ʼ��
}

function InitEvent() //��ʼ��
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
}

function BUpdate_Click() //�޸�
{
	var value=CombinData(); //��������
	var str=value.split("^");
	var plist=str[0];
	var Amount=str[1];
	opener.parent.DHCEQChangeAccount.SetElement("CAAffixIDS",plist);
	var AddChange=GetElementValue("AddChange");
	if (AddChange=="true")
	{
		AddChange=1
		opener.parent.DHCEQChangeAccount.SetElement("ChangeReasonRemark","��ֵ����");
	}
	else
	{
		AddChange=0
		opener.parent.DHCEQChangeAccount.SetElement("ChangeReasonRemark","��ֵ����");
		Amount=0-Amount
	}
	opener.parent.DHCEQChangeAccount.SetChkElement("AddChangeDR",AddChange);
	opener.parent.DHCEQChangeAccount.SetElement("ChangeFee",Amount);
	opener.parent.DHCEQChangeAccount.ChangeFee_Changed();
	window.close()
	/*var encmeth=GetElementValue("GetUpdate");
	var result=cspRunServerMethod(encmeth,plist,GetElementValue("ChangeAccountDR"));
	result=result.replace(/\\n/g,"\n")
	if(result<0) 
	{
		alertShow(t["01"]);
	}
	if (result>0) location.reload();	*/
}

function CombinData()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCAAffix');//+����� ������������ʾ Query ����Ĳ���
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var IDS=""
	var sum=0
	for (var i=1;i<=lastrowindex;i++)
	{
		var ID=GetElementValue("TAffixDRz"+i)
		var Flag=GetChkElementValue("TFlagz"+i)
		var obj=document.getElementById("TAmountz"+i)
		if (obj)
		{
			var Amount=parseFloat(obj.innerText)
		}
		if (Flag==true)
		{
			Flag="Y"
			sum=sum+Amount
		}
		else
		{
			Flag="N"
		}
		IDS=IDS+ID+":"+Flag+","
	}
	IDS=","+IDS;
	return IDS+"^"+sum
}

//����ҳ����ط���
document.body.onload = BodyLoadHandler;
