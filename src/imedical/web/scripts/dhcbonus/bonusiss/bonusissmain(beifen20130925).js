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
});
var value = "http: //www.baidu.com";

function DomUrl() {

	return "<a href=>" + value + "</a>";
}

var tabUrl = '../csp/dhc.bonus.bonustargetcollectexe.csp';
var userCode = session['LOGON.USERCODE'];
// �������
var yearDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

yearDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : tabUrl + '?action=yearlist'
					})
		});

var yearField = new Ext.form.ComboBox({
			id : 'yearField',
			fieldLabel : '�������',
			width : 60,
			listWidth : 40,
			allowBlank : false,
			store : yearDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
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
// ������Ŀ
var itemDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

itemDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : '../csp/dhc.bonus.bonusissexe.csp?action=itemlist&year='
								+ Ext.getCmp('yearField').getValue()
								+ '&period='
								+ Ext.getCmp('periodField').getValue()
								+ '&userCode=' + userCode
					})
		});

var itemField = new Ext.form.ComboBox({
			id : 'itemField',
			fieldLabel : '��������',
			width : 150,
			listWidth : 150,
			allowBlank : false,
			store : itemDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : false,
			forceSelection : 'true',
			editable : true
		});

var queryButton = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '��ѯ',
			iconCls : 'option',
			handler : function() {
				var year = Ext.getCmp('yearField').getValue();
				if (year == "") {
					Ext.Msg.show({
								title : '��ʾ',
								msg : '��ѡ�����!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.INFOR
							});
					return;
				}
				var period = Ext.getCmp('periodField').getValue();
				if (period == "") {
					Ext.Msg.show({
								title : '��ʾ',
								msg : '��ѡ���ڼ�!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.INFOR
							});
					return;
				}
				var itemId = Ext.getCmp('itemField').getValue();
				scheme1Ds.load({
							params : {
								start : 0,
								limit : schemePagingToolbar.pageSize,
								itemId : itemId,
								year : year,
								period : period,
								userCode : userCode
							}
						});
			}
		});
var upButton = new Ext.Toolbar.Button({
			text : '���ȷ��',
			tooltip : 'ȷ�Ϻ����ƽ����˷��ţ��������ٵ�����',
			iconCls : 'option',
			handler : function() {

				var obj = scheme1Main.getSelections();

				var len = obj.length;
				// �ж��Ƿ�ѡ����Ҫ�޸ĵ�����
				if (len < 1) {
					Ext.Msg.show({
								title : 'ע��',
								msg : '��ѡ����Ҫ�ϱ�������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
					return;
				}

				var upFlag = obj[0].get("upStatus");
				if (upFlag == "���ϱ�") {
					Ext.Msg.show({
								title : '��ʾ',
								msg : '�����Ѿ��ϱ�����Ҫ�ٱ�!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.INFO
							});
					return;
				}

				var rowObj = scheme1Main.getSelections();
				var total = rowObj[0].get("downmoeny");
				var rowid = rowObj[0].get("rowid");
				Ext.Ajax.request({
							url : '../csp/dhc.bonus.bonusissexe.csp?action=yz&rowid='
									+ rowid + '&total=' + total,
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
									Ext.MessageBox.confirm('��ʾ',
											'��֤�ɹ�,ȷ��Ҫ�ϱ�������?', callback);
								} else {
									Ext.Msg.show({
												title : '�ϱ�ʧ��',
												msg : jsonData.info,
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR
											});
									return;
								}
							},
							scope : this
						});
			}
		});
var schemeValue = new Array({
			header : '����ID',
			dataIndex : 'rowid'
		}, {
			header : '����ID',
			dataIndex : 'locId'
		}, {
			header : '�������',
			dataIndex : 'locName'
		}, {
			header : '��ĿID',
			dataIndex : 'itemId'
		}, {
			header : '��Ŀ����',
			dataIndex : 'itemName'
		}, {
			header : '������',
			dataIndex : 'downmoeny'
		}, {
			header : '���״̬',
			dataIndex : 'upStatus'
		}, {
			header : '���ʱ��',
			dataIndex : 'upTime'
		}, {
			header : '�����ID',
			dataIndex : 'upPersonId'
		}, {
			header : '�����Ա',
			dataIndex : 'upPersonName'
		}, {
			header : '�������',
			dataIndex : 'bonusYear'
		}, {
			header : '�����·�',
			dataIndex : 'bonusPeriod'
		});
