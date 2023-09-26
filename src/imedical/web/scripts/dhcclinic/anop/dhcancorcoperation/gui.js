function InitViewScreen(){
	var obj = new Object();
	//20150316+dyl
	obj.ancORCDesc = new Ext.form.TextField({
		id : 'ancORCDesc'
		,fieldLabel : '手术名称'
		,anchor : '95%'
	});	
	obj.ancORCCode = new Ext.form.TextField({
		id : 'ancORCCode'
		,fieldLabel : '手术代码'
		,anchor : '95%'
	});	

	//手术分类
	obj.OperCategModelDrstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.OperCategModelDrstore=new Ext.data.Store({
		proxy: obj.OperCategModelDrstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'operCategId'
		}, 
		[
			{name: 'operCategId', mapping: 'operCategId'}
			,{name: 'operCategLDesc', mapping: 'operCategLDesc'}
			
		])
	});
	obj.OperCategModelDr = new Ext.form.ComboBox({
		id : 'OperCategModelDr'
		,store:obj.OperCategModelDrstore
		,minChars:1
		//,displayField:'tBPCEMDesc'
		,displayField:'operCategLDesc'
		,fieldLabel : '手术分类'
		,valueField : 'operCategId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	

	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.ancORCDesc
			,obj.ancORCCode
		]
	});
		
	//手术规模已停用+20160830+dyl
	/*
	obj.AnCoplstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
    function seltextb(v,record) { 
         return record.ANCOPLRowId+" || "+record.ANCPLDesc; 
    } 
    
	obj.AnCoplstore=new Ext.data.Store({
		proxy: obj.AnCoplstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ANCOPLRowId'
		}, 
		[
			{name: 'ANCOPLRowId', mapping: 'ANCOPLRowId'}
			,{name: 'ANCPLDesc', mapping: 'ANCPLDesc'}
			//,{ name: 'selecttext', convert:seltextb}
			
		])
	});
	obj.AnCoplDr = new Ext.form.ComboBox({
		id : 'AnCoplDr'
		,store:obj.AnCoplstore
		,minChars:1
		,displayField:'ANCPLDesc'
		,fieldLabel : '手术规模'
		,valueField : 'ANCOPLRowId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.AnCoplstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'GetOPLevel';
		param.ArgCnt = 0;
		
	});
	obj.AnCoplstore.load({});
	*/
		//手术类型
	var data=[
		['D','诊断性操作'],
		['T','治疗性操作'],
		['N','手术']
		]
	obj.opTypeStoreProxy=data;
	obj.opTypeStore = new Ext.data.Store({
		proxy: new Ext.data.MemoryProxy(data),
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'code'}
			,{name: 'desc'}
		])
	});

	obj.opType = new Ext.form.ComboBox({
		id : 'opType'
		,valueField : 'code'
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '手术类型'
		,store : obj.opTypeStore
		,triggerAction : 'all'
		,anchor : '95%'
	});


	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		 obj.opType
		 ,obj.OperCategModelDr	
		]
	});
  
