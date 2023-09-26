function VL_InitVolumeLendEvent(obj) {
	obj.VL_LoadEvent = function(){
		obj.VL_GridVolumeLend.on("cellclick",obj.VL_GridVolumeLend_cellclick,obj);
		obj.VL_chkSelectAll.on("check",obj.VL_chkSelectAll_check,obj);
		obj.VL_btnCancel.on("click",obj.VL_btnCancel_click,obj);
		obj.VL_btnSave.on("click",obj.VL_btnSave_click,obj);
		obj.VL_cboLendLoc.on("select",obj.VL_cboLendLoc_select,obj);
		Common_SetValue("VL_txtLExpBackDate",'');
	};
	
	obj.VL_VolumeQuery = function(MrTypeID,MrNo){
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
			for (var row = 0; row < jsonData.record.length; row++){
				var record = jsonData.record[row];
				record.IsChecked = '0';
				jsonData.record[row] = record;
			}
			obj.VL_GridVolumeLend.getStore().loadData(jsonData);
			return true;
		}
	}
	
	obj.VL_cboLendLoc_select = function(combo,record,index){
		Common_SetValue("VL_cboLendDoc","","");
		obj.VL_cboLendDoc.getStore().removeAll();
		obj.VL_cboLendDoc.getStore().load({});
	}
	
	obj.VL_chkSelectAllClickFlag = 1;
	obj.VL_chkSelectAll_check = function(){
		if (obj.VL_chkSelectAllClickFlag != 1) return;
		var objStore = obj.VL_GridVolumeLend.getStore();
		if (objStore.getCount() < 1){
			return;
		}
		
		var isCheck = obj.VL_chkSelectAll.getValue();
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			if (record.get('ProblemCode')!=1) continue;
			record.set('IsChecked', isCheck);
			obj.VL_GridVolumeLend.getStore().commitChanges();
			obj.VL_GridVolumeLend.getView().refresh();
		}
	}
	
	obj.VL_GridVolumeLend_cellclick = function(grid, rowIndex, columnIndex, e){
		if (columnIndex != 1) return;
		var record = grid.getStore().getAt(rowIndex);
		var fieldName = grid.getColumnModel().getDataIndex(columnIndex);
	    var recValue = record.get(fieldName);
		if (record.get('ProblemCode')!= 1) return;
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
		
		obj.VL_chkSelectAllClickFlag = 0;
		if (isSelectAll == '0'){
			obj.VL_chkSelectAll.setValue(false);
		} else {
			obj.VL_chkSelectAll.setValue(true);
		}
		obj.VL_chkSelectAllClickFlag = 1;
	}
	
	obj.VL_btnSave_click = function(){
		var MainID = '';
		var VolumeIDs = '';
		var Error='';
		var objStore = obj.VL_GridVolumeLend.getStore();
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			if (record.get('IsChecked') == '1'){
				MainID = record.get('MainID');
				VolumeIDs += ',' + record.get('VolID');
			}
		}
		if (VolumeIDs != '') VolumeIDs = VolumeIDs.substr(1,VolumeIDs.length-1);
		if (VolumeIDs == ''){
			ExtTool.alert("提示", "请选择病案卷借阅!");
			return;
		}
		var MrTypeID = Common_GetValue("cboMrType");
		if (!MrTypeID){
			ExtTool.alert("提示",'病案类型为空!');
			return;
		}
		
		var LLocID = Common_GetValue("VL_cboLendLoc");
		var LLocDesc = Common_GetText("VL_cboLendLoc");
		var LLocTel = Common_GetValue("VL_txtLLocTel");
		var LCareProvID = Common_GetValue("VL_cboLendDoc");   
		var LCareProvName = Common_GetText("VL_cboLendDoc");
		var LUserTel = Common_GetValue("VL_txtLUserTel");
		var LPurpose = Common_GetValue("VL_cbgLPurpose");
		var LExpBackDate = Common_GetValue("VL_txtLExpBackDate");
		var LNote = Common_GetValue("VL_txtLNote");
		if (LPurpose != "") LPurpose = LPurpose.replace(/,/g,'#');
		if (!LCareProvName) Error = Error+'借阅医生、';
		if (!LLocDesc) Error = Error+'借阅科室、';
		if (Error)
		{
			ExtTool.alert("提示",Error+'为空！');
			return;
		}
		var objWFItem = ExtTool.RunServerMethod('DHCWMR.SS.WorkFItem','GetWFItemBySysOpera',MrTypeID,"LL");
		if (!objWFItem){
			ExtTool.alert("提示",'无出库操作项目!');
			return;
		}
		
		var Deatil = LLocID                     //借阅科室
			+ "^" + LLocDesc                    //借阅科室名称
			+ "^" + LLocTel                     //借阅科室电话
			+ "^" + LCareProvID                 //借阅人（医护人员）
			+ "^" + LCareProvName               //借阅人姓名（医护人员）
			+ "^" + LUserTel                    //借阅人电话
			+ "^" + LPurpose                    //借阅目的
			+ "^" + LExpBackDate                //预计归还日期
			+ "^" + LNote                       //备注

		var objInput = new Object();
		objInput.OperType = 'L';
		objInput.ToUserID = '';
		objInput.MRecord = MainID + '^' + VolumeIDs;
		objInput.LRecord = '';
		objInput.Detail = Deatil;
		objInput.LendFlag = '';
		
		obj.VL_WinVolumeLend.close();
		
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
	
	obj.VL_btnCancel_click = function(){
		obj.VL_WinVolumeLend.close();
		Common_SetValue("txtMrNo",'');  //清空病案号
		Ext.getCmp("txtMrNo").focus(false, 100);
	}
}