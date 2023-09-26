
// /����: ����Ƶ���ѯ
// /��д�ߣ�gwj
// /��д����: 2012.09.24
// 2014-08-06 ��д��window��ʽ
var payWindow = null;
function QueryPay(payLocRowId,Fn){
	var URL="dhcstm.payaction.csp";
	
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
		fieldLabel : '��ʼ����',
		id : 'StartDate',
		name : 'StartDate',
		anchor : '90%',
		
		width : 120,
		value : new Date().add(Date.DAY, - 30)
	});
	
	// ��ֹ����
	var EndDate = new Ext.ux.DateField({
		fieldLabel : '��ֹ����',
		id : 'EndDate',
		name : 'EndDate',
		anchor : '90%',
		
		width : 120,
		value : new Date()
	});
	
	var FindVendor = new Ext.ux.VendorComboBox({
		fieldLabel : '��Ӧ��',
		id : 'FindVendor',
		name : 'FindVendor',
		anchor : '90%',
		emptyText : '��Ӧ��...',
		valueParams : {LocId : payLocRowId}
	});
	
	// ��ѯ��ť
	var SearchBT = new Ext.Toolbar.Button({
		text : '��ѯ',
		tooltip : '�����ѯ',
		width : 70,
		height : 30,
		iconCls : 'page_find',
		handler : function() {
			Query();
		}
	});
	// ��հ�ť
	var ClearBT = new Ext.Toolbar.Button({
		text : '���',
		tooltip : '������',
		width : 70,
		height : 30,
		iconCls : 'page_clearscreen',
		handler : function() {
			clearData();
		}
	});
	
	// ȷ����ť
	var selectBT = new Ext.Toolbar.Button({
		text : 'ȷ��',
		tooltip : 'ȷ��',
		width : 70,
		height : 30,
		iconCls : 'page_gear',
		handler : function() {
			returnData();
		}
	});
	
	// ȡ����ť
	var CancelBT = new Ext.Toolbar.Button({
		text : '�ر�',
		tooltip : '����رձ�����',
		width : 70,
		height : 30,
		iconCls : 'page_close',
		handler : function() {
			payWindow.close();
		}
	});
	
	/**
	 * ��ѯ����
	 */
	function Query() {
		if (payLocRowId == null || payLocRowId.length <= 0) {
			return;
		}
		FindMasterGrid.load();
	}
	
	/**
	 * ��շ���
	 */
	function clearData() {
		Ext.getCmp("FindVendor").setValue("");
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 30));
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("payStatus").setValue("N");
		FindMasterGrid.removeAll();
		FindDetailGrid.removeAll();
		this.gPayRowId="";
	}
	
	var payStatus = new Ext.form.RadioGroup({
		id : 'payStatus',
		columns : 3,
		items:[
			{boxLabel:'ȫ��',name:'payStatus',inputValue:""},
			{boxLabel:'�����',name:'payStatus',inputValue:"Y"},
			{boxLabel:'δ���',name:'payStatus',inputValue:"N",checked:true}
		]
	});
	
	var FindMasterColumns = [{
			header : "RowId",
			dataIndex : 'pay',
			hidden : true
		}, {
			header : "�����",
			dataIndex : 'payNo',
			width : 120
		}, {
			header : "�ɹ�����",
			dataIndex : 'locDesc',
			width : 120,
			hidden:true
		}, {
			header : "��Ӧ��",
			dataIndex : 'vendorName',
			width : 230
		}, {
			header : "�Ƶ�����",
			dataIndex : 'payDate',
			width : 90,
			align : 'center'
		}, {
			header : "�Ƶ�ʱ��",
			dataIndex : 'payTime',
			width : 90,
			align : 'center'
		}, {
			header : "�Ƶ���",
			dataIndex : 'payUserName',
			width : 90
		}, {
			header : "������",
			dataIndex : 'payAmt',
			xtype : 'numbercolumn',
			width : 90
		}, {
			header : "�Ƿ�ɹ�ȷ��",
			dataIndex : 'ack1Flag',
			xtype : 'checkcolumn',
			mapping:'ack1'
		}, {
			header : "�ɹ�ȷ����",
			dataIndex : 'ack1UserName',
			align : 'center'
		}, {
			header : "�ɹ�ȷ������",
			dataIndex : 'ack1Date',
			align : 'center'
		}, {
			header : "�Ƿ���ȷ��",
			dataIndex : 'ack2Flag',
			xtype : 'checkcolumn',
			mapping:'ack2'
		}, {
			header : "���ȷ����",
			dataIndex : 'ack2UserName',
			align : 'center'
		}, {
			header : "���ȷ������",
			dataIndex : 'ack2Date',
			align : 'center'
		}, {
			header : "֧����ʽ",
			dataIndex : 'payMode'
		}, {
			header : "֧��Ʊ�ݺ�",
			dataIndex : 'checkNo'
		}, {
			header : "֧��Ʊ������",
			dataIndex : 'checkDate',
			align : 'center'
		}, {
			header : "֧��Ʊ�ݽ��",
			dataIndex : 'checkAmt'
		},{
			header : "��ɱ�־",
			dataIndex : 'completed',
			width :60,
			xtype : 'checkcolumn',
			mapping:'payComp'
		}
	];
	
	function FindMasterFn(){
		var sd = Ext.getCmp('StartDate').getValue();
		var ed = Ext.getCmp('EndDate').getValue();
		if(sd!=""){
			sd = sd.format(ARG_DATEFORMAT);
		}
		if(ed!=""){
			ed = ed.format(ARG_DATEFORMAT);
		}
		var vendor = Ext.getCmp('FindVendor').getValue();
		var completed = Ext.getCmp("payStatus").getValue().getGroupValue();
		var StrParam=sd+"^"+ed+"^"+payLocRowId+"^"+vendor+"^"+completed;
		
		return {strParam:StrParam};
	}
	
	function FindSmRowSelFn(){
		var rowData = FindMasterGrid.getSelected();
		gPayRowId = rowData.get("pay");
		FindDetailGrid.load({params:{parref:gPayRowId}});
	}
	
	var FindMasterGrid = new Ext.dhcstm.EditorGridPanel({
		id : 'FindMasterGrid',
		editable : false,
		childGrid : 'FindDetailGrid',
		contentColumns : FindMasterColumns,
		smType : "row",
		singleSelect : true,
		smRowSelFn : FindSmRowSelFn,
		autoLoadStore : true,
		actionUrl : URL,
		queryAction : "query",
		idProperty : "pay",
		paramsFn : FindMasterFn,
		showTBar : false,
		paging : true,
		listeners : {
			dblclick : function(){
				returnData();
			}
		}
	});
	
	var FindDetailColumns = [{
			header : "RowId",
			dataIndex : 'payi',
			hidden : true
		}, {
			header : "����˻�Id",
			dataIndex : 'pointer',
			width : 80,
			hidden : true
		}, {
			header : "����Id",
			dataIndex : 'INCI',
			width : 80,
			hidden : true
		}, {
			header : '���ʴ���',
			dataIndex : 'inciCode',
			width : 80
		}, {
			header : '��������',
			dataIndex : 'inciDesc',
			width : 180
		}, {
			header : "���",
			dataIndex : 'spec',
			width : 80
		}, {
			header : "����",
			dataIndex : 'manf',
			width : 150
		}, {
			header : "����",
			dataIndex : 'qty',
			width : 80,
			align : 'right'
		}, {
			header : "��λ",
			dataIndex : 'uomDesc',
			width : 80,
			align : 'left'
		}, {
			header : "����",
			dataIndex : 'rp',
			width : 60,
			xtype : 'numbercolumn'
		}, {
			header : "�ۼ�",
			dataIndex : 'sp',
			width : 60,
			xtype : 'numbercolumn'
		}, {
			header : "���۽��",
			dataIndex : 'rpAmt',
			xtype : 'numbercolumn'
		}, {
			header : "�ۼ۽��",
			dataIndex : 'spAmt',
			xtype : 'numbercolumn'
		}, {
			header : "�����־",
			dataIndex : 'OverFlag',
			width : 80,
			align : 'center'
		}, {
			header : "��Ʊ��",
			dataIndex : 'invNo'
		}, {
			header : "��Ʊ����",
			dataIndex : 'invDate',
			align : 'center'
		}, {
			header : "��Ʊ���",
			dataIndex : 'invAmt',
			xtype : 'numbercolumn',
			width : 80
		}, {
			header : "����",
			dataIndex : 'batNo',
			width : 80
		}, {
			header : "Ч��",
			dataIndex : 'ExpDate',
			align : 'center'
		}, {
			header : "����",
			dataIndex : 'TransType',
			align : 'center'
		}];
	
	var FindDetailGrid = new Ext.dhcstm.EditorGridPanel({
		id : 'FindDetailGrid',
		editable : false,
		contentColumns : FindDetailColumns,
		smType : "row",
		autoLoadStore : false,
		actionUrl : URL,
		queryAction : "queryItem",
		idProperty : "payi",
		remoteSort : false,
		showTBar : false,
		paging : true
	});
	
	function returnData() {
		if (gPayRowId!=""){
			Fn(gPayRowId);
			payWindow.close();
		}else{
			Msg.info("warning","��ѡ��Ҫ���ص���ⵥ��Ϣ!");
		}
	}
	
	var HisListTab = new Ext.form.FormPanel({
		labelWidth : 60,
		labelAlign : 'right',
		frame : true,
		bodyStyle : 'padding-top:5px;',
		tbar : [SearchBT, '-', ClearBT,'-',selectBT,'-',CancelBT],
		layout: 'fit',
		items : [{
			xtype : 'fieldset',
			title : '��ѯ����',
			layout : 'column',
			autoHeight : true,
			defaults: {columnWidth: 0.25,layout:'form'},
			items : [
				{
					items: [StartDate]
				},{
					items: [EndDate]
				},{
					items: [FindVendor]
				},{
					items: [payStatus]
				}
			]
		}]
	});
	
	var payWindow =  new Ext.Window({
		title : '�����ѯ',
		width : gWinWidth,
		height : gWinHeight+50,
		modal : true,
		layout : 'border',
		items : [
			{
				region: 'north',
				height: 120,
				layout: 'fit',
				items:HisListTab
			}, {
				region: 'center',
				title: '���',
				layout: 'fit',
				items: FindMasterGrid
			}, {
				region: 'south',
				split: true,
				height: 200,
				collapsible: true,
				title: '�����ϸ',
				layout: 'fit',
				items: FindDetailGrid
			}
		]
	});
	payWindow.show();
}