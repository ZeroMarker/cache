var userdr = session['LOGON.USERID'];
// 年度///////////////////////////////////
var projUrl = 'herp.budg.budgctrlfundbillsearchexe.csp';
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
// 申请年月
var YearDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
		totalProperty : "results",
		root : 'rows'
	}, [ 'rowid', 'name' ])
});

YearDs.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
		url : projUrl + '?action=yearList',
		method : 'POST'
	});
});

var yearCombo = new Ext.form.ComboBox({
	fieldLabel : '申请年月',
	store : YearDs,
	displayField : 'name',
	valueField : 'rowid',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 100,
	listWidth : 225,
	pageSize : 12,
	minChars : 1,
	columnWidth : .1,
	selectOnFocus : true
});
// 工号
var CodeDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
		totalProperty : "results",
		root : 'rows'
	}, [ 'rowid', 'code' ])
});

CodeDs.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
		url : projUrl + '?action=usercode',
		method : 'POST'
	});
});

var codeCombo = new Ext.form.ComboBox({
	fieldLabel : '工号',
	store : CodeDs,
	displayField : 'code',
	valueField : 'code',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 80,
	listWidth : 225,
	pageSize : 10,
	minChars : 1,
	columnWidth : .1,
	selectOnFocus : true
});



// 申请科室
var DeptDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
		totalProperty : "results",
		root : 'rows'
	}, [ 'rowid', 'name' ])
});

DeptDs.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
		url : commonboxUrl + '?action=dept',
		method : 'POST'
	});
});

var deptCombo = new Ext.form.ComboBox({
	fieldLabel : '科室名称',
	store : DeptDs,
	displayField : 'name',
	valueField : 'rowid',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 100,
	listWidth : 225,
	pageSize : 10,
	minChars : 1,
	columnWidth : .1,
	selectOnFocus : true
});

// ////////////项目名称////////////////////////
var userDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
		totalProperty : "results",
		root : 'rows'
	}, [ 'rowid', 'name' ])
});

userDs.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
		url : commonboxUrl + '?action=username&flag=2',
		method : 'POST'
	});
});

var userCombo = new Ext.form.ComboBox({
	fieldLabel : '申请人',
	store : userDs,
	displayField : 'name',
	valueField : 'rowid',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 100,
	listWidth : 225,
	pageSize : 10,
	minChars : 1,
	columnWidth : .1,
	selectOnFocus : true
});
// ///////////////////申请单号/////////////////////////
var applyNo = new Ext.form.TextField({
	columnWidth : .1,
	width : 70,
	columnWidth : .12,
	selectOnFocus : true

});

////////////////有否冲销/////////////////
/*var isCost = new Ext.form.Checkbox({
						id : 'isCost',
						fieldLabel: '有否冲销'
					});	
*/					
var isCost = new Ext.form.ComboBox({
    id: 'isCost',
    fieldLabel: '是否有申请单：',
    name: 'isCost',
    width:100,
    triggerAction : 'all',  
    lazyRender : true,  
    mode : 'local',
    store: new Ext.data.SimpleStore({
	  fields:['key','value'],
	  data:[['1','部分冲销'],['2','全部冲销'],['3','未冲销'],['','全部']]
     }),
    displayField: 'value',
    valueField: 'key',
    emptyText:'请选择...',
    selectOnFocus:true,
    forceSelection:'true',
    editable:true
});
			
var findButton = new Ext.Toolbar.Button({
	text : '查询',
	tooltip : '查询',
	iconCls : 'option',
	handler : function() {
		var year = yearCombo.getValue();
		var dept = deptCombo.getValue();
		var username = userCombo.getValue();
		var billcode = applyNo.getValue();
		var code = codeCombo.getValue();
		var cost = isCost.getValue();
		
		//alert(cost);

		itemGrid.load({
			params : {
				start : 0,
				limit : 25,
				year : year,
				dept : dept,
				username : username,
				code : code,
				cost : cost,
				billcode : billcode
			}
		});
	}
});

var addButton = new Ext.Toolbar.Button({
	text : '添加',
	tooltip : '添加',
	iconCls : 'add',
	handler : function() {
		addFun();
	}

});

