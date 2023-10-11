Ext.QuickTips.init();
Ext.form.Field.prototype.msgTarget = 'side';

//Desc:重写gridrowNumberer
//add by Candyxu
Ext.grid.RowNumbererA = Ext.extend(Ext.grid.RowNumberer, {
	fixed:false,
	css : 'background:#EEEEEE;',
	width: 40,
    renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
    return store.lastOptions.params.start + rowIndex + 1;   
    }   
}); 
// 全局的临时Store ，目前作用为：记录当前添加的方案，为“修改方案”提供信息
// add by 牛才才
var tempStore = new Ext.data.JsonStore({
	fields: ['ID','Desc','SaveUserID','SaveUserName']
});
// 描述：定义简单查询中的 科室、病区 store    for #Bug1537   **************** start
// add by 牛才才
var getLocStore = new Ext.data.JsonStore({
	autoLoad: false,
	url: '../web.eprajax.query.getDicList.cls',
	fields: ['ID', 'DicAlias', 'DicCode', 'DicDesc'],
	root: 'data',
	totalProperty: 'TotalCount',
	baseParams: { start: 0, limit: 12},
	listeners: {
		'beforeload': function() {
			var txtValueText = Ext.getCmp("cbxLoc").getRawValue();
			getLocStore.removeAll();
			getLocStore.baseParams = { DicCode: 'S07', DicQuery: txtValueText};
		}
	}
});

var getWardStore = new Ext.data.JsonStore({
	autoLoad: false,
	url: '../web.eprajax.query.getDicList.cls',
	fields: ['ID', 'DicAlias', 'DicCode', 'DicDesc'],
	root: 'data',
	totalProperty: 'TotalCount',
	baseParams: { start: 0, limit: 12},
	listeners: {
		'beforeload': function() {
			var txtValueText = Ext.getCmp("cbxWard").getRawValue();
			getWardStore.removeAll();
			getWardStore.baseParams = { DicCode: 'S10', DicQuery: txtValueText};
		}
	}
});
//*************************************************************************** end

