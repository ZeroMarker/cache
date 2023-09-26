function InitViewportEvents(obj)
{
	obj.LoadEvents = function()
	{
		obj.btnQuery.on('click',obj.btnQuery_click,obj);
		obj.txtMrNo.on('specialkey',obj.txt_specialkey,obj);
		obj.txtPapmiNo.on('specialkey',obj.txt_specialkey,obj);
		obj.txtBarCode.on('specialkey',obj.txt_specialkey,obj);
		obj.txtInvNo.on('specialkey',obj.txt_specialkey,obj);
		obj.gridCopy.on('rowdblclick',obj.gridCopy_rowdblclick,obj);
		
		obj.cboHospital.on("select",obj.cboHospital_select,obj);
		obj.cboHospital.setValue(CTHospID);
		obj.cboHospital.setRawValue(CTHospDesc);
		obj.cboHospital_select();
		
		obj.txtBarCode.focus(true);
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
	
	obj.gridCopy_rowdblclick = function()
	{
		var selectObj = obj.gridCopy.getSelectionModel().getSelected();
		var RecordID = selectObj.get("CopyRecordID");
		var win = new InitEditViewport(RecordID);
		win.EditViewport.show();
	}
	
	obj.txt_specialkey = function(field,e)
	{
		if (e.getKey() != Ext.EventObject.ENTER) return;
		obj.gridCopyStore.load({
			callback:function(){
				if (this.getCount()!=1) return;
				this.each(function(rd){
					var RecordID = rd.get("CopyRecordID");
					var win = new InitEditViewport(RecordID);
					win.EditViewport.show();
				});
			}
		});
		obj.cleanCondition();
	}
	
	obj.btnQuery_click = function()
	{
		Common_LoadCurrPage('gridCopy',1);
		obj.cleanCondition();
	}
	
	obj.cleanCondition = function()
	{
		Common_SetValue("txtMrNo","");
		Common_SetValue("txtBarCode","");
		Common_SetValue("txtPapmiNo","");
		Common_SetValue("txtInvNo","");
		obj.txtBarCode.focus(true);
	}
	
	obj.DisplayDetailWindow = function(RecordID)
	{
		var win = new InitDetailViewport(RecordID);
		win.DetailViewport.show();
	}
}