//FileName:DHCPEPreAudit.Common.JS
//Created by SongDeBo 2006/6/28
//Description: 团体/个人审核的共用JS文件, 使用时需设置gUI的相关值
//

///Description: 
function AuditUIData(){
	this.NameBtnAudit="btnAudit";
	this.NameBtnCancelAudit="btnCancelAudit";

	this.NameTxtAccountAmount="txtAccountAmount";
	this.NameTxtDiscountAmount="txtDiscountedAmount";
	this.NameTxtSaleAmount="txtSaleAmount";
	this.NameTxtFactAmount="txtFactAmount";
	
	this.NameBoxAudit="txtAuditBox";
	this.NameBoxCancelAudit="txtCancelAuditBox";
	this.NameBoxGetAmount="txtGetAmountBox";
	this.NameColAdmId="TAdmIdz";
	this.NameColStatus="TStatusz";
}
function AuditData(){
	this.RowIndex=0;
	this.UersId=session['LOGON.USERID'];
	this.TableName="";
	this.AdmType="";  //"PRESON"/"GROUP"
}

var gUI=new AuditUIData();
var gData=new AuditData();

function Ini(){
	var obj=document.getElementById(gUI.NameBtnAudit);
	obj.onclick=btnAudit_Click;
	var obj=document.getElementById(gUI.NameBtnCancelAudit);
	obj.onclick=btnCancelAudit_Click;
	
	//审核
	var obj=document.getElementById("btnAudit");
	if (obj) { obj.disabled=true; }	
	//取消审核
	var obj=document.getElementById("btnCancelAudit");
	if (obj) { obj.disabled=true; }	

}

function btnAudit_Click(){
	if (!(gData.RowIndex>0)) {alert(t['NotSelected']); return false;}
		
	var svrCode=GetCtlValueById(gUI.NameBoxAudit);
	var oldStatus=GetCtlValueById(gUI.NameColStatus+gData.RowIndex,1)
	if (oldStatus!="PREREG") {alert(t['ErrStatus']); return false;}
	var admId=GetCtlValueById(gUI.NameColAdmId + gData.RowIndex,1);
	var factAmount=GetCtlValueById(gUI.NameTxtFactAmount);
	factAmount=Val(factAmount);
	//alert("admId:"+admId+"  gData.AdmType:"+gData.AdmType+"  factAmount:"+factAmount+"  gData.UersId:"+gData.UersId)
	var retVal=cspRunServerMethod(svrCode,admId,gData.AdmType,factAmount,gData.UersId);  //return:  AccountAmount^DiscountAmount^aactAmount
	if (retVal!=""){alert(t['ErrAudit']+"  "+retVal); return false}
	
	document.location.reload();
	return false;
}

function btnCancelAudit_Click(){
	if (!(gData.RowIndex>0)) {alert(t['NotSelected']); return false;}
		
	var svrCode=GetCtlValueById(gUI.NameBoxCancelAudit);
	
	var oldStatus=GetCtlValueById(gUI.NameColStatus+gData.RowIndex,1)
	if (oldStatus!="CHECKED") {alert(t['ErrStatus']); return false;}
	var admId=GetCtlValueById(gUI.NameColAdmId+gData.RowIndex,1);
	
	var retVal=cspRunServerMethod(svrCode,admId,gData.AdmType,gData.UersId);  //return:  AccountAmount^DiscountAmount^aactAmount
	if (retVal!=""){alert(t['ErrAudit']+"  "+retVal); return false}
	
	document.location.reload();
	return false;
}

function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	//触发事件的
	var objtbl=document.getElementById(gData.TableName);	//取表格元素?名称
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	gData.RowIndex=rowObj.rowIndex;
	var admId=GetCtlValueById(gUI.NameColAdmId + gData.RowIndex,0);
	ShowAdmAmount(admId);
	var iStatus=GetCtlValueById(gUI.NameColStatus + gData.RowIndex,0);

	//审核
	var obj=document.getElementById("btnAudit");
	if (obj && "PREREG"==iStatus) { obj.disabled=false; }
	else { obj.disabled=true; }
	
	//取消审核
	var obj=document.getElementById("btnCancelAudit");
	if (obj && "CHECKED"==iStatus) { obj.disabled=false; }		
	else { obj.disabled=true; }
}

function ShowAdmAmount(admId){

	var svrCode=GetCtlValueById("txtGetAmountBox");
	var retVal=cspRunServerMethod(svrCode,admId,gData.AdmType);  //return:  AccountAmount^DiscountAmount^aactAmount
	var retList=retVal.split("^");
	SetCtlValueByID(gUI.NameTxtAccountAmount,retList[0],1);
	SetCtlValueByID(gUI.NameTxtDiscountAmount,retList[1],1);
	SetCtlValueByID(gUI.NameTxtSaleAmount,retList[2],1);
	SetCtlValueByID(gUI.NameTxtFactAmount,retList[3],1);

}