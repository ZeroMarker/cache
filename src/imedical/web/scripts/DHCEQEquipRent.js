//--------------------------------
//Modefied by zc 2014-10-15 ZC0013
//�޸�λ�� disabled����
//�ȳ�ʼ�����棬�ٻһ�
//Modefied by wy 2017-8-18 ��ӹ�������λ
//--------------------------------
var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler(){
	InitUserInfo(); //ϵͳ����
	//add by wy 2017-06-13 ����393388
	if (GetElementValue("SourceTypeDR")!="")
	{
		SetElement("SourceType",GetElementValue("SourceTypeDR"))
	} 
	if (GetElementValue("ModeDR")!="")
	{
		SetElement("Mode",GetElementValue("ModeDR"))
	}
	//modified by GR0012 2014-09-11 begin �����ť�һ�����Ȼ��ʹ�õ�����,�һ�Ӧ���ڰ�����֮�����
	//disabled(true);//�һ�
	InitPage();
	disabled(true);//add
	//modified by GR0012 2014-09-11 end
	KeyUp("SourceID^Model^UOM^WorkLoadUOM");
	Muilt_LookUp("SourceID^Model^UOM^WorkLoadUOM");
}
function InitPage()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
	var obj=document.getElementById("SourceType");
	if (obj) obj.onclick=SourceType_Click;
	var obj=document.getElementById(GetLookupName("SourceID"));
	if (obj) obj.onclick=SourceID_Click;
	//add by GBX ����ȫ���������µ����޶���
	var obj=document.getElementById("BAddAllEquip");
	if (obj) obj.onclick=BAddAllEquip_Click;
	
	var obj=document.getElementById("BAddAllItem");
	if (obj) obj.onclick=BAddAllItem_Click;
}


function BClear_Click()
{
	SetElement("ISNo","")
	SetElement("InvoiceNos","")
	SetElement("Status","")
	SetElement("LocDR","")
	SetElement("Loc","")
	SetElement("ProviderDR","")
	SetElement("Provider","")
	SetElement("PayRecordInfo","")
}
function SourceType_Click()
{
	var SourceType=GetElementValue("SourceType")
	SetElement("SourceTypeDR",SourceType);
}
function SourceID_Click()
{
	var SourceType=GetElementValue("SourceType")
	if (SourceType=="2")
	{
		LookUp("","web.DHCEQEquipRent:GetMasterItem","GetMasterItem","'','',SourceID");
	}
	else if (SourceType=="1")
	{
		LookUp("","web.DHCEQEquipRent:GetShortEquip","GetSourceID","SourceID");
	}
}
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("SourceType") ;//
  	combindata=combindata+"^"+GetElementValue("SourceIDDR") ; //
  	combindata=combindata+"^"+GetElementValue("ModelDR") ;
  	combindata=combindata+"^"+GetElementValue("Mode") ;
  	combindata=combindata+"^"+GetElementValue("UOMDR") ;
  	combindata=combindata+"^"+GetElementValue("Price") ; //
  	combindata=combindata+"^"+GetElementValue("WorkLoadUOMDR") ; //add by wy 2017-8-18
  	return combindata;
}

function BAdd_Click() //����
{
	if (condition()) return;
	var encmeth=GetElementValue("upd");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,plist,'0');
	if (result>0)
	{   
	    alertShow("�����ɹ�! ")
		location.reload();	
	}
	else
	{
		alertShow("����ʧ��! "+result);
	}
}

function BUpdate_Click() 
{
	if (condition()) return;
	rowid=GetElementValue("RowID");
	if (rowid=="") return;
	var encmeth=GetElementValue("upd");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,plist,"0");
	if (result>0)
	{
		location.reload();	
	}
	else
	{
		alertShow("����ʧ��! "+result);
	}
}

