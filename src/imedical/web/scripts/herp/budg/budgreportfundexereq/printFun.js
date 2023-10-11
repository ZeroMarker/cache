﻿
ShowPrintReportFun = function(startdate,enddate){



	var printReportPanel=new Ext.Panel({
			autoScroll:true,
			frame:true,
			html:'<iframe id="printReportFrame" height="100%" width="100%" src="../scripts/dhcmed/img/logon_bg2.jpg"/>'
	});



	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({ text : '关闭'});

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
				items : [printReportPanel]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : "一般支出资金执行情况统计打印",
				plain : true,
				width : 1000,
				height : 500,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
	
	var reportprintframe=document.getElementById("printReportFrame");					
	if( startdate !=""){startdate=startdate.format('Y-m-d');}
	if( enddate !=""){enddate=enddate.format('Y-m-d');}		
	var p_URL = 'dhccpmrunqianreport.csp?reportName=HERPBUDGBudgExeReqprint.raq&startdate='+startdate+'&enddate='+enddate; 
	
	reportprintframe.src=p_URL;
};