
function InitMainWindow(){
    var obj = new Object();
    
    obj.SexStore = new Ext.data.SimpleStore({
        fields: ['SexCode', 'SexDesc'],
        data: [['M', '男'], ['F', '女'], ['N', '不限']]
    });
    
    obj.QDCode = new Ext.form.TextField({
        id: 'QDCode',
        fieldLabel: ExtToolSetting.RedStarString+'编码',
        allowBlank: false
    });
    
    obj.TypeStore = new Ext.data.SimpleStore({
        fields: ['TypeCode', 'TypeDesc'],
        data: [['T', '说明型'], ['N', '数值型'], ['M', '多选型'], ['S', '单选型'], ['D', '日期型']]
    });
    
    obj.QDType = new Ext.form.ComboBox({
        id: 'QDType',
        minChars: 1,
        fieldLabel: ExtToolSetting.RedStarString+'类型',
        triggerAction: 'all',
        store: obj.TypeStore,
        mode: 'local',
        valueField: 'TypeCode',
        displayField: 'TypeDesc',
        allowBlank: false
    });
    
    obj.QDSex = new Ext.form.ComboBox({
        id: 'QDSex',
        minChars: 1,
        fieldLabel: '性别',
        triggerAction: 'all',
        store: obj.SexStore,
        mode: 'local',
        valueField: 'SexCode',
        displayField: 'SexDesc'
    });
    obj.QDElementNum = new Ext.form.NumberField({
        id: 'QDElementNum',
        fieldLabel: '显示列数'
    });
    obj.QDActive = new Ext.form.Checkbox({
        id: 'QDActive',
        fieldLabel: '激活',
        checked: true
    });
    obj.PanelF1 = new Ext.Panel({
        id: 'PanelF1',
        defaults: {
            width: 200
        },
        buttonAlign: 'center',
        columnWidth: .5,
        layout: 'form',
        items: [obj.QDCode, obj.QDType, obj.QDSex, obj.QDElementNum, obj.QDActive]
    });
    
    
    
    obj.QDDesc = new Ext.form.TextField({
        id: 'QDDesc',
        fieldLabel: ExtToolSetting.RedStarString+'描述',
        allowBlank: false
    });
    obj.QDUnit = new Ext.form.TextField({
        id: 'QDUnit',
        fieldLabel: '单位'
    });
    obj.QDLinkCode = new Ext.form.TextField({
        id: 'QDLinkCode',
        fieldLabel: '外部关联码'
    });
    obj.QDRequired = new Ext.form.Checkbox({
        id: 'QDRequired',
        fieldLabel: '必填'
    });
    obj.QDID = new Ext.form.TextField({
        id: 'QDID',
        hidden: true
    });
    obj.PanelF2 = new Ext.Panel({
        id: 'PanelF2',
        defaults: {
            width: 200
        },
        buttonAlign: 'center',
        columnWidth: .5,
        layout: 'form',
        items: [obj.QDDesc, obj.QDUnit, obj.QDLinkCode, obj.QDRequired, obj.QDID]
    });
    obj.QDRemark = new Ext.form.TextArea({
        id: 'QDRemark',
        width: 500,
        height: 40,
        fieldLabel: '备注'
    });
    obj.PanelF3 = new Ext.Panel({
        id: 'PanelF3',
        buttonAlign: 'center',
        columnWidth: 1,
        layout: 'form',
        items: [obj.QDRemark]
    });
    obj.QDSave = new Ext.Button({
        id: 'QDSave',
        iconCls: 'icon-save',
        text: '保存'
    });
    
    obj.QDClear = new Ext.Button({
        id: 'QDClear',
        iconCls: 'icon-new',
        text: '清空'
    });
    obj.FormPanelQD = new Ext.form.FormPanel({
        id: 'FormPanelQD',
        buttonAlign: 'center',
        labelAlign: 'right',
        labelWidth: 80,
        frame: true,
        height: 260,
        collapsible: true,
        layout: 'column',
        items: [obj.PanelF1, obj.PanelF2, obj.PanelF3],
        buttons: [obj.QDSave, obj.QDClear]
    });
    
    obj.QDCode.focus(true, 3);
    ExtTool.SetTabIndex("QDCode$1^QDDesc$2^QDType$3^QDUnit$4^QDSex$5^QDLinkCode$6^QDElementNum$7^QDRemark$7");
    
    obj.WindowQD = new Ext.Window({
        id: 'WindowQD',
        height: 400,
        buttonAlign: 'center',
        width: 700,
        title: '问卷内容维护',
        modal : true,
        layout: 'fit',
        items: [obj.FormPanelQD]
        ,constrain:true
    });
    
    InitMainWindowEvent(obj);
    
    obj.GridPanelQD = '';
    //事件处理代码
    obj.QDSave.on("click", obj.QDSave_click, obj);
    obj.QDClear.on("click", obj.QDClear_click, obj);
    
    obj.LoadEvent(arguments);
    return obj;
}


