function VB_InitVolumeBackEvent(obj) {
	obj.VB_LoadEvent = function(){
		obj.VB_GridVolumeBack.on("cellclick",obj.VB_GridVolumeBack_cellclick,obj);
		obj.VB_chkSelectAll.on("check",obj.VB_chkSelectAll_check,obj);
		obj.VB_btnCancel.on("click",obj.VB_btnCancel_click,obj);
		obj.VB_btnSave.on("click",obj.VB_btnSave_click,obj);
		obj.VB_chkSelectAll.setValue(true);
	};
	
	obj.VB_VolumeQuery = function(MrTypeID,MrNo){
		//查询借阅病案卷，同步执行
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCWMR.MOService.LendRecordSrv'
		url += '&QueryName=' + 'QryBackVolume'
		url += '&Arg1=' + MrTypeID
		url += '&Arg2=' + MrNo
		url += '&ArgCnt=' + 2
		url += '&2=2'
		conn.open('post',url,false);
		conn.send(null);
		
		if (conn.status != '200') {
			ExtTool.alert('错误', '查询Query报错!');
			return false;
		}
		
		var jsonData = new Ext.decode(conn.responseText);
		if (jsonData.total < 1){
			ExtTool.alert('错误', '无借出记录!');
			return false;
		} else {
			var VolCount = 0;
			for (var row = 0; row < jsonData.record.length; row++){
				var record = jsonData.record[row];
				record.IsChecked = '0'; //不全选,避免同一个病人不同病案卷被不同人借出,归还时误操作
				if (jsonData.record.length==1) record.IsChecked = '1'; //只有一条借出记录时自动选中 
				jsonData.record[row] = record;
				VolCount++;
			}
			
			obj.VB_GridVolumeBack.getStore().loadData(jsonData);
			if ((objScreen.WFIBatchOper=='1')&&(VolCount=1)) {
				obj.VB_btnSave_click();
			}else{
				return true;
			}
		}
	}
	
	obj.VB_chkSelectAllClickFlag = 1;
	obj.VB_chkSelectAll_check = function(){
		if (obj.VB_chkSelectAllClickFlag != 1) return;
		var objStore = obj.VB_GridVolumeBack.getStore();
		if (objStore.getCount() < 1){
			return;
		}
		
		var isCheck = obj.VB_chkSelectAll.getValue();
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			record.set('IsChecked', isCheck);
			obj.VB_GridVolumeBack.getStore().commitChanges();
			obj.VB_GridVolumeBack.getView().refresh();
		}
	}
	
	obj.VB_GridVolumeBack_cellclick = function(grid, rowIndex, columnIndex, e){
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
		
		obj.VB_chkSelectAllClickFlag = 0;
		if (isSelectAll == '0'){
			obj.VB_chkSelectAll.setValue(false);
		} else {
			obj.VB_chkSelectAll.setValue(true);
		}
		obj.VB_chkSelectAllClickFlag = 1;
	}
	
	obj.VB_btnSave_click = function(){
		var objStore = obj.VB_GridVolumeBack.getStore();
		if (objScreen.WFIBatchOper=='1') {
			for (var row = 0; row < objStore.getCount(); row++){
				var record = objStore.getAt(row);
				if (record.get('IsChecked') == '1'){
					objScreen.gridLendRecordStore.add(record);
				}
			}
			return;
		}

		var RecordIDs = '';
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			if (record.get('IsChecked') == '1'){
				RecordIDs += ',' + record.get('RecordID');
			}
		}
		if (RecordIDs != '') RecordIDs = RecordIDs.substr(1,RecordIDs.length-1);
		if (RecordIDs == ''){
			ExtTool.alert("提示", "请选择归还病案记录!");
			return;
		}
		var MrTypeID = Common_GetValue("cboMrType");
		if (!MrTypeID){
			ExtTool.alert("提示",'病案类型为空!');
			return;
		}
		var objWFItem = ExtTool.RunServerMethod('DHCWMR.SS.WorkFItem','GetWFItemBySysOpera',MrTypeID,"LB");
		if (!objWFItem){
			ExtTool.alert("提示",'无入库操作项目!');
			return;
		}
		
		var objInput = new Object();
		objInput.OperType = 'B';
		objInput.ToUserID = '';
		objInput.MRecord = '';
		objInput.LRecord = RecordIDs;
		objInput.Detail = '';
		objInput.LendFlag = '';
		
		obj.VB_WinVolumeBack.close();
		
		//是否用户校验
		if (objWFItem.WFICheckUser == 1){
			var win = new CU_InitCheckUser(objInput);
			win.WinCheckUser.show();
		} else {
			objScreen.SaveData(objInput);
		}
		
		Common_SetValue("txtMrNo",'');  //清空病案号
		Ext.getCmp("txtMrNo").focus(false, 100);
	}
	
	obj.VB_btnCancel_click = function(){
		obj.VB_WinVolumeBack.close();
		Common_SetValue("txtMrNo",'');  //清空病案号
		Ext.getCmp("txtMrNo").focus(false, 100);
	}
}