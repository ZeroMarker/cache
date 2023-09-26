/**
 * name:tab of database author:why Date:2011-01-14
 */

function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}

// ========================================================================================

var value = "http: //www.baidu.com";

function DomUrl() {

	return "<a href=>" + value + "</a>";
}
// ========================================================================================

// ���𷽰�
var SchemeDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

SchemeDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : StratagemTabUrl + '?action=schemelist&str='
								+ Ext.getCmp('SchemeField').getRawValue(),
						method : 'POST'
					})
		});

var SchemeField = new Ext.form.ComboBox({
			id : 'SchemeField',
			fieldLabel : '���𷽰�',
			width : 150,
			listWidth : 200,
			allowBlank : false,
			store : SchemeDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'SchemeField',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : false,
			forceSelection : 'true',
			editable : true
		});

// �����ͺ��㵥Ԫ����
SchemeField.on("select", function(cmb, rec, id) {
	searchFun(cmb.getValue());
	// tmpStr=cmb.getValue();
	UnitField.setValue("");
	UnitField.setRawValue("");
	UnitDs.load({
				params : {
					start : 0,
					limit : StratagemTabPagingToolbar.pageSize
				}
			});
		// unitdeptDs.load({params:{start:0,
		// limit:StratagemTabPagingToolbar.pageSize}});
	});

function searchFun(SetCfgDr) {
	UnitDs.proxy = new Ext.data.HttpProxy({
				url : '../csp/targetcalculateparamexe.csp?action=suunit&str='
						+ Ext.getCmp('UnitField').getRawValue() + '&SchemeID='
						+ Ext.getCmp('SchemeField').getValue(),
				method : 'POST'
			});
	UnitDs.load({
				params : {
					start : 0,
					limit : StratagemTabPagingToolbar.pageSize
				}
			});
};
// ���㵥Ԫ���
var UnitTypeDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

UnitTypeDs.on('beforeload', function(ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
		//url : '../csp/dhc.bonus.bonusunittypeexe.csp?action=list&start=0&limit=10&sort=code&dir=ASC',
		url : StratagemTabUrl+'?action=sUnitTyp&start=0&limit=10',

		method : 'POST'
	})
});

var UnitTypeField = new Ext.form.ComboBox({
			id : 'UnitTypeField',
			fieldLabel : '��Ԫ���',
			width : 120,
			listWidth : 200,
			allowBlank : false,
			store : UnitTypeDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'UnitTypeField',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : false,
			forceSelection : 'true',
			editable : true,
			listeners : {
				specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (UnField.getValue() != "") {
							TarField.focus();
						} else {
							Handler = function() {
								TarField.focus();
							}
							Ext.Msg.show({
										title : '����',
										msg : '���㵥Ԫ����Ϊ��!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR,
										fn : Handler
									});
						}
					}
				}
			}
		});

// �������Ԫ����
UnitTypeField.on("select", function(cmb, rec, id) {
			// searchFun(cmb.getValue());
			UnitField.setValue("");
			UnitField.setRawValue("");
			UnitDs.load({
						params : {
							start : 0,
							limit : StratagemTabPagingToolbar.pageSize
						}
					});

		});
// ���㵥Ԫ�ϼ�
var UnitSuperDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

UnitSuperDs.on('beforeload', function(ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
		url : '../csp/dhc.bonus.bonusunitexe.csp?action=UnitList&start=0&limit=10&LastStage=0',

		method : 'POST'
	})
});

var UnitSuperField = new Ext.form.ComboBox({
			id : 'UnitSuperField',
			fieldLabel : '��������',
			width : 120,
			listWidth : 210,
			allowBlank : false,
			store : UnitSuperDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'UnitSuperField',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : false,
			forceSelection : 'true',
			editable : true,
			listeners : {
				specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (UnField.getValue() != "") {
							TarField.focus();
						} else {
							Handler = function() {
								TarField.focus();
							}
							Ext.Msg.show({
										title : '����',
										msg : '������λ����Ϊ��!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR,
										fn : Handler
									});
						}
					}
				}
			}
		});

