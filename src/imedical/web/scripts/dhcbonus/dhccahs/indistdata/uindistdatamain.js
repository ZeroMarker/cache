var inDistDataUrl = 'dhc.ca.indistdataexe.csp';
var inDistDataProxy = new Ext.data.HttpProxy({ url: inDistDataUrl + '?action=list' });
var intervalDr = "";
function formatDate(value) {
    //alert(value);
    return value ? value.dateFormat('Y-m-d') : '';
};

//接口部门套数据源
var inDistDataDs = new Ext.data.Store({
    proxy: inDistDataProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
            'rowid',
			'intervalDr',
			'intervalName',
			'patType',
			'itemDr',
			'itemCode',
			'itemName',
			'deptDr',
			'deptCode',
			'deptName',
			'fee',
			'inType',
			'remark'
		]),
    // turn on remote sorting
    remoteSort: true
});

inDistDataDs.setDefaultSort('order', 'asc');

var inDistDataCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
	    header: '数据标识',
	    dataIndex: 'patType',
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
	    header: '部门代码',
	    dataIndex: 'deptCode',
	    width: 150,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '部门名称',
	    dataIndex: 'deptName',
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
	    header: '收入类别',
	    dataIndex: 'inType',
	    width: 100,
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
    inDistDataDs.load({ params: { start: 0, limit: inDistDataPagingToolbar.pageSize, intervalDr: intervalDr} });
});
var addDataTypesButton = new Ext.Toolbar.Button({
    text: '添加',
    tooltip: '添加新的接口部门套',
    iconCls: 'add',
    handler: function() { addFun(inDistDataDs, inDistDataMain, inDistDataPagingToolbar); }
});

var editDataTypesButton = new Ext.Toolbar.Button({
    text: '修改',
    tooltip: '修改选定的接口部门套',
    iconCls: 'remove',
    handler: function() { editFun(inDistDataDs, inDistDataMain, inDistDataPagingToolbar); }
});

var countButton = new Ext.Toolbar.Button({
    text: '执行分配',
    tooltip: '执行分配当月数据',
    iconCls: 'remove',
    handler: function() { 
		if (intervalDr == "") {
			Ext.Msg.show({ title: '错误', msg: '请选择核算区间再试!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
			return;
		}
			Ext.MessageBox.confirm('提示', 
							'确定要分配此月的数据?', 
							function(btn) {
								if(btn == 'yes')
								{
		    Ext.Ajax.request({
                        url: inDistDataUrl + '?action=count&intervalDr=' + intervalDr,
                        waitMsg: '保存中...',
                        failure: function(result, request) {
                            Ext.Msg.show({ title: '错误', msg: '请检查网络连接!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
                        },
                        success: function(result, request) {
                            var jsonData = Ext.util.JSON.decode(result.responseText);
                            if (jsonData.success == 'true') {
                                Ext.Msg.show({ title: '注意', msg: '分配成功!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
                                inDistDataDs.setDefaultSort('rowid', 'desc');
                                inDistDataDs.load({ params: { start: 0, limit: inDistDataPagingToolbar.pageSize, intervalDr: intervalDr} });
                                //window.close();
                            }
                            else {
                                var message = "";
                                message = "SQLErr: " + jsonData.info;
                                if (jsonData.info == 'EmptyCode') message = '输入的代码为空!';
                                if (jsonData.info == 'EmptyName') message = '输入的名称为空!';
                                if (jsonData.info == 'EmptyOrder') message = '输入的序号为空!';
                                if (jsonData.info == 'RepCode') message = '输入的代码已经存在!';
                                if (jsonData.info == 'RepName') message = '输入的名称已经存在!';
                                if (jsonData.info == 'RepOrder') message = '输入的序号已经存在!';
                                Ext.Msg.show({ title: '错误', msg: message, buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
                            }
                        },
                        scope: this
                    });
				}})
	}
});

var delDataTypesButton = new Ext.Toolbar.Button({
    text: '删除',
    tooltip: '删除选定的接口部门套',
    iconCls: 'remove',
    //disabled: true,
    handler: function() { delFun(inDistDataDs, inDistDataMain, inDistDataPagingToolbar); }
});

var totalButton = new Ext.Toolbar.Button({
    text: '统计汇总',
    tooltip: '统计汇总',
    iconCls: 'remove',
    handler: function() { CommFindFun(inDistDataDs, inDistDataMain, inDistDataPagingToolbar) }
});
var inDistDataSearchField = 'itemName';

var inDistDataFilterItem = new Ext.Toolbar.MenuButton({
    text: '过滤器',
    tooltip: '关键字所属类别',
    menu: { items: [
				new Ext.menu.CheckItem({ text: '数据标识', value: 'patType', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '项目代码', value: 'itemCode', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '项目名称', value: 'itemName', checked: true, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '部门代码', value: 'deptCode', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '部门名称', value: 'deptName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '收入类别', value: 'inType', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '金额', value: 'fee', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '备注', value: 'remark', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck })
		]
    }
});

function onDataTypesItemCheck(item, checked) {
    if (checked) {
        inDistDataSearchField = item.value;
        inDistDataFilterItem.setText(item.text + ':');
    }
};

var inDistDataSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
            inDistDataDs.proxy = new Ext.data.HttpProxy({ url: inDistDataUrl + '?action=list' });
            inDistDataDs.load({ params: { start: 0, limit: inDistDataPagingToolbar.pageSize, intervalDr: intervalDr} });
        }
    },
    onTrigger2Click: function() {
        if (this.getValue()) {
            inDistDataDs.proxy = new Ext.data.HttpProxy({
                url: inDistDataUrl + '?action=list&searchField=' + inDistDataSearchField + '&searchValue=' + this.getValue()
            });
            inDistDataDs.load({ params: { start: 0, limit: inDistDataPagingToolbar.pageSize, intervalDr: intervalDr} });
        }
    }
});

var inDistDataPagingToolbar = new Ext.PagingToolbar({//分页工具栏
    pageSize: 25,
    store: inDistDataDs,
    displayInfo: true,
    displayMsg: '当前显示{0} - {1}，共计{2}',
    emptyMsg: "没有数据",
    buttons: ['-', inDistDataFilterItem, '-', inDistDataSearchBox],
    doLoad: function(C) {
        var B = {},
		A = this.paramNames;
        B[A.start] = C;
        B[A.limit] = this.pageSize;
        B['intervalDr'] = intervalDr;
        if (this.fireEvent("beforechange", this, B) !== false) {
            this.store.load({ params: B });
        }
    }

});

//////////////////////////添加打印按钮 by 王赢赢
var excelButton = new Ext.Toolbar.Button({
	text:'生成excel',        
	tooltip:'生成excel',
	iconCls:'add',        
	handler: function(){ 
			if(months.getValue()==""){
				Ext.Msg.alert("提示","请选择核算周期");
			}else{
						//location.href = 'http://10.21.3.129:8080/outload/InDistData?outType=xls&months='+months.getValue();
                                                location.href = 'http://127.0.0.1:8080/outload/InDistData?outType=xls&months='+months.getValue();
			}
		}
});
////////////////////////////////////////////////

var inDistDataMain = new Ext.grid.GridPanel({//表格
    title: '收入分配数据表',
    store: inDistDataDs,
    cm: inDistDataCm,
    trackMouseOver: true,
    stripeRows: true,
    sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
    loadMask: true,
    tbar: ['核算周期:', months, '-',  totalButton,'-',excelButton],
    bbar: inDistDataPagingToolbar
});

//inDistDataDs.load({params:{start:0, limit:inDistDataPagingToolbar.pageSize}});