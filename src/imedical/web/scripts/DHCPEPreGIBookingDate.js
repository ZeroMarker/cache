/// DHCPEPreGIBookingDate.js
/// ����ʱ��		2006.10.20
/// ������		xuwm
/// ��Ҫ����		���������Ա�޸�ԤԼ��Ϣ?ԤԼʱ��?
/// 			��DHCPEPreIADM.Team.UpdateBooking����
/// ��Ӧ��		
/// ����޸�ʱ��	
/// ����޸���	
/// ���
var TFORM="";
function BodyLoadHandler() {

	var obj;

	//����
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	
	iniForm();
}

function iniForm(){
	/*
	var obj;
	
	obj=document.getElementById('DataBox');
	if (obj && ""!=obj.value) { 
		SetPatient_Sel(obj.value);
	}
	*/	
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

function Update_click() {
	var iRowId=""
	var iPEDate="", iPETime="",iUpdateUserDR="";
	var obj;
	
	obj=document.getElementById("RowId");
	if (obj) { iRowId=obj.value; } 

	//	PGT_ChildSub
	obj=document.getElementById("PEDate");
	if (obj) { iPEDate=obj.value; } 
	
	//��������	PGT_Desc
	obj=document.getElementById("PETime");
	if (obj) { iPETime=obj.value; }	
	
	iUpdateUserDR=session['LOGON.USERID'];

	if (""==iRowId) {
		alert(t['01']);
		return false;		
	}
	
	var Instring= trim(iRowId)			// 1
				+"^"+trim(iPEDate)		// 2 PIADM_PEDate	ԤԼ�������
				+"^"+trim(iPETime)		// 3 PIADM_PETime	ԤԼ���ʱ��
				+"^"+trim(iUpdateUserDR)// 4 
				;

	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring)

	if ('0'==flag) {
		//alert("Update Success!");
		alert(t['info 01']);
		if (opener) {
			// ���ø����� DHCPEPreGTeam.List �ķ��غ���
			opener.ChilidWindowReturn(iRowId+"^"+iPEDate+"^"+iPETime);
			close();
		}
		
	}else if('100'==flag) {
		alert(t['Err 100']);
		close();
	}	
	else {
		//alert("Insert error.ErrNo="+flag);
		alert(t['02']+flag);
		close();
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
document.body.onload = BodyLoadHandler;
/*
function FindPatDetail(ID){
	var Instring=ID;

	var Ins=document.getElementById('GetDetail');
	if (Ins) { var encmeth=Ins.value} else {var encmeth=''};
	var flag=cspRunServerMethod(encmeth,'SetPatient_Sel','',Instring);

}
function SetPatient_Sel(value) {

	var obj;
	var Data=value.split("^");
	var iLLoop=0;
	iRowId=Data[iLLoop];
	
	if ("0"==iRowId){
		return false;
	}
	
	//	PGT_RowId
	obj=document.getElementById("RowId");
	if (obj) { obj.value=Data[iLLoop]; } 
		
}
*/