var frmSimple = new Ext.form.FormPanel({
	id: "frmSimple",
	keys:[{
		key: Ext.EventObject.ENTER,
		scope:this,
		fn: EnterEvent
	}],
	items: [
		{
			id: "SimpleConditionTab",
			xtype: 'tabpanel',
			activeTab: 0,
			deferredRender: false,
			width: 358,
			//defaults: Ext.isIE?{}:{bodyStyle:'padding:10px'},
			items: [
			{
				xtype: 'panel',
				id: 'SimpleCondition',
				layout: 'form',
				title: '简单条件检索',
				lableWidth: 60,
				labelAlign: 'right',
				autoHeight: true,
				width: 350,
				//frame: true,
				defaults: { width: 150 },
				defaultType: 'textfield',
				items: [{
						id: 'txtPatientName',
						name: 'txtPatientName',
						fieldLabel: '患者姓名',
						emptyText: '请输入患者姓名'
					},
					{
						id: 'txtRegNo',
						name: 'txtRegNo',
						fieldLabel: '登记号',
						emptyText: '请输入登记号'
					},
					{
						id: 'MedicareNo',
						name: 'MedicareNo',
						fieldLabel: '病案号',
						emptyText: '病案号'
					},
					{
						id: 'txtEpisodeNo',
						name: 'txtEpisodeNo',
						fieldLabel: '就诊号',
						emptyText: '请输入就诊号'
					},
					{
						id: 'txtDiagnose',
						name: 'txtDiagnose',
						fieldLabel: '诊断',
						emptyText: '请输诊断内容'
					},
					{
						id: 'txtDiagnote',
						name: 'txtDiagnote',
						fieldLabel: '诊断备注',
						emptyText: '请输诊断备注内容'
					},
					{
						id: 'cbxRegType',
						name: 'cbxRegType',
						xtype: 'combo',
						fieldLabel: '就诊类型',
						emptyText: '请选择就诊类型',
						width: 150,
						//anchor: '90%',
						store: new Ext.data.SimpleStore({
							fields: ['id', 'name'],
							data:[
								['I','住院'],
								['O','门诊'],
								['E','急诊']
							]	
						}),
						mode: 'local',
						displayField: 'name',
						valueField: 'id'
					},
					{
						id: 'cbxLoc',
						name: 'cbxLoc',
						xtype: 'combo',
						fieldLabel: '科室',
						minChars: 1,
						store:getLocStore,
						hiddenName: 'locID',
						displayField: 'DicDesc',
						valueField: 'DicCode',
						triggerAction: 'all',
						selectOnFocus: true,
						emptyText: '请选择患者科室',
						listWidth: 240,
						pageSize: 12,
						mode : 'remote',
						listeners:{
							'expand': function(){
								getLocStore.load();
							}
						}
					},
					{
						id: 'cbxWard',
						name: 'cbxWard',
						xtype: 'combo',
						fieldLabel: '病区',
						minChars: 1,
						store: getWardStore,
						/*
						store: new Ext.data.JsonStore({
							url: '../web.eprajax.hisinterface.hospitalinfo.cls?Action=getWards',
							fields: ['ID', 'Name']
						}),
						*/
						hiddenName: 'wardID',
						displayField: 'DicDesc',
						valueField: 'DicCode',
						triggerAction: 'all',
						selectOnFocus: true,
						emptyText: '请选择患者病区',
						listWidth: 240,
						pageSize: 12,
						mode : 'remote',
						listeners:{
							'expand': function(){
								getWardStore.load();
							}
						}
					},
					{
						id: 'dtAdmBeginDate',
						name: 'dtAdmBeginDate',
						xtype: 'datefield',
						format: 'Y-m-d',
						width: 150,
						readOnly: false,
						fieldLabel: '入院起始日期',
						emptyText: '入院起始日期'
					},
					{
						id: 'dtAdmEndDate',
						name: 'dtAdmEndDate',
						xtype: 'datefield',
						format: 'Y-m-d',
						width: 150,
						readOnly: false,
						fieldLabel: '入院截止日期',
						emptyText: '入院截止日期'
					},
					{
						id: 'dtDisBeginDate',
						name: 'dtDisBeginDate',
						xtype: 'datefield',
						format: 'Y-m-d',
						width: 150,
						readOnly: false,
						fieldLabel: '出院起始日期',
						emptyText: '出院起始日期'
					},
					{
						id: 'dtDisEndDate',
						name: 'dtDisEndDate',
						xtype: 'datefield',
						format: 'Y-m-d',
						width: 150,
						readOnly: false,
						fieldLabel: '出院截止日期',
						emptyText: '出院截止日期'
					},
					{
						id: 'hiddenSimpleGUID',
						xtype: 'hidden',
						name: 'hiddenSimpleGUID'
					},
					{
						id: 'hiddenCols',
						xtype: 'hidden',
						name: 'hiddenCols'
					}
				],
				
				bbar: [
					{
						id: 'btnSimpleConReset',
						name: 'btnSimpleConReset',
						text: '重置',
						cls: 'x-btn-text-icon',
						icon: '../scripts/epr/Pics/btnReset.gif',
						pressed: false,
						handler: function() {
							//Ext.getCmp("frmSimple").getForm().reset();
							Ext.getCmp("txtPatientName").reset();
							Ext.getCmp("txtRegNo").reset();
							Ext.getCmp("MedicareNo").reset();
							Ext.getCmp("txtEpisodeNo").reset();
							Ext.getCmp("txtDiagnose").reset();
							Ext.getCmp("txtDiagnote").reset();
							Ext.getCmp("cbxRegType").reset();
							Ext.getCmp("cbxLoc").reset();
							Ext.getCmp("cbxWard").reset();
							Ext.getCmp("dtAdmBeginDate").reset();
							Ext.getCmp("dtAdmEndDate").reset();
							Ext.getCmp("dtDisBeginDate").reset();
							Ext.getCmp("dtDisEndDate").reset();
						}
					},
					'->', '-',
					{
						id: 'btnCommit',
						name: 'btnCommit',
						text: '提交查询',
						cls: 'x-btn-text-icon',
						icon: '../scripts/epr/Pics/btnConfirm.gif',
						pressed: false,
						handler:  function() {
							SimpleCommit();
						}
					}
				]
			},
			{
				xtype: 'panel',
				id: 'SimpleNoStr',
				title: '查询号串检索',
				autoHeight: true,
				width: 350,
				defaults: { width: 150 },
				defaultType: 'textfield',
				items: [
					{
						xtype: 'panel',
						id: 'SimpleNoStrNoType',
						layout: 'form',
						lableWidth: 60,
						labelAlign: 'right',
						width: 358,
						frame: true,
						items: [
							{
								id: 'NoStrcbxNoType',
								name: 'NoStrcbxNoType',
								xtype: 'combo',
								fieldLabel: '号串类型',
								emptyText: '请选择号串类型',
								width: 150,
								listWidth: 146,
								value: 'admNo',
								readOnly: true,
								triggerAction : 'all', 
								store: new Ext.data.SimpleStore({
									fields: ['id', 'name'],
									data:[
										['admNo','就诊号'],
										['patNo','登记号'],
										['medNo','病案号']
									]	
								}),
								mode: 'local',
								displayField: 'name',
								valueField: 'id'
							}
						]
					},
					{
						xtype: 'panel',
						id: 'SimpleNoStrNoArea',
						layout: 'fit',
						autoHeight: true,
						width: 358,
						frame: true,
						items: [
							{
								id: 'NoStrEpisodeNoStrArea',
								name: 'NoStrEpisodeNoStrArea',
								xtype: 'textarea',
								width: 350,
								height: 226,
								emptyText: '请输入/导入号串内容!\n\n导入数据时,读取Excel中的A1——An,每个单元格中是一个号,一次最多导入1500个号.\n\n查询时,每次查询不得多于2500个号,且每个号之间用 # 隔开！例:IP0000000001#IP0000000002'
							}
						]
					}
				],
				bbar: [
					{
						id: 'NoStrbtnSimpleConReset',
						name: 'NoStrbtnSimpleConReset',
						text: '重置',
						cls: 'x-btn-text-icon',
						icon: '../scripts/epr/Pics/btnReset.gif',
						pressed: false,
						handler: function() {
							Ext.getCmp("NoStrEpisodeNoStrArea").reset();
						}
					},
					'-',
					{
						id: 'NoStrbtnReadNoStr',
						name: 'NoStrbtnReadNoStr',
						text: '从Excel导入号串',
						cls: 'x-btn-text-icon',
						icon: '../scripts/epr/Pics/btnReset.gif',
						pressed: false,
						handler: function() {
							//ReadExcel();
							var fd = new ActiveXObject("MSComDlg.CommonDialog");
							fd.Filter = "All Files (*.*)|*.xls;*.xlsx";
							fd.FilterIndex = 4;
							fd.MaxFileSize = 1024;
							fd.CancelError=true;
							fd.ShowOpen();
							var filePath = fd.Filename;
							ReadExcel(filePath);
						}
					},
					'->', '-',
					{
						id: 'NoStrbtnCommit',
						name: 'NoStrbtnCommit',
						text: '提交查询',
						cls: 'x-btn-text-icon',
						icon: '../scripts/epr/Pics/btnConfirm.gif',
						pressed: false,
						handler:  function() {
							SimpleCommit();
						}
					}
				]
			}
		]
	},
	{
		xtype: 'panel',
		//id: 'pnlSimpleCols',
		id: 'frmSimpleCols',
		title: '定义结果设置',
		header: true,
		width: 358,
		//height: 327,
		autoHeight: true,
		frame: true,
		html: '<div id="divSimpleResultCols" clsss="divColumn" style="width:100%;height:100%;overflow:hidden;overflow-x:hidden;"></div>',
		bbar: [
				{
					id: 'btnSimpleColReset',
					name: 'btnSimpleColReset',
					text: '重置',
					cls: 'x-btn-text-icon',
					icon: '../scripts/epr/Pics/btnReset.gif',
					pressed: false,
					handler: function (){
						divSimpleResultColsReset();             
						reConfigSimpleGridCM();	   //重置后自动提交结果列
					}
				}, '->', '-',
				{
					id: 'btnAddSimpleCol',
					name: 'btnAddSimpleCol',
					text: '添加结果列',
					cls: 'x-btn-text-icon',
					icon: '../scripts/epr/Pics/btnConfirm.gif',
					pressed: false,
					handler: function (){
						var windowType = 'ConditonsAndResultCols';  //弹出窗口性质
						var addX = 'addResultCols';					//添加内容性质
						var addY = 'Simple';						//查询性质
						InitIQpopupWindow(windowType,addX,addY);	//初始化“添加信息”弹出窗口，见eprIntegratedQuery.js文件
					}
				}
			]
		}
	]
});

