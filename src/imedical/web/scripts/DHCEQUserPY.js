
var SelectedRow = 0;
var rowid=0;
//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();	//��ʼ��
	SetElement("RowID","");
	SetElement("Name","");
	SetElement("PYCode","");
}

function InitEvent() //��ʼ��
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
}

function BUpdate_Click()
{
	var rowid=GetElementValue("RowID")
	if (rowid=="") retrun
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=GetElementValue("RowID")+"^"+GetElementValue("Name")+"^"+GetElementValue("PYCode"); //��������
	var result=cspRunServerMethod(encmeth,plist);
	location.reload();
}

///ѡ�����д����˷���
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQUserPY');//+����� ������������ʾ Query ����Ĳ���
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	{
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		SetElement("Name","");
		SetElement("PYCode","");
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);//���ú���
		}
}

function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"ת��Ϊ�س���
	var list=gbldata.split("^");
	SetElement("RowID",rowid); //rowid
	SetElement("Name",list[0]); //Name
	SetElement("PYCode",list[1]); //PYCode
}

//����ҳ����ط���
document.body.onload = BodyLoadHandler;