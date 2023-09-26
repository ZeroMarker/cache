costDistMethods = function(dataStore, grid, pagingTool) {
    var rowObj = grid.getSelections();
    var len = rowObj.length;
	distMethodsDr = "";
    var layerDr = "";
    var active = "";
    var order = "";
    if (len < 1) {
        Ext.Msg.show({ title: 'ע��', msg: '��ѡ��ɱ���̯������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.WARNING });
        return;
    }
    else {
        active = rowObj[0].get("active");
        deptSetDr = rowObj[0].get("deptSetDr");
        myRowid = rowObj[0].get("rowid");
    }
    if (active != "Y") {
        Ext.Msg.show({ title: 'ע��', msg: '����Ϊ��Ч������ӷ�̯����!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.WARNING });
        return;
    }


    var outType = "rec";
    var outDeptTabProxy = new Ext.data.HttpProxy({ url: costDistSetsUrl + '?action=listCostDepts&type=' + outType });

    var costDeptsStore = new Ext.data.SimpleStore({//�ɱ���̯�׳ɱ���̯�׾�Դ
        fields: ['type', 'rowid'],
        data: [['�����ɱ�����', 'inc'], ['�������ɱ�����', 'outc']]
    });
    var outCostDepts = new Ext.form.ComboBox({
        id: 'outCostDepts',
        fieldLabel: '���ڿ�������',
        width: 100,
        listWidth: 260,
        hidden: true,
        allowBlank: false,
        store: costDeptsStore,
        valueField: 'rowid',
        displayField: 'type',
        name: 'outFlag',
        triggerAction: 'all',
        emptyText: '�ɱ���������...',
        mode: 'local',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });
    outCostDepts.on('select', function(combo, record, index) {
        if (distMethodsDr == "") {
            Ext.Msg.show({ title: 'ע��', msg: '��ѡ��ɱ���̯����!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.WARNING });
            return;
        }
        if (combo.getValue() == "inc") {
            outType = "inc";
            outRecDeptsPanel.reconfigure(outRecDeptsTabDs, outRecDeptsTabCm);
            //window.setTitle("�����ɱ�����");
        }
        else {
            outType = "outc";
            outRecDeptsPanel.reconfigure(outRecDeptsTabDs, outRecDeptsTabCm);
            //window.setTitle("�������ɱ�����");
        }
        outRecDeptsTabDs.proxy = new Ext.data.HttpProxy({ url: costDistSetsUrl + '?action=listCostDepts&type=' + outType });
        outRecDeptsTabDs.load({ params: { start: 0, limit: outRecDeptsTabPagingToolbar.pageSize, id: distMethodsDr} });

    });


    var recDeptsStore = new Ext.data.SimpleStore({//�ɱ���̯�׳ɱ���̯�׾�Դ
        fields: ['type', 'rowid'],
        data: [['�������ڿ���', 'inr'], ['���������ڿ���', 'outr']]
    });
    var outRecDepts = new Ext.form.ComboBox({
        id: 'outRecDepts',
        fieldLabel: '���ڿ�������',
        width: 100,
        hidden: true,
        listWidth: 260,
        allowBlank: false,
        store: recDeptsStore,
        valueField: 'rowid',
        displayField: 'type',
        triggerAction: 'all',
        emptyText: '���ڿ�������...',
        mode: 'local',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });
    outRecDepts.on('select', function(combo, record, index) {
        if (combo.getValue() == "inr") {
            outType = "inr";
            outRecDeptsPanel.reconfigure(outRecDeptsTabDs, InRecDeptsCm);
            //window.setTitle("�������ڿ���");
        }
        else {
            outType = "outr";
            outRecDeptsPanel.reconfigure(outRecDeptsTabDs, outRecDeptsTabCm);
            //window.setTitle("���������ڿ���");
        }
        outRecDeptsTabDs.proxy = new Ext.data.HttpProxy({ url: costDistSetsUrl + '?action=listCostDepts&type=' + outType });
        outRecDeptsTabDs.load({ params: { start: 0, limit: outRecDeptsTabPagingToolbar.pageSize, id: distMethodsDr} });
    });


    var outRecDeptsTabDs = new Ext.data.Store({
        proxy: outDeptTabProxy,
        reader: new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: 'results'
        }, [
		'rowid',
		'deptDr',
		'deptCode',
		'deptName',
		'rate'
		]),
        remoteSort: true
    });

    outRecDeptsTabDs.setDefaultSort('RowId', 'Desc');

    var outFlagStore = new Ext.data.SimpleStore({//�ɱ���̯�׳ɱ���̯�׾�Դ
        fields: ['type', 'rowid'],
        data: [['�ɱ�����', 'cost'], ['���ڿ���', 'rec']]
    });
    var outFlag = new Ext.form.ComboBox({
        id: 'outFlag',
        fieldLabel: '��������',
        width: 100,
        listWidth: 260,
        allowBlank: false,
        hidden: true,
        store: outFlagStore,
        valueField: 'rowid',
        displayField: 'type',
        value: 'rec',
        triggerAction: 'all',
        emptyText: '��������...',
        mode: 'local',
        name: 'Flag',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });

    var addRecDeptsButton = new Ext.Toolbar.Button({
        text: '���',
        tooltip: '��ӳɱ���̯����',
        iconCls: 'add',
        handler: function() {
            if (distMethodsDr == "") {
                Ext.Msg.show({ title: 'ע��', msg: '��ѡ��ɱ���̯����������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.WARNING });
                return;
            }
            addCostDeptsFun(outRecDeptsTabDs, outRecDeptsPanel, outRecDeptsTabPagingToolbar, distMethodsDr, outType, outCostDepts, outRecDepts, order, deptSetDr, layerDr);
        }
    });

    var editRecDeptsButton = new Ext.Toolbar.Button({
        text: '�޸�',
        tooltip: '�޸ĳɱ���̯����',
        iconCls: 'remove',
        handler: function() { editCostDeptsFun(outRecDeptsTabDs, outRecDeptsPanel, outRecDeptsTabPagingToolbar, distMethodsDr, outType, outCostDepts, outRecDepts, order, deptSetDr, layerDr); }
    });

    var delRecDeptsButton = new Ext.Toolbar.Button({
        text: 'ɾ��',
        tooltip: 'ɾ���ɱ���̯����',
        iconCls: 'remove',
        handler: function() { delCostDeptsFun(outRecDeptsTabDs, outRecDeptsPanel, outRecDeptsTabPagingToolbar, distMethodsDr, outType); }
    });

    var outRecDeptsTabCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
		    header: '���Ŵ���',
		    dataIndex: 'deptCode',
		    width: 150,
		    sortable: true
		},
		{
		    header: '��������',
		    dataIndex: 'deptName',
		    width: 150,
		    sortable: true
		}
	]);

    var outRecDeptsCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
		    header: '���Ŵ���',
		    dataIndex: 'deptCode',
		    width: 150,
		    sortable: true
		},
		{
		    header: '��������',
		    dataIndex: 'deptName',
		    width: 150,
		    sortable: true
		},
		{
		    header: '����',
		    dataIndex: 'rate',
		    width: 150,
		    sortable: true
		}
	]);

    var outRecDeptsTabPagingToolbar = new Ext.PagingToolbar({//��ҳ������
        pageSize: 15,
        store: outRecDeptsTabDs,
        displayInfo: true,
        displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
        emptyMsg: "û������",
        doLoad: function(C) {
            var B = {},
				A = this.paramNames;
            B[A.start] = C;
            B[A.limit] = this.pageSize;
            //B['layerDr']=layerDr;
            B['id'] = distMethodsDr;
            if (this.fireEvent("beforechange", this, B) !== false) {
                this.store.load({ params: B });
            }
        }

    });


    var outRecDeptsPanel = new Ext.grid.GridPanel({
        store: outRecDeptsTabDs,
        title: '���ڲ�������',
        cm: outRecDeptsTabCm,
        height: 220,
        trackMouseOver: true,
        stripeRows: true,
        sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
        loadMask: true,
        tbar: [addRecDeptsButton, '-', editRecDeptsButton, '-', delRecDeptsButton, '-', '��������:', outFlag, '-', outCostDepts, outRecDepts],
        bbar: outRecDeptsTabPagingToolbar
    });
    //======================================================================================================================
    var tmpUId = "";
    var findCommTabProxy = new Ext.data.HttpProxy({ url: costDistSetsUrl + '?action=listDistParams&id=' + distMethodsDr + '&type=' + myType });
    var tmpMonth = "";
    var myAct = "";

    var paramsTabDs = new Ext.data.Store({
        proxy: findCommTabProxy,
        reader: new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: 'results'
        }, [
		'rowid',
		'paramType',
		'itemDr',
		'itemCode',
		'itemName',
		'right'
		]),
        remoteSort: true
    });

    paramsTabDs.setDefaultSort('RowId', 'Desc');

    var addParamsButton = new Ext.Toolbar.Button({
        text: '���',
        tooltip: '��ӳɱ���̯����',
        iconCls: 'add',
        handler: function() {
            if (distMethodsDr == "") {
                Ext.Msg.show({ title: 'ע��', msg: '��ѡ��ɱ���̯����������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.WARNING });
                return;
            }
            addDistParamsFun(paramsTabDs, paramsPanel, paramsTabPagingToolbar, distMethodsDr, layerDr, deptSetDr, ioFlag);
        }
    });

    var editParamsButton = new Ext.Toolbar.Button({
        text: '�޸�',
        tooltip: '�޸ĳɱ���̯����',
        iconCls: 'remove',
        handler: function() { editCostItemsFun(paramsTabDs, paramsPanel, paramsTabPagingToolbar, distMethodsDr, myType, ioFlag); }
    });

    var delParamsButton = new Ext.Toolbar.Button({
        text: 'ɾ��',
        tooltip: 'ɾ���ɱ���̯����',
        iconCls: 'remove',
        handler: function() { delDistParamsFun(paramsTabDs, paramsPanel, paramsTabPagingToolbar, distMethodsDr, myType); }
    });

    var paramsTabCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
		    header: '��������',
		    dataIndex: 'paramType',
		    width: 150,
		    sortable: true
		},
		{
		    header: '��Ŀ����',
		    dataIndex: 'itemCode',
		    width: 150,
		    sortable: true
		},
		{
		    header: '��Ŀ����',
		    dataIndex: 'itemName',
		    width: 150,
		    sortable: true
		},
		{
		    header: 'Ȩ��',
		    dataIndex: 'right',
		    width: 150,
		    sortable: true
		}
	]);

    var paramsTabPagingToolbar = new Ext.PagingToolbar({//��ҳ������
        pageSize: 15,
        store: paramsTabDs,
        displayInfo: true,
        displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
        emptyMsg: "û������",
        doLoad: function(C) {
            var B = {},
				A = this.paramNames;
            B[A.start] = C;
            B[A.limit] = this.pageSize;
            B['layerDr'] = layerDr;
            B['id'] = myRowid;
            if (this.fireEvent("beforechange", this, B) !== false) {
                this.store.load({ params: B });
            }
        }

    });


    var paramsPanel = new Ext.grid.GridPanel({
        store: paramsTabDs,
        title: '��̯��������',
        height: 220,
        cm: paramsTabCm,
        trackMouseOver: true,
        stripeRows: true,
        sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
        loadMask: true,
        tbar: [addParamsButton, '-', delParamsButton],
        bbar: paramsTabPagingToolbar
    });
    //=======================================================================================================================

    var tmpUId = "";
    var findCommTabProxy = new Ext.data.HttpProxy({ url: costDistSetsUrl + '?action=listCostDepts&type=' + myType });
    var tmpMonth = "";
    var myAct = "";

    var costDeptsStore = new Ext.data.SimpleStore({//�ɱ���̯�׳ɱ���̯�׾�Դ
        fields: ['type', 'rowid'],
        data: [['�����ɱ�����', 'inc'], ['�������ɱ�����', 'outc']]
    });
    var costDepts = new Ext.form.ComboBox({
        id: 'costDepts',
        fieldLabel: '���ڿ�������',
        width: 100,
        listWidth: 260,
        hidden: true,
        allowBlank: false,
        store: costDeptsStore,
        valueField: 'rowid',
        displayField: 'type',
        name: 'distFlag',
        triggerAction: 'all',
        emptyText: '�ɱ���������...',
        mode: 'local',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });
    costDepts.on('select', function(combo, record, index) {
        if (distMethodsDr == "") {
            Ext.Msg.show({ title: 'ע��', msg: '��ѡ��ɱ���̯����!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.WARNING });
            return;
        }
        if (combo.getValue() == "inc") {
            myType = "inc";
            inRecDeptsPanel.reconfigure(costDeptsTabDs, inRecTabCm);
            //window.setTitle("�����ɱ�����");
        }
        else {
            myType = "outc";
            inRecDeptsPanel.reconfigure(costDeptsTabDs, inRecTabCm);
            //window.setTitle("�������ɱ�����");
        }
        costDeptsTabDs.proxy = new Ext.data.HttpProxy({ url: costDistSetsUrl + '?action=listCostDepts&type=' + myType });
        costDeptsTabDs.load({ params: { start: 0, limit: recDeptsTabPagingToolbar.pageSize, id: distMethodsDr} });

    });


    var recDeptsStore = new Ext.data.SimpleStore({//�ɱ���̯�׳ɱ���̯�׾�Դ
        fields: ['type', 'rowid'],
        data: [['�������ڿ���', 'inr'], ['���������ڿ���', 'outr']]
    });
    var recDepts = new Ext.form.ComboBox({
        id: 'recDepts',
        fieldLabel: '���ڿ�������',
        width: 100,
        hidden: true,
        listWidth: 260,
        allowBlank: false,
        store: recDeptsStore,
        valueField: 'rowid',
        displayField: 'type',
        triggerAction: 'all',
        emptyText: '���ڿ�������...',
        mode: 'local',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });
    recDepts.on('select', function(combo, record, index) {
        if (combo.getValue() == "inr") {
            myType = "inr";
            inRecDeptsPanel.reconfigure(costDeptsTabDs, InRecDeptsCm);
            //window.setTitle("�������ڿ���");
        }
        else {
            myType = "outr";
            inRecDeptsPanel.reconfigure(costDeptsTabDs, inRecTabCm);
            //window.setTitle("���������ڿ���");
        }
        costDeptsTabDs.proxy = new Ext.data.HttpProxy({ url: costDistSetsUrl + '?action=listCostDepts&type=' + myType });
        costDeptsTabDs.load({ params: { start: 0, limit: recDeptsTabPagingToolbar.pageSize, id: distMethodsDr} });
    });


    var costDeptsTabDs = new Ext.data.Store({
        proxy: findCommTabProxy,
        reader: new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: 'results'
        }, [
		'rowid',
		'deptDr',
		'deptCode',
		'deptName',
		'rate'
		]),
        remoteSort: true
    });

    costDeptsTabDs.setDefaultSort('RowId', 'Desc');

    var distFlagStore = new Ext.data.SimpleStore({//�ɱ���̯�׳ɱ���̯�׾�Դ
        fields: ['type', 'rowid'],
        data: [['�ɱ�����', 'cost'], ['���ڿ���', 'rec']]
    });
    var distFlag = new Ext.form.ComboBox({
        id: 'distFlag',
        fieldLabel: '��������',
        width: 100,
        listWidth: 260,
        allowBlank: false,
        hidden: true,
        store: distFlagStore,
        valueField: 'rowid',
        displayField: 'type',
        value: 'cost',
        triggerAction: 'all',
        emptyText: '��������...',
        mode: 'local',
        name: 'Flag',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });

    /**distFlag.on('select', function(combo,record,index) {
    var comboValue=distFlag.getValue();
    if(comboValue=="cost"){
    costDepts.show();
    recDepts.setVisible(false);
    //costDepts
    Ext.Ajax.request({
    url: costDistSetsUrl+'?action=checkDepts&id='+distMethodsDr,
    waitMsg:'������...',
    failure: function(result, request) {
    Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
    },
    success: function(result, request) {
    var jsonData = Ext.util.JSON.decode( result.responseText );
    if (jsonData.success=='true') {
    if(jsonData.info=="outc"){
    myType="outc";
    inRecDeptsPanel.reconfigure(costDeptsTabDs,inRecTabCm);
    costDepts.disable();
    costDepts.setValue("�������ɱ�����");
							
    }else if(jsonData.info=="inc"){
    myType="inc";
    inRecDeptsPanel.reconfigure(costDeptsTabDs,inRecTabCm);
    costDepts.disable();
    costDepts.setValue("�����ɱ�����");
    }else{
    myType="inc";
    inRecDeptsPanel.reconfigure(costDeptsTabDs,inRecTabCm);
    costDepts.enable();
    costDepts.setValue("�����ɱ�����");
    }
    costDeptsTabDs.proxy=new Ext.data.HttpProxy({url: costDistSetsUrl + '?action=listCostDepts&id='+distMethodsDr+'&type='+myType});
    costDeptsTabDs.load({params:{start:0, limit:recDeptsTabPagingToolbar.pageSize,id:distMethodsDr}});
    }
    },
    scope: this
    });
    }else{
    recDepts.setVisible(true);
    costDepts.setVisible(false);
    Ext.Ajax.request({
    url: costDistSetsUrl+'?action=checkRecDepts&id='+distMethodsDr,
    waitMsg:'������...',
    failure: function(result, request) {
    Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
    },
    success: function(result, request) {
    var jsonData = Ext.util.JSON.decode( result.responseText );
    if (jsonData.success=='true') {
    if(jsonData.info=="outr"){
    myType="outr";
    recDepts.disable();
    inRecDeptsPanel.reconfigure(costDeptsTabDs,inRecTabCm);
    recDepts.setValue("���������ڿ���");
							
    }else if(jsonData.info=="inr"){
    myType="inr";
    recDepts.disable();
    inRecDeptsPanel.reconfigure(costDeptsTabDs,InRecDeptsCm);
    recDepts.setValue("�������ڿ���");
    }else{
    myType="inr";
    recDepts.enable();
    inRecDeptsPanel.reconfigure(costDeptsTabDs,InRecDeptsCm);
    recDepts.setValue("�������ڿ���");
    }
    costDeptsTabDs.proxy=new Ext.data.HttpProxy({url: costDistSetsUrl + '?action=listCostDepts&id='+distMethodsDr+'&type='+myType});
    costDeptsTabDs.load({params:{start:0, limit:recDeptsTabPagingToolbar.pageSize,id:distMethodsDr}});
    }
    },
    scope: this
    });

		}
    });*/
    var addRecDeptsButton = new Ext.Toolbar.Button({
        text: '���',
        tooltip: '��ӳɱ���̯����',
        iconCls: 'add',
        handler: function() {
            if (distMethodsDr == "") {
                Ext.Msg.show({ title: 'ע��', msg: '��ѡ��ɱ���̯����������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.WARNING });
                return;
            }
            addCostDeptsFun(costDeptsTabDs, inRecDeptsPanel, recDeptsTabPagingToolbar, distMethodsDr, myType, costDepts, recDepts, order, deptSetDr, layerDr);
        }
    });

    var editRecDeptsButton = new Ext.Toolbar.Button({
        text: '�޸�',
        tooltip: '�޸ĳɱ���̯����',
        iconCls: 'remove',
        handler: function() { editCostDeptsFun(costDeptsTabDs, inRecDeptsPanel, recDeptsTabPagingToolbar, distMethodsDr, myType, costDepts, recDepts, order, deptSetDr, layerDr); }
    });

    var delRecDeptsButton = new Ext.Toolbar.Button({
        text: 'ɾ��',
        tooltip: 'ɾ���ɱ���̯����',
        iconCls: 'remove',
        handler: function() { delCostDeptsFun(costDeptsTabDs, inRecDeptsPanel, recDeptsTabPagingToolbar, distMethodsDr, myType); }
    });

    var inRecTabCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
		    header: '���Ŵ���',
		    dataIndex: 'deptCode',
		    width: 150,
		    sortable: true
		},
		{
		    header: '��������',
		    dataIndex: 'deptName',
		    width: 150,
		    sortable: true
		}
	]);

    var InRecDeptsCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
		    header: '���Ŵ���',
		    dataIndex: 'deptCode',
		    width: 150,
		    sortable: true
		},
		{
		    header: '��������',
		    dataIndex: 'deptName',
		    width: 150,
		    sortable: true
		},
		{
		    header: '����',
		    dataIndex: 'rate',
		    width: 150,
		    sortable: true
		}
	]);

    var recDeptsTabPagingToolbar = new Ext.PagingToolbar({//��ҳ������
        pageSize: 15,
        store: costDeptsTabDs,
        displayInfo: true,
        displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
        emptyMsg: "û������",
        doLoad: function(C) {
            var B = {},
				A = this.paramNames;
            B[A.start] = C;
            B[A.limit] = this.pageSize;
            //B['layerDr']=layerDr;
            B['id'] = distMethodsDr;
            if (this.fireEvent("beforechange", this, B) !== false) {
                this.store.load({ params: B });
            }
        }

    });


    var inRecDeptsPanel = new Ext.grid.GridPanel({
        store: costDeptsTabDs,
        title: '�ɱ���������',
        cm: inRecTabCm,
        height: 220,
        trackMouseOver: true,
        stripeRows: true,
        sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
        loadMask: true,
        tbar: [addRecDeptsButton, '-', delRecDeptsButton, '-', '��������:', distFlag, '-', costDepts, recDepts],
        bbar: recDeptsTabPagingToolbar
    });

    //============================================================���ؼ�=============================================================
    var itemSetDr = "";
    var layerDr = "";
    var active = "";

    //20090612
    var tmpUId = "";
    var costItemsCommTabProxy = new Ext.data.HttpProxy({ url: costDistSetsUrl + '?action=listCostItems&id=' + distMethodsDr + '&type=' + myType });
    var tmpMonth = "";
    var myAct = "";

    var costItemStore = new Ext.data.SimpleStore({//�ɱ���̯�׳ɱ���̯�׾�Դ
        fields: ['type', 'rowid'],
        data: [['�����ɱ���', 'in'], ['�����������ɱ���', 'out']]
    });
    var costItemCombo = new Ext.form.ComboBox({
        id: 'costItemCombo',
        fieldLabel: '���ڿ�������',
        width: 100,
        listWidth: 260,
        //hidden:true,
        allowBlank: false,
        store: costItemStore,
        valueField: 'rowid',
        displayField: 'type',
        triggerAction: 'all',
        emptyText: '�ɱ���������...',
        mode: 'local',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });
    costItemCombo.on('select', function(combo, record, index) {
        if (combo.getValue() == "in") {
            var parRef = distMethodsDr;
            if (parRef == "") {
                Ext.Msg.show({ title: 'ע��', msg: '��ѡ��ɱ���̯�׺�����!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.WARNING });
                return;
            }
            itemType = "in";
            itemsPanel.reconfigure(costItemTabDs, itemsTabCm);
            //window.setTitle("�����ɱ�����");
        }
        else {
            var parRef = distMethodsDr;
            if (parRef == "") {
                Ext.Msg.show({ title: 'ע��', msg: '��ѡ��ɱ���̯�׺�����!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.WARNING });
                return;
            }
            itemType = "out";
            itemsPanel.reconfigure(costItemTabDs, itemsTabCm);
            //window.setTitle("�������ɱ�����");
        }
        costItemTabDs.proxy = new Ext.data.HttpProxy({ url: costDistSetsUrl + '?action=listCostItems&type=' + itemType });
        costItemTabDs.load({ params: { start: 0, limit: itemsTabPagingToolbar.pageSize, id: distMethodsDr} });

    });

    var costItemTabDs = new Ext.data.Store({
        proxy: costItemsCommTabProxy,
        reader: new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: 'results'
        }, [
		'rowid',
		'itemDr',
		'itemCode',
		'itemName',
		'rate'
		]),
        remoteSort: true
    });

    costItemTabDs.setDefaultSort('RowId', 'Desc');

    var addItemsButton = new Ext.Toolbar.Button({
        text: '���',
        tooltip: '��ӳɱ���̯����',
        iconCls: 'add',
        handler: function() {
            if (distMethodsDr == "") {
                Ext.Msg.show({ title: 'ע��', msg: '��ѡ��ɱ���̯����������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.WARNING });
                return;
            }
            addCostItemsFun(costItemTabDs, itemsPanel, itemsTabPagingToolbar, costItemCombo);
        }
    });

    var delItemsButton = new Ext.Toolbar.Button({
        text: 'ɾ��',
        tooltip: 'ɾ���ɱ���̯����',
        iconCls: 'remove',
        handler: function() {
            delCostItemFun(costItemTabDs, itemsPanel, itemsTabPagingToolbar, distMethodsDr, itemType);
        }
    });

    var itemsTabCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
		    header: '��Ŀ����',
		    dataIndex: 'itemCode',
		    width: 150,
		    sortable: true
		},
		{
		    header: '��Ŀ����',
		    dataIndex: 'itemName',
		    width: 150,
		    sortable: true
		}
	]);


    var itemsTabPagingToolbar = new Ext.PagingToolbar({//��ҳ������
        pageSize: 15,
        store: costItemTabDs,
        title: 'ƾ֤���ݵ���',
        displayInfo: true,
        displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
        emptyMsg: "û������",
        doLoad: function(C) {
            var B = {},
				A = this.paramNames;
            B[A.start] = C;
            B[A.limit] = this.pageSize;
            B['layerDr'] = layerDr;
            B['id'] = distMethodsDr;
            if (this.fireEvent("beforechange", this, B) !== false) {
                this.store.load({ params: B });
            }
        }

    });


    var itemsPanel = new Ext.grid.GridPanel({
        store: costItemTabDs,
        title: '��̯�ɱ�������',
        height: 220,
        layoutOnTabChange: true,
        autoDestroy: false,
        closeAction: 'hide',
        cm: itemsTabCm,
        trackMouseOver: true,
        stripeRows: true,
        sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
        loadMask: true,
        tbar: [addItemsButton, '-', delItemsButton, '-', '��Ŀ����:', costItemCombo],
        bbar: itemsTabPagingToolbar
    });
    //============================================================���ؼ�=============================================================

    var tmpUId = "";
    var findCommTabProxy = new Ext.data.HttpProxy({ url: costDistSetsUrl + '?action=listMethods' });
    var tmpMonth = "";
    var myAct = "";

    var methodsTabDs = new Ext.data.Store({
        proxy: findCommTabProxy,
        reader: new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: 'results'
        }, [
		'rowid',
		'priority',
		'layerDr',
		'layerName',
		'code',
		'name',
		'itemDr',
		'itemName',
		'paramPeriDr',
		'paramPeriName',
		'active',
		'ioFlag'
		]),
        remoteSort: true
    });

    methodsTabDs.setDefaultSort('RowId', 'Desc');

    var addMethodsButton = new Ext.Toolbar.Button({
        text: '���',
        tooltip: '��ӳɱ���̯����',
        iconCls: 'add',
        handler: function() {
            addMethodsFun(methodsTabDs, methodsPanel, methodsTabPagingToolbar, myRowid, deptSetDr, layerDr);
        }
    });

    var editMethodsButton = new Ext.Toolbar.Button({
        text: '�޸�',
        tooltip: '�޸ĳɱ���̯����',
        iconCls: 'remove',
        handler: function() { editMethodsFun(methodsTabDs, methodsPanel, methodsTabPagingToolbar, myRowid, deptSetDr, layerDr); }
    });

    var delMethodsButton = new Ext.Toolbar.Button({
        text: 'ɾ��',
        tooltip: 'ɾ���ɱ���̯����',
        iconCls: 'remove',
        handler: function() { delMethodsFun(methodsTabDs, methodsPanel, methodsTabPagingToolbar, myRowid, deptSetDr, layerDr); }
    });

    var costDeptsButton = new Ext.Toolbar.Button({
        text: '�ɱ���������',
        tooltip: '�ɱ���������',
        iconCls: 'remove',
        handler: function() { costDeptsFun(methodsTabDs, methodsPanel, methodsTabPagingToolbar, deptSetDr, order, layerDr); }
    });

    var costItemButton = new Ext.Toolbar.Button({
        text: '�ɱ���Ŀ����',
        tooltip: '�ɱ���Ŀ����',
        iconCls: 'remove',
        handler: function() { costItemFun(methodsTabDs, methodsPanel, methodsTabPagingToolbar, deptSetDr); }
    });

    var distParamsButton = new Ext.Toolbar.Button({
        text: '��̯��������',
        tooltip: '��̯��������',
        iconCls: 'remove',
        handler: function() { distParamsFun(methodsTabDs, methodsPanel, methodsTabPagingToolbar, deptSetDr); }
    });

    var methodsTabCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
		    header: '���ȼ�',
		    dataIndex: 'priority', //or busItemName
		    width: 50,
		    sortable: true
		},
		{
		    header: '����',
		    dataIndex: 'code',
		    width: 100,
		    sortable: true
		},
		{
		    header: '����',
		    dataIndex: 'name',
		    width: 100,
		    sortable: true
		},
		{
		    header: '��̯��ɱ���',
		    dataIndex: 'itemName',
		    width: 100,
		    sortable: true
		},
		{
		    header: '��������',
		    dataIndex: 'paramPeriName',
		    width: 100,
		    sortable: true
		},
		{
		    header: "��֧���",
		    dataIndex: 'ioFlag',
		    width: 60,
		    sortable: true,
		    renderer: function(v, p, record) {
		        p.css += ' x-grid3-check-col-td';
		        return '<div class="x-grid3-check-col' + (v == 'Y' ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
		    }
		},
		{
		    header: "��Ч��־",
		    dataIndex: 'active',
		    width: 60,
		    sortable: true,
		    renderer: function(v, p, record) {
		        p.css += ' x-grid3-check-col-td';
		        return '<div class="x-grid3-check-col' + (v == 'Y' ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
		    }
		}

	]);

    var methodsTabPagingToolbar = new Ext.PagingToolbar({//��ҳ������
        pageSize: 15,
        store: methodsTabDs,
        displayInfo: true,
        displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
        emptyMsg: "û������",
        doLoad: function(C) {
            var B = {},
				A = this.paramNames;
            B[A.start] = C;
            B[A.limit] = this.pageSize;
            B['layerDr'] = layerDr;
            B['id'] = myRowid;
            if (this.fireEvent("beforechange", this, B) !== false) {
                this.store.load({ params: B });
            }
        }

    });

    var deptSetDs = new Ext.data.Store({
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['id', 'code', 'name', 'desc', 'remark', 'leaf', 'end', 'active', 'parent', 'uiProvider', 'order', 'recCost', 'hospDr', 'hospName', 'locDr'])
    });
    var deptSet = new Ext.form.ComboBox({
        id: 'deptSet',
        fieldLabel: '���ŷֲ���',
        width: 100,
        listWidth: 260,
        allowBlank: false,
        store: deptSetDs,
        valueField: 'id',
        displayField: 'desc',
        triggerAction: 'all',
        emptyText: '���ŷֲ���...',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });
    deptSetDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.costdistsetsexe.csp?action=listsub&id=' + deptSetDr + '&searchField=desc&active=Y&searchValue=' + Ext.getCmp('deptSet').getRawValue(), method: 'GET' });
    });

    var vouchDatasPanel = new Ext.TabPanel({
        region: 'south',
        activeTab: 0,
		deferredRender:false,
        items: [
			//itemsPanel,	zjw Ϊ���ڷ�̯��������⣬������ʾ˳�� 20160823 
			inRecDeptsPanel,
			itemsPanel,
			paramsPanel,
			outRecDeptsPanel
		]                                 //���Tabs
    });

    //==========================================================���==========================================================
    var methodsPanel = new Ext.grid.GridPanel({
        store: methodsTabDs,
        cm: methodsTabCm,
        height: 200,
        region: 'center',
        trackMouseOver: true,
        stripeRows: true,
        sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
        loadMask: true,
        tbar: [addMethodsButton, '-', editMethodsButton, '-', delMethodsButton, '-', '���ŷֲ�:', deptSet],
        bbar: methodsTabPagingToolbar
    });

    var methodsWindow = new Ext.Window({
        title: '�ɱ���̯����',
        width: 680,
        height: 500,
        layout: 'border',
        plain: true,
        modal: true,
        bodyStyle: 'padding:5px;',
        buttonAlign: 'center',
        items: [methodsPanel, vouchDatasPanel],
        buttons: [
				{
				    text: 'ȡ��',
				    handler: function() { methodsWindow.close(); }
}]
    });
    deptSet.on('select', function(combo, Record, index) {
        var selectedRow = deptSetDs.data.items[index];
        order = selectedRow.data["order"];
        distMethodsDr = "";
        //alert(order);
		itemType="in";
        layerDr = combo.getValue();
        methodsTabDs.load({ params: { start: 0, limit: methodsTabPagingToolbar.pageSize, id: myRowid, layerDr: layerDr} });
        costItemTabDs.load({ params: { start: 0, limit: 0} }); //ˢ�³ɱ���Ŀ
		paramsTabDs.load({ params: { start: 0, limit: 0} }); //����
        costDeptsTabDs.load({ params: { start: 0, limit: 0} });
        outRecDeptsTabDs.load({ params: { start: 0, limit: 0} });
    });

    methodsPanel.on('rowclick', function(grid, rowIndex, e) {
        var selectedRow = methodsTabDs.data.items[rowIndex];
        distMethodsDr = selectedRow.data["rowid"];
        ioFlag = selectedRow.data["ioFlag"];
        Ext.Ajax.request({
            url: costDistSetsUrl + '?action=checkItems&id=' + distMethodsDr,
            waitMsg: '������...',
            failure: function(result, request) {
                Ext.Msg.show({ title: '����', msg: '������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
            },
            success: function(result, request) {
                var jsonData = Ext.util.JSON.decode(result.responseText);
                if (jsonData.success == 'true') {
                    if (jsonData.info == "out") {
                        itemType = "out";
                        itemsPanel.reconfigure(costItemTabDs, itemsTabCm);
                        costItemCombo.disable();
                        costItemCombo.setValue("�������ɱ���");

                    } else if (jsonData.info == "in") {
                        itemType = "in";
                        itemsPanel.reconfigure(costItemTabDs, itemsTabCm);
                        costItemCombo.disable();
                        costItemCombo.setValue("�����ɱ���");
                    } else {
                        itemType = "in";
                        itemsPanel.reconfigure(costItemTabDs, itemsTabCm);
                        costItemCombo.enable();
                        costItemCombo.setValue("�����ɱ���");
                    }
                    costItemTabDs.proxy = new Ext.data.HttpProxy({ url: costDistSetsUrl + '?action=listCostItems&type=' + itemType });
                    costItemTabDs.load({ params: { start: 0, limit: methodsTabPagingToolbar.pageSize, id: distMethodsDr} }); //��Ŀ
                }
            },
            scope: this
        });
        //---------------------------�ɱ�ˢ��-----------------
        var comboValue = distFlag.getValue();
        if (comboValue == "cost") {
            costDepts.show();
            recDepts.setVisible(false);
            //costDepts
            Ext.Ajax.request({
                url: costDistSetsUrl + '?action=checkDepts&id=' + distMethodsDr,
                waitMsg: '������...',
                failure: function(result, request) {
                    Ext.Msg.show({ title: '����', msg: '������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
                },
                success: function(result, request) {
                    var jsonData = Ext.util.JSON.decode(result.responseText);
                    if (jsonData.success == 'true') {
                        if (jsonData.info == "outc") {
                            myType = "outc";
                            //inRecDeptsPanel.reconfigure(costDeptsTabDs, inRecTabCm);
                            costDepts.disable();
                            costDepts.setValue("�������ɱ�����");

                        } else if (jsonData.info == "inc") {
                            myType = "inc";
                            inRecDeptsPanel.reconfigure(costDeptsTabDs, inRecTabCm);
                            costDepts.disable();
                            costDepts.setValue("�����ɱ�����");
                        } else {
                            myType = "inc";
                            inRecDeptsPanel.reconfigure(costDeptsTabDs, inRecTabCm);
                            costDepts.enable();
                            costDepts.setValue("�����ɱ�����");
                        }
                        costDeptsTabDs.proxy = new Ext.data.HttpProxy({ url: costDistSetsUrl + '?action=listCostDepts&type=' + myType });
                        costDeptsTabDs.load({ params: { start: 0, limit: recDeptsTabPagingToolbar.pageSize, id: distMethodsDr} });
                    }
                },
                scope: this
            });
        }
        var outValue = outFlag.getValue();
		
        if (outValue == "rec") {
		
            outRecDepts.setVisible(true);
            outCostDepts.setVisible(false);
            Ext.Ajax.request({
                url: costDistSetsUrl + '?action=checkRecDepts&id=' + distMethodsDr,
                waitMsg: '������...',
                failure: function(result, request) {
                    Ext.Msg.show({ title: '����', msg: '������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
                },
                success: function(result, request) {
                    var jsonData = Ext.util.JSON.decode(result.responseText);
                    if (jsonData.success == 'true') {
                        if (jsonData.info == "outr") {
                            outType = "outr";
                            outRecDepts.disable();
                            outRecDeptsPanel.reconfigure(outRecDeptsTabDs, outRecDeptsTabCm);
                            outRecDepts.setValue("���������ڿ���");

                        } else if (jsonData.info == "inr") {
                            outType = "inr";
                            outRecDepts.disable();
                            outRecDeptsPanel.reconfigure(outRecDeptsTabDs, outRecDeptsCm);
                            outRecDepts.setValue("�������ڿ���");
                        } else {
                            outType = "inr";
                            outRecDepts.enable();
                            outRecDeptsPanel.reconfigure(outRecDeptsTabDs, outRecDeptsCm);
                            outRecDepts.setValue("�������ڿ���");
                        }
                        outRecDeptsTabDs.proxy = new Ext.data.HttpProxy({ url: costDistSetsUrl + '?action=listCostDepts&type=' + outType });
                        outRecDeptsTabDs.load({ params: { start: 0, limit: outRecDeptsTabPagingToolbar.pageSize, id: distMethodsDr} });
                    }
                },
                scope: this
            });

        }


        paramsTabDs.load({ params: { start: 0, limit: paramsTabPagingToolbar.pageSize, id: distMethodsDr} }); //����
        //costDeptsTabDs.load({ params: { start: 0, limit: recDeptsTabPagingToolbar.pageSize, id: distMethodsDr} });
        //outRecDeptsTabDs.load({ params: { start: 0, limit: outRecDeptsTabPagingToolbar.pageSize, id: distMethodsDr} });
    });

    methodsWindow.show();
};