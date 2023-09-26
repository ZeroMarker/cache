function InitviewScreenEvents(obj){
	obj.LoadEvents = function(){
		obj.btnCurrentStatus.on('click',obj.btnCurrentStatus_click,obj);
		obj.btnHistoryStatus.on('click',obj.btnHistoryStatus_click,obj);
		obj.btnControlStatus.on('click',obj.btnControlStatus_click,obj);
		obj.btnUnProcess.on('click',obj.btnUnProcess_click,obj);
		obj.btnExport.on('click',obj.btnExport_click,obj);
		obj.RowExpander.on("expand",obj.RowExpander_expand,obj);
		
		//obj.dfDateFrom.setValue('');
		//obj.dfDateTo.setValue('');
		
		obj.cboLocGroup.on("select",obj.cboLocGroup_select,obj);
		obj.cboHospital.on("select",obj.cboHospital_select,obj);
		obj.cboMrType.on("select",obj.cboMrType_select,obj);
		obj.cboHospital.setValue(CTHospID);
		obj.cboHospital.setRawValue(CTHospDesc);
		obj.cboHospital_select();
		obj.cboWFItem.on("select",obj.cboWFItem_select,obj);
		if (IsSecret!=1) {     //不涉密就隐藏【病人密级】和【病人级别】两列
			var cm = obj.VolStatusList.getColumnModel();
	    		var cfg = null;
			for(var i=0;i<cm.config.length;++i)
	 		{
	   	 		cfg = cm.config[i];
	   	 		if ((cfg.id=="Secret1")||(cfg.id=="Secret2")) {
					cm.setHidden(i,true);
	   	 		}
			}
		}
		if (MrClass=="O")
		{
			var cm = obj.VolStatusList.getColumnModel();
	    		var cfg = null;
			for(var i=0;i<cm.config.length;++i)
	 		{
	   	 		cfg = cm.config[i];
	   	 		if ((cfg.id=="BackDate")||(cfg.id=="DischDate")||(cfg.id=="ChiefProfessor")||(cfg.id=="Professor")||(cfg.id=="VistingDoctor")||(cfg.id=="AdmWardDesc")) {
					cm.setHidden(i,true);
	   	 		}
			}
		}
	}
	
	obj.RowExpander_expand = function(){	
		var objRec = arguments[1];
		var VolumeID = objRec.get("VolID");
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCWMR.SSService.VolStatusQry',
				QueryName : 'QryStatusList',
				Arg1 : VolumeID,
				ArgCnt : 1
			},
			success: function(response, opts) {
				var objData = Ext.decode(response.responseText);
				var arryData = new Array();
				var objItem = null;
				for(var i = 0; i < objData.total; i ++)
				{
					objItem = objData.record[i];
					arryData[arryData.length] = objItem;
				}
				var objRowExpander = new Object();
				objRowExpander.Record = new Array();
				objRowExpander.Record = arryData;
				obj.RowTemplate.overwrite("divStatusList-" + VolumeID, objRowExpander);
			},
			failure: function(response, opts) {
				var objTargetElement = document.getElementById("divStatusList-" + VolumeID);
				if (objTargetElement) {
					objTargetElement.innerHTML = response.responseText;
				}
			}
		});
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
		//加载科室组
		obj.cboLocGroup.getStore().removeAll();
		obj.cboLocGroup.getStore().load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0){
						obj.cboLocGroup.setValue(r[0].get("GroupID"));
						obj.cboLocGroup.setRawValue(r[0].get("GroupDesc"));
					}
				}
			}
		});
	}
	
	obj.cboLocGroup_select = function(combo,record,index){
		obj.cboLoc.setValue();
		obj.cboLoc.setRawValue();
		obj.cboLoc.getStore().removeAll();
		obj.cboLoc.getStore().load({});
	}
	
	obj.cboMrType_select = function(combo,record,index){
		//加载操作项目列表
		obj.cboWFItem.getStore().removeAll();
		obj.cboWFItem.getStore().load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0) {
						obj.cboWFItem_select();
					}
				}
			}
		});
	}
	
	// fix bug 6501 2015-01-22 by pylian 操作项目为归档上架时，【当前状态】置灰
	//update by niepeng 20150204 归档上架不允许当前状态查询
	obj.cboWFItem_select = function() {
		if (obj.cboWFItem.getRawValue("cboWFItem")=="归档上架"){
			Common_SetDisabled('btnCurrentStatus',true); 	
		}else{
			Common_SetDisabled('btnCurrentStatus',false);
		}
	}
	
	obj.btnCurrentStatus_click = function (){
		var WFItemID = Common_GetValue("cboWFItem");
		if (WFItemID==''){
			window.alert("请选择操作项目!");
			return;
		}
		/*
		Common_SetValue("dfDateFrom","");
		Common_SetValue("dfDateTo","");
		*/
		obj.QryFlag = 'C';
		Common_LoadCurrPage('VolStatusList',1);
		Common_SetValue('msgVolStatusList','当前状态查询结果');
	}
	obj.btnHistoryStatus_click = function (){
		var WFItemID = Common_GetValue("cboWFItem");
		if (WFItemID==''){
			window.alert("请选择操作项目!");
			return;
		}
		var DateFrom = Common_GetValue("dfDateFrom");
		var DateTo = Common_GetValue("dfDateTo");
		if ((DateFrom=='')||(DateTo=='')){
			window.alert("请选择开始日期、截止日期！");
			return;
		}
		obj.QryFlag = 'H';
		Common_LoadCurrPage('VolStatusList',1);
		Common_SetValue('msgVolStatusList','历史操作查询结果');
	}
	obj.btnControlStatus_click = function (){
		obj.QryFlag = 'E';
		Common_LoadCurrPage('VolStatusList',1);
		Common_SetValue('msgVolStatusList','问题病历查询结果');
	}
	obj.btnUnProcess_click = function (){
		var WFItemID = Common_GetValue("cboWFItem");
		if (WFItemID==''){
			window.alert("请选择操作项目!");
			return;
		}
		obj.QryFlag = 'U';
		Common_LoadCurrPage('VolStatusList',1);
		Common_SetValue('msgVolStatusList','未处理病历查询结果');
	}
	obj.btnExport_click = function (){
		if (obj.VolStatusListStore.getCount()<1) {
			window.alert("请先查询再导出Excel！");
			return;
		}
		if (obj.QryFlag=="C"){
			ExportGridByCls(obj.VolStatusList,'当前状态查询结果');
		}
		if (obj.QryFlag=="H"){
			ExportGridByCls(obj.VolStatusList,'历史操作查询结果');
		}
		if (obj.QryFlag=="E"){
			ExportGridByCls(obj.VolStatusList,'问题病历查询结果');
		}
		if (obj.QryFlag=="U"){
			ExportGridByCls(obj.VolStatusList,'未处理病历查询结果');
		}
	}
	
	obj.LnkVolStatusWin = function(aVolumeID){
		var sURL="dhcwmr.wf.revisestatus.csp?1=1&VolumeID=" + aVolumeID + "&2=2";
		var vArguments = '';
		var sFeatures = "dialogWidth=" + window.screen.availWidth + "px;dialogHeight=" + window.screen.availHeight + "px;resizable=no;"
		window.showModalDialog(sURL,vArguments,sFeatures);
		Common_LoadCurrPage('MrReviewGrid');
		//var oWin = window.open(sURL,'',"height=" + window.screen.availHeight + ",width=" + window.screen.availWidth + ",top=0,left=0,resizable=no");
	}
}