var queryPanel = new Ext.FormPanel(
		{
			height : 90,
			region : 'north',
			frame : true,

			defaults : {
				bodyStyle : 'padding:5px'
			},
			items : [
					{
						xtype : 'panel',
						layout : "column",
						items : [ {
							xtype : 'displayfield',
							value : '<center><p style="font-weight:bold;font-size:120%">资金申请单查询</p></center>',
							columnWidth : 1,
							height : '32'
						} ]
					}, {
						columnWidth : 1,
						xtype : 'panel',
						layout : "column",
						items : [ {
							xtype : 'displayfield',
							value : '申请年月:',
							columnWidth : .05
						}, yearCombo,{
							xtype : 'displayfield',
							value : '',
							columnWidth : .02
						}, {
							xtype : 'displayfield',
							value : '科室名称:',
							columnWidth : .05
						}, deptCombo,
						{
							xtype : 'displayfield',
							value : '',
							columnWidth : .02
						}, {
							xtype : 'displayfield',
							value : '申请人:',
							columnWidth : .05
						}, userCombo, 
						{
							xtype : 'displayfield',
							value : '',
							columnWidth : .02
						},
						{
							xtype : 'displayfield',
							value : '工号:',
							columnWidth : .03
						}, codeCombo,{
							xtype : 'displayfield',
							value : '',
							columnWidth : .02
						}, {
							xtype : 'displayfield',
							value : '申请单号:',
							columnWidth : .05
						}, applyNo,
						{
							xtype : 'displayfield',
							value : '',
							columnWidth : .01
						}, {
							xtype : 'displayfield',
							value : '是否冲销:',
							columnWidth : .05
						},isCost
//						,{
//							xtype : 'displayfield',
//							value : '',
//							columnWidth : .02
//						}, findButton
						
						]
					} ]
		});

