/// ����			DHCPEPreGADM.Edit.js
/// ����ʱ��		2006.06.13
/// ������			xuwm
/// ��Ҫ����		ԤԼ?����ԤԼ
/// ��Ӧ��		
/// ����޸�ʱ��	
/// ����޸���	
/// ���

var TFORM="";

function BodyLoadHandler() {

	var obj;
	//alert("s")
	//����
	obj=document.getElementById("Update");
	if (obj){ 
		obj.onclick = Update_click; 
		obj.disabled=true;
	}
	
	//������Ϣ/��Ŀ����
	obj=document.getElementById("PreGImport");
	if (obj){ 
		obj.onclick = ReadInfo; 
		//obj.disabled=true;
	}
	//������Ϣ��֤
	obj=document.getElementById("ImportCheck");
	if (obj){
		obj.onclick = CheckInfo; 
		//obj.disabled=true;
	}
	/*0405
	//��Ա����
	obj=document.getElementById("BITeam");
	if (obj){ 
		obj.onclick = Update_click; 
		obj.disabled=true;
	}
	
	//�������
	obj=document.getElementById("BGTeam");
	if (obj){ 
		obj.onclick = Update_click; 
		obj.disabled=true;
	}*/
	
	//�½�������Ϣ
	obj=document.getElementById("BNew");
	if (obj){ obj.onclick = NewGBaseInfo_click; }
	
	//����
	obj=document.getElementById("BFind");
	if (obj){ obj.onclick = BFind_click; }
	
	//���
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick = Clear_click; }
	
	//��λ����	PGBI_Code
	obj=document.getElementById('Code');
	if (obj) { obj.onchange = CodeChange; obj.onkeydown=Code_keydown;}
	
	////add
	//��λ����	PAPMINo
	obj=document.getElementById('PAPMINo');
	if (obj) { obj.onchange = PAPMINoChange;obj.onkeydown=PAPMINo_keydown; }
	
	// PGADM_AddOrdItem ������� 
	obj=document.getElementById("AddOrdItem");
	if (obj){ obj.onclick = AddOrdItem_click; }

	// PGADM_AddOrdItemLimit ���������� 
	obj=document.getElementById("AddOrdItemLimit");
	if (obj){ obj.onclick = AddOrdItemLimit_click; }

	// PGADM_AddPhcItem �����ҩ 
	obj=document.getElementById("AddPhcItem");
	//if (obj){ obj.onclick = AddPhcItem_click; }

	// PGADM_AddPhcItemLimit ��ҩ������� 
	obj=document.getElementById("AddPhcItemLimit");
	//if (obj){ obj.onclick = AddPhcItemLimit_click; }
	
	// Ĭ�������������뿪ʼ������ͬ
	obj=document.getElementById('BookDateBegin');
	if (obj) { obj.onblur=BookDateBegin_blur; }
	
	obj=document.getElementById("CardNo");
	if (obj) {obj.onchange=CardNo_Change;
	//obj.onkeydown=CardNo_KeyDown;
	obj.onkeydown=CardNo_keydown;
	}
	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCard_Click;}

	var obj=document.getElementById("PatFeeType_DR_Name");
	if (obj){obj.onchange=PatFeeType_Change;}

	initialReadCardButton()
	SetDefault()
	iniForm();

	DHCP_GetXMLConfig("InvPrintEncrypt","OEItemPrint");
	//ModifyDelayDate();
	//UpdatePreAudit();
}
function PatFeeType_Change()
{
	
	obj=document.getElementById("VIPLevel");
	if (obj){
		var VIPLevel=obj.value;
		if (VIPLevel=="") return false;
	}
	
	var obj=document.getElementById("PatFeeType_DR_Name");
	if(obj){var PatFeeType=obj.value; }
	
	var PatType=tkMakeServerCall("web.DHCPE.VIPLevel","GetPatFeeType",VIPLevel);
	if (PatType!=PatFeeType){
		var flag=tkMakeServerCall("web.DHCPE.PreCommon","IsFeeTypeSuperGroup");
		if(flag=="1")
		{
			alert("���ǳ���Ȩ��,�������޸��������")
			var obj=document.getElementById("PatFeeType_DR_Name");
			if(obj){ obj.value=PatType; }
			return false;
		}
		
	
 }
}

function CardNo_keydown(e)
{
	var key=websys_getKey(e);
	if (13==key) {
		CardNo_Change();
	}
}

function SetDefault()
{
	var ADMFeeType=""
	var obj=document.getElementById("GetADMFeeType");
	if (obj) {ADMFeeType=obj.value;}
	var obj=document.getElementById("PatFeeType_DR_Name");
	if (obj) {obj.value=ADMFeeType;}
}
function iniForm() {
	var obj;
	var LocID=session['LOGON.CTLOCID']
    obj=document.getElementById('AsCharged');
    if(obj) {
	var Default=document.getElementById("DefaultAsCharged");
	if (Default)
	{   
		if ((Default.value=="2")||(Default.value=="3")){obj.checked=true;}
		else{obj.checked=false;}
		
	} }
	
    AddOrdItem_click()
    AddPhcItem_click()
	obj=document.getElementById('ID');
	if (obj && ""!=obj.value) {
		obj=document.getElementById('DataBox');
		if (obj && ""!=obj.value) {
			SetPatient_Sel(obj.value);
			obj=document.getElementById("Update");
			if (obj){ obj.innerHTML="<img SRC='../images/websys/update.gif' BORDER='0'>����(<u>U</u>)"; }
		}
	}

}
function CardNo_Change()
{
	CardNoChangeApp("PAPMINo","CardNo","PAPMINoChange()","Clear_click()","1");
}

function ReadCard_Click()
{
	ReadCardApp("PAPMINo","PAPMINoChange()","CardNo");
	
}

// ///////////////////////////////////////////////////////////////////////////////

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

function nextfocus() {
	var eSrc=window.event.srcElement;
	var key=websys_getKey(e);
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
}
// /////////////////////////////////////////////////////////////

//�½�������Ϣ δʹ��
function NewGBaseInfo_click() {
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreGBaseInfo.Edit"
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=400,height=450,left=100,top=100';
	var nw=window.open(lnk,"_blank",nwin);

}

// �ṩ���Ӵ��ڵķ��غ��� δʹ��
function NewWindowReturn(value) {
	
	var Data=value.split("^");
	
	var obj=document.getElementById('Desc');
	if (obj) { obj.value=Data[0]; }
	
	var iCode=Data[1];
	obj=document.getElementById('Code');
	if (obj) { obj.value=iCode; }
	
	ID="^"+iCode;	// PGADM_RowId(DHC_PE_PreGADM)+PGBI_Code(DHC_PE_PreGBaseInfo)
	
	FindPatDetail(ID);
	
}

