//DHCPEPreIBaseInfo.Common.hisui.js


function BodyIni() {
	var obj;


	/*/�������� ������
	obj=document.getElementById('PatType_DR_Name');
	if (obj) {
		obj.onkeydown = PatType_DR_Name_keydown;
		//obj.onblur = PatType_DR_Name_blur;
		//obj.onchange = PatType_DR_Name_change;
	}*/
	
	//����
	obj=document.getElementById('Name');
	if (obj) {
		obj.onkeydown = nextfocus;
		obj.onchange = Name_change;
	}

	//���֤��
	obj=document.getElementById('IDCard');
	if (obj) { obj.onkeydown = nextfocus; }

	/*/�Ա�
	obj=document.getElementById('Sex_DR_Name');
	if (obj) {
		obj.onkeydown = Sex_DR_Name_keydown;
		obj.onblur = Sex_DR_Name_blur;
		obj.onchange = Sex_DR_Name_change;
	}

	//����
	obj=document.getElementById('DOB');
	if (obj) {
		obj.onkeydown = DOB_keydown;
		//obj.onchange = DOB_change;
	}*/

	//����
	obj=document.getElementById('Nation');
	if (obj) { obj.onkeydown = nextfocus; }

	//����״��
	obj=document.getElementById('Married_DR_Name');
	if (obj) {
		//obj.onkeydown = Married_DR_Name_keydown;
		obj.onblur = Married_DR_Name_blur;
		obj.onchange = Married_DR_Name_change;
	}

	//Ѫ��
	obj=document.getElementById('Blood_DR_Name');
	if (obj) {
		obj.onkeydown = Blood_DR_Name_keydown;
		
	}

	//ְҵ
	obj=document.getElementById('Vocation');
	if (obj) { obj.onkeydown = nextfocus; }

	//�ƶ��绰
	obj=document.getElementById('MobilePhone');
	if (obj) { obj.onkeydown = nextfocus; }

	//�绰
	obj=document.getElementById('Tel1');
	if (obj) { obj.onkeydown = nextfocus; }

	//�绰 2
	obj=document.getElementById('Tel2');
	if (obj) { obj.onkeydown = nextfocus; }

	//�����ʼ�
	obj=document.getElementById('Email');
	if (obj) { obj.onkeydown = nextfocus; }

	//��ϵ��ַ
	obj=document.getElementById('Address');
	if (obj) { obj.onkeydown = nextfocus; }

	//�ʱ�
	obj=document.getElementById('Postalcode');
	if (obj) { obj.onkeydown = nextfocus; }

	//��˾
	obj=document.getElementById('Company');
	if (obj) { obj.onkeydown = nextfocus; }

	//ְλ
	obj=document.getElementById('Position');
	if (obj) { obj.onkeydown = nextfocus; }


}
BodyIni();

