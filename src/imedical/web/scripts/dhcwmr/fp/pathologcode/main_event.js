function InitviewScreenEvents(obj){
	obj.LoadEvents = function(){
		obj.btnCodQry.on('click',obj.btnCodQry_click,obj);
		obj.btnNotCodQry.on('click',obj.btnNotCodQry_click,obj);
		obj.btnRepQry.on('click',obj.btnRepQry_click,obj);
		obj.cboLocGroup.on("select",obj.cboLocGroup_select,obj);
		obj.cboHospital.on("select",obj.cboHospital_select,obj);
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
	
	obj.btnNotCodQry_click = function()
	{
		var DateFrom = Common_GetValue("dfDateFrom");
		var DateTo = Common_GetValue("dfDateTo");
		if ((DateFrom=='')||(DateTo=='')){
			window.alert("请选择开始日期、截止日期！");
			return;
		}
		obj.QryFlg = 1;
		Common_LoadCurrPage('gridPathologRep',1);
		Common_SetValue('msggridPathologRep','未编目查询结果');
	}
	
	obj.btnCodQry_click = function()
	{
		var DateFrom = Common_GetValue("dfDateFrom");
		var DateTo = Common_GetValue("dfDateTo");
		if ((DateFrom=='')||(DateTo=='')){
			window.alert("请选择开始日期、截止日期！");
			return;
		}
		obj.QryFlg = 2;
		Common_LoadCurrPage('gridPathologRep',1);
		Common_SetValue('msggridPathologRep','已编目查询结果');
	}
	
	obj.btnRepQry_click = function()
	{
		var DateFrom = Common_GetValue("dfDateFrom");
		var DateTo = Common_GetValue("dfDateTo");
		if ((DateFrom=='')||(DateTo=='')){
			window.alert("请选择开始日期、截止日期！");
			return;
		}
		obj.QryFlg = 3;
		Common_LoadCurrPage('gridPathologRep',1);
		Common_SetValue('msggridPathologRep','病理报告查询结果');
	}
	
	obj.ViewFrontPageEdit = function(aFrontPageID,aVolumeID,aPathRepID){
		if ((!aFrontPageID)&&(!aVolumeID)&&(!aPathRepID)){
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
		
		var sURL="dhcwmr.fp.frontpageedit.csp?1=1&FrontPageID=" + aFrontPageID + "&VolumeID=" + aVolumeID + "&FPType=" + FPType + "&IsPathologEdit=1" +"&PathRepID=" + aPathRepID + "&EditFlag=1&2=2";
		var vArguments = '';
		var sFeatures = "dialogWidth=" + window.screen.availWidth + "px;dialogHeight=" + window.screen.availHeight + "px;resizable=no;"
		window.showModalDialog(sURL,vArguments,sFeatures);
		Common_LoadCurrPage('gridFrontPage');
		Common_SetValue("txtMrNo",'');  //清空病案号
		//var oWin = window.open(sURL,'',"height=" + window.screen.availHeight + ",width=" + window.screen.availWidth + ",top=0,left=0,resizable=no");
	}
}