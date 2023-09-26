///Modified By HZY 2011-08-29 HZY0005
///�޸ĺ���?BCancelSubmit_Click
var Component="DHCEQMaintNew"
function BodyLoadHandler() 
{
	if (GetElementValue("BussType")==2)
	{
		Component="DHCEQInspectNew"
		if (GetElementValue("MaintTypeDR")==5)
		{
			Component="DHCEQMeterageNew"
		}
	}
	InitUserInfo();
	InitPage();	
	FillData();
	SetEnabled();
	SetDisplay();	
	KeyUp("PlanName^Equip^UseLoc^MaintLoc^ManageLoc^MaintUser^MaintUser^MeasureDept^Service^MaintType^MaintMode","N");
	Muilt_LookUp("PlanName^Equip^UseLoc^MaintLoc^ManageLoc^MaintUser^MaintUser^MeasureDept^Service^MaintType^MaintMode","N");
}

function InitPage()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Click;
	
	var obj=document.getElementById("BCancelSubmit");
	if (obj) obj.onclick=BCancelSubmit_Click;
	
	var obj=document.getElementById("BMaintItem");
	if (obj) obj.onclick=BMaintItem_Click;
	
	var obj=document.getElementById("BMaintpart");
	if (obj) obj.onclick=BMaintPart_Click;
		
	var obj=document.getElementById("MeasureFlag");
	if (obj) obj.onclick=MeasureFlag_Click;
	
	var obj=document.getElementById("BPicture");
	if (obj) obj.onclick=BPicture_Click;
	
	var obj=document.getElementById("BPrint")	//modified by GR0032 20150420 ������¼���Ӵ�ӡ����
	if (obj) obj.onclick=BPrint_Click;
	
	var obj=document.getElementById("BPMReport");
	if (obj) obj.onclick=BPMReport_Click;		//modified by GR0058 20160125 PM����
}

function FillData()
{
	var RowID=GetElementValue("RowID");
  	if (RowID=="") return;
	var encmeth=GetElementValue("fillData");
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,RowID);
	Rtn=Rtn.replace(/\\n/g,"\n");
	list=Rtn.split("^");
	var sort=42;
	SetElement("EquipDR",list[0]);
	SetElement("BussType",list[1]);
	SetElement("PlanNameDR",list[2]);
	SetElement("MaintTypeDR",list[3]);
	SetElement("MaintDate",list[4]);
	SetElement("MaintLocDR",list[5]);
	SetElement("MaintUserDR",list[6]);
	SetElement("MaintModeDR",list[7]);
	SetElement("TotalFee",list[8]);
	SetChkElement("NormalFlag",list[9]);
	SetElement("ManageLocDR",list[10]);
	SetElement("UseLocDR",list[11]);
	SetElement("Status",list[12]);
	SetElement("Remark",list[13]);
	/*
	SetElement("UpdateUserDR",list[0]);
	SetElement("UpdateDate",list[0]);
	SetElement("UpdateTime",list[0]);
	SetElement("AuditUserDR",list[0]);
	SetElement("AuditDate",list[0]);
	SetElement("AuditTime",list[0]);
	SetElement("SubmitUserDR",list[0]);
	SetElement("SubmitDate",list[0]);
	SetElement("SubmitTime",list[0]);
	*/
	SetElement("MaintFee",list[23]);
	SetElement("Hold1",list[24]);
	SetElement("Hold2",list[25]);
	SetElement("Hold3",list[26]);
	SetElement("Hold4",list[27]);
	SetElement("Hold5",list[28]);
	SetChkElement("MeasureFlag",list[29]);
	SetElement("MeasureDeptDR",list[30]);
	SetElement("MeasureHandler",list[31]);
	SetElement("MeasureTel",list[32]);
	SetElement("MeasureUsers",list[33]);
	SetElement("ServiceDR",list[34]);
	SetElement("ServiceHandler",list[35]);
	SetElement("ServiceTel",list[36]);
	SetElement("ServiceUsers",list[37]);
	SetChkElement("InvalidFlag",list[38]);
	/*
	SetElement("DelUserDR",list[0]);
	SetElement("DelDate",list[0]);
	SetElement("DelTime",list[0]);*/
	SetElement("Equip",list[sort+0])
	SetElement("PlanName",list[sort+2])
	SetElement("MaintType",list[sort+3])
	SetElement("MaintLoc",list[sort+4])
	SetElement("MaintUser",list[sort+5])
	SetElement("MaintMode",list[sort+6])
	SetElement("ManageLoc",list[sort+7])
	SetElement("UseLoc",list[sort+8])
	SetElement("MeasureDept",list[sort+13])
	SetElement("Service",list[sort+14])
	SetElement("CertificateValidityDate",list[sort+16])
	SetElement("CertificateNo",list[sort+17])	//Mozy0193	20170817 
	//SetElement("ModelDR",list[sort+17])
	//SetElement("Model",list[sort+18])
}

