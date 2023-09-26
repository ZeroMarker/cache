
function InitViewPort()
{
	var obj = new Object();
	
	if (typeof InitReportEvent == 'function') obj = InitReportEvent(obj);     //初始化报告事件
	
	obj.CurrReport = new Object();
	if (!ModuleList) {
		ModuleList = obj.GetModuleList(TransLoc);
	}
	var arrRepType = ModuleList.split('^');
	for (var indType = 0; indType < arrRepType.length; indType++)
	{
		var tmpReport = new Object();
		tmpReport.RowID    = '';
		tmpReport.ReportTypeCode = arrRepType[indType];
		tmpReport.EpisodeID   = EpisodeID;
		tmpReport.TransID     = TransID;
		tmpReport.TransLoc    = TransLoc;
		tmpReport.BornWeight  = '';
		switch (arrRepType[indType]) {
			case "UC" :
				obj.CurrReport.ChildUC = tmpReport;
				break;
			case "PICC" :
				obj.CurrReport.ChildPICC = tmpReport;
				break;
			case "VAP" :
				obj.CurrReport.ChildVAP = tmpReport;
				break;
			case "OPR" :
				obj.CurrReport.ChildOPR = tmpReport;
				break;
			case "MDR" :
				obj.CurrReport.ChildMDR = tmpReport;
				break;
			case "NICU" :
				obj.CurrReport.ChildNICU = tmpReport;
				break;
			default :
				break;
		}
	}
	
	var arrReport = ReportList.split(",");
	for (indRep = 0; indRep <= arrReport.length; indRep++)
	{
		var objAimReport = obj.ClsAimReport.GetObjById(arrReport[indRep]);
		if (objAimReport) {
			objAimReport.ReportTypeCode = '';
			var objDictionary = obj.ClsSSDictionary.GetObjById(objAimReport.ReportType);
			if (objDictionary) {
				objAimReport.ReportTypeCode = objDictionary.Code;
			}
			switch (objAimReport.ReportTypeCode) {
				case "UC" :
					obj.CurrReport.ChildUC = objAimReport;
					break;
				case "PICC" :
					obj.CurrReport.ChildPICC = objAimReport;
					break;
				case "VAP" :
					obj.CurrReport.ChildVAP = objAimReport;
					break;
				case "OPR" :
					obj.CurrReport.ChildOPR = objAimReport;
					break;
				case "MDR" :
					obj.CurrReport.ChildMDR = objAimReport;
					break;
				case "NICU" :
					obj.CurrReport.ChildNICU = objAimReport;
					break;
				default :
					break;
			}
		}
	}
	
	var arrTabItems = [];
	var arrModule = ModuleList.split("^");
	for (var indModule = 0; indModule < arrModule.length; indModule++) {
		var strModule = arrModule[indModule];
		switch (strModule) {
			case "UC" :
				if (typeof InitUC == 'function') {
					obj = InitUC(obj);                      //加载 导尿管
					arrTabItems = arrTabItems.concat([obj.UC_ViewPort]);
				}
				break;
				
			case "PICC" :
				if (typeof InitPICC == 'function') {
					obj = InitPICC(obj);                  //加载 中央导管
					arrTabItems = arrTabItems.concat([obj.PICC_ViewPort]);
				}
				break;
				
			case "VAP" :
				if (typeof InitVAP == 'function') {
					obj = InitVAP(obj);                    //加载 呼吸机
					arrTabItems = arrTabItems.concat([obj.VAP_ViewPort]);
				}
				break;
				
			case "OPR" :
				if (typeof InitOPR == 'function') {
					obj = InitOPR(obj);                    //加载 手术
					arrTabItems = arrTabItems.concat([obj.OPR_ViewPort]);
				}
				break;
				
			case "MDR" :
				if (typeof InitMDR == 'function')  {
					obj = InitMDR(obj);                    //加载 多重耐药
					arrTabItems = arrTabItems.concat([obj.MDR_ViewPort]);
				}
				break;
				
			case "NICU" :
				if (typeof InitNUC == 'function') {
					obj = InitNUC(obj);                    //加载 NICU 脐静脉置管
					arrTabItems = arrTabItems.concat([obj.NUC_ViewPort]);
				}
				if (typeof InitNPICC == 'function') {
					obj = InitNPICC(obj);                //加载 NICU 中央导管
					arrTabItems = arrTabItems.concat([obj.NPICC_ViewPort]);
				}
				if (typeof InitNVNT == 'function') {
					obj = InitNVNT(obj);                  //加载 NICU 呼吸机
					arrTabItems = arrTabItems.concat([obj.NVNT_ViewPort]);
				}
				if (typeof InitNOTH == 'function') {
					obj = InitNOTH(obj);                  //加载 NICU 其他
					arrTabItems = arrTabItems.concat([obj.NOTH_ViewPort]);
				}
				break;
			
			case "NUC" :
				if (typeof InitNUC == 'function') {
					obj = InitNUC(obj);                    //加载 NICU 脐静脉置管
					arrTabItems = arrTabItems.concat([obj.NUC_ViewPort]);
				}
				break;
			
			case "NPICC" :
				if (typeof InitNPICC == 'function') {
					obj = InitNPICC(obj);                //加载 NICU 中央导管
					arrTabItems = arrTabItems.concat([obj.NPICC_ViewPort]);
				}
				break;
			
			case "NVNT" :
				if (typeof InitNVNT == 'function') {
					obj = InitNVNT(obj);                  //加载 NICU 呼吸机
					arrTabItems = arrTabItems.concat([obj.NVNT_ViewPort]);
				}
				break;
			
			case "NOTH" :
				if (typeof InitNOTH == 'function') {
					obj = InitNOTH(obj);                  //加载 NICU 其他
					arrTabItems = arrTabItems.concat([obj.NOTH_ViewPort]);
				}
				break;
			
			default :
				break;
		}
	}
	
	obj.ViewLayout = {
		layout : 'border',
		frame : true,
		items : [
			{
				region: 'north',
				layout : 'fit',
				height : 30,
				html: '<table border="0" width="100%" height="100%"><tr><td align="center" ><big><big><big><b>目标性监测信息</b></big></big></big></td></tr></table>'
			},
			{
				region: 'center',
				layout : 'fit',
				items : [
					new Ext.TabPanel({
						//resizeTabs: true,
						//minTabWidth: 100,
						enableTabScroll: true,
						activeTab: 0,
						frame:true,
						items : arrTabItems
					})
				]
			}
		]
	}
	
	obj.ViewPort = new Ext.Viewport({
		id : 'ViewPort',
		layout : 'fit',
		items :[
			obj.ViewLayout
		]
	});
	
	//取报告数据对象
	obj.Report_GetData = function(){
		//取医院感染报告数据
		return '';
	}
	
	//初始化报告页面
	obj.Report_InitView = function()
	{
		//取当前报告数据
		obj.CurrReportObject = obj.Report_GetData(0);
		
		//初始化各模块页面
		if (typeof obj.UC_InitView == 'function') obj.UC_InitView();              //显示 导尿管
		if (typeof obj.PICC_InitView == 'function') obj.PICC_InitView();          //显示 中央导管
		if (typeof obj.VAP_InitView == 'function') obj.VAP_InitView();            //显示 呼吸机
		if (typeof obj.OPR_InitView == 'function') obj.OPR_InitView();            //显示 手术
		if (typeof obj.MDR_InitView == 'function') obj.MDR_InitView();            //显示 多重耐药
		
		if (typeof obj.NUC_InitView == 'function') obj.NUC_InitView();            //显示 NICU 脐静脉置管
		if (typeof obj.NPICC_InitView == 'function') obj.NPICC_InitView();        //显示 NICU 中央导管
		if (typeof obj.NVNT_InitView == 'function') obj.NVNT_InitView();          //显示 NICU 呼吸机
		if (typeof obj.NOTH_InitView == 'function') obj.NOTH_InitView();          //显示 NICU 其他
	}
	obj.Report_InitView();
	
	return obj;
}