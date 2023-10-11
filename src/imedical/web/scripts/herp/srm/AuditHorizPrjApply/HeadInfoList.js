
 HeadInfoList = function(headdr){
	
	var HeadInfoGrid = new dhc.herp.Grid({
				title : "课题负责人信息",
				width : 400,
				region : 'center',                          
        url : 'herp.srm.srmprojectsapplyexe.csp',
				fields : [
              new Ext.grid.CheckboxSelectionModel({editable:false}),
           {
							id : 'MonographNum',
							header : '出版专著',
							dataIndex : 'MonographNum',
							width : 60,
							align : 'center',
							editable:false
						}, {
							id : 'PaperNum',
							header : '发表论文',
							dataIndex : 'PaperNum',
							width : 60,
							align : 'left',
							editable:false,
							hidden : false

						}, {
							id : 'PatentNum',
							header : '专利',
							dataIndex : 'PatentNum',
							width : 60,
              editable:false,
							align : 'center'
						}, {
							id : 'InvInCustomStanNum',
							header : '参与制定技术标准',
							dataIndex : 'InvInCustomStanNum',
							width : 60,
              editable:false,
							align : 'center'
						}, {
							id : 'TrainNum',
							header : '培养人才',
							dataIndex : 'TrainNum',
							width : 60,
              editable:false,
							align : 'center'
						}, {
							id : 'HoldTrainNum',
							header : '举办培训班',
							dataIndex : 'HoldTrainNum',
							width : 60,
              editable:false,
							align : 'center'
						}, {
							id : 'InTrainingNum',
							header : '参与培训班',
							dataIndex : 'InTrainingNum',
							width : 60,
              editable:false,
							align : 'center'
						}]    
			});
		HeadInfoGrid.btnAddHide();  //隐藏增加按钮
   	HeadInfoGrid.btnSaveHide();  //隐藏保存按钮
    HeadInfoGrid.btnResetHide();  //隐藏重置按钮
    HeadInfoGrid.btnDeleteHide(); //隐藏删除按钮
    HeadInfoGrid.btnPrintHide();  //隐藏打印按钮
    
	HeadInfoGrid.load({params:{start:0,limit:15,headdr:headdr}})
	
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
				items : [HeadInfoGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : '课题负责人信息',
				plain : true,
				width : 468,
				height : 300,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
}