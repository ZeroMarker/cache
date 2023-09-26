
function InitViewPort()
{
	var obj = new Object();
	
	if (typeof InitReportEvent == 'function') obj = InitReportEvent(obj);     //��ʼ�������¼�
	
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
					obj = InitUC(obj);                      //���� �����
					arrTabItems = arrTabItems.concat([obj.UC_ViewPort]);
				}
				break;
				
			case "PICC" :
				if (typeof InitPICC == 'function') {
					obj = InitPICC(obj);                  //���� ���뵼��
					arrTabItems = arrTabItems.concat([obj.PICC_ViewPort]);
				}
				break;
				
			case "VAP" :
				if (typeof InitVAP == 'function') {
					obj = InitVAP(obj);                    //���� ������
					arrTabItems = arrTabItems.concat([obj.VAP_ViewPort]);
				}
				break;
				
			case "OPR" :
				if (typeof InitOPR == 'function') {
					obj = InitOPR(obj);                    //���� ����
					arrTabItems = arrTabItems.concat([obj.OPR_ViewPort]);
				}
				break;
				
			case "MDR" :
				if (typeof InitMDR == 'function')  {
					obj = InitMDR(obj);                    //���� ������ҩ
					arrTabItems = arrTabItems.concat([obj.MDR_ViewPort]);
				}
				break;
				
			case "NICU" :
				if (typeof InitNUC == 'function') {
					obj = InitNUC(obj);                    //���� NICU �꾲���ù�
					arrTabItems = arrTabItems.concat([obj.NUC_ViewPort]);
				}
				if (typeof InitNPICC == 'function') {
					obj = InitNPICC(obj);                //���� NICU ���뵼��
					arrTabItems = arrTabItems.concat([obj.NPICC_ViewPort]);
				}
				if (typeof InitNVNT == 'function') {
					obj = InitNVNT(obj);                  //���� NICU ������
					arrTabItems = arrTabItems.concat([obj.NVNT_ViewPort]);
				}
				if (typeof InitNOTH == 'function') {
					obj = InitNOTH(obj);                  //���� NICU ����
					arrTabItems = arrTabItems.concat([obj.NOTH_ViewPort]);
				}
				break;
			
			case "NUC" :
				if (typeof InitNUC == 'function') {
					obj = InitNUC(obj);                    //���� NICU �꾲���ù�
					arrTabItems = arrTabItems.concat([obj.NUC_ViewPort]);
				}
				break;
			
			case "NPICC" :
				if (typeof InitNPICC == 'function') {
					obj = InitNPICC(obj);                //���� NICU ���뵼��
					arrTabItems = arrTabItems.concat([obj.NPICC_ViewPort]);
				}
				break;
			
			case "NVNT" :
				if (typeof InitNVNT == 'function') {
					obj = InitNVNT(obj);                  //���� NICU ������
					arrTabItems = arrTabItems.concat([obj.NVNT_ViewPort]);
				}
				break;
			
			case "NOTH" :
				if (typeof InitNOTH == 'function') {
					obj = InitNOTH(obj);                  //���� NICU ����
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
				html: '<table border="0" width="100%" height="100%"><tr><td align="center" ><big><big><big><b>Ŀ���Լ����Ϣ</b></big></big></big></td></tr></table>'
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
	
	//ȡ�������ݶ���
	obj.Report_GetData = function(){
		//ȡҽԺ��Ⱦ��������
		return '';
	}
	
	//��ʼ������ҳ��
	obj.Report_InitView = function()
	{
		//ȡ��ǰ��������
		obj.CurrReportObject = obj.Report_GetData(0);
		
		//��ʼ����ģ��ҳ��
		if (typeof obj.UC_InitView == 'function') obj.UC_InitView();              //��ʾ �����
		if (typeof obj.PICC_InitView == 'function') obj.PICC_InitView();          //��ʾ ���뵼��
		if (typeof obj.VAP_InitView == 'function') obj.VAP_InitView();            //��ʾ ������
		if (typeof obj.OPR_InitView == 'function') obj.OPR_InitView();            //��ʾ ����
		if (typeof obj.MDR_InitView == 'function') obj.MDR_InitView();            //��ʾ ������ҩ
		
		if (typeof obj.NUC_InitView == 'function') obj.NUC_InitView();            //��ʾ NICU �꾲���ù�
		if (typeof obj.NPICC_InitView == 'function') obj.NPICC_InitView();        //��ʾ NICU ���뵼��
		if (typeof obj.NVNT_InitView == 'function') obj.NVNT_InitView();          //��ʾ NICU ������
		if (typeof obj.NOTH_InitView == 'function') obj.NOTH_InitView();          //��ʾ NICU ����
	}
	obj.Report_InitView();
	
	return obj;
}