var SelectedRow = 0;
var rowid=0;
//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();	//��ʼ��
	disabled(true);//�һ�
	KeyUp("CheckItem^CheckResult");	//���ѡ��
	Muilt_LookUp("CheckItem^CheckResult");
}

function InitEvent() //��ʼ��
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
}

function BDelete_Click() //ɾ��
{
	rowid=GetElementValue("OCIRowID");
	var truthBeTold = window.confirm(t["-4003"]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
	alertShow(t["01"])
	return;
	}
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0) location.reload();	
}
function BUpdate_Click() //�޸�
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n")
	if(result=="") 
	{
	alertShow(t["02"]);
	return
	}
	if (result>0) location.reload();	
}
function BAdd_Click() //���
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		alertShow(t["01"])
		return
	}
	if (result>0)location.reload();	
}

function CombinData()
{
	var combindata="";
	var Flag=GetChkElementValue("NormalFlag"); //2009-08-06 ���� begin DJ0022
	if (Flag==false)
	{
		Flag="N"
	}
	else
	{
		Flag="Y"
	} //2009-08-06 ���� end
    combindata=GetElementValue("OCIRowID") ;//�к�
    combindata=combindata+"^"+GetElementValue("RowID") ;//��������RowID
	combindata=combindata+"^"+GetElementValue("CheckItemDR") ;//������Ŀ
	combindata=combindata+"^"+GetElementValue("CheckContent") ; //��������
  	combindata=combindata+"^"+GetElementValue("CheckResultDR") ; //���ս��
  	combindata=combindata+"^"+GetElementValue("CheckResultRemark") ; //���ս����ע
  	combindata=combindata+"^"+GetElementValue("User") ; //������Ա
  	combindata=combindata+"^"+GetElementValue("Date") ; //��������
  	combindata=combindata+"^"+GetElementValue("Time") ; //����ʱ��
  	combindata=combindata+"^"+Flag ; //����ʱ�� 2009-08-06 ���� DJ0022
  	return combindata;
}
///ѡ�����д����˷���
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQOpenCheckItem');//+����� ������������ʾ Query ����Ĳ���
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	{
		Clear();	
		disabled(true)//�һ�	
		SelectedRow=0;
		rowid=0;
		SetElement("OCIRowID","");
		location.reload();
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);//���ú���
		disabled(false)//���һ�
		}
}
	
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"ת��Ϊ�س���
	var list=gbldata.split("^");
	SetElement("OCIRowID",list[0]); //OCIRowid
	SetElement("CheckItemDR",list[1]); //������ĿDR
	SetElement("CheckItem",list[2]); //������Ŀ
	SetElement("CheckContent",list[3]);//��������
	SetElement("CheckResultDR",list[4]);//���ս��DR
	SetElement("CheckResult",list[5]); //���ս��
	SetElement("CheckResultRemark",list[6]); //���ս����ע
	SetElement("User",list[7]); //������Ա
	SetElement("Date",list[8]); //��������
	SetElement("Time",list[9]); //����ʱ��
	SetChkElement("NormalFlag",list[10]); //������ʶ //2009-08-06 DJ0022
}

function Clear()
{
	SetElement("OCIRowid","");
	SetElement("CheckItem","");
	SetElement("CheckItemDR","")
	SetElement("CheckResult","");
	SetElement("CheckResultDR","");
	SetElement("CheckContent","");
	SetElement("User","");
	SetElement("CheckResultRemark","");
	SetChkElement("NormalFlag","Y"); //2009-08-06 ���� DJ0022
}

function disabled(value)//�һ�
{
	InitEvent();
	DisableBElement("BUpdate",value)

	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
}

function condition()//����
{
	if (CheckMustItemNull()) return true;
	return false;
}

function GetCheckResult(value) {
	var user=value.split("^");
	var obj=document.getElementById("CheckResultDR");
	obj.value=user[1];
}

function GetCheckItem(value) {
	var type=value.split("^");
	var obj=document.getElementById("CheckItemDR");
	obj.value=type[1];
}
//����ҳ����ط���
document.body.onload = BodyLoadHandler;
