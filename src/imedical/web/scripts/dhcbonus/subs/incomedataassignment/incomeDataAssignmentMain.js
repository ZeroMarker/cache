var incomecollectUrl = 'dhc.bonus.incomedataassignmentexe.csp';
var OutKPIDataProxy = new Ext.data.HttpProxy({
			url : incomecollectUrl + '?action=list'
		});

var cycleDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

cycleDs.on('beforeload', function(ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.bonustargetcollectexe.csp?action=yearlist',
				method : 'POST'
			})
});

var cycleField = new Ext.form.ComboBox({
			id : 'cycleField',
			fieldLabel : '考核周期',
			width : 70,
			listWidth : 150,
			allowBlank : false,
			store : cycleDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText:'年度',
			name : 'cycleField',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});

var periodTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['M', '月'], ['Q', '季'], ['H', '半年'], ['Y', '年']]
		});
var periodTypeField = new Ext.form.ComboBox({
			id : 'periodTypeField',
			fieldLabel : '期间类型',
			selectOnFocus : true,
			width : 70,
			listWidth : 150,
			allowBlank : false,
			store : periodTypeStore,
			anchor : '90%',
			value : '', // 默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '期间类型',
			mode : 'local', // 本地模式
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});

periodTypeField.on("select", function(cmb, rec, id) {
	if (cmb.getValue() == "M") {
		data = [['01', '01月'], ['02', '02月'], ['03', '03月'], ['04', '04月'],
				['05', '05月'], ['06', '06月'], ['07', '07月'], ['08', '08月'],
				['09', '09月'], ['10', '10月'], ['11', '11月'], ['12', '12月']];
	}
	if (cmb.getValue() == "Q") {
		data = [['01', '01季度'], ['02', '02季度'], ['03', '03季度'], ['04', '04季度']];
	}
	if (cmb.getValue() == "H") {
		data = [['01', '1~6上半年'], ['02', '7~12下半年']];
	}
	if (cmb.getValue() == "Y") {
		data = [['00', '全年']];
	}
	periodStore.loadData(data);
});
periodStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue']
		});

var periodField = new Ext.form.ComboBox({
			id : 'periodField',
			fieldLabel : '',
			selectOnFocus : true,
			allowBlank : false,
			width : 70,
			listWidth : 150,
			store : periodStore,
			anchor : '90%',
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '期间',
			mode : 'local', // 本地模式
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});

var locSetDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name', 'shortcut'])
		});

locSetDs.on('beforeload', function(ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
		url : 'dhc.bonus.incomedataassignmentexe.csp?action=locsetSublist',
		method : 'POST'
	})
});

var locSetField = new Ext.form.ComboBox({
			id : 'locSetField',
			fieldLabel : '接口套:',
			width : 100,
			listWidth : 150,
			allowBlank : false,
			store : locSetDs,
			valueField : 'rowid',
			displayField : 'shortcut',
			triggerAction : 'all',
			emptyText : '',
			name : 'locSetField',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});

var interMedthodDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

interMedthodDs.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'dhc.bonus.intermethodexe.csp?action=InterMethod2&interLocSetDr='
						+ locSetField.getValue() + '&start=0&limit=10',
				method : 'POST'
			})
});
locSetField.on("select", function(cmb, rec, id) {

			interMedthodDs.load({
						params : {
							interLocSetDr : Ext.getCmp('locSetField')
									.getValue(),
							start : 0,
							limit : 10
						}
					});
		});
var interMethodField = new Ext.form.ComboBox({
			id : 'interMethodField',
			fieldLabel : '接口方法',
			width : 100,
			height : 200,
			listWidth : 200,
			allowBlank : false,
			store : interMedthodDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'interMethodField',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});

var IncomeCollect = new Ext.data.Store({
			proxy : OutKPIDataProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['rowid',
					'unitDr',
					'unitName',
					'itemDr', 
					'itemName',
					'year', 
					'period',
					'unitType',
					'unitTypeName', 
					'expensesType',
					'expensesTypeName', 
					'sickType',
					'sickTypeName', 
					'chiefDoctorDr',
					'chiefDoctorName', 
					'makeBillDoctorDr',
					'makeBillDoctorName',
					'executeDoctorDr',
					'executeDoctorName', 
					'incomeMoney',
					'incomeRate',
					'resultMoney',
					'state',
					'stateName',
					'updateDate',
					'kdDeptDr',
					'kdDeptName',
					'zxDeptDr',
					'zxDeptName',
					'brDeptDr',
					'brDeptName'
				]), 
			remoteSort : true
		});

IncomeCollect.setDefaultSort('rowid', 'DESC');

var OutKPIDataCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer()
, {
			header : '核算年度',
			dataIndex : 'year',
			width : 70,
			align : 'center',
			sortable : true
		}, {
			header : '核算期间',
			dataIndex : 'period',
			width : 70,
			align : 'center',
			sortable : true
		}, {
			header:'核算单元名称',
			dataIndex:'unitName',
			width:80,
			align:'center',
			sortable:true
		}, {
			header : '核算单元类别',
			dataIndex : 'unitTypeName',
			width : 80,
			align : 'center',
			sortable : true
		}, {
			header : '收费项目名称',
			dataIndex : 'itemName',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : " 费用类别",
			dataIndex : 'expensesTypeName',
			width : 80,
			align : 'center',
			sortable : true
		}, {
			header : " 开单科室",
			dataIndex : 'kdDeptName',
			width : 80,
			align : 'center',
			sortable : true
		}, {
			header : " 执行科室",
			dataIndex : 'zxDeptName',
			width : 80,
			align : 'center',
			sortable : true
		}, {
			header : " 病人科室",
			dataIndex : 'brDeptName',
			width : 80,
			align : 'center',
			sortable : true
		}, {
			header : '收入金额',
			dataIndex : 'incomeMoney',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : '计提系数',
			dataIndex : 'incomeRate',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : '计提金额',
			dataIndex : 'resultMoney',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : '数据状态',
			dataIndex : 'stateName',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : '数据日期',
			dataIndex : 'updateDate',
			width : 100,
			align : 'right',
			sortable : true
		}
]);
var incomeDataAssignmentButton = new Ext.Toolbar.Button({
	text:'收入数据分解',
	tooltip:'收入数据分解',
	iconCls:'add',
	handler:function() {
		var cycleDr = Ext.getCmp('cycleField').getValue();
		if (cycleDr == "") {
			Ext.Msg.show({title : '提示',msg : '请选择年度!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		var fre = Ext.getCmp('periodTypeField').getValue();
		if (fre == "") {
			Ext.Msg.show({title : '提示',msg : '请选择区间类别!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		var quote = Ext.getCmp('periodField').getValue();
		if (quote == "") {
			Ext.Msg.show({title : '提示',msg : '请选择区间!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		var interSetDr = Ext.getCmp('locSetField').getValue();
		if (interSetDr == "") {
			Ext.Msg.show({title : '提示',msg : '请选择接口套!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		var interMethod = Ext.getCmp('interMethodField').getValue();
		if (interMethod == "") {
			Ext.Msg.show({title : '提示',msg : '请选择接口方法!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		//alert(cycleDr+"^"+fre+"^"+quote+"^"+interSetDr+"^"+interMethod);
		
		Ext.MessageBox.confirm('提示', '确定要分解吗?', function(btn) {
			if (btn=='yes') {
				Ext.Ajax.request({
					url:'../csp/dhc.bonus.incomedataassignmentexe.csp?action=assignment&cycleDr='+cycleDr+'&fre='+fre+'&quote='+quote+'&interSetDr='+interSetDr+'&interMethod='+interMethod,
					waitMsg:'分解中...',
					failure:function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success:function(result, request){
						var jsonData=Ext.util.JSON.decode(result.responseText);
						if(jsonData.success=='0'){
							Ext.Msg.show({title:'提示',msg:'分解成功！',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							IncomeCollect.load({params:{start:0,limit:PagingToolbar.pageSize,cycleDr:cycleDr,fre:fre,quote:quote,interSetDr:interSetDr,interMethod:interMethod}});
						}else{
							Ext.Msg.show({title:'提示',msg:'分解失败！',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
					},
					scope : this
				});
			}
		});
	}
});

var delButton = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'add',
	handler:function() {
		var cycleDr = Ext.getCmp('cycleField').getValue();
		if (cycleDr == "") {
			Ext.Msg.show({title : '提示',msg : '请选择年度!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		var fre = Ext.getCmp('periodTypeField').getValue();
		if (fre == "") {
			Ext.Msg.show({title : '提示',msg : '请选择区间类别!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		var quote = Ext.getCmp('periodField').getValue();
		if (quote == "") {
			Ext.Msg.show({title : '提示',msg : '请选择区间!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		var interSetDr = Ext.getCmp('locSetField').getValue();
		if (interSetDr == "") {
			Ext.Msg.show({title : '提示',msg : '请选择接口套!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		var interMethod = Ext.getCmp('interMethodField').getValue();
		if (interMethod == "") {
			Ext.Msg.show({title : '提示',msg : '请选择接口方法!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		
		Ext.MessageBox.confirm('提示', '确定要删除吗？', function(btn) {
			if (btn=='yes') {
				Ext.Ajax.request({
					url:'../csp/dhc.bonus.incomedataassignmentexe.csp?action=del&cycleDr='+cycleDr+'&fre='+fre+'&quote='+quote+'&interSetDr='+interSetDr+'&interMethod='+interMethod,
					waitMsg:'删除中...',
					failure:function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success:function(result, request){
						var jsonData=Ext.util.JSON.decode(result.responseText);
						if(jsonData.success=='0'){
							Ext.Msg.show({title:'提示',msg:'删除成功！',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							IncomeCollect.load({params:{start:0,limit:PagingToolbar.pageSize,cycleDr:cycleDr,fre:fre,quote:quote,interSetDr:interSetDr,interMethod:interMethod}});
						}else{
							Ext.Msg.show({title:'提示',msg:'删除失败！',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
					},
					scope : this
				});
			}
		});
	}
});


var findDataButton = new Ext.Toolbar.Button({
	text:'查询',
	tooltip:'查询',
	iconCls:'add',
	handler:function() {
		var cycleDr = Ext.getCmp('cycleField').getValue();
		if (cycleDr == "") {
			Ext.Msg.show({title : '提示',msg : '请选择年度!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		var fre = Ext.getCmp('periodTypeField').getValue();
		if (fre == "") {
			Ext.Msg.show({title : '提示',msg : '请选择区间类别!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		var quote = Ext.getCmp('periodField').getValue();
		if (quote == "") {
			Ext.Msg.show({title : '提示',msg : '请选择区间!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		var interSetDr = Ext.getCmp('locSetField').getValue();
		if (interSetDr == "") {
			Ext.Msg.show({title : '提示',msg : '请选择接口套!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		var interMethod = Ext.getCmp('interMethodField').getValue();
		if (interMethod == "") {
			Ext.Msg.show({title : '提示',msg : '请选择接口方法!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		
		IncomeCollect.load({params:{start:0,limit:PagingToolbar.pageSize,cycleDr:cycleDr,fre:fre,quote:quote,interSetDr:interSetDr,interMethod:interMethod}});
	}
});


var OutKPIDataSearchField = 'sickTypeName';
var OutKPIDataFilterItem = new Ext.SplitButton({
			text:'过滤器',
			tooltip:'关键字所属类别',
			menu:{
				items:[new Ext.menu.CheckItem({
									text : '病人类别',
									value : 'sickTypeName',
									checked : false,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								}), new Ext.menu.CheckItem({
									text : '核算单元',
									value : 'unitName',
									checked : true,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								}), new Ext.menu.CheckItem({
									text : '费用类别',
									value : 'expensesTypeName',
									checked : false,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								}), new Ext.menu.CheckItem({
									text : '收费项目',
									value : 'itemName',
									checked : false,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								}), new Ext.menu.CheckItem({
									text : '数据日期',
									value : 'updateDate',
									checked : false,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								})]
			}
		});

function onOutKPIDataItemCheck(item, checked) {
	if (checked) {
		OutKPIDataSearchField = item.value;
		OutKPIDataFilterItem.setText(item.text + ':');
	}
};

var OutKPIDataSearchBox = new Ext.form.TwinTriggerField({// 查找按钮
	width : 180,
	trigger1Class : 'x-form-clear-trigger',
	trigger2Class : 'x-form-search-trigger',
	emptyText : '搜索...',
	listeners : {
		specialkey : {
			fn : function(field, e) {
				var key = e.getKey();
				if (e.ENTER === key) {
					this.onTrigger2Click();
				}
			}
		}
	},
	grid : this,
	onTrigger1Click : function() {
		if (this.getValue()) {
			this.setValue('');
			IncomeCollect.proxy = new Ext.data.HttpProxy({
						url : incomecollectUrl + '?action=list&cycleDr='
								+ cycleField.getValue() + '&fre='
								+ periodTypeField.getValue() + '&quote='
								+ periodField.getValue() + '&interSetDr='
								+ locSetField.getValue() + '&interMethod='
								+ interMethodField.getValue()
					});
			IncomeCollect.load({
						params : {
							start : 0,
							limit : PagingToolbar.pageSize
						}
					});
		}
	},
	onTrigger2Click : function() {
		if (this.getValue()) {
			IncomeCollect.proxy = new Ext.data.HttpProxy({
						url : incomecollectUrl + '?action=list&searchField='
								+ OutKPIDataSearchField + '&searchValue='
								+ this.getValue() + '&cycleDr='
								+ cycleField.getValue() + '&fre='
								+ periodTypeField.getValue() + '&quote='
								+ periodField.getValue() + '&interSetDr='
								+ locSetField.getValue() + '&interMethod='
								+ interMethodField.getValue()
					});
			IncomeCollect.load({
						params : {
							start : 0,
							limit : PagingToolbar.pageSize
						}
					});
		}
	}
});

var PagingToolbar = new Ext.PagingToolbar({// 分页工具栏
	pageSize : 25,
	store : IncomeCollect,
	displayInfo : true,
	displayMsg : '当前显示{0} - {1}，共计{2}',
	emptyMsg : "没有数据",
	buttons : ['-',OutKPIDataFilterItem,'-',OutKPIDataSearchBox]
});

var IncomeDataAssignmentMain = new Ext.grid.GridPanel({// 表格
	title : '收入数据分解',
	store : IncomeCollect,
	cm : OutKPIDataCm,
	trackMouseOver : true,
	region : 'center',
	stripeRows : true,
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask : true,
	frame : true,
	clicksToEdit : 2,
	stripeRows : true,
	tbar : ['核算年度:',cycleField,'-',periodTypeField,'-',periodField,'-','接口套:',locSetField,'-','接口方法:',interMethodField,'-',findDataButton,'-',incomeDataAssignmentButton,'-',delButton],
	bbar : PagingToolbar
});
