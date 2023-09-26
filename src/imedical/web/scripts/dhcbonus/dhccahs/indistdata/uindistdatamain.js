var inDistDataUrl = 'dhc.ca.indistdataexe.csp';
var inDistDataProxy = new Ext.data.HttpProxy({ url: inDistDataUrl + '?action=list' });
var intervalDr = "";
function formatDate(value) {
    //alert(value);
    return value ? value.dateFormat('Y-m-d') : '';
};

//�ӿڲ���������Դ
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
	    header: '���ݱ�ʶ',
	    dataIndex: 'patType',
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
	    header: '���Ŵ���',
	    dataIndex: 'deptCode',
	    width: 150,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '��������',
	    dataIndex: 'deptName',
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
	    dataIndex: 'inType',
	    width: 100,
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
    inDistDataDs.load({ params: { start: 0, limit: inDistDataPagingToolbar.pageSize, intervalDr: intervalDr} });
});
var addDataTypesButton = new Ext.Toolbar.Button({
    text: '���',
    tooltip: '����µĽӿڲ�����',
    iconCls: 'add',
    handler: function() { addFun(inDistDataDs, inDistDataMain, inDistDataPagingToolbar); }
});

var editDataTypesButton = new Ext.Toolbar.Button({
    text: '�޸�',
    tooltip: '�޸�ѡ���Ľӿڲ�����',
    iconCls: 'remove',
    handler: function() { editFun(inDistDataDs, inDistDataMain, inDistDataPagingToolbar); }
});

var countButton = new Ext.Toolbar.Button({
    text: 'ִ�з���',
    tooltip: 'ִ�з��䵱������',
    iconCls: 'remove',
    handler: function() { 
		if (intervalDr == "") {
			Ext.Msg.show({ title: '����', msg: '��ѡ�������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
			return;
		}
			Ext.MessageBox.confirm('��ʾ', 
							'ȷ��Ҫ������µ�����?', 
							function(btn) {
								if(btn == 'yes')
								{
		    Ext.Ajax.request({
                        url: inDistDataUrl + '?action=count&intervalDr=' + intervalDr,
                        waitMsg: '������...',
                        failure: function(result, request) {
                            Ext.Msg.show({ title: '����', msg: '������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
                        },
                        success: function(result, request) {
                            var jsonData = Ext.util.JSON.decode(result.responseText);
                            if (jsonData.success == 'true') {
                                Ext.Msg.show({ title: 'ע��', msg: '����ɹ�!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
                                inDistDataDs.setDefaultSort('rowid', 'desc');
                                inDistDataDs.load({ params: { start: 0, limit: inDistDataPagingToolbar.pageSize, intervalDr: intervalDr} });
                                //window.close();
                            }
                            else {
                                var message = "";
                                message = "SQLErr: " + jsonData.info;
                                if (jsonData.info == 'EmptyCode') message = '����Ĵ���Ϊ��!';
                                if (jsonData.info == 'EmptyName') message = '���������Ϊ��!';
                                if (jsonData.info == 'EmptyOrder') message = '��������Ϊ��!';
                                if (jsonData.info == 'RepCode') message = '����Ĵ����Ѿ�����!';
                                if (jsonData.info == 'RepName') message = '����������Ѿ�����!';
                                if (jsonData.info == 'RepOrder') message = '���������Ѿ�����!';
                                Ext.Msg.show({ title: '����', msg: message, buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
                            }
                        },
                        scope: this
                    });
				}})
	}
});

var delDataTypesButton = new Ext.Toolbar.Button({
    text: 'ɾ��',
    tooltip: 'ɾ��ѡ���Ľӿڲ�����',
    iconCls: 'remove',
    //disabled: true,
    handler: function() { delFun(inDistDataDs, inDistDataMain, inDistDataPagingToolbar); }
});

var totalButton = new Ext.Toolbar.Button({
    text: 'ͳ�ƻ���',
    tooltip: 'ͳ�ƻ���',
    iconCls: 'remove',
    handler: function() { CommFindFun(inDistDataDs, inDistDataMain, inDistDataPagingToolbar) }
});
var inDistDataSearchField = 'itemName';

var inDistDataFilterItem = new Ext.Toolbar.MenuButton({
    text: '������',
    tooltip: '�ؼ����������',
    menu: { items: [
				new Ext.menu.CheckItem({ text: '���ݱ�ʶ', value: 'patType', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��Ŀ����', value: 'itemCode', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��Ŀ����', value: 'itemName', checked: true, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '���Ŵ���', value: 'deptCode', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��������', value: 'deptName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '�������', value: 'inType', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '���', value: 'fee', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��ע', value: 'remark', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck })
		]
    }
});

function onDataTypesItemCheck(item, checked) {
    if (checked) {
        inDistDataSearchField = item.value;
        inDistDataFilterItem.setText(item.text + ':');
    }
};

var inDistDataSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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

var inDistDataPagingToolbar = new Ext.PagingToolbar({//��ҳ������
    pageSize: 25,
    store: inDistDataDs,
    displayInfo: true,
    displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
    emptyMsg: "û������",
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

//////////////////////////��Ӵ�ӡ��ť by ��ӮӮ
var excelButton = new Ext.Toolbar.Button({
	text:'����excel',        
	tooltip:'����excel',
	iconCls:'add',        
	handler: function(){ 
			if(months.getValue()==""){
				Ext.Msg.alert("��ʾ","��ѡ���������");
			}else{
						//location.href = 'http://10.21.3.129:8080/outload/InDistData?outType=xls&months='+months.getValue();
                                                location.href = 'http://127.0.0.1:8080/outload/InDistData?outType=xls&months='+months.getValue();
			}
		}
});
////////////////////////////////////////////////

var inDistDataMain = new Ext.grid.GridPanel({//���
    title: '����������ݱ�',
    store: inDistDataDs,
    cm: inDistDataCm,
    trackMouseOver: true,
    stripeRows: true,
    sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
    loadMask: true,
    tbar: ['��������:', months, '-',  totalButton,'-',excelButton],
    bbar: inDistDataPagingToolbar
});

//inDistDataDs.load({params:{start:0, limit:inDistDataPagingToolbar.pageSize}});