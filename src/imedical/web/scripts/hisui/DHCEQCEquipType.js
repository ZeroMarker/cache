//modified by GR 2014-09-24 2961 �����ʾ��Ϣ��׼ȷ����
//�޸�λ��BUpdate_Click() 
//----------------------------------------------------------
//�豸����
var SelectedRow = -1;
var rowid=0;
///modify by jyp 2018-08-16 Hisui���죺���initButtonWidth()�������ư�ť����
function BodyLoadHandler() 
{	
    InitUserInfo(); //ϵͳ����
	InitPage();	    ///modify by jyp 2018-08-16 Hisui���죺HisUI����-���������datagrid��ѡ���¼��Ĳ��������仯���������ݲ����������
	disabled(true);//�һ�
	initButtonWidth()  ///add by jyp 2018-08-16 Hisui���죺���initButtonWidth()�������ư�ť����
}
///modify by jyp 2018-08-16 Hisui���죺HisUI����-���������datagrid��ѡ���¼��Ĳ��������仯���������ݲ����������
function InitPage()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
}
function BClear_Click() 
{
	Clear();
	disabled(true);
}
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;
	combindata=combindata+"^"+GetElementValue("Code") ;
  	combindata=combindata+"^"+GetElementValue("Desc") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetChkElementValue("InvalidFlag") ;
  	combindata=combindata+"^"+GetElementValue("EQType") ;
  	combindata=combindata+"^"+GetChkElementValue("EQFlag") ;
  	combindata=combindata+"^"+GetElementValue("MinPrice") ;
  	combindata=combindata+"^"+GetElementValue("MaxPrice") ;	
  	combindata=combindata+"^"+GetElementValue("Hold1") ; //Modifeid by HHM 20150917 HHM0021
  	combindata=combindata+"^"+GetElementValue("Hold2") ;
  	combindata=combindata+"^"+GetElementValue("Hold3") ;
  	combindata=combindata+"^"+GetElementValue("Hold4") ;
  	combindata=combindata+"^"+GetElementValue("Hold5") ;
  	return combindata;
}
function BUpdate_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,plist,"");
	if(result<0) 
	{
		messageShow("","","",t[result]);
		return
	}
	if (result>0)
	{
		alertShow("�����ɹ�!")
		location.reload();
	}	
}
function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
		messageShow("","","",t[-3001])
		return;
	}
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		alertShow("ɾ���ɹ�!")
		location.reload();
	}	
}
///ѡ�����д����˷���
///begin add by jyp 2018-08-16 Hisui���죺HisUI����-���������datagrid��ѡ���¼��Ĳ��������仯���������ݲ����������
function SelectRowHandler(index,rowdata){
	if (index==SelectedRow){
		Clear();
		SelectedRow= -1;
		ChangeStatus(false);
		$('#tDHCEQCEquipType').datagrid('unselectAll'); 
		return;
		}
	ChangeStatus(true);
	SetData(rowdata.TRowID);    
    SelectedRow = index;
}
function ChangeStatus(Value)
{
	InitPage();
	DisableBElement("BUpdate",!Value);
	DisableBElement("BDelete",!Value);
	DisableBElement("BAdd",Value);
}
///end add by jyp 2018-08-16 Hisui���죺HisUI����-���������datagrid��ѡ���¼��Ĳ��������仯���������ݲ����������
/*
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCEquipType');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	
	{
		Clear();
		disabled(true);//�һ�	
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
	}
	else
	{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);//���ú���
		disabled(false);//���һ�
	}
}
*/
///end add by jyp 2018-08-16 Hisui���죺HisUI����-���������datagrid��ѡ���¼��Ĳ��������仯���������ݲ����������
function Clear()
{
	SetElement("RowID","")
	SetElement("Code",""); 
	SetElement("Desc","");
	SetElement("Remark","");
	SetElement("InvalidFlag","");
	SetElement("EQType","");
	SetElement("EQFlag","");
	SetElement("MinPrice","");
	SetElement("MaxPrice","");
	SetElement("Hold1","");
	SetElement("Hold1Desc","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	var list=gbldata.split("^");
	SetElement("RowID",list[0])
	SetElement("Code",list[1]); 
	SetElement("Desc",list[2]);
	SetElement("Remark",list[3]);
	SetElement("InvalidFlag",list[4]);
	SetElement("EQType",list[5]);
	SetChkElement("EQFlag",list[6]);	// 2012-5-31	Mozy0083
	SetElement("MinPrice",list[7]);
	SetElement("MaxPrice",list[8]);
	SetElement("Hold1",list[9]);
	SetElement("Hold1Desc",list[14]);    //13+1
	SetElement("Hold2",list[10]);
	SetElement("Hold3",list[11]);
	SetElement("Hold4",list[12]);
	SetElement("Hold5",list[13]);
}
function disabled(value)//�һ�
{
	InitPage();
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
}
//add by HHM 20150917 HHM0021
function GetFinanceType(value)
{
	var val=value.split("^");
	var obj=document.getElementById("Hold1");	
	if (obj) obj.value=val[0];
	var obj=document.getElementById("Hold1Desc");
	if (obj) obj.value=val[2];
}	
function condition()//����
{
	if (CheckMustItemNull()) return true;
	var minPrice=parseFloat(GetElementValue("MinPrice"));  //modified by kdf 2018-02-08 ����ţ�549092
	var maxPrice=parseFloat(GetElementValue("MaxPrice"));   //modified by kdf 2018-02-08 ����ţ�549092
	if ((minPrice!="")&&(maxPrice!="")&&(minPrice>maxPrice))
	{
		messageShow("","","",t['-3002']);
		return true;
	}
	return false;
}
document.body.onload = BodyLoadHandler;
