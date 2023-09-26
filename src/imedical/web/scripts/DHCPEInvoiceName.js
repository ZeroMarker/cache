///����?������
///����ʱ��?2009-02-23
///DHCPEInvoiceName.js,�������?DHCPEInvoiceName
///��������?��ӡ��Ʊ����
function BodyOnloadHandler(){
	//�ǼǺ�
	var objRegNo=document.getElementById("RegNo");
	if(objRegNo){
		objRegNo.onkeydown=RegNoKeyDown
	}
	//����
	var objPIBIName=document.getElementById("PIBIName");
	if(objPIBIName){
		objPIBIName.onkeydown=PIBINameKeyDown
	}
	//��������
	var objFindAll=document.getElementById("findAll");
	if(objFindAll){
		objFindAll.onclick=QueryAllInvoiceName;
	}
	//����
	var objFindPat=document.getElementById("findPat");
	if(objFindPat){
		objFindPat.onclick=QueryPat;
	}
	//����
	var objUpdate=document.getElementById("update");
	if(objUpdate){
		objUpdate.onclick=updateClick
	}
	//���
	var objClear=document.getElementById("clear");
	if(objClear){
		objClear.onclick=clearClick
	}
	//ɾ��
	var objDelete=document.getElementById("deleteInvoiceName");
	if(objDelete){
		objDelete.onclick=deleteClick
	}
}
///����?������
///����ʱ��?2009-02-23
///��������?��Ҫ�����е�������䵽Ԫ����
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	//�еĶ���	
	var rowObj=getRow(eSrc);
	//����
	var selectRow=rowObj.rowIndex;
	var SelRowObj=document.getElementById('tPIBI_PAPMINoz'+selectRow);
	var objRegNo=document.getElementById("RegNo");
	if(objRegNo){
		objRegNo.value=SelRowObj.innerText;
	}
	SelRowObj=document.getElementById('tPIBI_Namez'+selectRow);
	var objPIBIName=document.getElementById("PIBIName");
	if(objPIBIName){
		objPIBIName.value=SelRowObj.innerText;
	}
	SelRowObj=document.getElementById('tInvoiceNamez'+selectRow);
	var objIsInsert=document.getElementById("isInsert");
	var objInvoiceName=document.getElementById("invoiceName");
	
	
	if((""!=SelRowObj.innerText)&&(" "!=SelRowObj.innerText)){
	
		objInvoiceName.value=SelRowObj.innerText;
		
	}else{
	
		objInvoiceName.value=""
	}
}
///����:������
///����ʱ��:2009-02-23
///��������:���ǼǺ��ϰ��س��ļ����¼�
function RegNoKeyDown(){
	var Key=websys_getKey(e);
	if ((13==Key)) {
		QueryPat();
		return ;
	}
}
///����:������
///����ʱ��:2009-02-23
///��������:�����ϰ��س��ļ����¼�
function PIBINameKeyDown(){
	var Key=websys_getKey(e);
	if ((13==Key)) {
		QueryPat();
		return ;
	}
}
///����:������
///����ʱ��:2009-02-23
///��������:���ǼǺŲ�ѯ������Ϣ
function QueryPat(){
	var objRegNo=document.getElementById("RegNo");
	if(objRegNo){
		objRegNo=objRegNo.value;
	}
	var objPIBIName=document.getElementById("PIBIName");
	if(objPIBIName){
		objPIBIName=objPIBIName.value;
	}
	var allPat=""
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEInvoiceName"
			+"&RegNo="+objRegNo
			+"&PIBIName="+objPIBIName
			+"&allPat="+allPat
               
   location.href=lnk; 
}
///����:������
///����ʱ��:2009-02-23
///��������:��ѯ���е��з�Ʊ��ӡ���ƵĲ���
function QueryAllInvoiceName(){
	var objRegNo="";
	var objPIBIName="";
	var allPat="Y"
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEInvoiceName"
			+"&RegNo="+objRegNo
			+"&PIBIName="+objPIBIName
			+"&allPat="+allPat
               
   location.href=lnk; 
}
///����?������
///����ʱ��?2009-02-23
///��������?��ɸ��²���?û�б�����������
function updateClick(){
	var objInvoiceName=document.getElementById("invoiceName");
	if(objInvoiceName){
		objInvoiceName=objInvoiceName.value;
	}
	var objRegNo=document.getElementById("RegNo");
	if(objRegNo){
		objRegNo=objRegNo.value;
	}
	var objIns=document.getElementById("ins");
	if(objIns){
		objIns=objIns.value;
		//actionTypeΪU��ʾ����
		var actionType="U"
		var returnValue=cspRunServerMethod(objIns,"U",objRegNo,objInvoiceName);
		
	}
	if (returnValue==1){
		alert(t['updateSuccess']);
	}else{
		alert(t['updateFailed']);
	}
}
///����:������
///����ʱ��:2009-02-23
///��������:ɾ����ӡ��Ʊ����
function deleteClick(){
	var objInvoiceName=document.getElementById("invoiceName");
	if(objInvoiceName){
		objInvoiceName=objInvoiceName.value;
	}
	var objRegNo=document.getElementById("RegNo");
	if(objRegNo){
		objRegNo=objRegNo.value;
	}
	var objIns=document.getElementById("ins");
	if(objIns){
		objIns=objIns.value;
		//actionTypeΪD��ʾɾ��
		var actionType="D"
		var returnValue=cspRunServerMethod(objIns,"D",objRegNo,objInvoiceName);
		
	}
	if (returnValue==1){
		alert(t['deleteSuccess']);
		clearClick();
	}else{
		alert(t['deleteFailed']);
	}
}
///����:������
///����ʱ��:2009-02-23
///��������:���Ԫ�ص�����Ϊ��

function clearClick(){
	var objInvoiceName=document.getElementById("invoiceName");
	if(objInvoiceName){
		objInvoiceName.value="";
	}
	var objRegNo=document.getElementById("RegNo");
	if(objRegNo){
		objRegNo.value="";
	}
	var objPIBIName=document.getElementById("PIBIName");
	if(objPIBIName){
		objPIBIName.value="";
	}
}
document.body.onload=BodyOnloadHandler