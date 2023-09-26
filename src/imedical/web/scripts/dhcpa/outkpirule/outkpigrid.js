var outKpiUrl = '../csp/dhc.pa.outkpiruleexe.csp';
var outKpiProxy;

//外部指标
var outKpiDs = new Ext.data.Store({
	proxy: outKpiProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'rowid',
		'code',
		'name',
		'inLocSetDr',
		'inLocSetName',
		'active'
	]),
	remoteSort: true
});

outKpiDs.setDefaultSort('rowid', 'asc');
var outKpiCm = new Ext.grid.ColumnModel([
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
	},{
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
		var rowObj = LocSetGrid.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择接口套记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			var locSetDr=rowObj[0].get("rowid");
			addFun(locSetDr,outKpiDs,outKpiGrid,outKpiPagingToolbar);
		}
	}
});

//修改按钮
var editButton = new Ext.Toolbar.Button({
	text: '修改KPI指标',
    tooltip:'修改KPI指标',        
    iconCls:'add',
	handler:function(){
		editFun(outKpiDs,outKpiGrid,outKpiPagingToolbar);
	}
});

//删除按钮
var delButton = new Ext.Toolbar.Button({
	text: '删除KPI指标',
    tooltip:'删除KPI指标',        
    iconCls:'remove',
	handler:function(){
		var rowObj = outKpiGrid.getSelections();
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
								url:'../csp/dhc.pa.outkpiruleexe.csp?action=del&rowid='+rowObj[0].get("rowid"),
								waitMsg:'删除中...',
								failure: function(result, request) {
									Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true') {
										Ext.Msg.show({title:'提示',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
										outKpiDs.load({params:{start:0, limit:outKpiPagingToolbar.pageSize,locSetDr:LocSetGrid.getSelections()[0].get("rowid"),sort:"rowid",dir:"asc"}});
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

var outKpiSearchField = 'name';

var outKpiFilterItem = new Ext.Toolbar.MenuButton({
	text: '过滤器',
	tooltip: '关键字所属类别',
	menu: {items: [
		new Ext.menu.CheckItem({ text: '代码',value: 'code',checked: false,group: 'outKpiFilter',checkHandler: onBusItemItemCheck }),
		new Ext.menu.CheckItem({ text: '名称',value: 'name',checked: false,group: 'outKpiFilter',checkHandler: onBusItemItemCheck })
	]}
});
function onBusItemItemCheck(item, checked)
{
	if(checked) {
		outKpiSearchField = item.value;
		outKpiFilterItem.setText(item.text + ':');
	}
};

var outKpiSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
				outKpiDs.proxy = new Ext.data.HttpProxy({url:outKpiUrl+'?action=kpilist&locSetDr='+LocSetGrid.getSelections()[0].get("rowid")+'&sort=rowid&dir=asc'});
				outKpiDs.load({params:{start:0, limit:outKpiPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				outKpiDs.proxy = new Ext.data.HttpProxy({
				url: outKpiUrl+'?action=kpilist&locSetDr='+LocSetGrid.getSelections()[0].get("rowid")+'&searchField='+outKpiSearchField+'&searchValue='+encodeURIComponent(this.getValue())+'&sort=rowid&dir=asc'});
				outKpiDs.load({params:{start:0, limit:outKpiPagingToolbar.pageSize}});
			}
		}
	});
	var outKpiPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize:25,
		store:outKpiDs,
		displayInfo:true,
		displayMsg:'当前显示{0} - {1}，共计{2}',
		emptyMsg:"没有数据",
		buttons:[outKpiFilterItem,'-',outKpiSearchBox],
		doLoad:function(C){
			var B={},
			A=this.paramNames;
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['locSetDr']=LocSetGrid.getSelections()[0].get("rowid");
			B['dir']="asc";
			B['sort']="rowid";
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
	});
	var outKpiGrid = new Ext.grid.GridPanel({//表格
		title: 'KPI指标信息',
		region: 'center',
		xtype: 'grid',
		store: outKpiDs,
		cm: outKpiCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		viewConfig: {forceFit:true},
		tbar: [addButton,'-',editButton,'-',delButton],
		bbar: outKpiPagingToolbar
	});