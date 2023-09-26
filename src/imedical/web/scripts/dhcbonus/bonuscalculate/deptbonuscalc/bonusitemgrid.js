var jxUnitUrl = '../csp/dhc.pa.deptschemexe.csp';
var jxUnitProxy;

// 绩效单元
var bonusItemDs = new Ext.data.Store({
			proxy : jxUnitProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['d1', 'd2', 'd3']),
			remoteSort : true
		}); 

var jxUnitCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
			header : '核算单元代码',
			dataIndex : 'parRefCode',
			width : 120,
			sortable : true
		}, {
			header : "核算单元名称",
			dataIndex : 'parRefName',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			header : "实发奖金",
			dataIndex : 'jxLocTypeName',
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
		// buttons:[jxUnitFilterItem,'-',jxUnitSearchBox],
		/*
		 * doLoad:function(C){ var B={}, A=this.paramNames; B[A.start]=C;
		 * B[A.limit]=this.pageSize;
		 * B['schemDr']=SchemGrid.getSelections()[0].get("rowid");
		 * B['dir']="asc"; B['sort']="rowid";
		 * if(this.fireEvent("beforechange",this,B)!==false){
		 * this.store.load({params:B}); } }
		 */
});

var bonusitemgrid = new Ext.grid.GridPanel({// 表格
	title : '方案奖金核算项',
	region : 'center',
	xtype : 'grid',
	height : 600,
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
