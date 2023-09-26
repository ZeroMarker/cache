function InitViewportEvents(obj)
{
	obj.LoadEvents = function ()
	{
		obj.cboHospital.on("select",obj.cboHospital_select,obj);
		obj.btnQuery.on('click',obj.btnQuery_click,obj);
		obj.cboHospital.setValue(CTHospID);
		obj.cboHospital.setRawValue(CTHospDesc);
		obj.cboHospital_select();
	}
	
	obj.cboHospital_select = function(combo,record,index){
		//加载病案类型
		obj.cboMrType.getStore().removeAll();
		obj.cboMrType.getStore().load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0) {
						obj.cboMrType.setValue(r[0].get("MrTypeID"));
						obj.cboMrType.setRawValue(r[0].get("MrTypeDesc"));
					}
				}
			}
		});
	}
	
	obj.btnQuery_click = function()
	{
		Common_LoadCurrPage('FeeRecordList',1);
	}
}