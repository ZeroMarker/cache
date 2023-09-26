function InitEvent(obj){
	obj.LoadEvents = function(){
		obj.cboHospital.on("select",obj.cboHospital_select,obj);
		obj.btnPrint.on('click',obj.btnPrint_click,obj);
		obj.btnQry.on('click',obj.btnQry_click,obj);
		obj.btnExport.on('click',obj.btnExport_click,obj);
		obj.txtMrNo.on('specialkey',obj.txtMrNo_specialkey,obj);
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
	}
	
	obj.btnPrint_click = function()
	{
		if (obj.gridResultStore.getCount()<1) {
			window.alert("���Ȳ�ѯ�ٴ�ӡ��");
			return;
		}
		var fields = 'PapmiNo'
			+ CHR_1 + 'MrNo'
			+ CHR_1 + 'PatName'
			+ CHR_1 + 'Sex'
			+ CHR_1 + 'Age'
			+ CHR_1 + 'HospDesc'
			+ CHR_1 + 'StatusDesc'
			+ CHR_1 + 'LendDate'
			+ CHR_1 + 'LendLoc'
			+ CHR_1 + 'LendUser'
			+ CHR_1 + 'BackDate'
			+ CHR_1 + 'BackUser';
		var xlsName = 'DHCWMR_OMR_Lend.xlsx';
		var QryType = Common_GetText("cboQryType");
		var LendLoc = Common_GetText("cboLendLoc");
		var LendDoc = Common_GetText("cboLendDoc");
		var DateFrom = Common_GetValue("dfDateFrom");
		var DateTo = Common_GetValue("dfDateTo");
		var recTitle = LendLoc+LendDoc+QryType+"����("+DateFrom+"~"+DateTo+")";
		PrintGridByCls(obj.gridResult,fields,xlsName,recTitle);
	}
	
	obj.btnQry_click = function()
	{
		Common_LoadCurrPage('gridResult',1);
	}

	obj.btnExport_click = function()
	{
		if (obj.gridResultStore.getCount()<1) {
			window.alert("���Ȳ�ѯ�ٵ���Excel��");
			return;
		}
		ExportGridByCls(obj.gridResult,'�����ۺϲ�ѯ���');
	}
	
	obj.txtMrNo_specialkey = function(field, e)
	{
		if (e.getKey() != Ext.EventObject.ENTER) return;
		var MrNo     = Common_GetValue("txtMrNo");
		if (MrNo==''){
			window.alert("�����벡���ţ�");
			return '';
		}
		Common_LoadCurrPage('gridResult',1);
		Common_SetValue("txtMrNo","");
	}
	
	obj.GetQueryInput = function(){
		var HospID 	 = Common_GetValue("cboHospital");
		var MrTypeID = Common_GetValue("cboMrType");
		var QryType  = Common_GetValue("cboQryType");
		var DateFrom = Common_GetValue("dfDateFrom");
		var DateTo   = Common_GetValue("dfDateTo");
		var LendLoc  = Common_GetValue("cboLendLoc");
		var LendDoc  = Common_GetValue("cboLendDoc");
		var MrNo     = Common_GetValue("txtMrNo");
		
		if (HospID==''){
			window.alert("��ѡ��ҽԺ��");
			return '';
		}
		if (MrTypeID==''){
			window.alert("��ѡ�񲡰����ͣ�");
			return '';
		}
		if ((DateFrom=='')||(DateTo=='')) {
			window.alert("��ѡ��ʼ���ںͽ������ڣ�");
			return '';
		}
		
		var strArg = HospID;
		strArg += '^' + MrTypeID;
		strArg += '^' + QryType;
		strArg += '^' + DateFrom;
		strArg += '^' + DateTo;
		strArg += '^' + LendLoc;
		strArg += '^' + LendDoc;
		strArg += '^' + MrNo;
		return strArg;
	}
}