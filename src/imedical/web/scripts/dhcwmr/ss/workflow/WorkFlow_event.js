function InitWorkFlowSetViewPortEvent(obj){
	obj.LoadEvent = function(){
		obj.btnSave.on('click',obj.btnSave_click,obj);
		obj.btnDelete.on('click',obj.btnDelete_click,obj);
		obj.gridWorkFlow.on('rowclick',obj.gridWorkFlow_rowclick,obj);
	}
	
	obj.gridWorkFlow_rowclick = function(){
		var rowIndex = arguments[1];
		var objRec = obj.gridWorkFlowStore.getAt(rowIndex);
		if (obj.WorkFlowID==objRec.get("ID")){
			obj.txtWFCode.setDisabled(false);
			obj.WorkFlowID = '';
			obj.txtWFCode.setValue("");
			obj.txtWFDesc.setValue("");
			obj.txtWFResume.setValue("");
		} else {
			obj.WorkFlowID = objRec.get("ID");
			obj.txtWFCode.setDisabled(true);
			obj.txtWFCode.setValue(objRec.get("Code"));
			obj.txtWFDesc.setValue(objRec.get("Desc"));
			obj.txtWFResume.setValue(objRec.get("Resume"));
		}
	}
	
	obj.btnSave_click = function(){
		var separete=String.fromCharCode(1);
		var ID = obj.WorkFlowID;
		var Code = obj.txtWFCode.getValue();
		var Desc = obj.txtWFDesc.getValue();
		var Resume = obj.txtWFResume.getValue();
		if ((Code=="")||(Desc=="")){
			ExtTool.alert("提示","代码，描述不能为空！");
			return;
		}
		var tmp = ID + separete;
		tmp += Code + separete;
		tmp += Desc + separete;
		tmp += Resume + separete;
		
		var NewID = ExtTool.RunServerMethod("DHCWMR.SS.WorkFlow","Update",tmp,separete);
		if (NewID<0){
			ExtTool.alert("提示","保存失败！");
			return;
		} else {
			obj.gridWorkFlowStore.load({});
			obj.txtWFCode.setDisabled(false);
			obj.WorkFlowID = '';
			obj.txtWFCode.setValue("");
			obj.txtWFDesc.setValue("");
			obj.txtWFResume.setValue("");
		}
	}
	
	obj.btnDelete_click = function()
	{
		var ID = obj.WorkFlowID;
		if (ID==""){
			ExtTool.alert("提示","请选择项目！");
			return;
		}
		
		var NewID = ExtTool.RunServerMethod("DHCWMR.SS.WorkFlow","DeleteById",ID);
		if (NewID<0){
			ExtTool.alert("提示","删除失败！");
			return;
		} else {
			obj.gridWorkFlowStore.load({});
			obj.txtWFCode.setDisabled(false);
			obj.WorkFlowID = '';
			obj.txtWFCode.setValue("");
			obj.txtWFDesc.setValue("");
			obj.txtWFResume.setValue("");
		}
	}
}

function OpenWorkItemEdit(rowIndex){
	var objRec = Ext.getCmp("gridWorkFlow").store.getAt(rowIndex);
	var DTLWindow = new InitWorkItemEdit(objRec);
	DTLWindow.WorkItemEditWin.show();
}

function OpenWorkDetailEdit(rowIndex){
	var objRec = Ext.getCmp("gridWorkFlow").store.getAt(rowIndex);
	var DTLWindow = new InitWorkDetailEdit(objRec);
	DTLWindow.WorkDetailEditWin.show();
}