function InitViewScreenEvent(obj)
{
	var _DHCICUCTemperature=ExtTool.StaticServerObject('web.DHCICUCTemperature');
	obj.LoadEvent = function(args)
	{
	};
	
	var SelectedRowID = 0;
	var preRowID=0;	 
	obj.retGridPanel_rowclick=function(){
		
		var rc = obj.retGridPanel.getSelectionModel().getSelected();
	    if (rc){
		    SelectedRowID=rc.get("RowId");
		    if(preRowID!=SelectedRowID)
		    {
			    obj.RowId.setValue(rc.get("RowId"));
			    obj.RecordItem.setValue(rc.get("RecordItemId"));
			    obj.ObserveItem.setValue(rc.get("ObserveItemId"));
			    obj.ObserveItem.setRawValue(rc.get("ObserveItem"));
			    obj.DayFactor.setValue(rc.get("DayFactor"));
			    obj.StartTime.setValue(rc.get("StartTime"));
			    obj.ValidSpan.setValue(rc.get("ValidSpan"));
			    obj.Type.setValue(rc.get("Type"));
			    obj.UpperThreshold.setValue(rc.get("UpperThreshold"));
			    obj.Interval.setValue(rc.get("Interval"));
			    obj.SummaryInsertTime.setValue(rc.get("SummaryInsertTime"));
			    obj.Ctloc.setValue(rc.get("CtlocId"));
			    obj.Strategy.setRawValue(rc.get("Strategy"));
			    obj.SpareIcucriCode.setRawValue(rc.get("SpareIcucriCode"));
			    preRowID=SelectedRowID;
		    }else{
			    obj.RowId.setValue("");
			    obj.RecordItem.setValue("");
			    obj.ObserveItem.setValue("");
			    obj.ObserveItem.setRawValue("");
			    obj.DayFactor.setValue("");
			    obj.StartTime.setValue("");
			    obj.ValidSpan.setValue("");
			    obj.Type.setValue("");
			    obj.UpperThreshold.setValue("");
			    obj.Interval.setValue("");
			    obj.SummaryInsertTime.setValue("");
			    obj.Ctloc.setValue("");
			    obj.Strategy.setRawValue("");
			    obj.SpareIcucriCode.setRawValue("");
			    SelectedRowID = 0;
		        preRowID=0;
			}
	    }
		
	}
	
	obj.addbutton_click=function(){
		var recordItemId=obj.RecordItem.getValue();
		if(recordItemId=="")
		{
			alert("常用医嘱不能为空！");
			return;
		}
		var observeItemId=obj.ObserveItem.getValue();
		if(observeItemId=="")
		{
			alert("体温单项目不能为空！");
			return;
		}
		var dayFactor=obj.DayFactor.getValue();
		var startTime=obj.StartTime.getValue();
		var validSpan=obj.ValidSpan.getValue();
		var upperThreshold=obj.UpperThreshold.getValue();
		var interval=obj.Interval.getValue();
		var comtype=obj.Type.getValue();
		var summaryInsertTime=obj.SummaryInsertTime.getValue();
		var ctlocId=obj.Ctloc.getValue();
		var strategy=obj.Strategy.getValue();
		var spareIcucriCode=obj.SpareIcucriCode.getValue();
		var ret=_DHCICUCTemperature.SaveICUCTemper("",recordItemId,observeItemId,dayFactor,startTime,validSpan,upperThreshold,interval,comtype,summaryInsertTime,ctlocId,strategy,spareIcucriCode);
		if(ret<0) 
		{ 
		     Ext.Msg.alert("提示","添加失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","添加成功!",function(){
			    obj.RecordItem.setValue("");
			    obj.ObserveItem.setValue("");
			    obj.ObserveItem.setRawValue("");
			    obj.DayFactor.setValue("");
			    obj.StartTime.setValue("");
			    obj.ValidSpan.setValue("");
			    obj.Type.setValue("");
			    obj.UpperThreshold.setValue("");
			    obj.Interval.setValue("");
			    obj.SummaryInsertTime.setValue("");
			    obj.Ctloc.setValue("");
			    obj.Strategy.setRawValue("");
			    obj.SpareIcucriCode.setRawValue("");	
			    obj.retGridPanelStore.load({});  	
	  	  	});
		}
	}
	obj.updatebutton_click=function(){
		var rowId=obj.RowId.getValue();
		if(rowId=="")
		{
			alert("请选择要修改的行！");
			return;
		}
		var recordItemId=obj.RecordItem.getValue();
		if(recordItemId=="")
		{
			alert("常用医嘱不能为空！");
			return;
		}
		var observeItemId=obj.ObserveItem.getValue();
		if(observeItemId=="")
		{
			alert("体温单项目不能为空！");
			return;
		}
		var dayFactor=obj.DayFactor.getValue();
		var startTime=obj.StartTime.getValue();
		var validSpan=obj.ValidSpan.getValue();
		var upperThreshold=obj.UpperThreshold.getValue();
		var interval=obj.Interval.getValue();
		var comtype=obj.Type.getValue();
		var summaryInsertTime=obj.SummaryInsertTime.getValue();
		var ctlocId=obj.Ctloc.getValue();
		var strategy=obj.Strategy.getValue();
		var spareIcucriCode=obj.SpareIcucriCode.getValue();
		var ret=_DHCICUCTemperature.SaveICUCTemper(rowId,recordItemId,observeItemId,dayFactor,startTime,validSpan,upperThreshold,interval,comtype,summaryInsertTime,ctlocId,strategy,spareIcucriCode);
		if(ret<0) 
		{ 
		     Ext.Msg.alert("提示","修改失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","修改成功!",function(){
				obj.RowId.setValue("");
			    obj.RecordItem.setValue("");
			    obj.ObserveItem.setValue("");
			    obj.ObserveItem.setRawValue("");
			    obj.DayFactor.setValue("");
			    obj.StartTime.setValue("");
			    obj.ValidSpan.setValue("");
			    obj.Type.setValue("");
			    obj.UpperThreshold.setValue("");
			    obj.Interval.setValue("");
			    obj.SummaryInsertTime.setValue("");
			    obj.Ctloc.setValue("");
			    obj.Strategy.setRawValue("");
			    obj.SpareIcucriCode.setRawValue("");
			    obj.retGridPanelStore.load({});  		
	  	  	});
		}
	}
	obj.deletebutton_click=function(){
		var rowId=obj.RowId.getValue();
		if(rowId=="")
		{
			alert("请选择要删除的行！");
			return;
		}
		var ret=_DHCICUCTemperature.RemoveICUCTemper(rowId)
		if(ret!=0) 
		{ 
		     Ext.Msg.alert("提示","删除失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","删除成功!",function(){
				obj.RowId.setValue("");
			    obj.RecordItem.setValue("");
			    obj.ObserveItem.setValue("");
			    obj.ObserveItem.setRawValue("");
			    obj.DayFactor.setValue("");
			    obj.StartTime.setValue("");
			    obj.ValidSpan.setValue("");
			    obj.Type.setValue("");
			    obj.UpperThreshold.setValue("");
			    obj.Interval.setValue("");
			    obj.SummaryInsertTime.setValue("");
			    obj.Ctloc.setValue("");
			    obj.Strategy.setRawValue("");
			    obj.SpareIcucriCode.setRawValue("");
			    obj.retGridPanelStore.load({});  		
	  	  	});
		}
	}

}