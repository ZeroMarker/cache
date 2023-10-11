
stateFun = function(FundBillDR,Code,Name){

var statetitle = "单据号"+Code+"对应的项目"+Name +"状态";


var stateitemGrid = new dhc.herp.Gridhss({
				width : 400,
				region : 'center',
				url : 'herp.budg.budgprojfundreqexe.csp',
				fields : [
				{
							header : 'ID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'deptname',
							header : '执行科室',
							dataIndex : 'deptname',
							width : 80,
							editable:false
						},{
							id : 'apllyname',
							header : '执行人',
							dataIndex : 'apllyname',
							width : 70,
							editable:false

						},{
							id : 'ChkResult',
							header : '执行结果',
							dataIndex : 'ChkResult',
							width : 60,
							editable:false

						},{
							id : 'ChkProcDesc',
							header : '执行过程描述',
							dataIndex : 'ChkProcDesc',
							width : 80,
							editable:false

						},{
							id : 'DateTime',
							header : '执行时间',
							dataIndex : 'DateTime',
							width : 60,
							editable:false

						}],
						viewConfig : {forceFit : true}	

			});

	
	stateitemGrid.load({params:{start:0, limit:12,FundBillDR:FundBillDR}});
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
				items : [stateitemGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : statetitle,
				plain : true,
				width : 600,
				height : 350,
				modal : true,
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
};