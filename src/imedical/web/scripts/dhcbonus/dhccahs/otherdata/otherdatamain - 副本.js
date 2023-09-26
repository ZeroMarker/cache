var otherdataUrl = 'dhc.ca.otherdataexe.csp';
var otherdataProxy = new Ext.data.HttpProxy({ url: otherdataUrl + '?action=list' });
var intervalDr = "";
var itemTypeId = "";
function formatDate(value) {
    //alert(value);
    return value ? value.dateFormat('Y-m-d') : '';
};

//�ӿڲ���������Դ
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
	    header: '�ڲ���������',
	    dataIndex: 'servedInDeptName',
	    width: 150,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '���Ŵ���',
	    dataIndex: 'servedDeptCode',
	    width: 100,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '��������',
	    dataIndex: 'servedDeptName',
	    width: 150,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '���',
	    dataIndex: 'fee',
	    width: 100,
	    align: 'left',
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
    //otherdataDs.load({ params: { start: 0, limit: otherdataPagingToolbar.pageSize, intervalDr: intervalDr, dataTypeDr: itemTypeId} });
});
var addDataTypesButton = new Ext.Toolbar.Button({
    text: '���',
    tooltip: '����µĽӿڲ�����',
    iconCls: 'add',
    handler: function() { addFun(otherdataDs, otherdataMain, otherdataPagingToolbar); }
});

var editDataTypesButton = new Ext.Toolbar.Button({
    text: '�޸�',
    tooltip: '�޸�ѡ���Ľӿڲ�����',
    iconCls: 'remove',
    disabled: true,
    handler: function() { editFun(otherdataDs, otherdataMain, otherdataPagingToolbar); }
});

var delDataTypesButton = new Ext.Toolbar.Button({
    text: 'ɾ��',
    tooltip: 'ɾ��ѡ���Ľӿڲ�����',
    iconCls: 'remove',
    disabled: true,
    handler: function() { delFun(otherdataDs, otherdataMain, otherdataPagingToolbar); }
});

var relationButton = new Ext.Toolbar.Button({
    text: 'ִ�ж���',
    tooltip: 'ִ�ж���',
    iconCls: 'remove',
    handler: function() {refreshFun(otherdataDs, otherdataMain, otherdataPagingToolbar)}
});

var importButton = new Ext.Toolbar.Button({
    text: '��������',
    tooltip: '��������',
    iconCls: 'remove',
    handler: function() { loadBusData(otherdataDs,otherdataPagingToolbar) }
});

var totalButton = new Ext.Toolbar.Button({
    text: 'ͳ�ƻ���',
    tooltip: 'ͳ�ƻ���',
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
		fieldLabel:'������',
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
		emptyText:'ѡ�����������...',
		allowBlank: true,
		selectOnFocus: true,
		forceSelection: true
	});
	itemTypeSelecter.on("select", function(cmb, rec, id) {
		if (intervalDr == "") {
			Ext.Msg.show({ title: '����', msg: '��ѡ�������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
			return;
		}
		itemTypeId = cmb.getValue();
		otherdataDs.load({ params: { start: 0, limit: otherdataPagingToolbar.pageSize, intervalDr: intervalDr, dataTypeDr: itemTypeId} });
	});
var otherdataSearchField = 'itemInName';

var otherdataFilterItem = new Ext.Toolbar.MenuButton({
    text: '������',
    tooltip: '�ؼ����������',
    menu: { items: [
				new Ext.menu.CheckItem({ text: '�ڲ���Ŀ', value: 'itemInName', checked: true, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��Ŀ����', value: 'itemCode', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��Ŀ����', value: 'itemName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '�ڲ�����', value: 'servedInDeptName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '���Ŵ���', value: 'servedDeptCode', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��������', value: 'servedDeptName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				//new Ext.menu.CheckItem({ text: '�ڲ���Ա', value: 'receiverInName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				//new Ext.menu.CheckItem({ text: '��Ա����', value: 'receiverCode', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				//new Ext.menu.CheckItem({ text: '��Ա����', value: 'receiverName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '���', value: 'fee', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��������', value: 'operDate', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '������', value: 'operName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��ע', value: 'remark', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck })
		]
    }
});

function onDataTypesItemCheck(item, checked) {
    if (checked) {
        otherdataSearchField = item.value;
        otherdataFilterItem.setText(item.text + ':');
    }
};

var otherdataSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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

var otherdataPagingToolbar = new Ext.PagingToolbar({//��ҳ������
    pageSize: 25,
    store: otherdataDs,
    displayInfo: true,
    displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
    emptyMsg: "û������",
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

var otherdataMain = new Ext.grid.GridPanel({//���
    title: '��������',
    store: otherdataDs,
    cm: otherdataCm,
    trackMouseOver: true,
    stripeRows: true,
    //sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
    sm: new Ext.grid.CheckboxSelectionModel(),
    loadMask: true,
    tbar: ['��������:', months, '-',itemTypeSelecter,'-', addDataTypesButton, '-', editDataTypesButton, '-', delDataTypesButton, '-', importButton, '-', relationButton, '-', totalButton],
    bbar: otherdataPagingToolbar
});

//otherdataDs.load({params:{start:0, limit:otherdataPagingToolbar.pageSize}});