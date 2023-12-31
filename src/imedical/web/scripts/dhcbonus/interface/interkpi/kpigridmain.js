var KPIUrl = '../csp/dhc.bonus.interkpiexe.csp';
var KPIProxy = new Ext.data.HttpProxy({
			url : KPIUrl + '?action=kpilist'
		});

// 业务类别数据源
var KPIDs = new Ext.data.Store({
			proxy : KPIProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['rowid', 'name', 'code', 'InterMaprowid',
							'InterTargetDr', 'InterTargetCode',
							'InterTargetName', 'inLocSetDr', 'InterLocSetname','InterTargetemark','okrDr','TargetTypeID','TargetTypeName']),
			remoteSort : true
		});

KPIDs.setDefaultSort('rowid', 'asc');

var KPICm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),  
	 {
			header : '接口套',
			dataIndex : 'InterLocSetname',
			width : 100,
			sortable : true
		},{
			header : '奖金指标编码',
			dataIndex : 'code',
			width : 70,
			sortable : true
		}, {
			header : '奖金指标名称',
			dataIndex : 'name',
			width : 120,
			sortable : true
		},{
			header : '接口指标编码',
			dataIndex : 'InterTargetCode',
			width : 70,
			sortable : true
		}, {
			header : '接口指标名称',
			dataIndex : 'InterTargetName',
			width : 110,
			sortable : true
		},{
			header : '接口指标描述',
			dataIndex : 'InterTargetemark',
			width : 150,
			sortable : true
		}]);
		
		
var KPISearchField = 'name';

var KPIFilterItem = new Ext.Toolbar.MenuButton({
			text : '过滤器',
			tooltip : '关键字所属类别',
			menu : {
				items : [new Ext.menu.CheckItem({
									text : '代码',
									value : 'code',
									checked : false,
									group : 'KPIFilter',
									checkHandler : onBusItemItemCheck
								}), new Ext.menu.CheckItem({
									text : '名称',
									value : 'name',
									checked : true,
									group : 'KPIFilter',
									checkHandler : onBusItemItemCheck
								})]
			}
		});
function onBusItemItemCheck(item, checked) {
	if (checked) {
		KPISearchField = item.value;
		KPIFilterItem.setText(item.text + ':');
	}
};

var KPISearchBox = new Ext.form.TwinTriggerField({// 查找按钮
	width : 100,
	trigger1Class : 'x-form-clear-trigger',
	trigger2Class : 'x-form-search-trigger',
	emptyText : '搜索...',
	listeners : {
		specialkey : {
			fn : function(field, e) {
				var key = e.getKey();
				if (e.ENTER === key) {
					this.onTrigger2Click();
				}
			}
		}
	},
	grid : this,
	onTrigger1Click : function() {
		if (this.getValue()) {
			this.setValue('');
			KPIDs.proxy = new Ext.data.HttpProxy({
						url : KPIUrl + '?action=kpilist&sort=rowid&dir=asc'
					});
			KPIDs.load({
						params : {
							start : 0,
							limit : KPIPagingToolbar.pageSize
						}
					});
		}
	},
	onTrigger2Click : function() {
		if (this.getValue()) {
			KPIDs.proxy = new Ext.data.HttpProxy({
						url : KPIUrl + '?action=kpilist&searchField='
								+ KPISearchField + '&searchValue='
								+ this.getValue() + '&sort=rowid&dir=asc'
					});
			KPIDs.load({
						params : {
							start : 0,
							limit : KPIPagingToolbar.pageSize
						}
					});
		}
	}
});
var KPIPagingToolbar = new Ext.PagingToolbar({// 分页工具栏
	pageSize : 25,
	store : KPIDs,
	displayInfo : true,
	displayMsg : '当前显示{0} - {1}，共计{2}',
	emptyMsg : "没有数据",
	buttons : [KPIFilterItem, '-', KPISearchBox],
	doLoad : function(C) {
		var B = {}, A = this.paramNames;
		B[A.start] = C;
		B[A.limit] = this.pageSize;
		B['dir'] = "asc";
		B['sort'] = "rowid";
		if (this.fireEvent("beforechange", this, B) !== false) {
			this.store.load({
						params : B
					});
		}
	}
});

