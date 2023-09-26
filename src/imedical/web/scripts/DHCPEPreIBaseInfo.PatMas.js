/// DHCPEPreIBaseInfo.PatMas.js
/// ����ʱ��		2006.09.23
/// ������		xuwm
/// ��Ҫ����		Ϊ������Һż���?��ƴ����?
/// ��Ӧ��		
/// ����޸�ʱ��	
/// ����޸���	
/// ���
var FRegNo="";
function BodyLoadHandler() {

	var obj;
	
	//����
	obj=document.getElementById("Update");
	if (obj){
		obj.onclick=Update_click;
		obj.disabled=true;
	}
	
	//���
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }
	
	//�ǼǺ�
	obj=document.getElementById('PAPMINo');
	if (obj) {
		obj.onkeydown = RegNo_keydown;
		//obj.disabled=true;
	}

	//�������� ������
	obj=document.getElementById('PatType_DR_Name');
	if (obj) {
		obj.onkeydown = PatType_DR_Name_keydown;
		obj.onblur = PatType_DR_Name_blur;
	}
	
	//����
	obj=document.getElementById('Name');
	if (obj) { obj.onkeydown = nextfocus; }

	//���֤��
	obj=document.getElementById('IDCard');
	if (obj) { obj.onkeydown = nextfocus; }

	//�Ա�
	obj=document.getElementById('Sex_DR_Name');
	if (obj) {
		obj.onkeydown = Sex_DR_Name_keydown;
		obj.onblur = Sex_DR_Name_blur;
	}

	//����
	obj=document.getElementById('DOB');
	if (obj) { obj.onkeydown = DOB_keydown; }

	//����
	obj=document.getElementById('Nation');
	if (obj) { obj.onkeydown = nextfocus; }

	//����״��
	obj=document.getElementById('Married_DR_Name');
	if (obj) {
		obj.onkeydown = Married_DR_Name_keydown;
		obj.onblur = Married_DR_Name_blur;
	}

	//Ѫ��
	obj=document.getElementById('Blood_DR_Name');
	if (obj) { obj.onkeydown = nextfocus; }

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


	iniForm();

}

function iniForm(){
	var ID=""
	var obj;
	
	obj=document.getElementById("OperType");
	if (obj && "Q"==obj.value) {
	
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
		ID=obj.value; 
		ID=ID+"^";//PGBI_RowId_"^"_PGBI_Code
		FindPatDetail(ID);
	}else{ websys_setfocus('PAPMINo'); }
	

	
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
	if (9==key || 13==key) {
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
	}
	
}

