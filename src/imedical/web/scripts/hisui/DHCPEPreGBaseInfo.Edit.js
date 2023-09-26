//����	DHCPEPreGBaseInfo.Edit.js
//����	���������Ϣά��
//���	DHCPEPreGBaseInfo.Edit	
//����	2018.09.05
//������  xy

function BodyLoadHandler() {

	var obj;
	//����
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	
	//ɾ��
	obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click; }
	
	//���
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }
	
	//��λ����	
	obj=document.getElementById('Code');
	if (obj) { 
		obj.onkeydown = Code_keydown;
		obj.onchange=CodeChange;
	}
	
	
	obj=document.getElementById('PAPMINo');
	if (obj) { 
		obj.onchange = PAPMINoChange;
		obj.onkeydown= PAPMINo_keydown;
	}
	
	//��   ��	
	obj=document.getElementById('Desc');
	if (obj) { obj.onkeydown = nextfocus; }

	//��    ַ
	obj=document.getElementById('Address');
	if (obj) { obj.onkeydown = nextfocus; }
	
	//��������	PGBI_Postalcode	4
	obj=document.getElementById('Postalcode');
	if (obj) { obj.onkeydown = nextfocus; }
	
	//��ϵ��	PGBI_Linkman1	5
	obj=document.getElementById('Linkman1');
	if (obj) { obj.onkeydown = nextfocus; }
	
	//ҵ������	PGBI_Bank	6
	obj=document.getElementById('Bank');
	if (obj) { obj.onkeydown = nextfocus; }
	
	//��    ��	PGBI_Account	7
	obj=document.getElementById('Account');
	if (obj) { obj.onkeydown = nextfocus; }
	
	//��ϵ�绰1	PGBI_Tel1	8
	obj=document.getElementById('Tel1');
	if (obj) { obj.onkeydown = nextfocus; }
	
	//��ϵ�绰2	PGBI_Tel2	9
	obj=document.getElementById('Tel2');
	if (obj) { obj.onkeydown = nextfocus; }
	
	//�����ʼ�	PGBI_Email	10
	obj=document.getElementById('Email');
	if (obj) { obj.onkeydown = nextfocus; }
	
	//��ϵ��	PGBI_Linkman2	11
	obj=document.getElementById('Linkman2');
	if (obj) { obj.onkeydown = nextfocus; }
	
	//���� PGBI_FAX 12
	obj=document.getElementById('FAX');
	if (obj) { obj.onkeydown = nextfocus; }
	
	// ����� PGBI_PAPMINo 13
	//obj=document.getElementById('PAPMINo');
	//if (obj) { obj.onkeydown = nextfocus; }
	obj=document.getElementById("IBIUpdateModel");
	if (obj && "NoGen"==obj.value) {websys_setfocus("Desc");}

	//
	if (obj && "Gen"==obj.value) {
		websys_setfocus("PAPMINo");
	}
	obj=document.getElementById("CardNo");
	if (obj) {
		obj.onchange=CardNo_Change;
		//obj.onkeydown=CardNo_KeyDown;
		obj.onkeydown= CardNo_keydown;
	}
	
	//����
	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCard_Click;}

	
	iniForm();

	obj=document.getElementById("IBIUpdateModel");
	if (obj && "NoGen"==obj.value) {
		websys_setfocus("Desc");
		obj=document.getElementById("Code");
		if (obj) { var iCode=obj.value;}
		if(iCode!=""){
			obj=document.getElementById('PAPMINo');
			if(obj) websys_disable(obj);
			}
		}

	//�����ͳ�ʼ��
	initialReadCardButton()
}

function ReadCard_Click()
{
	var myrtn=DHCACC_GetAccInfo7(CardTypeCallBack);
	
}

function CardNo_keydown(e)
{
	var key=websys_getKey(e);
	if (13==key) {
		
		CardNo_Change();
	}
}

function CardNo_Change()
{
	 var obj=document.getElementById("CardNo"); 
	if (obj){ var myCardNo=obj.value;}
	//alert(myCardNo)
	if (myCardNo=="") return;
		var myrtn=DHCACC_GetAccInfo("",myCardNo,"","PatInfo",CardTypeCallBack);
		return false;
}

function CardTypeCallBack(myrtn){
   var myary=myrtn.split("^");
   var rtn=myary[0];
	switch (rtn){
		case "0": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#CardNo").focus().val(CardNo);
			$("#PAPMINo").val(PatientNo);
			PAPMINoChange();
			event.keyCode=13; 
			break;
		case "-200": //����Ч
			$.messager.alert("��ʾ","����Ч","info",function(){$("#CardNo").focus();});
			break;
		case "-201": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#CardNo").focus().val(CardNo);
			$("#PAPMINo").val(PatientNo);
			PAPMINoChange();
			event.keyCode=13;
			break;
		default:
	}
}

