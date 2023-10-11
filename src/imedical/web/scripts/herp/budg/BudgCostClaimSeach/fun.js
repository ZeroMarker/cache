billstate = function(rowid){

 var statetitle;
 statetitle = "单据状态明细";
 var addmainGrid = new dhc.herp.Gridapplyadddetail({
				width : 600,
				region : 'center',
				url : 'herp.budg.billstate.csp',
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
							id : 'exectdept',
							header : '执行科室',
							dataIndex : 'exectdept',
							width : 120,
							editable:false

						},{
							id : 'executor',
							header : '执行人',
							dataIndex : 'executor',
							width : 120,
							editable:false

						},{
							id : 'execresult',
							header : '执行结果',
							dataIndex : 'execresult',
///////							align:'right',
							width : 120,
							editable:false

						},{
							id : 'execprocedescr',
							header : '执行过程描述',
							dataIndex : 'execprocedescr',
							width : 120,
							editable:false

						},{
							id : 'execdate',
							header : '执行时间',
							dataIndex : 'execdate',
							align:'right',
							width : 120,
							editable:false
						}]
});


                addmainGrid.btnAddHide();  //隐藏增加按钮
   	addmainGrid.btnSaveHide();  //隐藏保存按钮
    

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
				items : [addmainGrid]
			});

	var tabPanel =  new Ext.Panel({
  	//activeTab: 0,
  	layout: 'border',
  	region:'center',
  	items:[addmainGrid]                                 //添加Tabs
  });
	

	var window = new Ext.Window({
				layout : 'fit',
				title : statetitle,
				plain : true,
				width : 770,
				height : 500,
				modal : true,
				buttonAlign : 'center',
				items : tabPanel,
				buttons : [cancelButton]
			});
	window.show();	
       addmainGrid.load({params:{start:0,rowid:rowid}});


};

















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








EditFun = function(itemGrid){
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var username = session['LOGON.USERNAME'];
var userId	= session['LOGON.USERID'];
Username=userId+'_'+username;
var billcode = "";



var selectedRow = itemGrid.getSelectionModel().getSelections();
var rowidm=selectedRow[0].data['rowid'];
var yearmonth=selectedRow[0].data['checkyearmonth'];
var billcode=selectedRow[0].data['billcode'];
var statetitle = billcode +"报销单据明细";
var dname=selectedRow[0].data['dname'];
//alert(dname);
var uname=selectedRow[0].data['applyer'];
var mdesc=selectedRow[0].data['applydecl'];
var deptdr=selectedRow[0].data['deprdr'];
//alert(deptdr);
var applycode=selectedRow[0].data['applycode'];
dname=deptdr+'_'+dname;
var billstate=selectedRow[0].data['billstate'];
	 

/////////////////////报销单号/////////////////////////
var applyNo = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value:billcode,
			disabled: true,
			selectOnFocus : true,
			listeners : {
					specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					Ext.Ajax.request({
					url: '../csp/herp.budg.expenseaccountdetailexe.csp?action=getclaimcode',				
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							var bcode = jsonData.info;
							applyNo.setValue(bcode);
						}else{
							var message="";
							if(jsonData.info=='RepCode') message='单据号已经存在，请回车重新生成！';
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							applyNo.focus();
						}
					},
					scope: this
					});
					dnamefield.focus();
						
						}
					}}

		});

			

var del = function() {

	Ext.Ajax.request({
		url: '../csp/herp.budg.expenseaccountdetailexe.csp?action=Del',
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
					}
				},
				scope : this
			});
}

//资金申请单号：
var applyDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['rowid', 'applycode'])
});

applyDs.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.expenseaccountdetailexe.csp?action=applycode&&userdr='+userId,
				method : 'POST'
			});
});

 applyCombo = new Ext.form.ComboBox({
	fieldLabel : '资金申请单号',
	store : applyDs,
	displayField : 'applycode',
	valueField : 'rowid',
	disabled:true,
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 90,
	value:applycode,
	listWidth : 200,
	pageSize : 10,
	minChars : 1,
	columnWidth : .15,
	selectOnFocus : true
});