function IBISetPatient_Sel(value,DataType) {

	var obj;
	var Data=value.split("^");
	var iLLoop=0;

	//	PIBI_RowId	0
	//obj=document.getElementById("RowId");
	//if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	
	//	PIBI_PAPMINo	�ǼǺ�	1
	iLLoop=iLLoop+1;
	obj=document.getElementById("PAPMINo");
	if (obj && Data[iLLoop]) {
		 setValueById("PAPMINo",Data[iLLoop]);
		obj.disabled=true;
	}
	
	//	PIBI_Name	����	2
	iLLoop=iLLoop+1;
	obj=document.getElementById("Name");
	if (obj && Data[iLLoop]) { setValueById("Name",Data[iLLoop]); }
	
	//	PIBI_Sex_DR	�Ա�	3
	iLLoop=iLLoop+1;
	obj=document.getElementById("Sex_DR");
	if (obj && Data[iLLoop]) { 
		setValueById("Sex_DR",Data[iLLoop]);
	}

	obj=document.getElementById("Sex_DR_Name");
	if (obj && Data[iLLoop]) { 
		setValueById("Sex_DR_Name",Data[iLLoop]);
	}

	//	3.1
	iLLoop=iLLoop+1;
	
	
	//	PIBI_DOB	����	4
	iLLoop=iLLoop+1;
	obj=document.getElementById("DOB");
	if (obj && Data[iLLoop]) {
		/*
	if ((Data[iLLoop].split("/")[2].length)==2)             //add by zhouli ����������ʾ��ʽ�Լ����Ϊ20��ͷ������
    {var DOB="19"+Data[iLLoop].split("/")[2]+"-"+Data[iLLoop].split("/")[1]+"-"+Data[iLLoop].split("/")[0]} //add by zhouli
    else {var DOB=Data[iLLoop].split("/")[2]+"-"+Data[iLLoop].split("/")[1]+"-"+Data[iLLoop].split("/")[0]} //add by zhouli
	 obj.value=DOB; */
	 obj.value=Data[iLLoop];
	 }
	
	/*
	var Year
	if (Data[iLLoop]!="")
	{ 
		var Year=Data[iLLoop].split("/")[2];
		var D   =   new   Date();
		var Year1=D.getFullYear();
		if (Year.length==2) Year="19"+Year;
		Year=Year1-Year;
		obj=document.getElementById("Age");
		if (obj){
		obj.value=Year
		
	}
	}
	*/
	//	PIBI_PatType_DR	��������	5
	iLLoop=iLLoop+1;
	obj=document.getElementById("PatType_DR");
	if (obj && Data[iLLoop]) { setValueById("PatType_DR",Data[iLLoop]); }
	
	obj=document.getElementById("PatType_DR_Name");
	if (obj && Data[iLLoop]) { setValueById("PatType_DR_Name",Data[iLLoop]); }	
	
	//	��������	5.1
	iLLoop=iLLoop+1;
	
	
	// PIBI_Tel1 �绰����1 6
	iLLoop=iLLoop+1;
	obj=document.getElementById("Tel1");
	if (obj && Data[iLLoop]) { setValueById("Tel1",Data[iLLoop]); }
	
	// PIBI_Tel2 �绰����2 7
	iLLoop=iLLoop+1;
	obj=document.getElementById("Tel2");
	if (obj && Data[iLLoop]) { setValueById("Tel2",Data[iLLoop]); }

   // PIBI_MobilePhone �ƶ��绰 8
	iLLoop=iLLoop+1;
	obj=document.getElementById("MobilePhone");
	if (obj && Data[iLLoop]) {  setValueById("MobilePhone",Data[iLLoop]); }
	

	//	PIBI_IDCard	���֤��	9
	iLLoop=iLLoop+1;
	obj=document.getElementById("IDCard");
	if (obj && Data[iLLoop]) {  setValueById("IDCard",Data[iLLoop]); }
	
	
	//	PIBI_Vocation	ְҵ	10
	iLLoop=iLLoop+1;
	obj=document.getElementById("Vocation");
	if (obj && Data[iLLoop]) { setValueById("Vocation",Data[iLLoop]); }
	
	
	//	PIBI_Position	ְλ	11
	iLLoop=iLLoop+1;
	obj=document.getElementById("Position");
	if (obj && Data[iLLoop]) { setValueById("Position",Data[iLLoop]); }
	
	
	//	PIBI_Company	��˾	12
	iLLoop=iLLoop+1;
	obj=document.getElementById("Company");
	if (obj && Data[iLLoop]) {  setValueById("Company",Data[iLLoop]); }
	
	
	//	PIBI_Postalcode	�ʱ�	13
	iLLoop=iLLoop+1;
	obj=document.getElementById("Postalcode");
	if (obj && Data[iLLoop]) { setValueById("Postalcode",Data[iLLoop]); }
	
	
	//	PIBI_Address	��ϵ��ַ	14
	iLLoop=iLLoop+1;
	obj=document.getElementById("Address");
	if (obj && Data[iLLoop]) { setValueById("Address",Data[iLLoop]); }
	
	
	//	PIBI_Nation	����	15
	iLLoop=iLLoop+1;
	obj=document.getElementById("CTNationDR");
	if (obj && Data[iLLoop]) { setValueById("CTNationDR",Data[iLLoop]); }
	//obj=document.getElementById("NationDesc");
	//if (obj && Data[iLLoop]) { setValueById("NationDesc",Data[iLLoop]); }
	
	
	//	PIBI_Email	�����ʼ�	16
	iLLoop=iLLoop+1;
	obj=document.getElementById("Email");
	if (obj && Data[iLLoop]) { setValueById("Email",Data[iLLoop]); }
		
	//	PIBI_Married	����״��	17
	iLLoop=iLLoop+1;
	obj=document.getElementById("Married_DR");
	if (obj && Data[iLLoop]) {  setValueById("Married_DR",Data[iLLoop]); }

	obj=document.getElementById("Married_DR_Name");
	if (obj && Data[iLLoop]) {  setValueById("Married_DR_Name",Data[iLLoop]); }	
	
	//	17.1
	iLLoop=iLLoop+1;
		
	//	PIBI_Blood	Ѫ��	18
	iLLoop=iLLoop+1;
	obj=document.getElementById("Blood_DR");
	if (obj && Data[iLLoop]) { setValueById("Blood_DR",Data[iLLoop]); }
	
	obj=document.getElementById("Blood_DR_Name");
	if (obj && Data[iLLoop]) { setValueById("Blood_DR_Name",Data[iLLoop]); }	
	
	//	18.1
	iLLoop=iLLoop+1;	
	
	//	PIBI_UpdateDate	����	19
	iLLoop=iLLoop+1;
	obj=document.getElementById("UpdateDate");
	if (obj && Data[iLLoop]) { setValueById("UpdateDate",Data[iLLoop]); }
	
	//	PIBI_UpdateUser_DR	������	20
	iLLoop=iLLoop+1;
	obj=document.getElementById("UpdateUser_DR");
	if (obj && Data[iLLoop]) { setValueById("UpdateUser_DR",Data[iLLoop]);}
	
	//	20.1
	iLLoop=iLLoop+1;
	obj=document.getElementById("UpdateUser_DR_Name");
	if (obj && Data[iLLoop]) { setValueById("UpdateUser_DR_Name",Data[iLLoop]); }
	//����
	iLLoop=iLLoop+1;
	obj=document.getElementById("HPNo");
	if (obj && Data[iLLoop]) { setValueById("HPNo",Data[iLLoop]); }
	//����
	iLLoop=iLLoop+1;
	obj=document.getElementById("Age");  //SexNV.split("^")
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop].split("Y")[0]; }
	//��ͬ��λ
	iLLoop=iLLoop+1;
	obj=document.getElementById("hcpdr");
	if (obj && Data[iLLoop]) { setValueById("hcpdr",Data[iLLoop]); }
	
	//��������
	iLLoop=iLLoop+1;
	obj=document.getElementById("HCRDR");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	
	//��������
	iLLoop=iLLoop+1;
	obj=document.getElementById("HCADR");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	
	//��������
	iLLoop=iLLoop+1;
	obj=document.getElementById("HCADesc");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	//CardNo
	iLLoop=iLLoop+1;
	obj=document.getElementById("CardNo");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	//VIP
	iLLoop=iLLoop+1;
	obj=document.getElementById("VIPLevel");
	if (obj && Data[iLLoop]) { setValueById("VIPLevel",Data[iLLoop]); }
	
		
	//ҽ����
	iLLoop=iLLoop+1;
	//iLLoop=iLLoop+1;
	obj=document.getElementById("MedicareCode");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	
	//֤������
	//iLLoop=iLLoop+1;
	iLLoop=iLLoop+1;
	obj=document.getElementById("PAPMICardType_DR_Name");
	if (obj && Data[iLLoop]) { 
		//setValueById("PAPMICardType_DR_Name",Data[iLLoop]);
		$("#PAPMICardType_DR_Name").combobox('setValue',Data[iLLoop])
		}

	iLLoop=iLLoop+1;
	iLLoop=iLLoop+1;
	
	obj=document.getElementById("CTNationDR");
	if (obj && Data[iLLoop]) { setValueById("CTNationDR",Data[iLLoop]); }

    //�������ͻ�����
    iLLoop=iLLoop+1;
    $("#SpecialType").combobox('setValue',Data[iLLoop]);

	return true;
	
}


