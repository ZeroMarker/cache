var incomecollectUrl = 'dhc.bonus.subincomecollectexe.csp';
var OutKPIDataProxy = new Ext.data.HttpProxy({
			url : incomecollectUrl + '?action=list'
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
		// url : 'dhc.bonus.intermethodexe.csp?action=getScheme',
		url : 'dhc.bonus.outkpiruleexe.csp?action=locsetSublist&searchField=TypeID&searchValue=2',
		method : 'POST'
	})
});

var locSetField = new Ext.form.ComboBox({
			id : 'locSetField',
			fieldLabel : '�ӿ����:',
			width : 100,
			listWidth : 150,
			allowBlank : false,
			store : locSetDs,
			valueField : 'rowid',
			displayField : 'shortcut',
			triggerAction : 'all',
			emptyText : '',
			name : 'locSetField',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});

var interMedthodDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

interMedthodDs.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'dhc.bonus.intermethodexe.csp?action=InterMethod2&interLocSetDr='
						+ locSetField.getValue() + '&start=0&limit=10',
				method : 'POST'
			})
});
locSetField.on("select", function(cmb, rec, id) {

			interMedthodDs.load({
						params : {
							interLocSetDr : Ext.getCmp('locSetField')
									.getValue(),
							start : 0,
							limit : 10
						}
					});
		});
var interMethodField = new Ext.form.ComboBox({
			id : 'interMethodField',
			fieldLabel : '�ӿڷ���',
			width : 100,
			height : 200,
			listWidth : 200,
			allowBlank : false,
			store : interMedthodDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'interMethodField',
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
					}, ['IncomeItemCode', 'IncomeItemName', 'BonusYear',
							'BonusPeriod', 'MakeBillDeptCode',
							'MakeBillDeptName', 'ExecuteDeptCode',
							'ExecuteDeptName', 'SickDeptCode', 'SickDeptName',
							'ChiefDoctorCode', 'ChiefDoctorName',
							'MakeBillDoctorCode', 'MakeBillDoctorName',
							'ExecuteDoctorCode', 'ExecuteDoctorName',
							'SickType', 'ExpensesType', 'IncomeMoney', 'State',
							'InterLocMethodID', 'UpdateDate','methodDesc','InterLocSetname'

					]), 
			// turn on remote sorting
			remoteSort : true
		});
// ��ʼ����ť
var uploadButton = new Ext.Toolbar.Button({
			text : 'Excel���ݵ���',
			tooltip : '��������(Excel��ʽ)',
			iconCls : 'add',
			handler : function() {

				importExcel('incomeCollect');

				return;

			}

		});
		
