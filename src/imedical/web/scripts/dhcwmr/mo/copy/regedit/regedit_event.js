function VC_InitVolumeCopyEvents(obj){
	obj.VC_LoadEvents = function(){
		obj.VC_btnSave.on('click',obj.VC_btnSave_click,obj);
		obj.VC_btnCancel.on('click',obj.VC_btnCancel_click,obj);
		obj.VC_GridVolumeCopy.on("cellclick",obj.VC_GridVolumeCopy_cellclick,obj);
		obj.VC_chkSelectAll.on("check",obj.VC_chkSelectAll_check,obj);
		obj.VC_chkSelectAll.setValue(true);
	}
	
	obj.VC_VolumeQuery = function(MrTypeID,MrNo,RecordID){
		//ȡ��ӡ�ǼǼ�¼��Ϣ
		var sCopyInfo = ExtTool.RunServerMethod("DHCWMR.MOService.CopyRecordSrv","GetCopyInfo",RecordID);
		if (sCopyInfo){
			var arrCopyInfo = sCopyInfo.split('^');
			obj.VC_Input.RecordID = arrCopyInfo[0];
			obj.VC_Input.MrTypeID = arrCopyInfo[1];
			obj.VC_Input.MrNo = arrCopyInfo[2];
			obj.VC_Input.VolumeIDs = arrCopyInfo[3];
			obj.VC_Input.StatusCode = arrCopyInfo[4];
			obj.VC_Input.ClientName = arrCopyInfo[5];
			obj.VC_Input.RelationID = arrCopyInfo[6];
			obj.VC_Input.RelationDesc = arrCopyInfo[7];
			obj.VC_Input.CardTypeID = arrCopyInfo[8];
			obj.VC_Input.CardTypeDesc = arrCopyInfo[9];
			obj.VC_Input.PersonalID = arrCopyInfo[10];
			obj.VC_Input.Telephone = arrCopyInfo[11];
			obj.VC_Input.Address = arrCopyInfo[12];
			obj.VC_Input.PurposeIDs = arrCopyInfo[13];
			obj.VC_Input.PurposeDescs = arrCopyInfo[14];
			obj.VC_Input.ContentIDs = arrCopyInfo[15];
			obj.VC_Input.ContentDescs = arrCopyInfo[16];
			obj.VC_Input.Resume = arrCopyInfo[17];
			obj.VC_Input.PaperNumber = arrCopyInfo[18];
			obj.VC_Input.CopyMoney = arrCopyInfo[19];
		} else {
			obj.VC_Input.RecordID = '';
			obj.VC_Input.MrTypeID = MrTypeID;
			obj.VC_Input.MrNo = MrNo;
			obj.VC_Input.VolumeIDs = '';
			obj.VC_Input.StatusCode = 'RE';
			obj.VC_Input.ClientName = '';
			obj.VC_Input.RelationID = '';
			obj.VC_Input.RelationDesc = '';
			obj.VC_Input.CardTypeID = '';
			obj.VC_Input.CardTypeDesc = '';
			obj.VC_Input.PersonalID = '';
			obj.VC_Input.Telephone = '';
			obj.VC_Input.Address = '';
			obj.VC_Input.PurposeIDs = '';
			obj.VC_Input.PurposeDescs = '';
			obj.VC_Input.ContentIDs = '';
			obj.VC_Input.ContentDescs = '';
			obj.VC_Input.Resume = '';
			obj.VC_Input.PaperNumber = '';
			obj.VC_Input.CopyMoney = '';
		}
		
		//��ѯ��ӡ������
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCWMR.MOService.CopyRecordSrv'
		url += '&QueryName=' + 'QryCopyVolume'
		url += '&Arg1=' + obj.VC_Input.MrTypeID
		url += '&Arg2=' + obj.VC_Input.MrNo
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
				if (obj.VC_Input.RecordID != ''){
					var tVolumeIDs = ',' + obj.VC_Input.VolumeIDs + ','
					var tVolumeID = ',' + record.VolID + ','
					if (tVolumeIDs.indexOf(tVolumeID)>-1){
						record.IsChecked = '1';
					} else {
						record.IsChecked = '0';
					}
				} else {
					record.IsChecked = '1';
				}
				jsonData.record[row] = record;
			}
			obj.VC_GridVolumeCopy.getStore().loadData(jsonData);
			
			if (obj.VC_Input.RecordID != ''){
				Common_SetValue('VC_ClientName',obj.VC_Input.ClientName);
				Common_SetValue('VC_cboClientRelation',obj.VC_Input.RelationID,obj.VC_Input.RelationDesc);
				Common_SetValue('VC_cboCardType',obj.VC_Input.CardTypeID,obj.VC_Input.CardTypeDesc);
				Common_SetValue('VC_txtPersonalID',obj.VC_Input.PersonalID);
				Common_SetValue('VC_txtTelephone',obj.VC_Input.Telephone);
				Common_SetValue('VC_txtAddress',obj.VC_Input.Address);
				Common_SetValue('VC_cbgPurpose',obj.VC_Input.PurposeIDs);
				Common_SetValue('VC_cbgContent',obj.VC_Input.ContentIDs);
				Common_SetValue('VC_txtResume',obj.VC_Input.Resume);
			}
			
			//�Ǽǡ����ϲ�����ť�Ƿ���ʾ
			if (obj.VC_Input.StatusCode != 'RE'){
				Common_SetVisible('VC_btnSave',false);
				Common_SetVisible('VC_btnCancel',false);
			} else {
				Common_SetVisible('VC_btnSave',true);
				if (obj.VC_Input.RecordID == ''){
					Common_SetVisible('VC_btnCancel',false);
				} else {
					Common_SetVisible('VC_btnCancel',true);
				}
			}
			
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
	
	obj.VC_btnSave_click = function(){
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
			ExtTool.alert("��ʾ", "��ѡ�񲡰������!");
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
		if (Purpose != "") Purpose = Purpose.replace(/,/g,'#');
		if (Content != "") Content = Content.replace(/,/g,'#');
		//var OperaList = objScreen.GetOperaList();
		if (ClientName=="") Error=Error+"ί���ˡ�";
		if (ClientRelation=="") Error=Error+"�뻼�߹�ϵ��";
		if (CardType=="") Error=Error+"֤�����ϡ�";
		if (PersonalID=="") Error=Error+"֤�����롢";
		if (Telephone=="") Error=Error+"��ϵ�绰��";
		if (Purpose=="") Error=Error+"��ӡĿ�ġ�";
	    if (Error!=""){
	    	ExtTool.alert("��ʾ",Error+"Ϊ�գ�");
	    	return;
	    }
		
	    var CopyInfo = obj.VC_Input.RecordID;				//�Ǽ�ID
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
		
		var FeeInfo ="";									//֧����ʽ
			FeeInfo += '^'+User;							//����Ա
			FeeInfo += '^'+Loc;								//��½����
			FeeInfo += '^'+GroupID;							//��½��ȫ��
			FeeInfo += '^'+HospID;							//��½ҽԺ					
		
		var ret = ExtTool.RunServerMethod("DHCWMR.MOService.CopyRecordSrv","CopyOper","RE",CopyInfo,FeeInfo,"^");
		if (parseInt(ret) <= 0) {
			ExtTool.alert("������ʾ","����ʧ��!");
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
	
	obj.VC_btnCancel_click = function(){
	    var User   = session['LOGON.USERID'];
		var Loc	   = session['LOGON.CTLOCID'];
		var GroupID= session['LOGON.GROUPID'];
		var HospID = Common_GetValue('cboHospital');
		var CopyInfo = obj.VC_Input.RecordID;				//�Ǽ�ID
		
		var PayModeID = 1;
		var FeeInfo =PayModeID;								//֧����ʽ
			FeeInfo += '^'+User;							//����Ա
			FeeInfo += '^'+Loc;								//��½����
			FeeInfo += '^'+GroupID;							//��½��ȫ��
			FeeInfo += '^'+HospID;							//��½ҽԺ
		
		var ret = ExtTool.RunServerMethod("DHCWMR.MOService.CopyRecordSrv","CopyOper","U",CopyInfo,FeeInfo,"^");
		if (parseInt(ret) <= 0) {
			ExtTool.alert("������ʾ","����ʧ��!");
			return;
		}else{
			obj.VC_WinVolumeCopy.close();
			objScreen.txtMrNo.focus(true);
			Common_SetValue('txtMrNo','');
			Common_LoadCurrPage('gridCopy',1);
		}
	}
}