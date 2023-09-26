function InitViewScreenEvent(obj)
{
	var _DHCANAduitAccredit=ExtTool.StaticServerObject('web.DHCANAduitAccredit');
	var _UDHCANOPArrange=ExtTool.StaticServerObject('web.UDHCANOPArrange');
	var userId=session['LOGON.USERID'];
	var curLocId=session['LOGON.CTLOCID'];
	var SelectedRowID = 0;
	var preRowID=0;
	obj.LoadEvent = function(args)
	{	
		var ret=_UDHCANOPArrange.GetDocLoc(userId,curLocId)
	    if (ret!="")
	    {	
            obj.ANAACtloc.setValue(ret.split("^")[1]);
            obj.ANAACtloc.setRawValue(ret.split("^")[0]);
            obj.retGridPanelStore.load({});
	    }
		
	}
	obj.retGridPanel_rowclick=function()
	{
	    var rc = obj.retGridPanel.getSelectionModel().getSelected();
		if (rc)
		{
			SelectedRowID=rc.get("RowId");
			if(preRowID!=SelectedRowID)
			{
				obj.RowId.setValue(rc.get("ANAARowId"));
				obj.ANAACtloc.setValue(rc.get("ANAACtlocId"));
				obj.ANAACtloc.setRawValue(rc.get("ANAACtlocDesc"));
				obj.ANAACtpcp.setValue(rc.get("ANAACtpcpId"));
				obj.ANAACtpcp.setRawValue(rc.get("ANAACtpcpDesc"));
				obj.ANAAStartDate.setRawValue(rc.get("ANAAStartDT").split(" ")[0]);
				obj.ANAAStartTime.setRawValue(rc.get("ANAAStartDT").split(" ")[1]);
				obj.ANAAEndDate.setRawValue(rc.get("ANAAEndDT").split(" ")[0]);
				obj.ANAAEndTime.setRawValue(rc.get("ANAAEndDT").split(" ")[1]);
				preRowID=SelectedRowID;
			}
			else
			{
				ClearFormData();
				SelectedRowID = 0;
		    	preRowID=0;
			}
			
		}
		
	}
	obj.saveButton_click=function(){
		var RowId=obj.RowId.getValue();
		var ANAACtloc=obj.ANAACtloc.getValue();
		var ANAACtpcp=obj.ANAACtpcp.getValue();
		var ANAAStartDate=obj.ANAAStartDate.getRawValue();
		var ANAAStartTime=obj.ANAAStartTime.getRawValue();
		var ANAAEndDate=obj.ANAAEndDate.getRawValue();
		var ANAAEndTime=obj.ANAAEndTime.getRawValue();
		if(ANAACtloc=="")
		{
			alert("授权科室不能为空！");
			return;
		}
		if(ANAACtpcp=="")
		{
			alert("授权医生不能为空！");
			return;
		}
		if(ANAAStartDate=="")
		{
			alert("授权开始日期不能为空！");
			return;
		}
		if(ANAAStartTime=="")
		{
			alert("授权开始时间不能为空！");
			return;
		}
		var result=_DHCANAduitAccredit.SaveAduitAccredit(RowId,ANAACtloc,ANAACtpcp,ANAAStartDate,ANAAStartTime,ANAAEndDate,ANAAEndTime,userId)
		if(result>0)
		{
			alert("系统号为"+result+"的授权信息保存成功！");
			ClearFormData();
			obj.retGridPanelStore.load({});
		}else
		{
			alert("授权信息保存失败！");
			return ;
		}
	
	}
	
	obj.deleteButton_click=function()
	{
		var rc = obj.retGridPanel.getSelectionModel().getSelected();
		if(rc)
		{
			var selectRowId=rc.get("ANAARowId")
			var result=_DHCANAduitAccredit.DeleteAduitAccredit(selectRowId);
			if(result!="0")
			{
				alert("删除失败！"+result);return ;
			}else
			{
				alert("删除成功！");
				ClearFormData();
				obj.retGridPanelStore.load({});
				
			}
		}
		else
		{
			alert("请选择要删除的行！");
			return;
		}
	}
	
	function ClearFormData()
	{
		obj.RowId.setValue();
        obj.ANAACtpcp.setRawValue();
	    obj.ANAACtpcp.setValue();
	    obj.ANAAStartDate.setValue();
	    obj.ANAAStartTime.setValue();
	    obj.ANAAEndDate.setValue();
	    obj.ANAAEndTime.setValue();
	}
	
}