
function InitViewport32Event(obj) {
	obj.LoadEvent = function()
  {};
	obj.vGridPanel_rowclick = function()
	{
		var rowIndex = arguments[1];
		var objRec = obj.vGridPanelStore.getAt(rowIndex);
		if(objRec.get("rowid")==obj.ICRowid.getValue())
		{
			obj.ICRowid.setValue("");
			obj.ICCode.setValue("");
			obj.ICDesc.setValue("");
			ExtTool.AddComboItem (obj.SubjectDr, "","")
			obj.SubjectDrStore.removeAll();
			obj.SubjectDrStore.load();
			return;
		}
		  obj.SubjectDrStore.removeAll();
			obj.SubjectDrStore.load();
			obj.ICRowid.setValue(objRec.get("rowid"));
			obj.ICCode.setValue(objRec.get("ICCode"));
			obj.ICDesc.setValue(objRec.get("ICDesc"));
			ExtTool.AddComboItem (obj.SubjectDr,objRec.get("title"), objRec.get("SubjectDr"))
	};
	obj.vGridPanel_rowdblclick = function()
	{
		obj.EditItemCat();
	};
	obj.btnFind_click = function()
	{
		obj.vGridPanelStore.load({params : {start:0,limit:20}});
	};
	obj.btnSave_click = function()
	{
		if((obj.ICCode.getValue()=="")||(obj.ICDesc.getValue()=="")||(obj.SubjectDr.getValue()==""))
			{
				ExtTool.alert("提示","代码、描述、监控主题都不能为空!");
				return;	
			}

			var tmp = obj.ICRowid.getValue();
			tmp += "^" + obj.ICCode.getValue();
			tmp += "^" + obj.ICDesc.getValue();
			tmp += "^" + obj.SubjectDr.getValue();
			var objItemCat = ExtTool.StaticServerObject("DHCMed.CC.ItemCat");
			try
			{
				var ret = objItemCat.Update(tmp);
				obj.ICRowid.setValue("");
				obj.ICCode.setValue("");
				obj.ICDesc.setValue("");
				ExtTool.AddComboItem (obj.SubjectDr, "","")
				obj.vGridPanelStore.load({params : {start:0,limit:20}});
			}catch(err)
			{
				ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			}
	};
	obj.btnEdit_click = function()
	{
		obj.EditItemCat();
	};
	obj.btnDelete_click = function()
	{
		var cICRowid=obj.ICRowid.getValue();
	 	if(cICRowid=="")
	 	{
	 		ExtTool.alert("提示","请先选中一行！");
	 		return;
	 	}
		ExtTool.confirm('选择框','确定删除?',function(btn){
            if(btn=="no") return;
                	
            var objIC = ExtTool.StaticServerObject("DHCMed.CCService.ItemCatSrv");
			var ret = objIC.DelInfoFromICId(cICRowid);
			if(ret==1)
				{
					obj.ICRowid.setValue("");
					obj.ICCode.setValue("");
					obj.ICDesc.setValue("");
					ExtTool.AddComboItem (obj.SubjectDr, "","")
					obj.vGridPanelStore.load({params : {start:0,limit:20}});

					return;
				}
	 		if(ret!=1)
	 			{
	 				ExtTool.alert("提示","删除失败!");
	 				return;	
	 			}
           	});
	};
	obj.EditItemCat = function(){		
		var selectObj = obj.vGridPanel.getSelectionModel().getSelected();
		if (selectObj){
			var objEdit = new InitwinEdit(selectObj);
			
			objEdit.tICRowid.setValue(selectObj.get("rowid"));
			objEdit.wGridPanelStore.load({params : {start:0,limit:20}});
			
			objEdit.winEdit.show();
		}
		else{
			ExtTool.alert("提示","请先选中一行!");
		}
	}
}
function InitwinEditEvent(obj) {
	var parent=objControlArry['Viewport32'];
	obj.LoadEvent = function()
  	{
  		
  	};
	obj.wGridPanel_rowclick = function()
	{
		var rowIndex = arguments[1];
		var objRec = obj.wGridPanelStore.getAt(rowIndex);
		if(objRec.get("rowid")==obj.ISCRowid.getValue())
		{
			obj.ISCRowid.setValue("");
			obj.ISCCode.setValue("");
			obj.ISCDesc.setValue("");

			return;
		}
			obj.ISCRowid.setValue(objRec.get("rowid"));
			obj.ISCCode.setValue(objRec.get("ISCCode"));
			obj.ISCDesc.setValue(objRec.get("ISCDesc"));
	};
	obj.winBtnSave_click = function()
	{
		if((obj.ISCCode.getValue()=="")||(obj.ISCDesc.getValue()==""))
			{
				ExtTool.alert("提示","代码、描述都不能为空!");
				return;	
			}

			var tmp = obj.ISCRowid.getValue();
			tmp += "^" + obj.ISCCode.getValue();
			tmp += "^" + obj.ISCDesc.getValue();
			tmp += "^" + obj.tICRowid.getValue();
		
			var objItemSubCat = ExtTool.StaticServerObject("DHCMed.CC.ItemSubCat");
			try
			{
				var ret = objItemSubCat.Update(tmp);
				obj.ISCRowid.setValue("");
				obj.ISCCode.setValue("");
				obj.ISCDesc.setValue("");
				obj.wGridPanelStore.load({params : {start:0,limit:20}});
			}catch(err)
			{
				ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			}
	};
	obj.winBtnDelete_click = function()
	{
		var selectObj = obj.wGridPanel.getSelectionModel().getSelected();
		if (selectObj){
			var objItemSubCat = ExtTool.StaticServerObject("DHCMed.CC.ItemSubCat");
			var ret=objItemSubCat.DeleteById(selectObj.get("rowid"));
			if(ret==0)
				{
					obj.wGridPanelStore.load({params : {start:0,limit:20}});
					obj.ISCRowid.setValue("");
					obj.ISCCode.setValue("");
					obj.ISCDesc.setValue("");
					return;	
				}
			else {
					 ExtTool.alert("提示","删除失败!!");
					 return;
				 }
		}
		else{
			ExtTool.alert("提示","请先选中一行!");
		}		
	};
	obj.winBtnExit_click = function()
	{
		obj.winEdit.close();
	};
/*新增代码占位符*/
}

