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
        fieldLabel: '核算区间',
        width: 100,
        listWidth: 260,
        allowBlank: false,
        store: monNameDs,
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
        fieldLabel: '业务项',
        store: itemsDs,
        valueField: 'itemDr',
        displayField: 'itemShortCut',
        typeAhead: true,
        pageSize: 10,
        minChars: 1,
        width: 100,
        listWidth: 250,
        triggerAction: 'all',
        emptyText: '选择业务项...',
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
        fieldLabel: '单元类别',
        width: 100,
        listWidth: 260,
        allowBlank: true,
        store: unitTypeDs,
        valueField: 'rowId',
        displayField: 'shortcut',
        triggerAction: 'all',
        emptyText: '选择单元类别...',
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
        fieldLabel: '单元',
        width: 100,
        listWidth: 260,
        allowBlank: true,
        store: unitsDs,
        valueField: 'rowId',
        displayField: 'shortcut',
        triggerAction: 'all',
        emptyText: '选择单元...',
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
        fieldLabel: '部门',
        width: 100,
        listWidth: 260,
        allowBlank: true,
        store: assLocDs,
        valueField: 'rowId',
        displayField: 'shortcut',
        triggerAction: 'all',
        emptyText: '选择部门...',
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
        fieldLabel: '人员',
        width: 100,
        listWidth: 260,
        allowBlank: true,
        store: personDs,
        valueField: 'rowid',
        displayField: 'shortcut',
        triggerAction: 'all',
        emptyText: '选择人员...',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });

    personDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.unitpersonsexe.csp?action=list&searchField=shortcut&searchValue=' + Ext.getCmp('person').getRawValue() + '&id=' + units.getValue() + '&active=Y', method: 'POST' });
    });
    var actionButton = new Ext.Toolbar.Button({
        text: '搜索',
        tooltip: '通过条件进行搜索',
        iconCls: 'add',
        handler: function() {
            tmpMonth = Ext.getCmp("monName").getValue();
            if (tmpMonth == "") {
                Ext.Msg.show({ title: '错误', msg: '请选择核算区间再试!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
                return;
            }
            findCommTabDs.load({ params: { start: 0, limit: findCommTabPagingToolbar.pageSize, intervalDr: tmpMonth, dataTypeDr: itemTypeId, deptDr: assLoc.getValue(), personDr: person.getValue(), itemDr: items.getValue()} });
        }
    });

    var findCommTabCm = new Ext.grid.ColumnModel([
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

    var findCommTabPagingToolbar = new Ext.PagingToolbar({//分页工具栏
        pageSize: 15,
        store: findCommTabDs,
        displayInfo: true,
        displayMsg: '当前显示{0} - {1}，共计{2}',
        emptyMsg: "没有数据",
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


    //==========================================================面板==========================================================
    var formPanel = new Ext.grid.GridPanel({
        //title: '通用数据',
        store: findCommTabDs,
        cm: findCommTabCm,
        trackMouseOver: true,
        stripeRows: true,
        sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
        loadMask: true,
        tbar: [monName, '-', items, '-', unitType, '-', units, '-', assLoc, '-', actionButton],
        bbar: findCommTabPagingToolbar
    });
    //============================================================窗口========================================================


    var window = new Ext.Window({
        title: '统计汇总',
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
				text: '取消',
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