// ///////////////////////////////////////////////////////////////////////////////
//������� ������Ӧ����Ϣ
function Code_keydown(e) {
	
	var key=websys_getKey(e);
	//return true;
	if (13==key)
	{
		CodeChange();
	}
	
}
function CodeChange() {
	
	//var key=websys_getKey(e);
	//return true;
	//if (13==key)
	//{

		var obj;
		var iCode="";
		obj=document.getElementById('Code');
		if (obj && ""!=obj.value) 
		{ 
			iCode = obj.value;
		}
		else { return false; }		
		
		ID="^"+iCode;	// PGADM_RowId(DHC_PE_PreGADM)+PGBI_Code(DHC_PE_PreGBaseInfo)

		FindPatDetail(ID);
		
	//}
	
}
function GetSales(value) {
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;

		obj=document.getElementById("Sales");
		if (obj) { obj.value=aiList[0]; }


		obj=document.getElementById("Sales_DR");
		if (obj) { obj.value=aiList[1]; }

	}
}
///add
//����ADM ������Ӧ����Ϣ
function PAPMINo_keydown(e) {
	var key=websys_getKey(e);
	//return true;
	if (13==key){
		PAPMINoChange();}	
}
function PAPMINoChange() {
	//var key=websys_getKey(e);
	//return true;
	//if (13==key ||9==key){
		var obj=document.getElementById('PAPMINo')
		var iPAPMINo="";
		if (obj && ""!=obj.value) 
		{ 
			iPAPMINo = obj.value;
		}
		else { return false; }
		iPAPMINo = RegNoMask(iPAPMINo);
		obj.value=iPAPMINo
		var GetCodeMethodObj=document.getElementById("GetGCodeByADM")
		if (GetCodeMethodObj && ""!=GetCodeMethodObj.value) { 
			GetCodeMethod = GetCodeMethodObj.value;
		}
		else { return false; }
		var GCode=cspRunServerMethod(GetCodeMethod,iPAPMINo)	
		if (GCode=="") {Clear_click();return false;}
		ID="^"+GCode;
		FindPatDetail(ID);//}	
}
// Ĭ�������������뿪ʼ������ͬ
function BookDateBegin_blur() {

	var eSrc=document.getElementById('BookDateBegin');

	var obj=document.getElementById('BookDateEnd');
	if (obj && ""==obj.value) { obj.value=eSrc.value; }

}

// ������������������ķ���?�����Ʋ�������
//function SearchGList(value) 
function SearchGListAfter(value)
{

	var Data=value.split("^");

	var obj=document.getElementById('Desc');
	if (obj) { obj.value=Data[0]; }
	
	var iCode=Data[1];
	obj=document.getElementById('Code');
	if (obj) { obj.value=iCode; }

	ID="^"+iCode;	// PGADM_RowId(DHC_PE_PreGADM)+PGBI_Code(DHC_PE_PreGBaseInfo)

	FindPatDetail(ID);	
}

// ///////////////////////////////////////////////////////////////////////////////
function FindPatDetail(ID){

	var Instring=ID;

	var Ins=document.getElementById('GetDetail');

	if (Ins) { var encmeth=Ins.value} else {var encmeth=''};

	var flag=cspRunServerMethod(encmeth,'SetPatient_Sel','',Instring);

}

// 
function SetPatient_Sel(value) {

	Clear_click();

	var obj;
	var Data=value.split(";");
	
	var IsShowAlert=Data[2];
	if ("Y"==IsShowAlert) {
		// �����Ѿ�ԤԼ
		//alert(t["info 02"]);
		if (!(confirm(t["info 02"]))){
			return false;
		}else{
			obj=document.getElementById("Update");
			if (obj){
				obj.innerHTML="<img SRC='../images/websys/update.gif' BORDER='0'>ԤԼ(<u>U</u>)";
			}
		}
	}
	
	//�Ǽ���Ϣ
	var PreGADMData=Data[1];
	if (""!=PreGADMData) { SetPreGADM(PreGADMData); }
	
	//������Ϣ
	var PreGBaseGnfoData=Data[0];
	if (""!=PreGBaseGnfoData) { SetPreGBaseInfo(PreGBaseGnfoData) }

		
}

