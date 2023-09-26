function InitviewScreenEvents(obj){
	obj.LoadEvents = function(){
		obj.btnNoReview.on('click',obj.btnNoReview_click,obj);
		obj.btnReview.on('click',obj.btnReview_click,obj);
		obj.btnExport.on('click',obj.btnExport_click,obj);
		
		obj.dfDateFrom.setValue('');
		obj.dfDateTo.setValue('');
		
		obj.cboLocGroup.on("select",obj.cboLocGroup_select,obj);
		obj.cboHospital.on("select",obj.cboHospital_select,obj);
		obj.cboHospital.setValue(CTHospID);
		obj.cboHospital.setRawValue(CTHospDesc);
		obj.cboHospital_select();
		
		if (IsSecret!=1) {     //不涉密就隐藏【病人密级】和【病人级别】两列
			var cm = obj.MrReviewGrid.getColumnModel();
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
	
	obj.btnNoReview_click = function (){
		obj.QryFlag = 0;
		Common_LoadCurrPage('MrReviewGrid',1);
		Common_SetValue('msgMrReviewGrid','未复核病历查询结果');
	}
	
	obj.btnReview_click = function (){
		var DateFrom = Common_GetValue("dfDateFrom");
		var DateTo = Common_GetValue("dfDateTo");
		if ((DateFrom=='')||(DateTo=='')){
			window.alert("请选择开始日期、截止日期！");
			return;
		}
		
		obj.QryFlag = 1;
		Common_LoadCurrPage('MrReviewGrid',1);
		Common_SetValue('msgMrReviewGrid','复核病历查询结果');
	}
	
	obj.btnExport_click = function (){
		if (obj.MrReviewGridStore.getCount()<1) {
			window.alert("请先查询再导出Excel！");
			return;
		}
		ExportGridByCls(obj.MrReviewGrid,'病历复核');
	}
	
	obj.LnkReviewWin = function(aVolumeID,aEpisodeID,ReviewFlag){
		if (ReviewFlag!="Y") {
			window.alert("临床医生病历归档尚未完成，不能做复核操作！");
			return;
		}
		//update by zf 20151210 替换病历复核页面
		var sURL="dhcwmr.wf.reviewpage.csp?1=1&VolumeID=" + aVolumeID + "&2=2";
		//var sURL="dhc.epr.fs.checkallinonewmr.csp?1=1&EpisodeID=" + aEpisodeID + "&2=2";
		var vArguments = '';
		var sFeatures = "dialogWidth=" + window.screen.availWidth + "px;dialogHeight=" + window.screen.availHeight + "px;resizable=no;"
		if (!!window.ActiveXObject || "ActiveXObject" in window){
			window.showModalDialog(sURL,vArguments,sFeatures);
		}else{
			var sFeatures = "width=" + window.screen.availWidth + "px;height=" + window.screen.availHeight + "px;resizable=no;"		
			websys_createWindow(sURL,"复核",sFeatures);
		}
		Common_LoadCurrPage('MrReviewGrid'); //项目数据较多时关闭"三单一致"弹出窗口后刷新列表速度较慢，影响复核操作
		//var oWin = window.open(sURL,'',"height=" + window.screen.availHeight + ",width=" + window.screen.availWidth + ",top=0,left=0,resizable=no");
	}
	
	obj.LnkVolStatusWin = function(aVolumeID){
		var sURL="dhcwmr.wf.revisestatus.csp?1=1&VolumeID=" + aVolumeID + "&2=2";
		var vArguments = '';
		var sFeatures = "dialogWidth=" + window.screen.availWidth + "px;dialogHeight=" + window.screen.availHeight + "px;resizable=no;"
		if (!!window.ActiveXObject || "ActiveXObject" in window){
			window.showModalDialog(sURL,vArguments,sFeatures);	
		}else{
			var sFeatures = "width=" + window.screen.availWidth + "px;height=" + window.screen.availHeight + "px;resizable=no;"	
			//window.open(sURL,vArguments,sFeatures);	
			websys_createWindow(sURL,"当前状态",sFeatures);
		}
		
		Common_LoadCurrPage('MrReviewGrid');
		//var oWin = window.open(sURL,'',"height=" + window.screen.availHeight + ",width=" + window.screen.availWidth + ",top=0,left=0,resizable=no");
	}
}
