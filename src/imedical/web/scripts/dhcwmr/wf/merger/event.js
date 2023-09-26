function InitEvent(obj){
	//var objMergerSrv = ExtTool.StaticServerObject("DHCWMR.SSService.MergerSrv");
	obj.LoadEvents = function(){
		obj.txtFromMrNo.setWidth(150);
		obj.txtToMrNo.setWidth(150);
		obj.txtFromMrNo.on('specialkey',obj.txtFromMrNo_specialkey,obj);
		obj.txtToMrNo.on('specialkey',obj.txtToMrNo_specialkey,obj);
		obj.btnSubmit.on('click',obj.btnSubmit_click,obj);
		obj.btnCancel.on('click',obj.btnCancel_click,obj);
		obj.btnMrNoMarker.on('click',obj.btnMrNoMarker_click,obj);
		obj.gridFromVolumeList.on("cellclick",obj.gridFromVolumeList_cellclick,obj);
		obj.chkSelectAll.on("check",obj.chkSelectAll_check,obj);
		
		obj.cboHospital.on("select",obj.cboHospital_select,obj);
		obj.cboMrType.on("select",obj.cboMrType_select,obj);
		obj.cboHospital.setValue(CTHospID);
		obj.cboHospital.setRawValue(CTHospDesc);
		obj.cboHospital_select();

		if (IsSecret!=1) {     //不涉密就隐藏【病人密级】和【病人级别】两列
			var cm = obj.gridFromVolumeList.getColumnModel();
	    		var cfg = null;
			for(var i=0;i<cm.config.length;++i)
	 		{
	   	 		cfg = cm.config[i];
	   	 		if ((cfg.id=="Secret1")||(cfg.id=="Secret2")) {
					cm.setHidden(i,true);
	   	 		}
			}
			var cm = obj.gridToVolumeList.getColumnModel();
	    		var cfg = null;
			for(var i=0;i<cm.config.length;++i)
	 		{
	   	 		cfg = cm.config[i];
	   	 		if ((cfg.id=="Secret1")||(cfg.id=="Secret2")) {
					cm.setHidden(i,true);
	   	 		}
			}
		}
		if (MrClass=='O')
		{
			var cm = obj.gridFromVolumeList.getColumnModel();
	    		var cfg = null;
			for(var i=0;i<cm.config.length;++i)
	 		{
	   	 		cfg = cm.config[i];
	   	 		if ((cfg.id=="AdmWardDesc")||(cfg.id=="DischDate")||(cfg.id=="BackDate")) {
					cm.setHidden(i,true);
	   	 		}
			}
			var cm = obj.gridToVolumeList.getColumnModel();
	    		var cfg = null;
			for(var i=0;i<cm.config.length;++i)
	 		{
	   	 		cfg = cm.config[i];
	   	 		if ((cfg.id=="AdmWardDesc")||(cfg.id=="DischDate")||(cfg.id=="BackDate")) {
					cm.setHidden(i,true);
	   	 		}
			}
		}
	}
	
	obj.cboHospital_select = function(combo,record,index){
		//加载病案类型
		obj.cboMrType.getStore().removeAll();
		obj.cboMrType.getStore().load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0) {
						obj.cboMrType.setValue(r[0].get("MrTypeID"));
						obj.cboMrType.setRawValue(r[0].get("MrTypeDesc"));
						obj.cboMrType_select();
					}
				}
			}
		});
	}
	
	obj.cboMrType_select = function(combo,record,index){
		Common_SetValue('txtFromMrNo','');
		Common_SetValue('txtToMrNo','');
		Common_SetValue('chkSelectAll',false);
		Common_SetDisabled('btnSubmit',true);
		Common_SetDisabled('btnCancel',true);
		Common_SetDisabled('btnMrNoMarker',true);
		Common_SetDisabled('cboMrNoMarker',true);
		Common_SetDisabled('txtFromMrNo',false);
		Common_SetDisabled('chkSelectAll',true);
		Common_SetDisabled('txtToMrNo',true);
		obj.gridFromVolumeList.getStore().removeAll();
		obj.gridToVolumeList.getStore().removeAll();
		
		obj.cboNoType.getStore().removeAll();
		obj.cboNoType.getStore().load({});
	}
	
	obj.txtFromMrNo_specialkey = function(field, e) {
		if (e.getKey() != Ext.EventObject.ENTER) return;
		
		var MrTypeID = Common_GetValue('cboMrType');
		if (!MrTypeID) {
			ExtTool.alert("错误提示",'病案类型为空!');
			return;
		}
		var FromMrNo = Common_GetValue('txtFromMrNo');
		if (!FromMrNo) {
			ExtTool.alert("错误提示",'病案号为空!');
			return;
		}
		
		obj.gridFromVolumeList.getStore().removeAll();
		obj.gridFromVolumeList.getStore().load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0) {
						Common_SetDisabled('txtFromMrNo',true);
						Common_SetDisabled('txtToMrNo',false);
						Common_SetDisabled('btnCancel',false);
						Common_SetDisabled('chkSelectAll',false);
						Common_SetValue('chkSelectAll',true);
						obj.chkSelectAll_check();
						Common_SetDisabled('btnMrNoMarker',false);
						Common_SetDisabled('cboMrNoMarker',false);
						obj.GetMrNoMarker();
					}
				}
			}
		});
	}
	
	obj.txtToMrNo_specialkey = function(field, e) {
		if (e.getKey() != Ext.EventObject.ENTER) return;
		
		var MrTypeID = Common_GetValue('cboMrType');
		if (!MrTypeID) {
			ExtTool.alert("错误提示",'病案类型为空!');
			return;
		}
		var ToMrNo = Common_GetValue('txtToMrNo');
		if (!ToMrNo) {
			ExtTool.alert("错误提示",'病案号为空!');
			return;
		}
		
		obj.gridToVolumeList.getStore().removeAll();
		obj.gridToVolumeList.getStore().load({
			callback : function(r,option,success){
				if (success) {
					Common_SetDisabled('txtToMrNo',true);
					Common_SetDisabled('btnSubmit',false);
				}
			}
		});
	}
	
	obj.chkSelectAllClickFlag = 1;
	obj.chkSelectAll_check = function(){
		if (obj.chkSelectAllClickFlag != 1) return;
		var objStore = obj.gridFromVolumeList.getStore();
		if (objStore.getCount() < 1){
			return;
		}
		
		var isCheck = obj.chkSelectAll.getValue();
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			record.set('IsChecked', isCheck);
			obj.gridFromVolumeList.getStore().commitChanges();
			obj.gridFromVolumeList.getView().refresh();
		}
	}
	
	obj.gridFromVolumeList_cellclick = function(grid, rowIndex, columnIndex, e){
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
		
		obj.chkSelectAllClickFlag = 0;
		if (isSelectAll == '0'){
			obj.chkSelectAll.setValue(false);
		} else {
			obj.chkSelectAll.setValue(true);
		}
		obj.chkSelectAllClickFlag = 1;
	}
	
	obj.btnCancel_click = function(){
		obj.cboMrType_select();
	}
	
	obj.btnSubmit_click = function() {
		var MrTypeID = Common_GetValue('cboMrType');
		if (!MrTypeID) {
			ExtTool.alert("错误提示",'病案类型为空!');
			return;
		}
		var FromMrNo = Common_GetValue('txtFromMrNo');
		if (!FromMrNo) {
			ExtTool.alert("错误提示",'旧病案号为空!');
			return;
		}
		var ToMrNo = Common_GetValue('txtToMrNo');
		if (!ToMrNo) {
			ExtTool.alert("错误提示",'新病案号为空!');
			return;
		}
		if (FromMrNo.toUpperCase() == ToMrNo.toUpperCase()) {
			ExtTool.alert("错误提示",'新病案号与旧病案号相同!');
			return;
		}
		
		var objStore = obj.gridFromVolumeList.getStore();
		var VolumeIDs = '';
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			if (record.get('IsChecked') != '1') continue;
			VolumeIDs += ',' + record.get('VolID');
		}
		if (VolumeIDs != '') VolumeIDs = VolumeIDs.substr(1,VolumeIDs.length - 1);
		if (!VolumeIDs) {
			ExtTool.alert("错误提示",'未选择修改卷列表!');
			return;
		}
		
		var ret = ExtTool.RunServerMethod("DHCWMR.SSService.MergerSrv","MergerMrNo",MrTypeID,FromMrNo,VolumeIDs,ToMrNo,session['LOGON.USERID']);
		if (parseInt(ret) < 1){
			ExtTool.alert("错误", "病案号修改失败!");
		} else {
			ExtTool.alert("提示", "病案号修改成功!");
		}
		obj.gridFromVolumeList.getStore().removeAll();
		obj.gridFromVolumeList.getStore().load({});
		obj.gridToVolumeList.getStore().removeAll();
		obj.gridToVolumeList.getStore().load({});
	}
	
	obj.btnMrNoMarker_click = function()
	{
		var objStore = obj.gridFromVolumeList.getStore();
		var MainID = '';
		if (objStore.getCount()>0) {
			var record = objStore.getAt(0);
			MainID = record.get('MainID');
		}
		if (MainID == '') return;
		var MarkerID = Common_GetValue('cboMrNoMarker');
		var ret = ExtTool.RunServerMethod("DHCWMR.SS.Main","UpdateMarker",MainID,MarkerID);
		if (parseInt(ret) < 1){
			ExtTool.alert("错误", "修改病案号标记失败!");
		} else {
			ExtTool.alert("提示", "修改病案号标记成功!");
		}
	}
	
	obj.GetMrNoMarker = function()
	{
		var Marker = '';
		var objStore = obj.gridFromVolumeList.getStore();
		var MainID = '';
		if (objStore.getCount()>0) {
			var record = objStore.getAt(0);
			MainID = record.get('MainID');
			Marker = ExtTool.RunServerMethod("DHCWMR.SS.Main","GetMarker",MainID);
		}
		
		//加载病案类型
		obj.cboMrNoMarker.getStore().removeAll();
		obj.cboMrNoMarker.getStore().load({
			callback : function(r,option,success){
				if (success) {
					if (r.length>0){
						for (var row = 0; row < r.length; row++){
							if (Marker == r[row].get("DicCode")){
								obj.cboMrNoMarker.setValue(r[row].get("DicRowId"));
								obj.cboMrNoMarker.setRawValue(r[row].get("DicDesc"));
							}
						}
					}
				}
			}
		});
	}
}