//�Ǽ���Ϣ
function SetPreGADM(value) {
	var obj;
	var fillData;
	var Data=value.split("^");
	var iLLoop=0;	
	iRowId=Data[iLLoop];
	var CurDate="",GReportSend="AC",IReportSend="IS"
	obj=document.getElementById("CurDate");
	if (obj) CurDate=obj.value;
	obj=document.getElementById("BookDateBegin");
	if (obj) obj.value=CurDate;
	obj=document.getElementById("BookDateEnd");
	if (obj) obj.value=CurDate;
	obj=document.getElementById("GReportSend");
	if (obj) obj.value=GReportSend;
	obj=document.getElementById("IReportSend");
	if (obj) obj.value=IReportSend;
	//��ͬ�շ� PIADM_AsCharged
	obj=document.getElementById("AsCharged");
	if (obj) { 
	var Default=document.getElementById("DefaultAsCharged");
	if (Default)
	{
		if ((Default.value=="2")||(Default.value=="3")){obj.checked=true;}
		else{obj.checked=false;}
		
	}}
		

	if ('0'==iRowId) { return true; }
	
	// ��ť"������Ϣ/��Ŀ����"����
	obj=document.getElementById("PreGImport");
	if (obj){ obj.disabled=false; }
	
	//����ADM 0
	obj=document.getElementById("PGADM_RowId");
	if (obj) { obj.value=iRowId; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_PGBI_DR	Ԥ����ͻ�RowId 2
	obj=document.getElementById("PGBI_RowId");
	//obj=document.getElementById("PGBI_DR");
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	obj=document.getElementById("PIBI_DR_Code");
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	obj=document.getElementById("PIBI_DR_Name");
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_BookDateBegin	ԤԼ���� 4
	obj=document.getElementById("BookDateBegin");
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	// PGADM_BookDateEnd 29
	obj=document.getElementById("BookDateEnd");
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	// PGADM_BookTime	ԤԼʱ�� 5
	obj=document.getElementById("BookTime");
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_AuditUser_DR	ԤԼ�Ӵ���Ա 16
	obj=document.getElementById("PEDeskClerk_DR");
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	obj=document.getElementById("PEDeskClerk_DR_Name");
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	// PGADM_Status	״̬ 8
	obj=document.getElementById("Status");
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
		
	// PGADM_AsCharged	��ͬ�շ� 3
	obj=document.getElementById("AsCharged");
	if (obj) {
		if (fillData=="Y"){obj.checked=true;
		}
		else{obj.checked=false;
		}
		}
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	var strLine=""
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	SetAddItem(strLine);
	
	// PGADM_GReportSend ���屨�淢�� 26
	obj=document.getElementById("GReportSend");
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];

	// PGADM_IReportSend ���˱��淢�� 27
	obj=document.getElementById("IReportSend");
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];

	// PGADM_DisChargedMode ���㷽ʽ 28
	obj=document.getElementById("DisChargedMode");
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	// PGADM_DelayDate
	obj=document.getElementById("DelayDate");
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	// PGADM_Remark	��ע 6
	obj=document.getElementById("Remark");
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	var obj=document.getElementById('PAPMINo');
	if (obj) { obj.value=fillData; }
	iLLoop=iLLoop+3;
	fillData=Data[iLLoop];
	// PGADM_PEDeskClerk_DR ԤԼ�Ӵ���Ա 15
	obj=document.getElementById("Sales_DR");
	if (obj) {obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// 15.1
	obj=document.getElementById("Sales");
	if (obj) {obj.value=fillData; }
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_AuditUser_DR	ҵ��Ա 31
	obj=document.getElementById("Type");
	if (obj) {obj.value=fillData; }
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_AuditUser_DR	ҵ��Ա 32
	obj=document.getElementById("GetReportDate");
	if (obj) {obj.value=fillData; }
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_AuditUser_DR	ҵ��Ա 33
	obj=document.getElementById("GetReportTime");
	if (obj) {obj.value=fillData; }
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_AuditUser_DR	ҵ��Ա 33
	obj=document.getElementById("PayType");
	if (obj) {obj.value=fillData; }
	
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_AuditUser_DR	ҵ��Ա 33
	obj=document.getElementById("Percent");
	if (obj) {obj.value=fillData; }
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// 	������� ����ȡ�ƷѼ۸�
	obj=document.getElementById("PatFeeType_DR_Name");
	if (obj) {obj.value=fillData; }
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// 	��ͬID
	obj=document.getElementById("ContractID");
	if (obj) {obj.value=fillData; }
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// 	��ͬ����
	obj=document.getElementById("Contract");
	if (obj) {obj.value=fillData; }
	return true

}
function SetAddItem(value) {
	var Data=value.split("^");
	var iLLoop=0;	
	
	var iAddOrdItem=false;
	//	�������	PGADM_AddOrdItem	19
	obj=document.getElementById("AddOrdItem");
	if (obj) {
		if ("Y"==Data[iLLoop]) {
			obj.checked=true;
			iAddOrdItem=true;
			
		}
		else { 
			obj.checked=false;
			iAddOrdItem=false;
		}
				
	}
	iLLoop=iLLoop+1;	
	
	var iAddOrdItemLimit=false;
	//	����������	PGADM_AddOrdItemLimit	20
	obj=document.getElementById("AddOrdItemLimit");
	if (obj) { 
		if (iAddOrdItem) {
			obj.style.display="inline"; // �ɼ�
			obj.disabled=false;
			if ("Y"==Data[iLLoop]) {
				obj.checked=true;
				iAddOrdItemLimit=true;
			}
			else {
				obj.checked=false;
				iAddOrdItemLimit=false;
			}
			
			obj=document.getElementById("cAddOrdItemLimit");	
			if (obj) {obj.style.display="inline"; }	
		}
		else {
			obj.style.display="none";
			obj.disabled=true;
			
			obj.checked=false;
			iAddOrdItemLimit=false;
			
			obj=document.getElementById("cAddOrdItemLimit");	
			if (obj) {obj.style.display="none"; }				
		}
	}
	iLLoop=iLLoop+1;	
	
	//	���������	PGADM_AddOrdItemAmount	21
	obj=document.getElementById("AddOrdItemAmount");
	if (obj) {
		if (iAddOrdItemLimit) {
			obj.style.display="inline"; // �ɼ�
			obj.disabled=false;
			
			obj.value=Data[iLLoop];
			
			obj=document.getElementById("cAddOrdItemAmount");	
			if (obj) {obj.style.display="inline"; }
		}
		else{
			obj.style.display="none"; // �ɼ�
			obj.disabled=true;
			
			obj.value="";
			
			obj=document.getElementById("cAddOrdItemAmount");	
			if (obj) {obj.style.display="none"; }
		}
		
	}
	iLLoop=iLLoop+1;	
	
	//	�����ҩ	PGADM_AddPhcItem	22
	var iAddPhcItem=false;
	obj=document.getElementById("AddPhcItem");
	if (obj) {
		if ("Y"==Data[iLLoop]) {
			obj.checked=true;
			iAddPhcItem=true;
		}
		else {
			obj.checked=false;
			iAddPhcItem=false
		}

	}
	iLLoop=iLLoop+1;	
	
	//	��ҩ�������	PGADM_AddPhcItemLimit	23
	var iAddPhcItemLimit=false;
	obj=document.getElementById("AddPhcItemLimit");
	if (obj) {
		if (iAddPhcItem) {
			//obj.style.display="inline"; // �ɼ�
			obj.disabled=false;
			
			if ("Y"==Data[iLLoop]) {
				obj.checked=true;
				iAddPhcItemLimit=true;
				
			}
			else {
				obj.checked=false;
				iAddPhcItemLimit=false;
			}
			
			obj=document.getElementById("cAddPhcItemLimit");	
			//if (obj) {obj.style.display="inline"; }
		}
		else{
			obj.style.display="none"; 
			obj.disabled=true;
			
			obj.checked=false;
			iAddPhcItemLimit=false;
			
			obj=document.getElementById("cAddPhcItemLimit");	
			if (obj) {obj.style.display="none"; }
		}	

	}
	iLLoop=iLLoop+1;
	
	//	�����ҩ���	PGADM_AddPhcItemAmount	24
	obj=document.getElementById("AddPhcItemAmount");		
	if (obj) {
		if (iAddPhcItemLimit) {
			//obj.style.display="inline";
			obj.disabled=false;
			
			obj.value=Data[iLLoop];
			
			obj=document.getElementById("cAddPhcItemAmount");
			//if (obj) { obj.style.display="inline"; }		
		}
		else{
			obj.style.display="none";
			obj.disabled=true;
			obj.value="";
		}
	}
	
}


