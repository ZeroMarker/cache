var salaryUrl = 'dhc.ca.salaryexe.csp';
var salaryProxy = new Ext.data.HttpProxy({ url: salaryUrl + '?action=list' });
var intervalDr = "";
function formatDate(value) {
    //alert(value);
    return value ? value.dateFormat('Y-m-d') : '';
};

//�ӿڲ���������Դ
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
	    header: '�ڲ�ҵ����',
	    dataIndex: 'itemInName',
	    width: 100,
	    align: 'left',
	    sortable: true
	},
	{
	    header: 'ҵ�������',
	    dataIndex: 'itemCode',
	    width: 100,
	    align: 'left',
	    sortable: true
	},
	{
	    header: 'ҵ��������',
	    dataIndex: 'itemName',
	    width: 150,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '��������',
	    dataIndex: 'servedInDeptName',
	    width: 150,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '�ڲ���Ա����',
	    dataIndex: 'receiverInName',
	    width: 150,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '��Ա����',
	    dataIndex: 'receiverCode',
	    width: 100,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '��Ա����',
	    dataIndex: 'receiverName',
	    width: 150,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '���',
	    dataIndex: 'fee',
	    width: 100,
	    align: 'right',
		renderer: formatNum,
	    sortable: true
	},
	{
	    header: '�������',
	    dataIndex: 'operType',
	    width: 100,
	    align: 'left',
	    sortable: true
	},
	{
	    header: "��������",
	    dataIndex: 'operDate',
	    width: 90,
	    renderer: formatDate,
	    align: 'left',
	    sortable: true
	},
	{
	    header: 'ִ����',
	    dataIndex: 'operName',
	    width: 150,
	    align: 'left',
	    sortable: true
	},
	{
	    header: 'ִ�п���',
	    dataIndex: 'operDeptName',
	    width: 150,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '��ע',
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
    fieldLabel: '��������',
    width: 100,
    listWidth: 260,
    allowBlank: false,
    store: monthsDs,
    //readOnly:true,
    valueField: 'rowid',
    displayField: 'name',
    triggerAction: 'all',
    emptyText: 'ѡ���������...',
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
    text: '���',
    tooltip: '����µĽӿڲ�����',
    iconCls: 'add',
    handler: function() { addFun(salaryDs, salaryMain, salaryPagingToolbar); }
});

var editDataTypesButton = new Ext.Toolbar.Button({
    text: '�޸�',
    tooltip: '�޸�ѡ���Ľӿڲ�����',
    iconCls: 'remove',
    handler: function() { editFun(salaryDs, salaryMain, salaryPagingToolbar); }
});

var delDataTypesButton = new Ext.Toolbar.Button({
    text: 'ɾ��',
    tooltip: 'ɾ��ѡ���Ľӿڲ�����',
    iconCls: 'remove',
    //disabled: true,
    handler: function() { delFun(salaryDs, salaryMain, salaryPagingToolbar); }
});

var relationButton = new Ext.Toolbar.Button({
    text: 'ִ�ж���',
    tooltip: 'ִ�ж���',
    iconCls: 'remove',
    handler: function() {
		Ext.MessageBox.confirm('��ʾ',
					'ȷ��Ҫ��������ô?',
					function(btn) {
						if (btn == 'yes') {
							
								Ext.Ajax.request({
									url: salaryUrl + '?action=refresh&intervalDr='+intervalDr+'&dataTypeDr='+ITEMTYPEID,
									waitMsg: '������...',
									failure: function(result, request) {
										Ext.Msg.show({ title: '����', msg: '������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
									},
									success: function(result, request) {
										var jsonData = Ext.util.JSON.decode(result.responseText);
										if (jsonData.success == 'true') {
											Ext.MessageBox.alert('��ʾ', '�������');
											salaryDs.load({ params: { start: 0, limit: salaryPagingToolbar.pageSize, intervalDr: intervalDr, dataTypeDr: ITEMTYPEID} });
											window.close();
										}
										else {
											var message = "SQLErr: " + jsonData.info;
											Ext.Msg.show({ title: '����', msg: message, buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
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
    text: '��������',
    tooltip: '��������',
    iconCls: 'remove',
    handler: function() { loadSalary() }
});

var totalButton = new Ext.Toolbar.Button({
    text: 'ͳ�ƻ���',
    tooltip: 'ͳ�ƻ���',
    iconCls: 'remove',
    handler: function() { CommFindFun(salaryDs, salaryMain, salaryPagingToolbar) }
});
var salarySearchField = 'itemInName';

var salaryFilterItem = new Ext.Toolbar.MenuButton({
    text: '������',
    tooltip: '�ؼ����������',
    menu: { items: [
				new Ext.menu.CheckItem({ text: '�ڲ���Ŀ', value: 'itemInName', checked: true, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��Ŀ����', value: 'itemCode', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��Ŀ����', value: 'itemName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '�ڲ�����', value: 'servedInDeptName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				//new Ext.menu.CheckItem({ text: '���Ŵ���', value: 'servedDeptCode', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				//new Ext.menu.CheckItem({ text: '��������', value: 'servedDeptName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '�ڲ���Ա', value: 'receiverInName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��Ա����', value: 'receiverCode', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��Ա����', value: 'receiverName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '���', value: 'fee', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��������', value: 'operDate', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '������', value: 'operName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��ע', value: 'remark', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck })
		]
    }
});

function onDataTypesItemCheck(item, checked) {
    if (checked) {
        salarySearchField = item.value;
        salaryFilterItem.setText(item.text + ':');
    }
};

var salarySearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
    width: 180,
    trigger1Class: 'x-form-clear-trigger',
    trigger2Class: 'x-form-search-trigger',
    emptyText: '����...',
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

var salaryPagingToolbar = new Ext.PagingToolbar({//��ҳ������
    pageSize: 25,
    store: salaryDs,
    displayInfo: true,
    displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
    emptyMsg: "û������",
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

var salaryMain = new Ext.grid.GridPanel({//���
    title: '��Ա����',
    store: salaryDs,
    cm: salaryCm,
    trackMouseOver: true,
    stripeRows: true,
    sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
    loadMask: true,
    tbar: ['��������:', months, '-', totalButton],
    bbar: salaryPagingToolbar
});

//salaryDs.load({params:{start:0, limit:salaryPagingToolbar.pageSize}});