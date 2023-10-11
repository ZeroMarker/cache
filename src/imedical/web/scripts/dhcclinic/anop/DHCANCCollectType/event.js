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
			//1^是，0^否：后台存的
			obj.ANCCTActive.setValue(rc.get("tANCCTActive")=="Y"?"1":"0");
			obj.ANCCTActive.setRawValue(rc.get("tANCCTActive")=="Y"?"是":"否");
			obj.ANCCTRowid.setValue(rc.get("trowid"));
			
			ReloadItemPanelStore();
				obj.Code.setValue("");
				obj.Code.enable() ;
				obj.ANCCTActiveItem.setValue("");
				obj.ANCCTActiveItem.setRawValue("");
				obj.ANCCTIChannelNo.setValue("");
				obj.ANCCTIComOrd.setValue("");
				obj.ANCCTIComOrd.setRawValue("");
				obj.ItemRowid.setValue("");
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
		//多加个判断
		var repeatret=_DHCANCCollectType.CompareCollectType(ANCCTCode,"")
		if(repeatret==1)
		{
			var flag=confirm("代码允许重复,确认继续添加?")
			if(flag)
			{
			}
			else
			{
				return;
			}
			
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
				
				ReloadItemPanelStore();
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
		//1^是，0^否：后台存的Y，N
		var ANCCTSource=obj.ANCCTSource.getValue();
		
		if(ANCCTCode==""||ANCCTDesc==""||ANCCTActive==""||ANCCTSource=="")
		{
			Ext.Msg.alert("提示","代码,名称,Source,ANCCTActive都不能为空");
			return;
		}
		//多加个判断
		var repeatret=_DHCANCCollectType.CompareCollectType(ANCCTCode,ANCCTRowid)
		if(repeatret==1)
		{
			var flag=confirm("代码允许重复,确认继续修改?")
			if(flag)
			{
			}
			else
			{
				return;
			}
			
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
				
				ReloadItemPanelStore();
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
				obj.ANCCTSource.setValue("I");
				obj.ANCCTRowid.setValue("");
				
				obj.retGridPanelStore.load({});
				//20160928+dyl
				obj.Code.setValue("");
				obj.ANCCTActiveItem.setValue("");
				obj.ANCCTActiveItem.setRawValue("");
				obj.ANCCTIChannelNo.setValue("");
				obj.ANCCTIComOrd.setValue("");
				obj.ANCCTIComOrd.setRawValue("");
				obj.ItemRowid.setValue("");
				

				ReloadItemPanelStore();
	  		}
	    });	
	};
	
	obj.findButton_click=function()
	{	obj.retGridPanelStore.removeAll();
		obj.retGridPanelStore.load({});
		obj.ANCCTCode.setValue("");
		obj.ANCCTDesc.setValue("");
		obj.ANCCTActive.setValue("");
		obj.ANCCTActive.setRawValue("");
		obj.ANCCTSource.setValue("I");
		obj.ANCCTRowid.setValue("");
		ReloadItemPanelStore();
	};
	
	
	obj.setDevesButton_click=function()
	{
		var hpDevs=obj.hpDevs.getValue();
		var MSrvIP=obj.MSrvIP.getValue();
		
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
	
	var curRow="",lastRow=""
	obj.retGridItemPanel_rowclick=function()
	{
		var rc = obj.retGridItemPanel.getSelectionModel().getSelected();
		if(rc)
		{
			obj.Code.setValue(rc.get("tCode"))
			curRow=obj.Code.getValue();
			if(curRow!=lastRow)
			{
				obj.Code.setValue(rc.get("tCode"));
				obj.Code.disable() ;
				obj.ANCCTActiveItem.setValue(rc.get("tANCCTIActive")=="Y"?"1":"0");
				obj.ANCCTActiveItem.setRawValue(rc.get("tANCCTIActive")=="Y"?"是":"否");
				obj.ANCCTIChannelNo.setValue(rc.get("tANCCTIChannelNo"));
				obj.ANCCTIComOrd.setValue(rc.get("tANCCTIComOrdDr"));
				obj.ANCCTIComOrd.setRawValue(rc.get("tANCCTIComOrdDrDesc"));
				obj.ItemRowid.setValue(rc.get("trowid"));
				lastRow=curRow;
			}
			else
			{
				obj.Code.setValue("");
				obj.Code.enable() ;
				obj.ANCCTActiveItem.setValue("");
				obj.ANCCTActiveItem.setRawValue("");
				obj.ANCCTIChannelNo.setValue("");
				obj.ANCCTIComOrd.setValue("");
				obj.ANCCTIComOrd.setRawValue("");
				obj.ItemRowid.setValue("");
				curRow="";
				lastRow=curRow;
			}
		}
		else
		{
			obj.Code.enable() ;
		}
	}
	//20160902+dyl
	obj.addButtonItem_click=function()
	{
		var ANCCTIComOrdFlag=false;
		var Code=obj.Code.getValue();
		if(Code=="")
	    {
		    ExtTool.alert("提示","序号不能为空!");	
			return; 
	    }
		var ANCCTIChannelNo=obj.ANCCTIChannelNo.getValue();
		 if(ANCCTIChannelNo=="")
	    {
		    ExtTool.alert("提示","通道号不能为空!");	
			return; 
	    }
		var ANCCTActive=(obj.ANCCTActiveItem.getValue()=="1"?"Y":"N");
		var ANCCTIParref=obj.ANCCTRowid.getValue();
		var ANCCTIComOrdDr=obj.ANCCTIComOrd.getValue();
		 if(ANCCTIComOrdDr=="")
	    {
		    ExtTool.alert("提示","监护项目名称不能为空!");	
			return; 
	    }
		if(ANCCTIParref=="")
		{
			Ext.Msg.alert("提示","请在监护设备中选中一行!");
			return;
		}
		//---20190109 YuanLin 下拉框只能选择不允许手写
		var ANCCTIComOrdNum=obj.ANCCTIComOrdStore.data.items.length;
		var ANCCTIComOrdItems=obj.ANCCTIComOrdStore.data.items;
		if(ANCCTIComOrdDr!="")
		{
			if(ANCCTIComOrdNum!=0)
			{
				for (var i = 0; i < ANCCTIComOrdNum; i++)
				{
					if (ANCCTIComOrdDr == ANCCTIComOrdItems[i].data.MDIRowid)
					{
						ANCCTIComOrdFlag = true;
						break;
					}
				}
				if(!ANCCTIComOrdFlag)
				{
					ExtTool.alert("提示","监护项目名称请从下拉框选择!");
					return ;
				}
			}
			if(ANCCTIComOrdNum==0)
			{
				ExtTool.alert("提示","监护项目名称请从下拉框选择!");
				return ;
			}
		}
		else
		{
			var ANCCTIComOrdRaw=obj.ANCCTIComOrd.getRawValue();
			if(ANCCTIComOrdRaw!="")
			{
				ExtTool.alert("提示","监护项目名称请从下拉框选择!");
				return ;
			}
		}
		//alert(Code+"/"+ANCCTIChannelNo+"/"+ANCCTActive+"/"+ANCCTIParref+"/"+ANCCTIComOrdDr)
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
				
				ReloadItemPanelStore();			
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
				
				ReloadItemPanelStore();
	  		}
	    });	
	}
	//20160902+控制
	obj.updateButtonItem_click=function()
	{
		var ANCCTIComOrdFlag=false;
		var Rowid=obj.ItemRowid.getValue();
		if(Rowid=="")
	    {
		    ExtTool.alert("提示","请选中一条记录!");	
			return; 
	    }
		var Code=obj.Code.getValue();
		 if(Code=="")
	    {
		    ExtTool.alert("提示","序号不能为空!");	
			return; 
	    }
		var ANCCTIChannelNo=obj.ANCCTIChannelNo.getValue();
		 if(ANCCTIChannelNo=="")
	    {
		    ExtTool.alert("提示","通道号不能为空!");	
			return; 
	    }
		var ANCCTActive=(obj.ANCCTActiveItem.getValue()=="1"?"Y":"N");
		var ANCCTIParref=obj.ANCCTRowid.getValue();
		var ANCCTIComOrdDr=obj.ANCCTIComOrd.getValue();
		 if(ANCCTIComOrdDr=="")
	    {
		    ExtTool.alert("提示","监护项目名称不能为空!");	
			return; 
	    }
		//20160902+dyl
		//alert(ANCCTActive)
		if(ANCCTIParref=="")
		{
			Ext.Msg.alert("提示","请在监护设备中选中一行!");
			return;
		}
		//---20190109 YuanLin 下拉框只能选择不允许手写
		var ANCCTIComOrdNum=obj.ANCCTIComOrdStore.data.items.length;
		var ANCCTIComOrdItems=obj.ANCCTIComOrdStore.data.items;
		if(ANCCTIComOrdDr!="")
		{
			if(ANCCTIComOrdNum!=0)
			{
				for (var i = 0; i < ANCCTIComOrdNum; i++)
				{
					if (ANCCTIComOrdDr == ANCCTIComOrdItems[i].data.MDIRowid)
					{
						ANCCTIComOrdFlag = true;
						break;
					}
				}
				if(!ANCCTIComOrdFlag)
				{
					ExtTool.alert("提示","监护项目名称请从下拉框选择!");
					return ;
				}
			}
			if(ANCCTIComOrdNum==0)
			{
				ExtTool.alert("提示","监护项目名称请从下拉框选择!");
				return ;
			}
		}
		else
		{
			var ANCCTIComOrdRaw=obj.ANCCTIComOrd.getRawValue();
			if(ANCCTIComOrdRaw!="")
			{
				ExtTool.alert("提示","监护项目名称请从下拉框选择!");
				return ;
			}
		}
		//alert(Rowid+"^"+Code+"^"+ANCCTIChannelNo+"^"+ANCCTActive+"^"+ANCCTIParref+"^"+ANCCTIComOrdDr)
		
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
				 
				ReloadItemPanelStore();
	  	  	});
		}
		else
		{
			Ext.Msg.alert("提示","更新失败:"+ret);
			return;
		}
	};
	
	function ReloadItemPanelStore()
	{
		var ANCCTSource=obj.ANCCTSource.getValue();
		obj.retGridItemPanel.getSelectionModel().clearSelections();//清除所有选择
				
	  	obj.retGridItemPanelStore.load({}); 
		/*var ANCCTSource=obj.ANCCTSource.getValue();
		if(ANCCTSource=="I")
		{
			obj.ANCCTIComOrdStoreProxy.on('beforeload', function(objProxy, param){
				param.ClassName = 'web.DHCICUBedEquip';
				param.QueryName = 'FindMoniDataItem';
				param.Arg1 = obj.ANCCTIComOrd.getRawValue();
				param.ArgCnt = 1;
			});
			obj.ANCCTIComOrdStore.load({});
		}
		else
		{
			obj.ANCCTIComOrdStoreProxy.on('beforeload', function(objProxy, param){
				param.ClassName = 'web.DHCANCCollectType';
				param.QueryName = 'FindMoniDataItem';
				param.Arg1 = obj.ANCCTIComOrd.getRawValue();
				param.ArgCnt = 1;
			});
			obj.ANCCTIComOrdStore.load({});
		}
		
		obj.retGridItemPanel.getSelectionModel().clearSelections();//清除所有选择
		obj.retGridItemPanelStore.removeAll();
	  	obj.retGridItemPanelStore.load({}); 
		*/
	}
}