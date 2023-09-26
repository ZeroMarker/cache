function InitViewportEvents(obj){
	obj.LoadEvents = function(){
		obj.btnQuery.on('click',obj.btnQuery_click,obj);
		obj.cboHospital.on("select",obj.cboHospital_select,obj);
		obj.txtMrNo.on('specialkey',obj.txtMrNo_specialkey,obj);
		obj.btnRegedit.on('click',obj.btnRegedit_click,obj);
		obj.chkBatch.on('check',obj.chkBatch_check,obj);
		obj.gridCopy.on('rowdblclick',obj.gridCopy_rowdblclick,obj);
		obj.cboHospital.setValue(CTHospID);
		obj.cboHospital.setRawValue(CTHospDesc);
		obj.cboHospital_select();
		obj.txtMrNo.focus(true);
	}
	
	obj.gridCopy_rowdblclick = function(){
		var selectObj = obj.gridCopy.getSelectionModel().getSelected();
		var RecordID = selectObj.get("CopyRecordID");
		var win = new VC_InitVolumeCopy();
		var flg = win.VC_VolumeQuery('','',RecordID);
		if (flg){
			win.VC_WinVolumeCopy.show();
			return;
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
	
	obj.txtMrNo_specialkey = function(field,e){
		if (e.getKey() != Ext.EventObject.ENTER) return;
		var MrTypeID = Common_GetValue('cboMrType');
		var MrNo = Common_GetValue('txtMrNo');
		if (MrNo==''){
			ExtTool.alert("提示",'请输入病案号！');
			return;
		}
		var checkBatch = obj.chkBatch.getValue();
		if (!checkBatch) {
			//单个病案复印
			var win = new VC_InitVolumeCopy();
				var flg = win.VC_VolumeQuery(MrTypeID,MrNo,'');
				if (flg){
					win.VC_WinVolumeCopy.show();
					return;
				}
			}else{
				Common_SetValue('msggridCopy','复印登记记录');
				
				//批量病案复印 选择病案卷
				//如果列表里有查询结果显示，在根据输入病案号查找病案卷前清除结果
				if (obj.QueryFlag==1) {  
					obj.gridCopy.getStore().removeAll();
					obj.QueryFlag=0;
				}
				var win = new BVC_InitVolumeCopy();
			var flg = win.BVC_VolumeQuery(MrTypeID,MrNo);
			if(flg){
				win.BVC_WinVolumeCopy.show();
				return;
			}
		}
	}
	
	obj.btnQuery_click = function(){
		Common_SetValue("txtMrNo",'');  //清空病案号
		Common_SetValue('msggridCopy','复印登记查询列表');
		Common_LoadCurrPage('gridCopy',1);
		obj.QueryFlag = 1; //标记 查询 
	}
	
	obj.chkBatch_check = function(){
		var value = obj.chkBatch.getValue();
		if (value) {
			obj.btnRegedit.show();			
		}else{
			obj.btnRegedit.hide();
			obj.gridCopy.getStore().removeAll();
		}
	}
	
	obj.btnRegedit_click = function(){
		/*var VolIDs = "",MainID="";
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
		*/
		
		var Records="",count=0
		var objStore = obj.gridCopy.getStore();
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			if (record.get('IsChecked') != '1') continue;
			var VolIDs = record.get('VolumeID');
			var	MainID = record.get('MainID');
			if(Records==""){
				Records=MainID+'^'+VolIDs;
			}else{
				Records=Records+'|'+MainID+'^'+VolIDs;
			}
			count++;
		}
		if (count==0){
			window.alert("没有需要复印的就诊记录！");
			return;
		}
		
		var win= new BC_InitCopyInfo(Records);
		win.BC_WinCopy.show();
	}
	
	obj.GetOperaList = function(){
		var OperaList = "";
		if (tDHCWMRMenuOper){
			for(var code in tDHCWMRMenuOper) {
				var hasPower = tDHCWMRMenuOper[code];
				if(hasPower == 0)
					continue;
				if(OperaList != "")
					OperaList += "#";
				OperaList += code;
			}
		}
		return OperaList;
	}
}