//添加按钮 zlg
var add_Button = new Ext.Toolbar.Button({
	text: '添加指标映射',
    tooltip:'添加指标映射',        
    iconCls:'add',
	handler:function(){

		addFun(KPIGrid,KPIDs,KPIGrid,KPIPagingToolbar);
	}
});

//修改按钮 zlg
var edit_Button = new Ext.Toolbar.Button({
	text: '修改指标映射',
    tooltip:'修改指标映射',        
    iconCls:'add',
	handler:function(){
		var rowObj = KPIGrid.getSelections();
		var InterMaprowid=rowObj[0].get("InterMaprowid");
		
		if (InterMaprowid==""){
			Ext.Msg.show({title:'注意',msg:'没有映射的接口指标，不能修改!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
			
		}
		editFun(KPIGrid,KPIDs,KPIGrid,KPIPagingToolbar);
	}
});

//删除按钮
var del_Button = new Ext.Toolbar.Button({
	text: '删除指标映射',
    tooltip:'删除指标映射',        
    iconCls:'remove',
	handler:function(){
		var rowObj = KPIGrid.getSelections();
		var InterMaprowid=rowObj[0].get("InterMaprowid");
		var len = rowObj.length;
		if(InterMaprowid==""){
			Ext.Msg.show({title:'注意',msg:'没有映射的接口指标，不需要删除!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('提示','确定要删除选定的行?',
				function(btn) {
					if(btn == 'yes'){
						var active=rowObj[0].get("active");

							Ext.Ajax.request({
								url:KPIUrl+'?action=del&rowid='+rowObj[0].get("InterMaprowid"),
								waitMsg:'删除中...',
								failure: function(result, request) {
									Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true') {
										Ext.Msg.show({title:'提示',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
										KPIDs.load({params:{start:0, limit:KPIPagingToolbar.pageSize,KPIDr:KPIGrid.getSelections()[0].get("rowid"),sort:"rowid",dir:"asc"}});
									}else{
										Ext.Msg.show({title:'提示',msg:'删除失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									}
								},
								scope: this
							});
						
					}
				}
			)
		}
	}
});

var KPIGrid = new Ext.grid.GridPanel({// 表格
	title : '奖金指标记录',
	region: 'center',
	width : 750,
	minSize : 350,
	maxSize : 450,
	split : true,
	collapsible : true,
	containerScroll : true,
	xtype : 'grid',
	store : KPIDs,
	cm : KPICm,
	trackMouseOver : true,
	stripeRows : true,
	sm : new Ext.grid.RowSelectionModel({
				singleSelect : true
			}),
	loadMask : true,
	viewConfig : {
		forceFit : true
	},
	tbar: [add_Button,'-',edit_Button,'-',del_Button],
	bbar : KPIPagingToolbar
});

KPIDs.load({
			params : {
				start : 0,
				limit : KPIPagingToolbar.pageSize
			}
		});

var KPIRowId = "";
var KPIName = "";
/*
KPIGrid.on('rowclick', function(grid, rowIndex, e) {
			// 单击接口套后刷指标记录
			var selectedRow = KPIDs.data.items[rowIndex];

			KPIRowId = selectedRow.data["rowid"];
			KPIName = selectedRow.data["name"];
			interKpiGrid.setTitle(KPIName + "-所对应指标记录");
			interKpiDs.proxy = new Ext.data.HttpProxy({
						url : KPIUrl + '?action=outkpirulelist&interkpi='
								+ KPIRowId + '&sort=rowid&dir=asc'
					});
			interKpiDs.load({
						params : {
							start : 0,
							limit : interKpiPagingToolbar.pageSize
						}
					});
		});

KPIDs.on("beforeload", function(ds) {
			interKpiDs.removeAll();
			KPIRowId = "";
			interKpiGrid.setTitle("指标信息");
		});
*/