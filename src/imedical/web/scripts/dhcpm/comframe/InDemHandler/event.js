//指定审核人事件
var UserIDStr="";
function InHandleSubScreenEvent(obj) {
	obj.LoadEvent = function(){
		obj.btnConfirm.on("click", obj.btnConfirm_click, obj);
	obj.btnCancel.on("click", obj.btnCancel_click, obj);
	
	obj.cboAuditUser.on("select", obj.cboAuditUser_click, obj);
	
	
	
};
obj.cboAuditUser_click=function()
{
	//alert(obj.cboAuditUser.getRawValue());
	var userName=obj.cboAuditUser.getRawValue();
	
	if (obj.textHandleStr.getValue()=="")
	{
		obj.textHandleStr.setValue(userName);
		UserIDStr=obj.cboAuditUser.getValue();
	}
	else
	{
		var handleStr=obj.textHandleStr.getValue();
		var handStrArray=handleStr.split(",");
		for(var i=0;i<handStrArray.length;i++)
		{
			if (handStrArray[i]==userName)
			{
				Ext.MessageBox.alert('Status','添加的人员重复');
				return false;
			}
		}
		
			obj.textHandleStr.setValue(obj.textHandleStr.getValue()+","+userName);
			UserIDStr=UserIDStr+","+obj.cboAuditUser.getValue();	
		    
		
	}
	
	
	
	
	
}


 obj.btnConfirm_click=function()
{
	//alert("分配人审核人");
	var DemandID=obj.DemandID.getValue();
	var AuditUserID=obj.cboAuditUser.getValue();
	//alert(AuditUserID);
	var note=obj.winAudiResult.getValue();
	var statusCode=obj.StatusCode.getValue();
	
	//alert(DemandID+"^"+statusCode+"^"+note);
	
	alert(UserIDStr);
	var objAudit = ExtTool.StaticServerObject("DHCPM.Audit.PMAudit");
	//var str=DemandID+"^"+AuditUserID+"^"+note+"^"+"024";  
	var str=DemandID+"^"+UserIDStr+"^"+note+"^"+"024";
	//alert(UserIDStr);
	var  distriRet=objAudit.InSubmit(str);
	//var  distriRet=objAudit.adjustStatusSave(str);
	
	if ('0'==distriRet)
	{
		Ext.MessageBox.alert('Status','指定处理人成功！');
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