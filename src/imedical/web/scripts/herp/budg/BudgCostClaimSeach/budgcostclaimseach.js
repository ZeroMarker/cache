
var Checker = session['LOGON.USERID'];
var DictSupplierTabUrl = 'herp.budg.budgschemmainexe.csp';
var projUrl = 'herp.budg.costclaimapplyexe.csp';
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';

///核算期间下拉框
  ///开始年月
var YearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['year', 'year'])
		});

YearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
                              url : commonboxUrl + '?action=year&flag=1',
			      method : 'POST'
					});
		});

var yearCombo = new Ext.form.ComboBox({
                        id:'yearCombo',
			fieldLabel : '核算期间',
			store : YearDs,
			displayField : 'year',
			valueField : 'year',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 230,
			pageSize : 12,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
   ///结束年月
var EYearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['year', 'year'])
		});

EYearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
                              url : commonboxUrl + '?action=year&flag=1',
			      method : 'POST'
					});
		});

var EyearCombo = new Ext.form.ComboBox({
                        id:'EyearCombo',
			fieldLabel : '申请',
			store : EYearDs,
			displayField : 'year',
			valueField : 'year',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 230,
			pageSize : 12,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});



///科室下拉框
var deptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

deptDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url : commonboxUrl + '?action=dept&flag=1',
                                method:'POST'
					});
		});

var deptCombo = new Ext.form.ComboBox({
                        id:'deptCombo',
			fieldLabel : '科室名称',
			store : deptDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 230,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});


///申请人下拉框
var applyerDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

applyerDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
			url : commonboxUrl + '?action=username&flag=1',
						method : 'POST'
					});
		});

var applyerCombo = new Ext.form.ComboBox({
                        id:'applyerCombo',
			fieldLabel : '申请人',
			store : applyerDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 230,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});


///资金申请单号下拉框
applyDs1 = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['rowid', 'name'])
});

applyDs1.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
			url : 'herp.budg.costclaimseachmain.csp?action=GetBillCode&str='+encodeURIComponent(Ext.getCmp('BillCode').getRawValue()),
			method : 'POST'
			});
});

 applyCombo1 = new Ext.form.ComboBox({
    id:'BillCode',
	fieldLabel : '申请单号',
	store : applyDs1,
	displayField : 'name',
	valueField : 'rowid',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 100,
	listWidth : 230,
	pageSize : 10,
	minChars : 1,
	columnWidth : .15,
	selectOnFocus : true
});


///申请时间下拉框
 ///开始时间
 budget = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['rowids', 'names'])
});

    budget.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.costclaimseachmain.csp?action=ApplyDate&str='+encodeURIComponent(Ext.getCmp('budgetCombox').getRawValue()), 
				method : 'POST'
			});
});

 StartDate = new Ext.form.ComboBox({
        id:'budgetCombox',
	fieldLabel : '开始时间',
	//xtype:'datefield',
	//format:'Y/m/d', 
	store : budget,
	displayField : 'names',
	valueField : 'rowids',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 100,
	listWidth : 230,
	pageSize : 12,
	minChars : 1,
	columnWidth : .12,
	selectOnFocus : true
});

  ///结束时间

 Ebudget = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['rowids', 'names'])
});

  Ebudget.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.costclaimseachmain.csp?action=ApplyDate&str='+encodeURIComponent(Ext.getCmp('EbudgetCombox').getRawValue()), 
				method : 'POST'
			});
});

 EedDate = new Ext.form.ComboBox({
        id:'EbudgetCombox',
	fieldLabel : '结束申请时间',
	store : Ebudget,
	displayField : 'names',
	valueField : 'rowids',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 100,
	listWidth : 230,
	pageSize : 12,
	minChars : 1,
	columnWidth : .12,
	selectOnFocus : true
});
var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'find',
	handler: function(){
	
	  var year     = yearCombo.getValue();
          var Eedyear  = EyearCombo.getValue()
          var dept     = deptCombo.getValue();
          var BillCode = applyCombo1.getValue(); 
          var AplyDate = StartDate.getValue(); 
          var EAplyDate= EedDate.getValue(); 
          var AplyUser = applyerCombo.getValue();
           if((year>Eedyear)||(AplyDate>EAplyDate)){
	          Ext.Msg.show({title:'注意',msg:'起始时间不应该大于结束时间',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});

	          }
          ///alert(adjusnum);
	  itemGrid.load({params:{start:0,limit:25,year:year,Eedyear:Eedyear,dept:dept,billcodes:BillCode,AplyDate:AplyDate,EAplyDate: EAplyDate,AplyUser:AplyUser}});
	}
});


