/**
 * name:tab of database author:zhaoliguo Date:2011-01-18
 */

function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}

// �������Դ
var BonusPayTabUrl = '../csp/dhc.bonus.paymanagerexe.csp';
var BonusPayTabProxy = new Ext.data.HttpProxy({
			url : BonusPayTabUrl + '?action=list'
		});


var periodStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue']
		});

var data = "";
var StratagemTabUrl = '../csp/dhc.bonus.deptbonuscalcexe.csp';

var periodTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['M', '�·�'], ['Q', '����'], ['H', '����'], ['Y', '���']]
		});

var periodTypeField = new Ext.form.ComboBox({
			id : 'periodTypeField',
			fieldLabel : '�ڼ�����',
			width : 70,
			listWidth : 50,
			selectOnFocus : true,
			allowBlank : false,
			store : periodTypeStore,
			anchor : '90%',
			value : '', // Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
periodTypeField.on("select", function(cmb, rec, id) {
	if (cmb.getValue() == "M") {
		data = [['M01', '01��'], ['M02', '02��'], ['M03', '03��'], ['M04', '04��'],
				['M05', '05��'], ['M06', '06��'], ['M07', '07��'], ['M08', '08��'],
				['M09', '09��'], ['M10', '10��'], ['M11', '11��'], ['M12', '12��']];
	}
	if (cmb.getValue() == "Q") {
		data = [['Q01', '01����'], ['Q02', '02����'], ['Q03', '03����'],
				['Q04', '04����']];
	}
	if (cmb.getValue() == "H") {
		data = [['H01', '�ϰ���'], ['H02', '�°���']];
	}
	if (cmb.getValue() == "Y") {
		data = [['Y00', '00']];
	}
	periodStore.loadData(data);

});

var periodField = new Ext.form.ComboBox({
			id : 'periodField',
			fieldLabel : '�����ڼ�',
			width : 70,
			listWidth : 50,
			selectOnFocus : true,
			allowBlank : false,
			store : periodStore,
			anchor : '90%',
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});

var cycleDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'BonusYear'])
		});

cycleDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : StratagemTabUrl
								+ '?action=yearlist&topCount=5&orderby=Desc',
						method : 'POST'
					})
		});

var periodYear = new Ext.form.ComboBox({
			id : 'periodYear',
			fieldLabel : '�������',
			width : 70,
			listWidth : 50,
			selectOnFocus : true,
			allowBlank : false,
			store : cycleDs,
			anchor : '90%',
			value : '', // Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'BonusYear',
			valueField : 'BonusYear',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
periodYear.on("select", function(cmb, rec, id) {

			if (Ext.getCmp('periodField').getValue() != '')
				schemDs.load({
							params : {
								bonusYear : Ext.getCmp('periodYear').getValue(),
								bonusPeriod : Ext.getCmp('periodField')
										.getValue(),

								schemeType : p_SchemeType,
								start : 0,
								limit : schemPagingToolbar.pageSize
							}
						});
		});
		
	var unitDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'name'])
			});

	var bonusUnitField = new Ext.form.ComboBox({
				id : 'bonusUnitField',
				fieldLabel : '���㵥Ԫ',
				width : 100,
				listWidth : 100,
				selectOnFocus : true,
				allowBlank : false,
				store : unitDs,
				anchor : '90%',
				value : '', // Ĭ��ֵ
				// valueNotFoundText : rowObj[0].get("appSysName"),
				displayField : 'name',
				valueField : 'rowid',
				triggerAction : 'all',
				emptyText : '',
				mode : 'local', // ����ģʽ
				editable : false,
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true,
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (appField.getValue() != "") {
								descField.focus();
							} else {
								Handler = function() {
									appField.focus();
								}
								Ext.Msg.show({
											title : '����',
											msg : 'Ӧ��ϵͳ���벻��Ϊ��!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR,
											fn : Handler
										});
							}
						}
					}
				}
			});
	unitDs.on('beforeload', function(ds, o) {

				ds.proxy = new Ext.data.HttpProxy({
						url : '../csp/dhc.bonus.bonusunitexe.csp'
									+ '?action=lastunit&sUnitFlag=1&LastStage=0',
							method : 'POST'
						})
			});

var BonusPayTabDs = new Ext.data.Store({
			proxy : BonusPayTabProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['rowID', 'BonusEmployeeID', 'EmployeeName',
							'BonusUnitID', 'BonusUnitName', 'BonusValue',
							'BonusYear', 'BonusPeriod','PeriodCode', 'UpdateDate']),

			remoteSort : true
		});

// ����Ĭ�������ֶκ�������

   BonusPayTabDs.setDefaultSort('rowID', 'desc');

// ���ݿ�����ģ��

var BonusPayTabCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
			header : 'rowID',
			dataIndex : 'rowID',
			width : 100,
			 hidden : true,
			sortable : true
		}, {
			header : '��ԱID',
			dataIndex : 'BonusEmployeeID',
			width : 100,
			hidden : true,
			sortable : true
		}, {
			header : '��ȡ��Ա',
			dataIndex : 'EmployeeName',
			width : 100,
			sortable : true
		}, {
			header : "���㵥ԪID",
			dataIndex : 'BonusUnitID',
			width : 120,
			align : 'left',
			hidden : true,
			sortable : true
		}, {
			header : "�������㵥Ԫ",
			dataIndex : 'BonusUnitName',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			header : "���ý���",
			dataIndex : 'BonusValue',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "�������",
			dataIndex : 'BonusYear',
			width : 80,
			align : 'left',
			sortable : true
	}	, {
			header : "�����ڼ�",
			dataIndex : 'BonusPeriod',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "�����ڼ�Code",
			dataIndex : 'PeriodCode',
			width : 100,
			hidden : true,
			align : 'left',
			sortable : true
		}, {
			header : '����ʱ��',
			width : 150,
			dataIndex : 'UpdateDate'

		}]);

// ��ʼ��Ĭ��������
BonusPayTabCm.defaultSortable = true;

// ��ѯ��ť
var findDimensType = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '���ݲ�ѯ',
			iconCls : 'add',
			handler : function() {

				var sbonusPeriod = Ext.getCmp('periodField').getValue();
				var sbonusYear = Ext.getCmp('periodYear').getValue();
				var sbonusUnit = Ext.getCmp('bonusUnitField').getValue();
				if (sbonusYear == "") {
					Ext.Msg.show({
								title : 'ע��',
								msg : '��ѡ��������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
					return;
				}
				if (sbonusPeriod == "") {
					Ext.Msg.show({
								title : 'ע��',
								msg : '��ѡ������ڼ�!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
					return;
				}

				BonusPayTabDs.load({
							params : {
								bonusYear : Ext.getCmp('periodYear').getValue(),
								bonusPeriod : Ext.getCmp('periodField')
										.getValue(),
								bonusUnit : Ext.getCmp('bonusUnitField').getValue(),
								start : 0,
								limit : BonusPayTabPagingToolbar.pageSize
							}
						});

			}
		})

// �޸İ�ť
var editDimensType = new Ext.Toolbar.Button({
			text : '�޸�',
			tooltip : '�޸Ľ���',
			iconCls : 'add',
			handler : function() {
				editBonus()
			}

		});
// ��Ӱ�ť
var addBonusBotton = new Ext.Toolbar.Button({
			text : '���',
			tooltip : '��ӽ���',
			iconCls : 'add',
			handler : function() {
				addBotton()
			}
		})
// ɾ����ť
var delDimensType = new Ext.Toolbar.Button({
	text : 'ɾ��',
	tooltip : 'ɾ������',
	iconCls : 'remove',
	handler : function() {
		// ���岢��ʼ���ж���
		var rowObj = BonusPay.getSelections();
		// ���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		// �ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if (len < 1) {
			Ext.Msg.show({
						title : 'ע��',
						msg : '��ѡ����Ҫɾ��������!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
		} else {
			var rowid = rowObj[0].get("rowID");
		}
		function handler(id) {
			if (id == "yes") {
				var isInner = rowObj[0].get("isInner");
				// �ж��Ƿ�����������,�����������ɾ��,������Ա�ɾ��

				Ext.Ajax.request({
					url : '../csp/dhc.bonus.paymanagerexe.csp?action=del&rowid='
							+ rowid,
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
						if (jsonData.success == 'true') {
							Ext.Msg.show({
										title : 'ע��',
										msg : 'ɾ���ɹ�!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.INFO
									});

							// ���¼���ҳ��
						BonusPayTabDs.load({
							params : {
								bonusYear : Ext.getCmp('periodYear').getValue(),
								bonusPeriod : Ext.getCmp('periodField')
										.getValue(),
								bonusUnit : Ext.getCmp('bonusUnitField').getValue(),
								start : 0,
								limit : BonusPayTabPagingToolbar.pageSize
							}
						});
		
									
									
						} else {
							Ext.Msg.show({
										title : '����',
										msg : 'ɾ��ʧ��!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						}
					},
					scope : this
				});
			}

		}
		Ext.MessageBox.confirm('��ʾ', 'ȷʵҪɾ��������¼��?', handler);
	}
});


// ��ҳ������
var BonusPayTabPagingToolbar = new Ext.PagingToolbar({
			store : BonusPayTabDs,
			pageSize : 25,
			displayInfo : true,
			displayMsg : '�� {0} ���� {1}�� ��һ�� {2} ��',
			emptyMsg : "û�м�¼"
			// ,buttons : ['-', DimensTypeFilterItem, '-', DimensTypeSearchBox]
		});

// ���
var BonusPay = new Ext.grid.EditorGridPanel({
			title : '��Ա����������',
			store : BonusPayTabDs,
			cm : BonusPayTabCm,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			loadMask : true,
			tbar : ['�������:', periodYear, '-', '�ڼ�����:', periodTypeField, '-',
					'�����ڼ�:', periodField, '���㵥Ԫ��','-',bonusUnitField,'-', findDimensType, '-',
					addBonusBotton, '-', editDimensType, '-', delDimensType],
			bbar : BonusPayTabPagingToolbar
		});

// ����
BonusPayTabDs.load({
			params : {
				start : 0,
				limit : BonusPayTabPagingToolbar.pageSize
			}
		});
