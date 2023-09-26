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
		obj.EditInterface();				
	};
	obj.gridList_rowdblclick = function()
	{
		obj.EditInterface();		
	};
	/*
	*编辑
	*/
	obj.EditInterface = function(){
		var selectObj = obj.gridList.getSelectionModel().getSelected();
		if (selectObj){
			var objWinEdit = new InitwinScreen(selectObj);
			objWinEdit.txtInterfaceCode.disable(); //setReadOnly(true);
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
  			var objInterface = ExtTool.StaticServerObject("DHCMed.CR.BO.InterService");
				var ret = objInterface.GetStringById(data.get("ID"));
				if (ret==-1) 
				{
					ExtTool.alert("提示","接口信息不存在!");
					return;
				}			
				var Str=ret.split("^");
				obj.txtInterfaceID.setValue(Str[0]);
				//obj.txtCategory.setValue(Str[1]);
				obj.txtInterfaceCode.setValue(Str[2]);
				obj.txtInterfaceName.setValue(Str[3]);
				obj.txtArguments.setValue(Str[4]);
				obj.txtClassName.setValue(Str[5]);
				obj.txtReturnType.setValue(Str[6]);	
				ExtTool.AddComboItem(obj.txtCategory,Str[7],Str[1]);		
  		}
	};
	obj.winfBtnSave_click = function()
	{

		var objInterface = ExtTool.StaticServerObject("DHCMed.CR.BO.InterService");
		var tmp = obj.txtInterfaceID.getValue()+"^";
		tmp += obj.txtCategory.getValue() + "^";
		tmp += obj.txtInterfaceCode.getValue() + "^";
		tmp += obj.txtInterfaceName.getValue() + "^";
		tmp += obj.txtArguments.getValue() + "^";
		tmp += obj.txtClassName.getValue() + "^";
		tmp += obj.txtReturnType.getValue() ;
	//	ExtTool.alert(tmp);
		try
		{
			var NewID = objInterface.update(tmp);
			//window.alert(NewID);
			if(NewID<0) {
				ExtTool.alert("提示","保存失败！");
				return;
				}
			obj.txtInterfaceID.setValue(NewID);
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

