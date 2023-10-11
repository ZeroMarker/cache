
 //ParticipantsInfoList = function(participantsdrs){
	
	var ParticipantsInfoGrid = new dhc.herp.Grid({
				//title : "课题参与人员信息列表",
				//iconCls: 'list',
				width : 400,
				region : 'center',                          
				url : 'herp.srm.horizonprjsetupexe.csp',
				fields : [
              new Ext.grid.CheckboxSelectionModel({editable:false}),
           {
							id : 'Name',
							header : '姓名',
							dataIndex : 'Name',
							width : 100,
							align : 'left',
							editable:false
						}, {
							id : 'CreditID',
							header : '身份证号',
							dataIndex : 'CreditID',
							width : 150,
							align : 'left',
							editable:false,
							hidden : false

						}, {
							id : 'BirthDay',
							header : '出生日期',
							dataIndex : 'BirthDay',
							width : 100,
							editable:false,
							align : 'left'
						}, {
							id : 'Sex',
							header : '性别',
							dataIndex : 'Sex',
							width : 80,
							editable:false,
							align : 'left'
						}, {
							id : 'TitleInfo',
							header : '职称',
							dataIndex : 'TitleInfo',
							width : 100,
							editable:false,
							align : 'left'
						}, {
							id : 'Degree',
							header : '学位',
							dataIndex : 'Degree',
							width : 100,
							editable:false,
							align : 'left'
						}, {
							id : 'Dept',
							header : '从事专业',
							dataIndex : 'Dept',
							width : 180,
							editable:false,
							align : 'left'
						}, {
							id : 'Comp',
							header : '单位名称',
							dataIndex : 'Comp',
							width : 180,
							editable:false,
							align : 'left'
						}, {
							id : 'Tel',
							header : '电话',
							dataIndex : 'Tel',
							width : 100,
							editable:false,
							align : 'left'
						}, {
							id : 'Email',
							header : '电子邮箱',
							dataIndex : 'Email',
							width : 180,
							editable:false,
							align : 'left'
						}]    
			});
	ParticipantsInfoGrid.btnAddHide();  //隐藏增加按钮
   	ParticipantsInfoGrid.btnSaveHide();  //隐藏保存按钮
    ParticipantsInfoGrid.btnResetHide();  //隐藏重置按钮
    ParticipantsInfoGrid.btnDeleteHide(); //隐藏删除按钮
    ParticipantsInfoGrid.btnPrintHide();  //隐藏打印按钮
    
	//ParticipantsInfoGrid.load({params:{start:0,limit:15,participantsdrs:participantsdrs}})
	
	// 初始化取消按钮
	/**
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
				items : [ParticipantsInfoGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : '课题参与人员信息',
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
**/