//����������Ϣ
function IBIClearNew_click() {
	var obj;	
	    
	//	PIBI_RowId
	setValueById("RowId","");
	
	//	PIBI_PAPMINo	�ǼǺ�
	setValueById("PAPMINo","");
	
	//	PIBI_Name	����
	setValueById("Name","");
	
	//	PIBI_Sex_DR	�Ա�
	setValueById("Sex_DR","");
	setValueById("Sex_DR_Name","");

	//	PIBI_DOB	����
	setValueById("DOB","");

	//	PIBI_PatType_DR	��������
	setValueById("PatType_DR","");
	setValueById("PatType_DR_Name","");

	//	PIBI_Tel1	�绰����1
	setValueById("Tel1","");

	//	PIBI_Tel2	�绰����2
	setValueById("Tel2","");

	//	PIBI_MobilePhone	�ƶ��绰
	setValueById("MobilePhone","");

	//	PIBI_IDCard	���֤��
	setValueById("IDCard","");

	//	PIBI_Vocation	ְҵ
	setValueById("Vocation","");

	//	PIBI_Position	ְλ
	setValueById("Position","");

	//	PIBI_Company	��˾
	setValueById("Company","");

	//	PIBI_Postalcode	�ʱ�
	setValueById("Postalcode","");

	//	PIBI_Address	��ϵ��ַ
	setValueById("Address","");

	//	PIBI_Nation	����
	//setValueById("NationDesc","");
    setValueById("CTNationDR","");
    
	//	PIBI_Email	�����ʼ�
	setValueById("Email","");

	//	PIBI_Married	����״��
	setValueById("Married_DR","");
	setValueById("Married_DR_Name","");
		
	//	PIBI_Blood	Ѫ��
	setValueById("Blood_DR","");
	setValueById("Blood_DR_Name","");
	
	//	PIBI_UpdateDate	����
	setValueById("UpdateDate","");

	//	PIBI_UpdateUser_DR	������
	setValueById("UpdateUser_DR","");
	setValueById("UpdateUser_DR_Name","");
	
	setValueById("HPNo","");
	setValueById("Age","");
	setValueById("hcpdr","");
	setValueById("HCRDR","");
	setValueById("HCADR","");
	setValueById("HCADesc","");
	
	setValueById("MedicareCode","");
	setValueById("GroupDesc","");
	setValueById("GroupDR","");
	setValueById("TeamDesc","");
	setValueById("TeamDR","");

	//֤������
	setValueById("PAPMICardType_DR_Name","");
	
	//vip�ȼ�
	setValueById("VIPLevel","");
	SetDefault();
	return true;
}

