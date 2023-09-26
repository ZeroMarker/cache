var schemeTypeCombo = new Ext.form.ComboBox({
			fieldLabel : '方案类别',
			name : 'type',
			store : schemeTypeSt,
			displayField : 'name',
			allowBlank : false,
			valueField : 'rowid',
			typeAhead : true,
			//mode : 'local',
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '必选',
			selectOnFocus : true,
			anchor : '100%'
		});

var schemeStateCombo = new Ext.form.ComboBox({
			fieldLabel : '方案状态',
			name : 'type',
			store : schemeStateSt,
			displayField : 'name',
			allowBlank : false,
			valueField : 'rowid',
			typeAhead : true,
			mode : 'local',
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '必选',
			selectOnFocus : true,
			anchor : '100%'
		});

schemeTypeCombo.allowBlank = true;
schemeTypeCombo.emptyText = '';
schemeStateCombo.allowBlank = true;
schemeStateCombo.emptyText = '';

schemeTypeCombo.on('select', function() {
			schemeDs.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.scheme03exe.csp?action=schemelist&type='
								+ schemeTypeCombo.getValue()
								+ '&state='
								+ schemeStateCombo.getValue(),
						method : 'GET'
					});
			 itemDs.removeAll();
			 schemeUnitDs.removeAll();

			// -------------------
			schemeDs.load({
						params : {
							start : 0,
							limit : 25
						},
						callback : function(record, options, success) {
							// schemeMain.fireEvent('rowclick',this,0);
							// schemeMain.getSelectionModel().selectAll();
							schemeCSM.fireEvent('rowselect', this, 0);
						}
					});

		});

schemeStateCombo.on('select', function() {
			schemeDs.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.scheme03exe.csp?action=schemelist&type='
								+ schemeTypeCombo.getValue()
								+ '&state='
								+ schemeStateCombo.getValue(),
						method : 'GET'
					});
			schemeDs.load({
						params : {
							start : 0,
							limit : 25
						},
						callback : function(record, options, success) {
							// schemeMain.fireEvent('rowclick',this,0);
							// schemeMain.getSelectionModel().selectAll();
							schemeCSM.fireEvent('rowselect', this, 0);
						}
					});
		});

// rowid^code^name^desc^type^createPerson^adjustPerson^schemeState^adjustDate^auditingPerson^auditingDate^isValid
var schemeValue = new Array({
			header : '',
			dataIndex : 'rowid'
		}, // 0
		{
			header : '代码',
			dataIndex : 'code'
		}, // 1
		{
			header : '方案名称',
			dataIndex : 'name'
		}, // 2
		{
			header : '方案描述',
			dataIndex : 'desc'
		}, // 3
		{
			header : '方案类别',
			dataIndex : 'SchemeTypeName'
		}, // 4
		{
			header : '创建人员',
			dataIndex : 'createPerson'
		}, // 5
		{
			header : '调整人员',
			dataIndex : 'adjustPerson'
		}, // 6
		{
			header : '方案状态',
			dataIndex : 'schemeState'
		}, // 7
		{
			header : '调整时间',
			dataIndex : 'adjustDate'
		}, // 8
		{
			header : '审核人员',
			dataIndex : 'auditingPerson'
		}, // 9
		{
			header : '审核时间',
			dataIndex : 'auditingDate'
		}, // 10
		{
			header : '是否有效',
			dataIndex : 'isValid'
		} // 11
);

var schemeUrl = 'dhc.bonus.scheme01exe.csp';
var schemeProxy = new Ext.data.HttpProxy({
			url : schemeUrl + '?action=schemelist'
		});

var schemeDs = new Ext.data.Store({
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
							schemeValue[11].dataIndex]),
			remoteSort : true
		});

//schemeDs.setDefaultSort('rowid', 'Desc');

var schemeCSM = new Ext.grid.CheckboxSelectionModel();

var schemeCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), schemeCSM,
		{
			header : schemeValue[1].header,
			dataIndex : schemeValue[1].dataIndex,
			width : 60,
			sortable : true
		}, {
			header : schemeValue[2].header,
			dataIndex : schemeValue[2].dataIndex,
			width : 150,
			align : 'left',
			sortable : true
		}, {
			header : schemeValue[3].header,
			dataIndex : schemeValue[3].dataIndex,
			width : 150,
			align : 'left',
			sortable : true
		}, {
			header : schemeValue[4].header,
			dataIndex : schemeValue[4].dataIndex,
			width : 60,
			align : 'left',
			/*renderer : function(value, metadata, record, rowIndex, colIndex,
					store) {
				return schemeTypeValue[value];
			},*/
			sortable : true
		}, {
			header : schemeValue[7].header,
			dataIndex : schemeValue[7].dataIndex,
			width : 60,
			align : 'left',
			renderer : function(value, metadata, record, rowIndex, colIndex,
					store) {
				return schemeStateValue[value];
			},
			sortable : true
		}, {
			header : schemeValue[10].header,
			dataIndex : schemeValue[10].dataIndex,
			width : 60,
			align : 'left',
			sortable : true
		}]);

var schemePagingToolbar = new Ext.PagingToolbar({
			pageSize : 25,
			store : schemeDs,
			displayInfo : true,
			displayMsg : '当前显示{0} - {1}，共计{2}',
			emptyMsg : "没有数据"// ,
		});

var codeField = new Ext.form.TextField({
			id : 'codeField',
			name : 'code',
			fieldLabel : '方案代码',
			allowBlank : false,
			emptyText : '必填',
			anchor : '100%'
		});

var nameField = new Ext.form.TextField({
			id : 'nameField',
			name : 'name',
			fieldLabel : '方案名称',
			allowBlank : false,
			emptyText : '必填',
			anchor : '100%'
		});

var descField = new Ext.form.TextField({
			id : 'descField',
			name : 'desc',
			fieldLabel : '方案描述',
			emptyText : '',
			anchor : '100%'
		});

var checkButton = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '查询',
			iconCls : 'add',
			handler : function() {
				schemeDs.proxy = new Ext.data.HttpProxy({
							url : 'dhc.bonus.scheme03exe.csp?action=schemelist&type='
									+ schemeTypeCombo.getValue()
									+ '&state='
									+ schemeStateCombo.getValue(),
							method : 'GET'
						});
				schemeDs.load({
							params : {
								start : 0,
								limit : 25
							},
							callback : function(r, o, s) {
								schemeCSM.selectFirstRow();
								// schemeCSM.fireEvent('rowselect',this,0);
							}
						});

			}
		});

