

function InitViewport1Event(obj) {
	obj.LoadEvent = function()
  {};
	obj.btnQuery_click = function()
	{
		obj.gridListStore.removeAll();
		//obj.gridListStore.load();                             //add by wuqk 2012-08-01 ��ҳ��ѯ
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
			ExtTool.confirm('ѡ���','ȷ��ɾ��?',function(btn){
				if(btn=="no") return;
				var objMainService = ExtTool.StaticServerObject("DHCMed.SSService.MenusSrv");
				var ret = objMainService.DelInfoFromMenuId(selectObj.get("rowid"));
				if(ret==1){
					//ExtTool.alert("��Ϣ","ɾ���ɹ�!");
					obj.gridListStore.removeAll();
					//obj.gridListStore.load();
					ExtTool.LoadCurrPage('gridList');    //update by zf 2012-11-02 ˢ�µ�ǰҳ
					obj.gListRowid.setValue("");
					return;
					}
		 		if(ret<1)
		 			{
		 			ExtTool.alert("��ʾ","ɾ��ʧ��!");
		 			return;	
		 			}
			});
		}
		else
	 	{
	 		ExtTool.alert("��ʾ","����ѡ��һ�У�");
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
	*�˵��༭����
	*/
	obj.MenuEdit = function(){		
		var selectObj = obj.gridList.getSelectionModel().getSelected();
		if (selectObj){
			var objWinEdit = new InitwinScreen(selectObj);
			objWinEdit.winfPProductDr.disabled=true;
			objWinEdit.winScreen.show();
		}
		else{
			ExtTool.alert("��ʾ","����ѡ��һ��!");
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
				ExtTool.alert("��ʾ","�˵���Ϣ������!");
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
		if(obj.winfPProductDr.getValue()!=obj.winfPProductDr.getRawValue())  // ��ֹ��comboBox�����ֵΪ�ֶ������
		{
			tmp += obj.winfPProductDr.getValue() + "^";
		}
		else tmp = tmp + "^";
		tmp += obj.winfPShowIndex.getValue() + "^";
		var Showindex=obj.winfPShowIndex.getValue();
		if((Showindex!="")&&(!Showindex.match(new RegExp("^[0-9]+$")))){
			ExtTool.alert("��ʾ","��ʾ˳����д���淶��ֻ����������!");
			return;
		}
		tmp += obj.winfPIconClass.getValue() + "^";
		if(obj.winfPParentMenuDr.getValue()!=obj.winfPParentMenuDr.getRawValue())
		{	
			tmp += obj.winfPParentMenuDr.getValue();	
		}

		if((obj.winfPMenuCode.getValue()=="")||(obj.winfPMenuCaption.getValue()=="")||(obj.winfPProductDr.getValue()==""))
		{
			ExtTool.alert("��ʾ","�˵����롢���ơ���Ʒ������Ϊ��!")
			return;	
		}
		
		var selectObj = parent.gridList.getSelectionModel().getSelected();	
		var strCodeLast = (selectObj != null ? selectObj.get("MenuCode") : "");
		var strCode = obj.winfPMenuCode.getValue();
		if ((strCode != strCodeLast) && (parent.gridListStore.findExact("MenuCode", strCode) >-1))
		{
			ExtTool.alert("��ʾ","�������б��е�������Ŀ�ظ�������ϸ���!");
			return;
		}
		
		try
		{
			var NewID = objMenus.Update(tmp);
			if (NewID>0){
				obj.MenuID.setValue(NewID);
				ExtTool.alert("��ʾ","����ɹ�!");
				//parent.gridListStore.load({params : {start:0,limit:15}});
				ExtTool.LoadCurrPage('gridList');    //update by zf 2012-11-02 ˢ�µ�ǰҳ
			}
			else{
				ExtTool.alert("��ʾ","����ʧ��!errCode="+NewID);
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
		ExtTool.LoadCurrPage('gridList');    //update by zf 2012-11-02 ˢ�µ�ǰҳ
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
			ExtTool.alert("��ʾ","����ѡ��һ�в�����!");
			return;	
		}
		var ret = objProduct.DeleteById(cMOId);
		if(ret==0)
		{
			//alert("ɾ���ɹ�!!");
			obj.winfGPanelStore.removeAll();
			obj.winfGPanelStore.load();
			obj.cMenuOperID.setValue("");
			obj.winfPPPOpeCode.setValue("");
			obj.winfPPPOpeName.setValue("");
			return;	
		}
		ExtTool.alert("��ʾ","ɾ��ʧ��!!");
	}
	obj.winfPPPUpdate_click = function()
	{
		if(obj.MenuID.getValue()=="") 
		{
			ExtTool.alert("��ʾ","���ȱ���˵���");
			return;
		}
		if((obj.winfPPPOpeCode.getValue()=="")||(obj.winfPPPOpeName.getValue()==""))
		{
			
			ExtTool.alert("��ʾ","������������ֶ�����Ϊ��!");
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

