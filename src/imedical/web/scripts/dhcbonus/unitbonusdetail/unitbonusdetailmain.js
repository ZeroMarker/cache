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

function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}

var value = "http: //www.baidu.com";

function DomUrl() {

	return "<a href=>" + value + "</a>";
}

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
			listWidth : 150,
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
						+ Ext.getCmp('SchemeField').getValue() + '&userCode='
						+ session['LOGON.USERCODE'],
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
								+ Ext.getCmp('SchemeField').getValue()
								+ '&userCode=' + session['LOGON.USERCODE'],
						method : 'POST'
					})
		});

var UnitField = new Ext.form.ComboBox({
			id : 'UnitField',
			fieldLabel : '核算单元',
			width : 80,
			listWidth : 120,
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
// 奖金核算项
var ItemDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

ItemDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : StratagemTabUrl + '?action=siunit&str='
								+ Ext.getCmp('ItemField').getRawValue()
								+ '&SchemeID='
								+ Ext.getCmp('SchemeField').getValue(),
						method : 'POST'
					})
		});

var ItemField = new Ext.form.ComboBox({
			id : 'ItemField',
			fieldLabel : '奖金核算项',
			width : 100,
			listWidth : 120,
			allowBlank : false,
			store : ItemDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '请选择奖金核算项...',
			name : 'ItemField',
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
			ItemField.setValue("");
			ItemField.setRawValue("");
			ItemDs.load({
						params : {
							start : 0,
							limit : StratagemTabPagingToolbar.pageSize
						}
					});

		});

function searchFun(SetCfgDr) {
	ItemDs.proxy = new Ext.data.HttpProxy({
				url : '../csp/unitbonusdetailexe.csp?action=siunit&str='
						+ Ext.getCmp('ItemField').getRawValue() + '&SchemeID='
						+ Ext.getCmp('SchemeField').getValue(),
				method : 'POST'
			});
	ItemDs.load({
				params : {
					start : 0,
					limit : StratagemTabPagingToolbar.pageSize
				}
			});
};
// 配件数据源
var StratagemTabUrl = '../csp/dhc.bonus.unitbonusdetailexe.csp';
var StratagemTabProxy = new Ext.data.HttpProxy({
			url : StratagemTabUrl + '?action=list'
		});
var StratagemTabDs = new Ext.data.Store({
			proxy : StratagemTabProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['rowid', 'BonusYear', 'BonusSchemeID', 'BonusPeriod',
							'PeriodName', 'UnitID', 'UnitName', 'ItemID',
							'ItemName', 'BonusValue', 'UpdateDate'

					]),

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
			width : 80,
			sortable : true
		}, {
			header : '核算期间',
			dataIndex : 'PeriodName',
			width : 80,
			sortable : true
		}, {
			header : '奖金核算项',
			width : 150,
			dataIndex : 'ItemName',
			sortable : true

		}, {
			header : "奖金金额",
			dataIndex : 'BonusValue',
			width : 80,
			align : 'left',
			css : 'background:#d0def0;color:#000000',
			sortable : true,
			editor : new Ext.form.TextField({
						allowBlank : true,
						plugins : new FormPlugin("金额为数字")
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
			dataIndex : 'ItemID',
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
			text : '初始化',
			tooltip : '初始化',
			iconCls : 'add',
			handler : function() {
				var BonusYear = Ext.getCmp('BonusyearField').getValue();
				var BonusPeriod = Ext.getCmp('periodField').getValue();
				var UnitID = Ext.getCmp('UnitField').getValue();
				var ItemID = Ext.getCmp('ItemField').getValue();
				var BonusSchemeID = Ext.getCmp('SchemeField').getValue();
				var userCode = session['LOGON.USERCODE'];
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
								ItemID : ItemID,
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
			displayMsg : '第 {0} 条到 {1}条 ，一共 {2} 条',
			emptyMsg : "没有记录",
			// buttons: ['-',StratagemFilterItem,'-',StratagemSearchBox],
			doLoad : function(C) {
				var B = {}, A = this.paramNames;
				B[A.start] = C;
				B[A.limit] = this.pageSize;
				if (this.fireEvent("beforechange", this, B) !== false) {
					this.store.load({
								params : B
							});
				}
			}
		});
// 初始化按钮
var uploadButton = new Ext.Toolbar.Button({
			text : '导入数据',
			tooltip : '导入数据(Excel格式)',
			iconCls : 'add',
			handler : function() {

				importExcel();

				return;

			}

		});

// 表格
var StratagemTab = new Ext.grid.EditorGridPanel({
			title : '奖金数据录入',
			store : StratagemTabDs,
			cm : StratagemTabCm,
			trackMouseOver : true,
			clicksToEdit : 1,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			loadMask : true,
			tbar : ['核算期间:', BonusyearField, '-', periodTypeField, '-',
					periodField, '-', '奖金方案:', SchemeField, '-', '核算单元:',
					UnitField, '-', '奖金核算项:', ItemField, '-', findButton, '-',
					uploadButton],
			bbar : StratagemTabPagingToolbar
		});
function afterEdit(rowObj) {

	var len = rowObj.length;
	// 判断是否选择了要修改的数据
	var rowid = rowObj.record.get("rowid");
	var UnitID = rowObj.record.get("UnitID");
	var BonusYear = rowObj.record.get("BonusYear");
	var BonusPeriod = rowObj.record.get("BonusPeriod");
	var ItemID = rowObj.record.get("ItemID");
	var BonusValue = rowObj.record.get("BonusValue");
	var UpdateDate = rowObj.record.get("UpdateDate");
	var data = UnitID.trim() + "^" + BonusYear.trim() + "^"
			+ BonusPeriod.trim() + "^" + ItemID.trim() + "^"
			+ BonusValue.trim() + "^" + UpdateDate.trim();
			
	// 
	var BonusSchemeID = SchemeField.getValue();
	alert(BonusSchemeID);
	Ext.Ajax.request({
				// url: StratagemTabUrl+'?action=add&data='+data,
				url : StratagemTabUrl + '?action=add&UnitID=' + UnitID
						+ '&BonusYear=' + BonusYear + '&BonusPeriod='
						+ BonusPeriod + '&ItemID=' + ItemID + '&BonusValue='
						+ BonusValue + '&UpdateDate=' + UpdateDate+ '&BonusSchemeID='+BonusSchemeID,
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
						var ItemID = Ext.getCmp('ItemField').getValue();
						var BonusSchemeID = Ext.getCmp('SchemeField')
								.getValue();
						var userCode = session['LOGON.USERCODE'];
						StratagemTabDs.load({
									params : {
										start : 0,
										limit : StratagemTabPagingToolbar.pageSize,
										BonusYear : BonusYear,
										BonusPeriod : BonusPeriod,
										ItemID : ItemID,
										UnitID : UnitID,
										BonusSchemeID : BonusSchemeID,
										userCode : userCode
									}
								});
						this.store.commitChanges(); // 还原数据修改提

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
StratagemTabDs.load({
			params : {
				start : 0,
				limit : StratagemTabPagingToolbar.pageSize
			}
		})
StratagemTab.on("afteredit", afterEdit, StratagemTab);
