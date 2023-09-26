function InitIQpopupWindow(windowType,addX,addY){
	
	// ���塰��Ӳ�ѯ�������͡���ӽ���С����������еļ��������� ********************** start
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
		emptyText: '��ѡ��������'
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
			Ext.get('divTree').dom.innerHTML = ""; //���֮ǰ����div
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

	//Desc: ��������������
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
			text: '��������',
			nodeType: 'async',
			draggable: false,
			id: "RT0"
		});

		tree.setRootNode(root);
		root.expand();
		return tree;
	}
	// ���塰��Ӳ�ѯ�������͡���ӽ���С����������еļ��������� ********************** end

	//********************************************** start
	// ������� ��ѯ����/����� ��������
	// add by ţ�Ų�
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
				header: '������Ŀ' ,
				dataIndex: 'Title',
				width: 562
			}
		]);
		// ��Ӹ߼���ѯ����
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
				loadMask: { msg: '�������ڼ����С���' },
				bbar: [
					'-','ÿҳ����',
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
						displayMsg: '�� {0} ����  {1} ��, һ�� {2} ��',
						beforePageText: 'ҳ��',
						afterPageText: '��ҳ�� {0}',
						firstText: '��ҳ',
						prevText: '��һҳ',
						nextText: '��һҳ',
						lastText: 'ĩҳ',
						refreshText: 'ˢ��',
						emptyMsg: "û�м�¼"
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
						text: '��Ӳ�ѯ����',
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
						text: 'ȡ��',
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
		// ��� �򵥲�ѯ���߼���ѯ �����
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
				loadMask: { msg: '�������ڼ����С���' },
				bbar: [
					'-','ÿҳ����',
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
						displayMsg: '�� {0} ����  {1} ��, һ�� {2} ��',
						beforePageText: 'ҳ��',
						afterPageText: '��ҳ�� {0}',
						firstText: '��ҳ',
						prevText: '��һҳ',
						nextText: '��һҳ',
						lastText: 'ĩҳ',
						refreshText: 'ˢ��',
						emptyMsg: "û�м�¼"
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
						text: '��ӽ����',
						cls: 'x-btn-text-icon',
						icon: '../scripts/epr/Pics/btnConfirm.gif',
						pressed: false,
						handler: function (){
							// ��� �߼���ѯ �����
							if (addY == 'Advance')
							{
								befaddAdvancedResultCols(eprIQaddGrid,eprIQaddWin);
							}
							// ��� �򵥲�ѯ �����
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
						text: 'ȡ��',
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
			,title: '�����Ϣ'
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
	// ���� ����/�޸Ĳ�ѯ���� ��������  
	// add by ţ�Ų�
	if (windowType == 'SaveCaseAndReadCase')
	{
		// ����/�޸� ��ѯ����
		if (addX == 'save' || addX == 'modify')
		{
			//************************************* ��ʾPanel start
			var label = new Ext.form.Label({
				id: 'label',
				name: 'label',
				text: 'ע�⣺�����в��ܰ��� ���� �� @,#,$,%,^,&,* �ȷ��ţ�'
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
			//************************************* ��ʾPanel end
			//************************************* ������������Panel start
			var caseNameField = new Ext.form.TextField({
				id: 'caseNameField',
				name: 'caseNameField',
				width: 400,
				fieldLabel: '��������',
                emptyText: '�����뷽������'
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
			//************************************* ������������Panel end
			//************************************* ���˿ɼ�Panel start
			
			var oneselfCR = new Ext.form.Checkbox({
				id: 'oneselfCR',
				name: 'oneselfCR',
				boxLabel: '���˿ɼ�',
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
			//************************************* ���˿ɼ�Panel end
			//**************************************************************** ���ҺͰ�ȫ�����
			//************************************* ѡ�����Panel start
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
						header: '��ѡ����' ,
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
						header: '�ɼ�����' ,
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
			//************************************* ѡ�����Panel end
			//************************************* ѡ��ȫ��Panel start
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
						header: '��ѡ��ȫ��',
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
						header: '�ɼ���ȫ��' ,
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
			
			//************************************* ѡ��ȫ��Panel end
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
			//************************************* ѡ����ҺͰ�ȫ��Panel end
			var caseTypePanel = new Ext.Panel({
				id: 'caseTypePanel',
				name: 'caseTypePanel',
				title: '�����ɼ���',
				width: 576,
				height: 350,
				frame: true,
				items: [
					oneselfCRPanel,
					CTLocAndGroupCRPanel
					]
			});
			//**************************************************************** �����ɼ���Panel end
			var btnOK = new Ext.Button({
				id: 'btnOK',
				name: 'btnOK',
				//cls: 'x-btn-text-icon',
				//icon: '../scripts/epr/Pics/save.gif',
				minWidth: 50,
				text: '����',
				handler: function (){
					if (addX == 'save')
					{
						buildQueryCase(caseSaveWin,'save');      // �����·���
					}
					else if (addX == 'modify')
					{
						buildQueryCase(caseSaveWin,'modify');    // �����޸ķ���
					}
				}
			});
			var btnCancel = new Ext.Button({
				id: 'btnCancel',
				name: 'btnCancel',
				//cls: 'x-btn-text-icon',
				//icon: '../scripts/epr/Pics/upda.gif',
				minWidth: 50,
				text: 'ȡ��',
				handler: function(){
					caseSaveWin.close();
				}
			});
			var caseSaveWin = new Ext.Window({
				id : 'caseSaveWin'
				,title: '���淽��'
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
			// ���Ǳ���Ϊ�µķ�����ֱ����ʾ����
			if (addX == 'save')
			{
				caseSaveWin.show();
			}
			// �����޸ĵ�ǰ��������ʾ���岢���ص�ǰ������Ϣ
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
							alert("�˷����Ѿ�ɾ���������޸ģ�����洢���뱣���·�����");
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