

function InitViewport1Event(obj) {
	obj.LoadEvent = function()
  {};
	obj.btnQuery_click = function()
	{
		obj.gridListStore.removeAll();
		//obj.gridListStore.load();                             //add by wuqk 2012-08-01 分页查询
		obj.gridListStore.load({params : {start:0,limit:15}});
	};
	obj.btnNew_click = function()
	{
		var objWinEdit = new InitwinScreen();
		objWinEdit.winScreen.show();
		//ExtDeignerHelper.HandleResize(objWinEdit);
	};
	obj.btnEdit_click = function()
	{
		obj.MenuEdit();
	};
	obj.btnDelete_click = function()
	{
		var selectObj = obj.gridList.getSelectionModel().getSelected();
		if (selectObj){
			ExtTool.confirm('选择框','确定删除?',function(btn){
				if(btn=="no") return;
				var objMainService = ExtTool.StaticServerObject("DHCMed.SSService.MenusSrv");
				var ret = objMainService.DelInfoFromMenuId(selectObj.get("rowid"));
				if(ret==1){
					//ExtTool.alert("信息","删除成功!");
					obj.gridListStore.removeAll();
					//obj.gridListStore.load();
					ExtTool.LoadCurrPage('gridList');    //update by zf 2012-11-02 刷新当前页
					obj.gListRowid.setValue("");
					return;
					}
		 		if(ret<1)
		 			{
		 			ExtTool.alert("提示","删除失败!");
		 			return;	
		 			}
			});
		}
		else
	 	{
	 		ExtTool.alert("提示","请先选中一行！");
	 		return;
	 	}
	 	
	};
	obj.txtMenuCaption_click = function()
	{
		obj.txtMenuCaptionStore.removeAll();
		obj.txtMenuCaptionStore.load();
	};
	obj.gridList_rowdblclick = function()
	{
		obj.MenuEdit();
	};
	obj.gridList_rowclick = function()
	{
		/*
		var rowIndex = arguments[1];
		var objRec = obj.gridListStore.getAt(rowIndex);
		obj.gListRowid.setValue(objRec.get("rowid"));
		*/
	};
	
	/*
	*菜单编辑函数
	*/
	obj.MenuEdit = function(){		
		var selectObj = obj.gridList.getSelectionModel().getSelected();
		if (selectObj){
			var objWinEdit = new InitwinScreen(selectObj);
			objWinEdit.winfPProductDr.disabled=true;
			objWinEdit.winScreen.show();
		}
		else{
			ExtTool.alert("提示","请先选中一行!");
		}
	}
}
function InitwinScreenEvent(obj) {
	var parent=objControlArry['Viewport1'];
	obj.LoadEvent = function(){
		var data = arguments[0][0];
  		if (data){
  			var objMenus = ExtTool.StaticServerObject("DHCMed.SSService.MenusSrv");
  			var menuRowid = data.get("rowid");
  			var ret = objMenus.GetMenusInfoFromId(menuRowid);
  			
			if (ret=="") 
			{
				ExtTool.alert("提示","菜单信息不存在!");
				return;
			}	
			var Str=ret.split("^");
			
			obj.MenuID.setValue(Str[0]);
			
			obj.winfPMenuCode.setValue(Str[1]);
			obj.winfPMenuCaption.setValue(Str[2]);
			obj.winfPLinkUrl.setValue(Str[3]);
			obj.winfPExpression.setValue(Str[4]);
			
			obj.winfPShowIndex.setValue(Str[6]);
			obj.winfPIconClass.setValue(Str[7]);
			
			if(Str[5]>0) ExtTool.AddComboItem(obj.winfPProductDr,Str[9],Str[5]);
			
			if(Str[8]>0) ExtTool.AddComboItem(obj.winfPParentMenuDr,Str[10],Str[8]);
			
			obj.winfGPanelStore.removeAll();
			obj.winfGPanelStore.load();
  		}
		
	};
	obj.winfPSave_click = function()
	{
		var objMenus = ExtTool.StaticServerObject("DHCMed.SS.Menus");
		var tmp = obj.MenuID.getValue()+"^";
		tmp += obj.winfPMenuCode.getValue() + "^";
		tmp += obj.winfPMenuCaption.getValue() + "^";
		tmp += obj.winfPLinkUrl.getValue() + "^";
		tmp += obj.winfPExpression.getValue() + "^";
		if(obj.winfPProductDr.getValue()!=obj.winfPProductDr.getRawValue())  // 防止在comboBox里面的值为手动输入的
		{
			tmp += obj.winfPProductDr.getValue() + "^";
		}
		else tmp = tmp + "^";
		tmp += obj.winfPShowIndex.getValue() + "^";
		var Showindex=obj.winfPShowIndex.getValue();
		if((Showindex!="")&&(!Showindex.match(new RegExp("^[0-9]+$")))){
			ExtTool.alert("提示","显示顺序填写不规范（只能是整数）!");
			return;
		}
		tmp += obj.winfPIconClass.getValue() + "^";
		if(obj.winfPParentMenuDr.getValue()!=obj.winfPParentMenuDr.getRawValue())
		{	
			tmp += obj.winfPParentMenuDr.getValue();	
		}

		if((obj.winfPMenuCode.getValue()=="")||(obj.winfPMenuCaption.getValue()=="")||(obj.winfPProductDr.getValue()==""))
		{
			ExtTool.alert("提示","菜单代码、名称、产品都不能为空!")
			return;	
		}
		
		var selectObj = parent.gridList.getSelectionModel().getSelected();	
		var strCodeLast = (selectObj != null ? selectObj.get("MenuCode") : "");
		var strCode = obj.winfPMenuCode.getValue();
		if ((strCode != strCodeLast) && (parent.gridListStore.findExact("MenuCode", strCode) >-1))
		{
			ExtTool.alert("提示","代码与列表中的现有项目重复，请仔细检查!");
			return;
		}
		
		try
		{
			var NewID = objMenus.Update(tmp);
			if (NewID>0){
				obj.MenuID.setValue(NewID);
				ExtTool.alert("提示","保存成功!");
				//parent.gridListStore.load({params : {start:0,limit:15}});
				ExtTool.LoadCurrPage('gridList');    //update by zf 2012-11-02 刷新当前页
			}
			else{
				ExtTool.alert("提示","保存失败!errCode="+NewID);
			}
			//window.alert(NewID);			
			//obj.winScreen.close();
			//parent.gridListStore.removeAll();
			//parent.gridListStore.load({params : {start:0,limit:15}});
			//obj.winfGPanelStore.removeAll();
			//obj.winfGPanelStore.load();
			
		}catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
	};
	obj.winfPCancel_click = function()
	{
		obj.winScreen.close();
		//parent.gridListStore.load({params : {start:0,limit:15}});
		ExtTool.LoadCurrPage('gridList');    //update by zf 2012-11-02 刷新当前页
	};
	obj.winfGPanel_rowclick = function()
	{
		var objGrid = arguments[0];
		var rowIndex = arguments[1];
		var objRec = obj.winfGPanelStore.getAt(rowIndex);
		if(objRec.get("rowid")==obj.cMenuOperID.getValue())
		{
			obj.cMenuOperID.setValue("");
			obj.winfPPPOpeCode.setValue("");
			obj.winfPPPOpeName.setValue("");
			return;
			
		}
		obj.cMenuOperID.setValue(objRec.get("rowid"));
		obj.winfPPPOpeCode.setValue(objRec.get("OperaCode"));
		obj.winfPPPOpeName.setValue(objRec.get("OperaName"));
	};
	obj.winfPPPDelete_click = function()
	{
		var objProduct = ExtTool.StaticServerObject("DHCMed.SS.MenuOperation");
		var cMOId=obj.cMenuOperID.getValue();
		if(cMOId=="")
		{
			ExtTool.alert("提示","请先选择一行操作项!");
			return;	
		}
		var ret = objProduct.DeleteById(cMOId);
		if(ret==0)
		{
			//alert("删除成功!!");
			obj.winfGPanelStore.removeAll();
			obj.winfGPanelStore.load();
			obj.cMenuOperID.setValue("");
			obj.winfPPPOpeCode.setValue("");
			obj.winfPPPOpeName.setValue("");
			return;	
		}
		ExtTool.alert("提示","删除失败!!");
	}
	obj.winfPPPUpdate_click = function()
	{
		if(obj.MenuID.getValue()=="") 
		{
			ExtTool.alert("提示","请先保存菜单！");
			return;
		}
		if((obj.winfPPPOpeCode.getValue()=="")||(obj.winfPPPOpeName.getValue()==""))
		{
			
			ExtTool.alert("提示","操作代码和名字都不能为空!");
			return;	
		}
		var objProduct = ExtTool.StaticServerObject("DHCMed.SS.MenuOperation");
		var tmp = obj.cMenuOperID.getValue()+"^";
		tmp += obj.MenuID.getValue() + "^";
		tmp += obj.winfPPPOpeCode.getValue() + "^";
		tmp += obj.winfPPPOpeName.getValue() + "^";
		try
		{
			var NewID = objProduct.Update(tmp);
			//window.alert(NewID);
			
			obj.winfGPanelStore.removeAll();
			obj.winfGPanelStore.load();
			obj.cMenuOperID.setValue(NewID);
			
		}catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
		obj.cMenuOperID.setValue("");
		obj.winfPPPOpeCode.setValue("");
		obj.winfPPPOpeName.setValue("");
	};
	obj.winfPParentMenuDr_click = function()
	{
		obj.winfPParentMenuDrStore.removeAll();
		obj.winfPParentMenuDrStore.load();
	}
}

