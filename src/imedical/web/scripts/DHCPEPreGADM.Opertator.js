/// DHCPEPreGADM.Opertator.js

var selected="";

function BodyLoadHandler() {

	iniForm();
	
}

function iniForm() {
	var obj;
	var iID="", iName="", GBookDate="", GBookTime="";
	var iOperType="";
	
	obj=document.getElementById("ID");
	if (obj) { iID=obj.value; }
	
	obj=document.getElementById("Name");
	if (obj) { iName=obj.value; }
	
	obj=document.getElementById("GBookDate");
	if (obj) { GBookDate=obj.value; }

	obj=document.getElementById("GBookTime");
	if (obj) { GBookTime=obj.value; }
	
	var obj=document.getElementById("charttabs");
	var arrDiv = obj.getElementsByTagName("DIV");
	
	obj=document.getElementById("OperType");
	if (obj && ""!=obj.value) { iOperType=obj.value; }

	// ��ѯ
	if ('Q'==iOperType) {
		//if (arrDiv.length) { SelectChart(arrDiv[0]); }
		SetChartItemDisabled('Q');
	}
	
	// �༭
	if ('E'==iOperType) {
		//if (""!=iID) { SetGADM(iID+"^"+iName+"^"+GBookDate+"^"+GBookTime); }
		//if (arrDiv.length) { SelectChart(arrDiv[0]); }
		SetChartItemDisabled('E');
	}
	
	// �м����
	if ('T'==iOperType) {
		//if (arrDiv.length) { SelectChart(arrDiv[2]); }
		SetChartItemDisabled('T');
	}
	
	// �½�
	if ('N'==iOperType) {
		//if (arrDiv.length) { SelectChart(arrDiv[0]); }
		SetChartItemDisabled('N');
	}

}

// ///////////////////////////////////////////////////////////////////////////////

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

function ClearSelected() {
	if (selected!="") {
		var obj=document.getElementById(selected);
		if (obj) { obj.className="chartitem"; }
	}
	selected="";
}

function SelectChart(eSrc) {
	
	if (eSrc.disabled) { return false; }
	
	// ���ѡ���ͼ��(��ʾЧ��)
	ClearSelected();
	
	selected=eSrc.id;
	eSrc.className="chartitemSel";

	var lnk=""
	var obj;
	
	var iRowId="",iName="";
	var iOperType="";
	obj=document.getElementById("ID");
	if (obj) { iRowId=obj.value; }
	obj=document.getElementById("Name");
	if (obj) { iName=obj.value; }
	
	obj=document.getElementById("OperType");
	if (obj && ""!=obj.value) { iOperType=obj.value; }
	
	//�����ѯ OperType="Q"
	if ("DHCPEPreGADM.Find" == eSrc.id) {
		lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreGADM.Find"
			;
		OpenIFRAMEWindow("dataframe",lnk);
		return true;
	}
	
	//����ԤԼ OperType="N"
	if ("DHCPEPreGADM.Edit" == eSrc.id) {	
		lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreGADM.Edit"
			"&OperType="+iOperType;
		if (""!=iRowId) { lnk=lnk+"&ID="+iRowId}
		OpenIFRAMEWindow("dataframe",lnk);
		return true;
	}
	
	var iGBookDate="",iGBookTime=""
	obj=document.getElementById("GBookDate");
	if (obj) { iGBookDate=obj.value; }
	
	obj=document.getElementById("GBookTime");
	if (obj) { iGBookTime=obj.value; }

	//����ԤԼ
	if ("DHCPEPreGTeam.List" == eSrc.id) {
		
		//lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreGTeam.List"
		lnk="dhcpepregadm.team.csp"
			+"?ParRef="+iRowId
			+"&ParRefName="+iName
			
			+"&GBookDate="+iGBookDate
			+"&GBookTime="+iGBookTime
			
			+"&OperType="+iOperType //�������� �½�
			
			;
		OpenIFRAMEWindow("dataframe",lnk); //chartbook.operator.js
		return true;
	}

	//����ԤԼ
	if ("DHCPEPreGTeamTest.Team" == eSrc.id) {
		
		lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreGTeam.List"
			+"&ParRef="+iRowId
			+"&ParRefName="+iName
			
			+"&GBookDate="+iGBookDate
			+"&GBookTime="+iGBookTime
			
			+"&OperType="+iOperType //�������� �½�
			
			;
		OpenIFRAMEWindow("dataframe",lnk); //chartbook.operator.js
		return true;
	}


	//��ԱԤԼ
	if ("DHCPEPreIADM.Team" == eSrc.id) {
		lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreIADM.Team"
			+"&ParRef="+iRowId
			+"&ParRefName="+iName
			
			+"&OperType="+iOperType //�������� �½�
			
			;
		
		OpenIFRAMEWindow("dataframe",lnk); //chartbook.operator.js
		return true;
	}
	
     //��������
    	if ("DHCPEGroupAllPersonFind" == eSrc.id) {
		lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEGroupAllPersonFind"
			;
		if (""!=iRowId) { lnk=lnk+"&ID="+iRowId}
		OpenIFRAMEWindow("dataframe",lnk);
		return true;
	}	
	

}

