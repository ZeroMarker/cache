// 名称:供应商评价指标维护
// 编写日期:2016-06-13
var isSysIndexEdit=true;
var VenEvaIndexUrl = 'dhcstm.vendorevaluationindexaction.csp';

var SearchBT = new Ext.Toolbar.Button({
		id: "SearchBT",
		text: '查询',
		width: 70,
		height: 30,
		iconCls: 'page_find',
		handler: function () {
			VenEvaIndexGrid.load();
		}
	});

var addEvalIndex = new Ext.Toolbar.Button({
		text:'新建',
		tooltip:'新建',
		iconCls:'page_add',
		width : 70,
		height : 30,
		handler:function(){
			VenEvaIndexGrid.addNewRow();
		}
	});

var saveVenEvaIndex = new Ext.Toolbar.Button({
		text: '保存',
		tooltip: '保存',
		iconCls: 'page_save',
		width: 70,
		height: 30,
		handler: function () {
			if (VenEvaIndexGrid.activeEditor != null) {
				VenEvaIndexGrid.activeEditor.completeEdit();
			}
			var SumWeight = 0;
			var count = VenEvaIndexGrid.getCount();
			for (var index = 0; index < count; index++) {
				var rec = VenEvaIndexGrid.getAt(index);
				var Weight = Number(rec.data['Weight']);
				if (Weight == "" || Weight <= 0 || Weight > 1) {
					Msg.info("warning", "第" + (VenEvaIndexGrid.indexOf(rec) + 1) + "行权重必须大于0小于等于1!");
					return;
				}
				SumWeight = accAdd(SumWeight,Weight);
			}
			if (SumWeight != 1) {
				Msg.info("warning", "权重之和必须等于1!")
				return;
			}
			//获取所有的新记录
			var mr = VenEvaIndexGrid.getModifiedRecords();
			var data = "";
			for (var i = 0; i < mr.length; i++) {
				var rowid = mr[i].get("RowId");
				var code = mr[i].get("Code");
				var desc = mr[i].get("Desc");
				var weight = mr[i].get("Weight");
				var sysIndex = mr[i].get("SysIndex");
				var scoreEdited = mr[i].get("ScoreEdited");
				var CalculationRules = mr[i].get("CalculationRules");
				if (code != "" && desc != "" && weight != "") {
					var dataRow = rowid + "^" + code + "^" + desc + "^" + weight + "^" + sysIndex + "^" + scoreEdited + "^" + CalculationRules;
					if (data == "") {
						data = dataRow;
					} else {
						data = data + xRowDelim() + dataRow;
					}
				}
			}
			if (data == "") {
				Msg.info("warning", "没有修改或添加新数据!");
				return false;
			} else {
				Ext.Ajax.request({
					url: VenEvaIndexUrl + '?actiontype=save',
					params: {
						data: data
					},
					success: function (result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							Msg.info("success", "保存成功!");
							VenEvaIndexGrid.load();
						} else {
							Msg.info("error", "记录重复：" + jsonData.info);
							VenEvaIndexGrid.load();
						}
					},
					scope: this
				});
			}
		}
	});

var deleteVenEvaIndex = new Ext.Toolbar.Button({
		text: '删除',
		tooltip: '删除',
		iconCls: 'page_delete',
		width: 70,
		height: 30,
		handler: function () {
			var cell = VenEvaIndexGrid.getSelectionModel().getSelectedCell();
			if (cell == null) {
				Msg.info("warning", "请选择数据!");
				return false;
			} else {
				var record = VenEvaIndexGrid.getAt(cell[0]);
				var RowId = record.get("RowId");
				if (RowId != "") {
					Ext.MessageBox.confirm('提示', '确定要删除选定的行?',
						function (btn) {
						if (btn == 'yes') {
							Ext.Ajax.request({
								url: VenEvaIndexUrl + '?actiontype=delete&rowid=' + RowId,
								waitMsg: '删除中...',
								failure: function (result, request) {
									Msg.info("error", "请检查网络连接!");
								},
								success: function (result, request) {
									var jsonData = Ext.util.JSON.decode(result.responseText);
									if (jsonData.success == 'true') {
										Msg.info("success", "删除成功!");
										VenEvaIndexGrid.load();
									} else {
										Msg.info("error", "删除失败!");
									}
								},
								scope: this
							});
						}
					})
				} else {
					Msg.info("warning", "数据有误,没有RowId!");
				}
			}
		}
	});

