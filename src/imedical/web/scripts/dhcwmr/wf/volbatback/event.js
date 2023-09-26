function VBB_InitVolumeSelectEvent(obj) {
	obj.VBB_LoadEvent = function(){
		obj.VBB_GridVolumeSelect.on("cellclick",obj.VBB_GridVolumeSelect_cellclick,obj);
		obj.VBB_chkSelectAll.on("check",obj.VBB_chkSelectAll_check,obj);
		obj.VBB_btnCancel.on("click",obj.VBB_btnCancel_click,obj);
		obj.VBB_btnSave.on("click",obj.VBB_btnSave_click,obj);
		
		obj.VBB_chkSelectAll.setValue(true);
		obj.VBB_LoadSelectVol();  //加载卷列表
	};
	
	obj.VBB_LoadSelectVol = function(){
		obj.VBB_GridVolumeSelectStore.load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0) {
						if (obj.VBB_chkSelectAll.getValue() == true){
							obj.VBB_chkSelectAll_check();
						}
					}
				}
			}
		});
	}
	
	obj.VBB_chkSelectAllClickFlag = 1;
	obj.VBB_chkSelectAll_check = function(){
		if (obj.VBB_chkSelectAllClickFlag != 1) return;
		var objStore = obj.VBB_GridVolumeSelect.getStore();
		if (objStore.getCount() < 1){
			return;
		}
		
		var isCheck = obj.VBB_chkSelectAll.getValue();
		for (var row = 0; row < objStore.getCount(); row++){
			objStore.getAt(row).set('IsChecked', isCheck);
		}
		obj.VBB_GridVolumeSelect.getStore().commitChanges();
		obj.VBB_GridVolumeSelect.getView().refresh();
	}
	
	obj.VBB_GridVolumeSelect_cellclick = function(grid, rowIndex, columnIndex, e){
		if (columnIndex != 1) return;
		var record = grid.getStore().getAt(rowIndex);
		var fieldName = grid.getColumnModel().getDataIndex(columnIndex);
	    var recValue = record.get(fieldName);
		if (recValue == '1') {
			var newValue = '0';
		} else {
			var newValue = '1';
		}
		record.set(fieldName, newValue);
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
		
		obj.VBB_chkSelectAllClickFlag = 0;
		if (isSelectAll == '0'){
			obj.VBB_chkSelectAll.setValue(false);
		} else {
			obj.VBB_chkSelectAll.setValue(true);
		}
		obj.VBB_chkSelectAllClickFlag = 1;
	}
	
	obj.VBB_btnSave_click = function(){
		var VolumeIDs = '';
		var objStore = obj.VBB_GridVolumeSelect.getStore();
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			if (record.get('IsChecked') == '1'){
				VolumeIDs += ',' + record.get('VolID');
			}
		}
		if (VolumeIDs != '') VolumeIDs = VolumeIDs.substr(1,VolumeIDs.length-1);
		
		if (VolumeIDs == ''){
			ExtTool.alert('提示', '无有效病案卷!');
			return;
		} else {
			var ret = ExtTool.RunServerMethod("DHCWMR.SSService.OperationWL","BatchOperaByVol",obj.MrTypeID,obj.SysOpera,session['LOGON.USERID'],VolumeIDs);
			if (parseInt(ret) < 0){
				ExtTool.alert("提示", "批量回收病案错误,Err="+ret);
			}
			obj.VBB_LoadSelectVol();  //加载卷列表
		}
	}
	
	obj.VBB_btnCancel_click = function(){
		obj.VBB_WinVolumeSelect.close();
		Common_LoadCurrPage(obj.ParrefGridId,1);
	}
}