IncomeCollect.setDefaultSort('rowid', 'DESC');

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
		var locSetDr = Ext.getCmp('locSetField').getValue();
		var locSetName = Ext.getCmp('locSetField').getRawValue();
		var interMethodDr = Ext.getCmp('interMethodField').getValue();

		if (locSetDr == "") {
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
							url : incomecollectUrl + '?action=collect&CycleDr='
									+ cycleDr + '&interMethodDr='
									+ interMethodDr + '&period=' + periodType
									+ period + '&locSetDr=' + locSetDr+ '&DataType=2',
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
												msg : locSetName + '��ָ�����ݲɼ���ɣ�',
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
		var locSetDr = Ext.getCmp('locSetField').getValue();
		var locSetName = Ext.getCmp('locSetField').getRawValue();
		var interMethodDr = Ext.getCmp('interMethodField').getValue();

		if (locSetDr == "") {
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
							url : incomecollectUrl + '?action=del&CycleDr='
									+ cycleDr + '&interMethodDr='
									+ interMethodDr + '&period=' + periodType
									+ period + '&locSetDr=' + locSetDr,
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
var queryButton = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '��ѯ',
			iconCls : 'add',
			handler : function() {
				// alert(btnField.getValue().trim());
				findData()
		
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


var OutKPIDataCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),

{
			header : " �ӿ���",
			dataIndex : 'InterLocSetname',
			width : 100,
			align : 'center',
			sortable : true
		}, {
			header : " �ӿڷ���",
			dataIndex : 'methodDesc',
			width : 100,
			align : 'center',
			sortable : true
		}, {
			header : '��Ŀ����',
			dataIndex : 'IncomeItemCode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '��Ŀ����',
			dataIndex : 'IncomeItemName',
			width : 100,
			align : 'left',
			sortable : true

		}, {
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
			header : '�������ұ���',
			dataIndex : 'MakeBillDeptCode',
			width : 80,
			align : 'left',
			sortable : true

		}, {
			header : '������������',
			dataIndex : 'MakeBillDeptName',
			width : 100,
			align : 'left',
			sortable : true

		}, {
			header : 'ִ�п��ұ���',
			dataIndex : 'ExecuteDeptCode',
			width : 80,
			align : 'left',
			sortable : true

		}, {
			header : 'ִ�п�������',
			dataIndex : 'ExecuteDeptName',
			width : 100,
			align : 'left',
			sortable : true

		}, {
			header : '���˿��ұ���',
			dataIndex : 'SickDeptCode',
			width : 80,
			align : 'left',
			sortable : true

		}, {
			header : '���˿�������',
			dataIndex : 'SickDeptName',
			width : 100,
			align : 'right',
			sortable : true

		}, {
			header : '����ҽ������',
			dataIndex : 'ChiefDoctorCode',
			width : 80,
			align : 'right',
			sortable : true

		}, {
			header : '����ҽ������',
			dataIndex : 'ChiefDoctorName',
			width : 80,
			align : 'right',
			sortable : true

		}, {
			header : '����ҽ������',
			dataIndex : 'MakeBillDoctorCode',
			width : 80,
			align : 'right',
			sortable : true

		}, {
			header : '����ҽ������',
			dataIndex : 'MakeBillDoctorName',
			width : 80,
			align : 'right',
			sortable : true

		}, {
			header : 'ִ��ҽ������',
			dataIndex : 'ExecuteDoctorCode',
			width : 80,
			align : 'right',
			sortable : true

		}, {
			header : 'ִ��ҽ������',
			dataIndex : 'ExecuteDoctorName',
			width : 80,
			align : 'right',
			sortable : true

		}, {
			header : '�������',
			dataIndex : 'SickType',
			width : 90,
			align : 'right',
			sortable : true

		}, {
			header : '�������',
			dataIndex : 'ExpensesType',
			width : 90,
			align : 'right',
			sortable : true

		}, {
			header : '������',
			dataIndex : 'IncomeMoney',
			width : 90,
			align : 'right',
			sortable : true

		}, {
			header : '����״̬',
			dataIndex : 'status',
			width : 70,
			align : 'right',
			sortable : true

		}, {
			header : '�ɼ�ʱ��',
			dataIndex : 'UpdateDate',
			width : 80,
			align : 'right',
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
						url : incomecollectUrl + '?action=list&CycleDr='
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
						url : incomecollectUrl + '?action=list&searchField='
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
	//buttons : ['-', OutKPIDataFilterItem, '-', OutKPIDataSearchBox]
});

var IncomeCollectMain = new Ext.grid.GridPanel({// ���
	title : '�������ݲɼ�',
	store : IncomeCollect,
	cm : OutKPIDataCm,
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
			'�ӿ����:', locSetField, '-', '�ӿڷ���:', interMethodField, '-',
			queryButton,'-',collectDataButton, '-', uploadButton, '-', delButton],
	bbar : OutKPIDataPagingToolbar

});

interMethodField.on('select', function(cmb, rec, id) {

			//findData()
		});
periodField.on('select', function(cmb, rec, id) {

			//findData()
		});
locSetField.on('select', function(cmb, rec, id) {
			//findData()
		});

function findData() {
	var locSetDr = Ext.getCmp('locSetField').getValue();
	var interMethodDr = Ext.getCmp('interMethodField').getValue();

	var surl = ''
	if (interMethodDr == '') {
		surl = incomecollectUrl + '?action=list&CycleDr=' + cycleField.getValue()
				+ '&frequency=' + periodTypeField.getValue() + '&period='
				+ periodField.getValue() + '&locSetDr=' + locSetDr
	} else {
		surl = incomecollectUrl + '?action=list&CycleDr=' + cycleField.getValue()
				+ '&frequency=' + periodTypeField.getValue() + '&period='
				+ periodField.getValue() + '&locSetDr=' + locSetDr
				+ '&interMethodDr=' + interMethodDr
	}
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
	var locSetDr = Ext.getCmp('locSetField').getValue();
	var locSetName = Ext.getCmp('locSetField').getRawValue();
	var cycleDr = Ext.getCmp('cycleField').getValue();
	var interMethodDr = Ext.getCmp('interMethodField').getValue();
	var periodType = Ext.getCmp('periodTypeField').getValue();
	var period = Ext.getCmp('periodField').getValue();

	var rtnStatus = '-1'

	Ext.Ajax.request({
				url : incomecollectUrl + '?action=ImportStatus&CycleDr=' + cycleDr
						+ '&interMethodDr=' + interMethodDr + '&period='
						+ periodType + period + '&locSetDr=' + locSetDr,
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
