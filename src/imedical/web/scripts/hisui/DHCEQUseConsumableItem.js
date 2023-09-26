///add by jyp 2016-11-18
function BodyLoadHandler()
{
	initButtonWidth();///Add By QW 2018-10-11 HISUI����:�޸İ�ť����
	setButtonText();///Add By QW 2018-10-11 HISUI����:��ť���ֹ淶
	InitPage();
}

function InitPage()
{
	document.getElementById('BAdd').onclick=BAdd_Click;
	document.getElementById('BUpdate').onclick=BUpdate_Click;
	document.getElementById('BDelete').onclick=BDelete_Click;
	setRequiredElements("ConsumableItem^UseRecord")   //add by yh 20190801
	var obj=document.getElementById("Quantity");         //add by czf 461821
	if (obj) obj.onkeyup=Num_KeyUp;
	var obj=document.getElementById("ConsumableItem");
	if (obj) obj.onchange=ValueClear;
}

function FillData()
{
	var rowid=GetElementValue("RowID");	
	if ((rowid=="")||(rowid<1)) 
	{	
	var encmeth=GetElementValue("GetData");
	if (encmeth=="")
	{
		messageShow("","","",t[-4001]);
		return;
	}
	var result=cspRunServerMethod(encmeth,'','',rowid);
	SetData(result);
}
}

function BAdd_Click() //����
{
	if (GetElementValue("RowID")!="")	
	{
		alertShow("�벻Ҫѡ��һ����¼")
		return
	}
	if (GetElementValue("UseRecordDR")=="")	
	{
		alertShow("ʹ�ü�¼����Ϊ��!");
		return
	}
	if (GetElementValue("ConsumableItemDR")=="")	
	{
		alertShow("������Ŀ����Ϊ��!")
		return
	}		
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,plist);
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		messageShow("","","",t[-3001])
		return
		}
	if (result>0)location.reload();	
}

function BUpdate_Click()
{
	if (GetElementValue("RowID")=="")	
	{
		alertShow("��ѡ��һ����¼")
		return
	}
	if (GetElementValue("UseRecordDR")=="")	
	{
		alertShow("ʹ�ü�¼����Ϊ��!");
		return
	}
	if (GetElementValue("ConsumableItemDR")=="")	
	{
		alertShow("������Ŀ����Ϊ��!")
		return
	}		
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,plist);
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		messageShow("","","",t[-3001])
		return
		}
	if (result>0)location.reload();	
}

function BDelete_Click() //ɾ��
{
	///modified by ZY0215 2020-04-02
	messageShow("confirm","","","ȷ��Ҫɾ����������Ŀ��¼?","",confirmFun,"")
}
///modified by ZY0215 2020-04-02
function confirmFun()
{
	if (GetElementValue("RowID")=="")	
	{
		alertShow("��ѡ��һ����¼")
		return
	}
	var encmeth=GetElementValue("GetDelete");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,GetElementValue("RowID"));
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		messageShow("","","",t[-3001])
		return
	}
	if (result>=0)location.reload();	
}

var SelectedRow = -1; ///Modify By QW 2018-10-11 HISUI����
///ѡ�����д����˷���
///Modify By QW 2018-10-11 HISUI���죺���ѡ���к󣬽����޷������������
///�����������index,rowdata�������������޸��ж��߼�
function SelectRowHandler(index,rowdata)
{
	if(index==SelectedRow)
    {
	    SelectedRow=-1;	
		document.getElementById('RowID').value='';
		document.getElementById('UseRecord').value='';
		document.getElementById('ConsumableItem').value='';
		document.getElementById('UseRecordDR').value='';
		document.getElementById('ConsumableItemDR').value='';
		document.getElementById('Quantity').value='';
		document.getElementById('Amount').value='';
		document.getElementById('Price').value='';  //Add BY QW20181029 �����:581780 ��յ���
		$('#tDHCEQUseConsumableItem').datagrid('unselectAll');
		return;
	 }
	document.getElementById('RowID').value=rowdata.TRowID;
	document.getElementById('UseRecord').value=rowdata.TUseRecord;
	document.getElementById('ConsumableItem').value=rowdata.TConsumableItem;
	document.getElementById('UseRecordDR').value=rowdata.TUseRecordDR;
	document.getElementById('ConsumableItemDR').value=rowdata.TConsumableItemDR;
	document.getElementById('Quantity').value=rowdata.TQuantity;
	document.getElementById('Price').value=rowdata.TPrice;
	document.getElementById('Amount').value=rowdata.TAmount;
	SelectedRow=index;
}
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("UseRecordDR") ;//
  	combindata=combindata+"^"+GetElementValue("ConsumableItemDR") ; //
  //	combindata=combindata+"^"+GetElementValue("UomDR") ;//��λ
  	combindata=combindata+"^"+GetElementValue("Quantity") ;//����
  //	combindata=combindata+"^"+GetElementValue("Price") ;//����
  	combindata=combindata+"^"+GetElementValue("Amount") ; //���
  	return combindata;
}
function GetUseRecordInfo(value)
{
	var List=value.split("^");
	var obj=document.getElementById('UseRecord');
	obj.value=List[2];
	var obj=document.getElementById('UseRecordDR');
	obj.value=List[0];	
}
function GetConsumableItemInfo(value)
{
	var List=value.split("^");						// modify by wl 2019-9-10 begin 1025258
	var obj=document.getElementById('ConsumableItem');
	obj.value=List[2];
	var obj=document.getElementById('ConsumableItemDR');
	obj.value=List[1];
	var obj=document.getElementById('Price');	//add by czf 461821 begin
	obj.value=List[5];							   // modify by wl 2019-9-10 end
}

function Num_KeyUp()
{
	var Num=GetElementValue("Quantity");
	var Price=GetElementValue("Price");
	if (Num!="")
	{
		Amount=Num*Price;
	}
	else
	{
		Amount=0;
	}
	SetElement("Amount",Amount.toFixed(2));
}

function ValueClear()
{
	SetElement("Quantity","");
	SetElement("Price","");
	SetElement("Amount","");
}									 //add by czf 461821 end
/*
function UnitDR(value) // ��λ
{
	messageShow("","","",value);
	var val=value.split("^");
	var obj=document.getElementById("UomDR");	
	if (obj) obj.value=val[1];
	var obj=document.getElementById("Uom");	
	if (obj) obj.value=val[0];

}
*/
document.body.onload = BodyLoadHandler;