var queryPanel = new Ext.FormPanel({
	height : 120,
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
			value : '<center><p style="font-weight:bold;font-size:120%">一般支出报销单查询</p></center>',
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
					value : '核算期间:',
					columnWidth : .05
				},yearCombo,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .022
				},{
					xtype : 'displayfield',
					value : ' -- ',
					columnWidth : .02
				},EyearCombo,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .08
				},
                                  {                                            
					xtype : 'displayfield',
					value : '科室名称:',
					columnWidth : .05
					
				},deptCombo,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .1
				},{
					xtype : 'displayfield',
					value : '申请人:',
					columnWidth : .04
				},applyerCombo

		]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
		{
					xtype : 'displayfield',
					value : '申请时间:',
					columnWidth : .054
				}, StartDate,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .01
				},{
					xtype : 'displayfield',
					value : '--',
					columnWidth : .02
				}, EedDate,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .07
				},{
					xtype : 'displayfield',
					value : '报销单号:',
					columnWidth : .05
				},applyCombo1,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .3
				},findButton

		]
	}]
});






	
var itemGrid = new dhc.herp.Grid({
			width : 400,
			region : 'center',
			url : 'herp.budg.costclaimseachmain.csp',
			fields : [{
						header : '申请表ID',
						dataIndex : 'rowid',
						hidden : true
					},{
						id : 'CompName',
						header : '医疗单位',
						width : 80,
                                                align:'left',
						editable:false,
						dataIndex : 'CompName'

					},{
						id : 'checkyearmonth',
						header : '核算年月',
						width : 80,
                                                align:'right',
						editable:false,
						dataIndex : 'checkyearmonth'

					},{
						id : 'billcode',
						header : '报销单号',
						editable:false,
						width : 150,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							//cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:red;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},
						dataIndex : 'billcode'

					}, {
						id : 'dname',
						header : '报销科室',
						editable:false,
						width : 120,
						dataIndex : 'dname',
						hidden : false
					}, {
						id : 'deprdr',
						header : '报销科室',
						editable:false,
						width : 120,
						dataIndex : 'deprdr',
						hidden : true
					}, {
						id : 'applyer',
						header : '申请人',
						editable:false,
						width : 120,
						dataIndex : 'applyer'

					},{
						id : 'reqpay',
						header : '报销金额',
						width : 100,
						editable:false,
                                                align:'right',
						dataIndex : 'reqpay'

					}, {
						id : 'actpay',
						header : '审批金额',
						width : 100,
						editable : false,
						align:'right',
						dataIndex : 'actpay'
						
					},{
						id : 'budgetsurplus',
						header : '预算结余',
						width : 100,
						editable:false,
						align:'right',
						dataIndex : 'budgetsurplus'

					},{
						id : 'applydate',
						header : '申请时间',
						width : 120,
						align : 'right',
						editable:false,
						dataIndex : 'applydate'

					},{
						id : 'billstate',
						header : '单据状态',
						width : 100,
						///align : 'right',
						editable:false,
                                                renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},
						dataIndex : 'billstate'

					},{
						id : 'applydecl',
						header : '报销原因',
						width : 120,
						editable:false,
						dataIndex : 'applydecl'

					},{
						id : 'budgcotrol',
						header : '预算控制',
						width : 60,
						editable:false,
						hidden:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['budgcotrol']
						if (sf == "预算内") {
							return '<span style="color:blue;cursor:hand;">'+value+'</span>';
						} else {
							return '<span style="color:red;cursor:hand">'+value+'</span>';
						}},
						dataIndex : 'budgcotrol'

					},{
						id : 'isover',
						header : '',
						width : 100,
						editable:false,
						hidden:true,

						dataIndex : 'isover'

					}],
					viewConfig : {forceFit : true},
					atLoad : true//, // 是否自动刷新					

		});

   itemGrid.btnAddHide();    //隐藏增加按钮
   itemGrid.btnSaveHide();   //隐藏保存按钮
   itemGrid.btnResetHide();  //隐藏重置按钮
   itemGrid.btnDeleteHide(); //隐藏删除按钮
   itemGrid.btnPrintHide();  //隐藏打印按钮
// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	// 报销单号
	if (columnIndex == 4) {
              
             EditFun(itemGrid);
	}
	// 单据状态
	if (columnIndex == 12) {
	var records = itemGrid.getSelectionModel().getSelections();
	var rowids  = records[0].get("rowid");
	billstate(rowids);
	}
})




