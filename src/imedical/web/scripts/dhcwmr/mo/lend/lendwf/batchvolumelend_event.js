function BL_InitVolumeLendEvent(obj) {
	obj.BL_LoadEvent = function(){
		obj.BL_GridVolumeLend.on("cellclick",obj.BL_GridVolumeLend_cellclick,obj);
		obj.BL_chkSelectAll.on("check",obj.BL_chkSelectAll_check,obj);
		obj.BL_btnCancel.on("click",obj.BL_btnCancel_click,obj);
		obj.BL_btnSave.on("click",obj.BL_btnSave_click,obj);
		obj.BL_chkSelectAll.setValue(true);
	};
	
	obj.BL_VolumeQuery = function(MrTypeID,MrNo){
		//查询借阅病案卷，同步执行
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCWMR.MOService.LendRecordSrv'
		url += '&QueryName=' + 'QryLendVolume'
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
				
				if (record.ProblemCode == '1') VolCount++;
				record.IsChecked = '1';
				jsonData.record[row] = record;
			}
			obj.BL_GridVolumeLend.getStore().loadData(jsonData);
			if ((VolCount==1)&&(objScreen.WFIBatchOper=='1')) {
				obj.BL_btnSave_click();
			}
			else{
				return true;
			}
		}
	}
	
	obj.BL_chkSelectAllClickFlag = 1;
	obj.BL_chkSelectAll_check = function(){
		if (obj.BL_chkSelectAllClickFlag != 1) return;
		var objStore = obj.BL_GridVolumeLend.getStore();
		if (objStore.getCount() < 1){
			return;
		}
		
		var isCheck = obj.BL_chkSelectAll.getValue();
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			record.set('IsChecked', isCheck);
			obj.BL_GridVolumeLend.getStore().commitChanges();
			obj.BL_GridVolumeLend.getView().refresh();
		}
	}
	
	obj.BL_GridVolumeLend_cellclick = function(grid, rowIndex, columnIndex, e){
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
				count++;
				if (record.get(fieldName) != '1') {
					isSelectAll = '0';
					break;
				}
			}
			if (count<1) isSelectAll = '0';
		}
		
		obj.BL_chkSelectAllClickFlag = 0;
		if (isSelectAll == '0'){
			obj.BL_chkSelectAll.setValue(false);
		} else {
			obj.BL_chkSelectAll.setValue(true);
		}
		obj.BL_chkSelectAllClickFlag = 1;
	}
	
	obj.BL_btnSave_click = function(){
		//当前父页面grid中条数
		var LRCount = objScreen.gridLendRecordStore.getCount();
		var objStore = obj.BL_GridVolumeLend.getStore();
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			var flg=1
			if (LRCount>0)
			{
				for (var i=0;i<LRCount ;i++ )
				{
					var objrecord=objScreen.gridLendRecordStore.getAt(i);
					if ((record.get('MainID')==objrecord.get('MainID'))&&(record.get('VolID')==objrecord.get('VolumeIDs')))
					{
						var flg=-1
					}
				}
			}
			if (flg<0) continue;
			if ((record.get('ProblemCode')== '1')&&(record.get('IsChecked') == '1')){
				var NewRecord = new objScreen.gridLendDataRecord({
					RecordID:'BL'+(++LRCount),
					PatientID:record.get('PatientID'),
					PapmiNo:record.get('PapmiNo'),
					MrNo:record.get('MrNo'),
					PatName:record.get('PatName'),
					Sex:record.get('Sex'),
					Age:record.get('Age'),
					MainID:record.get('MainID'),
					StatusCode:'O',
					StatusDesc:record.get('StatusDesc'),
					ReqDate:'',
					ReqTime:'',
					ReqUser:'',
					LendDate:'',
					LendTime:'',
					LendUser:'',
					BackDate:'',
					BackTime:'',
					BackUser:'',
					LLocCode:'',
					LLocDesc:'',
					LLocTel:'',
					LUserCode:'',
					LUserDesc:'',
					LUserTel:'',
					PurposeDescs:'',
					PrintFlag:'',
					ExpBackDate:'',
					Note:'',
					LendFlag:'',
					VolumeIDs:record.get('VolID'),
					IsChecked:1
				})
				objScreen.gridLendRecordStore.add(NewRecord);
			}
		}
		obj.BL_btnCancel_click();
	}
	
	obj.BL_btnCancel_click = function(){
		obj.BL_WinVolumeLend.close();
		Common_SetValue("txtMrNo",'');  //清空病案号
		Ext.getCmp("txtMrNo").focus(false, 100);
	}
}