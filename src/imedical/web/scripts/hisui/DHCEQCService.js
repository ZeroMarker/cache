///Modified By HZY 2011-10-18 HZY0017
///�޸ĺ���: BAdd_Click ,BUpdate_Click ,BDelete_Click

//������
var SelectedRow = -1;
var rowid=0;
function BodyLoadHandler() 
{
	initButtonWidth()  //hisui���� add by kdf 2018-10-25
	InitUserInfo();
	InitEvent();
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
    var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
	var obj=document.getElementById("BFind")
	if (obj) obj.onclick=BFind_Click;
}
function BFind_Click()
{
	var val="&Name="+GetElementValue("Name");
	val=val+"&Code="+GetElementValue("Code");
	val=val+"&Address="+GetElementValue("Address")
	val=val+"&Tel="+GetElementValue("Tel")
	val=val+"&Zip="+GetElementValue("Zip")
	val=val+"&Fax="+GetElementValue("Fax")
	val=val+"&ContPerson="+GetElementValue("ContPerson")
	val=val+"&ShName="+GetElementValue("ShName")
	val=val+"&Grading="+GetElementValue("Grading")
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCService"+val;
}
function disabled(value)//���һ�
{
	InitEvent();
	DisableBElement("BUpdate",value)

	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
}
function BClear_Click() 
{
	Clear();
	disabled(true);
}

///Modified By HZY 2011-10-18 HZY0017
function BAdd_Click() 
{
	if (CheckNull()) return;
	if((GetElementValue("EMail")!="")&&( GetElementValue("EMail").indexOf("@") <= -1 )) //2011-10-27 DJ DJ0097
	{
		alertShow("�����ʼ���ַ����,����ȷ����!")
		return
	}
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var plist=CombinData(); //��������
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n");
	if (result==0)		//Modified By HZY 2011-10-18 HZY0017
	{ 
		location.reload();
		return;
	}
	else
	{
		messageShow("","","",t[result]);
	}
}

///Modified By HZY 2011-10-18 HZY0017
function BUpdate_Click() 
{
	if (CheckNull()) return;
	var RowID=GetElementValue("RowID");
	if (RowID=="")
	{
		messageShow("","","",t[-4002]);
		return;
	}
	if (CheckNull()) return;
	if((GetElementValue("EMail")!="")&&( GetElementValue("EMail").indexOf("@") <= -1 )) //2011-10-27 DJ DJ0097
	{
		alertShow("�����ʼ���ַ����,����ȷ����!")
		return
	}
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var plist=CombinData(); //��������
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n");
	if (result==0)		//Modified By HZY 2011-10-18 HZY0017
	{ 
		location.reload();
		return;
	}
	else
	{
		messageShow("","","",t[result]);
	}	
}
function CombinData()
{
	var combindata="";
	combindata=GetElementValue("RowID") ;
	//Modified by HHM 20150914 HHM0019
	//ȥ���ַ���ǰ��ո�
    var Name=trim(GetElementValue("Name"));
    var Code=trim(GetElementValue("Code"));
  	combindata=combindata+"^"+Name ;//����2
  	combindata=combindata+"^"+Code ; //����3
  	//*****************************************
  	combindata=combindata+"^"+GetElementValue("Address") ; //��ַ4
  	combindata=combindata+"^"+GetElementValue("Tel") ; //�绰5
  	combindata=combindata+"^"+GetElementValue("Zip") ; //�ʱ�6
  	combindata=combindata+"^"+GetElementValue("Fax") ; //����7
  	combindata=combindata+"^"+GetElementValue("ContPerson") ; //��ϵ��8
  	combindata=combindata+"^"+GetElementValue("ShName") ; //������
  	combindata=combindata+"^"+GetElementValue("Grading") ; //�ȼ�
  	combindata=combindata+"^"+GetElementValue("Bank") ; //��������  2011-10-27 DJ DJ0097 Begin
  	combindata=combindata+"^"+GetElementValue("BankNo") ; //�����ʺ�
  	combindata=combindata+"^"+GetElementValue("EMail") ; //EMail
  	combindata=combindata+"^"+GetElementValue("Hold1") ; //
  	combindata=combindata+"^"+GetElementValue("Hold2") ; //
  	combindata=combindata+"^"+GetElementValue("Hold3") ; //
  	combindata=combindata+"^"+GetElementValue("Hold4") ; //
  	combindata=combindata+"^"+GetElementValue("Hold5") ; // 2011-10-27 DJ DJ0097 end
  	return combindata;
}

///Modified By HZY 2011-10-18 HZY0017
function BDelete_Click() 
{
	///modified by ZY0215 2020-04-02
	messageShow("confirm","","",t[-4003],"",confirmFun,"")
}
///modified by ZY0215 2020-04-02
function confirmFun()
{
	rowid=GetElementValue("RowID");
	if (rowid=="")
	{
		messageShow("","","",t[-4002]);
		return;
	}
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n");
	if (result==0)		//Modified By HZY 2011-10-18 HZY0017
	{ 
		location.reload();
		return;
	}
	else
	{
		messageShow("","","",t[result]);
	}
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	/*
	/if (CheckItemNull(2,"Name")) return true;
	if (CheckItemNull(2,"Code")) return true;
	*/
	return false;
}	
///ѡ�����д����˷���
// modified by kdf 2018-10-18 hisui-����
function SelectRowHandler(index,rowdata)	{
	if (SelectedRow==index)
		{
			
		Clear();
		SetElement("RowID","");
		SelectedRow=-1;
		$('#tDHCEQCService').datagrid('unselectAll');  //hisui���� add by kdf 2018-10-18
		disabled(true)
		}
	else{
		SelectedRow=index;
		rowid=rowdata.TRowID ;
		SetElement("RowID",rowid);
		SetData(rowid);//���ú���
		disabled(false)
		}
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="")return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n");
	var list=gbldata.split("^");
	//	alertShow("list"+list);
	SetElement("Name",list[1]); //����
	SetElement("Code",list[2]); //����
	SetElement("Address",list[3]);//��ַ
	SetElement("Tel",list[4]); //�绰
	SetElement("Zip",list[5]); //�ʱ�
	SetElement("Fax",list[6]); //����
	SetElement("ContPerson",list[7]); //��ϵ��
	SetElement("ShName",list[8]); //������
	SetElement("Grading",list[9]); //�ȼ�
	SetElement("InvalidFlag",list[10]); //��Ч��־
	SetElement("Bank",list[11]) //2011-10-27 DJ DJ0097 begin
	SetElement("BankNo",list[12])
	SetElement("EMail",list[13])
	SetElement("Hold1",list[14])
	SetElement("Hold2",list[15])
	SetElement("Hold3",list[16])
	SetElement("Hold4",list[17])
	SetElement("Hold5",list[18]) //2011-10-27 DJ DJ0097 end

}
function Clear()
{
	SetElement("RowID","");
	SetElement("Name",""); //����
	SetElement("Code",""); //����
	SetElement("Address",""); //��ַ
	SetElement("Tel",""); //�绰
	SetElement("Zip",""); //�ʱ�
	SetElement("Fax",""); //����
	SetElement("ContPerson",""); //��ϵ��
	SetElement("ShName",""); //������
	SetElement("Grading",""); //�ȼ�
	SetElement("Bank","") //2011-10-27 DJ DJ0097 begin
	SetElement("BankNo","")
	SetElement("EMail","")
	SetElement("Hold1","")
	SetElement("Hold2","")
	SetElement("Hold3","")
	SetElement("Hold4","")
	SetElement("Hold5","") //2011-10-27 DJ DJ0097 end
	}
document.body.onload = BodyLoadHandler;