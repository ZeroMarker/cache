
function VenItmListWindow(){
	
	var VenItmListUrl = 'dhcstm.vendoruseraction.csp?actiontype=VenItmList&Vendor=' + VENDORID;
	var VenItmListStore = new Ext.data.JsonStore({
		autoLoad : true,
		url : VenItmListUrl,
		totalProperty : 'results',
		root : 'rows',
		fields : ['InciId','InciCode','InciDesc','Spec','HVFlag']
	});
	
	var VenItmListSm = new Ext.grid.CheckboxSelectionModel({
		listeners : {
			beforerowselect : function(sm,rowIndex,keepExisting,record){
				if(record.get('HVFlag') == 'Y'){
					return false;
				}
			}
		}
	});
	var VenItmListCm = new Ext.grid.ColumnModel([
		VenItmListSm,
		{
			header : 'InciId',
			dataIndex : 'InciId',
			align : 'left',
			hidden : true
		},{
			header : '���ʴ���',
			dataIndex : 'InciCode',
			align : 'left',
			width : 160
		},{
			header : '��������',
			dataIndex : 'InciDesc',
			align : 'left',
			width : 200
		},{
			header : '���',
			dataIndex : 'Spec',
			align : 'left',
			width : 80
		},{
			header : '��������־',
			dataIndex : 'HVFlag',
			xtype : 'checkcolumn',
			width : 100
		}
	]);
	 
	var VenItmListGrid = new Ext.grid.GridPanel({
		store : VenItmListStore,
		cm : VenItmListCm,
		sm : VenItmListSm,
		listeners : {
			rowdblclick : function(grid, rowIndex, e){
				var SelRow = grid.getStore().getAt(rowIndex);
				var HVFlag = SelRow.get('HVFlag');
				if(HVFlag != 'Y'){
					Msg.info('warning', '�����ʲ��Ǹ�ֵ�Ĳ�!');
					return false;
				}
				var inciDr = SelRow.get('InciId');
				var inciCode = SelRow.get('InciCode');
				var inciDesc = SelRow.get('InciDesc');
				var Spec = SelRow.get('Spec');
				
				BarCodeGrid.addNewRow();
				var row = BarCodeGrid.getSelectedCell()[0];
				var rowData = BarCodeGrid.getAt(row);
				rowData.set("IncId", inciDr);
				rowData.set("IncCode", inciCode);
				rowData.set("IncDesc", inciDesc);
				rowData.set("Spec", Spec);
				rowData.set('Qty', 1);
				rowData.set('Vendor', VENDORID);
				var colIndex = GetColIndex(BarCodeGrid, 'SpecDesc');
				BarCodeGrid.startEditing(BarCodeGrid.getCount() - 1, colIndex);
				VenItmListWin.hide();
			}
		}
	});

	var VenItmListPrintNum = new Ext.form.NumberField({
		id : 'VenItmListPrintNum',
		fieldLabel : 'dd',
		width : 40,
		value : 1,		//ȱʡֵΪ1
		allowNegative : false,
		allowDecimals : false
	});
	
	var VenItmListPrint = new Ext.Button({
		text : '��ӡ��������',
		width : 70,
		height : 30,
		iconCls : 'page_print',
		handler : function(){
			var PrintNum = parseInt(Ext.getCmp('VenItmListPrintNum').getValue());
			if(PrintNum <= 0){
				PrintNum = 1;
			}
			var SelRows = VenItmListGrid.getSelectionModel().getSelections();
			for (var i=0,len=SelRows.length; i<len; i++){
				var rowData = SelRows[i];
				var InciCode = rowData.get('InciCode');
				var OriginalCode = '';
				var InciDesc = rowData.get('InciDesc');
				var BarcodeStr = InciCode+'^'+OriginalCode+'^'+InciDesc;
				for(var j=1; j<=PrintNum; j++){
					PrintBarcode(BarcodeStr);
				}
			}
		}
	});
	
	var VenItmListWin = new Ext.Window({
		title : '�����б�',
		width : 600,
		height : 500,
		layout : 'fit',
		modal : true,
		resizable : false,
		items : [VenItmListGrid],
		tbar : ['��ӡ����:', VenItmListPrintNum, '-', VenItmListPrint]
	});
	
	VenItmListWin.show();
}