/////////////////////预算期/////////////////////////
 var timeDs = new Ext.data.Store({
 	proxy : "",
 	reader : new Ext.data.JsonReader({
 				totalProperty : "results",
 				root : 'rows'
 			}, ['year', 'year'])
 });

 timeDs.on('beforeload', function(ds, o) {

 	ds.proxy = new Ext.data.HttpProxy({
 				url : commonboxUrl + '?action=year&flag=1',
 				method : 'POST'
 			});
 });

  timeCombo = new Ext.form.ComboBox({
 	fieldLabel : '预算期',
 	store : timeDs,
 	displayField : 'year',
 	valueField : 'year',
 	disabled:false,
 	typeAhead : true,
 	forceSelection : true,
			triggerAction : 'all',
			value : yearmonth,
			emptyText : '请选择...',
			width : 100,
			listWidth : 220,
			columnWidth : .15,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			listeners : {
				specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					if(timeCombo.getValue()!==""){
						applyCombo.focus();
					}else{
					Handler = function(){yearmonField.focus();};
					Ext.Msg.show({title:'错误',msg:'预算期不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
					}
					}}
		});


/////////////////////申请人/////////////////////////
var appuName = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value: uname,
			disabled: true,
			selectOnFocus : true,
			listeners : {
				specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					if(appuName.getValue()!==""){
						Descfield.focus();
					}else{
					Handler = function(){appuName.focus();};
					Ext.Msg.show({title:'错误',msg:'申请人不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
					}
					}}

		});

//appuName.on('select',function(combo, record, index){
//	//getMax(addAuthCombo.getValue(),addMonths.getValue());
//	getMax(appuName.getValue());
//	adddetailGrid.setUrlParam({Userid:appuName.getValue()});
//});	
/////////////////////申请说明/////////////////////////
 Descfield = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value : mdesc,
			selectOnFocus : true,
			listeners : {
				specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					if(Descfield.getValue()!==""){
						timeCombo.focus();
					}else{
					Handler = function(){Descfield.focus();};
					Ext.Msg.show({title:'错误',msg:'申请说明不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
					}
					}}

		});
		
////////////////////报销科室/////////////////////////
var dnamefield = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value :dname,
			emptyText : '回车生成科室...',
			disabled: true,
			selectOnFocus : true,
			listeners : {
					specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					Ext.Ajax.request({
					url: '../csp/herp.budg.budgctrlfundbillmngexe.csp?action=getdept&userID='+userId,				
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							var dept = jsonData.info;
							
						//alert(dept);
		               
							dnamefield.setValue(dept);
							appuName.focus();
						}else{
							var message="";
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							dnamefield.focus();
						}
					},
					scope: this
					});
						
						}
					}}

		});
		
		
		

//dnamefield.on('select',function(combo, record, index){
//	getMax(dnamefield.getValue());
//	adddetailGrid.setUrlParam({Deptcode:dnamefield.getValue()});
//});


var queryPanel = new Ext.FormPanel({
	height : 150,
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
			value : '<center><p style="font-weight:bold;font-size:120%">支出报销明细</p></center>',
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
					value : '报销科室:',
					columnWidth : .12
				},dnamefield,{
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
					value : '预算期:',
					columnWidth : .12
				},timeCombo,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}/*, {
					xtype : 'displayfield',
					value : '资金申请单号:',
					columnWidth : .12
				}, applyCombo  */

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
				url : 'herp.budg.expenseaccountdetailexe.csp?action=bidlist',
				method : 'POST'
			});
});

 codeCombo = new Ext.form.ComboBox({
	fieldLabel : '预算项',
	store : codeDs,
	displayField : 'name',
	valueField : 'code',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 70,
	listWidth : 200,
	pageSize : 10,
	minChars : 1,
	columnWidth : .1,
	selectOnFocus : true
                                                                                                                                          });

/*
//预算项和目前预算结余联动
 codeCombo.on("select",function(cmb,rec,id ){
		searchFun(cmb.getValue());
		//tmpStr=cmb.getValue();
		budgbalanceCombo.setValue("");
		budgbalanceCombo.setRawValue("");
		budgbalanceDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize}});
		//unitdeptDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize}});
	});
function searchFun(SetCfgDr){
	    budgbalanceDs.proxy = new Ext.data.HttpProxy({
		url:'../csp/targetcalculaterateexe.csp?action=budgbalancelist&deptdr='+Ext.getCmp('dnamefield').getValue()+'&yearmonth='+Ext.getCmp('timeCombo').getValue()
		                      +'&itemcode='+Ext.getCmp('codeCombo').getValue(),method:'POST'});
	    budgbalanceDs.load({params:{start:0, limit:25}});
	};
*/
	
