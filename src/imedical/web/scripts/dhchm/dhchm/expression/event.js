
function InitWindowExEvent(obj) {
	
	var TableEx = ExtTool.StaticServerObject("web.DHCHM.ExpressionSet");
	obj.LoadEvent = function(args)
  {};
	obj.ExSave_click = function()
	{
		if(obj.ECQuestionnaireDR.getValue()=="") {
			ExtTool.alert("提示","问卷不能为空！");
			return;
		}
		
    var id = obj.ExID.getValue();

		var property = 'EAgeMax^EAgeMin^ECQuestionnaireDR^EExpression^EExpressionType^EParameters^ERemark^ESex^ESourceID^EType^EUnit';
		
		var tmp = ExtTool.GetValuesByIds(property);
	
		try
		{  
			var ret = TableEx.ExSave(id,tmp,property);	
			if(ret.split("^")[0] == -1) {
				ExtTool.alert("失败",ret.split("^")[1]);
				return;
			}
			else{
				obj.GridPanelExStore.load();
				obj.ExClear_click();
			}
		}catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
	};
	obj.ExClear_click = function()
	{
		var ESourceID = obj.ESourceID.getValue();
		var EType = obj.EType.getValue();
		obj.FormPanelEx.getForm().reset();
		//obj.FormPanelEx.buttons[0].setText('添加');
		obj.ESourceID.setValue(ESourceID);
		obj.EType.setValue(EType);
		obj.ECQuestionnaireDR.focus(true,3);
	};
	obj.ExDelete_click = function()
	{
		
		var id = obj.ExID.getValue();
		if(id == "") {
			ExtTool.alert("提示","请选择一条记录！");
			return;
		}
		try
		{  
			var ret = TableEx.ExDelete(id);	
			if(ret.split("^")[0] == -1) {
				ExtTool.alert("失败",ret.split("^")[1]);
				return;
			}
			else{
				obj.GridPanelExStore.load();
			}
		}catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
		
	};
	obj.GridPanelEx_rowclick = function(g,row,e)
	{
		var record = g.getStore().getAt(row);
		obj.FormPanelEx.getForm().loadRecord(record);
		//obj.FormPanelEx.buttons[0].setText('更新');
		
	};
/*WindowEx新增代码占位符*/












































































































































































































































































}