var schemeUrl = 'dhc.bonus.bonusissexe.csp';
var schemeProxy = new Ext.data.HttpProxy({
			url : schemeUrl + '?action=locinfo'
		});

var scheme1Ds = new Ext.data.Store({
			proxy : schemeProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, [schemeValue[0].dataIndex, schemeValue[1].dataIndex,
							schemeValue[2].dataIndex, schemeValue[3].dataIndex,
							schemeValue[4].dataIndex, schemeValue[5].dataIndex,
							schemeValue[6].dataIndex, schemeValue[7].dataIndex,
							schemeValue[8].dataIndex, schemeValue[9].dataIndex,
							schemeValue[10].dataIndex,
							schemeValue[11].dataIndex,'schemeName']),
			remoteSort : true
		});

scheme1Ds.setDefaultSort('rowid', 'Desc');

var inDeptsCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
			header : schemeValue[10].header,
			dataIndex : schemeValue[10].dataIndex,
			width : 60,
			align : 'left',
			sortable : true
		}, {
			header : schemeValue[11].header,
			dataIndex : schemeValue[11].dataIndex,
			width : 60,
			align : 'left',
			sortable : true
		}, {
			header : '�������',
			dataIndex : 'locName',
			width : 60,
			align : 'left',
			sortable : true
		}, 
			{
			header : '������㷽��',
			dataIndex : 'schemeName',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : schemeValue[4].header,
			dataIndex : schemeValue[4].dataIndex,
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : schemeValue[5].header,
			dataIndex : schemeValue[5].dataIndex,
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : schemeValue[6].header,
			dataIndex : schemeValue[6].dataIndex,
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : schemeValue[7].header,
			dataIndex : schemeValue[7].dataIndex,
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : schemeValue[9].header,
			dataIndex : schemeValue[9].dataIndex,
			width : 60,
			align : 'right',
			sortable : true
		}]);

var schemePagingToolbar = new Ext.PagingToolbar({
			pageSize : 25,
			store : scheme1Ds,
			displayInfo : true,
			displayMsg : '��ǰ��ʾ{0} - {1}������{2}',
			emptyMsg : "û������",
			doLoad : function(C) {
				var B = {}, A = this.paramNames;
				B[A.start] = C;
				B[A.limit] = this.pageSize;
				B['period'] = Ext.getCmp('periodField').getValue();
				B['itemId'] = Ext.getCmp('itemField').getValue();
				B['userCode'] = userCode;
				B['year'] = Ext.getCmp('yearField').getValue();
				B['dir'] = "desc";
				B['sort'] = "rowid";
				if (this.fireEvent("beforechange", this, B) !== false) {
					this.store.load({
								params : B
							});
				}
			}
		});

var schemeSM = new Ext.grid.RowSelectionModel({
			singleSelect : true
		});

var scheme1Main = new Ext.grid.GridPanel({
			title : '�����·�����¼',
			region : 'north',
			// width:600,
			height : 300,
			store : scheme1Ds,
			cm : inDeptsCm,
			trackMouseOver : true,
			stripeRows : true,
			sm : schemeSM,
			loadMask : true,
			viewConfig : {
				forceFit : true
			},
			tbar : ['���', yearField, '-', '���', periodTypeField, '-', '�ڼ�',
					periodField, '-', '��������', itemField, '-', queryButton, '-',
					upButton],
			bbar : schemePagingToolbar
		});