//**********************************************构造 “查询方案设置” Panel  start
// add by 牛才才
var readCaseByUserID = new Ext.form.FormPanel({
	id: 'readCaseByUserID',
	title: '本用户',
	items:{},
	listeners: {
		'activate':function(){
			var queryType='readCaseByUserID';
			loadCaseName(queryType);
		}
	}
});
var readCaseByCtLocID = new Ext.form.FormPanel({
	id: 'readCaseByCtLocID',
	title: '本科室',
	items:{},
	listeners: {
		'activate':function(){
			var queryType='readCaseByCtLocID';
			loadCaseName(queryType);
		}
	}
});
var readCaseByGroupID = new Ext.form.FormPanel({
	id: 'readCaseByGroupID',
	title: '本安全组',
	items:{},
	listeners: {
		'activate':function(){
			var queryType='readCaseByGroupID';
			loadCaseName(queryType);
		}
	}
});
var queryCaseTabPanel = new Ext.TabPanel({
	id: "queryCaseTabPanel",
    activeTab: 0,
	height: 2,   //IE6和IE8中显示有区别，6中此Panel下面多一空白条，好像有默认的"height:20"的配置项，加上此配置项后，设置值的大小，将空白降到最低，6和8中均可视为正常显示。
	deferredRender: false,
    autoTabs: true,
	autoScroll: true,
	items:[
		readCaseByUserID
		,readCaseByCtLocID
		,readCaseByGroupID
		]
});
var putinText = new Ext.form.TextField({
	id: 'putinText',
	fieldLabel: '方案名称',
	width: 218,
	isFormField: false,
	emptyText: '请输入方案名称'
});

