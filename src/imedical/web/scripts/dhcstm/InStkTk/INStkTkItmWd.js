// /����: ʵ�̣�¼�뷽ʽһ�������������ݰ��������ʵ������
// /����:  ʵ�̣�¼�뷽ʽһ�������������ݰ��������ʵ������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.30
Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrDetailParams = '';
	var url = DictUrl + 'instktkaction.csp';
	var logonLocId = session['LOGON.CTLOCID'];
	var logonUserId = session['LOGON.USERID'];

	var LocManaGrp = new Ext.form.ComboBox({
			fieldLabel: '������',
			id: 'LocManaGrp',
			name: 'LocManaGrp',
			anchor: '90%',
			width: 140,
			store: LocManGrpStore,
			valueField: 'RowId',
			displayField: 'Description',
			allowBlank: true,
			triggerAction: 'all',
			emptyText: '������...',
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
			fieldLabel: 'ʵ�̴���',
			id: 'PhaWindow',
			name: 'PhaWindow',
			anchor: '90%',
			store: INStkTkWindowStore,
			valueField: 'RowId',
			displayField: 'Description',
			disabled: true,
			allowBlank: true,
			triggerAction: 'all',
			emptyText: 'ʵ�̴���...',
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
			fieldLabel: '������',
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
			fieldLabel: '��������',
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
	 * �������ʴ��岢���ؽ��
	 */
	function GetPhaOrderInfo(item, stkgrp) {
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, stkgrp, App_StkTypeCode, "", "N", "0", "", getDrugList);
		}
	}
	/**
	 * ���ط���
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
			fieldLabel: '��λ',
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

	//�̵㵥��
	var InstNo = new Ext.form.TextField({
			id: 'InstNo',
			name: 'InstNo',
			fieldLabel: '�̵㵥��',
			anchor: '90%',
			width: 140,
			disabled: true
		});

	// ��ѯ��ť
	var SearchBT = new Ext.Toolbar.Button({
			text: '��ѯ',
			tooltip: '�����ѯ',
			iconCls: 'page_find',
			width: 70,
			height: 30,
			handler: function () {
				QueryDetail();
			}
		});

	//����δ��������������
	var SetDefaultBT2 = new Ext.Toolbar.Button({
			text: '����δ��������������',
			tooltip: '�������δ��������������',
			iconCls: 'page_edit',
			width: 70,
			height: 30,
			handler: function () {
				var ss = Ext.Msg.show({
						title: '��ʾ',
						msg: '����δ��ʵ�����������������޸Ĵ��̵㵥����δ¼��ļ�¼���Ƿ������',
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

	//����δ��������0
	var SetDefaultBT = new Ext.Toolbar.Button({
			text: '����δ��������0',
			tooltip: '�������δ��������0',
			iconCls: 'page_edit',
			width: 70,
			height: 30,
			handler: function () {
				var ss = Ext.Msg.show({
						title: '��ʾ',
						msg: '����δ��ʵ��������0���޸Ĵ��̵㵥����δ¼��ļ�¼���Ƿ������',
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

	//����δ��ʵ����
	function SetDefaultQty(flag) {
		if (gRowid == '') {
			Msg.info('Warning', 'û��ѡ�е��̵㵥��');
			return;
		}
		var InstwWin = Ext.getCmp("PhaWindow").getValue();
		var UserId = session['LOGON.USERID'];
		var mask = ShowLoadMask(Ext.getBody(), "���������Ժ�...");
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
			waitMsg: '������...',
			success: function (response, opt) {
				var jsonData = Ext.util.JSON.decode(response.responseText);
				mask.hide();
				if (jsonData.success == 'true') {
					Msg.info('success', '�ɹ�!');
					QueryDetail();
				} else {
					var ret = jsonData.info;
					Msg.info('error', '����δ���¼ʵ����ʧ��:' + ret);

				}
			}
		});
	}

	// ��հ�ť
	var RefreshBT = new Ext.Toolbar.Button({
			text: '���',
			tooltip: '������',
			iconCls: 'page_clearscreen',
			width: 70,
			height: 30,
			handler: function () {
				clearData();
			}
		});

	/**
	 * ��շ���
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
			text: '����',
			tooltip: '�������',
			iconCls: 'page_save',
			width: 70,
			height: 30,
			handler: function () {
				save();
			}
		});

	//����ʵ������
	function save() {
		if (InstDetailGrid.activeEditor != null) {
			InstDetailGrid.activeEditor.completeEdit();
		}
		var rowCount = InstDetailStore.getCount();
		var ListDetail = '';
		for (var i = 0; i < rowCount; i++) {
			var rowData = InstDetailStore.getAt(i);
			//�������޸Ĺ�������
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
			Msg.info('Warning', 'û����Ҫ���������!');
			return;
		}
		var mask = ShowLoadMask(Ext.getBody(), "���������Ժ�...");
		Ext.Ajax.request({
			url: url,
			params: {
				actiontype: 'SaveTkItmWd',
				Params: ListDetail
			},
			method: 'post',
			waitMsg: '������...',
			success: function (response, opt) {
				var jsonData = Ext.util.JSON.decode(response.responseText);
				mask.hide();
				if (jsonData.success == 'true') {
					Msg.info('success', '����ɹ�!');
					QueryDetail();
				} else {
					var ret = jsonData.info;
					if (ret == '-1') {
						Msg.info('warning', 'û����Ҫ���������!');
					} else if (ret == '-2') {
						Msg.info('error', '����ʧ��!');
					} else {
						Msg.info('error', '�������ݱ���ʧ��:' + ret);
					}
				}
			}
		});
	}

	//�����������ݲ���ʵ���б�
	function create(inst, instwWin) {
		if (inst == null || inst == '') {
			Msg.info('warning', '��ѡ���̵㵥');
			return;
		}
		var UserId = session['LOGON.USERID'];
		var mask = ShowLoadMask(Ext.getBody(), "���������Ժ�...");
		Ext.Ajax.request({
			url: url,
			params: {
				actiontype: 'CreateTkItmWd',
				Inst: inst,
				UserId: UserId,
				InstwWin: instwWin
			},
			waitMsg: '������...',
			success: function (response, opt) {
				var jsonData = Ext.util.JSON.decode(response.responseText);
				mask.hide();
				if (jsonData.success == 'true') {
					Select(); //��ѯ�̵㵥������Ϣ
				} else {
					var ret = jsonData.info;
					Msg.info("error", "��ȡʵ���б�ʧ�ܣ�" + ret);
				}
			}
		});
	}

	//�����̵㵥����ϸ��Ϣ
	function QueryDetail() {

		//��ѯ�̵㵥��ϸ
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
		var mask = ShowLoadMask(Ext.getBody(), "���������Ժ�...");
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
					QueryDetail(); //��ѯ��ϸ��Ϣ
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
					header: '����',
					dataIndex: 'code',
					width: 80,
					align: 'left',
					sortable: true
				}, {
					header: "����",
					dataIndex: 'desc',
					width: 200,
					align: 'left',
					sortable: true
				}, {
					header: "���",
					dataIndex: 'spec',
					width: 80,
					align: 'left',
					sortable: true
				}, {
					header: '����',
					dataIndex: 'batNo',
					width: 80,
					align: 'left',
					sortable: true
				}, {
					header: 'Ч��',
					dataIndex: 'expDate',
					width: 100,
					align: 'left',
					sortable: true
				}, {
					header: "��λ",
					dataIndex: 'uomDesc',
					width: 60,
					align: 'left',
					sortable: true
				}, {
					header: '��������',
					dataIndex: 'freQty',
					width: 80,
					align: 'right',
					sortable: true
				}, {
					header: 'ʵ������',
					dataIndex: 'countQty',
					width: 80,
					align: 'right',
					sortable: true,
					editor: new Ext.form.NumberField({
						selectOnFocus: true,
						allowNegative: false
					})
				}, {
					header: "��λ��",
					dataIndex: 'stkbin',
					width: 100,
					align: 'left',
					sortable: true
				}, {
					header: "����",
					dataIndex: 'manf',
					width: 100,
					align: 'left',
					sortable: true
				}, {
					header: 'ʵ������',
					dataIndex: 'countDate',
					width: 80,
					align: 'left',
					sortable: true
				}, {
					header: "ʵ��ʱ��",
					dataIndex: 'countTime',
					width: 80,
					align: 'left',
					sortable: true
				}, {
					header: 'ʵ����',
					dataIndex: 'userName',
					width: 80,
					align: 'left',
					sortable: true
				}
			]);
	InstDetailGridCm.defaultSortable = true;

	// ���ݼ�
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
			displayMsg: '��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
			emptyMsg: "No results to display",
			prevText: "��һҳ",
			nextText: "��һҳ",
			refreshText: "ˢ��",
			lastText: "���ҳ",
			firstText: "��һҳ",
			beforePageText: "��ǰҳ",
			afterPageText: "��{0}ҳ",
			emptyMsg: "û������"
		});

	StatuTabPagingToolbar.addListener('beforechange', function (toolbar, params) {
		if (InstDetailGrid.activeEditor != null) {
			InstDetailGrid.activeEditor.completeEdit();
		}
		var records = InstDetailStore.getModifiedRecords();
		if (records.length > 0) {
			Msg.info("warning", "��ҳ���ݷ����仯�����ȱ��棡");
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
			title: 'ʵ�̣�¼�뷽ʽһ(���������ʵ����)',
			tbar: [SearchBT, '-', SaveBT, '-', RefreshBT, '-', SetDefaultBT, '-', SetDefaultBT2],
			items: [{
					xtype: 'fieldset',
					layout: 'column',
					title : '��ѯ����',
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

	// 5.2.ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
			layout: 'border',
			items: [form, InstDetailGrid]
		});

	//�Զ������̵㵥
	create(gRowid, gInstwWin);
})
