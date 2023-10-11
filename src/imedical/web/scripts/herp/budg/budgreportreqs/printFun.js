
ShowPrintReportFun = function(year,itemType,itemLevel,budgAll,schemeMainDr){



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
				title : "全院收支预算查询",
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
	//alert(yearmonths+"^"+yearmonthe+"^"+type+"^"+itemcode+"^"+deptdr+"^"+isoverbudg+"^"+isoverbudg)		
	var p_URL = 'dhccpmrunqianreport.csp?reportName=HERPBUDGHosInOutBudgReqprint.raq&year='+year+'&itemType='+itemType+'&itemLevel='+itemLevel+'&budgAll='+budgAll+'&reportType='+'&dept=-1'+'&itemCode='+'&schemeMainDr='+schemeMainDr;
	
	reportprintframe.src=p_URL;
};