function iniForm(){
	var ID=""
	var obj;
	
	obj=document.getElementById("ID");
	if (obj && ""!=obj.value) { 
		ID="^"+obj.value;
		
		FindPatDetail(ID);
	}
	
	//����
	obj=document.getElementById("Update");
	//if (obj){ obj.style.display="inline"; }
	
	//ɾ��
	obj=document.getElementById("Delete");
	//if (obj){ obj.style.display="inline"; }
	
	//���
	obj=document.getElementById("Clear");
	//if (obj){ obj.style.display="inline"; }
	
	
	websys_setfocus('Code');
}
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

//��֤�Ƿ�Ϊ������
function IsFloat(Value) {
	
	var reg;
	
	if(""==trim(Value)) {
		//����Ϊ��
		return true; 
	}else { Value=Value.toString(); }
	
	reg=/^((-?|\+?)\d+)(\.\d+)?$/;

	var r=Value.match(reg);
	if (null==r) { return false; }
	else { return true; }
}

//������� ������Ӧ����Ϣ
function Code_keydown(e) {

	var key=websys_getKey(e);
	if (13==key) {
		CodeChange();
	}
}
//������� ������Ӧ����Ϣ
function CodeChange() {

		var obj;
		var iCode="";
		obj=document.getElementById('Code');
		if (obj && ""!=obj.value) { 
			iCode = obj.value;
		}
		else { return false; }		
		
		var ID="^"+iCode; //PGBI_RowId+"^"+PGBI_Code
		
		FindPatDetail(ID);

}
function FindPatDetail(ID){
	var Instring=ID;
	var Ins=document.getElementById('GetDetail');
	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
	var flag=cspRunServerMethod(encmeth,'SetPatient_Sel','',Instring);
	if (flag=='0') {

		//obj.className='clsInvalid';
		return websys_cancel();
	}
	websys_setfocus('Desc');
}
//������� ������Ӧ����Ϣ
function PAPMINo_keydown(e) {

	var key=websys_getKey(e);

	if (13==key) {
		PAPMINoChange();
	}
}
//������� ������Ӧ����Ϣ
function PAPMINoChange() {

	//var key=websys_getKey(e);

	//if (9==key || 13==key) {
		var obj;
		var iCode="";
		obj=document.getElementById('PAPMINo');
		if (obj && ""!=obj.value) { 
			iPAPMINo = obj.value;
		}
		else { return false; }		
		iPAPMINo = RegNoMask(iPAPMINo);
		var GetCodeMethodObj=document.getElementById("GetGCodeByADM")
		if (GetCodeMethodObj && ""!=GetCodeMethodObj.value) { 
			GetCodeMethod = GetCodeMethodObj.value;
		}
		else { return false; }
		var GCode=cspRunServerMethod(GetCodeMethod,iPAPMINo)	
		if (GCode==""){
		var ID="^"+iPAPMINo+"^"; //PGBI_RowId+"^"+PGBI_Code
		FindGBaseDetail(ID);}
		else{
		var ID="^"+GCode; //PGBI_RowId+"^"+PGBI_Code
		FindPatDetail(ID);}
//	}
}
function FindGBaseDetail(ID){
	var Instring=ID;

	var Ins=document.getElementById('GetHISInfo');
	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
	var flag=cspRunServerMethod(encmeth,'SetHISInfo_Sel','',Instring);
	if (flag=='0') {

		//obj.className='clsInvalid';
		return websys_cancel();
	}
	else if(flag==""){
		obj=document.getElementById("IBIUpdateModel");
	
	//
	if (obj && "FreeCreate"==obj.value) {}
	
	//
	if (obj && "FreeCreate"!=obj.value) {
		alert("�ǼǺŲ�����");
		Clear_click();
	}
		
	}
	websys_setfocus('Desc');
}
function SetHISInfo_Sel(value) {
	var obj;
	Clear_click();
	var Data=value.split("^");
	var iLLoop=0;

	iLLoop=iLLoop+1;
	//��    ��	PGBI_Desc	2
	obj=document.getElementById('PAPMINo');
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//��    ��	PGBI_Desc	2
	obj=document.getElementById('Desc');
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	//��    ��	PGBI_Desc	2
	obj=document.getElementById('CardNo');
	if (obj) { obj.value=Data[iLLoop]; }
}
//
function SetPatient_Sel(value) {
	var obj;

	Clear_click();

	var Data=value.split("^");
	var iLLoop=0;

	var iRowId=Data[iLLoop];	

	iLLoop=iLLoop+1;

	//��λ����	PGBI_Code	1
	obj=document.getElementById('Code');
	if (obj) { obj.value=Data[iLLoop]; }	

	if ("0"==iRowId) {	//δ�ҵ���¼
		//��    ��	PGBI_Desc	2
		obj=document.getElementById('Desc');
		if (obj) { obj.value="δ��"; }

		return false;
	}else{
		//0
		obj=document.getElementById('RowId');
		if (obj) { obj.value=iRowId; }		
	}
		
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
	//��ϵ��	PGBI_Linkman1	5
	obj=document.getElementById('Linkman1');
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
	
	iLLoop=iLLoop+1;
	//��ϵ��	PGBI_Linkman2	11
	obj=document.getElementById('Linkman2');
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//���� PGBI_FAX 12
	obj=document.getElementById('FAX');
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	// ����� PGBI_PAPMINo 13
	obj=document.getElementById('PAPMINo');
	if (obj) { obj.value=Data[iLLoop]; }
	
	// �ۿ���  14 wrz
	iLLoop=iLLoop+1;
	obj=document.getElementById('Rebate');
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	obj=document.getElementById('CardNo');
	if (obj) { obj.value=Data[iLLoop]; }
	return true;
}

