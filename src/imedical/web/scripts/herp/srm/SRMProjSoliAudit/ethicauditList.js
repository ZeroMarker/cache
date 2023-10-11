
 EthicAuditList = function(rowid,title,subuser){
  
  var ethicaudittitle=title+'--'+subuser;
	var EthicAuditGrid = new dhc.herp.GridEthic({
				//title : "作者排名信息",
				width : 400,
				region : 'center',                          
				url : 'herp.srm.srmprosoliauditexe.csp',
				fields : [
              //new Ext.grid.CheckboxSelectionModel({editable:false}),
           {
							id : 'rowid',
							header : 'rowid',
							dataIndex : 'rowid',
							width : 60,
							hidden:true,
							align : 'center',
							editable:false
						}, {
							id : 'EthicExpert',
							header : '伦理专家',
							dataIndex : 'EthicExpert',
							width : 120,
							align : 'left',
							editable:false,
							hidden : false

						}, {
							id : 'datastatus',
							header : '是否已提交至科教处',
							dataIndex : 'datastatus',
							width : 120,
							editable:false,
							align : 'left'
						},{
							id : 'EthicChkResult',
							header : '伦理审核结果',
							dataIndex : 'EthicChkResult',
							width : 120,
							editable:false,
							align : 'left'
						},{
							id : 'EthicAuditDate',
							header : '伦理审核时间',
							dataIndex : 'EthicAuditDate',
							width : 120,
							editable:false,
							align : 'left'
						},{
							id : 'EthicAuditDesc',
							header : '伦理审核意见',
							dataIndex : 'EthicAuditDesc',
							width : 120,
							editable:false,
							align : 'left'
						}]    
			});
		EthicAuditGrid.btnAddHide();  //隐藏增加按钮
   	EthicAuditGrid.btnSaveHide();  //隐藏保存按钮
    EthicAuditGrid.btnResetHide();  //隐藏重置按钮
    EthicAuditGrid.btnDeleteHide(); //隐藏删除按钮
    EthicAuditGrid.btnPrintHide();  //隐藏打印按钮
    
	EthicAuditGrid.load({params:{start:0,limit:15,rowid:rowid}})
	
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
				items : [EthicAuditGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : ethicaudittitle,
				plain : true,
				width : 500,
				height : 400,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
}