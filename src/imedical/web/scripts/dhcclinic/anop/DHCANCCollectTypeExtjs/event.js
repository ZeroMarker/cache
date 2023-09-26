function InitViewScreenEvent(obj)
{
	var _DHCANCCollectType = ExtTool.StaticServerObject('web.DHCANCCollectType');
	
	obj.LoadEvent=function(args)
	{

		var hpDevs=_DHCANCCollectType.GetHPDeves();
		var MSrvIP=_DHCANCCollectType.GetMSrvIP();
		
		obj.hpDevs.setValue(hpDevs);
		
		var strArr=MSrvIP.split("^");
		if(strArr.length>=2)
		{
			obj.ANCCTSource.setValue(strArr[1]);
			obj.MSrvIP.setValue(strArr[0]);
		}
	};
	
	
	obj.retGridPanel_rowclick=function()
	{
		var rc = obj.retGridPanel.getSelectionModel().getSelected();
		if(rc)
		{
			obj.ANCCTCode.setValue(rc.get("tCode"));
			obj.ANCCTDesc.setValue(rc.get("tDesc"));
			obj.ANCCTSource.setValue(rc.get("tSource"));
			obj.ANCCTActive.setValue(rc.get("tANCCTActive"));
			obj.ANCCTActive.setRawValue(rc.get("tANCCTActive")=="Y"?"是":"否");
			obj.ANCCTRowid.setValue(rc.get("trowid"));
			
			obj.retGridItemPanelStore.load({});
		}
	};
	
	obj.addButton_click=function()
	{
		var ANCCTCode=obj.ANCCTCode.getValue();
		var ANCCTDesc=obj.ANCCTDesc.getValue();
		var ANCCTActive=(obj.ANCCTActive.getValue()=="1"?"Y":"N");
		var ANCCTSource=obj.ANCCTSource.getValue();
		
		if(ANCCTCode==""||ANCCTDesc==""||ANCCTActive==""||ANCCTSource=="")
		{
			Ext.Msg.alert("提示","代码,名称,Source,ANCCTActive都不能为空");
			return;
		}
		
		var ret=_DHCANCCollectType.InsertDHCANCCollectType(ANCCTCode,ANCCTDesc,ANCCTActive,ANCCTSource);
		if(ret=="0")
		{
			Ext.Msg.alert("提示","增加成功!",function(){
				obj.ANCCTCode.setValue("");
				obj.ANCCTDesc.setValue("");
				obj.ANCCTActive.setValue("");
				obj.ANCCTActive.setRawValue("");
				obj.ANCCTSource.setValue("I");
				obj.ANCCTRowid.setValue("");
				
				obj.retGridPanelStore.load({});
				obj.retGridItemPanelStore.load({});
			});
		}
		else
		{
			Ext.Msg.alert("提示","增加失败:"+ret);
			return;
		}
		
	};
	
	obj.updateButton_click=function()
	{
		var ANCCTRowid=obj.ANCCTRowid.getValue();
		if(ANCCTRowid=="")
		{
			Ext.Msg.alert("提示","请选中一行");
			return;
		}
		
		var ANCCTCode=obj.ANCCTCode.getValue();
		var ANCCTDesc=obj.ANCCTDesc.getValue();
		var ANCCTActive=(obj.ANCCTActive.getValue()=="1"?"Y":"N");
		var ANCCTSource=obj.ANCCTSource.getValue();
		
		if(ANCCTCode==""||ANCCTDesc==""||ANCCTActive==""||ANCCTSource=="")
		{
			Ext.Msg.alert("提示","代码,名称,Source,ANCCTActive都不能为空");
			return;
		}
		
		var ret=_DHCANCCollectType.UPDATEDHCANCCollectType(ANCCTRowid,ANCCTCode,ANCCTDesc,ANCCTActive);
		if(ret=="0")
		{
			Ext.Msg.alert("提示","更新成功!",function(){
				obj.ANCCTCode.setValue("");
				obj.ANCCTDesc.setValue("");
				obj.ANCCTActive.setValue("");
				obj.ANCCTActive.setRawValue("");
				obj.ANCCTSource.setValue("I");
				obj.ANCCTRowid.setValue("");
				
				obj.retGridPanelStore.load({});
				obj.retGridItemPanelStore.load({});
			})
		}
		else
		{
			Ext.Msg.alert("提示","更新失败:"+ret);
			return;
		}
	};
	
	obj.deleteButton_click=function()
	{
		var ANCCTRowid=obj.ANCCTRowid.getValue();
		if(ANCCTRowid=="")
		{
			Ext.Msg.alert("提示","请选一条要删除的记录！");
			return;
		}
		
		Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  		if(btn=="no")
	  		{
		  		return;
	  		}
	  		var ret=_DHCANCCollectType.DeleteDHCANCCollectType(ANCCTRowid);
	  		if(ret!="0")
	  		{
	  	  		Ext.Msg.alert("提示","删除失败！");
	  	  		return;
	  		}
	  		else
	  		{
		  		Ext.Msg.alert("提示","删除成功！");
	  	 	 	obj.ANCCTCode.setValue("");
				obj.ANCCTDesc.setValue("");
				obj.ANCCTActive.setValue("");
				obj.ANCCTActive.setRawValue("");
				obj.ANCCTSource.setValue("A");
				obj.ANCCTRowid.setValue("");
				
				obj.retGridPanelStore.load({});
				obj.retGridItemPanelStore.load({});
				
				obj.retGridPanel.getSelectionModel().clearSelections();//清除所有选择
	  		}
	    });	
	};
	
	obj.findButton_click=function()
	{
		obj.retGridPanelStore.load({});
		obj.retGridItemPanelStore.load({});
	};
	
	
	obj.setDevesButton_click=function()
	{
		var hpDevs=""
		hpDevs=obj.hpDevs.getValue();
		var MSrvIP=obj.MSrvIP.getValue();
		alert(hpDevs+MSrvIP)
		var ret1=_DHCANCCollectType.SetHPDeves(hpDevs);
		
		var ret2=_DHCANCCollectType.SetMSrvIP(MSrvIP);
		
		Ext.Msg.alert("提示","设置成功！");
	};
	
	obj.copyButton_click=function()
	{
		var srcDev=obj.srcDev.getValue();
		var dstDev=obj.dstDev.getValue();
		
		if(srcDev=="")
		{
			Ext.Msg.alert("提示","Source Device不能为空！");
			return;
		}
		
		if(dstDev=="")
		{
			Ext.Msg.alert("提示","dest Deivice不能为空！");
			return;
		}
		
		var ret=_DHCANCCollectType.CopyDevChNo(srcDev,dstDev);
		if(ret=="0")
		{
			Ext.Msg.alert("提示","复制成功！");
			return
		}
		else
		{
			Ext.Msg.alert("提示","复制失败！");
			return
		}
	};
	
	
	obj.retGridItemPanel_rowclick=function()
	{
		var rc = obj.retGridItemPanel.getSelectionModel().getSelected();
		if(rc)
		{
			obj.Code.setValue(rc.get("tCode"));
			obj.ANCCTActiveItem.setValue(rc.get("tANCCTIActive"));
			obj.ANCCTActiveItem.setRawValue(rc.get("tANCCTIActive")=="Y"?"是":"否");
			obj.ANCCTIChannelNo.setValue(rc.get("tANCCTIChannelNo"));
			obj.ANCCTIComOrd.setValue(rc.get("tANCCTIComOrdDr"));
			obj.ANCCTIComOrd.setRawValue(rc.get("tANCCTIComOrdDrDesc"));
			obj.ItemRowid.setValue(rc.get("trowid"));
		}
	}
	
	obj.addButtonItem_click=function()
	{
		var Code=obj.Code.getValue();
		var ANCCTIChannelNo=obj.ANCCTIChannelNo.getValue();
		var ANCCTActive=(obj.ANCCTActiveItem.getValue()=="1"?"Y":"N");
		var ANCCTIParref=obj.ANCCTRowid.getValue();
		var ANCCTIComOrdDr=obj.ANCCTIComOrd.getValue();
		
		if(ANCCTIParref=="")
		{
			Ext.Msg.alert("提示","请在监护设备中选中一行!");
			return;
		}
		
		var ret=_DHCANCCollectType.InsertDHCANCCollectTypeitem(Code, ANCCTIChannelNo, ANCCTActive, ANCCTIParref, ANCCTIComOrdDr);
		if(ret=="0")
		{
			Ext.Msg.alert("提示","增加成功!",function(){
				obj.Code.setValue("");
				obj.ANCCTActiveItem.setValue("");
				obj.ANCCTActiveItem.setRawValue("");
				obj.ANCCTIChannelNo.setValue("");
				obj.ANCCTIComOrd.setValue("");
				obj.ANCCTIComOrd.setRawValue("");
				obj.ItemRowid.setValue("");
				obj.retGridItemPanel.getSelectionModel().clearSelections();//清除所有选择
				
				
	  	  		obj.retGridItemPanelStore.load({});  	
	  	  	});
		}
		else
		{
			Ext.Msg.alert("提示","增加失败:"+ret);
			return;
		}
	}
	
	
	obj.deleteButtonItem_click=function()
	{
		var Rowid=obj.ItemRowid.getValue();
		if(Rowid=="")
		{
			Ext.Msg.alert("提示","请选中一行");
			return;
		}
		
		Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  		if(btn=="no")
	  		{
		  		return;
	  		}
	  		var ret=_DHCANCCollectType.DeleteDHCANCCollectTypeitem(Rowid);
	  		if(ret!="0")
	  		{
	  	  		Ext.Msg.alert("提示","删除失败！");
	  		}
	  		else
	  		{
		  		Ext.Msg.alert("提示","删除成功！");
	  	 	 	obj.Code.setValue("");
				obj.ANCCTActiveItem.setValue("");
				obj.ANCCTActiveItem.setRawValue("");
				obj.ANCCTIChannelNo.setValue("");
				obj.ANCCTIComOrd.setValue("");
				obj.ANCCTIComOrd.setRawValue("");
				obj.ItemRowid.setValue("");
				obj.retGridItemPanel.getSelectionModel().clearSelections();//清除所有选择
				
	  	  		obj.retGridItemPanelStore.load({});
	  		}
	    });	
	}
	
	obj.updateButtonItem_click=function()
	{
		var Rowid=obj.ItemRowid.getValue();
		var Code=obj.Code.getValue();
		var ANCCTIChannelNo=obj.ANCCTIChannelNo.getValue();
		var ANCCTActive=(obj.ANCCTActiveItem.getValue()=="1"?"Y":"N");
		var ANCCTIParref=obj.ANCCTRowid.getValue();
		var ANCCTIComOrdDr=obj.ANCCTIComOrd.getValue();
		
		if(ANCCTIParref=="")
		{
			Ext.Msg.alert("提示","请在监护设备中选中一行!");
			return;
		}
		
		alert(Rowid+"^"+Code+"^"+ANCCTIChannelNo+"^"+ANCCTActive+"^"+ANCCTIParref+"^"+ANCCTIComOrdDr)
		
		var ret=_DHCANCCollectType.UPDATEDHCANCCollectTypeitem(Rowid, Code, ANCCTIChannelNo, ANCCTActive, ANCCTIParref, ANCCTIComOrdDr);
		if(ret=="0")
		{
			Ext.Msg.alert("提示","更新成功!",function(){
				obj.Code.setValue("");
				obj.ANCCTActiveItem.setValue("");
				obj.ANCCTActiveItem.setRawValue("");
				obj.ANCCTIChannelNo.setValue("");
				obj.ANCCTIComOrd.setValue("");
				obj.ANCCTIComOrd.setRawValue("");
				obj.ItemRowid.setValue("");
				obj.retGridItemPanel.getSelectionModel().clearSelections();//清除所有选择
				
	  	  		obj.retGridItemPanelStore.load({});  	
	  	  	});
		}
		else
		{
			Ext.Msg.alert("提示","更新失败:"+ret);
			return;
		}
	}
}