function SetEnabled()
{
	var Status=GetElementValue("Status");
	if (Status=="")
	{
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BMaintPlanItem",true);
		DisableBElement("BMaintPlanPart",true);
		DisableBElement("BPicture",true);
		DisableBElement("BPMReport",true);
	}
	else if (Status=="0")
	{
		DisableBElement("BCancelSubmit",true);
	}	
	else 
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BCancelSubmit",true);//270282 Add By BRB 2016-10-19
	}
}

function GetMaintInfoList()
{
	var combindata="";	
	combindata=GetElementValue("RowID") ; //1
	combindata=combindata+"^"+GetElementValue("EquipDR") ; //2
	combindata=combindata+"^"+GetElementValue("BussType") ; //3
	combindata=combindata+"^"+GetElementValue("PlanNameDR") ; //4
	combindata=combindata+"^"+GetElementValue("MaintTypeDR") ; //5
	combindata=combindata+"^"+GetElementValue("MaintDate") ; //6
	combindata=combindata+"^"+GetElementValue("MaintLocDR") ; //7
	combindata=combindata+"^"+GetElementValue("MaintUserDR") ; //8
	combindata=combindata+"^"+GetElementValue("MaintModeDR") ; //9
	combindata=combindata+"^"+GetElementValue("TotalFee") ; //10
	combindata=combindata+"^"+GetChkElementValue("NormalFlag") ; //11
	combindata=combindata+"^"+GetElementValue("ManageLocDR") ; //12
	combindata=combindata+"^"+GetElementValue("UseLocDR") ; //13
	combindata=combindata+"^"+GetElementValue("Status") ; //14
	combindata=combindata+"^"+GetElementValue("Remark") ; //15
	/*
	combindata=combindata+"^"+GetElementValue("UpdateUserDR") ; //
	combindata=combindata+"^"+GetElementValue("UpdateDate") ; //
	combindata=combindata+"^"+GetElementValue("UpdateTime") ; //
	combindata=combindata+"^"+GetElementValue("AuditUserDR") ; //
	combindata=combindata+"^"+GetElementValue("AuditDate") ; //
	combindata=combindata+"^"+GetElementValue("AuditTime") ; //
	combindata=combindata+"^"+GetElementValue("SubmitUserDR") ; //
	combindata=combindata+"^"+GetElementValue("SubmitDate") ; //
	combindata=combindata+"^"+GetElementValue("SubmitTime") ; //*/
	combindata=combindata+"^"+GetElementValue("MaintFee") ; //16
	combindata=combindata+"^"+GetElementValue("Hold1") ; //17
	combindata=combindata+"^"+GetElementValue("Hold2") ; //18
	combindata=combindata+"^"+GetElementValue("Hold3") ; //19
	combindata=combindata+"^"+GetElementValue("Hold4") ; //20
	combindata=combindata+"^"+GetElementValue("Hold5") ; //21
	combindata=combindata+"^"+GetChkElementValue("MeasureFlag") ; //22
	combindata=combindata+"^"+GetElementValue("MeasureDeptDR") ; //23
	combindata=combindata+"^"+GetElementValue("MeasureHandler") ; //24
	combindata=combindata+"^"+GetElementValue("MeasureTel") ; //25
	combindata=combindata+"^"+GetElementValue("MeasureUsers") ; //26
	combindata=combindata+"^"+GetElementValue("ServiceDR") ; //27
	combindata=combindata+"^"+GetElementValue("ServiceHandler") ; //28
	combindata=combindata+"^"+GetElementValue("ServiceTel") ; //29
	combindata=combindata+"^"+GetElementValue("ServiceUsers") ; //30
	combindata=combindata+"^"+GetChkElementValue("InvalidFlag") ; //31
	combindata=combindata+"^"+GetElementValue("CertificateValidityDate") ; //32
	combindata=combindata+"^"+GetElementValue("CertificateNo") ; //33	Mozy0193	20170817
	/*
	combindata=combindata+"^"+GetElementValue("DelUserDR") ; //
	combindata=combindata+"^"+GetElementValue("DelDate") ; //
	combindata=combindata+"^"+GetElementValue("DelTime") ; //*/
	return combindata;
}

