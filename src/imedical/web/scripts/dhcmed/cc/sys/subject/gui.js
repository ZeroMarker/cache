function InitViewport(){
	var obj = new Object();
	obj.CurrRowid="";
	obj.gridSubjectStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridSubjectStore = new Ext.data.Store({
		proxy: obj.gridSubjectStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'rowid', mapping: 'rowid'}
			,{name: 'Title', mapping: 'Title'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'IsActiveDesc', mapping: 'IsActiveDesc'}
			,{name: 'Categroy', mapping: 'Categroy'}
			,{name: 'Expression', mapping: 'Expression'}
			,{name: 'ResumeText', mapping: 'ResumeText'}
			,{name: 'IsAutoRun', mapping: 'IsAutoRun'}
			,{name: 'IsAutoRunDesc', mapping: 'IsAutoRunDesc'}
			,{name: 'IsTimeLine', mapping: 'IsTimeLine'}
			,{name: 'IsTimeLineDesc', mapping: 'IsTimeLineDesc'}
		])
	});
	obj.gridSubject = new Ext.grid.GridPanel({
		id : 'obj.gridSubject'
		,store : obj.gridSubjectStore
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: 'ID', width: 60, dataIndex: 'rowid', sortable: true}
			,{header: '代码', width: 100, dataIndex: 'Code', sortable: true}
			,{header: '名称', width: 150, dataIndex: 'Title', sortable: true}
			,{header: '是否<br>有效', width: 45, dataIndex: 'IsActiveDesc', sortable: true}
			,{header: '是否自<br>动任务', width: 60, dataIndex: 'IsAutoRunDesc', sortable: true}
			,{header: '是否生成<br>时间线数据', width: 60, dataIndex: 'IsTimeLineDesc', sortable: true}
			,{header: '说明', width: 200, dataIndex: 'Desc', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.gridSubjectStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,viewConfig : {
			forceFit : true
		}
	});
	obj.CenterFPanel = new Ext.Panel({
		id : 'CenterFPanel'
		,region : 'center'
		,layout : 'border'
		,items:[
			obj.gridSubject
		]
	});
	obj.txtCode = new Ext.form.TextField({
		id : 'txtCode'
		,fieldLabel : '代码'
		,anchor : '100%'
	});
	obj.txtTitle = new Ext.form.TextField({
		id : 'txtTitle'
		,fieldLabel : '名称'
		,anchor : '100%'
	});
	obj.txtDesc = new Ext.form.TextField({
		id : 'txtDesc'
		,fieldLabel : '说明'
		,anchor : '100%'
	});
	obj.chkIsActive = new Ext.form.Checkbox({
		id : 'chkIsActive'
		,checked : true
		,fieldLabel : '是否有效'
	});
	obj.chkIsAutoWork = new Ext.form.Checkbox({
		id : 'chkIsAutoWork'
		,fieldLabel : '是否自动业务处理'
	});	
	obj.chkIsTimeLine = new Ext.form.Checkbox({
		id : 'chkIsTimeLine'
		,fieldLabel : '是否生成时间线数据'
	});	
	
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-update'
		,anchor : '95%'
		,text : '更新'
	});
	
	obj.btnStartConfig = new Ext.Button({
		iconCls : 'icon-add'
		,anchor : '95%'
		,text : '启动设置'
	});

	obj.btnAutoWorkFilter = new Ext.Button({
		iconCls : 'icon-add'
		,anchor : '95%'
		,text : '自动监控过滤设置'
	});
	
	obj.Viewport = new Ext.Viewport({
		id : 'Viewport'
		,layout : 'fit'
		,items:[
			{
				region: 'center',
				layout : 'border',
				frame : true,
				items : [
					{
						region: 'south',
						height: 65,
						layout : 'form',
						frame : true,
						labelWidth : 70,
						items : [
							{
								layout : 'column',
								items : [
									{
										columnWidth:.40
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtCode]
									},{
										columnWidth:.60
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtTitle]
									},{
										width:100
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.chkIsActive]
									},{
										width:150
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 120
										,items: [obj.chkIsAutoWork]
									},{
										width:190
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 140
										,items: [obj.chkIsTimeLine]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										columnWidth:1
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtDesc]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						//frame : true,
						items : [
							obj.gridSubject
						]
					}
				],
				buttons : [
					obj.btnUpdate
					,obj.btnStartConfig
					,obj.btnAutoWorkFilter
				]
			}
		]
	});
	obj.gridSubjectStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.Sys.SubjectSrv';
			param.QueryName = 'QrySubject';
			param.Arg1 = "";
			param.ArgCnt = 1;
	});
	obj.gridSubjectStore.load({params : {start:0,limit:20}});
	
	InitViewportEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

