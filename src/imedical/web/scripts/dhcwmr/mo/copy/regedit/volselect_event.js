function BVC_InitVolumeCopyEvent(obj){
	obj.BVC_LoadEvent=function(){
		obj.BVC_btnSave.on('click',obj.BVC_btnSave_click,obj);
		obj.BVC_btnCancel.on('click',obj.BVC_btnCancel_click,obj);
		obj.BVC_GridVolumeCopy.on("cellclick",obj.BVC_GridVolumeCopy_cellclick,obj);
	}
	
	obj.BVC_btnCancel_click = function(){
		obj.BVC_WinVolumeCopy.close();
		Common_SetValue("txtMrNo",'');  //清空病案号
		Ext.getCmp("txtMrNo").focus(false, 100);
	}	
	
	obj.BVC_VolumeQuery = function(MrTypeID,MrNo){
		//查询借阅病案卷，同步执行
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCWMR.MOService.CopyRecordSrv'
		url += '&QueryName=' + 'QryCopyVolume'
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
			ExtTool.alert('错误', '无有效病案卷!');
			return false;
		} else {
			var VolCount = 0;
			for (var row = 0; row < jsonData.record.length; row++){
				var record = jsonData.record[row];
				record.IsChecked = '1';
				jsonData.record[row] = record;
				VolCount += 1;
			}
			obj.BVC_GridVolumeCopy.getStore().loadData(jsonData);
			if (VolCount==1) {
				obj.BVC_btnSave_click();
			}
			else{
				return true;
			}
		}
	}
	
	obj.BVC_btnSave_click = function(){
		//当前父页面grid中条数
		var LRCount = objScreen.gridCopyStore.getCount();
		var objStore = obj.BVC_GridVolumeCopy.getStore();
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			var flg=1
			if (LRCount>0)
			{
				for (var i=0;i<LRCount ;i++ )
				{
					var objrecord=objScreen.gridCopyStore.getAt(i);
					if ((record.get('MainID')==objrecord.get('MainID'))&&(record.get('VolID')==objrecord.get('VolumeIDs')))
					{
						var flg=-1
					}
				}
			}
			if (flg<0) continue;
			if (record.get('IsChecked') == '1'){
				var NewRecord = new objScreen.gridCopyDataRecord({
					PatientID:record.get('PatientID'),
					PapmiNo:record.get('PapmiNo'),
					MrNo:record.get('MrNo'),
					PatName:record.get('PatName'),
					MainID:record.get('MainID'),
					StatusDesc:record.get('StatusDesc'),
					VolumeID:record.get('VolID'),
					IsChecked:1
				})
				objScreen.gridCopyStore.add(NewRecord);
			}
		}
			
		obj.BVC_btnCancel_click();
		
	}

	obj.BVC_GridVolumeCopy_cellclick = function(grid, rowIndex, columnIndex, e){
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
	}
}