//当前预算结余
var budgbalanceDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['name', 'name'])
});

budgbalanceDs.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.expenseaccountdetailexe.csp'+'?action=getcurbalance&deptdr='+Ext.getCmp('dnamefield').getValue()+'&yearmonth='+Ext.getCmp('timeCombo').getValue()
                +'&itemcode='+Ext.getCmp('codeCombo').getValue(),method:'POST'});
				method : 'POST'
			});

var budgbalanceCombo = new Ext.form.ComboBox({
	fieldLabel : '当前预算结余',
	store : budgbalanceDs,
	displayField : 'name',
	valueField : 'name',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 70,
	listWidth : 200,
	pageSize : 10,
	minChars : 1,
	columnWidth : .1,
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

/*////////////////添加按钮////////////////////////////
var addButton = new Ext.Toolbar.Button({
	text: '保存',
    tooltip:'保存',        
    iconCls: 'save',
	handler:function(){
	Add1Fun();			//调用申请单据管理界面
	}
	
});*/

//////////////////提交/////////////////////
/*var SubButton = new Ext.Toolbar.Button({
			text : '提交',
			tooltip : '提交',
			iconCls:'add',
			handler : function() {
				var rowObj = editGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				if (len < 1) {
					Ext.Msg.show({title : '注意',msg : '请选择需要提交的记录!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.WARNING});
					return;
				}
				var reqpay = rowObj[0].get("reqpay");
				var itemcode = rowObj[0].get("itemcode");
				var yearmonth = timeCombo.getValue();
				var deptdr = dnamefield.getValue();
				var arr = deptdr.split("_");deptdr=arr[0];
				Ext.Ajax.request({
					url : 'herp.budg.expenseaccountdetailexe.csp?action=submit&reqpay='+reqpay+'&itemcode='+itemcode+'&yearmonth='+yearmonth+'&deptdr='+deptdr+'&billcode='+billcode,
					failure : function(result, request) {
						Ext.Msg.show({title : '错误',msg : '请检查网络连接!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
					},
					success : function(result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							Ext.Msg.show({title : '注意',msg : '提交成功!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
							editGrid.load({params:{start:0, limit:25,billcode:billcode}});
						} else {
							var message="SQLErr: "+ jsonData.info;
							Ext.Msg.show({title : '错误',msg : message,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
						}
					},
					scope : this
				});
			}
		});
*/
var editGrid = new dhc.herp.Grid({
				width : 600,
				height : 150,
				region : 'center',
				url : 'herp.budg.expenseaccountdetailexe.csp',
					//tbar:addButton,
				forms : [],
				listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                var record = grid.getStore().getAt(rowIndex);
		                  // 根据条件设置单元格点击编辑是否可用
		                  //alert(columnIndex);
		                  if ((record.get('itemname')!="")&&(record.get('rowid')=="")&&(columnIndex == 5)) { var itemcode=record.get('itemcode');
			                  for (var f in editGrid.getSelectionModel().getSelected().getChanges()) {
								if (f=="itemname"){
									itemcode = record.get('itemname');
								}
								}
					            Ext.Ajax.request({
								url: '../csp/herp.budg.budgctrlfundbillmngexe.csp?action=getcurbalance&deptdr='+deptdr+'&yearmonth='+yearmonth+'&itemcode='+itemcode,				
								success: function(result, request){
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true'){
										var curbalance = jsonData.info;
										record.data.Balance=curbalance;
										record.set(5, curbalance);
									}
								},scope: this
								});
							}  
		                    if ((record.get('rowid') != "")&& (columnIndex == 4)) {
		                         return false;
		                     } else {return true;}
		                    
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
						
						if ((record.get('itemname')!="")&&(record.get('rowid')=="")&&(columnIndex == 5)) {
							 var itemcode=record.get('itemcode');
							  //alert(itemcode);
							   for (var f in editGrid.getSelectionModel().getSelected().getChanges()) {
								if (f=="itemname"){
								itemcode = record.get('itemname');	
								}
								}
					            Ext.Ajax.request({
								url: '../csp/herp.budg.budgctrlfundbillmngexe.csp?action=getcurbalance&deptdr='+deptdr+'&yearmonth='+yearmonth+'&itemcode='+itemcode,				
								success: function(result, request){
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true'){
										var curbalance = jsonData.info;
										record.data.Balance=curbalance;
										record.set(5, curbalance);
									}
								},scope: this
								});
							}
						if ((record.get('rowid') != "") && (columnIndex == 4)) {
							return false;
						} else {
							return true;
						}
					}
	            },
				fields : [
				{
							header : 'ID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'billdr',
							header : '申请主表ID',
							dataIndex : 'billdr',
							width : 120,
							hidden:true
						},{
							id : 'itemcode',
							header : '预算项编码',
							dataIndex : 'itemcode',
							hidden:true,
							width : 120,
							type:codeCombo
						},{
							id : 'itemname',
							header : '预算项',
							dataIndex : 'itemname',
							width : 120,
							type:codeCombo
						},{
							id : 'balance',
							header : '当前预算结余',
							dataIndex : 'balance',
							xtype:'numbercolumn',
							aalign:'right',
							width : 120,
							editable:false
						},{
							id : 'reqpay',
							header : '本次报销申请',
							dataIndex : 'reqpay',
							align:'right',
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
							},
							width : 120
						},{
							id : 'actpay',
							header : '审批支付',
							align:'right',
							dataIndex : 'actpay',
							editable:false,
							width : 120
						},{
							id : 'balance1',
							header : '审批后预算结余',
							dataIndex : 'balance1',
							editable:false,
							align:'right',
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
							},
							width : 120

						},{
							id : 'budgcotrol',
							header : '预算控制',
							dataIndex : 'budgcotrol',
							width : 100,
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							var sf = record.data['budgcotrol']
							if (sf == "超预算") {
								return '<span style="color:red;cursor:hand;">'+value+'</span>';
							} else {
								return '<span style="color:black;cursor:hand">'+value+'</span>';
							}},
							editable:false
						}],
						viewConfig : {forceFit : true}
			});
 
 		
