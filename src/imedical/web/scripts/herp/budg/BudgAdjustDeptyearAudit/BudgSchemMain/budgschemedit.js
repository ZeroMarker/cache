
// ************************************************
var Checker = session['LOGON.USERID'];
var DictSupplierTabUrl = 'herp.budg.budgschemmainexe.csp';

var delButton = new Ext.Toolbar.Button({
	        id : 'delButton',
			text : '删除',
			tooltip : '删除',
			// iconCls:'add',
			handler : function() {
				var rowObj = itemGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				if (len < 1) {
					Ext.Msg.show({
								title : '注意',
								msg : '请选择需要删除的行!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
					return;
				} else {
					myRowid = rowObj[0].get("rowid");
				}
				Ext.Ajax.request({
							url : DictSupplierTabUrl + '?action=change&rowid='
									+ myRowid,
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
									// dataStore.load({params:{start:pagingTool.cursor,limit:pagingTool.pageSize}});
									itemGrid.load(({
												params : {
													start : 0,
													limit : 25
												}
											}));
								} else {
									Ext.Msg.show({
												title : '错误',
												msg : message,
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR
											});
								}
							},
							scope : this
						})

			}
		})

var schemTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '全院'], ['2', '科室']]
		});
var IschemTypeField = new Ext.form.ComboBox({
			id : 'IschemTypeField',
			fieldLabel : '类型',
			width : 120,
			listWidth : 120,
			selectOnFocus : true,
			allowBlank : false,
			store : schemTypeStore,
			anchor : '90%',
			// value:'key', //默认值
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

var IsDBStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', '否'], ['1', '是']]
		});
var IsDBField = new Ext.form.ComboBox({
			id : 'IsDBField',
			fieldLabel : '是否代编',
			width : 70,
			listWidth : 85,
			selectOnFocus : true,
			allowBlank : false,
			store : IsDBStore,
			anchor : '90%',
			// value:'key', //默认值
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
var itemTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '计划指标'], ['2', '收支预算'], ['3', '费用标准'], ['4', '预算结果表']]
		});
var itemTypeField = new Ext.form.ComboBox({
			id : 'itemTypeField',
			fieldLabel : '预算类别',
			width : 70,
			listWidth : 250,
			selectOnFocus : true,
			allowBlank : false,
			store : itemTypeStore,
			anchor : '90%',
			// value:'key', //默认值
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

// ////////////////////////////////////
var smYearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

smYearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgschemmainexe.csp?action=GetYear',
						method : 'POST'
					});
		});

var yearCombo = new Ext.form.ComboBox({
			fieldLabel : '年度',
			store : smYearDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 70,
			listWidth : 120,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
var schemtypeDs = new Ext.data.SimpleStore({
			fields : ['rowid', 'name'],
			data : [['1', '全院'], ['2', '科室']]
		});

var schemTypeCombo = new Ext.form.ComboBox({
			fieldLabel : '方案类别',
			store : schemtypeDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 70,
			listWidth : 145,
			pageSize : 10,
			minChars : 1,
			columnWidth : .12,
			mode : 'local', // 本地模式
			selectOnFocus : true
		});
var schemNo = new Ext.form.TextField({
			columnWidth : .1,
			width : 70,
			columnWidth : .12,
			selectOnFocus : true

		});
var queryPanel = new Ext.FormPanel({
	height : 90,
	region : 'north',
	frame : true,

	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<center><p style="font-weight:bold;font-size:150%">预算编制方案定义</p></center>',
			columnWidth : 1,
			height : '32'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [

		{
					xtype : 'displayfield',
					value : '年度:',
					columnWidth : .03
				}, yearCombo,

				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '方案类别:',
					columnWidth : .05
				}, schemTypeCombo, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '方案名称:',
					columnWidth : .05
				}, schemNo

		]
	}]
});

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
						url : 'herp.budg.budgschemmainexe.csp'
								+ '?action=BudgItem&str='
								+ encodeURIComponent(Ext.getCmp('budgItem')
										.getRawValue()) + '&byear='
								+ yearCombo.getValue(),
						method : 'POST'
					})
		});

var itemcbbox = new Ext.form.ComboBox({
			id : 'budgItem',
			fieldLabel : '预算项目',
			width : 200,
			listWidth : 250,
			allowBlank : false,
			store : itemDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'budgItem',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});
		
//
var checkflowDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

checkflowDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgschemmainexe.csp?action=checkflow',
						method : 'POST'
					})
		});

var checkflowbox = new Ext.form.ComboBox({
			id : 'checkflow',
			fieldLabel : '预算项目',
			width : 220,
			//listWidth : 125,
			allowBlank : false,
			store : checkflowDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'checkflow',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});

