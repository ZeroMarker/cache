var schemUrl = '../csp/dhc.bonus.impempinfoexe.csp';
var schemProxy = new Ext.data.HttpProxy({
			url : schemUrl + '?action=Mlist'
		});
var userCode = session['LOGON.USERCODE'];
var periodStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue']
		});

var data = "";
var StratagemTabUrl = '../csp/dhc.bonus.deptbonuscalcexe.csp';

// 奖金核算主表数据源
var schemDs = new Ext.data.Store({
			proxy : schemProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['rowid', 'ImpTitle', 'ImpFileDesc', 'ImpUserCode',
							'ImpDatetime', 'ImpFlag', 'FileTypeName',
							'OnloadFileID']),
			remoteSort : true
		});

schemDs.setDefaultSort('rowid', 'desc');

var fileTypeDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

fileTypeDs.on('beforeload', function(ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
		url : '../csp/dhc.bonus.bonustargetcollectexe.csp?action=fileType&userCode='
				+ session['LOGON.USERCODE'],
		method : 'POST'
	})
});
// ----------------------------------------
var fileTypeField = new Ext.form.ComboBox({
			id : 'fileTypeField',
			fieldLabel : '文件类别',
			allowBlank : false,
			store : fileTypeDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'fileTypeField',
			minChars : 1,
			anchor : '90%',
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});

var startDate = new Ext.form.DateField({
			id : 'startDate',
			fieldLabel : '开始时间',
			allowBlank : false,
			dateFormat : 'Y-m-d',
			// valueNotFoundText : rowObj[0].get("startDate"),
			emptyText : '',
			anchor : '90%',
			isteners : {
				specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (start1Date.getValue() != "") {
							endDate.focus();
						} else {
							Handler = function() {
								start1Date.focus();
							}
							Ext.Msg.show({
										title : '错误',
										msg : '开始时间为空!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR,
										fn : Handler
									});
						}
					}
				}
			}
		});
var endDate = new Ext.form.DateField({
			id : 'endDate',
			fieldLabel : '结束时间',
			allowBlank : false,
			// valueNotFoundText : rowObj[0].get("endDate"),
			dateFormat : 'Y-m-d',
			emptyText : '',
			anchor : '90%'
		});

// --FileTypeName ImpTitle ImpFileDesc ImpUserCode ImpDatetime ImpFlag

var schemCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
			header : '导入数据ID',
			dataIndex : 'rowid',
			width : 40,
			hidden : true,
			sortable : true
		}, {
			header : '文件标题',
			dataIndex : 'ImpTitle',
			width : 100,
			sortable : true
		}, {
			header : "文件描述",
			dataIndex : 'ImpFileDesc',
			width : 150,
			align : 'left',
			sortable : true
		}, {
			header : "文件类型",
			dataIndex : 'FileTypeName',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "操作人员",
			dataIndex : 'ImpUserCode',
			width : 60,
			align : 'left',
			sortable : true
		}, {
			header : "导入时间",
			dataIndex : 'ImpDatetime',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			header : "数据状态",
			dataIndex : 'ImpFlag',
			width : 70,
			align : 'center',
			sortable : true

		}]);

// 奖金方案核算
var BonusCalcButton = new Ext.Toolbar.Button({
			text : '查 询',
			tooltip : '查 询',
			iconCls : 'add',
			handler : function() {
				// schemeCalc(SchemGrid, schemDs);
				var enddr = ""
				var startdr = ""
				if (startDate.getValue() != "") {
					startdr = startDate.getValue().format('Y-m-d');
				}
				if (endDate.getValue() != "") {
					enddr = endDate.getValue().format('Y-m-d');
				}

				schemDs.load({
							params : {
								fileTypeID : Ext.getCmp('fileTypeField').getValue(),
								sDate : startdr,
								userCode : session['LOGON.USERCODE'],
								eDate : enddr,
								start : 0,
								limit : schemPagingToolbar.pageSize
							}
						});
			}
		});

// 奖金方案审核
var BonusAuditingButton = new Ext.Toolbar.Button({
			text : '数据上传',
			tooltip : '数据上传',
			iconCls : 'add',
			handler : function() {
				upImpEmp(SchemGrid, schemDs);
			}
		});
// 导入人员下发奖金
var uploadButton = new Ext.Toolbar.Button({
			text : '导入人员信息',
			tooltip : '导入数据(Excel格式)',
			iconCls : 'add',
			handler : function() {

				importExcel();

				return;

			}

		});


// 奖金方案发放
var BonusPayButton = new Ext.Toolbar.Button({
			text : '奖金发放',
			tooltip : '奖金发放',
			iconCls : 'add',
			handler : function() {
				// editJXUnitFun(SchemGrid, bonusItemDs,
				// bonusitemgrid,jxUnitPagingToolbar);
				schemePay(SchemGrid, schemDs);
			}
		});

var schemPagingToolbar = new Ext.PagingToolbar({// 分页工具栏
	pageSize : 25,
	store : schemDs,
	displayInfo : true,
	displayMsg : '当前显示{0} - {1}，共计{2}',
	emptyMsg : "没有数据",
	doLoad : function(C) {
		var B = {}, A = this.paramNames;
		B[A.start] = C;
		B[A.limit] = this.pageSize;
		B['period'] = Ext.getCmp('periodTypeField').getValue();
		B['dir'] = "asc";
		B['sort'] = "rowid";
		if (this.fireEvent("beforechange", this, B) !== false) {
			this.store.load({
						params : B
					});
		}
	}
});