var tmpSelectedScheme = '';
var itemDr = "";
var locid = "";
var syear= ""
var speriod=""
scheme1Main.on('rowclick', function(grid, rowIndex, e) {
			var selectedRow = scheme1Ds.data.items[rowIndex];
			tmpSelectedScheme = selectedRow.data['rowid'];
			locid = selectedRow.data['locId']; // ����ID
			itemDr = selectedRow.data['itemId'];
			syear = Ext.getCmp('yearField').getValue(),
			speriod = Ext.getCmp('periodField').getValue()
							
			if (itemDr == "") {
				Ext.Msg.show({
							title : '��ʾ',
							msg : '��ĿΪ��!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFOR
						});
				return;
			}
			if (tmpSelectedScheme == "") {
				Ext.Msg.show({
							title : '��ʾ',
							msg : '�����¼Ϊ��!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFOR
						});
				return;
			}
			scheme02Ds.proxy = new Ext.data.HttpProxy({
						url : scheme02Url + '?action=detail&parent=' + locid
								+ '&itemId=' + itemDr
					});
			scheme02Ds.load({
						params : {
							start : 0,
							limit : scheme02PagingToolbar.pageSize,
							year : Ext.getCmp('yearField').getValue(),
							period : Ext.getCmp('periodField').getValue()
						}
					});
		});

var scheme02Value = new Array({
			header : '����ID',
			dataIndex : 'rowid'
		}, {
			header : '���',
			dataIndex : 'year'
		}, {
			header : '�ڼ�',
			dataIndex : 'period'
		}, {
			header : '��ԱID',
			dataIndex : 'personId'
		}, {
			header : '��Ա����',
			dataIndex : 'personName'
		}, {
			header : '������',
			dataIndex : 'downmoeny'
		}, {
			header : '�������',
			dataIndex : 'tzmoeny'
		}, {
			header : '��������',
			dataIndex : 'upmoney'
		}, {
			header : '��ĿID',
			dataIndex : 'itemId'
		}, {
			header : '��Ŀ����',
			dataIndex : 'itemName'
		}, {
			header : '����ʱ��',
			dataIndex : 'adjustDate'
		}, {
			header : '������ID',
			dataIndex : 'adjustPersonId'
		}, {
			header : '������Ա',
			dataIndex : 'adjustPersonName'
		}, {
			header : '��Ա����',
			dataIndex : 'UnitCode'
		}, {
			header : '���ݱ�ʶ',
			dataIndex : 'NewEmp'
		}, {
			header : '��������',
			dataIndex : 'adjRate'
		}, {
			header : '������',
			dataIndex : 'Remark'
		}

);

var scheme02Url = 'dhc.bonus.bonusissexe.csp';
var scheme02Ds = new Ext.data.Store({
			proxy : '',
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, [scheme02Value[0].dataIndex, scheme02Value[1].dataIndex,
							scheme02Value[2].dataIndex,
							scheme02Value[3].dataIndex,
							scheme02Value[4].dataIndex,
							scheme02Value[5].dataIndex,
							scheme02Value[6].dataIndex,
							scheme02Value[7].dataIndex,
							scheme02Value[8].dataIndex,
							scheme02Value[9].dataIndex,
							scheme02Value[10].dataIndex,
							scheme02Value[11].dataIndex,
							scheme02Value[12].dataIndex,
							scheme02Value[13].dataIndex,
							scheme02Value[14].dataIndex,
							scheme02Value[15].dataIndex,
							scheme02Value[16].dataIndex]),
			remoteSort : true
		});

scheme02Ds.setDefaultSort('BonusUnitCode', 'Desc');

var inDeptsCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
			header : scheme02Value[1].header,
			dataIndex : scheme02Value[1].dataIndex,
			width : 60,
			align : 'left',
			sortable : true
		}, {
			header : scheme02Value[2].header,
			dataIndex : scheme02Value[2].dataIndex,
			width : 60,
			align : 'left',
			sortable : true
		}, {
			header : scheme02Value[13].header,
			dataIndex : scheme02Value[13].dataIndex,
			width : 60,
			align : 'left',
			sortable : true
		}, {
			header : scheme02Value[4].header,
			dataIndex : scheme02Value[4].dataIndex,
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : scheme02Value[9].header,
			dataIndex : scheme02Value[9].dataIndex,
			width : 100,
			align : 'center',
			sortable : true
		}, {
			header : scheme02Value[5].header,
			dataIndex : scheme02Value[5].dataIndex,
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : scheme02Value[6].header,
			dataIndex : scheme02Value[6].dataIndex,
			width : 100,
			align : 'right',
			css : 'background:#d0def0;color:#000000',
			sortable : true,
			editor : new Ext.form.TextField({
						allowBlank : true,
						plugins : new FormPlugin("ָ��ֵΪ����")
					})
		}, {
			header : scheme02Value[7].header,
			dataIndex : scheme02Value[7].dataIndex,
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : scheme02Value[15].header,
			dataIndex : scheme02Value[15].dataIndex,
			width : 70,
			align : 'center',
			sortable : true
		}, {
			header : scheme02Value[10].header,
			dataIndex : scheme02Value[10].dataIndex,
			width : 160,
			align : 'center',
			sortable : true
		}, {
			header : scheme02Value[12].header,
			dataIndex : scheme02Value[12].dataIndex,
			width : 100,
			align : 'center',
			sortable : true
		}, {
			header : scheme02Value[14].header,
			dataIndex : scheme02Value[14].dataIndex,
			width : 60,
			align : 'center',
			sortable : true
		}, {
			header : scheme02Value[16].header,
			dataIndex : scheme02Value[16].dataIndex,
			width : 120,
			align : 'left',
			sortable : true
		}]);