var checkbotton = new Ext.Toolbar.Button({
	text: '审核',
	tooltip: '审核',
	iconCls: 'option',
	handler: function(){
	
		var rowObj = itemGrid.getSelectionModel().getSelections();		
		var len = rowObj.length;
		if(len < 1)
		{
			Ext.Msg.show({title:'注意',msg:'请选择需要审核的方案!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			rowid = rowObj[0].get("rowid");	
			Ext.MessageBox.confirm('提示','确定要审核选定的方案吗?',function(btn){
			if(btn == 'yes'){
			Ext.Ajax.request({
				url: DictSupplierTabUrl + '?action=updcheck&rowid='+rowid+'&Checker='+Checker,
				waitMsg:'审核中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success=='true') {
						Ext.Msg.show({title:'注意',msg:'操作成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							itemGrid.load({params:{start:0,limit:25}});
					}else{
						Ext.Msg.show({title:'错误',msg:'错误',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});   	
				}
				} 
			)	
		}
	
	
	}
	
});		

var uncheckbotton = new Ext.Toolbar.Button({
	text: '取消审核',
	tooltip: '取消审核',
	iconCls: 'option',
	handler: function(){
	
		var rowObj = itemGrid.getSelectionModel().getSelections();		
		var len = rowObj.length;
		if(len < 1)
		{
			Ext.Msg.show({title:'注意',msg:'请选择需要取消审核的方案!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			rowid = rowObj[0].get("rowid");	
			Ext.MessageBox.confirm('提示','确定要取消审核选定的方案吗?',function(btn){
			if(btn == 'yes'){
			Ext.Ajax.request({
				url: DictSupplierTabUrl + '?action=unupdcheck&rowid='+rowid+'&Checker='+Checker,
				waitMsg:'审核中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success=='true') {
						Ext.Msg.show({title:'注意',msg:'操作成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							itemGrid.load({params:{start:0,limit:25}});
					}else{
						Ext.Msg.show({title:'错误',msg:'错误',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});   	
				}
				} 
			)	
		}
	
	
	}
	
});	
		
var itemGrid = new dhc.herp.Grid({
			width : 400,
			region : 'center',
			url : 'herp.budg.budgschemmainexe.csp',
			
			listeners : {
		    'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                 var record = grid.getStore().getAt(rowIndex);
		                 if ((record.get('IsCheck') =="审核")&&((columnIndex==2)||(columnIndex==3)||(columnIndex==4)||(columnIndex==5)||(columnIndex==6)||(columnIndex==7)||(columnIndex==8)||(columnIndex==12)||(columnIndex==13)||(columnIndex==14))) {
		                      return false;
		                  } else if((record.get('rowid')=="")&&((columnIndex==9)||(columnIndex==10)||(columnIndex==11))){
		                  		return false;
		                  }
		                  else {return true;}
		               },
		    'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
					if ((record.get('IsCheck') =="审核")&&((columnIndex==2)||(columnIndex==3)||(columnIndex==4)||(columnIndex==5)||(columnIndex==6)||(columnIndex==7)||(columnIndex==8)||(columnIndex==12)||(columnIndex==13)||(columnIndex==14))) {
		                      return false;
					} else if((record.get('rowid')=="")&&((columnIndex==9)||(columnIndex==10)||(columnIndex==11))){
		                 return false;
		           }
		           else {
							return true;
					}
				}
        	},
			fields : [{
						//id: 'rowid',
						header : 'ID',
						dataIndex : 'rowid',
						//print : false,
						hidden : true
					}, {
						id : 'Year',
						header : '年度',
						dataIndex : 'Year',
						width : 30,
						hidden : false

					}, {
						id : 'Code',
						header : '方案编码',
						width : 50,
						allowBlank : false,
						dataIndex : 'Code'

				}	, {
						id : 'Name',
						header : '方案名称',
						width : 190,
						allowBlank : false,
						dataIndex : 'Name'

					}, {
						id : 'UnitType',
						header : '方案属性',
						width : 40,
						//allowBlank : false,
						type : IschemTypeField,
						dataIndex : 'UnitType'

					}, {
						id : 'Type',
						header : '预算类别',
						//allowBlank : false,
						width : 60,
						type : itemTypeField,
						dataIndex : 'Type'

					}, {
						id : 'OrderBy',
						header : '编制顺序',
						width : 30,
						dataIndex : 'OrderBy'

					}, {
						id : 'ItemCode',
						header : '结果预算项',
						width : 90,
						type : itemcbbox,
						dataIndex : 'ItemCode'

					}, {
						id:'qzfa',
						header : '前置方案',
						editable : false,
						width : 40,
						align : 'center',
						print : false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['rowid']
						if (sf != "") {
							return '<span style="color:blue;cursor:hand"><u>设置</u></span>';
						} else {
							return '<span style="color:gray;cursor:hand"></span>';
						}},
						dataIndex : 'SupSchem'

					}, {
						id:'nrsz',
						header : '内容设置',
						editable : false,
						width : 40,
						align : 'center',
						print : false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['rowid']
						if (sf != "") {
							return '<span style="color:blue;cursor:hand"><u>编辑</u></span>';
						} else {
							return '<span style="color:gray;cursor:hand"></span>';
						}},
						dataIndex : 'ctSet'

					}, {
						id:'copy',
						header : '内容复制 ',
						editable : false,
						width : 40,
						print : false,
						align : 'center',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['rowid']
						if (sf != "") {
							return '<span style="color:blue;cursor:hand"><u>复制</u></span>';
						} else {
							return '<span style="color:gray;cursor:hand"></span>';
						}},
						dataIndex : 'ctCopy'

					}, {
						id : 'IsHelpEdit',
						header : '是否代编',
						width : 40,
						type : IsDBField,
						dataIndex : 'IsHelpEdit'

					}, {
						id:'IsCheck',
						header : '审核状态', 
						width : 60,
						editable : false,
						dataIndex : 'IsCheck'

					}, {
						id:'ChkFlowName',
						header : '审批流', 
						width : 650,
						type: checkflowbox,
						dataIndex : 'ChkFlowName'

					}],
					viewConfig : {forceFit : true},
					atLoad : true//, // 是否自动刷新					
//
		});
// 主页面查询
var findButton = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '查询',
			iconCls:'find',
			handler : function() {
				// var billMakerTimeEnd
				// =((billMakerTimeTo.getValue()=='')?'':billMakerTimeTo.getValue().format('Y-m-d'));
				var syear = yearCombo.getValue();
				
				var sSchemType = schemTypeCombo.getValue();
				//alert(sSchemType);
				var sSchemeName = schemNo.getValue();

				itemGrid.load({
							params : {
								start : 0,
								limit : 25,
								byear : syear,
								schemtype : sSchemType,
								str : sSchemeName
							}
						});

			}
			
		})

// 给主页面添加查询按钮
	itemGrid.addButton(findButton);
	itemGrid.addButton('-');
	itemGrid.addButton(checkbotton);
	itemGrid.addButton('-');
	itemGrid.addButton(uncheckbotton);
	
// itemgrid.hiddenbutton(3);
// itemGrid.hiddenButton(4);
//itemGrid.btnPrintHide()
// 单击gird的单元格事件

itemGrid.on('rowclick',function(grid,rowIndex,e){
	var records = itemGrid.getSelectionModel().getSelections();
	var IsCheck = records[0].get("IsCheck");
	var tbar = itemGrid.getTopToolbar();
	var tbutton = tbar.get('herpDeleteId');
	
	if(IsCheck=='审核'){
		
		tbutton.hide();
		
	}else{
	
		tbutton.show();
		}

});

itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	
		
	// 前置方案设置
	//alert(columnIndex);
	if (columnIndex == 9) {
	 
		
		var records = itemGrid.getSelectionModel().getSelections();
		var schmDr = records[0].get("rowid")
		var IsCheck = records[0].get("IsCheck")
		var schmName = records[0].get("Name")
		var orderindex = records[0].get("OrderBy")
		var syear = records[0].get("Year")

		// 预算方案编辑页面
		supSchemeFun(schmDr, IsCheck,schmName, syear, orderindex);
		//alert("hello");
	}
		// 预算方案明细添加
	if (columnIndex == 10) {
		var records = itemGrid.getSelectionModel().getSelections();
		var schmDr = records[0].get("rowid")
		var IsCheck = records[0].get("IsCheck")
		var schmName = records[0].get("Name")
		var syear = records[0].get("Year")
		
		//alert(schmDr+':'+schmName+':'+syear)
		// 预算方案明细编制
		schemeDetailFun(schmDr,IsCheck,schmName,syear);
		//alert("hello");
	}

	// 预算方案复制
	if (columnIndex == 11) {
		Ext.MessageBox.confirm('提示', '确定要复制选定的方案吗', function(btn) {
			if (btn == 'yes') {
				var records = itemGrid.getSelectionModel().getSelections();
				var schmDr = records[0].get("rowid")
				var surl = 'herp.budg.budgschemmainexe.csp?action=copysheme&rowid='
						+ schmDr;

				itemGrid.saveurl(surl)
			}
		});
	}

})
