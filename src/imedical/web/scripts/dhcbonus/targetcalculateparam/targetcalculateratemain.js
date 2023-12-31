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
// 核算单元类别
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
			fieldLabel : '单元类别',
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
										title : '错误',
										msg : '核算单元不能为空!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR,
										fn : Handler
									});
						}
					}
				}
			}
		});

// 核算类别单元联动
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
// 核算单元上级
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
			fieldLabel : '所属科室',
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
										title : '错误',
										msg : '所属单位不能为空!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR,
										fn : Handler
									});
						}
					}
				}
			}
		});

// 核算类别单元联动
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
			fieldLabel : '核算单元',
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
			fieldLabel : '核算指标',
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

// 审核状态
var StateDs = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', '未审核'], ['1', '审核']]
		});

var StateField = new Ext.form.ComboBox({
			id : 'StateField',
			fieldLabel : '审核状态',
			width : 80,
			listWidth : 80,
			selectOnFocus : true,
			allowBlank : false,
			store : StateDs,
			// anchor: '90%',
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

// 配件数据源
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

// 设置默认排序字段和排序方向
StratagemTabDs.setDefaultSort('rowid', 'desc');

// 数据库数据模型
var StratagemTabCm = new Ext.grid.ColumnModel([
		new Ext.grid.CheckboxSelectionModel(), {
			header : '奖金方案',
			dataIndex : 'BonusSchemeName',
			width : 200,
			sortable : true

		}, {
			header : '方案状态',
			dataIndex : 'SchemeState',
			width : 100,
			sortable : true

		}, {
			header : '所属上级',
			dataIndex : 'unitSuperName',
			width : 90,
			sortable : true

		}, {
			header : '核算单元',
			dataIndex : 'UnitName',
			width : 100,
			sortable : true
			// unitSuperName

	}	, {
			header : '单元类别',
			dataIndex : 'UnitTypeName',
			width : 90,
			sortable : true

		}, {
			header : '指标名称',
			width : 120,
			dataIndex : 'TargetName',
			sortable : true

		}, {
			header : "核算项单位",
			dataIndex : 'TargetUnitName',
			width : 80,
			align : 'left',
			sortable : true

		}, {
			header : "计提系数",
			dataIndex : 'TargetRate',
			width : 80,
			align : 'right',
			sortable : true
		}]);

// 初始化默认排序功能
StratagemTabCm.defaultSortable = true;

// 查询按钮
var findButton = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '查询',
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
	text : '删除',
	tooltip : '删除',
	iconCls : 'add',
	handler : function() {
		// 定义并初始化行对象
		var rowObj = StratagemTab.getSelections();
		// 定义并初始化行对象长度变量
		var len = rowObj.length;
		// 判断是否选择了要修改的数据
		// alert(len);
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
			var state = rowObj[0].get("SchemeState");
			// alert(state);
			if (state == "审核完成") {
				Ext.Msg.show({
							title : '注意',
							msg : '该条数据方案已经被审核,不允许删除!',
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
											title : '错误',
											msg : '数据已审核,删除失败!',
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
		Ext.MessageBox.confirm('提示', '确实要删除目标记录吗?', handler);
	}
});

// 分页工具栏
var StratagemTabPagingToolbar = new Ext.PagingToolbar({
			store : StratagemTabDs,
			pageSize : 20,
			displayInfo : true,
			displayMsg : '第 {0} 条到 {1}条 ，一共 {2} 条',
			emptyMsg : "没有记录"  ,
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
// 表格
var StratagemTab = new Ext.grid.EditorGridPanel({
			title : '固定指标设置',
			store : StratagemTabDs,
			cm : StratagemTabCm,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.CheckboxSelectionModel({
						singleSelect : false
					}),
			loadMask : true,//
			tbar : ['奖金方案:', SchemeField, '-', '单元类别:', UnitTypeField, '-',
					'所属科室:', UnitSuperField, '-', '核算单元:', UnitField, '-',
					'核算指标:', TargetField, '-', findButton, '-', addButton, '-',
					editButton, '-', DelButton],
			bbar : StratagemTabPagingToolbar
		});
