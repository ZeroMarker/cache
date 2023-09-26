function InitViewScreenEvent(obj)
{
	var _DHCICUCommonOrdMapping=ExtTool.StaticServerObject('web.DHCICUCommonOrdMapping');
	
	obj.retGridPanel_rowclick=function()
	{
		var rc = obj.retGridPanel.getSelectionModel().getSelected();
	    if (rc)
	    {
		    obj.ViewSuperCat.setValue(rc.get("tViewSuperCatIDT"));
		    obj.ViewSuperCat.setRawValue(rc.get("tViewSuperCatDescT"));
		    obj.ViewCat.setValue(rc.get("tViewCatIDT"));
		    obj.ViewCat.setRawValue(rc.get("tViewCatDescT"));
		    obj.Arcim.setValue(rc.get("tArcimIDT"));
		    obj.Arcim.setRawValue(rc.get("tArcimDescT"));
		    obj.OeoriNote.setValue(rc.get("tOeoriNoteT"));
		    
		    obj.Anco.setValue(rc.get("tAncoId"));
		    obj.Anco.setRawValue(rc.get("tAncoDesc"));
		    obj.SpeedUnit.setValue(rc.get("tSpeedUnitId"));
		    obj.SpeedUnit.setRawValue(rc.get("tSpeedUnitDesc"));
		    obj.Uom.setValue(rc.get("tUomId"));
		    obj.Uom.setRawValue(rc.get("tUomDesc"));
		    
		    obj.PrepareVolume.setValue(rc.get("tPrepareVolume"));
		    obj.Abbreviate.setValue(rc.get("tAbbreviate"));
		    obj.Qty.setValue(rc.get("tQty"));
		    
		    obj.DefSpeed.setValue(rc.get("tDefSpeed"));
		    obj.Density.setValue(rc.get("tDensity"));
		    obj.Dept.setValue(rc.get("tDeptId"));
		    obj.Dept.setRawValue(rc.get("tDeptDesc"));
		    
		}
	};
	
	obj.addButton_click=function()
	{
		var viewSuperCat = obj.ViewSuperCat.getValue();
		if(viewSuperCat=="")
		{
			Ext.Msg.alert("提示","医嘱大类不能为空");
			return;
		}
		
		var viewCat = obj.ViewCat.getValue();
		var arcim=obj.Arcim.getValue();
		var speedUnit=obj.SpeedUnit.getValue();
		var anco=obj.Anco.getValue();
		if((anco=="")&&(viewSuperCat!=""))
		{
			Ext.Msg.alert("提示","常用医嘱不能为空");
			return;
		}
		var oeoriNote=obj.OeoriNote.getValue();
		var uom=obj.Uom.getValue();
		var density=obj.Density.getValue();
		var qty=obj.Qty.getValue();
		var prepareVolume=obj.PrepareVolume.getValue();
		var abbreviate=obj.Abbreviate.getValue();
		var defSpeed=obj.DefSpeed.getValue();
		var deptId=obj.Dept.getValue();
		
		var ret = _DHCICUCommonOrdMapping.InsertOrdMapping(viewSuperCat,viewCat,arcim,speedUnit,anco,oeoriNote,uom,density,qty,prepareVolume,abbreviate,defSpeed,deptId);
		if(ret=="0")
		{
			Ext.Msg.alert("提示","添加成功");
			obj.retGridPanelStore.load({});
			obj.ViewSuperCat.setValue("");
		    obj.ViewSuperCat.setRawValue("");
		    obj.ViewCat.setValue("");
		    obj.ViewCat.setRawValue("");
		    obj.Arcim.setValue("");
		    obj.Arcim.setRawValue("");
		    obj.OeoriNote.setValue("");
		    
		    obj.Anco.setValue("");
		    obj.Anco.setRawValue("");
		    obj.SpeedUnit.setValue("");
		    obj.SpeedUnit.setRawValue("");
		    obj.Uom.setValue("");
		    obj.Uom.setRawValue("");
		    
		    obj.PrepareVolume.setValue("");
		    obj.Abbreviate.setValue("");
		    obj.Qty.setValue("");
		    
		    obj.DefSpeed.setValue("");
		    obj.Density.setValue("");
		    obj.Dept.setValue("");
		    obj.Dept.setRawValue("");
		}
		else
		{
			Ext.Msg.alert("提示","添加失败:"+ret);
		}
	};
	
	obj.deleteButton_click=function()
	{
		var viewSuperCat = obj.ViewSuperCat.getValue();
		if(viewSuperCat=="")
		{
			Ext.Msg.alert("提示","医嘱大类不能为空");
			return;
		}
		var viewCat = obj.ViewCat.getValue();
		var arcim=obj.Arcim.getValue();
		var oeoriNote=obj.OeoriNote.getValue();
		var ret = _DHCICUCommonOrdMapping.DeleteOrdMapping(viewSuperCat,viewCat,arcim,oeoriNote);
		if(ret=="0")
		{
			Ext.Msg.alert("提示","删除成功");
			obj.retGridPanelStore.load({});
			
			obj.ViewSuperCat.setValue("");
		    obj.ViewSuperCat.setRawValue("");
		    obj.ViewCat.setValue("");
		    obj.ViewCat.setRawValue("");
		    obj.Arcim.setValue("");
		    obj.Arcim.setRawValue("");
		    obj.OeoriNote.setValue("");
		    
		    obj.Anco.setValue("");
		    obj.Anco.setRawValue("");
		    obj.SpeedUnit.setValue("");
		    obj.SpeedUnit.setRawValue("");
		    obj.Uom.setValue("");
		    obj.Uom.setRawValue("");
		    
		    obj.PrepareVolume.setValue("");
		    obj.Abbreviate.setValue("");
		    obj.Qty.setValue("");
		    
		    obj.DefSpeed.setValue("");
		    obj.Density.setValue("");
		    obj.Dept.setValue("");
		    obj.Dept.setRawValue("");
		    //obj.retGridPanelStore.load({});
		}
		else
		{
			Ext.Msg.alert("提示","删除失败:"+ret);
		}
	};
	
	obj.saveButton_click=function()
	{
		var viewSuperCat = obj.ViewSuperCat.getValue();
		if(viewSuperCat=="")
		{
			Ext.Msg.alert("提示","医嘱大类不能为空");
			return;
		}
		
		var viewCat = obj.ViewCat.getValue();
		var arcim=obj.Arcim.getValue();
		var speedUnit=obj.SpeedUnit.getValue();
		var anco=obj.Anco.getValue();
		if((anco=="")&&(viewSuperCat!=""))
		{
			Ext.Msg.alert("提示","常用医嘱不能为空");
			return;
		}
		var oeoriNote=obj.OeoriNote.getValue();
		var uom=obj.Uom.getValue();
		var density=obj.Density.getValue();
		var qty=obj.Qty.getValue();
		var prepareVolume=obj.PrepareVolume.getValue();
		var abbreviate=obj.Abbreviate.getValue();
		var defSpeed=obj.DefSpeed.getValue();
		var deptId=obj.Dept.getValue();
		
		var ret = _DHCICUCommonOrdMapping.UpdateOrdMapping(viewSuperCat,viewCat,arcim,speedUnit,anco,oeoriNote,uom,density,qty,prepareVolume,abbreviate,defSpeed,deptId);
		if(ret=="0")
		{
			Ext.Msg.alert("提示","保存成功");
			obj.retGridPanelStore.load({});
			obj.ViewSuperCat.setValue("");
		    obj.ViewSuperCat.setRawValue("");
		    obj.ViewCat.setValue("");
		    obj.ViewCat.setRawValue("");
		    obj.Arcim.setValue("");
		    obj.Arcim.setRawValue("");
		    obj.OeoriNote.setValue("");
		    
		    obj.Anco.setValue("");
		    obj.Anco.setRawValue("");
		    obj.SpeedUnit.setValue("");
		    obj.SpeedUnit.setRawValue("");
		    obj.Uom.setValue("");
		    obj.Uom.setRawValue("");
		    
		    obj.PrepareVolume.setValue("");
		    obj.Abbreviate.setValue("");
		    obj.Qty.setValue("");
		    
		    obj.DefSpeed.setValue("");
		    obj.Density.setValue("");
		    obj.Dept.setValue("");
		    obj.Dept.setRawValue("");
		}
		else
		{
			Ext.Msg.alert("提示","保存失败:"+ret);
		}
	};
}