// �������Ԫ����
UnitSuperField.on("select", function(cmb, rec, id) {
			// searchFun(cmb.getValue());
			UnitField.setValue("");
			UnitField.setRawValue("");
			UnitDs.load({
						params : {
							start : 0,
							limit : StratagemTabPagingToolbar.pageSize
						}
					});

		});

// ���㵥Ԫ
var UnitDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

UnitDs.on('beforeload', function(ds, o) {

			// encodeURIComponent unitSuperID
			ds.proxy = new Ext.data.HttpProxy({
						url : StratagemTabUrl + '?action=suunit&str='
								+ (Ext.getCmp('UnitField').getRawValue())
								+ '&SchemeID='
								+ Ext.getCmp('SchemeField').getValue()
								+ '&BonusUnitTypeID='
								+ Ext.getCmp('UnitTypeField').getValue()
								+ '&unitSuperID='
								+ Ext.getCmp('UnitSuperField').getValue(),
						method : 'POST'
					})
		});

var UnitField = new Ext.form.ComboBox({
			id : 'UnitField',
			fieldLabel : '���㵥Ԫ',
			width : 100,
			listWidth : 200,
			allowBlank : false,
			store : UnitDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'UnitField',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : false,
			forceSelection : 'true',
			editable : true
		});
// ����ָ��
var TargetDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

TargetDs.on('beforeload', function(ds, o) {
			// prompt('sss',StratagemTabUrl+'?action=stunit&str='+Ext.getCmp('TargetField').getRawValue()+'&SchemeID='+Ext.getCmp('SchemeField').getValue())
			ds.proxy = new Ext.data.HttpProxy({
						url : StratagemTabUrl + '?action=stunit&str='
								+ Ext.getCmp('TargetField').getRawValue()
								+ '&SchemeID='
								+ Ext.getCmp('SchemeField').getValue(),
						method : 'POST'
					})
		});

var TargetField = new Ext.form.ComboBox({
			id : 'TargetField',
			fieldLabel : '����ָ��',
			width : 120,
			listWidth : 200,
			allowBlank : false,
			store : TargetDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'TargetField',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : false,
			forceSelection : 'true',
			editable : true
		});
// ������ָ������
SchemeField.on("select", function(cmb, rec, id) {
	searchFun(cmb.getValue());
	// tmpStr=cmb.getValue();
	TargetField.setValue("");
	TargetField.setRawValue("");
	TargetDs.load({
				params : {
					start : 0,
					limit : StratagemTabPagingToolbar.pageSize
				}
			});
		// unitdeptDs.load({params:{start:0,
		// limit:StratagemTabPagingToolbar.pageSize}});
	});

function searchFun(SetCfgDr) {
	TargetDs.proxy = new Ext.data.HttpProxy({
				url : '../csp/targetcalculateparamexe.csp?action=stunit&str='
						+ Ext.getCmp('TargetField').getRawValue()
						+ '&SchemeID=' + Ext.getCmp('SchemeField').getValue(),
				method : 'POST'
			});
	TargetDs.load({
				params : {
					start : 0,
					limit : StratagemTabPagingToolbar.pageSize
				}
			});
};

// ���״̬
var StateDs = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', 'δ���'], ['1', '���']]
		});

