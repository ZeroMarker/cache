﻿addFun = function(itemGrid){
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var userCode = session['LOGON.USERCODE'];
var username = session['LOGON.USERNAME'];
var userId	= session['LOGON.USERID'];
var hisdeptdr	= session['LOGON.CTLOCID'];
username=userId+'_'+username;
var billcode = "";
var statetitle = name +"支出申请";
var isReq = new Ext.form.Checkbox({
						id : 'isdept',
						fieldLabel: '有否申请单',
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									applyNofield.focus();
								}
							}
						}			
					});	

/////////////////////报销单号/////////////////////////
var applyNofield = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			emptyText: '回车生成单据号......',	
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
							var bcodes = jsonData.info;
							var arr = bcodes.split("^");
							bcode=arr[0];
							checkdr=arr[1];
							applyNofield.setValue(bcode);
							checkflowField.setValue(checkdr);
						}else{
							var message="";
							if(jsonData.info=='RepCode') message='单据号已经存在，请回车重新生成！';
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							applyNofield.focus();
						}
					},
					scope: this
					});
					appuName.focus();
						
						}
					}}

		});
///////////////报销人////////////////////////
var appuDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

appuDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url :  commonboxUrl + '?action=username&flag=3',
						method : 'POST'
					});
		});

var appuName = new Ext.form.ComboBox({
			fieldLabel : '申请人',
			store : appuDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .15,
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
appuName.setValue(username);
/*Ext.Ajax.request({
					url: commonboxUrl + '?action=getdname&hisdeptdr='+hisdeptdr+'&start=0&limit=10',
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							var bcodes = jsonData.info;
							var arr = bcodes.split("^");
							bcode=arr[0];
	  						if(bcode=='0409'){
		  						appuName.disabled="true";
		  					}
						}
						
					},
					scope: this
});*/
				
/////////////////////报销说明/////////////////////////
 Descfield = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
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
////////////预算期//////////////////////
var timeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({totalProperty : "results",root : 'rows'}, ['year', 'year'])
		});

timeDs.on('beforeload', function(ds, o) {ds.proxy = new Ext.data.HttpProxy({url : commonboxUrl + '?action=year&flag=1' ,method : 'POST'});});

var timeCombo = new Ext.form.ComboBox({
			fieldLabel : '预算期',
			store : timeDs,
			displayField : 'year',
			valueField : 'year',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择...',
			width : 100,
			listWidth : 220,
			columnWidth : .15,
			pageSize : 12,
			minChars : 1,
			selectOnFocus : true,
			listeners : {
				specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					if(timeCombo.getValue()!==""){
						dnamefield.focus();
					}else{
					Handler = function(){timeCombo.focus();};
					Ext.Msg.show({title:'错误',msg:'预算期不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
					}
					}}
		});
timeCombo.on("select",function(cmb,rec,id ){
		Ext.Ajax.request({
					url: '../csp/herp.budg.expenseaccountdetailexe.csp?action=getclaimcode&yearmonth='+cmb.getValue(),				
					success: function(result, request){
					
						var jsonData = Ext.util.JSON.decode( result.responseText );

						if (jsonData.success=='true'){
							var bcodes = jsonData.info;
							var arr = bcodes.split("^");
							bcode=arr[0];
							checkdr=arr[1];
							applyNofield.setValue(bcode);
							checkflowField.setValue(checkdr);
						}else{
							var message="";
							if(jsonData.info=='RepCode') message='单据号已经存在，请回车重新生成！';
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							applyNofield.focus();
						}
					},
					scope: this
					});
	}
);
			
///////////////科室名称////////////////////////
var dnameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

dnameDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : commonboxUrl + '?action=dept&flag=2',
						method : 'POST'
					});
		});