var putinTextPanel = new Ext.Panel({
	id: 'putinTextPanel',
	name: 'putinTextPanel',
	bodyStyle: 'width:99%',
	width: 258,
	height: 28,
	frame: true,
	items: [
		putinText
		]
});

var btnQuery = new Ext.Button({
	id: 'btnQuery',
	cls: 'x-btn-text-icon',
	icon: '../scripts/epr/Pics/btnSearch.gif',
	minWidth: 50,
	text: '查询',
	handler: function(){
		var queryType = Ext.getCmp('queryCaseTabPanel').getActiveTab().getId();
		loadCaseName(queryType);
	}
});
var btnQueryPanel = new Ext.Panel({
	id: 'btnQueryPanel',
	name: 'btnQueryPanel',
	width: 70,
	height: 2,  //IE6和IE8中显示有区别，6中此Panel下面多一空白条，好像有默认的"height:20"的配置项的显示效果，加上此配置项后，设置值的大小，将空白降到最低，6和8中均可视为正常显示。
	buttonAlign : 'center',
	items: {},
	buttons: [
		btnQuery
		]
});

var queryPanel = new Ext.Panel({
	id: 'queryPanel',
	layout: 'column',
	width: 346,
	height: 41,
	frame: true,
	items: [
		putinTextPanel
		,btnQueryPanel
		]
});
var btnRead = new Ext.Button({
	id: 'btnRead',
	name: 'btnRead',
	cls: 'x-btn-text-icon',
	icon: '../scripts/epr/Pics/upda.gif',
	minWidth: 50,
	text: '读取',
	handler: readQueryCase
});
var btnDelete = new Ext.Button({
	id: 'btnDelete',
	name: 'btnDelete',
	cls: 'x-btn-text-icon',
	icon: '../scripts/epr/Pics/btnClose.gif',
	minWidth: 50,
	text: '删除',
	handler: deleteQueryCase
});
var readCaseStore = new Ext.data.JsonStore({
	url: '../web.eprajax.query.getquerycase.cls',
	fields: ['ID','Desc','SaveUserID','SaveUserName']
	//baseParams: {action:'getCaseName', QueryAreaStr: 'userID^' + userID}
});
//readCaseStore.load({});
var ReadCaseGrid = new Ext.grid.GridPanel({
	id: 'ReadCaseGrid',
	frame: true,
	autoScroll: true,
	bodyStyle: 'width:99%',
	width: 346,
	height: 150,
	store: readCaseStore,
	columns: [
		new Ext.grid.RowNumberer(
		{
			header: '' ,
			width: 25 ,
			fixed: false,
			css : 'background:#EEEEEE;'
		}),
		{
			header: '方案名称' ,
			dataIndex: 'Desc',
			width: 188,
			sortable: true
		},
		{
			header: '保存人' ,
			dataIndex: 'SaveUserName',
			width: 70,
			sortable: true
		}
	],
	bbar:[
		'-',
		btnRead,
		'-','->','-',
		btnDelete,
		'-'
	],
	listeners: {
		'dblclick':function(){
			readQueryCase();
		}
	},
	stripeRows: true,
	viewConfig: { forceFit: false},
	loadMask: { msg: '数据正在加载中……' }
});

