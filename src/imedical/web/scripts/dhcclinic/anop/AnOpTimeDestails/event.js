function InitViewScreenEvent(obj)
{ 

    var _DHCANRecord=ExtTool.StaticServerObject('web.DHCANRecord');
    obj.LoadEvent = function(args)
	{


     obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANRecord';
		param.QueryName = 'GetAnOpTimeDestails';
		param.Arg1 = obj.dateFrm.getRawValue();
		param.Arg2 = obj.dateTo.getRawValue();
		param.ArgCnt = 2;
	});
	obj.retGridPanelStore.load({});
	
	}
	obj.findbutton_click=function()
	{
	   obj.retGridPanelStore.load({});
	}
	obj.retGridPanel_rowclick = function()
	{
	    var rc = obj.retGridPanel.getSelectionModel().getSelected();
		
		
		if (rc){
	    obj.opaId.setRawValue(rc.get("opaId"));
	    obj.opaStartTime.setRawValue(rc.get("opaStartTime"));
	    obj.opaEndTime.setRawValue(rc.get("opaEndTime"));
	    obj.anaStartTime.setRawValue(rc.get("anaStartTime"));
	    obj.anaEndTime.setRawValue(rc.get("anaEndTime"));
		}
	};
	obj.updatebutton_click=function()
	{
	    var opaId=obj.opaId.getValue();
		var opaStartTime=obj.opaStartTime.getRawValue();
		var opaEndTime=obj.opaEndTime.getRawValue();
		var anaStartTime=obj.anaStartTime.getRawValue();
		var anaEndTime=obj.anaEndTime.getRawValue();
		if(opaStartTime=="")
		{
		    alert("手术开始时间为空");
			return;
		}
		if(opaEndTime=="")
		{
		    alert("手术结束时间为空")
			return;
		}
		if(anaStartTime=="")
		{
		    alert("麻醉开始时间为空")
			return;
		}
		if(anaEndTime=="")
		{
		    alert("麻醉结束时间为空")
			return;
		}
		var ret=_DHCANRecord.UpdateOpTime(opaId,opaStartTime,opaEndTime,anaStartTime,anaEndTime);
		if(ret!='1') 
		{ 
		     Ext.Msg.alert("提示","更新失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","更新成功!",function(){
	        obj.opaStartTime.setRawValue("");
	        obj.opaEndTime.setRawValue("");
	        obj.anaStartTime.setRawValue("");
	        obj.anaEndTime.setRawValue("");
	  	  	obj.retGridPanelStore.load({});	  	
	  	  	});
		}
	}
}