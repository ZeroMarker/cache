/**
 * name:tab of database author:why Date:2011-01-14
 */
Ext.QuickTips.init();
// ����ࣺ�����ڿؼ�ĩβ��ʾ������Ϣ
FormPlugin = function(msg) {
	// ���캯�������
	this.init = function(cmp) {
		// �ؼ���Ⱦʱ����
		cmp.on("render", function() {
					cmp.el.insertHtml("afterEnd",
							"<font color='red'>*</font><font color='blue'>"
									+ msg + "</font>");
				});
	}
}
// --------------------------------------------------------------------------------------------//
function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}
var userCode = session['LOGON.USERCODE'];
// -------------------------
var smObj = new Ext.grid.RowSelectionModel({
	moveEditorOnEnter : true,

	onEditorKey : function(field, e) {
		var k = e.getKey(), newCell, g = this.grid, last = g.lastEdit, ed = g.activeEditor, ae, last, r, c;
		var shift = e.shiftKey;

		if (k === TAB) {
			e.stopEvent();
			ed.completeEdit();

			if (shift) {
				newCell = g.walkCells(ed.row, ed.col - 1, -1, this.acceptsNav,
						this);
			} else {

				newCell = g.walkCells(ed.row + 1, ed.col, 1, this.acceptsNav,
						this);
			}
			if (newCell) {
				r = newCell[0];
				c = newCell[1];
				tmpRow = r;
				tmpColumn = c;

				if (g.isEditor && g.editing) { // *** handle tabbing while
					// editorgrid is in edit mode
					ae = g.activeEditor;
					if (ae && ae.field.triggerBlur) {

						ae.field.triggerBlur();
					}
				}
				g.startEditing(r, c);
			}

		}

	}
		// ------------------------------
});
var value = "http: //www.baidu.com";

function DomUrl() {

	return "<a href=>" + value + "</a>";
}
// ========================================================================================
// �������
var BonusyearDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

BonusyearDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : StratagemTabUrl + '?action=yearlist'
					})
		});

var BonusyearField = new Ext.form.ComboBox({
			id : 'BonusyearField',
			fieldLabel : '�������',
			width : 60,
			listWidth : 40,
			allowBlank : false,
			store : BonusyearDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'BonusyearField',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : false,
			forceSelection : 'true',
			editable : true
		});

var periodTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['M', '�·�'], ['Q', '����'], ['H', '����'], ['Y', '���']]
		});
var periodTypeField = new Ext.form.ComboBox({
			id : 'periodTypeField',
			fieldLabel : '�ڼ�����',
			width : 60,
			listWidth : 40,
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
		data = [['0', '00']];
	}
	periodStore.loadData(data);
	searchFun(cmb.getValue());
});
periodStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue']
		});

var periodField = new Ext.form.ComboBox({
			id : 'periodField',
			fieldLabel : '',
			width : 60,
			listWidth : 40,
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
			width : 120,
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
				url : '../csp/bonustargetcollectexe.csp?action=suunit&str='
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
			ds.proxy = new Ext.data.HttpProxy({
						url : StratagemTabUrl + '?action=suunit&str='
								+ Ext.getCmp('UnitField').getRawValue()
								+ '&SchemeID='
								+ Ext.getCmp('SchemeField').getValue(),
						method : 'POST'
					})
		});

var UnitField = new Ext.form.ComboBox({
			id : 'UnitField',
			fieldLabel : '���㵥Ԫ',
			width : 80,
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
			ds.proxy = new Ext.data.HttpProxy({
						url : StratagemTabUrl + '?action=stunit&str='
								+ Ext.getCmp('TargetField').getRawValue()
								+ '&SchemeID='
								+ Ext.getCmp('SchemeField').getValue()
								+ '&userCode=' + session['LOGON.USERCODE'],
						method : 'POST'
					})
		});

var TargetField = new Ext.form.ComboBox({
			id : 'TargetField',
			fieldLabel : '����ָ��',
			width : 80,
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

		});

function searchFun(SetCfgDr) {
	TargetDs.proxy = new Ext.data.HttpProxy({
				url : '../csp/bonustargetcollectexe.csp?action=stunit&str='
						+ Ext.getCmp('TargetField').getRawValue()
						+ '&SchemeID=' + Ext.getCmp('SchemeField').getValue()
						+ '&userCode=' + session['LOGON.USERCODE'],
				method : 'POST'
			});
	TargetDs.load({
				params : {
					start : 0,
					limit : StratagemTabPagingToolbar.pageSize
				}
			});
};
// �������Դ
var StratagemTabUrl = '../csp/dhc.bonus.bonustargetcollectexe.csp';
var StratagemTabProxy = new Ext.data.HttpProxy({
			url : StratagemTabUrl + '?action=list'
		});