//������Ϣ
function SetPreGBaseInfo(value) {

	var obj;
	var Data=value.split("^");
	var iLLoop=0;

	var iRowId=Data[iLLoop];	

	iLLoop=iLLoop+1;
	
	if ("0"==iRowId) {	//δ�ҵ���¼
	

		//��λ����	PGBI_Code	1
		obj=document.getElementById('Code');
		if (obj) { obj.value=Data[iLLoop]; }
	
		iLLoop=iLLoop+1;
		//��    ��	PGBI_Desc	2
		obj=document.getElementById('Desc');
		if (obj) { obj.value=Data[iLLoop]; }
		return false;
	}

	//����
	obj=document.getElementById("Update");
	if (obj){ obj.disabled=false; }
	
	
	//����
	obj=document.getElementById("Update");
	if (obj){ obj.disabled=false; }
	
	obj=document.getElementById('PGBI_RowId');
	if (obj) { obj.value=iRowId; }		

	//��λ����	PGBI_Code	1
	obj=document.getElementById('Code');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//��    ��	PGBI_Desc	2
	obj=document.getElementById('Desc');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//��    ַ	PGBI_Address	3
	obj=document.getElementById('Address');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//��������	PGBI_Postalcode	4
	obj=document.getElementById('Postalcode');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//��ϵ��	PGBI_Linkman	5
	obj=document.getElementById('Linkman');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//ҵ������	PGBI_Bank	6
	obj=document.getElementById('Bank');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//��    ��	PGBI_Account	7
	obj=document.getElementById('Account');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//��ϵ�绰1	PGBI_Tel1	8
	obj=document.getElementById('Tel1');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//��ϵ�绰2	PGBI_Tel2	9
	obj=document.getElementById('Tel2');
	if (obj) { obj.value=Data[iLLoop]; }

	iLLoop=iLLoop+1;
	//�����ʼ�	PGBI_Email	10
	obj=document.getElementById('Email');
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+3;
	//�����ʼ�	PGBI_PAPMINo	10
	obj=document.getElementById('PAPMINo');
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+2;
	//	CardNo	10
	obj=document.getElementById('CardNo');
	if (obj) { obj.value=Data[iLLoop]; }
	
	return true;
}


// ///////////////////////////////////////////////////////////////////////////////
// �����µĸ�����ԤԼ��¼
function SetParentID(Data) {
	parent.SetGADM(Data);
}

// �����������Ϣ
function GImport_click(){
		var Imp;
		var iUpdateUserDR="",iRowId="",iDesc="";
		var obj;

		obj=document.getElementById("PGADM_RowId");
		if (obj) { iRowId=obj.value; }
		if (""==iRowId) { return ; }
		obj=document.getElementById('Desc');
		if (obj) { iDesc=obj.value; }
		
		iUpdateUserDR=session['LOGON.USERID']; // ������
		
		Imp= new ActiveXObject("DHCPEIMPGInfor.PEGInfo");
		
		//alert(Imp)
		Imp.Import(iRowId,iDesc,iUpdateUserDR,"");
		
		//Imp=null;
		
}

// ����ҳ�� ��ĿԤԼ ����Ӧ�ս����
function SetAmount(Amount){
	var iAccountAmount="";
	
	var obj=document.getElementById("AccountAmount");
	if (obj) { 
		iAccountAmount=obj.value;
		obj.value=Amount;
	}
	
}

