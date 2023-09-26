function InitClinRepToAdmEvent(obj){
	obj.LoadEvent = function(args)
	{
		obj.CurrTypeIndex = -1;
		obj.btnRepType_OnClick(-1);
  	};
	
	//�������͵����¼�
	obj.btnRepType_OnClick = function(aTypeIndex)
	{
		obj.CurrTypeIndex = aTypeIndex;
		obj.LoadReportData(aTypeIndex);
		
		var TDIndex = aTypeIndex*1+1;
		for (var tmpIndex = 0; tmpIndex <= obj.RepTypeList.length; tmpIndex++){
			if (tmpIndex == TDIndex){
				var objTD = document.getElementById("tdRepType" + tmpIndex);
				if (objTD) {
					objTD.style.backgroundColor="#4499EE";
					objTD.style.color="#FFFFFF";
				}
			} else {
				var objTD = document.getElementById("tdRepType" + tmpIndex);
				if (objTD) {
					objTD.style.backgroundColor="#FFFFFF";
					objTD.style.color="#4499EE";
				}
			}
		}
		
		setTimeout('objScreen.ViewReportData(' + aTypeIndex + ')',500);
	}
	
	//��ʾ������Ϣ
	obj.ViewReportData = function(aTypeIndex)
	{
		if (aTypeIndex == -1) {
			obj.RepXTemplate.overwrite("RepXTemplateDIV", obj.RepTypeList);
		} else {
			//obj.RepXTemplate.overwrite("RepXTemplateDIV", [obj.RepTypeList[aTypeIndex]]);
			obj.RepXTemplate.overwrite("RepXTemplateDIV", obj.RepTypeList[aTypeIndex]);
		}
		//���û�����ϢX�������λ��
		setTimeout('objScreen.setBaseInfoScrollLeft("divInfCtlResult")',500);
	}
	
	//���ر�������
	obj.LoadReportData = function(aTypeIndex)
	{
		for (var indRepType = 0; indRepType < obj.RepTypeList.length; indRepType++) {
			if ((aTypeIndex != -1)&&(aTypeIndex != indRepType)) continue;
			
			var objRepType = obj.RepTypeList[indRepType];
			
			if ((objRepType.TypeCate == 'EPD')&&(objRepType.TypeCode == '2')) {
				obj.LoadEPD2Data(indRepType,'ErrXTemplateDIV');
			}
			
			//ҽԺ��Ⱦ����V3.0
			if ((objRepType.TypeCate == 'INF')&&(objRepType.TypeCode == '3')) {
				obj.LoadINF3Data(indRepType,'ErrXTemplateDIV');
			}
			
			//ҽԺ��Ⱦ����V4.0
			if ((objRepType.TypeCate == 'HAI')&&(objRepType.TypeCode == '1')) {
				obj.LoadHAIData(indRepType,'ErrXTemplateDIV');
			}
			
			if ((objRepType.TypeCate == 'DTH')&&(objRepType.TypeCode == '2')) {
				obj.LoadDTH2Data(indRepType,'ErrXTemplateDIV');
			}
			
			if (objRepType.TypeCate == 'CRF') {
				obj.LoadCRFData(indRepType,'ErrXTemplateDIV');
			}
			
			if ((objRepType.TypeCate == 'FBD')&&(objRepType.TypeCode == '1')) {
				obj.LoadFBD1Data(indRepType,'ErrXTemplateDIV');
			}
			
			//Add By LiYang 2014-12-20 �������ؾ��񼲻�����ҳ��
			if (objRepType.TypeCate == 'SMD') {
				obj.LoadSMDData(indRepType,'ErrXTemplateDIV',objRepType.TypeCode);
			}
			
			//Add By jiangpengpeng 2015-09-01 ������������ҳ��
			if (objRepType.TypeCate == 'CD') {
				obj.LoadCDData(indRepType,'ErrXTemplateDIV',objRepType.TypeCode);
			}

			//�������⻼��ҳ��
			if (objRepType.TypeCate == 'SPE') {
				obj.LoadSPEData(indRepType,'ErrXTemplateDIV',objRepType.TypeCode);
			}
		}
	}
	
	/*
	//���ش�Ⱦ������ڶ������
	obj.LoadEPD2Data = function(indType,errDiv)
	{
		obj.RepTypeList[indType].ReportList.length = 0;
		obj.RepTypeList[indType].ReportCount = 0;
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCMed.EPDService.EpidemicSrv',
				QueryName : 'QryByPapmi',
				Arg1 : PatientID,
				ArgCnt : 1
			},
			success: function(response, opts) {
				var objData = Ext.decode(response.responseText);
				var objRepType = obj.RepTypeList[indType];
				var objItem = null;
				for(var i = 0; i < objData.total; i ++)
				{
					objItem = objData.record[i];
					if (!objItem) continue;
					
					var ind = objRepType.ReportList.length;
					objRepType.ReportList[ind] = objItem;
					objRepType.ReportCount++;
				}
				obj.RepTypeList[indType] = objRepType;
			},
			failure: function(response, opts) {
				var objTargetElement = document.getElementById(errDiv);
				if (objTargetElement) {
					objTargetElement.innerHTML = response.responseText;
				}
			}
		});
	}
	
	//����ҽԺ��Ⱦ������������
	obj.LoadINF3Data = function(indType)
	{
		obj.RepTypeList[indType].ReportList.length = 0;
		obj.RepTypeList[indType].ReportCount = 0;
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCMed.NINFService.Rep.InfReport',
				QueryName : 'QryReportByAdm',
				Arg1 : EpisodeID,
				Arg2 : '',
				ArgCnt : 2
			},
			success: function(response, opts) {
				var objData = Ext.decode(response.responseText);
				
				var objRepType = obj.RepTypeList[indType];
				var objItem = null;
				for(var i = 0; i < objData.total; i ++)
				{
					objItem = objData.record[i];
					if (!objItem) continue;
					
					var ind = objRepType.ReportList.length;
					objRepType.ReportList[ind] = objItem;
					objRepType.ReportCount++;
				}
				obj.RepTypeList[indType] = objRepType;
			},
			failure: function(response, opts) {
				var objTargetElement = document.getElementById(errDiv);
				if (objTargetElement) {
					objTargetElement.innerHTML = response.responseText;
				}
			}
		});
		
		obj.RepTypeList[indType].InfCasesList = new Array();
		obj.RepTypeList[indType].InfCasesCount = 0;
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCMed.NINFService.BC.CasesSrv',
				QueryName : 'QryHandleDtl',
				Arg1 : SubjectCode,
				Arg2 : EpisodeID,
				ArgCnt : 2
			},
			success: function(response, opts) {
				var objData = Ext.decode(response.responseText);
				
				var objRepType = obj.RepTypeList[indType];
				var objItem = null;
				for(var i = 0; i < objData.total; i ++)
				{
					objItem = objData.record[i];
					if (!objItem) continue;
					
					var ind = objRepType.InfCasesList.length;
					objRepType.InfCasesList[ind] = objItem;
					objRepType.InfCasesCount++;
				}
				obj.RepTypeList[indType] = objRepType;
			},
			failure: function(response, opts) {
				var objTargetElement = document.getElementById(errDiv);
				if (objTargetElement) {
					objTargetElement.innerHTML = response.responseText;
				}
			}
		});
		
		return;	//add by zf 2014-09-02
		var strDateList = ExtTool.RunServerMethod("DHCMed.NINFService.BC.CasesXSrv", "GetCtlDateList", SubjectCode, EpisodeID);
		if (!strDateList) return;
		var arrDateList = strDateList.split(',');
		obj.RepTypeList[indType].CtlDateList = arrDateList;
		obj.RepTypeList[indType].CtlDateListI = new Array();
		obj.RepTypeList[indType].CtlRstList = new Array();
		obj.RepTypeList[indType].CtlRstListI = new Array();
		for (var indDate = 0; indDate < arrDateList.length; indDate++) {
			var tmpDate = arrDateList[indDate];
			obj.RepTypeList[indType].CtlDateListI[tmpDate] = indDate;
		}
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCMed.NINFService.BC.CasesXSrv',
				QueryName : 'QryCtlResult',
				Arg1 : SubjectCode,
				Arg2 : EpisodeID,
				ArgCnt : 2
			},
			success: function(response, opts) {
				var objData = Ext.decode(response.responseText);
				
				var objInfCtlRst = obj.RepTypeList[indType];
				var objItem = null;
				for(var i = 0; i < objData.total; i ++)
				{
					objItem = objData.record[i];
					if (!objItem) continue;
					if (typeof(objInfCtlRst.CtlDateListI[objItem.OccurDate]) == 'undefined') continue;
					
					var ItemCat = objItem.ItemCatID;
					var ItemSubCat = objItem.SubCatID;
					var indexItemCat = ItemCat + '-' + ItemSubCat;
					
					if (typeof(objInfCtlRst.CtlRstListI[indexItemCat]) != 'undefined') {
						var ind = objInfCtlRst.CtlRstListI[indexItemCat];
						var objSubCat = objInfCtlRst.CtlRstList[ind];
						if (typeof(objSubCat.ItemDateList[objItem.OccurDate]) != 'undefined') {
						} else {
							objSubCat.ItemDateList[objItem.OccurDate] = {
								ItemDate : objItem.OccurDate,
								ItemList : new Array
							}
						}
					} else {
						var objSubCat = {
							ItemCatID : objItem.ItemCatID,
							ItemCat : objItem.ItemCatDesc,
							ItemSubCatID : objItem.SubCatID,
							ItemSubCat : objItem.SubCatDesc,
							ItemDateList : new Array()
						}
						objSubCat.ItemDateList[objItem.OccurDate] = {
							ItemDate : objItem.OccurDate,
							ItemList : new Array
						}
						var ind = objInfCtlRst.CtlRstList.length;
						objInfCtlRst.CtlRstListI[indexItemCat] = ind;
						objInfCtlRst.CtlRstList[ind] = objSubCat;
					}
					var ind = objSubCat.ItemDateList[objItem.OccurDate].ItemList.length;
					objSubCat.ItemDateList[objItem.OccurDate].ItemList[ind] = objItem;
					var ind = objInfCtlRst.CtlRstListI[indexItemCat];
					objSubCat.CtlDateList = new Array();
					objSubCat.CtlDateList = objInfCtlRst.CtlDateList;
					objInfCtlRst.CtlRstList[ind] = objSubCat;
				}
				obj.RepTypeList[indType] = objInfCtlRst;
			},
			failure: function(response, opts) {
				var objTargetElement = document.getElementById(errDiv);
				if (objTargetElement) {
					objTargetElement.innerHTML = response.responseText;
				}
			}
		});
	}
	
	obj.setBaseInfoScrollLeft = function(aCmpId)
	{
		var XTable = document.getElementById(aCmpId + '-x-table');
		var Table = document.getElementById(aCmpId + '-table');
		var XScroll = document.getElementById(aCmpId + '-x-scroll');
		var Scroll = document.getElementById(aCmpId + '-scroll');
		if ((!XTable)||(!Table)||(!XScroll)||(!Scroll)) return;
		
		XTable.style.width = ((Table.width + 20)/100) + "px";
		XScroll.scrollLeft = XScroll.scrollWidth;
		Scroll.scrollLeft = Scroll.scrollWidth;
		
		XScroll.onscroll = function (e) {
			Scroll.scrollLeft = XScroll.scrollLeft;
		}
	}
	
	//��������֤������ڶ�������
	obj.LoadDTH2Data = function(indType)
	{
		obj.RepTypeList[indType].ReportList.length = 0;
		obj.RepTypeList[indType].ReportCount = 0;
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCMed.DTHService.ReportSrv',
				QueryName : 'QryReportByPatientID',
				Arg1 : PatientID,
				ArgCnt : 1
			},
			success: function(response, opts) {
				var objData = Ext.decode(response.responseText);
				var objRepType = obj.RepTypeList[indType];
				var objItem = null;
				for(var i = 0; i < objData.total; i ++)
				{
					objItem = objData.record[i];
					if (!objItem) continue;
					
					var ind = objRepType.ReportList.length;
					objRepType.ReportList[ind] = objItem;
					objRepType.ReportCount++;
				}
				obj.RepTypeList[indType] = objRepType;
			},
			failure: function(response, opts) {
				var objTargetElement = document.getElementById(errDiv);
				if (objTargetElement) {
					objTargetElement.innerHTML = response.responseText;
				}
			}
		});
	}
	
	//�����Զ��������
	obj.LoadCRFData = function(indType)
	{
		obj.RepTypeList[indType].ReportList.length = 0;
		obj.RepTypeList[indType].ReportCount = 0;
		var strTmp = ExtTool.RunServerMethod("DHCMed.CR.PO.Form", "GetStringById",obj.RepTypeList[indType].TypeCode);
		if (!strTmp) return;
		var arrTmp = strTmp.split('^');
		var FormEName = arrTmp[2];
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCMed.CR.BO.FormQry',
				QueryName : 'QryByPatientID',
				Arg1 : PatientID,
				Arg2 : FormEName,
				ArgCnt : 2
			},
			success: function(response, opts) {
				var objData = Ext.decode(response.responseText);
				
				var objRepType = obj.RepTypeList[indType];
				var objItem = null;
				for(var i = 0; i < objData.total; i ++)
				{
					objItem = objData.record[i];
					if (!objItem) continue;
					
					var ind = objRepType.ReportList.length;
					objRepType.ReportList[ind] = objItem;
					objRepType.ReportCount++;
				}
				obj.RepTypeList[indType] = objRepType;
			},
			failure: function(response, opts) {
				var objTargetElement = document.getElementById(errDiv);
				if (objTargetElement) {
					objTargetElement.innerHTML = response.responseText;
				}
			}
		});
	}
	
	// ����ʳԴ�Լ�������
	obj.LoadFBD1Data = function(indType,errDiv) {
		obj.RepTypeList[indType].ReportList.length = 0;
		obj.RepTypeList[indType].ReportCount = 0;
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params : {
				ClassName : 'DHCMed.FBDService.ReportSrv',
				QueryName : 'QryReportByPapmi',
				Arg1 : PatientID,
				ArgCnt : 1
			},
			success : function(response, opts) {
				var objData = Ext.decode(response.responseText);
				var objRepType = obj.RepTypeList[indType];
				var objItem = null;
				for(var i=0; i<objData.total; i ++) {
					objItem = objData.record[i];
					if (!objItem) { continue; }
					var ind = objRepType.ReportList.length;
					objRepType.ReportList[ind] = objItem;
					objRepType.ReportCount++;
				}
				obj.RepTypeList[indType] = objRepType;
			},
			failure : function(response, opts) {
				var objTargetElement = document.getElementById(errDiv);
				if (objTargetElement) {
					objTargetElement.innerHTML = response.responseText;
				}
			}
		});
	}
	
	//���ؾ��񼲲�����
	obj.LoadSMDData = function(indType,arg2,TypeCode)
	{
		obj.RepTypeList[indType].ReportList.length = 0;
		obj.RepTypeList[indType].ReportCount = 0;
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCMed.SMDService.ReportSrv',
				QueryName : 'QryReportByAdm',
				Arg1 : EpisodeID,
				ArgCnt : 1
			},
			success: function(response, opts) {
				var objData = Ext.decode(response.responseText);
				var objRepType = obj.RepTypeList[indType];
				var objItem = null;
				for(var i = 0; i < objData.total; i ++)
				{
					objItem = objData.record[i];
					if (!objItem) continue;
					
					var ind = objRepType.ReportList.length;
					objRepType.ReportList[ind] = objItem;
					objRepType.ReportCount++;
				}
				obj.RepTypeList[indType] = objRepType;
			},
			failure: function(response, opts) {
				var objTargetElement = document.getElementById(errDiv);
				if (objTargetElement) {
					objTargetElement.innerHTML = response.responseText;
				}
			}
		});
	}
	
	
	//��������2.0����
	obj.LoadCDData = function(indType,arg2,TypeCode)
	{
		obj.RepTypeList[indType].ReportList.length = 0;
		obj.RepTypeList[indType].ReportCount = 0;
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCMed.CDService.QryService',
				QueryName : 'QryRepByEpisodeID',
				Arg1 : EpisodeID,
				Arg2 : '',
				ArgCnt : 2
			},
			success: function(response, opts) {
				var objData = Ext.decode(response.responseText);
				var objRepType = obj.RepTypeList[indType];
				var objItem = null;
				for(var i = 0; i < objData.total; i ++)
				{
					objItem = objData.record[i];
					if (!objItem) continue;
					
					var ind = objRepType.ReportList.length;
					objRepType.ReportList[ind] = objItem;
					objRepType.ReportCount++;
				}
				obj.RepTypeList[indType] = objRepType;
			},
			failure: function(response, opts) {
				var objTargetElement = document.getElementById(errDiv);
				if (objTargetElement) {
					objTargetElement.innerHTML = response.responseText;
				}
			}
		});
	}
	
	// �������⻼�߹���
	obj.LoadSPEData = function(indType,errDiv) {
		obj.RepTypeList[indType].ReportList.length = 0;
		obj.RepTypeList[indType].ReportCount = 0;
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params : {
				ClassName : 'DHCMed.SPEService.PatientsQry',
				QueryName : 'QrySpeListByAdm',
				Arg1 : EpisodeID,
				Arg2 : '1',
				ArgCnt : 2
			},
			success : function(response, opts) {
				var objData = Ext.decode(response.responseText);
				var objRepType = obj.RepTypeList[indType];
				var objItem = null;
				for(var i=0; i<objData.total; i ++) {
					objItem = objData.record[i];
					if (!objItem) { continue; }
					var ind = objRepType.ReportList.length;
					objRepType.ReportList[ind] = objItem;
					objRepType.ReportCount++;
				}
				obj.RepTypeList[indType] = objRepType;
			},
			failure : function(response, opts) {
				var objTargetElement = document.getElementById(errDiv);
				if (objTargetElement) {
					objTargetElement.innerHTML = response.responseText;
				}
			}
		});
	}
    */
    //���ش�Ⱦ������ڶ������
	obj.LoadEPD2Data = function(indType,errDiv)
	{
		obj.RepTypeList[indType].ReportList.length = 0;
		obj.RepTypeList[indType].ReportCount = 0;
		
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCMed.EPDService.EpidemicSrv'
		url += '&QueryName=' + 'QryByPapmi'
		url += '&Arg1=' + PatientID
		url += '&ArgCnt=' + 1
		url += '&2=2'
        conn.open("post",url,false);
		conn.send(null);
		
		if (conn.status == "200") {
			var objData = Ext.decode(conn.responseText);
			var objRepType = obj.RepTypeList[indType];
			var objItem = null;
			for(var i = 0; i < objData.total; i ++)
			{
				objItem = objData.record[i];
				if (!objItem) continue;
					
				var ind = objRepType.ReportList.length;
				objRepType.ReportList[ind] = objItem;
				objRepType.ReportCount++;
			}
			obj.RepTypeList[indType] = objRepType;
			return true;
		} else {
			ExtTool.alert("��ʾ","���ش�Ⱦ�����ݴ���!");
			return false;
		}
		
	}
	
	//ҽԺ��Ⱦ����V3.0
	obj.LoadINF3Data = function(indType)
	{
		obj.RepTypeList[indType].ReportList.length = 0;
		obj.RepTypeList[indType].ReportCount = 0;
		
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCMed.NINFService.Rep.InfReport'
		url += '&QueryName=' + 'QryReportByAdm'
		url += '&Arg1=' + EpisodeID
		url += '&Arg2=' + ''
		url += '&ArgCnt=' + 2
		url += '&2=2'
        conn.open("post",url,false);
		conn.send(null);
	
		if (conn.status == "200") {
			var objData = Ext.decode(conn.responseText);
			var objRepType = obj.RepTypeList[indType];
			var objItem = null;
			for(var i = 0; i < objData.total; i ++)
			{
				objItem = objData.record[i];
				if (!objItem) continue;
					
				var ind = objRepType.ReportList.length;
				objRepType.ReportList[ind] = objItem;
				objRepType.ReportCount++;
			}
			obj.RepTypeList[indType] = objRepType;
			//return true;
			
		} else {
			ExtTool.alert("��ʾ","����Ժ�б������ݴ���!");
			return false;
		}
		
		
		obj.RepTypeList[indType].InfCasesList = new Array();
		obj.RepTypeList[indType].InfCasesCount = 0;		
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCMed.NINFService.BC.CasesSrv'
		url += '&QueryName=' + 'QryHandleDtl'
		url += '&Arg1=' + SubjectCode
		url += '&Arg2=' + EpisodeID
		url += '&ArgCnt=' + 2
		url += '&2=2'
        conn.open("post",url,false);
		conn.send(null);
		
		if (conn.status == "200") {
			var objData = Ext.decode(conn.responseText);
			var objRepType = obj.RepTypeList[indType];
			var objItem = null;
			for(var i = 0; i < objData.total; i ++)
			{
				objItem = objData.record[i];
				if (!objItem) continue;
				
				var ind = objRepType.InfCasesList.length;
				objRepType.InfCasesList[ind] = objItem;
				objRepType.InfCasesCount++;
			}
			obj.RepTypeList[indType] = objRepType;
			//return true;
		} else {
			ExtTool.alert("��ʾ","�������Ʋ����������ݴ���!");
			return false;
		}
		
		return;	//add by zf 2014-09-02
		var strDateList = ExtTool.RunServerMethod("DHCMed.NINFService.BC.CasesXSrv", "GetCtlDateList", SubjectCode, EpisodeID);
		if (!strDateList) return;
		var arrDateList = strDateList.split(',');
		obj.RepTypeList[indType].CtlDateList = arrDateList;
		obj.RepTypeList[indType].CtlDateListI = new Array();
		obj.RepTypeList[indType].CtlRstList = new Array();
		obj.RepTypeList[indType].CtlRstListI = new Array();
		for (var indDate = 0; indDate < arrDateList.length; indDate++) {
			var tmpDate = arrDateList[indDate];
			obj.RepTypeList[indType].CtlDateListI[tmpDate] = indDate;
		}
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCMed.NINFService.BC.CasesXSrv'
		url += '&QueryName=' + 'QryCtlResult'
		url += '&Arg1=' + SubjectCode
		url += '&Arg2=' + EpisodeID
		url += '&ArgCnt=' + 2
		url += '&2=2'
        conn.open("post",url,false);
		conn.send(null);
		
		if (conn.status == "200") {
			var objData = Ext.decode(conn.responseText);
			var objInfCtlRst = obj.RepTypeList[indType];
			var objItem = null;
			for(var i = 0; i < objData.total; i ++)
			{
				objItem = objData.record[i];
				if (!objItem) continue;
				if (typeof(objInfCtlRst.CtlDateListI[objItem.OccurDate]) == 'undefined') continue;
				
				var ItemCat = objItem.ItemCatID;
				var ItemSubCat = objItem.SubCatID;
				var indexItemCat = ItemCat + '-' + ItemSubCat;
				
				if (typeof(objInfCtlRst.CtlRstListI[indexItemCat]) != 'undefined') {
					var ind = objInfCtlRst.CtlRstListI[indexItemCat];
					var objSubCat = objInfCtlRst.CtlRstList[ind];
					if (typeof(objSubCat.ItemDateList[objItem.OccurDate]) != 'undefined') {
					} else {
						objSubCat.ItemDateList[objItem.OccurDate] = {
							ItemDate : objItem.OccurDate,
							ItemList : new Array
						}
					}
				} else {
					var objSubCat = {
						ItemCatID : objItem.ItemCatID,
						ItemCat : objItem.ItemCatDesc,
						ItemSubCatID : objItem.SubCatID,
						ItemSubCat : objItem.SubCatDesc,
						ItemDateList : new Array()
					}
					objSubCat.ItemDateList[objItem.OccurDate] = {
						ItemDate : objItem.OccurDate,
						ItemList : new Array
					}
					var ind = objInfCtlRst.CtlRstList.length;
					objInfCtlRst.CtlRstListI[indexItemCat] = ind;
					objInfCtlRst.CtlRstList[ind] = objSubCat;
				}
				var ind = objSubCat.ItemDateList[objItem.OccurDate].ItemList.length;
				objSubCat.ItemDateList[objItem.OccurDate].ItemList[ind] = objItem;
				var ind = objInfCtlRst.CtlRstListI[indexItemCat];
				objSubCat.CtlDateList = new Array();
				objSubCat.CtlDateList = objInfCtlRst.CtlDateList;
				objInfCtlRst.CtlRstList[ind] = objSubCat;
			}
			obj.RepTypeList[indType] = objInfCtlRst;
			return true;
		} else {
			ExtTool.alert("��ʾ","�������Ʋ����������ݴ���!");
			return false;
		}
	}
	
	//ҽԺ��Ⱦ����V4.0
	obj.LoadHAIData = function(indType){
		//ҽԺ��Ⱦ�����б�
		obj.RepTypeList[indType].ReportList.length = 0;
		obj.RepTypeList[indType].ReportCount = 0;
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCHAI.CUS.ToClinReport'
		url += '&QueryName=' + 'QryReportByAdm'
		url += '&Arg1=' + HAIEpisodeDr
		url += '&ArgCnt=' + 1
		url += '&2=2'
        conn.open("post",url,false);
		conn.send(null);
		
		if (conn.status == "200") {
			var objData = Ext.decode(conn.responseText);
			var objRepType = obj.RepTypeList[indType];
			var objItem = null;
			for(var i = 0; i < objData.total; i ++)
			{
				objItem = objData.record[i];
				if (!objItem) continue;
					
				var ind = objRepType.ReportList.length;
				objRepType.ReportList[ind] = objItem;
				objRepType.ReportCount++;
			}
			obj.RepTypeList[indType] = objRepType;
			//return true;
			
		} else {
			ExtTool.alert("��ʾ","����Ժ�б������ݴ���!");
			return false;
		}
		
		//���Ʋ���ɸ���¼
		obj.RepTypeList[indType].InfCasesList = new Array();
		obj.RepTypeList[indType].InfCasesCount = 0;
		obj.RepTypeList[indType].SusInfStatus = '';
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCHAI.IRS.CCScreeningSrv'
		url += '&QueryName=' + 'QryScreenResult'
		url += '&Arg1=' + HAIEpisodeDr
		url += '&ArgCnt=' + 1
		url += '&2=2'
        conn.open("post",url,false);
		conn.send(null);
		
		if (conn.status == "200") {
			var objData = Ext.decode(conn.responseText);
			var objRepType = obj.RepTypeList[indType];
			var objItem = null;
			for(var i = 0; i < objData.total; i ++)
			{
				objItem = objData.record[i];
				if (!objItem) continue;
				
				var ind = objRepType.InfCasesList.length;
				objRepType.InfCasesList[ind] = objItem;
				objRepType.InfCasesCount++;
			}
			obj.RepTypeList[indType] = objRepType;
			//return true;
		} else {
			ExtTool.alert("��ʾ","�������Ʋ����������ݴ���!");
			return false;
		}
		
		//��������ɸ�� ����״̬
		var SusInfStatus='';
		var retval = ExtTool.RunServerMethod("DHCHAI.IRS.CCScreenAttSrv","UpdateSusInfFlag",HAIEpisodeDr);
		var rstArr = retval.split("^");
		if (rstArr[1] ==1 ){
			var SusInfStatus=rstArr[3];
		}
		obj.RepTypeList[indType].SusInfStatus = SusInfStatus;
	}
	
	obj.setBaseInfoScrollLeft = function(aCmpId)
	{
		var XTable = document.getElementById(aCmpId + '-x-table');
		var Table = document.getElementById(aCmpId + '-table');
		var XScroll = document.getElementById(aCmpId + '-x-scroll');
		var Scroll = document.getElementById(aCmpId + '-scroll');
		if ((!XTable)||(!Table)||(!XScroll)||(!Scroll)) return;
		
		XTable.style.width = ((Table.width + 20)/100) + "px";
		XScroll.scrollLeft = XScroll.scrollWidth;
		Scroll.scrollLeft = Scroll.scrollWidth;
		
		XScroll.onscroll = function (e) {
			Scroll.scrollLeft = XScroll.scrollLeft;
		}
	}
	//��������֤������ڶ�������
	obj.LoadDTH2Data = function(indType)
	{
		obj.RepTypeList[indType].ReportList.length = 0;
		obj.RepTypeList[indType].ReportCount = 0;
		
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCMed.DTHService.ReportSrv'
		url += '&QueryName=' + 'QryReportByPatientID'
		url += '&Arg1=' + PatientID
		url += '&ArgCnt=' + 1
		url += '&2=2'
        conn.open("post",url,false);
		conn.send(null);
		
		if (conn.status == "200") {
			var objData = Ext.decode(conn.responseText);
			var objRepType = obj.RepTypeList[indType];
			var objItem = null;
			for(var i = 0; i < objData.total; i ++)
			{
				objItem = objData.record[i];
				if (!objItem) continue;
				
				var ind = objRepType.ReportList.length;
				objRepType.ReportList[ind] = objItem;
				objRepType.ReportCount++;
			}
			obj.RepTypeList[indType] = objRepType;
			return true;
		} else {
			ExtTool.alert("��ʾ","��������֤�������ݴ���!");
			return false;
		}
		
	}
	//�����Զ��������
	obj.LoadCRFData = function(indType)
	{
		obj.RepTypeList[indType].ReportList.length = 0;
		obj.RepTypeList[indType].ReportCount = 0;
		var strTmp = ExtTool.RunServerMethod("DHCMed.CR.PO.Form", "GetStringById",obj.RepTypeList[indType].TypeCode);
		if (!strTmp) return;
		var arrTmp = strTmp.split('^');
		var FormEName = arrTmp[2];
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCMed.CR.BO.FormQry'
		url += '&QueryName=' + 'QryByPatientID'
		url += '&Arg1=' + PatientID
		url += '&Arg2=' + FormEName
		url += '&ArgCnt=' + 2
		url += '&2=2'
        conn.open("post",url,false);
		conn.send(null);
		
		if (conn.status == "200") {
			var objData = Ext.decode(conn.responseText);
			var objRepType = obj.RepTypeList[indType];
			var objItem = null;
			for(var i = 0; i < objData.total; i ++)
			{
				objItem = objData.record[i];
				if (!objItem) continue;
				
				var ind = objRepType.ReportList.length;
				objRepType.ReportList[ind] = objItem;
				objRepType.ReportCount++;
			}
			obj.RepTypeList[indType] = objRepType;
			return true;
		} else {
			ExtTool.alert("��ʾ","�����Զ�������ݴ���!");
			return false;
		}
	}
	
	// ����ʳԴ�Լ�������
	obj.LoadFBD1Data = function(indType,errDiv) {
		obj.RepTypeList[indType].ReportList.length = 0;
		obj.RepTypeList[indType].ReportCount = 0;
		
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCMed.FBDService.ReportSrv'
		url += '&QueryName=' + 'QryReportByPapmi'
		url += '&Arg1=' + PatientID
		url += '&ArgCnt=' + 1
		url += '&2=2'
        conn.open("post",url,false);
		conn.send(null);
		
		if (conn.status == "200") {
			var objData = Ext.decode(conn.responseText);
			var objRepType = obj.RepTypeList[indType];
			var objItem = null;
			for(var i = 0; i < objData.total; i ++)
			{
				objItem = objData.record[i];
				if (!objItem) continue;
				
				var ind = objRepType.ReportList.length;
				objRepType.ReportList[ind] = objItem;
				objRepType.ReportCount++;
			}
			obj.RepTypeList[indType] = objRepType;
			return true;
		} else {
			ExtTool.alert("��ʾ","����ʳԴ�Լ������ݴ���!");
			return false;
		}

	}
	
	//���ؾ��񼲲�����
	obj.LoadSMDData = function(indType,arg2,TypeCode)
	{
		obj.RepTypeList[indType].ReportList.length = 0;
		obj.RepTypeList[indType].ReportCount = 0;
		
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCMed.SMDService.ReportSrv'
		url += '&QueryName=' + 'QryReportByAdm'
		url += '&Arg1=' + EpisodeID
		url += '&ArgCnt=' + 1
		url += '&2=2'
        conn.open("post",url,false);
		conn.send(null);
		
		if (conn.status == "200") {
			var objData = Ext.decode(conn.responseText);
			var objRepType = obj.RepTypeList[indType];
			var objItem = null;
			for(var i = 0; i < objData.total; i ++)
			{
				objItem = objData.record[i];
				if (!objItem) continue;
				
				var ind = objRepType.ReportList.length;
				objRepType.ReportList[ind] = objItem;
				objRepType.ReportCount++;
			}
			obj.RepTypeList[indType] = objRepType;
			return true;
		} else {
			ExtTool.alert("��ʾ","���ؾ��񼲲����ݴ���!");
			return false;
		}
	}
	
	
	//��������2.0����
	obj.LoadCDData = function(indType,arg2,TypeCode)
	{
		obj.RepTypeList[indType].ReportList.length = 0;
		obj.RepTypeList[indType].ReportCount = 0;
		
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCMed.CDService.QryService'
		url += '&QueryName=' + 'QryRepByEpisodeID'
		url += '&Arg1=' + EpisodeID
		url += '&Arg2=' + ''
		url += '&ArgCnt=' + 2
		url += '&2=2'
        conn.open("post",url,false);
		conn.send(null);
		
		if (conn.status == "200") {
			var objData = Ext.decode(conn.responseText);
			var objRepType = obj.RepTypeList[indType];
			var objItem = null;
			for(var i = 0; i < objData.total; i ++)
			{
				objItem = objData.record[i];
				if (!objItem) continue;
				
				var ind = objRepType.ReportList.length;
				objRepType.ReportList[ind] = objItem;
				objRepType.ReportCount++;
			}
			obj.RepTypeList[indType] = objRepType;
			return true;
		} else {
			ExtTool.alert("��ʾ","���������������ݴ���!");
			return false;
		}
	}
	
	// �������⻼�߹���
	obj.LoadSPEData = function(indType,errDiv) {
		obj.RepTypeList[indType].ReportList.length = 0;
		obj.RepTypeList[indType].ReportCount = 0;
		
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCMed.SPEService.PatientsQry'
		url += '&QueryName=' + 'QrySpeListByAdm'
		url += '&Arg1=' + EpisodeID
		url += '&Arg2=' + 1
		url += '&ArgCnt=' + 2
		url += '&2=2'
        conn.open("post",url,false);
		conn.send(null);
		
		if (conn.status == "200") {
			var objData = Ext.decode(conn.responseText);
			var objRepType = obj.RepTypeList[indType];
			var objItem = null;
			for(var i = 0; i < objData.total; i ++)
			{
				objItem = objData.record[i];
				if (!objItem) continue;
				
				var ind = objRepType.ReportList.length;
				objRepType.ReportList[ind] = objItem;
				objRepType.ReportCount++;
			}
			obj.RepTypeList[indType] = objRepType;
			return true;
		} else {
			ExtTool.alert("��ʾ","�������⻼�����ݴ���!");
			return false;
		}
	}
	
	//ҽԺ��Ⱦ����V4.0
	obj.OpenHAIReport = function(aTypeCate,aTypeCode,aType,aRowID){
		if (HAIEpisodeDr=="") {
			ExtTool.alert("��ʾ","�û��߿��ܷǰ�����Ժ�ǼǵĻ��ߣ����֤�����!");
			return false;
		}
		var t=new Date();
		t=t.getTime();
		if ((aTypeCate == 'HAI')&&(aTypeCode  == '1')){
			if (aType == '1') {
				var lnk="dhchai.ir.inf.report.csp?1=1&Paadm=" + EpisodeID + "&ReportID="+ aRowID + "&EpisodeID="+ "&t=" + t;
			    obj.viewReportWin('win' + aTypeCate + aTypeCode + aType + 'Report',lnk);
			}else if(aType == '2') {
				var lnk="dhchai.ir.inf.nreport.csp?1=1&Paadm=" + EpisodeID + "&ReportID="+ aRowID + "&EpisodeID="+ "&t=" + t;	   
			    obj.viewReportWin('win' + aTypeCate + aTypeCode + aType + 'Report',lnk);
			}	
		}
	}
	
	obj.OpenReportWinByCom = function(aTypeCate,aTypeCode,aRowID){
		var t=new Date();
		t=t.getTime();
		if ((aTypeCate == 'INF')&&(aTypeCode  == '3')){
			var lnk="dhcmed.ninf.rep.infreport.csp?1=1&ReportID="+aRowID+"&EpisodeID="+EpisodeID+"&AdminPower="+obj.AdminPower + "&t=" + t;
			obj.viewReportWin('win' + aTypeCate + aTypeCode + 'Report',lnk);
		}
		if ((aTypeCate == 'EPD')&&(aTypeCode  == '2')){
			var lnk="dhcmed.epd.report.csp?1=1&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&ReportID="+aRowID + "&t=" + t;
			obj.viewReportWin('win' + aTypeCate + aTypeCode + 'Report',lnk);
		}
		if ((aTypeCate == 'DTH')&&(aTypeCode  == '2')){
			if (aRowID == ''){
				var flg = ExtTool.RunServerMethod("DHCMed.DTHService.ReportSrv","CheckDthRepByAdm",EpisodeID);
				if (flg*1==1){
					ExtTool.alert('��ʾ','��ǰ��������֤���,�������ظ��!');
					return;
				}
			}
			var lnk="dhcmed.dth.report.csp?1=1&EpisodeID="+EpisodeID+"&CTLocID="+session['LOGON.CTLOCID']+"&ReportID=" + aRowID + "&t=" + t;
			obj.viewReportWin('win' + aTypeCate + aTypeCode + 'Report',lnk);
		}
		if (aTypeCate == 'CRF'){
			var strClassName = ExtTool.RunServerMethod("DHCMed.CR.PO.Form", "GetClassNameById",aTypeCode);
			if (!strClassName) return;
			var lnk = "dhcmed.crf.reportfrom.csp?a=a"
				+ "&EpisodeID=" + EpisodeID
				+ "&PatientID=" + PatientID
				+ "&GoalUserID=" + session['LOGON.USERID']
				+ "&FormCode=" + strClassName
				+ "&Caption=" + ''
				+ "&DataID=" + aRowID
				+ "&LocFlag="
				+ "&t=" + t;
			obj.viewReportWin('win' + aTypeCate + aTypeCode + 'Report',lnk);
		}
		
		if (aTypeCate == 'FBD' && aTypeCode  == '1') {
			var lnk="dhcmed.fbd.report.csp?1=1&EpisodeID=" + EpisodeID + "&ReportID=" + aRowID + "&LocFlag=0" + "&t=" + t;
			obj.viewReportWin('win' + aTypeCate + aTypeCode + 'Report',lnk);
		}
		
		if (aTypeCate == 'SMD') {
			var lnk="dhcmed.smd.report.csp?1=1&ReportID=" + aRowID + "&LocFlag=0" + "&t=" + t;
			obj.viewReportWin('win' + aTypeCate + aTypeCode + 'Report',lnk);
		}
		
		if (aTypeCate == 'CD') {
			if(aTypeCode== 'ZLK'){
				var lnk="dhcmed.cd.reportzlk.csp?1=1&ReportID=" + aRowID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&t=" + t;
				obj.viewReportWin('win' + aTypeCate + aTypeCode + 'Report',lnk);
			}else if(aTypeCode== 'XNXG'){
				var lnk="dhcmed.cd.reportxnxg.csp?1=1&ReportID=" + aRowID + "&EpisodeID=" + EpisodeID + "&t=" + t;
				obj.viewReportWin('win' + aTypeCate + aTypeCode + 'Report',lnk);
			}else if(aTypeCode== 'SHK'){
				var lnk="dhcmed.cd.reportshk.csp?1=1&ReportID=" + aRowID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&t=" + t;
				obj.viewReportWin('win' + aTypeCate + aTypeCode + 'Report',lnk);
			}else if(aTypeCode== 'NYZD'){
				var lnk="dhcmed.cd.reportnyzd.csp?1=1&ReportID=" + aRowID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&t=" + t;
				obj.viewReportWin('win' + aTypeCate + aTypeCode + 'Report',lnk);
			}else if(aTypeCode== 'GWZS'){
				var lnk="dhcmed.cd.reportgwzs.csp?1=1&ReportID=" + aRowID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&t=" + t;
				obj.viewReportWin('win' + aTypeCate + aTypeCode + 'Report',lnk);
			}else if(aTypeCode== 'TNB'){
				var lnk="dhcmed.cd.reporttnb.csp?1=1&ReportID=" + aRowID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&t=" + t;
				obj.viewReportWin('win' + aTypeCate + aTypeCode + 'Report',lnk);
			}else if(aTypeCode== 'YSZYB'){
				var lnk="dhcmed.cd.reportyszyb.csp?1=1&ReportID=" + aRowID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&t=" + t;
				obj.viewReportWin('win' + aTypeCate + aTypeCode + 'Report',lnk);
			}else if(aTypeCode== 'FZYCO'){
				var lnk="dhcmed.cd.reportfzyco.csp?1=1&ReportID=" + aRowID + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&t=" + t;
				obj.viewReportWin('win' + aTypeCate + aTypeCode + 'Report',lnk);
			}
		}

		if (aTypeCate == 'SPE') {
			var objInput = new Object();
			objInput.SpeID     = aRowID;
			objInput.EpisodeID = EpisodeID;
			objInput.OperTpCode = '1';
			var objMarkWin = new SPM_InitSpeMarkWin(objInput);
			objMarkWin.SPM_WinSpeMark.show();
		}
	}
	
	obj.OpenReportWinByComA = function(aTypeCate,aTypeCode,aRowID){
		var strInfo = ExtTool.RunServerMethod("DHCMed.EPD.ReferralRep","GetInfoByEPD",EpisodeID);
		if (strInfo=="") {
			ExtTool.alert("��ʾ","������д���ν�ˡ���Ⱦ�����棡");
			return;
		}
		var ret = ExtTool.RunServerMethod("DHCMed.EPD.ReferralRep","GetRepIDByAdm",EpisodeID);
		var lnk="dhcmed.epd.referral.csp?1=1&ReportID=" + ret + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&t=" + t;
		obj.viewReportWinA('winReferralReport',lnk);
	}
	
	obj.OpenReportWinByTp = function(aTypeCate,aTypeCode,aRepType){
		var t=new Date();
		t=t.getTime();
		if ((aTypeCate == 'INF')&&(aTypeCode  == '3')){
			var lnk="dhcmed.ninf.rep.infreport.csp?1=1&ReportType=" + aRepType + "&EpisodeID=" + EpisodeID + "&TransLoc=" + "" + "&AdminPower=" + "&t=" + t;
			obj.viewReportWin('win' + aTypeCate + aTypeCode + 'Report',lnk);
		}
		if ((aTypeCate == 'SMD')&&(aTypeCode  == '1')){
			var lnk="dhcmed.smd.report.csp?1=1&ReportType=" + aRepType + "&EpisodeID=" + EpisodeID + "&t=" + t;
			obj.viewReportWin('win' + aTypeCate + aTypeCode + 'Report',lnk);
		}
		if ((aTypeCate == 'CD')&&(aTypeCode  == '1')){
			if(aRepType== 'ZLK'){
				var lnk="dhcmed.cd.reportzlk.csp?1=1&ReportID=" + "" + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&t=" + t;
				obj.viewReportWin('win' + aTypeCate + aTypeCode + 'Report',lnk);
			}else if(aRepType== 'XNXG'){
				var lnk="dhcmed.cd.reportxnxg.csp?1=1&ReportID=" + "" + "&EpisodeID=" + EpisodeID + "&t=" + t;
				obj.viewReportWin('win' + aTypeCate + aTypeCode + 'Report',lnk);
			}else if(aRepType== 'SHK'){
				var lnk="dhcmed.cd.reportshk.csp?1=1&ReportID=" + "" + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&t=" + t;
				obj.viewReportWin('win' + aTypeCate + aTypeCode + 'Report',lnk);
			}else if(aRepType== 'NYZD'){
				var lnk="dhcmed.cd.reportnyzd.csp?1=1&ReportID=" + "" + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&t=" + t;
				obj.viewReportWin('win' + aTypeCate + aTypeCode + 'Report',lnk);
			}else if(aRepType== 'GWZS'){
				var lnk="dhcmed.cd.reportgwzs.csp?1=1&ReportID=" + "" + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&t=" + t;
				obj.viewReportWin('win' + aTypeCate + aTypeCode + 'Report',lnk);
			}else if(aRepType== 'TNB'){
				var lnk="dhcmed.cd.reporttnb.csp?1=1&ReportID=" + "" + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&t=" + t;
				obj.viewReportWin('win' + aTypeCate + aTypeCode + 'Report',lnk);
			}else if(aRepType== 'YSZYB'){
				var lnk="dhcmed.cd.reportyszyb.csp?1=1&ReportID=" + "" + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&t=" + t;
				obj.viewReportWin('win' + aTypeCate + aTypeCode + 'Report',lnk);
			}else if(aRepType== 'FZYCO'){
				var lnk="dhcmed.cd.reportfzyco.csp?1=1&ReportID=" + "" + "&EpisodeID=" + EpisodeID + "&PatientID="+PatientID + "&t=" + t;
				obj.viewReportWin('win' + aTypeCate + aTypeCode + 'Report',lnk);
			}
		}
	}
	
	//���Ʋ���ɸ�� ժҪ��Ϣ
	obj.ViewInfBaseInfo = function(aEpisodeID)
	{
		var objDisplayWin = new InitPatientDtl(aEpisodeID, SubjectCode);
		objDisplayWin.WinPatientDtl.show();
	}
	
	//���Ʋ���ɸ�� ժҪ��Ϣ��ҽԺ��Ⱦ����V4.0��
	obj.HAIViewBaseInfo = function(aHAIEpisodeDr)
	{
		var t=new Date();
		t=t.getTime();
		var lnk = "../csp/dhchai.ir.view.main.csp?PaadmID=" + aHAIEpisodeDr + "&t=" + t;
		obj.viewReportWin('win' + aHAIEpisodeDr + 'HAIIRViewMain',lnk);
	}
	
	//���Ʋ���ɸ�� ������Ϣ��ҽԺ��Ⱦ����V4.0��
	obj.HAICasesMsgOper = function(aHAIEpisodeDr)
	{
		var t=new Date();
		t=t.getTime();
		var lnk = "../csp/dhchai.ir.ccmessage.csp?EpisodeDr=" + aHAIEpisodeDr + "&PageType=WinOpen&MsgType=2&t=" + t;
		var sFeatures = "dialogWidth=" + 800 + "px;dialogHeight=" + 500 + "px;resizable=no;"
		//var oWin = window.open(lnk,"",sFeatures);
		window.showModalDialog(lnk,"",sFeatures);
	}
	
	//���Ʋ���ɸ�� �����ų���ҽԺ��Ⱦ����V4.0��
	obj.HAICasesDetOper = function(aHAIEpisodeDr)
	{
		//�����Ʋ�����������
		var txtSusInfStatus = '';
		var objSusInfStatus=document.getElementById("SusInfStatus");
		if (objSusInfStatus){
			txtSusInfStatus = objSusInfStatus.innerHTML;
		}
		if (!txtSusInfStatus) {
			ExtTool.alert('��ʾ','�����Ʋ����������ų�!');
			return;
		}
	
		if ((txtSusInfStatus =="���ϱ�")||(txtSusInfStatus=="���ų�")) {
			ExtTool.alert('��ʾ','���ϱ������ų������Ʋ����������ų�!');
			return;
		}
		
		Ext.MessageBox.prompt('�����', '�������ų�ԭ��?', function(btn,text){
			if(btn=="ok"){
				if (!text) {
					ExtTool.alert('������ʾ','�������ų�ԭ��!');
					return;
				}
				var retval = ExtTool.RunServerMethod("DHCHAI.IRS.CCScreeningSrv","ScreenRstOperAll",aHAIEpisodeDr,2,HAIUserDr,text);
				var rstArr = retval.split("^");
				if (parseInt(rstArr[0])<1){
					ExtTool.alert('������ʾ','�����ų�����ʧ��!');
					return;
				}
				var SusInfStatus=rstArr[3];
				var objSusInfStatus=document.getElementById("SusInfStatus");
				if (objSusInfStatus){
					objSusInfStatus.innerHTML=SusInfStatus;
				}
			}
		},this,50);
	}
	
	//���Ʋ���ɸ�� ���ö���
	obj.btnHandle_onClick = function(aEpisodeID, aOperation)
	{
		var Operation = ExtTool.RunServerMethod("DHCMed.NINFService.BC.CommonSrv", "GetHandleGradeByCode", aOperation);
		if (!Operation) return;
		
		//��鴦�ò����뵱ǰ״̬�Ƿ����
		var flg = ExtTool.RunServerMethod("DHCMed.NINFService.BC.CasesSrv", "CheckCasesHandle", "HB", SubjectCode, aEpisodeID, aOperation);
		if (parseInt(flg) < 1) {
			var arrError = flg.split('^');
			if (arrError[0] == '-1') {
				ExtTool.alert('������ʾ',arrError[1]);
			} else if (arrError[0] == '-999') {
				ExtTool.alert('������ʾ',arrError[1]);
			} else {
				ExtTool.alert('������ʾ','Error:' + flg);
			}
			return;
		}
		
		if (aOperation == '5') {
			//���Ʋ�������(��Ⱦ����)
			var flg = ExtTool.RunServerMethod("DHCMed.NINFService.BC.CasesSrv", "CloseCasesHandle", "HB", SubjectCode, aEpisodeID, Operation, session['LOGON.CTLOCID'], session['LOGON.USERID']);
			if (parseInt(flg) > 0) {
				//���¼��ص�ǰ�������Ʋ���ɸ������
				ExtTool.alert('��ʾ','��' + Operation + '�������ɹ�!');
				obj.WindowRefresh_Handler();
			} else if (parseInt(flg)== 0){
				ExtTool.alert('������ʾ',"�޴��ü�¼�򱾴θ�Ⱦ�ѽ���!");
			} else {
				ExtTool.alert('������ʾ','��' + Operation + '����������!Error=' + flg);
			}
		} else {
			ExtTool.prompt("��ʾ", "�����봦�����!", function(btn, txt) {
				if (btn == 'ok') {
					//�������ȡֵ
					var Opinion = txt;
					if (((aOperation == '1')||(aOperation == '2')||(aOperation == '3'))&&(Opinion == '')) {
						ExtTool.alert('��ʾ','��' + Operation + '��������Ҫ��д"�������",����ɺ����ύ!');
						return;
					}
					
					var flg = ExtTool.RunServerMethod("DHCMed.NINFService.BC.CasesSrv", "ProcCasesHandle", "HB", SubjectCode, aEpisodeID, "", aOperation, Opinion, session['LOGON.CTLOCID'], session['LOGON.USERID'],0);
					if (parseInt(flg) > 0) {
						//���¼��ص�ǰ�������Ʋ���ɸ������
						if (aOperation == '3') {
							ExtTool.alert('��ʾ','��' + Operation + '�������ɹ�,�뼰ʱ�ϱ�ҽԺ��Ⱦ����,ȷ��δ������©������!');
						} else {
							ExtTool.alert('��ʾ','��' + Operation + '�������ɹ�!');
						}
						obj.WindowRefresh_Handler();
					} else {
						ExtTool.alert('������ʾ','��' + Operation + '����������!Error=' + flg);
					}
				}
			});
		}
	}
	
	obj.tabCancelHandle_onDblClick = function(aHandleType,aHandleID)
	{
		if (aHandleType != 'HB') {
			ExtTool.alert('������ʾ','���ܳ����Լ��Ĵ��ü�¼');
			return;
		}
		//ȡ�����ü�¼
		var flg = ExtTool.RunServerMethod("DHCMed.NINFService.BC.CasesSrv", "CancelCasesHandle", 'HB', aHandleID, session['LOGON.CTLOCID'], session['LOGON.USERID']);
		if (parseInt(flg) > 0) {
			//���¼��ص�ǰ�������Ʋ���ɸ������
			var EpisodeID = flg;
			//obj.LoadAdmCasesX(EpisodeID);
		} else {
			var tmpRet=flg.split('^');
			if (tmpRet[0] == '-999') {
				ExtTool.alert('������ʾ','ȡ�����ü�¼ʧ��!Error:' + tmpRet[1]);
			} else if (tmpRet[0] == '-1') {
				ExtTool.alert('������ʾ',tmpRet[1]);
			} else {
				ExtTool.alert('������ʾ','ȡ�����ü�¼ʧ��!Error=' + flg);
			}
		}
		//ˢ��
		obj.WindowRefresh_Handler();
	}
	
	obj.OpenSpeNewsWin = function(SpeID){
		var objInput = new Object();
		objInput.SpeID = SpeID;
		objInput.OperTpCode = "1";
		
		var objNewsWin = new SPN_InitSpeNewsWin(objInput);
		objNewsWin.SPN_WinSpeNews.show();
	}
	
	obj.viewReportWin = function(winid,url){
		if (ExtWinOpen == 1) {
			/* CS������Ҫ�õ����ַ�ʽ���޷�����ҳ�� */
			var win_report = new Ext.Window({
				id : winid,
				width : (window.screen.availWidth - 200),
				height : (window.screen.availHeight - 50),
				modal : true,
				plain : true,
				html : '<iframe id="' + winid + '" width=100% height=100% frameborder=0 scrolling=auto src="' + url + '"></iframe>'
			});
			win_report.show();
		} else {
			var sFeatures = "dialogWidth=" + window.screen.availWidth + "px;dialogHeight=" + window.screen.availHeight + "px;resizable=no;"
			window.showModalDialog(url,"closeBtnInvisible",sFeatures); //ժҪ��Ϣȥ��layer�Ĺرհ�ť��IR.View.main.GUI
			obj.btnRepType_OnClick(obj.CurrTypeIndex);
			//var oWin = window.open(url,'',"height=" + (window.screen.availHeight - 50) + ",width=" + (window.screen.availWidth - 200) + ",top=0,left=100,resizable=no");
		}
	}
	
	obj.viewReportWinA = function(winid,url){
		var sFeatures = "dialogWidth=" + (window.screen.availWidth/2) + "px;dialogHeight=" + (window.screen.availHeight/2) + "px;resizable=no;"
		window.showModalDialog(url,"",sFeatures);
	}
	
	obj.WindowRefresh_Handler = function()
	{
		obj.btnRepType_OnClick(obj.CurrTypeIndex);
	}
}
