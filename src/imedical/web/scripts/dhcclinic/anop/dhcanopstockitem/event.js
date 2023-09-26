function InitViewScreenEvent(obj)
{
	var preSelectRowId="";
	var curSelectRowId="";
	var _DHCANOPStock=ExtTool.StaticServerObject('web.DHCANOPStock');
	obj.LoadEvent = function(args)
	{
	};
		
	obj.retGridPanel_rowclick = function()
	{
		var rc = obj.retGridPanel.getSelectionModel().getSelected();
		if(rc){
			curSelectRowId=rc.get("count");
			if(curSelectRowId!=preSelectRowId){
				obj.comAppLoc.setValue(rc.get("LocId"));
				obj.comAppLoc.setRawValue(rc.get("locDesc"));
				obj.comStockItem.setValue(rc.get("incitrRowId"));
				obj.comStockItem.setRawValue(rc.get("itDesc"));
				obj.txtStockDesc.setValue(rc.get("ancDesc"));
				obj.Rowid.setValue(rc.get("LocId"));
				preSelectRowId=curSelectRowId;
			}else{
				obj.comAppLoc.setValue("");
				obj.comStockItem.setValue("");
				obj.txtStockDesc.setValue("");
				obj.Rowid.setValue("");
				preSelectRowId="";
				curSelectRowId=""
			}
		};

	};
	
	obj.addbutton_click = function()
	{
		if(obj.comAppLoc.getValue()=="")
		{
			ExtTool.alert("提示","请选择手术申请科室!");	
			return;
		}
		if(obj.comStockItem.getValue()=="")
		{
			ExtTool.alert("提示","请选择耗材信息!");	
			return;
		}
		//var RowId = obj.RowId.getValue();
		var comAppLoc=obj.comAppLoc.getValue();
		var comStockItem=obj.comStockItem.getValue();
		var ancDesc=obj.txtStockDesc.getValue();
		var ret=_DHCANOPStock.SaveINCItmRalLoc(comAppLoc,comStockItem,ancDesc,"S");
		
			Ext.Msg.alert("提示","保存成功!",function(){
	  	  	obj.Rowid.setValue("");
	  	  	//obj.comAppLoc.setValue("");
	  	  	obj.comStockItem.setValue("");
			obj.txtStockDesc.getValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
	};
	obj.deletebutton_click = function()
	{
		var rc = obj.retGridPanel.getSelectionModel().getSelected();
		var ID=obj.Rowid.getValue();
		if(ID=="")
		{
			Ext.Msg.alert("提示","请选择一条要删除的记录！");
			return;
		}
		var incId=rc.get("incitrRowId")
		if(incId==""){
			Ext.Msg.alert("提示","这条记录数据有错，暂不能删除！");
			return;
		}
		
		Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCANOPStock.SaveINCItmRalLoc(ID,incId,"","D");
		//alert(ret)
	  	if(ret!=0)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.comAppLoc.setValue("");
	  	  	obj.comStockItem.setValue("");
			obj.txtStockDesc.getValue("");
	  	  	obj.retGridPanelStore.load({});  	
			preSelectRowId="";
			curSelectRowId=""			
	  	  	});

	  	}
	  );
	};
	obj.seachButton_click=function(){
		obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCANOPStock';
			param.QueryName = 'FindANCStock';
			param.Arg1 = obj.comAppLoc.getValue();
			param.Arg2 = obj.comStockItem.getRawValue();
			param.ArgCnt = 2;
		});
		obj.retGridPanelStore.load({});
	}
}

