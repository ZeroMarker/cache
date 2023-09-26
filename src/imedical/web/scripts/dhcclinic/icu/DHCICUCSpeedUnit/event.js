function InitViewScreenEvent(obj)
{
var _DHCICUCSpeedUnit=ExtTool.StaticServerObject('web.DHCICUCSpeedUnit');
obj.LoadEvent = function(args)
	{
	};
obj.retGridPanel_rowclick=function()
    {
	    var rc = obj.retGridPanel.getSelectionModel().getSelected();
	    
	    if (rc)
	    {
		    obj.ANCSUCode.setValue(rc.get("ANCSUCode"));
		    obj.ANCSUDesc.setValue(rc.get("ANCSUDesc"));
		    obj.ANCSUType.setValue(rc.get("ANCSUType"));
		    obj.ANCSUUomDr.setValue(rc.get("ANCSUUomDr"));
		    obj.ANCSUFactor.setValue(rc.get("ANCSUFactor"));
		    obj.ANCSUByPatWeight.setValue(rc.get("ANCSUByPatWeight"));
		    obj.ANCSUBaseSpeedUnitDr.setValue(rc.get("ANCSUBaseSpeedUnitDrdesc"));
		    obj.ANCSUBaseUomFactor.setValue(rc.get("ANCSUBaseUomFactor"));
		    
			//obj.retGridPanelStore.load({});      
	    }
    }
    
obj.addbutton_click=function()
    {
	    var ANCSUCode=obj.ANCSUCode.getValue();
	    var ANCSUDesc=obj.ANCSUDesc.getValue();
	    if(ANCSUCode=="")
	    {
		    alert("代码不能为空");
		    return;
	    }
	    if(ANCSUDesc=="")
	    {
		    alert("描述不能为空");
		    return;
	    }
	    var ANCSUType=obj.ANCSUType.getValue();
	    var ANCSUUomDr=obj.ANCSUUomDr.getValue();
	    var ANCSUFactor=obj.ANCSUFactor.getValue();
	    var ANCSUByPatWeight=obj.ANCSUByPatWeight.getValue();
	    var ANCSUBaseSpeedUnitDr=obj.ANCSUBaseSpeedUnitDr.getRawValue();
	    var ANCSUBaseUomFactor=obj.ANCSUBaseUomFactor.getValue();
		var typeStr=ANCSUCode+"^"+ANCSUDesc+"^"+ANCSUType+"^"+ANCSUUomDr+"^"+ANCSUFactor+"^"+ANCSUByPatWeight+"^"+ANCSUBaseSpeedUnitDr+"^"+ANCSUBaseUomFactor;
		var ret=_DHCICUCSpeedUnit.SpeedAdd(typeStr);
		if(ret==0)
		{
			Ext.Msg.alert("提示","增加成功!",function(){
			obj.ANCSUCode.setValue("");
			obj.ANCSUDesc.setValue("");
			obj.ANCSUType.setValue("");
			obj.ANCSUUomDr.setValue("");
			obj.ANCSUFactor.setValue("");
			obj.ANCSUByPatWeight.setValue("");
			obj.ANCSUBaseSpeedUnitDr.setValue("");
			obj.ANCSUBaseUomFactor.setValue("");
			obj.retGridPanelStore.removeAll();
	  	  	obj.retGridPanelStore.load({});
	  	  	});
		}
		else
		{
			alert(ret)
		}
		
	}

obj.updatebutton_click=function()
	{
		var ANCSUCode=obj.ANCSUCode.getValue();
	    var ANCSUDesc=obj.ANCSUDesc.getValue();
	    if(ANCSUCode=="")
	    {
		    alert("代码不能为空");
		    return;
	    }
	    if(ANCSUDesc=="")
	    {
		    alert("描述不能为空");
		    return;
	    }
	    var ANCSUType=obj.ANCSUType.getValue();
	    var ANCSUUomDr=obj.ANCSUUomDr.getValue();
	    var ANCSUFactor=obj.ANCSUFactor.getValue();
	    var ANCSUByPatWeight=obj.ANCSUByPatWeight.getValue();
	    var ANCSUBaseSpeedUnitDr=obj.ANCSUBaseSpeedUnitDr.getRawValue();
	    var ANCSUBaseUomFactor=obj.ANCSUBaseUomFactor.getValue();	//20160914+dyl
		var rc = obj.retGridPanel.getSelectionModel().getSelected();
		var Rowid=rc.get("Rowid");
		var typeStr=ANCSUCode+"^"+ANCSUDesc+"^"+ANCSUType+"^"+ANCSUUomDr+"^"+ANCSUFactor+"^"+ANCSUByPatWeight+"^"+ANCSUBaseSpeedUnitDr+"^"+ANCSUBaseUomFactor;
		var ret=_DHCICUCSpeedUnit.SpeedUpdate(Rowid,typeStr);
		if(ret==0)
		{
			Ext.Msg.alert("提示","修改成功!",function(){
				obj.ANCSUCode.setValue("");
			    obj.ANCSUDesc.setValue("");
			    obj.ANCSUType.setValue("");
			    obj.ANCSUUomDr.setValue("");
			    obj.ANCSUFactor.setValue("");
			    obj.ANCSUByPatWeight.setValue("");
			    obj.ANCSUBaseSpeedUnitDr.setValue("");
			    obj.ANCSUBaseUomFactor.setValue("");
				obj.retGridPanelStore.removeAll();
	  	  		obj.retGridPanelStore.load({});  
	  	  		
	  	  	});
		}
		else
		{
			alert(ret)
		}
	}

obj.deletebutton_click=function()
	{
		var rc = obj.retGridPanel.getSelectionModel().getSelected();
		var Rowid=rc.get("Rowid");
		if(Rowid=="")
		{
			Ext.Msg.alert("提示","请选择一条要删除的记录!");
			return;
		}
		
		Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  		if(btn=="no")return;
	  		var ret=_DHCICUCSpeedUnit.SpeedDel(Rowid);
	  		if(ret!="0")
	  	  		Ext.Msg.alert("提示","删除失败！");
	  		else
	  	 	 Ext.Msg.alert("提示","删除成功！",function(){
				obj.ANCSUCode.setValue("");
			    obj.ANCSUDesc.setValue("");
			    obj.ANCSUType.setValue("");
			    obj.ANCSUUomDr.setValue("");
			    obj.ANCSUFactor.setValue("");
			    obj.ANCSUByPatWeight.setValue("");
			    obj.ANCSUBaseSpeedUnitDr.setValue("");
			    obj.ANCSUBaseUomFactor.setValue("");
				obj.retGridPanelStore.removeAll();
	  	  		obj.retGridPanelStore.load({});
		  	});
	    });	 
	}
}