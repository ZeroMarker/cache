var jxUnitUrl = '../csp/dhc.pa.unitdeptschemexe.csp';
var jxUnitProxy;

//绩效单元
var jxUnitDs = new Ext.data.Store({
	proxy: jxUnitProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'rowid',
		'code',
		'name',
		'type'
	]),
	remoteSort: true
});

jxUnitDs.setDefaultSort('rowid', 'Desc');
var jxUnitCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: '科室代码',
		dataIndex: 'code',
		width: 120,
		sortable: true
	},{
		header: "科室名称",
		dataIndex: 'name',
		width: 120,
		align: 'left',
		sortable: true
	}
]);


//选择按钮
var addButton = new Ext.Toolbar.Button({
	text: '选择科室',
    tooltip:'选择科室',        
    iconCls:'add',
	handler:function(){
		addJXUnitFun(SchemGrid,jxUnitDs,jxUnitGrid,jxUnitPagingToolbar);
	}
});


//删除按钮
var delButton = new Ext.Toolbar.Button({
	text: '删除科室',
    tooltip:'删除科室',        
    iconCls:'remove',
	handler:function(){
		var rowObj = jxUnitGrid.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的基本数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('提示','确定要删除选定的行?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'../csp/dhc.pa.unitdeptschemexe.csp?action=del&rowid='+rowObj[0].get("rowid"),
							waitMsg:'删除中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									jxUnitDs.load({params:{start:jxUnitPagingToolbar.cursor, limit:jxUnitPagingToolbar.pageSize,schemDr:SchemGrid.getSelections()[0].get("rowid"),sort:"rowid",dir:"DESC"}});
								}else{
									var message="删除错误";
									Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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

var jxUnitSearchField = 'name';

var jxUnitFilterItem = new Ext.Toolbar.MenuButton({
	text: '过滤器',
	tooltip: '关键字所属类别',
	menu: {items: [
		new Ext.menu.CheckItem({ text: '科室代码',value: 'code',checked: false,group: 'jxUnitFilter',checkHandler: onBusItemItemCheck }),
		new Ext.menu.CheckItem({ text: '科室名称',value: 'name',checked: false,group: 'jxUnitFilter',checkHandler: onBusItemItemCheck }),
		new Ext.menu.CheckItem({ text: '科室类别',value: 'type',checked: false,group: 'jxUnitFilter',checkHandler: onBusItemItemCheck })
	]}
});
function onBusItemItemCheck(item, checked)
{
	if(checked) {
		jxUnitSearchField = item.value;
		jxUnitFilterItem.setText(item.text + ':');
	}
};

var jxUnitSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
				jxUnitDs.proxy = new Ext.data.HttpProxy({url:jxUnitUrl+'?action=jxunitlist&schemDr='+SchemGrid.getSelections()[0].get("rowid")+'&sort=rowid&dir=DESC'});
				jxUnitDs.load({params:{start:0, limit:jxUnitPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				jxUnitDs.proxy = new Ext.data.HttpProxy({
				url: jxUnitUrl+'?action=jxunitlist&schemDr='+SchemGrid.getSelections()[0].get("rowid")+'&searchField='+jxUnitSearchField+'&searchValue='+encodeURIComponent(this.getValue())+'&sort=rowid&dir=DESC'});
				jxUnitDs.load({params:{start:0, limit:jxUnitPagingToolbar.pageSize}});
			}
		}
	});
	var jxUnitPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize:25,
		store:jxUnitDs,
		displayInfo:true,
		displayMsg:'当前显示{0} - {1}，共计{2}',
		emptyMsg:"没有数据",
		buttons:[jxUnitFilterItem,'-',jxUnitSearchBox],
		doLoad:function(C){
			var B={},
			A=this.paramNames;
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['schemDr']=SchemGrid.getSelections()[0].get("rowid");
			B['dir']="asc";
			B['sort']="rowid";
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
	});
	var jxUnitGrid = new Ext.grid.GridPanel({//表格
		title: '科室信息',
		region: 'center',
		xtype: 'grid',
		store: jxUnitDs,
		cm: jxUnitCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		viewConfig: {forceFit:true},
		tbar: [addButton,'-',delButton],
		bbar: jxUnitPagingToolbar
	});