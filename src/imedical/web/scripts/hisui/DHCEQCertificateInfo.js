/// DHCEQCertificateInfo.js
var SelectedRow = -1;  //hisui���죺�޸Ŀ�ʼ�к� add by lmm 2018-08-17
var rowid=0;

function BodyLoadHandler() 
{
	SetElement("SourceType",0);
	InitMessage();			//20140228  Mozy0120
	InitButton(false);
	KeyUp("SourceDesc^CertificateType","N");
	Muilt_LookUp("SourceDesc^CertificateType");
	SetElement("SourceType",GetElementValue("SourceTypeID"));  //add by czf ����ţ�325590
	initButtonWidth()  //hisui���죺�޸Ľ��水ť���Ȳ�һ�� add by lmm 2018-08-20
	SetElement("Level",GetElementValue("LevelID"));
	singlelookup("SourceDesc","PLAT.L.EQUser","",GetSourceID)  //modified by csj 20190524
	SetComboboxRequired("SourceType")   //hisui modified by czf 20181120
	initPanelHeaderStyle();
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
	var obj=document.getElementById("BPicture");
	if (obj) obj.onclick=BPicture_Click;
	
	//hisui���죺������ modify by lmm 2018-08-17 begin
	//var obj=document.getElementById("SourceType");
	//if (obj) obj.onchange=SourceType_change;
	//var obj=document.getElementById("ld"+GetElementValue("GetComponentID")+"iSourceDesc");
	//if (obj) obj.onclick=BSourceDesc_Click;
	//hisui���� modify by lmm 2018-08-17 end
	DisableBElement("BAdd",isselected);
	DisableBElement("BUpdate",!isselected);
	DisableBElement("BDelete",!isselected);
	DisableBElement("BDisuse",!isselected);
	DisableBElement("BPicture",!isselected);
}

