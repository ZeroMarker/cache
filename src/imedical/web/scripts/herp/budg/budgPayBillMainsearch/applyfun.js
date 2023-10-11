var MainUrl='herp.budg.budgprojclaimapplyno.csp';
var ItemUrl='herp.budg.budgprojclaimapplynos.csp';
//报销单明细
applyFun = function(rowid,Code,dname,deprdr,Name,Desc,year){

	var statetitle = Name +"支出申请";
	var billapply = Code + Desc;

	var projUrl = 'herp.budg.budgprojfundreqexe.csp';
	var applyDs = new Ext.data.Store({
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : "results",
							root : 'rows'
						}, ['rowid', 'name'])
			});

	applyDs.on('beforeload', function(ds, o) {

				ds.proxy = new Ext.data.HttpProxy({
							url : projUrl+'?action=yearList',
							method : 'POST'
						});
			});

	var applyCombo = new Ext.form.ComboBox({
				fieldLabel : '资金申请单',
				store : applyDs,
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				value : billapply,
				disabled: true,
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
				value: dname,
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
				value: deprdr,
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


	//预算项
	var codeDs = new Ext.data.Store({
		proxy : "",
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows'
				}, ['code', 'name'])
	});

	codeDs.on('beforeload', function(ds, o) {

		ds.proxy = new Ext.data.HttpProxy({
					url : 'herp.budg.budgprojclaimapplynos.csp?action=itemcode',
					method : 'POST'
				});
	});

	var codeCombo = new Ext.form.ComboBox({
		fieldLabel : '预算项',
		store : codeDs,
		displayField : 'name',
		valueField : 'code',
		typeAhead : true,
		forceSelection : true,
		triggerAction : 'all',
		emptyText : '',
		width : 70,
	//	value:codedesc,
		listWidth : 200,
		pageSize : 10,
		minChars : 1,
		columnWidth : .1,
		selectOnFocus : true
	});

	//配件数据源
	var itemGridProxy= new Ext.data.HttpProxy({url:ItemUrl+'?action=list'});
	var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
		    'rowid',
			'itemcode',
			'codename',
			'budgreal',		  
			'reqpay',
			'actpay',
			'ddesc',
			'budgco',
			'budgcontrol'
		]),
	    remoteSort: true
	});
	
	//数据库数据模型
	var itemGridCm = new Ext.grid.ColumnModel([
					    new Ext.grid.RowNumberer(), 
					    {
							header : '项目支出明细ID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'itemcode',
							header : '预算项(编码)',
							dataIndex : 'itemcode',
							width : 60,
							editable:false,
							hidden : true
						},{
							id : 'codename',
							header : '预算项',
							dataIndex : 'codename',
							width : 100,
							editable:false
						},{
							id : 'budgreal',
							header : '当前预算结余',
							dataIndex : 'budgreal',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'reqpay',
							header : '本次报销申请',
							dataIndex : 'reqpay',
							align:'right',
							width : 120,
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
							}
						},{
							id : 'actpay',
							header : '审批支付',
							align:'right',
							dataIndex : 'actpay',
							width : 120,
							editable:false

						},{
							id : 'ddesc',
							header : '说明',
							dataIndex : 'ddesc',
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
								cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
								return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
								},
							width : 120,
							editable:true
						},{
							id : 'budgco',
							header : '执后预算结余',
							dataIndex : 'budgco',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'budgcontrol',
							header : '预算控制',
							dataIndex : 'budgcontrol',
							width : 100,
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							var sf = record.data['budgcontrol']
							if (sf == "超出预算") {
								return '<span style="color:red;cursor:hand;">'+value+'</span>';
							} else {
								return '<span style="color:black;cursor:hand">'+value+'</span>';
							}},
							editable:false

						}
	]);	
	
	//报销单明细
	var applyGrid = new Ext.grid.GridPanel({
		width : 600,
		height : 150,
		region : 'south',
	    readerModel:'remote',
	    atLoad : true, // 是否自动刷新
		store: itemGridDs,
		cm: itemGridCm,
		trackMouseOver: true,
		stripeRows: true,
		loadMask: true
	});			

	//项目信息
	//配件数据源
	var mainGridProxy= new Ext.data.HttpProxy({url:MainUrl+'?action=list'});
	var mainGridDs = new Ext.data.Store({
		proxy: mainGridProxy,
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
		    'rowid',
			'budgtotal',
			'reppay',
			'actpaywait',		  
			'actpay',
			'budgcur',
			'actpaycur',
			'budgco',
			'budgcontrol',
			'FundBillDR'
		]),
	    remoteSort: true
	});
	
	//数据库数据模型
	var mainGridCm = new Ext.grid.ColumnModel([
					    new Ext.grid.RowNumberer(), 
					    {
							header : '项目支出主表ID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'budgtotal',
							header : '项目总预算',
							dataIndex : 'budgtotal',
							width : 120,
							align:'right',
							editable:false
						},{
							id : 'reppay',
							header : '申请资金',
							dataIndex : 'reppay',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'actpaywait',
							header : '在途报销',
							dataIndex : 'actpaywait',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'actpay',
							header : '已执行预算',
							dataIndex : 'actpay',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'budgcur',
							header : '当前预算结余',
							dataIndex : 'budgcur',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'actpaycur',
							header : '本次报销',
							dataIndex : 'actpaycur',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'budgco',
							header : '执行后预算结余',
							dataIndex : 'budgco',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'budgcontrol',
							header : '预算控制',
							dataIndex : 'budgcontrol',
							width : 100,
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							var sf = record.data['budgcontrol']
							if (sf == "超出预算") {
								return '<span style="color:red;cursor:hand;">'+value+'</span>';
							} else {
								return '<span style="color:black;cursor:hand">'+value+'</span>';
							}},
							editable:false

						},{
							id : 'FundBillDR',
							header : '项目报销对应的资金申请单ID',
							dataIndex : 'FundBillDR',
							align:'right',
							width : 120,
							editable:false,
							hidden:true

						}
	]);	
	
	//报销单明细
	var mainGrid = new Ext.grid.GridPanel({
		width : 600,
		region : 'center',
	    readerModel:'remote',
	    atLoad : true, // 是否自动刷新
		store: mainGridDs,
		cm: mainGridCm,
		trackMouseOver: true,
		stripeRows: true,
		loadMask: true
	});				

	mainGridDs.load({params:{start:0, limit:25, rowid : rowid}});
	itemGridDs.load({params:{start:0, limit:25,rowid :rowid}});	
	
	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({ text : '关闭'});

	// 定义取消按钮的响应函数
	cancelHandler = function(){ 
	  window.close();
	};

	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);
	
	
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
				width : 1000,
				height : 540,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : tabPanel,
				buttons : [cancelButton]

			});
	window.show();
};