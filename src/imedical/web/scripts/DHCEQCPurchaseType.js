//�깺�������
function BodyLoadHandler() 
{
   InitUserInfo();
	InitEvent();
	//KeyUp("Omdr")	//���ѡ��
	disabled(true)//�һ�
	}
	function InitEvent()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
}
function BUpdate_Click() 
{
	if (condition()) return;
var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var plist=CombinData(); //��������
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n")
	if(result==-2001)alertShow(t[-3002]);
	if (result==-99) //2010-06-11 ���� begin
	{
		alertShow("�����ظ�!����!")
		return
	} //2010-06-11 ���� end
	if (result>0)
	{
	alertShow("���³ɹ�!");   // add by kdf 2018-01-16 ����ţ�531038
	location.reload();
	}		
}
function CombinData()
{	
	var AutoFlag="";
	var combindata="";
	combindata=GetElementValue("RowID") ;
	combindata=combindata+"^"+GetElementValue("Code") ;//����2
  	combindata=combindata+"^"+GetElementValue("Desc") ; //����3
  	combindata=combindata+"^"+GetElementValue("Remark") ; //��ע4
  	var obj=document.getElementById("DefaultFlag")
  	if (obj.checked){ var AutoFlag="Y"}
  			else  	{ var AutoFlag="N" }
  	combindata=combindata+"^"+AutoFlag; //Ĭ�ϱ�־5
  	return combindata;
}
function BAdd_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var plist=CombinData(); //��������
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n")
	if(result==-2001) alertShow(t[-3001]);
	if (result==-99) //2010-06-11 ���� begin
	{
		alertShow("�����ظ�!����!")
		return
	} //2010-06-11 ���� end
	if (result>0)
	{
	alertShow("���ӳɹ�!");  // add by kdf 2018-01-16 ����ţ�531035
	location.reload();
	}
}
function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0) 
	{
	alertShow("ɾ���ɹ�!") ;     //add by kdf 2018-01-16 ����ţ�531110
	location.reload();
	}
}
	
///ѡ�����д����˷���
var SelectedRow = 0;
var rowid=0;
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCPurchaseType');//+����� ������������ʾ Query ����Ĳ���
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
		SetElement("RowID","");
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetElement("RowID",rowid);
		SetData(rowid);//���ú���
		disabled(false)//���һ�
		}
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n");
	var list=gbldata.split("^");
	//alertShow("list"+list);
	SetElement("Code",list[1]); //�豸
	SetElement("Desc",list[2]); //��λ
	SetElement("Remark",list[3]);//��ע
	var obj=document.getElementById("DefaultFlag")
	if(list[4]=="Y"){obj.checked=true}
	else{obj.checked=false}
}
function Clear()
{
	SetElement("Code",""); 
	SetElement("Desc","");
	SetElement("Remark","");
	var obj=document.getElementById("DefaultFlag");
	obj.checked=false;
	}		
function disabled(value)//���һ�
{
	InitEvent();
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
}
function condition()//����
{
	if (CheckMustItemNull()) return true;
	//if (CheckItemNull(0,"Code")) return true;
	return false;
}	
document.body.onload = BodyLoadHandler	
