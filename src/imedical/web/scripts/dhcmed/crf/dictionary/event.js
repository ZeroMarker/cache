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
		obj.EditDic();				
	};
	obj.gridList_rowdblclick = function()
	{
		obj.EditDic();		
	};
	/*
	*编辑
	*/
	obj.EditDic = function(){
		var selectObj = obj.gridList.getSelectionModel().getSelected();
		if (selectObj){
			var objWinEdit = new InitwinScreen(selectObj);
			objWinEdit.txtDicCode.setReadOnly(true);
			//objWinEdit.txtDicCode.setDisabled(true);
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
  			var objDic = ExtTool.StaticServerObject("DHCMed.CR.BO.Dictionary");
			var ret = objDic.GetStringById(data.get("ID"));
			if (ret==-1) 
			{
				ExtTool.alert("提示","字典信息不存在!");
				return;
			}			
			var Str=ret.split("^");
			obj.txtDicID.setValue(Str[0]); 		
			obj.txtDicCode.setValue(Str[1]);
			obj.txtDicName.setValue(Str[2]);
			obj.txtClassName.setValue(Str[3]);
			obj.txtQueryName.setValue(Str[4]);
			obj.txtFields.setValue(Str[5]);
			obj.txtFormalSpec.setValue(Str[6]);
  		}
	};
	obj.winfBtnSave_click = function()
	{
		var objDic = ExtTool.StaticServerObject("DHCMed.CR.BO.Dictionary");
		var tmp = obj.txtDicID.getValue()+"^";
		tmp += obj.txtDicCode.getValue() + "^";
		tmp += obj.txtDicName.getValue() + "^";
		tmp += obj.txtClassName.getValue() + "^";
		tmp += obj.txtQueryName.getRawValue() + "^";
		tmp += obj.txtFields.getValue() + "^";
		tmp += obj.txtFormalSpec.getValue(); 
	//	ExtTool.alert(tmp);
		try
		{
			var NewID = objDic.update(tmp);
			//window.alert(NewID);
			if(NewID<0) {
				ExtTool.alert("提示","保存失败！");
				return;
				}
			obj.txtDicID.setValue(NewID);
			obj.winScreen.close();
			//parent.GridPanelStore.removeAll();
			parent.gridListStore.load();
			
		}catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
	};
		obj.winfBtnGet_click = function()
	{
		if(obj.txtClassName.getValue()==""||obj.txtQueryName.getRawValue()=="")
		{
			ExtTool.alert("Error","请输入类名称和Query名称！" );
			return;
		}
		var formSev=ExtTool.StaticServerObject("DHCMed.CR.BO.Dictionary");
    var str=formSev.GetQueryInfo(obj.txtClassName.getValue(),obj.txtQueryName.getRawValue());
    var queryInfo=str.split("^");
		obj.txtFields.setValue(queryInfo[2]);
	  obj.txtFormalSpec.setValue(queryInfo[1]);
	};
		obj.winfPBtnCancle_click = function()
	{
		obj.winScreen.close();
	};
}

