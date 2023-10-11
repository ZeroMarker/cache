EditFun = function(itemGrid){
/**
*按钮权限说明
*本人未审核前：保存可用、打印可用
*	提交状态、当前审批=1
*其他：打印可用
*
**/
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var username = session['LOGON.USERNAME'];
var userId	= session['LOGON.USERID'];
Username=userId+'_'+username;
var billcode = "";
var statetitle = name +"支出申请";

var selectedRow = itemGrid.getSelectionModel().getSelections();
var rowidm=selectedRow[0].data['rowid'];
var yearmonth=selectedRow[0].data['checkyearmonth'];
var billcode=selectedRow[0].data['billcode'];
var dname=selectedRow[0].data['dname'];

var uname=selectedRow[0].data['applyer'];
var mdesc=selectedRow[0].data['applydecl'];
var deptdr=selectedRow[0].data['deprdr'];
var applycode=selectedRow[0].data['applycode'];
dname=deptdr+'_'+dname;
var billstate=selectedRow[0].data['billstate'];
var audeprdr=selectedRow[0].data['audeprdr'];
var audname=selectedRow[0].data['audname'];
var audname=audeprdr+'_'+audname;
var CheckDR=selectedRow[0].data['CheckDR'];
var FundSour=selectedRow[0].data['FundSour'];
var IsCurStep=selectedRow[0].data['IsCurStep'];
var GetMoneyPerson=selectedRow[0].data['GetMoneyPerson'];
var atnumber=selectedRow[0].data['Number'];
var openbank=selectedRow[0].data['Bank'];
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
					appuName.focus();
						
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
			pageSize : 12,
			minChars : 1,
			selectOnFocus : true,
			listeners : {
				specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					if(timeCombo.getValue()!==""){
						dnamefield.focus();
					}else{
					Handler = function(){yearmonField.focus();};
					Ext.Msg.show({title:'错误',msg:'预算期不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
					}
					}}
		});
	
/////////////////////报销科室/////////////////////////
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
			value : dname,
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
	audnamefield.setValue(cmb.getRawValue());
	}
);

///////////////////////资金申请单号/////////////////////
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
				AddReqFun(applyCombo);
			});	
//增加银行信息1、2、3


var userDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['user', 'name'])
		});

userDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgbankinformationpreserveexe.csp?action=list',
						method : 'POST'
					});
		});

var userfield = new Ext.form.ComboBox({
			fieldLabel : '付给人',
			store : userDs,
			displayField : 'name',
			valueField : 'user',
			value :GetMoneyPerson,
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			editable: false, 
			emptyText : '',
			width : 60,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .15,
			selectOnFocus : true,
			listeners:{
            	                                   select:{fn:function(combo,record,index) { 
                	                   numberDs.removeAll();
                	                   numberfield.setValue('');     				
                                                 numberDs.load({params:{start:0,limit:10,user:combo.value}});
                                                   bankDs.removeAll();
                	                   bankfield.setValue('');     				
                                                 bankDs.load({params:{start:0,limit:10,user:combo.value}});
            	}}
         	}
         	
});



			

	
///////////////////////资金申请单号/////////////////////
var numberDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['atnumber', 'atnumber'])
		});

/*numberDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgbankinformationpreserveexe.csp?action=list',
						method : 'POST'
					});
		});*/
numberDs.on('beforeload', function(ds, o) {
    var userdr=userfield.getValue();
	
    ds.proxy = new Ext.data.HttpProxy({
     url : 'herp.budg.budgbankinformationpreserveexe.csp?action=list&user='+userfield.getValue(),
						method : 'POST'
					});
	
});
var numberfield = new Ext.form.ComboBox({
			fieldLabel : '账号',
			store : numberDs,
			displayField : 'atnumber',
			valueField : 'atnumber',
			value :atnumber,
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			editable:true,
			emptyText :'',
			width : 60,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .15,
			selectOnFocus : true
			
});


numberDs.on("load", function(){
	var Num=numberDs.getCount();
    if (Num!=0){
	var id=numberDs.getAt(0).get('atnumber');
		numberfield.setValue(id);  
    } 

});




var bankDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['openbank', 'openbank'])
		});

/*bankDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgbankinformationpreserveexe.csp?action=list',
						method : 'POST'
					});
		});*/
bankDs.on('beforeload', function(ds, o) {
    var userdr=userfield.getValue();
	
    ds.proxy = new Ext.data.HttpProxy({
     url : 'herp.budg.budgbankinformationpreserveexe.csp?action=list&user='+userfield.getValue(),
						method : 'POST'
});					});
var bankfield = new Ext.form.ComboBox({
			fieldLabel : '银行',
			store : bankDs,
			displayField : 'openbank',
			valueField : 'openbank',
			value :openbank,
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			editable: true, 
			width : 60,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .15,
			selectOnFocus : true
});
bankDs.on("load", function(){
	var Num=bankDs.getCount();
    if (Num!=0){
	var id=bankDs.getAt(0).get('openbank');
		bankfield.setValue(id);  
    } 

});


