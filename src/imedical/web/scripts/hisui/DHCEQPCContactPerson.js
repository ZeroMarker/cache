//DHCEQPCContactPerson.js
var SelectedRow = -1;
var rowid=0;
document.body.onload = BodyLoadHandler;
function BodyLoadHandler() 
{	
	InitMessage();	
	InitButton(false);
	KeyUp("SourceDesc","N");
	Muilt_LookUp("SourceDesc");
	initButtonWidth(); 
	SetElement("SourceTypeID",5);		//modified by czf 202004004
	singlelookup("SourceDesc","PLAT.L.Vendor","",GetVendorID);
	SetElement("SourceType",GetElementValue("SourceTypeID")); 
	SetElement("Type",GetElementValue("TypeID"));
	SetComboboxRequired("SourceType");
	SetComboboxRequired("Type");		//modified by CZF0100
	disableElement("SourceType",true);	//modifeid by czf 20200404
	if(GetElementValue("SourceFlag")=="1")		//modified by CZF0095
	{
		disableElement("SourceDesc",true);
	}
} 

function InitButton(isselected)
{
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	DisableBElement("BAdd",isselected);
	DisableBElement("BUpdate",!isselected);
	DisableBElement("BDelete",!isselected);
	DisableBElement("BDisuse",!isselected);
}

