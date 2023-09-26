function InitViewport1(){
	var obj = new Object();
	obj.HandHealthRepStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.HandHealthRepStore = new Ext.data.Store({
		proxy: obj.HandHealthRepStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RepID'
		}, 
		[
			{name: 'RepID', mapping: 'RepID'}
			,{name: 'CTLOCID', mapping: 'CTLOCID'}
			,{name: 'LocDesc', mapping: 'LocDesc'}
			,{name: 'ObserveDate', mapping: 'ObserveDate'}
			,{name: 'ObserveTime', mapping: 'ObserveTime'}
			,{name: 'ObserverDR', mapping: 'ObserverDR'}
			,{name: 'ObserverName', mapping: 'ObserverName'}
			,{name: 'ObserverCode', mapping: 'ObserverCode'}
			,{name: 'Identity', mapping: 'Identitys'}
			,{name: 'IdentityDesc', mapping: 'IdentitysDesc'}
			,{name: 'HandPoint', mapping: 'HandPoint'}
			,{name: 'HandPointDesc', mapping: 'HandPointDesc'}
			,{name: 'HandAction', mapping: 'HandAction'}
			,{name: 'HandActionDesc', mapping: 'HandActionDesc'}
			,{name: 'HandActionRit', mapping: 'HandActionRit'}
			,{name: 'HandActionRitDesc', mapping: 'HandActionRitDesc'}
			,{name: 'WardID', mapping: 'WardID'}
			,{name: 'WardDesc', mapping: 'WardDesc'}
		])
	});
	obj.HandHealthRepCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.HandHealthRep = new Ext.grid.GridPanel({
		id : 'HandHealthRep'
		,title : ''
		,region : 'center'
		,store : obj.HandHealthRepStore
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '日期', width: 80, dataIndex: 'ObserveDate', sortable: true}
			,{header: '科室', width: 100, dataIndex: 'LocDesc', sortable: true}
			,{header: '病区', width: 100, dataIndex: 'WardDesc', sortable: true}
			,{header: '报告人', width: 80, dataIndex: 'ObserverName', sortable: true}
			,{header: '专业类', width: 80, dataIndex: 'IdentityDesc', sortable: true}
			,{header: '手卫生指针', width: 230, dataIndex: 'HandPointDesc', sortable: true}
			,{header: '手卫生措施', width: 80, dataIndex: 'HandActionDesc', sortable: true}
			,{header: '是否正确', width: 60, dataIndex: 'HandActionRitDesc', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 1000,
			store : obj.HandHealthRepStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})

       });
	obj.Panel16 = new Ext.Panel({
		id : 'Panel16'
		,height : 280
		,buttonAlign : 'center'
		,autoHeight : true
		,columnWidth : .1
		,layout : 'form'
		,items:[
		]
	});
	obj.dtSurveryDate = new Ext.form.DateField({
		id : 'dtSurveryDate'
		,format : 'Y-m-d H:i'
		,fieldLabel : '日期'
		,anchor : '95%'
		,altFormats : 'Y-m-d H:i|d/m/Y H:i'
	});
		
	obj.cboInfCtLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboInfCtLocStore = new Ext.data.Store({
		proxy: obj.cboInfCtLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'depid'
		}, 
		[
			{name: 'depid', mapping: 'depid'}
			,{name: 'dep', mapping: 'dep'}
		])
	});
    obj.cboInfCtLoc = new Ext.form.ComboBox({
		minChars : 1
		,displayField : 'dep'
		,fieldLabel : '科室'
		,store : obj.cboInfCtLocStore
		,triggerAction : 'all'
		,valueField : 'depid'
		,anchor:'95%'
		,editable : true
		,mode: 'local'
	});
  obj.cboInfCtLocStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.NINFService.Aim.InfBaseSrv';
			param.QueryName = 'admdeplookup';
			param.Arg1 = obj.cboInfCtLoc.getRawValue();
			param.ArgCnt = 1;
	});
  obj.cboInfCtLocStore.load({});
    
  obj.WardStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.WardStore = new Ext.data.Store({
		proxy: obj.WardStoreProxy,
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
	obj.Ward = new Ext.form.ComboBox({
		id : 'Ward'
		,selectOnFocus : true
		,forceSelection : true
		,minChars : 1
		,displayField : 'Desc'
		,fieldLabel : '病区'
		,store : obj.WardStore
		,mode : 'local'  //remote
		,typeAhead : true
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'Rowid'
	});
	
	obj.WardStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.NINFService.Aim.BasePatInfoQuery';
			param.QueryName = 'QueryAllWard';
			param.Arg1 = obj.Ward.getValue();
			param.Arg2 = "";
			param.ArgCnt = 2;
	});
	obj.WardStore.load({}); 
    
  obj.RepUserStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.RepUserStore = new Ext.data.Store({
		proxy: obj.RepUserStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tmpid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'tmpid', mapping: 'tmpid'}
			,{name: 'Name', mapping: 'Name'}
		])
	});
	obj.RepUser=new Ext.form.ComboBox({
    id:'RepUser'
    ,store : obj.RepUserStore
		,minChars : 1
		,displayField : 'Name'
		,fieldLabel : '报告人'
		,valueField : 'tmpid'
		,editable : true
		,triggerAction : 'all'
		,mode:'local'
		,anchor : '95%' 
  });
   
	obj.DocTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.DocTypeStore = new Ext.data.Store({
		proxy: obj.DocTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'myid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'myid', mapping: 'myid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Description', mapping: 'Description'}
			,{name: 'Type', mapping: 'Type'}
		])
	});
	obj.DocType=new Ext.form.ComboBox({
    id:'DocType'
    ,store : obj.DocTypeStore
		//,minChars : 0
		,displayField : 'Description'
		,fieldLabel : '专业类'
		,valueField : 'Code'
		,editable : false
		,triggerAction : 'all'
		,mode:'local'
		,anchor : '95%' 
        });
  
  obj.HandHealthGuideStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.HandHealthGuideStore = new Ext.data.Store({
		proxy: obj.HandHealthGuideStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'myid'
		}, 
		[
			 {name: 'checked', mapping : 'checked'}
      ,{name: 'myid', mapping: 'myid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Description', mapping: 'Description'}
		])
	});
	obj.objStatusColumn = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.HandHealthGuide = new Ext.grid.GridPanel({
		height : 150
		,hideHeaders:true
		,store : obj.HandHealthGuideStore
		,anchor : "95%"
		,fieldLabel : '手卫生指针'
		,columns: [
			obj.objStatusColumn
			,{header: '状态', width: 143, dataIndex: 'Description', sortable: true}
			]	
		,plugins:obj.objStatusColumn
	});
	
	obj.Radio1 = new Ext.form.Radio({
		name : 'Measures'
		,anchor : '95%'
		,boxLabel : '擦手'
		,inputValue : 1
});
	obj.Radio2 = new Ext.form.Radio({
		name : 'Measures'
		,anchor : '95%'
		,boxLabel : '洗手'
		,inputValue : 2
});
	obj.Radio3 = new Ext.form.Radio({
		name : 'Measures'
		,anchor : '95%'
		,boxLabel : '未采取'
		,inputValue : 3
});
	obj.Radio4 = new Ext.form.Radio({
		name : 'Measures'	//名称一样，选择时有bug
		,anchor : '95%'
		,boxLabel : 'gloves'
		,inputValue : 4
});
	obj.RadioGroup1 = new Ext.form.RadioGroup({
		items:[
			obj.Radio1
			,obj.Radio2
		]
	});
	
	obj.RadioGroup2 = new Ext.form.RadioGroup({
		items:[
			obj.Radio3
			,obj.Radio4
		]
	});
	
	obj.RadioGroup = new Ext.form.RadioGroup({
		fieldLabel : '手卫生措施'
		,height : 100
		,items:[
			obj.RadioGroup1
			,obj.RadioGroup2
		]
	});
	
	obj.Radio5 = new Ext.form.Radio({
		name : 'YesNo'
		,anchor : '95%'
		,boxLabel : '是'
		,inputValue : 1
});
	obj.Radio6 = new Ext.form.Radio({
		name : 'YesNo'
		,anchor : '95%'
		,boxLabel : '否'
		,inputValue : 2
});
 obj.RadioGroupYN = new Ext.form.RadioGroup({
		fieldLabel : '手卫生是否正确'
		,height : 50
		,items:[
			obj.Radio5
			,obj.Radio6
		]
	});
	
	obj.BtnFind = new Ext.Button({
		id : 'BtnFind'
		,iconCls : 'icon-find'
		,anchor : '95%'
		,text : '查询'
	});
	
	obj.BtnSave = new Ext.Button({
		id : 'BtnSave'
		,iconCls : 'icon-save'
		,anchor : '95%'
		,text : '保存'
	});
	
	obj.BtnDelete = new Ext.Button({
		id : 'BtnDelete'
		,iconCls : 'icon-delete'
		,anchor : '95%'
		,text : '删除'
	});
	
	obj.RepID = new Ext.form.TextField({
		id : 'RepID'
		,hidden : true
		,anchor : '95%'
        });
        
	obj.FormPanel= new Ext.Panel({
		id : 'FormPanel'
		,layout : 'form'
		,buttonAlign : 'center'
		,height : 500
		,items:[
			obj.cboInfCtLoc
			,obj.Ward 
			,obj.dtSurveryDate
			,obj.RepUser
			,obj.DocType
			,obj.HandHealthGuide
			,obj.RadioGroup
			,obj.RadioGroupYN
			,obj.RepID
		],buttons:[obj.BtnFind,obj.BtnSave,obj.BtnDelete]
	});

