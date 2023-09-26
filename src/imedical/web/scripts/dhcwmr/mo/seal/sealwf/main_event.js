function InitViewportEvents(obj)
{
	obj.LoadEvents = function()
	{
		obj.cboHospital.on("select",obj.cboHospital_select,obj);
		obj.cboMrType.on("select",obj.cboMrType_click,obj);
		obj.cboQryType.on("select",obj.cboQryType_click,obj);
		obj.btnQuery.on("click",obj.btnQuery_click,obj);
		obj.btnSeal.on("click",obj.btnSeal_click,obj);
		obj.btnFree.on("click",obj.btnFree_click,obj);
		obj.gridSealRecord.on("rowdblclick",obj.gridSealRecord_rowdblclick,obj);
		obj.gridSealRecord.on("rowclick",obj.gridSealRecord_rowclick,obj);
		obj.txtMrNo.on('specialkey',obj.txtMrNo_specialkey,obj);
		obj.cboHospital.setValue(CTHospID);
		obj.cboHospital.setRawValue(CTHospDesc);
		obj.cboHospital_select();
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
	
	obj.cboMrType_click = function()
	{
		obj.gridSealRecord.getStore().removeAll();
	}
	obj.cboQryType_click = function()
	{
		obj.gridSealRecord.getStore().removeAll();
	}
	obj.btnQuery_click = function()
	{
		Common_SetValue("txtMrNo","");
		var QryType=Common_GetValue("cboQryType");
		if (QryType=='S') {
			Common_SetValue('msggridSealRecord','封存列表');
			Common_SetDisabled("btnSeal",true);
			Common_SetDisabled("btnbtnFree",false);
		} else if (QryType=='F') {
			Common_SetValue('msggridSealRecord','解封列表');
			Common_SetDisabled("btnSeal",false);
			Common_SetDisabled("btnbtnFree",true);
		} else {}
		
		obj.gridSealRecordStore.removeAll();
		obj.gridSealRecordStore.load({});
	}
	
	obj.btnSeal_click = function()
	{
	}
	
	obj.btnFree_click = function()
	{
		var RecordIDS="";
		var objStore = obj.gridSealRecord.getStore();
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			if (record.get('IsChecked') != '1') continue;	
			var Status = record.get('Status');
			if (Status != "S") continue;
			var RecordID = record.get('RecordID');
			RecordIDS = RecordIDS + "," + RecordID;
		}
		if (RecordIDS != '') RecordIDS = RecordIDS.substr(1,RecordIDS.length - 1);
		if (RecordIDS==''){
			ExtTool.alert("提示",'无封存病案列表!');
			return;
		}
		var MrTypeID = Common_GetValue("cboMrType");
		if (!MrTypeID){
			ExtTool.alert("提示",'病案类型为空!');
			return;
		}
		var objWFItem = ExtTool.RunServerMethod('DHCWMR.SS.WorkFItem','GetWFItemBySysOpera',MrTypeID,"SF");
		if (!objWFItem){
			ExtTool.alert("提示",'无解封操作项目!');
			return;
		}
		
		var objInput = new Object();
		objInput.OperType = 'F';
		objInput.ToUserID = '';
		objInput.MrInfo = '';
		objInput.SealInfo = RecordIDS;

		//是否用户校验
		if (objWFItem.WFICheckUser == 1){
			var win = new CU_InitCheckUser(objInput);
			win.WinCheckUser.show();
		} else {
			obj.SaveData(objInput);
		}
	}
	
	obj.gridSealRecord_rowclick = function(grid,rowIndex,e){
		var objStore = grid.getStore();
		var record = objStore.getAt(rowIndex);
		var StatusCode = record.get('StatusCode')
		if (StatusCode!="U"){
			if (record.get('IsChecked') != '1'){
				record.set('IsChecked', '1');
			} else {
				record.set('IsChecked', '0');
			}
		}
	}
	
	obj.gridSealRecord_rowdblclick = function()
	{
		var selectObj = obj.gridSealRecord.getSelectionModel().getSelected();
		var RecordID = selectObj.get("RecordID");
		Ext.MessageBox.confirm("系统提示", "是否取消当前操作？", function(but) {
			if (but=="yes"){
				var objInput = new Object();
				objInput.OperType = 'U';
				objInput.ToUserID = '';
				objInput.MrInfo = '';
				objInput.SealInfo = RecordID;
				obj.SaveData(objInput);
			}
        });
	}
	
	obj.txtMrNo_specialkey = function(field,e){
		if (e.getKey() != Ext.EventObject.ENTER) return;
		var HospID = Common_GetValue("cboHospital");
		var MrTypeID = Common_GetValue("cboMrType");
		var MrNo = Common_GetValue("txtMrNo");
		if (MrNo==''){
			ExtTool.alert("提示",'请输入病案号！');
			return;
		}
		var QryType = Common_GetValue("cboQryType");
		if (QryType == 'S') {  //封存
			obj.gridSealRecordStore.removeAll();
			obj.gridSealRecordStore.load({
				callback : function(r,option,success){
					if (success) {
						var win = new VS_InitVolumeSeal();
						var flg = win.VS_VolumeQuery(MrTypeID,MrNo);
						if (flg){
							win.VS_WinVolumeSeal.show();
							return;
						}
					}
				}
			});
		} else if (QryType == 'L') {  //解封
			
		}
		
		//Common_LoadCurrPage('gridSealRecord',1);
		//Common_SetValue("txtMrNo","");
	}
	
	obj.SaveData = function(objInput)
	{
		var FromUserID  = session['LOGON.USERID'];
		var OperType = objInput.OperType;
		var ToUserID = objInput.ToUserID;
		var MrInfo = objInput.MrInfo;
		var SealInfo = objInput.SealInfo;
		var ret = ExtTool.RunServerMethod('DHCWMR.MOService.SealRecordSrv','SealOper',OperType,FromUserID,ToUserID,MrInfo,SealInfo);
		if (parseInt(ret) < 1){
			ExtTool.alert("错误","保存封存记录失败!");
		} else {
			obj.btnQuery_click();
		}
	}
}