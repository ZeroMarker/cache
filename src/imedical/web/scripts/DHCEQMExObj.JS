///--------------------------------------------
///Created By zx 
///Description:�ڴ���ά���˵�������ϵͳ�����Ӳ˵�?ʵ�ֶ�ϵͳ������Ϣ�Ĺ���?
///--------------------------------------------

var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{		
    InitUserInfo(); //ϵͳ����
	InitEvent();
	KeyUp("Type^Name","N")     //add by wy 2018-3-1
	Muilt_LookUp("Type^Name")	//add by wy 2018-03-21 ����544109 
	disabled(true);//�һ�		
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
	var obj=document.getElementById("ld"+GetElementValue("GetComponentID")+"iName");
	if (obj) obj.onclick=BName_Click;
		
	var obj=document.getElementById("ExType");
	if (obj) obj.onchange=ExType;
}
function ExType()
{
	var ExType=GetElementValue("ExType")
	if (ExType=="1")
	{
		SetElementsReadOnly("ExID^No^ExObjLoc",true)
		var obj=document.getElementById(GetLookupName("Name"));  //add by jyp 2018-03-12 544947
		obj.style.display=""                                     //add by jyp 2018-03-12 544947
	}
	else if (ExType=="9")
	{
		SetElementsReadOnly("ExID^No^ExObjLoc",false)
		var obj=document.getElementById(GetLookupName("Name"));  //add by jyp 2018-03-12 544947
		obj.style.display="none"                                 //add by jyp 2018-03-12 544947
	}
}

function BFind_Click()
{
	var val="&Name"+GetElementValue("Name");
	val=val+"&No="+GetElementValue("No");	
	combindata=combindata+"^"+GetElementValue("ExType") ; //
	val=val+"&ExID="+GetElementValue("ExID")
	val=val+"&TypeDR="+GetElementValue("TypeDR")
	val=val+"&Remark="+GetElementValue("Remark")
	val=val+"&InvalidFlag="+GetElementValue("InvalidFlag")
	val=val+"&ExObjLoc="+GetElementValue("ExObjLoc")	
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMExObj"+val;
}
function BClear_Click() 
{
	Clear();
	disabled(true);
}
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("Name") ;//
  	combindata=combindata+"^"+GetElementValue("No") ; //
  	combindata=combindata+"^"+GetElementValue("ExObjLocDR") ; //
  	combindata=combindata+"^"+GetElementValue("ExType") ; //
   	combindata=combindata+"^"+GetElementValue("ExID") ; //
   	combindata=combindata+"^"+GetElementValue("TypeDR") ; //
   	combindata=combindata+"^"+GetElementValue("Remark") ; //
   	
  	return combindata;
}
function BAdd_Click() //����
{
	var ExType=GetElementValue("ExType");
	if (ExType=="")
	{
		alertShow("��ѡ����չ����!")
		return
	}
	var ExID=GetElementValue("ExID");  //���ӵ�������Ϊ��ʱ���� ����ţ�267914  add by mwz 2016-10-09 begin
	var Name=GetElementValue("Name");
	if ((ExType=="1")&&(ExID==""))
	{
		alertShow("��ѡ����!")     //add by wy 2018-3-1
		return
	}
	if ((ExType=="9")&&(Name==""))   
	{
		alertShow("����������!")
		return
	}               //add by mwz 2016-10-09 end
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,plist,'2');
	result=result.replace(/\\n/g,"\n")
	if(result<0)
	{
		if (result=="-1001")
		{
			alertShow(t[-1001])
			return
		}
		alertShow(t[-3001])
		return
	}
	else
	{
		alertShow("�����ɹ�!")
	   location.reload();
	}	
}	
function BUpdate_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,plist,'2');
	result=result.replace(/\\n/g,"\n")
	if(result=="") 
	{
		alertShow(t[-3001]);
		return
	}
	else 
	{
		alertShow("���³ɹ�!")
		location.reload();	
	}
}
function BDelete_Click() 
{
	var rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);//����ţ�269196  add by csy 2016-10-10
    if (!truthBeTold) return;//����ţ�269196  add by csy 2016-10-10
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
		alertShow(t[-3001])
		return;
	}
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n");
	if (result==0) 
	{
		alertShow("ɾ���ɹ�!")
		location.reload();	
	}
}
///ѡ������д����˷���
function SelectRowHandler()
{	
	var eSrc=window.event.srcElement;
	
	var objtbl=document.getElementById('tDHCEQMExObj');  //t+����� ������������ʾ Query ����Ĳ���
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
		
		var obj = document.getElementById("TTypez"+selectrow);
		var Type = obj.innerText;		
		var obj = document.getElementById("Type");
		obj.value = Type;
		
		disabled(false);//���һ�
	}
}
function Clear()
{
	SetElement("RowID","")
	SetElement("Name",""); 
	SetElement("No","");	
	SetElement("ExType","");	
	SetElement("ExID","")
	SetElement("Type",""); 
	SetElement("TypeDR","");
	SetElement("Remark","");	
	SetElement("InvalidFlag","");	
	SetElement("ExObjLoc","");
	
	SetElement("ExObjLocDR","");  //add by kdf 2018-02-08 ����ţ�544170
	
	}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	//alertShow(gbldata);
	var list=gbldata.split("^");
	var sort=15
	
	SetElement("RowID",rowid); //rowid
	SetElement("Name",list[0]); //
	SetElement("No",list[1]); //
	SetElement("ExObjLocDR",list[2]);
	SetElement("ExObjLoc",list[sort+0]);
	SetElement("ExType",list[3]);//
	SetElement("ExID",list[4]); //
	SetElement("TypeDR",list[5]); //
	SetElement("Remark",list[6]); //
	SetElement("InvalidFlag",list[13]);//
}

function disabled(value)//�һ�
{
	InitEvent();
	DisableBElement("BUpdate",value)

	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
	ExType()
}
	
function condition()//����
{
	if (CheckMustItemNull()) return true;
	return false;
}

function GetTypeInfo(value)
{		
	var List = value.split("^");
	var obj = document.getElementById("Type"); 
	obj.value = List[2];	
	var obj = document.getElementById("TypeDR"); 
	obj.value = List[0];
}
function BName_Click()
{	
    var value=GetElementValue("ExType")
    if (value=="1") 
	{
        LookUp("","web.DHCEQEquip:GetShortEquip","GetEquipID","Name");	
	}
	else
	{
	    var obj = document.getElementById("Name");	
	    obj.value=GetElementValue("Name");
	}
}
function GetEquipID(value) 
{
	//Name,HIDDEN,UseLoc,No,LeaveFactoryNo,HIDDEN,HIDDEN,HIDDEN")
	var list=value.split("^")
	SetElement('Name',list[0]);
	SetElement('NameID',list[1]);
	SetElement('No',list[3]);
	SetElement('ExObjLocDR',list[5]);
	SetElement('ExObjLoc',list[2]);
	SetElement('ExID',list[1]);
}
function GetExObjLoc(value)
{
	GetLookUpID('ExObjLocDR',value);
}

function SetElementsReadOnly(val,flag)
{
	var List=val.split("^")
	for(var i = 0; i < List.length; i++)
	{
		DisableElement(List[i],flag);
		ReadOnlyElement(List[i],flag);
		if (document.getElementById(GetLookupName(List[i])))
		{
			DisableElement(GetLookupName(List[i]),flag);
		}
	}
}
document.body.onload = BodyLoadHandler;

