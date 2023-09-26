function InitViewportEvent(obj)
{
	obj.LoadEvent = function(args)
	{
	}
	var SelectedRowID = 0;
	var preRowID=0;
	obj.GridPanel_rowclick = function()
	{
	  var rc = obj.GridPanel.getSelectionModel().getSelected();
	  var linenum=obj.GridPanel.getSelectionModel().lastActive;
	  if (rc)
	  {
		SelectedRowID=rc.get("rowId");
		if(preRowID!=SelectedRowID)
	    {
		    obj.comGroup.setValue(rc.get("groupDesc"));
		    obj.comType.setValue(rc.get("type"));
		    preRowID=SelectedRowID;
		}
		else
		{
		    obj.comGroup.setValue("");
		    obj.comType.setValue("");
		    SelectedRowID = 0;
		    preRowID=0;
		    obj.GridPanel.getSelectionModel().deselectRow(linenum);
		}
	  }
	};
	obj.btnSch_click = function()
	{
		obj.GridPanelStore.removeAll();
		obj.GridPanelStore.load({});
	};
	obj.btnNew_click=function()
	{
		
		var objWinEdit = new InitwinScreen();
		objWinEdit.winScreen.show();
	}
	obj.btnEdit_click=function()
	{
		var selectObj = obj.GridPanel.getSelectionModel().getSelected();
		//alert(selectObj)
		if (selectObj)
		{
			var objWinEdit = new InitwinScreen(selectObj);
			objWinEdit.winScreen.show();
		}
		else
		{
			ExtTool.alert("提示","请先选中一行!");
		}		
	};
	obj.btnDelete_click = function()
	{
		var selectObj = obj.GridPanel.getSelectionModel().getSelected();
		if (selectObj)
		{
			ExtTool.confirm('选择框','确定删除?',function(btn){
				if(btn=="no") return;
				var _DHCANOPArrange = ExtTool.StaticServerObject("web.DHCANOPArrange");
                        
				var ret = _DHCANOPArrange.DeleteGroupConfig(selectObj.get("groupId"),selectObj.get("typeCode"),selectObj.get("rowId"));
				if(ret=='0')
				{
					ExtTool.alert("信息","删除成功!");
					obj.comGroup.setValue("");
					obj.comType.setValue("");
					obj.GridPanelStore.removeAll();
			    	obj.GridPanelStore.load({});
					return;
				}
		 		if(ret!='0')
		 		{
		 			ExtTool.alert("提示",ret);
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
}

function InitwinScreenEvent(obj)
{
	var parent=objControlArry['Viewport'];
	obj.LoadEvent = function(args)
	{
		var data = arguments[0][0];
		if (data)
		{
  			obj.winTxtRowId.setValue(data.get("rowId"));
  			obj.winComRowId.setValue(data.get("rowId"));
  			ExtTool.AddComboItem(obj.winComGroup,data.get("groupDesc"),data.get("groupId"))
  			ExtTool.AddComboItem(obj.winComType,data.get("type"),data.get("typeCode"))
  			ExtTool.AddComboItem(obj.winComCaption,data.get("caption"),data.get("name"))
  			obj.winTxtName.setValue(data.get("name"));
  			obj.winComGroup.setReadOnly(true);
  			obj.winComType.setReadOnly(true);
			
		    
			obj.winComCaptionStore.each(function(r)
	       {
	       if(r.get('type')!=data.get("typeCode"))
	       {
	        obj.winComCaptionStore.remove(r)
	       }
	       })
			obj.storeProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.DHCANOPArrange';
		    param.QueryName = 'GetGroupConfig';
		    param.Arg1 = obj.winComType.getValue();
		    param.Arg2 = obj.winComGroup.getValue();
		    param.ArgCnt = 2;
	       });
	      obj.store.load(
	      {
	      callback:function(records,option,success)
	      {
	      for(i=0;i<records.length;i++)
	      {
	      var record=records[i];
		  var rowId=record.get('rowId')
          var i0 = obj.winComRowIdStore.find('code',rowId);
		  if(i0!=-1)
		  {
		  obj.winComRowIdStore.removeAt(i0)
		  }
		 var name=record.get('name')
		 var i1=obj.winComCaptionStore.find('code',name)
		 if(i1!=-1)
		 {
		  obj.winComCaptionStore.removeAt(i1)
		 }
	     }
	     }
	    })
			
			
  		}
	}
	obj.winBtnSave_click=function()
	{		
		var _DHCANOPArrange = ExtTool.StaticServerObject("web.DHCANOPArrange");
		var groupId=obj.winComGroup.getValue();
		if (groupId=="") {ExtTool.alert("提示","请选择安全组！");return;}
		var typeCode=obj.winComType.getValue();
		if (typeCode=="") {ExtTool.alert("提示","请选择元素类型！");return;}
		var rowId=obj.winComRowId.getValue();
		if (rowId=="") {ExtTool.alert("提示","请选择元素顺序！");return;}
		var str=obj.winTxtName.getValue()+"^"+obj.winComCaption.getRawValue()
		try
		{
			if(obj.winTxtRowId.getValue()=="")
			{
				var ret = _DHCANOPArrange.InsertGroupConfig(groupId,typeCode,rowId,str);
				if(ret!=0)
				{
					ExtTool.alert("提示",ret);
					return;
				}
				obj.winScreen.close();
				parent.comGroup.setValue("");
				parent.comType.setValue("");
				parent.GridPanelStore.removeAll();
				parent.GridPanelStore.load({});
			}
			else 
			{
				var oriRowId=obj.winTxtRowId.getValue();
				var ret = _DHCANOPArrange.UpdateGroupConfig(groupId,typeCode,oriRowId,rowId,str);
				if(ret!=0)
				{
					ExtTool.alert("提示",ret);
					return;
				}
				obj.winScreen.close();
				parent.comGroup.setValue("");
				parent.comType.setValue("");
				parent.GridPanelStore.removeAll();
				parent.GridPanelStore.load({});
			}
		}
		catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
	}
	obj.winComCaption_select=function()
	{
		obj.winTxtName.setValue(obj.winComCaption.getValue());
	}
	obj.winBtnCancle_click=function()
	{		
		obj.winScreen.close();
	}
	obj.winComType_select=function()
	{
	 obj.winComRowIdStore.reload({})
	 obj.winComCaptionStore.reload({})
	 obj.winComRowId.setValue("");
	 obj.winComCaption.setValue("");
	 obj.winTxtName.setValue("");
	 var typeCode=obj.winComType.getValue();	 
	 obj.winComCaptionStore.each(function(r)
	 {
	  if(r.get('type')!=typeCode)
	  {
	   obj.winComCaptionStore.remove(r)
	  }
	 })
	 if(obj.winComGroup.getValue()=="") 
	 { 
	    alert("请首先选择安全组!");
		obj.winComType.setValue("");
	 }
	 obj.storeProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANOPArrange';
		param.QueryName = 'GetGroupConfig';
		param.Arg1 = obj.winComType.getValue();
		param.Arg2 = obj.winComGroup.getValue();
		param.ArgCnt = 2;
	});
	obj.store.load(
	 {
	   callback:function(records,option,success)
	    {
	   for(i=0;i<records.length;i++)
	    {
	     var record=records[i];
		 var rowId=record.get('rowId')
         var i0 = obj.winComRowIdStore.find('code',rowId);
		 if(i0!=-1)
		 {
		  obj.winComRowIdStore.removeAt(i0)
		 }
		 var name=record.get('name')
		 var i1=obj.winComCaptionStore.find('code',name)
		 if(i1!=-1)
		 {
		  obj.winComCaptionStore.removeAt(i1)
		 }
	   }
	  }
	}
	);
	}
	obj.winComGroup_select=function()
	{ 
	}
	obj.winComRowId_select=function()
	{
	 if((obj.winComGroup.getValue()=="")||(obj.winComType.getValue()==""))
	 { 
	    alert("请确保安全组和类型不为空!");
		obj.winComRowId.setValue("");
	 }
	}

}