var StratagemTabDs = new Ext.data.Store({
			proxy : StratagemTabProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['rowid', 'BonusYear', 'BonusSchemeID', 'BonusPeriod',
							'PeriodName', 'UnitID', 'UnitName', 'TargetID',
							'TargetName', 'TargetValue', 'UpdateDate'

					]),
			// turn on remote sorting
			remoteSort : true
		});

// ����Ĭ�������ֶκ�������
StratagemTabDs.setDefaultSort('rowid', 'desc');

// ���ݿ�����ģ��
var StratagemTabCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
			header : '���㵥Ԫ',
			dataIndex : 'UnitName',
			width : 150,
			sortable : true

		}, {
			header : '�������',
			dataIndex : 'BonusYear',
			width : 100,
			sortable : true
		}, {
			header : '�����ڼ�',
			dataIndex : 'PeriodName',
			width : 100,
			sortable : true
		}, {
			header : '����ָ��',
			width : 150,
			dataIndex : 'TargetName',
			sortable : true

		}, {
			header : "����ָ��ֵ",
			dataIndex : 'TargetValue',
			width : 100,
			align : 'left',
			css : 'background:#d0def0;color:#000000',
			sortable : true,
			editor : new Ext.form.TextField({
						allowBlank : true,
						plugins : new FormPlugin("ָ��ֵΪ����")

					})
		}, {
			header : "¼��ʱ��",
			dataIndex : 'UpdateDate',
			width : 150,
			align : 'left',
			sortable : true

		}, {
			header : "���㵥ԪID",
			dataIndex : 'UnitID',
			width : 150,
			align : 'left',
			hidden : true,
			sortable : true

		}, {
			header : "���㵥ԪID",
			dataIndex : 'TargetID',
			width : 150,
			align : 'left',
			hidden : true,
			sortable : true

		}, {
			header : "���㵥ԪID",
			dataIndex : 'BonusPeriod',
			width : 150,
			align : 'left',
			hidden : true,
			sortable : true

		}

]);

// ��ʼ��Ĭ��������
StratagemTabCm.defaultSortable = true;

// ��ѯ��ť
var findButton = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '��ʼ��',
			iconCls : 'add',
			handler : function() {
				// alert("hell");
				var BonusYear = Ext.getCmp('BonusyearField').getValue();
				var BonusPeriod = Ext.getCmp('periodField').getValue();
				var UnitID = Ext.getCmp('UnitField').getValue();
				var TargetID = Ext.getCmp('TargetField').getValue();
				var BonusSchemeID = Ext.getCmp('SchemeField').getValue();
				if (BonusYear == "") {
					Ext.Msg.show({
								title : '����',
								msg : '�������Ϊ��',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};
				if (BonusPeriod == "") {
					Ext.Msg.show({
								title : '����',
								msg : '��������Ϊ��',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};
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
								limit : StratagemTabPagingToolbar.pageSize,
								BonusYear : BonusYear,
								BonusPeriod : BonusPeriod,
								TargetID : TargetID,
								UnitID : UnitID,
								BonusSchemeID : BonusSchemeID,
								userCode : userCode
							}
						});
			}
		});

// ��ҳ������
var StratagemTabPagingToolbar = new Ext.PagingToolbar({
			store : StratagemTabDs,
			pageSize : 25,
			displayInfo : true,
			displayMsg : '��ǰ��ʾ{0} - {1}������{2}',
			emptyMsg : "û�м�¼",
			// buttons: ['-',StratagemFilterItem,'-',StratagemSearchBox],
			doLoad : function(C) {
				var BonusYear = Ext.getCmp('BonusyearField').getValue();
				var BonusPeriod = Ext.getCmp('periodField').getValue();
				var UnitID = Ext.getCmp('UnitField').getValue();
				var TargetID = Ext.getCmp('TargetField').getValue();
				var BonusSchemeID = Ext.getCmp('SchemeField').getValue();
				var B = {}, A = this.paramNames;
				B[A.start] = C;
				B[A.limit] = this.pageSize;

				if (this.fireEvent("beforechange", this, B) !== false) {
					this.store.load({
								params : {
									start : C,
									limit : this.pageSize,
									BonusYear : BonusYear,
									BonusPeriod : BonusPeriod,
									TargetID : TargetID,
									UnitID : UnitID,
									BonusSchemeID : BonusSchemeID,
									userCode : userCode
								}
							});
				}
			}
		});

