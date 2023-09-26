function InitViewScreen(){
	var obj = new Object();	
	obj.dateFrm = new Ext.form.DateField({
		id : 'dateFrm'
		,value : new Date()
		,format : 'j/n/Y'
		,fieldLabel : '开始日期'
		,anchor : '95%'
	});
	obj.dateTo = new Ext.form.DateField({
		id : 'dateTo'
		,value : new Date()
		,format : 'j/n/Y'
		,fieldLabel : '结束日期'
		,anchor : '95%'
	});
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.dateFrm
			,obj.dateTo
		]
	});
	obj.comAppLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comAppLocStore = new Ext.data.Store({
		proxy: obj.comAppLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ctlocId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ctlocId', mapping: 'ctlocId'}
			,{name: 'ctlocDesc', mapping: 'ctlocDesc'}
			,{name: 'ctlocCode', mapping: 'ctlocCode'}
		])
	});
	obj.comAppLoc = new Ext.form.ComboBox({
		id : 'comAppLoc'
		,store : obj.comAppLocStore
		,minChars : 1
		,displayField : 'ctlocDesc'
		,fieldLabel : '申请科室'
		,valueField : 'ctlocId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.RiskStatData=[['I','申请'],
    		['A','审核'],
    		['U','撤销审核']     
    	];
    //I,S,C,A,U,D,F    Initial,Assess,Check,Audit,UnAudit,Delete,Finish    
	obj.comRiskStatStoreProxy = new Ext.data.MemoryProxy(obj.RiskStatData);	
	obj.RiskStatColumnName = new Ext.data.Record.create([
		{ name: "RiskStatCode", type: "string" },
		{ name: "RiskStatDesc", type: "string" }
		]);
	obj.RiskStatReader = new Ext.data.ArrayReader({},obj.RiskStatColumnName);
	
	/*obj.comRiskStatStore = new Ext.data.SimpleStore({
        fields: ['RiskStatCode', 'RiskStatDesc'],
 		data : data
	});*/
	obj.comRiskStatStore = new Ext.data.Store({
		proxy: obj.comRiskStatStoreProxy,
        reader: obj.RiskStatReader,
		autoLoad: true
		});	
	
	obj.comRiskStat = new Ext.form.ComboBox({
		id : 'comRiskStat'
		,store : obj.comRiskStatStore
		,minChars : 1
		,displayField : 'RiskStatDesc'
		,fieldLabel : '分级管理状态'
		,valueField : 'RiskStatCode'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.comRiskSortData=[
		['B','择期']
		,['R','限期']
		,['E','急诊']
		];
	obj.comRiskSortStoreProxy = new Ext.data.MemoryProxy(obj.comRiskSortData);
	obj.columnName = new Ext.data.Record.create([
		{ name: "RiskTypeCode", type: "string" },
		{ name: "RiskTypeDesc", type: "string" }
		]);
	obj.riskSortReader = new Ext.data.ArrayReader({},obj.columnName);
	obj.comRiskSortStore = new Ext.data.Store({
		proxy: obj.comRiskSortStoreProxy,
        reader: obj.riskSortReader,
		autoLoad: true
		});
	
	obj.comRiskSort = new Ext.form.ComboBox({
		id : 'comRiskSort'
		,store : obj.comRiskSortStore
		,minChars : 1
		,displayField : 'RiskTypeDesc'
		,fieldLabel : '手术类型'
		,valueField : 'RiskTypeCode'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.comAppLoc
			,obj.comRiskStat			
		]
	});
	obj.OperDiffcultyStoreProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.OperDiffcultyStore=new Ext.data.Store({
		proxy:obj.OperDiffcultyStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'operCategId'
		}, 
		[
			{name: 'operCategId', mapping: 'operCategId'},
			{name: 'operCategLDesc', mapping: 'operCategLDesc'}
		])
	});
	obj.OperDiffculty = new Ext.form.ComboBox({
		id : 'OperDiffculty'
		,store : obj.OperDiffcultyStore
		,minChars : 1
		,displayField : 'operCategLDesc'
		,fieldLabel : '手术难度分类'
		,valueField : 'operCategId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.ASAStoreProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.ASAStore=new Ext.data.Store({
		proxy:obj.ASAStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Id'
		}, 
		[
			{name: 'ASAId', mapping: 'Id'},
			{name: 'ASADesc', mapping: 'Description'}
		])
	});
	obj.ASA = new Ext.form.ComboBox({
		id : 'ASA'
		,store : obj.ASAStore
		,minChars : 1
		,displayField : 'ASADesc'
		,fieldLabel : 'ASA分级'
		,valueField : 'ASAId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
    
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.OperDiffculty
			,obj.ASA
		]
	});
	obj.txtMedCareNo = new Ext.form.TextField({
		id : 'txtMedCareNo'
		,fieldLabel : '病案号'
		,anchor : '95%'
		,enableKeyEvents:true
		//,vtype:'lengthRange'
		//,lengthRange:{min:0,max:8}
	});
	obj.AnrcrcStoreProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.AnrcrcStore=new Ext.data.Store({
		proxy:obj.AnrcrcStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'anrcrcId'
		}, 
		[
			{name: 'anrcrcId', mapping: 'anrcrcId'},
			{name: 'RiskClassDesc', mapping: 'tDesc'}
		])
	});	

	obj.Anrcrc = new Ext.form.ComboBox({
		id : 'Anrcrc'
		,store : obj.AnrcrcStore
		,minChars : 1
		,displayField : 'RiskClassDesc'
		,fieldLabel : '手术风险级别'
		,valueField : 'anrcrcId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.ManageClassStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
   	obj.ManageClassStore=new Ext.data.Store({
	   	proxy: obj.ManageClassStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowId'
		}, 
	    [
			{name: 'RowId', mapping : 'RowId'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'CtlocDr', mapping: 'CtlocDr'}
			,{name: 'Ctloc', mapping: 'Ctloc'}
			,{name: 'AuditCarPrvTpDescStr', mapping: 'AuditCarPrvTpDescStr'}
			,{name: 'AuditCarPrvTpDrStr', mapping: 'AuditCarPrvTpDrStr'}
		])
		});
	obj.ManageClass = new Ext.form.ComboBox({
		id : 'ManageClass'
		,store : obj.ManageClassStore
		,minChars : 1
		,displayField : 'Desc'
		,fieldLabel : '风险管理级别'
		,valueField : 'RowId'
		,triggerAction : 'all'
		,anchor : '95%'
	});	
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[			
			obj.Anrcrc
			,obj.ManageClass
		]
	});
	obj.Panel5 = new Ext.Panel({
		id : 'Panel5'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.txtMedCareNo
			,obj.comRiskSort
		]
	});
	obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,region : 'center'
		,layout : 'column'
		,items:[
			//obj.Panel0
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.Panel4
		    ,obj.Panel5
		]
	});	
	obj.chkapply = new Ext.form.Checkbox({
		id : 'chkapply'
		,fieldLabel : '申请时间'
		,anchor : '50%'
	});
	obj.chkoutDept = new Ext.form.Checkbox({
		id : 'chkoutDept'
		,fieldLabel : '出科时间'
		,anchor : '50%'
	});
	obj.schSubapply = new Ext.Panel({
		id : 'schSubapply'
		,buttonAlign : 'center'	
		,columnWidth :.3
		,layout : 'form'
		,items:[
			obj.chkapply	
		]
	});
	obj.schSubDept = new Ext.Panel({
		id : 'schSubDept'
		,buttonAlign : 'center'	
		,columnWidth :.3
		,layout : 'form'
		,items:[
			obj.chkoutDept
		]
	});	
	obj.schSubPl = new Ext.Panel({
		id : 'schSubPl'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'column'
		,items:[
			obj.schSubapply
			,obj.schSubDept
		]
	});	
	obj.btnSch = new Ext.Button({
		id : 'btnSch'
		,text : '查询'
	});
	obj.btnMedify = new Ext.Button({
		id : 'btnMedify'
		,text : '修改'
	});
	obj.labelApply=new Ext.form.Label(
	{
		id:'labColorApply'
		,text:'申请'
		,cls:'white'
		,width:30
		,height:15
	})
	obj.labelDecline=new Ext.form.Label(
	{
		id:'labelDecline'
		,text:'撤销审核'
		,cls:'deepskyblue'
		,width:50
		,height:15
	})
	obj.labelReceive=new Ext.form.Label(
	{
		id:'labelReceive'
		,text:'审核'
		,cls:'palegreen'
		,width:30
		,height:15
	})
	obj.schSubChildPl2 = new Ext.Panel({
		id : 'schSubChildPl2'
		,buttonAlign : 'left'
		,columnWidth : .4
		,layout : 'column'
		,items:[
		]
		,buttons:[
			obj.btnSch
			,obj.btnMedify
		]
	});
	obj.schSubChildPl3 = new Ext.Panel({
		id : 'schSubChildPl3'
		,buttonAlign : 'left'
		,columnWidth : .1
		,layout : 'column'
		,items:[
			obj.labelApply			
			,obj.labelReceive
			,obj.labelDecline		
		]
		,buttons:[]
	}); 
	obj.chkFormPanel = new Ext.form.FormPanel({
		id : 'chkFormPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 45
		,region : 'south'
		,layout : 'column'
		,frame : true
		,items:[
		    obj.schSubChildPl3
		    ,obj.schSubPl
		    ,obj.schSubChildPl2	
		]
	});
	obj.schPanel = new Ext.Panel({
		id : 'schPanel'
		,buttonAlign : 'center'
		,height : 142
		,title : '手术风险评估查询'
		,region : 'north'
		,layout : 'border'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.fPanel
			,obj.chkFormPanel		
		]
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
	
	
	obj.retGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.retGridPanelStore = new Ext.data.Store({
		proxy: obj.retGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'anrrDr'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
		    ,{name: 'ANRdateStr', mapping: 'ANRdateStr'}
			,{name: 'anrrDr', mapping: 'anrrDr'}
			,{name: 'admId', mapping: 'admId'}
			,{name: 'patname', mapping: 'patname'}
			,{name: 'age', mapping: 'age'}
			,{name: 'sex', mapping: 'sex'}			
			,{name: 'medCareNo', mapping: 'medCareNo'}
			,{name: 'locid', mapping: 'locid'}
			,{name: 'Locdes', mapping: 'Locdes'}
			,{name: 'OperationDr', mapping: 'OperationDr'}
			,{name: 'OperationDesc', mapping: 'OperationDesc'}
			,{name: 'OperDiffDr', mapping: 'OperDiffDr'}
			,{name: 'OperDiffDesc', mapping: 'OperDiffDesc'}
			,{name: 'AsaDr', mapping: 'AsaDr'}
			,{name: 'AsaDesc', mapping: 'AsaDesc'}
			,{name: 'AnrcrcDr', mapping: 'AnrcrcDr'}
			,{name: 'AnrcrcDesc', mapping: 'AnrcrcDesc'}
			,{name: 'AnrcmcDr', mapping: 'AnrcmcDr'}
			,{name: 'AnrmcDesc', mapping: 'AnrmcDesc'}
			,{name: 'OpType', mapping: 'OpType'}
			,{name: 'OpTypeDesc', mapping: 'OpTypeDesc'}
			,{name: 'AnrStatus', mapping: 'AnrStatus'}
		    ,{name: 'AnrStatusDesc', mapping: 'AnrStatusDesc'}
		    ,{name: 'CrtDocDrDesc', mapping: 'CrtDocDrDesc'}		    
		])
	});
	obj.retGridPanelCheckCol = new Ext.grid.CheckColumn({
		header:'选择', 
		dataIndex: 'checked', 
		width: 40
	});
	var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer()
			,obj.retGridPanelCheckCol
			,{header: '时间', width: 140, dataIndex: 'ANRdateStr', sortable: true}
			,{header: '姓名', width: 70, dataIndex: 'patname', sortable: true}
			,{header: '年龄', width: 50, dataIndex: 'age', sortable: true}
			,{header: '性别', width: 50, dataIndex: 'sex', sortable: true}
			,{header: '就诊号', width: 100, dataIndex: 'admId', sortable: true}
			,{header: '病案号', width: 100, dataIndex: 'medCareNo', sortable: true}
			,{header: '风险管理状态', width: 80, dataIndex: 'AnrStatusDesc', sortable: true}
			,{header: '科室', width: 140, dataIndex: 'Locdes', sortable: true}
			,{header: '手术名称', width: 140, dataIndex: 'OperationDesc', sortable: true}
			,{header: '手术难度', width: 80, dataIndex: 'OperDiffDesc', sortable: true}
			,{header: '预估ASA分级', width: 100, dataIndex: 'AsaDesc', sortable: true}
			,{header: '手术风险级别', width: 100, dataIndex: 'AnrcrcDesc', sortable: true}
			,{header: '风险管理级别', width: 100, dataIndex: 'AnrmcDesc', sortable: true}
			,{header: '手术类型', width: 100, dataIndex: 'OpTypeDesc', sortable: true}
			,{header: '分级管理状态', width: 100, dataIndex: 'AnrStatusDesc', sortable: true}
			,{header: '录入医师', width: 70, dataIndex: 'CrtDocDrDesc', sortable: true}
			,{header: '分级ID', width: 100, dataIndex: 'anrrDr', sortable: true}		
		]
	})
	obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //设置为单行选中模式
		,clicksToEdit:1    //单击编辑
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,cm:cm
		,viewConfig:
		{
			forceFit: false,
			//Return CSS class to apply to rows depending upon data values
			getRowClass: function(record, index)
			{
				var status = record.get('AnrStatusDesc');
				var type=record.get('OpTypeDesc');
				switch (status)
				{
					case '申请':
						if(type=='急诊') return 'emergency';
						break;
					case '撤销审核':
						return 'deepskyblue'; //blue /refuse
						break;
					case '审核':
						return 'palegreen';  //green //arranged
						break;
					case '完成':
						return 'yellow' ;//yellow //finish
						break;
					case '术中':
						return 'red' ;//red 
						break;
					case '术毕':
						return 'lightblue' ;//light blue
						break;
					case '恢复室':
						return 'resume';
						break;
					default:
						return 'exec'; //
						break; 
				}
			}
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.retGridPanelStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,plugins : obj.retGridPanelCheckCol
	});

	obj.opManageMenu=new Ext.menu.Menu({});
	obj.tb=new Ext.Toolbar(
	{
		height: 30
		,items:[
			{   
				text:"风险管理",   
				menu:obj.opManageMenu 
			}			
		]
	});
	obj.resultPanel = new Ext.Panel({
		id : 'resultPanel'
		,buttonAlign : 'center'
		,title : '手术风险评估结果'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,tbar:obj.tb
		,items:[
			obj.Panel23
			,obj.Panel25
			,obj.retGridPanel
		]
	});

	obj.EpisodeID = new Ext.form.TextField({
		id : 'EpisodeID'
	});
	obj.opaId = new Ext.form.TextField({
		id : 'opaId'
	});
	obj.loc = new Ext.form.TextField({
		id : 'loc'
	});
	obj.userLocId = new Ext.form.TextField({
		id : 'userLocId'
	});
	obj.maxOrdNo = new Ext.form.TextField({
		id : 'maxOrdNo'
	});
	obj.logUserType = new Ext.form.TextField({
		id : 'logUserType'
	});
	obj.InDateType = new Ext.form.TextField({  //查询条件按申请时间或者出院时间(离科室)
		id : 'InDateType'
	});
	obj.hiddenPanel = new Ext.Panel({
		id : 'hiddenPanel'
		,buttonAlign : 'center'
		,region : 'south'
		,hidden : true
		,items:[
			obj.EpisodeID
			,obj.opaId
			,obj.loc
			,obj.userLocId
			,obj.maxOrdNo
			,obj.logUserType
			,obj.InDateType
		]
	});
	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.schPanel
			,obj.resultPanel
			,obj.hiddenPanel
		]
	});
	
	obj.ManageClassStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANRCManageClass';
		param.QueryName = 'FindANRCManageClass';
		param.ArgCnt = 0;
	});
	obj.ManageClassStore.load({});	
	obj.comAppLocStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLCom';
		param.QueryName = 'FindLocList';
		param.Arg1 = obj.comAppLoc.getRawValue();
		param.Arg2 = 'INOPDEPT^OUTOPDEPT^EMOPDEPT';
		param.ArgCnt = 2;
	});
	obj.comAppLocStore.load({});
    obj.OperDiffcultyStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCOrc';
		param.QueryName = 'FindORCOperationCategory';
		param.ArgCnt=0;
	});
	obj.OperDiffcultyStore.load({});
	obj.ASAStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCom';
		param.QueryName = 'FindASAClass';
		param.ArgCnt=0;
	});
	obj.ASAStore.load({}); 
	
	var sessLoc=session['LOGON.CTLOCID'];

	obj.AnrcrcStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANRCRiskCLass';
		param.QueryName = 'FindRiskClass';
		param.Arg1=obj.Anrcrc.getRawValue();
		param.Arg2='';
		param.Arg3='';
		param.ArgCnt=3;	});
	obj.AnrcrcStore.load({});
	obj.comRiskSortStore.load({});
	obj.comRiskStatStore.load({});
	//obj.ordNoStore.load({});
	InitViewScreenEvent(obj);
	
	//事件处理代码
	obj.comAppLoc.on("select", obj.comAppLoc_select, obj);
	obj.comAppLoc.on("keyup", obj.comAppLoc_keyup, obj);
	//obj.txtMedCareNo.on("keyup", obj.txtMedCareNo_keyup, obj);	
	obj.btnSch.on("click", obj.btnSch_click, obj);
	obj.btnMedify.on("click", obj.btnMedify_click, obj);
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);	
	obj.LoadEvent(arguments);
	return obj;
}