//**********************************************构造 “查询方案设置” Panel  end
var tpCondition = new Ext.TabPanel({
    id: "tpCondition",
    activeTab: 0,
    deferredRender: false,
	width: 373,
    //defaults: Ext.isIE?{}:{bodyStyle:'padding:10px'},  //质量部要求的统一修改UI时，应用EXT3.2.1.css后效果不好，故去掉  by niucaicai 2017-4-1
    items: [
		{
            id: "tabSimple",
            //layout: 'fit',
            title: '简单查询',
            border: false,
			frame: true,
            autoHeight: true,
            items: frmSimple
        },
		// 高级查询页签 ********************** start
        {
            id: "tabAdvanced",
            title: '高级查询',
            border: false,
            frame: true,
            autoHeight: true,
			listeners: {
					'activate':function(){
						var queryType = Ext.getCmp('queryCaseTabPanel').getActiveTab().getId();
						loadCaseName(queryType);
					}
				},
            items: [
                {
                    xtype: 'panel',
                    title: '定义条件设置',
                    header: true,
					width: 358,
					autoHeight: true,
                    frame: true,
                    //html: '<div id="divCondition" style="width:100%;height:100%;overflow:scroll;overflow-x:hidden;"><input type="hidden" id="hiddenAdvancedGUID" name="hiddenAdvancedGUID" /><table id="tblCondition"></table></div>',
					html: '<div id="divCondition" style="width:100%;overflow:hidden;overflow-x:hidden;"><input type="hidden" id="hiddenAdvancedGUID" name="hiddenAdvancedGUID" /><table id="tblCondition" style="width:100%"></table></div>',
                    tbar: [
						'-',
						{
							id: 'buttonSave',
							name: 'buttonSave',
							//disabled: true,
							cls: 'x-btn-text-icon',
							icon: '../scripts/epr/Pics/save.gif',                             // 添加此对属性时，IE6中显示的按钮下面多一条虚线，不美观 
							minWidth: 80,
							text: '保存新方案',
							handler: function (){
								//判断查询条件是否合法
								var table = Ext.get("tblCondition");
								var length = table.dom.rows.length;
								var rightCondition = true;
								var txtValue0 = Ext.get("txtValue0").getValue();
								var txtValue1 = Ext.get("txtValue1").getValue();
								if (txtValue0=='' || txtValue0=='请选择日期')
								{
									txtValue0='';
								}
								if (txtValue1=='' || txtValue1=='请选择日期')
								{
									txtValue1='';
								}
								if (length<=2 && txtValue0=='' && txtValue1 =='' )
								{
									rightCondition = false;
								}
								//判断是否有新添加的结果列
								var divAdvancedResultCols = Ext.get('divAdvancedResultCols');
								var items = Ext.fly("divAdvancedResultCols").select("input[type=checkbox]", true);
								var UnDisabledCount = 0;
								Ext.each(items.elements, function(item) {
									if (item.dom.checked) {
										if (!item.dom.disabled)
										{
											UnDisabledCount = UnDisabledCount + 1;
										}
									}
								});
								//若入院起始日期和入院结束日期同时为空并且无新增结果列，此方案视为无效，不允许保存！
								if (rightCondition==false && UnDisabledCount == 0)
								{
									alert("此方案为无效方案！请完善'查询条件' 或者 添加新的'结果列'！");
									return;
								}
								else{
									var windowType = 'SaveCaseAndReadCase';			                // 弹出窗口性质								                                      
									var addX = 'save';												// 保存/修改性质		
									var authorityInfo = userID + '^' + ctLocID + '^' + ssGroupID;   // 权限信息：用户ID,科室ID,安全组ID
									var addY = authorityInfo;
									InitIQpopupWindow(windowType,addX,addY);						//初始化“保存查询方案”弹出窗口，见eprIntegratedQuery.js文件
								}
							}
						},
						'-',
						{
							id: 'buttonModify',
							name: 'buttonModify',
							cls: 'x-btn-text-icon',
							icon: '../scripts/epr/Pics/btnReset.gif',
							minWidth: 80,
							text: '修改此方案',
							handler: function (){
								var tempDataNum = tempStore.getCount();
								if (tempDataNum==0)
								{
									alert("请先读取已有方案再修改！");
								}
								else{
									var SaveUserID = tempStore.getAt(0).get('SaveUserID');
									if (SaveUserID != userID )
									{
										alert("您不是该方案的保存者，无权修改此方案！");
									}
									else {
										var windowType = 'SaveCaseAndReadCase';
										var addX = 'modify';
										var authorityInfo = userID + '^' + ctLocID + '^' + ssGroupID;   // 权限信息：用户ID,科室ID,安全组ID
										var addY = authorityInfo;                              
										InitIQpopupWindow(windowType,addX,addY);						//初始化“修改查询方案”弹出窗口，见eprIntegratedQuery.js文件
									}
								}
							}
						},
						'->','-',
						{
                            id: 'btnTaskList',
                            name: 'btnTaskList',
                            text: '后台任务',
                            cls: 'x-btn-text-icon',
                            icon: '../scripts/epr/Pics/btnConfirm.gif',	
                            pressed: false,
                            handler: function() {
                                openTaskList();
                            }
                        }
					],
					bbar: [
                        {
                            id: 'btnAdvanceConReset',
                            name: 'btnAdvanceConReset',
                            text: '重置',
                            cls: 'x-btn-text-icon',
                            icon: '../scripts/epr/Pics/btnReset.gif',
                            pressed: false,
                            handler: function() {
                                initAdvancedConditons();
                                //return;
                            }
                        },
                        '-',
						{
                            id: 'btnAddTask',
                            name: 'btnAddTask',
                            text: '添加任务',
                            cls: 'x-btn-text-icon',
                            icon: '../scripts/epr/Pics/btnConfirm.gif',	
                            pressed: false,
                            handler: function() {
                                addTaskRecord();
                            }
                        },
                        '-',
						{
                            id: 'btnAddAdvanceCon',
                            name: 'btnAddAdvanceCon',
                            text: '添加查询条件',
                            cls: 'x-btn-text-icon',
                            icon: '../scripts/epr/Pics/btnConfirm.gif',								                                         
                            pressed: false,															                                         
							handler: function (){													                                             
								var windowType = 'ConditonsAndResultCols';			//弹出窗口性质	 
								var addX = 'addConditons';							//添加内容性质
								var addY = 'Advance';								//查询性质
								InitIQpopupWindow(windowType,addX,addY);			//初始化“添加信息”弹出窗口，见eprIntegratedQuery.js文件
							}
                        },
						'-',
                        {
                            id: 'btnAdvancedCommit',
                            name: 'btnAdvancedCommit',
                            text: '提交查询',
                            cls: 'x-btn-text-icon',
                            icon: '../scripts/epr/Pics/btnConfirm.gif',
                            pressed: false,
                            handler: function() {
                                commitAdvancedRequest();
                            }
                        }
                    ]
                },
				//****************************************** start
				// 保存/读取 查询方案面板      for #Bug1643
				// add by 牛才才
				{
					xtype: 'panel',
					id: 'CasePanel',
					width: 358,
                    autoHeight: true,
					title: '查询方案设置',
					buttonAlign : 'center',
                    frame: true,
					items: [
						queryCaseTabPanel
						,queryPanel
						,ReadCaseGrid
						]
				},
				//****************************************** end
                {
                    xtype: 'panel',
                    layout: 'fit',
                    title: '定义结果设置',
                    header: true,
					width: 358,
                    frame: true,
                    autoScroll: true,
                    html: '<div id="divAdvancedResultCols" clsss="divColumn"></div>',
                    bbar: [
                        {
                            id: 'btnAdvancedColReset',
                            name: 'btnAdvancedColReset',
                            text: '重置',
                            cls: 'x-btn-text-icon',
                            icon: '../scripts/epr/Pics/btnReset.gif',
                            pressed: false,
							handler: function (){
								divAdvancedResultColsReset();
								reConfigAdvancedGridCM();                  //添加完成后自动提交结果列
							}
                        }, '->', '-',
						{
                            id: 'btnAddAdvancedCol',
                            name: 'btnAddAdvancedCol',
                            text: '添加结果列',
                            cls: 'x-btn-text-icon',
                            icon: '../scripts/epr/Pics/btnConfirm.gif',
                            pressed: false,
							handler: function (){
								var windowType = 'ConditonsAndResultCols';
								var addX = 'addResultCols';
								var addY = 'Advance';
								InitIQpopupWindow(windowType,addX,addY);
							}
                        }
                    ]
                }
				
            ]
        }
		// 简单查询页签 ********************** end
    ]
});