var VenEvaIndexGridCm = [{
			header : 'RowId',
			dataIndex : 'RowId',
			hidden : true
		},{
			header: "代码",
			dataIndex: 'Code',
			width: 80,
			align: 'left',
			sortable: true,
			editor: new Ext.form.TextField({
				allowBlank: false,
				listeners: {
					specialKey: function (field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var col = GetColIndex(VenEvaIndexGrid, 'Desc');
							VenEvaIndexGrid.startEditing(VenEvaIndexGrid.getCount() - 1, col);
						}
					}
				}
			})
		}, {
			header: "名称",
			dataIndex: 'Desc',
			width: 150,
			align: 'left',
			sortable: true,
			editor: new Ext.form.TextField({
				allowBlank: false,
				listeners: {
					specialKey: function (field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var col = GetColIndex(VenEvaIndexGrid, 'Weight');
							VenEvaIndexGrid.startEditing(VenEvaIndexGrid.getCount() - 1, col);
						}
					}
				}
			})
		}, {
			header: "权重",
			dataIndex: 'Weight',
			width: 100,
			align: 'left',
			xtype: 'numbercolumn',
			format: '0.0000',
			sortable: true,
			editor: new Ext.form.NumberField({
				allowBlank: false,
				decimalPrecision: 4,
				listeners: {
					specialKey: function (field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var weight = field.getValue();
							if (weight == null || weight.length <= 0) {
								Msg.info("warning", "权重不能为空!");
								return;
							}
							if (weight <= 0) {
								Msg.info("warning", "权重不能小于等于0!");
								return;
							}
							if (weight > 1) {
								Msg.info("warning", "权重不能大于1!");
								return;
							}
							var col = GetColIndex(EvalReasonGrid, 'CalculationRules');
							EvalReasonGrid.startEditing(EvalReasonGrid.getCount() - 1, col);
							
						}
					}
				}
			})
		}, {
			header: '系统指标',
			dataIndex: 'SysIndex',
			align: 'center',
			width: 80,
			xtype: 'checkcolumn'
		}, {
			header: '是否可修改分数',
			dataIndex: 'ScoreEdited',
			align: 'center',
			width: 110,
			xtype: 'checkcolumn'
		}, {
			header: "计算规则",
			dataIndex: 'CalculationRules',
			width: 200,
			align: 'left',
			sortable: true,
			editor: new Ext.form.TextField({
				allowBlank: false,
				listeners: {
					specialKey: function (field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							VenEvaIndexGrid.addNewRow();
							
						}
					}
				}
			})
		}
	];

var VenEvaIndexGrid = new Ext.dhcstm.EditorGridPanel({
		id: 'VenEvaIndexGrid',
		title: '供应商评价指标维护',
		region: 'west',
		width : 650,
		tbar: [SearchBT,'-', addEvalIndex,'-', saveVenEvaIndex,"<font color=blue>注：权重需为大于0小于等于1的数</font>"],
		contentColumns: VenEvaIndexGridCm,
		actionUrl : VenEvaIndexUrl,
		queryAction : "selectAll",
		idProperty : "RowId",
		checkProperty : "Code",
		smType : "row",
		showTBar : false,
		childGrid : ["EvalReasonGrid"],
		smRowSelFn : VenEvaIndexRowSelFn
	});

var addEvalReason = new Ext.Toolbar.Button({
		text:'新建',
		tooltip:'新建',
		iconCls:'page_add',
		width : 70,
		height : 30,
		handler:function(){
			var record = VenEvaIndexGrid.getSelectionModel().getSelected();
			var rowId = record.get("RowId");
			if(rowId==null||rowId==""){
				Msg.info("warning", "请先保存评级指标!");
				return false;
			}
			EvalReasonGrid.addNewRow();
		}
	});

