function InitViewportMain(){
    var obj = new Object();
    obj.ComboBoxHCStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
        url: ExtToolSetting.RunQueryPageURL
    }));
    obj.ComboBoxHCStore = new Ext.data.Store({
        proxy: obj.ComboBoxHCStoreProxy,
        reader: new Ext.data.JsonReader({
            root: 'record',
            totalProperty: 'total',
            idProperty: 'id'
        }, [{
            name: 'checked',
            mapping: 'checked'
        }, {
            name: 'id',
            mapping: 'id'
        }, {
            name: 'text',
            mapping: 'text'
        }, {
            name: 'leaf',
            mapping: 'leaf'
        }, {
            name: 'checked',
            mapping: 'checked'
        }])
    });
    obj.ComboBoxHC = new Ext.form.ComboBox({
        id: 'ComboBoxHC',
        store: obj.ComboBoxHCStore,
        minChars: 1,
        displayField: 'text',
        fieldLabel: '分类级别',
        valueField: 'id',
        triggerAction: 'all'
    });
    obj.ComboBoxHCIStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
        url: ExtToolSetting.RunQueryPageURL
    }));
    obj.ComboBoxHCIStore = new Ext.data.Store({
        proxy: obj.ComboBoxHCIStoreProxy,
        reader: new Ext.data.JsonReader({
            root: 'record',
            totalProperty: 'total',
            idProperty: 'ID'
        }, [{
            name: 'checked',
            mapping: 'checked'
        }, {
            name: 'ID',
            mapping: 'ID'
        }, {
            name: 'HCActive',
            mapping: 'HCActive'
        }, {
            name: 'HCCode',
            mapping: 'HCCode'
        }, {
            name: 'HCDesc',
            mapping: 'HCDesc'
        }, {
            name: 'HCExpandCode',
            mapping: 'HCExpandCode'
        }, {
            name: 'HCMonths',
            mapping: 'HCMonths'
        }, {
            name: 'HCRemark',
            mapping: 'HCRemark'
        }, {
            name: 'HCType',
            mapping: 'HCType'
        }])
    });
    obj.ComboBoxHCI = new Ext.form.ComboBox({
        id: 'ComboBoxHCI',
        minChars: 1,
        store: obj.ComboBoxHCIStore,
        fieldLabel: '人员类型',
        displayField: 'HCDesc',
        valueField: 'ID',
        triggerAction: 'all'
    });
    obj.DateFieldS = new Ext.form.DateField({
        id: 'DateFieldS',
        fieldLabel: '开始日期'
    });
    obj.DateFieldE = new Ext.form.DateField({
        id: 'DateFieldE',
        fieldLabel: '结束日期'
    });
    obj.ButtonES = new Ext.Button({
        id: 'ButtonES',
        iconCls: 'icon-find',
        text: '查询'
    });
    
    obj.PanelQ1 = new Ext.Panel({
        id: 'PanelQ1',
        defaults: {
            width: 200
        },
        buttonAlign: 'center',
        columnWidth: .5,
        layout: 'form',
        items: [obj.ComboBoxHC, obj.DateFieldS]
    });
    
    obj.PanelQ2 = new Ext.Panel({
        id: 'PanelQ2',
        defaults: {
            width: 200
        },
        buttonAlign: 'center',
        columnWidth: .5,
        layout: 'form',
        items: [obj.ComboBoxHCI, obj.DateFieldE]
    });
    
    obj.FormPanelES = new Ext.form.FormPanel({
        id: 'FormPanelES',
        buttonAlign: 'center',
        labelAlign: 'right',
        labelWidth: 80,
        defaults: {
            width: 200
        },
        height: 150,
        title: '评估统计',
        region: 'north',
        layout: 'column',
        frame: true,
        items: [obj.PanelQ1, obj.PanelQ2],
        buttons: [obj.ButtonES]
    });

    obj.GridPanelESStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
        url: ExtToolSetting.RunQueryPageURL
    }));
    obj.GridPanelESStore = new Ext.data.Store({
        proxy: obj.GridPanelESStoreProxy,
        reader: new Ext.data.JsonReader({
            root: 'record',
            totalProperty: 'total',
            idProperty: 'OQEId'
        }, [{
            name: 'checked',
            mapping: 'checked'
        }, {
            name: 'OQEId',
            mapping: 'OQEId'
        }, {
            name: 'vBIPAPMINo',
            mapping: 'vBIPAPMINo'
        }, {
            name: 'vName',
            mapping: 'vName'
        }, {
            name: 'SexDesc',
            mapping: 'SexDesc'
        }, {
            name: 'Date',
            mapping: 'Date'
        }, {
            name: 'EducationDesc',
            mapping: 'EducationDesc'
        }, {
            name: 'MaritalDesc',
            mapping: 'MaritalDesc'
        }])
    });
    obj.GridPanelESCheckCol = new Ext.grid.CheckColumn({
        header: '',
        dataIndex: 'checked',
        width: 50
    });
    obj.GridPanelES = new Ext.grid.GridPanel({
        id: 'GridPanelES',
        store: obj.GridPanelESStore,
        region: 'center',
        buttonAlign: 'center',
        columns: [{
            header: 'ID',
            width: 100,
            dataIndex: 'OQEId',
            sortable: true
        },{
            header: '登记号',
            width: 100,
            dataIndex: 'vBIPAPMINo',
            sortable: true
        }, {
            header: '姓名',
            width: 100,
            dataIndex: 'vName',
            sortable: true
        }, {
            header: '性别',
            width: 100,
            dataIndex: 'SexDesc',
            sortable: true
        }, {
            header: '日期',
            width: 100,
            dataIndex: 'Date',
            sortable: true
        }, {
            header: '学历',
            width: 100,
            dataIndex: 'EducationDesc',
            sortable: true
        }, {
            header: '婚姻',
            width: 100,
            dataIndex: 'MaritalDesc',
            sortable: true
        }]
	,bbar: new Ext.PagingToolbar({
			pageSize : 25,
			store : obj.GridPanelESStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
    });
    obj.ViewportMain = new Ext.Viewport({
        id: 'ViewportMain',
        layout: 'border',
        items: [obj.FormPanelES, obj.GridPanelES]
    });
    obj.ComboBoxHCStoreProxy.on('beforeload', function(objProxy, param){
        param.ClassName = 'web.DHCHM.EvaluationStatistic';
        param.QueryName = 'FindTblTree';
        param.Arg1 = 1004;
        param.ArgCnt = 1;
    });
    obj.ComboBoxHCStore.load({});
    obj.ComboBoxHCIStoreProxy.on('beforeload', function(objProxy, param){
        param.ClassName = 'web.DHCHM.HMCodeConfig';
        param.QueryName = 'FindHumClass';
        param.Arg1 = obj.ComboBoxHC.getValue();
        param.ArgCnt = 1;
    });
    obj.GridPanelESStoreProxy.on('beforeload', function(objProxy, param){
        param.ClassName = 'web.DHCHM.EvaluationStatistic';
        param.QueryName = 'FindBaseInfoByType';
        param.Arg1 = obj.DateFieldS.getValue();
        param.Arg2 = obj.DateFieldE.getValue();
        param.Arg3 = obj.ComboBoxHCI.getValue();
        param.ArgCnt = 3;
    });
    //obj.GridPanelESStore.load({});
    InitViewportMainEvent(obj);
    //事件处理代码
    obj.ComboBoxHC.on("select", obj.ComboBoxHC_select, obj);
    obj.ButtonES.on("click", obj.ButtonES_click, obj);
    obj.LoadEvent(arguments);
    return obj;
}

