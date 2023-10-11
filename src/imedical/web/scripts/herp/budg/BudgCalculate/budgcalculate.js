
// ************************************************
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var budgDataInitUrl = 'herp.budg.budgcalculateexe.csp';

var calculateButton = new Ext.Toolbar.Button({
			text : '计算',
			tooltip : '计算',
			// iconCls:'add',
			width : 70,
			handler : function() {
				var syear= yearCombo.getValue();
				if(syear==""){
					Ext.Msg.show({title:'错误',msg:'年度不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				};
				
				var Schemname= SchemCombo.getValue();
				if(Schemname==""){
					Ext.Msg.show({title:'错误',msg:'方案名称不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				};
				
				function handler(id) {
					if (id == 'yes') {
						Ext.Ajax.request({
								url : budgDataInitUrl + '?action=yearbudgetingdeptsplit&year='
										+ syear+'&schemdr='+Schemname+'&ChangeFlag=1&AdjustNo=0',
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
													msg : '计算成功!',
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
							})
					}
				}
				Ext.MessageBox.confirm('提示','确实要计算吗?',handler);			
				}
		})


// //////////////年度//////////////////////
var smYearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['year', 'year'])
		});

smYearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgcommoncomboxexe.csp?action=year',
						method : 'POST'
					});
		});

var yearCombo = new Ext.form.ComboBox({
			fieldLabel : '年度',
			store : smYearDs,
			displayField : 'year',
			valueField : 'year',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .13,
			selectOnFocus : true,
                        listeners:{
            	        select:{fn:function(combo,record,index) { 
                	SchemDs.removeAll();
                	SchemCombo.setValue('');     				
                  SchemDs.load({params:{start:0,limit:10,year:combo.value}});
            	}}
         	}
		});
yearCombo.on("select",function(cmb,rec,id ){
	SchemCombo.setValue("");
	}
);


// ////////////方案名称////////////////////////
var SchemDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

SchemDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgcalculateexe.csp?action=SchemList&year='+yearCombo.getValue(),
						method : 'POST'
					});
		});

var SchemCombo = new Ext.form.ComboBox({
			fieldLabel : '方案名称',
			store : SchemDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .15,
			selectOnFocus : true
		});


var queryPanel = new Ext.FormPanel({
	height : 90,
	region : 'center',
	frame : true,

	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<center><p style="font-weight:bold;font-size:150%">科室年度预算分解计算</p></center>',
			columnWidth : 1,
			height : '30'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
					xtype : 'displayfield',
					value : '年度:',
					columnWidth : .03
				}, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .002
				}, yearCombo,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '方案名称:',
					columnWidth : .05
				}, SchemCombo, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}

		]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
					xtype : 'displayfield',
					value : '',
					columnWidth : .25
				}, calculateButton

		]
	},{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<p style="color:red;font-size:100%">说明：****科室年度预算分解计算****</p>',
			columnWidth : 1,
			height : '30'
		}]
	},{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<p style="color:red;font-size:100%">@@@：****自编页面计算的批量处理,根据方案的要分解的预算项，对所有科室分解到年****</p>',
			columnWidth : 1,
			height : '30'
		}]
	}]
});

/*
// 主页面查询
var findButton = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '查询',
			// iconCls:'add',
			handler : function() {
				// var billMakerTimeEnd
				// =((billMakerTimeTo.getValue()=='')?'':billMakerTimeTo.getValue().format('Y-m-d'));
				var syear = yearCombo.getValue();
				var sSchemType = schemTypeCombo.getValue();
				var sSchemeName = schemNo.getValue();

			},
			iconCls : 'add'
		})
*/
// 给主页面添加查询按钮

// itemGrid.hiddenButton(3);
// itemGrid.hiddenButton(4);