//初始化结
//var guid = (trigger == 0)?Ext.getCmp('hiddenSimpleGUID').getValue():Ext.getCmp('hiddenAdvancedGUID').getValue();
var curColumnModel = AjaxReturn("../web.eprajax.query.basicsetting.cls", { Action: "getDefaultHISCM" }, "GET", false);
var curStoreFields = AjaxReturn("../web.eprajax.query.basicsetting.cls", { Action: "getStoreFields" }, "GET", false);
var cm = new Ext.grid.ColumnModel(curColumnModel);
var store = new Ext.data.JsonStore({
    //autoLoad: false,
    url: '../web.eprajax.query.basicquery.cls',
    fields: curStoreFields,
    root: 'data',
    totalProperty: 'TotalCount'
});
//Edit by Candyxu
var resultGrid = new Ext.grid.GridPanel({
    id: 'resultGrid',
    //layout: 'fit',
    frame: true,
    border: 'false',
    autoScroll: true,
    bodyStyle: 'width:99%',
    autoWidth: true,
    height: 200,
    title: '电子病历综合查询结果',
    store: store,
    cm: cm,
    stripeRows: true,
    viewConfig: { forceFit: false },
    loadMask: { msg: '数据正在加载中……' },
    tbar: [           
        "->", "-",
        {
            id: 'btnExport',
            name: 'btnExport',
            text: '导出当前数据到Excel',
            cls: 'x-btn-text-icon',
            icon: '../scripts/epr/Pics/xls.gif',
            pressed: false,
            handler: function() { doExport(resultGrid,1) }
        },'-',{
        	  id: 'btnExportAll',
        	  name: 'btnExportAll',
        	  text: '导出所有数据到Excel',
        	  cls: 'x-btn-text-icon',
        	  icon: '../scripts/epr/Pics/xlsBatch.gif',
        	  pressed: false,
        	  handler: function() { doExport(resultGrid,2) }
        	}
    ],
    bbar: new Ext.PagingToolbar({
        id: "pagingToolbar",
        store: store,
        pageSize: queryPageSize,
        displayInfo: true,
        displayMsg: '第 {0} 条到  {1} 条, 一共 {2} 条',
        beforePageText: '页码',
        afterPageText: '总页数 {0}',
        firstText: '首页',
        prevText: '上一页',
        nextText: '下一页',
        lastText: '末页',
        refreshText: '刷新',
        emptyMsg: "没有记录"
    })
});

