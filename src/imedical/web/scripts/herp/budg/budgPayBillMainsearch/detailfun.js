﻿
detailFun = function(FundBillDR,ProjDR,Name){

	var statetitle = Name +"执行明细";
	var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
	var projUrl = 'herp.budg.budgprojclaimapplyprojname.csp';
	//预算年度
	var YearDs = new Ext.data.Store({
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : "results",
							root : 'rows'
						}, ['year', 'year'])
			});

	YearDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : commonboxUrl+'?action=year',
							method : 'POST'
						});
			});
	var yearCombo = new Ext.form.ComboBox({
				fieldLabel : '立项年度',
				store : YearDs,
				displayField : 'year',
				valueField : 'year',
				typeAhead : true,
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '',
				width : 100,
				listWidth : 200,
				pageSize : 10,
				minChars : 1,
				columnWidth : .1,
				selectOnFocus : true
			});
			
	//项目名称	
	var projDs = new Ext.data.Store({
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : "results",
							root : 'rows'
						}, ['rowid', 'name'])
			});
	projDs.on('beforeload', function(ds, o) {

				ds.proxy = new Ext.data.HttpProxy({
							url : commonboxUrl+'?action=projList&str=',
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
				listWidth : 200,
				pageSize : 10,
				minChars : 1,
				columnWidth : .1,
				selectOnFocus : true
			});

	//查询
	var findButton = new Ext.Toolbar.Button({
		text: '查询',
		tooltip: '查询',
		iconCls: 'option',
		handler: function(){
			var year = yearCombo.getValue();
			var projname = projCombo.getValue();
			detailitemGrid.load({params:{start:0,limit:25,year:year,projname:projname,projDr:ProjDR}});
		}
	});
	
	//显示表格
	var detailitemGrid = new dhc.herp.Grid({
				width : 400,
				region : 'center',
				url : projUrl,
				fields : [
				{
							header : '执行明细ID',
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
							id : 'Desc',
							header : '摘要',
							dataIndex : 'Desc',
							width : 70,
							editable:false

						},{
							id : 'itemCode',
							header : '预算项',
							dataIndex : 'itemCode',
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
							id : 'Banlance',
							header : '结余',
							dataIndex : 'Banlance',
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
	detailitemGrid.load({params:{start:0, limit:25,projDr:ProjDR}});
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