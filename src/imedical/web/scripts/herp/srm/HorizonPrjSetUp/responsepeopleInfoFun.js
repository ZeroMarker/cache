
responsepeopleInfoFun=function(Name,HeadDR){
	var Participantstitle = Name+"--项目负责人";
	
	var ParticipantsInfo = new dhc.herp.Gridres({
				width : 500,
				region : 'center',
				autoScroll:true,
				url : 'herp.srm.horizonprjsetupexe.csp',
				fields : [{
							header : '人员编码',
							width : 100,
							editable:false,
							dataIndex : 'code',
							hidden : false
						},{
							id : 'name',
							header : '姓名',
							dataIndex : 'name',
							width : 100
						},{
							id : 'ID',
							header : '身份证号',
							dataIndex : 'ID',
							width : 150
						},{
							id : 'sex',
							header : '性别',
							dataIndex : 'sex',
							width : 80,
							hidden : false
						},{
							id : 'DeptName',
							header : '科室',
							dataIndex : 'DeptName',
							width : 180
						},{
							id : 'TitleDr',
							header : '技术职称',
							dataIndex : 'TitleDr',
							//align:'right',
							width : 100
						},{
							id : 'Phone',
							header : '联系电话',
							dataIndex : 'Phone',
							width : 100,
							hidden : false
							
						},{
							id : 'EMail',
							header : '邮箱',
							dataIndex : 'EMail',
							//align:'right',
							hidden:true,
							width : 80
						},{
							id : 'Degree',
							header : '学位',
							dataIndex : 'Degree',
							//align:'right',
							width : 100
						}
						]
						//viewConfig : {forceFit : true}
						//tbar : [Name,'-','参与人员']	
	});

	ParticipantsInfo.btnAddHide();  //隐藏增加按钮
   	ParticipantsInfo.btnSaveHide();  //隐藏保存按钮
    ParticipantsInfo.btnResetHide();  //隐藏重置按钮
    ParticipantsInfo.btnDeleteHide(); //隐藏删除按钮
    ParticipantsInfo.btnPrintHide();  //隐藏打印按钮
    
	ParticipantsInfo.load({params : {start : 0,limit : 25,HeadDR:HeadDR}});
	//alert(ParticipantsIDs);
	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({ text : '关闭',iconCls : 'cancel'});
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
				items : [ParticipantsInfo]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : Participantstitle,
				iconCls: 'popup_list',
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