//切刀类型	
	obj.BldtpstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
    function seltext(v,record) { 
         return record.BLDTPRowId+" || "+record.BLDTPDesc; 
    } 
    
	obj.Bldtpstore=new Ext.data.Store({
		proxy: obj.BldtpstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'BLDTPRowId'
		}, 
		[
			{name: 'BLDTPRowId', mapping: 'BLDTPRowId'}
			,{name: 'BLDTPDesc', mapping: 'BLDTPDesc'}
			//,{ name: 'selecttext', convert:seltext}
			
		])
	});
	obj.ancOPCModelDr = new Ext.form.ComboBox({
		id : 'ancOPCModelDr'
		,store:obj.Bldtpstore
		,minChars:1
		,displayField:'BLDTPDesc'
		,fieldLabel : '切口类型'
		,valueField : 'BLDTPRowId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
   obj.Bldtpstore.load({});

//手术体位
obj.OperPositionstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	})); 
function seltextd(v,record) { 
         return record.OPPOS_RowId+" || "+record.OPPOS_Desc; 
    } 
    
	obj.OperPositionstore=new Ext.data.Store({
		proxy: obj.OperPositionstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'OPPOS_RowId'
		}, 
		[
			{name: 'OPPOS_RowId', mapping: 'OPPOS_RowId'}
			,{name: 'OPPOS_Desc', mapping: 'OPPOS_Desc'}
			//,{ name: 'selecttext', convert:seltextd}
			
		])
	});
	obj.OperPositionModelDr = new Ext.form.ComboBox({
		id : 'OperPositionModelDr'
		,store:obj.OperPositionstore
		,minChars:1
		//,displayField:'tBPCEMDesc'
		,displayField:'OPPOS_Desc'
		,fieldLabel : '手术体位'
		,valueField : 'OPPOS_RowId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	
	obj.OperPositionstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'GetOperPosition';
		param.Arg1=obj.OperPositionModelDr.getValue();
		param.ArgCnt = 1;
		
	});	
	obj.OperPositionstore.load({});
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.ancOPCModelDr
			,obj.OperPositionModelDr
		]
	});
	obj.RowId = new Ext.form.TextField({
		id : 'RowId'
		,hidden : true
    });
     //手术部位
     obj.BodsstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
 	 function seltextc(v,record) { 
         return record.BODS_RowId+" || "+record.BODS_Desc; 
    } 
    
	obj.Bodsstore=new Ext.data.Store({
		proxy: obj.BodsstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'BODS_RowId'
		}, 
		[
			{name: 'BODS_RowId', mapping: 'BODS_RowId'}
			,{name: 'BODS_Desc', mapping: 'BODS_Desc'}
			,{ name: 'selecttext', convert:seltextc}
			
		])
	});
	obj.BodssDr = new Ext.form.ComboBox({
		id : 'BodssDr'
		,store:obj.Bodsstore
		,minChars:1
		,displayField:'BODS_Desc'
		//,displayField:'selecttext'
		,fieldLabel : '手术部位'
		,valueField : 'BODS_RowId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.BodsstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'FindBodySite';
		param.ArgCnt = 0;
		
	});
	obj.Bodsstore.load({});
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.BodssDr
			,obj.RowId
			//,obj.opType
		]
	});


	obj.conditionPanel = new Ext.form.FormPanel({
		id : 'conditionPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,region : 'center'
		,layout : 'column'
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.Panel4
		]
	});
	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,text : '增加'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,text : '更新'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,text : '删除'
	});
	obj.findbutton = new Ext.Button({
		id : 'findbutton'
		,text : '查找'
	});

	obj.keypanel = new Ext.Panel({
		id : 'keypanel'
		,buttonAlign : 'center'
		//,columnWidth : .72
		,layout : 'column'
        ,buttons:[
        	obj.addbutton
            ,obj.updatebutton
            ,obj.deletebutton
            ,obj.findbutton
       ]
	});

	obj.buttonPanel = new Ext.form.FormPanel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 50
		,region : 'south'
		,layout : 'column'
		,frame : false
		,items:[
			obj.keypanel
		]
	});
	
	obj.functionPanel = new Ext.Panel({
		id : 'functionPanel'
		,buttonAlign : 'center'
		,height : 140
		,title : '手术名关联'
		,region : 'north'
		,layout : 'border'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.conditionPanel
			,obj.buttonPanel
		]
    });
    
	
	obj.retGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.retGridPanelStore = new Ext.data.Store({
		proxy: obj.retGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tOperId'
		}, 
	    [
			{name: 'tOperId', mapping: 'tOperId'}
			,{name: 'tOperDesc', mapping: 'tOperDesc'}
			,{name: 'tOperCode', mapping: 'tOperCode'}
			,{name: 'tAncoplId', mapping: 'tAncoplId'}
			,{name: 'tAncoplDesc', mapping: 'tAncoplDesc'}
			,{name: 'tBldtpId', mapping: 'tBldtpId'}
			,{name: 'tBldtpDesc', mapping: 'tBldtpDesc'}
			,{name: 'tBodsId', mapping: 'tBodsId'}
			,{name: 'tBodsDesc', mapping: 'tBodsDesc'}
			,{name: 'tOperPositionId', mapping: 'tOperPositionId'}
			,{name: 'tOperPositionDesc', mapping: 'tOperPositionDesc'}
			,{name: 'tOperCategId', mapping: 'tOperCategId'}
			,{name: 'tOperCategDesc', mapping: 'tOperCategDesc'}
			,{name: 'tOpTypeCode', mapping: 'tOpTypeCode'}
			,{name: 'tOpType', mapping: 'tOpType'}
		])
	});

    obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //设置为单行选中模式
		,clicksToEdit:1    //单击编辑
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,columns:[
		new Ext.grid.RowNumberer()
		//,{header: 'tID', width: 50, dataIndex: 'tID', sortable: true}
		,{header: '手术名称', width:160, dataIndex: 'tOperDesc', sortable: true}
		,{header: '手术代码', width:160, dataIndex: 'tOperCode', sortable: true}
		//,{header: '手术规模', width:160, dataIndex: 'tAncoplDesc', sortable: true}
		,{header: '切刀类型', width:100, dataIndex: 'tBldtpDesc', sortable: true}
		,{header: '手术部位', width:100, dataIndex: 'tBodsDesc', sortable: true}
		,{header: '手术体位', width:100, dataIndex: 'tOperPositionDesc', sortable: true}
		,{header: '手术分类', width:100, dataIndex: 'tOperCategDesc', sortable: true}
		,{header: '手术类型', width:100, dataIndex: 'tOpType', sortable: true}
		,{header: 'tOpTypeCode', width:10, dataIndex: 'tOpTypeCode', sortable: true,hidden:true}
		,{header: 'tOperCategId', width:10, dataIndex: 'tOperCategId', sortable: true,hidden:true}
		,{header: 'tOperId', width:100, dataIndex: 'tOperId', sortable: true}
		//,{header: 'tAncoplId', width:10, dataIndex: 'tAncoplId', sortable: true,hidden:true}
		,{header: 'tBldtpId', width:10, dataIndex: 'tBldtpId', sortable: true,hidden:true}
		,{header: 'tBodsId', width:10, dataIndex: 'tBodsId', sortable: true,hidden:true}
		,{header: 'tOperPositionId', width:10, dataIndex: 'tOperPositionId', sortable: true,hidden:true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.retGridPanelStore,
		    displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
		    emptyMsg: '没有记录'
		})
	});

	obj.Panel23 = new Ext.Panel({
		id : 'Panel23'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'north'
		,items:[
		]
	});
	obj.Panel25 = new Ext.Panel({
		id : 'Panel25'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'south'
		,items:[
		]
	});	
	obj.resultPanel = new Ext.Panel({
		id : 'resultPanel'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,items:[
		    obj.Panel23
			,obj.Panel25
		    ,obj.retGridPanel
		]
	});
	
    obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.functionPanel
			,obj.resultPanel
		]
	});
	obj.OperCategModelDrstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCOrc';
		param.QueryName = 'FindORCOperationCategory';
		param.ArgCnt =0;
		
	});
	obj.OperCategModelDrstore.load({});


	obj.BldtpstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'GetBladeType';
		param.ArgCnt =0;
		
	});
	obj.Bldtpstore.load({});

	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCOrc';
		param.QueryName = 'FindOrcOperation';
		param.Arg1=obj.RowId.getValue();
		param.Arg2=obj.ancORCDesc.getValue();
		param.ArgCnt =2;
	});
	obj.retGridPanelStore.load({
		 params : {
				start:0
				,limit:200
			}

		});
	
	InitViewScreenEvent(obj);
	
	//事件处理代码
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);
    obj.findbutton.on("click", obj.findbutton_click, obj);

	obj.LoadEvent(arguments);
	return obj;
}