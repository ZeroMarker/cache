
depAdjustFun = function(Year, AdjustNo, itemCode, itemName, planValueModi){
	var depadjustURL='herp.budg.budgadjustdepadjustexe.csp';
	var budginfotitle = "单位工作量科室调整";
	var detailitemGrid = new dhc.herp.Grid({
				width : 400,
				region : 'center',
				url : depadjustURL,
				fields : [{
							header : 'ID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'code',
							header : '科室名称',
							dataIndex : 'code',
							width : 60,
							editable:false
						},{
							id : 'planValue',
							header : '年初预算',
							dataIndex : 'planValue',
							align:'right',
							width : 60,
							editable:false

						},{
							id : 'planValueModi',
							header : '调整预算',
							dataIndex : 'planValueModi',
							align:'right',
							width : 60,
							editable:false

						},{
							id : 'adjustRatio',
							header : '调整比例',
							dataIndex : 'adjustRatio',
							align:'right',
							width : 60,
							editable:false
						}
						],
						viewConfig : {forceFit : true},
						tbar : ['工作量名称：',itemName,'-','调整预算：',planValueModi]	

	});
	
	detailitemGrid.btnAddHide();  //隐藏增加按钮
   	detailitemGrid.btnSaveHide();  //隐藏保存按钮
    detailitemGrid.btnResetHide();  //隐藏重置按钮
    detailitemGrid.btnDeleteHide(); //隐藏删除按钮
    detailitemGrid.btnPrintHide();  //隐藏打印按钮
	detailitemGrid.load({params:{Year:Year, AdjustNo:AdjustNo, itemCode:itemCode, start:0, limit:25}});
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
				title : budginfotitle,
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