//����������Ϣ
function IBIClear_click() {
	setValueById("CardNo","");	
	 IBIClearNew_click (); 
	return true;
	
}

function nextfocus() {
	var eSrc=window.event.srcElement;
	var key=websys_getKey(e);
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
}

// ************************************************************************************
// �Ա�
function Sex_DR_Name_blur() {
	obj=document.getElementById("Sex_DR");
	if (obj && ""==obj.value) {
		obj=document.getElementById("Sex_DR_Name");
		//obj.className='clsInvalid';
		//websys_setfocus(obj.id);
	}
}

function Sex_DR_Name_change() {
	var src=window.event.srcElement;
	src.classname='';
}

function Sex_DR_Name_keydown(e) {
	var key=websys_getKey(e);
	var eSrc=window.event;
	
	var obj=document.getElementById("Sex_DR_Name");
	if (obj) { obj.className=''; }
	
	if ( (9==key) || (13==key) ) {
		// ��ʾ�б�
		obj=document.getElementById("Sex_DR_Name");
		if (obj && (("��ȷ��"==obj.value)||(""==obj.value))) {
			eSrc.keyCode=117;
			Sex_DR_Name_lookuphandler(117); 
		}
		else { websys_nexttab(eSrc.srcElement.tabIndex); }
	}else{
		obj=document.getElementById("Sex_DR");
		if (obj) { obj.value=''; }
	}
}
function GetSex(value) {
	var aiList=value.split("^");
	alert(aiList)
	if (""==value){ return false; }
	else{
		var obj;
	
		obj=document.getElementById("Sex_DR_Name");
		if (obj) {
			//obj.value=aiList[0];
			obj.value=aiList[0];
			websys_nexttab(obj.tabIndex);
		}

		obj=document.getElementById("Sex_DR");
		if (obj) { obj.value=aiList[2]; }
		
	}
}



