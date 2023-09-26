/**
 * 高值包下的每个明细的自带条码,批号,效期等信息处理
 * @param {} dhcit
 * @param {} InfoStr
 */
function BarCodePackItm(dhcit, InfoStr) {
	
	var Info = tkMakeServerCall('web.DHCSTM.DHCItmTrack', 'GetPackInciStr', dhcit);
	//获取不到关联信息的,不再显示该Window
	if(Ext.isEmpty(Info)){
		return false;
	}
	
	//显示已存在的信息
	function GetPackItmInfo() {
		if (Ext.isEmpty(dhcit)) {
			return;
		}
		var StrParam = dhcit;	//参数拼接
		PackItmStore.setBaseParam('StrParam', StrParam);
		PackItmStore.load();
	}
	
	var PackItmCloseBT = {
		xtype : 'button',
		text : '关闭',
		tooltip : '关闭界面',
		iconCls : 'page_delete',
		height : 30,
		width : 70,
		handler : function() {
			PackItmWin.close();
		}
	};

	var PackItmSaveBT = {
		xtype : 'uxbutton',
		text : '保存',
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
		var loadMask = ShowLoadMask(PackItmWin.body, '处理中...');
		Ext.Ajax.request({
			url : 'dhcstm.barcodeaction.csp?actiontype=SavePackItm',
			method : 'POST',
			params : {dhcit : dhcit, ListDetail : ListDetail},
			waitMsg : '处理中...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if(jsonData.success == 'true') {
					Msg.info("success", "保存成功!");
					PackItmStore.reload();
				}else{
					var ret = jsonData.info;
					Msg.info('error', '保存失败: ' + ret);
				}
				loadMask.hide();
			},
			scope : this
		});
	}

	var PackItmManf = new Ext.ux.ComboBox({
		store : PhManufacturerStore,
		emptyText : ' 厂商...',
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
			header : '明细ID',
			dataIndex : 'RowId',
			width : 60,
			hidden : true
		}, {
			header : '物资RowId',
			dataIndex : 'inci',
			width : 60,
			hidden : true
		}, {
			header : '物资代码',
			dataIndex : 'InciCode',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : '物资名称',
			dataIndex : 'InciDesc',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			header : '规格',
			dataIndex : 'Spec',
			width : 60,
			align : 'left',
			sortable : true
		}, {
			header : '自带条码',
			dataIndex : 'OriginalCode',
			width : 150,
			align : 'left',
			sortable : true,
			editable : false,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField())
		}, {
			header : '批号',
			dataIndex : 'BatchNo',
			width : 120,
			align : 'left',
			sortable : true,
			editable : false,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField())
		}, {
			header : '效期',
			dataIndex : 'ExpDate',
			width : 120,
			align : 'left',
			sortable : true,
			editable : false,
			editor : new Ext.grid.GridEditor(new Ext.ux.DateField()),
			renderer : Ext.util.Format.dateRenderer(DateFormat)
		}, {
			header : '厂商',
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
		title : InfoStr + '  明细信息',
		width : 0.7 * gWinWidth,
		height : 0.9 * gWinHeight,
		modal : true,
		layout : 'fit',
		items : [PackItmGrid],
		tbar : [PackItmCloseBT]		//PackItmSaveBT
	});
	PackItmWin.show();

	// 自动显示已有信息
	GetPackItmInfo(dhcit);
}