var SchemGrid = new Ext.grid.GridPanel({// 表格
	title : '人员数据导入',
	region : 'north',
	height : 210,
	minSize : 350,
	maxSize : 450,
	split : true,
	collapsible : true,
	containerScroll : true,
	xtype : 'grid',
	store : schemDs,
	cm : schemCm,
	trackMouseOver : true,
	stripeRows : true,
	sm : new Ext.grid.RowSelectionModel({
				singleSelect : true
			}),
	loadMask : true,
	viewConfig : {
		forceFit : true
	},
	tbar : ['文件类型:', fileTypeField, '开始日期:', startDate, '-', '结束日期:', endDate, '-',
			BonusCalcButton, '-', uploadButton, '-', BonusAuditingButton],
	bbar : schemPagingToolbar
});
// ,'-',uploadButton DownButton
// ------组件事件加载-----begin-----------------


var schemRowId = "";
var schemName = "";

// 单击奖金核算方案后刷新 核算单元奖金项
SchemGrid.on('rowclick', function(grid, rowIndex, e) {
			showBonusDetail(grid, rowIndex, e)
		});
// 奖金方案主表
schemDs.on("beforeload", function(ds) {
			bonusItemDs.removeAll();
			schemRowId = "";
			bonusitemgrid.setTitle("人员数据导入明细");
		});

var tmpStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : ''
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}),
			remoteSort : true
		});

// ----------------函数处理------------------------------------
// 显示奖金核算明细
function showBonusDetail(grid, rowIndex, e) {

	var selectedRow = schemDs.data.items[rowIndex];
	var schemName = "";
	schemRowId = selectedRow.data["rowid"];
	schemName = selectedRow.data["ImpTitle"];
	schemCode = selectedRow.data["BonusSchemeCode"];
	ImpUnitMainID = selectedRow.data["rowid"];
	OnloadFileID = selectedRow.data["OnloadFileID"];

	// var str=schemRowId+":"+schemCode+":"+schemName

	//sbonusYear = Ext.getCmp('periodYear').getValue(), sbonusPeriod = Ext.getCmp('periodField').getValue(),

	bonusitemgrid.setTitle("[" + schemName + "]的数据明细");
	Ext.Ajax.request({
		url : '../csp/dhc.bonus.impempinfoexe.csp?action=getTitleInfo&OnloadFileID='
				+ OnloadFileID,
		waitMsg : '正在查询中...',
		failure : function(result, request) {
			Ext.Msg.show({
						title : '错误',
						msg : '请检查网络连接!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
		},
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);

			var cmItems = [];
			var cmConfig = {};
			// cmItems.push(sm);
			cmItems.push(new Ext.grid.RowNumberer());

			var cmConfig = {};
			var jsonHeadNum = jsonData.results;
			var jsonHeadList = jsonData.rows;
			var tmpDataMapping = [];

			for (var i = 0; i < jsonHeadList.length; i++) {
				cmConfig = {
					header : jsonHeadList[i].title,
					dataIndex : jsonHeadList[i].IndexName,
					width : 95,
					sortable : true,
					align : 'left',
					editor : new Ext.form.TextField({
								allowBlank : true
							})
				};

				cmItems.push(cmConfig);
				tmpDataMapping.push(jsonHeadList[i].IndexName);
			}

			// 提取奖金项数据
			var tmpColumnModel = new Ext.grid.ColumnModel(cmItems);
			// return false tmpDataMapping

			tmpStore.proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.impempinfoexe.csp?action=ImpEmpDetail&ImpUnitMainID='
						+ ImpUnitMainID,
				method : 'POST'
			})

			tmpStore.reader = new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, tmpDataMapping);

			bonusitemgrid.reconfigure(tmpStore, tmpColumnModel);
			tmpStore.load({
						params : {
							start : 0,
							limit : jxUnitPagingToolbar.pageSize
						}
					});
			jxUnitPagingToolbar.bind(tmpStore);
		},
		scope : this
	});

}

// 奖金方案审核
function upImpEmp(SchemGrid, schemDs) {

	var rowObj = SchemGrid.getSelections();
	var len = rowObj.length;
	if (len < 1) {
		Ext.Msg.show({
					title : '注意',
					msg : '请选择需要上传的数据!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return false;
	}

	var rowid = rowObj[0].get("rowid")
	var isCalc = rowObj[0].get("rowid")
	var IsAuditing = rowObj[0].get("ImpFlag")

	if (IsAuditing == '已上传') {
		Ext.Msg.show({
					title : '注意',
					msg : '该数据已经上传!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return false;
	}

	Ext.MessageBox.confirm('提示', '确要上传该数据吗?', Auditing);

	function Auditing(id) {

		if (id == 'yes') {

			Ext.Ajax.request({
						url : schemUrl + '?action=upImpEmp&rowid=' + rowid,

						failure : function(result, request) {
							Ext.Msg.show({
										title : '错误',
										msg : '请检查网络连接!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						},
						success : function(result, request) {
							var rtn = result.responseText;
							if (rtn == 0) {
								Ext.Msg.show({
											title : '注意',
											msg : '数据上传成功!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO
										});
								var enddr = ""
								var startdr = ""
								if (startDate.getValue() != "") {
									startdr = startDate.getValue()
											.format('Y-m-d');
								}
								if (endDate.getValue() != "") {
									enddr = endDate.getValue().format('Y-m-d');
								}

								schemDs.load({
											params : {
												fileTypeID : Ext
														.getCmp('fileTypeField')
														.getValue(),
												sDate : startdr,
												userCode : session['LOGON.USERCODE'],
												eDate : enddr,
												start : 0,
												limit : schemPagingToolbar.pageSize
											}
										});

								window.close();
							} else {
								var message = "";
								message = "奖金方案审核失败！";
								Ext.Msg.show({
											title : '错误',
											msg : message,
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							}
						},
						scope : this
					});

		}
	}

}
