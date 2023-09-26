///add by jyp 2016-11-18
function BodyLoadHandler()
{
	InitPage();
}

function InitPage()
{
	document.getElementById('BAdd').onclick=BAdd_Click;
	document.getElementById('BUpdate').onclick=BUpdate_Click;
	document.getElementById('BDelete').onclick=BDelete_Click;
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
		alertShow(t[-4001]);
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
		alertShow(t[-3001])
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
		alertShow(t[-3001])
		return
		}
	if (result>0)location.reload();	
}

function BDelete_Click() //ɾ��
{
	if (GetElementValue("RowID")=="")	
	{
		alertShow("��ѡ��һ����¼")
		return
	}
	/// Mozy	2017-10-12	463564	����ɾ��ȷ����ʾ
	var truthBeTold = window.confirm("ȷ��Ҫɾ����������Ŀ��¼?");
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetDelete");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,GetElementValue("RowID"));
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		alertShow(t[-3001])
		return
	}
	if (result>=0)location.reload();	
}

var select=-1;
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectRow=rowObj.rowIndex;
	if(select!=selectRow){
	document.getElementById('RowID').value=document.getElementById("TRowIDz"+selectRow).value;
	document.getElementById('UseRecord').value=document.getElementById("TUseRecordz"+selectRow).innerText;
	document.getElementById('ConsumableItem').value=document.getElementById("TConsumableItemz"+selectRow).innerText;
	document.getElementById('UseRecordDR').value=document.getElementById("TUseRecordDRz"+selectRow).value;
	document.getElementById('ConsumableItemDR').value=document.getElementById("TConsumableItemDRz"+selectRow).value;
	//document.getElementById('Uom').value=document.getElementById("TUomz"+selectRow).innerText;
	//document.getElementById('UomDR').value=document.getElementById("TUomDRz"+selectRow).innerText;
	document.getElementById('Quantity').value=document.getElementById("TQuantityz"+selectRow).innerText;
	document.getElementById('Price').value=document.getElementById("TPricez"+selectRow).innerText;    //add by kdf 2017-12-26 ����ţ�468836
	document.getElementById('Amount').value=document.getElementById("TAmountz"+selectRow).innerText;
	select=selectRow;
	}
	
	else{
		select=-1;
	document.getElementById('RowID').value='';
	document.getElementById('UseRecord').value='';
	document.getElementById('ConsumableItem').value='';
	document.getElementById('UseRecordDR').value='';
	document.getElementById('ConsumableItemDR').value='';
	//document.getElementById('Uom').value='';
	//document.getElementById('UomDR').value='';
	document.getElementById('Quantity').value='';
	//document.getElementById('Price').valu;e=''
	document.getElementById('Amount').value='';
	}
	
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
	var List=value.split("^");
	var obj=document.getElementById('ConsumableItem');
	obj.value=List[1];
	var obj=document.getElementById('ConsumableItemDR');
	obj.value=List[0];
	var obj=document.getElementById('Price');	//add by czf 461821 begin
	obj.value=List[4];
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
	alertShow(value);
	var val=value.split("^");
	var obj=document.getElementById("UomDR");	
	if (obj) obj.value=val[1];
	var obj=document.getElementById("Uom");	
	if (obj) obj.value=val[0];

}
*/
document.body.onload = BodyLoadHandler;