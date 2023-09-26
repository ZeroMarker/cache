function InitViewscreenEvent(obj) {
	obj.LoadEvent = function()
  {
  	/*
  	if (tDHCMedMenuOper['a']==1) alert('有a的权限')
  	if (tDHCMedMenuOper['b']==1) alert('有b的权限')
  	if (tDHCMedMenuOper['c']==1) alert('有c的权限')
  	*/
  	};
	obj.btnNew_click = function()
	{
		var objWinEdit = new InitwinScreen();
		objWinEdit.winScreen.show();
		ExtDeignerHelper.HandleResize(objWinEdit);
	};
	obj.btnEdit_click = function()
	{	
		//alert(1);
		obj.EditProduct();
		/*
		var ProID=obj.ProID.getValue();
		if(ProID=="")
		{
			ExtTool.alert("提示","请先选中一行!");	
			return;
		}
		var objProduct = ExtTool.StaticServerObject("DHCMed.SS.Products");
		var ret = objProduct.GetStringById(ProID);
		if (ret==-1) 
		{
			ExtTool.alert("提示","产品信息不存在!");
			return;
		}
		var objWinEdit = new InitwinScreen(obj);
		objWinEdit.winScreen.show();

		var Str=ret.split("^");
	
		objWinEdit.winfPProID.setValue(Str[0]);
		objWinEdit.winfPProCode.setValue(Str[1]);
		objWinEdit.winfPProName.setValue(Str[2]);
		objWinEdit.winfPProVersion.setValue(Str[3]);
		objWinEdit.winfPProActive.setValue(Str[6]);
		objWinEdit.winfPProResume.setValue(Str[7]);
		objWinEdit.winfPProShowIndex.setValue(Str[5]);
		objWinEdit.winfPProIconClass.setValue(Str[4]);
		*/
		
	};
	obj.GridPanel_rowclick = function()
	{
		/*
		var rowIndex = arguments[1];
		var objRec = obj.GridPanel5Store.getAt(rowIndex);
		obj.ProID.setValue(objRec.get("rowid"));
		*/
	};
	obj.GridPanel_rowdblclick = function()
	{
		
		obj.EditProduct();
		/*
		var rowIndex = arguments[1];
		var objRec = obj.GridPanel5Store.getAt(rowIndex);
		var objProduct = ExtTool.StaticServerObject("DHCMed.SS.Products");
		var ret = objProduct.GetStringById(objRec.get("rowid"));
		if (ret==-1) 
		{
			ExtTool.alert("提示","产品信息不存在!");
			return;
		}
		var objWinEdit = new InitwinScreen(obj);
		objWinEdit.winScreen.show();
		
		var Str=ret.split("^");
	
		objWinEdit.winfPProID.setValue(Str[0]);
		objWinEdit.winfPProCode.setValue(Str[1]);
		objWinEdit.winfPProName.setValue(Str[2]);
		objWinEdit.winfPProVersion.setValue(Str[3]);
		objWinEdit.winfPProActive.setValue(Str[6]);
		objWinEdit.winfPProResume.setValue(Str[7]);
		objWinEdit.winfPProShowIndex.setValue(Str[5]);
		objWinEdit.winfPProIconClass.setValue(Str[4]);
		*/
	};
	
	/*
	*编辑产品函数
	*/
	obj.EditProduct = function(){
		var selectObj = obj.GridPanel.getSelectionModel().getSelected();
		
		if (selectObj){
			var objWinEdit = new InitwinScreen(selectObj);
		//	objWinEdit.winfPProCode.disabled=true;
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
			
  			var objProduct = ExtTool.StaticServerObject("DHCPM.SS.Products");
			
			var ret = objProduct.GetStringById(data.get("rowid"));
			
			if (ret==-1) 
			{
				ExtTool.alert("提示","产品信息不存在!");
				return;
			}
			
			var Str=ret.split("^");		
			obj.winfPProID.setValue(Str[0]);
			obj.winfPProCode.setValue(Str[1]);
			obj.winfPProName.setValue(Str[2]);
			obj.winfPProVersion.setValue(Str[3]);
			obj.winfPProActive.setValue(Str[6]);
			obj.winfPProResume.setValue(Str[7]);
			obj.winfPProShowIndex.setValue(Str[5]);
			obj.winfPProIconClass.setValue(Str[4]);
  		}
	};
	obj.winfBtnSave_click = function()
	{
		
		if((obj.winfPProCode.getValue()=="")||(obj.winfPProName.getValue()==""))
		{
			ExtTool.alert("提示","产品代码、名称不能为空!");
			return;			
		}
		var objProduct = ExtTool.StaticServerObject("DHCPM.SS.Products");
		//ExtTool.alert(objProduct);
		var tmp = obj.winfPProID.getValue()+"^";
		tmp += obj.winfPProCode.getValue() + "^";
		tmp += obj.winfPProName.getValue() + "^";
		tmp += obj.winfPProVersion.getValue() + "^";
		tmp += obj.winfPProIconClass.getValue() + "^";
		tmp += obj.winfPProShowIndex.getValue() + "^";
		tmp += (obj.winfPProActive.getValue() ? "1" : "0") + "^";
		tmp += obj.winfPProResume.getValue() + "^";
		//alert(tmp)
		try
		{
			var NewID = objProduct.Update(tmp);
			//window.alert(NewID);
			//alert(NewID)
			if(NewID<0) {
				ExtTool.alert("提示","保存失败！");
				return;
				}
			obj.winfPProID.setValue(NewID);
			obj.winScreen.close();
			//parent.GridPanelStore.removeAll();
			parent.GridPanelStore.load({params : {	start:0	,limit:20}});
			
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

