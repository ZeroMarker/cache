var UserId = session['LOGON.USERID'];
var userCode = session['LOGON.USERCODE'];
var userName = session['LOGON.USERNAME'];
var bookID= IsExistAcctBook();

var projUrl="herp.acct.acctunentrycompexe.csp"
//初始余额保存
var SaveAmtBal  = new Ext.Toolbar.Button({
		text: '余额保存',  
        iconCls:'save',
        handler:function(){
		//定义并初始化行对象
		var rowObj=itemGrid.getSelectionModel().getSelections();
		var SubName=deptCombo.getValue();
		if(SubName=="")
		{
			Ext.Msg.show({title:'注意',msg:'请选择银行科目!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;			
		}
        var amtbal=amtbalField.getValue();
		if(amtbal==""||amtbal==0)
		{	
			Ext.Msg.show({title:'注意',msg:'请填写金额! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;		
		}
		function handler(id){
			if(id=="yes"){
					Ext.Ajax.request({
					url:projUrl+'?action=saveamtbal&amtbal='+amtbal+'&SubName='+SubName+'&bookID='+bookID,
					waitMsg:'保存中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:'保存成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							itemGrid.load({params:{start:0, limit:12,UserId:UserId}});							
						}else{
							Ext.Msg.show({title:'错误',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}
			else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要保存最新余额吗?',handler);
    }
});	


//删除按钮
var delButton = new Ext.Toolbar.Button({
			text : '删除',
			tooltip : '删除',
			iconCls : 'remove',
            handler :function( ) {
				itemGrid.del();				
            }
});

//增加按钮
var addButton = new Ext.Toolbar.Button({
    text: '增加',
    tooltip:'增加',        //悬停提示
    iconCls: 'add',
    handler:function(){	
		itemGrid.add();  
	}   
});

//保存按钮
var saveButton = new Ext.Toolbar.Button({
	text:'保存',
	tooltip:'保存更改',
	iconCls: 'save',
	handler:function(){
		//调用保存函数
		itemGrid.save();
		//alert("11");
		}
	});
	
	
// 定义起始时间控件
	var PSField = new Ext.form.DateField({
		id : 'PSField',
		//format : 'Y-m-d',
		fieldLabel:'开始日期',
		width : 120,
		editable:true,
		emptyText : '请选择开始日期...'
	});
	var PEField = new Ext.form.DateField({
		id : 'PEField',
		//format : 'Y-m-d',
		fieldLabel:'结束日期',
		width : 120,
		editable:true,
		emptyText : '请选择结束日期...'
	});
//grid时间显示	
/* 	var dateField = new Ext.form.DateField({
		id : 'dateField',
		//format : 'Y-m-d',
		fieldLabel:'业务时间',
		width : 120,
		editable:true
	}); */	
 ///银行科目
var bankDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['subjCode','subjName', 'subjCodeName'])
		});

bankDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=GetCashSubj&bookID='+bookID,method:'POST'
					});
		});
var bankCombo = new Ext.form.ComboBox({
			fieldLabel : '银行科目',
			store : bankDs,
			displayField : 'subjName',
			valueField : 'subjCode',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			//emptyText : '科目字典中末级银行科目',
			width : 200,
			listWidth : 250,
			pageSize : 10,
			minChars : 1,
			//allowBlank: false,
			selectOnFocus : true
		});
//末级银行科目
var deptCombo = new Ext.form.ComboBox({
			id : 'deptCombo',
			fieldLabel : '银行科目',
			store : bankDs,
			displayField : 'subjCodeName',
			valueField : 'subjCode',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '科目字典中末级银行科目',
			width : 220,
			listWidth : 250,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			listeners: {
               select: function(){ 
			         var SubName=Ext.getCmp('deptCombo').getValue();
					 Ext.Ajax.request({
						url : projUrl+'?action=GetAmtBal&bookID='+bookID+'&SubName='+SubName,
						failure : function(result, request) {
								Ext.Msg.show({
											title : '错误',
											msg : '请检查网络连接!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
											});
								},
						success : function(result, request) {
							    var resultstr = result.responseText;
								amtbalField.setValue(resultstr);								
								},
										scope : this
							});		
			         
			   }
            }
		});		
//结算方式

var typeDs = new Ext.data.Store({
			autoLoad:true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
typeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({

						url : projUrl+'?action=GetSysChequeType',method:'POST'
					});
		});
var CheqTypeNameCombo = new Ext.form.ComboBox({
			fieldLabel : '结算方式',
			store : typeDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 80,
			listWidth : 250,
			pageSize : 10,
			minChars : 1,
			editable:true,
			selectOnFocus : true
	});
		

		//初始余额
var amtbalField = new Ext.form.TextField({
    id: 'amtbal',
    width:140,
    //triggerAction: 'all',
    fieldLabel: '初始余额', 
    style:'text-align:right', 		
    name: 'amtbal' ,
	//type:'numberField',
    //editable:true,
	selectOnFocus : true
});

//查询按钮
var findButton = new Ext.Toolbar.Button({
		text: '查询',
		tooltip:'查询', 
		iconCls: 'find',	       //给按钮加图标
		width:55,
		handler:function(){	
			//查询函数List()的JS文件
					var startdate= PSField.getValue();
					if(startdate!==""){
						startdate=startdate.format('Y-m-d');
					}
					var enddate = PEField.getValue();
					if(enddate!==""){
						enddate=enddate.format('Y-m-d');
					}
					var dept  = deptCombo.getValue();
					itemGrid.load({
						 params:{						 
						        //start : 0,
								//limit : 25,
								StartDate:startdate,
		    					EndDate:enddate,
		    					SubName:dept,
								bookID:bookID
								}
					});
		}
});

  	
	var queryPanel = new Ext.FormPanel({
	    title:'单位未达账维护',
		iconCls:'maintain',
		region: 'north',
		height: 73,
		frame: true,
		defaults: {
			bodyStyle: 'padding:5px '
		},
		items: [{
				xtype: 'panel',
				layout: 'column',
				hideLabel: true,
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: '开始时间',
						style: 'padding:0 5px;'
						//width: 70
					}, PSField, {
						xtype: 'displayfield',
						value: '',
						style: 'line-height: 15px;',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '结束时间',
						style: 'padding:0 5px;'
						//width: 70
					}, PEField, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '银行科目',
						style: 'padding:0 5px;'
						//width: 70
					}, deptCombo, {
						xtype: 'displayfield',
						value: '',
						width: 15
					},
					findButton,{
						xtype: 'displayfield',
						value: '',
						width: 15
					},{
						xtype: 'displayfield',
						value: '初始余额',
						style: 'padding:0 5px;'
						//width: 70
					},amtbalField,{
						xtype: 'displayfield',
						value: '',
						width: 15
					},SaveAmtBal
				]
			}]

	});