var scheme02PagingToolbar = new Ext.PagingToolbar({
			pageSize : 25,
			store : scheme02Ds,
			displayInfo : true,
			displayMsg : '��ǰ��ʾ{0} - {1}������{2}',
			emptyMsg : "û������",
			doLoad : function(C) {
				var B = {}, A = this.paramNames;
				B[A.start] = C;
				B[A.limit] = this.pageSize;
				B['parent'] = locid;
				B['period'] = Ext.getCmp('periodField').getValue();
				B['itemId'] = itemDr;
				B['year'] = Ext.getCmp('yearField').getValue();
				B['dir'] = "desc";
				B['sort'] = "rowid";
				if (this.fireEvent("beforechange", this, B) !== false) {
					this.store.load({
								params : B
							});
				}
			}
		});

var codeField = new Ext.form.TextField({
			id : 'codeField',
			name : 'code',
			fieldLabel : '��������',
			allowBlank : false,
			emptyText : '����',
			anchor : '100%'
		});

var nameField = new Ext.form.TextField({
			id : 'nameField',
			name : 'name',
			fieldLabel : '��������',
			allowBlank : false,
			emptyText : '����',
			anchor : '100%'
		});

var descField = new Ext.form.TextField({
			id : 'descField',
			name : 'desc',
			fieldLabel : '��������',
			emptyText : '',
			anchor : '100%'
		});

// ��֤
var yzButton = new Ext.Toolbar.Button({
			text : '������֤',
			tooltip : '������֤',
			iconCls : 'add',
			handler : function() {
				var rowObj = scheme1Main.getSelections();
				var total = rowObj[0].get("downmoeny");
				var rowid = rowObj[0].get("rowid");
				// alert(total)
				Ext.Ajax.request({
							url : '../csp/dhc.bonus.bonusissexe.csp?action=yz&rowid='
									+ rowid + '&total=' + total,
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
												title : '��ʾ',
												msg : '��֤�ɹ�!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO
											});
								} else {
									Ext.Msg.show({
												title : '����',
												msg : jsonData.info,
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR
											});
								}
							},
							scope : this
						});
			}
		});
function callback(id) {
	if (id == "yes") {
		var rowObj = scheme1Main.getSelections();
		var rowid = rowObj[0].get("rowid");
		
		Ext.Ajax.request({
			url : '../csp/dhc.bonus.bonusissexe.csp?action=up&rowid=' + rowid
					+ '&userCode=' + userCode,
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
					Ext.Msg.show({
								title : '��ʾ',
								msg : '�����ϱ��ɹ�!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.INFO
							});
					scheme1Ds.load({
								params : {
									start : 0,
									limit : schemePagingToolbar.pageSize,
									itemId : Ext.getCmp('itemField').getValue(),
									year : Ext.getCmp('yearField').getValue(),
									period : Ext.getCmp('periodField').getValue(),
									userCode : userCode
								}
							});
				} else {
					Ext.Msg.show({
								title : '��ʾ',
								msg : '�����ϱ�ʧ��!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.INFO
							});
				}
			},
			scope : this
		});
	} else {
		return;
	}
}

// ������Ա�·�����
var uploadButton = new Ext.Toolbar.Button({
			text : 'Excel���ݵ���',
			tooltip : '��������(Excel��ʽ)',
			iconCls : 'add',
			handler : function() {

				importExcel();

				return;

			}

		});
