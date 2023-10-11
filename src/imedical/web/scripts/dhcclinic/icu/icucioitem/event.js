function InitViewScreenEvent(obj)
{
	obj.intCurrRowIndex = -1;
	var _DHCICUCIOItem=ExtTool.StaticServerObject('web.DHCICUCIOItem');
	
	obj.LoadEvent = function(args)
	{
	};
	var SelectedRowID = 0;
	var preRowID=0;
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){ 
	  	SelectedRowID=rc.get("tIcucioiId")
	  	if(preRowID!=SelectedRowID)
	    {  
		    obj.IcucioiId.setValue(rc.get("tIcucioiId"));
		    //alert(rc.get("tIcucioiId"))
		    obj.itemcode.setValue(rc.get("tIcucioiCode"));
		    obj.itemname.setValue(rc.get("tIcucioiDesc"));
		    obj.itemctloc.setValue(rc.get("tCtlocId"));
		    obj.itemynuse.setValue(rc.get("tIcucioiActive"));
			obj.itemynuse.setRawValue(rc.get("tIcucioiActiveDesc"));
		    obj.itemtype.setValue(rc.get("tIcucioiType"));
		    //obj.itemviewcat.setValue(rc.get("tAncvcId"));
			//obj.itemviewcat.setRawValue(rc.get("tAncvcDesc"));
		    //alert(rc.get("tAncvcId"))
		    obj.itemcomorder.setValue(rc.get("tAncoId"));
			obj.itemcomorder.setRawValue(rc.get("tAncoDesc"));
		    obj.itemusemethod.setValue(rc.get("tPhcinId"));
			//obj.IcucioiDr.setValue(rc.get("tIcucioiDr"));	//20160831+dyl
			//obj.IcucioiStrategy.setValue(rc.get(""));
			obj.IcucioiStrategy.setValue(rc.get("tIcucioiStrategyDesc"));
			obj.IcucioiStrategy.setRawValue(rc.get("tIcucioiStrategyDesc"));
			obj.IcucioiDrDesc.setValue(rc.get("tIcucioiDr"));	//主项名称Id+20160914
			obj.IcucioiDrDesc.setRawValue(rc.get("tIcucioiDrDesc"));
			obj.IcucioiValueField.setValue(rc.get("tIcucioiValueField"));
			obj.IcucioiValueField.setRawValue(rc.get("tIcucioiValueField"));
			obj.IcucioiMultiple.setValue(rc.get("tIcucioiMultiple"));
			preRowID=SelectedRowID;
		}
		else
			{
				obj.IcucioiId.setValue("");
		    obj.itemcode.setValue("");
		    obj.itemname.setValue("");
		    obj.itemctloc.setValue("");
		    obj.itemynuse.setValue("");
			obj.itemynuse.setRawValue("");
		    obj.itemtype.setValue("");
		    //obj.itemviewcat.setValue("");
			//obj.itemviewcat.setRawValue("");
		    obj.itemcomorder.setValue("");
			obj.itemcomorder.setRawValue("");
		    obj.itemusemethod.setValue("");
			//obj.IcucioiDr.setValue(rc.get("tIcucioiDr"));	//20160831+dyl
			//obj.IcucioiStrategy.setValue(rc.get(""));
			obj.IcucioiStrategy.setRawValue("");
			obj.IcucioiDrDesc.setValue("");	//主项名称Id+20160914
			obj.IcucioiDrDesc.setRawValue("");
			//obj.IcucioiValueField.setValue(rc.get(""));
			obj.IcucioiValueField.setRawValue("");
			obj.IcucioiMultiple.setValue("");
			obj.retGridPanel.getSelectionModel().clearSelections();
		     SelectedRowID = 0;
		    preRowID=0;
			}
	  }
	};
	
	obj.addbutton_click = function()
	{
		var itemctlocFlag=false;
		var itemcomorderFlag=false;
		if(obj.itemcode.getValue()=="")
		{
			ExtTool.alert("提示","代码不能为空!");	
			return;
		}
		if(obj.itemname.getValue()=="")
		{
			ExtTool.alert("提示","描述不能为空!");	
			return;
		}
		/*if(obj.itemviewcat.getValue()=="")
		{
			ExtTool.alert("提示","显示分类不能为空!");	
			return;
		}*/
		/*if(obj.itemtype.getValue()=="")
		{
			ExtTool.alert("提示","出入量类型不能为空!");	
			return;
		}*/
		//var RowId = obj.RowId.getValue();
		var itemcode=obj.itemcode.getValue();           //代码
		var itemname=obj.itemname.getValue();           //名称
		var itemtype=obj.itemtype.getValue();         //类型
		//alert(itemtype)
		var itemcomorder=obj.itemcomorder.getValue();      //常用医嘱
        //alert(itemcomorder)
		//var itemviewcat=obj.itemviewcat.getValue();         //显示分类
        //alert(itemviewcat)
		var itemusemethod=obj.itemusemethod.getValue();   //用法
		var itemynuse=obj.itemynuse.getValue();       //是否可用
		var itemctloc=obj.itemctloc.getValue();          //科室
		var icucioiDr=obj.IcucioiDrDesc.getValue();	//20160831+dyl
		//var icucioiDr=obj.IcucioiDr.getValue();	//20160831
		var icucioiStrategy=obj.IcucioiStrategy.getValue();
		var icucioiMultiple=obj.IcucioiMultiple.getValue();
		var icucioiValueField=obj.IcucioiValueField.getValue();
		//---20190110 YuanLin 下拉框只能选择不允许手写
		//科室
		var itemctlocNum=obj.itemctlocstore.data.items.length;
		var itemctlocItems=obj.itemctlocstore.data.items;
		if(itemctloc!="")
		{
			if(itemctlocNum!=0)
			{
				for (var i = 0; i < itemctlocNum; i++)
				{
					if (itemctloc == itemctlocItems[i].data.ctlocId)
					{
						itemctlocFlag = true;
						break;
					}
				}
				if(!itemctlocFlag)
				{
					ExtTool.alert("提示","科室请从下拉框选择!");
					return ;
				}
			}
			if(itemctlocNum==0)
			{
				ExtTool.alert("提示","科室请从下拉框选择!");
				return ;
			}
		}
		else
		{
			var itemctlocRaw=obj.itemctloc.getRawValue();
			if(itemctlocRaw!="")
			{
				ExtTool.alert("提示","科室请从下拉框选择!");
				return ;
			}
		}
		//常用医嘱
		var itemcomorderNum=obj.itemcomorderstore.data.items.length;
		var itemcomorderItems=obj.itemcomorderstore.data.items;
		if(itemcomorder!="")
		{
			if(itemcomorderNum!=0)
			{
				for (var i = 0; i < itemcomorderNum; i++)
				{
					if (itemcomorder == itemcomorderItems[i].data.ID)
					{
						itemcomorderFlag = true;
						break;
					}
				}
				if(!itemcomorderFlag)
				{
					ExtTool.alert("提示","常用医嘱请从下拉框选择!");
					return ;
				}
			}
			if(itemcomorderNum==0)
			{
				ExtTool.alert("提示","常用医嘱请从下拉框选择!");
				return ;
			}
		}
		else
		{
			var itemcomorderRaw=obj.itemcomorder.getRawValue();
			if(itemcomorderRaw!="")
			{
				ExtTool.alert("提示","常用医嘱请从下拉框选择!");
				return ;
			}
		}
		var ret=_DHCICUCIOItem.InsertICUCIOItem(itemcode,itemname,itemtype,itemcomorder,"",itemusemethod,itemynuse,itemctloc,icucioiDr,icucioiStrategy,icucioiMultiple,icucioiValueField);
		//alert(ret)
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","添加失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","添加成功!",function(){
			obj.IcucioiId.setValue("");
			obj.itemcode.setValue("");
			obj.itemname.setValue("");
			obj.itemctloc.setValue("");
			obj.itemynuse.setValue("");
			obj.itemynuse.setRawValue("");
			obj.itemtype.setValue("");
			//obj.itemviewcat.setValue("");
			//obj.itemviewcat.setRawValue("");
			obj.itemcomorder.setValue("");
			obj.itemcomorder.setRawValue("");
			obj.itemusemethod.setValue("");
			//obj.IcucioiDr.setValue("");
			obj.IcucioiStrategy.setRawValue("");
			obj.IcucioiDrDesc.setValue("");
			obj.IcucioiDrDesc.setRawValue("");
			obj.IcucioiValueField.setRawValue("");
			obj.IcucioiMultiple.setValue("");
	  	  	obj.retGridPanelStore.load({});  	
	  	  	});
		}
	};
	
	obj.updatebutton_click = function()
	{
		var itemctlocFlag=false;
		var itemcomorderFlag=false;
		if(obj.IcucioiId.getValue()=="")
		{
			ExtTool.alert("提示","记录ID不能为空!");	
			return;
		}
		if(obj.itemcode.getValue()=="")
		{
			ExtTool.alert("提示","代码不能为空!");	
			return;
		}
		if(obj.itemname.getValue()=="")
		{
			ExtTool.alert("提示","描述不能为空!");	
			return;
		}
		/*if(obj.itemviewcat.getValue()=="")
		{
			ExtTool.alert("提示","显示分类不能为空!");	
			return;
		}
		*/
		/*if(obj.itemtype.getValue()=="")
		{
			ExtTool.alert("提示","出入量类型不能为空!");	
			return;
		}*/
		var IcucioiId = obj.IcucioiId.getValue();
		var itemcode=obj.itemcode.getValue();           //代码
		var itemname=obj.itemname.getValue();           //名称
		var itemtype=obj.itemtype.getValue();         //类型
		var itemcomorder=obj.itemcomorder.getValue();      //常用医嘱
		//var itemviewcat=obj.itemviewcat.getValue();         //显示分类
		var itemusemethod=obj.itemusemethod.getValue();   //用法
		var itemynuse=obj.itemynuse.getValue();       //是否可用
		var itemctloc=obj.itemctloc.getValue();          //科室
		//var icucioiDr=obj.IcucioiDr.getValue();	//20160831+dyl
		var icucioiDr=obj.IcucioiDrDesc.getValue();
		var icucioiStrategy=obj.IcucioiStrategy.getValue();
		//alert(icucioiStrategy)
		var icucioiMultiple=obj.IcucioiMultiple.getValue();
		var icucioiValueField=obj.IcucioiValueField.getValue();
		//---20190110 YuanLin 下拉框只能选择不允许手写
		//科室
		var itemctlocNum=obj.itemctlocstore.data.items.length;
		var itemctlocItems=obj.itemctlocstore.data.items;
		if(itemctloc!="")
		{
			if(itemctlocNum!=0)
			{
				for (var i = 0; i < itemctlocNum; i++)
				{
					if (itemctloc == itemctlocItems[i].data.ctlocId)
					{
						itemctlocFlag = true;
						break;
					}
				}
				if(!itemctlocFlag)
				{
					ExtTool.alert("提示","科室请从下拉框选择!");
					return ;
				}
			}
			if(itemctlocNum==0)
			{
				ExtTool.alert("提示","科室请从下拉框选择!");
				return ;
			}
		}
		else
		{
			var itemctlocRaw=obj.itemctloc.getRawValue();
			if(itemctlocRaw!="")
			{
				ExtTool.alert("提示","科室请从下拉框选择!");
				return ;
			}
		}
		//常用医嘱
		var itemcomorderNum=obj.itemcomorderstore.data.items.length;
		var itemcomorderItems=obj.itemcomorderstore.data.items;
		if(itemcomorder!="")
		{
			if(itemcomorderNum!=0)
			{
				for (var i = 0; i < itemcomorderNum; i++)
				{
					if (itemcomorder == itemcomorderItems[i].data.ID)
					{
						itemcomorderFlag = true;
						break;
					}
				}
				if(!itemcomorderFlag)
				{
					ExtTool.alert("提示","常用医嘱请从下拉框选择!");
					return ;
				}
			}
			if(itemcomorderNum==0)
			{
				ExtTool.alert("提示","常用医嘱请从下拉框选择!");
				return ;
			}
		}
		else
		{
			var itemcomorderRaw=obj.itemcomorder.getRawValue();
			if(itemcomorderRaw!="")
			{
				ExtTool.alert("提示","常用医嘱请从下拉框选择!");
				return ;
			}
		}
        //alert(IcucioiId+"^"+itemcode+"^"+itemname+"^"+itemtype+"^"+itemcomorder+"^"+itemviewcat+"^"+itemusemethod+"^"+itemynuse+"^"+itemctloc)
		var ret=_DHCICUCIOItem.UpdateICUCIOItem(IcucioiId,itemcode,itemname,itemtype,itemcomorder,"",itemusemethod,itemynuse,itemctloc,icucioiDr,icucioiStrategy,icucioiMultiple,icucioiValueField);
		//alert(ret)
		if(ret!=0)
		{
		  Ext.Msg.alert("提示","更新失败！"+ret);	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
			obj.IcucioiId.setValue("");
			obj.itemcode.setValue("");
			obj.itemname.setValue("");
			obj.itemctloc.setValue("");
			obj.itemynuse.setValue("");
			obj.itemynuse.setRawValue("");
			obj.itemtype.setValue("");
			//obj.itemviewcat.setValue("");
			//obj.itemviewcat.setRawValue("");
			obj.itemcomorder.setValue("");
			obj.itemcomorder.setRawValue("");
			obj.itemusemethod.setValue("");
			//obj.IcucioiDr.setValue("");	//20160831+dyl
			obj.IcucioiStrategy.setRawValue("");
			obj.IcucioiDrDesc.setValue("");
			obj.IcucioiDrDesc.setRawValue("");
			obj.IcucioiValueField.setRawValue("");
			obj.IcucioiMultiple.setValue(""); 
	  	  	obj.retGridPanelStore.load({});  
		  	});
	     }
	 };
	 
	obj.deletebutton_click = function()
	{
	  var ID=obj.IcucioiId.getValue();
	  //alert(ID);
	  if(ID=="")
	  {
	    Ext.Msg.alert("提示","请选择一条要删除的记录！");
	    return;
	  }
	  Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCICUCIOItem.DeleteICUCIOItem(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
			obj.IcucioiId.setValue("");
			obj.itemcode.setValue("");
			obj.itemname.setValue("");
			obj.itemctloc.setValue("");
			obj.itemynuse.setValue("");
			obj.itemynuse.setRawValue("");
			obj.itemtype.setValue("");
			//obj.itemviewcat.setValue("");
			//obj.itemviewcat.setRawValue("");
			obj.itemcomorder.setValue("");
			obj.itemcomorder.setRawValue("");
			obj.itemusemethod.setValue("");
			//obj.IcucioiDr.setValue("");	//20160831+dyl
			obj.IcucioiStrategy.setRawValue("");
			obj.IcucioiDrDesc.setValue("");
			obj.IcucioiDrDesc.setRawValue("");
			obj.IcucioiValueField.setRawValue("");
			obj.IcucioiMultiple.setValue("");  
	  	  	obj.retGridPanelStore.load({});  
		  	});

	  	}
	  );
	};
	
	obj.findbutton_click = function(){
		obj.retGridPanelStore.removeAll();
		obj.retGridPanelStore.load({});
			//obj.IcucioiId.setValue("");
			//obj.itemcode.setValue("");
			//obj.itemname.setValue("");
			//obj.itemctloc.setValue("");
			//obj.itemynuse.setValue("");
			//obj.itemynuse.setRawValue("");
			//obj.itemtype.setValue("");
			//obj.itemviewcat.setValue("");
			//obj.itemviewcat.setRawValue("");
			//obj.itemcomorder.setValue("");
			//obj.itemcomorder.setRawValue("");
			//obj.itemusemethod.setValue("");
			//obj.IcucioiDr.setValue("");	//20160831+dyl
			//obj.IcucioiStrategy.setRawValue("");
			//obj.IcucioiDrDesc.setValue("");
			//obj.IcucioiDrDesc.setRawValue("");
			//obj.IcucioiValueField.setRawValue("");
			//obj.IcucioiMultiple.setValue("");  
		obj.intCurrRowIndex = -1;
	};
}