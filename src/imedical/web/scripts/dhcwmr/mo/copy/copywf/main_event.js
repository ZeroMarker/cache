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
		if (CopyFeeType==0){	//不收费不显示金额
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
		if (IsRecordRoomPrintBill==0){ //病案室不打发票不显示发票号
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
		//加载病案类型
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
			ExtTool.alert("提示",'请输入病案号！');
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
			window.alert("请选择需要复印的就诊记录！");
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
		var CopyInfo = RecordID;						//登记ID

		var PayModeID = 1;
		var FeeInfo =PayModeID;								//支付方式
			FeeInfo += '^'+User;							//操作员
			FeeInfo += '^'+Loc;								//登陆科室
			FeeInfo += '^'+GroupID;							//登陆安全组
			FeeInfo += '^'+HospID;							//登陆医院

		var ret = ExtTool.RunServerMethod("DHCWMR.MOService.CopyRecordSrv","CopyOper","U",CopyInfo,FeeInfo,"^");
		if (parseInt(ret) <= 0) {
			ExtTool.alert("错误提示","作废失败!");
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
		
		var CopyInfo = CopyRecordID;						//登记ID
		var PayModeID = 1;
		var FeeInfo =PayModeID;								//支付方式
			FeeInfo += '^'+User;							//操作员
			FeeInfo += '^'+Loc;								//登陆科室
			FeeInfo += '^'+GroupID;							//登陆安全组
			FeeInfo += '^'+HospID;							//登陆医院

		var ret = ExtTool.RunServerMethod("DHCWMR.MOService.CopyRecordSrv","CopyOper","RF",CopyInfo,FeeInfo,"^");
		if (parseInt(ret) <= 0) {
			ExtTool.alert("错误提示","退费失败!");
			return;
		}else{
			Common_LoadCurrPage('gridCopy',1);
		}
	}

}