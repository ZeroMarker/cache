function InitViewport1(){
    var obj = new Object();
    
    obj.RecordID = "";
    obj.ElementNum = 1 / 3;
    obj.InputInfo = "请输入...";
    obj.Type = arguments[0];
	obj.TJReg=arguments[1];
	//alert(arguments[2])
	obj.QRecordID=arguments[2];
    obj.Method = ExtTool.StaticServerObject("web.DHCHM.OEvaluationRecord");
    //alert(obj.Type)
    //alert(obj.TJReg)
	/*
	obj.Close= new Ext.Button({
        id: 'BClose',
        text: '关闭',
        iconCls: 'icon-close'
    });
	*/
	obj.GetHisResult = new Ext.Button({
        id: 'BGetHisResult',
        text: '获取问卷结果',
        iconCls: 'icon-add',
		hidden:true
    });
	obj.Save = new Ext.Button({
        id: 'BSave',
        text: '保存',
        iconCls: 'icon-save'
    });
    
    
    obj.Submit = new Ext.Button({
        id: 'BSubmit',
        text: '提交',
        iconCls: 'icon-submit'
    });
	obj.CancelSubmit = new Ext.Button({
        id: 'CancelSubmit',
        text: '取消提交',
        iconCls: 'icon-cancel'
    });
    obj.Clear = new Ext.Button({
        id: 'Clear',
        text: '清空',
        iconCls: 'icon-new'
    });
	/*
    obj.PrintReport = new Ext.Button({
        id: 'PrintReport',
        text: '打印报告',
        iconCls: 'icon-print'
    });
	*/

    obj.FormPanel3 = new Ext.TabPanel({
        id: 'FormPanel3',
        region: 'center',
        //buttons: [obj.GetHisResult,obj.Save, obj.Submit, obj.CancelSubmit,obj.Clear,obj.PrintReport],
		buttons: [obj.GetHisResult,obj.Save, obj.Submit, obj.CancelSubmit,obj.Clear],
	items: []
    
    });

    obj.StartDate = new Ext.form.DateField({
        id: 'StartDate',
        format: ExtToolSetting.DateFormatString,
        anchor: '98%',
        fieldLabel: '开始日期',
        id: 'StartDate'
		//,tabIndex:1
    });
    
    obj.Code = new Ext.form.TextField({
        id: 'Code',
        fieldLabel: '编码',
        anchor: '98%'
		//,tabIndex:5
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
        format: ExtToolSetting.DateFormatString,
        fieldLabel: '结束日期',
        anchor: '98%'
		//,tabIndex:2
    });
    obj.BFind = new Ext.Button({
        id: 'BFind',
        cls: 'padding-left: 20px;',
        iconCls: 'icon-find',
        id: 'BFind',
        text: '查找'
    });
    obj.Panel7 = new Ext.Panel({
        id: 'Panel7',
        buttonAlign: 'center',
        columnWidth: 0.25,
        layout: 'form',
        items: [obj.EndDate, obj.BFind]
    });
    obj.RegNo = new Ext.form.TextField({
        id: 'RegNo',
        id: 'RegNo',
        fieldLabel: '登记号',
        anchor: '98%'
		//,tabIndex:3
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
        fieldLabel: '姓名',
        anchor: '98%'
		//,tabIndex:4
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
        pageSize: 4,
        store: obj.GridPanel1Store,
        displayMsg: '显示记录： {0} - {1} 合计： {2}',
        displayInfo: true,
        emptyMsg: '没有记录'
    });
    obj.GridPanel1 = new Ext.grid.GridPanel({
        id: 'GridPanel1',
        buttonAlign: 'center',
        columnWidth: 1,
        store: obj.GridPanel1Store,
        height: 180,
        sm: obj.GridPanel1SM,
        viewConfig: {
            forceFit: true
        },
        columns: [new Ext.grid.RowNumberer(), {
            header: '登记号',
            width: 70,
            dataIndex: 'RegNo',
            sortable: true
        }, {
            header: '姓名',
            width: 80,
            dataIndex: 'BIName',
            sortable: true
        }, {
            header: '性别',
            width: 40,
            dataIndex: 'SexDesc',
            sortable: true
        }, {
            header: '编码',
            width: 100,
            dataIndex: 'BICode',
            sortable: true
        }, {
            header: '日期',
            width: 80,
            dataIndex: 'QAddDate',
            sortable: true
        }, {
            header: '学历',
            width: 50,
            dataIndex: 'EducationDesc',
            sortable: true
        }, {
            header: '婚否',
            width: 50,
            dataIndex: 'MaritalDesc',
            sortable: true
        }, {
            header: '职业',
            width: 100,
            dataIndex: 'OccupationDesc',
            sortable: true
        }, {
            header: '行政区划编码',
            width: 90,
            dataIndex: 'QPostCode',
            sortable: true
        }, {
            header: '备注',
            width: 200,
            dataIndex: 'QRemark',
            sortable: true
        }],
        bbar: obj.bbar
    
    });
    obj.FormPanel2 = new Ext.form.FormPanel({
        id: 'FormPanel2',
        buttonAlign: 'center',
        labelWidth: 70,
        region: 'center',
        labelAlign: 'right',
        layout: 'column',
        hidden:true,
        items: [obj.Panel6, obj.Panel7, obj.Panel17, obj.Panel18, obj.GridPanel1]
    });
	
	
    obj.TreeLoader = new Ext.tree.TreeLoader({
        dataUrl: ExtToolSetting.TreeQueryPageURL,
        baseParams: {
            ClassName: 'web.DHCHM.GetTreeInfo',
            QueryName: 'QuestionTree',
            ArgCnt: 2,
            Arg1: obj.RecordID,
            Arg2: obj.Type
        }
    })
    obj.TreePanel = new Ext.tree.TreePanel({
    
        region: 'east',
        width: 250,
        //autoScroll: true,
        animate: true,
        //frame : true,
        autoHeight: true,
        loader: obj.TreeLoader,
        root: new Ext.tree.AsyncTreeNode({
            id: '0',
            text: '问卷信息'
        })
    });
	
    obj.TreePanel.expandAll();
    
    obj.Panel2 = new Ext.Panel({
        id: 'Panel2',
        buttonAlign: 'center',
        title: '人员信息',
        collapsible: true,
        region: 'north',
        layout: 'border',
        frame: true,
        height: 100,
        items: [obj.FormPanel2, obj.TreePanel]
    });
	ExtTool.SetTabIndex("StartDate$1^EndDate$2^RegNo$3^Name$4^Code$5");
    obj.Viewport1 = new Ext.Viewport({
        id: 'Viewport1',
        layout: 'border',
        items: [obj.FormPanel3,obj.Panel2]
    });
    obj.GridPanel1StoreProxy.on('beforeload', function(objProxy, param){
        param.ClassName = 'web.DHCHM.OEvaluationRecord';
        param.QueryName = 'OEvaluationRecord';
		
		
        param.ArgCnt = 6;
        param.Arg1 = obj.StartDate.getValue();
        param.Arg2 = obj.EndDate.getValue();
        param.Arg3 = obj.RegNo.getValue();
		//alert(param.Arg3)
		if (param.Arg3==""){
			
			param.Arg3=obj.TJReg;
			
		}
        param.Arg4 = obj.Name.getValue();
        param.Arg5 = obj.Code.getValue();
        param.Arg6 = obj.Type;
    });
    //ExtTool.SetTabIndex("StartDate^EndDate^RegNo^Name^Code");
    InitViewport1Event(obj);
	
	
	
    //事件处理代码
	//obj.Close.on("click", obj.Close_click, obj);
	
	obj.GetHisResult.on("click", obj.GetHisResult_click, obj);
    obj.BFind.on("click", obj.BFind_click, obj);
	//alert(1)
	
    obj.GridPanel1.on("rowclick", obj.GridPanel1_rowclick, obj);
	//alert(2)
	
    obj.TreePanel.on("click", obj.TreePanel_click, obj);
    obj.Save.on("click", obj.showProgress, obj);
    //obj.Save.on("click", obj.Save_click, obj);
    obj.Submit.on("click", obj.Submit_click, obj);
	obj.CancelSubmit.on("click", obj.CancelSubmit_click, obj);
    obj.Clear.on("click", obj.Clear_click, obj);
	obj.FormPanel3.on("tabchange",obj.TabChange,obj);
    //obj.PrintReport.on("click",obj.PrintReport_click,obj)
    obj.LoadEvent(arguments);
	//alert(obj.QRecordID)
	
	var tmpid=obj.QRecordID.split("$$")[0]
	var tmpdesc=obj.QRecordID.split("$$")[1]
	//self.resizeTo(20001, 12001); 
	//self.moveTo(0, 0); 
	//addwindow.show()
	//addwindow.maximize()
	//obj.FormPanel3.maximize()
	//alert(tmpid)
	CreateActivePanel(obj, tmpid, tmpdesc);
	
	var RecordID= tmpid.split("Q")[1].split("||")[0]
	//alert(RecordID)
	
		//树
		obj.RecordID = RecordID;
        obj.TreeLoader.baseParams.Arg1 = obj.RecordID;
        obj.TreePanel.loader = obj.TreeLoader;
        obj.TreeLoader.load(obj.TreePanel.getRootNode());
		
        obj.TreePanel.expandAll();
	
	//GridPanel1_rowclick
    return obj;
}