obj.tFormPanel= new Ext.form.FormPanel({
		id : 'tFormPanel'
		,labelWidth : 70
		,labelAlign : 'right'
		,columnWidth : .9
		,buttonAlign : 'center'
		,region : 'west'
		,frame : true
		,width : 300
		,items:[obj.FormPanel]
	});
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[
			obj.HandHealthRep
			,obj.tFormPanel
		]
	});
	obj.HandHealthRepStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.NINFService.Aim.HandHealthSrv';
			param.QueryName = 'QryForHandHeRep';
			param.Arg1 = '';
			param.Arg2 = obj.dtSurveryDate.getRawValue().split(" ")[0];
			param.Arg3 = obj.cboInfCtLoc.getValue();
			param.ArgCnt = 3;
	});
	
	obj.RepUserStoreProxy.on('beforeload',function(objProxy,param){
		  param.ClassName = 'DHCMed.NINFService.Aim.HandHealthSrv';
			param.QueryName = 'QueryUserInfo';
			param.Arg1 = obj.RepUser.getRawValue();
			param.ArgCnt = 1;
		});
	obj.RepUserStore.load({});

	obj.DocTypeStoreProxy.on('beforeload',function(objProxy,param){
		  param.ClassName = 'DHCMed.SSService.DictionarySrv';
			param.QueryName = 'QryDictionary';
			param.Arg1 = "HandHealthDocType";
			param.ArgCnt = 1;
		});
	obj.DocTypeStore.load({});
	
	obj.HandHealthGuideStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.SSService.DictionarySrv';
		param.QueryName = 'QryDictionary';
		param.Arg1 = "HandHealthGuide";
		param.ArgCnt = 1;
	});
	obj.HandHealthGuideStore.load({});
		
	InitViewport1Event(obj);
	//事件处理代码
	obj.HandHealthRep.on("rowclick", obj.HandHealthRep_rowclick, obj);
	obj.RadioGroup1.on("change",obj.RadioGroup1_change, obj);
  obj.RadioGroup2.on("change",obj.RadioGroup2_change, obj); 
  obj.BtnFind.on("click",obj.BtnFind_click, obj);
  obj.BtnSave.on("click",obj.BtnSave_click, obj);
  obj.BtnDelete.on("click",obj.BtnDelete_click, obj);
  obj.LoadEvent(arguments);
  return obj;
}