//增加完成
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
						url : commonboxUrl+'?action=dept&flag=2',
						method : 'POST'
					});
		});

var audnamefield = new Ext.form.ComboBox({
			fieldLabel : '归口科室',
			store : audnameDs,
			displayField : 'name',
			valueField : 'rowid',
			value : audname,
			typeAhead : true,
			disabled: false,
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
							Ext.Msg.show({title:'错误',msg:'归口科室不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
						}
					}}
		});
audnamefield.on("select",function(cmb,rec,id ){
	Ext.MessageBox.confirm('提示', '更改归口科室需要重新进行审核，确定修改吗？', function(btn) {
		if (btn == 'no'){
			audnamefield.setValue(audname);
		}
	});
	}
);
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
			value:CheckDR,
			disabled: true,
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
						value:FundSour,
						anchor: '90%',
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
	height : 120,
	region : 'north',
	frame : true,
	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items :  [
		{
					xtype : 'displayfield',
					value : '报销单号:',
					columnWidth : .08
				}, applyNo,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .01
				}, {
					xtype : 'displayfield',
					value : '报销科室:',
					columnWidth : .08
				},dnamefield,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .01
				}, {
					xtype : 'displayfield',
					value : '付给人:',
					columnWidth : .08
				},userfield,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .01
				}, {
					xtype : 'displayfield',
					value : '申请人:',
					columnWidth : .08
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
					columnWidth : .08
				}, Descfield,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .01
				}, {
					xtype : 'displayfield',
					value : '预算期:',
					columnWidth : .08
				},timeCombo,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .01
				},  {
					xtype : 'displayfield',
					value : '账号:',
					columnWidth : .08
				},numberfield,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .01
				},{
					xtype : 'displayfield',
					value : '资金申请单号:',
					columnWidth : .08
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
					columnWidth : .08
				},audnamefield,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .01
				},{
					xtype : 'displayfield',
					value : '审批流:',
					columnWidth : .08
				},checkflowField, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .01
				}, {
					xtype : 'displayfield',
					value : '银行:',
					columnWidth : .08
				},bankfield,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .01
				}, {
					xtype : 'displayfield',
					value : '资金来源:',
					columnWidth : .08
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
    tooltip:'保存',        
    iconCls: 'save',
	handler:function(){

			Add1Fun();	//调用申请单据管理界面
	}
	
});

