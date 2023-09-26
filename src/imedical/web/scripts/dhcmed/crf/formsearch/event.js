function InitViewscreenEvent(obj) {
	obj.LoadEvent = function()
  {
  	};
	obj.btnFind_click = function()
	{
		//alert("rrr");
		obj.GridStore.removeAll();
		obj.GridStore.reader = new Ext.data.JsonReader({
			root : 'record',
			totalProperty : 'total'
				,idProperty: 'DataId'
			}, obj.storeFields)
		obj.GridStore.load({});
		obj.GridColumns = new Ext.grid.ColumnModel(obj.gridColumn);
		//obj.GridColumns.rows = obj.GridColumnHeaderGroup.config.rows;
		obj.RstGridPanel.reconfigure(obj.GridStore, obj.GridColumns);
	};
	
	obj.btnExport_click = function()
	{
		var objForm = ExtTool.RunServerMethod("DHCMed.CR.PO.Form", "GetObjById", ExtTool.GetParam(window, "formId"));
		
		FormExport.TemplateFileName = "../../med/Results/Template/" + objForm.ESchema + "." + objForm.Type + "." + objForm.EName + ".xlt";
		FormExport.LoadDataToArray(
			objForm.ESchema + "." + objForm.Type + "." + objForm.EName
			, obj.GridStore
			,FormExport.ExportToExcel
			,FormExport
		);
	}
	
	obj.cboLoc_OnExpand = function() {
		obj.cboLocStore.load({});
	};
	obj.GetStatusList = function() {
		var StatusList = "*";
		var objStatusList = obj.bgRepStatus.getValue();
		for (var statusIndex = 0; statusIndex < objStatusList.length; statusIndex++) {
			StatusList = StatusList + objStatusList[statusIndex].getName() + "*";
		}
		return StatusList;
	};
	
	//Add By LiYang 2013-10-17 增加编辑报告功能
	obj.GridPanel_rowdblclick = function(objGrid, rowIndex, eventObject){
		var objRec = obj.GridStore.getAt(rowIndex);
		//debugger;
		showForm({
			keyId : objRec.get("DataId")
			,EpisodeID:objRec.get("EpisodeID")
			,PatientID:objRec.get("PatientID")
			,GoalUserID:objRec.get("GoalUserID")
			,locFlag:"1" //允许审核
		});
	}
}
/*
function ClinReportLookUpHeader(ckeyId,cformCode,cformVerId,cPatientID,cEpisodeID,cGoalUserID,cFormDesc)
{
	var url="dhcmed.crf.directrun.csp?"+"keyId=" +ckeyId+"&formCode=" +"" +"&formVerId=" +cformVerId +"&design=" +""+"&PatientID=" +cPatientID +"&EpisodeID=" +cEpisodeID +"&GoalUserID=" +cGoalUserID;	
	var objWin = new Ext.Window(
		{
			title:"临床上报["+cFormDesc+"]",
			html:'<iframe width=847 height=627 scrollbars=no src='+ url + '></iframe>',
			height:600,
			width:852
		}
	);
	objWin.show();
}*/