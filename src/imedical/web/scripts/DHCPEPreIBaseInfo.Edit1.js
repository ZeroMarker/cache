/// DHCPEPreIBaseInfo.Edit.js
///
/// ����ʱ��		2006.09.23
/// ������			xuwm
/// ��Ҫ����		�༭/�鿴�ͻ���Ϣ
/// 				OperType="Q"ʱ,�鿴�ͻ���Ϣ,����ʾ"����"�Ȱ�ť
/// ��Ӧ��		
/// ����޸�ʱ��	
/// ����޸���	
/// ���
var FIBIUpdateModel="";
function BodyLoadHandler() {

	var obj;

	obj=document.getElementById("IBIUpdateModel");
	if (obj) { FIBIUpdateModel=obj.value; }

	//����
	obj=document.getElementById("Update");
	if (obj) { obj.onclick=Update_click; }
	
	//�½�
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	
	//���
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }
	
	//�ǼǺ�
	obj=document.getElementById('PAPMINo');
	if (obj) {
		obj.onchange = RegNoChange;
		obj.onkeydown= RegNo_keydown;
		obj.disabled=false;
		if ('NoGen'==FIBIUpdateModel) {
			obj.disabled=true;
			
		}
		if ('Gen'==FIBIUpdateModel) {
			obj.disabled=false;
			websys_setfocus("PAPMINo");
		}
	}
	obj=document.getElementById("DOB");
	if (obj){obj.onchange=Dob_Change;}
	obj=document.getElementById("IDCard");
	if (obj){obj.onchange=ChangeIDCard;}
	iniForm();
	PAPMINoFind();
}
function PAPMINoFind()
{
	var obj=document.getElementById('PAPMINo');
	var PAPMINo="";
	if (obj) PAPMINo=obj.value;
	if (PAPMINo!=""){RegNoChange();}
}
function Dob_Change()
{
	//����
	obj=document.getElementById("DOB");
	if (obj){iAge=obj.value;}
	if (!(isNaN(iAge)))
	{
		iAge=parseInt(iAge)
		var D   =   new   Date();
	    var Year=D.getFullYear();
	    var Year=Year-iAge
	    obj.value="01/01/"+Year;

	}
}
function iniForm(){
	var ID=""
	var obj;

	// 
	obj=document.getElementById("OperType");
	if ( obj && "Q"==obj.value) {
	}else{
			//����
			obj=document.getElementById("Update");
			if (obj){ obj.style.display="inline"; }
	
			//����
			obj=document.getElementById("BFind");
			if (obj){ obj.style.display="inline"; }
	
			//���
			obj=document.getElementById("Clear");
			if (obj){ obj.style.display="inline"; }	
	}
	
	obj=document.getElementById('ID');
	if (obj && ""!=obj.value) {
		obj=document.getElementById('DataBox');
		if (obj && ""!=obj.value) {
			SetPatient(obj.value);
		}
	}

	
}
function trim(s) {
	if (""==s) { return "";}
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

function RegNo_keydown(e) {

	var key=websys_getKey(e);
	if (13==key) {
		RegNoChange();
	}
	
}
function RegNoChange() {

	//var key=websys_getKey(e);
	//if (9==key || 13==key) {
		var obj;
		var iPAPMINo="";
		obj=document.getElementById('PAPMINo');
		if (obj && ""!=obj.value) { 
			iPAPMINo = obj.value;
			iPAPMINo = RegNoMask(iPAPMINo)
		}
		else { return false; }	
		iPAPMINo="^"+iPAPMINo+"^";
		FindPatDetail(iPAPMINo);
	//}
	
}
//	ID ��ʽ RowId^PAPMINo^Name
function FindPatDetail(ID){
	var Instring=ID;
	
	var Ins=document.getElementById('GetDetail');
	if (Ins) { var encmeth=Ins.value} else {var encmeth=''};
	var flag=cspRunServerMethod(encmeth,'SetPatient','',Instring);
	
}

function SetPatient(value) {
	if ((""==value)&&(";"==value)) { return false; }
	var Data=value.split(";");
	Clear_click();
	
	
	PreData=Data[0];
	HISData=Data[1];
	
	if (""!=PreData) {
		value=PreData;
		var Data=value.split("^");
		var iRowId=Data[0];
		//	PIBI_RowId	0
		obj=document.getElementById("RowId");
		if (obj) { obj.value=iRowId; }
		
		obj=document.getElementById("IBIUpdateModel");
		if (obj && "NoGen"==obj.value) { websys_setfocus("Name"); }
		if (obj && "Gen"==obj.value) { websys_setfocus("PAPMINo"); }		

		SetPatient_Sel(value);
		return;
	}
	
	if (""!=HISData) {
		
		var value=HISData;
		var Data=value.split("^");
		//var iRowId=Data[0];
		//	PIBI_RowId	0
		obj=document.getElementById("RowId");
		if (obj) { obj.value=""; }
		
		SetPatient_Sel(value);
		obj=document.getElementById("IBIUpdateModel");
		if (obj && "NoGen"==obj.value) { websys_setfocus("Name"); }
		if (obj && "Gen"==obj.value) { websys_setfocus("PatType_DR_Name"); }		
	
		return;
	}

		//	PIBI_RowId	0
		obj=document.getElementById("RowId");
		if (obj) { obj.value=""; }	
		
		//	PIBI_Name	����	2
		obj=document.getElementById("Name");
		if (obj) { obj.value="δ�ҵ����߼�¼";	}
		
		
		obj=document.getElementById("IBIUpdateModel");
		if (obj && "NoGen"==obj.value) { websys_setfocus("PatType_DR_Name"); }
		if (obj && "Gen"==obj.value) { websys_setfocus("PAPMINo"); }
}
//
function SetPatient_Sel(value) {

	obj=document.getElementById("Update");
	if (obj){  obj.disabled=false; }
	IBISetPatient_Sel(value);
	return true;
}

function Update_click() {
	var Src=window.event.srcElement;
	if (Src.disabled) { return false; }
	Src.disabled=true;
	Update();
	Src.disabled=false;
}

function Update() {	

	var iRowId="",iHPNo="";
	var iPAPMINo="", iName="", iSex_DR="", iDOB="", iPatType_DR="", iTel1="", iTel2="", iMobilePhone="", iIDCard="", iVocation="", iPosition="", iCompany="", iPostalcode="", iAddress="", iNation="", iEmail="", iMarriedDR="", iBloodDR="", iUpdateDate="", iUpdateUserDR="";	  
	var obj;
	
	//	PIBI_RowId	21
	obj=document.getElementById("RowId");
	if (obj) { iRowId=obj.value; }
	
	//	PIBI_PAPMINo	�ǼǺ�	1	�����޸�
	obj=document.getElementById("PAPMINo");
	if (obj) { iPAPMINo=obj.value; }

	//	PIBI_Name	����	2
	obj=document.getElementById("Name");
	if (obj) { iName=obj.value; }
	
	//	PIBI_Sex_DR	�Ա�	3
	//obj=document.getElementById("Sex_DR");	//	�ı���ʱʹ��
	obj=document.getElementById("Sex_DR_Name");	//	�б��ʱʹ��
	if (obj) { iSex_DR=obj.value; }

	//	PIBI_IDCard	���֤��	9
	obj=document.getElementById("IDCard");
	if (obj) { iIDCard=obj.value; }
	iIDCard=trim(iIDCard)
	if (!isIdCardNo(iIDCard)) return;
	
	
	//	PIBI_DOB	����	4
	obj=document.getElementById("DOB");
	if (obj) { iDOB=obj.value; }
	//	PIBI_PatType_DR	��������	5
	//obj=document.getElementById("PatType_DR");	//	�ı���ʱʹ��
	obj=document.getElementById("PatType_DR_Name");		//	�б��ʱʹ��
	if (obj) { iPatType_DR=obj.value; }

	
	//	PIBI_Tel2	�绰����2	7
	obj=document.getElementById("Tel2");
	if (obj) { iTel2=obj.value; }

	//	PIBI_MobilePhone	�ƶ��绰	8
	obj=document.getElementById("MobilePhone");
	if (obj) { iMobilePhone=obj.value; }
	iMobilePhone=trim(iMobilePhone);
	if (!isMoveTel(iMobilePhone))
	{
		websys_setfocus(obj.id);
		return;
	}
	
	
	//	PIBI_Tel1	�绰����1	6
	obj=document.getElementById("Tel1");
	if (obj) { iTel1=obj.value; }

	
	//	PIBI_Vocation	ְҵ	10
	obj=document.getElementById("Vocation");
	if (obj) { iVocation=obj.value; }

	//	PIBI_Position	ְλ	11
	obj=document.getElementById("Position");
	if (obj) { iPosition=obj.value; }

	//	PIBI_Company	��˾	12
	obj=document.getElementById("Company");
	if (obj) { iCompany=obj.value; }

	//	PIBI_Postalcode	�ʱ�	13
	obj=document.getElementById("Postalcode");
	if (obj) { iPostalcode=obj.value; }

	//	PIBI_Address	��ϵ��ַ	14
	obj=document.getElementById("Address");
	if (obj) { iAddress=obj.value; }

	//	PIBI_Nation	����	15
	obj=document.getElementById("Nation");
	if (obj) { iNation=obj.value; }

	//	PIBI_Email	�����ʼ�	16
	obj=document.getElementById("Email");
	if (obj) { iEmail=obj.value; }

	//	PIBI_Married	����״��	17
	//obj=document.getElementById("Married_DR");	//	�ı���ʱʹ��
	obj=document.getElementById("Married_DR_Name");		//	�б��ʱʹ��
	if (obj) { iMarriedDR=obj.value; }
	
	//	PIBI_Blood	Ѫ��	18
	//obj=document.getElementById("Blood_DR");	//	�ı���ʱʹ��
	obj=document.getElementById("Blood_DR_Name");	//	�б��ʱʹ��
	if (obj && ""!=obj.value) { iBloodDR=obj.value; }

	//	PIBI_UpdateDate	����	19
	//obj=document.getElementById("UpdateDate");
	//if (obj) { iUpdateDate=obj.value; }
	iUpdateDate='';

	//	PIBI_UpdateUser_DR	������	20
	//obj=document.getElementById("UpdateUser_DR");
	//if (obj) { iUpdateUser_DR=obj.value; }
	iUpdateUserDR=session['LOGON.USERID'];

	// /////////////////////       ������֤          ////////////////////////////////////
	//�������̵Ĳ�ͬ?����ǼǺ�
	obj=document.getElementById("IBIUpdateModel");
	
	//
	if (obj && "NoGen"==obj.value) {}

	//
	if (obj && "Gen"==obj.value) {
		// �ǼǺű���
		if (""==iPAPMINo) {
			//alert("Please entry all information.");
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
	
	// �������ͱ���
	if (""==iPatType_DR) {
		//alert("Please entry all information.");
		
		obj=document.getElementById("PatType_DR_Name")
		if (obj) {
			obj.value="";
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert(t['01']);
		return false;
	}

	// ��������
	if (""==iName) {
		//alert("Please entry all information.");
		
		obj=document.getElementById("Name")
		if (obj) {
			obj.value="";
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert(t['01']);
		return false;
	}

	// �Ա����
	if (""==iSex_DR) {
		//alert("Please entry all information.");
		
		obj=document.getElementById("Sex_DR_Name")
		if (obj) {
			obj.value="";
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert(t['01']);
		return false;
	}
	// ���ձ���
	if (""==iDOB) {
		//alert("Please entry all information.");
		
		obj=document.getElementById("DOB")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert(t['01']);
		return false;
	}
	/*
	// ����״������
	if (""==iMarriedDR) {
		//alert("Please entry all information.");
		alert(t['01']);
		obj=document.getElementById("Married_DR_Name")
		if (obj) {
			obj.value="";
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		return false;
	}
	*/
	var HPNo=document.getElementById("HPNo");
	if (HPNo) iHPNo=HPNo.value;
	var Instring=	trim(iRowId)			//			1 
				+"^"+trim(iPAPMINo)			//�ǼǺ�		2
				+"^"+trim(iName)			//����		3
				+"^"+trim(iSex_DR)			//�Ա�		4
				+"^"+trim(iDOB)				//����		5
				+"^"+trim(iPatType_DR)		//��������	6
				+"^"+trim(iTel1)			//�绰����1	7
				+"^"+trim(iTel2)			//�绰����2	8
				+"^"+trim(iMobilePhone)		//�ƶ��绰	9
				+"^"+trim(iIDCard)			//���֤��	10
				+"^"+trim(iVocation)		//ְҵ		11
				+"^"+trim(iPosition)		//ְλ		12
				+"^"+trim(iCompany)			//��˾		13
				+"^"+trim(iPostalcode)		//�ʱ�		14
				+"^"+trim(iAddress)			//��ϵ��ַ	15
				+"^"+trim(iNation)			//����		16
				+"^"+trim(iEmail)			//�����ʼ�	17
				+"^"+trim(iMarriedDR)		//����״��	18
				+"^"+trim(iBloodDR)			//Ѫ��		19
				+"^"+trim(iUpdateDate)		//����		20
				+"^"+trim(iUpdateUserDR)	//������	21
				+"^"+trim(iHPNo)+";"+FIBIUpdateModel
				
				;
	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var flag=cspRunServerMethod(encmeth,'','',Instring)
	//if (""==iRowId) { //�������
		var Data=flag.split("^");
		flag=Data[0];
		iRowId=Data[1];
	//}
	
	if (flag=='0') {
		//alert("Update Success!");
		
		if (opener)
		{
			close();
			
			var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreIADM.Edit"
			+"&PAPMINo="+iPAPMINo
			;
			//opener.location.href=lnk;
			opener.RegNoOnChange();
			return;
		}
		alert(t['info 01']);
		Clear_click();
		return;}
		else {
		//alert("Insert error.ErrNo="+flag);
		alert(t['02']+flag);
		return false;
	}
}

function nextfocus() {
	var eSrc=window.event.srcElement;
	var key=websys_getKey(e);
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
}

//����������Ϣ
function Clear_click() {
	var obj;
	IBIClear_click();
	
	obj=document.getElementById("IBIUpdateModel");
	
	if (obj && "NoGen"==obj.value) {
		websys_setfocus("PatType_DR_Name");
		return;
	}
	
	if (obj && "Gen"==obj.value) {
		obj=document.getElementById("PAPMINo");
		if (obj) { obj.disabled=false; }
		websys_setfocus("PAPMINo");
		return;
	}	
	
}
function ChangeIDCard()
{
	var obj=document.getElementById("IDCard");
	var num=obj.value;
	isIdCardNo(num);
}
///�ж����֤��?�����������Ϊ���Զ���������
function isIdCardNo(num) {
	if (num=="") return true;
	var ShortNum=num.substr(1,num.length-2)
	if (isNaN(ShortNum))
	{
		alert("����Ĳ�������?");
		return false;
	}
	var len = num.length;
	var re;
	if (len == 15) re = new RegExp(/^(\d{6})()?(\d{2})(\d{2})(\d{2})(\d{3})$/);
	else if (len == 18) re = new RegExp(/^(\d{6})()?(\d{4})(\d{2})(\d{2})(\d{3})(\d)$/);
	else {alert("���֤�����������λ������?");
	websys_setfocus("IDCard");
	return false;}
	var a = num.match(re);
	if (a != null)
	{
		if (len==15)
		{
			var D = new Date("19"+a[3]+"/"+a[4]+"/"+a[5]);
			var B = D.getYear()==a[3]&&(D.getMonth()+1)==a[4]&&D.getDate()==a[5];
		}
		else
		{
			var D = new Date(a[3]+"/"+a[4]+"/"+a[5]);
			var B = D.getFullYear()==a[3]&&(D.getMonth()+1)==a[4]&&D.getDate()==a[5];
		}
		if (!B)
		{
			alert("��������֤�� "+ a[0] +" ��������ڲ���?");
			websys_setfocus("IDCard"); //DGV2DGV2
			return false;
		}
		var obj=document.getElementById("DOB");
		//if ((obj)&&(obj.value=="")) obj.value=a[5]+"/"+a[4]+"/"+a[3];
		if (obj) obj.value=a[5]+"/"+a[4]+"/"+a[3];
		if (len==15)
		{
			var SexFlag=num.substr(14,1);
		}
		else
		{
			var SexFlag=num.substr(16,1);
		}
		var SexNV=""
		var obj=document.getElementById("SexNV");
		if (obj) SexNV=obj.value;
		SexNV=SexNV.split("^");
		var obj=document.getElementById("Sex_DR_Name");
		if (SexFlag%2==1)
		{
			obj.value=SexNV[2];
		}
		else
		{
			obj.value=SexNV[3];
		}
	}
	return true;
}
///�ж��ƶ��绰
function isMoveTel(elem){
	if (elem=="") return true;
	var pattern=/^0{0,1}13|15[0-9]{9}$/;
	if(pattern.test(elem)){
		
	//	PIBI_Tel1	�绰����1	6
	obj=document.getElementById("Tel1");
	if (obj&&obj.value=="") { obj.value=elem; }	
		
	return true;
	}else{
  	alert("�ƶ��绰���벻��ȷ");
	return false;
 	}
}
//�̶��绰(С��ͨ????��ͥ�绰)
function isFixTel(elem){
 var pattern=/(^[0-9]{3,4}\-[0-9]{3,8}$)|(^[0-9]{3,8}$)|(^\([0-9]{3,4}\)[0-9]{3,8}$)/;
 if(pattern.test(elem)){
  return true;
 }else{
  //alert("�绰�����ʽ����ȷ");
  return false;
 }
}

//�绰����(���϶���)
function  isTel(elem){
 var pattern=/(^[0-9]{3,4}\-[0-9]{3,8}$)|(^[0-9]{3,8}$)|(^\([0-9]{3,4}\)[0-9]{3,8}$)|(^0{0,1}13[0-9]{9}$)/;
 if(pattern.test(elem)){
  return true;
 }else{
  //elert("�绰�����ʽ����ȷ");
  return false;
 }
}


document.body.onload = BodyLoadHandler;