var confirmButton = new Ext.Toolbar.Button({
	text : '审核',
	tooltip : '审核',
	iconCls : 'option',
	handler : function() {
		var rows = schemeMain.getSelectionModel().getSelections();
		var len = rows.length;
		if (len == 0) {
			Ext.Msg.alert('注意', '请先选择数据行!');
		} else {
			for (var i = 0; i < len; i++) {
				var tmpRowid = rows[i].get('rowid');
				var tmpS = rows[i].get('schemeState');
				if (tmpS == 1) {
					Ext.Msg.show({
								title : '注意',
								msg : '数据已审核!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
					return;
				}
				if (flag == 1) {
					Ext.Msg.show({
								title : '注意',
								msg : '方案审核单元或方案项为空!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
					return;
				}
			}

			for (var i = 0; i < len; i++) {
				var tmpRowid = rows[i].get('rowid');
				// rowid^code^name^desc^type^createPerson^adjustPerson^schemeState^adjustDate^auditingPerson^auditingDate^isValid
				// tmpData=rows[i].get('code')+"^"+rows[i].get('name')+"^"+rows[i].get('desc')+"^"+rows[i].get('type')+"^"+rows[i].get('createPerson')+"^"+rows[i].get('adjustPerson')+"^1^"+rows[i].get('adjustDate')+"^"+rows[i].get('auditingPerson')+"^"+dt+"^"+rows[i].get('isValid');
				Ext.Ajax.request({
					url : 'dhc.bonus.scheme03exe.csp?action=audit&person='
							+ userCode + '&scheme=' + tmpRowid + '&date=' + dt,
					waitMsg : '保存中...',
					failure : function(result, request) {
						Ext.Msg.show({
									title : '错误',
									msg : '请检查网络连接!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
					},
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							Ext.Msg.show({
										title : '注意',
										msg : '操作成功!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.INFO
									});
							schemeDs.load({
										params : {
											start : 0,
											limit : schemePagingToolbar.pageSize
										}
									});
						} else {
							Ext.Msg.show({
										title : '错误',
										msg : '错误',
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
});
//
var cancelConfirmBt = new Ext.Toolbar.Button({
	text : '取消审核',
	tooltip : '取消审核',
	iconCls : 'option',
	handler : function() {
		var rows = schemeMain.getSelectionModel().getSelections();
		var len = rows.length;
		if (len == 0) {
			Ext.Msg.alert('注意', '请先选择数据行!');
		} else {
			for (var i = 0; i < len; i++) {
				var tmpRowid = rows[i].get('rowid');
				var tmpS = rows[i].get('schemeState');
				if (tmpS == 0) {
					Ext.Msg.show({
								title : '注意',
								msg : '数据未审核!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
					return;
				}
				if (flag == 1) {
					Ext.Msg.show({
								title : '注意',
								msg : '方案审核单元或方案项为空!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
					return;
				}
			}

			for (var i = 0; i < len; i++) {
				var tmpRowid = rows[i].get('rowid');
				// rowid^code^name^desc^type^createPerson^adjustPerson^schemeState^adjustDate^auditingPerson^auditingDate^isValid
				// tmpData=rows[i].get('code')+"^"+rows[i].get('name')+"^"+rows[i].get('desc')+"^"+rows[i].get('type')+"^"+rows[i].get('createPerson')+"^"+rows[i].get('adjustPerson')+"^1^"+rows[i].get('adjustDate')+"^"+rows[i].get('auditingPerson')+"^"+dt+"^"+rows[i].get('isValid');
				Ext.Ajax.request({
					url : 'dhc.bonus.scheme03exe.csp?action=cancelAudit&person='
							+ userCode + '&scheme=' + tmpRowid + '&date=' + dt,
					waitMsg : '保存中...',
					failure : function(result, request) {
						Ext.Msg.show({
									title : '错误',
									msg : '请检查网络连接!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
					},
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							Ext.Msg.show({
										title : '注意',
										msg : '操作成功!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.INFO
									});
							schemeDs.load({
										params : {
											start : 0,
											limit : schemePagingToolbar.pageSize
										}
									});
						} else {
							Ext.Msg.show({
										title : '错误',
										msg : '错误',
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
});

var schemeMain = new Ext.grid.GridPanel({
			title : '奖金核算方案',
			region : 'north',
			height : 250,
			store : schemeDs,
			cm : schemeCm,
			trackMouseOver : true,
			stripeRows : true,
			sm : schemeCSM,
			loadMask : true,
			viewConfig : {
				forceFit : true
			},
			tbar : ['方案类别:', schemeTypeCombo, '-', '方案状态:', schemeStateCombo,
					'-', checkButton, '-', confirmButton,'-',cancelConfirmBt],
			bbar : schemePagingToolbar
		});

// var schemeProxy = new Ext.data.HttpProxy({url:
// 'dhc.bonus.scheme03exe.csp?action=schemelist&type='+schemeTypeCombo.getValue()+'&state='+schemeStateCombo.getValue()});
schemeDs.proxy = new Ext.data.HttpProxy({
			url : 'dhc.bonus.scheme03exe.csp?action=schemelist&type='
					+ schemeTypeCombo.getValue() + '&state='
					+ schemeStateCombo.getValue(),
			method : 'GET'
		});

schemeDs.load({
			// proxy: schemeProxy,
			params : {
				start : 0,
				limit : schemePagingToolbar.pageSize
			}

		});

var flag = 0;

schemeCSM.on('rowselect', function(t, index, r) {
			var sR = "";
			var iR = "";
			var selectedRow = schemeDs.data.items[index];
			var tmpSelectedScheme = selectedRow.data['rowid'];
			schemeUnitDs.proxy = new Ext.data.HttpProxy({
						url : schemeUnitUrl + '?action=schemeunitlist&scheme='
								+ tmpSelectedScheme
					});

			itemDs.proxy = new Ext.data.HttpProxy({
						url : itemUrl + '?action=itemlist&scheme='
								+ tmpSelectedScheme
					});
			schemeUnitDs.load({
						params : {
							start : 0,
							limit : schemeUnitPagingToolbar.pageSize
						},
						callback : function(schemeUnitR, options, success) {
							sR = schemeUnitR;
							itemDs.load({
										params : {
											start : 0,
											limit : itemPagingToolbar.pageSize
										},
										callback : function(itemR, options,
												success) {
											iR = itemR;
											if ((sR.length == 0)
													|| (iR.length == 0)) {
												flag = 1;
											} else {
												flag = 0;
											}
										}
									});
						}
					});

		});