function BUpdate_Click() 
{
	if (CheckNull()) return;
	if (CheckInvalidData()) return;
	var combindata=GetMaintInfoList();
	var encmeth=GetElementValue("UpdateData");
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata);
	if (Rtn<0) 
	{
		alertShow(t["04"]);
		return;	
	}
	//add by HHM 20150910 HHM0013
	//��Ӳ����ɹ��Ƿ���ʾ
	ShowMessage();
	//****************************	
    parent.location.href= "dhceqmaint.csp?&RowID="+Rtn+"&EquipDR="+GetElementValue("EquipDR")+"&BussType="+GetElementValue("BussType")+"&MaintTypeDR="+GetElementValue("MaintTypeDR");
}

function BDelete_Click() 
{
	var RowID=GetElementValue("RowID");
  	if (RowID=="") return;
	var truthBeTold = window.confirm(t["-4003"]);	
	if (!truthBeTold) return;
	var encmeth=GetElementValue("DeleteData");
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,RowID);
	if (Rtn!=0) 
	{
		alertShow(t["04"]);
		return;	
	}
    parent.location.href= "dhceqmaint.csp?&MaintTypeDR="+GetElementValue("MaintTypeDR");
}

function BSubmit_Click() 
{
	var RowID=GetElementValue("RowID");
  	if (RowID=="") return;
	var MaintPlanDR=GetElementValue("MaintPlanDR");
	var MaintDate=GetElementValue("MaintDate");
	if (MaintDate=="")
	{
		alertShow(t["11"]);
		return;
	}
	var encmeth=GetElementValue("SubmitData");
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,RowID)
	if (Rtn<0) 
	{
		alertShow(t["04"]);
		return;	
	}
    parent.location.href= "dhceqmaint.csp?&RowID="+Rtn+"&EquipDR="+GetElementValue("EquipDR")+"&BussType="+GetElementValue("BussType")+"&MaintTypeDR="+GetElementValue("MaintTypeDR");	
}

//Modified By HZY 2011-08-29 HZY0005
function BCancelSubmit_Click() 
{
	var RowID=GetElementValue("RowID");
  	if (RowID=="") return;
  	var encmeth=GetElementValue("CancelSubmitData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,RowID);
	if (Rtn<0) 
	{
		alertShow(t["09"]);
		return;	
	}
    //parent.location.href= "dhceqmaint.csp?RowID="+Rtn+"&EquipDR="+GetElementValue("EquipDR");	
    parent.location.href= "dhceqmaint.csp?&BussType="+GetElementValue("BussType")+"&MaintTypeDR="+GetElementValue("MaintTypeDR");		//2011-08-29 HZY0005 
}

function BMaintItem_Click() 
{
	var MaintDR=GetElementValue("RowID");
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMaintItem&MaintDR='+MaintDR+"&BussType="+GetElementValue("BussType");
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=600,height=400,left=320,top=0');
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	return false;
}
function CheckInvalidData()
{
	if (IsValidateNumber(GetElementValue("MaintFee"),1,1,0,1)==0)
	{
		alertShow("�������������쳣,������.");
		return true;
	}
	return false;
}
function BMaintPart_Click() 
{
	var MaintDR=GetElementValue("RowID");
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMaintpart&MaintDR='+MaintDR;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=600,height=400,left=320,top=0');
}

