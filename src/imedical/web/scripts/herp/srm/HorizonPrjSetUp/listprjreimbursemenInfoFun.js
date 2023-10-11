
listprjreimbursemenInfoFun=function(Name,ProjectDR){
	var Participantstitle = Name+"--经费信息";
	
	var ParticipantsInfo = new dhc.herp.Gridprs({
				width : 400,
				region : 'center',
				url : 'herp.srm.horizonprjsetupexe.csp',
				fields : [{
							header : '预算总额(万元)',
							width : 120,
							editable:false,
							dataIndex : 'BudgTotal',
							align : 'right',
							hidden : false,
							renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
						},{
							id : 'ActPayWait',
							header : '累计在途报销金额(万元)',
							dataIndex : 'ActPayWait',
							align : 'right',
							width : 150,
							renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
						},{
							id : 'ActPay',
							header : '累计已执行报销金额(万元)',
							dataIndex : 'ActPay',
							align : 'right',
							width : 180,
							renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
						}
						]
						//viewConfig : {forceFit : true}
						
	});

	ParticipantsInfo.btnAddHide();  //隐藏增加按钮
   	ParticipantsInfo.btnSaveHide();  //隐藏保存按钮
    ParticipantsInfo.btnResetHide();  //隐藏重置按钮
    ParticipantsInfo.btnDeleteHide(); //隐藏删除按钮
    ParticipantsInfo.btnPrintHide();  //隐藏打印按钮
    
	ParticipantsInfo.load({params : {start : 0,limit : 25,ProjectDR:ProjectDR}});
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