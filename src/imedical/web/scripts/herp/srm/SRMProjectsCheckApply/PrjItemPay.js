var projUrl = 'herp.srm.srmhorizontalprjcheckapplyexe.csp';
BudgItemPay=function(SubNo){ 
var PrjItemPayGrid = new dhc.herp.Gridhs({
				//title : "经费信息",
				region : 'center',                          
				url : 'herp.srm.srmhorizontalprjcheckapplyexe.csp',
				fields : [
              new Ext.grid.CheckboxSelectionModel({editable:false}),
           {
							id : 'PYear',
							header : '年度',
							dataIndex : 'PYear',
							width : 120,
							align : 'center',
							editable:false
							//hidden:true
						},{
							id : 'PCode',
							header : '项目编码',
							dataIndex : 'PCode',
							width : 120,
							align : 'center',
							editable:false
							//type:ItemCombo
						},{
							id : 'PName',
							header : '项目名称',
							dataIndex : 'PName',
							width : 120,
							align : 'left',
							editable:false,
							hidden : false
						},{
							id : 'ItemCode',
							header : '科目编码',
							dataIndex : 'ItemCode',
							width : 120,
							editable:false,
							align : 'left'
						},{
							id : 'ItemName',
							header : '科目名称',
							dataIndex : 'ItemName',
							width : 120,
							editable:false,
							align : 'left'
						},{
							id : 'BudgTotal',
							header : '经费预算总额',
							dataIndex : 'BudgTotal',
							width : 120,
							editable:false,
							align : 'right'
						},{
							id : 'DName',
							header : '报销科室',
							dataIndex : 'DName',
							width : 120,
							editable:false,
							align : 'left'
						},{
							id : 'UName',
							header : '报销人',
							dataIndex : 'UName',
							width : 120,
							editable:false,
							align : 'left'
						},{
							id : 'BillCode',
							header : '报销单号',
							dataIndex : 'BillCode',
							width : 120,
							editable:false,
							align : 'left'
						},{
							id : 'ActPay',
							header : '实际报销',
							dataIndex : 'ActPay',
							width : 120,
							editable:false,
							align : 'right'
						},{
							id : 'BudgBalance',
							header : '结余',
							dataIndex : 'BudgBalance',
							width : 120,
							editable:false,
							align : 'right'
						},{
							id : 'Desc',
							header : '报销说明',
							dataIndex : 'Desc',
							width : 120,
							editable:false,
							align : 'left'
						}]    
			});
    
    PrjItemPayGrid.btnAddHide();  //隐藏增加按钮
    PrjItemPayGrid.btnSaveHide();  //隐藏保存按钮
    //PrjItemPayGrid.btnResetHide();  //隐藏重置按钮
    PrjItemPayGrid.btnDeleteHide(); //隐藏删除按钮
    //PrjItemPayGrid.btnPrintHide();  //隐藏打印按钮
	
	PrjItemPayGrid.load({params:{start:0,limit:15,prjcode:SubNo}})
	
	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({
				text : '关闭'
			});

	// 定义取消按钮的响应函数
	cancelHandler = function() {
		window.close();
	}
	
	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);
	// 初始化面板
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [PrjItemPayGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				//title : ethicaudittitle,
				plain : true,
				width : 800,
				height : 400,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
}