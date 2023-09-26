
//指定审核人事件
function toAuditSubScreenEvent(obj) {
	obj.LoadEvent = function(){
		obj.btnConfirm.on("click", obj.btnConfirm_click, obj);
	obj.btnCancel.on("click", obj.btnCancel_click, obj);
	
	
	
};
 obj.btnConfirm_click=function()
{
	//alert("分配人审核人");
	var DemandID=obj.DemandID.getValue();
	var AuditUserID=obj.cboAuditUser.getValue();
	//alert(AuditUserID);
	var note=obj.winAudiResult.getValue();
	var statusCode=obj.StatusCode.getValue();
	
	//alert(DemandID+"^"+statusCode+"^"+note);
	
	
	var objAudit = ExtTool.StaticServerObject("DHCPM.Audit.PMAudit");
	var str=DemandID+"^"+AuditUserID+"^"+note+"^"+"005";
	//alert(str);
	var  distriRet=objAudit.appointAuditor1(str);
	//var  distriRet=objAudit.adjustStatusSave(str);
	
	if ('0'==distriRet)
	{
		Ext.MessageBox.alert('Status','指定审核人成功！');
	}
	else
	{
		Ext.MessageBox.alert('Status','保存失败'+distriRet);
	}
	
	obj.winScreen.close();
	ExtTool.LoadCurrPage('DtlDataGridPanel');
	
	
}

obj.btnCancel_click=function()
{
	obj.winScreen.close();
	ExtTool.LoadCurrPage('DtlDataGridPanel'); 
	
	
} 
	
	
	
}