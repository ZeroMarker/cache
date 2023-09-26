
function InitMainViewport(){
	var obj = new Object();
	SubCategID=ExtTool.GetParam(window,"subcate");    //add by wuqk 2011-09-16
	obj.MainGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.MainGridPanelStore = new Ext.data.Store({
		proxy: obj.MainGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'TypeID', mapping: 'TypeID'}
			,{name: 'TypeDesc', mapping: 'TypeDesc'}
			,{name: 'CPWDID', mapping: 'CPWDID'}
			,{name: 'CPWDDesc', mapping: 'CPWDDesc'}
			,{name: 'IsActive', mapping: 'IsActive'}
		])
	});
	obj.MainGridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.MainGridPanel = new Ext.grid.GridPanel({
		id : 'MainGridPanel'
		,store : obj.MainGridPanelStore
		,region : 'center'
		,viewConfig: {forceFit: true}
		,buttonAlign : 'center'
		,columns: [
			//{header: '��Ŀ����', width: 100, dataIndex: 'TypeDesc', sortable: true}
			//,{header: '�ٴ�·��', width: 100, dataIndex: 'CPWDDesc', sortable: true}
			{header: '����', dataIndex: 'Code', sortable: false}
			,{header: '����', dataIndex: 'Desc', sortable: false}
			,{header: '�Ƿ���Ч',  dataIndex: 'IsActive', sortable: false}
		]/*
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.MainGridPanelStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})*/
		,stripeRows : true
        ,autoExpandColumn : 'Desc'
        ,bodyStyle : 'width:100%'
        ,autoWidth : true
        ,autoScroll : true
        ,viewConfig : {
            forceFit : true
        }
	});
	obj.SubPanel1 = new Ext.Panel({
		id : 'SubPanel1'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
		]
	});
	obj.txtCode = new Ext.form.TextField({
		id : 'txtCode'
		,width : 150
		,fieldLabel : '����'
		,anchor : '95%'
	});
	obj.txtDesc = new Ext.form.TextField({
		id : 'txtDesc'
		,width : 150
		,fieldLabel : '����'
		,anchor : '95%'
	});
	obj.chkIsActive = new Ext.form.Checkbox({
		id : 'chkIsActive'
		//,boxLabel : '�Ƿ���Ч'
		,fieldLabel : '�Ƿ���Ч'
	});
	/*
	obj.cboSubCategStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboSubCategStore = new Ext.data.Store({
		proxy: obj.cboSubCategStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.cboSubCateg = new Ext.form.ComboBox({
		id : 'cboSubCateg'
		,width : 150
		,store : obj.cboSubCategStore
		,displayField : 'Desc'
		,fieldLabel : '��Ŀ����'
		,editable : false
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'Rowid'
	});
	obj.cboCPWDicStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboCPWDicStore = new Ext.data.Store({
		proxy: obj.cboCPWDicStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.cboCPWDic = new Ext.form.ComboBox({
		id : 'cboCPWDic'
		,width : 150
		,store : obj.cboCPWDicStore
		,displayField : 'Desc'
		,fieldLabel : '�ٴ�·��'
		,editable : true
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'ID'
	});*/
	obj.SubPanel2 = new Ext.Panel({
		id : 'SubPanel2'
		,buttonAlign : 'center'
		,columnWidth : .50
		,layout : 'form'
		,labelAlign : 'right'
		,labelWidth : 60
		,items:[
			obj.txtCode
			,obj.txtDesc
			,obj.chkIsActive
			//,obj.cboSubCateg
			//,obj.cboCPWDic
		]
	});
	
	obj.SubPanel3 = new Ext.Panel({
		id : 'SubPanel3'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
		]
	});
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-save'
		,text : '����'
	});
	obj.btnFind = new Ext.Button({
		id : 'btnFind'
		,iconCls : 'icon-find'
		,text : '��ѯ'
	});
	obj.MainPanel = new Ext.form.FormPanel({
		id : 'MainPanel'
		,buttonAlign : 'center'
		,layout : 'column'
		,height:140,
		frame:true,
		labelAlign:'right'
		,region : 'south'
		,items:[
			obj.SubPanel1
			,obj.SubPanel2
			,obj.SubPanel3
		]
		,buttons:[
			obj.btnUpdate
			//,obj.btnFind
		]
	
	});
	obj.WinDicCateg = new Ext.Viewport({
		id : 'WinDicCateg'
		,height : 520
		,buttonAlign : 'center'
		,width : 800
		,title : '�����ֵ�ά��'
		,layout : 'border'
		,modal : true
		,items:[
			obj.MainGridPanel
			,obj.MainPanel
		]
	});/*
	obj.cboSubCategStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.BaseDicSubCategory';
			param.QueryName = 'QrySubCategory';
			param.Arg1 = '';
			param.ArgCnt = 1;
	});
	obj.cboSubCategStore.load({});
	obj.cboCPWDicStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.ClinPathWaysDicSrv';
			param.QueryName = 'QryClinPathWayDic';
			param.ArgCnt = 0;
	});
	obj.cboCPWDicStore.load({});*/
	obj.MainGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.BaseDictionary';
			param.QueryName = 'QryBaseDictionary';
			param.Arg1 = '';   
			param.Arg2 = SubCategID;//obj.cboSubCateg.getValue();  //by wuqk 2011-09-16
			param.Arg3 = '';//obj.cboCPWDic.getValue();
			param.Arg4 = '';
			param.ArgCnt = 4;
	});
	obj.MainGridPanelStore.load();
	
	InitMainViewportEvent(obj);
  	obj.LoadEvent(arguments);
  	return obj;
}

