// /名称: 实盘：录入方式一（根据帐盘数据按批次填充实盘数）
// /描述:  实盘：录入方式一（根据帐盘数据按批次填充实盘数）
// /编写者：zhangdongmei
// /编写日期: 2012.08.30
Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrDetailParams = '';
	var url = DictUrl + 'instktkaction.csp';
	var logonLocId = session['LOGON.CTLOCID'];
	var logonUserId = session['LOGON.USERID'];

	var LocManaGrp = new Ext.form.ComboBox({
			fieldLabel: '管理组',
			id: 'LocManaGrp',
			name: 'LocManaGrp',
			anchor: '90%',
			width: 140,
			store: LocManGrpStore,
			valueField: 'RowId',
			displayField: 'Description',
			allowBlank: true,
			triggerAction: 'all',
			emptyText: '管理组...',
			selectOnFocus: true,
			forceSelection: true,
			minChars: 1,
			pageSize: 20,
			listWidth: 250,
			valueNotFoundText: '',
			listeners: {
				'expand': function (combox) {
					LocManGrpStore.removeAll();
					LocManGrpStore.load({
						params: {
							start: 0,
							limit: 20,
							locId: gLocId
						}
					});
				}
			}
		});

	var PhaWindow = new Ext.form.ComboBox({
			fieldLabel: '实盘窗口',
			id: 'PhaWindow',
			name: 'PhaWindow',
			anchor: '90%',
			store: INStkTkWindowStore,
			valueField: 'RowId',
			displayField: 'Description',
			disabled: true,
			allowBlank: true,
			triggerAction: 'all',
			emptyText: '实盘窗口...',
			listeners: {
				'beforequery': function (e) {
					this.store.removeAll();
					this.store.setBaseParam('LocId', gLocId);
					this.store.load({
						params: {
							start: 0,
							limit: 99
						}
					});
				}
			}
		});
	INStkTkWindowStore.load({
		params: {
			start: 0,
			limit: 99,
			'LocId': gLocId
		},
		callback: function () {
			Ext.getCmp("PhaWindow").setValue(gInstwWin);
		}
	});

	var StkGrpType = new Ext.ux.StkGrpComboBox({
			id: 'StkGrpType',
			name: 'StkGrpType',
			StkType: App_StkTypeCode,
			LocId: logonLocId,
			UserId: logonUserId,
			anchor: '90%',
			width: 140
		});

	var DHCStkCatGroup = new Ext.form.ComboBox({
			fieldLabel: '库存分类',
			id: 'DHCStkCatGroup',
			name: 'DHCStkCatGroup',
			anchor: '90%',
			width: 140,
			listWidth: 180,
			store: StkCatStore,
			valueField: 'RowId',
			displayField: 'Description',
			allowBlank: true,
			typeAhead: false,
			selectOnFocus: true,
			forceSelection: true,
			minChars: 1,
			valueNotFoundText: '',
			pageSize: 20,
			listeners: {
				'beforequery': function (e) {
					var stkgrpid = Ext.getCmp("StkGrpType").getValue();
					StkCatStore.removeAll();
					StkCatStore.load({
						params: {
							StkGrpId: stkgrpid,
							start: 0,
							limit: 20
						}
					});

				}
			}
		});

	var InciDesc = new Ext.form.TextField({
			fieldLabel: '物资名称',
			id: 'InciDesc',
			name: 'InciDesc',
			anchor: '90%',
			width: 140,
			listeners: {
				specialkey: function (field, e) {
					var keyCode = e.getKey();
					if (keyCode == Ext.EventObject.ENTER) {
						var stkgrp = Ext.getCmp("StkGrpType").getValue();
						GetPhaOrderInfo(field.getValue(), stkgrp);
					}
				}
			}
		});

	/**
	 * 调用物资窗体并返回结果
	 */
	function GetPhaOrderInfo(item, stkgrp) {
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, stkgrp, App_StkTypeCode, "", "N", "0", "", getDrugList);
		}
	}
	/**
	 * 返回方法
	 */
	function getDrugList(record) {
		if (record == null || record == "") {
			return;
		}
		gIncId = record.get("InciDr");
		var inciCode = record.get("InciCode");
		var inciDesc = record.get("InciDesc");
		Ext.getCmp("InciDesc").setValue(inciDesc);

		QueryDetail();
	}

	var StkBin = new Ext.form.ComboBox({
			fieldLabel: '货位',
			id: 'StkBin',
			name: 'StkBin',
			anchor: '90%',
			width: 140,
			store: LocStkBinStore,
			valueField: 'RowId',
			displayField: 'Description',
			allowBlank: true,
			triggerAction: 'all',
			selectOnFocus: true,
			forceSelection: true,
			minChars: 1,
			pageSize: 20,
			listWidth: 250,
			valueNotFoundText: '',
			enableKeyEvents: true,
			listeners: {
				'beforequery': function (e) {
					LocStkBinStore.removeAll();
					LocStkBinStore.setBaseParam('LocId', gLocId);
					LocStkBinStore.setBaseParam('Desc', this.getRawValue());
					LocStkBinStore.load({
						params: {
							start: 0,
							limit: 20
						}
					});
				}
			}
		});

	//盘点单号
	var InstNo = new Ext.form.TextField({
			id: 'InstNo',
			name: 'InstNo',
			fieldLabel: '盘点单号',
			anchor: '90%',
			width: 140,
			disabled: true
		});

	// 查询按钮
	var SearchBT = new Ext.Toolbar.Button({
			text: '查询',
			tooltip: '点击查询',
			iconCls: 'page_find',
			width: 70,
			height: 30,
			handler: function () {
				QueryDetail();
			}
		});

	//设置未填数等于帐盘数
	var SetDefaultBT2 = new Ext.Toolbar.Button({
			text: '设置未填数等于帐盘数',
			tooltip: '点击设置未填数等于帐盘数',
			iconCls: 'page_edit',
			width: 70,
			height: 30,
			handler: function () {
				var ss = Ext.Msg.show({
						title: '提示',
						msg: '设置未填实盘数等于帐盘数将修改此盘点单所有未录入的记录，是否继续？',
						buttons: Ext.Msg.YESNO,
						fn: function (b, t, o) {
							if (b == 'yes') {
								SetDefaultQty(2);
							}
						},
						icon: Ext.MessageBox.QUESTION
					});
			}
		});

	//设置未填数等于0
	var SetDefaultBT = new Ext.Toolbar.Button({
			text: '设置未填数等于0',
			tooltip: '点击设置未填数等于0',
			iconCls: 'page_edit',
			width: 70,
			height: 30,
			handler: function () {
				var ss = Ext.Msg.show({
						title: '提示',
						msg: '设置未填实盘数等于0将修改此盘点单所有未录入的记录，是否继续？',
						buttons: Ext.Msg.YESNO,
						fn: function (b, t, o) {
							if (b == 'yes') {
								SetDefaultQty(1);
							}
						},
						icon: Ext.MessageBox.QUESTION
					});
			}
		});

	//设置未填实盘数
	function SetDefaultQty(flag) {
		if (gRowid == '') {
			Msg.info('Warning', '没有选中的盘点单！');
			return;
		}
		var InstwWin = Ext.getCmp("PhaWindow").getValue();
		var UserId = session['LOGON.USERID'];
		var mask = ShowLoadMask(Ext.getBody(), "处理中请稍候...");
		Ext.Ajax.request({
			url: url,
			params: {
				actiontype: 'SetDefaultQty',
				Inst: gRowid,
				UserId: UserId,
				Flag: flag,
				InstwWin: InstwWin
			},
			method: 'post',
			waitMsg: '处理中...',
			success: function (response, opt) {
				var jsonData = Ext.util.JSON.decode(response.responseText);
				mask.hide();
				if (jsonData.success == 'true') {
					Msg.info('success', '成功!');
					QueryDetail();
				} else {
					var ret = jsonData.info;
					Msg.info('error', '设置未填记录实盘数失败:' + ret);

				}
			}
		});
	}

	// 清空按钮
	var RefreshBT = new Ext.Toolbar.Button({
			text: '清空',
			tooltip: '点击清空',
			iconCls: 'page_clearscreen',
			width: 70,
			height: 30,
			handler: function () {
				clearData();
			}
		});

	/**
	 * 清空方法
	 */
	function clearData() {

		Ext.getCmp("DHCStkCatGroup").setValue('');
		Ext.getCmp("StkBin").setValue('');
		//Ext.getCmp("Complete").setValue(false);
		Ext.getCmp("StkGrpType").setValue('');
		Ext.getCmp("PhaWindow").setValue('');
		Ext.getCmp("LocManaGrp").setValue('');
		Ext.getCmp("InciDesc").setValue('');
		InstDetailGrid.store.removeAll();
		InstDetailGrid.getView().refresh();
	}

	var SaveBT = new Ext.Toolbar.Button({
			text: '保存',
			tooltip: '点击保存',
			iconCls: 'page_save',
			width: 70,
			height: 30,
			handler: function () {
				save();
			}
		});

	//保存实盘数据
	function save() {
		if (InstDetailGrid.activeEditor != null) {
			InstDetailGrid.activeEditor.completeEdit();
		}
		var rowCount = InstDetailStore.getCount();
		var ListDetail = '';
		for (var i = 0; i < rowCount; i++) {
			var rowData = InstDetailStore.getAt(i);
			//新增或修改过的数据
			if (rowData.dirty || rowData.data.newRecord) {
				var Parref = rowData.get('insti');
				var Rowid = rowData.get('instw');
				var UserId = session['LOGON.USERID'];
				var CountQty = rowData.get('countQty');
				if (CountQty == "") {
					CountQty = 0;
				}
				var CountUomId = rowData.get('uom');
				var StkBin = '';
				var PhaWin = Ext.getCmp('PhaWindow').getValue();
				var Detail = Parref + '^' + Rowid + '^' + UserId + '^' + CountQty + '^' + CountUomId + '^' + StkBin + '^' + PhaWin;
				if (ListDetail == '') {
					ListDetail = Detail;
				} else {
					ListDetail = ListDetail + xRowDelim() + Detail;
				}
			}
		}
		if (ListDetail == '') {
			Msg.info('Warning', '没有需要保存的数据!');
			return;
		}
		var mask = ShowLoadMask(Ext.getBody(), "处理中请稍候...");
		Ext.Ajax.request({
			url: url,
			params: {
				actiontype: 'SaveTkItmWd',
				Params: ListDetail
			},
			method: 'post',
			waitMsg: '处理中...',
			success: function (response, opt) {
				var jsonData = Ext.util.JSON.decode(response.responseText);
				mask.hide();
				if (jsonData.success == 'true') {
					Msg.info('success', '保存成功!');
					QueryDetail();
				} else {
					var ret = jsonData.info;
					if (ret == '-1') {
						Msg.info('warning', '没有需要保存的数据!');
					} else if (ret == '-2') {
						Msg.info('error', '保存失败!');
					} else {
						Msg.info('error', '部分数据保存失败:' + ret);
					}
				}
			}
		});
	}

	//根据帐盘数据插入实盘列表
	function create(inst, instwWin) {
		if (inst == null || inst == '') {
			Msg.info('warning', '请选择盘点单');
			return;
		}
		var UserId = session['LOGON.USERID'];
		var mask = ShowLoadMask(Ext.getBody(), "处理中请稍候...");
		Ext.Ajax.request({
			url: url,
			params: {
				actiontype: 'CreateTkItmWd',
				Inst: inst,
				UserId: UserId,
				InstwWin: instwWin
			},
			waitMsg: '处理中...',
			success: function (response, opt) {
				var jsonData = Ext.util.JSON.decode(response.responseText);
				mask.hide();
				if (jsonData.success == 'true') {
					Select(); //查询盘点单主表信息
				} else {
					var ret = jsonData.info;
					Msg.info("error", "提取实盘列表失败：" + ret);
				}
			}
		});
	}

	//查找盘点单及明细信息
	function QueryDetail() {

		//查询盘点单明细
		var StkGrpId = Ext.getCmp('StkGrpType').getValue();
		var StkCatId = Ext.getCmp('DHCStkCatGroup').getValue();
		var StkBinId = Ext.getCmp('StkBin').getValue();
		var PhaWinId = Ext.getCmp('PhaWindow').getValue();
		var ManaGrpId = Ext.getCmp('LocManaGrp').getValue();
		var InciDesc = Ext.getCmp('InciDesc').getValue();
		var size = StatuTabPagingToolbar.pageSize;

		gStrDetailParams = gRowid + '^' + ManaGrpId + '^' + StkGrpId + '^' + StkCatId + '^' + StkBinId + '^' + PhaWinId + '^' + InciDesc;
		InstDetailStore.removeAll();
		InstDetailStore.setBaseParam('sort', 'stkbin');
		InstDetailStore.setBaseParam('dir', 'ASC');
		InstDetailStore.setBaseParam('Params', gStrDetailParams);
		InstDetailStore.setBaseParam('start', 0);
		InstDetailStore.setBaseParam('limit', size);
		InstDetailStore.setBaseParam('actiontype', 'INStkTkItmWd');
		InstDetailStore.load();
	}

	function Select() {
		if (gRowid == null || gRowid == "") {
			return;
		}
		var mask = ShowLoadMask(Ext.getBody(), "处理中请稍候...");
		Ext.Ajax.request({
			url: url,
			params: {
				actiontype: 'Select',
				Rowid: gRowid
			},
			method: 'post',
			success: function (response, opt) {
				var jsonData = Ext.util.JSON.decode(response.responseText);
				mask.hide();
				if (jsonData.success == 'true') {
					var info = jsonData.info;
					if (info != "") {
						var detail = info.split("^");
						var InstNo = detail[0];
						var StkGrpId = detail[17];
						var StkGrpDesc = detail[24];
						var StkCatId = detail[18];
						var StkCatDesc = detail[19];
						var StkGrpDesc = detail[28];
						Ext.getCmp("InstNo").setValue(InstNo);
						addComboData(null, StkGrpId, StkGrpDesc, StkGrpType);
						Ext.getCmp("StkGrpType").setValue(StkGrpId);
						addComboData(StkCatStore, StkCatId, StkCatDesc);
						Ext.getCmp("DHCStkCatGroup").setValue(StkCatId);
					}
					QueryDetail(); //查询明细信息
				}
			}

		});
	}

	var nm = new Ext.grid.RowNumberer();
	var InstDetailGridCm = new Ext.grid.ColumnModel([nm, {
					header: "rowid",
					dataIndex: 'instw',
					width: 80,
					align: 'left',
					sortable: true,
					hidden: true
				}, {
					header: "parref",
					dataIndex: 'insti',
					width: 80,
					align: 'left',
					sortable: true,
					hidden: true
				}, {
					header: "inclb",
					dataIndex: 'inclb',
					width: 80,
					align: 'left',
					sortable: true,
					hidden: true
				}, {
					header: '代码',
					dataIndex: 'code',
					width: 80,
					align: 'left',
					sortable: true
				}, {
					header: "名称",
					dataIndex: 'desc',
					width: 200,
					align: 'left',
					sortable: true
				}, {
					header: "规格",
					dataIndex: 'spec',
					width: 80,
					align: 'left',
					sortable: true
				}, {
					header: '批号',
					dataIndex: 'batNo',
					width: 80,
					align: 'left',
					sortable: true
				}, {
					header: '效期',
					dataIndex: 'expDate',
					width: 100,
					align: 'left',
					sortable: true
				}, {
					header: "单位",
					dataIndex: 'uomDesc',
					width: 60,
					align: 'left',
					sortable: true
				}, {
					header: '冻结数量',
					dataIndex: 'freQty',
					width: 80,
					align: 'right',
					sortable: true
				}, {
					header: '实盘数量',
					dataIndex: 'countQty',
					width: 80,
					align: 'right',
					sortable: true,
					editor: new Ext.form.NumberField({
						selectOnFocus: true,
						allowNegative: false
					})
				}, {
					header: "货位码",
					dataIndex: 'stkbin',
					width: 100,
					align: 'left',
					sortable: true
				}, {
					header: "厂商",
					dataIndex: 'manf',
					width: 100,
					align: 'left',
					sortable: true
				}, {
					header: '实盘日期',
					dataIndex: 'countDate',
					width: 80,
					align: 'left',
					sortable: true
				}, {
					header: "实盘时间",
					dataIndex: 'countTime',
					width: 80,
					align: 'left',
					sortable: true
				}, {
					header: '实盘人',
					dataIndex: 'userName',
					width: 80,
					align: 'left',
					sortable: true
				}
			]);
	InstDetailGridCm.defaultSortable = true;

	// 数据集
	var InstDetailStore = new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url: url,
				method: "POST"
			}),
			reader: new Ext.data.JsonReader({
				root: 'rows',
				totalProperty: "results",
				id: "instw",
				fields: ["instw", "insti", "inclb", "code", "desc", "spec", "manf", "batNo", "expDate",
					"freQty", "uom", "uomDesc", "buom", "buomDesc", "rp", "sp", "countQty",
					"countDate", "countTime", "userName", "stkbin"]
			}),
			pruneModifiedRecords: true,
			remoteSort: true
		});

	var StatuTabPagingToolbar = new Ext.PagingToolbar({
			store: InstDetailStore,
			pageSize: PageSize,
			displayInfo: true,
			displayMsg: '当前记录 {0} -- {1} 条 共 {2} 条记录',
			emptyMsg: "No results to display",
			prevText: "上一页",
			nextText: "下一页",
			refreshText: "刷新",
			lastText: "最后页",
			firstText: "第一页",
			beforePageText: "当前页",
			afterPageText: "共{0}页",
			emptyMsg: "没有数据"
		});

	StatuTabPagingToolbar.addListener('beforechange', function (toolbar, params) {
		if (InstDetailGrid.activeEditor != null) {
			InstDetailGrid.activeEditor.completeEdit();
		}
		var records = InstDetailStore.getModifiedRecords();
		if (records.length > 0) {
			Msg.info("warning", "本页数据发生变化，请先保存！");
			return false;
		}
	});

	var InstDetailGrid = new Ext.grid.EditorGridPanel({
			id: 'InstDetailGrid',
			region: 'center',
			cm: InstDetailGridCm,
			store: InstDetailStore,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.ux.CellSelectionModel(),
			loadMask: true,
			bbar: StatuTabPagingToolbar,
			clicksToEdit: 1
		});

	var form = new Ext.ux.FormPanel({
			title: '实盘：录入方式一(按批次填充实盘数)',
			tbar: [SearchBT, '-', SaveBT, '-', RefreshBT, '-', SetDefaultBT, '-', SetDefaultBT2],
			items: [{
					xtype: 'fieldset',
					layout: 'column',
					title : '查询条件',
					style:'padding:5px 0px 0px 5px',
					defaults:{xtype:'fieldset',border:false},
					items: [{
							columnWidth: 0.34,
							items: [LocManaGrp, StkBin, InciDesc]

						}, {
							columnWidth: 0.33,
							items: [StkGrpType, DHCStkCatGroup]

						}, {
							columnWidth: 0.33,
							items: [PhaWindow, InstNo]

						}
					]
				}
			]
		});

	// 5.2.页面布局
	var mainPanel = new Ext.ux.Viewport({
			layout: 'border',
			items: [form, InstDetailGrid]
		});

	//自动加载盘点单
	create(gRowid, gInstwWin);
})