// ��ʼ����ť
var uploadButton = new Ext.Toolbar.Button({
			text : 'Excel���ݵ���',
			tooltip : '��������(Excel��ʽ)',
			iconCls : 'add',
			handler : function() {

				importExcel();

				return;

			}

		});

// ���
var StratagemTab = new Ext.grid.EditorGridPanel({
			title : 'ָ������¼��',
			store : StratagemTabDs,
			cm : StratagemTabCm,
			clicksToEdit : 1,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			loadMask : true,
			tbar : ['�����ڼ�:', BonusyearField, '-', periodTypeField, '-',
					periodField, '-', '���𷽰�:', SchemeField, '-', '���㵥Ԫ:',
					UnitField, '-', '����ָ��:', TargetField, '-', findButton, '-',
					uploadButton],
			bbar : StratagemTabPagingToolbar
		});
function afterEdit(rowObj) {

	// ���岢��ʼ���ж��󳤶ȱ���
	var len = rowObj.length;
	// �ж��Ƿ�ѡ����Ҫ�޸ĵ�����
	// var rowid = record.get("rowid");
	var UnitID = rowObj.record.get("UnitID");
	var BonusYear = rowObj.record.get("BonusYear");
	var BonusPeriod = rowObj.record.get("BonusPeriod");
	var TargetID = rowObj.record.get("TargetID");
	var TargetValue = rowObj.record.get("TargetValue");
	var UpdateDate = rowObj.record.get("UpdateDate");
	// alert(record);
	var data = UnitID.trim() + "^" + BonusYear.trim() + "^"
			+ BonusPeriod.trim() + "^" + TargetID.trim() + "^"
			+ TargetValue.trim() + "^" + UpdateDate.trim();
	// alert(data);

	Ext.Ajax.request({
				// url: StratagemTabUrl+'?action=add&data='+data,
				url : StratagemTabUrl + '?action=add&UnitID=' + UnitID
						+ '&BonusYear=' + BonusYear + '&BonusPeriod='
						+ BonusPeriod + '&TargetID=' + TargetID
						+ '&TargetValue=' + TargetValue + '&UpdateDate='
						+ UpdateDate,
				failure : function(result, request) {
					Ext.Msg.show({
								title : '����',
								msg : '������������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						// Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons:
						// Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						var BonusYear = Ext.getCmp('BonusyearField').getValue();
						var BonusPeriod = Ext.getCmp('periodField').getValue();
						var UnitID = Ext.getCmp('UnitField').getValue();
						var TargetID = Ext.getCmp('TargetField').getValue();
						var BonusSchemeID = Ext.getCmp('SchemeField')
								.getValue();
						var userCode = session['LOGON.USERCODE'];
						StratagemTabDs.load({
									params : {
										start : 0,
										limit : StratagemTabPagingToolbar.pageSize,
										BonusYear : BonusYear,
										BonusPeriod : BonusPeriod,
										TargetID : TargetID,
										UnitID : UnitID,
										BonusSchemeID : BonusSchemeID,
										userCode : userCode
									}
								});
						this.store.commitChanges(); // ��ԭ�����޸���

						var view = StratagemTab.getView();
						//view.focusCell(tmpRow, tmpColumn);

					} else {
						var message = "";
						message = "SQLErr: " + jsonData.info;
						// if(jsonData.info=='EmptyRecData') message='���������Ϊ��!';
						if (jsonData.info == 'RepCode')
							message = '����Ĵ����Ѿ�����!';
						if (jsonData.info == 'RepName')
							message = '����������Ѿ�����!';
						Ext.Msg.show({
									title : '����',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
					}
				},
				scope : this
			});

}

// alert("BonusYear="+BonusYear);
StratagemTabDs.load(

{
			params : {
				start : 0,
				limit : StratagemTabPagingToolbar.pageSize,
				BonusYear : Ext.getCmp('BonusyearField').getValue(),
				BonusPeriod : Ext.getCmp('periodField').getValue(),
				TargetID : Ext.getCmp('TargetField').getValue(),
				UnitID : Ext.getCmp('UnitField').getValue(),
				BonusSchemeID : Ext.getCmp('SchemeField'),
				userCode : session['LOGON.USERCODE']
			}
		})
StratagemTab.on("afteredit", afterEdit, StratagemTab);