function GetEquip(value) 
{
	var list=value.split("^")
	SetElement('Equip',list[0]);
	SetElement('EquipDR',list[1]);
	SetElement('UseLoc',list[2]);
	SetElement('UseLocDR',list[5]);
	parent.frames["DHCEQBanner"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBanner&RowIDB='+GetElementValue("EquipDR");
}

function GetMeasureDeptID(value)
{
	GetLookUpID("MeasureDeptDR",value);
}
function GetServiceID(value)
{	
	GetLookUpID("ServiceDR",value);
}
function GetMaintType(value) 
{
	GetLookUpID("MaintTypeDR",value);
}
function GetMaintLoc(value) 
{
	GetLookUpID("MaintLocDR",value);
}
function GetMaintMode(value) 
{
	GetLookUpID("MaintModeDR",value);
}
function GetManageLoc(value) 
{
	GetLookUpID("ManageLocDR",value);
}
function GetUseLoc(value) 
{
	GetLookUpID("UseLocDR",value);
}
function GetMaintUser(value) 
{
	GetLookUpID("MaintUserDR",value);
}
function GetPlanNameID(value)
{
	GetLookUpID("PlanNameDR",value);
	var PlanNameDR=GetElementValue("PlanNameDR")
	if (PlanNameDR=="")  return
	var encmeth=GetElementValue("GetPlanInfo");
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,PlanNameDR)
	Rtn=Rtn.replace(/\\n/g,"\n");
	var list=Rtn.split("^");
	var sort=44;	//DHC_EQMaintPlan
	SetElement("PlanName",list[0]);
	SetElement("ModelDR",list[4]);
	SetElement("MaintTypeDR",list[8]);
	SetElement("MaintFee",list[12]);
	SetElement("MaintLocDR",list[13]);
	SetElement("MaintUserDR",list[14]);
	SetElement("MaintModeDR",list[15]);
	SetChkElement("MeasureFlag",list[17]);
	SetElement("MeasureDeptDR",list[18]);
	SetElement("MeasureHandler",list[19]);
	SetElement("MeasureTel",list[20]);
	SetElement("ServiceDR",list[21]);
	SetElement("ServiceHandler",list[22]);
	SetElement("ServiceTel",list[23]);
	SetElement("Remark",list[24]);
	SetChkElement("InvalidFlag",list[35]);
	SetElement("MaintType",list[sort+4]);
	SetElement("MaintLoc",list[sort+5]);
	SetElement("MaintUser",list[sort+6]);
	SetElement("MaintMode",list[sort+7]);
	SetElement("MeasureDept",list[sort+9]);
	SetElement("Service",list[sort+10]);
}
function SetDisplay()
{
	ReadOnlyCustomItem(GetParentTable("PlanName"),GetElementValue("Status"));
	ReadOnlyElements("TotalFee^UseLoc",true)        //modified by czf begin ����ţ�337913
	var val=true
	if (GetElementValue("MaintTypeDR")=="5")
	{
		SetChkElement("MeasureFlag",true);
		DisableElement("MeasureFlag",true);
		val=false
	}
	ReadOnlyElements("MeasureDept^MeasureHandler^MeasureTel",val)
	DisableElement(GetLookupName("MeasureDept"),val);
	DisableElement(GetLookupName("UseLoc"),true);        //modified by czf begin ����ţ�337913
}

function MeasureFlag_Click()
{
	var MeasureFlag=GetElementValue("MeasureFlag")
	var value=true
	if (MeasureFlag==true)  value=false
	ReadOnlyElements("MeasureDept^MeasureHandler^MeasureTel",value)
	DisableElement(GetLookupName("MeasureDept"),value);
}

function BPicture_Click()
{
	//GR0033 EXTjs ͼƬ�ϴ�
	if (GetElementValue("RowID")=="") return; 
	if (GetElementValue("EquipDR")=="") {alertShow("��ѡ���豸");return}
	var Status=GetElementValue("Status")
	var str='dhceq.process.picturemenu.csp?&CurrentSourceType=32&CurrentSourceID='+GetElementValue("RowID")+'&EquipDR='+GetElementValue("EquipDR")+"&Status="+Status;
	//window.open(str,'_blank','left=0,top=0,width='+ (screen.availWidth - 10) +',height='+ (screen.availHeight-50) +',toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes')
	window.open(str,'_blank','left='+ (screen.availWidth - 1150)/2 +',top='+ ((screen.availHeight>750)?(screen.availHeight-750)/2:0) +',width=1150,height=750,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes')
	/*
	if (GetElementValue("RowID")=="") return; 
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQPicture&SourceType=1&SourceID='+GetElementValue("RowID");
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
	*/
}

