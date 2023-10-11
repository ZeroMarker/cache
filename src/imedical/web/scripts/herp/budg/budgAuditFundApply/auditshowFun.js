auditshowFun = function(){

var userdr = session['LOGON.USERID'];
var projUrl = 'herp.budg.budgauditfundapplyshow.csp';

///////////////申请单号//////////////////////
var BillCodeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'billcode'])
		});

BillCodeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=billcodelist',
						method : 'POST'
					});
		});

var BillCodeCombo = new Ext.form.ComboBox({
			fieldLabel : '申请年度',
			store : BillCodeDs,
			displayField : 'billcode',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
		
///////////////审批人//////////////////////
var CherckerDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'CherckerName'])
		});

CherckerDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=checkerlist',
						method : 'POST'
					});
		});

var CherckerCombo = new Ext.form.ComboBox({
			fieldLabel : '申请年度',
			store : CherckerDs,
			displayField : 'CherckerName',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
		
///////////////审批时间//////////////////////
var DateTimeField = new Ext.form.DateField({
	id:'DateTimeField',
	fieldLabel: '修改日期',
	width:120,
	allowBlank:true,
	format:'Y-m-d',
	selectOnFocus:'true'
});


/////////////////// 查询按钮 //////////////////
var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){
	    var BillCode = BillCodeCombo.getValue();
        var Chercker = CherckerCombo.getValue();
	    var DateTime = DateTimeField.getValue();
	    
	    if(DateTime==="")
	    {
				var DateTime="";
		}else{
				DateTime=DateTime.format('Y-m-d');
		}

	    
	    //alert(BillCode);
	    //alert(Chercker);
	    //alert(DateTime);
	    
		auditshowGrid.load({params:{start:0,limit:25,BillCode:BillCode,Chercker:Chercker,DateTime:DateTime}});
	}
});

var auditshowGrid = new dhc.herp.Grid({
				width : 400,
				region : 'center',
				url : projUrl,
				fields : [{
						header : '本表表ID',
						width : 20,
						hidden:true,
						dataIndex : 'rowid'
					}, {
						id : 'BillDR',
						header : '单据编码',
						editable:false,
						width : 120,
						dataIndex : 'BillDR'
					},{
						id : 'Chercker',
						header : '审批人',
						width :100 ,
						editable:false,
						dataIndex : 'Chercker'

					},{
						id : 'DateTime',
						header : '审批时间',
						editable:false,
						width : 150,
						dataIndex : 'DateTime'

					}, {
						id : 'ChkResult',
						header : '审批结果',
						editable:false,
						width : 120,
						dataIndex : 'ChkResult',
						hidden : false
					}, {
						id : 'ChkProcDesc',
						header : '审批功能描述',
						editable:false,
						width : 120,
						dataIndex : 'ChkProcDesc'
					}, {
						id : 'Desc',
						header : '审批意见描述',
						editable:false,
						width : 70,
						dataIndex : 'Desc'
					},{
						id : 'StepNO',
						header : '审批顺序号',
						width : 120,
						editable:false,
						dataIndex : 'StepNO'
					}, {
						id : 'DeptDR',
						header : '审批科室',
						width : 120,
						editable : false,
						dataIndex : 'DeptDR'
						
					},{
						id : 'BillType',
						header : '单据类型',
						width : 140,
						editable:false,
						dataIndex : 'BillType'

					},{
						id : 'IsCurStep',
						header : '是否为当前审批',
						width : 140,
						editable:false,
						dataIndex : 'IsCurStep'

					}],
				tbar:['申请单号:',BillCodeCombo,'-','审批人',CherckerCombo,'-','审核日期:',DateTimeField,'-',findButton],
				viewConfig : {forceFit : true}	

			});

	auditshowGrid.btnAddHide();    //隐藏增加按钮
   	auditshowGrid.btnSaveHide();   //隐藏保存按钮
    auditshowGrid.btnResetHide();  //隐藏重置按钮
    auditshowGrid.btnDeleteHide(); //隐藏删除按钮
    auditshowGrid.btnPrintHide();  //隐藏打印按钮
    
	auditshowGrid.load({params:{start:0, limit:12}});
	
	cancelButton = new Ext.Toolbar.Button({ text : '关闭'}); // 初始化取消按钮

	
	cancelHandler = function(){   							// 定义取消按钮的响应函数
	  window.close();
	};

	
	cancelButton.addListener('click', cancelHandler, false); // 添加取消按钮的监听事件
	
	
	
	formPanel = new Ext.form.FormPanel({					// 初始化面板
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [auditshowGrid]
			});
	var window = new Ext.Window({
				layout: 'fit',
				title : '审批流显示',
				plain : true,
				width : 1000,
				height: 500,
				modal : true,
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
			
	window.show();

};


