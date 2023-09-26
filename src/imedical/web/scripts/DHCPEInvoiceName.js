///作者?汪福建
///创建时间?2009-02-23
///DHCPEInvoiceName.js,对于组件?DHCPEInvoiceName
///功能描述?打印发票名称
function BodyOnloadHandler(){
	//登记号
	var objRegNo=document.getElementById("RegNo");
	if(objRegNo){
		objRegNo.onkeydown=RegNoKeyDown
	}
	//姓名
	var objPIBIName=document.getElementById("PIBIName");
	if(objPIBIName){
		objPIBIName.onkeydown=PIBINameKeyDown
	}
	//查找所有
	var objFindAll=document.getElementById("findAll");
	if(objFindAll){
		objFindAll.onclick=QueryAllInvoiceName;
	}
	//查找
	var objFindPat=document.getElementById("findPat");
	if(objFindPat){
		objFindPat.onclick=QueryPat;
	}
	//更新
	var objUpdate=document.getElementById("update");
	if(objUpdate){
		objUpdate.onclick=updateClick
	}
	//清空
	var objClear=document.getElementById("clear");
	if(objClear){
		objClear.onclick=clearClick
	}
	//删除
	var objDelete=document.getElementById("deleteInvoiceName");
	if(objDelete){
		objDelete.onclick=deleteClick
	}
}
///作者?汪福建
///创建时间?2009-02-23
///功能描述?主要将表中的数据填充到元素上
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	//行的对象	
	var rowObj=getRow(eSrc);
	//行数
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
///作者:汪福建
///创建时间:2009-02-23
///功能描述:当登记号上按回车的监听事件
function RegNoKeyDown(){
	var Key=websys_getKey(e);
	if ((13==Key)) {
		QueryPat();
		return ;
	}
}
///作者:汪福建
///创建时间:2009-02-23
///功能描述:姓名上按回车的监听事件
function PIBINameKeyDown(){
	var Key=websys_getKey(e);
	if ((13==Key)) {
		QueryPat();
		return ;
	}
}
///作者:汪福建
///创建时间:2009-02-23
///功能描述:按登记号查询病人信息
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
///作者:汪福建
///创建时间:2009-02-23
///功能描述:查询所有的有发票打印名称的病人
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
///作者?汪福建
///创建时间?2009-02-23
///功能描述?完成更新操作?没有别名则插入别名
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
		//actionType为U表示更新
		var actionType="U"
		var returnValue=cspRunServerMethod(objIns,"U",objRegNo,objInvoiceName);
		
	}
	if (returnValue==1){
		alert(t['updateSuccess']);
	}else{
		alert(t['updateFailed']);
	}
}
///作者:汪福建
///创建时间:2009-02-23
///功能描述:删除打印发票名称
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
		//actionType为D表示删除
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
///作者:汪福建
///创建时间:2009-02-23
///功能描述:清空元素的内容为空

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