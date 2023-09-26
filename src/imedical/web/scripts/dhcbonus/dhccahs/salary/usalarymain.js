var salaryUrl = 'dhc.ca.salaryexe.csp';
var salaryProxy = new Ext.data.HttpProxy({ url: salaryUrl + '?action=list' });
var intervalDr = "";
function formatDate(value) {
    //alert(value);
    return value ? value.dateFormat('Y-m-d') : '';
};

//接口部门套数据源
var salaryDs = new Ext.data.Store({
    proxy: salaryProxy,
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

salaryDs.setDefaultSort('order', 'asc');

var salaryCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
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
	    header: '部门名称',
	    dataIndex: 'servedInDeptName',
	    width: 150,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '内部人员名称',
	    dataIndex: 'receiverInName',
	    width: 150,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '人员代码',
	    dataIndex: 'receiverCode',
	    width: 100,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '人员名称',
	    dataIndex: 'receiverName',
	    width: 150,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '金额',
	    dataIndex: 'fee',
	    width: 100,
	    align: 'right',
		renderer: formatNum,
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
    salaryDs.load({ params: { start: 0, limit: salaryPagingToolbar.pageSize, intervalDr: intervalDr, dataTypeDr: ITEMTYPEID} });
});
var addDataTypesButton = new Ext.Toolbar.Button({
    text: '添加',
    tooltip: '添加新的接口部门套',
    iconCls: 'add',
    handler: function() { addFun(salaryDs, salaryMain, salaryPagingToolbar); }
});

var editDataTypesButton = new Ext.Toolbar.Button({
    text: '修改',
    tooltip: '修改选定的接口部门套',
    iconCls: 'remove',
    handler: function() { editFun(salaryDs, salaryMain, salaryPagingToolbar); }
});

var delDataTypesButton = new Ext.Toolbar.Button({
    text: '删除',
    tooltip: '删除选定的接口部门套',
    iconCls: 'remove',
    //disabled: true,
    handler: function() { delFun(salaryDs, salaryMain, salaryPagingToolbar); }
});

var relationButton = new Ext.Toolbar.Button({
    text: '执行对照',
    tooltip: '执行对照',
    iconCls: 'remove',
    handler: function() {
		Ext.MessageBox.confirm('提示',
					'确定要对照数据么?',
					function(btn) {
						if (btn == 'yes') {
							
								Ext.Ajax.request({
									url: salaryUrl + '?action=refresh&intervalDr='+intervalDr+'&dataTypeDr='+ITEMTYPEID,
									waitMsg: '对照中...',
									failure: function(result, request) {
										Ext.Msg.show({ title: '错误', msg: '请检查网络连接!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
									},
									success: function(result, request) {
										var jsonData = Ext.util.JSON.decode(result.responseText);
										if (jsonData.success == 'true') {
											Ext.MessageBox.alert('提示', '对照完成');
											salaryDs.load({ params: { start: 0, limit: salaryPagingToolbar.pageSize, intervalDr: intervalDr, dataTypeDr: ITEMTYPEID} });
											window.close();
										}
										else {
											var message = "SQLErr: " + jsonData.info;
											Ext.Msg.show({ title: '错误', msg: message, buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
										}
									},
									scope: this
								});
							
						}
					}
				);
	}
});

var importButton = new Ext.Toolbar.Button({
    text: '导入数据',
    tooltip: '导入数据',
    iconCls: 'remove',
    handler: function() { loadSalary() }
});

var totalButton = new Ext.Toolbar.Button({
    text: '统计汇总',
    tooltip: '统计汇总',
    iconCls: 'remove',
    handler: function() { CommFindFun(salaryDs, salaryMain, salaryPagingToolbar) }
});
var salarySearchField = 'itemInName';

var salaryFilterItem = new Ext.Toolbar.MenuButton({
    text: '过滤器',
    tooltip: '关键字所属类别',
    menu: { items: [
				new Ext.menu.CheckItem({ text: '内部项目', value: 'itemInName', checked: true, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '项目代码', value: 'itemCode', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '项目名称', value: 'itemName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '内部部门', value: 'servedInDeptName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				//new Ext.menu.CheckItem({ text: '部门代码', value: 'servedDeptCode', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				//new Ext.menu.CheckItem({ text: '部门名称', value: 'servedDeptName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '内部人员', value: 'receiverInName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '人员代码', value: 'receiverCode', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '人员名称', value: 'receiverName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '金额', value: 'fee', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '操作日期', value: 'operDate', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '操作人', value: 'operName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '备注', value: 'remark', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck })
		]
    }
});

function onDataTypesItemCheck(item, checked) {
    if (checked) {
        salarySearchField = item.value;
        salaryFilterItem.setText(item.text + ':');
    }
};

var salarySearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
            salaryDs.proxy = new Ext.data.HttpProxy({ url: salaryUrl + '?action=list' });
            salaryDs.load({ params: { start: 0, limit: salaryPagingToolbar.pageSize, intervalDr: intervalDr, dataTypeDr: ITEMTYPEID} });
        }
    },
    onTrigger2Click: function() {
        if (this.getValue()) {
            salaryDs.proxy = new Ext.data.HttpProxy({
                url: salaryUrl + '?action=list&searchField=' + salarySearchField + '&searchValue=' + this.getValue()
            });
            salaryDs.load({ params: { start: 0, limit: salaryPagingToolbar.pageSize, intervalDr: intervalDr, dataTypeDr: ITEMTYPEID} });
        }
    }
});

var salaryPagingToolbar = new Ext.PagingToolbar({//分页工具栏
    pageSize: 25,
    store: salaryDs,
    displayInfo: true,
    displayMsg: '当前显示{0} - {1}，共计{2}',
    emptyMsg: "没有数据",
    buttons: ['-', salaryFilterItem, '-', salarySearchBox],
    doLoad: function(C) {
        var B = {},
		A = this.paramNames;
        B[A.start] = C;
        B[A.limit] = this.pageSize;
        B['intervalDr'] = intervalDr;
        B['dataTypeDr'] = ITEMTYPEID;
        if (this.fireEvent("beforechange", this, B) !== false) {
            this.store.load({ params: B });
        }
    }

});

var salaryMain = new Ext.grid.GridPanel({//表格
    title: '人员工资',
    store: salaryDs,
    cm: salaryCm,
    trackMouseOver: true,
    stripeRows: true,
    sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
    loadMask: true,
    tbar: ['核算周期:', months, '-', totalButton],
    bbar: salaryPagingToolbar
});

//salaryDs.load({params:{start:0, limit:salaryPagingToolbar.pageSize}});