// ��Ӱ�ť
var addButton = new Ext.Toolbar.Button({
	text : '���',
	tooltip : '���',
	iconCls : 'add',
	handler : function() {

		var obj = scheme1Main.getSelections();
		var upFlag = obj[0].get("upStatus");
		if (upFlag == "���ϱ�") {
			Ext.Msg.show({
						title : '��ʾ',
						msg : '�Ѿ��ϱ������ݲ��������!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return;
		}

		var rowObj = scheme1Main.getSelections();
		// ���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		// �ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if (len < 1) {
			Ext.Msg.show({
						title : 'ע��',
						msg : '��ѡ����Ҫ����������!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
		} else {
			var rowid = rowObj[0].get("rowid");
		}
		var year = rowObj[0].get("bonusYear");
		var month = rowObj[0].get("bonusPeriod");
		var itemID = rowObj[0].get("itemId");
		var itemName = rowObj[0].get("itemId");
		var SchemeItemID = rowObj[0].get("locId");
		var SupUnitID = rowObj[0].get("locId");
		var SupUnitName = rowObj[0].get("locName");

		var sdata = ""
		// /mID^AdjustBonus^AdjustPerson^SchemeItemID^SuperiorUnitID
		// ^SupUnitName^BonusUnitCode^BonusUnitName^BonusYear^ userCode
		var yearField = new Ext.form.TextField({
					id : 'yearField',
					fieldLabel : '�������',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					anchor : '90%',
					valueNotFoundText : rowObj[0].get("bonusYear"),
					selectOnFocus : 'true',
					disabled : true
				});
		var monthField = new Ext.form.TextField({
					id : 'monthField',
					fieldLabel : '�����·�',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					anchor : '90%',
					valueNotFoundText : rowObj[0].get("bonusPeriod"),
					selectOnFocus : 'true',
					disabled : true
				});
		var Item1Field = new Ext.form.TextField({
					id : 'Item1Field',
					fieldLabel : '������Ŀ',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					valueNotFoundText : rowObj[0].get("itemName"),
					anchor : '90%',
					selectOnFocus : 'true',
					disabled : true
				});
		var cField = new Ext.form.TextField({
					id : 'cField',
					fieldLabel : '��Ա����',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					emptyText : '������',
					anchor : '90%',
					selectOnFocus : 'true',

					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								if (cField.getValue() != "") {
									nField.focus();
								} else {
									Handler = function() {
										cField.focus();
									}
									Ext.Msg.show({
												title : '����',
												msg : '��Ա���Ų���Ϊ��!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR,
												fn : Handler
											});
								}
							}
						}
					}
				});

		var nField = new Ext.form.TextField({
					id : 'nField',
					fieldLabel : '��Ա����',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					emptyText : '������',
					anchor : '90%',
					selectOnFocus : 'true',
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								if (nField.getValue() != "") {
									unitField.focus();
								} else {
									Handler = function() {
										nField.focus();
									}
									Ext.Msg.show({
												title : '����',
												msg : '��Ա��������Ϊ��!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR,
												fn : Handler
											});
								}
							}
						}
					}
				});
		var aField = new Ext.form.NumberField({
					id : 'aField',
					fieldLabel : '�������',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					emptyText : '0.00',
					anchor : '90%',
					selectOnFocus : 'true'
				});
		var unitDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		unitDs.on('beforeload', function(ds, o) {
					ds.proxy = new Ext.data.HttpProxy({
								url : '../csp/dhc.bonus.bonusiss.csp?action=unit&str='
										+ Ext.getCmp('unitField').getRawValue(),
								method : 'POST'
							})
				});

		var unitField = new Ext.form.ComboBox({
					id : 'unitField',
					fieldLabel : '��������',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : unitDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'unitField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true,
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								addButton.focus();
							}
						}
					}
				});

		// ��ʼ�����
		formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [yearField, monthField, Item1Field, cField, nField,
							aField]
				});
		// ������ unitField,
		formPanel.on('afterlayout', function(panel, layout) {
					this.getForm().loadRecord(rowObj[0]);
					yearField.setValue(year);
					monthField.setValue(month);
					Item1Field.setValue(itemName);
				});
		// ��ʼ����Ӱ�ť
		addButton = new Ext.Toolbar.Button({
					text : '�� ��'
				});

		// ������Ӱ�ť��Ӧ����
		addHandler = function() {

			var code = cField.getValue();
			var name = nField.getValue();
			var unitdr = unitField.getValue();
			var AdjustBonus = aField.getValue();

			if (code == "") {
				Ext.Msg.show({
							title : '����',
							msg : '��Ա���Ų���Ϊ�գ�',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (name == "") {
				Ext.Msg.show({
							title : '����',
							msg : '��Ա��������Ϊ�գ�',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			/*
			 * if (unitdr == "") { Ext.Msg.show({ title : '����', msg :
			 * '�������Ҳ���Ϊ�գ�', buttons : Ext.Msg.OK, icon : Ext.MessageBox.ERROR
			 * }); return; };
			 */

			// /mID^AdjustBonus^AdjustPerson^SchemeItemID^SuperiorUnitID
			// ^SupUnitName^BonusUnitCode^BonusUnitName^BonusYear^
			// alert((name))
			// encodeURIComponent
			sdata = rowid + "^" + AdjustBonus + "^" + userCode + "^" + itemID
					+ "^" + SupUnitID + "^" + SupUnitName + "^" + code + "^"
					+ name + "^" + year + "^" + month
			// alert(sdata)
			// return

			Ext.Ajax.request({
				url : '../csp/dhc.bonus.bonusissexe.csp?action=addNew&sdata='
						+ sdata,
				waitMsg : '������...',
				failure : function(result, request) {
					Handler = function() {
						unitField.focus();
					}
					Ext.Msg.show({
								title : '����',
								msg : '������������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR,
								fn : Handler
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Handler = function() {
							nField.focus();
						}
						Ext.Msg.show({
									title : 'ע��',
									msg : '��ӳɹ�!',
									icon : Ext.MessageBox.INFO,
									buttons : Ext.Msg.OK,
									fn : Handler
								});

			scheme02Ds.proxy = new Ext.data.HttpProxy({
						url : scheme02Url + '?action=detail&parent=' + locid
								+ '&itemId=' + itemDr
					});
			scheme02Ds.load({
						params : {
							start : 0,
							limit : scheme02PagingToolbar.pageSize,
							year : syear,  //Ext.getCmp('yearField').getValue(),
							period :speriod  // Ext.getCmp('periodField').getValue()
						}
					});
						// addwin.close();
					} else {
						var message = "";
						if (jsonData.info == 'RepCode')
							message = '����ı����Ѿ�����!';

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

		// ��ӱ��水ť�ļ����¼�
		addButton.addListener('click', addHandler, false);

		// ��ʼ��ȡ����ť
		cancelButton = new Ext.Toolbar.Button({
					text : 'ȡ��'
				});

		// ����ȡ����ť����Ӧ����
		cancelHandler = function() {
			addwin.close();
		}

		// ���ȡ����ť�ļ����¼�
		cancelButton.addListener('click', cancelHandler, false);

		// ��ʼ������
		addwin = new Ext.Window({
					title : '��Ӽ�¼',
					width : 400,
					height : 300,
					minWidth : 400,
					minHeight : 300,
					layout : 'fit',
					plain : true,
					modal : true,
					bodyStyle : 'padding:5px;',
					buttonAlign : 'center',
					items : formPanel,
					buttons : [addButton, cancelButton]
				});

		// ������ʾ
		addwin.show();
	}
});

// �޸İ�ť
var editButton = new Ext.Toolbar.Button({
	text : '�޸�',
	tooltip : '�޸�',
	iconCls : 'option',
	handler : function() {
		// ���岢��ʼ���ж���
		var rowObj = BonusEmployeeTab.getSelections();
		// ���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		// �ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if (len < 1) {
			Ext.Msg.show({
						title : 'ע��',
						msg : '��ѡ����Ҫ�޸ĵ�����!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
		} else {
			var rowid = rowObj[0].get("rowid");
		}

		var c1Field = new Ext.form.TextField({
					id : 'c1Field',
					fieldLabel : '����',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					valueNotFoundText : rowObj[0].get("code"),
					emptyText : '����...',
					anchor : '90%',
					selectOnFocus : 'true',

					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								if (c1Field.getValue() != "") {
									n1Field.focus();
								} else {
									Handler = function() {
										c1Field.focus();
									}
									Ext.Msg.show({
												title : '����',
												msg : '���벻��Ϊ��!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR,
												fn : Handler
											});
								}
							}
						}
					}
				});

		var n1Field = new Ext.form.TextField({
					id : 'n1Field',
					fieldLabel : '����',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					valueNotFoundText : rowObj[0].get("name"),
					emptyText : '����...',
					anchor : '90%',
					selectOnFocus : 'true',
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								if (n1Field.getValue() != "") {
									unit1Field.focus();
								} else {
									Handler = function() {
										n1Field.focus();
									}
									Ext.Msg.show({
												title : '����',
												msg : '���Ʋ���Ϊ��!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR,
												fn : Handler
											});
								}
							}
						}
					}
				});

		var unit1Ds = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		unit1Ds.on('beforeload', function(ds, o) {

					ds.proxy = new Ext.data.HttpProxy({
								url : '../csp/dhc.bonus.bonusiss.csp?action=unit&str='
										+ Ext.getCmp('unit1Field')
												.getRawValue(),
								method : 'POST'
							})
				});

		var unit1Field = new Ext.form.ComboBox({
					id : 'unit1Field',
					fieldLabel : '�������㵥Ԫ',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : unit1Ds,
					valueField : 'rowid',
					displayField : 'name',
					valueNotFoundText : rowObj[0].get("unitName"),
					triggerAction : 'all',
					emptyText : '��ѡ�������㵥Ԫ...',
					name : 'unit1Field',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',

					editable : true,

					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								editButton.focus();
							}
						}
					}
				});

		// ���岢��ʼ�����
		var formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [c1Field, n1Field, unit1Field]
				});

		// ������
		formPanel.on('afterlayout', function(panel, layout) {
					this.getForm().loadRecord(rowObj[0]);
					c1Field.setValue(rowObj[0].get("code"));
					n1Field.setValue(rowObj[0].get("name"));
					unit1Field.setValue(rowObj[0].get("unitDr"));
				});

		// ���岢��ʼ�������޸İ�ť
		var editButton = new Ext.Toolbar.Button({
					text : '�����޸�'
				});

		// �����޸İ�ť��Ӧ����
		editHandler = function() {

			var code = c1Field.getValue();
			var name = n1Field.getValue();
			code = trim(code);
			name = trim(name);

			if (code == "") {
				Ext.Msg.show({
							title : '����',
							msg : '����Ϊ��',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (name == "") {
				Ext.Msg.show({
							title : '����',
							msg : '����Ϊ��',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			var unitdr = unit1Field.getValue();

			Ext.Ajax.request({
				url : '../csp/dhc.bonus.bonusiss.csp?action=edit&rowid='
						+ rowid + '&code=' + code + '&name=' + name
						+ '&unitdr=' + unitdr,
				waitMsg : '������...',
				failure : function(result, request) {
					Handler = function() {
						activeFlag.focus();
					}
					Ext.Msg.show({
								title : '����',
								msg : '������������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR,
								fn : Handler
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Ext.Msg.show({
									title : 'ע��',
									msg : '�޸ĳɹ�!',
									icon : Ext.MessageBox.INFO,
									buttons : Ext.Msg.OK
								});
						BonusEmployeeTabDs.load({
									params : {
										start : 0,
										limit : BonusEmployeeTabPagingToolbar.pageSize
									}
								});
						editwin.close();
					} else {
						var message = "";
						if (jsonData.info == 'RepCode')
							message = '����Ĵ����Ѿ�����!';

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

		// ��ӱ����޸İ�ť�ļ����¼�
		editButton.addListener('click', editHandler, false);

		// ���岢��ʼ��ȡ���޸İ�ť
		var cancelButton = new Ext.Toolbar.Button({
					text : 'ȡ���޸�'
				});

		// ����ȡ���޸İ�ť����Ӧ����
		cancelHandler = function() {
			editwin.close();
		}

		// ���ȡ����ť�ļ����¼�
		cancelButton.addListener('click', cancelHandler, false);

		// ���岢��ʼ������
		var editwin = new Ext.Window({
					title : '�޸ļ�¼',
					width : 400,
					height : 300,
					minWidth : 400,
					minHeight : 300,
					layout : 'fit',
					plain : true,
					modal : true,
					bodyStyle : 'padding:5px;',
					buttonAlign : 'center',
					items : formPanel,
					buttons : [editButton, cancelButton]
				});

		// ������ʾ
		editwin.show();
	}
});

// ɾ����ť
var delButton = new Ext.Toolbar.Button({
	text : 'ɾ��',
	tooltip : 'ɾ��',
	iconCls : 'remove',
	handler : function() {
		// ���岢��ʼ���ж���

		var obj = scheme1Main.getSelections();
		var upFlag = obj[0].get("upStatus");
		if (upFlag == "���ϱ�") {
			Ext.Msg.show({
						title : '��ʾ',
						msg : '�Ѿ��ϱ������ݲ�����ɾ��!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return;
		}

		var rowObj = scheme02Main.getSelections();
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
			var rowid = rowObj[0].get("rowid");
		}
		function handler(id) {
			if (id == "yes") {

				Ext.Ajax.request({
					url : '../csp/dhc.bonus.bonusissexe.csp?action=del&rowid='
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
			scheme02Ds.proxy = new Ext.data.HttpProxy({
						url : scheme02Url + '?action=detail&parent=' + locid
								+ '&itemId=' + itemDr
					});
			scheme02Ds.load({
						params : {
							start : 0,
							limit : scheme02PagingToolbar.pageSize,
							year : syear, //Ext.getCmp('yearField').getValue(),
							period : speriod //Ext.getCmp('periodField').getValue()
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

			} else {
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ', 'ȷʵҪɾ��������¼��?', handler);
	}
});

var scheme02Main = new Ext.grid.EditorGridPanel({
			title : '�·�������ϸ',
			region : 'center',
			store : scheme02Ds,
			cm : inDeptsCm,
			trackMouseOver : true,
			stripeRows : true,
			clicksToEdit : 1,
			viewConfig : {   
               forceFit : true,   
               getRowClass : function(record,rowIndex,rowParams,store){   
                   //����������ʾ��ɫ   
               	//return 'x-grid-record-red';   
               	var dow =record.data.downmoeny
               	var adj=record.data.tzmoeny
               	var NewEmp=record.data.NewEmp
               	
               	if (dow==0){
               		return 'x-grid-record-blue';  
               	}else
                   if((adj/dow>0.15) ||(adj/dow<-0.15)){   
                       return 'x-grid-record-red';   
                   }else{   
                       return '';   
                   }   
                  }   
            },  

			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			loadMask : true,
			tbar : [addButton, '-', delButton, '-', yzButton],

			bbar : scheme02PagingToolbar
		});
// ,'-',uploadButton editButton, '-','-', upButton
function afterEdit(rowObj) {
	var obj = scheme1Main.getSelections();
	var upFlag = obj[0].get("upStatus");
	if (upFlag == "���ϱ�") {
		Ext.Msg.show({
					title : '��ʾ',
					msg : '�Ѿ��ϱ������ݲ������޸�!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.INFO
				});
		return;
	} else {

		var rowid = rowObj.record.get("rowid");
		var tzmoeny = rowObj.record.get("tzmoeny");
		var downmoeny = rowObj.record.get("downmoeny");
		Ext.Ajax.request({
					url : '../csp/dhc.bonus.bonusissexe.csp?action=update&rowid='
							+ rowid
							+ '&userCode='
							+ userCode
							+ '&tzmoeny='
							+ tzmoeny + '&downmoeny=' + downmoeny,
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
							scheme02Ds.load({
										params : {
											start : 0,
											limit : scheme02PagingToolbar.pageSize,
											parent : locid,
											itemId : itemDr,
											year : Ext.getCmp('yearField')
													.getValue(),
											period : Ext.getCmp('periodField')
													.getValue()
										}
									});
							this.store.commitChanges();
							var view = scheme02Main.getView();
						} else {
							Ext.Msg.show({
										title : '����',
										msg : 'ʧ��',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						}
					},
					scope : this
				});
	}
}

scheme02Main.on("afteredit", afterEdit, scheme02Main);