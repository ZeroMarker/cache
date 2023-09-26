function InitMainWindow(){
    var obj = new Object();
    
    obj.EDCode = new Ext.form.TextField({
        id: 'EDCode',
        fieldLabel: ExtToolSetting.RedStarString+'����',
        allowBlank: false
    });
    obj.TypeStore = new Ext.data.SimpleStore({
        fields: ['TypeCode', 'TypeDesc'],
        data: [['T', '˵����'], ['N', '��ֵ��'], ['C', '�����б�'], ['D', '������']]
    });
    obj.EDType = new Ext.form.ComboBox({
        id: 'EDType',
        minChars: 1,
        fieldLabel: ExtToolSetting.RedStarString+'����',
        triggerAction: 'all',
        store: obj.TypeStore,
        mode: 'local',
        valueField: 'TypeCode',
        displayField: 'TypeDesc',
        allowBlank: false
    });
    
    obj.SexStore = new Ext.data.SimpleStore({
        fields: ['SexCode', 'SexDesc'],
        data: [['M', '��'], ['F', 'Ů'], ['N', '����']]
    });
    
    obj.EDSex = new Ext.form.ComboBox({
        id: 'EDSex',
        minChars: 1,
        fieldLabel: '�Ա�',
        triggerAction: 'all',
        store: obj.SexStore,
        mode: 'local',
        valueField: 'SexCode',
        displayField: 'SexDesc'
    });
    obj.EDActive = new Ext.form.Checkbox({
        id: 'EDActive',
        fieldLabel: '����',
        checked: true
    });
    obj.Panel1 = new Ext.Panel({
        id: 'Panel1',
        defaults: {
            width: 200
        },
        buttonAlign: 'center',
        columnWidth: .5,
        layout: 'form',
        items: [obj.EDCode, obj.EDType, obj.EDSex, obj.EDActive]
    });
    obj.EDDesc = new Ext.form.TextField({
        id: 'EDDesc',
        fieldLabel: ExtToolSetting.RedStarString+'����',
        allowBlank: false
    });
    obj.EDDataSource = new Ext.form.TextField({
        id: 'EDDataSource',
        fieldLabel: '������Դ'
    });
    obj.EDUnit = new Ext.form.TextField({
        id: 'EDUnit',
        fieldLabel: '��λ'
    });
    obj.EDID = new Ext.form.TextField({
        id: 'EDID',
        hidden: true
    });
    obj.Panel2 = new Ext.Panel({
        id: 'Panel2',
        defaults: {
            width: 200
        },
        buttonAlign: 'center',
        columnWidth: .5,
        layout: 'form',
        items: [obj.EDDesc, obj.EDDataSource, obj.EDUnit, obj.EDID]
    });
    obj.EDSave = new Ext.Button({
        id: 'EDSave',
        iconCls: 'icon-save',
        text: '����'
    });
    obj.EDClear = new Ext.Button({
        id: 'EDClear',
        iconCls: 'icon-new',
        text: '���'
    });
    obj.EDFind = new Ext.Button({
        id: 'EDFind',
        iconCls: 'icon-find',
        text: '����'
    });
    obj.FormPanelED = new Ext.form.FormPanel({
        id: 'FormPanelED',
        buttonAlign: 'center',
        labelAlign: 'right',
        labelWidth: 80,
        region: 'north',
        layout: 'column',
        collapsible: true,
        frame: true,
        height: 220,
        items: [obj.Panel1, obj.Panel2],
        buttons: [obj.EDSave, obj.EDClear]
    });
    
    obj.EDCode.focus(true, 3);
    ExtTool.SetTabIndex("EDCode$1^EDDesc$2^EDType$3^EDDataSource$4^EDSex$5^EDUnit$6");
    
    obj.WindowED = new Ext.Window({
        id: 'WindowED',
        height: 300,
        buttonAlign: 'center',
        width: 700,
        title: '��������ά��',
        layout: 'fit',
		modal:true,
        items: [obj.FormPanelED]
        ,constrain:true
    });
    
    InitMainWindowEvent(obj);
    
    obj.GridPanelED = '';
    //�¼��������
    obj.EDSave.on("click", obj.EDSave_click, obj);
    obj.EDClear.on("click", obj.EDClear_click, obj);
    
    obj.LoadEvent(arguments);
    return obj;
}

