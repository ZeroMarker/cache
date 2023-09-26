function InitEvent(obj)
{
	obj.LoadEvents = function()
	{
		obj.cboHospital.on("select",obj.cboHospital_select,obj);
		obj.btnPrint.on('click',obj.btnPrint_click,obj);
		obj.btnQry.on('click',obj.btnQry_click,obj);
		obj.btnExport.on('click',obj.btnExport_click,obj);
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
		Common_LoadCurrPage('gridCopyDeail',1);
	}
	
	obj.btnExport_click = function()
	{
		if (obj.gridCopyDeailStore.getCount()<1) {
			window.alert("���Ȳ�ѯ�ٵ���Excel��");
			return;
		}
		ExportGridByCls(obj.gridCopyDeail,'��ӡͳ��');
	}
		
	obj.btnPrint_click = function()
	{
		if (obj.gridCopyDeailStore.getCount()<1) {
			window.alert("���Ȳ�ѯ�ٴ�ӡ��");
			return;
		}
		var fields = 'MrNo'
			+ CHR_1 + 'PatName'
			+ CHR_1 + 'Sex'
			+ CHR_1 + 'Age'
			+ CHR_1 + 'RegDate'
			+ CHR_1 + 'PaperNumber'
			+ CHR_1 + 'Money'
			+ CHR_1 + 'CreateUser'
		var xlsName = 'DHCWMR_OMR_CopyQry.xlsx';
		var recTitle = "";
		if (MrClass == 'I') {
			recTitle = "סԺ������ӡͳ�Ʊ�";
		}
		PrintGridByCls(obj.gridCopyDeail,fields,xlsName,recTitle,1);
	}
}