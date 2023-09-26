var SchemUrl = 'dhc.pa.schemexe.csp';
var SchemProxy = new Ext.data.HttpProxy({url: SchemUrl+'?action=list'});
var KPIIndexUrl = 'dhc.pa.kpiindexexe.csp';
var KPIIndexProxy = new Ext.data.HttpProxy({url: KPIIndexUrl+'?action=kpi&start=0&limit=25'});

var SchemDs = new Ext.data.Store({
	proxy: SchemProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid','parRef','code','name','shortcut','appSysDr','frequency','KPIDr','KPIName','desc','level','appSys','quency', 'computeTypeDr','computeTypeName','upschemDr','upschemName','schemFlag','schemType'
 
		]),
    remoteSort: true
});

SchemDs.setDefaultSort('rowid', 'DESC');


var KPIIndexDs = new Ext.data.Store({
	proxy:KPIIndexProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid','name'
 
		]),
    remoteSort: true
});
KPIIndexDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:KPIIndexUrl+'?action=kpi&&start=0&limit=25'});
});

var SchemCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '方案编号',
			dataIndex: 'code',
			width: 60,
			align: 'left',
			sortable: true
		},
		{
			header: '方案名称',
			dataIndex: 'name',
			width: 150,
			align: 'left',
			sortable: true
		},
		{
        header: "考核频率",
        dataIndex: 'frequency',
        width: 60,
        align: 'left',
        sortable: true
		},
		{
        header: "结果指标",
        dataIndex: 'KPIName',
        width: 150,
        align: 'left',
        sortable: true
		}
		,
		{
        header: "上级方案",
        dataIndex: 'upschemName',
        width: 350,
        align: 'left',
        sortable: true
		}
		,
		{
        header: "处理方式",
        dataIndex: 'computeTypeName',
        width: 100,
        align: 'left',
        sortable: true
		}
		,
		{
        header: "方案类型",
        dataIndex: 'schemFlag',
        width: 60,
        align: 'left',
        sortable: true
		}
		
		
		
	]);
	
var SchemSearchField = 'name';

var SchemFilterItem = new Ext.SplitButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '名称',value: 'name',checked: false,group: 'SchemFilter',checkHandler: onSchemItemCheck }),
				new Ext.menu.CheckItem({ text: '编码',value: 'code',checked: false,group: 'SchemFilter',checkHandler: onSchemItemCheck })
		]}
});

function onSchemItemCheck(item, checked)
{
		if(checked) {
				SchemSearchField = item.value;
				SchemFilterItem.setText(item.text + ':');
		}
}

var SchemSearchBox = new Ext.form.TwinTriggerField({//查找按钮
		width: 100,
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
				SchemDs.proxy = new Ext.data.HttpProxy({url: SchemUrl + '?action=list'});
				SchemDs.load({params:{start:0, limit:SchemPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				SchemDs.proxy = new Ext.data.HttpProxy({
				url: SchemUrl + '?action=list&searchField=' + SchemSearchField + '&searchValue=' + encodeURIComponent(this.getValue())});
				SchemDs.load({params:{start:0, limit:SchemPagingToolbar.pageSize}});
	    	}
		}
});
SchemDs.each(function(record){
    alert(record.get('tieOff'));

});
var SchemPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize:25,
		store: SchemDs,
		displayInfo: true,
		displayMsg: '当前显示{0}-{1},共计{2}',
		emptyMsg: "没有数据",
		buttons: [SchemFilterItem,'-',SchemSearchBox]
});

var addAdjustButton = new Ext.Toolbar.Button({
		text: '添加',
		tooltip: '添加新的方案',
		iconCls: 'add',
		handler: function(){addSchemFun(SchemDs,SchemGrid,SchemPagingToolbar);
		}
});

var copyButton = new Ext.Toolbar.Button({
		text: '复制',
		tooltip: '复制方案标准版',
		iconCls: 'add',
		handler: function(){copySchemFun(SchemDs,SchemGrid,SchemPagingToolbar);
		}
});

var editAdjustButton = new Ext.Toolbar.Button({
		text: '修改',
		tooltip: '修改选择的方案',
		iconCls: 'add',
		handler: function(){editSchemFun(SchemDs,SchemGrid,SchemPagingToolbar);
		}
});

var delAdjustButton = new Ext.Toolbar.Button({
		text: '删除',
		tooltip: '删除选择的方案',
		iconCls: 'remove',
		handler: function(){delSchemFun(SchemDs,SchemGrid,SchemPagingToolbar);
		}
});

var SchemGrid = new Ext.grid.EditorGridPanel({//表格
		title: '绩效方案设定',
		store: SchemDs,
		xtype: 'grid',
		cm: SchemCm,
		trackMouseOver: true,
		region: 'west',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		width:650,
		//clicksToEdit: 2,
		stripeRows: true, 
        tbar:[addAdjustButton,/*editAdjustButton,*/delAdjustButton,'-',copyButton],		
		bbar: SchemPagingToolbar
});


SchemGrid.on('cellclick',function(grid,rowIndex,columnIndex,e){
	if(columnIndex==9){
		accPeriodsEditor(grid);
	}else if(columnIndex==10){
		copyOtherMon(grid);
	}
});

SchemGrid.on(
	"rowclick",
	function(grid,rowIndex,e ){
		var rowObj = grid.getSelectionModel().getSelections();
		initemrowid = rowObj[0].get("rowid");
        var url='dhc.pa.schemexe.csp?action=findkpi&schem='+initemrowid;
		detailTreeLoader.dataUrl=url+"&parent=0";	
		
		Ext.getCmp('detailReport').getNodeById("roo").reload();
		/* outItemsDs.proxy = new Ext.data.HttpProxy({url:'dhc.pa.schemexe.csp?action=findkpi&schem='+initemrowid});
		outItemsDs.load({params:{start:0, limit:inItemsPagingToolbar.pageSize}}); */
	});
SchemDs.load({params:{start:0, limit:SchemPagingToolbar.pageSize}});