function Update_click() {
	
	var eSrc=window.event.srcElement;
	if (eSrc.disabled) { return false; }
	Update();
	
}
function Update() {
	var iRowId="";
	var iPGBIDR="", iAsCharged="", iBookDateBegin="", iBookDateEnd="", iBookTime="", iRemark="", 
		iContractNo="", iStatus="",
		iAccountAmount="", iDiscountedAmount="", iFactAmount="",
		iAuditUserDR="", iAuditDate="", 
		iUpdateUserDR="", iUpdateDate="", 
		iPEDeskClerkDR="", iSaleAmount="",
		iChargedStatus="", iChargedStatusDesc="", 
		iCheckedStatus="", iCheckedStatusDesc="", 
		iAddOrdItem="", iAddOrdItemLimit="", iAddOrdItemAmount="", 
		iAddPhcItem="", iAddPhcItemLimit="", iAddPhcItemAmount="", 
		iGReportSend="", iGReportSendDesc="", 
		iIReportSend="", iIReportSendDesc="",
		iDisChargedMode="", iDisChargedModeDesc="",iDelayDate="",Sales="",
		Type="",GetReportDate="",GetReportTime="",PayType="",Percent=""
		DietFlag="1",GiftFlag="0",PatFeeType="",Contract="";
	    var obj;

	// PGADM_RowId	����ADM 1
	obj=document.getElementById("PGADM_RowId");
	if (obj) { iRowId=obj.value; }
	
	// PGADM_PGBI_DR	Ԥ����ͻ�RowId 2
	obj=document.getElementById("PGBI_RowId");
	//obj=document.getElementById("PGBI_DR");
	if (obj) { iPGBIDR=obj.value; }
	
	// PGADM_BookDateBegin	ԤԼ���� 4
	obj=document.getElementById("BookDateBegin");
	if (obj) { iBookDateBegin=obj.value; }
	
	// PGADM_BookDateEnd 29
	obj=document.getElementById("BookDateEnd");
	if (obj) { iBookDateEnd=obj.value; }
	
	// PGADM_BookTime	ԤԼʱ�� 5
	obj=document.getElementById("BookTime");
	if (obj) {
		if ('clsInvalid'==obj.className) { 
			//alert("��Чʱ���ʽ");
			alert(t["Err 04"]);
			return false;
		}
		iBookTime=obj.value;
	}
	

	// PGADM_AuditUser_DR	ԤԼ�Ӵ���Ա 16
	obj=document.getElementById("PEDeskClerk_DR");
	if (obj) { iPEDeskClerkDR=obj.value; }	

	// PGADM_Status	״̬ 8
	obj=document.getElementById("Status");
	if (obj) { 
		iStatus=obj.value;
		if (("PREREG"!=iStatus)&&(""!=iRowId)) {
			//alert("����Ԥ�ǼǵǼ�״̬?�����޸�")
			//alert(t['Err 05']);
			//return false;			
		}
	}
		
	// PGADM_AsCharged	��ͬ�շ� 3
	obj=document.getElementById("AsCharged");
	if (obj && obj.checked) { iAsCharged="Y"; }
	else { iAsCharged="N"; }
	
	// PGADM_AddOrdItem ������� 20
	obj=document.getElementById("AddOrdItem");
	if (obj && obj.checked) { iAddOrdItem='Y'; }
	else { iAddOrdItem='N';}
	
	// PGADM_AddOrdItemLimit ���������� 21
	obj=document.getElementById("AddOrdItemLimit");
	if (obj && obj.checked) { iAddOrdItemLimit='Y'; }
	else { iAddOrdItemLimit='N';}

	// PGADM_AddOrdItemAmount ��������� 22
	obj=document.getElementById("AddOrdItemAmount");
	if (obj) { iAddOrdItemAmount=obj.value; }

	// PGADM_AddPhcItem �����ҩ 23
	obj=document.getElementById("AddPhcItem");
	if (obj && obj.checked) { iAddPhcItem='Y'; }
	else { iAddPhcItem='N';}

	// PGADM_AddPhcItemLimit ��ҩ������� 24
	obj=document.getElementById("AddPhcItemLimit");
	if (obj && obj.checked) { iAddPhcItemLimit='Y'; }
	else { iAddPhcItemLimit='N';}

	//  PGADM_AddPhcItemAmount�����ҩ��� 25
	obj=document.getElementById("AddPhcItemAmount");
	if (obj) { iAddPhcItemAmount=obj.value; }
	
	// PGADM_GReportSend ���屨�淢�� 26
	obj=document.getElementById("GReportSend");
	if (obj) { iGReportSend=obj.value; }

	// PGADM_IReportSend ���˱��淢�� 27
	obj=document.getElementById("IReportSend");
	if (obj) { iIReportSend=obj.value; }

	// PGADM_DisChargedMode ���㷽ʽ 28
	obj=document.getElementById("DisChargedMode");
	if (obj) { iDisChargedMode=obj.value; }

	// PGADM_DelayDate
	obj=document.getElementById("DelayDate");
	if (obj) { iDelayDate=obj.value; }
	
	// PGADM_Remark	��ע 29
	obj=document.getElementById("Remark");
	if (obj) { iRemark=obj.value; }
	//����������֤
	if (""==iPGBIDR) {
		//alert("Please entry all information.");
		alert(t['01']);
		return false;
	}
	//����������֤
	if (""==iBookDateBegin) {
		//alert("Please entry all information.");
		alert(t['08']);
		websys_setfocus('BookDateBegin');
		return false;
	}
	//����������֤
	if (""==iBookDateEnd) {
		//alert("Please entry all information.");
		alert(t['08']);
		websys_setfocus('BookDateEnd');
		return false;
	}
	//����������֤
	if (""==iGReportSend) {
		//alert("Please entry all information.");
		alert(t['Err 10']);
		websys_setfocus('GReportSend');
		return false;
	}
	//����������֤
	if (""==iIReportSend) {
		//alert("Please entry all information.");
		alert(t['Err 10']);
		websys_setfocus('IReportSend');
		return false;
	}
	//����������֤
	if (("Y"==iAddOrdItemLimit)&&(""==iAddOrdItemAmount)) {
		//alert("Please entry all information.");
		alert(t['Err 09']);
		websys_setfocus('AddOrdItemAmount');
		return false;
	}
	if (("Y"==iAddPhcItemLimit)&&(""==iAddPhcItemAmount)) {
		//alert("Please entry all information.");
		alert(t['Err 09']);
		websys_setfocus('AddPhcItemAmount');
		return false;
	}
	// PGADM_AuditUser_DR	ҵ��Ա 30
	obj=document.getElementById("Sales_DR");
	if (obj) { Sales=obj.value; }
	
	
	// ����	ҵ��Ա 31
	obj=document.getElementById("Type");
	if (obj) { Type=obj.value; }
	
	// ȡ��������	ҵ��Ա 32
	obj=document.getElementById("GetReportDate");
	if (obj) { GetReportDate=obj.value; }
	
	// ȡ����ʱ��	ҵ��Ա 33
	obj=document.getElementById("GetReportTime");
	if (obj) { GetReportTime=obj.value; }
	
	// ��������	ҵ��Ա 33
	obj=document.getElementById("PayType");
	if (obj) { PayType=obj.value; }	
	
	// �ٷֱ�	ҵ��Ա 33
	obj=document.getElementById("Percent");
	if (obj) { Percent=obj.value; }	
	// �Ͳͱ�־	ҵ��Ա 33
	obj=document.getElementById("DietFlag");
	if (obj&&!obj.checked) { DietFlag="0"; }	
	//��Ʒ��־	ҵ��Ա 33
	obj=document.getElementById("GiftFlag");
	if (obj&&obj.checked) { GiftFlag="1" ;}
	//var GiftFlag="@@@@"
	//������������ȡ�۸�
	obj=document.getElementById("PatFeeType_DR_Name");		
	if (obj) { PatFeeType=obj.value; }
	
	//������ͬ
	obj=document.getElementById("ContractID");		
	if (obj) { Contract=obj.value; }
	
	/*
	//����������֤
	if (""==iBookTime) {
		//alert("Please entry all information.");
		alert(t['09']);
		websys_setfocus('BookTime');
		return false;
	}
	*/
	var Instring= trim(iRowId)					// 1
				+"^"+trim(iPGBIDR)				// 2	PGADM_PGBI_DR	Ԥ����ͻ�
				+"^"+trim(iBookDateBegin)		// 3	PGADM_BookDateBegin	ԤԼ����
				+"^"+trim(iBookDateEnd)			// 4	PGADM_BookDateEnd
				+"^"+trim(iBookTime)			// 5	PGADM_BookTime	ԤԼʱ��
				+"^"+trim(iPEDeskClerkDR)		// 6	PGADM_PEDeskClerk_DR	ԤԼ�Ӵ���Ա
				+"^"+trim(iStatus)				// 7	PGADM_Status	״̬
				+"^"+trim(iAsCharged)			// 8	PGADM_AsCharged	��ͬ�շ�
				+"^"+trim(iAddOrdItem)			// 9	PGADM_AddOrdItem �������
				+"^"+trim(iAddOrdItemLimit)		// 10	PGADM_AddOrdItemLimit ����������
				+"^"+trim(iAddOrdItemAmount)	// 11	PGADM_AddOrdItemAmount ���������
				+"^"+trim(iAddPhcItem)			// 12	PGADM_AddPhcItem �����ҩ
				+"^"+trim(iAddPhcItemLimit)		// 13	PGADM_AddPhcItemLimit ��ҩ�������
				+"^"+trim(iAddPhcItemAmount)	// 14	PGADM_AddPhcItemAmount�����ҩ���
				+"^"+trim(iGReportSend)			// 15	PGADM_GReportSend ���屨�淢��
				+"^"+trim(iIReportSend)			// 16	PGADM_IReportSend ���˱��淢��
				+"^"+trim(iDisChargedMode)		// 17	PGADM_DisChargedMode ���㷽ʽ
				+"^"+trim(iDelayDate)           // 18	PGADM_DelayDate ��������
				+"^"+trim(iRemark)				// 19	PGADM_Remark	��ע	
				+"^"+trim(Sales)
				+"^"+trim(Type)
				+"^"+trim(GetReportDate)
				+"^"+trim(GetReportTime)
				+"^"+trim(PayType)
				+"^"+trim(Percent)
				+"^"+trim(DietFlag)
				+"^"+trim(GiftFlag)
				+"^"+trim(PatFeeType)
				+"^"+trim(Contract)
				;
	//alert("Instring :"+Instring);
	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring)
	if (flag=="Err Date")
	{
		alert(t["Err Date"]);
		return false;
	}
	
	if (flag=="Err HomeDate")
	{
		alert(t["Err HomeDate"]);
		return false;
	}

	if (""==iRowId) { //������� ���� RowId
		var Rets=flag.split("^");
		flag=Rets[0];
		
		// PGADM_RowId	����ADM 1
		obj=document.getElementById("PGADM_RowId");
		if (obj) { obj.value=Rets[1]; }
	}

	if ('0'==flag) {
		//alert("Update Success!");
		if (""==iRowId) { alert(t['info 01']); }
		else { alert(t['info 04']); }
	
		// ������Ϣ/��Ŀ����
		obj=document.getElementById("PreGImport");
		if (obj){ obj.disabled=false; }	
			
		if (""==iRowId) { //ˢ��ҳ��
		
			obj=document.getElementById("PGADM_RowId");
			if (obj) { obj.value=Rets[1]; }
			
			//��    ��	PGBI_Desc
			obj=document.getElementById('Desc');
			if (obj) { iDesc=obj.value; }
			
			var lnk="dhcpepregadm.edit.csp?"
			+"ParRef="+Rets[1]
			+"&ParRefName="+""
			+"&OperType="+"E"
			;
         
			SetParentID(
				Rets[1]
				+"^"+iDesc+"^"
				+iBookDateBegin
				+"^"+iBookTime
				+"^"+"E"
				
			);
			
			return false;
		}

		return false;
	}
	else if ('Err 02'==flag) {
		alert(t['Err 02']);
		return false;		
	}
	else if ('Err 05'==flag) {
		//alert("����Ԥ�ǼǵǼ�״̬?�����޸�")
		alert(t['Err 05']);
		return false;		
	}		
	else {
		//alert("Insert error.ErrNo="+flag);
		alert(t['02']+flag);
		
		return false;
	}

	//ˢ��ҳ��
	//location.reload(); 
	return true;
}


