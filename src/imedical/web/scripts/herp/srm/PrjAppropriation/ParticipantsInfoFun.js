
ParticipantsInfoFun=function(Name,ParticipantsIDs){
	var Participantstitle = Name+"--参与人员";
	
	var ParticipantsInfo = new dhc.herp.Gridlyf({
				width : 400,
				region : 'center',
				url : 'herp.srm.horizonprjsetupexe.csp',
				fields : [{
							header : '人员ID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'name',
							header : '参与人员',
							dataIndex : 'name',
							width : 100
						},{
							id : 'isthehosrowid',
							header : '参与课题时身份',
							dataIndex : 'isthehosrowid',
							width : 60,
							hidden : true
						},{
							id : 'isthehos',
							header : '参与课题时身份',
							dataIndex : 'isthehos',
							//align:'right',
							width : 180
						},{
							id : 'rangerowid',
							header : '人员位次',
							dataIndex : 'rangerowid',
							width : 60,
							hidden : true
							
						},{
							id : 'range',
							header : '人员位次',
							dataIndex : 'range',
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
    
	ParticipantsInfo.load({params : {start : 0,limit : 25,ParticipantsIDs:ParticipantsIDs}});
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