var userdr = session['LOGON.USERID'];
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var projUrl = 'herp.budg.budgpaybillmainsearchexe.csp';
//年度
var YearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['year', 'year'])
		});
YearDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : commonboxUrl +'?action=year',
						method : 'POST'
					});
		});
var yearCombo = new Ext.form.ComboBox({
			fieldLabel : '立项年度',
			store : YearDs,
			displayField : 'year',
			valueField : 'year',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 255,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true,
			listeners:{
				select:{fn:function(combo,record,index) { 
                	projDs.removeAll();
                	projCombo.setValue('');     				
                    projDs.load({params:{start:0,limit:10,year:combo.value,flag:2}});
	           	}}
			}
		});
		
//项目名称
var projDs = new Ext.data.Store({
	
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
projDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=projList',
						method : 'POST'
					});
		});
var projCombo = new Ext.form.ComboBox({
			fieldLabel : '项目名称',
			store : projDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 200,
			listWidth : 255,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});

//申请人
var userDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
userDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : commonboxUrl +'?action=username&year='+yearCombo.getValue(),
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
			pageSize : 10,
			listWidth : 255,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});

//报销单号
var applyNo = new Ext.form.TextField({
			columnWidth : .1,
			width : 70,
			columnWidth : .12,
			selectOnFocus : true

		});

//查询
var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){
	      	var year = yearCombo.getValue();
			var projname = projCombo.getValue();
			var applyer = userCombo.getValue();
			var billcode = applyNo.getValue();
			itemGrid.load({
				params:{start:0
						,limit:25
						,year:year
						,projname:projname
						,billcode:billcode
						,applyer:applyer
			}});
	}
});


var queryPanel = new Ext.FormPanel({
	height : 90,
	region : 'north',
	frame : true,
	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<center><p style="font-weight:bold;font-size:120%">项目支出报销单据查询</p></center>',
			columnWidth : 1,
			height : '32'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [

		{
					xtype : 'displayfield',
					value : '立项年度:',
					columnWidth : .05
				}, yearCombo,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '项目名称:',
					columnWidth : .05
				},projCombo,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '申请人:',
					columnWidth : .05
				}, userCombo, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '申请单号:',
					columnWidth : .05
				}, applyNo

		]
	}]
});

var itemGrid = new dhc.herp.Grid({
			region : 'center',
			url : projUrl,		
			fields : [{
						header : 'ID',
						dataIndex : 'rowid',
						editable:false,
						hidden : true
					},{
			            id : 'CompName',
			        	header : '医疗单位',
						width : 90,
			      		editable : false,
						dataIndex : 'CompName',
						hidden : true
				    }, {
						id : 'Code',
						header : '报销单号',
						width : 80,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},
						dataIndex : 'Code'

					},{
						id : 'Name',
						header : '项目名称',
						editable:false,
						width : 120,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},
						dataIndex : 'Name'

					}, {
						id: 'ProjDR',
						header : '项目ID',
						dataIndex : 'ProjDR',
						editable:false,
						hidden : true
					}, {
						id : 'deprdr',
						header : '报销科室',
						editable:false,
						width : 120,
						dataIndex : 'deprdr'

					},{
						id : 'dname',
						header : '报销人',
						width : 60,
						editable:false,
						dataIndex : 'dname'

					}, {
						id : 'ApplyMoney',
						header : '报销金额',
						width : 60,
						editable : false,
						align:'right',
						dataIndex : 'ApplyMoney'
						
					},{
						id : 'BillState',
						header : '单据状态',
						width : 60,
						align : 'center',
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['BillState']
						if (sf == "新建") {
							return '<span style="color:blue;cursor:hand"><u>'+value+'</u></span>';
						} else if (sf == "提交"){
							return '<span style="color:brown;cursor:hand"><u>'+value+'</u></span>';
						}else {
							return '<span style="color:black;cursor:hand"><u>'+value+'</u></span>';
						}},
						dataIndex : 'BillState'

					},{
						id : 'Desc',
						header : '报销说明',
						width : 80,
						editable:false,
						//hidden:true,
						dataIndex : 'Desc'

					},{
						id : 'budgco',
						header : '预算结余',
						width : 60,
						editable:false,
						align:'right',
						dataIndex : 'budgco'

					},{
						id : 'budgcotrol',
						header : '预算控制',
						width : 60,
						editable:false,
						hidden:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['budgcotrol']
						if (sf == "超出预算") {
							return '<span style="color:red;cursor:hand;">'+value+'</span>';
						} else {
							return '<span style="color:black;cursor:hand">'+value+'</span>';
						}},
						dataIndex : 'budgcotrol'

					},{
						id : 'Year',
						header : '立项年度',
						width : 60,
						editable:false,
						align:'right',
						hidden:true,
						dataIndex : 'Year'

					}],
					xtype : 'grid',
					loadMask : true,
					viewConfig : {forceFit : true},
					tbar : [findButton ]

		});

    itemGrid.btnAddHide();  //隐藏增加按钮
   	itemGrid.btnSaveHide();  //隐藏保存按钮
    itemGrid.btnResetHide();  //隐藏重置按钮
    itemGrid.btnDeleteHide(); //隐藏删除按钮
    itemGrid.btnPrintHide();  //隐藏打印按钮


itemGrid.load({params:{start:0, limit:12,userdr:userdr}});


// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {

 	//单击报销单号
	if (columnIndex == 3) {		
		var records = itemGrid.getSelectionModel().getSelections();
		var rowid = records[0].get("rowid")
		var Code  		 = records[0].get("Code");
		var deprdr  	 = records[0].get("deprdr");
		var dname  		 = records[0].get("dname");
		var Name  		 = records[0].get("Name");
		var Desc  		 = records[0].get("Desc");
		var year  		 = records[0].get("Year");
	
		applyFun(rowid,Code,dname,deprdr,Name,Desc,year);
	}
	
	//单击项目名称
	if (columnIndex == 4) {
		var records = itemGrid.getSelectionModel().getSelections();
		var FundBillDR   = records[0].get("rowid");
		var ProjDR		 = records[0].get("ProjDR");
		var Name		 = records[0].get("Name");
		detailFun(FundBillDR,ProjDR,Name);
	}
	//单击单据状态
	if (columnIndex == 9) {
		var records = itemGrid.getSelectionModel().getSelections();
		var FundBillDR   = records[0].get("rowid");
		var Code  		 = records[0].get("Code");
		var Name		 = records[0].get("Name");
		stateFun(FundBillDR,Code,Name);
	}

});