var itemGrid = new dhc.herp.Grid(
		{
			atload : true,
			region : 'center',
			url : 'herp.budg.budgctrlfundbillsearchexe.csp',
			listeners : {
				'cellclick' : function(grid, rowIndex, columnIndex, e) {
					var record = grid.getStore().getAt(rowIndex);
					// 根据条件设置单元格点击编辑是否可用
					
					if ((record.get('chequecode') != "") && (columnIndex == 2)) {
						
						return false;
					} else {
						return true;
					}
				},
				'celldblclick' : function(grid, rowIndex, columnIndex, e) {
					var record = grid.getStore().getAt(rowIndex);
					// 预算项目公式编辑
					if ((record.get('chequecode') != null) && (columnIndex == 2)) {
						return false;
					} else {
						return true;
					}
				}
			},
			fields : [
					{
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					},
					/*
					{
						id : 'submit',
						header : '选择',
						dataIndex : 'submit',
						width : 90,
						align : 'center',
						editable : false,
						renderer : function(value, cellmeta, record, rowIndex,
								columnIndex, store) {
							var sf = record.data['chequecode'];
							if (sf == "") {
								return '<span style="color:blue;cursor:hand"><u>发放支票</u></span>';
							} else {
								return '<span style="color:gray;cursor:hand"><u>发放支票</u></span>';
							}
						},
//						 renderer : function(value,cellmeta, record,rowIndex,
//						 columnIndex, store) {
//						 var sf = record.data['BillState']
//						 if (sf != "提交") {
//						 //cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
//						 return '<span
//						 style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
//						 } else {
//						 return '<span
//						 style="color:gray;cursor:hand">'+value+'</span>';
//						 }},
						hidden : false

					},
					*/
					{
						id : 'CompName',
						header : '医疗单位',
						width : 80,
						editable : false,
						dataIndex : 'CompName'

					},
					{
						id : 'yearmonth',
						header : '年月',
						width : 70,
						editable : false,
						dataIndex : 'yearmonth'

					},
					{
						id : 'code',
						header : '申请单号',
						width : 120,
						editable : false,
						allowBlank : false,
						dataIndex : 'code'

					},
					{
						id : 'dname',
						header : '申请科室',
						editable : false,
						width : 120,
						dataIndex : 'dname'

					},
					{
						id : 'uName',
						header : '申请人',
						width : 100,
						editable : false,
						dataIndex : 'uName'

					},
					{
						id : 'ApplyMoney',
						header : '申请额度',
						xtype:'numbercolumn',
						width : 120,
						editable : false,
						align : 'right',
						dataIndex : 'ApplyMoney'
					},
					{
						id : 'ReplyMoney',
						xtype:'numbercolumn',
						header : '审批额度',
						width : 120,
						editable : false,
						align : 'right',
						dataIndex : 'ReplyMoney'

					},
					{
						id : 'ApplyDate',
						header : '申请时间',
						width : 90,
						editable : false,
						dataIndex : 'ApplyDate'
					},
					{
						id : 'BillState',
						header : '单据状态',
						width : 60,
						align : 'center',
						editable : false,
						renderer : function(value, cellmeta, record, rowIndex,
								columnIndex, store) {
							var sf = record.data['BillState']
							if (sf == "0") {
								return '<span style="color:blue;cursor:hand"><u>'
										+ '没有通过' + '</u></span>';
							} else if (sf == "1") {
								return '<span style="color:brown;cursor:hand"><u>'
										+ '通过' + '</u></span>';
							} else {
								return '<span style="color:black;cursor:hand"><u>'
										+ '撤销' + '</u></span>';
							}
						},
						dataIndex : 'BillState'

					},
					{
						id : 'Desc',
						header : '资金申请说明',
						width : 120,
						editable : true,
						// hidden:true,
						dataIndex : 'Desc'

					},
					{
						id : 'budgco',
						xtype:'numbercolumn',
						header : '预算结余',
						width : 120,
						editable : false,
						align : 'right',
						dataIndex : 'budgco'

					},
					{
						id : 'budgcotrol',
						header : '预算控制',
						width : 80,
						editable : false,
						hidden : false,
						renderer : function(value, cellmeta, record, rowIndex,
								columnIndex, store) {
							var sf = record.data['budgco']
							
							if(sf>=0){
								return '<span style="color:black;cursor:hand;">'
								+ '预算内' + '</span>';
							}else{
								return '<span style="color:red;cursor:hand">'
								+ '预算外' + '</span>';
							}
							
						},
						dataIndex : 'budgcotrol'

					}, {
						id : 'chequecode',
						header : '支票号',
						width : 100,
						editable : false,
						// hidden:true,
						dataIndex : 'chequecode'

					}, {
						id : 'chequedate',
						header : '支票发放日期',
						width : 90,
						editable : false,
						// hidden:true,
						dataIndex : 'chequedate'

					}, {
						id : 'afforder',
						header : '发放人',
						width : 120,
						editable : false,
						// hidden:true,
						dataIndex : 'afforder'

					} ],
			xtype : 'grid',
			loadMask : true,
			// viewConfig : {forceFit : true},
//			tbar : [ '-', findButton, '-', addButton ]
		tbar : [ findButton]

		});

itemGrid.btnAddHide(); // 隐藏增加按钮
itemGrid.btnSaveHide(); // 隐藏保存按钮
itemGrid.btnResetHide(); // 隐藏重置按钮
itemGrid.btnDeleteHide(); // 隐藏删除按钮
itemGrid.btnPrintHide(); // 隐藏打印按钮

itemGrid.load({
	params : {
		start : 0,
		limit : 12,
		userdr : userdr
	}
});

// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	// alert(columnIndex);

//	if (columnIndex == 5) {
//		var records = itemGrid.getSelectionModel().getSelections();
//		var FundBillDR = records[0].get("rowid");
//		var Name = records[0].get("Name");
//		detailFun(FundBillDR, Name);
//	}

	if (columnIndex ==10) {
		var records = itemGrid.getSelectionModel().getSelections();
		var FundBillDR = records[0].get("rowid");
		var Code = records[0].get("code");
		var Name = records[0].get("BillState");
		stateFun(FundBillDR, Code, Name);
	}

	//if (columnIndex == 2) {
		
	//	var records = itemGrid.getSelectionModel().getSelections();
	//	var FundBillDR = records[0].get("rowid");
	//	var Code = records[0].get("code");
	//	var Name = records[0].get("Name");
	//	savefun(FundBillDR, Code);
	//}

});
