function InitviewScreenEvents(obj){
	obj.LoadEvents = function(){
		obj.cboArcim.on("select",obj.cboArcim_select,obj);
		obj.btnQuery.on("click",obj.btnQuery_click,obj);
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.gridLnkArcim.on("cellclick",obj.gridLnkArcim_cellclick,obj);
		obj.chkSelectAll.on("check",obj.chkSelectAll_check,obj);
	}
	
	obj.ClearCmpListVal = function(){
		Common_SetValue('cboArcim','','');
		Common_SetValue('txtDoseQty','');
		Common_SetValue('cboDoseUom','','');
		Common_SetValue('cboPHCFreq','','');
		Common_SetValue('cboPHCInstruc','','');
		Common_SetValue('cboPHCDuration','','');
		Common_SetValue('txtPackQty','');
		Common_SetValue('txtItmResume','');
		Common_SetValue('chkSelectAll',0);
		Common_GetValue('cboPathWayType','','');
		obj.SetArcimLnkCmpDisabled();
	}
	
	obj.SetArcimLnkCmpDisabled = function(ArcimID,SetDefValue){
		Common_SetDisabled('txtDoseQty',true);
		Common_SetDisabled('txtPackQty',true);
		Common_SetDisabled('cboDoseUom',true);
		Common_SetDisabled('cboPHCFreq',true);
		Common_SetDisabled('cboPHCInstruc',true);
		Common_SetDisabled('cboPHCDuration',true);
		
		var arcimStr = ExtTool.RunServerMethod("DHCCPW.MRC.FORM.LnkArcimSrv","GetArcimInfoById",ArcimID);
		if (arcimStr == '') return;
	  	var arcim=arcimStr.split("^");
	  	if(arcim[1]=="R"){
			Common_SetDisabled('txtDoseQty',false);
			Common_SetDisabled('cboDoseUom',false);
			Common_SetDisabled('cboPHCFreq',false);
			Common_SetDisabled('cboPHCInstruc',false);
			Common_SetDisabled('cboPHCDuration',false);
	  	}else if(arcim[2]=="4"){
			Common_SetDisabled('txtPackQty',false);
			Common_SetDisabled('cboPHCFreq',false);
			Common_SetDisabled('cboPHCDuration',false);
	  	}else{
			Common_SetDisabled('txtPackQty',false);
	  	}
		
		if (SetDefValue){  //设置默认值
			if(arcim[1]=="R"){
				Common_SetValue('txtDoseQty',arcim[3]);
				Common_SetValue('cboDoseUom',arcim[4],arcim[5]);
				Common_SetValue('cboPHCFreq',arcim[8],arcim[9]);
				Common_SetValue('cboPHCInstruc',arcim[10],arcim[11]);
				Common_SetValue('cboPHCDuration',arcim[6],arcim[7]);
			}else if(arcim[2]=="4"){
				Common_SetValue('txtPackQty',1);
				Common_SetValue('cboPHCFreq',arcim[8],arcim[9]);
				Common_SetValue('cboPHCDuration',arcim[6],arcim[7]);
			}else{
				Common_SetValue('txtPackQty',1);
			}
		}
	}
	
	obj.cboArcim_select = function(combo,record,index){
		Common_SetValue('txtDoseQty','');
		Common_SetValue('txtPackQty','');
		Common_SetValue('txtItmResume','');
		Common_SetValue('cboDoseUom','','');
		Common_SetValue('cboPHCFreq','','');
		Common_SetValue('cboPHCInstruc','','');
		Common_SetValue('cboPHCDuration','','');
		obj.cboDoseUom.getStore().removeAll();
		obj.cboDoseUom.getStore().load({});
		obj.cboPHCFreq.getStore().removeAll();
		obj.cboPHCInstruc.getStore().removeAll();
		obj.cboPHCDuration.getStore().removeAll();
		var ArcimID = record.get(combo.valueField);
		obj.SetArcimLnkCmpDisabled(ArcimID,1);
	}
	
	obj.btnQuery_click = function(){
		if (Common_GetValue('cboPathWayType')==''){
			ExtTool.alert("提示","请选择路径类型!");
			return;
		}
		obj.gridLnkArcimStore.removeAll();
		obj.gridLnkArcimStore.load({});
		obj.ClearCmpListVal();
	}
	
	obj.btnUpdate_click = function(){
		var ArcimID = Common_GetValue('cboArcim');
		var ArcimDesc = Common_GetText('cboArcim');
		var DoseQty = Common_GetValue('txtDoseQty');
		var DoseUomID = Common_GetValue('cboDoseUom');
		var FreqID = Common_GetValue('cboPHCFreq');
		var InstrucID = Common_GetValue('cboPHCInstruc');
		var DurationID = Common_GetValue('cboPHCDuration');
		var PackQty = Common_GetValue('txtPackQty');
		var ItmResume = Common_GetValue('txtItmResume');
		if ((ArcimID == '')||(ArcimDesc == '')){
			ExtTool.alert("提示","替换医嘱不允许为空!");
			return;
		}
		
		var ArcimInfo = ArcimID
			+ '^' + DoseQty
			+ '^' + DoseUomID
			+ '^' + FreqID
			+ '^' + InstrucID
			+ '^' + DurationID
			+ '^' + PackQty
			+ '^' + ItmResume
			+ '^' + session['LOGON.USERID']
		
		var Count = 0,IGAIndexList = '',IsError = 0;
		var objStore = obj.gridLnkArcimStore;
		for (var ind = 0; ind < objStore.getCount(); ind++){
			var rd = objStore.getAt(ind);
			
			if (rd.get('IsChecked') == '1'){
				Count++;
				IGAIndexList += ',' + rd.get('IGAIndex');
			}
			
			if (((Count%100 == 0)||(ind >= objStore.getCount()-1))
				&&(IGAIndexList != '')){
				var ret = ExtTool.RunServerMethod("DHCCPW.MRC.FORM.LnkArcimBat","ChangeLnkArcim",IGAIndexList,ArcimInfo);
				if (parseInt(ret)<0){
					IsError = 1;
					break;
				} else {
					IGAIndexList = '';
				}
			}
		}
		if (Count <1) {
			ExtTool.alert("提示","请选择关联医嘱再替换!");
			return;
		}
		if (IsError == 1){
			ExtTool.alert("提示","批量替换关联医嘱项错误!");
			return;
		}
		obj.gridLnkArcimStore.removeAll();
		obj.gridLnkArcimStore.load({});
	}
	
	obj.chkSelectAllClickFlag = 1;
	obj.chkSelectAll_check = function(){
		if (obj.chkSelectAllClickFlag != 1) return;
		var objStore = obj.gridLnkArcim.getStore();
		if (objStore.getCount() < 1){
			return;
		}
		
		var isCheck = obj.chkSelectAll.getValue();
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			record.set('IsChecked', isCheck);
			obj.gridLnkArcim.getStore().commitChanges();
			obj.gridLnkArcim.getView().refresh();
		}
	}
	
	obj.gridLnkArcim_cellclick = function(grid, rowIndex, columnIndex, e){
		var objRec = grid.getStore().getAt(rowIndex);
	    var fieldName = grid.getColumnModel().getDataIndex(columnIndex);
		if (fieldName != 'IsChecked') return;
	    var recValue = objRec.get(fieldName);
		if (recValue == '1') {
			var newValue = '0';
		} else {
			var newValue = '1';
		}
		objRec.set(fieldName, newValue);
		grid.getStore().commitChanges();
		grid.getView().refresh();
		
		if (newValue == '0') {
			var isSelectAll = '0';
		} else {
			var isSelectAll = '1';
			var count = 0;
			var objStore = grid.getStore();
			for (var row = 0; row < objStore.getCount(); row++){
				var record = objStore.getAt(row);
				count++;
				if (record.get(fieldName) != '1') {
					isSelectAll = '0';
					break;
				}
			}
			if (count<1) isSelectAll = '0';
		}
		
		obj.chkSelectAllClickFlag = 0;
		if (isSelectAll == '0'){
			obj.chkSelectAll.setValue(false);
		} else {
			obj.chkSelectAll.setValue(true);
		}
		obj.chkSelectAllClickFlag = 1;
	}
}
