//--------------------------------
//Modefied by zc 2014-10-15 ZC0013
//�޸�λ�� disabled����
//�ȳ�ʼ�����棬�ٻһ�
//Modefied by wy 2017-8-18 ��ӹ�������λ
//--------------------------------
var SelectedRow = -1;  //hisui���죺�޸Ŀ�ʼ�к�  add by csj 20181009
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
	initButtonWidth();//add by csj 20181009 ����60��HISUIͳһ��ť���
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
	//add by GBX ����ȫ���������µ����޶���
	var obj=document.getElementById("BAddAllEquip");
	if (obj) obj.onclick=BAddAllEquip_Click;
	
	var obj=document.getElementById("BAddAllItem");
	if (obj) obj.onclick=BAddAllItem_Click;

}
function ValueClear()
{
	SetElement("SourceID","");
	SetElement("SourceIDDR","");
}

///add by CSJ 2018-09-29 
///������hisui���� ���������б����¶�������������
 $("#SourceType").combobox({
	onChange:function(n,o){ValueClear()},//add by csj 20181010 //add by csj 20181010�����б����ʱ�豸Ҳ��� �����:681501
    onSelect: function () {
	    SourceType = GetElementValue("SourceType");
		SetElement("SourceTypeDR",SourceType);  //Moidefied by zc0070 ������ֵ
	    if (SourceType=="2")
		{
			singlelookup("SourceID","EM.L.GetMasterItem","",GetMasterItem)
		}
		else if (SourceType=="1")
		{
			singlelookup("SourceID","EM.L.Equip","",GetSourceID);  //Modify by zx 2020-05-19 BUG ZX0088
		}

    }
 })
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
		$('#tDHCEQEquipRent').datagrid('reload');
//		BFind_Click();	//Ϊʲô���У�
//		location.reload();	
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
//modified by csj 20181120 �첽���ز�ѯ���
function BFind_Click()
{
/* 	var val="&SourceTypeDR="+GetElementValue("SourceType")
	val=val+"&SourceID="+GetElementValue("SourceID")
	val=val+"&SourceIDDR="+GetElementValue("SourceIDDR")
	//val=val+"&Model="+GetElementValue("Model")
	//val=val+"&ModelDR="+GetElementValue("ModelDR")
	//val=val+"&ModeDR="+GetElementValue("Mode")
	//val=val+"&UOM="+GetElementValue("UOM")
	//val=val+"&UOMDR="+GetElementValue("UOMDR")
	//val=val+"&Price="+GetElementValue("Price")
	//messageShow("","","",val)
	window.location.href= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQEquipRent'+val */
	if (!$(this).linkbutton('options').disabled){
	//Moidefied by zc0070 ���IDֵ�̶����� begin
	//$('#tDHCEQEquipRent').datagrid('load',{ComponentID:53262,SourceTypeDR:getValueById("SourceTypeDR"),SourceIDDR:getValueById("SourceIDDR")});
	$('#tDHCEQEquipRent').datagrid('load',{ComponentID:GetElementValue("GetComponentID"),SourceTypeDR:GetElementValue("SourceTypeDR"),SourceIDDR:GetElementValue("SourceIDDR")});
	//Moidefied by zc0070 ���IDֵ�̶����� begin
}
}

///ѡ�����д����˷���
///add by csj 20181009ѡ�����¼�
function SelectRowHandler(index,rowdata)
{
	if (SelectedRow==index)	{
		BClear_Click()
		disabled(true)//�һ�		
		SelectedRow=-1;
		$('#tDHCEQEquipRent').datagrid('unselectAll'); 
		return;
		}
	SelectedRow=index;
	SetData(rowdata.TRowID);//���ú���
	//add by csj 20181011������Դ���Ͳ�ͬѡ��lookup���
	SourceType = GetElementValue("SourceType");
    if (SourceType=="2")
	{
		singlelookup("SourceID","EM.L.GetMasterItem","",GetMasterItem)
	}
	else if (SourceType=="1")
	{
		singlelookup("SourceID","EM.L.Equip","",GetSourceID); //Modify by zx 2020-05-19 BUG ZX0088
	}
	InitPage();  //Modefied by zc 2014-10-15 ZC0013
	disabled(false)//���һ�
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

///modified by csj 2018-10-08
///������hisui���� �豸����ѡ���к����ݸ�ֵ
///��Σ�item ѡ����json����
function GetMasterItem(item)
{
	SetElement("SourceID",item.TName);
	SetElement("SourceIDDR",item.TRowID);
	SetElement("UOM",item.TUnit);
	SetElement("UOMDR",item.TUnitDR);
}

///modified by csj 2018-10-08
///������hisui���� �豸����ѡ���к����ݸ�ֵ
///��Σ�item ѡ����json����
function GetSourceID(item)
{
	SetElement("SourceID",item.TName); //Modify by zx 2020-05-19 BUG ZX0088
	SetElement("SourceIDDR",item.TRowID);
	SetElement("ModelDR",item.TModelDR);
	SetElement("Model",item.TModel);   //add by HHM 2015-12-24 ��������
	SetElement("UOMDR",item.TUnitDR); //�ֶε��޸�
	SetElement("UOM",item.TUnit);   //add by HHM 2015-12-24 �����豸��λ  282913

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