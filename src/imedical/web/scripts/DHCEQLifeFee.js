//�豸�������ڷ��ù���
var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{	
	InitUserInfo();	
	show();	
	if (1==GetElementValue("ReadOnly"))
	{
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BAudit",true);
		return;
	}
	
	if(GetElementValue("LFAuditUserDR")=="")
	{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	}
	else
	{
		var obj=document.getElementById("BUpdate");
	if (obj)obj.onclick=YBUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj)obj.onclick=YDelete_Click;
		}
	var obj=document.getElementById("BAudit"); //���
	if (obj) obj.onclick=BAudit_Click;
	var RowID=GetElementValue("RowID")
	if (RowID=="")
	{
		DisableBElement("BUpdate",false)
		DisableBElement("BDelete",true)
		DisableBElement("BAudit",true)
	}
	 KeyUp("UseLoc^MangerLoc^FeeType^Equip")
	 Muilt_LookUp("UseLoc^MangerLoc^FeeType^Equip");
}
function YDelete_Click()
{
	alertShow(t[-2022])
	}
	function YBUpdate_Click()
{
	alertShow(t[-2021])
	}
function BUpdate_Click() 
{
	if (condition()) return;
	SaveData();
}
function SaveData()
{
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var plist=CombinData(); //��������
	//alertShow("plist"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n")
	if(result==-1002)alertShow(t[-2011]);
	if (result>0)
	{	
	//location.reload();	
	parent.frames["DHCEQLifeFee"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQLifeFee&RowID='+result;
	}
}
function CombinData()
{
	var combindata="";
   
	combindata=GetElementValue("RowID") ;
	//combindata=combindata+"^"+GetElementValue("EquipDR") ;//�豸����
  	combindata=combindata+"^"+GetElementValue("EquipDR") ; //�豸����1
  	//combindata=combindata+"^"+GetElementValue("MangerLoc") ; //�������2
  	combindata=combindata+"^"+GetElementValue("MangerLocDR") ; //�������2
  	//combindata=combindata+"^"+GetElementValue("UseLoc") ; //ʹ�ÿ���3
  	combindata=combindata+"^"+GetElementValue("UseLocDR") ; //ʹ�ÿ���3
  	combindata=combindata+"^"+GetElementValue("FeeDate") ; //��������4
  	combindata=combindata+"^"+GetElementValue("FeeTypeDR") ; //��������5
  	combindata=combindata+"^"+GetElementValue("UseFee") ; //����6
  	combindata=combindata+"^"+GetElementValue("InvoiceDate") ; //��Ʊ����7
  	combindata=combindata+"^"+GetElementValue("InvoiceDept") ; //��Ʊ��λ8
  	combindata=combindata+"^"+GetElementValue("InvoiceNo") ; //��Ʊ��9
  	combindata=combindata+"^"+GetElementValue("Remark") ; //��ע11
  	combindata=combindata+"^"+curUserID;//�����12
  	return combindata;
}
//////ɾ��
function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if(result==-1002){alertShow(t[-2022]);}
	if (result>0) parent.location.href="dhceqlifefee.csp" //	Clear();
}
function Clear()
{
	SetElement("Equip",""); //�豸����
	SetElement("MangerLoc","");//�������
	SetElement("UseLoc","");//ʹ�ÿ���
	SetElement("FeeType","");//��������
	SetElement("InvoiceDate","");//��Ʊ����
	SetElement("FeeDate","");//��������
	SetElement("InvoiceDept","");//��Ʊ��λ
	SetElement("InvoiceNo","");//��Ʊ��
	SetElement("UseFee","");//����
	SetElement("Remark","");//��ע	
	DisableBElement("BDelete",true)	
	DisableBElement("BAudit",true)
	
}
///ѡ�����д����˷���
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQLifeFee');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (SelectedRow==selectrow)	{	
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		}
	else{
		SelectedRow=selectrow;
		rowid=GetCElementValue("TRowIDz"+SelectedRow);
		SetElement("RowID",rowid);
		SetData(rowid);
		}
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="")return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	var list=gbldata.split("^");
	//alertShow(list);
	var sort=14
	SetElement("Equip",list[1]); //�豸����
	SetElement("MangerLoc",list[2]);//�������
	SetElement("UseLoc",list[3]);//ʹ�ÿ���
	SetElement("FeeType",list[4]);//��������
	SetElement("InvoiceDate",list[5]);//��Ʊ����
	SetElement("FeeDate",list[6]);//��������
	SetElement("InvoiceDept",list[7]);//��Ʊ��λ
	SetElement("InvoiceNo",list[8]);//��Ʊ��
	SetElement("UseFee",list[9]);//����
	SetElement("Remark",list[10]);//��ע
}
function sEquip(value)//�豸����
{
	//alertShow(value);
	var obj=document.getElementById("EquipDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//alertShow(val[1]);
	parent.frames["DHCEQBanner"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBanner&RowIDB='+val[1];
}
function FeeTypeDR(value) // ��������
{
	//alertShow(value);
	var obj=document.getElementById("FeeTypeDR");
	var val=value.split("^");	
	if (obj) obj.value=val[2];
	//alertShow(val[2]);
}
function show() 
{
    var encmeth=GetElementValue("GetData");
    if (encmeth=="")return;
    var rowid=GetElementValue("RowID") ;
    if (rowid=="")
	{ 
		//Clear()
		return;
	}
    var gbldata=cspRunServerMethod(encmeth,'','',rowid);
    var list=gbldata.split("^");
    //alertShow("list:"+list)
    SetElement("Equip",list[1]); //�豸����
	SetElement("MangerLoc",list[2]);//�������
	SetElement("UseLoc",list[3]);//ʹ�ÿ���
	SetElement("FeeType",list[4]);//��������
	SetElement("InvoiceDate",list[5]);//��Ʊ����
	SetElement("FeeDate",list[6]);//��������
	SetElement("InvoiceDept",list[7]);//��Ʊ��λ
	SetElement("InvoiceNo",list[8]);//��Ʊ��
	SetElement("UseFee",list[9]);//����
	SetElement("Remark",list[10]);//��ע
	SetElement("FeeTypeDR",list[11]);//���ʹ���
	SetElement("EquipDR",list[12]);//�豸���ƴ���
	SetElement("UseLocDR",list[13]);//ʹ�ÿ��Ҵ���
	SetElement("MangerLocDR",list[14]);//������Ҵ���
	SetElement("LFAuditUserDR",list[15]);//�����
	if(list[15]=="") //���
	{
		DisableBElement("BUpdate",false)
		DisableBElement("BDelete",false)
		DisableBElement("BAudit",false)
		}
		else{
		DisableBElement("BUpdate",true)
		DisableBElement("BDelete",true)
		DisableBElement("BAudit",true)
			}
	if (list[16]=="N") //�Ƿ��˹�¼�� 
	{
		DisableBElement("BUpdate",true)
		DisableBElement("BDelete",true)
		DisableBElement("BAudit",true)
		}
}
function BAudit_Click() //���
{
	var encmeth=GetElementValue("GetUpdate1");
	if (encmeth=="")return;
	//var plist=CombinDataBAudit(); //��������
	var plist=GetElementValue("RowID") ;
   plist=plist+"^"+curUserID;
   //alertShow(plist)
   if (plist=="") { alertShow(t[-4005])}
	var result=cspRunServerMethod(encmeth,'','',plist);//plist=var
	if (result==-1003)
	{	
	alertShow(t[-1003])	
	return
	}
	if (result>0)location.reload();
}
function MangerLocDR(value) // �������
{
	//alertShow(value);
	var obj=document.getElementById("MangerLocDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//alertShow(val[1])
}

function UseLocDR(value) // ʹ�ÿ���
{
	//alertShow(value);
	var obj=document.getElementById("UseLocDR");
	var val=value.split("^");
	if (obj) obj.value=val[1];
}
function disabled(value)//���һ�
{
	//InitEvent();
	DisableBElement("BAudit",value)
	DisableBElement("BDelete",value)	
	DisableBElement("BUpdate",value)
}
function condition()//����
{
	if (CheckMustItemNull()) return true;
	/*
	if (CheckItemNull(1,"Equip")) return true;
	if (CheckItemNull(1,"UseLoc")) return true;
	if (CheckItemNull(0,"UseFee")) return true;
	if (CheckItemNull(0,"FeeDate")) return true;
	if (CheckItemNull(1,"FeeType")) return true;
	*/
	return false;
}

document.body.onload = BodyLoadHandler;