resultGrid.on("rowcontextmenu", rightClickFn);

function rightClickFn(grid, rowindex, e) {
    //debugger;
    e.preventDefault();
    
    if (rowindex < 0) { return; }
    if (grid.store.data.items[rowindex].data["AdmType"] == "I") 
	{
		var menus = new Ext.menu.Menu({
			id: 'mnuContext',
			items: [
			{
				id: 'menuEPRBrowse',
				text: '病历浏览',
				pressed: true,
				icon: '../scripts/epr/Pics/browser.gif',
					//handler: function() { goEPRBrowse(grid, rowindex, e); }
					handler: function() { GetEPRorEMR(grid, rowindex, e, "Browse"); }
			}, {
				id: 'menuEPRWrite',
				text: '病历书写',
				pressed: true,
				icon: '../scripts/epr/Pics/eprwrite.gif',
					//handler: function() { goEPRWrite(grid, rowindex, e); }
					handler: function() { GetEPRorEMR(grid, rowindex, e, "Write"); }
			},
			{
				id: 'menuEPRPrint',
				text: '一键打印',
				pressed: true,
				icon: '../scripts/epr/Pics/print.gif',
					//handler: function() { goEPROnePrint(grid, rowindex, e); }
					handler: function() { GetEPRorEMR(grid, rowindex, e, "Print"); }
			},
			//add by yang 2012-10-24
			{
				id: 'menuEPRCentralizedPrint',
				text: '集中打印',
				pressed: true,
				icon: '../scripts/epr/Pics/print.gif',
					//handler: function() { goEPRCentralizedPrint(grid, rowindex, e); }
					handler: function() { GetEPRorEMR(grid, rowindex, e, "CentralizedPrint"); }
			}]
		});
	}
	else if (grid.store.data.items[rowindex].data["AdmType"] == "O") 
    {
	     var menus = new Ext.menu.Menu({
        id: 'mnuContext',
        items: [
        {
            id: 'menuEPRBrowse',
            text: '病历浏览',
            pressed: true,
            icon: '../scripts/epr/Pics/browser.gif',
            handler: function() { goEPRBrowse(grid, rowindex, e); }
        }/*, {
            id: 'menuEPRWrite',
            text: '病历书写',
            pressed: true,
            icon: '../scripts/epr/Pics/eprwrite.gif',
            handler: function() { goEPRWrite(grid, rowindex, e); }
        }
        ,
        {
            id: 'menuEPRPrint',
            text: '一键打印',
            pressed: true,
            icon: '../scripts/epr/Pics/print.gif',
            handler: function() { goEPROnePrint(grid, rowindex, e); }
		},
		//add by yang 2012-10-24
        {
            id: 'menuEPRCentralizedPrint',
            text: '集中打印',
            pressed: true,
            icon: '../scripts/epr/Pics/print.gif',
            handler: function() { goEPRCentralizedPrint(grid, rowindex, e); }
        }*/
        ]
    });
    menus.showAt(e.getPoint());
}}

