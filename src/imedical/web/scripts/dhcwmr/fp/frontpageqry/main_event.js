function InitviewScreenEvents(obj){
	obj.LoadEvents = function(){
		obj.btnDisNotFP.on('click',obj.btnDisNotFP_click,obj);
		obj.btnDischQry.on('click',obj.btnDischQry_click,obj);
		obj.btnFPQry.on('click',obj.btnFPQry_click,obj);
		obj.btnCurrFPQry.on('click',obj.btnCurrFPQry_click,obj);
		obj.btnExport.on('click',obj.btnExport_click,obj);
		obj.txtMrNo.on('specialKey',obj.txtMrNo_specialKey,obj);
		obj.RowExpander.on("expand",obj.RowExpander_expand,obj);
		
		//obj.dfDateFrom.setValue('');
		//obj.dfDateTo.setValue('');
		
		obj.cboLocGroup.on("select",obj.cboLocGroup_select,obj);
		obj.cboHospital.on("select",obj.cboHospital_select,obj);
		obj.cboHospital.setValue(CTHospID);
		obj.cboHospital.setRawValue(CTHospDesc);
		obj.cboHospital_select();
		
		Ext.getCmp("txtMrNo").focus(false, 100);
		if (IsSecret!=1) {     //不涉密就隐藏【病人密级】和【病人级别】两列
			var cm = obj.gridFrontPage.getColumnModel();
	    		var cfg = null;
			for(var i=0;i<cm.config.length;++i)
	 		{
	   	 		cfg = cm.config[i];
	   	 		if ((cfg.id=="Secret1")||(cfg.id=="Secret2")) {
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
	
	obj.txtMrNo_specialKey = function(field, e) {
		if (e.getKey() != Ext.EventObject.ENTER) return;
		Common_GetValue("dfDateFrom",'');
		Common_GetValue("dfDateTo",'');
		Common_GetValue("cboLoc",'','');
		
		var HospitalID = Common_GetValue("cboHospital");
		if (HospitalID == '') {
			window.alert("请选择院区!");
			return;
		}
		var MrTypeID = Common_GetValue("cboMrType");
		if (MrTypeID == '') {
			window.alert("请选中病案类型!");
			return;
		}
		var MrNo = Common_GetValue("txtMrNo");
		if (MrNo == '') {
			window.alert("请正确输入病案号!");
			return;
		}
		
		//病案卷查询
		var win = new VS_InitVolumeSelect();
		var flg = win.VS_VolumeQuery(HospitalID,MrTypeID,FPType,MrNo);
		if (flg){
			win.VS_WinVolumeSelect.show();
			return;
		}
		
		Common_SetValue("txtMrNo",'');  //清空病案号
		Ext.getCmp("txtMrNo").focus(false, 100);
	}
	
	obj.btnDisNotFP_click = function (){
		var DateFrom = Common_GetValue("dfDateFrom");
		var DateTo = Common_GetValue("dfDateTo");
		if ((DateFrom=='')||(DateTo=='')){
			window.alert("请选择开始日期、截止日期！");
			return;
		}
		obj.QryFlg = 1;
		obj.txtMrNo.setValue('');
		Common_LoadCurrPage('gridFrontPage',1);
		Common_SetValue('msgGridFrontPage','未编目查询结果');
	}
	
	obj.btnDischQry_click = function (){
		var DateFrom = Common_GetValue("dfDateFrom");
		var DateTo = Common_GetValue("dfDateTo");
		if ((DateFrom=='')||(DateTo=='')){
			window.alert("请选择开始日期、截止日期！");
			return;
		}
		obj.QryFlg = 2;
		obj.txtMrNo.setValue('');
		Common_LoadCurrPage('gridFrontPage',1);
		Common_SetValue('msgGridFrontPage','出院查询结果');
	}
	
	obj.btnFPQry_click = function (){
		var DateFrom = Common_GetValue("dfDateFrom");
		var DateTo = Common_GetValue("dfDateTo");
		if ((DateFrom=='')||(DateTo=='')){
			window.alert("请选择开始日期、截止日期！");
			return;
		}
		obj.QryFlg = 3;
		obj.txtMrNo.setValue('');
		Common_LoadCurrPage('gridFrontPage',1);
		Common_SetValue('msgGridFrontPage','编目查询结果');
	}
	
	obj.btnCurrFPQry_click = function (){
		Common_SetValue("dfDateFrom",'');
		Common_SetValue("dfDateTo",'');
		Common_SetValue("cboLoc",'','');
		Common_SetValue("txtMrNo",'');  //清空病案号
		
		obj.QryFlg = 4;
		Common_LoadCurrPage('gridFrontPage',1);
		Common_SetValue('msgGridFrontPage','当日查询结果');
	}
	
	obj.btnExport_click = function (){
		if (obj.gridFrontPageStore.getCount()<1) {
			window.alert("请先查询再导出Excel！");
			return;
		}
		ExportGridByCls(obj.gridFrontPage,'编目病案查询');
	}
	
	obj.ViewFrontPageEdit = function(aFrontPageID,aVolumeID){
		if ((!aFrontPageID)&&(!aVolumeID)){
			window.alert("编目参数错误!");
			return;
		}
		
		if ((!aFrontPageID)&&(aVolumeID!='')){
			var ret = ExtTool.RunServerMethod("DHCWMR.FPService.FrontPageSrv","CheckOperation",aVolumeID,FPType);
			if (parseInt(ret) <= 0) {
				window.alert("当前病历不允许病案编目操作!");
				return;
			}
		}
		
		var sURL="dhcwmr.fp.frontpageedit.csp?1=1&FrontPageID=" + aFrontPageID + "&VolumeID=" + aVolumeID + "&FPType=" + FPType + "&IsPathologEdit=0" + "&EditFlag=1&2=2";
		var vArguments = '';
		var sFeatures = "dialogWidth=" + window.screen.availWidth + "px;dialogHeight=" + window.screen.availHeight + "px;resizable=no;"
		if (!!window.ActiveXObject || "ActiveXObject" in window){
			window.showModalDialog(sURL,vArguments,sFeatures);
		}else{
			var sFeatures = "width=" + window.screen.availWidth + "px;height=" + window.screen.availHeight + "px;resizable=no;"	
			//window.open(sURL,vArguments,sFeatures);
			websys_createWindow(sURL,"编目",sFeatures);
		}
		Common_LoadCurrPage('gridFrontPage');
		Common_SetValue("txtMrNo",'');  //清空病案号
		//var oWin = window.open(sURL,'',"height=" + window.screen.availHeight + ",width=" + window.screen.availWidth + ",top=0,left=0,resizable=no");
	}
}
