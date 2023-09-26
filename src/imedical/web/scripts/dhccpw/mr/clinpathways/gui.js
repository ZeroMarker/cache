function InitMainViewport(){
	var obj = new Object();
	obj.CurrClinPathWay = null;
	obj.SelClinPathWay = null;
	obj.CurrLogon = null;
	obj.CurrPaPerson = null;
	obj.CurrPAADM = null;
	
	//***************************************************************
	// ���²���
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
        ,emptyText: '������δά�������ٴ�·��'
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
            //header: '���ҳ����ٴ�·��',
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
		//,title : 'ѡ���ٴ�·��'
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
                title: '���ҳ���·��',
                frame: true,
                layout : 'fit',
                items: [obj.lsvLocClinPathWay]
            },{
                id : 'CPWSelTabPanelElse',
                layout : 'fit',
                frame: true,
                title: '����·��'  //CPWSelTabPanelElse web.DHCCPW.MRC.ClinPathWaysSrv QueryCPWTypeTree
                
            }
		]
	});
	
	//***************************************************************
	// ���²���
	//***************************************************************
	obj.CPWTreeDetailPanel = new Ext.Panel({
		id : 'CPWTreeDetailPanel'
		,buttonAlign : 'center'
		,layout : 'fit'
		,title : '��ϸչ��'
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
		,title : '��չ��'
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
	// �ϰ벿��
	//***************************************************************
	obj.btnOutWay  = new Ext.Toolbar.Button({
		id : 'btnOutWay',
		text: '����',   
		iconCls : 'icon-cancel',
		tooltip: '����'
	});
	obj.btnFormShow  = new Ext.Toolbar.Button({
		id : 'btnFormShow',
		text: 'չ�ֱ�',
		iconCls : 'icon-new',
		tooltip: 'չ�ֱ�'
	});
	obj.btnVarRecord  = new Ext.Toolbar.Button({
		id : 'btnVarRecord',
		text: '�����¼',
		iconCls : 'icon-new',
		tooltip: '�����¼'
	});
	obj.btnPrintForm  = new Ext.Toolbar.Button({
		id : 'btnPrintForm',
		text: '��ӡ��',
		iconCls : 'icon-print',
		tooltip: '��ӡ��'
	});
	obj.btnPathWayRst  = new Ext.Toolbar.Button({
		id : 'btnPathWayRst',
		text: '·������',
		iconCls : 'icon-save',
		tooltip: '·������'
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
		,title : '���뾶��¼'
		,buttonAlign : 'center'
		,viewConfig : {forceFit:true}
		,columns: [
			{header: '�ٴ�·��', width: 200, dataIndex: 'CPWDesc', sortable: false}
			,{header: '״̬', width: 60, dataIndex: 'StatusDesc', sortable: false}
			,{header: '�뾶�׶�', width: 180, dataIndex: 'CPWEpDesc', sortable: false}
			//,{header: '�뾶����', width: 100, dataIndex: 'CPWEPStepDesc', sortable: false}
			,{header: '�뾶��', width: 60, dataIndex: 'InDoctorDesc', sortable: false}
			,{header: '�뾶����', width: 80, dataIndex: 'InDate', sortable: false}
			,{header: '�뾶ʱ��', width: 60, dataIndex: 'InTime', sortable: false}
			,{header: '������', width: 60, dataIndex: 'OutDoctorDesc', sortable: false}
			,{header: '��������', width: 80, dataIndex: 'OutDate', sortable: false}
			,{header: '����ʱ��', width: 60, dataIndex: 'OutTime', sortable: false}
			,{header: '����ԭ��', width: 100, dataIndex: 'OutReasonDesc', sortable: false}
			,{header: '������', width: 60, dataIndex: 'UpdateUserDesc', sortable: false}
			,{header: '��������', width: 80, dataIndex: 'UpdateDate', sortable: true}
			,{header: '����ʱ��', width: 60, dataIndex: 'UpdateTime', sortable: false}
			,{header: '��ע', width: 300, dataIndex: 'Comments', sortable: false}
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
	//��������
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