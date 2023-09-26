function VS_InitVolumeSelectEvent(obj) {
	obj.VS_LoadEvent = function(){
		//obj.VS_GridVolumeSelect.on("rowclick",obj.VS_GridVolumeSelect_rowclick,obj);
		obj.VS_GridVolumeSelect.on("rowdblclick",obj.VS_GridVolumeSelect_rowdblclick,obj);
		obj.VS_btnCancel.on("click",obj.VS_btnCancel_click,obj);
		obj.VS_btnSave.on("click",obj.VS_btnSave_click,obj);
		obj.VS_txtMrNo.on("specialKey",obj.VS_txtMrNo_specialKey,obj);
	};
	
	obj.VS_VolumeQuery = function(aHospIDs,aMrTypeID,aFPType,aMrNo){
		obj.VS_txtMrNo.setValue(aMrNo);
		
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCWMR.FPService.FPVolumeQry'
		url += '&QueryName=' + 'QryVolumeList'
		url += '&Arg1=' + aHospIDs
		url += '&Arg2=' + aMrTypeID
		url += '&Arg3=' + aFPType
		url += '&Arg4=' + aMrNo
		url += '&Arg5=' + ''
		url += '&Arg6=' + ''
		url += '&Arg7=' + ''
		url += '&Arg8=' + ''                        //修改与QryVolumeList方法入参不一致的情况，解决病案编目时输入病案号不能直接编目的问题
		url += '&Arg9=' + 0
		url += '&ArgCnt=' + 9
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
			var isFinishCnt = 0;
			var unFinishCnt = 0;
			var VolumeID = '',FrontPageID = '';
			for (var row = 0; row < jsonData.record.length; row++){
				var record = jsonData.record[row];
				if (record.FPIsFinish == '编目') {
					isFinishCnt++;
				} else {
					unFinishCnt++;
					VolumeID = record.VolID;
					FrontPageID = record.FrontPageID;
					record.IsChecked = '1';
					jsonData.record[row] = record;
				}
			}
			
			//if ((unFinishCnt == 1)&&(isFinishCnt == 0)) {
			if (unFinishCnt == 1) {  //update by zf 20150402 当前只有一条待编目记录，自动弹出编目页面
				objScreen.ViewFrontPageEdit(FrontPageID,VolumeID);
				return false;
			} else {
				obj.VS_GridVolumeSelect.getStore().loadData(jsonData);
				Ext.getCmp("VS_txtMrNo").focus(false, 500);
				return true;
			}
		}
	}
	
	obj.VS_GridVolumeSelect_rowclick = function(grid,rowIndex,e){
		grid.getView().getRow(rowIndex).className = "x-grid3-row    x-grid3-row-first ";
		var objStore = grid.getStore();
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			if (row == rowIndex){
				record.set('IsChecked', '1');
			} else {
				record.set('IsChecked', '0');
			}
		}
		grid.getStore().commitChanges();
		grid.getView().refresh();
		
		Ext.getCmp("VS_txtMrNo").focus(false, 100);  //光标回到病案号输入框
	}
	
	obj.VS_txtMrNo_specialKey = function(field, e) {
		if (e.getKey() != Ext.EventObject.ENTER) return;
		obj.VS_btnSave_click();
	}
	
	obj.VS_btnSave_click = function(){
		var chkVolumeCnt = 0;
		var VolumeID = '',FrontPageID = '';
		var objStore = obj.VS_GridVolumeSelect.getStore();
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			if (record.get('IsChecked') == '1'){
				chkVolumeCnt++;
				FrontPageID = record.get('FrontPageID');
				VolumeID = record.get('VolID');
			}
		}
		
		if (chkVolumeCnt < 1){
			ExtTool.alert('提示', '未选择编目病案卷!');
			return;
		}
		if (chkVolumeCnt > 1){
			ExtTool.alert('提示', '请选择一卷编目病案卷!');
			return;
		}
		
		obj.VS_WinVolumeSelect.close();
		objScreen.ViewFrontPageEdit(FrontPageID,VolumeID);
	}
	obj.VS_GridVolumeSelect_rowdblclick = function(grid,rowIndex,e){
		var record = grid.getStore().getAt(rowIndex);
		FrontPageID = record.get('FrontPageID');
		VolumeID = record.get('VolID');
		
		obj.VS_WinVolumeSelect.close();
		objScreen.ViewFrontPageEdit(FrontPageID,VolumeID);
	}
	obj.VS_btnCancel_click = function(){
		obj.VS_WinVolumeSelect.close();
		Common_SetValue("txtMrNo",'');  //清空病案号
		Ext.getCmp("txtMrNo").focus(false, 100);
	}
}