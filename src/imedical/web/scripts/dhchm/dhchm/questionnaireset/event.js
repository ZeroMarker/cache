
function InitViewportQNEvent(obj) {
	
	var Table = ExtTool.StaticServerObject("web.DHCHM.QuestionnaireSet");
	
	obj.LoadEvent = function(args)
  {};
	obj.QNClear_click = function()
	{
		obj.FormPanelQN.getForm().reset();
		obj.QCode.focus(true,3);
		//obj.FormPanelQN.buttons[0].setText('添加');
	};
	obj.QNSave_click = function()
	{
		/*
		if(obj.QCode.getValue()=="") {
			ExtTool.alert("提示","编码不能为空！");
			return;
		}
		
		if(obj.QDesc.getValue()=="") {
			ExtTool.alert("提示","描述不能为空！");
			return;
		}
		*/
		if(!obj.FormPanelQN.getForm().isValid()) {
			ExtTool.alert("提示","请检查必填项！");
			return;
		}
		
    	var id = obj.QNID.getValue();
    
		var property = 'QActive^QCode^QDesc^QRemark^QType';
		
		var tmp = ExtTool.GetValuesByIds(property);
		
		try
		{       
			var ret = Table.QNSave(id,tmp,property);	
			if(ret.split("^")[0] == -1) {
				ExtTool.alert("失败",ret.split("^")[1]);
				return;
			}
			else{
				//obj.GridPanelQNStore.load();
				obj.QNID.setValue(ret);
				ExtTool.FormToGrid(id,obj.GridPanelQN,obj.FormPanelQN);
				obj.QNClear_click();
			}
		}catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
	};
	obj.GridPanelQN_rowclick = function(g, row, e)
	{
		var record = obj.GridPanelQNStore.getAt(row);
		obj.FormPanelQN.getForm().loadRecord(record);
		//obj.FormPanelQN.buttons[0].setText('更新');
		obj.QSParRef.setValue(obj.QNID.getValue());
		obj.GridPanelQSStore.load();
		obj.QSClear_click();
		obj.QEDLParRef.setValue(obj.QNID.getValue());
		obj.GridPanelEDLStore.load();
		obj.EDLClear_click();
	
	};
	obj.QSSave_click = function()
	{
		/*
		if(obj.QSCode.getValue()=="") {
			ExtTool.alert("提示","编码不能为空！");
			return;
		}
		*/
		if(obj.QSParRef.getValue()=="") {
			ExtTool.alert("提示","请选择一个问卷！");
			return;
		}
		
		if(!obj.FormPanelQS.getForm().isValid()) {
			ExtTool.alert("提示","请检查必填项！");
			return;
		}
		
    	var id = obj.QSID.getValue();
    
		var property = 'QSActive^QSCode^QSDesc^QSOrder^QSParRef^QSRemark';
		
		var tmp = ExtTool.GetValuesByIds(property);
		
		try
		{       
			var ret = Table.QSSave(id,tmp,property);	
			if(ret.split("^")[0] == -1) {
				ExtTool.alert("失败",ret.split("^")[1]);
				return;
			}
			else{
				//obj.GridPanelQSStore.load();
				obj.QSID.setValue(ret);
				ExtTool.FormToGrid(id,obj.GridPanelQS,obj.FormPanelQS);
				obj.QSClear_click();
			}
		}catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
	};
	obj.QSClear_click = function()
	{
		var QSParRef=obj.QSParRef.getValue();
		obj.FormPanelQS.getForm().reset();
		//obj.FormPanelQS.buttons[0].setText('添加');
		obj.QSParRef.setValue(QSParRef);
		obj.QSCode.focus(true,3);
	};
	obj.GridPanelQS_rowclick = function(g ,row, e)
	{
		var record = obj.GridPanelQSStore.getAt(row);
		obj.FormPanelQS.getForm().loadRecord(record);
		//obj.FormPanelQS.buttons[0].setText('更新');
		obj.SDLParRef.setValue(obj.QSID.getValue());
		obj.GridPanelSDLStore.load();
		obj.SDLClear_click();
		
	};
	obj.SDLSave_click = function()
	{
		if(!obj.FormPanelSDL.getForm().isValid()) {
			ExtTool.alert("提示","请检查必填项！");
			return;
		}
   		var id = obj.SDLID.getValue();
    
		var property = 'SDLActive^SDLOrder^SDLParRef^SDLQuestionsDetailDR';
		
		var tmp = ExtTool.GetValuesByIds(property);

		try
		{       
			var ret = Table.SDLSave(id,tmp,property,obj.SDLParRef.getValue(),obj.SDLQuestionsDetailDR.getValue());	
			if(ret.split("^")[0] == -1) {
				ExtTool.alert("失败",ret.split("^")[1]);
				return;
			}
			else{
				//obj.GridPanelSDLStore.load();
				obj.QDDesc.setValue(obj.SDLQuestionsDetailDR.getRawValue());
				obj.SDLID.setValue(ret);
				ExtTool.FormToGrid(id,obj.GridPanelSDL,obj.FormPanelSDL);
				obj.SDLClear_click();
			}
		}catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
	};
	obj.SDLClear_click = function()
	{
		var SDLParRef=obj.SDLParRef.getValue();
		obj.FormPanelSDL.getForm().reset();
		//obj.FormPanelSDL.buttons[0].setText('添加');
		obj.SDLParRef.setValue(SDLParRef);
		obj.SDLQuestionsDetailDR.focus(true,3);
	};
	obj.GridPanelSDL_rowclick = function(g, row, e)
	{
		var record = obj.GridPanelSDLStore.getAt(row);
		obj.FormPanelSDL.getForm().loadRecord(record);
		//obj.FormPanelSDL.buttons[0].setText('更新');
		
	};
	obj.EDLSave_click = function()
	{
		
		if(!obj.FormPanelEDL.getForm().isValid()) {
			ExtTool.alert("提示","请检查必填项！");
			return;
		}
		
		var id = obj.EDLID.getValue();
    
		var property = 'QEDLActive^QEDLCalculateOrder^QEDLEvaluationDetailDR^QEDLOrder^QEDLParRef';
		
		var tmp = ExtTool.GetValuesByIds(property);

		try
		{       
			var ret = Table.EDLSave(id,tmp,property,obj.QEDLParRef.getValue(),obj.QEDLEvaluationDetailDR.getValue());	
			if(ret.split("^")[0] == -1) {
				ExtTool.alert("失败",ret.split("^")[1]);
				return;
			}
			else{
				//obj.GridPanelEDLStore.load();
				obj.EDDesc.setValue(obj.QEDLEvaluationDetailDR.getRawValue());
				obj.EDLID.setValue(ret);
				ExtTool.FormToGrid(id,obj.GridPanelEDL,obj.FormPanelEDL);
				obj.EDLClear_click();
			}
		}catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
	};
	obj.EDLClear_click = function()
	{
		var EDLParRef=obj.QEDLParRef.getValue();
		obj.FormPanelEDL.getForm().reset();
		//obj.FormPanelEDL.buttons[0].setText('添加');
		obj.QEDLParRef.setValue(EDLParRef);
		obj.QEDLEvaluationDetailDR.focus(true,3);
	};
	obj.GridPanelEDL_rowclick = function(g,row,e)
	{
		var record = obj.GridPanelEDLStore.getAt(row);
		obj.FormPanelEDL.getForm().loadRecord(record);
		//obj.FormPanelEDL.buttons[0].setText('更新');
	};
/*ViewportQN新增代码占位符*/































































































































































































































































































































































































































}

