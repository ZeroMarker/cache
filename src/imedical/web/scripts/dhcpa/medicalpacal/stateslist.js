
StatesDetail = function(title,schemmainrowid){
	//alert(schemmainrowid);
var stateGrid = new dhc.herp.stateGrid({
            region : 'center',
		    url: 'dhc.pa.basicuintpacaluexe.csp',
			fields : [
			       new Ext.grid.CheckboxSelectionModel({hidden : true,editable:false}),
			       {
						header : '方案ID',
						dataIndex : 'periodchkrowid',
						editable:false,
						hidden : true
					}, {
						id : 'chkresult',
						header : '审批状态',
						width : 100,
						editable:false,
						dataIndex : 'chkresult'

					},{
						id : 'chercker',
						header : '审批人',
						editable:false,
						width : 80,
						dataIndex : 'chercker'

					},{
						id : 'cherckdate',
						header : '审批时间',
						editable:false,
						width : 80,
						dataIndex : 'cherckdate'

					},{
						id : 'chkdeptname',
						header : '科室',
						editable:false,
						width : 100,
						dataIndex : 'chkdeptname'

					}, {
						id : 'desc',
						header : '审批意见',
						editable:false,
						width : 200,
						dataIndex : 'desc'

					}],

						split : true,
						collapsible : true,
						containerScroll : true,
						xtype : 'grid',
						trackMouseOver : true,
						stripeRows : true,
						sm : new Ext.grid.RowSelectionModel({
									singleSelect : true
								}),
						loadMask : true,
						height:300,
						trackMouseOver: true,
						stripeRows: true
		});

    stateGrid.btnAddHide();  //隐藏增加按钮
   	stateGrid.btnSaveHide();  //隐藏保存按钮
    stateGrid.btnResetHide();  //隐藏重置按钮
    stateGrid.btnDeleteHide(); //隐藏删除按钮
    stateGrid.btnPrintHide();  //隐藏打印按钮
	
	stateGrid.load({params:{start:0,limit:15,schemrowid:schemmainrowid}})
	
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
				items : [stateGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : title+'--',
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
