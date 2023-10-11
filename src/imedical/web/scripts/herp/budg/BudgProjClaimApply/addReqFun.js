AddReqFun = function(applyCombo){

/////////////////////申请单号/////////////////////////////
var ReqNofield = new Ext.form.TextField({
		id: 'ReqNofield',
		fieldLabel: '申请单号',
		allowBlank: true,
		emptyText:'请填写...',
		width:100,
	    listWidth : 100
	});
///////////////申请科室////////////////////////
var dnameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
			totalProperty : "results",root : 'rows'}, ['rowid', 'name'])});
dnameDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
			url : 'herp.budg.budgschemaselfexe.csp?action=deptNList',method : 'POST'});
		});

var dnamefield = new Ext.form.ComboBox({
			fieldLabel : '申请科室',
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
			selectOnFocus : true
		});
////////////预算期//////////////////////
var timeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({totalProperty : "results",root : 'rows'}, ['yearmonth', 'yearmonth'])
		});

timeDs.on('beforeload', function(ds, o) {ds.proxy = new Ext.data.HttpProxy({url :'herp.budg.expenseaccountdetailexe.csp?action=timelist' ,method : 'POST'});});

var timeCombo = new Ext.form.ComboBox({
			fieldLabel : '预算期',
			store : timeDs,
			displayField : 'yearmonth',
			valueField : 'yearmonth',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择...',
			width : 100,
			listWidth : 220,
			columnWidth : .15,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
///////////////申请人////////////////////////
var appuDs = new Ext.data.Store({
	proxy : "",reader : new Ext.data.JsonReader({totalProperty : "results",root : 'rows'}, ['rowid', 'name'])
});

appuDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
			url : 'herp.budg.expenseaccountdetailexe.csp?action=userlist',method : 'POST'});
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
			selectOnFocus : true
		});
//查询按钮
var findButton = new Ext.Toolbar.Button({
	text: '查询',
    tooltip:'查询',        
    iconCls:'add',
	handler:function(){
		var billcode=ReqNofield.getValue();
		var deptdr=dnamefield.getValue();
		var yearmonth=timeCombo.getValue();
		var applyer=appuName.getValue(); 
		//billcode deptdr yearmonth applyer   dnamefield timeCombo appuName
		AddReqGrid.load(({params:{start:0,limit:25,billcode:billcode,deptdr:deptdr,yearmonth:yearmonth,applyer:applyer}}));
	}
});		

//确认按钮
var addButton = new Ext.Toolbar.Button({
	text: '确认',
    tooltip:'确认',        
    iconCls:'add'});


	// 科室设置grid
var AddReqGrid = new dhc.herp.Grid({
				width : 400,
				region : 'center',
				url : 'herp.budg.budgprojclaimapplydetailreqexe.csp',
				atLoad:true,
				fields : [
				//new Ext.grid.CheckboxSelectionModel({editable:false}),
				{
							header : 'ID',
							dataIndex : 'rowid',
							hidden : true
						}, {
							id : 'BillCode',
							header : '申请单号',
							dataIndex : 'BillCode',
							width : 120,
							editable:false
						},{
							id : 'YearMonth',
							header : '预算期间',
							dataIndex : 'YearMonth',
							width : 100,
							editable:false
						},{
							id : 'DeptDR',
							header : '申请科室',
							dataIndex : 'DeptDR',
							width : 120,
							hidden:true

						}, {
							id : 'UserDR',
							header : '申请人',
							dataIndex : 'UserDR',
							width : 120,
							editable:false
						},{
							id : 'ReqPay',
							header : '申请额度',
							dataIndex : 'ReqPay',
							width : 200,
							editable:false
						}, {
							id : 'Desc',
							header : '申请说明',
							dataIndex : 'Desc',
							width : 80,
							editable:false
						}],
				tbar:['申请单号:',ReqNofield,'-','申请科室:',dnamefield,'-','期间:',timeCombo,'-','申请人:',appuName,'-',findButton]
			});
	
//定义添加按钮响应函数
addHandler = function(){
        var rowObj=AddReqGrid.getSelectionModel().getSelections();
	    var len = rowObj.length;
	    if(len < 1){
		    Ext.Msg.show({title:'注意',msg:'请选择一条记录！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		    return;
	       }
	    var str="";
	    for(var i = 0; i < len; i++){
	    	var rowid = rowObj[i].get("rowid");
	    	var billcode = rowObj[i].get("BillCode");
			str=rowid+"_"+billcode;
			applyCombo.setValue(str);
			}	 
		  window.close();
		  
		};
	
	addButton.addListener('click',addHandler,false);
	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({ text : '关闭'});

	// 定义取消按钮的响应函数
	cancelHandler = function() { window.close(); };

	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);
	
	
	// 初始化面板
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [AddReqGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : '申请单选择',
				plain : true,
				width : 900,
				height : 450,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [addButton,cancelButton]

			});
			
	window.show();
    AddReqGrid.btnAddHide();  //隐藏增加按钮
    AddReqGrid.btnSaveHide();  //隐藏保存按钮
    AddReqGrid.btnResetHide();  //隐藏重置按钮
    AddReqGrid.btnDeleteHide(); //隐藏删除按钮
    AddReqGrid.btnPrintHide();  //隐藏打印按钮
};