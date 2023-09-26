var otherdataUrl = 'dhc.ca.otherdataexe.csp';
var otherdataProxy = new Ext.data.HttpProxy({ url: otherdataUrl + '?action=list' });
var intervalDr = "";
var itemTypeId = "";
function formatDate(value) {
    //alert(value);
    return value ? value.dateFormat('Y-m-d') : '';
};

//接口部门套数据源
var otherdataDs = new Ext.data.Store({
    proxy: otherdataProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
            'rowid',
			'intervalDr',
			'intervalName',
			'sysDataType',
			'dataTypeDr',
			'dataTypeName',
			{ name: 'busDate', type: 'date', dateFormat: 'Y-m-d' },
			'itemDr',
			'itemInName',
			'itemCode',
			'itemName',
			'servedDeptDr',
			'servedInDeptName',
			'servedDeptCode',
			'servedDeptName',
			'receiverDr',
			'receiverInName',
			'receiverCode',
			'receiverName',
			'fee',
			'operType',
			{ name: 'operDate', type: 'date', dateFormat: 'Y-m-d' },
			'operDr',
			'operName',
			'operDeptDr',
			'operDeptName',
			'remark',
			'remark1',
			'remark2'
		]),
    // turn on remote sorting
    remoteSort: true
});

otherdataDs.setDefaultSort('order', 'asc');

var otherdataCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),new Ext.grid.CheckboxSelectionModel(),
	{
	    header: '内部业务项',
	    dataIndex: 'itemInName',
	    width: 100,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '业务项代码',
	    dataIndex: 'itemCode',
	    width: 100,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '业务项名称',
	    dataIndex: 'itemName',
	    width: 150,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '内部部门名称',
	    dataIndex: 'servedInDeptName',
	    width: 150,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '部门代码',
	    dataIndex: 'servedDeptCode',
	    width: 100,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '部门名称',
	    dataIndex: 'servedDeptName',
	    width: 150,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '金额',
	    dataIndex: 'fee',
	    width: 100,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '操作类别',
	    dataIndex: 'operType',
	    width: 100,
	    align: 'left',
	    sortable: true
	},
	{
	    header: "操作日期",
	    dataIndex: 'operDate',
	    width: 90,
	    renderer: formatDate,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '执行人',
	    dataIndex: 'operName',
	    width: 150,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '执行科室',
	    dataIndex: 'operDeptName',
	    width: 150,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '备注',
	    dataIndex: 'remark',
	    width: 150,
	    align: 'left',
	    sortable: true
	}
]);
var monthsDs = new Ext.data.Store({
    proxy: "",
    reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowid', 'code', 'name', 'desc', 'start', 'end', 'dataFinish'])
});
var months = new Ext.form.ComboBox({
    id: 'months',
    fieldLabel: '核算区间',
    width: 100,
    listWidth: 260,
    allowBlank: false,
    store: monthsDs,
    //readOnly:true,
    valueField: 'rowid',
    displayField: 'name',
    triggerAction: 'all',
    emptyText: '选择核算区间...',
    pageSize: 10,
    minChars: 1,
    selectOnFocus: true,
    forceSelection: true
});
monthsDs.on('beforeload', function(ds, o) {
    ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.vouchdatasexe.csp?action=months&searchValue=' + Ext.getCmp('months').getRawValue(), method: 'GET' });
});
months.on("select", function(cmb, rec, id) {
    intervalDr = cmb.getValue();
    //otherdataDs.load({ params: { start: 0, limit: otherdataPagingToolbar.pageSize, intervalDr: intervalDr, dataTypeDr: itemTypeId} });
});
var addDataTypesButton = new Ext.Toolbar.Button({
    text: '添加',
    tooltip: '添加新的接口部门套',
    iconCls: 'add',
    handler: function() { addFun(otherdataDs, otherdataMain, otherdataPagingToolbar); }
});

var editDataTypesButton = new Ext.Toolbar.Button({
    text: '修改',
    tooltip: '修改选定的接口部门套',
    iconCls: 'remove',
    disabled: true,
    handler: function() { editFun(otherdataDs, otherdataMain, otherdataPagingToolbar); }
});

var delDataTypesButton = new Ext.Toolbar.Button({
    text: '删除',
    tooltip: '删除选定的接口部门套',
    iconCls: 'remove',
    disabled: true,
    handler: function() { delFun(otherdataDs, otherdataMain, otherdataPagingToolbar); }
});

var relationButton = new Ext.Toolbar.Button({
    text: '执行对照',
    tooltip: '执行对照',
    iconCls: 'remove',
    handler: function() {refreshFun(otherdataDs, otherdataMain, otherdataPagingToolbar)}
});

var importButton = new Ext.Toolbar.Button({
    text: '导入数据',
    tooltip: '导入数据',
    iconCls: 'remove',
    handler: function() { loadBusData(otherdataDs,otherdataPagingToolbar) }
});