//��������
function PatType_DR_Name_blur() {
	obj=document.getElementById("PatType_DR");
	if (obj && ""==obj.value) {
		obj=document.getElementById("PatType_DR_Name");
		obj.value='';
		//obj.className='clsInvalid';
		//websys_setfocus(obj.id);
	}
}
function PatType_DR_Name_change() {
	var src=window.event.srcElement;
	src.classname='';
}
function PatType_DR_Name_keydown(e) {
	var key=websys_getKey(e);
	var eSrc=window.event;
	
	var obj=document.getElementById("PatType_DR_Name");
	if (obj) { obj.className=''; }
	// ��ʾ�б�
	if ( (9==key) || (13==key) ) {
		obj=document.getElementById("PatType_DR");
		if (obj && ""==obj.value) {
			eSrc.keyCode=117;
			PatType_DR_Name_lookuphandler(117);
		}
		else { websys_nexttab(eSrc.srcElement.tabIndex); }
	}else{
		obj=document.getElementById("PatType_DR");
		if (obj) { obj.value=''; }
	}
}
function GetPatType(value) {
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;

		obj=document.getElementById("PatType_DR_Name");
		if (obj) {
			//obj.value=aiList[0];
			obj.value=aiList[2];
			websys_nexttab(obj.tabIndex);
		}


		obj=document.getElementById("PatType_DR");
		if (obj) { obj.value=aiList[2]; }
		
	}
}




//����״��
function Married_DR_Name_blur() {
	obj=document.getElementById("Married_DR");
	if (obj && ""==obj.value) {
		obj=document.getElementById("Married_DR_Name");
		//obj.className='clsInvalid';
		//websys_setfocus(obj.id);
	}
}
function Married_DR_Name_change() {
	var src=window.event.srcElement;
	src.classname='';
}
function Married_DR_Name_keydown(e) {
	var obj=document.getElementById("Married_DR_Name");
	if (obj) { obj.className=''; }
	
	var key=websys_getKey(e);
	var eSrc=window.event;
	
	// ��ʾ�б�
	if ( (9==key) || (13==key) ) {
		obj=document.getElementById("Married_DR");
		if (obj && ""==obj.value) {
			eSrc.keyCode=117;
			Married_DR_Name_lookuphandler(117);
			
		}
		else { websys_nexttab(eSrc.srcElement.tabIndex); }
	}else{
		obj=document.getElementById("Married_DR");
		if (obj) { obj.value=''; }
	}
	
}
function GetMarital(value) {
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;

		obj=document.getElementById("Married_DR_Name");
		if (obj) {
			//obj.value=aiList[0];
			obj.value=aiList[2];
			websys_nexttab(obj.tabIndex);
		}

		obj=document.getElementById("Married_DR");
		if (obj) { obj.value=aiList[2]; }
	}
}

function Name_change() {
	var src=window.event.srcElement;
	src.classname='';
}

// ����
function DOB_keydown(e) {
	var key=websys_getKey(e);
	var eSrc=window.event;
	
	if ( (9==key) || (13==key) ) {
		obj=document.getElementById("DOB");
		// ��ʾ�б�
		if (obj && (("12/08/2005"==obj.value)||(""==obj.value))) {
			eSrc.keyCode=117;
			DOB_lookuphandler(117);
		}
		else { websys_nexttab(eSrc.srcElement.tabIndex); }
	}
}
function DOB_change() {

}



//Ѫ��
function Blood_DR_Name_keydown(e) {
	var key=websys_getKey(e);
	var eSrc=window.event;
	
	if ( (9==key) || (13==key) ) {
		//eSrc.keyCode=117;
		//Blood_DR_Name_lookuphandler(117);
		websys_nexttab(eSrc.srcElement.tabIndex);
	}
}
function GetBloodType(value) {
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;

		obj=document.getElementById("Blood_DR_Name");
		if (obj) {
			//obj.value=aiList[0];
			obj.value=aiList[2];
			websys_nexttab(obj.tabIndex);
		}


		obj=document.getElementById("Blood_DR");
		if (obj) { obj.value=aiList[2]; }
	}
}


