
// /描述: 付款单制单查询
// /编写者：gwj
// /编写日期: 2012.09.24
// 2014-08-06 改写成window格式
var payWindow = null;
function QueryPay(payLocRowId,Fn){
	var URL="dhcstm.payaction.csp";
	
	// 起始日期
	var StartDate = new Ext.ux.DateField({
		fieldLabel : '起始日期',
		id : 'StartDate',
		name : 'StartDate',
		anchor : '90%',
		
		width : 120,
		value : new Date().add(Date.DAY, - 30)
	});
	
	// 截止日期
	var EndDate = new Ext.ux.DateField({
		fieldLabel : '截止日期',
		id : 'EndDate',
		name : 'EndDate',
		anchor : '90%',
		
		width : 120,
		value : new Date()
	});
	
	var FindVendor = new Ext.ux.VendorComboBox({
		fieldLabel : '供应商',
		id : 'FindVendor',
		name : 'FindVendor',
		anchor : '90%',
		emptyText : '供应商...',
		valueParams : {LocId : payLocRowId}
	});
	
	// 查询按钮
	var SearchBT = new Ext.Toolbar.Button({
		text : '查询',
		tooltip : '点击查询',
		width : 70,
		height : 30,
		iconCls : 'page_find',
		handler : function() {
			Query();
		}
	});
	// 清空按钮
	var ClearBT = new Ext.Toolbar.Button({
		text : '清空',
		tooltip : '点击清空',
		width : 70,
		height : 30,
		iconCls : 'page_clearscreen',
		handler : function() {
			clearData();
		}
	});
	
	// 确定按钮
	var selectBT = new Ext.Toolbar.Button({
		text : '确定',
		tooltip : '确定',
		width : 70,
		height : 30,
		iconCls : 'page_gear',
		handler : function() {
			returnData();
		}
	});
	
	// 取消按钮
	var CancelBT = new Ext.Toolbar.Button({
		text : '关闭',
		tooltip : '点击关闭本窗口',
		width : 70,
		height : 30,
		iconCls : 'page_close',
		handler : function() {
			payWindow.close();
		}
	});
	
	/**
	 * 查询方法
	 */
	function Query() {
		if (payLocRowId == null || payLocRowId.length <= 0) {
			return;
		}
		FindMasterGrid.load();
	}
	
	/**
	 * 清空方法
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
			{boxLabel:'全部',name:'payStatus',inputValue:""},
			{boxLabel:'已完成',name:'payStatus',inputValue:"Y"},
			{boxLabel:'未完成',name:'payStatus',inputValue:"N",checked:true}
		]
	});
	
	var FindMasterColumns = [{
			header : "RowId",
			dataIndex : 'pay',
			hidden : true
		}, {
			header : "付款单号",
			dataIndex : 'payNo',
			width : 120
		}, {
			header : "采购部门",
			dataIndex : 'locDesc',
			width : 120,
			hidden:true
		}, {
			header : "供应商",
			dataIndex : 'vendorName',
			width : 230
		}, {
			header : "制单日期",
			dataIndex : 'payDate',
			width : 90,
			align : 'center'
		}, {
			header : "制单时间",
			dataIndex : 'payTime',
			width : 90,
			align : 'center'
		}, {
			header : "制单人",
			dataIndex : 'payUserName',
			width : 90
		}, {
			header : "付款金额",
			dataIndex : 'payAmt',
			xtype : 'numbercolumn',
			width : 90
		}, {
			header : "是否采购确认",
			dataIndex : 'ack1Flag',
			xtype : 'checkcolumn',
			mapping:'ack1'
		}, {
			header : "采购确认人",
			dataIndex : 'ack1UserName',
			align : 'center'
		}, {
			header : "采购确认日期",
			dataIndex : 'ack1Date',
			align : 'center'
		}, {
			header : "是否会计确认",
			dataIndex : 'ack2Flag',
			xtype : 'checkcolumn',
			mapping:'ack2'
		}, {
			header : "会计确认人",
			dataIndex : 'ack2UserName',
			align : 'center'
		}, {
			header : "会计确认日期",
			dataIndex : 'ack2Date',
			align : 'center'
		}, {
			header : "支付方式",
			dataIndex : 'payMode'
		}, {
			header : "支付票据号",
			dataIndex : 'checkNo'
		}, {
			header : "支付票据日期",
			dataIndex : 'checkDate',
			align : 'center'
		}, {
			header : "支付票据金额",
			dataIndex : 'checkAmt'
		},{
			header : "完成标志",
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
			header : "入库退货Id",
			dataIndex : 'pointer',
			width : 80,
			hidden : true
		}, {
			header : "物资Id",
			dataIndex : 'INCI',
			width : 80,
			hidden : true
		}, {
			header : '物资代码',
			dataIndex : 'inciCode',
			width : 80
		}, {
			header : '物资名称',
			dataIndex : 'inciDesc',
			width : 180
		}, {
			header : "规格",
			dataIndex : 'spec',
			width : 80
		}, {
			header : "厂商",
			dataIndex : 'manf',
			width : 150
		}, {
			header : "数量",
			dataIndex : 'qty',
			width : 80,
			align : 'right'
		}, {
			header : "单位",
			dataIndex : 'uomDesc',
			width : 80,
			align : 'left'
		}, {
			header : "进价",
			dataIndex : 'rp',
			width : 60,
			xtype : 'numbercolumn'
		}, {
			header : "售价",
			dataIndex : 'sp',
			width : 60,
			xtype : 'numbercolumn'
		}, {
			header : "进价金额",
			dataIndex : 'rpAmt',
			xtype : 'numbercolumn'
		}, {
			header : "售价金额",
			dataIndex : 'spAmt',
			xtype : 'numbercolumn'
		}, {
			header : "结清标志",
			dataIndex : 'OverFlag',
			width : 80,
			align : 'center'
		}, {
			header : "发票号",
			dataIndex : 'invNo'
		}, {
			header : "发票日期",
			dataIndex : 'invDate',
			align : 'center'
		}, {
			header : "发票金额",
			dataIndex : 'invAmt',
			xtype : 'numbercolumn',
			width : 80
		}, {
			header : "批号",
			dataIndex : 'batNo',
			width : 80
		}, {
			header : "效期",
			dataIndex : 'ExpDate',
			align : 'center'
		}, {
			header : "类型",
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
			Msg.info("warning","请选择要返回的入库单信息!");
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
			title : '查询条件',
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
		title : '付款单查询',
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
				title: '付款单',
				layout: 'fit',
				items: FindMasterGrid
			}, {
				region: 'south',
				split: true,
				height: 200,
				collapsible: true,
				title: '付款单明细',
				layout: 'fit',
				items: FindDetailGrid
			}
		]
	});
	payWindow.show();
}