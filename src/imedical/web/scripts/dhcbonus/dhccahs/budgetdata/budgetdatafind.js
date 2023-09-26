CommFindFun = function(dataStore, grid, pagingTool) {

    var tmpUId = "";
    var findCommTabProxy = new Ext.data.HttpProxy({ url: budgetDataUrl + '?action=list' });
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
			'deptDr',
			'deptName',
			'itemDr',
			'itemName',
			'amount',
			'price',
			'fee',
			'remark',
			'type'
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
    var orderField = new Ext.form.NumberField({
        id: 'orderField',
        fieldLabel: '���',
        allowDecimals: false,
        allowBlank: false,
        emptyText: '���...',
        anchor: '90%'
    });

    var remarkField = new Ext.form.TextField({
        id: 'remarkField',
        fieldLabel: '��ע',
        allowBlank: true,
        emptyText: '��ע...',
        anchor: '90%'
    });

    var itemTypeDs = new Ext.data.Store({
        autoLoad: true,
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowid', 'order', 'code', 'name', 'shortcut', 'remark', 'active'])
    });

    itemTypeDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.dataitemcorresexe.csp?action=listtype&searchField=shortcut&searchValue=' + Ext.getCmp('itemTypesCombo').getRawValue(), method: 'GET' });
    });

    var itemTypesCombo = new Ext.form.ComboBox({
        id: 'itemTypesCombo',
        fieldLabel: '��Ŀ���',
        store: itemTypeDs,
        valueField: 'rowid',
        displayField: 'shortcut',
        typeAhead: true,
        pageSize: 10,
        minChars: 1,
        width: 100,
        listWidth: 250,
        triggerAction: 'all',
        emptyText: 'ѡ�����������...',
        allowBlank: false,
        selectOnFocus: true,
        forceSelection: true
    });

    var itemsDs = new Ext.data.Store({
        autoLoad: true,
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowid', 'typeDr', 'typeName', 'typeShortCut', 'order', 'itemDr', 'itemCode', 'itemName', 'itemShortCut'])
    });

    itemsDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.vouchdatasexe.csp?action=items&searchField=itemShortCut&searchValue=' + Ext.getCmp('items').getRawValue() + '&id=' + itemTypesCombo.getValue(), method: 'GET' });
    });

    var items = new Ext.form.ComboBox({
        id: 'items',
        fieldLabel: '������',
        store: itemsDs,
        valueField: 'itemDr',
        displayField: 'itemShortCut',
        typeAhead: true,
        pageSize: 10,
        minChars: 1,
        width: 100,
        listWidth: 250,
        triggerAction: 'all',
        emptyText: 'ѡ��������...',
        allowBlank: false,
        name: 'items',
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
        allowBlank: false,
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
        allowBlank: false,
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
        allowBlank: false,
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
        allowBlank: false,
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

    var formStore = new Ext.data.SimpleStore({//������Ͽ�����ʾ������Դ
        fields: ['type', 'rowid'],
        data: [['סԺ', 'I'], ['����', 'O']]
    });
    var formComm = new Ext.form.ComboBox({
        id: 'formComm',
        fieldLabel: '�������',
        width: 100,
        listWidth: 260,
        allowBlank: false,
        store: formStore,
        valueField: 'rowid',
        displayField: 'type',
        triggerAction: 'all',
        emptyText: '�������...',
        mode: 'local',
        name: 'Flag',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });

	var flagStore = new Ext.data.SimpleStore({//������Ͽ�����ʾ������Դ
        fields: ['type', 'rowid'],
        data: [['���', 'price'], ['����', 'amount']]
    });
    var flagComm = new Ext.form.ComboBox({
        id: 'flagComm',
        fieldLabel: '���ݱ�ʶ',
        width: 100,
        listWidth: 260,
        allowBlank: false,
        store: flagStore,
        valueField: 'rowid',
        displayField: 'type',
        triggerAction: 'all',
		value:'price',
        emptyText: '���ݱ�ʶ...',
        mode: 'local',
        name: 'Flag',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
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
            var itemTypes = itemTypesCombo.getValue();
            var itemDr = items.getValue();
            var deptDr = assLoc.getValue();
            var type = flagComm.getValue();
            findCommTabDs.load({ params: { start: 0, limit: findCommTabPagingToolbar.pageSize, intervalDr: tmpMonth, deptDr: deptDr, itemDr: itemDr, type: type, findType: "find"} });
        }
    });

    var findCommTabCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
	{
	    header: '��������',
	    dataIndex: 'deptName',
	    width: 100,
	    align: 'left',
	    sortable: true
	},
	{
	    header: 'ҵ��������',
	    dataIndex: 'itemName',
	    width: 100,
	    align: 'left',
	    sortable: true
	},

	{
	    header: '����',
	    dataIndex: 'amount',
	    width: 70,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '����',
	    dataIndex: 'price',
	    width: 100,
	    align: 'right',
	    renderer: formatNum,
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
            var itemTypes = itemTypesCombo.getValue();
            var itemDr = items.getValue();
            var deptDr = assLoc.getValue();
            var flag = flagComm.getValue();
            var inType = formComm.getValue();
            B['intervalDr'] = tmpMonth;
            B['deptDr'] = deptDr;
            B['type'] = flag;
            B['itemDr'] = itemDr;
            B['findType'] = "find";
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
        tbar: [monName, '-', itemTypesCombo, '-', items, '-', unitType, '-', units, '-', assLoc, '-', flagComm, '-', actionButton],
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
    itemTypesCombo.on("select", function(cmb, rec, id) {
        items.setRawValue("");
        items.setValue("");
        itemsDs.load({ params: { start: 0, limit: cmb.pageSize, id: cmb.getValue()} });
    });
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