var totalButton = new Ext.Toolbar.Button({
    text: '统计汇总',
    tooltip: '统计汇总',
    iconCls: 'remove',
    handler: function() { CommFindFun(otherdataDs, otherdataMain, otherdataPagingToolbar) }
});
	var itemTypeDs = new Ext.data.Store({
		autoLoad: true,
		proxy: '',
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'},['shortcut','rowid'])
	});
	
	itemTypeDs.on(
		'beforeload',
		function(ds, o){
			ds.proxy = new Ext.data.HttpProxy({url:otherdataUrl+'?action=listItemType&active=Y&searchField=shortcut&searchValue='+Ext.getCmp('itemTypeSelecter').getRawValue()+'&id='+DATATYPEID, method:'GET'});
		}
	);
	
	var itemTypeSelecter = new Ext.form.ComboBox({
		id:'itemTypeSelecter',
		fieldLabel:'数据类',
		store: itemTypeDs,
		valueField:'rowid',
		//disabled:true,
		displayField:'shortcut',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		width:100,
		listWidth:250,
		triggerAction:'all',
		emptyText:'选择数据项类别...',
		allowBlank: true,
		selectOnFocus: true,
		forceSelection: true
	});
	itemTypeSelecter.on("select", function(cmb, rec, id) {
		if (intervalDr == "") {
			Ext.Msg.show({ title: '错误', msg: '请选择核算区间再试!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
			return;
		}
		itemTypeId = cmb.getValue();
		otherdataDs.load({ params: { start: 0, limit: otherdataPagingToolbar.pageSize, intervalDr: intervalDr, dataTypeDr: itemTypeId} });
	});
var otherdataSearchField = 'itemInName';

var otherdataFilterItem = new Ext.Toolbar.MenuButton({
    text: '过滤器',
    tooltip: '关键字所属类别',
    menu: { items: [
				new Ext.menu.CheckItem({ text: '内部项目', value: 'itemInName', checked: true, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '项目代码', value: 'itemCode', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '项目名称', value: 'itemName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '内部部门', value: 'servedInDeptName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '部门代码', value: 'servedDeptCode', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '部门名称', value: 'servedDeptName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				//new Ext.menu.CheckItem({ text: '内部人员', value: 'receiverInName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				//new Ext.menu.CheckItem({ text: '人员代码', value: 'receiverCode', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				//new Ext.menu.CheckItem({ text: '人员名称', value: 'receiverName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '金额', value: 'fee', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '操作日期', value: 'operDate', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '操作人', value: 'operName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '备注', value: 'remark', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck })
		]
    }
});

function onDataTypesItemCheck(item, checked) {
    if (checked) {
        otherdataSearchField = item.value;
        otherdataFilterItem.setText(item.text + ':');
    }
};

var otherdataSearchBox = new Ext.form.TwinTriggerField({//查找按钮
    width: 180,
    trigger1Class: 'x-form-clear-trigger',
    trigger2Class: 'x-form-search-trigger',
    emptyText: '搜索...',
    listeners: {
        specialkey: { fn: function(field, e) {
            var key = e.getKey();
            if (e.ENTER === key) { this.onTrigger2Click(); } 
        } 
        }
    },
    grid: this,
    onTrigger1Click: function() {
        if (this.getValue()) {
            this.setValue('');
            otherdataDs.proxy = new Ext.data.HttpProxy({ url: otherdataUrl + '?action=list' });
            otherdataDs.load({ params: { start: 0, limit: otherdataPagingToolbar.pageSize, intervalDr: intervalDr, dataTypeDr: itemTypeId} });
        }
    },
    onTrigger2Click: function() {
        if (this.getValue()) {
            otherdataDs.proxy = new Ext.data.HttpProxy({
                url: otherdataUrl + '?action=list&searchField=' + otherdataSearchField + '&searchValue=' + this.getValue()
            });
            otherdataDs.load({ params: { start: 0, limit: otherdataPagingToolbar.pageSize, intervalDr: intervalDr, dataTypeDr: itemTypeId} });
        }
    }
});

var otherdataPagingToolbar = new Ext.PagingToolbar({//分页工具栏
    pageSize: 25,
    store: otherdataDs,
    displayInfo: true,
    displayMsg: '当前显示{0} - {1}，共计{2}',
    emptyMsg: "没有数据",
    buttons: ['-', otherdataFilterItem, '-', otherdataSearchBox],
    doLoad: function(C) {
        var B = {},
		A = this.paramNames;
        B[A.start] = C;
        B[A.limit] = this.pageSize;
        B['intervalDr'] = intervalDr;
        B['dataTypeDr'] = itemTypeId;
        if (this.fireEvent("beforechange", this, B) !== false) {
            this.store.load({ params: B });
        }
    }

});

var otherdataMain = new Ext.grid.GridPanel({//表格
    title: '其他数据',
    store: otherdataDs,
    cm: otherdataCm,
    trackMouseOver: true,
    stripeRows: true,
    //sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
    sm: new Ext.grid.CheckboxSelectionModel(),
    loadMask: true,
    tbar: ['核算周期:', months, '-',itemTypeSelecter,'-', addDataTypesButton, '-', editDataTypesButton, '-', delDataTypesButton, '-', importButton, '-', relationButton, '-', totalButton],
    bbar: otherdataPagingToolbar
});

//otherdataDs.load({params:{start:0, limit:otherdataPagingToolbar.pageSize}});