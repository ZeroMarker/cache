function VC_InitVolumeCopyEvents(obj)
{
	obj.VC_LoadEvents = function()
	{
		obj.VC_btnSave.on('click',obj.VC_btnSave_click,obj);
		obj.VC_GridVolumeCopy.on("cellclick",obj.VC_GridVolumeCopy_cellclick,obj);
		obj.VC_chkSelectAll.on("check",obj.VC_chkSelectAll_check,obj);
		obj.VC_chkSelectAll.setValue(true);
	}
	
	obj.VC_VolumeQuery = function(MrTypeID,MrNo){
		//��ѯ��ӡ������
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
			ExtTool.alert('����', '��ѯQuery����!');
			return false;
		}
		
		var jsonData = new Ext.decode(conn.responseText);
		if (jsonData.total < 1){
			ExtTool.alert('����', '����Ч������!');
			return false;
		} else {
			for (var row = 0; row < jsonData.record.length; row++){
				var record = jsonData.record[row];
				record.IsChecked = '1';
				jsonData.record[row] = record;
			}
			obj.VC_GridVolumeCopy.getStore().loadData(jsonData);
			return true;
		}
	}
	
	obj.VC_chkSelectAllClickFlag = 1;
	obj.VC_chkSelectAll_check = function(){
		if (obj.VC_chkSelectAllClickFlag != 1) return;
		var objStore = obj.VC_GridVolumeCopy.getStore();
		if (objStore.getCount() < 1){
			return;
		}
		
		var isCheck = obj.VC_chkSelectAll.getValue();
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			record.set('IsChecked', isCheck);
			obj.VC_GridVolumeCopy.getStore().commitChanges();
			obj.VC_GridVolumeCopy.getView().refresh();
		}
	}
	
	obj.VC_GridVolumeCopy_cellclick = function(grid, rowIndex, columnIndex, e){
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
		
		obj.VC_chkSelectAllClickFlag = 0;
		if (isSelectAll == '0'){
			obj.VC_chkSelectAll.setValue(false);
		} else {
			obj.VC_chkSelectAll.setValue(true);
		}
		obj.VC_chkSelectAllClickFlag = 1;
	}
	
	obj.VC_btnSave_click = function()
	{
		var MainID = '';
		var VolumeIDs = '';
		var objStore = obj.VC_GridVolumeCopy.getStore();
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			if (record.get('IsChecked') == '1'){
				MainID = record.get('MainID');
				VolumeIDs += ',' + record.get('VolID');
			}
		}
		if (VolumeIDs != '') VolumeIDs = VolumeIDs.substr(1,VolumeIDs.length-1);
		if (VolumeIDs == ''){
			ExtTool.alert("��ʾ", "��ѡ�񲡰����ٸ�ӡ!");
			return;
		}
		
		var Error = "";
		var User   = session['LOGON.USERID'];
		var Loc	   = session['LOGON.CTLOCID'];
		var GroupID= session['LOGON.GROUPID'];
		var HospID = session['LOGON.HOSPID'];
		var MrType			= Common_GetValue('VC_cboMrType');
		var ClientName     	= Common_GetValue('VC_ClientName');
		var ClientRelation  = Common_GetValue('VC_cboClientRelation');
		var CardType     	= Common_GetValue('VC_cboCardType');
		var PersonalID      = Common_GetValue('VC_txtPersonalID');
		var Telephone    	= Common_GetValue('VC_txtTelephone');
		var Address    		= Common_GetValue('VC_txtAddress');
		var Purpose     	= Common_GetValue('VC_cbgPurpose');
		var Content 		= Common_GetValue('VC_cbgContent');
		var CopyResume  	= Common_GetValue('VC_txtResume');
		var PaperNumber  	= Common_GetValue('VC_txtPaperNumber');
		if (Purpose != "") Purpose = Purpose.replace(/,/g,'#');
		if (Content != "") Content = Content.replace(/,/g,'#');
		if (ClientName=="") Error=Error+"ί���ˡ�";
		if (ClientRelation=="") Error=Error+"�뻼�߹�ϵ��";
		if (CardType=="") Error=Error+"֤�����ϡ�";
		if (PersonalID=="") Error=Error+"֤�����롢";
		if (Telephone=="") Error=Error+"��ϵ�绰��";
		if (Purpose=="") Error=Error+"��ӡĿ�ġ�";
		if (PaperNumber=="") Error=Error+"��ӡ������";
	    if (Error!=""){
	    	ExtTool.alert("��ʾ",Error+"Ϊ�գ�");
	    	return;
	    }
	    var CopyInfo = '';									//�Ǽ�ID
	    	CopyInfo += '^' + MainID;						//��������ID
			CopyInfo += '^' + VolumeIDs;					//�������ID�б�
			CopyInfo += '^' + ClientName;					//ί��������
			CopyInfo += '^' + ClientRelation;				//ί�����뻼�߹�ϵ
			CopyInfo += '^' + CardType;						//ί����֤������
			CopyInfo += '^' + PersonalID;					//ί�������֤��
			CopyInfo += '^' + Telephone;					//ί������ϵ�绰
			CopyInfo += '^' + Address;						//ί������ϵ��ַ
			CopyInfo += '^' + Content;						//��ӡ����
			CopyInfo += '^' + Purpose;						//��ӡĿ��
			CopyInfo += '^' + CopyResume;					//��ӡ��ע
			CopyInfo += '^' + PaperNumber;					//��ӡ����
		
		var PayModeID = 1;
		var FeeInfo =PayModeID;								//֧����ʽ
			FeeInfo += '^'+User;							//����Ա
			FeeInfo += '^'+Loc;								//��½����
			FeeInfo += '^'+GroupID;							//��½��ȫ��
			FeeInfo += '^'+HospID;							//��½ҽԺ					
		
		var ret = ExtTool.RunServerMethod("DHCWMR.MOService.CopyRecordSrv","CopyOper01","CH",CopyInfo,FeeInfo,"^");
		if (parseInt(ret) <= 0) {
			ExtTool.alert("������ʾ","����ʧ��!"+ret);
			return;
		}else{
			//TODO ��ӡ�Ǽ�С��������
			PrintBarCode(parseInt(ret));
			PrintSerialNumber(parseInt(ret));
			obj.VC_WinVolumeCopy.close();
			objScreen.txtMrNo.focus(true);
			Common_SetValue('txtMrNo','');
			Common_LoadCurrPage('gridCopy',1);
		}
	}
}