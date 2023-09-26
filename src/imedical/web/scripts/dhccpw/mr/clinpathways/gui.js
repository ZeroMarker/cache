function InitMainViewport(){
	var obj = new Object();
	obj.CurrClinPathWay = null;
	obj.SelClinPathWay = null;
	obj.CurrLogon = null;
	obj.CurrPaPerson = null;
	obj.CurrPAADM = null;
	
	//***************************************************************
	// 左下部分
	//***************************************************************
	obj.lsvLocClinPathWayStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
	}));
	obj.lsvLocClinPathWayStore = new Ext.data.Store({
		proxy: obj.lsvLocClinPathWayStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.lsvLocClinPathWay = new Ext.list.ListView({
		id : 'lsvLocClinPathWay'
        ,store: obj.lsvLocClinPathWayStore
        ,multiSelect: false
        ,emptyText: '本科室未维护常用临床路径'
        ,reserveScrollOffset: true
        ,hideLabel: true
        ,hideHeaders:true
        //,anchor : '100%'
        //,region : 'center'
        ,columns: [{
           // header: '',
            width: 0,
            dataIndex: 'Rowid'
        },{
            //header: '科室常用临床路径',
            width: '100%',
            dataIndex: 'Desc'
        }
        ]
    });
	obj.lsvLocClinPathWayStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.ClinPathWaysSrv';
			param.QueryName = 'QryLocClinPathWays';
			if (obj.CurrLogon){
				param.Arg1 = obj.CurrLogon.CTLOCID;
			}else{
				param.Arg1 = "";
			}
			param.ArgCnt = 1;
	});
	
	obj.CPWSelTabPanel = new Ext.TabPanel({
		id : 'CPWSelTabPanel'
		//,buttonAlign : 'center'
		//,layout : 'border'
		//,title : '选择临床路径'
		,activeTab: 0
		//,split:true
		,collapsible: true
		//,collapsed : true
		,region : 'west'
		,width : 400
		,tabPosition:'bottom'
		//,frame : true
		,items:[
			{
				id : 'CPWSelTabPanelLoc',
                title: '科室常用路径',
                frame: true,
                layout : 'fit',
                items: [obj.lsvLocClinPathWay]
            },{
                id : 'CPWSelTabPanelElse',
                layout : 'fit',
                frame: true,
                title: '其它路径'  //CPWSelTabPanelElse web.DHCCPW.MRC.ClinPathWaysSrv QueryCPWTypeTree
                
            }
		]
	});
	
	//***************************************************************
	// 右下部分
	//***************************************************************
	obj.CPWTreeDetailPanel = new Ext.Panel({
		id : 'CPWTreeDetailPanel'
		,buttonAlign : 'center'
		,layout : 'fit'
		,title : '明细展现'
		//,region : 'center'
		,frame : true
		,items:[
			//panelTree
		]
	});
	obj.CPWFormDetailPanel = new Ext.Panel({
		id : 'CPWFormDetailPanel'
		,buttonAlign : 'center'
		,layout : 'fit'
		,autoScroll:true
		,title : '表单展现'
		,frame : true
		,items:[]
	});
	obj.CPWDetailTabPanel = new Ext.TabPanel({
		id : 'CPWDetailTabPanel'
		,activeTab: 0
		,region : 'center'
		,tabPosition:'bottom'
		,items:[
			obj.CPWTreeDetailPanel
			,obj.CPWFormDetailPanel
		]
	});
	
	//***************************************************************
	// 上半部分
	//***************************************************************
	obj.btnOutWay  = new Ext.Toolbar.Button({
		id : 'btnOutWay',
		text: '出径',   
		iconCls : 'icon-cancel',
		tooltip: '出径'
	});
	obj.btnFormShow  = new Ext.Toolbar.Button({
		id : 'btnFormShow',
		text: '展现表单',
		iconCls : 'icon-new',
		tooltip: '展现表单'
	});
	obj.btnVarRecord  = new Ext.Toolbar.Button({
		id : 'btnVarRecord',
		text: '变异记录',
		iconCls : 'icon-new',
		tooltip: '变异记录'
	});
	obj.btnPrintForm  = new Ext.Toolbar.Button({
		id : 'btnPrintForm',
		text: '打印表单',
		iconCls : 'icon-print',
		tooltip: '打印表单'
	});
	obj.btnPathWayRst  = new Ext.Toolbar.Button({
		id : 'btnPathWayRst',
		text: '路径评估',
		iconCls : 'icon-save',
		tooltip: '路径评估'
	});
	obj.PathWayGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
	}));
	obj.PathWayGridPanelStore = new Ext.data.Store({
		proxy: obj.PathWayGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'CPWMRAdm', mapping: 'CPWMRAdm'}
			,{name: 'CPWDR', mapping: 'CPWDR'}
			,{name: 'CPWDesc', mapping: 'CPWDesc'}
			,{name: 'CPWEpDR', mapping: 'CPWEpDR'}
			,{name: 'CPWEpDesc', mapping: 'CPWEpDesc'}
			,{name: 'CPWEpStepDR', mapping: 'CPWEpStepDR'}
			,{name: 'CPWEPStepDesc', mapping: 'CPWEPStepDesc'}
			,{name: 'Status', mapping: 'Status'}
			,{name: 'StatusDesc', mapping: 'StatusDesc'}
			,{name: 'InDoctorDR', mapping: 'InDoctorDR'}
			,{name: 'InDoctorDesc', mapping: 'InDoctorDesc'}
			,{name: 'InDate', mapping: 'InDate'}
			,{name: 'InTime', mapping: 'InTime'}
			,{name: 'OutDoctorDR', mapping: 'OutDoctorDR'}
			,{name: 'OutDoctorDesc', mapping: 'OutDoctorDesc'}
			,{name: 'OutDate', mapping: 'OutDate'}
			,{name: 'OutTime', mapping: 'OutTime'}
			,{name: 'OutReasonDR', mapping: 'OutReasonDR'}
			,{name: 'OutReasonDesc', mapping: 'OutReasonDesc'}
			,{name: 'UpdateUserDR', mapping: 'UpdateUserDR'}
			,{name: 'UpdateUserDesc', mapping: 'UpdateUserDesc'}
			,{name: 'UpdateDate', mapping: 'UpdateDate'}
			,{name: 'UpdateTime', mapping: 'UpdateTime'}
			,{name: 'Comments', mapping: 'Comments'}
		])
	});
	obj.PathWayGridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.PathWayGridPanel = new Ext.grid.GridPanel({
		id : 'PathWayGridPanel'
		,store : obj.PathWayGridPanelStore
		,region : 'center'
		,frame : true
		,title : '出入径记录'
		,buttonAlign : 'center'
		,viewConfig : {forceFit:true}
		,columns: [
			{header: '临床路径', width: 200, dataIndex: 'CPWDesc', sortable: false}
			,{header: '状态', width: 60, dataIndex: 'StatusDesc', sortable: false}
			,{header: '入径阶段', width: 180, dataIndex: 'CPWEpDesc', sortable: false}
			//,{header: '入径步骤', width: 100, dataIndex: 'CPWEPStepDesc', sortable: false}
			,{header: '入径人', width: 60, dataIndex: 'InDoctorDesc', sortable: false}
			,{header: '入径日期', width: 80, dataIndex: 'InDate', sortable: false}
			,{header: '入径时间', width: 60, dataIndex: 'InTime', sortable: false}
			,{header: '出径人', width: 60, dataIndex: 'OutDoctorDesc', sortable: false}
			,{header: '出径日期', width: 80, dataIndex: 'OutDate', sortable: false}
			,{header: '出径时间', width: 60, dataIndex: 'OutTime', sortable: false}
			,{header: '出径原因', width: 100, dataIndex: 'OutReasonDesc', sortable: false}
			,{header: '更新人', width: 60, dataIndex: 'UpdateUserDesc', sortable: false}
			,{header: '更新日期', width: 80, dataIndex: 'UpdateDate', sortable: true}
			,{header: '更新时间', width: 60, dataIndex: 'UpdateTime', sortable: false}
			,{header: '备注', width: 300, dataIndex: 'Comments', sortable: false}
		]
		,tbar: [obj.btnOutWay,obj.btnFormShow,obj.btnVarRecord,obj.btnPrintForm,obj.btnPathWayRst]
	});
	obj.PathWayGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCPW.MR.ClinicalPathWays';
		param.QueryName = 'QryPathWayByAdm';
		if (obj.CurrPAADM){
			param.Arg1 = obj.CurrPAADM.MRAdm ;
		}else{
			param.Arg1 = "";
		}
		param.ArgCnt = 1;
	});
	
	//***************************************************************
	//整个窗体
	//***************************************************************
	obj.CPWTabPanel = new Ext.Panel({
		id : 'CPWTabPanel'
		,buttonAlign : 'center'
		,layout : 'border'
		,region : 'south'
		,height : 350
		,items:[
			obj.CPWSelTabPanel
			,obj.CPWDetailTabPanel
		]
	});
	obj.TitlePanel = new Ext.Panel({
		id : 'TitlePanel'
		,buttonAlign : 'center'
		,region : 'north'
		,frame : true
		,height : 30
		,layout : 'fit'
	})
	obj.MainViewport = new Ext.Viewport({
		id : 'MainViewport'
		,layout : 'border'
		,items:[
			obj.TitlePanel
			,obj.CPWTabPanel
			,obj.PathWayGridPanel
		]
	});
	InitMainViewportEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}