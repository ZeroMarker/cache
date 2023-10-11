//�豸��λ
var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{
	//modified by cjt 20230212 �����3221885 UIҳ�����
	initPanelHeaderStyle();
	initButtonColor();
	InitUserInfo();
	InitEvent();	
	//KeyUp("Uom");	//���ѡ��
	disabled(true);//�һ�
	SetComboboxRequired(); //hisui���� add by MWZ 2018-08-28
	initButtonWidth(); //hisui���� add by MWZ 2018-08-28
	setButtonText();	//HISUI���� add by MWZ 2018-09-28
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
	var obj=document.getElementById("BFind"); // add by sjh SJH0042 2020-12-16 ���Ӳ�ѯ
	if (obj) obj.onclick=BFind_Click; 
}

// add by sjh SJH0042 2020-12-16 ���Ӳ�ѯ
function BFind_Click()
{
	if (!$(this).linkbutton('options').disabled){
		$('#tDHCEQCUOM').datagrid('load',{ComponentID:getValueById("GetComponentID"),Uomtype:getValueById("Uomtype"),Desc:getValueById("Desc"),Code:getValueById("Code"),Remark:getValueById("Remark")});
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
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		alertShow("ɾ���ɹ�!")
		$('#tDHCEQCUOM').datagrid('reload'); 
		Clear();
		disabled(true);
	}	
}
//medified by myl 2260706  20211109
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
		messageShow("","","",t[-3001]);
		return
	}
	if (result>0)
	{
		$('#tDHCEQCUOM').datagrid('reload'); 
        $.messager.popover({msg:"����ɹ�",type:'success'});
		Clear();
		disabled(true)//���һ�
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
		messageShow("","","",t[-3001])
		return
		}
	if (result>0)
	{
		alertShow("�����ɹ�!")
		$('#tDHCEQCUOM').datagrid('reload'); 
		Clear();
		disabled(true);
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

///modify by lmm 2018-08-17
///������hisui���� ����ֵ��ȡ��ʽ ��������
///��Σ�index �к�
///      rowdata ��json����
function SelectRowHandler(index,rowdata)
	{
		
	if (SelectedRow==index)	{
		Clear();
		disabled(true)//�һ�		
		SelectedRow=-1;
		rowid=0;
		SetElement("RowID","");
		
		$('#tDHCEQCUOM').datagrid('unselectAll');  //add by kdf 
		
		}
	else{
		SelectedRow=index;
		rowid=rowdata.TRowID   //add by kdf
		SetData(rowid);//���ú���
		disabled(false)//���һ�
		}
}
function Clear()
{
	SetElement("Uom","");
	SetElement("UomDR","")
	SetElement("Uomtype","");
	SetElement("Desc","");
	SetElement("Code","");
	SetElement("Remark","");
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
