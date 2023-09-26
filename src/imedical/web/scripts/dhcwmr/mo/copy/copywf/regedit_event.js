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
		//查询复印病案卷
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
			ExtTool.alert("提示", "请选择病案卷再复印!");
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
		if (ClientName=="") Error=Error+"委托人、";
		if (ClientRelation=="") Error=Error+"与患者关系、";
		if (CardType=="") Error=Error+"证明材料、";
		if (PersonalID=="") Error=Error+"证件号码、";
		if (Telephone=="") Error=Error+"联系电话、";
		if (Purpose=="") Error=Error+"复印目的、";
		if (PaperNumber=="") Error=Error+"复印张数、";
	    if (Error!=""){
	    	ExtTool.alert("提示",Error+"为空！");
	    	return;
	    }
	    var CopyInfo = '';									//登记ID
	    	CopyInfo += '^' + MainID;						//病案主表ID
			CopyInfo += '^' + VolumeIDs;					//病案卷表ID列表
			CopyInfo += '^' + ClientName;					//委托人姓名
			CopyInfo += '^' + ClientRelation;				//委托人与患者关系
			CopyInfo += '^' + CardType;						//委托人证明材料
			CopyInfo += '^' + PersonalID;					//委托人身份证号
			CopyInfo += '^' + Telephone;					//委托人联系电话
			CopyInfo += '^' + Address;						//委托人联系地址
			CopyInfo += '^' + Content;						//复印内容
			CopyInfo += '^' + Purpose;						//复印目的
			CopyInfo += '^' + CopyResume;					//复印备注
			CopyInfo += '^' + PaperNumber;					//复印张数
		
		var PayModeID = 1;
		var FeeInfo =PayModeID;								//支付方式
			FeeInfo += '^'+User;							//操作员
			FeeInfo += '^'+Loc;								//登陆科室
			FeeInfo += '^'+GroupID;							//登陆安全组
			FeeInfo += '^'+HospID;							//登陆医院					
		
		var ret = ExtTool.RunServerMethod("DHCWMR.MOService.CopyRecordSrv","CopyOper01","CH",CopyInfo,FeeInfo,"^");
		if (parseInt(ret) <= 0) {
			ExtTool.alert("错误提示","保存失败!"+ret);
			return;
		}else{
			//TODO 打印登记小条、条码
			PrintBarCode(parseInt(ret));
			PrintSerialNumber(parseInt(ret));
			obj.VC_WinVolumeCopy.close();
			objScreen.txtMrNo.focus(true);
			Common_SetValue('txtMrNo','');
			Common_LoadCurrPage('gridCopy',1);
		}
	}
}