function Update_click() {

	var iRowId="",iCardNo;
	var iCode="", iDesc="", iAddress="", iPostalcode="", iLinkman1="", 
		iBank="", iAccount="", iTel1="", iTel2="", iEmail=""
		iLinkman2="", iFAX="", iPAPMINo=""
		;
	var obj;
	
	//						1
	obj=document.getElementById("RowId");
	if (obj) { iRowId=obj.value; }

	//��λ����	PGBI_Code	2
	obj=document.getElementById("Code");
	if (obj) { iCode=obj.value; }

	//��    ��	PGBI_Desc	3
	obj=document.getElementById("Desc");
	if (obj) { iDesc=obj.value; }

	//��    ַ	PGBI_Address	4
	obj=document.getElementById("Address");
	if (obj) { iAddress=obj.value; }

	//��������	PGBI_Postalcode	5
	obj=document.getElementById("Postalcode");
	if (obj) { iPostalcode=obj.value; }
	if(!IsPostalcode(iPostalcode)){
		websys_setfocus(obj.id);
		return;
	}


	//��ϵ��	PGBI_Linkman	6
	obj=document.getElementById("Linkman1");
	if (obj) { iLinkman1=obj.value; }

	//ҵ������	PGBI_Bank	7
	obj=document.getElementById("Bank");
	if (obj) { iBank=obj.value; }

	//��    ��	PGBI_Account	8
	obj=document.getElementById("Account");
	if (obj) { iAccount=obj.value; }

	//��ϵ�绰1	PGBI_Tel1	9
	obj=document.getElementById("Tel1");
	if (obj) { iTel1=obj.value; }
	if(!CheckTelOrMobile(iTel1,"Tel1","��ϵ�绰1")){
		websys_setfocus(obj.id);
		return;
	}
   



	//��ϵ�绰2	PGBI_Tel2	10
	obj=document.getElementById("Tel2");
	if (obj) { iTel2=obj.value; }
	if(iTel2!=""){
	if(!CheckTelOrMobile(iTel2,"Tel2","��ϵ�绰2")){
		websys_setfocus(obj.id);
		return;
	}
	}



	//�����ʼ�	PGBI_Email	11
	obj=document.getElementById("Email");
	if (obj) { iEmail=obj.value; }
	if(!IsEMail(iEmail)){
		websys_setfocus(obj.id);
		return;
	}

	
	//��ϵ��	PGBI_Linkman2	12
	obj=document.getElementById('Linkman2');
	if (obj) { iLinkman2=obj.value; }
	
	//���� PGBI_FAX 13
	obj=document.getElementById('FAX');
	if (obj) { iFAX=obj.value; }
	
	// ����� PGBI_PAPMINo 13
	obj=document.getElementById('PAPMINo');
	if (obj) { iPAPMINo=obj.value; }
	
	//�ۿ��� wrz
	obj=document.getElementById('Rebate');
	if (obj) { iRebate=obj.value; }
	//�ۿ��� wrz
	obj=document.getElementById('CardNo');
	if (obj) { iCardNo=obj.value; }
	var iHospitalCode=""                      //add by zl20100228 start
	var HospitalCode=document.getElementById("HospitalCode");
	if (HospitalCode) iHospitalCode=HospitalCode.value;    //add by zl20100228 end
	var CardRelate=document.getElementById("CardRelate");
	if (CardRelate)
	{
		if ((CardRelate.value=="Yes")&&(iCardNo=="")&&(iHospitalCode!="SHDF"))
		{
			//alert("���Ų���Ϊ��")
			//websys_setfocus("BReadCard");
			//return;
		}
	}
	
	
	//����������֤
	if (""==iDesc) {
		$.messager.alert("��ʾ","�������Ʋ���Ϊ��","info");
		websys_setfocus('Desc');
		return false;
	} 
	obj=document.getElementById("IBIUpdateModel");
	
	
	if (obj && "NoGen"==obj.value) {}

	if (obj && "Gen"==obj.value) {
		// �ǼǺű���
		if (""==iPAPMINo) {
			obj=document.getElementById("PAPMINo")
			if (obj) {
				obj.value="";
				websys_setfocus(obj.id);
				obj.className='clsInvalid';
			}
			alert(t['01']);
			return false;
		} 
	}
	if (obj&&"FreeCreate"==obj.value)
	{
		if (""==iPAPMINo) {
			obj=document.getElementById("PAPMINo")
			if (obj) {
				obj.value="";
				websys_setfocus(obj.id);
				obj.className='clsInvalid';
			}
			alert(t['01']);
			return false;
		}
		if (isNaN(iPAPMINo)){
			obj=document.getElementById("PAPMINo")
			if (obj) {
				websys_setfocus(obj.id);
				obj.className='clsInvalid';
			}
			$.messager.alert("��ʾ","�ǼǺŲ�������","info");
			return false;
		}
	}
	if (""==iLinkman1) {
		$.messager.alert("��ʾ","��ϵ��1����Ϊ��","info");
		websys_setfocus('Linkman1');
		return false;
	}
 	if (""==iTel1) {
		$.messager.alert("��ʾ","��ϵ�绰1����Ϊ��","info");
		websys_setfocus('Tel1');
		return false;
	}
	
	var Instring= trim(iRowId)			//			1
				+"^"+trim(iCode)		//��λ����	2
				+"^"+trim(iDesc)		//��    ��	3
				+"^"+trim(iAddress)		//��    ַ	4
				+"^"+trim(iPostalcode)	//��������	5
				+"^"+trim(iLinkman1)	//��ϵ��	6
				+"^"+trim(iBank)		//ҵ������	7
				+"^"+trim(iAccount)		//��    ��	8
				+"^"+trim(iTel1)		//��ϵ�绰1	9
				+"^"+trim(iTel2)		//��ϵ�绰2	10
				+"^"+trim(iEmail)		//�����ʼ�	11
				+"^"+trim(iLinkman2)		//��ϵ��2	12
				+"^"+trim(iFAX)		//����	13
				+"^"+trim(iPAPMINo)		//�ǼǺ�	14
				+"^"+trim(iRebate)  //�ۿ���  15
				+"^"+trim(iCardNo)  //CardNo
				;
	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring)
	
	if (""==iCode) { //�������
		var Data=flag.split("^");
		flag=Data[0];
		iRowId=Data[1];
		iCode=Data[2];
		iRegNo=Data[3];
	}
	if (flag=='0') {
		//$.messager.alert("��ʾ",t['info 01']);
		alert("���³ɹ�")
		websys_showModal("close"); 
		return false

		obj=document.getElementById('RowId');
		if (obj) obj.value=iRowId;
		obj=document.getElementById('PAPMINo');
		if (obj) obj.value=iRegNo;
		obj=document.getElementById("Code");
		if (obj) obj.value=iCode;
		websys_setfocus('Name');
		
		if (opener) {
			// ���ø����� DHCPEPreGADM.Edit �ķ��غ���
			opener.NewWondowReturn(iDesc+"^"+iCode+"^"+iRowId);
			close(); 
		}
		
		
		var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEPreGBaseInfo.Edit"
				+"&ID="+iCode;
		location.href=lnk;

	}
	else if('Err 01'==flag){
		$.messager.alert("��ʾ",t['Err 01'],"info");
		return false;		
	}
	else if('Err 02'==flag){
		$.messager.alert("��ʾ",t['Err 02'],"info");
		return false;
	}else if('-119'==flag){
		$.messager.alert("��ʾ","�������Ѿ�����","info");
		return false;
	}
	else {
		$.messager.alert("��ʾ",t['02']+flag,"info");
		return false;
	}

	return true;
}