var itemGrid = new dhc.herp.Grid({
		    //title: '单位未达账查询列表',
			//iconCls:'list',
		    region : 'center',
		    url: projUrl,
		    //atLoad : true, // 是否自动刷新
		    tbar:[addButton,'-',delButton,'-',saveButton],
			fields : [
			      new Ext.grid.CheckboxSelectionModel({editable:false}),
			       {
						header : '申请表ID',
						dataIndex : 'rowid',
						hidden : true
					},{
						id : 'AcctSubjName',
						header: '<div style="text-align:center">银行科目</div>',
						width : 150,
						allowBlank: false,
						type:bankCombo,
						dataIndex : 'AcctSubjName'
					},{
						id : 'OccurDate',
						header: '<div style="text-align:center">业务时间</div>',
						width : 100,
						allowBlank: true,						
						align: 'center',
						dataIndex : 'OccurDate',
						type: 'dateField'
					},{
						id : 'CheqTypeName',
						header: '<div style="text-align:center">结算方式</div>',
						width : 90,
						type:CheqTypeNameCombo,
						align: 'center',
						allowBlank: true,
						dataIndex : 'CheqTypeName'
					},{
						id : 'CheqNo',
						header: '<div style="text-align:center">票据号</div>',
						width : 180,
						allowBlank: true,
						dataIndex : 'CheqNo'
					}, {
						id : 'summary',
						header: '<div style="text-align:center">摘要</div>',
						width : 300,
						allowBlank: true,
						dataIndex : 'summary'
					}, {
						id : 'AmtDebit',
						header: '<div style="text-align:center">借方金额</div>',
						width : 150,
						align: 'right',
						type:'numberField',
						allowBlank: false,
						dataIndex : 'AmtDebit'
					},{
						id : 'AmtCredit',
						header: '<div style="text-align:center">贷方金额</div>',
						width : 150,
						align: 'right',
						allowBlank: false,
						type:'numberField',
						dataIndex : 'AmtCredit'
					}]					
		});
		itemGrid.load({params:{start:0, limit:12,bookID:bookID}});

//-----------InitBankFlag==1时，增删改按钮不可用
itemGrid.store.on('load',function(){
	Ext.Ajax.request({
		url: projUrl+'?action=GetInitBankFlag&bookID=' + bookID,method:'POST',
		success: function (result, request) {
			var respText = Ext.decode(result.responseText);
			var str = respText.info;
			InitBankFlag = str;
			if (InitBankFlag == 1) {			
				addButton.disable();
				delButton.disable();
				saveButton.disable();
				SaveAmtBal.disable();
			}
		}
	});
});  
//按钮标志为1时，不可进行行编辑
itemGrid.on('beforeedit',function(editor, e){		
	if (InitBankFlag == 1) {
		return false;
	}
});
 //借贷方金额修改一个，另一个就为0
itemGrid.on('afteredit', afterEdit, this );
function afterEdit(e) {
    if(e.field=="AmtDebit"){
    	if(e.value!=0){e.record.set("AmtCredit",0);}
    }else if(e.field=="AmtCredit"){
    	if(e.value!=0){e.record.set("AmtDebit",0);}
    }     
};



 	itemGrid.btnAddHide()     //隐藏增加按钮
    itemGrid.btnSaveHide()    //隐藏保存按钮
    itemGrid.btnDeleteHide()  //隐藏删除按钮
    itemGrid.btnResetHide()     //隐藏重置按钮
    itemGrid.btnPrintHide()     //隐藏打印按钮