// 
function  SetGADM(Data) {
	
	var obj;
	var Datas=Data.split("^");
	var ID=Datas[0];
	
	if (""==ID) { return false;}
	obj=document.getElementById("ID");
	if (obj) { obj.value=ID; }
	
	var Name=Datas[1];
	obj=document.getElementById("Name");
	if (obj) { obj.value=Name; }
	
	var GBookDate=Datas[2];
	obj=document.getElementById("GBookDate");
	if (obj) { obj.value=GBookDate; }
	
	var GBookTime=Datas[3];
	obj=document.getElementById("GBookTime");
	if (obj) { obj.value=GBookTime; }
	
	var iOperType=Datas[4];
	//alert("SetGADM OperType:"+iOperType)
	obj=document.getElementById("OperType");
	if (obj) { obj.value=iOperType; }
	
	SetChartItemDisabled(iOperType);

}

// ����ͼ���Ƿ����

function SetChartItemDisabled(OperType) {
	// �½�ԤԼ
	if ('N'==OperType) {
		//ͼ�� ����ԤԼ
		obj=document.getElementById("DHCPEPreGADM.Edit");
		if (obj){ obj.disabled=false; }

		//ͼ�� �������
		obj=document.getElementById("DHCPEPreGTeam.List");
		if (obj){ obj.disabled=true; }

		//ͼ�� ��Ա����
		obj=document.getElementById("DHCPEPreIADM.Team");
		if (obj){ obj.disabled=true; }
		
				//ͼ�� �����Ӽ���
		obj=document.getElementById("DHCPEGroupAllPersonFind");
		if (obj){ obj.disabled=false; }
			
		return true;
	}
	
	// �༭ԤԼ
	if ('E'==OperType) {
		//ͼ�� ����ԤԼ
		obj=document.getElementById("DHCPEPreGADM.Edit");
		if (obj){ obj.disabled=false; }

		//ͼ�� �������
		obj=document.getElementById("DHCPEPreGTeam.List");
		if (obj){ obj.disabled=false; }
		
		//ͼ�� ��Ա����
		obj=document.getElementById("DHCPEPreIADM.Team");
		if (obj){ obj.disabled=false; }
		
	   //ͼ�� �����Ӽ���
		obj=document.getElementById("DHCPEGroupAllPersonFind");
		if (obj){ obj.disabled=false; }
		
		return true;
	}
	
	// �м����
	if ('T'==OperType) {
		//ͼ�� ����ԤԼ
		obj=document.getElementById("DHCPEPreGADM.Edit");
		if (obj){ obj.disabled=true; }

		//ͼ�� �������
		obj=document.getElementById("DHCPEPreGTeam.List");
		if (obj){ obj.disabled=true; }

		//ͼ�� ��Ա����
		obj=document.getElementById("DHCPEPreIADM.Team");
		if (obj){ obj.disabled=false; }	
		
				//ͼ�� �����Ӽ���
		obj=document.getElementById("DHCPEGroupAllPersonFind");
		if (obj){ obj.disabled=false; }	
		return true;
	}

	// �½�ԤԼ
	if ('Q'==OperType) {
		//ͼ�� ����ԤԼ��ѯ
		obj=document.getElementById("DHCPEPreGADM.Find");
		if (obj){ obj.disabled=false; }

		//ͼ�� �������
		obj=document.getElementById("DHCPEPreGTeam.List");
		if (obj){ obj.disabled=false; }
		
		//ͼ�� ��Ա����
		obj=document.getElementById("DHCPEPreIADM.Team");
		if (obj){ obj.disabled=false; }
	
		//ͼ�� �������
		obj=document.getElementById("DHCPEPreGTeamTest.Team");
		if (obj){ obj.disabled=false; }
		
			//ͼ�� �������
		obj=document.getElementById("DHCPEPreGTeamTest.Team");
		if (obj){ obj.disabled=false; }
		
			//ͼ�� �����Ӽ���
		obj=document.getElementById("DHCPEGroupAllPersonFind");
		if (obj){ obj.disabled=false; }
		
		return true;
	}
	
}

document.body.onload = BodyLoadHandler;
