function VS_InitVolumeSealEvent(obj)
{
	obj.VS_LoadEvents = function()
	{
		obj.VS_GridVolumeSeal.on("cellclick",obj.VS_GridVolumeSeal_cellclick,obj);
		obj.VS_chkSelectAll.on("check",obj.VS_chkSelectAll_check,obj);
		obj.VS_btnCancel.on("click",obj.VS_btnCancel_click,obj);
		obj.VS_btnSave.on("click",obj.VS_btnSave_click,obj);
		obj.VS_chkSelectAll.setValue(true);
	}
	
	obj.VS_VolumeQuery= function(MrTypeID,MrNo)
	{
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCWMR.MOService.SealRecordSrv'
		url += '&QueryName=' + 'QrySealVolume'
		url += '&Arg1=' + MrTypeID
		url += '&Arg2=' + MrNo
		url += '&ArgCnt=' + 2
		url += '&2=2'
		conn.open('post',url,false);
		conn.send(null);
		
		if (conn.status != '200') {
			ExtTool.alert('����', '��ѯQuery����!');
			return false;
		}
		
		var jsonData = new Ext.decode(conn.responseText);
		if (jsonData.total < 1){
			alert(jsonData.total);
			ExtTool.alert('����', '����Ч������!');
			return false;
		} else {
			for (var row = 0; row < jsonData.record.length; row++){
				var record = jsonData.record[row];
				record.IsChecked = '1';
				jsonData.record[row] = record;
			}
			obj.VS_GridVolumeSeal.getStore().loadData(jsonData);
			return true;
		}
	}
	
	obj.VS_chkSelectAllClickFlag = 1;
	obj.VS_chkSelectAll_check = function(){
		if (obj.VS_chkSelectAllClickFlag != 1) return;
		var objStore = obj.VS_GridVolumeSeal.getStore();
		if (objStore.getCount() < 1){
			return;
		}
		
		var isCheck = obj.VS_chkSelectAll.getValue();
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			record.set('IsChecked', isCheck);
			obj.VS_GridVolumeSeal.getStore().commitChanges();
			obj.VS_GridVolumeSeal.getView().refresh();
		}
	}
	
	obj.VS_GridVolumeSeal_cellclick = function(grid, rowIndex, columnIndex, e){
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
		
		obj.VS_chkSelectAllClickFlag = 0;
		if (isSelectAll == '0'){
			obj.VS_chkSelectAll.setValue(false);
		} else {
			obj.VS_chkSelectAll.setValue(true);
		}
		obj.VS_chkSelectAllClickFlag = 1;
	}
	
	obj.VS_btnSave_click = function(){
		var MainID = '';
		var VolumeIDs = '';
		var objStore = obj.VS_GridVolumeSeal.getStore();
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			if (record.get('IsChecked') == '1'){
				MainID = record.get('MainID');
				VolumeIDs += ',' + record.get('VolID');
			}
		}
		if (VolumeIDs != '') VolumeIDs = VolumeIDs.substr(1,VolumeIDs.length-1);
		if (VolumeIDs == ''){
			ExtTool.alert("��ʾ", "��ѡ�񲡰������!");
			return;
		}
		var MrTypeID = Common_GetValue("cboMrType");
		if (!MrTypeID){
			ExtTool.alert("��ʾ",'��������Ϊ��!');
			return;
		}
		var objWFItem = ExtTool.RunServerMethod('DHCWMR.SS.WorkFItem','GetWFItemBySysOpera',MrTypeID,"SS");
		if (!objWFItem){
			ExtTool.alert("��ʾ",'�޷�������Ŀ!');
			return;
		}
		var SClientName = Common_GetValue("VS_txtClientName");
		var SClientRelation = Common_GetValue("VS_cboClientRelation");
		var SCardType = Common_GetValue("VS_cboCardType");
		var SPersonalID = Common_GetValue("VS_txtPersonalID");
		var STelephone = Common_GetValue("VS_txtTelephone");
		var SAddress = Common_GetValue("VS_txtAddress");
		var SContent = Common_GetValue("VS_cboContent");
		var SReason = Common_GetValue("VS_cboReason");
		var SCount = Common_GetValue("VS_txtCount");
		var SDocID = Common_GetValue("VS_cboDoc");
		var SMedUserID = Common_GetValue("VS_cboMedUser");
		var SNote = Common_GetValue("VL_txtNote");
		
		var Error = '';
		if (!SClientName) Error += 'ί����������'; 
		if (!SClientRelation) Error += '�뻼�߹�ϵ��'; 
		if (!SCardType) Error += '֤�����ϡ�'; 
		if (!SPersonalID) Error += '֤�����롢'; 
		if (!STelephone) Error += '��ϵ�绰��'; 
		if (!SAddress) Error += '��ϵ��ַ��'; 
		if (!SContent) Error += '������ݡ�'; 
		if (!SReason) Error += '���ԭ��'; 
		if (!SCount) Error += '������'; 
		if (!SDocID) Error += 'ҽ����'; 
		if (!SMedUserID) Error += 'ҽ����Ա��'; 
		if (Error){
			ExtTool.alert('��ʾ',Error+'Ϊ�գ�');
			return;
		}
		var SealInfo = ""
			+ "^" + SClientName
			+ "^" + SClientRelation
			+ "^" + SCardType
			+ "^" + SPersonalID
			+ "^" + STelephone
			+ "^" + SAddress
			+ "^" + SContent
			+ "^" + SReason
			+ "^" + SCount
			+ "^" + SDocID
			+ "^" + SMedUserID
			+ "^" + SNote
			
		var objInput = new Object();
		objInput.OperType = 'S';
		objInput.ToUserID = '';
		objInput.MrInfo = MainID + '^' + VolumeIDs;
		objInput.SealInfo = SealInfo;
		
		obj.VS_WinVolumeSeal.close();
		
		//�Ƿ��û�У��
		if (objWFItem.WFICheckUser == 1){
			var win = new CU_InitCheckUser(objInput);
			win.WinCheckUser.show();
		} else {
			objScreen.SaveData(objInput);
		}
		
		Common_SetValue("txtMrNo",'');  //��ղ�����
		Ext.getCmp("txtMrNo").focus(false, 100);
	}
	
	obj.VS_btnCancel_click = function()
	{
		obj.VS_WinVolumeSeal.close();
		Common_SetValue("txtMrNo",'');  //��ղ�����
		Ext.getCmp("txtMrNo").focus(false, 100);
	}
}