/*Add1Fun=function() {
		var records=editGrid.store.getModifiedRecords();
		var o = {};
	    var tmpDate = editGrid.dateFields;
	    var tmpstro = "";
	    var tmpstros="";
	    var data = [];
	    var rtn = 0;
	    var datad="";
	    var itemcode=""
		Ext.each(records, function(r) {
			var o = {};
			var tmpstro = "&rowid=" + r.data['rowid'];
			var deleteFlag = r.data['delFlag'];// 删除标识，1：是该记录已经删除，0：未删除。

			// 数据完整性验证Beging
			for (var i = 0; i < editGrid.fields.length; i++) {
				var indx = editGrid.getColumnModel().getColumnId(i + 1)
				var tmobj = editGrid.getColumnModel().getColumnById(indx)
				if (tmobj != null) {
					// 列增加update属性，true：该列数据没有变化也向后台提交数据，false：则不会强制提交数据
					var reValue = r.data[indx];
					if ((typeof(reValue) != "undefined") && (tmobj.update)) {
						tmpstro += "&" + indx + "=" + r.data[indx].toString();
					}
					if (tmobj.allowBlank == false) {
						var title = tmobj.header
						if ((r.data[indx].toString() == "")|| (parseInt(r.data[indx].toString()) == 0)) {
							var info = "[" + title + "]列为必填项，不能为空或零！"
							Ext.Msg.show({
										title : '错误',
										msg : info,
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
							rtn = -1;
							return -1;

						}
					}
				}

			}
			// 数据完整性验证END

			if (r.isValid()) {
				if (deleteFlag == "-1") {
					return;
				}
				for (var f in r.getChanges()) {
				if (f=="itemname"){
					itemcode = r.data['itemname'];	
				}
				}	
			
			var paybilldr = r.data['billdr'];
			;var itemcode = r.data['itemname'];
			var reqpay = r.data['reqpay'];
			var actpay = r.data['actpay'];
			var budgbalance = r.data['balance'];
			//BillDR ItemName Balance ReqPay ActPay Balance1
			//FundBillDR ItemCode ReqPay ActPay Desc BudgBalance
			var datad = paybilldr+"|"+itemcode+"|"+reqpay+"|"+actpay+"|"+budgbalance;
			} else {
				Ext.Msg.show({
							title : '错误',
							msg : '请将数据添加完整后再试!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			}
			
			var billcode = applyNo.getValue();
			var yearmonth = timeCombo.getValue();
			var deptdr = dnamefield.getValue();
			var arr = deptdr.split("_");deptdr=arr[0];
			var userdr = appuName.getValue();
			var arr1 = userdr.split("_"); userdr=arr1[0];
			var mdesc = Descfield.getValue();
			var applycode = applyCombo.getValue();
			var datam = billcode+"|"+yearmonth+"|"+deptdr+"|"+userdr+"|"+mdesc+"|"+applycode;
			var recordType;
			if (r.data.newRecord) {
				recordType = "add1";
			} else {
				recordType = "edit";
			}
			o[this.idName] = r.get(this.idName);
			data.push(o);
			var saveUrl = editGrid.url + '?action=' + recordType + tmpstro.toString() +"&rowidm="+rowidm+"&datad="+encodeURIComponent(datad)+"&datam="+encodeURIComponent(datam)
					+ Ext.urlEncode(this.urlParam);
			p = {
				url : saveUrl,
				method : 'GET',
				waitMsg : '保存中...',
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

						var message = "";
						message = recordType == 'add1' ? '添加成功!' : '保存成功!'
						Ext.Msg.show({
									title : '注意',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
								});
						editGrid.store.commitChanges();
						if (jsonData.refresh == 'true') {
							editGrid.store.load({
								params : {
									start : Ext
											.isEmpty(editGrid.getTopToolbar().cursor)
											? 0
											: editGrid.getTopToolbar().cursor,
									limit : editGrid.pageSize,
									billcode:billcode
								}
							});
						}
					} else {
						if (jsonData.refresh == 'true') {
							editGrid.store.load({
								params : {
									start : Ext
											.isEmpty(editGrid.getTopToolbar().cursor)
											? 0
											: editGrid.getTopToolbar().cursor,
									limit : editGrid.pageSize,
									billcode:billcode
								}
							});
						}
						var message = "";
						message = "SQLErr: " + jsonData.info;
						if (jsonData.info == 'EmptyName')
							message = '输入的名称为空!';
						if (jsonData.info == 'EmptyOrder')
							message = '输入的序号为空!';
						if (jsonData.info == 'RepCode')
							message = '输入的编码已经存在!';
						if (jsonData.info == 'RepName')
							message = '输入的名称已经存在!';
						if (jsonData.info == 'RepOrder')
							message = '输入的序号已经存在!';
						if (jsonData.info == 'RecordExist')
							message = '输入的记录已经存在!';
						Ext.Msg.show({
									title : '错误',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
						editGrid.store.rejectChanges();
					}
				},
				scope : this
			};
			Ext.Ajax.request(p);
		}, this);
		return rtn;
	}*/
editGrid.load({params:{start:0, limit:25,billcode:billcode}});
//editGrid.addButton(SubButton);
editGrid.btnAddHide();
editGrid.btnSaveHide();
editGrid.btnResetHide();
editGrid.btnDeleteHide();
editGrid.btnPrintHide();
editGrid.btnSaveHide();
///if((billstate=='完成')&&(billstate=='新建')&&(billstate=='提交')) {
	if(billstate=='完成') {
	var tbar = editGrid.getTopToolbar();
	var addbutton = tbar.get('herpAddId');
	var deletebutton = tbar.get('herpDeleteId');
	addbutton.disable();
	deletebutton.disable();
}


	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({ text : '关闭'});

	// 定义取消按钮的响应函数
	cancelHandler = function(){
		itemGrid.load({params:{start:0, limit:12, userdr:userId}});
	  	window.close();
	};

	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);
	
	
	// 初始化面板
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [queryPanel,editGrid]
			});

	var tabPanel =  new Ext.Panel({
  	//activeTab: 0,
  	layout: 'border',
  	region:'center',
  	items:[queryPanel,editGrid]                                 //添加Tabs
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
	
	window.show();	
	//window.on('beforeclose',del);
	
};
