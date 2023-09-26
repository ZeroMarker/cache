CostResultFun = function(repdr, monthDr, deptDr, type) {

    //============================================================���ؼ�=============================================================
	if(type==undefined||type==""){
		type="dist";
	}
    var history = new Array();
    var currentLocation = 0;
    var tmpUId = "";
    var costResultTabProxy = new Ext.data.HttpProxy({ url: costDistSetsUrl + '?action=find&monthDr=' + monthDr + '&deptSet=' + repdr + '&deptDr=' + deptDr + '&type='+type });
    var tmpMonth = "";
    var myAct = "";
    var itemDr = "";

    var costResultTabDs = new Ext.data.Store({
        proxy: costResultTabProxy,
        reader: new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: 'results'
        }, [
		'rowid',
		'distedDeptDr',
		'distedDeptName',
		'distDeptDr',
		'distDeptName',
		'itemDr',
		'itemName',
		'fee',
		'distFlag',
		'dealFlag'
		]),
        remoteSort: true
    });

    costResultTabDs.setDefaultSort('distedDeptName', 'Desc');


    var costResultTabCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
		{
		    header: '����̯����',
		    dataIndex: 'distedDeptName', //or busItemName
		    width: 100,
		    sortable: true
		},
		{
		    header: '��̯����',
		    dataIndex: 'distDeptName',
		    width: 100,
		    sortable: true
		},
		{
		    header: '�ɱ���',
		    dataIndex: 'itemName',
		    width: 100,
		    sortable: true
		},
		{
		    header: '�ɱ����',
		    dataIndex: 'fee',
		    width: 100,
		    align: 'right',
		    renderer: formatNum,
		    sortable: true
		},
		{
		    header: '��̯��־',
		    dataIndex: 'distFlag',
		    width: 100,
		    sortable: true
		},
		{
		    header: "�����־",
		    dataIndex: 'dealFlag',
		    width: 60,
		    sortable: true,
		    renderer: function(v, p, record) {
		        p.css += ' x-grid3-check-col-td';
		        return '<div class="x-grid3-check-col' + (v == 'Y' ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
		    }
		}

		]);
    var nextButton = new Ext.Toolbar.Button({
        text: 'ǰ��',
        tooltip: 'ǰ��',
        disabled: true,
        iconCls: 'add',
        handler: function() {
            backButton.enable();
            currentLocation++;
            if (currentLocation == history.length - 1) nextButton.disable();
            else nextButton.enable();
            costResultTabDs.proxy = history[currentLocation];

            costResultTabDs.load({ params: { start: 0, limit: costResultTabPagingToolbar.pageSize} });
        }
    });

    var backButton = new Ext.Toolbar.Button({
        text: '����',
        tooltip: '����',
        disabled: true,
        iconCls: 'add',
        handler: function() {
            currentLocation--;
            if (currentLocation == 0) backButton.disable();
            else backButton.enable();
            nextButton.enable();
            costResultTabDs.proxy = history[currentLocation];
            costResultTabDs.load({ params: { start: 0, limit: costResultTabPagingToolbar.pageSize} });
        }
    });
    //--------------------------------------------------------
    var costDistSetsSearchField = 'distDeptName';

    var costDistSetsFilterItem = new Ext.Toolbar.MenuButton({
        text: '������',
        tooltip: '�ɱ���̯�����',
        menu: { items: [
					new Ext.menu.CheckItem({ text: '����̯����', value: 'distedDeptName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
					new Ext.menu.CheckItem({ text: '��̯����', value: 'distDeptName', checked: true, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
					new Ext.menu.CheckItem({ text: '�ɱ���', value: 'itemName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
					new Ext.menu.CheckItem({ text: '��̯��־', value: 'distFlag', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
					new Ext.menu.CheckItem({ text: '�����־', value: 'dealFlag', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck })
			]
        }
    });

    function onDataTypesItemCheck(item, checked) {
        if (checked) {
            costDistSetsSearchField = item.value;
            costDistSetsFilterItem.setText(item.text + ':');
        }
    };

    var costDistSetsSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
                costResultTabDs.proxy = new Ext.data.HttpProxy({ url: costDistSetsUrl + '?action=find&monthDr=' + monthDr + '&deptSet=' + repdr + '&deptDr=' + deptDr + '&type='+type });
                costResultTabDs.load({ params: { start: 0, limit: costDistSetsPagingToolbar.pageSize} });
            }
        },
        onTrigger2Click: function() {
            if (this.getValue()) {
                costResultTabDs.proxy = new Ext.data.HttpProxy({
                    url: costDistSetsUrl + '?action=find&monthDr=' + monthDr + '&deptSet=' + repdr + '&deptDr=' + deptDr + '&type='+type+'&searchField=' + costDistSetsSearchField + '&searchValue=' + this.getValue()
                });
                costResultTabDs.load({ params: { start: 0, limit: costDistSetsPagingToolbar.pageSize} });
            }
        }
    });
    //-------------------------------------------------------

    var costResultTabPagingToolbar = new Ext.PagingToolbar({//��ҳ������
        pageSize: 15,
        store: costResultTabDs,
        displayInfo: true,
        displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
        emptyMsg: "û������",
        buttons: ['-', costDistSetsFilterItem, '-', costDistSetsSearchBox],
        doLoad: function(C) {
            var B = {},
				A = this.paramNames;
            B[A.start] = C;
            B[A.limit] = this.pageSize;
            B['itemDr'] = itemDr;
            if (this.fireEvent("beforechange", this, B) !== false) {
                this.store.load({ params: B });
            }
        }

    });

    //==========================================================���==========================================================
    var formPanel = new Ext.grid.GridPanel({
        store: costResultTabDs,
        cm: costResultTabCm,
        trackMouseOver: true,
        stripeRows: true,
        sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
        loadMask: true,
        tbar: [backButton, '-', nextButton],
        bbar: costResultTabPagingToolbar
    });
    //============================================================����========================================================
    formPanel.on('rowdblclick', function(grid, rowIndex, e) {//˫�������ִ��
		//if(type=="dist"){
			var selectedRow = costResultTabDs.data.items[rowIndex];
			var distedDeptDr = "";
			if(type=="dist")distedDeptDr = selectedRow.get("distedDeptDr");
			else distedDeptDr=selectedRow.get("distDeptDr");
			if (distedDeptDr == "") {
				Ext.Msg.show({ title: 'ע��', msg: '���ϼ��ɱ�����!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
				return;
			} else {
				var tmpProxy = new Ext.data.HttpProxy({ url: costDistSetsUrl + '?action=find&monthDr=' + monthDr + '&deptSet=' + repdr + '&deptDr=' + distedDeptDr + '&type='+type });
				history[currentLocation] = formPanel.store.proxy;
				currentLocation++;
				costResultTabDs.proxy = tmpProxy;
				history[currentLocation] = tmpProxy;
				if (currentLocation == 0) backButton.disable();
				else backButton.enable();
			}
			itemDr = selectedRow.get("itemDr");
			costResultTabDs.load({ params: { start: 0, limit: costResultTabPagingToolbar.pageSize, itemDr: itemDr} });
		//}
    });
	
    var window = new Ext.Window({
        title: '�ɱ���̯���',
        width: 750,
        height: 500,
        minWidth: 750,
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
}]
    });
    costResultTabDs.load({ params: { start: 0, limit: costResultTabPagingToolbar.pageSize, type: type} });
	if(type=="disted")window.setTitle("��̯��ϸ");
    window.show();

};