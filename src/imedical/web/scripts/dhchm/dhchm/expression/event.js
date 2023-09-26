
function InitWindowExEvent(obj) {
	
	var TableEx = ExtTool.StaticServerObject("web.DHCHM.ExpressionSet");
	obj.LoadEvent = function(args)
  {};
	obj.ExSave_click = function()
	{
		if(obj.ECQuestionnaireDR.getValue()=="") {
			ExtTool.alert("��ʾ","�ʾ���Ϊ�գ�");
			return;
		}
		
    var id = obj.ExID.getValue();

		var property = 'EAgeMax^EAgeMin^ECQuestionnaireDR^EExpression^EExpressionType^EParameters^ERemark^ESex^ESourceID^EType^EUnit';
		
		var tmp = ExtTool.GetValuesByIds(property);
	
		try
		{  
			var ret = TableEx.ExSave(id,tmp,property);	
			if(ret.split("^")[0] == -1) {
				ExtTool.alert("ʧ��",ret.split("^")[1]);
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
		//obj.FormPanelEx.buttons[0].setText('���');
		obj.ESourceID.setValue(ESourceID);
		obj.EType.setValue(EType);
		obj.ECQuestionnaireDR.focus(true,3);
	};
	obj.ExDelete_click = function()
	{
		
		var id = obj.ExID.getValue();
		if(id == "") {
			ExtTool.alert("��ʾ","��ѡ��һ����¼��");
			return;
		}
		try
		{  
			var ret = TableEx.ExDelete(id);	
			if(ret.split("^")[0] == -1) {
				ExtTool.alert("ʧ��",ret.split("^")[1]);
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
		//obj.FormPanelEx.buttons[0].setText('����');
		
	};
/*WindowEx��������ռλ��*/












































































































































































































































































}