function Delete_click() {

	var iRowId="";

	var obj=document.getElementById("RowId");
	if (obj){ iRowId=obj.value; }

	if (""==iRowId)	{
		//alert("Please select the row to be deleted.");
		alert(t['03']);
		return false
	} 
	else{ 
		//if (confirm("Are you sure delete it?")){
		if (confirm(t['04'])) {
			var Ins=document.getElementById('DeleteBox');
			if (Ins) {var encmeth=Ins.value; } 
			else {var encmeth=''; };

			var flag=cspRunServerMethod(encmeth,'','',iRowId)
			if ('0'==flag) { New_click(); }
			else{
				//alert("Delete error.ErrNo="+flag)
				alert(t['05']+flag);
				
			}
		
		}
	}
}

function nextfocus(e) {
	var eSrc=window.event.srcElement;
	var key=websys_getKey(e);
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
}

//����������Ϣ
function Clear_click() {
	var obj;	
	    
	//			PGBI_RowId
	obj=document.getElementById("RowId");
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
	obj=document.getElementById('Linkman1');
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
	
	//��ϵ��	PGBI_Linkman2	11
	obj=document.getElementById('Linkman2');
	if (obj) { obj.value=''; }
	
	//���� PGBI_FAX 12
	obj=document.getElementById('FAX');
	if (obj) { obj.value=''; }
	
	// ����� PGBI_PAPMINo 13
	obj=document.getElementById('PAPMINo');
	if (obj) { obj.value=''; }
	
	// ����� PGBI_PAPMINo 13
	obj=document.getElementById('Rebate');
	if (obj) { obj.value=''; }
	// ����
	obj=document.getElementById('CardNo');
	if (obj) { obj.value=''; }
	websys_setfocus('PAPMINo');
}

