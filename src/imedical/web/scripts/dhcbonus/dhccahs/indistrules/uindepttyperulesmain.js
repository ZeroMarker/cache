var busdingUrl = 'dhc.ca.indistrulesexe.csp';
var specialUnitProxy = new Ext.data.HttpProxy({url: busdingUrl + '?action=listtyperules'});

//特殊数据单元数据源
var specialUnitDs = new Ext.data.Store({
	proxy: specialUnitProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
	'rowid',
	'deptType',
	'percent'
	]),
	// turn on remote sorting
	remoteSort: true
});

specialUnitDs.setDefaultSort('rowid', 'ASC');

var specialUnitCm = new Ext.grid.ColumnModel([
new Ext.grid.RowNumberer(),
{
	header: '科室类别',
	dataIndex: 'deptType',
	width: 80,
	sortable: true
},
{
	header: "比率",
	dataIndex: 'percent',
	width: 150,
	align: 'left',
	sortable: true
}
]);

var specialUnitSearchField = 'Name';

var busdingFilterItem = new Ext.Toolbar.MenuButton({
	text: '过滤器',
	tooltip: '关键字所属类别',
	menu: {items: [
		new Ext.menu.CheckItem({ text: '代码',value: 'Code',checked: false,group: 'busdingFilter',checkHandler: onBusdingItemCheck }),
		new Ext.menu.CheckItem({ text: '名称',value: 'Name',checked: true,group: 'busdingFilter',checkHandler: onBusdingItemCheck })
	]}
});

function onBusdingItemCheck(item, checked)
{
	if(checked) {
		specialUnitSearchField = item.value;
		busdingFilterItem.setText(item.text + ':');
	}
};

var specialUnitSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
				specialUnitDs.proxy = new Ext.data.HttpProxy({url: busdingUrl + '?action=list&active=Y'});
				specialUnitDs.load({params:{start:0, limit:specialUnitPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				specialUnitDs.proxy = new Ext.data.HttpProxy({
				url: busdingUrl + '?action=list&activey&searchfield=' + specialUnitSearchField + '&searchvalue=' + this.getValue()});
				specialUnitDs.load({params:{start:0, limit:specialUnitPagingToolbar.pageSize}});
			}
		}
	});

	var specialUnitPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 10,
		store: specialUnitDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		doLoad:function(C){
			var tmpRow = specialParamPanel.getSelections();
			var tmpSRowid=tmpRow[0].get("rowid");	
			var B={},
			A=this.paramNames;
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['parRef']=tmpSRowid;
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
	});
	var menubar = [
    		{
				text: '修改科室类别分配规则',
        		tooltip:'修改科室类别分配规则',
				id:'locadd',
        		iconCls:'add',
				//disabled:true,
		        handler: function(){                     
		        	specialUnitAddFun(specialUnitDs, specialParamPanel ,specialUnitPagingToolbar);        
		        }
        }];
	var specialUnitGrid = new Ext.grid.GridPanel({//表格
		title: '科室类别分配规则',
		region: 'center',
		//width: 200,
		height:300,
		split: true,
		collapsible: true,
		maskDisabled:false,
		containerScroll: true,
		xtype: 'grid',
		store: specialUnitDs,
		cm: specialUnitCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		viewConfig: {forceFit:true},
		//tbar: menubar,
		bbar: specialUnitPagingToolbar
	});
	//specialUnitDs.load({params:{start:0, limit:specialUnitPagingToolbar.pageSize}});

	var specialUnitRowId = "";
	var specialUnitName = "";

	

