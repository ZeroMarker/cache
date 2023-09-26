var expendcollectUrl = 'dhc.bonus.subimportdataexe.csp';
var OutKPIDataProxy = new Ext.data.HttpProxy({
			url : expendcollectUrl + '?action=list'
		});

var cycleDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

cycleDs.on('beforeload', function(ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.bonustargetcollectexe.csp?action=yearlist',
				method : 'POST'
			})
});

var cycleField = new Ext.form.ComboBox({
			id : 'cycleField',
			fieldLabel : '��������',
			width : 70,
			listWidth : 150,
			allowBlank : false,
			store : cycleDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '���',
			name : 'cycleField',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});

var periodTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['M', '��'], ['Q', '��'], ['H', '����'], ['Y', '��']]
		});
var periodTypeField = new Ext.form.ComboBox({
			id : 'periodTypeField',
			fieldLabel : '�ڼ�����',
			selectOnFocus : true,
			width : 70,
			listWidth : 150,
			allowBlank : false,
			store : periodTypeStore,
			anchor : '90%',
			value : '', // Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '�ڼ�����',
			mode : 'local', // ����ģʽ
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});

periodTypeField.on("select", function(cmb, rec, id) {
	if (cmb.getValue() == "M") {
		data = [['01', '01��'], ['02', '02��'], ['03', '03��'], ['04', '04��'],
				['05', '05��'], ['06', '06��'], ['07', '07��'], ['08', '08��'],
				['09', '09��'], ['10', '10��'], ['11', '11��'], ['12', '12��']];
	}
	if (cmb.getValue() == "Q") {
		data = [['01', '01����'], ['02', '02����'], ['03', '03����'], ['04', '04����']];
	}
	if (cmb.getValue() == "H") {
		data = [['01', '1~6�ϰ���'], ['02', '7~12�°���']];
	}
	if (cmb.getValue() == "Y") {
		data = [['00', 'ȫ��']];
	}
	periodStore.loadData(data);
});
periodStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue']
		});

var periodField = new Ext.form.ComboBox({
			id : 'periodField',
			fieldLabel : '',
			selectOnFocus : true,
			allowBlank : false,
			width : 70,
			listWidth : 150,
			store : periodStore,
			anchor : '90%',
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '�ڼ�',
			mode : 'local', // ����ģʽ
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});

var locSetDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name', 'shortcut'])
		});

locSetDs.on('beforeload', function(ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
		url : 'dhc.bonus.outkpiruleexe.csp?action=locsetSublist&searchField=TypeID&searchValue=3',
		method : 'POST'
	})
});

var targetTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '����ָ��'], ['2', '������ָ��'], ['3', '֧��ָ��']]
		});

var targetTypeField = new Ext.form.ComboBox({
			id : 'targetTypeField',
			fieldLabel : 'ָ�����:',
			width : 150,
			listWidth : 150,
			allowBlank : false,
			// store : locSetDs,
			store : targetTypeStore,
			valueField : 'key',
			displayField : 'keyValue',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			name : 'targetTypeField',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});

var targeListDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

targeListDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : expendcollectUrl
								+ '?action=targetList&subItemType='
								+ targetTypeField.getValue()
								+ '&start=0&limit=10',
						method : 'POST'
					})
		});
targetTypeField.on("select", function(cmb, rec, id) {

			targeListDs.load({
						params : {
							subItemType : Ext.getCmp('targetTypeField')
									.getValue(),
							start : 0,
							limit : 10
						}
					});
		});
var bonusTargetField = new Ext.form.ComboBox({
			id : 'bonusTargetField',
			fieldLabel : '����ָ��',
			width : 150,
			height : 200,
			listWidth : 200,
			allowBlank : false,
			store : targeListDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'bonusTargetField',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});

var IncomeCollect = new Ext.data.Store({
			proxy : OutKPIDataProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['rowid', 'BonusUnitID', 'BonusUnitName',
							'BonusTargetID', 'BonusTargetName', 'BonusYear',
							'BonusPeriod', 'BonusValue', 'DataType',
							'UpadeDate'

					]),

			remoteSort : true
		});

