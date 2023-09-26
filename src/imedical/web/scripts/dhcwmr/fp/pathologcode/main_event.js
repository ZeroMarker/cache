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
		//���ؿ�����
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
			window.alert("��ѡ��ʼ���ڡ���ֹ���ڣ�");
			return;
		}
		obj.QryFlg = 1;
		Common_LoadCurrPage('gridPathologRep',1);
		Common_SetValue('msggridPathologRep','δ��Ŀ��ѯ���');
	}
	
	obj.btnCodQry_click = function()
	{
		var DateFrom = Common_GetValue("dfDateFrom");
		var DateTo = Common_GetValue("dfDateTo");
		if ((DateFrom=='')||(DateTo=='')){
			window.alert("��ѡ��ʼ���ڡ���ֹ���ڣ�");
			return;
		}
		obj.QryFlg = 2;
		Common_LoadCurrPage('gridPathologRep',1);
		Common_SetValue('msggridPathologRep','�ѱ�Ŀ��ѯ���');
	}
	
	obj.btnRepQry_click = function()
	{
		var DateFrom = Common_GetValue("dfDateFrom");
		var DateTo = Common_GetValue("dfDateTo");
		if ((DateFrom=='')||(DateTo=='')){
			window.alert("��ѡ��ʼ���ڡ���ֹ���ڣ�");
			return;
		}
		obj.QryFlg = 3;
		Common_LoadCurrPage('gridPathologRep',1);
		Common_SetValue('msggridPathologRep','�������ѯ���');
	}
	
	obj.ViewFrontPageEdit = function(aFrontPageID,aVolumeID,aPathRepID){
		if ((!aFrontPageID)&&(!aVolumeID)&&(!aPathRepID)){
			window.alert("��Ŀ��������!");
			return;
		}
		
		if ((!aFrontPageID)&&(aVolumeID!='')){
			var ret = ExtTool.RunServerMethod("DHCWMR.FPService.FrontPageSrv","CheckOperation",aVolumeID,FPType);
			if (parseInt(ret) <= 0) {
				window.alert("��ǰ��������������Ŀ����!");
				return;
			}
		}
		
		var sURL="dhcwmr.fp.frontpageedit.csp?1=1&FrontPageID=" + aFrontPageID + "&VolumeID=" + aVolumeID + "&FPType=" + FPType + "&IsPathologEdit=1" +"&PathRepID=" + aPathRepID + "&EditFlag=1&2=2";
		var vArguments = '';
		var sFeatures = "dialogWidth=" + window.screen.availWidth + "px;dialogHeight=" + window.screen.availHeight + "px;resizable=no;"
		window.showModalDialog(sURL,vArguments,sFeatures);
		Common_LoadCurrPage('gridFrontPage');
		Common_SetValue("txtMrNo",'');  //��ղ�����
		//var oWin = window.open(sURL,'',"height=" + window.screen.availHeight + ",width=" + window.screen.availWidth + ",top=0,left=0,resizable=no");
	}
}