var dnamefield = new Ext.form.ComboBox({
			fieldLabel : '科室名称',
			store : dnameDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .15,
			selectOnFocus : true,
			listeners : {
					specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					if(dnamefield.getValue()!==""){
							applyCombo.focus();
						}else{
							Handler = function(){dnamefield.focus();};
							Ext.Msg.show({title:'错误',msg:'科室名称不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
						}
					}}
		});
dnamefield.on("select",function(cmb,rec,id ){
	audnamefield.setValue(cmb.getValue()+"_"+cmb.getRawValue());
	}
);

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
				//url : 'herp.budg.expenseaccountdetailexe.csp?action=applycode&&userdr='+ userId,
				method : 'POST'
			});
});

 applyCombo = new Ext.form.ComboBox({
	fieldLabel : '资金申请单号',
	store : applyDs,
	displayField : 'applycode',
	valueField : 'rowid',
	disabled:false,
	typeAhead : true,
	emptyText:'请选择资金申请单号',
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 90,
	listWidth : 200,
	pageSize : 10,
	minChars : 1,
	columnWidth : .15,
	selectOnFocus : true,
	listeners : {
				specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					if(applyCombo.getValue()!==""){
						audnamefield.focus();
					}else{
					Handler = function(){applyCombo.focus();};
					Ext.Msg.show({title:'错误',msg:'资金申请单号不能为空!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
					}
					}}
});
applyCombo.on('focus', function(f){
				/*var state=stateField.getValue();
				if (state!="1"){
					Ext.Msg.show({title:'错误',msg:'用户状态不是有效，不能同步！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;}*/
				if(audnamefield.getValue()==""){
					Ext.Msg.show({
								title : '注意',
								msg : '请先选择归口科室！',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
					}
				  else if(codeCombo.getValue()==""){
					applyDs=null;
					Ext.Msg.show({
								title : '注意',
								msg : '请先选择报销项！',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
				
					}else{
						
						var audeptdr = audnamefield.getValue();
						var itemcode = codeCombo.getValue();
						var arr=audeptdr.split("_");audeptdr=arr[0];
					
							AddReqFun(applyCombo,audeptdr,itemcode);
						
						}
				
			});	
///////////////归口科室////////////////////////
var audnameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

audnameDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : commonboxUrl + '?action=dept&flag=1',
						method : 'POST'
					});
		});
var audnamefield = new Ext.form.ComboBox({
			fieldLabel : '归口科室',
			store : audnameDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .15,
			selectOnFocus : true,
			listeners : {
					specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					if(audnamefield.getValue()!==""){
							checkflowField.focus();
						}else{
							Handler = function(){audnamefield.focus();};
							Ext.Msg.show({title:'错误',msg:'科室名称不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
						}
					}}
		});
////////////审批流//////////////////////
var checkflowDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({totalProperty : "results",root : 'rows'}, ['rowid', 'name'])
		});

checkflowDs.on('beforeload', function(ds, o) {ds.proxy = new Ext.data.HttpProxy({
url :'../csp/herp.budg.budgctrlfundbillmngexe.csp?action=checkflowlist',method : 'POST'});});

var checkflowField = new Ext.form.ComboBox({
			fieldLabel : '审批流',
			store : checkflowDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
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
					if(checkflowField.getValue()!==""){
						fundsourceField.focus();
					}else{
					Handler = function(){checkflowField.focus();};
					Ext.Msg.show({title:'错误',msg:'审批流不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
					}
					}}
		});
///给审批流赋值
/*Ext.Ajax.request({
					url: '../csp/herp.budg.budgctrlfundbillmngexe.csp?action=getcheckdr',				
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							var checkdr = jsonData.info;
							checkflowField.setValue(checkdr);
						}else{
							var message=jsonData.info;
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
});		*/
applyCombo.disable();
isReq.on('check', function( c , checked ){
				if(checked){
					dnamefield.enable();
					applyCombo.enable();
					audnamefield.enable();
					checkflowField.disable();
				}else{
					dnamefield.enable();
					applyCombo.disable();
					audnamefield.enable();
					checkflowField.enable();
				}
			});
/////////////////////资金来源////////////////////////////
var fundsourceStore = new Ext.data.SimpleStore({
						fields:['key','keyValue'],
						data:[['1','现金'],['2','银行']]
					});
var fundsourceField = new Ext.form.ComboBox({
						id: 'fundsourceField',
						fieldLabel: '资金来源',
						width:120,
						allowBlank: false,
						store: fundsourceStore,
						//anchor: '90%',
						displayField: 'keyValue',
						valueField: 'key',
						triggerAction: 'all',
						emptyText:'选择...',
						mode: 'local', // 本地模式
						pageSize: 10,
						minChars: 15,
						columnWidth : .15,
						selectOnFocus:true,
						forceSelection:true,
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									if(fundsourceField.getValue()!==""){
									fundsourceField.focus();
									}else{
									Handler = function(){fundsourceField.focus();};
									Ext.Msg.show({title:'错误',msg:'资金来源不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
									}
								}
							}
						}
					});	
