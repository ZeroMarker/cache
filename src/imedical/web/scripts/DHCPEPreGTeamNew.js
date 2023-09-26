/// DHCPEPreGTeamNew.js

var TFORM="tDHCPEPreGTeamNew";
function BodyLoadHandler() {
	

	var obj,VIP;
	var tobj=document.getElementById(TFORM)
	if (tobj) {
		tobj.ondblclick=ClicktblToSetTemplate;}
	//����
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	
	//�����Ա� 
	obj=document.getElementById("Sex_N");
	if (obj){ obj.onclick=Sex_click; }
	obj=document.getElementById("Sex_M");
	if (obj){ obj.onclick=Sex_click; }	
	obj=document.getElementById("Sex_F");
	if (obj){ obj.onclick=Sex_click; }	
	
	//����״��
	obj=document.getElementById("Married_UM");
	if (obj){ obj.onclick=Married_click; }
	obj=document.getElementById("Married_M");
	if (obj){ obj.onclick=Married_click; }
	obj=document.getElementById("Married_N");
	if (obj){ obj.onclick=Married_click;}
	
	//���÷������
	obj=document.getElementById("Team_One");
	if (obj){ obj.onclick=Team_click; }	
	obj=document.getElementById("Team_Two");
	if (obj){ obj.onclick=Team_click; }	
	obj=document.getElementById("Team_Three");
	if (obj){ obj.onclick=Team_click; }	
	obj=document.getElementById("Team_Four");
	if (obj){ obj.onclick=Team_click; }	
	obj=document.getElementById("Team_Five");
	if (obj){ obj.onclick=Team_click; }		
	
	var obj=document.getElementById("GetVIP");
	if (obj) VIP=obj.value;  
	obj=document.getElementById("VIPLevel");	//	�б��ʱʹ��
	if (obj) {
		obj.value=VIP;
		obj.onchange=VIPLevel_Change;
	}
	// PGT_AddOrdItem ���Ѽ��� 
	obj=document.getElementById("AddOrdItem");
	if (obj){ obj.onclick = AddOrdItem_click; }

	// PGT_AddOrdItemLimit ���������� 
	obj=document.getElementById("AddOrdItemLimit");
	if (obj){ obj.onclick = AddOrdItemLimit_click; }

	// PGT_AddPhcItem �����ҩ 
	obj=document.getElementById("AddPhcItem");
	if (obj){ obj.onclick = AddPhcItem_click; }
	
	// PGT_AddPhcItemLimit ��ҩ������� 
	obj=document.getElementById("AddPhcItemLimit");
	if (obj){ obj.onclick = AddPhcItemLimit_click; }
	DHCP_GetXMLConfig("InvPrintEncrypt","OEItemPrint");  //Add 20080708

	iniForm();
}
function VIPLevel_Change()
{
	obj=document.getElementById("VIPLevel");
	if (obj){
		var VIPLevel=obj.value;
		if (VIPLevel=="") return false;
		var PatType=tkMakeServerCall("web.DHCPE.VIPLevel","GetPatFeeType",VIPLevel)
		if (PatType!=""){
			var obj=document.getElementById("PatFeeType_DR_Name");
			if (obj) obj.value=PatType;
		}
	}
}
function iniForm(){

	var SelRowObj;
	var obj;
	//var iParRef,iChildSub="";
	obj=document.getElementById("OperType");
	if (obj && "Q"==obj.value) {}
	else{
		obj=document.getElementById("Update");
		if (obj){ obj.style.display="inline"; }
	
		//����
		obj=document.getElementById("RapidNew");
		if (obj){ obj.style.display="inline"; }			
	
	}
	    
	obj=document.getElementById('ParRefBox');
	if (obj) { iParRef=obj.value; }
	
	obj=document.getElementById('ParRef');
	if (""!=iParRef && obj) { obj.value=iParRef; }
	
	if (""==iParRef)
	{
		obj=document.getElementById("ParRef_Name");
	    if (obj) { obj.value=""; }
	    return false;
	}
	else
	{
		SelRowObj=document.getElementById('ParRefNameBox');	
		obj=document.getElementById('ParRef_Name');
		if (SelRowObj && obj) { obj.value=SelRowObj.value; }
	}

	obj=document.getElementById('DataBox');
	if (obj && ""!=obj.value) { 
		SetPatient_Sel(obj.value);
		websys_setfocus("Desc");
	}else{
		obj=document.getElementById('ParRefDataBox');
		if (obj && ""!=obj.value) { 
			SetParRefData(obj.value);
		}
	}	
}
//��֤�Ƿ�Ϊ������
function IsFloat(Value) {
	
	var reg;
	
	if(""==trim(Value)) { 
		//����Ϊ��
		return true; 
	}else { Value=Value.toString(); }
	
	reg=/^((-?|\+?)\d+)(\.\d+)?$/;
	if ("."==Value.charAt(0)) {
		Value="0"+Value;
	}
	
	var r=Value.match(reg);
	if (null==r) { return false; }
	else { return true; }
}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];

}
function FindPatDetail(ID){
	var Instring=ID;

	var Ins=document.getElementById('GetDetail');
	if (Ins) { var encmeth=Ins.value} else {var encmeth=''};
	var flag=cspRunServerMethod(encmeth,'SetPatient_Sel','',Instring);

}
function SetAddItem(value) {
	var Data=value.split("^");
	var iLLoop=0;	
	
	var iAddOrdItem=false;
	//	���Ѽ���	PGT_AddOrdItem	19
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
	//	����������	PGT_AddOrdItemLimit	20
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
	
	//	���Ѽ�����	PGT_AddOrdItemAmount	21
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
	
	//	�����ҩ	PGT_AddPhcItem	22
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
	
	//	��ҩ�������	PGT_AddPhcItemLimit	23
	var iAddPhcItemLimit=false;
	obj=document.getElementById("AddPhcItemLimit");
	if (obj) {
		if (iAddPhcItem) {
			obj.style.display="inline"; // �ɼ�
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
			if (obj) {obj.style.display="inline"; }
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
	
	//	�����ҩ���	PGT_AddPhcItemAmount	24
	obj=document.getElementById("AddPhcItemAmount");		
	if (obj) {
		if (iAddPhcItemLimit) {
			obj.style.display="inline";
			obj.disabled=false;
			
			obj.value=Data[iLLoop];
			
			obj=document.getElementById("cAddPhcItemAmount");
			if (obj) { obj.style.display="inline"; }		
		}
		else{
			obj.style.display="none";
			obj.disabled=true;
			obj.value="";
		}
	}
	
}
function SetParRefData(value) {

	var obj;
	var fillData;
	var Data=value.split("^");
	var iLLoop=4;	
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
	iLLoop=iLLoop+3;
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
	if (obj) { obj.value=fillData; obj.disabled=true}
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];

	// PGADM_IReportSend ���˱��淢�� 27
	obj=document.getElementById("IReportSend");
	if (obj) { obj.value=fillData; obj.disabled=true}
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];

	// PGADM_DisChargedMode ���㷽ʽ 28
	obj=document.getElementById("DisChargedMode");
	if (obj) { obj.value=fillData;} //obj.disabled=true
	iLLoop=iLLoop+3;
	fillData=Data[iLLoop];
    
    //VIP
    obj=document.getElementById("VIPLevel");
	//if (obj) { obj.value=fillData; }
		iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
    
    iLLoop=iLLoop+9;
    fillData=Data[iLLoop];

    //Ĭ������������
    obj=document.getElementById("PatFeeType_DR_Name");
	if (obj) { obj.value=fillData; }
	
	return true

}
function SetPatient_Sel(value) {
	var obj;
	var Data=value.split("^");
	//alert("value:"+value)
	var iLLoop=0;
	iRowId=Data[iLLoop];
	if ("0"==iRowId){
		return false;
	}
	
	//����ADM	PGT_ParRef	1
	obj=document.getElementById("ParRef");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
		
	//	PGT_RowId
	obj=document.getElementById("RowId");
	if (obj) { obj.value=Data[iLLoop]; } 
	iLLoop=iLLoop+1;
	//	PGT_ChildSub 3
	obj=document.getElementById("ChildSub");
	if (obj) { obj.value=Data[iLLoop]; } 
	iLLoop=iLLoop+1;
	
	//��������	PGT_Desc 4
	obj=document.getElementById("Desc");
	if (obj) { obj.value=Data[iLLoop]; } 
	iLLoop=iLLoop+1;
	
	//	PGT_BookDateBegin	21
	obj=document.getElementById("BookDateBegin");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	//	PGT_BookDateEnd	22
	obj=document.getElementById("BookDateEnd");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	//ԤԼʱ�� PGT_BookTime 23
	obj=document.getElementById("BookTime");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	// PGT_PEDeskClerk_DR 24
	obj=document.getElementById("PEDeskClerk_DR");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	var strLine="";
	//	���Ѽ���	PGT_AddOrdItem	12
	strLine=strLine+Data[iLLoop]+"^"; 
	iLLoop=iLLoop+1;	

	//	����������	PGT_AddOrdItemLimit	13
	strLine=strLine+Data[iLLoop]+"^"; 
	iLLoop=iLLoop+1;
	
	//	���Ѽ�����	PGT_AddOrdItemAmount	14
	strLine=strLine+Data[iLLoop]+"^"; 
	iLLoop=iLLoop+1;	
	
	//	�����ҩ	PGT_AddPhcItem	15
	strLine=strLine+Data[iLLoop]+"^"; 
	iLLoop=iLLoop+1;	
	
	//	��ҩ�������	PGT_AddPhcItemLimit	16
	strLine=strLine+Data[iLLoop]+"^"; 
	iLLoop=iLLoop+1;

	//	�����ҩ���	PGT_AddPhcItemAmount	17
	strLine=strLine+Data[iLLoop]+"^"; 
	iLLoop=iLLoop+1;
	SetAddItem(strLine);
	
	//�Ա�	PGT_Sex 5
	obj=document.getElementById("Sex");
	if (obj) { 
		obj.value=Data[iLLoop];
		SetSex("");
		SetSex(Data[iLLoop]);
	} 

	iLLoop=iLLoop+1;
	//��������	PGT_UpperLimit 6
	obj=document.getElementById("UpperLimit");
	if (obj) { obj.value=Data[iLLoop]; } 

	iLLoop=iLLoop+1;
	//��������	PGT_LowerLimit 7
	obj=document.getElementById("LowerLimit");
	if (obj) { obj.value=Data[iLLoop]; } 

	iLLoop=iLLoop+1;
	//����״��	PGT_Married 8
	obj=document.getElementById("Married");
	if (obj) { 
		//obj.value=Data[iLLoop]; 
		SetMarried("");
		SetMarried(Data[iLLoop]);
	} 
   
	iLLoop=iLLoop+4;
	
	//��������	PGT_LowerLimit 7
	obj=document.getElementById("ParRef_Name");
	if (obj) { obj.value=Data[iLLoop]; } 
	iLLoop=iLLoop+1;
	
	//	���屨�淢��	PGT_GReportSend	18
	obj=document.getElementById("GReportSend");
	if (obj) { obj.value=Data[iLLoop]; obj.disabled=true;}
	iLLoop=iLLoop+1;	
	
	//	���˱��淢��	PGT_IReportSend	19
	obj=document.getElementById("IReportSend");
	if (obj) { obj.value=Data[iLLoop]; obj.disabled=true;}
	iLLoop=iLLoop+1;	
	
	//	���㷽ʽ	PGT_DisChargedMode	20
	obj=document.getElementById("DisChargedMode");
	if (obj) { obj.value=Data[iLLoop];} //obj.disabled=true;
	iLLoop=iLLoop+1;	
	// PGT_PEDeskClerk_DR_Name 24.1
	obj=document.getElementById("PEDeskClerk_DR_Name");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	obj=document.getElementById("VIPLevel");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	obj=document.getElementById("TeamLevel");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	obj=document.getElementById("PatFeeType_DR_Name");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	var NoInclude=""
	NoInclude=Data[iLLoop];
	if (NoInclude=="1"){
		obj=document.getElementById("NoIncludeGroup");
		if (obj) obj.checked=true;
	}
}
function Update_click() {
	
	var obj;
	var iDesc="",iSex="",iMarried="",iAge="",iAgeLow="",iAgeHigh="";
	var iTeamNum=0;
	obj=document.getElementById("Team_One");
	if (obj && obj.checked==true){
		iTeamNum=1;
		for (var i=0;i<iTeamNum;i++)
		{
			if(i==0)
			{
				iDesc="ȫ����Ա";
	            iSex="N";
	            iMarried="N";
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
		}		
	}
	obj=document.getElementById("Team_Two");
	if (obj  && obj.checked==true){
		iTeamNum=2;
		for (var i=0;i<iTeamNum;i++)
		{
			if(i==0)
			{
				iDesc="��";
	            iSex="M";
	            iMarried="N";
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
			else
			{
				iDesc="Ů";
	            iSex="F";
	            iMarried="N";
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
		}
	}
	obj=document.getElementById("Team_Three");
	if (obj && obj.checked==true){
		iTeamNum=3;
		for (var i=0;i<iTeamNum;i++)
		{
			if(i==0)
			{
				iDesc="��";
	            iSex="M";
	            iMarried="N";
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue; 
			}
			else if(i==1)
			{
				iDesc="Ůδ��";
	            iSex="F";
	            iMarried="UM";
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
			else 
			{
				iDesc="Ů�ѻ�";
	            iSex="F";
	            iMarried="M";
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
		}
	}
	obj=document.getElementById("Team_Four");
	if (obj && obj.checked==true){
		iTeamNum=4;
		obj=document.getElementById("AgeBoundary");
	    if (obj&& obj.value){ iAge=obj.value;}
		for (var i=0;i<iTeamNum;i++)
		{
			if(i==0)
			{
				iDesc="�д���"+iAge+"��";
	            iSex="M";
	            iMarried="N";
	            iAgeLow=iAge
	            iAgeHigh=100
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
			else if(i==1)
			{
				iDesc="��С��"+iAge+"��";
	            iSex="M";
	            iMarried="N";
	            iAgeLow=0
	            iAgeHigh=iAge
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
			else if(i==2) 
			{
				iDesc="Ů����"+iAge+"��";
	            iSex="F";
	            iMarried="N";
	            iAgeLow=iAge
	            iAgeHigh=100
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
			else
			{
				iDesc="ŮС��"+iAge+"��";
	            iSex="F";
	            iMarried="N";
	            iAgeLow=0
	            iAgeHigh=iAge
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
		}
	}
	obj=document.getElementById("Team_Five");
	if (obj && obj.checked==true){
		iTeamNum=5;
		obj=document.getElementById("AgeBoundary");
	    if (obj&& obj.value){ iAge=obj.value;}
		for (var i=0;i<iTeamNum;i++)
		{
			if(i==0)
			{
				iDesc="Ůδ��";
	            iSex="F";
	            iMarried="UM";
	            iAgeLow=""
	            iAgeHigh=""
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
			else if(i==1)
			{
				iDesc="�д���"+iAge+"��";
	            iSex="M";
	            iMarried="N";
	            iAgeLow=iAge
	            iAgeHigh=100
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
			else if(i==2) 
			{
				iDesc="��С��"+iAge+"��";
	            iSex="M";
	            iMarried="N";
	            iAgeLow=0
	            iAgeHigh=iAge
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
			else if(i==3)
			{
				iDesc="Ů�ѻ����"+iAge+"��";
	            iSex="F";
	            iMarried="M";
	            iAgeLow=iAge
	            iAgeHigh=100
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum)
	            continue;
			}
			else
			{
				iDesc="Ů�ѻ�С��"+iAge+"��";
	            iSex="F";
	            iMarried="M";
	            iAgeLow=0
	            iAgeHigh=iAge
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
		}
	}
	
}
function save(Desc,Sex,Married,AgeLow,AgeHigh,Num,TeamNum){
	
	var obj,OneData="",DataStr="";
	var iParRef="",iRowId="",iChildSub,iDesc;
	
	obj=document.getElementById("ParRef");
	if (obj) { OneData=obj.value; } 
	else {
		 obj.value=Desc; 
	     OneData=obj.value; }
	/*if (""==OneData) {
		//alert("��Ч����");
		alert(t['01']);
		return false;		
	}*/
	iParRef=OneData
	DataStr=OneData
	OneData=""
	var PreGInfoStr=tkMakeServerCall("web.DHCPE.PreGTeamNew","GetPreGInfo",iParRef);
	var PreGInfo=PreGInfoStr.split("^");
	//	PGT_RowId
	obj=document.getElementById("RowId");
	if (obj) { OneData=obj.value; } 
	iRowId=OneData
	DataStr=DataStr+"^"+OneData
	OneData=""

	//	PGT_ChildSub
	obj=document.getElementById("ChildSub");
	if (obj) { OneData=obj.value; }
	iChildSub=OneData 
	DataStr=DataStr+"^"+OneData
	OneData=""

	//��������	PGT_Desc
	OneData=Desc
	iDesc=OneData
	DataStr=DataStr+"^"+OneData
	OneData=""
		
	// PGT_BookDateBegin 29
	obj=document.getElementById("BookDateBegin");
	if (obj) { OneData=obj.value; } 
	DataStr=DataStr+"^"+OneData
	OneData=""

	// PGT_BookDateEnd 30
	obj=document.getElementById("BookDateEnd");
	if (obj) { OneData=obj.value; } 
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//ԤԼʱ�� PGT_BookTime
	obj=document.getElementById("BookTime");
	if (obj) { OneData=obj.value; } 
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//ԤԼ�Ӵ�Ա PGT_PEDeskClerk_DR
	obj=document.getElementById("PEDeskClerk_DR");
	if (obj) { OneData=obj.value; } 
	DataStr=DataStr+"^"+OneData
	OneData=""	
	
	// PGT_AddOrdItem ���Ѽ��� 20
	/*
	obj=document.getElementById("AddOrdItem");
	if (obj && obj.checked) { OneData='Y'; }
	else { OneData='N';}
	*/
	OneData=PreGInfo[7];
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// PGT_AddOrdItemLimit ���������� 21
	/*
	obj=document.getElementById("AddOrdItemLimit");
	if (obj && obj.checked) { OneData='Y'; }
	else { OneData='N';}
	*/
	OneData=PreGInfo[8];
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// PGT_AddOrdItemAmount ���Ѽ����� 22
	/*
	obj=document.getElementById("AddOrdItemAmount");
	if (obj) { OneData=obj.value; }
	*/
	OneData=PreGInfo[9];
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// PGT_AddPhcItem �����ҩ 23
	/*
	obj=document.getElementById("AddPhcItem");
	if (obj && obj.checked) { OneData='Y'; }
	else { OneData='N';}
	*/
	OneData=PreGInfo[10];
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// PGT_AddPhcItemLimit ��ҩ������� 24
	/*
	obj=document.getElementById("AddPhcItemLimit");
	if (obj && obj.checked) { OneData='Y'; }
	else { OneData='N';}
	*/
	OneData=PreGInfo[11];
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//  PGT_AddPhcItemAmount�����ҩ��� 25
	/*
	obj=document.getElementById("AddPhcItemAmount");
	if (obj) { OneData=obj.value; }
	*/
	OneData=PreGInfo[12];
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//�Ա�	PGT_Sex
	OneData=Sex
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//��������	PGT_UpperLimit
	OneData=AgeHigh
	DataStr=DataStr+"^"+OneData
	OneData=""

	//��������	PGT_LowerLimit
	OneData=AgeLow
	DataStr=DataStr+"^"+OneData
	OneData=""

	//����״��	PGT_Married
	OneData=Married
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//VIP�ȼ�
	obj=document.getElementById("VIPLevel");
	if (obj) { OneData=obj.value; } 
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	obj=document.getElementById("TeamLevel");
	if (obj) { OneData=obj.value; } 
	DataStr=DataStr+"^"+OneData
	OneData=""
	 
    //���������� ���ڼƷѼ۸�
    obj=document.getElementById("PatFeeType_DR_Name");
	if (obj) { OneData=obj.value; } 
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//�Ƿ����������
	OneData=""
	obj=document.getElementById("NoIncludeGroup");
	if (obj&&obj.checked) { OneData=1; } 
	DataStr=DataStr+"^"+OneData;

	//���㷽ʽ
	obj=document.getElementById("DisChargedMode");
	if (obj) { OneData=obj.value;}
	DataStr=DataStr+"^"+OneData;

	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',DataStr)
	if (flag=="Err Date")
	{
		alert(t["Err Date"]);
		return false;
	}
	if ('0'==flag) {
		//alert("Update Success!");	
		if (opener && Num==TeamNum-1) {
			alert(t['info 01']);
			// ���ø����� DHCPEPreGTeam.List �ķ��غ���
			opener.NewWondowReturn("1"+"^"+iParRef+"^"+iRowId+"^"+iChildSub+"^"+iDesc);
			close();
		}
		
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
function SearchGList(value) {
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;
		obj=document.getElementById("ParRef_Name");
		if (obj) { obj.value=aiList[0]; }

		obj=document.getElementById("ParRef");
		if (obj) { obj.value=aiList[2]; }

	}
}

function nextfocus() {
	var eSrc=window.event.srcElement;
	var key=websys_getKey(e);
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
}
document.body.onload = BodyLoadHandler;

// **************  ���Ա����⴦��   ********************
function GetSex() {	
	var obj;

	obj=document.getElementById("Sex_M");
	if (obj){ if (obj.checked) { return "M"; } }
	
	obj=document.getElementById("Sex_F");
	if (obj){ if (obj.checked) { return "F"; } }
	
	obj=document.getElementById("Sex_N");
	if (obj){ if (obj.checked) { return "N"; } }
	
	return "N";
	
}

function SetSex(value) {
	
	var obj;
	
	if (""==value) {		 		
		obj=document.getElementById("Sex_N");
		if (obj){ obj.checked=false; }
		obj=document.getElementById("Sex_M");
		if (obj){ obj.checked=false; }
		obj=document.getElementById("Sex_F");
		if (obj){ obj.checked=false; }
		return false;				
	}
	
	if ("M"==value) {
	
		obj=document.getElementById("Sex_M");
		if (obj) { obj.checked=true; }  
	}
	else {
		if ("F"==value) {
		obj=document.getElementById("Sex_F");
		if (obj){ obj.checked=true; }  
		}
		else {
			if ("N"==value) {
				obj=document.getElementById("Sex_N");
				if (obj){ obj.checked=true; } 
			}
			else{  //Ĭ��
				obj=document.getElementById("Sex_N");
				if (obj){ obj.checked=true; }  			
			}
		}
	}  
}
function Sex_click() {
	var obj;
	ChildSub=6;

	srcElement = window.event.srcElement;

	SetSex("");

	obj=srcElement;
	obj.checked=true;
}
// **************  �Ի������⴦��   ********************
function GetMarried() {	
	var obj; 
	obj=document.getElementById("Married_UM");
	if (obj){ if (obj.checked) { return "UM"; } }
	
	obj=document.getElementById("Married_M");
	if (obj){ if (obj.checked) { return "M"; } }
	
	obj=document.getElementById("Married_N");
	if (obj){ if (obj.checked) { return "N"; } }
		
	return "N";
}

function SetMarried(value) {
	
	var obj;
	
	if (""==value) {		 		
		obj=document.getElementById("Married_UM");
		if (obj){ obj.checked=false; }
		obj=document.getElementById("Married_M");
		if (obj){ obj.checked=false; }
		obj=document.getElementById("Married_N");
		if (obj){ obj.checked=false; }		
		
		return false;				
	}
	
	obj=document.getElementById("Married_UM");
	if (("UM"==value || "Unmarried"==value)&& obj) { 
		obj.checked=true;
		return true;
	}
	
	obj=document.getElementById("Married_M");
	if (("M"==value || "Married"==value) && obj) {
		obj.checked=true;
		return true;
	}

	obj=document.getElementById("Married_N");
	if (("N"==value || "No"==value) && obj) {
		obj.checked=true;
		return true;
	}

}

function Married_click() {
	var obj;

	srcElement = window.event.srcElement;

	SetMarried("");

	obj=srcElement;
	obj.checked=true;
}


// **************  �Է���������⴦��   ********************
function GetTeam() {	
	var obj;

	obj=document.getElementById("Team_One");
	if (obj){ if (obj.checked) { return "One"; } }
	
	obj=document.getElementById("Team_Two");
	if (obj){ if (obj.checked) { return "Two"; } }
	
	obj=document.getElementById("Team_Three");
	if (obj){ if (obj.checked) { return "Three"; } }
	
	obj=document.getElementById("Team_Four");
	if (obj){ if (obj.checked) { return "Four"; } }
	
	obj=document.getElementById("Team_Five");
	if (obj){ if (obj.checked) { return "Five"; } }
	
	return "One";
	
}
function SetTeam(value) {
	
	var obj;
	
	if (""==value) {		 		
		obj=document.getElementById("Team_One");
		if (obj){ obj.checked=false; }
		obj=document.getElementById("Team_Two");
		if (obj){ obj.checked=false; }
		obj=document.getElementById("Team_Three");
		if (obj){ obj.checked=false; }	
		obj=document.getElementById("Team_Four");
		if (obj){ obj.checked=false; }	
		obj=document.getElementById("Team_Five");
		if (obj){ obj.checked=false; }		
		
		return false;				
	}
	
	obj=document.getElementById("Team_One");
	if (("One"==value )&& obj) { 
		obj.checked=true;
		return true;
	}
	
	obj=document.getElementById("Team_Two");
	if (("Two"==value) && obj) {
		obj.checked=true;
		return true;
	}

	obj=document.getElementById("Team_Three");
	if (("Three"==value ) && obj) {
		obj.checked=true;
		return true;
	}
	obj=document.getElementById("Team_Four");
	if (("Four"==value) && obj) {
		obj.checked=true;
		return true;
	}
	obj=document.getElementById("Team_Five");
	if (("Five"==value) && obj) {
		obj.checked=true;
		return true;
	}
}
function Team_click() {
	var obj;
	 
	srcElement = window.event.srcElement;
	
	SetTeam("");

	obj=srcElement;
	obj.checked=true;	
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
		alert(aiList[1])
	}
}
//  ���Ѽ���(PGT_AddOrdItem)
function AddOrdItem_click() {
	//var src=window.event.srcElement;
	var src=document.getElementById("AddOrdItem");
	var obj;

	if (src.checked) {
		// PGT_AddOrdItemLimit ���������� 
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
		// PGT_AddOrdItemLimit ���������� 
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
// PGT_AddOrdItemLimit ���������� 
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
// PGT_AddPhcItem �����ҩ 
function AddPhcItem_click() {
	//var src=window.event.srcElement;
	var src=document.getElementById("AddPhcItem");
	var obj;
	
	if (src.checked) {
		// PGT_AddPhcItemLimit ��ҩ������� 
		obj=document.getElementById("AddPhcItemLimit");
		if (obj){
			obj.style.display = "inline" ;
			obj.disabled=false;
			obj.checked=true;
		}
		obj=document.getElementById("cAddPhcItemLimit");
		if (obj){ obj.style.display = "inline" ; }
		
		// PGT_AddPhcItemAmount	�����ҩ���
		obj=document.getElementById("AddPhcItemAmount");
		if (obj){
			obj.style.display="inline";
			obj.disabled=false;
			obj.value="";
		}
		obj=document.getElementById("cAddPhcItemAmount");
		if (obj){ obj.style.display = "inline" ; }
		
		websys_setfocus("AddPhcItemAmount");
		
	}
	else{
		// PGT_AddPhcItemLimit ��ҩ������� 
		obj=document.getElementById("AddPhcItemLimit");
		if (obj){
			obj.style.display = "none" ;
			obj.disabled=true;
			obj.checked=false;
		}
		obj=document.getElementById("cAddPhcItemLimit");
		if (obj){ obj.style.display = "none" ; }
		
		// PGT_AddPhcItemAmount	�����ҩ���
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
// PGT_AddPhcItemLimit ��ҩ������� 
function AddPhcItemLimit_click() {
	//alert("AddPhcItemLimit_click"+src.id)
	//var src=window.event.srcElement;
	var src=document.getElementById("AddPhcItemLimit");
	var obj;
	
	if (src.checked) {
		// PGT_AddPhcItemAmount	�����ҩ���
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
		// PGT_AddPhcItemAmount	�����ҩ���
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
function DelGTeamTemp()
{
	var eSrc=window.event.srcElement;
	var ID=eSrc.id;
	ret=tkMakeServerCall("web.DHCPE.PreGTeam","GTeamTempSet","",ID,"Del"); 
	location.reload();
	
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