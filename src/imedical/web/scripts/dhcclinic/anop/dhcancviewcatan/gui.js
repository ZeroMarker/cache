//20170307+GY
function InitViewScreen(){
	var obj = new Object();
	
	obj.viewcode = new Ext.form.TextField({
		id : 'viewcode'
		,fieldLabel : '显示类型代码'
		,labelSeparator: ''
		,anchor : '95%'
	});	
	obj.viewsupcatId = new Ext.form.TextField({
		id : 'viewsupcatId'
		,hidden : true
    });
	obj.vieweventstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.vieweventstore = new Ext.data.Store({
		proxy: obj.vieweventstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Id'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Id', mapping: 'Id'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	
	
	obj.viewevent = new Ext.form.ComboBox({
		id : 'viewevent'
		,store:obj.vieweventstore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '显示事件'
		,labelSeparator: ''
		,valueField : 'Id'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	
	obj.viewcatstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.viewcatstore = new Ext.data.Store({
		proxy: obj.viewcatstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Id'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Id', mapping: 'Id'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.viewcat = new Ext.form.ComboBox({
		id : 'viewcat'
		,store:obj.viewcatstore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '按分类显示'
		,valueField : 'Id'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	obj.tRowid = new Ext.form.TextField({
		id : 'tRowid'
		,hidden : true
    });	
    
//    obj.tANCVSCId=new Ext.form.TextField({
//		id : 'tANCVSCId'
//		,hidden : true
//    });	
//    
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .20
		,layout : 'form'
		,items:[
			obj.viewcode
			,obj.viewevent
			,obj.viewcat
			,obj.tRowid
			,obj.viewsupcatId
		]
	});
	
	obj.viewname = new Ext.form.TextField({
		id : 'viewname'
		,fieldLabel : '显示类型名称'
		,labelSeparator: ''
		,anchor : '95%'
	}); 

	obj.viewphystoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.viewphystore = new Ext.data.Store({
		proxy: obj.viewphystoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Id'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Id', mapping: 'Id'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.viewphy = new Ext.form.ComboBox({
		id : 'viewphy'
		,store:obj.viewphystore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '显示用药'
		,valueField : 'Id'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
	});

	obj.viewsupcatstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.viewsupcatstore = new Ext.data.Store({
		proxy: obj.viewsupcatstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ANCVSCId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ANCVSCId', mapping: 'ANCVSCId'}
			,{name: 'ANCVSCDesc', mapping: 'ANCVSCDesc'}
		])
	});	
	obj.viewsupcat = new Ext.form.ComboBox({
		id : 'viewsupcat'
		,store:obj.viewsupcatstore
		,minChars:1	
		,displayField:'ANCVSCDesc'	
		,fieldLabel : '显示大类'
		,valueField : 'ANCVSCId'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
	}); 	
	
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .20
		,layout : 'form'
		,items:[
			obj.viewname
			,obj.viewphy
			,obj.viewsupcat
		]
	});

	obj.venipuncturestoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.venipuncturestore = new Ext.data.Store({
		proxy: obj.venipuncturestoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Id'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Id', mapping: 'Id'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.venipuncture = new Ext.form.ComboBox({
		id : 'venipuncture'
		,store:obj.venipuncturestore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '静脉穿刺'
		,valueField : 'Id'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
	});

	obj.viewhealthstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.viewhealthstore = new Ext.data.Store({
		proxy: obj.viewhealthstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Id'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Id', mapping: 'Id'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.viewhealth = new Ext.form.ComboBox({
		id : 'viewhealth'
		,store:obj.viewhealthstore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '显示治疗'
		,valueField : 'Id'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
	});

	obj.totaltypestoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.totaltypestore = new Ext.data.Store({
		proxy: obj.totaltypestoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tCode'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			//,{name: 'codeId', mapping: 'codeId'}
			,{name: 'tCode', mapping: 'tCode'}
			,{name: 'tDesc', mapping: 'tDesc'}
		])
	});
	obj.totaltype = new Ext.form.ComboBox({
		id : 'totaltype'
		,store:obj.totaltypestore
		,minChars:1
		,displayField:'tCode'
		,fieldLabel : '汇总类型'
		,valueField : 'tCode'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
	});
	

	
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .18
		,layout : 'form'
		,items:[
			obj.venipuncture
			,obj.viewhealth
			,obj.totaltype
		]
	});

	obj.viewvitalstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.viewvitalstore = new Ext.data.Store({
		proxy: obj.viewvitalstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Id'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Id', mapping: 'Id'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.viewvital = new Ext.form.ComboBox({
		id : 'viewvital'
		,store:obj.viewvitalstore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '显示生命体征'
		,valueField : 'Id'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
	});

	obj.viewcheckstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.viewcheckstore = new Ext.data.Store({
		proxy: obj.viewcheckstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Id'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Id', mapping: 'Id'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.viewcheck = new Ext.form.ComboBox({
		id : 'viewcheck'
		,store:obj.viewcheckstore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '显示检验'
		,valueField : 'Id'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
	});

	obj.choice = new Ext.form.TextField({
		id : 'choice'
		,fieldLabel : '选项'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	 obj.ANCOViewCatDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ANCOViewCatDrStore = new Ext.data.Store({
      	proxy: obj.ANCOViewCatDrStoreProxy,
      	reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'ANCEViewCatId'   
      		}, 
      		[	
      			{name: 'ANCEViewCatId', mapping: 'ANCEViewCatId'}
      			,{name: 'ANCEViewCat', mapping: 'ANCEViewCat'}
      		])
      	});		
   obj.ANCOViewCatDr =new Ext.form.ComboBox({
      	id : 'ANCOViewCatDr'
      	,store : obj.ANCOViewCatDrStore
      	,minChars : 0
      	,displayField : 'ANCEViewCat'
      	,fieldLabel : '显示分类关联项'
      	,valueField : 'ANCEViewCatId'
      	,multiSelect : true
      	,editable : true
      	,triggerAction : 'all'
      	,labelSeparator: ''
      	,anchor : '98%'
              });	
    obj.ANCOViewCatDrStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCANCCommonOrd';
      	param.QueryName = 'FindANCEViewCat';
      	param.Arg1="";
      	param.ArgCnt = 1;
      	});
    obj.ANCOViewCatDrStore.load();
      	
	
    var data = [];
	obj.listANCOViewCatDrStoreProxy=data;
	obj.listANCOViewCatDrStore = new Ext.data.Store({
		proxy: new Ext.data.MemoryProxy(data),
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'listId'}
			,{name: 'listDesc'}
		])
	});
	obj.listANCOViewCatDrStore.load();
	obj.listANCOViewCatDr = new Ext.ListView({
	    id : 'listANCOViewCatDr'
		,store: obj.listANCOViewCatDrStore
		,multiSelect: true
		,height : 40
		,bodyStyle :'overflow-x:hidden;overflow-y:auto'
		,hideHeaders : true
		,columns: [{
		        header : 'listDesc'
                ,dataIndex: 'listDesc'
            }]
    });	
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .18
		,layout : 'form'
		,items:[
			obj.viewvital
			,obj.viewcheck
			,obj.choice
		]
	});
	obj.listPanel1 = new Ext.Panel({
	    id : 'listPanel1'
	    //,width:100
	    //,anchor:'70%'
		,frame : true
		,items : [
		    obj.listANCOViewCatDr
		]
	});	
	obj.Panel5 = new Ext.Panel({
		id : 'Panel5'
		,buttonAlign : 'center'
		,columnWidth : .20
		,layout : 'form'
		,items:[
			obj.ANCOViewCatDr
			,obj.listPanel1
		]
	});
	
	obj.conditionPanel = new Ext.form.FormPanel({
		id : 'conditionPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 100
		,region : 'center'
		,layout : 'column'
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.Panel4
			,obj.Panel5
		]
	});

	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,text : '增加'
		,iconCls : 'icon-add'
		,width:86
		,style:'margin-left:15px;'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,text : '删除'
		,iconCls : 'icon-delete'
		,width:86
		,style:'margin-left:15px;'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,text : '更新'
		,iconCls : 'icon-updateSmall'
		,width:86
		,style:'margin-left:15px;'
	});
	obj.findbutton = new Ext.Button({
		id : 'findbutton'
		,iconCls : 'icon-find'
		,text : '查询'
		,width:86
		,style:'margin-left:15px;'
	});
	obj.checkall = new Ext.form.Checkbox({
		id : 'checkall'
		,labelSeparator: ''
		,fieldLabel : '全部'
	});
	obj.keypanel = new Ext.Panel({
		id : 'keypanel'
		,buttonAlign : 'center'
		,columnWidth : .72
		,layout : 'column'
        ,buttons:[
            obj.findbutton
            ,obj.addbutton
            ,obj.updatebutton
            ,obj.deletebutton
       ]
	});
	
	obj.checkpanel=new Ext.Panel({
		id : 'checkpanel'
		,buttonAlign : 'center'
		,columnWidth : .28
		,layout : 'form'
        ,items:[
            obj.checkall
         ]
	});
	
	obj.buttonPanel = new Ext.form.FormPanel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 35
		,region : 'south'
		,layout : 'column'
		,frame : false
		,items:[
			obj.keypanel
			//,obj.checkpanel
		]