//modified by GR0032 20150420 ������¼���Ӵ�ӡ����
function BPrint_Click()
{
	if(GetElementValue("RowID")=="")
	{
		alertShow("��ά���豸���ݿɴ�ӡ!")
		return
	}
	var RowID=GetElementValue("RowID")
	var encmetha=GetElementValue("fillData");
	if (encmetha=="") return;
	var ReturnList=cspRunServerMethod(encmetha,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var lista=ReturnList.split("^");
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	try {
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQMaintNewK.xls";
	    xlApp = new ActiveXObject("Excel.Application");
    	xlBook = xlApp.Workbooks.Add(Template);
    	xlsheet = xlBook.ActiveSheet;
    	var sort=42;
    	xlsheet.cells(2,1)="�����ʺ�:"+GetShortName(lista[sort+8],"-"); //ʹ�ÿ���1
    	xlsheet.cells(3,1)="������λ:"+GetShortName(lista[sort+20],"-"); //��Ӧ��1
    	xlsheet.cells(3,4)=ChangeDateFormat(lista[21]); //����ά������(ά������)
    	xlsheet.cells(3,6)=""; //ά�޵���
    	
    	xlsheet.cells(5,1)=lista[sort+0]; //�豸����1
    	xlsheet.cells(5,2)=lista[sort+24]; //Ʒ��1
    	xlsheet.cells(5,3)=lista[sort+16]; //����ͺ�1
    	xlsheet.cells(5,4)=lista[sort+3]	//����(ԭά�޷�ʽ)(��������)
    	xlsheet.cells(5,5)=ChangeDateFormat(lista[4]); //����ʱ��(�ύ����)1
    	xlsheet.cells(5,6)=lista[8]	//��������1
    	
    	xlsheet.cells(7,1)=""	//��Ʊ��
    	xlsheet.cells(7,2)=""	//���������
    	xlsheet.cells(7,3)=""	//���������
    	xlsheet.cells(7,4)=""	//��ʱ
    	xlsheet.cells(7,5)=lista[sort+18]; //�豸���1
    	xlsheet.cells(7,6)=lista[23]	//�����ۼ�1
    	
    	xlsheet.cells(8,2)=""; //��������
    	xlsheet.cells(9,2)=""	//���������(ʵ�ʺ����ǹ�������ע)
    	xlsheet.cells(10,2)=lista[13]	//��ע1
    	xlsheet.cells(11,2)="������:"+lista[sort+5]
    	xlsheet.cells(11,6)=curUserName	//������
    	
    	var obj = new ActiveXObject("PaperSet.GetPrintInfo");
	    var size=obj.GetPaperInfo("DHCEQInStock");
	    if (0!=size) xlsheet.PageSetup.PaperSize = size;
    	
    	xlsheet.printout; 	//��ӡ���
    	xlBook.Close (savechanges=false);
    	
    	xlsheet.Quit;
    	xlsheet=null;
	    
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}
function BPMReport_Click()
{
	//GR0058 PM����
	if (GetElementValue("RowID")=="") return; 
	if (GetElementValue("EquipDR")=="") {alertShow("��ѡ���豸");return}
	var Status=GetElementValue("Status")
	var ReadOnly=GetElementValue("ReadOnly")
	var str='dhceq.process.pmreport.csp?&MaintDR='+GetElementValue("RowID")+"&ReadOnly="+ReadOnly;
	//window.open(str,'_blank','left=0,top=0,width='+ (screen.availWidth - 10) +',height='+ (screen.availHeight-50) +',toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes')
	window.open(str,'_blank','left='+ (screen.availWidth - 1150)/2 +',top='+ ((screen.availHeight>750)?(screen.availHeight-750)/2:0) +',width=1150,height=750,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes')
	/*
	if (GetElementValue("RowID")=="") return; 
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQPicture&SourceType=1&SourceID='+GetElementValue("RowID");
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
	*/
}

document.body.onload = BodyLoadHandler;
