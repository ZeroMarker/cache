FormPlugin = function(msg) {
	// 构造函数中完成
	this.init = function(cmp) {
		// 控件渲染时触发
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
// 核算年度
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
			fieldLabel : '核算年度',
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
			data : [['M', '月份'], ['Q', '季度'], ['H', '半年'], ['Y', '年度']]
		});
var periodTypeField = new Ext.form.ComboBox({
			id : 'periodTypeField',
			fieldLabel : '期间类型',
			width : 60,
			listWidth : 40,
			selectOnFocus : true,
			allowBlank : false,
			store : periodTypeStore,
			anchor : '90%',
			value : '', // 默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});

periodTypeField.on("select", function(cmb, rec, id) {
	if (cmb.getValue() == "M") {
		data = [['M01', '01月'], ['M02', '02月'], ['M03', '03月'], ['M04', '04月'],
				['M05', '05月'], ['M06', '06月'], ['M07', '07月'], ['M08', '08月'],
				['M09', '09月'], ['M10', '10月'], ['M11', '11月'], ['M12', '12月']];
	}
	if (cmb.getValue() == "Q") {
		data = [['Q01', '01季度'], ['Q02', '02季度'], ['Q03', '03季度'],
				['Q04', '04季度']];
	}
	if (cmb.getValue() == "H") {
		data = [['H01', '上半年'], ['H02', '下半年']];
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
			mode : 'local', // 本地模式
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
// 核算项目
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
			fieldLabel : '科室名称',
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
			text : '查询',
			tooltip : '查询',
			iconCls : 'option',
			handler : function() {
				var year = Ext.getCmp('yearField').getValue();
				if (year == "") {
					Ext.Msg.show({
								title : '提示',
								msg : '请选择年度!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.INFOR
							});
					return;
				}
				var period = Ext.getCmp('periodField').getValue();
				if (period == "") {
					Ext.Msg.show({
								title : '提示',
								msg : '请选择期间!',
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
			text : '审核确认',
			tooltip : '确认后财务科将按此发放，奖金不能再调整！',
			iconCls : 'option',
			handler : function() {

				var obj = scheme1Main.getSelections();

				var len = obj.length;
				// 判断是否选择了要修改的数据
				if (len < 1) {
					Ext.Msg.show({
								title : '注意',
								msg : '请选择需要上报的数据!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
					return;
				}

				var upFlag = obj[0].get("upStatus");
				if (upFlag == "已上报") {
					Ext.Msg.show({
								title : '提示',
								msg : '数据已经上报不需要再报!',
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
									Ext.MessageBox.confirm('提示',
											'验证成功,确定要上报数据吗?', callback);
								} else {
									Ext.Msg.show({
												title : '上报失败',
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
			header : '数据ID',
			dataIndex : 'rowid'
		}, {
			header : '科室ID',
			dataIndex : 'locId'
		}, {
			header : '核算科室',
			dataIndex : 'locName'
		}, {
			header : '项目ID',
			dataIndex : 'itemId'
		}, {
			header : '项目名称',
			dataIndex : 'itemName'
		}, {
			header : '核算金额',
			dataIndex : 'downmoeny'
		}, {
			header : '审核状态',
			dataIndex : 'upStatus'
		}, {
			header : '审核时间',
			dataIndex : 'upTime'
		}, {
			header : '审核人ID',
			dataIndex : 'upPersonId'
		}, {
			header : '审核人员',
			dataIndex : 'upPersonName'
		}, {
			header : '核算年份',
			dataIndex : 'bonusYear'
		}, {
			header : '核算月份',
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
			header : '核算科室',
			dataIndex : 'locName',
			width : 60,
			align : 'left',
			sortable : true
		}, 
			{
			header : '奖金核算方案',
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
			displayMsg : '当前显示{0} - {1}，共计{2}',
			emptyMsg : "没有数据",
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
			title : '科室下发金额记录',
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
			tbar : ['年度', yearField, '-', '类别', periodTypeField, '-', '期间',
					periodField, '-', '科室名称', itemField, '-', queryButton, '-',
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
			locid = selectedRow.data['locId']; // 科室ID
			itemDr = selectedRow.data['itemId'];
			syear = Ext.getCmp('yearField').getValue(),
			speriod = Ext.getCmp('periodField').getValue()
							
			if (itemDr == "") {
				Ext.Msg.show({
							title : '提示',
							msg : '项目为空!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFOR
						});
				return;
			}
			if (tmpSelectedScheme == "") {
				Ext.Msg.show({
							title : '提示',
							msg : '主表记录为空!',
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
			header : '数据ID',
			dataIndex : 'rowid'
		}, {
			header : '年度',
			dataIndex : 'year'
		}, {
			header : '期间',
			dataIndex : 'period'
		}, {
			header : '人员ID',
			dataIndex : 'personId'
		}, {
			header : '人员名称',
			dataIndex : 'personName'
		}, {
			header : '核算金额',
			dataIndex : 'downmoeny'
		}, {
			header : '调整额度',
			dataIndex : 'tzmoeny'
		}, {
			header : '调整后金额',
			dataIndex : 'upmoney'
		}, {
			header : '项目ID',
			dataIndex : 'itemId'
		}, {
			header : '项目名称',
			dataIndex : 'itemName'
		}, {
			header : '调整时间',
			dataIndex : 'adjustDate'
		}, {
			header : '调整人ID',
			dataIndex : 'adjustPersonId'
		}, {
			header : '调整人员',
			dataIndex : 'adjustPersonName'
		}, {
			header : '人员工号',
			dataIndex : 'UnitCode'
		}, {
			header : '数据标识',
			dataIndex : 'NewEmp'
		}, {
			header : '调整比例',
			dataIndex : 'adjRate'
		}, {
			header : '审查意见',
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
						plugins : new FormPlugin("指标值为数字")
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
			displayMsg : '当前显示{0} - {1}，共计{2}',
			emptyMsg : "没有数据",
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

// 验证
var yzButton = new Ext.Toolbar.Button({
			text : '数据验证',
			tooltip : '数据验证',
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
												title : '提示',
												msg : '验证成功!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO
											});
								} else {
									Ext.Msg.show({
												title : '错误',
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
							title : '错误',
							msg : '请检查网络连接!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
			},
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					Ext.Msg.show({
								title : '提示',
								msg : '数据上报成功!',
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
								title : '提示',
								msg : '数据上报失败!',
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

// 导入人员下发奖金
var uploadButton = new Ext.Toolbar.Button({
			text : 'Excel数据导入',
			tooltip : '导入数据(Excel格式)',
			iconCls : 'add',
			handler : function() {

				importExcel();

				return;

			}

		});
// 添加按钮
var addButton = new Ext.Toolbar.Button({
	text : '添加',
	tooltip : '添加',
	iconCls : 'add',
	handler : function() {

		var obj = scheme1Main.getSelections();
		var upFlag = obj[0].get("upStatus");
		if (upFlag == "已上报") {
			Ext.Msg.show({
						title : '提示',
						msg : '已经上报的数据不允许被添加!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return;
		}

		var rowObj = scheme1Main.getSelections();
		// 定义并初始化行对象长度变量
		var len = rowObj.length;
		// 判断是否选择了要修改的数据
		if (len < 1) {
			Ext.Msg.show({
						title : '注意',
						msg : '请选择需要调整的数据!',
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
					fieldLabel : '发放年度',
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
					fieldLabel : '发放月份',
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
					fieldLabel : '发放项目',
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
					fieldLabel : '人员工号',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					emptyText : '必填项',
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
												title : '错误',
												msg : '人员工号不能为空!',
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
					fieldLabel : '人员姓名',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					emptyText : '必填项',
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
												title : '错误',
												msg : '人员姓名不能为空!',
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
					fieldLabel : '调整金额',
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
					fieldLabel : '所属科室',
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

		// 初始化面板
		formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [yearField, monthField, Item1Field, cField, nField,
							aField]
				});
		// 面板加载 unitField,
		formPanel.on('afterlayout', function(panel, layout) {
					this.getForm().loadRecord(rowObj[0]);
					yearField.setValue(year);
					monthField.setValue(month);
					Item1Field.setValue(itemName);
				});
		// 初始化添加按钮
		addButton = new Ext.Toolbar.Button({
					text : '添 加'
				});

		// 定义添加按钮响应函数
		addHandler = function() {

			var code = cField.getValue();
			var name = nField.getValue();
			var unitdr = unitField.getValue();
			var AdjustBonus = aField.getValue();

			if (code == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '人员工号不能为空！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (name == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '人员姓名不能为空！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			/*
			 * if (unitdr == "") { Ext.Msg.show({ title : '错误', msg :
			 * '所属科室不能为空！', buttons : Ext.Msg.OK, icon : Ext.MessageBox.ERROR
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
				waitMsg : '保存中...',
				failure : function(result, request) {
					Handler = function() {
						unitField.focus();
					}
					Ext.Msg.show({
								title : '错误',
								msg : '请检查网络连接!',
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
									title : '注意',
									msg : '添加成功!',
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
							message = '输入的编码已经存在!';

						Ext.Msg.show({
									title : '错误',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
					}
				},
				scope : this
			});
		}

		// 添加保存按钮的监听事件
		addButton.addListener('click', addHandler, false);

		// 初始化取消按钮
		cancelButton = new Ext.Toolbar.Button({
					text : '取消'
				});

		// 定义取消按钮的响应函数
		cancelHandler = function() {
			addwin.close();
		}

		// 添加取消按钮的监听事件
		cancelButton.addListener('click', cancelHandler, false);

		// 初始化窗口
		addwin = new Ext.Window({
					title : '添加记录',
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

		// 窗口显示
		addwin.show();
	}
});

// 修改按钮
var editButton = new Ext.Toolbar.Button({
	text : '修改',
	tooltip : '修改',
	iconCls : 'option',
	handler : function() {
		// 定义并初始化行对象
		var rowObj = BonusEmployeeTab.getSelections();
		// 定义并初始化行对象长度变量
		var len = rowObj.length;
		// 判断是否选择了要修改的数据
		if (len < 1) {
			Ext.Msg.show({
						title : '注意',
						msg : '请选择需要修改的数据!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
		} else {
			var rowid = rowObj[0].get("rowid");
		}

		var c1Field = new Ext.form.TextField({
					id : 'c1Field',
					fieldLabel : '编码',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					valueNotFoundText : rowObj[0].get("code"),
					emptyText : '编码...',
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
												title : '错误',
												msg : '编码不能为空!',
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
					fieldLabel : '名称',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					valueNotFoundText : rowObj[0].get("name"),
					emptyText : '名称...',
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
												title : '错误',
												msg : '名称不能为空!',
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
					fieldLabel : '所属核算单元',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : unit1Ds,
					valueField : 'rowid',
					displayField : 'name',
					valueNotFoundText : rowObj[0].get("unitName"),
					triggerAction : 'all',
					emptyText : '请选所属核算单元...',
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

		// 定义并初始化面板
		var formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [c1Field, n1Field, unit1Field]
				});

		// 面板加载
		formPanel.on('afterlayout', function(panel, layout) {
					this.getForm().loadRecord(rowObj[0]);
					c1Field.setValue(rowObj[0].get("code"));
					n1Field.setValue(rowObj[0].get("name"));
					unit1Field.setValue(rowObj[0].get("unitDr"));
				});

		// 定义并初始化保存修改按钮
		var editButton = new Ext.Toolbar.Button({
					text : '保存修改'
				});

		// 定义修改按钮响应函数
		editHandler = function() {

			var code = c1Field.getValue();
			var name = n1Field.getValue();
			code = trim(code);
			name = trim(name);

			if (code == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '编码为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (name == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '名称为空',
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
				waitMsg : '保存中...',
				failure : function(result, request) {
					Handler = function() {
						activeFlag.focus();
					}
					Ext.Msg.show({
								title : '错误',
								msg : '请检查网络连接!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR,
								fn : Handler
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Ext.Msg.show({
									title : '注意',
									msg : '修改成功!',
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
							message = '输入的代码已经存在!';

						Ext.Msg.show({
									title : '错误',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
					}
				},
				scope : this
			});
		}

		// 添加保存修改按钮的监听事件
		editButton.addListener('click', editHandler, false);

		// 定义并初始化取消修改按钮
		var cancelButton = new Ext.Toolbar.Button({
					text : '取消修改'
				});

		// 定义取消修改按钮的响应函数
		cancelHandler = function() {
			editwin.close();
		}

		// 添加取消按钮的监听事件
		cancelButton.addListener('click', cancelHandler, false);

		// 定义并初始化窗口
		var editwin = new Ext.Window({
					title : '修改记录',
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

		// 窗口显示
		editwin.show();
	}
});

// 删除按钮
var delButton = new Ext.Toolbar.Button({
	text : '删除',
	tooltip : '删除',
	iconCls : 'remove',
	handler : function() {
		// 定义并初始化行对象

		var obj = scheme1Main.getSelections();
		var upFlag = obj[0].get("upStatus");
		if (upFlag == "已上报") {
			Ext.Msg.show({
						title : '提示',
						msg : '已经上报的数据不允许被删除!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return;
		}

		var rowObj = scheme02Main.getSelections();
		// 定义并初始化行对象长度变量
		var len = rowObj.length;
		// 判断是否选择了要修改的数据
		if (len < 1) {
			Ext.Msg.show({
						title : '注意',
						msg : '请选择需要删除的数据!',
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
					waitMsg : '删除中...',
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
										msg : '删除成功!',
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
										title : '错误',
										msg : '删除失败!',
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
		Ext.MessageBox.confirm('提示', '确实要删除该条记录吗?', handler);
	}
});

var scheme02Main = new Ext.grid.EditorGridPanel({
			title : '下发奖金明细',
			region : 'center',
			store : scheme02Ds,
			cm : inDeptsCm,
			trackMouseOver : true,
			stripeRows : true,
			clicksToEdit : 1,
			viewConfig : {   
               forceFit : true,   
               getRowClass : function(record,rowIndex,rowParams,store){   
                   //禁用数据显示红色   
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
	if (upFlag == "已上报") {
		Ext.Msg.show({
					title : '提示',
					msg : '已经上报的数据不允许被修改!',
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
										title : '错误',
										msg : '失败',
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