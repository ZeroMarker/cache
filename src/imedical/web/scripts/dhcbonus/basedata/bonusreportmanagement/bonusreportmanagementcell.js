/**
 * name:tab of database author:zhaoliguo Date:2016-8-29
 */

		
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

var BonusReportCellTabUrl = '../csp/dhc.bonus.bonusreportmanagementexe.csp';
function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}
//---------------------------------------------------------------------------------------
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
//--------------------------------------------------------------------------------------------
// �������Դ
/*
var BonusReportCellTabProxy = new Ext.data.HttpProxy({
			url : BonusReportCellTabUrl + '?action=listcell&rowID='
					+ BonusReportMainRowId
		});
		*/
var reportCellDs = new Ext.data.Store({
			proxy : '',    //BonusReportCellTabProxy
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['rowid', 'name', 'celltype', 'rpindex','cellName','FontBold','BackColor']),
			// turn on remote sorting
			remoteSort : true
		});
// rowid^loadFileID^loadFileName^CalGroupID^CalGroupName^ColNum
// ����Ĭ�������ֶκ�������
reportCellDs.setDefaultSort('rowid');

// ���ݿ�����ģ��
var BonusReportCellTabCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
		{
			header : '��Ŀ����',
			dataIndex : 'name',
			width : 120,
			sortable : true
		}, {
			header : '��������',
			dataIndex : 'celltype',
			width : 100,
			sortable : true
		}, {
			header : '��˳��',
			dataIndex : 'rpindex',
			width : 100,
			align : 'center',
			css : 'background:#d0def0;color:#000000',
			sortable : true,
			editor : new Ext.form.TextField({
						allowBlank : true,
						width :60,
						plugins : new FormPlugin("��λ��Ϊ�ַ�")

					})
		}, {
			header : '����������',
			dataIndex : 'cellName',
			width : 120,
			align : 'center',
			css : 'background:#d0def0;color:#000000',
			sortable : true,
			editor : new Ext.form.TextField({
						allowBlank : true,
						plugins : new FormPlugin("����������")

					})
		}, {
			header : '������',
			dataIndex : 'FontBold',
			width : 100,
			align : 'center',
			css : 'background:#d0def0;color:#000000',
			sortable : true,
			editor : new Ext.form.TextField({
						allowBlank : true,
						plugins : new FormPlugin("true/false")

					})
		}, {
			header : '�б���ɫ',
			dataIndex : 'BackColor',
			width : 100,
			align : 'left',
			css : 'background:#d0def0;color:#000000',
			sortable : true,
			editor : new Ext.form.TextField({
						allowBlank : true,
						plugins : new FormPlugin("��:-3342337")

					})
		}

]);
// rowid^loadFileID^loadFileName^CalGroupID^CalGroupName^ColNum
// ��ʼ��Ĭ��������
BonusReportCellTabCm.defaultSortable = true;

// ��ʼ�������ֶ�
var BonusReportCellSearchField = 'name';

// ���ӽ���ť
var addschemeButton = new Ext.Toolbar.Button({
	text : '���ӽ���',
	tooltip : '����',
	iconCls : 'add',
	handler : function() {

		
		if (BonusReportMainRowId == "") {
			Ext.Msg.show({
						title : '����',
						msg : '����ѡ�񱨱�����飡',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		}
		var rpindex1Field = new Ext.form.TextField({
					id : 'rpindexlField',
					fieldLabel : '��˳��',
					allowBlank : false,
					width : 60,
					listWidth : 60,
					emptyText : '',
					anchor : '90%',
					selectOnFocus : 'true',
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								addButton.focus();
							}
						}
					}
				});
var cellNameField = new Ext.form.TextField({
					id : 'cellNameField ',
					fieldLabel : '����������',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					emptyText : '',
					anchor : '90%',
					selectOnFocus : 'true',
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								addButton.focus();
							}
						}
					}
				});

		var schemeTypeDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		schemeTypeDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.bonusreportmanagementexe.csp?action=schemetype&start=0&limit=10',
				method : 'POST'
			})
		});

		var schemeTypeField = new Ext.form.ComboBox({
					id : 'schemeTypeField',
					fieldLabel : '���𷽰�',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : schemeTypeDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
//					valueNotFoundText : fileTypeCurrName,
					name : 'schemeTypeField',
					minChars : 1,
					pageSize : 5,
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
		var schemeNameDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		schemeNameDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.bonusreportmanagementexe.csp?action=schemename&schemetype='
						+ schemeTypeField.getValue() + '&start=0&limit=10',
				method : 'POST'
			})
		});

		var schemeNameField = new Ext.form.ComboBox({
					id : 'schemeNameField',
					fieldLabel : '������Ŀ',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					// disabled:true,
					store : schemeNameDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					// valueNotFoundText : fileTypeCurrName,
					name : 'schemeNameField',
					minChars : 1,
					pageSize : 5,
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
		
		// ��������Ŀ����
		schemeTypeField.on("select", function(cmb, rec, id) {
					searchFun(cmb.getValue());
					// tmpStr=cmb.getValue();
					schemeNameField.setValue("");
					schemeNameField.setRawValue("");
					schemeNameDs.load({
								params : {
									start : 0,
									limit : BonusReportCellTabPagingToolbar.pageSize
								}
							});

				});
		
		function searchFun(SetCfgDr) {
			schemeNameDs.proxy = new Ext.data.HttpProxy({
						url : '../csp/bonusreportmanagementexe.csp?action=schemename&schemetype='
								+ Ext.getCmp('schemeTypeField').getValue(),
						method : 'POST'
					});
			schemeNameDs.load({
						params : {
							start : 0,
							limit : BonusReportCellTabPagingToolbar.pageSize
						}
					});
		};
		
		// ��ʼ�����
		formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [schemeTypeField, schemeNameField, rpindex1Field,cellNameField]
				});
		// , targetField, AsValueField
		// ��ʼ�����Ӱ�ť
		addButton = new Ext.Toolbar.Button({
					text : '�� ��'
				});

		//		