function Clear()
{
	SetElement("RowID","");                 //modified by czf ����ţ�325361
	SetElement("SourceType","");
	SetElement("SourceDesc","");
	SetElement("SourceID","");
	SetElement("CertificateType","");
	SetElement("CertificateTypeDR","");
	SetElement("No","");
	SetElement("Level","");
	SetElement("CertificateDept","");
	SetElement("CertificateDate","");
	SetElement("AvailableDate","");
	SetElement("Remark","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
}

function BFind_Click()      
{  
	var val="&SourceTypeID="+GetElementValue("SourceType"); 	//modified by czf 20181105 HISUI����
	val=val+"&SourceDesc="+GetElementValue("SourceDesc");
	val=val+"&CertificateType="+GetElementValue("CertificateType")
	val=val+"&No="+GetElementValue("No")
	val=val+"&LevelID="+GetElementValue("Level")
	val=val+"&CertificateDept="+GetElementValue("CertificateDept")
	val=val+"&CertificateDate="+GetElementValue("CertificateDate")
	val=val+"&AvailableDate="+GetElementValue("AvailableDate")
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCertificateInfo"+val;
  	//$("#tDHCEQCertificateInfo").datagrid("load");  //hisui���죺��ϸ�б��ؼ��� modify by lmm 2018-08-17
}

function BUpdate_Click() 
{
	if (CheckMustItemNull()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")
	{
		messageShow("","","",t[-4001]);
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
	//var result=cspRunServerMethod(encmeth,'','',rowid+"^"+GetElementValue("EquipDR"),GetElementValue("CheckListDR"),'1');
	var result=cspRunServerMethod(encmeth,rowid+"^",'1');
	//messageShow("","","",result)
	if (result>0)
	{	location.reload();	}
}

function BPicture_Click()
{
	//modified by czf 20190305
	var SourceType=GetElementValue("SourceType")
	var str='dhceq.plat.picturemenu.csp?&CurrentSourceType=63&CurrentSourceID='+GetElementValue("RowID")+'&Status=0';
	if ((SourceType==2)||(SourceType==5))		//modified by czf 20200404
	{
		str='dhceq.plat.picturemenu.csp?&CurrentSourceType=63-1&CurrentSourceID='+GetElementValue("RowID")+'&Status=0';
	}
	else if (SourceType==3)
	{
		str='dhceq.plat.picturemenu.csp?&CurrentSourceType=63-2&CurrentSourceID='+GetElementValue("RowID")+'&Status=0';
	}
	//hisui���� modified by czf 20181012 begin
	//window.open(str,'_blank','left='+ (screen.availWidth - 1150)/2 +',top='+ ((screen.availHeight>750)?(screen.availHeight-750)/2:0) +',width=1150,height=750,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes');
	var iWidth=1080
	var iHeight=650
  	var iTop = (window.screen.height-30-iHeight)/2;       //��ô��ڵĴ�ֱλ��;
	var iLeft = (window.screen.width-10-iWidth)/2;        //��ô��ڵ�ˮƽλ��;
	SetWindowSize(str,false,iWidth,iHeight,iTop,iLeft,"ͼƬ��Ϣ","true","","")
	//hisui���� modified by czf 20181012 end
}
function BClose_Click()
{
	//window.close();
	CloseWindow();
}

function CombinData()
{
	var combindata="";
  	combindata=GetElementValue("RowID");
  	combindata=combindata+"^"+GetElementValue("SourceType");
  	combindata=combindata+"^"+GetElementValue("SourceID");
  	combindata=combindata+"^"+GetElementValue("CertificateTypeDR");
  	combindata=combindata+"^"+GetElementValue("No");
  	combindata=combindata+"^"+GetElementValue("Level");
  	combindata=combindata+"^"+GetElementValue("CertificateDept");
  	combindata=combindata+"^"+GetElementValue("CertificateDate");
  	combindata=combindata+"^"+GetElementValue("AvailableDate");
  	combindata=combindata+"^"+GetElementValue("Remark");
	combindata=combindata+"^"+GetElementValue("Hold1");
	combindata=combindata+"^"+GetElementValue("Hold2");
	combindata=combindata+"^"+GetElementValue("Hold3");
	combindata=combindata+"^"+GetElementValue("Hold4");
	combindata=combindata+"^"+GetElementValue("Hold5");
	
  	return combindata;
}

function SetData(RowID)
{   
	SetElement("RowID",RowID);  //hisui���죺RowID��ֵ add by lmm 2018-08-17
	var encmeth=GetElementValue("GetData");
	if (encmeth=="")
	{
		alertShow("Ԫ�ؿ�ֵ");
		return;
	}
	var sort=18;
	var gbldata=cspRunServerMethod(encmeth,RowID);
	var list=gbldata.split("^");
	//messageShow("","","",gbldata)
	SetElement("SourceType",list[0]);
	SetElement("SourceTypeID",list[0]);
	SetElement("SourceID",list[1]);
	SetElement("SourceDesc",list[sort+0]);
	SetElement("CertificateTypeDR",list[2]);
	SetElement("CertificateType",list[sort+1]);
	SetElement("No",list[3]);
	SetElement("Level",list[4]);
	SetElement("LevelID",list[4]);
	SetElement("CertificateDept",list[5]);
	SetElement("CertificateDate",list[6]);
	SetElement("AvailableDate",list[7]);
	SetElement("Remark",list[8]);
	SetElement("Hold1",list[13]);
	SetElement("Hold2",list[14]);
	SetElement("Hold3",list[15]);
	SetElement("Hold4",list[16]);
	SetElement("Hold5",list[17]);
}


///modified by kdf 2018-02-24
///������hisui���� �����������������,�������ƹ̶�
///��Σ�index �к� ѡ���е�indexӦ�ô�0��ʼ,�����߼��ж�
///      rowdata ��json����
function SelectRowHandler(index,rowdata){
	if (index==SelectedRow){
		Clear();
		SelectedRow= -1;
		InitButton(false); 
		$('#tDHCEQCertificateInfo').datagrid('unselectAll'); 
		return;
	}
	SetData(rowdata.TRowID); 
	InitButton(true);   
	SelectedRow = index;
	ReloadSourceDesc();
}

function GetCertificateType(value)
{
	GetLookUpID("CertificateTypeDR",value);
}

function SourceType_change()
{
	//SetElement("ExTypeDR",GetElementValue("ExType"));
	//changeSourceDesc();
	SetElement("SourceID","");
	SetElement("SourceDesc","");
	SetElement("SourceTypeID",GetElementValue("SourceType"));
}

//hisui���� add by lmm 2018-08-17 ������Դ�����л���Դ����������
$("#SourceType").combobox({
    onSelect: function () {
		SourceType_change()
		ReloadSourceDesc()		//modfied by czf 20171105 HISUI����
	}
})

//hisui���� add by by czf 20181120 
$("#Level").combobox({
    onSelect: function () {
	    SetElement("LevelID",GetElementValue("Level"));	
	}
})

//modified by czf 20171105
function ReloadSourceDesc()
{
	var SourceType=GetElementValue("SourceType")
	if (SourceType==1){    //��Ա
		singlelookup("SourceDesc","PLAT.L.EQUser","",GetSourceID)	//modified by csj 20190524 ����ϵͳά����Ա
	}
	else if ((SourceType==2)||(SourceType==5)) //��˾		//modified by czf 20200404
	{
		singlelookup("SourceDesc","PLAT.L.Vendor",[{name:"Name",type:1,value:"SourceDesc"},{name:"SourceType",type:2,value:5}],GetVendorID)
	}
	else if (SourceType==3) //3 ��������
	{
		singlelookup("SourceDesc","PLAT.L.ManuFacturer","",GetManuFacturerID)
	}
}

///modified by lmm 2018-08-17
///������hisui���� ������ֵ
///��Σ�item ѡ����json����
function GetSourceID(item) 
{
	SetElement('SourceDesc',item.TName);	//modified by csj 20190524
	SetElement('SourceID',item.TRowID);
}

///add by lmm 2018-08-17
///������hisui���� ������ֵ
///��Σ�item ѡ����json����
function GetVendorID(item) 
{
	SetElement('SourceDesc',item.TName);
	SetElement('SourceID',item.TRowID);
}

///add by lmm 2018-08-17
///������hisui���� ������ֵ
///��Σ�item ѡ����json����
function GetManuFacturerID(item) 
{
	SetElement('SourceDesc',item.TName);
	SetElement('SourceID',item.TRowID);
}

document.body.onload = BodyLoadHandler;