function InitMainPanel(){
    var obj = new Object();
    
    
    obj.GridPanelEDStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
        url: ExtToolSetting.RunQueryPageURL
    }));
    obj.GridPanelEDStore = new Ext.data.Store({
        proxy: obj.GridPanelEDStoreProxy,
        reader: new Ext.data.JsonReader({
            root: 'record',
            totalProperty: 'total',
            idProperty: 'EDID'
        }, [{
            name: 'checked',
            mapping: 'checked'
        }, {
            name: 'EDID',
            mapping: 'EDID'
        }, {
            name: 'EDCode',
            mapping: 'EDCode'
        }, {
            name: 'EDDesc',
            mapping: 'EDDesc'
        }, {
            name: 'EDDataSource',
            mapping: 'EDDataSource'
        }, {
            name: 'EDSex',
            mapping: 'EDSex'
        }, {
            name: 'EDType',
            mapping: 'EDType'
        }, {
            name: 'EDUnit',
            mapping: 'EDUnit'
        }, {
            name: 'EDActive',
            mapping: 'EDActive'
        }, {
            name: 'EditExpression',
            mapping: 'EditExpression'
        }, {
            name: 'EDNote',
            mapping: 'EDNote'
        }])
    });
    
    obj.GridPanelEDCheckCol = new Ext.grid.CheckColumn({
        header: '',
        dataIndex: 'checked',
        width: 50
    });
    obj.GridPanelED = new Ext.grid.GridPanel({
        id: 'GridPanelED',
        store: obj.GridPanelEDStore,
        region: 'center',
        buttonAlign: 'center',
        columns: [new Ext.grid.RowNumberer(), {
            header: 'ID',
            width: 0,
            dataIndex: 'EDID',
            sortable: true
        }, {
            header: '����',
            width: 100,
            dataIndex: 'EDCode',
            sortable: true
        }, {
            header: '����',
            width: 100,
            dataIndex: 'EDDesc',
            sortable: true
        }, {
            header: '������Դ',
            width: 200,
            dataIndex: 'EDDataSource',
            sortable: true
        }, {
            header: '�Ա�',
            width: 100,
            dataIndex: 'EDSex',
            sortable: true,
            renderer: function(value){
                if (value == 'M') {
                    return '��'
                }
                if (value == 'F') {
                    return 'Ů'
                }
                if (value == 'N') {
                    return '����'
                }
            }
        }, {
            header: '����',
            width: 100,
            dataIndex: 'EDType',
            sortable: true,
            renderer: function(value){
                if (value == 'T') {
                    return '˵����'
                }
                if (value == 'N') {
                    return '��ֵ��'
                }
                if (value == 'C') {
                    return '�����б�'
                }
                if (value == 'D') {
                    return '������'
                }
            }
        }, {
            header: '��λ',
            width: 100,
            dataIndex: 'EDUnit',
            sortable: true
        }, {
            header: '����',
            width: 100,
            dataIndex: 'EDActive',
            sortable: true,
            renderer: function(v, p, record){
                p.css += ' x-grid3-check-col-td';
                return '<div class="x-grid3-check-col' +
                (v == 'true' ? '-on' : '') +
                ' x-grid3-cc-' +
                this.id +
                '">&#160;</div>';
            }
        }, {
            header: '�༭���ʽ',
            width: 150,
            dataIndex: 'EditExpression',
            renderer: function(v, c, record, row){
            
                return "<input type='button' value='���ʽά��'>";
                
            }
        }, {
            header: 'EDNote',
            width: 0,
            dataIndex: 'EDNote',
            sortable: true
        }],
        bbar: new Ext.PagingToolbar({
            pageSize: 20,
            store: obj.GridPanelEDStore,
            displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
            displayInfo: true,
            emptyMsg: 'û�м�¼'
        })
    
    });
    
    obj.QUCode = new Ext.form.TextField({
        id: 'QUCode',
        fieldLabel: '����'
    });
    
    obj.QUDesc = new Ext.form.TextField({
        id: 'QUDesc',
        fieldLabel: '����'
    });
    
    obj.PanelQ1 = new Ext.Panel({
        id: 'PanelQ1',
        defaults: {
            width: 200
        },
        buttonAlign: 'center',
        columnWidth: .5,
        layout: 'form',
        items: [obj.QUCode]
    });
    
    obj.PanelQ2 = new Ext.Panel({
        id: 'PanelQ2',
        defaults: {
            width: 200
        },
        buttonAlign: 'center',
        columnWidth: .5,
        layout: 'form',
        items: [obj.QUDesc]
    });
    
    obj.QUAdd = new Ext.Button({
        id: 'QUAdd',
        iconCls: 'icon-add',
        text: '���'
    });
    
    obj.QUClear = new Ext.Button({
        id: 'QUClear',
        iconCls: 'icon-new',
        text: '���'
    });
    
    obj.EDFind = new Ext.Button({
        id: 'EDFind',
        iconCls: 'icon-find',
        text: '����'
    });
    
    obj.FormPanelQU = new Ext.form.FormPanel({
        id: 'FormPanelQU',
        buttonAlign: 'center',
        labelAlign: 'right',
        labelWidth: 80,
        height: 100,
        frame: true,
        title: '��������',
        //collapsible: true,
        region: 'north',
        layout: 'column',
        items: [obj.PanelQ1, obj.PanelQ2],
        buttons: [obj.QUAdd, obj.QUClear, obj.EDFind]
    });
    obj.QUCode.focus(true, 3);
    obj.MainPanel = new Ext.Viewport({
        id: 'MainPanel',
        layout: 'border',
        items: [obj.FormPanelQU, obj.GridPanelED]
    });
    obj.GridPanelEDStoreProxy.on('beforeload', function(objProxy, param){
        param.ClassName = 'web.DHCHM.EvaluationDetailSet';
        param.QueryName = 'FindEVADetail';
        param.Arg1 = obj.QUCode.getValue();
        param.Arg2 = obj.QUDesc.getValue();
        param.ArgCnt = 2;
    });
    obj.GridPanelEDStore.load({
        params: {
            start: 0,
            limit: 20
        }
    });
    
    InitMainPanelEvent(obj);
    //�¼��������
    obj.QUAdd.on("click", obj.QUAdd_click, obj);
    obj.QUClear.on("click", obj.QUClear_click, obj);
    obj.EDFind.on("click", obj.EDFind_click, obj);
    obj.GridPanelED.on("rowdblclick", obj.GridPanelED_rowdblclick, obj);
    obj.GridPanelED.on("cellclick", obj.GridPanelED_cellclick, obj);
    obj.LoadEvent(arguments);
    return obj;
}