//       ,buttons:[
//            obj.addbutton
//            ,obj.deletebutton
//            ,obj.updatebutton
//            ,obj.findbutton
//       ]
	});
	
	obj.functionPanel = new Ext.Panel({
		id : 'functionPanel'
		,buttonAlign : 'center'
		,height : 142
		,title : '显示分类'
		,iconCls:'icon-manage'
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
			idProperty: 'tRowid'
		}, 
	    [
	        {name: 'checked', mapping : 'checked'}
			,{name: 'RowId', mapping : 'RowId'}
			,{name: 'tRowid', mapping: 'tRowid'}
			,{name: 'tAncvcCode', mapping: 'tAncvcCode'}
			,{name: 'tAncvcDesc', mapping: 'tAncvcDesc'}
			,{name: 'tAncvcEvent', mapping: 'tAncvcEvent'}
			,{name: 'tAncvcOrder', mapping: 'tAncvcOrder'}
			,{name: 'tAncvcVPSite', mapping: 'tAncvcVPSite'}
			,{name: 'tAncvcVs', mapping: 'tAncvcVs'}
			,{name: 'tAncvcTherapy', mapping: 'tAncvcTherapy'}
			,{name: 'tAncvcLab', mapping: 'tAncvcLab'}
			,{name: 'tAncvcDisplayByCat', mapping: 'tAncvcDisplayByCat'}
			,{name: 'tANCVSCDesc', mapping: 'tANCVSCDesc'}
			,{name: 'tANCVSCId', mapping: 'tANCVSCId'}
			,{name: 'tVpsiteDesc', mapping: 'tVpsiteDesc'}
			,{name: 'tVpsiteId', mapping: 'tVpsiteId'}
			,{name: 'tLconId', mapping: 'tLconId'}
			,{name: 'tAncvcSummaryType', mapping: 'tAncvcSummaryType'}
			,{name: 'tOptions', mapping: 'tOptions'}
			,{name: 'tANCOViewCatDesc', mapping: 'tANCOViewCatDesc'}
			,{name: 'tANCOViewCatDr', mapping: 'tANCOViewCatDr'}
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
		,{header: '行号', width: 40, dataIndex: 'tRowid', sortable: true}
		,{header: '显示类型代码', width: 100, dataIndex: 'tAncvcCode', sortable: true}
		,{header: '显示类型名称', width: 100, dataIndex: 'tAncvcDesc', sortable: true}
		,{header: '显示生命体征', width: 100, dataIndex: 'tAncvcVs', sortable: true}
		,{header: '显示事件', width: 80, dataIndex: 'tAncvcEvent', sortable: true}
		,{header: '显示用药', width: 100, dataIndex: 'tAncvcOrder', sortable: true}
		,{header: '静脉穿刺', width: 100, dataIndex: 'tAncvcVPSite', sortable: true}
		,{header: '显示治疗', width: 100, dataIndex: 'tAncvcTherapy', sortable: true}
		,{header: '显示检验', width: 100, dataIndex: 'tAncvcLab', sortable: true}
		,{header: '按分类显示', width: 100, dataIndex: 'tAncvcDisplayByCat', sortable: true}
		,{header: '显示大类', width: 100, dataIndex: 'tANCVSCDesc', sortable: true}
		,{header: 'tANCVSCId', width: 100, dataIndex: 'tANCVSCId', sortable: true}
		,{header: '静脉穿刺位置', width: 100, dataIndex: 'tVpsiteDesc', sortable: true}
		,{header: 'tVpsiteId', width: 100, dataIndex: 'tVpsiteId', sortable: true}
		,{header: 'tLconId', width: 100, dataIndex: 'tLconId', sortable: true}
		,{header: '小结类型', width: 100, dataIndex: 'tAncvcSummaryType', sortable: true}
		,{header: '选项', width: 100, dataIndex: 'tOptions', sortable: true}
		,{header: '显示分类关联项', width: 150, dataIndex: 'tANCOViewCatDesc', sortable: true}
		,{header: 'tANCOViewCatDr', width: 100, dataIndex: 'tANCOViewCatDr', sortable: true}
		]
//		,viewConfig:
//		{
//			forceFit: false
//		}
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
		,title : '显示分类查询结果'
		,iconCls:'icon-result'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,items:[
		    obj.Panel23
		    ,obj.retGridPanel
		    ,obj.Panel25
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
	

	obj.vieweventstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCViewCat';
		param.QueryName = 'FindAncVC';
		param.ArgCnt = 0;
	});
	obj.vieweventstore.load({});
	
	obj.viewcatstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCViewCat';
		param.QueryName = 'FindAncVC';
		param.ArgCnt = 0;
	});
	obj.viewcatstore.load({});
	
	obj.viewphystoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCViewCat';
		param.QueryName = 'FindAncVC';
		param.ArgCnt = 0;
	});
	obj.viewphystore.load({});
	
	obj.viewsupcatstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCViewCat';
		param.QueryName = 'FindVSC';
		param.ArgCnt = 0;
	});
	obj.viewsupcatstore.load({});

	obj.venipuncturestoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCViewCat';
		param.QueryName = 'FindAncVC';
		param.ArgCnt = 0;
	});
	obj.venipuncturestore.load({});
	
	obj.viewhealthstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCViewCat';
		param.QueryName = 'FindAncVC';
		param.ArgCnt = 0;
	});
	obj.viewhealthstore.load({});
	
	obj.totaltypestoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLCom';
		param.QueryName = 'LookUpComCode';
		param.Arg1 = 'SummaryType'
		param.ArgCnt = 1;
	});
	obj.totaltypestore.load({});

	obj.viewvitalstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCViewCat';
		param.QueryName = 'FindAncVC';
		param.ArgCnt = 0;
	});
	obj.viewvitalstore.load({});

	obj.viewcheckstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCViewCat';
		param.QueryName = 'FindAncVC';
		param.ArgCnt = 0;
	});
	obj.viewcheckstore.load({});
	
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCViewCat';
		param.QueryName = 'FindANCViewCat';
		//param.Arg1 = 'OpaStatus';
		param.Arg1 = 'N';
		param.Arg2 = obj.checkall.getValue()?'Y':'N';
		param.Arg3 = obj.viewname.getValue();
		param.ArgCnt = 3;
	});
	obj.retGridPanelStore.load({});
	
	InitViewScreenEvent(obj);
	
	//事件处理代码
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);
    obj.findbutton.on("click", obj.findbutton_click, obj);
    obj.ANCOViewCatDr.on('select',obj.ANCOViewCatDr_select,obj);
    obj.viewsupcat.on('select',obj.viewsupcat_select,obj);
	obj.listANCOViewCatDr.on('dblClick',obj.listANCOViewCatDr_dblClick,obj);
	obj.LoadEvent(arguments);
	return obj;
}