// ///////////////////////////////////////////////////////////////////////////////
//����������Ϣ
function Clear_click() {

	//����
	obj=document.getElementById("Update");
	if (obj){ obj.disabled=true; }
	
	// ������Ϣ/��Ŀ����
	obj=document.getElementById("PreGImport");
	if (obj){ obj.disabled=true; }
	
	//��Ա����
	obj=document.getElementById("BITeam");
	if (obj){ obj.disabled=true; }
	
	//�������
	obj=document.getElementById("BGTeam");
	if (obj){ obj.disabled=true; }
	
	PreGADM_Clear_click();
	PreGBaseInfo_Clear_click();

}
//�Ǽ���Ϣ
function PreGADM_Clear_click() {

	var obj;	
	    
	// PGADM_RowId	 ����ADM 0
	obj=document.getElementById("PGADM_RowId");
	if (obj) {obj.value=""; }
	
	// PGADM_PGBI_DR	 Ԥ����ͻ�RowId 1
	obj=document.getElementById("PGBI_DR");
	if (obj) {obj.value=""; }
	// PGADM_PGBI_DR_Name	 Ԥ����ͻ�RowId 1.1
	//obj=document.getElementById("PGBI_DR_Name");
	//if (obj) {obj.value=""; }
	
	// PGADM_AsCharged	 ��ͬ�շ� 2
	//obj=document.getElementById("AsCharged");
	//if (obj) { obj.checked=false; }
	obj=document.getElementById("AsCharged");
	if (obj) { 
	var Default=document.getElementById("DefaultAsCharged");
	if (Default)
	{
		if ((Default.value=="1")||(Default.value=="3")){obj.checked=true;}
		else{obj.checked=false;}
		
	}}
	
	
	// PGADM_BookDateBegin	 ԤԼ���� 3
	obj=document.getElementById("BookDate");
	if (obj) {obj.value=""; }
	
	// PGADM_BookTime	 ԤԼʱ�� 4
	obj=document.getElementById("BookTime");
	if (obj) {obj.value=""; }
	
	// PGADM_Remark	 ��ע 5
	obj=document.getElementById("Remark");
	if (obj) {obj.value=""; }
	
	// PGADM_ContractNo	 ��ͬ��� 6
	obj=document.getElementById("ContractNo");
	if (obj) {obj.value=""; }
	
	// PGADM_Status	 ״̬ 7
	obj=document.getElementById("Status");
	if (obj) {obj.value=""; }
	
	// PGADM_AccountAmount	 Ӧ�ս�� 8
	obj=document.getElementById("AccountAmount");
	if (obj) {obj.value=""; }
	
	//PGADM_DiscountedAmount	 ���ۺ��� 9
	obj=document.getElementById("DiscountedAmount");
	if (obj) {obj.value=""; }
	
	// PGADM_FactAmount	 ���ս�� 10
	obj=document.getElementById("FactAmount");
	if (obj) {obj.value=""; }
	
	// PGADM_AuditUser_DR	 ����� 11
	obj=document.getElementById("AuditUser_DR");
	if (obj) {obj.value=""; }
	//obj=document.getElementById("AuditUser_DR_Name");
	//if (obj) {obj.value=""; }
		
	// PGADM_AuditDate	 ������� 12
	obj=document.getElementById("AuditDate");
	if (obj) {obj.value=""; }
	
	// PGADM_UpdateUser_DR	 ������ 13
	obj=document.getElementById("UpdateUser_DR");
	if (obj) {obj.value=""; }
	//PGADM_UpdateUser_DR_Name	 	
	//obj=document.getElementById("UpdateUser_DR_Name");
	//if (obj) {obj.value=""; }
		
	// PGADM_UpdateDate	 �������� 14
	obj=document.getElementById("UpdateDate");
	if (obj) {obj.value=""; }	
	
	
	// PGADM_PEDeskClerk_DR ԤԼ�Ӵ���Ա 15
	obj=document.getElementById("PEDeskClerk_DR");
	if (obj) {obj.value=""; }
	
	// 15.1
	obj=document.getElementById("PEDeskClerk_DR_Name");
	if (obj) {obj.value=""; }
		
	// PGADM_SaleAmount	���۽�� 16
	obj=document.getElementById("SaleAmount");
	if (obj) { obj.value=""; }
	
	
	//	�շ�״̬	PGADM_ChargedStatus	17
	obj=document.getElementById("ChargedStatus");
	if (obj) { obj.value=""; }	
	
	//	�շ�״̬	PGADM_ChargedStatus_Name	17.1
	obj=document.getElementById("ChargedStatus_Name");
	if (obj) { obj.value=""; }	
	
	//	���״̬	PGADM_CheckedStatus	18
	obj=document.getElementById("CheckedStatus");
	if (obj) { obj.value=""; }
	
	//	���״̬	PGADM_CheckedStatus_Name	18.1
	//obj=document.getElementById("CheckedStatus_Name");
	//if (obj) { obj.value=""; }
	
	//	�������	PGADM_AddOrdItem	19
	obj=document.getElementById("AddOrdItem");
	if (obj) { obj.checked=false; }
	
	//	����������	PGADM_AddOrdItemLimit	20
	obj=document.getElementById("AddOrdItemLimit");
	if (obj) {
		obj.style.display="none";
		obj.checked=false;
	}
	
	//	���������	PGADM_AddOrdItemAmount	21
	obj=document.getElementById("AddOrdItemAmount");
	if (obj) {
		obj.style.display="none";
		obj.value="";	
	}
	
	//	�����ҩ	PGADM_AddPhcItem	22
	obj=document.getElementById("AddPhcItem");
	if (obj) { obj.checked=false; }	
	
	//	��ҩ�������	PGADM_AddPhcItemLimit	23
	obj=document.getElementById("AddPhcItemLimit");
	if (obj) { 
		obj.checked=false;
		obj.style.display="none";
	}
	
	//	�����ҩ���	PGADM_AddPhcItemAmount	24
	obj=document.getElementById("AddPhcItemAmount");
	if (obj) {
		obj.style.display="none";
		obj.value="";	
	}
	
	//	���屨�淢��	PGADM_GReportSend	25
	obj=document.getElementById("GReportSend");
	if (obj) { obj.value=""; }	
	
	//	���屨�淢��	PGADM_GReportSend_Name	25.1
	//obj=document.getElementById("GReportSend_Name");
	//if (obj) { obj.value=""; }	
	
	//	���˱��淢��	PGADM_IReportSend	26
	obj=document.getElementById("IReportSend");
	if (obj) { obj.value=""; }

	//	���˱��淢��	PGADM_IReportSend_Name	26.1
	//obj=document.getElementById("IReportSend_Name");
	//if (obj) { obj.value=""; }

	//	���㷽ʽ	PGADM_DisChargedMode	27
	obj=document.getElementById("DisChargedMode");
	if (obj) { obj.value="GD"; }
	
	//	���㷽ʽ	PGADM_DisChargedMode_Name	27.1
	//obj=document.getElementById("DisChargedMode_Name");
	//if (obj) { obj.value=""; }

	// PGADM_BookDateEnd	 28
	obj=document.getElementById("BookDateEnd");
	if (obj) {obj.value=""; }
	
	// PGADM_PEDeskClerk_DR ԤԼ�Ӵ���Ա 15
	obj=document.getElementById("Sales_DR");
	if (obj) {obj.value=""; }
	
	// 15.1
	obj=document.getElementById("Sales");
	if (obj) {obj.value=""; }
	
	// 15.1
	obj=document.getElementById("Type");
	if (obj) {obj.value=""; }
	
	// 15.1
	obj=document.getElementById("GetReportDate");
	if (obj) {obj.value=""; }
	
	// 15.1
	obj=document.getElementById("GetReportTime");
	if (obj) {obj.value=""; }
	
	// 15.1
	obj=document.getElementById("PayType");
	if (obj) {obj.value=""; }
	
	// 15.1
	obj=document.getElementById("Percent");
	if (obj) {obj.value=""; }
	
}
//������Ϣ
function PreGBaseInfo_Clear_click() {

	var obj;	
	    
	//			PGBI_RowId
	obj=document.getElementById("PGBI_RowId");
	if (obj) {obj.value=""; }

	//��λ����	PGBI_Code
	obj=document.getElementById('Code');
	if (obj) { obj.value=''; }

	//��    ��	PGBI_Desc
	obj=document.getElementById('Desc');
	if (obj) { obj.value=''; }

	//��    ַ	PGBI_Address
	obj=document.getElementById('Address');
	if (obj) { obj.value=''; }

	//��������	PGBI_Postalcode
	obj=document.getElementById('Postalcode');
	if (obj) { obj.value=''; }

	//��ϵ��	PGBI_Linkman
	obj=document.getElementById('Linkman');
	if (obj) { obj.value=''; }

	//ҵ������	PGBI_Bank
	obj=document.getElementById('Bank');
	if (obj) { obj.value=''; }

	//��    ��	PGBI_Account
	obj=document.getElementById('Account');
	if (obj) { obj.value=''; }

	//��ϵ�绰1	PGBI_Tel1
	obj=document.getElementById('Tel1');
	if (obj) { obj.value=''; }

	//��ϵ�绰2	PGBI_Tel2
	obj=document.getElementById('Tel2');
	if (obj) { obj.value=''; }

	//�����ʼ�	PGBI_Email
	obj=document.getElementById('Email');
	if (obj) { obj.value=''; }

}
// /////////////////////////////////////////////////////////////
// ѡ��Ӵ���
function SearchUser(value) {

	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;

		obj=document.getElementById("PEDeskClerk_DR_Name");
		if (obj) { obj.value=aiList[0]; }


		obj=document.getElementById("PEDeskClerk_DR");
		if (obj) { obj.value=aiList[1]; }

	}
}
//  �������(PGADM_AddOrdItem)
function AddOrdItem_click() {
	//var src=window.event.srcElement;
	var src=document.getElementById("AddOrdItem");
	var obj;

	if (src.checked) {
		// PGADM_AddOrdItemLimit ���������� 
		obj=document.getElementById("AddOrdItemLimit");
		if (obj){
			obj.style.display = "inline" ;
			obj.disabled=false;
			obj.checked=true;
		}
		obj=document.getElementById("cAddOrdItemLimit");
		if (obj){ obj.style.display = "inline" ; }
		
		obj=document.getElementById("AddOrdItemAmount");
		if (obj){
			obj.style.display="inline";
			obj.disabled=false;
			obj.value="";
		}
		obj=document.getElementById("cAddOrdItemAmount");
		if (obj){ obj.style.display = "inline" ; }
		
		websys_setfocus("AddOrdItemAmount");
	}
	else{
		// PGADM_AddOrdItemLimit ���������� 
		obj=document.getElementById("AddOrdItemLimit");
		if (obj){
			obj.style.display = "none" ;
			obj.disabled=true;
			obj.checked=false;
		}
		obj=document.getElementById("cAddOrdItemLimit");
		if (obj){ obj.style.display = "none" ; }
		
		obj=document.getElementById("AddOrdItemAmount");
		if (obj){
			obj.style.display = "none" ;
			obj.disable=true;
			obj.value="";
		}
		obj=document.getElementById("cAddOrdItemAmount");
		if (obj){ obj.style.display = "none" ; }
	}

}
// PGADM_AddOrdItemLimit ���������� 
function AddOrdItemLimit_click() {
	//var src=window.event.srcElement;
	var src=document.getElementById("AddOrdItemLimit");
	var obj;
	if (src.checked) {
		obj=document.getElementById("AddOrdItemAmount");
		if (obj){
			obj.style.display = "inline" ;
			obj.disable=false;
			obj.checked=true;
		}
		obj=document.getElementById("cAddOrdItemAmount");
		if (obj){ obj.style.display = "inline" ; }
		
		websys_setfocus("AddOrdItemAmount");
	}
	else{
		obj=document.getElementById("AddOrdItemAmount");
		if (obj){
			obj.style.display="none";
			obj.value="";
		}
		obj=document.getElementById("cAddOrdItemAmount");
		if (obj){ obj.style.display = "none" ; }
			
	}
	
}
// PGADM_AddPhcItem �����ҩ 
function AddPhcItem_click() {
	//var src=window.event.srcElement;
	var src=document.getElementById("AddPhcItem");
	var obj;
	
	if (src.checked) {
		// PGADM_AddPhcItemLimit ��ҩ������� 
		obj=document.getElementById("AddPhcItemLimit");
		if (obj){
			//obj.style.display = "inline" ;
			obj.disabled=false;
			obj.checked=true;
		}
		obj=document.getElementById("cAddPhcItemLimit");
		//if (obj){ obj.style.display = "inline" ; }
		
		// PGADM_AddPhcItemAmount	�����ҩ���
		obj=document.getElementById("AddPhcItemAmount");
		if (obj){
			//obj.style.display="inline";
			obj.disabled=false;
			obj.value="";
		}
		obj=document.getElementById("cAddPhcItemAmount");
		//if (obj){ obj.style.display = "inline" ; }
		
		websys_setfocus("AddPhcItemAmount");
		
	}
	else{
		// PGADM_AddPhcItemLimit ��ҩ������� 
		obj=document.getElementById("AddPhcItemLimit");
		if (obj){
			obj.style.display = "none" ;
			obj.disabled=true;
			obj.checked=false;
		}
		obj=document.getElementById("cAddPhcItemLimit");
		if (obj){ obj.style.display = "none" ; }
		
		// PGADM_AddPhcItemAmount	�����ҩ���
		obj=document.getElementById("AddPhcItemAmount");
		if (obj){
			obj.style.display="none";
			obj.disabled=true;
			obj.value="";
		}
		obj=document.getElementById("cAddPhcItemAmount");
		if (obj){ obj.style.display = "none" ; }	
	}
	
}
//�޸�ԤԼ�������� Type "Item","Pre";ID  ԤԼID
function ModifyDelayDate()
{
	var Type="Item";
	var obj;
	obj=document.getElementById("PGADM_RowId");
	if (obj){ var ID=obj.value;}
	else{return false;}
	if (ID=="") return false;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreModifyDelayDate"
			+"&ID="+ID+"&Type="+Type;
	
	var wwidth=250;
	var wheight=150;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
}
//������˵�����Ϣ  Type "G","I";CRMADM  ԤԼADM;GIADM  �����ADM;RowID  ��˼�¼ID
function UpdatePreAudit()
{
	var Type="G";
	var obj;
	obj=document.getElementById("PGADM_RowId");
	if (obj){ var ID=obj.value;}
	else{return false;}
	if (ID=="") return false;
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreAudit.Edit"
	//		+"&CRMADM="+ID+"&ADMType="+Type+"&GIADM=";
	var lnk="dhcpepreaudit.csp?CRMADM="+ID+"&ADMType="+Type+"&GIADM="+"&RowID=";
	var wwidth=800;
	var wheight=500;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
}

