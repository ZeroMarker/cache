
detailFun = function(FundBillDR,Name){

var statetitle = Name +"执行明细";

var projUrl = 'herp.budg.budgprojfundreqexe.csp';
var YearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

YearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=yearList',
						method : 'POST'
					});
		});

var yearCombo = new Ext.form.ComboBox({
			fieldLabel : '立项年度',
			store : YearDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
var projDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

projDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=projList&userdr='+userdr,
						method : 'POST'
					});
		});

var projCombo = new Ext.form.ComboBox({
			fieldLabel : '项目名称',
			store : projDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});

var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){

	      	var year = yearCombo.getValue();
			var projname = projCombo.getValue();
			
			var selectedRow = itemGrid.getSelectionModel().getSelections();
	 	    var ProjDR=selectedRow[0].data['ProjDR'];  

			detailitemGrid.load({params:{start:0,limit:25,ProjDR:ProjDR,year:year,projname:projname}});
	}
});

var detailitemGrid = new dhc.herp.Grid({
				width : 400,
				region : 'center',
				url : 'herp.budg.budgprojfundreqitemexe.csp',
				fields : [
				{
							header : 'ID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'Date',
							header : '时间',
							dataIndex : 'Date',
							width : 60,
							editable:false
						},{
							id : 'Digest',
							header : '摘要',
							dataIndex : 'Digest',
							width : 70,
							editable:false
// rowid  Date  Digest   ItemCode  BudgValue  PayValue  Balance
						},{
							id : 'ItemCode',
							header : '预算项',
							dataIndex : 'ItemCode',
							width : 80,
							editable:false

						},{
							id : 'BudgValue',
							header : '预算额',
							dataIndex : 'BudgValue',
							align:'right',
							width : 60,
							editable:false

						},{
							id : 'PayValue',
							header : '执行额',
							dataIndex : 'PayValue',
							align:'right',
							width : 60,
							editable:false

						},{
							id : 'Balance',
							header : '结余',
							dataIndex : 'Balance',
							align:'right',
							width : 60,
							editable:false

						}],
						viewConfig : {forceFit : true},
						tbar : ['立项年度：',yearCombo,'项目名称：',projCombo,'-',findButton ]	

			});

	detailitemGrid.btnAddHide();  //隐藏增加按钮
   	detailitemGrid.btnSaveHide();  //隐藏保存按钮
    detailitemGrid.btnResetHide();  //隐藏重置按钮
    detailitemGrid.btnDeleteHide(); //隐藏删除按钮
    detailitemGrid.btnPrintHide();  //隐藏打印按钮
    
    
    var selectedRow = itemGrid.getSelectionModel().getSelections();
	var ProjDR=selectedRow[0].data['ProjDR'];  
	detailitemGrid.load({params:{start:0, limit:12,ProjDR:ProjDR}});
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
				items : [detailitemGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : statetitle,
				plain : true,
				width : 600,
				height : 350,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
};