var StateField = new Ext.form.ComboBox({
			id : 'StateField',
			fieldLabel : '���״̬',
			width : 80,
			listWidth : 80,
			selectOnFocus : true,
			allowBlank : false,
			store : StateDs,
			// anchor: '90%',
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

// �������Դ
var BonusSchemeID = Ext.getCmp('SchemeField').getValue();
var UnitID = Ext.getCmp('UnitField').getValue();
var TargetID = Ext.getCmp('TargetField').getValue();
var unitType = Ext.getCmp('UnitTypeField').getValue();
var unitSuperID = Ext.getCmp('UnitSuperField').getValue()
/*
 * TargetID : TargetID, UnitID : UnitID, BonusSchemeID : BonusSchemeID,
 * searchField : 'BonusUnitTypeID', searchValue : unitType,
 * unitSuperID :unitSuperID
 */

var StratagemTabUrl = '../csp/dhc.bonus.targetcalculateparamexe.csp';
var StratagemTabProxy = new Ext.data.HttpProxy({
			url : StratagemTabUrl + '?action=list&UnitID=' + UnitID
					+ '&BonusSchemeID=' + BonusSchemeID
					+ '&searchValue=' + unitType
					+ '&unitSuperID=' + unitSuperID
		});
var StratagemTabDs = new Ext.data.Store({
			proxy : StratagemTabProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['rowid', 'BonusSchemeID', 'BonusSchemeName', 'UnitID',
							'UnitName', 'UnitTypeID', 'UnitTypeName',
							'TargetID', 'TargetName', 'TargetUnit',
							'TargetUnitName', 'ParameterTarget',
							'ParameterTargetName', 'AccountBase', 'StepSize',
							'TargetDirection', 'StartLimit', 'EndLimit',
							'TargetRate', 'SchemeState', 'IsValid',
							'unitSuperName'

					]),
			// turn on remote sorting
			remoteSort : true
		});

// ����Ĭ�������ֶκ�������
StratagemTabDs.setDefaultSort('rowid', 'desc');

// ���ݿ�����ģ��
var StratagemTabCm = new Ext.grid.ColumnModel([
		new Ext.grid.CheckboxSelectionModel(), {
			header : '���𷽰�',
			dataIndex : 'BonusSchemeName',
			width : 200,
			sortable : true

		}, {
			header : '����״̬',
			dataIndex : 'SchemeState',
			width : 100,
			sortable : true

		}, {
			header : '�����ϼ�',
			dataIndex : 'unitSuperName',
			width : 90,
			sortable : true

		}, {
			header : '���㵥Ԫ',
			dataIndex : 'UnitName',
			width : 100,
			sortable : true
			// unitSuperName

	}	, {
			header : '��Ԫ���',
			dataIndex : 'UnitTypeName',
			width : 90,
			sortable : true

		}, {
			header : 'ָ������',
			width : 120,
			dataIndex : 'TargetName',
			sortable : true

		}, {
			header : "�����λ",
			dataIndex : 'TargetUnitName',
			width : 80,
			align : 'left',
			sortable : true

		}, {
			header : "����ϵ��",
			dataIndex : 'TargetRate',
			width : 80,
			align : 'right',
			sortable : true
		}]);

// ��ʼ��Ĭ��������
StratagemTabCm.defaultSortable = true;

// ��ѯ��ť
var findButton = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '��ѯ',
			iconCls : 'add',
			handler : function() {
				var BonusSchemeID = Ext.getCmp('SchemeField').getValue();
				var UnitID = Ext.getCmp('UnitField').getValue();
				var TargetID = Ext.getCmp('TargetField').getValue();
				var unitType = Ext.getCmp('UnitTypeField').getValue();
				var unitSuperID = Ext.getCmp('UnitSuperField').getValue()

				// Ext.getCmp('UnitSuperField').getValue()
				if (BonusSchemeID == "") {
					Ext.Msg.show({
								title : '����',
								msg : '���𷽰�Ϊ��',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};

				StratagemTabDs.load({
							params : {
								start : 0,
								limit : 20, // StratagemTabPagingToolbar.pageSize,
								TargetID : TargetID,
								UnitID : UnitID,
								BonusSchemeID : BonusSchemeID,
								searchField : 'BonusUnitTypeID',
								searchValue : unitType,
								unitSuperID : unitSuperID
							}
						});
			}
		});

var DelButton = new Ext.Toolbar.Button({
	text : 'ɾ��',
	tooltip : 'ɾ��',
	iconCls : 'add',
	handler : function() {
		// ���岢��ʼ���ж���
		var rowObj = StratagemTab.getSelections();
		// ���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		// �ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		// alert(len);
		if (len < 1) {
			Ext.Msg.show({
						title : 'ע��',
						msg : '��ѡ����Ҫɾ��������!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
		} else {
			var rowid = rowObj[0].get("rowid");
			var state = rowObj[0].get("SchemeState");
			// alert(state);
			if (state == "������") {
				Ext.Msg.show({
							title : 'ע��',
							msg : '�������ݷ����Ѿ������,������ɾ��!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING
						});
				return false;
			}
		}
		function handler(id) {
			if (id == "yes") {
				for (var i = 0; i < len; i++) {
					Ext.Ajax.request({
						url : '../csp/dhc.bonus.targetcalculateparamexe.csp?action=del&rowid='
								+ rowObj[i].get("rowid"),
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
								var BonusSchemeID = Ext.getCmp('SchemeField')
										.getValue();
								var UnitID = Ext.getCmp('UnitField').getValue();
								var TargetID = Ext.getCmp('TargetField')
										.getValue();
								var unitType = Ext.getCmp('UnitTypeField').getValue();
								var unitSuperID = Ext.getCmp('UnitSuperField').getValue()
								
								StratagemTabDs.load({
									params : {
										start : 0,
										limit : StratagemTabPagingToolbar.pageSize,
										TargetID : TargetID,
										UnitID : UnitID,
										BonusSchemeID : BonusSchemeID,
										searchField : 'BonusUnitTypeID',
										searchValue : unitType,
										unitSuperID : unitSuperID
									}
								});
								/*
								 * 								TargetID : TargetID,
								UnitID : UnitID,
								BonusSchemeID : BonusSchemeID,
								searchField : 'BonusUnitTypeID',
								searchValue : unitType,
								unitSuperID : unitSuperID
								 * */
								
							} else {
								Ext.Msg.show({
											title : '����',
											msg : '���������,ɾ��ʧ��!',
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
		Ext.MessageBox.confirm('��ʾ', 'ȷʵҪɾ��Ŀ���¼��?', handler);
	}
});

// ��ҳ������
var StratagemTabPagingToolbar = new Ext.PagingToolbar({
			store : StratagemTabDs,
			pageSize : 20,
			displayInfo : true,
			displayMsg : '�� {0} ���� {1}�� ��һ�� {2} ��',
			emptyMsg : "û�м�¼"  ,
			// buttons: ['-',StratagemFilterItem,'-',StratagemSearchBox],
			doLoad : function(C) {
				var B = {}, A = this.paramNames;
				B[A.start] = C;
				B[A.limit] = this.pageSize;
				B['BonusSchemeID']=Ext.getCmp('SchemeField').getValue();
			  B['unitSuperID']=Ext.getCmp('UnitSuperField').getValue();
				B['searchField']='BonusUnitTypeID'
				B['searchValue']=Ext.getCmp('UnitTypeField').getValue();
				B['TargetID']=Ext.getCmp('TargetField').getValue();
				B['UnitID']=Ext.getCmp('UnitField').getValue();
					

				if (this.fireEvent("beforechange", this, B) !== false) {
					this.store.load({
								params : B
							});
				}
			}
		});
/**
 * 								TargetID : TargetID,
								UnitID : UnitID,
								BonusSchemeID : BonusSchemeID,
								searchField : 'BonusUnitTypeID',
								searchValue : unitType,
								unitSuperID : unitSuperID
 */
// ����
var StratagemTab = new Ext.grid.EditorGridPanel({
			title : '�̶�ָ������',
			store : StratagemTabDs,
			cm : StratagemTabCm,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.CheckboxSelectionModel({
						singleSelect : false
					}),
			loadMask : true,//
			tbar : ['���𷽰�:', SchemeField, '-', '��Ԫ���:', UnitTypeField, '-',
					'��������:', UnitSuperField, '-', '���㵥Ԫ:', UnitField, '-',
					'����ָ��:', TargetField, '-', findButton, '-', addButton, '-',
					editButton, '-', DelButton],
			bbar : StratagemTabPagingToolbar
		});