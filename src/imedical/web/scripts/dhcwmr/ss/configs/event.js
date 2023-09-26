function InitViewport1Event(obj) {

	obj.LoadEvent = function() {
		obj.GridPanel.on("rowdblclick", obj.GridPanel_rowdblclick, obj);
		obj.btnNew.on("click", obj.btnNew_click, obj);
		obj.btnEdit.on("click", obj.btnEdit_click, obj);
		obj.btnDelete.on("click", obj.btnDelete_click, obj);
		obj.GridPanelStore.load({});
	};
	
	obj.GridPanel_rowdblclick = function()
	{
		obj.ConfigEdit();
	};
	obj.btnNew_click = function()
	{
		 var objWinEdit = new InitWinEdit();
         objWinEdit.WinEdit.show();
         objWinEdit.winhidden.setValue("");
	};
	
	obj.btnDelete_click = function()
	{
		var objGrid = Ext.getCmp("GridPanel");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if (arrRec.length>0){
				Ext.MessageBox.confirm('删除', '是否删除选中配置项?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							var RowID = objRec.get("Id");
							var flg = ExtTool.RunServerMethod("DHCWMR.SS.Config","DeleteById",RowID);
						
							if (parseInt(flg) < 0) {
								ExtTool.alert("错误提示","删除数据错误!Error=" + flg);
							} else {
								objGrid.getStore().remove(objRec);
							}
						}
					}
				});
			} else {
				ExtTool.alert("提示","请选中数据记录,再点击删除!");
			}
		}
	}
	
	obj.btnEdit_click = function()
	{
		obj.ConfigEdit();
	};
	
	/*
	*配置项编辑
	*/
	obj.ConfigEdit = function() {
		var selectObj = obj.GridPanel.getSelectionModel().getSelected();
		if (selectObj){
			var objWinEdit = new InitWinEdit(selectObj);
			objWinEdit.WinEdit.show();
		}
		else{
			ExtTool.alert("提示","请先选中一行!");
		}		
	}
}
function InitWinEditEvent(obj) {
	
	var objConfig1 = ExtTool.StaticServerObject("DHCWMR.SS.Config");
  	var objConfig2 = ExtTool.StaticServerObject("DHCWMR.SSService.ConfigSrv");
  	var parent=objControlArry['Viewport1'];	
	
	obj.LoadEvent = function()
	{		
  		if (obj.objConfig){
			obj.Keys.setValue(obj.objConfig.get("Keys"));
			obj.Description.setValue(obj.objConfig.get("Description"));
			obj.Value.setValue(obj.objConfig.get("Value"));
  			obj.ValueDesc.setValue(obj.objConfig.get("ValueDesc"));
			obj.Resume.setValue(obj.objConfig.get("Resume"));
			ExtTool.AddComboItem(obj.HispsDescs,obj.objConfig.get("HospDesc"),obj.objConfig.get("HospId"));
			
        }
	};
	obj.btnSave_click = function()
	{
		var CHR_1=String.fromCharCode(1);
		var hospital = obj.HispsDescs.getValue();
		if(obj.Keys.getValue()=="")
		{
			ExtTool.alert("提示","键不能为空!");
			return;			
		}
		if(obj.Value.getValue()=="")
		{
			ExtTool.alert("提示","值不能为空!");
			return;
		}
		if(obj.Description.getValue()=="")
		{
			ExtTool.alert("提示","描述不能为空!");
			return;			
		}
		
        var CHR_1=String.fromCharCode(1);
        var separate=CHR_1;
		var configId="";
		if(obj.objConfig)
		{
			configId=obj.objConfig.get("Id");
	    }		
		var tmp = configId+ separate;
		tmp += obj.Keys.getValue()+ separate;
		tmp += obj.Description.getValue() + separate;
		tmp += obj.Value.getValue() + separate;
		tmp += obj.ValueDesc.getValue() + separate;
		tmp += hospital + separate;
		tmp += obj.Resume.getValue() + separate;
		
		var ret = objConfig1.Update(tmp,separate);
		if(parseInt(ret)<1) {
			if (parseInt(ret) == -100){
				ExtTool.alert("提示","键值重复，不允许保存！");
			} else {
				ExtTool.alert("提示","保存失败！");
			}
			return;
		} else {
			obj.WinEdit.close();
			parent.GridPanelStore.load({params : {start:0,limit:1000}});
		}
	};
	obj.btnCancel_click = function()
	{
		obj.WinEdit.close();
		parent.GridPanelStore.load({});
	};

	
}