function InitMainPanel(){
    var obj = new Object();
    obj.SexStore = new Ext.data.SimpleStore({
        fields: ['SexCode', 'SexDesc'],
        data: [['M', '男'], ['F', '女'], ['N', '不限']]
    });
    
    obj.GridPanelQDOStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
        url: ExtToolSetting.RunQueryPageURL
    }));
    obj.GridPanelQDOStore = new Ext.data.Store({
        proxy: obj.GridPanelQDOStoreProxy,
        reader: new Ext.data.JsonReader({
            root: 'record',
            totalProperty: 'total',
            idProperty: 'QDOID'
        }, [{
            name: 'checked',
            mapping: 'checked'
        }, {
            name: 'QDOID',
            mapping: 'QDOID'
        }, {
            name: 'QDODesc',
            mapping: 'QDODesc'
        }, {
            name: 'QDOSex',
            mapping: 'QDOSex'
        }, {
            name: 'QDOOrder',
            mapping: 'QDOOrder'
        }, {
            name: 'QDOActive',
            mapping: 'QDOActive'
        }, {
            name: 'QDODefault',
            mapping: 'QDODefault'
        }, {
            name: 'QDOClass',
            mapping: 'QDOClass'
        }, {
            name: 'QDONote',
            mapping: 'QDONote'
        }])
    });
    obj.GridPanelQDOCheckCol = new Ext.grid.CheckColumn({
        header: '',
        dataIndex: 'checked',
        width: 50
    });
    obj.GridPanelQDO = new Ext.grid.GridPanel({
        id: 'GridPanelQDO',
        store: obj.GridPanelQDOStore,
        buttonAlign: 'center',
        region: 'center',
        columns: [{
            header: 'ID',
            hidden:true,
            dataIndex: 'QDOID',
            sortable: true
        }, {
            header: '描述',
            width: 100,
            dataIndex: 'QDODesc',
            sortable: true
        }, {
            header: '性别',
            width: 50,
            dataIndex: 'QDOSex',
            sortable: true,
            renderer: function(value){
                if (value == 'M') {
                    return '男'
                }
                if (value == 'F') {
                    return '女'
                }
                if (value == 'N') {
                    return '不限'
                }
            }
        }, {
            header: '顺序',
            width: 50,
            dataIndex: 'QDOOrder',
            sortable: true
        }, {
            header: '激活',
            width: 50,
            dataIndex: 'QDOActive',
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
            header: '默认',
            width: 50,
            dataIndex: 'QDODefault',
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
            header: '级别',
            width: 50,
            dataIndex: 'QDOClass',
            sortable: true
        }, {
            header: 'QDONote',
            hidden:true,
            dataIndex: 'QDONote',
            sortable: true
        }]
    });
    obj.QDODesc = new Ext.form.TextField({
        id: 'QDODesc',
        fieldLabel: ExtToolSetting.RedStarString+'描述',
        allowBlank: false
    });
    obj.QDOOrder = new Ext.form.NumberField({
        id: 'QDOOrder',
        fieldLabel: '顺序号'
    });
    obj.QDOClass = new Ext.form.TextField({
        id: 'QDOClass',
        fieldLabel: '级别'
    });
    obj.QDOSex = new Ext.form.ComboBox({
        id: 'QDOSex',
        minChars: 1,
        fieldLabel: '性别',
        triggerAction: 'all',
        store: obj.SexStore,
        mode: 'local',
        valueField: 'SexCode',
        displayField: 'SexDesc'
    });
    obj.QDODefault = new Ext.form.Checkbox({
        id: 'QDODefault',
        fieldLabel: '默认值'
    });
    obj.QDOActive = new Ext.form.Checkbox({
        id: 'QDOActive',
        fieldLabel: '激活',
        checked: true
    });
    obj.QDOParRef = new Ext.form.TextField({
        id: 'QDOParRef',
        hidden: true
    });
    obj.QDOID = new Ext.form.TextField({
        id: 'QDOID',
        hidden: true
    });
    obj.QDOSave = new Ext.Button({
        id: 'QDOSave',
        iconCls: 'icon-save',
        text: '保存'
    });
    obj.QDOClear = new Ext.Button({
        id: 'QDOClear',
        iconCls: 'icon-new',
        text: '清空'
    });
    obj.FormPanelQDO = new Ext.form.FormPanel({
        id: 'FormPanelQDO',
        buttonAlign: 'center',
        labelAlign: 'right',
        labelWidth: 80,
        defaults: {
            width: 200
        },
        height: 230,
        //collapsible: true,
        region: 'north',
        items: [obj.QDODesc, obj.QDOOrder, obj.QDOClass, obj.QDOSex, obj.QDODefault, obj.QDOActive, obj.QDOParRef, obj.QDOID],
        buttons: [obj.QDOSave, obj.QDOClear]
    });
    obj.PanelQDO = new Ext.Panel({
        id: 'PanelQDO',
        buttonAlign: 'center',
        width: 380,
        title: '选择项',
        collapsible: true,
        region: 'east',
        layout: 'border',
        frame: true,
        items: [obj.GridPanelQDO, obj.FormPanelQDO]
    });
    
    obj.QUCode = new Ext.form.TextField({
        id: 'QUCode',
        fieldLabel: '编码'
    });
    
    obj.QUDesc = new Ext.form.TextField({
        id: 'QUDesc',
        fieldLabel: '描述'
    });
    
    obj.PanelQ1 = new Ext.Panel({
        id: 'PanelQ1',
        defaults: {
            //width: 200
            anchor:'90%'
        },
        buttonAlign: 'center',
        columnWidth: .5,
        layout: 'form',
        items: [obj.QUCode]
    });
    
    obj.PanelQ2 = new Ext.Panel({
        id: 'PanelQ2',
        defaults: {
            anchor:'90%'
        },
        buttonAlign: 'center',
        columnWidth: .5,
        layout: 'form',
        items: [obj.QUDesc]
    });
    
    obj.GridPanelQDStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
        url: ExtToolSetting.RunQueryPageURL
    }));
    obj.GridPanelQDStore = new Ext.data.Store({
        proxy: obj.GridPanelQDStoreProxy,
        reader: new Ext.data.JsonReader({
            root: 'record',
            totalProperty: 'total',
            idProperty: 'QDID'
        }, [{
            name: 'checked',
            mapping: 'checked'
        }, {
            name: 'QDID',
            mapping: 'QDID'
        }, {
            name: 'QDCode',
            mapping: 'QDCode'
        }, {
            name: 'QDDesc',
            mapping: 'QDDesc'
        }, {
            name: 'QDType',
            mapping: 'QDType'
        }, {
            name: 'QDUnit',
            mapping: 'QDUnit'
        }, {
            name: 'QDSex',
            mapping: 'QDSex'
        }, {
            name: 'QDLinkCode',
            mapping: 'QDLinkCode'
        }, {
            name: 'QDElementNum',
            mapping: 'QDElementNum'
        }, {
            name: 'QDActive',
            mapping: 'QDActive'
        }, {
            name: 'QDRequired',
            mapping: 'QDRequired'
        }, {
            name: 'QDRemark',
            mapping: 'QDRemark'
        }, {
            name: 'QDNote',
            mapping: 'QDNote'
        }])
    });
    obj.GridPanelQDCheckCol = new Ext.grid.CheckColumn({
        header: '',
        dataIndex: 'checked',
        width: 50
    });
    obj.GridPanelQD = new Ext.grid.GridPanel({
        id: 'GridPanelQD',
        store: obj.GridPanelQDStore,
        region: 'center',
        buttonAlign: 'center',
        columns: [{
            header: 'ID',
            width: 40,
            dataIndex: 'QDID',
            sortable: true
        }, {
            header: '编码',
            width: 100,
            dataIndex: 'QDCode',
            sortable: true
        }, {
            header: '描述',
            width: 110,
            dataIndex: 'QDDesc',
            sortable: true
        }, {
            header: '类型',
            width: 80,
            dataIndex: 'QDType',
            sortable: true,
            renderer: function(value){
                if (value == 'T') {
                    return '说明型'
                }
                if (value == 'N') {
                    return '数值型'
                }
                if (value == 'M') {
                    return '多选型'
                }
                if (value == 'S') {
                    return '单选型'
                }
                if (value == 'D') {
                    return '日期型'
                }
            }
        }, {
            header: '单位',
            width: 80,
            dataIndex: 'QDUnit',
            sortable: true
        }, {
            header: '性别',
            width: 50,
            dataIndex: 'QDSex',
            sortable: true,
            renderer: function(value){
                if (value == 'M') {
                    return '男'
                }
                if (value == 'F') {
                    return '女'
                }
                if (value == 'N') {
                    return '不限'
                }
            }
        }, {
            header: '关联码',
            width: 100,
            dataIndex: 'QDLinkCode',
            sortable: true
        }, {
            header: '列数',
            width: 50,
            dataIndex: 'QDElementNum',
            sortable: true
        }, {
            header: '激活',
            width: 40,
            dataIndex: 'QDActive',
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
            header: '必填',
            width: 40,
            dataIndex: 'QDRequired',
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
            header: '备注',
            width: 125,
            dataIndex: 'QDRemark',
            sortable: true
        }, {
            header: 'QDNote',
            hidden:true,
            dataIndex: 'QDNote',
            sortable: true
        }],
        bbar: new Ext.PagingToolbar({
            pageSize: 20,
            store: obj.GridPanelQDStore,
            displayMsg: '显示记录： {0} - {1} 合计： {2}',
            displayInfo: true,
            emptyMsg: '没有记录'
        })
    
    });
    
    obj.QUAdd = new Ext.Button({
        id: 'QUAdd',
        iconCls: 'icon-add',
        text: '添加'
    });
    
    obj.QUClear = new Ext.Button({
        id: 'QUClear',
        iconCls: 'icon-new',
        text: '清空'
    });
    
    obj.QDFind = new Ext.Button({
        id: 'QDFind',
        iconCls: 'icon-find',
        text: '查找'
    });
    
    obj.FormPanelQU = new Ext.form.FormPanel({
        id: 'FormPanelQU',
        buttonAlign: 'center',
        labelAlign: 'right',
        labelWidth: 80,
        height: 100,
        //collapsible: true,
        region: 'north',
        layout: 'column',
        items: [obj.PanelQ1, obj.PanelQ2],
        buttons: [obj.QUAdd, obj.QUClear, obj.QDFind]
    });
    
    obj.PanelQD = new Ext.Panel({
        id: 'PanelQD',
        title: '问卷内容',
        buttonAlign: 'center',
        region: 'center',
        frame: true,
        //collapsible: true,
        layout: 'border',
        items: [obj.FormPanelQU, obj.GridPanelQD]
    });
    obj.QUCode.focus(true, 3);
    obj.MainPanel = new Ext.Viewport({
        id: 'MainPanel',
        layout: 'border',
        items: [obj.PanelQDO, obj.PanelQD]
    });
    obj.GridPanelQDOStoreProxy.on('beforeload', function(objProxy, param){
        param.ClassName = 'web.DHCHM.QuestionDetailSet';
        param.QueryName = 'FindQDOption';
        param.Arg1 = obj.QDOParRef.getValue();
        param.ArgCnt = 1;
    });
    obj.GridPanelQDStoreProxy.on('beforeload', function(objProxy, param){
        param.ClassName = 'web.DHCHM.QuestionDetailSet';
        param.QueryName = 'FindQDetail';
        param.Arg1 = obj.QUCode.getValue();
        param.Arg2 = obj.QUDesc.getValue();
        param.ArgCnt = 2;
    });
    obj.GridPanelQDStore.load({
        params: {
            start: 0,
            limit: 20
        }
    });
    
    InitMainPanelEvent(obj);
    //事件处理代码
    obj.GridPanelQDO.on("rowclick", obj.GridPanelQDO_rowclick, obj);
    obj.QDOSave.on("click", obj.QDOSave_click, obj);
    obj.QDOClear.on("click", obj.QDOClear_click, obj);
    obj.QUClear.on("click", obj.QUClear_click, obj);
    obj.QDFind.on("click", obj.QDFind_click, obj);
    obj.QUAdd.on("click", obj.QUAdd_click, obj);
    obj.GridPanelQD.on("rowclick", obj.GridPanelQD_rowclick, obj);
    obj.GridPanelQD.on("rowdblclick", obj.GridPanelQD_rowdblclick, obj);
    
    obj.LoadEvent(arguments);
    return obj;
}

