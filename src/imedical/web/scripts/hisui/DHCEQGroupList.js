//add by zx 20171107 ZX0047
//�豸����ά����ϸ
//
var SelectedRow = -1; ///Modify By QW 2018-10-11 HISUI����
var rowid=0;
var length=0; //�������򣬴���DHC_EQGroupList�е�GL_Sort�ֶ�
function BodyLoadHandler() 
{
	initButtonWidth();///Add By QW 2018-10-11  HISUI����:�޸İ�ť����
	setButtonText();///Add By QW 2018-10-11  HISUI����:��ť���ֹ淶
	InitPage();
	InitUserInfo();
	disabled(true);//�һ�
}
function InitPage()
{
	var obj=document.getElementById("Badd");
	if (obj) obj.onclick=BUpdate_click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_click;
}

function BUpdate_click()
{	
	if(GetElementValue("EquipDR")=="")  //add by wl 2019-9-6   1022859   begin
	{ 
			messageShow("","","","�豸����Ϊ�ջ򲻴���")
			return;
	}    								//add by wl 2019-9-6    end
	
	if (!CheckData())
	{
		alertShow("�����̯����,֧��ռ�ȱ��������!");
		return;
	}
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,plist,"");
	var list=result.split("^");
	

	if (list[1]!="0")
	{		
		messageShow("","","",EQMsg("�����쳣!",list[1]));
	}
	else
	{
		
		if (list[0]>0)
		{
			
			  
			  alertShow("�����ɹ�")
			  window.location.reload();   //add by wy 2017-12-21
			 
		}
		else
		{
			messageShow("","","",t["01"])
		}
	}	
}
function BDelete_click()
{
	///modified by ZY0215 2020-04-02
	messageShow("confirm","","",t[-4003],"",confirmFun,"")
}
///modified by ZY0215 2020-04-02
function confirmFun()
{
	rowid=GetElementValue("RowID");
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
		messageShow("","","",t[-3002])
		return;
	}
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n")
	//messageShow("","","",result)
	var list=result.split("^");
	if (list[1]!="0")
	{
		messageShow("","","",EQMsg("�����쳣!",list[1]));
		
	}
	else
	{
		if (list[0]>0)
		{
			alertShow("ɾ���ɹ�")      
			window.location.reload();       //add by wy 2017-12-21
		}
		else
		{
			messageShow("","","",t["01"])
		}
	}	
}
///ѡ�����д����˷���
///Modify By QW 2018-10-11 HISUI���죺���ѡ���к󣬽����޷������������
///�����������index,rowdata�������������޸��ж��߼�
function SelectRowHandler(index,rowdata)
{
	if(index==SelectedRow)
    {
		Clear();	
		disabled(true)//�һ�
		SelectedRow=-1;	
		SetElement("RowID","");
		$('#tDHCEQGroupList').datagrid('unselectAll');
		return;
	 }
	SelectedRow=index;
	SetData(rowdata.TRowID);//���ú���
	disabled(false);//���һ�
}
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID");
	combindata=combindata+"^"+GetElementValue("GroupDR");
	combindata=combindata+"^"+GetElementValue("EquipDR");
  	combindata=combindata+"^"+GetChkElementValue("MainFlag");
  	combindata=combindata+"^"+GetElementValue("Sort");
  	combindata=combindata+"^"+GetElementValue("Remark");
  	combindata=combindata+"^"+GetElementValue("FromDate");
  	combindata=combindata+"^"+GetElementValue("ToDate");
  	combindata=combindata+"^"+GetElementValue("IncomeRate");
  	combindata=combindata+"^"+GetElementValue("ExpendRate");
  	combindata=combindata+"^"+GetElementValue("UpdateDate"); 
  	combindata=combindata+"^"+GetElementValue("UpdateTime");
  	combindata=combindata+"^"+GetElementValue("UpdateUserDR");
  	combindata=combindata+"^"+GetElementValue("InvalidFlag");
  	combindata=combindata+"^"+GetElementValue("Hold1"); 
  	combindata=combindata+"^"+GetElementValue("Hold2"); 
  	combindata=combindata+"^"+GetElementValue("Hold3"); 
  	combindata=combindata+"^"+GetElementValue("Hold4"); 
  	combindata=combindata+"^"+GetElementValue("Hold5");
  	return combindata;
}

function Clear()
{
	SetElement("RowID","")
	SetElement("EquipDR","");
	SetElement("EqName",""); 
	SetChkElement("MainFlag","");
	SetElement("Sort","");
	SetElement("Remark","");
	SetElement("FromDate","");
	SetElement("ToDate","");
	SetElement("IncomeRate","");
	SetElement("ExpendRate","");
	SetElement("UpdateDate","");
	SetElement("UpdateTime","");
	SetElement("UpdateUserDR","");
	SetElement("InvalidFlag","");
	SetElement("Hold1","");
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
	//alertShow("gbldata="+gbldata)
	var list=gbldata.split("^");
	SetElement("RowID",list[0]);
	SetElement("GroupDR",list[1]);
	SetElement("Name",list[2]);
	SetElement("EquipDR",list[3]); 
	SetElement("EqName",list[4]);
	SetChkElement("MainFlag",list[5]);
	SetElement("Sort",list[6]);
	SetElement("Remark",list[7]);
	SetElement("FromDate",list[8]);
	SetElement("ToDate",list[9]);
	SetElement("IncomeRate",list[10]);
	SetElement("ExpendRate",list[11]);
	SetElement("UpdateDate",list[12]);
	SetElement("UpdateTime",list[13]);
	SetElement("UpdateUserDR",list[14]);
	SetElement("InvalidFlag",list[15]);
	SetElement("Hold1",list[16]);
	SetElement("Hold2",list[17]);
	SetElement("Hold3",list[18]);
	SetElement("Hold4",list[19]);
	SetElement("Hold5",list[20]);
}
///Modify By QW 2018-10-11 HISUI���죺���ѡ���к󣬽����޷������������
function disabled(value)//�һ�
{
	InitPage();
	DisableBElement("BUpdate",value);
	DisableBElement("BDelete",value);	
	DisableBElement("Badd",!value);
}	
function condition()//����
{
	if (CheckMustItemNull()) return true;
	return false;
}
function CheckData()
{
	var IncomeRate=GetElementValue("IncomeRate");
	var ExpendRate=GetElementValue("ExpendRate");
	if((IncomeRate!="")&&(IncomeRate<=0)) return false;
	if((ExpendRate!="")&&(ExpendRate<=0)) return false;
	return true;
}
function GetEquip(value)
{
	var list=value.split("^")
	SetElement("EquipDR",list[1]);
	SetElement("EqName",list[0]);
}
document.body.onload = BodyLoadHandler;