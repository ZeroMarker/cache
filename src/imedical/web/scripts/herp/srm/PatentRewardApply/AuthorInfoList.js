
 AuthorInfoList = function(title,authorinfo){
	var title=title+'--发明者位次信息';
	var AuthorInfoGrid = new dhc.herp.GridAuthor({
				//title : "发明者位次信息列表",
				width : 400,
				region : 'center',                          
        url : 'herp.srm.srmpatentrewardapplyexe.csp',
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
							id : 'name',
							header : '发明人名称',
							dataIndex : 'name',
							width : 100,
							align : 'left',
							editable:false,
							hidden : false

						}, {
							id : 'range',
							header : '发明人位次',
							dataIndex : 'range',
							width : 100,
              editable:false,
							align : 'left'
						}, {
							id : 'isthehos',
							header : '是否本院',
							dataIndex : 'isthehos',
							width : 80,
              editable:false,
							align : 'left'
						}]    
			});
		AuthorInfoGrid.btnAddHide();  //隐藏增加按钮
   	AuthorInfoGrid.btnSaveHide();  //隐藏保存按钮
    AuthorInfoGrid.btnResetHide();  //隐藏重置按钮
    AuthorInfoGrid.btnDeleteHide(); //隐藏删除按钮
    AuthorInfoGrid.btnPrintHide();  //隐藏打印按钮
    
	AuthorInfoGrid.load({params:{start:0,limit:15,IDs:authorinfo}})
	
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
				items : [AuthorInfoGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : title,
				iconCls: 'popup_list',
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