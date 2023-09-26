function InitViewscreenEvent(obj) {
	obj.LoadEvent = function()
  {
  	};
	obj.btnNew_click = function()
	{
		var objWinEdit = new InitwinScreen();
		objWinEdit.winScreen.show();
		ExtDeignerHelper.HandleResize(objWinEdit);
	};
	obj.btnEdit_click = function()
	{			
		obj.EditFunction();				
	};
	obj.gridList_rowdblclick = function()
	{
		obj.EditFunction();		
	};
	/*
	*编辑
	*/
	obj.EditFunction = function(){
		var selectObj = obj.gridList.getSelectionModel().getSelected();
		if (selectObj){
			var objWinEdit = new InitwinScreen(selectObj);
			objWinEdit.txtFunctionName.setReadOnly(true);
			objWinEdit.winScreen.show();
		}
		else{
			ExtTool.alert("提示","请先选中一行!");
		}		
	};
}
function InitwinScreenEvent(obj) {
	var parent=objControlArry['Viewscreen'];
	obj.LoadEvent = function(){
		var data = arguments[0][0];
  		if (data){
  			var objFunction = ExtTool.StaticServerObject("DHCMed.CR.BO.FunctionService");
			var ret = objFunction.GetStringById(data.get("ID"));
			if (ret==-1) 
			{
				ExtTool.alert("提示","接口信息不存在!");
				return;
			}			
			var Str=ret.split("^");
			obj.txtFunctionID.setValue(Str[0]);			
			obj.txtFunctionName.setValue(Str[1]);
			obj.txtCaption.setValue(Str[2]);
			obj.txtType.setValue(Str[3]);
			obj.txtData.setValue(Str[4]);
			obj.txtDescription.setValue(Str[5]);			
  		}
	};
	obj.winfBtnSave_click = function()
	{

		var objFunction = ExtTool.StaticServerObject("DHCMed.CR.BO.FunctionService");
		var tmp = obj.txtFunctionID.getValue()+"^";
		tmp += obj.txtFunctionName.getValue() + "^";
		tmp += obj.txtCaption.getValue() + "^";
		tmp += obj.txtType.getValue() + "^";
		tmp += obj.txtData.getValue() + "^";
		tmp += obj.txtDescription.getValue() ;
	//	ExtTool.alert(tmp);
		try
		{
			var NewID = objFunction.update(tmp);
			//window.alert(NewID);
			if(NewID<0) {
				ExtTool.alert("提示","保存失败！");
				return;
				}
			obj.txtFunctionID.setValue(NewID);
			obj.winScreen.close();
			//parent.GridPanelStore.removeAll();
			parent.gridListStore.load();
			
		}catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
	};
	obj.winfPBtnCancle_click = function()
	{
		obj.winScreen.close();
	};
}

