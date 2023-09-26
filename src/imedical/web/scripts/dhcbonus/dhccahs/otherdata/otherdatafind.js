CommFindFun = function(dataStore, grid, pagingTool) {

    var tmpUId = "";
    var findCommTabProxy = new Ext.data.HttpProxy({ url: otherdataUrl + '?action=find' });
    var tmpMonth = "";
    var myAct = "";
    function formatDate(value) {
        //alert(value);
        return value ? value.dateFormat('Y-m-d') : '';
    };
    var findCommTabDs = new Ext.data.Store({
        proxy: findCommTabProxy,
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
        remoteSort: true
    });

    findCommTabDs.setDefaultSort('RowId', 'Desc');

    var monNameDs = new Ext.data.Store({
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowid', 'code', 'name', 'desc', 'start', 'end', 'dataFinish'])
    });
    var monName = new Ext.form.ComboBox({
        id: 'monName',
        fieldLabel: '��������',
        width: 100,
        listWidth: 260,
        allowBlank: false,
        store: monNameDs,
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
    monNameDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.vouchdatasexe.csp?action=months&searchValue=' + Ext.getCmp('monName').getRawValue(), method: 'GET' });
    });
    var itemsDs = new Ext.data.Store({
        autoLoad: true,
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowid', 'typeDr', 'typeName', 'typeShortCut', 'order', 'itemDr', 'itemCode', 'itemName', 'itemShortCut'])
    });

    itemsDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.dataitemcorresexe.csp?action=list&searchField=itemShortCut&searchValue=' + Ext.getCmp('items').getRawValue() + '&dataTypeDr=' + itemTypeId, method: 'GET' });
    });

    var items = new Ext.form.ComboBox({
        id: 'items',
        fieldLabel: 'ҵ����',
        store: itemsDs,
        valueField: 'itemDr',
        displayField: 'itemShortCut',
        typeAhead: true,
        pageSize: 10,
        minChars: 1,
        width: 100,
        listWidth: 250,
        triggerAction: 'all',
        emptyText: 'ѡ��ҵ����...',
        allowBlank: true,
        selectOnFocus: true,
        forceSelection: true
    });

    var unitTypeDs = new Ext.data.Store({
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowId', 'code', 'name', 'shortcut', 'remark', 'flag', 'active'])
    });
    var unitType = new Ext.form.ComboBox({
        id: 'unitType',
        fieldLabel: '��Ԫ���',
        width: 100,
        listWidth: 260,
        allowBlank: true,
        store: unitTypeDs,
        valueField: 'rowId',
        displayField: 'shortcut',
        triggerAction: 'all',
        emptyText: 'ѡ��Ԫ���...',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });
    unitTypeDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.unitpersonsexe.csp?action=unitType&searchValue=' + Ext.getCmp('unitType').getRawValue(), method: 'POST' });
    });

    var unitsDs = new Ext.data.Store({
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowId', 'code', 'name', 'shortcut', 'remark', 'flag', 'active'])
    });
    var units = new Ext.form.ComboBox({
        id: 'units',
        fieldLabel: '��Ԫ',
        width: 100,
        listWidth: 260,
        allowBlank: true,
        store: unitsDs,
        valueField: 'rowId',
        displayField: 'shortcut',
        triggerAction: 'all',
        emptyText: 'ѡ��Ԫ...',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });

    unitsDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.unitpersonsexe.csp?action=units&searchValue=' + Ext.getCmp('units').getRawValue() + '&id=' + unitType.getValue(), method: 'POST' });
    });

    var assLocDs = new Ext.data.Store({
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowId', 'code', 'name', 'shortcut', 'address', 'remark', 'startTime', 'stop', 'unitDr', 'propertyDr', 'active'])
    });
    var assLoc = new Ext.form.ComboBox({
        id: 'assLoc',
        fieldLabel: '����',
        width: 100,
        listWidth: 260,
        allowBlank: true,
        store: assLocDs,
        valueField: 'rowId',
        displayField: 'shortcut',
        triggerAction: 'all',
        emptyText: 'ѡ����...',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });

    assLocDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.vouchdatasexe.csp?action=depts&searchField=shortcut&searchValue=' + Ext.getCmp('assLoc').getRawValue() + '&unitsDr=' + units.getValue(), method: 'GET' });
    });

    var personDs = new Ext.data.Store({
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowid', 'code', 'name', 'shortcut', 'gender', 'birthday', 'national', 'birthPlace', 'education', 'title', 'duty', 'state', 'preparation', 'phone', 'remark', 'start', 'stop', 'unitDr', 'unitName', 'active'])
    });
    var person = new Ext.form.ComboBox({
        id: 'person',
        fieldLabel: '��Ա',
        width: 100,
        listWidth: 260,
        allowBlank: true,
        store: personDs,
        valueField: 'rowid',
        displayField: 'shortcut',
        triggerAction: 'all',
        emptyText: 'ѡ����Ա...',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });

    personDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.unitpersonsexe.csp?action=list&searchField=shortcut&searchValue=' + Ext.getCmp('person').getRawValue() + '&id=' + units.getValue() + '&active=Y', method: 'POST' });
    });
    var actionButton = new Ext.Toolbar.Button({
        text: '����',
        tooltip: 'ͨ��������������',
        iconCls: 'add',
        handler: function() {
            tmpMonth = Ext.getCmp("monName").getValue();
            if (tmpMonth == "") {
                Ext.Msg.show({ title: '����', msg: '��ѡ�������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
                return;
            }
            findCommTabDs.load({ params: { start: 0, limit: findCommTabPagingToolbar.pageSize, intervalDr: tmpMonth, dataTypeDr: itemTypeId, deptDr: assLoc.getValue(), personDr: person.getValue(), itemDr: items.getValue()} });
        }
    });

    var findCommTabCm = new Ext.grid.ColumnModel([
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

    var findCommTabPagingToolbar = new Ext.PagingToolbar({//��ҳ������
        pageSize: 15,
        store: findCommTabDs,
        displayInfo: true,
        displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
        emptyMsg: "û������",
        doLoad: function(C) {
            var B = {},
			A = this.paramNames;
            B[A.start] = C;
            B[A.limit] = this.pageSize;
            B['intervalDr'] = tmpMonth;
            B['dataTypeDr'] = itemTypeId;
			B['deptDr'] = assLoc.getValue();
			B['personDr'] = person.getValue();
			B['itemDr'] = items.getValue();
            if (this.fireEvent("beforechange", this, B) !== false) {
                this.store.load({ params: B });
            }
        }

    });


    //==========================================================���==========================================================
    var formPanel = new Ext.grid.GridPanel({
        //title: 'ͨ������',
        store: findCommTabDs,
        cm: findCommTabCm,
        trackMouseOver: true,
        stripeRows: true,
        sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
        loadMask: true,
        tbar: [monName, '-', items, '-', unitType, '-', units, '-', assLoc, '-', actionButton],
        bbar: findCommTabPagingToolbar
    });
    //============================================================����========================================================


    var window = new Ext.Window({
        title: 'ͳ�ƻ���',
        width: 1100,
        height: 500,
        minWidth: 1100,
        minHeight: 500,
        layout: 'fit',
        plain: true,
        modal: true,
        bodyStyle: 'padding:5px;',
        buttonAlign: 'center',
        items: formPanel,
        buttons: [
			{
				text: 'ȡ��',
				handler: function() { window.close(); }
			}
		]
    });

    window.show();
    unitType.on("select", function(cmb, rec, id) {
        units.setRawValue("");
        units.setValue("");
        assLoc.setValue("");
        assLoc.setRawValue("");
        person.setValue("");
        person.setRawValue("");
        unitsDs.load({ params: { start: 0, limit: cmb.pageSize, id: cmb.getValue()} });
    });
    units.on("select", function(cmb, rec, id) {
        assLoc.setValue("");
        assLoc.setRawValue("");
        person.setValue("");
        person.setRawValue("");
        personDs.load({ params: { start: 0, limit: person.pageSize, id: cmb.getValue()} });
        assLocDs.load({ params: { start: 0, limit: assLoc.pageSize, id: cmb.getValue()} });
    });
};