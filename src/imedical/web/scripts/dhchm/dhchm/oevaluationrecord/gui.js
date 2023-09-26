function InitViewport1(){
    var obj = new Object();
    obj.Type = arguments[0];
    obj.Method = ExtTool.StaticServerObject("web.DHCHM.OEvaluationRecord");
    obj.ID = new Ext.form.Hidden({
        id: 'ID',
        value: '',
        name: 'ID'
    });
    obj.QOBaseInfoDR = new Ext.form.Hidden({
        id: 'QOBaseInfoDR',
        value: '',
        name: 'QOBaseInfoDR'
    });
    
    obj.BICode = new Ext.form.TextField({
        id: 'BICode',
        fieldLabel: '����',
        enableKeyEvents: true
    });
    obj.BIName = new Ext.form.TextField({
        id: 'BIName',
        fieldLabel: '����',
        disabled: true
    });
    obj.BIMobilePhone = new Ext.form.TextField({
        id: 'BIMobilePhone',
        fieldLabel: '�ֻ�',
        disabled: true
    });
    obj.QCOccupationDR = ExtTool.CreateCombo('QCOccupationDR', 'ְҵ', false, 'web.DHCHM.GetComboxInfo', 'GetCCodeTable', '10010001', 'Y');
    
    obj.QDocDR = ExtTool.CreateCombo('QDocDR', '����ҽ��', false, 'web.DHCHM.GetComboxInfo', 'GetDoctor','��������ʦ');
    
    obj.Panel9 = new Ext.Panel({
        id: 'Panel9',
        defaults: {
            width: 100
        },
        buttonAlign: 'center',
        columnWidth: 0.25,
        layout: 'form',
        items: [obj.ID, obj.QOBaseInfoDR, obj.BICode, obj.BIName, obj.BIMobilePhone, obj.QCOccupationDR, obj.QDocDR]
    });
    obj.BIPAPMINo = new Ext.form.TextField({
        id: 'BIPAPMINo',
        fieldLabel: '�ǼǺ�',
        enableKeyEvents: true
    });
    obj.BICSexDR = ExtTool.CreateCombo('BICSexDR', '�Ա�', true, 'web.DHCHM.GetComboxInfo', 'GetCCodeTable', '10010003', 'Y');
    obj.BICUserTypeDR = ExtTool.CreateCombo('BICUserTypeDR', '��Ա���', true, 'web.DHCHM.GetComboxInfo', 'GetCCodeTable', '10010007', 'Y');
    
    obj.QCEducationDR = ExtTool.CreateCombo('QCEducationDR', 'ѧ��', false, 'web.DHCHM.GetComboxInfo', 'GetCCodeTable', '10010002', 'Y');
    
    obj.QHMDR = ExtTool.CreateCombo('QHMDR', '��������ʦ', false, 'web.DHCHM.GetComboxInfo', 'GetDoctor','��������ʦ');
    
    obj.Panel10 = new Ext.Panel({
        id: 'Panel10',
        buttonAlign: 'center',
        defaults: {
            width: 100
        },
        columnWidth: 0.25,
        layout: 'form',
        items: [obj.BIPAPMINo, obj.BICSexDR, obj.BICUserTypeDR, obj.QCEducationDR, obj.QHMDR]
    });
    obj.BIIDCard = new Ext.form.TextField({
        id: 'BIIDCard',
        fieldLabel: '֤�����',
        enableKeyEvents: true
    });
    obj.BIDOB = new Ext.form.TextField({
        id: 'BIDOB',
        fieldLabel: '��������',
        disabled: true
    });
    obj.QCServiceClassDR = ExtTool.CreateCombo('QCServiceClassDR', '���񼶱�', true, 'web.DHCHM.GetComboxInfo', 'GetCServiceClass', 'Y');
    /*new Ext.form.TextField({
     id : 'BICServiceClassDR'
     ,fieldLabel : '���񼶱�'
     });*/
    obj.QCMaritalDR = ExtTool.CreateCombo('QCMaritalDR', '����״��', false, 'web.DHCHM.GetComboxInfo', 'GetCCodeTable', '10010004', 'Y');
    
    obj.QPostCode = new Ext.form.TextField({
        id: 'QPostCode',
        fieldLabel: '��������'
    });
    obj.Panel12 = new Ext.Panel({
        id: 'Panel12',
        defaults: {
            width: 100
        },
        buttonAlign: 'center',
        columnWidth: 0.25,
        layout: 'form',
        items: [obj.BIIDCard, obj.BIDOB, obj.QCServiceClassDR, obj.QCMaritalDR, obj.QPostCode]
    });
    obj.QRemark = new Ext.form.TextField({
        id: 'QRemark',
        fieldLabel: '��ע',
        anchor: '92%'
    });
    obj.Panel30 = new Ext.Panel({
        id: 'Panel30',
        buttonAlign: 'center',
        columnWidth: 0.75,
        layout: 'form',
        items: [obj.QRemark]
    });
    obj.BSave = new Ext.Button({
        id: 'BSave',
        iconCls: 'icon-save',
        text: '����'
    });
    obj.BClear = new Ext.Button({
        id: 'BClear',
        iconCls: 'icon-clear',
        text: '���'
    });
    obj.TreeLoader = new Ext.tree.TreeLoader({
        dataUrl: ExtToolSetting.TreeQueryPageURL,
        baseParams: {
            ClassName: 'web.DHCHM.GetTreeInfo',
            QueryName: 'SQuestionTree',
            ArgCnt: 2,
            Arg1: obj.ID.getValue(),
            Arg2: obj.QCServiceClassDR.getValue()
        }
    })
    obj.TreePanel = new Ext.tree.TreePanel({
        columnWidth: 0.25,
        autoScroll: true,
        animate: true,
        //frame : true,
        autoHeight: true,
        loader: obj.TreeLoader,
        root: new Ext.tree.AsyncTreeNode({
            id: '0',
            text: '�ʾ���Ϣ'
        })
    });
    obj.TreePanel.expandAll();
    obj.FormPanel2 = new Ext.form.FormPanel({
        id: 'FormPanel2',
        buttonAlign: 'center',
        labelAlign: 'right',
        labelWidth: 80,
        height: 250,
        title: '�����Ǽ�',
        defaults: {
            width: 100
        },
        collapsible: true,
        region: 'north',
        layout: 'column',
        frame: true, 
        items: [obj.Panel9, obj.Panel10, obj.Panel12, obj.TreePanel, obj.Panel30],
        buttons: [obj.BSave, obj.BClear]
    });
    obj.StartDate = new Ext.form.DateField({
        id: 'StartDate',
        format: ExtToolSetting.DateFormatString,
        anchor: '98%',
        fieldLabel: '��ʼ����',
        id: 'StartDate'
    });
    
    obj.Code = new Ext.form.TextField({
        id: 'Code',
        id: 'Code',
        fieldLabel: '����',
        anchor: '98%'
    });
    obj.Panel6 = new Ext.Panel({
        id: 'Panel6',
        buttonAlign: 'center',
        columnWidth: 0.25,
        layout: 'form',
        items: [obj.StartDate, obj.Code]
    });
    obj.EndDate = new Ext.form.DateField({
        id: 'EndDate',
        id: 'EndDate',
        format: ExtToolSetting.DateFormatString,
        fieldLabel: '��������',
        anchor: '98%'
    });
    obj.BFind = new Ext.Button({
        id: 'BFind',
        cls: 'padding-left: 20px;',
        iconCls: 'icon-find',
        id: 'BFind',
        text: '����'
    });

obj.Panel8888 = new Ext.Panel({
        id: 'Panel8888',
        buttonAlign: 'center',
       labelAlign: 'right',
width:20,
height:25,
   columnWidth: 0.25
   });
    obj.Panel7777 = new Ext.Panel({
        id: 'Panel7777',
        buttonAlign: 'center',
       labelAlign: 'right',
width:380,
height:35,
      layout: 'column',
    items: [ obj.Panel8888 ,obj.BFind]
    });
    obj.Panel7 = new Ext.Panel({
        id: 'Panel7',
        buttonAlign: 'center',
        columnWidth: 0.25,
        layout: 'form',
        items: [obj.EndDate,  obj.Panel7777]
    });
    obj.RegNo = new Ext.form.TextField({
        id: 'RegNo',
        id: 'RegNo',
        fieldLabel: '�ǼǺ�',
        anchor: '98%'
    });
    
    
    obj.Panel17 = new Ext.Panel({
        id: 'Panel17',
        buttonAlign: 'center',
        columnWidth: 0.25,
        layout: 'form',
        items: [obj.RegNo]
    });
    obj.Name = new Ext.form.TextField({
        id: 'Name',
        id: 'Name',
        fieldLabel: '����',
        anchor: '98%'
    });
    obj.Panel18 = new Ext.Panel({
        id: 'Panel18',
        buttonAlign: 'center',
        columnWidth: 0.25,
        layout: 'form',
        items: [obj.Name]
    });
    obj.GridPanel1StoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
        url: ExtToolSetting.RunQueryPageURL
    }));
    obj.GridPanel1Store = new Ext.data.Store({
        proxy: obj.GridPanel1StoreProxy,
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
            name: 'RegNo',
            mapping: 'RegNo'
        }, {
            name: 'BIName',
            mapping: 'BIName'
        }, {
            name: 'SexDesc',
            mapping: 'SexDesc'
        }, {
            name: 'BICode',
            mapping: 'BICode'
        }, {
            name: 'QAddDate',
            mapping: 'QAddDate'
        }, {
            name: 'EducationDesc',
            mapping: 'EducationDesc'
        }, {
            name: 'MaritalDesc',
            mapping: 'MaritalDesc'
        }, {
            name: 'OccupationDesc',
            mapping: 'OccupationDesc'
        }, {
            name: 'QPostCode',
            mapping: 'QPostCode'
        }, {
            name: 'QRemark',
            mapping: 'QRemark'
        }, {
            name: 'QAddTime',
            mapping: 'QAddTime'
        }, {
            name: 'QAddUserDR',
            mapping: 'QAddUserDR'
        }, {
            name: 'SSUSRName',
            mapping: 'SSUSRName'
        }, {
            name: 'QCEducationDR',
            mapping: 'QCEducationDR'
        }, {
            name: 'QCMaritalDR',
            mapping: 'QCMaritalDR'
        }, {
            name: 'QCOccupationDR',
            mapping: 'QCOccupationDR'
        }, {
            name: 'QDocDR',
            mapping: 'QDocDR'
        }, {
            name: 'DocName',
            mapping: 'DocName'
        }, {
            name: 'QHMDR',
            mapping: 'QHMDR'
        }, {
            name: 'SSUSRName',
            mapping: 'SSUSRName'
        }, {
            name: 'QOBaseInfoDR',
            mapping: 'QOBaseInfoDR'
        }])
    });
    obj.GridPanel1CheckCol = new Ext.grid.CheckColumn({
        header: '',
        dataIndex: 'checked',
        width: 50
    });
    obj.GridPanel1SM = new Ext.grid.RowSelectionModel({
        singleSelect: true
    });
    obj.bbar = new Ext.PagingToolbar({
        pageSize: 25,
        store: obj.GridPanel1Store,
        displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
        displayInfo: true,
        emptyMsg: 'û�м�¼'
    });
    obj.GridPanel1 = new Ext.grid.GridPanel({
        id: 'GridPanel1',
        buttonAlign: 'center',
        store: obj.GridPanel1Store,
        region: 'center',
        sm: obj.GridPanel1SM,
        viewConfig: {
            forceFit: true
        },
        columns: [new Ext.grid.RowNumberer(), {
            header: '�ǼǺ�',
            width: 70,
            dataIndex: 'RegNo',
            sortable: true
        }, {
            header: '����',
            width: 80,
            dataIndex: 'BIName',
            sortable: true
        }, {
            header: '�Ա�',
            width: 40,
            dataIndex: 'SexDesc',
            sortable: true
        }, {
            header: '����',
            width: 100,
            dataIndex: 'BICode',
            sortable: true
        }, {
            header: '����',
            width: 80,
            dataIndex: 'QAddDate',
            sortable: true
        }, {
            header: 'ѧ��',
            width: 50,
            dataIndex: 'EducationDesc',
            sortable: true
        }, {
            header: '���',
            width: 50,
            dataIndex: 'MaritalDesc',
            sortable: true
        }, {
            header: 'ְҵ',
            width: 100,
            dataIndex: 'OccupationDesc',
            sortable: true
        }, {
            header: '������������',
            width: 90,
            dataIndex: 'QPostCode',
            sortable: true
        }, {
            header: '��ע',
            width: 200,
            dataIndex: 'QRemark',
            sortable: true
        }],
        bbar: obj.bbar
    
    });
    obj.FormPanel3 = new Ext.form.FormPanel({
        id: 'FormPanel3',
        buttonAlign: 'center',
        labelWidth: 70,
        region: 'north',
        labelAlign: 'right',
        height: 55,
        layout: 'column',
        items: [obj.Panel6, obj.Panel7, obj.Panel17, obj.Panel18]
    });
    
    obj.QueryPanel = new Ext.Panel({
        id: 'QueryPanel',
        frame: true,
        region: 'center',
        layout: 'border',
        items: [obj.FormPanel3, obj.GridPanel1]
    })
    obj.GridPanel1StoreProxy.on('beforeload', function(objProxy, param){
        param.ClassName = 'web.DHCHM.OEvaluationRecord';
        param.QueryName = 'OEvaluationRecord';
        param.ArgCnt = 6;
        param.Arg1 = obj.StartDate.getValue();
        param.Arg2 = obj.EndDate.getValue();
        param.Arg3 = obj.RegNo.getValue();
        param.Arg4 = obj.Name.getValue();
        param.Arg5 = obj.Code.getValue();
        param.Arg6 = obj.Type;
    });
	//obj.ID, obj.QOBaseInfoDR, obj.BICode, obj.BIName, obj.BIMobilePhone, obj.QCOccupationDR, obj.QDocDR]
	//obj.BIPAPMINo, obj.BICSexDR, obj.BICUserTypeDR, obj.QCEducationDR, obj.QHMDR
	//obj.BIIDCard, obj.BIDOB, obj.QCServiceClassDR, obj.QCMaritalDR, obj.QPostCode
	//obj.QRemark
	ExtTool.SetTabIndex("BICode$1^BIPAPMINo$2^BIIDCard$3^QCOccupationDR$4^QCEducationDR$5^QCMaritalDR$6^QDocDR$7^QHMDR$8^QPostCode$9^QRemark$10");
    obj.Viewport1 = new Ext.Viewport({
        id: 'Viewport1',
        layout: 'border',
        items: [obj.FormPanel2, obj.QueryPanel]
    });
    InitViewport1Event(obj);
    obj.BICode.on("keydown", obj.BICode_keydown, obj);
	obj.BIIDCard.on("keydown", obj.BICode_keydown, obj);
	obj.BIPAPMINo.on("keydown", obj.BICode_keydown, obj);
	obj.BICode.on("keydown", obj.BICode_keydown, obj);
    obj.GridPanel1.on("rowdblclick", obj.GridPanel1_rowdblclick, obj);
    obj.BSave.on("click", obj.BSave_click, obj);
    obj.BClear.on("click", obj.BClear_click, obj);
    obj.BFind.on("click", obj.BFind_click, obj);
    //�¼��������
    obj.LoadEvent(arguments);
    return obj;
}