// PGADM_AddPhcItemLimit ��ҩ������� 
function AddPhcItemLimit_click() {
	//alert("AddPhcItemLimit_click"+src.id)
	//var src=window.event.srcElement;
	var src=document.getElementById("AddPhcItemLimit");
	var obj;
	
	if (src.checked) {
		// PGADM_AddPhcItemAmount	�����ҩ���
		obj=document.getElementById("AddPhcItemAmount");
		if (obj){
			obj.disabled = false;
			obj.value="";
			obj.style.display = "inline" ;
		}
		obj=document.getElementById("cAddPhcItemAmount");
		if (obj){ obj.style.display = "inline" ; }
		websys_setfocus("AddPhcItemAmount");
	}
	else{
		// PGADM_AddPhcItemAmount	�����ҩ���
		obj=document.getElementById("AddPhcItemAmount");
		if (obj){
			obj.disabled = true;
			obj.value="";
			obj.style.display = "none" ;
		}
		obj=document.getElementById("cAddPhcItemAmount");
		if (obj){ obj.style.display = "none" ; }		
	}

}
function UpdateAsCharged()
{
	var Type="G";
	
	var obj;
	obj=document.getElementById("Status");
	//if ((obj)&&(obj.value!="PREREG")) {alert(t["Err 02"]); return;}
	obj=document.getElementById("PGADM_RowId");
	if (obj){ var ID=obj.value;}
	else{return false;}
	if (ID=="") return false;
	obj=document.getElementById("UpdateAsCharged");
	if (obj) var encmeth=obj.value;
	var Return=cspRunServerMethod(encmeth,ID,Type)
	if (Return==""){alert("Status Err");}
	else if (Return=="SQLErr"){alert("Update Err");}
	else{alert("Update Success!");}
}


