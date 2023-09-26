function InitViewportEvents(obj)
{
	obj.LoadEvents = function()
	{
		obj.btnQuery.on('click',obj.btnQuery_click,obj);
		obj.cboHospital.on("select",obj.cboHospital_select,obj);
		obj.txtMrNo.on('specialkey',obj.btnQuery_specialkey,obj);
		obj.cboHospital.setValue(CTHospID);
		obj.cboHospital.setRawValue(CTHospDesc);
		obj.cboHospital_select();
		obj.txtMrNo.focus(true);
		if (CopyFeeType==0){	//���շѲ���ʾ���
			var cm = obj.gridCopy.getColumnModel();
	    	var cfg = null;
			for(var i=0;i<cm.config.length;++i)
	 		{
	   	 		cfg = cm.config[i];
	   	 		if (cfg.id=="Money") {
					cm.setHidden(i,true);
	   	 		}
			}
		}
		if (IsRecordRoomPrintBill==0){ //�����Ҳ���Ʊ����ʾ��Ʊ��
			var cm = obj.gridCopy.getColumnModel();
	    	var cfg = null;
			for(var i=0;i<cm.config.length;++i)
	 		{
	   	 		cfg = cm.config[i];
	   	 		if (cfg.id=="InvNo") {
					cm.setHidden(i,true);
	   	 		}
			}
		}
		
	}
	
	obj.cboHospital_select = function(combo,record,index){
		//���ز�������
		obj.cboMrType.getStore().removeAll();
		obj.cboMrType.getStore().load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0) {
						obj.cboMrType.setValue(r[0].get("MrTypeID"));
						obj.cboMrType.setRawValue(r[0].get("MrTypeDesc"));
					}
				}
			}
		});
	}

	obj.btnQuery_specialkey = function(field,e)
	{
		if (e.getKey() != Ext.EventObject.ENTER) return;
		var MrTypeID = Common_GetValue('cboMrType');
		var MrNo = Common_GetValue('txtMrNo');
		if (MrNo==''){
			ExtTool.alert("��ʾ",'�����벡���ţ�');
			return;
		}
		var win = new VC_InitVolumeCopy();
		var flg = win.VC_VolumeQuery(MrTypeID,MrNo);
		if (flg){
			win.VC_WinVolumeCopy.show();
			return;
		}
	}
	
	obj.btnQuery_click = function()
	{
		Common_LoadCurrPage('gridCopy',1);
	}

	obj.btnRegedit_click = function()
	{
		var VolIDs = "",MainID="";
		var objStore = obj.VolList.getStore();
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			if (record.get('IsChecked') == '1'){
				VolIDs += ',' + record.get('VolID');
				MainID = record.get('MainID');
			}
		}
		if (VolIDs==""){
			window.alert("��ѡ����Ҫ��ӡ�ľ����¼��");
			return;
		}
		VolIDs = VolIDs.replace(/,/g,'#');
		var RegeditWindow= new InitRegeditViewport(MainID,VolIDs);
		RegeditWindow.RegeditViewport.show();
	}
	
	obj.cancel = function(RecordID)
	{
		var User   = session['LOGON.USERID'];
		var Loc	   = session['LOGON.CTLOCID'];
		var GroupID= session['LOGON.GROUPID'];
		var HospID = Common_GetValue('cboHospital');
		var CopyInfo = RecordID;						//�Ǽ�ID

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
			Common_LoadCurrPage('gridCopy',1);
		}
	}
	
	obj.RetFee = function(CopyRecordID)
	{
		var User   = session['LOGON.USERID'];
		var Loc	   = session['LOGON.CTLOCID'];
		var GroupID= session['LOGON.GROUPID'];
		var HospID = Common_GetValue('cboHospital');
		
		var CopyInfo = CopyRecordID;						//�Ǽ�ID
		var PayModeID = 1;
		var FeeInfo =PayModeID;								//֧����ʽ
			FeeInfo += '^'+User;							//����Ա
			FeeInfo += '^'+Loc;								//��½����
			FeeInfo += '^'+GroupID;							//��½��ȫ��
			FeeInfo += '^'+HospID;							//��½ҽԺ

		var ret = ExtTool.RunServerMethod("DHCWMR.MOService.CopyRecordSrv","CopyOper","RF",CopyInfo,FeeInfo,"^");
		if (parseInt(ret) <= 0) {
			ExtTool.alert("������ʾ","�˷�ʧ��!");
			return;
		}else{
			Common_LoadCurrPage('gridCopy',1);
		}
	}

}