function InitColor(SubjectID){
	var obj = new Object();
	obj.SubjectID=SubjectID;
	obj.CurrColorID="";
	obj.ColorListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.ColorListStore = new Ext.data.Store({
		proxy: obj.ColorListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'SubjectDr', mapping: 'SubjectDr'}
			,{name: 'Score', mapping: 'Score'}
			,{name: 'ColorRGB', mapping: 'ColorRGB'}
		])
	});
	obj.ColorListCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.ColorList = new Ext.grid.GridPanel({
		id : 'ColorList'
		,store : obj.ColorListStore
		,buttonAlign : 'center'
		,width : 177
		,height : 368
		,region : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '分数', width: 50, dataIndex: 'Score', sortable: true}
			,{header: '颜色', width: 100, dataIndex: 'ColorRGB', sortable: true}
		]});
	obj.LeftPanel = new Ext.Panel({
		id : 'cLeftPanel'
		,buttonAlign : 'center'
		,columnWidth : .1
		,items:[
		]
	});
	obj.Score = new Ext.form.NumberField({
		id : 'Score'
		,fieldLabel : '分数'
		,anchor : '95%'
	});
	obj.txtVCColour = new Ext.form.TextField({
		id : 'txtVCColour'
		,fieldLabel : '颜色'
		,value : '███  测试颜色'
		,readOnly : true
		,width : 190
	});
	obj.ColorPicker = new Ext.ColorPalette({
			id : 'ColorPicker'
			,fieldLabel : '调色板'
			,width : 500
	});
	obj.ColorPicker.colors =  
			   ["000000","000033","000066","000099","0000CC","0000FF","330000","330033","330066","330099","3300CC",
				"3300FF","660000","660033","660066","660099","6600CC","6600FF","990000","990033","990066","990099",
				"9900CC","9900FF","CC0000","CC0033","CC0066","CC0099","CC00CC","CC00FF","FF0000","FF0033","FF0066",
				"FF0099","FF00CC","FF00FF","003300","003333","003366","003399","0033CC","0033FF","333300","333333",
				"333366","333399","3333CC","3333FF","663300","663333","663366","663399","6633CC","6633FF","993300",
				"993333"];
	obj.cboColor = new Ext.form.ComboBox({
	    triggerAction: 'all',
	    mode: 'local',
	    listWidth : 120,
	    width : 18,
	    editable : false,
	    store: new Ext.data.ArrayStore({
	        id: 0,
	        fields: [
	            'myId',
	            'displayText'
	        ],
	        data: [['#000000', '000000'], ['#000033', '000033'],['#000066', '000066']
	              ,['#000099', '000099'], ['#0000CC', '0000CC'],['#0000FF', '0000FF']
	              ,['#330000', '330000'], ['#330033', '330033'],['#330066', '330066']
	              ,['#330099', '330099'], ['#3300CC', '3300CC'],['#3300FF', '3300FF']
	              ,['#660000', '660000'], ['#660033', '660033'],['#660066', '660066']
	              ,['#CC0099', 'CC0099'], ['#CC00CC', 'CC00CC'],['#CC00FF', 'CC00FF']
	              ,['#FF0000', 'FF0000'], ['#FF0033', 'FF0033'],['#FF0066', 'FF0066']
	        ]
	    }),
	    valueField: 'myId',
	    displayField: 'displayText',
	    hideParent:true
	});
	
   	obj.cboMarkColorStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboMarkColorStore = new Ext.data.Store({
		proxy: obj.cboMarkColorStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ColorNumber'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ColorNumber', mapping: 'ColorNumber'}
			,{name: 'ColorName', mapping: 'ColorName'}
		])
	});
	obj.cboMarkColor = new Ext.form.ComboBox({
		id : 'cboMarkColor'
		,width : 18
		,store : obj.cboMarkColorStore
		,minChars : 1
		,displayField : 'ColorName'
		,valueField : 'ColorNumber'
		,editable : false
		,triggerAction : 'all'
		,hideParent : true
		,listWidth : 120
	});
	obj.cboMarkColorStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.Sys.SubjectSrv';
			param.QueryName = 'QueryColor';
			param.ArgCnt = 0;
	});
	obj.cboMarkColorStore.load({});
    obj.Panel15 = new Ext.Panel({
		id : 'Panel15'
		,buttonAlign : 'center'
		,columnWidth : 0.9
		,layout : 'form'
		,items:[
			obj.txtVCColour
		]
	});
	obj.Panel16 = new Ext.Panel({
		id : 'Panel16'
		,buttonAlign : 'center'
		,columnWidth : 0.1
		,items:[
			obj.cboMarkColor
		]
	});
	obj.Panel14 = new Ext.Panel({
		id : 'Panel14'
		,buttonAlign : 'center'
		,layout : 'column'
		,items:[
			obj.Panel15
			,obj.Panel16
		]
	});
	obj.CenterPanel = new Ext.Panel({
		id : 'cLeftCenPanel'
		,buttonAlign : 'center'
		,columnWidth : .8
		,labelWidth : 60
		,layout : 'form'
		,items:[
			obj.Score
			,obj.Panel14
		]
	});
	obj.RightPanel = new Ext.Panel({
		id : 'cRightPanel'
		,buttonAlign : 'center'
		,columnWidth : .1
		,items:[
		]
	});
	obj.cBtnUpdate = new Ext.Button({
		id : 'cBtnUpdate'
		,iconCls : 'icon-update'
		,anchor : '95%'
		,text : '更新'
	});
	obj.cBtnDelete = new Ext.Button({
		id : 'cBtnDelete'
		,iconCls : 'icon-delete'
		,anchor : '95%'
		,text : '删除'
	});
	obj.ColorPanel = new Ext.form.FormPanel({
		id : 'ColorPanel'
		,width : '400'
		,labelAlign : 'right'
		,buttonAlign : 'center'
		,labelWidth : 80
		,region : 'east'
		,layout : 'column'
		,frame : true
		,items:[
			obj.LeftPanel
			,obj.CenterPanel
			,obj.RightPanel
		]
		,buttons:[
			obj.cBtnUpdate
			,obj.cBtnDelete
		]
	});
	obj.Color = new Ext.Window({
		id : 'Color'
		,height : 400
		,buttonAlign : 'center'
		,width : 591
		,title : '监控主题颜色维护'
		,layout : 'border'
		,modal : true
		,items:[
			obj.ColorList
			,obj.ColorPanel
		]
	});
	obj.ColorListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.Sys.SubjectSrv';
			param.QueryName = 'QrySubColorByID';
			param.Arg1 = obj.SubjectID;
			param.ArgCnt = 1;
	});
	obj.ColorListStore.load({});
	
	InitColorEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

