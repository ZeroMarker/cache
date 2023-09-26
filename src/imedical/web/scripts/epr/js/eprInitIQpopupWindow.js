function InitIQpopupWindow(windowType,addX,addY){
	
	// 定义“添加查询条件”和“添加结果列”弹出窗口中的检索大类树 ********************** start
	var cbxScope = new Ext.form.ComboBox({
		id: 'cbxScope',
		name: 'cbxScope',
		readOnly: true,
		resizable: false,
		listWidth: 539,
		mode: 'local',
		store: new Ext.data.SimpleStore({ fields: [], data: [[]] }),
		tpl: '<tpl for="."><div id="divSTree" style="height: 600px;"><div id="divTree"></div></div></tpl>',
		hiddenName: 'AdvancedCategoryCode',
		displayField: 'Name',
		valueField: 'Code',
		triggerAction: 'all',
		editable: false,
		emptyText: '请选择检索类别'
	});
	var scopePanel = new Ext.Panel({
		id: 'scopePanel',
		region: 'north',
		height: 35,
		layout: 'fit',
		frame:true,
		items: [
			cbxScope
		]
	});
	Ext.getCmp('cbxScope').on('Expand', function() {
		if (!Ext.getCmp('divTree')) {
			Ext.get('divTree').dom.innerHTML = ""; //清空之前树的div
			getCategoryTree().render('divTree');
		}
	});

	function getCategoryTree() {
		var ThisTree = createTree();
		ThisTree.on('click', function(node, event) {
			SelectedNode = node;
			Ext.getCmp('cbxScope').setValue(SelectedNode.text);
			Ext.getCmp('cbxScope').collapse();
			this.fireEvent('treeselected', node);
		});

		ThisTree.on('treeselected', function(node, event) {
			CategoryID = node.id;
			store.load({params: {start: 0, limit: PageToolbarPageSize}});
		});
		return ThisTree;
	}

	//Desc: 创建检索大类树
	function createTree() {
		var Tree = Ext.tree;
		var treeLoader = new Tree.TreeLoader({ dataUrl: "../web.eprajax.query.basicsetting.cls?Action=getCategoryTree" });
		var tree = new Tree.TreePanel({
			//width:600,
			//height: 600 ,
			autoWidth: true,
			autoHeight: true,
			id: "categoryTree",
			rootVisible: false,
			autoScroll: true,
			animate: false,
			containerScroll: true,
			lines: true,
			checkModel: 'cascade',
			autoHeight: true,
			border: false,
			loader: treeLoader
		});

		var root = new Tree.AsyncTreeNode({
			text: '检索分类',
			nodeType: 'async',
			draggable: false,
			id: "RT0"
		});

		tree.setRootNode(root);
		root.expand();
		return tree;
	}
	// 定义“添加查询条件”和“添加结果列”弹出窗口中的检索大类树 ********************** end

	//********************************************** start
	// 定义添加 查询条件/结果列 弹出窗口
	// add by 牛才才
	if (windowType == 'ConditonsAndResultCols')
	{
		var store = new Ext.data.JsonStore({
			autoLoad: false,
			url: '../web.eprajax.query.basicsetting.cls',
			root: 'data',
			totalProperty: 'totalCount',
			fields: ['Code' ,'Title'],
			listeners: {
				'beforeload': function() {
					store.baseParams = {Action:'getCategoryItems',CategoryID:CategoryID};
				}
			}
		});
		var sm = new Ext.grid.CheckboxSelectionModel({handleMouseDown: Ext.emptyFn});
		var addColsCM = new Ext.grid.ColumnModel([
			sm
			,{
				header: '检索项目' ,
				dataIndex: 'Title',
				width: 562
			}
		]);
		// 添加高级查询条件
		if (addX == 'addConditons')
		{
			var eprIQaddGrid = new Ext.grid.EditorGridPanel({
				id: 'eprIQaddResultColsGrid',
				frame: true,
				region: 'center',
				autoScroll: true,
				bodyStyle: 'width:99%',
				height: 410,
				store: store,
				cm: addColsCM,
				sm: sm,
				stripeRows: true,
				viewConfig: { forceFit: false },
				loadMask: { msg: '数据正在加载中……' },
				bbar: [
					'-','每页条数',
					{
						id:'pageSizeComboBox',
						width:51,
						resizable: false,
						xtype :'combo',
						valueField:'returnValue',
						displayField:'displayText',
						readOnly: true,
						listWidth: 30,
						triggerAction : 'all', 
						mode: 'local',
						value: PageToolbarPageSize,
						store: new Ext.data.SimpleStore({
							fields:['returnValue','displayText'],
							data:[['10','10'],['15','15'],['20','20'],['25','25'],['30','30'],['50','50']]
						}),
						listeners: {
							'select': function() {
								PageToolbarPageSize = Ext.getCmp("pageSizeComboBox").getValue();
								Ext.getCmp("eprPagingToolbar").pageSize = PageToolbarPageSize;
								store.removeAll();
								store.load({params: {start: 0, limit: PageToolbarPageSize}});
							}
						}
					}
					,'-','->',
					new Ext.PagingToolbar({
						id: "eprPagingToolbar",
						width: 490,
						store: store,
						pageSize: PageToolbarPageSize,
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
				]
				,listeners: {
					'render': function(){
							ConditonsBbar2.render(this.bbar);
					}
				}
			});
			var ConditonsBbar2 = new Ext.Toolbar({
				id: 'ConditonsBbar2',
				autoWidth: true,
				items: [
					'-',
					{
						id: 'btnAddConditons',
						name: 'btnAddConditons',
						text: '添加查询条件',
						cls: 'x-btn-text-icon',
						icon: '../scripts/epr/Pics/btnConfirm.gif',
						pressed: false,
						handler: function (){
							befaddAdvancedConditions(eprIQaddGrid,eprIQaddWin);
						}
					},
					'-','->', '-',
					{
						id: 'btnCancel',
						name: 'btnCancel',
						text: '取消',
						cls: 'x-btn-text-icon',
						icon: '../scripts/epr/Pics/btnClose.gif',
						pressed: false,
						handler: function() {
							CategoryID = "-1";
							PageToolbarPageSize = 15;
							eprIQaddWin.close();
						}
					},'-'
				]
			});
		}
		// 添加 简单查询、高级查询 结果列
		if (addX == 'addResultCols')
		{
			var eprIQaddGrid = new Ext.grid.EditorGridPanel({
				id: 'eprIQaddResultColsGrid',
				frame: true,
				region: 'center',
				autoScroll: true,
				bodyStyle: 'width:99%',
				height: 410,
				store: store,
				cm: addColsCM,
				sm: sm,
				stripeRows: true,
				viewConfig: { forceFit: false },
				loadMask: { msg: '数据正在加载中……' },
				bbar: [
					'-','每页条数',
					{
						id:'pageSizeComboBox',
						width:51,
						resizable: false,
						xtype :'combo',
						valueField:'returnValue',
						displayField:'displayText',
						readOnly: true,
						listWidth: 30,
						triggerAction : 'all', 
						mode: 'local',
						value: PageToolbarPageSize,
						store: new Ext.data.SimpleStore({
							fields:['returnValue','displayText'],
							data:[['10','10'],['15','15'],['20','20'],['25','25'],['30','30'],['50','50']]
						}),
						listeners: {
							'select': function() {
								PageToolbarPageSize = Ext.getCmp("pageSizeComboBox").getValue();
								Ext.getCmp("eprPagingToolbar").pageSize = PageToolbarPageSize;
								store.removeAll();
								store.load({params: {start: 0, limit: PageToolbarPageSize}});
							}
						}
					}
					,'-','->',
					new Ext.PagingToolbar({
						id: "eprPagingToolbar",
						width: 490,
						store: store,
						pageSize: PageToolbarPageSize,
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
				]
				,listeners: {
					'render': function(){
							ResultColsBbar2.render(this.bbar);
					}
				}
			});
			var ResultColsBbar2 = new Ext.Toolbar({
				id: 'ResultColsBbar2',
				autoWidth: true,
				items: [
					'-',
					{
						id: 'btnAddResultCol',
						name: 'btnAddResultCol',
						text: '添加结果列',
						cls: 'x-btn-text-icon',
						icon: '../scripts/epr/Pics/btnConfirm.gif',
						pressed: false,
						handler: function (){
							// 添加 高级查询 结果列
							if (addY == 'Advance')
							{
								befaddAdvancedResultCols(eprIQaddGrid,eprIQaddWin);
							}
							// 添加 简单查询 结果列
							if (addY == 'Simple')
							{
								befaddSimpleResultCols(eprIQaddGrid,eprIQaddWin);
							}
						}
					},
					'-','->', '-',
					{
						id: 'btnCancel',
						name: 'btnCancel',
						text: '取消',
						cls: 'x-btn-text-icon',
						icon: '../scripts/epr/Pics/btnClose.gif',
						pressed: false,
						handler: function() {
							CategoryID = "-1";
							PageToolbarPageSize = 15;
							eprIQaddWin.close();
						}
					},'-'
				]
			});
		}
		var eprIQaddWin = new Ext.Window({
			id : 'eprIQaddResultColsWin'
			,title: '添加信息'
			,height : 485
			,buttonAlign : 'center'
			,width : 629
			,layout : 'border'
			,modal: true
			,maximizable: true
			,items:[
				scopePanel,
				eprIQaddGrid
			]
		});
		eprIQaddWin.show();
	}
	//********************************************** end


	//********************************************** start
	// 定义 保存/修改查询方案 弹出窗口  
	// add by 牛才才
	if (windowType == 'SaveCaseAndReadCase')
	{
		// 保存/修改 查询方案
		if (addX == 'save' || addX == 'modify')
		{
			//************************************* 提示Panel start
			var label = new Ext.form.Label({
				id: 'label',
				name: 'label',
				text: '注意：名字中不能包含 逗号 及 @,#,$,%,^,&,* 等符号！'
			});
			var tipsPanel = new Ext.Panel({
				id: 'tipsPanel',
				name: 'tipsPanel',
				lableWidth: 60,
				labelAlign: 'right',
				frame: true,
				items: [
					label
					]
			});
			//************************************* 提示Panel end
			//************************************* 方案名称输入Panel start
			var caseNameField = new Ext.form.TextField({
				id: 'caseNameField',
				name: 'caseNameField',
				width: 400,
				fieldLabel: '方案名称',
                emptyText: '请输入方案名称'
			});
			var caseNamePanel = new Ext.Panel({
				id: 'caseNamePanel',
				name: 'caseNamePanel',
				layout: 'form',
				lableWidth: 60,
				labelAlign: 'right',
				frame: true,
				items: [
					caseNameField
					]
			});
			//************************************* 方案名称输入Panel end
			//************************************* 个人可见Panel start
			
			var oneselfCR = new Ext.form.Checkbox({
				id: 'oneselfCR',
				name: 'oneselfCR',
				boxLabel: '个人可见',
				checked: true,
				disabled: true
			});
			var oneselfCRPanel = new Ext.Panel({
				id: 'oneselfCRPanel',
				name: 'oneselfCRPanel',
				width: 564,
				height: 30,
				layout: 'table',
				isFormField: true,
				frame: true,
				items: [
					oneselfCR
					]
			});
			//************************************* 个人可见Panel end
			//**************************************************************** 科室和安全组面板
			//************************************* 选择科室Panel start
			var CTLocGrid = new Ext.grid.GridPanel({
				id: 'CTLocGrid',
				autoScroll: true,
				bodyStyle: 'width:99%',
				columnWidth: .425,
				height: 270,
				store: new Ext.data.JsonStore({
					autoload: true,
					url: '../web.eprajax.hisinterface.hospitalinfo.cls?Action=getLocs',
					fields: ['ID', 'Name']
				}),
				columns: [
					{
						header: '待选科室' ,
						dataIndex: 'Name',
						width: 150,
						sortable: true
					}
				],
				stripeRows: true
			});
			CTLocGrid.store.load({});
			var addCtLocBtn = new Ext.Button({
				id: 'addCtLocBtn',
				name: 'addCtLocBtn',
				cls: 'x-btn-text-icon',
				icon: '../scripts/epr/Pics/pagedownbrowser.gif'
			});
			addCtLocBtn.on("click", addCtLocBtnClick);
			var buttonInCTLocCRTopPanel = new Ext.Panel({
				id: 'buttonInCTLocCRTopPanel',
				name: 'buttonInCTLocCRTopPanel',
				height: 105,
				buttonAlign: 'center',
				buttons: [
					addCtLocBtn
					]
			});
			var deleteCtLocBtn = new Ext.Button({
				id: 'deleteCtLocBtn',
				name: 'deleteCtLocBtn',
				cls: 'x-btn-text-icon',
				icon: '../scripts/epr/Pics/pageupbrowser.gif'
			});
			deleteCtLocBtn.on("click", deleteCtLocBtnClick);
			var buttonInCTLocCRBottomPanel = new Ext.Panel({
				id: 'buttonInCTLocCRBottomPanel',
				name: 'buttonInCTLocCRBottomPanel',
				height: 105,
				buttonAlign: 'center',
				buttons: [
					deleteCtLocBtn
					]
			});
			var CTLocButtonsPanel = new Ext.Panel({
				id: 'CTLocButtonsPanel',
				name: 'CTLocButtonsPanel',
				height: 270,
				columnWidth: .15,
				layout: 'form',
				items: [
					buttonInCTLocCRTopPanel,
					buttonInCTLocCRBottomPanel
					]
			});
			var CTLocCRPanelGrid = new Ext.grid.GridPanel({
				id: 'CTLocCRPanelGrid',
				autoScroll: true,
				bodyStyle: 'width:99%',
				columnWidth: .425,
				height: 270,
				store: new Ext.data.JsonStore({
					url: '../web.eprajax.query.getquerycase.cls',
					fields: ['ID', 'Name']
				}),
				columns: [
					{
						header: '可见科室' ,
						dataIndex: 'Name',
						width: 150,
						sortable: true
					}
				],
				stripeRows: true
			});
			
			var CTLocCRPanel = new Ext.Panel({
				id: 'CTLocCRPanel',
				name: 'CTLocCRPanel',
				height: 283,
				columnWidth: .5,
				layout: 'column',
				frame: true,
				items: [
					CTLocGrid,
					CTLocButtonsPanel,
					CTLocCRPanelGrid
					]
			});
			//************************************* 选择科室Panel end
			//************************************* 选择安全组Panel start
			var GroupGrid = new Ext.grid.GridPanel({
				id: 'GroupGrid',
				autoScroll: true,
				bodyStyle: 'width:99%',
				columnWidth: .425,
				height: 270,
				store: new Ext.data.JsonStore({
					url: '../web.eprajax.query.getquerycase.cls?action=getAllSSGroup',
					fields: ['ID', 'Desc']
				}),
				columns: [
					{
						header: '待选安全组',
						dataIndex: 'Desc',
						width: 150,
						sortable: true
					}
				],
				stripeRows: true
			});
			GroupGrid.store.load({});
			var addGroupBtn = new Ext.Button({
				id: 'addGroupBtn',
				name: 'addGroupBtn',
				cls: 'x-btn-text-icon',
				icon: '../scripts/epr/Pics/pagedownbrowser.gif'
			});
			addGroupBtn.on("click", addGroupBtnClick);
			var buttonInGroupCRTopPanel = new Ext.Panel({
				id: 'buttonInGroupCRTopPanel',
				name: 'buttonInGroupCRTopPanel',
				height: 105,
				buttonAlign: 'center',
				buttons: [
					addGroupBtn
					]
			});
			var deleteGroupBtn = new Ext.Button({
				id: 'deleteGroupBtn',
				name: 'deleteGroupBtn',
				cls: 'x-btn-text-icon',
				icon: '../scripts/epr/Pics/pageupbrowser.gif'
			});
			deleteGroupBtn.on("click", deleteGroupBtnClick);
			var buttonInGroupCRBottomPanel = new Ext.Panel({
				id: 'buttonInGroupCRBottomPanel',
				name: 'buttonInGroupCRBottomPanel',
				height: 105,
				buttonAlign: 'center',
				buttons: [
					deleteGroupBtn
					]
			});
			var GroupButtonsPanel = new Ext.Panel({
				id: 'GroupButtonsPanel',
				name: 'GroupButtonsPanel',
				height: 270,
				columnWidth: .15,
				layout: 'form',
				items: [
					buttonInGroupCRTopPanel,
					buttonInGroupCRBottomPanel
					]
			});
			var GroupCRPanelGrid = new Ext.grid.GridPanel({
				id: 'GroupCRPanelGrid',
				autoScroll: true,
				bodyStyle: 'width:99%',
				columnWidth: .425,
				height: 270,
				store: new Ext.data.JsonStore({
					url: '../web.eprajax.query.getquerycase.cls',
					fields: ['ID', 'Desc']
				}),
				columns: [
					{
						header: '可见安全组' ,
						dataIndex: 'Desc',
						width: 150,
						sortable: true
					}
				],
				stripeRows: true
			});
			var GroupCRPanel = new Ext.Panel({
				id: 'GroupCRPanel',
				name: 'GroupCRPanel',
				height: 283,
				columnWidth: .5,
				layout: 'column',
				frame: true,
				items: [
					GroupGrid,
					GroupButtonsPanel,
					GroupCRPanelGrid
					]
			});
			
			//************************************* 选择安全组Panel end
			var CTLocAndGroupCRPanel = new Ext.Panel({
				id: 'CTLocAndGroupCRPanel',
				name: 'CTLocAndGroupCRPanel',
				width: 564,
				height: 284,
				layout: 'column',
				items: [
					CTLocCRPanel,
					GroupCRPanel
				]
			});
			//************************************* 选择科室和安全组Panel end
			var caseTypePanel = new Ext.Panel({
				id: 'caseTypePanel',
				name: 'caseTypePanel',
				title: '方案可见性',
				width: 576,
				height: 350,
				frame: true,
				items: [
					oneselfCRPanel,
					CTLocAndGroupCRPanel
					]
			});
			//**************************************************************** 方案可见性Panel end
			var btnOK = new Ext.Button({
				id: 'btnOK',
				name: 'btnOK',
				//cls: 'x-btn-text-icon',
				//icon: '../scripts/epr/Pics/save.gif',
				minWidth: 50,
				text: '保存',
				handler: function (){
					if (addX == 'save')
					{
						buildQueryCase(caseSaveWin,'save');      // 保存新方案
					}
					else if (addX == 'modify')
					{
						buildQueryCase(caseSaveWin,'modify');    // 保存修改方案
					}
				}
			});
			var btnCancel = new Ext.Button({
				id: 'btnCancel',
				name: 'btnCancel',
				//cls: 'x-btn-text-icon',
				//icon: '../scripts/epr/Pics/upda.gif',
				minWidth: 50,
				text: '取消',
				handler: function(){
					caseSaveWin.close();
				}
			});
			var caseSaveWin = new Ext.Window({
				id : 'caseSaveWin'
				,title: '保存方案'
				,height : 483
				,lableWidth: 60
				,labelAlign: 'right'
				,buttonAlign : 'center'
				,width : 590
				,layout : 'form'
				,modal: true
				,frame: true
				,resizable:false
				,items: [
					tipsPanel,
					caseNamePanel,
					caseTypePanel
					]
				,buttons: [
					btnOK,
					btnCancel
					]
			});
			// 若是保存为新的方案，直接显示窗体
			if (addX == 'save')
			{
				caseSaveWin.show();
			}
			// 若是修改当前方案，显示窗体并加载当前方案信息
			else if (addX == 'modify')
			{
				var caseID = tempStore.getAt(0).get('ID');
				Ext.Ajax.request({
					url: '../web.eprajax.query.getquerycase.cls',
					params: { action: 'checkCaseID',CaseID:caseID},
					success: function(response, options){
						var ret = response.responseText;
						if (ret == 0)
						{
							alert("此方案已经删除，不能修改！若想存储，请保存新方案！");
						}
						else if (ret == 1)
						{
							var caseDesc = tempStore.getAt(0).get('Desc');
							caseSaveWin.show();
							caseNameField.setRawValue(caseDesc);
							CTLocCRPanelGrid.store.load( {params: {action:'getCTLocByCaseID',CaseID:caseID} });
							GroupCRPanelGrid.store.load( {params: {action:'getGroupByCaseID',CaseID:caseID} });
						}
					}
				});
			}
		}
		
	}
	//********************************************** end
}