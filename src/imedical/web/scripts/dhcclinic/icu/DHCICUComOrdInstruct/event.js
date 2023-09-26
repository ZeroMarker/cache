function InitViewScreenEvent(obj)
{
	var _DHCICUCode=ExtTool.StaticServerObject('web.DHCICUCode');
	
	obj.LoadEvent = function(args)
	{
		//取默认药品常用医嘱
		var ret=_DHCICUCode.GetOrdDefault();
		var OrdDefaultStr=ret.split("@");
		//alert(ret);
		if(OrdDefaultStr)
		{
			obj.defaultOrd.setRawValue(OrdDefaultStr[1]);
			obj.defaultOrd.setValue(OrdDefaultStr[0]);
		}
	};
	
	
	//保存默认药品常用医嘱
	obj.saveDefaultOrdButton_click = function()
	{
		var OrdDefaultId=obj.defaultOrd.getValue();
		var ret=_DHCICUCode.SaveDefaultOrdData(OrdDefaultId);
		if(ret=="0")
		{
			Ext.Msg.alert("提示","保存成功!");
		}
		else
		{
			Ext.Msg.alert("提示","保存失败!");
		}
	}
	
	//"添加>>"按钮
	obj.AddOrdInstrucButton_click = function()
	{
		var rcs = obj.dphcin.getSelectionModel().getSelections();
		var len=rcs.length;
		if(len>0)
		{
			for(var i=0; i< len; i++)
			{
				var phcinrowid=rcs[i].get("phcinrowid");
				var phcinDesc=rcs[i].get("phcinDesc");
				if(isExist(phcinrowid))
				{
					continue;
				}
				var rec = new (obj.unUsePhcinDescStore.recordType)();
				rec.set('unusephcinid',phcinrowid);
				rec.set('unusephcindesc',phcinDesc);
				obj.unUsePhcinDescStore.add(rec);
				SaveUnUsePhcin();
			}
		}
		else
		{
			Ext.Msg.alert("提示","请至少在用药途径中选择一行");
		}
	}
	
	//判断要添加的用药途径是否在不关联常用医嘱中存在
	function isExist(phcinrowid)
	{
		for(var i=0; i<obj.unUsePhcinDescStore.getCount(); i++)
		{
			var unusephcinid=obj.unUsePhcinDescStore.getAt(i).get("unusephcinid");
			if(phcinrowid==unusephcinid)
			{
				return true;
			}
		}
		return false;
	}
	
	//"移除<<"按钮
	obj.DelOrdInstrucButton_click=function()
	{
		var rcs = obj.unUsePhcinDesc.getSelectionModel().getSelections();
		var len=rcs.length;
		
		if(len>0)
		{
			for(var i=0;i<len;i++)
			{
				obj.unUsePhcinDescStore.remove(rcs[i]);
				SaveUnUsePhcin();
			}
		}
		else
		{
			Ext.Msg.alert("提示","请至少在不关联常用医嘱的用药途径中选择一行");
		}
	}
	
	//保存不关联常用医嘱的用药途径
	function SaveUnUsePhcin()
	{
		var PHCINIdStr="";
		for(var i=0; i<obj.unUsePhcinDescStore.getCount(); i++)
		{
			var unusephcinid=obj.unUsePhcinDescStore.getAt(i).get("unusephcinid");
			if(PHCINIdStr=="")
			{
				PHCINIdStr=unusephcinid;
			}
			else
			{
				PHCINIdStr=PHCINIdStr+"^"+unusephcinid;
			}
		}
		//alert(PHCINIdStr);
		//return;
		var ret=_DHCICUCode.SaveUnusePhcin(PHCINIdStr);
		if(ret!="0")
		{
			Ext.Msg.alert("提示","保存不关联常用医嘱的用药途径失败!");
			return;
		}
	}
	
	obj.saveButton_click=function()
	{
		var ancorowid=obj.dancoDesc.getValue();
		var phcinrowidStr="";
		var rcs = obj.dphcin.getSelectionModel().getSelections();
		for(var i=0; i< rcs.length; i++)
		{
			var phcinrowid=rcs[i].get("phcinrowid");
			if(phcinrowidStr=="")
			{
				phcinrowidStr=phcinrowid;
			}
			else
			{
				phcinrowidStr=phcinrowidStr+"^"+phcinrowid;
			}
		}
		//alert("ancorowid:"+ancorowid);
		//alert("phcinrowidStr:"+phcinrowidStr);
		if(ancorowid=="")
		{
			Ext.Msg.alert("提示","常用药品医嘱不能为空");
			return;
		}
		var ret=_DHCICUCode.SaveOrdPhcinData(ancorowid,phcinrowidStr);
		if(ret=="0")
		{
			Ext.Msg.alert("提示","保存成功");
			obj.dancoDesc.setValue("");
      //obj.dphcinID.SetValue("");
			obj.retGridPanelStore.load({});
		}
		else
		{
			Ext.Msg.alert("提示","保存失败:"+ret);
		}
	}
	
	obj.deleteButton_click=function()
	{
		var dancoRowid=obj.dancoDesc.getValue();
		if(dancoRowid!="")
		{
			//alert(dancoRowid);
			//return;
			var ret=_DHCICUCode.DelOrdPhcinData(dancoRowid);
			if(ret=="0")
			{
				Ext.Msg.alert("提示","删除成功");
				obj.dancoDesc.setValue("");
				obj.retGridPanelStore.load({});
			}
			else
			{
				Ext.Msg.alert("提示","删除失败:"+ret);
			}
		}
		else
		{
			Ext.Msg.alert("提示","常用药品医嘱不能为空!");
		}
	}
	
	obj.findButton_click=function()
	{
		obj.retGridPanelStore.load({});
	}
	
	obj.retGridPanel_rowclick=function()
	{
		var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  	if (rc)
	  	{
		  	obj.dancoDesc.setValue(rc.get("dancoRowid"));
		  	obj.dancoDesc.setRawValue(rc.get("dancoDesc"));
		  	
		  	obj.dphcin.getSelectionModel().clearSelections();//清除所有选择
		  	
		  	var phcinrowidStr=rc.get("dphcinRowid");
		  	var phcinrowidArray=phcinrowidStr.split("^");
		  	var firstSelectRowIndex=-1;
		  	var rowIndex=0;
		  	for(var i=0; i<obj.dphcinStore.getCount(); i++)
		  	{
			  	var dphcinid=obj.dphcinStore.getAt(i).get("phcinrowid");
			  	for(var j=0; j<phcinrowidArray.length; j++)
			  	{
				  	if(dphcinid==phcinrowidArray[j])
				  	{
					  	obj.dphcin.getSelectionModel().selectRow(rowIndex, true);
					  	//第一个选中的行
					  	if(firstSelectRowIndex==-1)
					  	{
						  	firstSelectRowIndex=rowIndex;
						}
					}
				  	
				}
				rowIndex++;
			}
			//聚焦到第一个选中的行
			if(firstSelectRowIndex>=0)
			{
			  	obj.dphcin.getView().focusRow(firstSelectRowIndex);
			}
	  	}
	}
}