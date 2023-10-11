 paydetail = function(rowid,applydecls,applyers,deprdrs,billcodes){

 ///var statetitle;
 

 var statetitle = "一般支出报销单明细";

 //var code=FundBillDR;
 var name="vcxv";
 var username="cv";
 var Desc="weerdfs";
//////资金申请单号//////////////////
applyDs1 = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['rowid', 'name'])
});

applyDs1.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.costpaydetaiexe.csp?action=billcode',
				method : 'POST'
			});
});

 applyCombo1 = new Ext.form.ComboBox({
	fieldLabel : '资金申请单号',
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


/////////////////////预算期///////////////////////////


    budget = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['rowids', 'names'])
});

    budget.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.costpaydetaiexe.csp?action=budget',
				method : 'POST'
			});
});

 budgetCombox = new Ext.form.ComboBox({
	fieldLabel : '预算期',
	store : budget,
	displayField : 'names',
	valueField : 'rowids',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 150,
	listWidth : 230,
	pageSize : 10,
	minChars : 1,
	columnWidth : .15,
	selectOnFocus : true
});

/////////////////////预算项//////////////////////////

  budgetitem = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['rowids', 'names'])
});

    budgetitem.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.costpaydetaiexe.csp?action=budgetitem',
				method : 'POST'
			});
});

 budgetitemCombox = new Ext.form.ComboBox({
	fieldLabel : '预算项',
	store :budgetitem,
	displayField : 'names',
	valueField : 'rowids',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 150,
	listWidth : 230,
	pageSize : 10,
	minChars : 1,
	columnWidth : .1,
	selectOnFocus : true
});
 
/////////////////////报销单号/////////////////////////
var applyNo = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value:billcodes,
			disabled: true,
			selectOnFocus : true

		});
/////////////////////报销科室/////////////////////////
var projname = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value:deprdrs,
			disabled: true,
			selectOnFocus : true

		});
/////////////////////申请人/////////////////////////
var appuName = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value: applyers,
                 	disabled: true,
			selectOnFocus : true

		});
/////////////////////报销说明/////////////////////////
Descfield1 = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value:applydecls,
			selectOnFocus : true

		});		




//////修改
var modification = new Ext.Toolbar.Button({
	text: '修改',
        tooltip:'修改',        
        iconCls:'add',
	handler:function(){
        var selectedRow = addmainGrid.getSelectionModel().getSelections();
        var len = selectedRow.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要撤销的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});

			return;
		}
		
         rowid	=selectedRow[0].data['rowid'];
	modificationfun(rowid);
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
			value : '<center><p style="font-weight:bold;font-size:120%">一般性支出报销单明细</p></center>',
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
					columnWidth : .06
				},applyNo,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .1
				},{
					xtype : 'displayfield',
					value : '报销科室:',
					columnWidth : .06
				},projname,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .1
				},{
					xtype : 'displayfield',
					value : '申请人:',
					columnWidth : .06
				}, appuName

		]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
		{
					xtype : 'displayfield',
					value : '预算期:',
					columnWidth : .06
				},budgetCombox,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .1
				}, {
					xtype : 'displayfield',
					value : '资金申请单号:',
					columnWidth : .06
				},applyCombo1,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .1
				},{
					xtype : 'displayfield',
					value : '说明:',
					columnWidth : .06
				},Descfield1

		]
	}]
});






 




//////////////////////////////
var paydetailGrid = new dhc.herp.Grid({
				width : 600,
				region : 'center',
				url : 'herp.budg.costpaydetaiexe.csp',
				fields : [
				{
							header : 'ID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'serialnumber',
							header : '序号',
							dataIndex : 'serialnumber',
							width : 120,
							align:'right',
							editable:false
						},{
							id : 'budget',
							header : '预算项',
							dataIndex : 'budget',
							align:'right',
							width : 120,
							type:budgetitemCombox


						},{
							id : 'currbudgetsurplus',
							header : '当前预算结余',
							dataIndex : 'currbudgetsurplus',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'reimbursementapply',
							header : '本次报销申请',
							dataIndex : 'reimbursementapply',
							align:'right',
							width : 120,
							editable:true

						},{
							id : 'examinepay',
							header : '审批支付',
							dataIndex : 'examinepay',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'execbudgetsurplus',
							header : '执行后预算结余',
							dataIndex : 'execbudgetsurplus',
							align:'right',
							width : 120,
							editable:false,
                                                        listeners : {
					                specialKey : function(field, e) {
                                                           var sf = record.data['budgetcontrol'];
                                                             var sf = record.data['budgetcontrol'];
					                   if (e.getKey() == Ext.EventObject.ENTER) {
					
						                }
					      }
                                         }
						},{
							id : 'budgetcontrol',
							header : '预算控制',
							dataIndex : 'budgetcontrol',
							align:'right',
							width : 120,
							editable:false,
                                                        renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['budgetcontrol']
						if (sf == "预算外") {
							return '<span style="color:red;cursor:hand;">'+value+'</span>';
						} else {
							return '<span style="color:black;cursor:hand">'+value+'</span>';
						}}
						}],
tbar:[modification]
});
   


 paydetailGrid.btnPrintHide() 	//隐藏打印按钮
                 
 paydetailGrid.btnResetHide();  //隐藏重置按钮     

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
				items : [queryPanel,paydetailGrid]
			});

	var tabPanel =  new Ext.Panel({
  	//activeTab: 0,
  	layout: 'border',
  	region:'center',
  	items:[queryPanel,paydetailGrid]                                 //添加Tabs
  });
	
	var window = new Ext.Window({
				layout : 'fit',
				title : statetitle,
				plain : true,
				width : 885,
				height : 500,
				modal : true,
				buttonAlign : 'center',
				items : tabPanel,
				buttons : [cancelButton]

			});
	
	window.show();	
        paydetailGrid.load({params:{start:0,rowid:rowid}});





};