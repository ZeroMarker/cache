showCalcTypeTargetFun = function() {
	var CalcTypeTargetUrl = '../csp/dhc.bonus.calculatetypeexe.csp';
	// alert('showCalcTypeTargetFun')

	var CalculateTypeID = ""
	var empName = ""
	var CalculateTypeName =""
	var UnitID =""
	
	var rowObj = BonusEmployeeTab.getSelections();
	var len = rowObj.length;
	// 判断是否选择了要修改的数据
	if (len < 1) {
		Ext.Msg.show({
					title : '注意',
					msg : '请选择需要修改的数据!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return;
	} else {
		 CalculateTypeID = rowObj[0].get("CalculateTypeID");
		 empName = rowObj[0].get("BonusUnitName");
		 CalculateTypeName = rowObj[0].get("CalculateTypeName");
		 UnitID = rowObj[0].get("BonusUnitID");
	}
	//CalculateTypeID=1
	//alert('CalculateTypeID=' + CalculateTypeID)

	// 单击核算类别 刷新 相关指标

	// ---------------------
	var CalcTypeTargetProxy = new Ext.data.HttpProxy({
				url : CalcTypeTargetUrl + '?action=listUT&CalcTypeID='
						+ CalculateTypeID+'&UnitID='+UnitID
			});
	var CalcTypeTargetDs = new Ext.data.Store({
				proxy : CalcTypeTargetProxy,
				reader : new Ext.data.JsonReader({
							root : 'rows',
							totalProperty : 'results'
						}, ['rowid', 'svalue', 'targetID', 'targetName',
								'ctypeID', 'SchemeName', 'BonusSchemeID',
								'cTypeName']),
				// "rowid^svalue^targetID^targetName^ctypeID^cTypeName"
				remoteSort : true
			});
	CalcTypeTargetDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : CalcTypeTargetUrl
									+ '?action=listUT&CalcTypeID='
									+ CalculateTypeID+'&UnitID='+UnitID,
							method : 'POST'
						})
			})

	// 设置默认排序字段和排序方向
	CalcTypeTargetDs.setDefaultSort('rowid', 'targetName');

	// 数据库数据模型
	var CalcTypeTargetCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header : '奖金方案',
				dataIndex : 'SchemeName',
				width : 170,
				sortable : true
			}/*, {
				header : '核算类型',
				dataIndex : 'cTypeName',
				width : 120,
				sortable : true
			}*/, {
				header : '关联指标',
				dataIndex : 'targetName',
				width : 120,
				sortable : true
			}, {
				header : '指标标准',
				dataIndex : 'svalue',
				width : 80,
				sortable : true
			}

	]);

	// 初始化默认排序功能
	CalcTypeTargetCm.defaultSortable = true;

	// 初始化搜索字段
	var BonusItemTypeSearchField = 'cTypeName';

	// 分页工具栏
	var CalcTypeTargetPagingToobar = new Ext.PagingToolbar({

		store : CalcTypeTargetDs,
		pageSize : 25,
		displayInfo : true,
		displayMsg : '第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg : "没有记录" // ,
			// buttons : ['-', BonusItemTypeFilterItem, '-',
			// BonusItemTypeSearchBox]

		});

	// alert(CalculateTypeID)
	// 表格
	var CalcTypeTargetPanel = new Ext.grid.EditorGridPanel({
				title : '手术提成标准',
				region : 'center',
				width : 500,
				height : 450,
				store : CalcTypeTargetDs,
				cm : CalcTypeTargetCm,
				trackMouseOver : true,
				stripeRows : true,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				loadMask : true,
				// tbar : [addButtonT, '-', editButtonT, '-', delButtonT],
				bbar : CalcTypeTargetPagingToobar
			});

	// /------------------------

	// 定义并初始化面板
	var formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				labelWidth : 100,
				layout : 'fit',
				items : [CalcTypeTargetPanel]
			});

	// 面板加载
	formPanel.on('afterlayout', function(panel, layout) {
		this.getForm().loadRecord(rowObj[0]);
		CalcTypeTargetDs.load({
					params : {
						CalcTypeID : CalculateTypeID,
						UnitID : UnitID,
						start : 0,
						limit : CalcTypeTargetPagingToobar.pageSize
					}
				});
			// alert('aa')

		});
	CalcTypeTargetPanel.title="【"+empName+"】--【"+CalculateTypeName+"】"
	// 定义并初始化取消修改按钮
	var cancelButton = new Ext.Toolbar.Button({
				text : '关闭'
			});

	// 定义取消修改按钮的响应函数
	cancelHandler = function() {
		editwin.close();
	}

	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);
	// 定义并初始化窗口
	var editwin = new Ext.Window({
				title : '人员职称提成标准',
				width : 700,
				height : 530,
				minWidth : 400,
				minHeight : 250,
				layout : 'fit',
				plain : true,
				modal : true,
				bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]
			});
	// 窗口显示
	editwin.show();

}