var SaveEvalReason = new Ext.Toolbar.Button({
		text: '保存',
		tooltip: '保存',
		iconCls: 'page_save',
		width: 70,
		height: 30,
		handler: function () {
			var record = VenEvaIndexGrid.getSelectionModel().getSelected();
			var VEIrowId = record.get("RowId");
			if(VEIrowId==null||VEIrowId==""){
				Msg.info("warning", "请先保存评级指标!");
				return false;
			}
			if (EvalReasonGrid.activeEditor != null) {
				EvalReasonGrid.activeEditor.completeEdit();
			}
			var SumWeight = 0;
			var count = EvalReasonGrid.getCount();
			for (var index = 0; index < count; index++) {
				var rec = EvalReasonGrid.getAt(index);
				var Weight = Number(rec.data['Weight']);
				if (Weight == "" || Weight <= 0 || Weight > 1) {
					Msg.info("warning", "第" + (EvalReasonGrid.indexOf(rec) + 1) + "行权重必须大于0小于等于1!");
					return;
				}
				SumWeight = accAdd(SumWeight, Weight);
			}
			if (SumWeight != 1) {
				Msg.info("warning", "权重之和必须等于1!")
				return;
			}
			//获取所有的新记录
			var mr = EvalReasonGrid.getModifiedRecords();
			var data = "";
			for (var i = 0; i < mr.length; i++) {
				var rowid = mr[i].get("RowId");
				var code = mr[i].get("Code");
				var desc = mr[i].get("Desc");
				var weight = mr[i].get("Weight");
				if (code != "" && desc != "" && weight != "") {
					var dataRow = rowid + "^" + code + "^" + desc + "^" + weight;
					if (data == "") {
						data = dataRow;
					} else {
						data = data + xRowDelim() + dataRow;
					}
				}
			}
			if (data == "") {
				Msg.info("warning", "没有修改或添加新数据!");
				return false;
			} else {
				Ext.Ajax.request({
					url: VenEvaIndexUrl + '?actiontype=saveEvalReason',
					params: {
						rowid: VEIrowId,
						data: data
					},
					success: function (result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							Msg.info("success", "保存成功!");
							EvalReasonGrid.load({params:{rowid:VEIrowId}});
						} else {
							Msg.info("error", "记录重复：" + jsonData.info);
							EvalReasonGrid.load({params:{rowid:VEIrowId}});
						}
					},
					scope: this
				});
			}
		}
	});

var EvalReasonGridCm = [{
			header : 'RowId',
			dataIndex : 'RowId',
			hidden : true
		},{
			header: "代码",
			dataIndex: 'Code',
			width: 80,
			align: 'left',
			sortable: true,
			editor: new Ext.form.TextField({
				allowBlank: false,
				listeners: {
					specialKey: function (field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var col = GetColIndex(EvalReasonGrid, 'Desc');
							EvalReasonGrid.startEditing(EvalReasonGrid.getCount() - 1, col);
						}
					}
				}
			})
		}, {
			header: "描述",
			dataIndex: 'Desc',
			width: 150,
			align: 'left',
			sortable: true,
			editor: new Ext.form.TextField({
				allowBlank: false,
				listeners: {
					specialKey: function (field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var col = GetColIndex(EvalReasonGrid, 'Weight');
							EvalReasonGrid.startEditing(EvalReasonGrid.getCount() - 1, col);
						}
					}
				}
			})
		}, {
			header: "权重",
			dataIndex: 'Weight',
			width: 100,
			align: 'left',
			xtype: 'numbercolumn',
			format: '0.0000',
			sortable: true,
			editor: new Ext.form.NumberField({
				allowBlank: false,
				decimalPrecision: 4,
				listeners: {
					specialKey: function (field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var weight = field.getValue();
							if (weight == null || weight.length <= 0) {
								Msg.info("warning", "权重不能为空!");
								return;
							}
							if (weight <= 0) {
								Msg.info("warning", "权重不能小于等于0!");
								return;
							}
							if (weight > 1) {
								Msg.info("warning", "权重不能大于1!");
								return;
							}
							EvalReasonGrid.addNewRow();
						}
					}
				}
			})
		}
	];

var EvalReasonGrid = new Ext.dhcstm.EditorGridPanel({
		id : 'EvalReasonGrid',
		title : '扣分项',
		region : 'center',
		contentColumns : EvalReasonGridCm,
		actionUrl : VenEvaIndexUrl,
		queryAction : "GetEvalReason",
		idProperty : "RowId",
		checkProperty : "Code",
		showTBar : false,
		tbar : [addEvalReason,SaveEvalReason,"<font color=blue>注：权重需为大于0小于等于1的数</font>"]
	});

function VenEvaIndexRowSelFn(grid,rowIndex,r){
	var rowid = r.get('RowId');
	EvalReasonGrid.load({params:{rowid:rowid}});
}
//===========模块主页面===============================================
Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
			layout: 'border',
			items: [VenEvaIndexGrid,EvalReasonGrid],
			renderTo: 'mainPanel'
		});
	SearchBT.handler();
});
//===========模块主页面===============================================
