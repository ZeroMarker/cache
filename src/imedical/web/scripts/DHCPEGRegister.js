///filename: DHCPEGRegister.JS
///�ű����� ����Ǽ�
///��Ӧҳ�� ����Ǽ�

var CurrentSel=0;
var SelectedRow= "-1";

var UserId=session['LOGON.USERID'];
var LocId=session['LOGON.CTLOCID'];

//ҳ���ʼ��
function BodyLoadHandler()
{	
	var obj;
	obj=document.getElementById("BGetData");
	if (obj) obj.onclick=BGetData_Click;
}

//��λ��Ŀ��Ϣ��ȡ 
function BGetData_Click()
{	
	
	var	CrmGrpId=GetCtlValueById("RowId");
	
	//var myObject=document.getElementById("RowId");
	//if (myObject){
	//	CrmGrpId=myObject.value;
	//	}
		
	var	CrmGRegId=GetCtlValueById("RegId");
	//var myObject=document.getElementById("RegId");
	//if (myObject){
	//	CrmGRegId=myObject.value;
	//	}
	
	//alert("GAdmCrmId:"+GAdmCrmId+"GRegId:"+GRegId+"UserId:"+UserId+"LocId:"+LocId);
	if (""==CrmGrpId){
		alert(t['NoSelected']);
		return false
  	} 

    //��CRM��ȡ����
	var encmeth=GetCtlValueById('GetDataBox',1);   
	//alert(encmeth + "\n" + CrmGrpId+ "\n"+CrmGRegId+"\n"+UserId+"\n"+LocId);     
	var flag=cspRunServerMethod(encmeth,CrmGrpId,CrmGRegId,UserId,LocId)///////////
	//alert("0724mlh");
    if (flag!='') {
        alert(t['FailsTrans']+"  error="+flag);
        return false
    }
    
    //���õ���״̬
	encmeth=GetCtlValueById('GAdmArrived',1);        
    var flag=cspRunServerMethod(encmeth,CrmGRegId)
    if (flag!='0') {
        alert(t['FailsArrived']+"  error="+flag);
        return false
    }

    alert(t['Completed']);
    location.reload();

     
}

//��ѯ��ǰ��λ����Ա�ļ�����Ŀ 
//�������� ����˵�?��ȡ��ǰ������Ŀ?
function SearchIAdmOrder() {
	
	var lnk;
	var GAdmRowId="";
	var iStatus="";
	
	obj=document.getElementById("RegId");
	if (obj) { GAdmRowId=obj.value; }
	if (""==GAdmRowId) {
		alert('����ѡ��һ������,�ٲ�ѯ');
		return false;
	}
	/*
	else
	{
		
	
		obj=document.getElementById("Status");
		if (obj) { iStatus=obj.value; }
		if ("PREREG"==iStatus) {
			alert('�˵�λ����Ԥ�Ǽ�״̬,���Ȼ�ȡ,�ٲ�ѯ');
			return false;
		}	
			
		var Ins=document.getElementById('ADMIdBox');
		if (Ins) {var encmeth=Ins.value} 
		else {var encmeth=''};
		var flag=cspRunServerMethod(encmeth,"","",GAdmRowId)
		if (''!=flag) {
			GAdmRowId=flag;
		}
		else{
			alert("δ��ϵͳ���ҵ���Ӧ������");
			return false;
		}
	
	}
	*/
	lnk="DHCPEGTeamRegQuery.csp"
		+"?"+"ParRef="+GAdmRowId	
	//	+"&"+"sType"+"G"		//��ѯ���Ͱ�?�����ѯ
		+"&"+"sType="+"GT"		//��ѯ���Ͱ������ѯ
		;

	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=700,height=520,left=0,top=0';
	
	window.open(lnk,"_blank",nwin)

}
// ----------------------------------------------------------------
//��ʾ��ǰ��λ��ȫ����Ա�ı���״̬
//�������� ����˵� ���屨���ѯ
function SearchGReport() {
	
	var lnk;
	var GAdmRowId="";
	var iStatus="";
	
	obj=document.getElementById("RegId");
	if (obj) { GAdmRowId=obj.value; }
	if (""==GAdmRowId) {
		alert('����ѡ��һ������,�ٲ�ѯ');
		return false;
	}
	lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEGReport"
		+"&"+"aGADMDR="+GAdmRowId	
		+"&"+"aIADMDesc="+""		
		+"&"+"aSTatus="+""	
		;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=700,height=520,left=0,top=0';

	window.open(lnk,"_blank",nwin)

}
// ******************************************************
function trim(s) {
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
        return (m == null) ? "" : m[1];
 }

function ShowCurRecord(selectrow) {

	var SelRowObj;
	var obj;

	SelRowObj=document.getElementById('TGroupId'+'z'+selectrow);
	obj=document.getElementById("RowId");
	if (obj) { obj.value=SelRowObj.innerText; }	

	SelRowObj=document.getElementById('TGroupRegId'+'z'+selectrow);
	obj=document.getElementById("RegId");
	obj.value=SelRowObj.innerText;
	
	SelRowObj=document.getElementById('TStatus'+'z'+selectrow);
	obj=document.getElementById("Status");
	if (obj) { obj.value=SelRowObj.innerText; }

}
function SelectRowHandler() {  
	var eSrc=window.event.srcElement;
	
	var objtbl=document.getElementById('tDHCPEGRegister');
	
	if (objtbl){
		var rows=objtbl.rows.length;
	}

	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	
	
	if (!selectrow) return;

	if (selectrow!=SelectedRow) {
		ShowCurRecord(selectrow);
		SelectedRow = selectrow;
	}
}

document.body.onload = BodyLoadHandler;