var jxUnitUrl="herp.acct.acctPersonnelWagesexe.csp";
var jxUnitProxy;
var tmpStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : ''
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}),
			remoteSort : true
		});


var wagesitemDs = new Ext.data.Store({
			proxy : jxUnitProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['d1', 'd2', 'd3']),
			remoteSort : true
		}); 

var jxUnitCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
			header : '<div style="text-align:center">工资方案名称</div>',
			dataIndex : 'SchemeName',
			width : 130,
			sortable : true
		}, {
			header : '<div style="text-align:center">科室名称</div>',
			dataIndex : 'DeptName',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			header : '<div style="text-align:center">备注</div>',
			dataIndex : 'Remark',
			width : 120,
			align : 'left',
			sortable : true
		}]);

var jxUnitPagingToolbar = new Ext.PagingToolbar({// 分页工具栏
	pageSize : 20,
	store : tmpStore,
	displayInfo : true,
	displayMsg : '当前显示{0} - {1}，共计{2}',
	emptyMsg : "没有数据"
});

var wagesitemgrid = new Ext.grid.GridPanel({// 表格
	title : '工资方案明细信息',
	 iconCls:'list',
	region : 'south',
	xtype : 'grid',
	height : 300,
	width : 1000,
	store : tmpStore,
	cm : jxUnitCm,
	trackMouseOver : true,
	stripeRows : true,
	sm : new Ext.grid.RowSelectionModel({
				singleSelect : true
			}),
	loadMask : true,
	bbar : jxUnitPagingToolbar
});
