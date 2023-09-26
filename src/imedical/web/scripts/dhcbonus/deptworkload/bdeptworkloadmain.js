/**
 * name:tab of database author:why Date:2011-01-14
 */
Ext.QuickTips.init();
// 插件类：用以在控件末尾提示输入信息
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
// 核算年度
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
			fieldLabel : '核算年度',
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
			mode : 'local', // 本地模式
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});

// 奖金方案
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
			fieldLabel : '奖金方案',
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

// 方案和核算单元联动
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
// 核算单元
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
			fieldLabel : '核算单元',
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
// 奖金指标
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
			fieldLabel : '核算指标',
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
// 方案和指标联动
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
// 配件数据源
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

// 设置默认排序字段和排序方向
StratagemTabDs.setDefaultSort('rowid', 'desc');

// 数据库数据模型
var StratagemTabCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
			header : '核算单元',
			dataIndex : 'UnitName',
			width : 150,
			sortable : true

		}, {
			header : '核算年度',
			dataIndex : 'BonusYear',
			width : 100,
			sortable : true
		}, {
			header : '核算期间',
			dataIndex : 'PeriodName',
			width : 100,
			sortable : true
		}, {
			header : '奖金指标',
			width : 150,
			dataIndex : 'TargetName',
			sortable : true

		}, {
			header : "奖金指标值",
			dataIndex : 'TargetValue',
			width : 100,
			align : 'left',
			css : 'background:#d0def0;color:#000000',
			sortable : true,
			editor : new Ext.form.TextField({
						allowBlank : true,
						plugins : new FormPlugin("指标值为数字")

					})
		}, {
			header : "录入时间",
			dataIndex : 'UpdateDate',
			width : 150,
			align : 'left',
			sortable : true

		}, {
			header : "核算单元ID",
			dataIndex : 'UnitID',
			width : 150,
			align : 'left',
			hidden : true,
			sortable : true

		}, {
			header : "核算单元ID",
			dataIndex : 'TargetID',
			width : 150,
			align : 'left',
			hidden : true,
			sortable : true

		}, {
			header : "核算单元ID",
			dataIndex : 'BonusPeriod',
			width : 150,
			align : 'left',
			hidden : true,
			sortable : true

		}

]);

// 初始化默认排序功能
StratagemTabCm.defaultSortable = true;

// 查询按钮
var findButton = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '初始化',
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
								title : '错误',
								msg : '核算年度为空',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};
				if (BonusPeriod == "") {
					Ext.Msg.show({
								title : '错误',
								msg : '核算周期为空',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};
				if (BonusSchemeID == "") {
					Ext.Msg.show({
								title : '错误',
								msg : '奖金方案为空',
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

// 分页工具栏
var StratagemTabPagingToolbar = new Ext.PagingToolbar({
			store : StratagemTabDs,
			pageSize : 25,
			displayInfo : true,
			displayMsg : '当前显示{0} - {1}，共计{2}',
			emptyMsg : "没有记录",
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

// 初始化按钮
var uploadButton = new Ext.Toolbar.Button({
			text : 'Excel数据导入',
			tooltip : '导入数据(Excel格式)',
			iconCls : 'add',
			handler : function() {

				importExcel();

				return;

			}

		});

// 表格
var StratagemTab = new Ext.grid.EditorGridPanel({
			title : '指标数据录入',
			store : StratagemTabDs,
			cm : StratagemTabCm,
			clicksToEdit : 1,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			loadMask : true,
			tbar : ['核算期间:', BonusyearField, '-', periodTypeField, '-',
					periodField, '-', '奖金方案:', SchemeField, '-', '核算单元:',
					UnitField, '-', '核算指标:', TargetField, '-', findButton, '-',
					uploadButton],
			bbar : StratagemTabPagingToolbar
		});
function afterEdit(rowObj) {

	// 定义并初始化行对象长度变量
	var len = rowObj.length;
	// 判断是否选择了要修改的数据
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
								title : '错误',
								msg : '请检查网络连接!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						// Ext.Msg.show({title:'注意',msg:'添加成功!',buttons:
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
						this.store.commitChanges(); // 还原数据修改提

						var view = StratagemTab.getView();
						//view.focusCell(tmpRow, tmpColumn);

					} else {
						var message = "";
						message = "SQLErr: " + jsonData.info;
						// if(jsonData.info=='EmptyRecData') message='输入的数据为空!';
						if (jsonData.info == 'RepCode')
							message = '输入的代码已经存在!';
						if (jsonData.info == 'RepName')
							message = '输入的名称已经存在!';
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
