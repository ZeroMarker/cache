/**
 * 不可退药原因维护
 */
function addNewRow() {
	var record = Ext.data.Record.create([{
		name: 'RowId',
		type: 'int'
	}, {
		name: 'Desc',
		type: 'string'
	}]);

	var NewRecord = new record({
		RowId: '',
		Desc: ''
	});

	IncReasonForRefRetGridDs.add(NewRecord);
	IncReasonForRefRetGrid.startEditing(IncReasonForRefRetGridDs.getCount() - 1, 1);
}

var IncReasonForRefRetGrid = "";
//配置数据源
var IncReasonForRefRetGridUrl = 'dhcst.increasonforrefretaction.csp';
var IncReasonForRefRetGridProxy = new Ext.data.HttpProxy({
	url: IncReasonForRefRetGridUrl + '?actiontype=query',
	method: 'GET'
});
var IncReasonForRefRetGridDs = new Ext.data.Store({
	proxy: IncReasonForRefRetGridProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results',
		pageSize: 35
	}, [{
			name: 'RowId'
		},
		{
			name: 'Desc'
		}
	]),
	remoteSort: false,
	pruneModifiedRecords: true
});

//模型
var IncReasonForRefRetGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: "名称",
		dataIndex: 'Desc',
		width: 300,
		align: 'left',
		sortable: true,
		editor: new Ext.form.TextField({
			id: 'descField',
			allowBlank: false,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						addNewRow();
					}
				}
			}
		})
	}
]);

//初始化默认排序功能
IncReasonForRefRetGridCm.defaultSortable = true;
var addIncReasonForRefRet = new Ext.Toolbar.Button({
	text: '新建',
	tooltip: '新建',
	iconCls: 'page_add',
	width: 70,
	height: 30,
	handler: function () {
		addNewRow();
	}
});

var saveIncReasonForRefRet = new Ext.Toolbar.Button({
	text: '保存',
	tooltip: '保存',
	iconCls: 'page_save',
	width: 70,
	height: 30,
	handler: function () {
		//获取所有的新记录 
		var mr = IncReasonForRefRetGridDs.getModifiedRecords();
		var data = "";
		for (var i = 0; i < mr.length; i++) {
			var rowId = mr[i].data["RowId"];
			var desc = mr[i].data["Desc"].trim();
			var rowNum = IncReasonForRefRetGridDs.indexOf(mr[i]) + 1;
			if (desc == "") {
				Msg.info("warning", "第" + rowNum + "行名称为空!");
				return;
			}
			if (desc != "") {
				var dataRow = rowId + "^" + desc;
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
			var mask = ShowLoadMask(Ext.getBody(), "处理中请稍候...");
			Ext.Ajax.request({
				url: IncReasonForRefRetGridUrl + '?actiontype=save',
				params: {
					data: data
				},
				failure: function (result, request) {
					mask.hide();
					Msg.info("error", "请检查网络连接!");
					IncReasonForRefRetGridDs.commitChanges();
				},
				success: function (result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					mask.hide();
					if (jsonData.success == 'true') {
						Msg.info("success", "保存成功!");
					} else {
						if (jsonData.info == -2) {
							Msg.info("warning", "名称重复!");
						} else {
							Msg.info("warning", "保存失败!");
						}
					}
					IncReasonForRefRetGridDs.commitChanges();
					IncReasonForRefRetGridDs.load();
				},
				scope: this
			});
		}
	}
});


var deleteIncReasonForRefRet = new Ext.Toolbar.Button({
	text: '删除',
	tooltip: '删除',
	iconCls: 'page_delete',
	width: 70,
	height: 30,
	handler: function () {
		var cell = IncReasonForRefRetGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", "请选择数据!");
			return false;
		} else {
			var record = IncReasonForRefRetGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if (RowId != "") {
				Ext.MessageBox.confirm('提示', '确定要删除选定的行?',
					function (btn) {
						if (btn == 'yes') {
							var mask = ShowLoadMask(Ext.getBody(), "处理中请稍候...");
							Ext.Ajax.request({
								url: IncReasonForRefRetGridUrl + '?actiontype=delete&rowid=' + RowId,
								waitMsg: '删除中...',
								failure: function (result, request) {
									mask.hide();
									Msg.info("error", "请检查网络连接!");
								},
								success: function (result, request) {
									var jsonData = Ext.util.JSON.decode(result.responseText);
									mask.hide();
									if (jsonData.success == 'true') {
										Msg.info("success", "删除成功!");
										IncReasonForRefRetGridDs.remove(record);
										IncReasonForRefRetGrid.getView().refresh();
									} else {
										if (jsonData.info == "-2") {
											Msg.info("warning", "该原因已被使用,无法删除!");
										} else {
											Msg.info("error", "删除失败!");
										}
									}
								},
								scope: this
							});
						}
					}
				)
			} else {
				IncReasonForRefRetGridDs.remove(record);
				IncReasonForRefRetGrid.getView().refresh();
			}
		}
	}
});

//表格
IncReasonForRefRetGrid = new Ext.grid.EditorGridPanel({
	store: IncReasonForRefRetGridDs,
	cm: IncReasonForRefRetGridCm,
	trackMouseOver: true,
	region: 'center',
	height: 690,
	stripeRows: true,
	sm: new Ext.grid.CellSelectionModel({}),
	loadMask: true,
	tbar: [addIncReasonForRefRet, '-', saveIncReasonForRefRet, '-', deleteIncReasonForRefRet],
	clicksToEdit: 1
});

IncReasonForRefRetGridDs.load();

var HospPanel = InitHospCombo('DHC_StkRefuseRetReason',function(combo, record, index){
	HospId = this.value; 
	IncReasonForRefRetGridDs.reload();
});

//===========模块主页面=============================================
Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var panel = new Ext.Panel({
		title: '不可退药原因',
		activeTab: 0,
		region: 'center',
		items: [IncReasonForRefRetGrid]
	});

	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items: [HospPanel,panel],
		renderTo: 'mainPanel'
	});
});
//===========模块主页面=============================================