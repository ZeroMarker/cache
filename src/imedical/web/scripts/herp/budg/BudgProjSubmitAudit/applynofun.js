
applynoFun = function(rowid,Code,dname,uName,Name,Desc){

var statetitle = Name +"支出申请";

var projUrl = 'herp.budg.budgprojsubmitauditexe.csp';
var applyDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

applyDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=yearlist',
						method : 'POST'
					});
		});

var applyCombo = new Ext.form.ComboBox({
			fieldLabel : '资金申请单',
			store : applyDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			emptyText : '',
			columnWidth : .15,
			width : 200,
			selectOnFocus : true
		});

/////////////////////报销单号/////////////////////////
var applyNo = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value:Code,
			disabled: true,
			selectOnFocus : true

		});
/////////////////////项目名称/////////////////////////
var projname = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value:Name,
			disabled: true,
			selectOnFocus : true

		});
/////////////////////申请人/////////////////////////
var appuName = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value: uName,
			disabled: true,
			selectOnFocus : true

		});
/////////////////////报销说明/////////////////////////
var Descfield = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value: Desc,
			disabled: true,
			selectOnFocus : true

		});		
/////////////////////申请科室/////////////////////////
var dnamefield = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value: dname,
			disabled: true,
			selectOnFocus : true

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
			value : '<center><p style="font-weight:bold;font-size:120%">项目支出申请</p></center>',
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
					value : '报销单号:',
					columnWidth : .12
				}, applyNo,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '项目名称:',
					columnWidth : .12
				},projname,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '申请人:',
					columnWidth : .12
				}, appuName

		]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
		{
					xtype : 'displayfield',
					value : '报销说明:',
					columnWidth : .12
				}, Descfield,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '申请科室:',
					columnWidth : .12
				},dnamefield,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '资金申请单:',
					columnWidth : .12
				}, applyCombo

		]
	}]
});

var applyGrid = new dhc.herp.Gridapplynos({
				width : 600,
				height : 200,
				region : 'south',
				url : 'herp.budg.budgprojsubmitauditsexe.csp',
				fields : [
				{
							header : 'ID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'name',
							header : '预算项',
							dataIndex : 'name',
							width : 60,
							editable:false
						},{
							id : 'nsurplus',
							header : '当前预算结余',
							dataIndex : 'nsurplus',
							align:'right',
							width : 70,
							editable:false

						},{
							id : 'apply',
							header : '本次报销申请',
							dataIndex : 'apply',
							align:'right',
							width : 80,
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
							},
							editable:true

						},{
							id : 'apppay',
							header : '审批支付',
							dataIndex : 'apppay',
							align:'right',
							width : 60,
							editable:false

						},{
							id : 'surplus',
							header : '预算结余',
							dataIndex : 'surplus',
							align:'right',
							width : 60,
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
							},
							editable:true

						},{
							id : 'budgcontrol',
							header : '预算控制',
							dataIndex : 'budgcontrol',
							align:'right',
							width : 60,
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							var sf = record.data['budgcotrol']
							if (sf == "超出预算") {
								return '<span style="color:red;cursor:hand;">'+value+'</span>';
							} else {
								return '<span style="color:black;cursor:hand">'+value+'</span>';
							}},
							editable:false

						}],
						loadMask : true,
						viewConfig : {forceFit : true}

			});

var mainGrid = new dhc.herp.Gridapplyno({
				width : 600,
				region : 'center',
				url : 'herp.budg.budgprojsubmitauditmexe.csp',
				fields : [
				{
							header : 'ID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'totalbudg',
							header : '项目总预算',
							dataIndex : 'totalbudg',
							width : 70,
							align:'right',
							editable:false
						},{
							id : 'apply',
							header : '申请资金',
							dataIndex : 'apply',
							align:'right',
							width : 70,
							editable:false

						},{
							id : 'onexpense',
							header : '在途报销',
							dataIndex : 'onexpense',
							align:'right',
							width : 60,
							editable:false

						},{
							id : 'executed',
							header : '已执行预算',
							dataIndex : 'executed',
							align:'right',
							width : 70,
							editable:false

						},{
							id : 'surplus',
							header : '当前预算结余',
							dataIndex : 'surplus',
							align:'right',
							width : 70,
							editable:false

						},{
							id : 'reimburses',
							header : '本次报销',
							dataIndex : 'reimburses',
							align:'right',
							width : 60,
							editable:false

						},{
							id : 'budgsurplus',
							header : '执行后预算结余',
							dataIndex : 'budgsurplus',
							align:'right',
							width : 70,
							editable:false

						},{
							id : 'budgcontrol',
							header : '预算控制',
							dataIndex : 'budgcontrol',
							align:'right',
							width : 60,
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							var sf = record.data['budgcotrol']
							if (sf == "超出预算") {
								return '<span style="color:red;cursor:hand;">'+value+'</span>';
							} else {
								return '<span style="color:black;cursor:hand">'+value+'</span>';
							}},
							editable:false

						}],
						viewConfig : {forceFit : true}

			});

	//mainGrid.load({params:{start:0, limit:12,FundBillDR:FundBillDR}});
	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({ text : '关闭'});

	// 定义取消按钮的响应函数
	cancelHandler = function(){ 
	  window.close();
	};

	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);
	
	
	// 初始化面板
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [queryPanel,applyGrid]
			});

	var tabPanel =  new Ext.Panel({
  	//activeTab: 0,
  	layout: 'border',
  	region:'center',
  	items:[queryPanel,mainGrid,applyGrid]                                 //添加Tabs
  });
	
	var window = new Ext.Window({
				layout : 'fit',
				title : statetitle,
				plain : true,
				width : 900,
				height : 540,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : tabPanel,
				buttons : [cancelButton]

			});
	window.show();
};