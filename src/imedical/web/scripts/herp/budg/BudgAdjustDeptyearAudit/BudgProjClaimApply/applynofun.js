
applynofun = function(itemDetail){
	var userid = session['LOGON.USERID'];

	var records   = itemDetail.getSelectionModel().getSelections();
	var rowid     = records[0].get("rowid")
	var code  	  = records[0].get("code");
	var name  	  = records[0].get("name");
	var deptname  = records[0].get("deptname");
	var username  = records[0].get("username");
	var Desc  	  = records[0].get("Desc");
	var facode    = records[0].get("facode")
	var projdr    = records[0].get("projdr")
	var oldfundbilldr=records[0].get("FundBillDR")	
	var BillState=records[0].get("BillState")	
	
var statetitle = name +"支出申请";

////////////////////////// 资金申请单号 ///////////////////////
 applyDs1 = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['rowid', 'namedesc'])
});

applyDs1.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.budgprojclaimapplynos.csp?action=billcode&projDr='+projdr,
				method : 'POST'
			});
});
var applyCombo1 = new Ext.form.ComboBox({
	fieldLabel : '资金申请单',
	store : applyDs1,
	displayField : 'namedesc',
	valueField : 'rowid',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	allowBlank:false,
	width : 90,
	listWidth : 225,
	pageSize : 10,
	minChars : 1,
	columnWidth : .15,
	selectOnFocus : true
});
applyCombo1.setValue(facode);
 
/////////////////////报销单号/////////////////////////
var applyNo = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value:code,
			disabled: true,
			selectOnFocus : true

		});
/////////////////////项目名称/////////////////////////
var projname = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value:name,
			disabled: true,
			selectOnFocus : true

		});
/////////////////////申请人/////////////////////////
var appuName = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value: username,
			disabled: true,
			selectOnFocus : true

		});
/////////////////////报销说明/////////////////////////
Descfield1 = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value: Desc,
			selectOnFocus : true

		});		
/////////////////////申请科室/////////////////////////
var dnamefield = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value: deptname,
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
				}, Descfield1,{
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
				}, applyCombo1

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

//当前预算结余
var budgbalanceDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['code', 'name'])
});

budgbalanceDs.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.budgprojclaimapplynos.csp'+'?action=budgbalance&start=0&limit=25&itemcode='+ codeCombo.getvalue(),
				method : 'POST'
			});
});

var budgbalanceCombo = new Ext.form.ComboBox({
	fieldLabel : '当前预算结余',
	store : budgbalanceDs,
	displayField : 'name',
	valueField : 'rowid',
	typeAhead : true,
	forceSelection : true,
	disabled: true,
	emptyText : '',
	columnWidth : .15,
	width : 200,
	selectOnFocus : true
});

//数据录入
var valueField = new Ext.form.TextField({
	id: 'valueField',
	width:215,
	listWidth : 215,
	name: 'valueField',
	regex : /^(-?\d+)(\.\d+)?$/,
	regexText : "只能输入数字",
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var applyGrid = new dhc.herp.Gridapplynos({
				width : 600,
				height : 150,
				region : 'south',
				url : 'herp.budg.budgprojclaimapplynos.csp',
				tbar:[],
				listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                 if (BillState=="提交") {
		                      return false;
		                 } else {return true;}
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						if (BillState=="提交") {
		                      return false;
		                 } else {return true;}
					}
            	},
				fields : [
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
							editable:false,
							type:codeCombo
						},{
							id : 'budgreal',
							header : '当前预算结余',
							dataIndex : 'budgreal',
							align:'right',
							width : 120,
							editable:false,
							type:budgbalanceCombo

						},{
							id : 'reqpay',
							header : '本次报销申请',
							dataIndex : 'reqpay',
							align:'right',
							width : 120,
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
							},
							editable:true,
							type:valueField
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

						}],
						loadMask : true,
						viewConfig : {forceFit : true}
			});
var aaa = function(){ 
	mainGrid.load({params:{start:0, limit:25,rowid:rowid}});
	};			
Ext.getCmp('herpSaveId').addListener('click', aaa, false);


/////////////////主表中的添加按钮////////////////////////////
var saveButtonMain = new Ext.Toolbar.Button({
	text: '保存',
    tooltip:'添加',        
    iconCls: 'save',
	handler:function(){

		var mdesc=encodeURIComponent(Descfield1.getValue());
		var fundbilldr=applyCombo1.getValue();
		if(fundbilldr==facode)
		{
			fundbilldr=oldfundbilldr
		}
		
		var datad='&rowid='+rowid+'&mdesc='+mdesc+'&fundbilldr='+fundbilldr+'&oldfundbilldr='+oldfundbilldr;		
		Ext.Ajax.request({
				url: 'herp.budg.budgprojclaimapplynos.csp?action=edit'+datad,
				waitMsg : '处理中...',
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
								title : '',
								msg : '保存成功',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.INFO
							});
					}
				},
				scope : this
			});
			
			mainGrid.load({params:{start:0, limit:25,rowid:rowid}});
	}
	
	
	
});


var mainGrid = new dhc.herp.Gridapplyno({
				width : 600,
				region : 'center',
				url : 'herp.budg.budgprojclaimapplyno.csp',
				tbar:[saveButtonMain],
				fields : [
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

						}],
						viewConfig : {forceFit : true}
			}
);




	mainGrid.load({params:{start:0, limit:25,rowid:rowid}});
	applyGrid.load({params:{start:0, limit:25,rowid:rowid}});
	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({ text : '关闭'});

	// 定义取消按钮的响应函数
	cancelHandler = function(){ 
	  window.hide();
	  itemDetail.load({params:{start:0,limit:12,userid:userid,projdr:projdr}});
	};

	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);
	
	
	// 初始化面板
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [queryPanel,mainGrid,applyGrid]
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
				width : 950,
				height : 500,
				modal : true,
				buttonAlign : 'center',
				items : tabPanel,
				buttons : [cancelButton]

			});
	if(BillState=="提交")
	{
		saveButtonMain.disable();
		Ext.getCmp('herpSaveId').disable();
		applyCombo1.disable();
		Descfield1.disable();
	}
	window.show();
};