function Selected(selectrow)
{
	if (SelectedRow==selectrow)
	{
		Clear();
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		InitButton(false);
	}
	else
	{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		if (rowid=="") return;
		SetElement("RowID",rowid);
		SetData(rowid);
		InitButton(true);
	}
}
function Clear()
{
	SetElement("RowID",""); 
	if(GetElementValue("SourceFlag")!="1")		//modified by CZF0095
	{
		//SetElement("SourceType","");	//modified by czf 20200407 只有公司类型，无需清空
		//SetElement("SourceTypeID","");
		SetElement("SourceDesc","");
		SetElement("SourceID","");
	} 
	SetElement("Type","");
	SetElement("TypeID","");
	SetElement("Name","");
	SetElement("Role","");
	SetElement("Sex","");
	SetElement("MobilePhone","");
	SetElement("OfficePhone","");
	SetElement("Email","");
	SetElement("Fax","");
	SetElement("Remark","");
	SetElement("QQ","");
	SetElement("WeChat","");
	SetElement("OtherContact","");
	SetElement("Address","");
	SetElement("Area","");
	SetElement("Remark","");
	SetElement("FromDate","");
	SetElement("ToDate","");
	SetElement("OtherContact","");
	SetElement("Hold5","");
	SetElement("OtherContact","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
}

function BFind_Click()       
{
	var val=""; 
	val="&SourceTypeID="+GetElementValue("SourceTypeID");
	val=val+"&SourceDesc="+GetElementValue("SourceDesc")
	val=val+"&TypeID="+GetElementValue("TypeID")
	val=val+"&Name="+GetElementValue("Name")
	val=val+"&Role="+GetElementValue("Role")
	val=val+"&Sex="+GetElementValue("Sex")
	val=val+"&MobilePhone="+GetElementValue("MobilePhone")
	val=val+"&OfficePhone="+GetElementValue("OfficePhone")
	val=val+"&Email="+GetElementValue("Email")
	val=val+"&Fax="+GetElementValue("Fax")
	val=val+"&QQ="+GetElementValue("QQ")
	val=val+"&WeChat="+GetElementValue("WeChat")
	val=val+"&OtherContact="+GetElementValue("OtherContact")
	val=val+"&Address="+GetElementValue("Address")
	val=val+"&Area="+GetElementValue("Area")
	val=val+"&Remark="+GetElementValue("Remark")
	val=val+"&FromDate="+GetElementValue("FromDate")
	val=val+"&ToDate="+GetElementValue("ToDate")
	val=val+"&InvalidFlag="+GetElementValue("InvalidFlag")
	val=val+"&Hold1="+GetElementValue("Hold1")
	val=val+"&Hold2="+GetElementValue("Hold2")
	val=val+"&Hold3="+GetElementValue("Hold3")
	val=val+"&Hold4="+GetElementValue("Hold4")
	val=val+"&Hold5="+GetElementValue("Hold5")
	val=val+"&SourceFlag="+GetElementValue("SourceFlag")		//modified by czf 20200404
	val=val+"&SourceID="+GetElementValue("SourceID")
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQPCContactPerson"+val;
}

function BUpdate_Click() 
{
	if (CheckMustItemNull()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")
	{
		alertShow(t[-4001]);	
		return;
	}
	var plist=CombinData();
	var result=cspRunServerMethod(encmeth,plist,"0");
	if (result>0)
	{	location.reload();	}
	else
	{
		alertShow("SQLCODE="+result);
	}
}

function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	if (rowid=="")
	{
		messageShow("","","",t['-3002']);
		return;
	}
	var truthBeTold = window.confirm(t['-3001']);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")
	{
		messageShow("","","",t[-4001]);
		return;
	}
	var result=cspRunServerMethod(encmeth,rowid+"^",'1');
	if (result>0)
	{	location.reload();	}
}

function CombinData()
{
	var combindata="";
  	combindata=GetElementValue("RowID");
  	combindata=combindata+"^"+GetElementValue("SourceType");
  	combindata=combindata+"^"+GetElementValue("SourceID");
  	combindata=combindata+"^"+GetElementValue("Type");
  	combindata=combindata+"^"+GetElementValue("Name");
  	combindata=combindata+"^"+GetElementValue("Role");
  	combindata=combindata+"^"+GetElementValue("Sex");
  	combindata=combindata+"^"+GetElementValue("MobilePhone");
  	combindata=combindata+"^"+GetElementValue("OfficePhone");
  	combindata=combindata+"^"+GetElementValue("Email");
  	combindata=combindata+"^"+GetElementValue("Fax");
  	combindata=combindata+"^"+GetElementValue("QQ");
  	combindata=combindata+"^"+GetElementValue("WeChat");
  	combindata=combindata+"^"+GetElementValue("OtherContact");
  	combindata=combindata+"^"+GetElementValue("Address");
  	combindata=combindata+"^"+GetElementValue("Area");
  	combindata=combindata+"^"+GetElementValue("Remark");
  	combindata=combindata+"^"+GetElementValue("FromDate");
  	combindata=combindata+"^"+GetElementValue("ToDate");
  	combindata=combindata+"^"+GetElementValue("InvalidFlag");
	combindata=combindata+"^"+GetElementValue("Hold1");
	combindata=combindata+"^"+GetElementValue("Hold2");
	combindata=combindata+"^"+GetElementValue("Hold3");
	combindata=combindata+"^"+GetElementValue("Hold4");
	combindata=combindata+"^"+GetElementValue("Hold5");	
  	return combindata;
}
function SetData(rowid)
{
	SetElement("RowID",rowid);
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var sort=24;	
	var gbldata=cspRunServerMethod(encmeth,rowid);
	var list=gbldata.split("^");
	SetElement("SourceType",list[0]);
	SetElement("SourceTypeID",list[0]);
	SetElement("SourceID",list[1]);
	SetElement("SourceDesc",list[sort+0]);	
	SetElement("Type",list[2]);
	SetElement("TypeID",list[2]);
	SetElement("Name",list[3]);
	SetElement("Role",list[4]);
	SetElement("Sex",list[5]);
	SetElement("MobilePhone",list[6]);
	SetElement("OfficePhone",list[7]);
	SetElement("Email",list[8]);
	SetElement("Fax",list[9]);
	SetElement("QQ",list[10]);
	SetElement("WeChat",list[11]);
	SetElement("OtherContact",list[12]);
	SetElement("Address",list[13]);
	SetElement("Area",list[14]);
	SetElement("Remark",list[15]);
	SetElement("FromDate",list[16]);
	SetElement("ToDate",list[17]);
	SetElement("InvalidFlag",list[18]);
	SetElement("Hold1",list[19]);
	SetElement("Hold2",list[20]);
	SetElement("Hold3",list[21]);
	SetElement("Hold4",list[22]);
	SetElement("Hold5",list[23]);
}

function SelectRowHandler(index,rowdata){
	if (index==SelectedRow){
		Clear();
		SelectedRow= -1;
		InitButton(false); 
		$('#tDHCEQPCContactPerson').datagrid('unselectAll'); 
		return;
	}
	SetData(rowdata.TRowID); 
	InitButton(true);   
	SelectedRow = index;
	ReloadSourceDesc();
}

function SourceType_change()
{
	SetElement("SourceID","");
	SetElement("SourceDesc","");
	SetElement("SourceTypeID",GetElementValue("SourceType"));
}
function ReloadSourceDesc()
{
	var SourceType=GetElementValue("SourceType")
	if ((SourceType==2)||(SourceType==5))		//modified by czf 20200404 //供应商	  //modified by CZF0095 与DHC_EQCVendor公司类型一致 begin
	{
		singlelookup("SourceDesc","PLAT.L.Vendor","",GetVendorID)
	}
	else if (SourceType==3) //生产厂商
	{
		singlelookup("SourceDesc","PLAT.L.ManuFacturer","",GetManuFacturerID)
	}
	else if (SourceType==4){   //服务商
		singlelookup("SourceDesc","PLAT.L.Service","",GetServiceID)			//modified by CZF0095 与DHC_EQCVendor公司类型一致 end
	}
}

$("#SourceType").combobox({
    onSelect: function () {
		SourceType_change()
		ReloadSourceDesc()		
	}
})

$("#Type").combobox({
    onSelect: function () {
		SetElement("TypeID",GetElementValue("Type"));			
	}
})

function GetVendorID(item) 
{
	SetElement('SourceDesc',item.TName);
	SetElement('SourceID',item.TRowID);
}
function GetServiceID(item) 
{
	SetElement('SourceDesc',item.TDesc);	
	SetElement('SourceID',item.TRowID);
}
function GetManuFacturerID(item) 
{
	SetElement('SourceDesc',item.TName);
	SetElement('SourceID',item.TRowID);
}

