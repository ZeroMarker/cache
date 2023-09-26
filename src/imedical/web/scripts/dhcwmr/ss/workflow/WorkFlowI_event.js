function InitWorkItemEditEvent(obj)
{
	var objWorkFItem = ExtTool.StaticServerObject("DHCWMR.SS.WorkFItem");
	var CHR_1 = String.fromCharCode(1);
	
	obj.LoadEvent = function(){
		obj.gridWFItem.on('rowclick',obj.gridWFItem_rowclick,obj);
		obj.GridPreItems.on("cellclick",obj.GridPreItems_cellclick,obj);
		obj.cboItemType.on("select",obj.cboItemType_select,obj);
		obj.btnMoveUp.on('click',obj.btnMoveUp_click,obj);
		obj.btnMoveDown.on('click',obj.btnMoveDown_click,obj);
		obj.btnSave.on('click',obj.btnSave_click,obj);
		
		Common_SetDisabled('btnMoveUp',true);
		Common_SetDisabled('btnMoveDown',true);
	}
	
	obj.GridPreItems_cellclick = function(grid, rowIndex, columnIndex, e){
		if (columnIndex != 0) return;
		var objRec = grid.getStore().getAt(rowIndex);
	    var fieldName = grid.getColumnModel().getDataIndex(columnIndex);
	    var recValue = objRec.get(fieldName);
		if (recValue == '1') {
			var newValue = '0';
		} else {
			var newValue = '1';
		}
		objRec.set(fieldName, newValue);
		grid.getStore().commitChanges();
		grid.getView().refresh();
	}
	
	obj.gridWFItem_rowclick = function (){
		var rowIndex = arguments[1];
		var objRec = obj.gridWFItemStore.getAt(rowIndex);
		if (objRec){
			if (objRec.get('ItemIndex') == ''){
				Common_SetDisabled('btnMoveUp',true);
				Common_SetDisabled('btnMoveDown',true);
			} else {
				Common_SetDisabled('btnMoveUp',false);
				Common_SetDisabled('btnMoveDown',false);
			}
			
			obj.WFItemID = objRec.get("WFItemID");
			Common_SetValue('txtItemDesc',objRec.get("ItemDesc"));
			Common_SetValue('txtItemAlias',objRec.get("ItemAlias"));
			Common_SetValue('cboItemType',objRec.get("TypeID"),objRec.get("TypeDesc"));
			obj.cboItemType_select();
			Common_SetValue('cbgPreStep',objRec.get("PreStepCode"),objRec.get("PreStepDesc"));
			Common_SetValue('cbgPostStep',objRec.get("PostStepCode"),objRec.get("PostStepDesc"));
			Common_SetValue('cboSysOpera',objRec.get("SysOperaID"),objRec.get("SysOperaDesc"));
			Common_SetValue('cboSubFlow',objRec.get("SubFlowID"),objRec.get("SubFlowDesc"));
			Common_SetValue('chkCheckUser',(objRec.get("CheckUser")==1));
			Common_SetValue('chkBeRequest',(objRec.get("BeRequest")==1));
			Common_SetValue('chkBatchOper',(objRec.get("BatchOper")==1));
			Common_SetValue('cbgMRCategory',objRec.get("MRCategory"),objRec.get("MRCategoryDesc"));
			Common_SetValue('chkIsActive',(objRec.get("IsActive")==1));
			Common_SetValue('txtResume',objRec.get("Resume"));
			obj.GridPreItemsStore.load({});
		}
	}
	
	obj.cboItemType_select = function (){
		Common_SetValue('cbgPreStep','','');
		Common_SetValue('cbgPostStep','','');
		var ItemType = Common_GetText('cboItemType');
		if (ItemType.indexOf('顺序')>-1){  //顺序项
			Ext.getCmp("cbgPreStep-A").setDisabled(false);
			Ext.getCmp("cbgPreStep-D").setDisabled(false);
			Ext.getCmp("cbgPreStep-S").setDisabled(false);
			Ext.getCmp("cbgPostStep-A").setDisabled(false);
			Ext.getCmp("cbgPostStep-D").setDisabled(false);
			Ext.getCmp("cbgPostStep-S").setDisabled(false);
		} else {  //突发项
			Ext.getCmp("cbgPreStep-A").setDisabled(true);
			Ext.getCmp("cbgPreStep-D").setDisabled(true);
			Ext.getCmp("cbgPreStep-S").setDisabled(true);
			Ext.getCmp("cbgPostStep-A").setDisabled(true);
			Ext.getCmp("cbgPostStep-D").setDisabled(true);
			Ext.getCmp("cbgPostStep-S").setDisabled(true);
		}
	}
	
	obj.btnMoveUp_click = function (){
		var objRec = obj.gridWFItem.getSelectionModel().getSelected();
		if (!objRec){
			ExtTool.alert("提示","请选择操作项目!");
			return;	
		}
		var tmpId1 = objRec.get("WFItemID");
		var tmpIndex1 = objRec.get("ItemIndex");
		var tmpId2 =""
		obj.gridWFItemStore.each(function(record) {
			if (record.get('ItemIndex')==(tmpIndex1*1-1)){
				tmpId2 = record.get('WFItemID')
			}
		});
		if ((tmpId2 == '')||(tmpId1 == '')) return;
		var ret = ExtTool.RunServerMethod("DHCWMR.SS.WorkFItem","SwapIndex",tmpId1,tmpId2);
		obj.gridWFItemStore.load({});
	}
	
	obj.btnMoveDown_click = function (){
		var objRec = obj.gridWFItem.getSelectionModel().getSelected();
		if (!objRec){
			ExtTool.alert("提示","请选择操作项目!");
			return;	
		}
		var tmpId1 = objRec.get("WFItemID");
		var tmpIndex1 = objRec.get("ItemIndex");
		var tmpId2 =""
		obj.gridWFItemStore.each(function(record) {
			if (record.get('ItemIndex')==(tmpIndex1*1+1)){
				tmpId2 = record.get('WFItemID')
			}
		});
		if ((tmpId2 == '')||(tmpId1 == '')) return;
		var ret = ExtTool.RunServerMethod("DHCWMR.SS.WorkFItem","SwapIndex",tmpId1,tmpId2);
		obj.gridWFItemStore.load({});
	}
	
	obj.btnSave_click = function(){
		var objRec = obj.gridWFItem.getSelectionModel().getSelected();
		if (!objRec){
			ExtTool.alert("提示","请选择操作项目!");
			return;
		}
		var WorkItemID = objRec.get("WFItemID");
		var arrID = WorkItemID.split("||");
		if (arrID.length>1){
			var Parref = arrID[0];
			var Childsub = arrID[1];
		} else {
			var Parref = obj.WFlowID;
			var Childsub = '';
		}
		
		var ItemID = objRec.get("ItemID");
		var ItemAlias = Common_GetValue('txtItemAlias');
		var TypeID = Common_GetValue('cboItemType');
		var PreStep = Common_GetValue('cbgPreStep');
		var PostStep = Common_GetValue('cbgPostStep');
		var SysOperaID = Common_GetValue('cboSysOpera');
		if (SysOperaID == '-') SysOperaID = '';
		var CheckUser = Common_GetValue('chkCheckUser');
		var BeRequest = Common_GetValue('chkBeRequest');
		var BatchOper = Common_GetValue('chkBatchOper');
		var MRCategory = Common_GetValue('cbgMRCategory');
		var SubFlowID = Common_GetValue('cboSubFlow');
		if (SubFlowID == '-') SubFlowID = '';
		var IsActive = Common_GetValue('chkIsActive');
		var Resume = Common_GetValue('txtResume');
		
		var PreItems = '';
		for (var i =0; i< obj.GridPreItems.store.data.items.length;i++){
			if (obj.GridPreItems.store.data.items[i].data.IsChecked==1){
				PreItems=PreItems+"#"+obj.GridPreItems.store.data.items[i].data.ItemID;
			}
		}
		if (PreItems != '') PreItems=PreItems.substr(1);
		
		if (Parref == '') return;
		if (ItemID == '') return;
		if (TypeID == ''){
			ExtTool.alert("提示","项目类型为空!");
			return;
		}
		if (SubFlowID == ''){
			ExtTool.alert("提示","操作流程为空!");
			return;
		}
		
		var tmp = Parref;
		tmp += CHR_1 + Childsub;
		tmp += CHR_1 + ItemID;
		tmp += CHR_1 + ItemAlias;
		tmp += CHR_1 + TypeID;
		tmp += CHR_1 + PreStep;
		tmp += CHR_1 + PostStep;
		tmp += CHR_1 + PreItems;
		tmp += CHR_1 + SysOperaID;
		tmp += CHR_1 + (CheckUser==false?0:1);
		tmp += CHR_1 + (BeRequest==false?0:1);
		tmp += CHR_1 + SubFlowID;
		tmp += CHR_1 + (BatchOper==false?0:1);
		tmp += CHR_1 + MRCategory;
		tmp += CHR_1 + (IsActive==false?0:1);
		tmp += CHR_1 + Resume;
		
		var ret = ExtTool.RunServerMethod("DHCWMR.SS.WorkFItem","Update",tmp,CHR_1);
		if (ret<0){
			ExtTool.alert("提示","保存失败！");
			return;
		} else {
			ExtTool.alert("提示","保存成功！");
			obj.gridWFItemStore.load({});
		}
	}
}