//////////////////提交/////////////////////
var SubButton = new Ext.Toolbar.Button({
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
				var rowid = rowObj[0].get("rowid");
				var idm = rowObj[0].get("billdr");
				var reqpay = rowObj[0].get("reqpay");
				var itemcode = rowObj[0].get("itemcode");
				var State = rowObj[0].get("State");
				if(State=="提交"){
					Ext.Msg.show({
								title : '错误',
								msg : '记录已经提交,不能重复提交!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				}
				var yearmonth = timeCombo.getValue();
				var deptdr = dnamefield.getValue();
				var audeptdr = audnamefield.getValue();
				var arr = deptdr.split("_");deptdr=arr[0];
				Ext.Ajax.request({
					url : 'herp.budg.expenseaccountdetailexe.csp?action=submit&rowid='+rowid+'&idm='+idm+'&reqpay='+reqpay+'&itemcode='+itemcode+'&yearmonth='+yearmonth+'&deptdr='+deptdr+'&audeptdr='+audeptdr+'&billcode='+billcode,
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
///////打印按钮
/*var printButton = new Ext.Toolbar.Button({
	text: '打印',
    tooltip:'打印',        
    iconCls:'add',
	handler:function(){
	
	if(obj.ReportID==""){
			ExtTool.alert("错误","请先做【上报】操作");
			return;
		}
		var PrintStr=obj.ReportID;
		PrintStr=PrintStr+"^"+session['LOGON.USERID'];
		PrintStr=PrintStr+"^"+session['LOGON.CTLOCID'];
		PrintStr=PrintStr+"^"+"PRINT";
		var ret=obj.ReportCls.ExportReport(PrintStr,"^");
		if(parseInt(ret)<=0){
			ExtTool.alert("错误","报告打印失败!"+ret);
			return;
		}else{
			var cArguments=obj.ReportID;
			var flg=PrintDataToExcel("","","高温中暑报告卡("+Common_GetValue("txtPatName")+")",cArguments);
		}

	}
});*/
///////打印按钮
var printButton = new Ext.Toolbar.Button({
    text : '打印',
	tooltip : '点击打印报销单',
	width : 70,
	height : 30,
	iconCls : 'print',
	handler : function() {
	
	//alert(billcode);
	/*fileName="{herp.budg.report.budgctrlpaybillprint.raq(billcode1="+billcode+")}";
	DHCCPM_RQDirectPrint(fileName);*/
	
		/*医政组打印
		var PrintStr=billcode;
			var flg=PrintDataToExcel("","","",PrintStr);
	*/
	//获取打印信息
			Ext.Ajax.request({
				url:'herp.budg.expenseaccountdetailexe.csp?action=print&billcode='+billcode,
				waitMsg:'打印中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success=='true') {
						var str=jsonData.info;
					
						//alert(str)
					    var listm=str.split("|")[0].split("^")
						//alert(listm)
					    var listd=str.split("|")[1].split("#")
					    var rows =str.split("|")[2]
						printCost(listm,listd,rows,billcode)			
					}else{
						Ext.Msg.show({title:'错误',msg:'错误',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				},
				scope: this
			}); 
	
    }
});

///////打印差旅费按钮
var printtravleButton = new Ext.Toolbar.Button({
    text : '打印差旅费',
	tooltip : '点击打印差旅费报销单',
	width : 70,
	height : 30,
	iconCls : 'print',
	handler : function() {
	
			Ext.Ajax.request({
				url:'herp.budg.expenseaccountdetailexe.csp?action=print&billcode='+billcode,
				waitMsg:'打印中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success=='true') {
						var str=jsonData.info;
					
						//alert(str)
					    var listm=str.split("|")[0].split("^")
						//alert(listm)
					    var listd=str.split("|")[1].split("#")
					    var rows =str.split("|")[2]
						printCostTravel(listm,listd,rows,billcode)			
					}else{
						Ext.Msg.show({title:'错误',msg:'错误',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				},
				scope: this
			}); 
	
    }
});
///////打印银行支出凭单
var printBT = new Ext.Toolbar.Button({
				id : "printBT",
				text : '<font color=black>打印支出凭单</font>',
				tooltip : '打印银行支出凭单',
				width : 70,
				height : 30,
	                 
	                  iconCls : 'print',
	                  handler : function() {
		           
		        
		       //alert(yearmonth+"^"+deptdr+"^"+uname+"^"+billstate+"^"+userId+"^"+userId);
		       fileName="{HERPBudgBankSaveExpendBill.raq(year="+yearmonth+";dept="+deptdr+";applyer="+uname+";state="+billstate+";userdr="+userId+";user="+userId+")}";
	                        //alert(yearmonth+"^"+deptdr+"^"+uname+"^"+billstate+"^"+userId+"^"+userId);
	                        DHCCPM_RQDirectPrint(fileName);
	                        
				}
});	               
var editGrid = new dhc.herp.Grid({
				width : 600,
				height : 150,
				region : 'center',
				url : 'herp.budg.expenseaccountdetailexe.csp',
				tbar:addButton,
				forms : [],
				listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                var record = grid.getStore().getAt(rowIndex);
		                  // 根据条件设置单元格点击编辑是否可用
		                  //alert(columnIndex);
		                  if ((record.get('itemname')!="")&&(record.get('rowid')=="")&&(columnIndex == 5)) {
			                  var dirty = false;
			                  var itemcode="";
			                  dirty = codeCombo.isDirty();
			                  //alert(dirty);
			                  if (dirty==true){
				                  //alert(dirty);
				                  itemcode=codeCombo.getValue();
				              }else{
					              itemcode=record.get('itemcode');
					          }
					        
					         	var audeptdr = audnamefield.getValue();
					         	var arr =audeptdr.split("_");audeptdr=arr[0];
					         	var rowid=record.get('billdr');
								var rowidd=record.get('rowid');
								var applyID = selectedRow[0].data['applydr']
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
		                    if (((record.get('State') == "提交")&& (columnIndex == 6))) {
		                         return false;
		                     } else {return true;}
		                    
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
						if ((record.get('itemname')!="")&&(record.get('rowid')=="")&&(columnIndex == 5)) {
							 var dirty = false;
			                  var itemcode="";
			                  dirty = codeCombo.isDirty();
			                  //alert(dirty);
			                  if (dirty==true){
				                  //alert(dirty);
				                  itemcode=codeCombo.getValue();
				              }else{
					              itemcode=record.get('itemcode');
					          }
					          
					          	var audeptdr = audnamefield.getValue();
					         	var arr =audeptdr.split("_");audeptdr=arr[0];
					         	var rowid=record.get('billdr');
								var rowidd=record.get('rowid');
								var applyID = selectedRow[0].data['applydr']
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
						if (((record.get('rowid') != "")&& (columnIndex == 4))||((encodeURIComponent(record.get('State')) == "提交")&& (columnIndex == 6))) {
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
							allowBlank: false,
							width : 120,
							type:codeCombo
						},{
							id : 'balance',
							header : '当前预算结余',
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
							width : 120
						},{
							id : 'actpay',
							header : '审批支付',
							align:'right',
							xtype:'numbercolumn',
							update:true,
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
							},
							dataIndex : 'actpay',
							editable:true,
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
							var sf = record.data['budgcotrol']
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
						},{
							id : 'State1',
							header : '状态1',
							dataIndex : 'State1',
							editable:false,
							hidden:true,
							width : 80
						}],
						viewConfig : {forceFit : true}
			});
 
 		
Add1Fun=function() {
		
		var records=editGrid.store.getModifiedRecords();
		var o = {};
	    var tmpDate = editGrid.dateFields;
	    var tmpstro = "";
	    var tmpstros="";
	    var data = [];
	    var itemcode = "";
	    var rtn = 0;
	    var datad="";
	    
	    editGrid.getSelectionModel().selectRow(0);
	    var getSelection = editGrid.getSelectionModel().getSelections();
	    //alert(getSelection);
	    var a="."+getSelection[0].get("State1")+".";
	    //alert("a:"+a); 
	    getSelection[0].set('State1',a);
	    //alert(getSelection[0].get("State1"));
	    
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
			var paybilldr = r.data['billdr'];
			var itemcode="";
			for (var f in r.getChanges()) {
				//alert(f);
				if (f=="itemname"){
				itemcode = r.data['itemname'];	
				}else{
					itemcode = r.data['itemcode'];
				}
				}
			if(r.data['rowid']==""){
				itemcode = r.data['itemname'];	
				}
			//alert("yicile"+ItemCode);
				
			var reqpay = r.data['reqpay'];
			var actpay = r.data['actpay'];
			var budgbalance = r.data['balance'];
			var state = r.data['State'];
			
			//BillDR ItemName Balance ReqPay ActPay Balance1
			//FundBillDR ItemCode ReqPay ActPay Desc BudgBalance
			var datad = paybilldr+"|"+itemcode+"|"+reqpay+"|"+actpay+"|"+budgbalance+"|"+state;
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
			var fundsource = fundsourceField.getValue();
			var audeptdr = audnamefield.getValue();
			var arr2 = audeptdr.split("_"); audeptdr=arr2[0];
			var checkdr = checkflowField.getValue();
                        var user = userfield.getValue();
			//alert(user)
                        var atnumber = numberfield.getValue();
			var openbank = bankfield.getValue();
			var datam = billcode+"|"+yearmonth+"|"+deptdr+"|"+userdr+"|"+mdesc+"|"+applycode+"|"+checkdr+"|"+audeptdr+"|"+fundsource+"|"+user+"|"+atnumber+"|"+openbank;
			var recordType;
			if (r.data.newRecord) {
				recordType = "add";
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
						message = recordType == 'add' ? '添加成功!' : '保存成功!'
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
	}
editGrid.load({params:{start:0, limit:25,billcode:billcode}});
//editGrid.addButton(SubButton);
editGrid.addButton(printButton);
editGrid.addButton(printtravleButton);
editGrid.addButton(printBT);
editGrid.btnAddHide();
editGrid.btnSaveHide();
editGrid.btnResetHide();
editGrid.btnDeleteHide();
editGrid.btnPrintHide();
//alert(billstate);
if((billstate=='提交')&&(IsCurStep==1)) {
	var tbar = editGrid.getTopToolbar();
	var addbutton = tbar.get('herpAddId');
	var deletebutton = tbar.get('herpDeleteId');
	addbutton.disable();
	addButton.enable();
	deletebutton.disable();
	//SubButton.disable();
}else{
	var tbar = editGrid.getTopToolbar();
	var addbutton = tbar.get('herpAddId');
	var deletebutton = tbar.get('herpDeleteId');
	addbutton.disable();
	addButton.disable();
	deletebutton.disable();
	}


	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({ text : '关闭'});

	// 定义取消按钮的响应函数
	cancelHandler = function(){
		//itemGrid.load({params:{start:0, limit:12, userdr:userId,billcode:''}});
	  	window.hide();
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
				title : '报销申请',
				plain : true,
				width : 950,
				height : 500,
				modal : true,
				buttonAlign : 'center',
				closeAction : 'hide',
				closable : true,// 是否有关闭
				listeners : {'hide':{fn: makesure}},
				items : tabPanel,
				buttons : [cancelButton]

			});
	function makesure(){
	  itemGrid.load({params:{start:0, limit:12, userdr:userId,billcode:''}});
	}
	window.show();	
	//window.on('beforeclose',del);
	
};