//�豸������
function BodyLoadHandler() 
{  
	InitUserInfo();
	InitEvent();
	SetDisable();
}

function InitEvent()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCCounter');//+����� ������������ʾ Query ����Ĳ���
	var rows=objtbl.rows.length;
	for (i=1;i<rows;i++)
	{		
		var obj=document.getElementById("TGroupFlagz"+i);
		if (obj) obj.onclick=BGroupFlag_Click;
	}
	
}
function BUpdate_Click()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCCounter');//+����� ������������ʾ Query ����Ĳ���
	var rows=objtbl.rows.length;
	var combindata="";
	for (i=1;i<rows;i++)
	{
		combindata=combindata+"^"+GetElementValue("TRowIDz"+i);
		combindata=combindata+"^"+GetElementValue("TCounterNumz"+i); ;//ֵ
		combindata=combindata+"^"+GetElementValue("TypeDRz"+i); ;//����
		combindata=combindata+"^"+GetElementValue("TLengthz"+i); ;//��ע
		combindata=combindata+"^"+GetElementValue("TPrefixz"+i); ;//ǰ׺
		combindata=combindata+"^"+GetElementValue("TSuffixz"+i); ;//��׺
		combindata=combindata+"^"+GetChkElementValue("TGroupFlagz"+i); ;//�Ƿ����
		combindata=combindata+"^"+GetElementValue("TGroupz"+i); ;//�����ַ���
		combindata=combindata+"^"+GetElementValue("THold1z"+i); ;//����1
		combindata=combindata+"^"+GetElementValue("THold2z"+i); ;//����2
		combindata=combindata+"^"+GetElementValue("THold3z"+i); ;//����3
		combindata=combindata+"^"+";"
	}
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',combindata);
	if (gbldata!=0)
	{
		alertShow(t[-2201])
		return
	}
	else
	{
		location.reload();
	}
}
function BGroupFlag_Click()
{
	var i=GetTableCurRow();
	var obj=document.getElementById("TGroupFlagz"+i);
	if (obj.checked==true)
	{
		DisableElement("TCounterNumz"+i,true)
		DisableElement("TGroupz"+i,false)
	}
	else
	{
		DisableElement("TCounterNumz"+i,false)
		DisableElement("TGroupz"+i,true)
	}
	
}
function SetDisable()
{	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCCounter');//+����� ������������ʾ Query ����Ĳ���
	var rows=objtbl.rows.length;
	var combindata="";
	for (i=1;i<rows;i++)
	{		
		var GroupFlag=GetChkElementValue("TGroupFlagz"+i)
		if (GroupFlag==true)
		{
			DisableElement("TCounterNumz"+i,true)
		}
		else
		{
			DisableElement("TGroupz"+i,true)
		}
	}
}
document.body.onload = BodyLoadHandler;