var frmMainContent = new Ext.Viewport({
    id: 'vpEPRQuery',
    layout: 'border',
    shim: false,
    animCollapse: false,
    constrainHeader: true,
    collapsible: true,
    margins: '0 0 0 0',
    border: false,
    items: [{
        id: 'west',
        region: 'west',
        title: '电子病历综合查询条件设置',
		width: 402,
        split: true,
		autoScroll: true,
        collapsible: true,
		frame: true,
        items: tpCondition
    }, {
        id: 'center',
        region: 'center',
        layout: 'fit',
        //border: true,
        split: true,
        collapsible: true,
        items: resultGrid
    }]
});

//关闭时清空临时数据
window.onbeforeunload = function() {
    //debugger;
    if (window.screenLeft != 10008) {
        var simpleID = Ext.getCmp('hiddenSimpleGUID').getValue();
        var advancedID = Ext.get("hiddenAdvancedGUID").getValue();
        var guids = simpleID + "^" + advancedID;
        Ext.Ajax.request({
            url: '../web.eprajax.query.globalcleaner.cls',
            params: { GUIDs: guids },
            success: function(response, opts) {
                //debugger
            },
            failure: function(response, opts) {
                alert(response.responseText);
            }
        });
    }
}

//添加任务
function addTaskRecord()
{
	Ext.MessageBox.prompt('输入框','任务名称',function(btn,text){
		if(btn == "ok")
		{
			var arrAdvancedCondition = getAdvancedConditions("addTask");
			if (!arrAdvancedCondition[0]) 
			{
				 alert(arrAdvancedCondition[1]); 
				 return;
			}
			jQuery.ajax({
				type: "post",
				dataType: "json",
				url: '../web.eprajax.query.advancedquery.cls',
				async: true,
				data:{action: 'getGUID', hiddenGUID: ""},
				success: function(d) 
				{
					if (d.GUID != "")
					{
						var ReslutFields = getResultCMAndFields("divAdvancedResultCols");
						var advancedResultCols = ReslutFields[2];
						var queryType0 = "",queryType1 = "";
						queryType0 = document.getElementById("column0").value.split("^")[1];
						queryType1 = document.getElementById("column1").value.split("^")[1];
						if (queryType0 == queryType1)
						{
							queryType = queryType0;
							jQuery.ajax({
								type: "post",
								dataType: "text",
								url: "../EMRservice.Ajax.common.cls",
								async: true,
								data: {
									"OutputType":"",
									"Class":"EPRservice.BLL.Query.BLMedicalQueryTasklist",
									"Method":"InsertInfo",
									"p1":text,
									"p2":userID,
									"p3":userName,
									"p4":d.GUID,
									"p5":arrAdvancedCondition[2][0],
									"p6":taskConditions,
									"p7":advancedResultCols,
									"p8":queryType
								},
							});
							
							//创建任务时记录日志
							var resultColumnArr = advancedResultCols.split("&");
							var resColDesc = "";
							$.each(resultColumnArr,function(i,item)
							{
								var itemArr = item.split("^");
								resColDesc = resColDesc+"/"+itemArr[3];
							});	//获取结果列
							var url = "../web.eprajax.query.medicalquerytask.cls";
							if (queryType == "DischDate"){taskConditions = "出院日期"+taskConditions;}else{taskConditions = "入院日期"+taskConditions;}
							setQueryLog(url,"EMR.Query.Task.Create",queryType,taskConditions,resColDesc);
						}
						else
						{
							alert("条件需要成对出现！");
						}
					}
				},
				errot: function(){alert("getGUID ERROR!");}
			})
		}
	});
}

function openTaskList()
{
	window.showModalDialog("dhc.epr.query.tasklist.csp?UserId="+userID+"&UserName="+userName,"","dialogHeight:600px;dialogWidth:1200px;resizable:no;status:no");
}

//记录日志
function setQueryLog(url,actionType,dateType,conditions,resultCol)
{
	var ipAddress = getIpAddress();
	jQuery.ajax({
		type : "GET",
		dataType : "text",
		url : url,
		async : true,
		data : {
			"actionType":actionType,
			"userID":userID,
			"userName":userName,
			"ipAddress":ipAddress,			//当前ip
			"dateType":dateType,			//日期类型
			"conditions":conditions,		//条件描述
			"resultCol":resultCol			//结果列
		}
	});	
}