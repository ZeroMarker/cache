function InitviewScreenEvents(obj){
	obj.LoadEvents = function(){
		obj.cboHospital.setValue(CTHospID);
		obj.cboHospital.setRawValue(CTHospDesc);
		obj.cboHospital.on('select',obj.cboHospital_select,obj);
		obj.btnQuery.on('click',obj.btnQuery_click,obj);
		obj.txtMrNo.on('specialkey',obj.txtMrNo_specialkey,obj);
		obj.txtRegNo.on('specialkey',obj.txtRegNo_specialkey,obj);
		obj.txtCardNo.on('specialkey',obj.txtCardNo_specialkey,obj);
		obj.txtPatName.on('specialkey',obj.txtPatName_specialkey,obj);
		obj.txtPersonalID.on('specialkey',obj.txtPersonalID_specialkey,obj);
		obj.RowExpander.on("expand",obj.RowExpander_expand,obj);
		
		obj.cboHospital.on("select",obj.cboHospital_select,obj);
		obj.cboHospital.setValue(CTHospID);
		obj.cboHospital.setRawValue(CTHospDesc);
		obj.cboHospital_select();
		
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
		if (MrClass=="O")  //门诊不显示项目
		{
			var cm = obj.VolStatusList.getColumnModel();
	    		var cfg = null;
			for(var i=0;i<cm.config.length;++i)
	 		{
	   	 		cfg = cm.config[i];
	   	 		if ((cfg.id=="DischDate")||(cfg.id=="ChiefProfessor")||(cfg.id=="Professor")||(cfg.id=="VistingDoctor")||(cfg.id=="ResidentDoctor")) {
					cm.setHidden(i,true);
	   	 		}
			}
			//不显示病区,出院日期
			obj.dfDisDateFrom.getEl().up('.x-form-item').setDisplayed(false);
			obj.dfDisDateTo.getEl().up('.x-form-item').setDisplayed(false);
			obj.cboWard.getEl().up('.x-form-item').setDisplayed(false);
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
	}
	
	obj.txtMrNo_specialkey = function(field, e) {
		if (e.getKey() != Ext.EventObject.ENTER) return;
		Common_SetValue('txtRegNo','');
		Common_SetValue('txtCardNo','');
		Common_SetValue('txtPatName','');
		Common_SetValue('txtPersonalID','');
		Common_LoadCurrPage('VolStatusList',1);
	}
	
	obj.txtRegNo_specialkey = function(field, e) {
		if (e.getKey() != Ext.EventObject.ENTER) return;
		Common_SetValue('txtMrNo','');
		Common_SetValue('txtCardNo','');
		Common_SetValue('txtPatName','');
		Common_SetValue('txtPersonalID','');
		Common_LoadCurrPage('VolStatusList',1);
	}
	
	obj.txtCardNo_specialkey = function(field, e) {
		if (e.getKey() != Ext.EventObject.ENTER) return;
		Common_SetValue('txtMrNo','');
		Common_SetValue('txtRegNo','');
		Common_SetValue('txtPatName','');
		Common_SetValue('txtPersonalID','');
		Common_LoadCurrPage('VolStatusList',1);
	}
	
	obj.txtPatName_specialkey = function(field, e) {
		if (e.getKey() != Ext.EventObject.ENTER) return;
		Common_SetValue('txtMrNo','');
		Common_SetValue('txtRegNo','');
		Common_SetValue('txtCardNo','');
		Common_SetValue('txtPersonalID','');
		Common_LoadCurrPage('VolStatusList',1);
	}
	
	obj.txtPersonalID_specialkey = function(field, e) {
		if (e.getKey() != Ext.EventObject.ENTER) return;
		Common_SetValue('txtMrNo','');
		Common_SetValue('txtRegNo','');
		Common_SetValue('txtCardNo','');
		Common_SetValue('txtPatName','');
		Common_LoadCurrPage('VolStatusList',1);
	}
	
	obj.btnQuery_click = function(){
		Common_LoadCurrPage('VolStatusList',1);
	}
	
	obj.GetQueryInput = function(){
		var HospID = Common_GetValue("cboHospital");
		var MrTypeID = Common_GetValue("cboMrType");
		var MrNo = Common_GetValue("txtMrNo");
		var RegNo = Common_GetValue("txtRegNo");
		var CardNo = Common_GetValue("txtCardNo");
		var PatName = Common_GetValue("txtPatName");
		var PersonalID = Common_GetValue("txtPersonalID");
		var AdmDateFrom = Common_GetValue("dfAdmDateFrom");
		var AdmDateTo = Common_GetValue("dfAdmDateTo");
		var DisDateFrom = Common_GetValue("dfDisDateFrom");
		var DisDateTo = Common_GetValue("dfDisDateTo");
		var LocID = Common_GetValue("cboLoc");
		var WardID = Common_GetValue("cboWard");
		var KeyWord = Common_GetValue("txtKeyWord");
		
		if (HospID==''){
			window.alert("请选择医院！");
			return '';
		}
		if (MrTypeID==''){
			window.alert("请选择病案类型！");
			return '';
		}
		if ((MrNo=='')&&(RegNo=='')&&(CardNo=='')&&(PatName=='')&&(PersonalID=='')&&(KeyWord=='')){
			window.alert("请输入病案号、登记号、卡号、姓名、证件号码或关键字查询条件！");
			return '';
		}
		if ((MrNo=='')&&(RegNo=='')&&(CardNo=='')&&(PatName=='')&&(PersonalID=='')){
			if (((AdmDateFrom=='')&&(AdmDateTo!=''))||((AdmDateFrom!='')&&(AdmDateTo==''))){
				window.alert("请选择就诊日期查询条件！");
				return '';
			}
			if (MrClass=="O"){
				if (AdmDateFrom==''){
				window.alert("请选择就诊日期查询条件！");
				return '';
				}
			}
			else{
				if (((DisDateFrom=='')&&(DisDateTo!=''))||((DisDateFrom!='')&&(DisDateTo==''))){
				window.alert("请选择出院日期查询条件！");
				return '';
				}
				if ((AdmDateFrom=='')&&(DisDateFrom=='')){
				window.alert("请选择就诊日期或出院日期查询条件！");
				return '';
				}
			}
		}
		
		var strArg = HospID;
		strArg += '^' + MrTypeID;
		strArg += '^' + MrNo;
		strArg += '^' + RegNo;
		strArg += '^' + CardNo;
		strArg += '^' + PatName;
		strArg += '^' + PersonalID;
		strArg += '^' + KeyWord;
		strArg += '^' + AdmDateFrom;
		strArg += '^' + AdmDateTo;
		strArg += '^' + DisDateFrom;
		strArg += '^' + DisDateTo;
		strArg += '^' + LocID;
		strArg += '^' + WardID;
		return strArg;
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
	
	//Add By LiYang 2016-02-23 病案操作时间线展示
	obj.btnTimeLine_onclick = function(VolID)
	{
		var strURL = "./dhcwmr.wf.timeline.csp?VolID=" + VolID;
		//window.open(strURL,"_blank", "height=600,width=800,status=yes,toolbar=no,menubar=no,scrollbars=yes");
		websys_createWindow(strURL,"时间线", "height=600,width=800,status=yes,toolbar=no,menubar=no,scrollbars=yes");
	}
}
