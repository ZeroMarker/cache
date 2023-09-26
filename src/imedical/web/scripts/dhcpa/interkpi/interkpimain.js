var interKpiUrl = 'dhc.pa.interkpiexe.csp';
var interKpiProxy;

//外部指标
var interKpiDs = new Ext.data.Store({
	proxy: interKpiProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'rowid','KPIDr','kpirule','KPIName','code','name','locSetDr','locSetName','remark','active'
	]),
	remoteSort: true
});

interKpiDs.setDefaultSort('rowid', 'asc');
var interKpiCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: 'KPI指标代码',
		dataIndex: 'code',
		width: 120,
		align: 'left',
		sortable: true
	},{
		header: "KPI指标名称",
		dataIndex: 'name',
		width: 120,
		align: 'left',
		sortable: true
	},/*{
		header: "备注",
		dataIndex: 'remark',
		width: 120,
		align: 'left',
		sortable: true
	},*/{
		header: "有效标志",
		dataIndex: 'active',
		width: 120,
		align: 'center',
		sortable: true,
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	}
]);


//添加按钮
var addButton = new Ext.Toolbar.Button({
	text: '添加KPI指标',
    tooltip:'添加KPI指标',        
    iconCls:'add',
	handler:function(){
		addFun(KPIGrid,interKpiDs,interKpiGrid,interKpiPagingToolbar);
	}
});

//修改按钮
var editButton = new Ext.Toolbar.Button({
	text: '修改KPI指标',
    tooltip:'修改KPI指标',        
    iconCls:'add',
	handler:function(){
		editFun(KPIGrid,interKpiDs,interKpiGrid,interKpiPagingToolbar);
	}
});

//删除按钮
var delButton = new Ext.Toolbar.Button({
	text: '删除KPI指标',
    tooltip:'删除KPI指标',        
    iconCls:'remove',
	handler:function(){
		var rowObj = interKpiGrid.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的KPI指标记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('提示','确定要删除选定的行?',
				function(btn) {
					if(btn == 'yes'){
						var active=rowObj[0].get("active");
						if((active=="Y")||(active=="Yes")){
							Ext.Msg.show({title:'提示',msg:'该数据有效,不能删除!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							return false;
						}else{
							Ext.Ajax.request({
								url:KPIUrl+'?action=del&rowid='+rowObj[0].get("rowid"),
								waitMsg:'删除中...',
								failure: function(result, request) {
									Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true') {
										Ext.Msg.show({title:'提示',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
										interKpiDs.load({params:{start:0, limit:interKpiPagingToolbar.pageSize,KPIDr:KPIGrid.getSelections()[0].get("rowid"),sort:"rowid",dir:"asc"}});
									}else{
										Ext.Msg.show({title:'提示',msg:'删除失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									}
								},
								scope: this
							});
						}
					}
				}
			)
		}
	}
});

var interKpiSearchField = 'name';

var interKpiFilterItem = new Ext.Toolbar.MenuButton({
	text: '过滤器',
	tooltip: '关键字所属类别',
	menu: {items: [
		new Ext.menu.CheckItem({ text: '代码',value: 'code',checked: false,group: 'interKpiFilter',checkHandler: onBusItemItemCheck }),
		new Ext.menu.CheckItem({ text: '名称',value: 'name',checked: false,group: 'interKpiFilter',checkHandler: onBusItemItemCheck })
	]}
});
function onBusItemItemCheck(item, checked)
{
	if(checked) {
		interKpiSearchField = item.value;
		interKpiFilterItem.setText(item.text + ':');
	}
};

var interKpiSearchBox = new Ext.form.TwinTriggerField({//查找按钮
	width: 180,
	trigger1Class: 'x-form-clear-trigger',
	trigger2Class: 'x-form-search-trigger',
	emptyText:'搜索...',
	listeners: {
		specialkey: {fn:function(field, e) {
			var key = e.getKey();
		if(e.ENTER === key) {this.onTrigger2Click();}}}
		},
		grid: this,
		onTrigger1Click: function() {
			if(this.getValue()) {
				this.setValue('');
				interKpiDs.proxy = new Ext.data.HttpProxy({url:interKpiUrl+'?action=outkpirulelist&interkpi='+KPISetGrid.getSelections()[0].get("rowid")+'&sort=rowid&dir=asc'});
				interKpiDs.load({params:{start:0, limit:interKpiPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				interKpiDs.proxy = new Ext.data.HttpProxy({
				url: interKpiUrl+'?action=outkpirulelist&interkpi='+KPIGrid.getSelections()[0].get("rowid")+'&searchField='+interKpiSearchField+'&searchValue='+encodeURIComponent(this.getValue())+'&sort=rowid&dir=asc'});
				interKpiDs.load({params:{start:0, limit:interKpiPagingToolbar.pageSize}});
			}
		}
	});
	var interKpiPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize:25,
		store:interKpiDs,
		displayInfo:true,
		displayMsg:'当前显示{0} - {1}，共计{2}',
		emptyMsg:"没有数据",
		buttons:[interKpiFilterItem,'-',interKpiSearchBox],
		doLoad:function(C){
			var B={},
			A=this.paramNames;
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['interkpi']=KPIGrid.getSelections()[0].get("rowid");
			B['dir']="asc";
			B['sort']="rowid";
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
	});
	var interKpiGrid = new Ext.grid.GridPanel({//表格
		title: 'KPI指标信息',
		region: 'center',
		xtype: 'grid',
		store: interKpiDs,
		cm: interKpiCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		viewConfig: {forceFit:true},
		tbar: [addButton,'-',editButton,'-',delButton],
		bbar: interKpiPagingToolbar
	});