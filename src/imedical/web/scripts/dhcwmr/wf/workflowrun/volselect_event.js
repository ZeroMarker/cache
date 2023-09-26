function VS_InitVolumeSelectEvent(obj) {
	obj.VS_LoadEvent = function(){
		obj.VS_GridVolumeSelect.on("cellclick",obj.VS_GridVolumeSelect_cellclick,obj);
		obj.VS_chkSelectAll.on("check",obj.VS_chkSelectAll_check,obj);
		obj.VS_btnCancel.on("click",obj.VS_btnCancel_click,obj);
		obj.VS_btnSave.on("click",obj.VS_btnSave_click,obj);
		obj.VS_txtMrNo.on("specialKey",obj.VS_txtMrNo_specialKey,obj);
		obj.VS_chkSelectAll.setValue(true);
	};
	
	obj.VS_VolumeQuery = function(MrTypeID,WFItemOBJ,MrNo){
		obj.VS_Argument.MrTypeID = MrTypeID;
		obj.VS_Argument.WFItemOBJ = WFItemOBJ;
		obj.VS_Argument.MrNo = MrNo;
		
		obj.VS_txtMrNo.setValue(MrNo);
		
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCWMR.SSService.OperationQry'
		url += '&QueryName=' + 'QrySelVolList'
		url += '&Arg1=' + MrTypeID
		url += '&Arg2=' + WFItemOBJ.WFItemID
		url += '&Arg3=' + MrNo
		url += '&Arg4=' + ''
		url += '&ArgCnt=' + 4
		url += '&2=2'
		conn.open('post',url,false);
		conn.send(null);
		
		if (conn.status != '200') {
			ExtTool.alert('错误', '查询Query报错!');
			return false;
		}
		
		var jsonData = new Ext.decode(conn.responseText);
		if (jsonData.total < 1){
			alert('无有效病案卷!');
			return false;
		} else {
			var RecordIDs = '';
			var VolumeIDs = '';
			var isProblem = 0;
			var volCount = 0;
			for (var row = 0; row < jsonData.record.length; row++){
				var record = jsonData.record[row];
				if (record.ProblemCode != '1'){
					isProblem = 1;
				} else {
					volCount++;
					RecordIDs += ',' + record.RecordID;
					VolumeIDs += ',' + record.VolID;
					record.IsChecked = '1';
					jsonData.record[row] = record;
				}
			}
			if (RecordIDs != '') RecordIDs=RecordIDs.substr(1,RecordIDs.length-1);
			if (VolumeIDs != '') VolumeIDs = VolumeIDs.substr(1,VolumeIDs.length-1);
			
			//if ((volCount == 1)&&(isProblem == 0)) {
			if (volCount == 1) {  //update by zf 20150402 如果只有一条符合当前流程，自动加载
				var MrTypeID = obj.VS_Argument.MrTypeID;
				var WFItemID = obj.VS_Argument.WFItemOBJ.WFItemID;
				var ret = ExtTool.RunServerMethod("DHCWMR.SSService.OperationWL","SetVolume",MrTypeID,WFItemID,RecordIDs,session['LOGON.USERID']);
				if (parseInt(ret) < 0){
					ExtTool.alert("提示", "自动添加有效卷错误,Err="+flg);
				} else {
					objScreen.PrintMrBarcode(VolumeIDs);  //打印条码 add by zf 20150318
					Common_LoadCurrPage("GridWorkList",1);
				}
				return false;
			} else {
				obj.VS_GridVolumeSelect.getStore().loadData(jsonData);
				Ext.getCmp("VS_txtMrNo").focus(false, 500);
				return true;
			}
		}
	}
	
	obj.VS_chkSelectAllClickFlag = 1;
	obj.VS_chkSelectAll_check = function(){
		if (obj.VS_chkSelectAllClickFlag != 1) return;
		var objStore = obj.VS_GridVolumeSelect.getStore();
		if (objStore.getCount() < 1){
			return;
		}
		
		var isCheck = obj.VS_chkSelectAll.getValue();
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			if (record.get('ProblemCode') != 1) continue;  //不符合条件记录，不允许选择
			
			record.set('IsChecked', isCheck);
			obj.VS_GridVolumeSelect.getStore().commitChanges();
			obj.VS_GridVolumeSelect.getView().refresh();
		}
	}
	
	obj.VS_GridVolumeSelect_cellclick = function(grid, rowIndex, columnIndex, e){
		if (columnIndex != 1) return;
		var record = grid.getStore().getAt(rowIndex);
		if (record.get('ProblemCode') != 1) return;
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
				if (record.get('ProblemCode') != 1) continue;  //不符合条件记录，不允许选择
				count++;
				if (record.get(fieldName) != '1') {
					isSelectAll = '0';
					break;
				}
			}
			if (count<1) isSelectAll = '0';
		}
		
		obj.VS_chkSelectAllClickFlag = 0;
		if (isSelectAll == '0'){
			obj.VS_chkSelectAll.setValue(false);
		} else {
			obj.VS_chkSelectAll.setValue(true);
		}
		obj.VS_chkSelectAllClickFlag = 1;
	}
	
	obj.VS_txtMrNo_specialKey = function(field, e) {
		if (e.getKey() != Ext.EventObject.ENTER) return;
		obj.VS_btnSave_click();
	}
	
	obj.VS_btnSave_click = function(){
		var RecordIDs = '';
		var VolumeIDs = '';
		var objStore = obj.VS_GridVolumeSelect.getStore();
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			if (record.get('IsChecked') == '1'){
				RecordIDs += ',' + record.get('RecordID');
				VolumeIDs += ',' + record.get('VolID');
			}
		}
		if (RecordIDs != '') RecordIDs = RecordIDs.substr(1,RecordIDs.length-1);
		if (VolumeIDs != '') VolumeIDs = VolumeIDs.substr(1,VolumeIDs.length-1);
		
		if (RecordIDs == ''){
			ExtTool.alert('提示', '无有效病案卷!');
			return;
		} else {
			var MrTypeID = obj.VS_Argument.MrTypeID;
			var WFItemID = obj.VS_Argument.WFItemOBJ.WFItemID;
			var ret = ExtTool.RunServerMethod("DHCWMR.SSService.OperationWL","SetVolume",MrTypeID,WFItemID,RecordIDs,session['LOGON.USERID']);
			if (parseInt(ret) < 0){
				ExtTool.alert("提示", "自动添加有效卷错误,Err="+ret);
				return;
			} else {
				objScreen.PrintMrBarcode(VolumeIDs);  //打印条码 add by zf 20150318
			}
		}
		
		Common_LoadCurrPage("GridWorkList",1);
		obj.VS_WinVolumeSelect.close();
		Common_SetValue("txtMrNo",'');  //清空病案号
		Ext.getCmp("txtMrNo").focus(false, 100);
	}
	
	obj.VS_btnCancel_click = function(){
		obj.VS_WinVolumeSelect.close();
		Common_SetValue("txtMrNo",'');  //清空病案号
		Ext.getCmp("txtMrNo").focus(false, 100);
	}
}