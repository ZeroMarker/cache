//�豸ϵͳ���ñ�
function BodyLoadHandler() 
{	
  
	InitUserInfo();
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
}
function BUpdate_Click()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCSysSet');//+����� ������������ʾ Query ����Ĳ���
	var rows=objtbl.rows.length;
	var combindata="";
	//alertShow("rows:"+rows)
	for (i=1;i<rows;i++)
		{
	combindata=combindata+"^"+GetElementValue("TRowIDz"+i);
	combindata=combindata+"^"+GetElementValue("TValuez"+i); ;//ֵ
	combindata=combindata+"^"+GetCElementValue("TDescz"+i); ;//����
	combindata=combindata+"^"+GetElementValue("TRemarkz"+i); ;//��ע
	combindata=combindata+"^"+GetElementValue("TAddValuez"+i); ;//ֵ
	combindata=combindata+"^"+";"
		}		
			SetData(combindata,rows);//���ú���	
}
function SetData(combindata,rows)
{
	//alertShow("combindata"+combindata)
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',combindata,rows);
	var plist=gbldata.split("^");
	//alertShow("plist"+plist)
    location.reload();
}
document.body.onload = BodyLoadHandler;