function PatItemPrint() {
	obj=document.getElementById("PGADM_RowId");
	if (obj){ CRMId=obj.value; }
	if (CRMId=="") return;
	var DietFlag="TRUE"
	var Diet=document.getElementById('DietFlag');
	if (Diet) DietFlag=Diet.checked;
	
	var Ins=document.getElementById('GetAdmListBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,CRMId,"G");
	if (value=="") return;
	var AdmList=value.split("^");
	var i=AdmList.length;
	for (var iLLoop=0;iLLoop<i;iLLoop++)
	{
		var ID=AdmList[iLLoop]
		var Instring=ID+"^"+DietFlag+"^CRM";
		var Ins=document.getElementById('GetOEOrdItemBox');
		if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
		var value=cspRunServerMethod(encmeth,'','',Instring);
		Print(value);
	}
	
}
function PrintRisRequest() {
	obj=document.getElementById("PGADM_RowId");
	if (obj){ CRMId=obj.value; }
	if (CRMId=="") return;
	var DietFlag="TRUE"
	var Diet=document.getElementById('DietFlag');
	if (Diet) DietFlag=Diet.checked;
	
	var Ins=document.getElementById('GetAdmListBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,CRMId,"G");
	if (value=="") return;
	var AdmList=value.split("^");
	var i=AdmList.length;
	for (var iLLoop=0;iLLoop<i;iLLoop++)
	{
		var ID=AdmList[iLLoop]
		PrintRisRequestApp(ID,"","PreIADM")
	}
	
}
function PrintReportRJ()
{
	obj=document.getElementById("PGADM_RowId");
	if (obj){ CRMId=obj.value; }
	if (CRMId=="") return;
	var DietFlag="TRUE"
	var Diet=document.getElementById('DietFlag');
	if (Diet) DietFlag=Diet.checked;
	
	var Ins=document.getElementById('GetAdmListBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,CRMId,"G");
	if (value=="") return;
	var AdmList=value.split("^");
	var i=AdmList.length;
	for (var iLLoop=0;iLLoop<i;iLLoop++)
	{
		var ID=AdmList[iLLoop]
		PrintReportRJApp(ID,"PreIADM");
	}
	
}
function ContractFindAfter(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	//alert(Arr)
	var obj=document.getElementById("Contract");
	if (obj) obj.value=Arr[2];
	var obj=document.getElementById("ContractID");
	if (obj) obj.value=Arr[0];
}

function UpdatePreAudit()
{
	alert("���������������ԤԼ��ѯ����鿴");
	return false;
}

document.body.onload = BodyLoadHandler;