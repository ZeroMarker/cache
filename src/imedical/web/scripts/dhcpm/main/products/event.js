function InitViewscreenEvent(obj) {
	obj.LoadEvent = function()
  {
  	/*
  	if (tDHCMedMenuOper['a']==1) alert('��a��Ȩ��')
  	if (tDHCMedMenuOper['b']==1) alert('��b��Ȩ��')
  	if (tDHCMedMenuOper['c']==1) alert('��c��Ȩ��')
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
			ExtTool.alert("��ʾ","����ѡ��һ��!");	
			return;
		}
		var objProduct = ExtTool.StaticServerObject("DHCMed.SS.Products");
		var ret = objProduct.GetStringById(ProID);
		if (ret==-1) 
		{
			ExtTool.alert("��ʾ","��Ʒ��Ϣ������!");
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
			ExtTool.alert("��ʾ","��Ʒ��Ϣ������!");
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
	*�༭��Ʒ����
	*/
	obj.EditProduct = function(){
		var selectObj = obj.GridPanel.getSelectionModel().getSelected();
		
		if (selectObj){
			var objWinEdit = new InitwinScreen(selectObj);
		//	objWinEdit.winfPProCode.disabled=true;
			objWinEdit.winScreen.show();
		}
		else{
			ExtTool.alert("��ʾ","����ѡ��һ��!");
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
				ExtTool.alert("��ʾ","��Ʒ��Ϣ������!");
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
			ExtTool.alert("��ʾ","��Ʒ���롢���Ʋ���Ϊ��!");
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
				ExtTool.alert("��ʾ","����ʧ�ܣ�");
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