//	ID ��ʽ RowId^PAPMINo^Name
function FindPatDetail(ID){
	var Instring=ID;
	
	var Ins=document.getElementById('GetDetail');
	if (Ins) { var encmeth=Ins.value} else {var encmeth=''};
	var flag=cspRunServerMethod(encmeth,'SetPatient','',Instring);

}
function SetPatient(value) {
	var values=value.split(";");

	PreIBaseInfodata=values[0];
	PatMasInfodata=values[1];

	Clear_click();

	var Data=PreIBaseInfodata.split("^");
	iRowId=Data[0];
	//	PIBI_RowId	0
	obj=document.getElementById("RowId");
	if (obj) { obj.value=iRowId; }	

	var Data=PatMasInfodata.split("^");
	iRowId=Data[0];
	//	
	obj=document.getElementById("HRowId");
	if (obj) { obj.value=iRowId; }
	
	if (""==PreIBaseInfodata) { SetPatient_Sel(PatMasInfodata);	}
	else { SetPatient_Sel(PreIBaseInfodata); }

}
//
function SetPatient_Sel(value) {

	var obj;
	var Data=value.split("^");
	var iLLoop=0;

	//iRowId=Data[iLLoop];
	iLLoop=iLLoop+1;
	
	obj=document.getElementById("Update");
	if (obj){  obj.disabled=false; }	
	
	//	PIBI_PAPMINo	�ǼǺ�	1
	obj=document.getElementById("PAPMINo");
	if (obj) {
		obj.value=Data[iLLoop];
		obj.disabled=true;
	}
	
	iLLoop=iLLoop+1;
	//	PIBI_Name	����	2
	obj=document.getElementById("Name");
	if (obj) {
		obj.value=Data[iLLoop];
		if ('δ��'==obj.value) { websys_setfocus('PatType_DR_Name'); }
		else { websys_setfocus("Name"); }
	}
	
	iLLoop=iLLoop+1;
	//	PIBI_Sex_DR	�Ա�	3
	obj=document.getElementById("Sex_DR");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	3.1
	obj=document.getElementById("Sex_DR_Name");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_DOB	����	4
	obj=document.getElementById("DOB");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_PatType_DR	��������	5
	obj=document.getElementById("PatType_DR");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	��������	5.1
	obj=document.getElementById("PatType_DR_Name");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_Tel1	�绰����1	6
	obj=document.getElementById("Tel1");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_Tel2	�绰����2	7
	obj=document.getElementById("Tel2");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_MobilePhone	�ƶ��绰	8
	obj=document.getElementById("MobilePhone");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_IDCard	���֤��	9
	obj=document.getElementById("IDCard");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_Vocation	ְҵ	10
	obj=document.getElementById("Vocation");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_Position	ְλ	11
	obj=document.getElementById("Position");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_Company	��˾	12
	obj=document.getElementById("Company");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_Postalcode	�ʱ�	13
	obj=document.getElementById("Postalcode");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_Address	��ϵ��ַ	14
	obj=document.getElementById("Address");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_Nation	����	15
	obj=document.getElementById("Nation");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_Email	�����ʼ�	16
	obj=document.getElementById("Email");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_Married	����״��	17
	obj=document.getElementById("Married_DR");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	17.1
	obj=document.getElementById("Married_DR_Name");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;	
	//	PIBI_Blood	Ѫ��	18
	obj=document.getElementById("Blood_DR");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	18.1
	obj=document.getElementById("Blood_DR_Name");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;	
	//	PIBI_UpdateDate	����	19
	obj=document.getElementById("UpdateDate");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_UpdateUser_DR	������	20
	obj=document.getElementById("UpdateUser_DR");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	20.1
	obj=document.getElementById("UpdateUser_DR_Name");
	if (obj) { obj.value=Data[iLLoop]; }
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
	var iRowId="",iHRowId="";
	var iPAPMINo="", iName="", iSex_DR="", iDOB="", iPatType_DR="", iTel1="", iTel2="", iMobilePhone="", iIDCard="", iVocation="", iPosition="", iCompany="", iPostalcode="", iAddress="", iNation="", iEmail="", iMarriedDR="", iBloodDR="", iUpdateDate="", iUpdateUserDR="";	  
	var obj;
	
	//	PAPMI_RowId	
	obj=document.getElementById("HRowId");
	if (obj) { iHRowId=obj.value; }
		
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
	obj=document.getElementById("Sex_DR");
	if (obj) { iSex_DR=obj.value; }

	//	PIBI_DOB	����	4
	obj=document.getElementById("DOB");
	if (obj) { iDOB=obj.value; }

	//	PIBI_PatType_DR	��������	5
	obj=document.getElementById("PatType_DR");
	if (obj) { iPatType_DR=obj.value; }

	//	PIBI_Tel1	�绰����1	6
	obj=document.getElementById("Tel1");
	if (obj) { iTel1=obj.value; }

	//	PIBI_Tel2	�绰����2	7
	obj=document.getElementById("Tel2");
	if (obj) { iTel2=obj.value; }

	//	PIBI_MobilePhone	�ƶ��绰	8
	obj=document.getElementById("MobilePhone");
	if (obj) { iMobilePhone=obj.value; }

	//	PIBI_IDCard	���֤��	9
	obj=document.getElementById("IDCard");
	if (obj) { iIDCard=obj.value; }

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
	obj=document.getElementById("Married_DR");
	if (obj) { iMarriedDR=obj.value; }
	
	//	PIBI_Blood	Ѫ��	18
	obj=document.getElementById("Blood_DR");
	if (obj && ""!=obj.value) {
		iBloodDR=obj.value;
		
	}else{
		obj=document.getElementById("Blood_DR_Name");
		if (obj) { obj.value=""; }
	}

	//	PIBI_UpdateDate	����	19
	//obj=document.getElementById("UpdateDate");
	//if (obj) { iUpdateDate=obj.value; }
	iUpdateDate='';

	//	PIBI_UpdateUser_DR	������	20
	//obj=document.getElementById("UpdateUser_DR");
	//if (obj) { iUpdateUser_DR=obj.value; }
	iUpdateUserDR=session['LOGON.USERID'];

	// ������֤
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

	var Instring=	 trim(iPAPMINo)			//�ǼǺ�		1
				+"^"+trim(iName)			//����		2
				+"^"+trim(iSex_DR)			//�Ա�		3
				+"^"+trim(iDOB)				//����		4
				+"^"+trim(iPatType_DR)		//��������	5
				+"^"+trim(iTel1)			//�绰����1	6
				+"^"+trim(iTel2)			//�绰����2	7
				+"^"+trim(iMobilePhone)		//�ƶ��绰	8
				+"^"+trim(iIDCard)			//���֤��	9
				+"^"+trim(iVocation)		//ְҵ		10
				+"^"+trim(iPosition)		//ְλ		11
				+"^"+trim(iCompany)			//��˾		12
				+"^"+trim(iPostalcode)		//�ʱ�		13
				+"^"+trim(iAddress)			//��ϵ��ַ	14
				+"^"+trim(iNation)			//����		15
				+"^"+trim(iEmail)			//�����ʼ�	16
				+"^"+trim(iMarriedDR)		//����״��	17
				+"^"+trim(iBloodDR)			//Ѫ��		18
				+"^"+trim(iUpdateDate)		//����		19
				+"^"+trim(iUpdateUserDR)	//������		20
				+"^"+trim(iRowId)			//			21
				+";"+trim(iHRowId)			//			21
				;

	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var flag=cspRunServerMethod(encmeth,'','',Instring)

	if (""==iRowId) { //�������
		var Data=flag.split("^");
		flag=Data[0];
		iRowId=Data[1];
	}
	
	if (flag=='0') {
		//alert("Update Success!");
		alert(t['info 01']);
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreIBaseInfo.PatMas"
			+"&ID="+iRowId+"^^";
		location.href=lnk;		
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
	
	obj=document.getElementById("Update");
	if (obj) { obj.disabled=true; }
	
	//	PIBI_RowId
	obj=document.getElementById("HRowId");
	if (obj) { obj.value=""; }
		
	//	PIBI_RowId
	obj=document.getElementById("RowId");
	if (obj) { obj.value=""; }

	//	PIBI_PAPMINo	�ǼǺ�
	obj=document.getElementById("PAPMINo");
	if (obj) {
		obj.value="";
		obj.disabled=false;
		websys_setfocus(obj.id);
	}

	//	PIBI_Name	����
	obj=document.getElementById("Name");
	if (obj) { obj.value=""; }

	//	PIBI_Sex_DR	�Ա�
	obj=document.getElementById("Sex_DR");
	if (obj) { obj.value=""; }

	obj=document.getElementById("Sex_DR_Name");
	if (obj) { obj.value=""; }

	//	PIBI_DOB	����
	obj=document.getElementById("DOB");
	if (obj) { obj.value=""; }

	//	PIBI_PatType_DR	��������
	obj=document.getElementById("PatType_DR");
	if (obj) { obj.value=""; }

	obj=document.getElementById("PatType_DR_Name");
	if (obj) { obj.value=""; }

	//	PIBI_Tel1	�绰����1
	obj=document.getElementById("Tel1");
	if (obj) { obj.value=""; }

	//	PIBI_Tel2	�绰����2
	obj=document.getElementById("Tel2");
	if (obj) { obj.value=""; }

	//	PIBI_MobilePhone	�ƶ��绰
	obj=document.getElementById("MobilePhone");
	if (obj) { obj.value=""; }

	//	PIBI_IDCard	���֤��
	obj=document.getElementById("IDCard");
	if (obj) { obj.value=""; }

	//	PIBI_Vocation	ְҵ
	obj=document.getElementById("Vocation");
	if (obj) { obj.value=""; }

	//	PIBI_Position	ְλ
	obj=document.getElementById("Position");
	if (obj) { obj.value=""; }

	//	PIBI_Company	��˾
	obj=document.getElementById("Company");
	if (obj) { obj.value=""; }

	//	PIBI_Postalcode	�ʱ�
	obj=document.getElementById("Postalcode");
	if (obj) { obj.value=""; }

	//	PIBI_Address	��ϵ��ַ
	obj=document.getElementById("Address");
	if (obj) { obj.value=""; }

	//	PIBI_Nation	����
	obj=document.getElementById("Nation");
	if (obj) { obj.value=""; }

	//	PIBI_Email	�����ʼ�
	obj=document.getElementById("Email");
	if (obj) { obj.value=""; }

	//	PIBI_Married	����״��
	obj=document.getElementById("Married_DR");
	if (obj) { obj.value=""; }
	
	obj=document.getElementById("Married_DR_Name");
	if (obj) { obj.value=""; }
	
	//	PIBI_Blood	Ѫ��
	obj=document.getElementById("Blood_DR");
	if (obj) { obj.value=""; }
	
	obj=document.getElementById("Blood_DR_Name");
	if (obj) { obj.value=""; }
	
	//	PIBI_UpdateDate	����
	obj=document.getElementById("UpdateDate");
	if (obj) { obj.value=""; }
	
	//	PIBI_UpdateUser_DR	������
	obj=document.getElementById("UpdateUser_DR");
	if (obj) { obj.value=""; }
	
	obj=document.getElementById("UpdateUser_DR_Name");
	if (obj) { obj.value=""; }

}

// ************************************************************************************
function Sex_DR_Name_blur() {
	obj=document.getElementById("Sex_DR");
	if (obj && ""==obj.value) {
		obj=document.getElementById("Sex_DR_Name");
		//obj.className='clsInvalid';
		//websys_setfocus(obj.id);
	}
}
function Sex_DR_Name_keydown(e) {
	var key=websys_getKey(e);
	var eSrc=window.event;
	
	var obj=document.getElementById("Sex_DR_Name");
	if (obj) { obj.className=''; }
	
	if ( (9==key) || (13==key) ) {
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
// �Ա�
function GetSex(value) {
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;
	
		obj=document.getElementById("Sex_DR_Name");
		if (obj) {
			obj.value=aiList[0];
			websys_nexttab(obj.tabIndex);
		}

		obj=document.getElementById("Sex_DR");
		if (obj) { obj.value=aiList[2]; }
		
	}
}
function PatType_DR_Name_blur() {
	obj=document.getElementById("PatType_DR");
	if (obj && ""==obj.value) {
		obj=document.getElementById("PatType_DR_Name");
		//obj.className='clsInvalid';
		//websys_setfocus(obj.id);
	}
}
function PatType_DR_Name_keydown(e) {
	var key=websys_getKey(e);
	var eSrc=window.event;
	
	var obj=document.getElementById("PatType_DR_Name");
	if (obj) { obj.className=''; }
	
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

//��������
function GetPatType(value) {
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;

		obj=document.getElementById("PatType_DR_Name");
		if (obj) {
			obj.value=aiList[0];
			websys_nexttab(obj.tabIndex);
		}


		obj=document.getElementById("PatType_DR");
		if (obj) { obj.value=aiList[2]; }
		
	}
}
function Married_DR_Name_blur() {
	obj=document.getElementById("Married_DR");
	if (obj && ""==obj.value) {
		obj=document.getElementById("Married_DR_Name");
		//obj.className='clsInvalid';
		//websys_setfocus(obj.id);
	}
}

function Married_DR_Name_keydown(e) {
	var obj=document.getElementById("Married_DR_Name");
	if (obj) { obj.className=''; }
	
	var key=websys_getKey(e);
	var eSrc=window.event;
	
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

//����״��
function GetMarital(value) {
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;

		obj=document.getElementById("Married_DR_Name");
		if (obj) {
			obj.value=aiList[0];
			websys_nexttab(obj.tabIndex);
		}

		obj=document.getElementById("Married_DR");
		if (obj) { obj.value=aiList[2]; }
	}
}


function DOB_keydown(e) {
	var key=websys_getKey(e);
	var eSrc=window.event;
	
	if ( (9==key) || (13==key) ) {
		obj=document.getElementById("DOB");
		if (obj && (("12/08/2005"==obj.value)||(""==obj.value))) {
			eSrc.keyCode=117;
			DOB_lookuphandler(117);
		}
		else { websys_nexttab(eSrc.srcElement.tabIndex); }
	}
}
/*
function Blood_DR_Name_keydown(e) {
	var key=websys_getKey(e);
	var eSrc=window.event;
	
	if ( (9==key) || (13==key) ) {
		eSrc.keyCode=117;
		Blood_DR_Name_lookuphandler(117);
	}
}
*/
//Ѫ��
function GetBloodType(value) {
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;

		obj=document.getElementById("Blood_DR_Name");
		if (obj) {
			obj.value=aiList[0];
			websys_nexttab(obj.tabIndex);
		}


		obj=document.getElementById("Blood_DR");
		if (obj) { obj.value=aiList[2]; }
	}
}

document.body.onload = BodyLoadHandler;

