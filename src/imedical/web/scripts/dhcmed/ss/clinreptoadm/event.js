function InitClinRepToAdmEvent(obj){
	obj.LoadEvent = function(args)
	{
		obj.CurrTypeIndex = -1;
		obj.btnRepType_OnClick(-1);
  	};
	
	//报告类型单击事件
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
	
	//显示报告信息
	obj.ViewReportData = function(aTypeIndex)
	{
		if (aTypeIndex == -1) {
			obj.RepXTemplate.overwrite("RepXTemplateDIV", obj.RepTypeList);
		} else {
			//obj.RepXTemplate.overwrite("RepXTemplateDIV", [obj.RepTypeList[aTypeIndex]]);
			obj.RepXTemplate.overwrite("RepXTemplateDIV", obj.RepTypeList[aTypeIndex]);
		}
		//设置基本信息X轴滚动条位置
		setTimeout('objScreen.setBaseInfoScrollLeft("divInfCtlResult")',500);
	}
	
	//加载报告数据
	obj.LoadReportData = function(aTypeIndex)
	{
		for (var indRepType = 0; indRepType < obj.RepTypeList.length; indRepType++) {
			if ((aTypeIndex != -1)&&(aTypeIndex != indRepType)) continue;
			
			var objRepType = obj.RepTypeList[indRepType];
			
			if ((objRepType.TypeCate == 'EPD')&&(objRepType.TypeCode == '2')) {
				obj.LoadEPD2Data(indRepType,'ErrXTemplateDIV');
			}
			
			//医院感染管理V3.0
			if ((objRepType.TypeCate == 'INF')&&(objRepType.TypeCode == '3')) {
				obj.LoadINF3Data(indRepType,'ErrXTemplateDIV');
			}
			
			//医院感染管理V4.0
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
			
			//Add By LiYang 2014-12-20 增加严重精神疾患报告页面
			if (objRepType.TypeCate == 'SMD') {
				obj.LoadSMDData(indRepType,'ErrXTemplateDIV',objRepType.TypeCode);
			}
			
			//Add By jiangpengpeng 2015-09-01 增加慢病报告页面
			if (objRepType.TypeCate == 'CD') {
				obj.LoadCDData(indRepType,'ErrXTemplateDIV',objRepType.TypeCode);
			}

			//加载特殊患者页面
			if (objRepType.TypeCate == 'SPE') {
				obj.LoadSPEData(indRepType,'ErrXTemplateDIV',objRepType.TypeCode);
			}
		}
	}
	
	/*
	//加载传染病管理第二版程序
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
	
	//加载医院感染管理第三版程序
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
	
	//加载死亡证明管理第二版数据
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
	
	//加载自定义表单数据
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
	
	// 加载食源性疾病数据
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
	
	//加载精神疾病报卡
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
	
	
	//加载慢病2.0报卡
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
	
	// 加载特殊患者管理
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
    //加载传染病管理第二版程序
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
			ExtTool.alert("提示","加载传染病数据错误!");
			return false;
		}
		
	}
	
	//医院感染管理V3.0
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
			ExtTool.alert("提示","加载院感报告数据错误!");
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
			ExtTool.alert("提示","加载疑似病例处置数据错误!");
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
			ExtTool.alert("提示","加载疑似病例处置数据错误!");
			return false;
		}
	}
	
	//医院感染管理V4.0
	obj.LoadHAIData = function(indType){
		//医院感染报告列表
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
			ExtTool.alert("提示","加载院感报告数据错误!");
			return false;
		}
		
		//疑似病例筛查记录
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
			ExtTool.alert("提示","加载疑似病例处置数据错误!");
			return false;
		}
		
		//加载疑似筛查 处置状态
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
	//加载死亡证明管理第二版数据
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
			ExtTool.alert("提示","加载死亡证明书数据错误!");
			return false;
		}
		
	}
	//加载自定义表单数据
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
			ExtTool.alert("提示","加载自定义表单数据错误!");
			return false;
		}
	}
	
	// 加载食源性疾病数据
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
			ExtTool.alert("提示","加载食源性疾病数据错误!");
			return false;
		}

	}
	
	//加载精神疾病报卡
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
			ExtTool.alert("提示","加载精神疾病数据错误!");
			return false;
		}
	}
	
	
	//加载慢病2.0报卡
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
			ExtTool.alert("提示","加载慢病管理数据错误!");
			return false;
		}
	}
	
	// 加载特殊患者管理
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
			ExtTool.alert("提示","加载特殊患者数据错误!");
			return false;
		}
	}
	
	//医院感染管理V4.0
	obj.OpenHAIReport = function(aTypeCate,aTypeCode,aType,aRowID){
		if (HAIEpisodeDr=="") {
			ExtTool.alert("提示","该患者可能非办理入院登记的患者，请查证后再填报!");
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
					ExtTool.alert('提示','当前患者死亡证已填报,不允许重复填报!');
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
			ExtTool.alert("提示","请先填写“肺结核”传染病报告！");
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
	
	//疑似病例筛查 摘要信息
	obj.ViewInfBaseInfo = function(aEpisodeID)
	{
		var objDisplayWin = new InitPatientDtl(aEpisodeID, SubjectCode);
		objDisplayWin.WinPatientDtl.show();
	}
	
	//疑似病例筛查 摘要信息（医院感染管理V4.0）
	obj.HAIViewBaseInfo = function(aHAIEpisodeDr)
	{
		var t=new Date();
		t=t.getTime();
		var lnk = "../csp/dhchai.ir.view.main.csp?PaadmID=" + aHAIEpisodeDr + "&t=" + t;
		obj.viewReportWin('win' + aHAIEpisodeDr + 'HAIIRViewMain',lnk);
	}
	
	//疑似病例筛查 发送消息（医院感染管理V4.0）
	obj.HAICasesMsgOper = function(aHAIEpisodeDr)
	{
		var t=new Date();
		t=t.getTime();
		var lnk = "../csp/dhchai.ir.ccmessage.csp?EpisodeDr=" + aHAIEpisodeDr + "&PageType=WinOpen&MsgType=2&t=" + t;
		var sFeatures = "dialogWidth=" + 800 + "px;dialogHeight=" + 500 + "px;resizable=no;"
		//var oWin = window.open(lnk,"",sFeatures);
		window.showModalDialog(lnk,"",sFeatures);
	}
	
	//疑似病例筛查 疑似排除（医院感染管理V4.0）
	obj.HAICasesDetOper = function(aHAIEpisodeDr)
	{
		//非疑似病例，不处置
		var txtSusInfStatus = '';
		var objSusInfStatus=document.getElementById("SusInfStatus");
		if (objSusInfStatus){
			txtSusInfStatus = objSusInfStatus.innerHTML;
		}
		if (!txtSusInfStatus) {
			ExtTool.alert('提示','非疑似病例，不需排除!');
			return;
		}
	
		if ((txtSusInfStatus =="已上报")||(txtSusInfStatus=="已排除")) {
			ExtTool.alert('提示','已上报或已排除的疑似病例不需再排除!');
			return;
		}
		
		Ext.MessageBox.prompt('输入框', '请输入排除原因?', function(btn,text){
			if(btn=="ok"){
				if (!text) {
					ExtTool.alert('错误提示','请输入排除原因!');
					return;
				}
				var retval = ExtTool.RunServerMethod("DHCHAI.IRS.CCScreeningSrv","ScreenRstOperAll",aHAIEpisodeDr,2,HAIUserDr,text);
				var rstArr = retval.split("^");
				if (parseInt(rstArr[0])<1){
					ExtTool.alert('错误提示','疑似排除操作失败!');
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
	
	//疑似病例筛查 处置动作
	obj.btnHandle_onClick = function(aEpisodeID, aOperation)
	{
		var Operation = ExtTool.RunServerMethod("DHCMed.NINFService.BC.CommonSrv", "GetHandleGradeByCode", aOperation);
		if (!Operation) return;
		
		//检查处置操作与当前状态是否符合
		var flg = ExtTool.RunServerMethod("DHCMed.NINFService.BC.CasesSrv", "CheckCasesHandle", "HB", SubjectCode, aEpisodeID, aOperation);
		if (parseInt(flg) < 1) {
			var arrError = flg.split('^');
			if (arrError[0] == '-1') {
				ExtTool.alert('错误提示',arrError[1]);
			} else if (arrError[0] == '-999') {
				ExtTool.alert('错误提示',arrError[1]);
			} else {
				ExtTool.alert('错误提示','Error:' + flg);
			}
			return;
		}
		
		if (aOperation == '5') {
			//疑似病例处置(感染结束)
			var flg = ExtTool.RunServerMethod("DHCMed.NINFService.BC.CasesSrv", "CloseCasesHandle", "HB", SubjectCode, aEpisodeID, Operation, session['LOGON.CTLOCID'], session['LOGON.USERID']);
			if (parseInt(flg) > 0) {
				//重新加载当前患者疑似病例筛查数据
				ExtTool.alert('提示','【' + Operation + '】操作成功!');
				obj.WindowRefresh_Handler();
			} else if (parseInt(flg)== 0){
				ExtTool.alert('错误提示',"无处置记录或本次感染已结束!");
			} else {
				ExtTool.alert('错误提示','【' + Operation + '】操作错误!Error=' + flg);
			}
		} else {
			ExtTool.prompt("提示", "请输入处置意见!", function(btn, txt) {
				if (btn == 'ok') {
					//处置意见取值
					var Opinion = txt;
					if (((aOperation == '1')||(aOperation == '2')||(aOperation == '3'))&&(Opinion == '')) {
						ExtTool.alert('提示','【' + Operation + '】操作需要填写"处置意见",请完成后再提交!');
						return;
					}
					
					var flg = ExtTool.RunServerMethod("DHCMed.NINFService.BC.CasesSrv", "ProcCasesHandle", "HB", SubjectCode, aEpisodeID, "", aOperation, Opinion, session['LOGON.CTLOCID'], session['LOGON.USERID'],0);
					if (parseInt(flg) > 0) {
						//重新加载当前患者疑似病例筛查数据
						if (aOperation == '3') {
							ExtTool.alert('提示','【' + Operation + '】操作成功,请及时上报医院感染报告,确诊未报卡以漏报处理!');
						} else {
							ExtTool.alert('提示','【' + Operation + '】操作成功!');
						}
						obj.WindowRefresh_Handler();
					} else {
						ExtTool.alert('错误提示','【' + Operation + '】操作错误!Error=' + flg);
					}
				}
			});
		}
	}
	
	obj.tabCancelHandle_onDblClick = function(aHandleType,aHandleID)
	{
		if (aHandleType != 'HB') {
			ExtTool.alert('错误提示','仅能撤消自己的处置记录');
			return;
		}
		//取消处置记录
		var flg = ExtTool.RunServerMethod("DHCMed.NINFService.BC.CasesSrv", "CancelCasesHandle", 'HB', aHandleID, session['LOGON.CTLOCID'], session['LOGON.USERID']);
		if (parseInt(flg) > 0) {
			//重新加载当前患者疑似病例筛查数据
			var EpisodeID = flg;
			//obj.LoadAdmCasesX(EpisodeID);
		} else {
			var tmpRet=flg.split('^');
			if (tmpRet[0] == '-999') {
				ExtTool.alert('错误提示','取消处置记录失败!Error:' + tmpRet[1]);
			} else if (tmpRet[0] == '-1') {
				ExtTool.alert('错误提示',tmpRet[1]);
			} else {
				ExtTool.alert('错误提示','取消处置记录失败!Error=' + flg);
			}
		}
		//刷新
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
			/* CS程序需要用到这种方式，无法弹出页面 */
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
			window.showModalDialog(url,"closeBtnInvisible",sFeatures); //摘要信息去掉layer的关闭按钮，IR.View.main.GUI
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