var queryPanel = new Ext.FormPanel({
	height : 145,
	region : 'north',
	frame : true,
	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		xtype : 'panel',
		layout : "column",

		items : [ {
							xtype : 'displayfield',
							value : '有否申请单:',
							columnWidth : .12
						},isReq ]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
		{
					xtype : 'displayfield',
					value : '报销单号:',
					columnWidth : .12
				}, applyNofield,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '申请人:',
					columnWidth : .12
				}, appuName,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '报销说明:',
					columnWidth : .12
				}, Descfield

		]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
		{
					xtype : 'displayfield',
					value : '预算期:',
					columnWidth : .12
				},timeCombo,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : '报销科室:',
					columnWidth : .12
				},dnamefield, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '资金申请单号:',
					columnWidth : .12
				}, applyCombo
		]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
		{
					xtype : 'displayfield',
					value : '归口科室:',
					columnWidth : .12
				},audnamefield,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : '审批流:',
					columnWidth : .12
				},checkflowField, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '资金来源:',
					columnWidth : .12
				}, fundsourceField
		]
	}]
});

// ////////////预算项名称////////////////////////
var codeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

codeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgctrlfundbillmngexe.csp?action=itemcodelist&year='+ timeCombo.getValue().substr(0,4),
						method : 'POST'
					});
		});

