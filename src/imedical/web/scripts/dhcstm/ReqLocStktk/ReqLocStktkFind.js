var loginLocId = session['LOGON.CTLOCID'];
var InRequestParamObj = GetAppPropValue('DHCSTINREQM'); 
//科室类型全局变量
var INREQUEST_LOCTYPE2 = ''; //判断盘点科室是否使用关联科室
if(InRequestParamObj && InRequestParamObj.ReqLocUseLinkLoc){
	INREQUEST_LOCTYPE2 = InRequestParamObj.ReqLocUseLinkLoc == 'Y'? 'L' : '';
}

SubLocStkTkFind = function(Fn){
	
 
	var FindStkTkLoc = new Ext.ux.LocComboBox({
		id : 'FindStkTkLoc',
		fieldLabel : '盘点科室',
		protype : INREQUEST_LOCTYPE2,
	    linkloc:loginLocId,
		anchor : '90%'
	});

	var FindStartDate = new Ext.ux.DateField({
		id : 'FindStartDate',
		allowBlank : true,
		fieldLabel : '起始日期',
		
		anchor : '90%',
		value : new Date()
	});

	var FindEndDate = new Ext.ux.DateField({
		id : 'FindEndDate',
		allowBlank : true,
		fieldLabel : '截止日期',
		
		anchor : '90%',
		value : new Date()
	});

	var FindScg = new Ext.ux.StkGrpComboBox({
		id : 'FindScg',
		StkType : App_StkTypeCode,
		anchor : '90%',
		LocId : gLocId,
		UserId : gUserId
	});

	var FindQuery = new Ext.ux.Button({
		text : '查询',
		iconCls : 'page_find',
		handler : function(){
			var FindStkTkLoc = Ext.getCmp('FindStkTkLoc').getValue();
			if(Ext.isEmpty(FindStkTkLoc)){
				Msg.info('warning', '盘点科室不可为空!');
				return false;
			}
			var StartDate = Ext.getCmp('FindStartDate').getValue();
			if(Ext.isEmpty(StartDate)){
				Msg.info('warning', '起始日期不可为空!');
				return false;
			}else{
				StartDate = StartDate.format(ARG_DATEFORMAT);
			}
			var EndDate = Ext.getCmp('FindEndDate').getValue();
			if(Ext.isEmpty(EndDate)){
				Msg.info('warning', '截止日期不可为空!');
				return false;
			}else{
				EndDate = EndDate.format(ARG_DATEFORMAT);
			}
			if(StartDate>EndDate){
				Msg.info('warning','起始日期应该小于截止日期');
				return;
			}
			var StrParam = FindStkTkLoc + '^' + StartDate + '^' + EndDate;
			FindMasterStore.setBaseParam('StrParam', StrParam);
			FindMasterStore.removeAll();
			FindDetailStore.removeAll();
			FindMasterStore.load({
				params:{start : 0, limit : FindMasterPaging.pageSize}
			});
		}
	});

	var FindSel = new Ext.ux.Button({
		text:'确定',
		iconCls:'page_gear',
		width : 70,
		height : 30,
		handler:function(){
			ReturnData();
		}
	});

	function ReturnData(){
		var rowObj = FindMasterGrid.getSelectionModel().getSelections();
		var len = rowObj.length;
		if(len < 1){
			Msg.info('error', '请选择盘点单!');
			return false;
		}else{
			var RowId = rowObj[0].get('RowId');
			Fn(RowId);
			FindWin.close();
		}
	}

	var FindClear = new Ext.Toolbar.Button({
		text : '清空',
		iconCls : 'page_clearscreen',
		width : 70,
		height :30,
		handler:function(){
			clearPanel(FindFormPanel);
			FindFormPanel.getForm().setValues({FindStartDate : new Date(), FindStartDate : new Date()})
			FindMasterGrid.getStore().removeAll();
			FindMasterGrid.getView().refresh();
			FindDetailGrid.getStore().removeAll();
			FindDetailGrid.getView().refresh();
		}
	});

	var FindCancel = new Ext.Toolbar.Button({
		text : '关闭',
		iconCls : 'page_close',
		width : 70,
		height : 30,
		handler : function(){
			FindWin.close();
		}
	});

	var FindFormPanel = new Ext.form.FormPanel({
		id : 'FindFormPanel',
		region : 'north',
		height : 145,
		frame : true,
		labelAlign : 'right',
		tbar : [FindQuery, '-', FindSel, '-', FindClear, '-', FindCancel],
		items : [{
			xtype : 'fieldset',
			title : '查询条件',
			style : 'padding:5px 0px 0px 0px',
			defaults : {border:false},
			layout : 'column',
			items : [{
				columnWidth : 0.25,
				xtype : 'fieldset',
				items : [ FindStkTkLoc]
			},{
				columnWidth : 0.25,
				xtype : 'fieldset',
				items : [FindStartDate, FindEndDate]
			}]
		}]
	});

	var FindMasterStore = new Ext.data.JsonStore({
		url : Url + '?actiontype=QueryMaster',
		root : 'rows',
		totalProperty : 'results',
		fields : ['RowId','SubSTNo','StkTkLoc','StkTkLocDesc','CreateLoc','CreateLocDesc',
			'CreateUser','CreateDate','CreateTime','Completed','CountCompleted', 'AdjCompleted',
			'Scg','ScgDesc','Incsc','IncscDesc'],
		remoteSort : true,
		listeners : {
			'load' : function(ds){
				if (ds.getCount() > 0){
					FindMasterGrid.getSelectionModel().selectFirstRow();
					FindMasterGrid.getView().focusRow(0);
				}
			}
		}
	});

	var FindMasterCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header : 'RowId',
			dataIndex : 'RowId',
			width : 60,
			align : 'left',
			hidden : true
		},{
			header : '便易盘点单号',
			dataIndex : 'SubSTNo',
			width : 160,
			align : 'left',
			sortable : true
		},{
			header : '库房',
			dataIndex : 'CreateLocDesc',
			width : 160,
			align : 'left',
			sortable : true
		},{
			header : '盘点科室',
			dataIndex : 'StkTkLocDesc',
			width : 160,
			align : 'left',
			sortable : true
		},{
			header : '制单人',
			width : 80,
			dataIndex : 'CreateUser',
			align : 'left',
			sortable : true
		},{
			header : '制单日期',
			align : 'left',
			width : 70,
			dataIndex : 'CreateDate',
			sortable : true
		},{
			header : '制单时间',
			align : 'left',
			width : 70,
			dataIndex : 'CreateTime',
			sortable : true
		},{
			header : '完成',
			align : 'center',
			width : 70,
			dataIndex : 'Completed',
			xtype : 'checkcolumn'
		},{
			header : '实盘完成',
			align : 'center',
			width:70,
			dataIndex : 'CountCompleted',
			xtype : 'checkcolumn'
		},{
			header : '调整完成',
			align : 'center',
			width : 70,
			dataIndex : 'AdjCompleted',
			xtype : 'checkcolumn'
		}
	]);

	var FindMasterPaging = new Ext.PagingToolbar({
		store : FindMasterStore,
		pageSize : 30,
		displayInfo : true
	});

	FindMasterGrid = new Ext.ux.GridPanel({
		id : 'FindMasterGrid',
		title : '便易盘点单',
		region : 'center',
		store : FindMasterStore,
		cm : FindMasterCm,
		trackMouseOver : true,
		stripeRows : true,
		sm : new Ext.grid.RowSelectionModel({
			singleSelect : true,
			listeners : {
				'rowselect' : function(sm,rowIndex,record){
					var Parref = record.get('RowId');
					FindDetailStore.setBaseParam('Parref', Parref);
					FindDetailStore.load({
						params : {start : 0, limit : FindDetailPaging.pageSize}
					});
				}
			}
		}),
		loadMask: true,
		bbar : [FindMasterPaging],
		listeners : {
			rowdblclick : function(grid,rowindex,e){
				ReturnData();
			}
		}
	});

	var FindDetailStore = new Ext.data.JsonStore({
		url : Url + '?actiontype=QueryDetail',
		root : 'rows',
		totalProperty : 'results',
		fields : ['RowId','Incil','InciCode','InciDesc','Spec','RepLev','RepQty','FreezeQty','PUomDesc','CountQty','Qty',
			'RpAmt','SpAmt','Remarks','PhaLocAvaQty'],
		remoteSort : false
	});

	var FindDetailCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header : 'RowId',
			align : 'left',
			width : 70,
			dataIndex :'RowId',
			sortable : true,
			hidden : true
		},{
			header : 'Incil',
			align : 'left',
			width : 70,
			dataIndex :'Incil',
			hidden : true
		},{
			header : '物资代码',
			dataIndex : 'InciCode',
			width : 100,
			align : 'left',
			sortable : true
		},{
			header : '物资名称',
			dataIndex : 'InciDesc',
			width : 160,
			align : 'left',
			sortable : true
		},{
			header : '规格',
			width : 120,
			dataIndex : 'Spec',
			align : 'left',
			sortable : true
		},{
			header : '冻结数量',
			align: 'right',
			width : 70,
			dataIndex : 'FreezeQty',
			sortable : true
		},{
			header : '单位',
			align : 'left',
			width : 70,
			dataIndex : 'PUomDesc',
			sortable : true
		},{
			header : '进价金额',
			align : 'right',
			width : 70,
			dataIndex : 'RpAmt',
			sortable : true
		},{
			header : '售价金额',
			align : 'right',
			width : 70,
			dataIndex : 'SpAmt',
			sortable : true
		},{
			header : '备注',
			align : 'left',
			width : 180,
			dataIndex : 'Remarks',
			sortable : true
		}
	]);

	var FindDetailPaging = new Ext.PagingToolbar({
		store : FindDetailStore,
		pageSize : 30,
		displayInfo : true
	});

	var FindDetailGrid = new Ext.ux.GridPanel({
		id : 'FindDetailGrid',
		title : '便易盘点单明细',
		region : 'south',
		height : 240,
		id : 'FindDetailGrid',
		store : FindDetailStore,
		cm : FindDetailCm,
		trackMouseOver : true,
		stripeRows : true,
		sm : new Ext.grid.RowSelectionModel({
			singleSelect : true
		}),
		loadMask : true,
		bbar : [FindDetailPaging]
	});

	var FindWin = new Ext.Window({
		title : '查找便易盘点单',
		width : 1000,
		height : 600,
		layout : 'border',
		modal : true,
		bodyStyle : '',
		items : [FindFormPanel, FindMasterGrid, FindDetailGrid],
		listeners : {
			show : function(){
				FindQuery.handler();
			}
		}
	});

	FindWin.show();
};