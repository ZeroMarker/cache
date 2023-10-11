//单据状态
stateFun = function(FundBillDR,Code,Name){
	var statetitle = "单据号"+Code+"对应的项目"+Name +"状态";
	//配件数据源
	var Url='herp.budg.budgprojclaimapplystate.csp';
	var itemGridProxy= new Ext.data.HttpProxy({url:Url+'?action=itemlist'});
	var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
		    'rowid',
			'deptname',
			'applyname',
			'ChkResult',		  
			'ChkProcDesc',
			'DateTime'
		]),
	    remoteSort: true
	});	
	
	//数据库数据模型
	var itemGridCm = new Ext.grid.ColumnModel([
					    new Ext.grid.RowNumberer(), 
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
							header : '执行人',
							dataIndex : 'applyname',
							width : 100,
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
							width : 100,
							editable:false

						},{
							id : 'DateTime',
							header : '执行时间',
							dataIndex : 'DateTime',
							width : 150,
							editable:false

						}
	]);
	
	var stateitemGrid = new Ext.grid.GridPanel({
	    width:400,
	    readerModel:'remote',
	    atLoad : true, // 是否自动刷新
		store: itemGridDs,
		cm: itemGridCm,
		trackMouseOver: true,
		stripeRows: true,
		loadMask: true
	});
	
	itemGridDs.load({params:{start:0, limit:25,FundBillDR:FundBillDR}});
	
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
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
};