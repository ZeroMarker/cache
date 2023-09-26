var loginLocId = session['LOGON.CTLOCID'];
var InRequestParamObj = GetAppPropValue('DHCSTINREQM'); 
//��������ȫ�ֱ���
var INREQUEST_LOCTYPE2 = ''; //�ж��̵�����Ƿ�ʹ�ù�������
if(InRequestParamObj && InRequestParamObj.ReqLocUseLinkLoc){
	INREQUEST_LOCTYPE2 = InRequestParamObj.ReqLocUseLinkLoc == 'Y'? 'L' : '';
}

SubLocStkTkFind = function(Fn){
	
 
	var FindStkTkLoc = new Ext.ux.LocComboBox({
		id : 'FindStkTkLoc',
		fieldLabel : '�̵����',
		protype : INREQUEST_LOCTYPE2,
	    linkloc:loginLocId,
		anchor : '90%'
	});

	var FindStartDate = new Ext.ux.DateField({
		id : 'FindStartDate',
		allowBlank : true,
		fieldLabel : '��ʼ����',
		
		anchor : '90%',
		value : new Date()
	});

	var FindEndDate = new Ext.ux.DateField({
		id : 'FindEndDate',
		allowBlank : true,
		fieldLabel : '��ֹ����',
		
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
		text : '��ѯ',
		iconCls : 'page_find',
		handler : function(){
			var FindStkTkLoc = Ext.getCmp('FindStkTkLoc').getValue();
			if(Ext.isEmpty(FindStkTkLoc)){
				Msg.info('warning', '�̵���Ҳ���Ϊ��!');
				return false;
			}
			var StartDate = Ext.getCmp('FindStartDate').getValue();
			if(Ext.isEmpty(StartDate)){
				Msg.info('warning', '��ʼ���ڲ���Ϊ��!');
				return false;
			}else{
				StartDate = StartDate.format(ARG_DATEFORMAT);
			}
			var EndDate = Ext.getCmp('FindEndDate').getValue();
			if(Ext.isEmpty(EndDate)){
				Msg.info('warning', '��ֹ���ڲ���Ϊ��!');
				return false;
			}else{
				EndDate = EndDate.format(ARG_DATEFORMAT);
			}
			if(StartDate>EndDate){
				Msg.info('warning','��ʼ����Ӧ��С�ڽ�ֹ����');
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
		text:'ȷ��',
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
			Msg.info('error', '��ѡ���̵㵥!');
			return false;
		}else{
			var RowId = rowObj[0].get('RowId');
			Fn(RowId);
			FindWin.close();
		}
	}

	var FindClear = new Ext.Toolbar.Button({
		text : '���',
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
		text : '�ر�',
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
			title : '��ѯ����',
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
			header : '�����̵㵥��',
			dataIndex : 'SubSTNo',
			width : 160,
			align : 'left',
			sortable : true
		},{
			header : '�ⷿ',
			dataIndex : 'CreateLocDesc',
			width : 160,
			align : 'left',
			sortable : true
		},{
			header : '�̵����',
			dataIndex : 'StkTkLocDesc',
			width : 160,
			align : 'left',
			sortable : true
		},{
			header : '�Ƶ���',
			width : 80,
			dataIndex : 'CreateUser',
			align : 'left',
			sortable : true
		},{
			header : '�Ƶ�����',
			align : 'left',
			width : 70,
			dataIndex : 'CreateDate',
			sortable : true
		},{
			header : '�Ƶ�ʱ��',
			align : 'left',
			width : 70,
			dataIndex : 'CreateTime',
			sortable : true
		},{
			header : '���',
			align : 'center',
			width : 70,
			dataIndex : 'Completed',
			xtype : 'checkcolumn'
		},{
			header : 'ʵ�����',
			align : 'center',
			width:70,
			dataIndex : 'CountCompleted',
			xtype : 'checkcolumn'
		},{
			header : '�������',
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
		title : '�����̵㵥',
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
			header : '���ʴ���',
			dataIndex : 'InciCode',
			width : 100,
			align : 'left',
			sortable : true
		},{
			header : '��������',
			dataIndex : 'InciDesc',
			width : 160,
			align : 'left',
			sortable : true
		},{
			header : '���',
			width : 120,
			dataIndex : 'Spec',
			align : 'left',
			sortable : true
		},{
			header : '��������',
			align: 'right',
			width : 70,
			dataIndex : 'FreezeQty',
			sortable : true
		},{
			header : '��λ',
			align : 'left',
			width : 70,
			dataIndex : 'PUomDesc',
			sortable : true
		},{
			header : '���۽��',
			align : 'right',
			width : 70,
			dataIndex : 'RpAmt',
			sortable : true
		},{
			header : '�ۼ۽��',
			align : 'right',
			width : 70,
			dataIndex : 'SpAmt',
			sortable : true
		},{
			header : '��ע',
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
		title : '�����̵㵥��ϸ',
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
		title : '���ұ����̵㵥',
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