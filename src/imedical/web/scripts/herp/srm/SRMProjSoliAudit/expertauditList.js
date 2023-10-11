
 ExpertAuditList = function(rowid,title,subuser){
	var ExpertAuditGrid = new dhc.herp.GridExpert({
				//title : "作者排名信息",
				width : 400,
				region : 'center',                          
				url : 'herp.srm.srmprosoliauditexe.csp',
				fields : [
						{
							id : 'rowid',
							header : 'rowid',
							dataIndex : 'rowid',
							width : 60,
							hidden:true,
							align : 'center',
							editable:false
						}, {
							id : 'ExpertName',
							header : '专家',
							dataIndex : 'ExpertName',
							width : 80,
							align : 'left',
							editable:false,
							hidden : false

						}, {
							id : 'datastatus',
							header : '是否已提交至科教处',
							dataIndex : 'datastatus',
							width : 80,
							editable:false,
							align : 'left'
						},{
							id : 'sumscore',
							header : '总分',
							dataIndex : 'sumscore',
							width : 80,
							editable:false,
							align : 'right'
						},{
							id : 'Index1score',
							header : '目的明确性',
							dataIndex : 'Index1score',
							width : 80,
							editable:false,
							align : 'right'
						},{
							id : 'Index2score',
							header : '文献掌握程度',
							dataIndex : 'Index2score',
							width : 80,
							editable:false,
							align : 'right'
						},{
							id : 'Index3score',
							header : '设计科学性',
							dataIndex : 'Index3score',
							width : 80,
							editable:false,
							align : 'right'
						},{
							id : 'Index4score',
							header : '课题创新性',
							dataIndex : 'Index4score',
							width : 80,
							editable:false,
							align : 'right'
						},{
							id : 'Index5score',
							header : '理论可行性',
							dataIndex : 'Index5score',
							width : 80,
							editable:false,
							align : 'right'
						},{
							id : 'Index6score',
							header : '技术可行性',
							dataIndex : 'Index6score',
							width : 80,
							editable:false,
							align : 'right'
						},{
							id : 'Index7score',
							header : '人员可行性',
							dataIndex : 'Index7score',
							width : 80,
							editable:false,
							align : 'right'
						},{
							id : 'Index8score',
							header : '外部条件可行性',
							dataIndex : 'Index8score',
							width : 80,
							editable:false,
							align : 'right'
						},{
							id : 'Index9score',
							header : '预算合理性',
							dataIndex : 'Index9score',
							width : 80,
							editable:false,
							align : 'right'
						},{
							id : 'Index10score',
							header : '课题逻辑清晰度',
							dataIndex : 'Index10score',
							width : 80,
							editable:false,
							align : 'right'
						},{
							id : 'Index11score',
							header : '课题完成预期',
							dataIndex : 'Index11score',
							width : 80,
							editable:false,
							align : 'right'
						},{
							id : 'Index12score',
							header : '前期工作基础',
							dataIndex : 'Index12score',
							width : 80,
							editable:false,
							align : 'right'
						}]    
			});
	ExpertAuditGrid.btnAddHide();  //隐藏增加按钮
   	ExpertAuditGrid.btnSaveHide();  //隐藏保存按钮
    ExpertAuditGrid.btnResetHide();  //隐藏重置按钮
    ExpertAuditGrid.btnDeleteHide(); //隐藏删除按钮
    ExpertAuditGrid.btnPrintHide();  //隐藏打印按钮
    
	ExpertAuditGrid.load({params:{start:0,limit:15,rowid:rowid}})
	
	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({
				text : '关闭',
				iconCls : 'cancel'
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
				items : [ExpertAuditGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : subuser+"--"+title,
				iconCls : 'popup_list',
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