IncomeCollect.setDefaultSort('rowid', 'DESC');
// ���밴ť
var excelButton = new Ext.Toolbar.Button({
			text : '����Excel����',
			tooltip : '����Excel����',
			iconCls : 'add',
			handler : function() {
				importExcel('expendCollect')
			}

		});

var importButton = new Ext.Toolbar.Button({
	text : '���ݵ���',
	tooltip : '���ݵ���',
	iconCls : 'add',
	handler : function() {
		var cycleDr = Ext.getCmp('cycleField').getValue();
		if (cycleDr == "") {
			Ext.Msg.show({
						title : '��ʾ',
						msg : '��ѡ�����!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		}
		var periodType = Ext.getCmp('periodTypeField').getValue();
		if (periodType == "") {
			Ext.Msg.show({
						title : '��ʾ',
						msg : '��ѡ���������!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		}
		var period = Ext.getCmp('periodField').getValue();
		if (period == "") {
			Ext.Msg.show({
						title : '��ʾ',
						msg : '��ѡ������!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		}
		var targetType = Ext.getCmp('targetTypeField').getValue();
		var locSetName = Ext.getCmp('targetTypeField').getRawValue();
		var bonusTarget = Ext.getCmp('bonusTargetField').getValue();

		if (targetType == "") {
			Ext.Msg.show({
						title : '��ʾ',
						msg : '��ѡ��ӿ���!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		}

		var status2 = IncomeCollectMain.getStore().find('status', '����ɹ�')
		var stext = ""
		if (status2 >= 0) {
			stext = "�����Ѿ����룬ȷ��Ҫ���µ���������µ�������?"
		} else {
			stext = "ȷ��Ҫ�����������ָ��������?"
		}
		var spr = expendcollectUrl + '?action=import&CycleDr=' + cycleDr
				+ '&bonusTarget=' + bonusTarget + '&period=' + periodType
				+ period + '&targetType=' + targetType
		// alert(spr);
		// TargetType,TargetID
		Ext.MessageBox.confirm('��ʾ', stext, function(btn) {
			if (btn == 'yes') {
				Ext.Ajax.request({
							url : expendcollectUrl + '?action=import&CycleDr='
									+ cycleDr + '&period=' + periodType
									+ period + '&TargetType=' + targetType
									+ '&TargetID=' + bonusTarget,
							waitMsg : '������...',
							failure : function(result, request) {
								Ext.Msg.show({
											title : '����',
											msg : '������������!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							},
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == '0') {

									findData();
									Ext.Msg.show({
												title : '��ʾ',
												msg : locSetName + '��ָ�����ݵ���ɹ���',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO
											});

									// ���³���
								} else {
									Ext.Msg.show({
												title : '��ʾ',
												msg : 'ָ�����ݵ���ʧ�ܣ�',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO
											});
								}
							},
							scope : this
						});
			}
		});
	}
});
//
var collectDataButton = new Ext.Toolbar.Button({
	text : '���ݲɼ�',
	tooltip : '���ݲɼ�',
	iconCls : 'add',
	handler : function() {
		var cycleDr = Ext.getCmp('cycleField').getValue();
		if (cycleDr == "") {
			Ext.Msg.show({
						title : '��ʾ',
						msg : '��ѡ�����!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		}
		var periodType = Ext.getCmp('periodTypeField').getValue();
		if (periodType == "") {
			Ext.Msg.show({
						title : '��ʾ',
						msg : '��ѡ���������!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		}
		var period = Ext.getCmp('periodField').getValue();
		if (period == "") {
			Ext.Msg.show({
						title : '��ʾ',
						msg : '��ѡ������!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		}
		var targetType = Ext.getCmp('targetTypeField').getValue();
		var locSetName = Ext.getCmp('targetTypeField').getRawValue();
		var bonusTarget = Ext.getCmp('bonusTargetField').getValue();

		if (targetType == "") {
			Ext.Msg.show({
						title : '��ʾ',
						msg : '��ѡ��ӿ���!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		}

		var ss = IncomeCollectMain.getStore().getCount()

		var stext = ""
		// var status=
		// IncomeCollectMain.getStore().getById(1).get('status').toString()
		var status = IncomeCollectMain.getStore().find('status', '�ɼ��ɹ�')
		var status2 = IncomeCollectMain.getStore().find('status', '����ɹ�')
		if (status >= 0) {
			stext = "�����Ѿ��ɼ���ȷ��Ҫ���²ɼ��������µ�������?"
		} else if (status2 >= 0) {
			stext = "�����Ѿ����룬ȷ��Ҫ���²ɼ��������µ�������?"
		} else {
			stext = "ȷ��Ҫ�ɼ���������ָ��������?"
		}
		Ext.MessageBox.confirm('��ʾ', stext, function(btn) {
			if (btn == 'yes') {
				Ext.Ajax.request({
							url : expendcollectUrl + '?action=collect&CycleDr='
									+ cycleDr + '&bonusTarget=' + bonusTarget
									+ '&period=' + periodType + period
									+ '&targetType=' + targetType
									+ '&DataType=3',
							waitMsg : '������...',
							failure : function(result, request) {
								Ext.Msg.show({
											title : '����',
											msg : '������������!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							},
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == '0') {
									Ext.Msg.show({
												title : '��ʾ',
												msg : locSetName + '��ָ�����ݵ���ɹ���',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO
											});
									findData()
									// ���³���
								} else {
									Ext.Msg.show({
												title : '��ʾ',
												msg : 'ָ�����ݵ���ʧ�ܣ�',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO
											});
								}
							},
							scope : this
						});
			}
		});

	}
});

var delButton = new Ext.Toolbar.Button({
	text : '����ɾ��',
	tooltip : '����ɾ��',
	iconCls : 'add',
	handler : function() {
		var cycleDr = Ext.getCmp('cycleField').getValue();
		if (cycleDr == "") {
			Ext.Msg.show({
						title : '��ʾ',
						msg : '��ѡ�����!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		}
		var periodType = Ext.getCmp('periodTypeField').getValue();
		if (periodType == "") {
			Ext.Msg.show({
						title : '��ʾ',
						msg : '��ѡ���������!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		}
		var period = Ext.getCmp('periodField').getValue();
		if (period == "") {
			Ext.Msg.show({
						title : '��ʾ',
						msg : '��ѡ������!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		}
		var targetType = Ext.getCmp('targetTypeField').getValue();
		var locSetName = Ext.getCmp('targetTypeField').getRawValue();
		var bonusTarget = Ext.getCmp('bonusTargetField').getValue();

		if (targetType == "") {
			Ext.Msg.show({
						title : '��ʾ',
						msg : '��ѡ��ӿ���!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		}

		Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ���������µ�ָ��������?', function(btn) {
			if (btn == 'yes') {
				Ext.Ajax.request({
							url : expendcollectUrl + '?action=del&CycleDr='
									+ cycleDr + '&period=' + periodType
									+ period + '&TargetType=' + targetType,
							waitMsg : 'ɾ����...',
							failure : function(result, request) {
								Ext.Msg.show({
											title : '����',
											msg : '������������!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							},
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == '0') {
									Ext.Msg.show({
												title : '��ʾ',
												msg : locSetName + '��ָ������ɾ���ɹ���',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO
											});
									findData()
									// ���³���
								} else {
									Ext.Msg.show({
												title : '��ʾ',
												msg : 'ָ������ɾ��ʧ�ܣ�',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO
											});
								}
							},
							scope : this
						});
			}
		});
	}
});

Ext.grid.CheckColumn = function(config) {
	Ext.apply(this, config);
	if (!this.id) {
		this.id = Ext.id();
	}
	this.renderer = this.renderer.createDelegate(this);
};

Ext.grid.CheckColumn.prototype = {
	init : function(grid) {
		this.grid = grid;
		this.grid.on('render', function() {
					var view = this.grid.getView();
					view.mainBody.on('mousedown', this.onMouseDown, this);
				}, this);
	},

	onMouseDown : function(e, t) {
		if (t.className && t.className.indexOf('x-grid3-cc-' + this.id) != -1) {
			e.stopEvent();
			var index = this.grid.getView().findRowIndex(t);
			var cindex = this.grid.getView().findCellIndex(t);
			var record = this.grid.store.getAt(index);
			var field = this.grid.colModel.getDataIndex(cindex);
			var e = {
				grid : this.grid,
				record : record,
				field : field,
				originalValue : record.data[this.dataIndex],
				value : !record.data[this.dataIndex],
				row : index,
				column : cindex,
				cancel : false
			};
			if (this.grid.fireEvent("validateedit", e) !== false && !e.cancel) {
				delete e.cancel;
				record.set(this.dataIndex, !record.data[this.dataIndex]);
				this.grid.fireEvent("afteredit", e);
			}
		}
	},

	renderer : function(v, p, record) {
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col' + (v ? '-on' : '')
				+ ' x-grid3-cc-' + this.id + '">&#160;</div>';
	}
};
// "rowid^BonusUnitID^BonusUnitName^BonusTargetID^BonusTargetName^BonusYear^BonusPeriod^BonusValue^DataType^UpadeDate"

var subMainCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
			header : " �������",
			dataIndex : 'BonusYear',
			width : 80,
			align : 'center',
			sortable : true
		}, {
			header : " �����ڼ�",
			dataIndex : 'BonusPeriod',
			width : 70,
			align : 'center',
			sortable : true
		}, {
			header : '���㵥Ԫ',
			dataIndex : 'BonusUnitName',
			width : 100,
			align : 'left',
			sortable : true

		}, {
			header : '����ָ��',
			dataIndex : 'BonusTargetName',
			width : 100,
			align : 'left',
			sortable : true

		}, {
			header : 'ָ��ֵ',
			dataIndex : 'BonusValue',
			width : 100,
			align : 'left',
			sortable : true

		}, {//
			header : '��������',
			dataIndex : 'DataType',
			width : 100,
			align : 'left',
			sortable : true

		}, {
			header : '����ʱ��',
			dataIndex : 'UpadeDate',
			width : 150,
			align : 'left',
			sortable : true

		}]);

var OutKPIDataSearchField = 'outUnitName';

var OutKPIDataFilterItem = new Ext.SplitButton({
			text : '������',
			tooltip : '�ؼ����������',
			menu : {
				items : [new Ext.menu.CheckItem({
									text : '�ⲿ��λ����',
									value : 'outUnitCode',
									checked : false,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								}), new Ext.menu.CheckItem({
									text : '�ⲿ��λ����',
									value : 'outUnitName',
									checked : true,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								}), new Ext.menu.CheckItem({
									text : '�ⲿ��λ�������Ҵ���',
									value : 'outUnitLocCode',
									checked : false,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								}), new Ext.menu.CheckItem({
									text : '�ⲿ��λ������������',
									value : 'outUnitLocName',
									checked : false,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								}), new Ext.menu.CheckItem({
									text : '�ⲿָ�����',
									value : 'outKpiCode',
									checked : false,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								}), new Ext.menu.CheckItem({
									text : '�ⲿָ������',
									value : 'outKpiName',
									checked : false,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								}), new Ext.menu.CheckItem({
									text : 'ָ��ʵ��ֵ',
									value : 'actValue',
									checked : false,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								}), new Ext.menu.CheckItem({
									text : '�����־',
									value : 'handFlag',
									checked : false,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								})]
			}
		});

function onOutKPIDataItemCheck(item, checked) {
	if (checked) {
		OutKPIDataSearchField = item.value;
		OutKPIDataFilterItem.setText(item.text + ':');
	}
};

var OutKPIDataSearchBox = new Ext.form.TwinTriggerField({// ���Ұ�ť
	width : 180,
	trigger1Class : 'x-form-clear-trigger',
	trigger2Class : 'x-form-search-trigger',
	emptyText : '����...',
	listeners : {
		specialkey : {
			fn : function(field, e) {
				var key = e.getKey();
				if (e.ENTER === key) {
					this.onTrigger2Click();
				}
			}
		}
	},
	grid : this,
	onTrigger1Click : function() {
		if (this.getValue()) {
			this.setValue('');
			IncomeCollect.proxy = new Ext.data.HttpProxy({
						url : expendcollectUrl + '?action=list&CycleDr='
								+ cycleField.getValue() + '&frequency='
								+ periodTypeField.getValue() + '&period='
								+ periodField.getValue()
					});
			IncomeCollect.load({
						params : {
							start : 0,
							limit : OutKPIDataPagingToolbar.pageSize
						}
					});
		}
	},
	onTrigger2Click : function() {
		if (this.getValue()) {
			IncomeCollect.proxy = new Ext.data.HttpProxy({
						url : expendcollectUrl + '?action=list&searchField='
								+ OutKPIDataSearchField + '&searchValue='
								+ this.getValue() + '&CycleDr='
								+ cycleField.getValue() + '&frequency='
								+ periodTypeField.getValue() + '&period='
								+ periodField.getValue()
					});
			IncomeCollect.load({
						params : {
							start : 0,
							limit : OutKPIDataPagingToolbar.pageSize
						}
					});
		}
	}
});
IncomeCollect.each(function(record) {
			alert(record.get('tieOff'));

		});
var OutKPIDataPagingToolbar = new Ext.PagingToolbar({// ��ҳ������
	pageSize : 25,
	store : IncomeCollect,
	displayInfo : true,
	displayMsg : '��ǰ��ʾ{0} - {1}������{2}',
	emptyMsg : "û������"
		// buttons : ['-', OutKPIDataFilterItem, '-', OutKPIDataSearchBox]
});

var IncomeCollectMain = new Ext.grid.GridPanel({// ���
	title : '�������ݵ���',
	store : IncomeCollect,
	cm : subMainCm,
	trackMouseOver : true,
	region : 'center',
	stripeRows : true,
	sm : new Ext.grid.RowSelectionModel({
				singleSelect : true
			}),
	loadMask : true,
	frame : true,
	// plugins:checkColumn,
	clicksToEdit : 2,
	stripeRows : true,
	tbar : ['�ɼ��ڼ�:', cycleField, '-', periodTypeField, '-', periodField, '-',
			'ָ�����:', targetTypeField, '-', importButton, '-', delButton],
	bbar : OutKPIDataPagingToolbar

});
// , '����ָ��:', bonusTargetField, '-'

bonusTargetField.on('select', function(cmb, rec, id) {

			findData()
		});
periodField.on('select', function(cmb, rec, id) {

			findData()
		});
targetTypeField.on('select', function(cmb, rec, id) {
			findData()
		});

function findData() {
	var targetType = Ext.getCmp('targetTypeField').getValue();
	var bonusTarget = Ext.getCmp('bonusTargetField').getValue();

	var surl = ''
	surl = expendcollectUrl + '?action=list&CycleDr=' + cycleField.getValue()
			+ '&frequency=' + periodTypeField.getValue() + '&period='
			+ periodField.getValue() + '&TargetType=' + targetType

	// prompt('surl',surl)

	IncomeCollect.proxy = new Ext.data.HttpProxy({
		url : surl
			// ,method : 'POST'
		});
	IncomeCollect.load({
				params : {
					start : 0,
					limit : OutKPIDataPagingToolbar.pageSize
				}
			});

}
function isEdit(value, record) {
	// ���̨�ύ����
	return value;
}

function getImportStatus() {
	var targetType = Ext.getCmp('targetTypeField').getValue();
	var locSetName = Ext.getCmp('targetTypeField').getRawValue();
	var cycleDr = Ext.getCmp('cycleField').getValue();
	var bonusTarget = Ext.getCmp('bonusTargetField').getValue();
	var periodType = Ext.getCmp('periodTypeField').getValue();
	var period = Ext.getCmp('periodField').getValue();

	var rtnStatus = '-1'

	Ext.Ajax.request({
				url : expendcollectUrl + '?action=ImportStatus&CycleDr='
						+ cycleDr + '&bonusTarget=' + bonusTarget + '&period='
						+ periodType + period + '&targetType=' + targetType,
				waitMsg : '������...',
				failure : function(result, request) {
					rtnStatus = "-2"
					Ext.Msg.show({
								title : '����',
								msg : '������������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					rtnStatus = jsonData.success
					prompt('aaa', rtnStatus)
					// return rtnStatus;
				},
				scope : this
			});
	prompt('bbb', rtnStatus)
	return rtnStatus;
}
IncomeCollect.load({
			params : {
				start : 0,
				limit : OutKPIDataPagingToolbar.pageSize
			}
		});