var codeCombo = new Ext.form.ComboBox({
			fieldLabel : '预算项',
			store : codeDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .15,
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

/////////////////添加按钮////////////////////////////
var addButton = new Ext.Toolbar.Button({
	text: '保存',
    tooltip:'添加',        
    iconCls: 'save',
	handler:function(){
		var rowObj = addGrid.getSelectionModel().getSelections();
		var len = rowObj.length;
		if (len < 1) {
			Ext.Msg.show({title : '注意',msg : '请选择需要操作的记录!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.WARNING});
			return;
		}
		var State = rowObj[0].get("State");
				if(State=="提交"){
					addButton.disabled();
					Ext.Msg.show({
								title : '注意',
								msg : '记录已经提交,不能重复提交!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				}

				AddFun();	//调用申请单据管理界面
		
	}
	
});

//////////////////提交/////////////////////
var SubButton = new Ext.Toolbar.Button({
			text : '提交',
			tooltip : '提交',
			iconCls:'add',
			handler : function() {
				var rowObj = addGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				if (len < 1) {
					Ext.Msg.show({title : '注意',msg : '请选择需要提交的记录!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.WARNING});
					return;
				}
				var billcode = applyNofield.getValue();
				var rowid = rowObj[0].get("rowid");
				var idm = rowObj[0].get("billdr");
				var reqpay = rowObj[0].get("reqpay");
				var itemcode = rowObj[0].get("itemcode");
				var State = rowObj[0].get("State");
				if(State=="提交"){
					Ext.Msg.show({
								title : '注意',
								msg : '记录已经提交,不能重复提交!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				}
				var yearmonth = timeCombo.getValue();
				var deptdr = dnamefield.getValue();
				var audeptdr = audnamefield.getValue();
				var arr = deptdr.split("_");
				deptdr=arr[0];
				Ext.Ajax.request({
					url : 'herp.budg.expenseaccountdetailexe.csp?action=submit&rowid='+rowid+'&idm='+idm+'&reqpay='+reqpay+'&itemcode='+itemcode+'&yearmonth='+yearmonth+'&deptdr='+deptdr+'&audeptdr='+audeptdr+'&billcode='+billcode,
					failure : function(result, request) {
						Ext.Msg.show({title : '错误',msg : '请检查网络连接!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
					},
					success : function(result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							Ext.Msg.show({title : '注意',msg : '提交成功!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
							addGrid.load({params:{start:0, limit:25,billcode:billcode}});
						} else {
							var message="SQLErr: "+ jsonData.info;
							Ext.Msg.show({title : '错误',msg : message,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
						}
					},
					scope : this
				});
			}
		});

var addGrid = new dhc.herp.Grid({
				width : 600,
				region : 'center',
				url : 'herp.budg.expenseaccountdetailexe.csp',
				tbar:addButton,
				forms : [],
				listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                var record = grid.getStore().getAt(rowIndex);
		                  // 根据条件设置单元格点击编辑是否可用
		                  //alert(columnIndex);
		                  	//if ((record.get('itemname')!="")&&(record.get('rowid')=="")&&(columnIndex == 5)) {
			                if ((record.get('itemname')!="")&&(record.get('rowid')=="")&&(columnIndex == 5)) {
					           	var yearmonth = timeCombo.getValue();
								var deptdr = dnamefield.getValue();
								var audeptdr = audnamefield.getValue();
								//alert(deptdr);
								if(audeptdr!=""){
								deptdr=audeptdr;
								}
							  var arr = deptdr.split("_");deptdr=arr[0];
								//alert(deptdr);
							  var rowid = record.get('rowid');
							  var itemcode=record.get('itemcode');
			                  for (var f in addGrid.getSelectionModel().getSelected().getChanges()) {
								if (f=="itemname"){
									itemcode = record.get('itemname');
										
								}
								}
								
								var rowid=record.get('billdr');
								var rowidd=record.get('rowid');
								var applyID = applyCombo.getValue();
								var arr1 = applyID.split("_");applyID=arr1[0];
								var isreq = isReq.getValue();
								var data = deptdr+"^"+yearmonth+"^"+itemcode+"^"+record.get('State')+"^"+rowidd+"^"+"Act"+"^"+rowid+"^"+isreq+"^"+applyID;
								
					            Ext.Ajax.request({				
								url: '../csp/herp.budg.budgctrlfundbillmngexe.csp?action=getcurbalance&data='+encodeURIComponent(data),				
								success: function(result, request){
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true'){
										var curbalance = jsonData.info;
										record.data.balance=curbalance;
										record.set(5, curbalance);
									}
								},scope: this
								});
							}
		                    if ((record.get('rowid') != "")&&(record.get('rowid')=="")&&(record.get('State') !== "新建")) {
			                    //((record.get('rowid') != "")&& (columnIndex == 4))||
		                         return false;
		                    } else {return true;}
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
						if ((record.get('itemname')!="")&&(columnIndex == 5)) {
					           	var yearmonth = timeCombo.getValue();
								var deptdr = dnamefield.getValue();
								var audeptdr = audnamefield.getValue();
								if(audeptdr!=""){
								deptdr=audeptdr;
								}
								var arr = deptdr.split("_");deptdr=arr[0];
							  
							  var itemcode=record.get('itemcode');
			                  for (var f in addGrid.getSelectionModel().getSelected().getChanges()) {
								if (f=="itemname"){
									itemcode = record.get('itemname');	
								}
								}
								var rowid=record.get('billdr');
								var rowidd=record.get('rowid');
								var applyID = applyCombo.getValue();
								var arr1 = applyID.split("_");applyID=arr1[0];
								var isreq = isReq.getValue();
								var data = deptdr+"^"+yearmonth+"^"+itemcode+"^"+record.get('State')+"^"+rowidd+"^"+"Act"+"^"+rowid+"^"+isreq+"^"+applyID;
					            
					            Ext.Ajax.request({
								url: '../csp/herp.budg.budgctrlfundbillmngexe.csp?action=getcurbalance&data='+encodeURIComponent(data),				
								success: function(result, request){
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true'){
										var curbalance = jsonData.info;
										record.data.balance=curbalance;
										record.set(5, curbalance);
									}
								},scope: this
								});
							}
						if ((record.get('rowid') != "")&&(record.get('State') !== "新建")){
						//(((record.get('rowid') != "") && (columnIndex == 4))||((record.get('State') == "提交")&& (columnIndex == 6))){						
							return false;
						} else {return true;}
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
							header : '报销主表ID',
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
							allowBlank: false,
							width : 120,
							type:codeCombo
						},{
							id : 'balance',
							header : '目前预算结余',
							dataIndex : 'balance',
							align:'right',
							xtype:'numbercolumn',
							width : 120,
							editable:false
						},{
							id : 'reqpay',
							header : '本次报销申请',
							dataIndex : 'reqpay',
							align:'right',
							xtype:'numbercolumn',
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
							},
							width : 120,
							type:valueField
						},{
							id : 'actpay',
							header : '审批支付',
							dataIndex : 'actpay',
							align:'right',
							xtype:'numbercolumn',
							editable:false,
							width : 120
						},{
							id : 'balance1',
							header : '审批后预算结余',
							dataIndex : 'balance1',
							align:'right',
							xtype:'numbercolumn',
							editable:false,
							width : 120
						},{
							id : 'budgcotrol',
							header : '预算控制',
							dataIndex : 'budgcotrol',
							width : 100,
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							var sf = record.data['budgcotrol'];
							if (sf == "超预算") {
								return '<span style="color:red;cursor:hand;">'+value+'</span>';
							} else {
								return '<span style="color:black;cursor:hand">'+value+'</span>';
							}},
							editable:false
						},{
							id : 'State',
							header : '状态',
							dataIndex : 'State',
							editable:false,
							width : 80
						}],
						viewConfig : {forceFit : true}
			}
);


	AddFun=function() {
		var records=addGrid.store.getModifiedRecords();
		var o = {};
	    var tmpDate = addGrid.dateFields;
	    var tmpstro = "";
	    var tmpstros="";
	    var data = [];
	    var rtn = 0;
	    var datad="";
		Ext.each(records, function(r) {
			var o = {};
			var tmpstro = "&rowid=" + r.data['rowid'];
			var deleteFlag = r.data['delFlag'];// 删除标识，1：是该记录已经删除，0：未删除。

			// 数据完整性验证Beging
			for (var i = 0; i < addGrid.fields.length; i++) {
				var indx = addGrid.getColumnModel().getColumnId(i + 1)
				var tmobj = addGrid.getColumnModel().getColumnById(indx)
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
			var paybilldr = r.data['billdr'];
			var itemcode = r.data['itemcode'];
			if(itemcode==""){
			var itemcode = r.data['itemname'];
			}
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
			  
			var billcode = applyNofield.getValue();
			var yearmonth = timeCombo.getValue();
			var deptdr = dnamefield.getValue();
			var arr = deptdr.split("_");deptdr=arr[0];
			var userdr = appuName.getValue().split("_")[0];
			var mdesc = Descfield.getValue();
			var applycode = applyCombo.getValue();
			var arr1 = applycode.split("_");applycode=arr1[0];
			var fundsource = fundsourceField.getValue();
			var audname = audnamefield.getValue();
			if(audname==dnamefield.getRawValue()){
				audname = dnamefield.getValue();
				}
		
			var checkdr = checkflowField.getValue();
			var arr2 = checkdr.split("_"); checkdr=arr2[0];
			var datam = billcode+"|"+yearmonth+"|"+deptdr+"|"+userdr+"|"+mdesc+"|"+applycode+"|"+checkdr+"|"+audname+"|"+fundsource+"|"+userId;
                       

			var rowidm="";
			var recordType;
			if (r.data.newRecord) {
				recordType = "add";
			} else {
				recordType = "edit";
			}
			o[this.idName] = r.get(this.idName);
			data.push(o);
			var saveUrl = addGrid.url + '?action=' + recordType + tmpstro.toString()+"&rowidm="+rowidm+"&datad="+encodeURIComponent(datad)+"&datam="+encodeURIComponent(datam)
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
						message = recordType == 'add' ? '添加成功!' : '保存成功!'
						
						Ext.Msg.show({
									title : '注意',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
								});
						addGrid.store.commitChanges();
						if (jsonData.refresh == 'true') {
							addGrid.store.load({
								params : {
									start : Ext
											.isEmpty(addGrid.getTopToolbar().cursor)
											? 0
											: addGrid.getTopToolbar().cursor,
									limit : addGrid.pageSize,
									billcode:billcode
								}
							});
						}
					} else {
						if (jsonData.refresh == 'true') {
							addGrid.store.load({
								params : {
									start : Ext
											.isEmpty(addGrid.getTopToolbar().cursor)
											? 0
											: addGrid.getTopToolbar().cursor,
									limit : addGrid.pageSize,
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
						addGrid.store.rejectChanges();
					}
				},
				scope : this
			};
			Ext.Ajax.request(p);
		}, this);
		return rtn;
	}
addGrid.load({params:{start:0, limit:25,billcode:billcode}});
//addGrid.addButton(SubButton);
addGrid.btnSaveHide();
addGrid.btnResetHide();
addGrid.btnPrintHide();
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
				items : [queryPanel,addGrid]
			});

	var tabPanel =  new Ext.Panel({
  	//activeTab: 0,
  	layout: 'border',
  	region:'center',
  	items:[queryPanel,addGrid]                                 //添加Tabs
  });
	
	var window = new Ext.Window({
				layout : 'fit',
				title : '报销申请',
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