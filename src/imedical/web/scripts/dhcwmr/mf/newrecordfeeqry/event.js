function InitEvent(obj){
	obj.LoadEvents = function(){
		obj.cboHospital.on("select",obj.cboHospital_select,obj);
		obj.btnQry.on('click',obj.btnQry_click,obj);
		obj.btnExport.on('click',obj.btnExport_click,obj);
		obj.btnPrint.on('click',obj.btnPrint_click,obj);
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
	
	obj.btnQry_click = function()
	{
		Common_LoadCurrPage('GridNewRecord',1);
		var msgTitle = "��ѯ���ڣ�"+ Common_GetValue('dfDateFrom')+"��"+Common_GetValue('dfDateTo')+ "  ���ң�"+(Common_GetText('cboLendLoc')!==""?Common_GetText('cboLendLoc'):'ȫ��');
		Common_SetValue('msgNewRecordFeeList',msgTitle);
	}
	
	obj.btnExport_click = function()
	{
		if (obj.GridNewRecordStore.getCount()<1) {
			window.alert("���Ȳ�ѯ�ٵ���Excel��");
			return;
		}
		ExportGridByCls(obj.GridNewRecord,'�����Ѳ�ѯ');
	}
	
	obj.btnPrint_click = function()
	{
		if (obj.GridNewRecordStore.getCount()<1) {
			window.alert("���Ȳ�ѯ�ٴ�ӡ��");
			return;
		}
		var fields = 'BuildUser'
			+ CHR_1 + 'MrNo'
			+ CHR_1 + 'PatName'
			+ CHR_1 + 'PapmiNo'
			+ CHR_1 + 'Price'
			+ CHR_1 + 'BillNum'
			+ CHR_1 + 'DateTime'

		var xlsName = 'DHCWMR_OMR_Newrecordfee.xlt';
		var recTitle = "" 
		PrintGridByCls(obj.GridNewRecord,fields,xlsName,recTitle);
	}
}