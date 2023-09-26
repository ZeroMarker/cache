/**
 * ��ֵ���µ�ÿ����ϸ���Դ�����,����,Ч�ڵ���Ϣ����
 * @param {} dhcit
 * @param {} InfoStr
 */
function BarCodePackItm(dhcit, InfoStr) {
	
	var Info = tkMakeServerCall('web.DHCSTM.DHCItmTrack', 'GetPackInciStr', dhcit);
	//��ȡ����������Ϣ��,������ʾ��Window
	if(Ext.isEmpty(Info)){
		return false;
	}
	
	//��ʾ�Ѵ��ڵ���Ϣ
	function GetPackItmInfo() {
		if (Ext.isEmpty(dhcit)) {
			return;
		}
		var StrParam = dhcit;	//����ƴ��
		PackItmStore.setBaseParam('StrParam', StrParam);
		PackItmStore.load();
	}
	
	var PackItmCloseBT = {
		xtype : 'button',
		text : '�ر�',
		tooltip : '�رս���',
		iconCls : 'page_delete',
		height : 30,
		width : 70,
		handler : function() {
			PackItmWin.close();
		}
	};

	var PackItmSaveBT = {
		xtype : 'uxbutton',
		text : '����',
		iconCls : 'page_save',
		handler : function() {
			if(PackItmGrid.activeEditor != null){
				PackItmGrid.activeEditor.completeEdit();
			}
			PackItmSave();
		}
	};

	function PackItmSave(){
		var ListDetail = '';
		var rowCount = PackItmStore.getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = PackItmStore.getAt(i);
			if(rowData.data.newRecord || rowData.dirty){
				var RowId = rowData.get('RowId');
				var inci = rowData.get('inci');
				var OriginalCode = rowData.get('OriginalCode');
				var BatchNo = rowData.get('BatchNo');
				var ExpDate = Ext.util.Format.date(rowData.get('ExpDate'), ARG_DATEFORMAT);
				var ManfId = rowData.get('ManfId');
				var Str = RowId + '^' + inci + '^' + OriginalCode + '^' + BatchNo + '^' + ExpDate
					+ '^' + ManfId;
				if(ListDetail == ''){
					ListDetail = Str;
				}else{
					ListDetail = ListDetail + xRowDelim() + Str;
				}
			}
		}
		var loadMask = ShowLoadMask(PackItmWin.body, '������...');
		Ext.Ajax.request({
			url : 'dhcstm.barcodeaction.csp?actiontype=SavePackItm',
			method : 'POST',
			params : {dhcit : dhcit, ListDetail : ListDetail},
			waitMsg : '������...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if(jsonData.success == 'true') {
					Msg.info("success", "����ɹ�!");
					PackItmStore.reload();
				}else{
					var ret = jsonData.info;
					Msg.info('error', '����ʧ��: ' + ret);
				}
				loadMask.hide();
			},
			scope : this
		});
	}

	var PackItmManf = new Ext.ux.ComboBox({
		store : PhManufacturerStore,
		emptyText : ' ����...',
		filterName : 'PHMNFName'
	});
	
	var PackItmStore = new Ext.data.JsonStore({
		url : 'dhcstm.barcodeaction.csp?actiontype=GetPackItm',
		root : 'rows',
		totalProperty : 'results',
		fields : ['RowId', 'inci', 'InciCode', 'InciDesc', 'Spec',
			'OriginalCode', 'BatchNo', {name:'ExpDate', type:'date',dateFormat:DateFormat}, 'ManfId', 'ManfDesc'],
		pruneModifiedRecords : true
	});
	
	var PackItmCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header : '��ϸID',
			dataIndex : 'RowId',
			width : 60,
			hidden : true
		}, {
			header : '����RowId',
			dataIndex : 'inci',
			width : 60,
			hidden : true
		}, {
			header : '���ʴ���',
			dataIndex : 'InciCode',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : '��������',
			dataIndex : 'InciDesc',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			header : '���',
			dataIndex : 'Spec',
			width : 60,
			align : 'left',
			sortable : true
		}, {
			header : '�Դ�����',
			dataIndex : 'OriginalCode',
			width : 150,
			align : 'left',
			sortable : true,
			editable : false,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField())
		}, {
			header : '����',
			dataIndex : 'BatchNo',
			width : 120,
			align : 'left',
			sortable : true,
			editable : false,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField())
		}, {
			header : 'Ч��',
			dataIndex : 'ExpDate',
			width : 120,
			align : 'left',
			sortable : true,
			editable : false,
			editor : new Ext.grid.GridEditor(new Ext.ux.DateField()),
			renderer : Ext.util.Format.dateRenderer(DateFormat)
		}, {
			header : '����',
			dataIndex : 'ManfId',
			width : 120,
			align : 'left',
			sortable : true,
			editable : false,
			editor : new Ext.grid.GridEditor(PackItmManf),
			renderer : Ext.util.Format.comboRenderer2(PackItmManf, 'ManfId', 'ManfDesc')
		}
	]);

	var PackItmGrid = new Ext.ux.EditorGridPanel({
		id : 'PackItmGrid',
		title : '',
		cm : PackItmCm,
		sm : new Ext.grid.CellSelectionModel(),
		store : PackItmStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		clicksToEdit : 1
	});

	var PackItmWin = new Ext.Window({
		title : InfoStr + '  ��ϸ��Ϣ',
		width : 0.7 * gWinWidth,
		height : 0.9 * gWinHeight,
		modal : true,
		layout : 'fit',
		items : [PackItmGrid],
		tbar : [PackItmCloseBT]		//PackItmSaveBT
	});
	PackItmWin.show();

	// �Զ���ʾ������Ϣ
	GetPackItmInfo(dhcit);
}