//���Ҽ������� ������ⲿ��
function BodyLoadHandler() 
{
	InitUserInfo();
	InitEvent();
	disabled(true)//�һ�
	initButtonWidth();
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
	val=val+"&Contperson="+GetElementValue("Contperson")
	val=val+"&Shname="+GetElementValue("Shname")
	val=val+"&Grading="+GetElementValue("Grading")
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCMeasureDept"+val;
}
function BClear_Click() 
{
	Clear();
	disabled(true);
}
function BDelete_Click() 
{
	var rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n");
	if (result>0) {
		alertShow("ɾ���ɹ�!");  //add by kdf 2018-01-16 ����ţ�528983
		location.reload();}	
}
function BUpdate_Click() 
{
	if (condition()) return;
	if((GetElementValue("EMail")!="")&&( GetElementValue("EMail").indexOf("@") <= -1 )) //2011-10-27 DJ DJ0097
	{
		alertShow("�����ʼ���ַ����,����ȷ����!")
		return
	}
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n");
	if (result==-99) //2010-06-11 ���� begin
 	{
	 	alertShow("�����ظ�!����!")
	 	return
	 } //2010-06-11 ���� end
	if (result>0){
		alertShow("���³ɹ�!"); // add by kdf 2018-01-16 ����ţ�528977
		location.reload();}	
}
function BAdd_Click() //����
{
	if (condition()) return;
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
	if (result==-99) //2010-06-11 ���� begin
 	{
	 	alertShow("�����ظ�!����!")
	 	return
	 } //2010-06-11 ���� end
	if (result>0){
	alertShow("���ӳɹ�!"); // add by kdf 2018-01-16 ����ţ�528975
	location.reload(); }
}	
	function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("Name") ;//����2
  	combindata=combindata+"^"+GetElementValue("Code") ; //����3
  	combindata=combindata+"^"+GetElementValue("Address") ; //��ַ4
  	combindata=combindata+"^"+GetElementValue("Tel") ; //�绰5
  	combindata=combindata+"^"+GetElementValue("Zip") ; //�ʱ�6
  	combindata=combindata+"^"+GetElementValue("Fax") ; //����7
  	combindata=combindata+"^"+GetElementValue("Contperson") ; //��ϵ��8
  	combindata=combindata+"^"+GetElementValue("Shname") ; //������9
  	combindata=combindata+"^"+GetElementValue("Grading") ; //�ȼ�10
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

///ѡ�����д����˷���
var SelectedRow = -1;
var rowid=0;
function SelectRowHandler(index,rowdata)
{
	if (SelectedRow==index)
	{
		Clear();
		disabled(true)//�һ�
		SelectedRow=-1;
		rowid=0;
		SetElement("RowID","");
	}
	else
	{
		SelectedRow=index;
		rowid=rowdata.TRowID;
		SetData(rowid);//���ú���
		disabled(false)//���һ�
	}
}
function Clear()
{
	SetElement("RowID","");
	SetElement("Name",""); //����1
	SetElement("Code","");//����2
	SetElement("Address","");//��ַ3
	SetElement("Tel","");//�绰4
	SetElement("Zip","");//�ʱ�
	SetElement("Fax","");//����
	SetElement("Contperson","");//��ϵ��
	SetElement("Shname","");//������
	SetElement("Grading","");//�ȼ�
	SetElement("Bank","") //2011-10-27 DJ DJ0097 begin
	SetElement("BankNo","")
	SetElement("EMail","")
	SetElement("Hold1","")
	SetElement("Hold2","")
	SetElement("Hold3","")
	SetElement("Hold4","")
	SetElement("Hold5","") //2011-10-27 DJ DJ0097 end
	}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n");
	var list=gbldata.split("^");
	//alertShow("list"+list);
	SetElement("RowID",list[0]); //rowid
	SetElement("Name",list[1]); //����1
	SetElement("Code",list[2]);//����2
	SetElement("Address",list[3]);//��ַ3
	SetElement("Tel",list[4]);//�绰4
	SetElement("Zip",list[5]);//�ʱ�
	SetElement("Fax",list[6]);//����
	SetElement("Contperson",list[7]);//��ϵ��
	SetElement("Shname",list[8]);//������
	SetElement("Grading",list[9]);//�ȼ�
	SetElement("Bank",list[10]) //2011-10-27 DJ DJ0097 begin
	SetElement("BankNo",list[11])
	SetElement("EMail",list[12])
	SetElement("Hold1",list[13])
	SetElement("Hold2",list[14])
	SetElement("Hold3",list[15])
	SetElement("Hold4",list[16])
	SetElement("Hold5",list[17]) //2011-10-27 DJ DJ0097 end
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
	/*if (CheckItemNull(2,"Name")) return true;
	if (CheckItemNull(2,"Code")) return true;
	*/
	return false;
}
document.body.onload = BodyLoadHandler; //�������� ����