//		AtypeGroupField.setValue(fileTypeCurrRowID);

		// �������Ӱ�ť��Ӧ����
		addHandler = function() {

			var schemeid = schemeNameField.getValue();
			var rpindex1 = rpindex1Field.getValue();
			var cellName = cellNameField.getValue();
			

			if (schemeid == "") {
				Ext.Msg.show({
							title : '����',
							msg : '������ĿΪ��',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (rpindex1 == "") {
				Ext.Msg.show({
							title : '����',
							msg : '��˳��Ϊ��',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (cellName == "") {
				Ext.Msg.show({
							title : '����',
							msg : '����������Ϊ��',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};

			// 
			//alert('../csp/dhc.bonus.bonusreportmanagementexe.csp?action=addscheme&schemeid='	+ schemeid+ '&rpindex='	+ rpindex1	+ '&rowId='+ BonusReportMainRowId	+ '&cellName='+cellName)
			Ext.Ajax.request({
				url : ('../csp/dhc.bonus.bonusreportmanagementexe.csp?action=addscheme&schemeid='
						+ schemeid
						+ '&rpindex='
						+ rpindex1
						+ '&rowId='
						+ BonusReportMainRowId
						+ '&cellName='+encodeURIComponent(cellName)),
				waitMsg : '������...',
				failure : function(result, request) {
					Handler = function() {
						rpindex1Field.focus();
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
					//alert(jsonData.info)
					if (jsonData.success == 'true') {
						Handler = function() {
							rpindex1Field.focus();
						}
						Ext.Msg.show({
									title : 'ע��',
									msg : '���ӳɹ�!',
									icon : Ext.MessageBox.INFO,
									buttons : Ext.Msg.OK,
									fn : Handler
								});
								
								

						reportCellDs.load({
									params : {
										//rowID : BonusReportMainRowId,
										start : 0,
										limit : 25
									}
								});

						// addwin.close();
					} else if(jsonData.info=='RepScheme'){
						Ext.Msg.show({
									title : 'ע��',
									msg : '�����ӵĽ������Ѿ�����!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
									
								});
					} else {
						Ext.Msg.show({
									title : '����',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
					}
					
				},
				scope : this
			});
		}

		// ���ӱ��水ť�ļ����¼�
		addButton.addListener('click', addHandler, false);

		// ��ʼ��ȡ����ť
		cancelButton = new Ext.Toolbar.Button({
					text : 'ȡ��'
				});

		// ����ȡ����ť����Ӧ����
		cancelHandler = function() {
			addwin.close();
		}

		// ����ȡ����ť�ļ����¼�
		cancelButton.addListener('click', cancelHandler, false);

		// ��ʼ������
		addwin = new Ext.Window({
					title : '���ӽ����¼',
					width : 400,
					height : 250,
					minWidth : 400,
					minHeight : 250,
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

//����ָ�갴ť
var addtargetButton = new Ext.Toolbar.Button({
	text : '����ָ��',
	tooltip : '����',
	iconCls : 'add',
	handler : function() {
		if (BonusReportMainRowId == "") {
			Ext.Msg.show({
						title : '����',
						msg : '����ѡ�񱨱�����飡',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		}
		var rpindex2Field = new Ext.form.TextField({
					id : 'rpindex2Field',
					fieldLabel : '��˳��',
					allowBlank : false,
					width : 60,
					listWidth : 60,
					emptyText : '',
					anchor : '90%',
					selectOnFocus : 'true',
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								addButton.focus();
							}
						}
					}
				});
		var cellName2Field = new Ext.form.TextField({
					id : 'cellName2Field',
					fieldLabel : '����������',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					emptyText : '',
					anchor : '90%',
					selectOnFocus : 'true',
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								addButton.focus();
							}
						}
					}
				});

		var targetTypeDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		targetTypeDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.bonusreportmanagementexe.csp?action=targettype&start=0&limit=10',
				method : 'POST'
			})
		});

		var targetTypeField = new Ext.form.ComboBox({
					id : 'targetTypeField',
					fieldLabel : 'ָ�����',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : targetTypeDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
//					valueNotFoundText : fileTypeCurrName,
					name : 'targetTypeField',
					minChars : 1,
					pageSize : 5,
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
		var targetNameDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		targetNameDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.bonusreportmanagementexe.csp?action=targetname&targettype='
						+ targetTypeField.getValue() + '&start=0&limit=10',
				method : 'POST'
			})
		});

		var targetNameField = new Ext.form.ComboBox({
					id : 'targetNameField',
					fieldLabel : 'ָ������',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					// disabled:true,
					store : targetNameDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					// valueNotFoundText : fileTypeCurrName,
					name : 'targetNameField',
					minChars : 1,
					pageSize : 5,
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
		
		// ������������
		targetTypeField.on("select", function(cmb, rec, id) {
					searchFun(cmb.getValue());
					// tmpStr=cmb.getValue();
					targetNameField.setValue("");
					targetNameField.setRawValue("");
					targetNameDs.load({
								params : {
									start : 0,
									limit : BonusReportCellTabPagingToolbar.pageSize
								}
							});

				});
		
		function searchFun(SetCfgDr) {
			targetNameDs.proxy = new Ext.data.HttpProxy({
						url : '../csp/bonusreportmanagementexe.csp?action=targetname&targettype='
								+ Ext.getCmp('targetTypeField').getValue(),
						method : 'POST'
					});
			targetNameDs.load({
						params : {
							start : 0,
							limit : BonusReportCellTabPagingToolbar.pageSize
						}
					});
		};
		
		// ��ʼ�����
		formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [targetTypeField, targetNameField, rpindex2Field,cellName2Field]
				});
		// , targetField, AsValueField
		// ��ʼ�����Ӱ�ť
		addButton = new Ext.Toolbar.Button({
					text : '�� ��'
				});

		//		
//		AtypeGroupField.setValue(fileTypeCurrRowID);

		// �������Ӱ�ť��Ӧ����
		addHandler = function() {

			var targetid = targetNameField.getValue();
			var rpindex2 = rpindex2Field.getValue();
			var cellName2 =cellName2Field.getValue();
			
			if (targetid == "") {
				Ext.Msg.show({
							title : '����',
							msg : 'ָ������Ϊ��',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (rpindex2 == "") {
				Ext.Msg.show({
							title : '����',
							msg : '��˳��Ϊ��',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			
			if (cellName2 == "") {
				Ext.Msg.show({
							title : '����',
							msg : '����������Ϊ��',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};

			// 
			//alert('../csp/dhc.bonus.bonusreportmanagementexe.csp?action=addtarget&targetid='+ targetid+ '&rpindex='+ rpindex2	+ '&rowId='	+ BonusReportMainRowId+ '&cellName='+ cellName2)
			Ext.Ajax.request({
				url : ('../csp/dhc.bonus.bonusreportmanagementexe.csp?action=addtarget&targetid='
						+ targetid
						+ '&rpindex='
						+ rpindex2
						+ '&rowId='
						+ BonusReportMainRowId
						+ '&cellName='
						+ encodeURIComponent(cellName2)
						),
				waitMsg : '������...',
				failure : function(result, request) {
					Handler = function() {
						rpindex2Field.focus();
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
							rpindex2Field.focus();
						}
						Ext.Msg.show({
									title : 'ע��',
									msg : '���ӳɹ�!',
									icon : Ext.MessageBox.INFO,
									buttons : Ext.Msg.OK,
									fn : Handler
								});

						reportCellDs.load({
									params : {
										//rowID : BonusReportMainRowId,
										start : 0,
										limit : 25
									}
								});

						// addwin.close();
					} else if(jsonData.info=='RepTarget'){
						Ext.Msg.show({
									title : 'ע��',
									msg : '�����ӵ�ָ�����Ѿ�����!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
									
								});
					} else {
						Ext.Msg.show({
									title : '����',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
					}
				},
				scope : this
			});
		}

		// ���ӱ��水ť�ļ����¼�
		addButton.addListener('click', addHandler, false);

		// ��ʼ��ȡ����ť
		cancelButton = new Ext.Toolbar.Button({
					text : 'ȡ��'
				});

		// ����ȡ����ť����Ӧ����
		cancelHandler = function() {
			addwin1.close();
		}

		// ����ȡ����ť�ļ����¼�
		cancelButton.addListener('click', cancelHandler, false);

		// ��ʼ������
		addwin1 = new Ext.Window({
					title : '����ָ���¼',
					width : 400,
					height : 250,
					minWidth : 400,
					minHeight : 250,
					layout : 'fit',
					plain : true,
					modal : true,
					bodyStyle : 'padding:5px;',
					buttonAlign : 'center',
					items : formPanel,
					buttons : [addButton, cancelButton]
				});

		// ������ʾ
		addwin1.show();
	}
});

// ɾ����ť
var delButton = new Ext.Toolbar.Button({
	text : 'ɾ��',
	tooltip : 'ɾ��',
	iconCls : 'remove',
	handler : function() {
		// ���岢��ʼ���ж��� BonusReportManagementCellPanel
		var rowObj = BonusReportManagementCellPanel.getSelections();
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
					url : '../csp/dhc.bonus.bonusreportmanagementexe.csp?action=delcell&rowId='
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

							reportCellDs.load({
										params : {
											//rowID : BonusReportMainRowId,
											start : 0,
											limit : 25
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

// ��ҳ������
var BonusReportCellTabPagingToolbar = new Ext.PagingToolbar({
	store : reportCellDs,
	pageSize : 25,
	displayInfo : true,
	displayMsg : '�� {0} ���� {1}�� ��һ�� {2} ��',
	emptyMsg : "û�м�¼" // ,
		// buttons : ['-', BonusReportCellFilterItem, '-', BonusReportCellSearchBox]

	});

// ����
var BonusReportManagementCellPanel = new Ext.grid.EditorGridPanel({
			title : '��������ά��',
			region : 'center',
			store : reportCellDs,
			cm : BonusReportCellTabCm,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			loadMask : true,
			tbar : [addschemeButton, '-', addtargetButton, '-', delButton],
			bbar : BonusReportCellTabPagingToolbar
		});

function afterEdit(rowObj) {

	// ���岢��ʼ���ж��󳤶ȱ���
	var len = rowObj.length;
	
	// �ж��Ƿ�ѡ����Ҫ�޸ĵ�����
	 var rowid = rowObj.record.get("rowid");
	//var name = rowObj.record.get("name");
	var cellName= rowObj.record.get("cellName");
	var cellName= encodeURIComponent(cellName)
	var rpindex = rowObj.record.get("rpindex");
	var backColor = rowObj.record.get("BackColor");
	var fontBold = rowObj.record.get("FontBold");
	
	
	/*var data = name.trim() + "^" + celltype.trim() + "^"
			+ rpindex.trim();*/
	 var data = rowid.trim() + "^" + rpindex.trim() + "^" + backColor.trim() + "^" + fontBold.trim();
	
	Ext.Ajax.request({
		url : BonusReportCellTabUrl + '?action=editcell&rowId=' + rowid
				+ '&rpindex=' + rpindex+ '&cellName=' + cellName
				+ '&backColor=' + backColor+ '&fontBold=' + fontBold,	
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
				// Ext.Msg.show({title:'ע��',msg:'���ӳɹ�!',buttons:
				// Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				reportCellDs.load({
					params : {
						//rowID : BonusReportMainRowId,
						start : 0,
						limit : 25
					}
				});
				this.store.commitChanges(); // ��ԭ�����޸���

				var view = BonusReportManagementCellPanel.getView();
				// view.focusCell(tmpRow, tmpColumn);

			} else {
				Ext.Msg.show({
							title : '����',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
			}
		},
		scope : this
	});
}

BonusReportManagementCellPanel.on("afteredit", afterEdit, BonusReportManagementCellPanel);



