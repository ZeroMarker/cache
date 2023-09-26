function InitWorkDetailEditEvent(obj)
{
	var objWorkFDetail = ExtTool.StaticServerObject("DHCWMR.SS.WorkFDetail");
	obj.SelectedExistWorkFIDetailRowid =-1;  //选中已配置附加项目ID
	obj.CurrWorkFIDetailIndex = -1;
	var CHR_1 = String.fromCharCode(1);
	obj.LoadEvents = function()
	{
		obj.ExistWorkItemGrid.on('rowclick',obj.ExistWorkItemGrid_rowclick,obj);
		obj.WorkDetailGrid.on('rowclick',obj.WorkDetailGrid_rowclick,obj);
		obj.ExistWorkFIDetailGrid.on('rowclick',obj.ExistWorkFIDetailGrid_rowclick,obj);
		obj.BtnLeft.on('click',obj.BtnLeft_click,obj);
		obj.BtnRight.on('click',obj.BtnRight_click,obj);
		obj.BtnUp.on('click',obj.BtnUp_click,obj);
		obj.BtnDown.on('click',obj.BtnDown_click,obj);
		obj.btnSave.on('click',obj.btnSave_click,obj);
	}

	obj.ExistWorkItemGrid_rowclick = function ()
	{
		obj.WorkDetailGridStore.load({});
		obj.ExistWorkFIDetailGridStore.load({});
	}
	obj.WorkDetailGrid_rowclick = function()
	{
		//TODO
	}
	obj.ExistWorkFIDetailGrid_rowclick = function()
	{
		var rowIndex = arguments[1];
		var Separate=String.fromCharCode(1)
		if (obj.CurrWorkFIDetailIndex==rowIndex)
		{
			obj.WFDIsNeed.setValue(false);
			obj.WFDInitVal.setValue("");
			obj.WFDIsActive.setValue(false);
			obj.WFDResume.setValue("");
			obj.WFDRowid.setValue("");
			obj.SelectedExistWorkFIDetailRowid=-1;
			obj.CurrWorkFIDetailIndex=-1
		}
		else{
			var objRec = obj.ExistWorkFIDetailGridStore.getAt(rowIndex);
			obj.SelectedExistWorkFIDetailRowid = objRec.get("ID");
			obj.CurrWorkFIDetailIndex=rowIndex;
			var RetObj=objWorkFDetail.GetObjById(obj.SelectedExistWorkFIDetailRowid)
			obj.WFDIsNeed.setValue(RetObj.WFDIsNeed?true:false);
			obj.WFDInitVal.setValue(RetObj.WFDInitVal);
			obj.WFDIsActive.setValue(RetObj.WFDIsActive?true:false);
			obj.WFDResume.setValue(RetObj.WFDResume);
			obj.WFDRowid.setValue(obj.SelectedExistWorkFIDetailRowid);
		}
	}
	obj.BtnLeft_click = function()
	{
		var objRec = obj.ExistWorkFIDetailGrid.getSelectionModel().getSelected();
		if (!objRec)
		{
			ExtTool.alert("提示","请选择要移除的附加项目!");
			return;	
		}
		var WorkFIDtlID = objRec.get("ID");
		try
		{
			var ret = objWorkFDetail.DelWorkFDetail(WorkFIDtlID);
			if (ret<0)
			{
				ExtTool.alert("提示","移除失败!");
			}
		}
		catch (err)
		{
			ExtTool.alert("提示", err.description,Ext.MessageBox.ERROR);
		}
		obj.ExistWorkFIDetailGridStore.load({});
		obj.WFDIsNeed.setValue(false);
		obj.WFDInitVal.setValue("");
		obj.WFDIsActive.setValue(false);
		obj.WFDResume.setValue("");
		obj.WFDRowid.setValue("");
	}
	obj.BtnRight_click = function()
	{
		var objRec1 = obj.WorkDetailGrid.getSelectionModel().getSelected();
		if (!objRec1)
		{
			ExtTool.alert("提示","请选择需要添加的附加项目!");
			return;	
		}
		var objRec2 = obj.ExistWorkItemGrid.getSelectionModel().getSelected();
		if (!objRec2)
		{
			ExtTool.alert("提示","请选择流操作项目!");
			return;
		}
		var RowCount = obj.ExistWorkFIDetailGridStore.getCount();
		var separete = String.fromCharCode(1);
		var WorkItemId = objRec2.get("ID");
		var WorkDetaId = objRec1.get("ID");
		var WFDIndex = ++RowCount;
		var tmp  = WorkItemId + separete;
			tmp += WorkDetaId +separete;
			tmp += WFDIndex +separete;
		try
		{
			var NewID = objWorkFDetail.AddWorkFDetail(tmp,separete);
			if(NewID<0) {
				ExtTool.alert("提示","添加失败！");
				return;
			}
			else{
			}
		}
		catch(err)
		{
			ExtTool.alert("提示", err.description,Ext.MessageBox.ERROR);
		}
		obj.ExistWorkFIDetailGridStore.load({});
	}
	obj.BtnUp_click = function()
	{
		var objRec = obj.ExistWorkFIDetailGrid.getSelectionModel().getSelected();
		if (!objRec)
		{
			ExtTool.alert("提示","请选择要移除的附加项目!");
			return;	
		}
		var tmpId1 = objRec.get("ID");
		var tmpIndex1 = objRec.get("DtlIndex");
		var tmpId2 =""
		if (tmpIndex1!=1)
		{
			obj.ExistWorkFIDetailGridStore.each(function(record) {
				if (record.get('DtlIndex')==(tmpIndex1-1))
				{
					tmpId2 = record.get('ID')
				}
			});
		}
		var ret = objWorkFDetail.SwapIndex(tmpId1,tmpId2);
		obj.ExistWorkFIDetailGridStore.load({});
	}
	obj.BtnDown_click = function()
	{
		var objRec = obj.ExistWorkFIDetailGrid.getSelectionModel().getSelected();
		if (!objRec)
		{
			ExtTool.alert("提示","请选择要下移的附加项目!");
			return;	
		}
		var tmpId1 = objRec.get("ID");
		var tmpIndex1 = objRec.get("DtlIndex");
		var tmpId2 =""
		if (tmpIndex1!=obj.ExistWorkFIDetailGridStore.getCount())
		{
			tmpIndex1++;
			obj.ExistWorkFIDetailGridStore.each(function(record) {
				if (record.get('DtlIndex')==tmpIndex1)
				{
					tmpId2 = record.get('ID')
				}
			});
		}
		var ret = objWorkFDetail.SwapIndex(tmpId1,tmpId2);
		obj.ExistWorkFIDetailGridStore.load({});
	}
	obj.btnSave_click = function()
	{
		var ID="",ItemID="",Index="",IsNeed="",InitVal="",IsActive="",Resume="",PID="",SubId="";
		var objRec= obj.ExistWorkFIDetailGrid.getSelectionModel().getSelected();
		if (objRec)
		{
			 ItemID = objRec.get("DtlID");
			 Index = objRec.get("DtlIndex");
			 ID = objRec.get("ID");
		}
		
		if ((ID=="")||(ItemID=="")||(Index==""))
		{
			ExtTool.alert("提示","请选择附加项!");
			return;	
		}
		PID = ID.split("||")[0]+"||"+ID.split("||")[1];
		SubId = ID.split("||")[2];
		IsNeed=obj.WFDIsNeed.getValue();
		InitVal = obj.WFDInitVal.getValue();
		IsActive = obj.WFDIsActive.getValue();
		Resume = obj.WFDResume.getValue();
		var separete=CHR_1;
		var tmp = PID + separete;
			tmp += SubId + separete;
			tmp += ItemID + separete;
			tmp += Index + separete;
			tmp += (IsNeed==true?1:0) + separete;
			tmp += InitVal + separete;
			tmp += (IsActive==true?1:0) + separete;
			tmp += Resume + separete;
		try
		{
			var ret = objWorkFDetail.Update(tmp,separete);
			if(ret<0) {
				ExtTool.alert("提示","保存失败！");
				return;
			}
			else{
				//ExtTool.alert("提示","保存成功！");
			}
		}
		catch(err)
		{
			ExtTool.alert("提示", err.description,Ext.MessageBox.ERROR);
		}
		obj.ExistWorkFIDetailGridStore.load({});
	}
}