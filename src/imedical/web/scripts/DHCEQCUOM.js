//�豸��λ
var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{	    
    InitUserInfo();
	InitEvent();	
	//KeyUp("Uom");	//���ѡ��
	disabled(true);//�һ�
	//Muilt_LookUp("Uom");
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
function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
	alertShow(t[-3001])
	return;
	}
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		alertShow("ɾ���ɹ�!")
		location.reload();
	}	
}
function BUpdate_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n");
	if(result<0) //modified by HHM 20150831 HHM0012
	{
		alertShow(t[-3001]);
		return
	}
	if (result>0)
	{
		alertShow("�����ɹ�!")
		location.reload();
	}	
}
function BAdd_Click() //����
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n")
	if(result<0) //modified by HHM 20150831 HHM0012
	{
		alertShow(t[-3001])
		return
		}
	if (result>0)
	{
		alertShow("�����ɹ�!")
		location.reload();
	}	
}	
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("UomDR") ;//���
  	combindata=combindata+"^"+GetElementValue("Uomtype") ; //����
  	
  	//add By HHM 20150830 HHM0012
  	//DHC_EQCUOM��������ԣ�UOM_Code,UOM_Desc,UOM_InvalidFlag,UOM_Remark
  	combindata=combindata+"^"+GetElementValue("Code") ; //����
  	combindata=combindata+"^"+GetElementValue("Desc") ; //����
  	combindata=combindata+"^"+GetElementValue("Remark") ; //��ע
  	return combindata;
  	//************************************************************
}

///ѡ�����д����˷���
function SelectRowHandler()
	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCUOM');//+����� ������������ʾ Query ����Ĳ���
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
		SetElement("Desc","");      //����ţ�396169 add by mwz 2017-06-27 start
		SetElement("Code","");
		SetElement("Remark","");
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);//���ú���
		disabled(false)//���һ�
		}
}
function Clear()
{
	SetElement("Uom","");
	SetElement("UomDR","")
	SetElement("Uomtype","");
	}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	var list=gbldata.split("^");
	SetElement("RowID",list[0]); //rowid
	SetElement("Uom",list[1]); //��λ
	SetElement("Uomtype",list[2]);//����
	SetElement("UomDR",list[3]); //��λ����
	
	//add By HHM 20150831 HHM0012
	SetElement("Code",list[4]); //����
	SetElement("Desc",list[5]); //����
	SetElement("Remark",list[6]); //��ע
}

function UomDR(value) // ��λ
{
	var obj=document.getElementById("UomDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
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
	/*
	if (CheckItemNull(1,"Uom")) return true;
	if (CheckItemNull(0,"Uomtype")) return true;
	*/
	return false;
}
document.body.onload = BodyLoadHandler;