//�������� 
function  IsEMail(elem){
if (elem=="") return true;
 var pattern=/^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
 if(pattern.test(elem)){
  return true;
 }else{
	 $.messager.alert("��ʾ","���������ʽ����ȷ","info");
  return false;
 }
}


//�绰����(�ƶ��������绰)
/* 
��;����������Ƿ���ȷ�ĵ绰���ֻ��� 
���룺 
value���ַ��� 
���أ� 
���ͨ����֤����true,���򷵻�false 
*/  
function IsTel(telephone){ 

	var teleReg1 = /^((0\d{2,3})-)(\d{7,8})$/;
	var teleReg2 = /^((0\d{2,3}))(\d{7,8})$/; 
	var mobileReg =/^1[3|4|5|6|7|8|9][0-9]{9}$/;
	if (!teleReg1.test(telephone)&& !teleReg2.test(telephone) && !mobileReg.test(telephone)){ 
		return false; 
	}else{ 
	
		return true; 
	} 
}
//���ܣ��˶��ֻ��ź͵绰�Ƿ���ȷ
//������telephone:�绰���� Name:Ԫ������ Type:Ԫ������
function CheckTelOrMobile(telephone,Name,Type){
	if (telephone.length==8) return true;
	if (IsTel(telephone)) return true;
	if (telephone.substring(0,1)==0){
		if (telephone.indexOf('-')>=0){
			$.messager.alert("��ʾ",Type+": �̶��绰���ȴ���,�̶��绰���ų���Ϊ��3����4��λ,�̶��绰���볤��Ϊ��7����8��λ,�������ӷ���-������,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("��ʾ",Type+": �̶��绰���ȴ���,�̶��绰���ų���Ϊ��3����4��λ,�̶��绰���볤��Ϊ��7����8��λ,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}else{
		if(telephone.length!=11){
			$.messager.alert("��ʾ",Type+": ��ϵ�绰�绰����ӦΪ��11��λ,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("��ʾ",Type+": �����ڸúŶε��ֻ���,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}
	return true;
}




//��������
function  IsPostalcode(elem){
if (elem=="") return true;
 var pattern=/[0-9]\d{5}(?!\d)/;
 if(pattern.test(elem)){
  return true;
 }else{
   $.messager.alert("��ʾ","���������ʽ����ȷ","info");
   //alert("���������ʽ����ȷ");
  return false;
 }
}
function RegNoMask(RegNo)
{
	if (RegNo=="") return RegNo;
	var RegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",RegNo);
	return RegNo;
}

document.body.onload = BodyLoadHandler;
