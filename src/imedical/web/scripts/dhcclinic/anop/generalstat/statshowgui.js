function InitViewScreen(){
	var obj = new Object();
	//查询结果
	obj.retGridHeaderStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.retGridHeaderStore = new Ext.data.Store({
		proxy: obj.retGridHeaderStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'code'   
			}, 
			[
				{name: 'code', mapping: 'code'}
				,{name: 'desc', mapping: 'desc'}
				,{name: 'width', mapping: 'width'}
			]
		)
	});
	obj.retGridHeaderStoreProxy.on('beforeload',function(objProxy, param){
		param.ClassName = 'web.DHCANOPStat';
		param.QueryName = 'GetANCIResultHeader';
		param.Arg1=obj.anciId;
		param.ArgCnt =1;
	});
	
	obj.anciId = 0;
	obj.ifInquiry = 'N';
	obj.dateType = 'OP';
	obj.historySeq = "";
	obj.sumType = '';
	
	obj.retGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : "./dhcclinic.anop.statmethodresponse.csp"
	}));
	
	obj.retGridPanelStore = new Ext.data.Store({
		proxy: obj.retGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'displayId'   
			}, 
			[
				{name: 'displayId', mapping: 'displayId'}
				,{name: 'desc', mapping: 'desc'}
			]
		)
	});
	obj.retGridPanelStoreProxy.on('beforeload',function(objProxy, param){
		param.ClassName = 'web.DHCANOPStat';
		param.MethodName = 'ResponseInquiryResult';
		param.Arg1 = '';
		param.Arg2 = obj.anciId;
		param.Arg3 = '';
		param.Arg4 = '';
		param.Arg5 = obj.ifInquiry;
		param.Arg6 = obj.dateType;
		param.Arg7 = obj.sumType;
		param.Arg8 = obj.historySeq;
		param.ArgCnt = 8;
	});
	obj.resultPanel = new Ext.Panel({
		id : 'resultPanel'
		,title : '手术查询结果'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,items:[
		]
	});
	/*obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		//,items:[]
	});*/
	
	InitViewScreenEvent(obj);
	obj.retGridHeaderStore.on('load',obj.retGridHeaderStore_load,obj);
	obj.retGridPanelStore.on("load",obj.retGridPanelStore_load,obj);
	obj.LoadEvent(arguments);
	return obj;
}