function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("upd");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0) location.reload();	
}
function BFind_Click()
{
	var val="&SourceTypeDR="+GetElementValue("SourceType")
	val=val+"&SourceID="+GetElementValue("SourceID")
	val=val+"&SourceIDDR="+GetElementValue("SourceIDDR")
	//val=val+"&Model="+GetElementValue("Model")
	//val=val+"&ModelDR="+GetElementValue("ModelDR")
	//val=val+"&ModeDR="+GetElementValue("Mode")
	//val=val+"&UOM="+GetElementValue("UOM")
	//val=val+"&UOMDR="+GetElementValue("UOMDR")
	//val=val+"&Price="+GetElementValue("Price")
	//alertShow(val)
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQEquipRent'+val
}
///ѡ�����д����˷���
function SelectRowHandler()
	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQEquipRent');//+����� ������������ʾ Query ����Ĳ���
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	{
		BClear_Click()
		disabled(true)//�һ�		
		SelectedRow=0;
		rowid=0;
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);//���ú���
		InitPage();  //Modefied by zc 2014-10-15 ZC0013
		disabled(false)//���һ�
		}
}
function BClear_Click()
{
	SetElement("RowID","");
	SetElement("SourceType",""); 
	SetElement("SourceID","");
	SetElement("SourceIDDR",""); //
	SetElement("Model",""); //
	SetElement("ModelDR",""); //
	SetElement("Mode","");//
	SetElement("UOM","");//
	SetElement("UOMDR","");//
	SetElement("Price","");//
	SetElement("WorkLoadUOMDR","");
	SetElement("WorkLoadUOM","");
    disabled(true)  //Add by wy 2017-3-9
    InitPage();
	}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetDataByID");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	var list=gbldata.split("^");
	SetElement("RowID",rowid);
	SetElement("SourceType",list[0]); //
	SetElement("SourceIDDR",list[1]); //
	SetElement("ModelDR",list[2]); //
	SetElement("Mode",list[3]);//
	SetElement("UOMDR",list[4]);//
	SetElement("Price",list[5]);//
	SetElement("SourceID",list[15]); //
	SetElement("Model",list[16]); //
	SetElement("UOM",list[17]);//
	SetElement("WorkLoadUOMDR",list[9]);
	SetElement("WorkLoadUOM",list[18]);
}

function disabled(value)//�һ�
{
	DisableBElement("BUpdate",value)

	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
}
//add by wy 2017-8-18 ��������λ
function GetWorkLoadUOMID(value)
{   
	var val=value.split("^");
	SetElement("WorkLoadUOM",val[0]);
	SetElement("WorkLoadUOMDR",val[1]);
}	
function GetUOM(value)
{
	GetLookUpID("UOMDR",value);
}
function GetModelID(value)
{
	GetLookUpID('ModelDR',value);
}
function GetMasterItem(value)
{
	var val=value.split("^");
	SetElement("SourceID",val[0]); 
	SetElement("SourceIDDR",val[1]); 
	SetElement("UOMDR",val[5]); //
	SetElement("UOM",val[6]);  //add by HHM 2015-12-24 �����豸��λ	 
} 
function GetSourceID(value)
{
	var val=value.split("^");
	SetElement("SourceID",val[0]); 
	SetElement("SourceIDDR",val[1]);
	SetElement("ModelDR",val[6]);
	SetElement("Model",val[7]);   //add by HHM 2015-12-24 ��������
	SetElement("UOMDR",val[8]); //�ֶε��޸�
	SetElement("UOM",val[9]);   //add by HHM 2015-12-24 �����豸��λ  282913
}
function condition()//����
{
	if (CheckMustItemNull()) return true;
	return false;
}
function BAddAllEquip_Click()
{
	var RentLocEquip=GetElementValue("GetRentLocEquip");
	var EquipInfo=cspRunServerMethod(RentLocEquip);
	//var GetRentEquipNum=GetElementValue("GetRentEquipNum");
	var EquipInfoList=EquipInfo.split("&");
	var Len=EquipInfoList.length;
	//alertShow("EquipInfoList="+EquipInfoList)
	//alertShow("EquipInfoList="+EquipInfoList);
	//alertShow("Len="+Len);
	var encmeth=GetElementValue("upd");
	if (encmeth=="") return;
	for (var i=0;i<Len;i++)
	{
		//var plist=cspRunServerMethod(GetRentEquipInfo,i+1);
		var plist=EquipInfoList[i];
		var result=cspRunServerMethod(encmeth,plist,"0");
		if (result<0)
		{
			alertShow("����ʧ��!����ϵ����Ա!");
			return;
		}
	}
	if (i==Len)
	{
		alertShow("���ɳɹ�!")
		location.reload();
	}
}


function BAddAllItem_Click()
{
	var RentLocItem=GetElementValue("GetRentLocItem");
	var ItemInfo=cspRunServerMethod(RentLocItem);
	//var GetRentEquipNum=GetElementValue("GetRentEquipNum");
	var ItemInfoList=ItemInfo.split("&");
	var Len=ItemInfoList.length;
	//alertShow("EquipInfoList="+EquipInfoList)
	//alertShow("EquipInfoList="+EquipInfoList);
	//alertShow("Len="+Len);
	var encmeth=GetElementValue("upd");
	if (encmeth=="") return;
	for (var i=0;i<Len;i++)
	{
		//var plist=cspRunServerMethod(GetRentEquipInfo,i+1);
		var plist=ItemInfoList[i];
		var result=cspRunServerMethod(encmeth,plist,"0");
		if (result<0)
		{
			alertShow("����ʧ��!����ϵ����Ա!");
			return;
		}
	}
	if (i==Len)
	{
		alertShow("���ɳɹ�!")
		location.reload();
	}
}
document.body.onload = BodyLoadHandler;