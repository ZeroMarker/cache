function InitClinRepToAdmEvent(obj){
	obj.LoadEvent = function(args)
	{
		aTypeIndex = -1;
		if (SubjectCode=="EPD") {
			aTypeIndex=0;
		}
		if (SubjectCode=="INTCCS") {
			aTypeIndex=1;
		}
		if (SubjectCode=="DTH") {
			aTypeIndex=2;
		}
		if (SubjectCode=="SMD") {
			aTypeIndex=3;
		}	
		if (SubjectCode=="FBD") {
			aTypeIndex=4;
		}
		if (SubjectCode=="SPE") {
			aTypeIndex=5;
		}
		if (SubjectCode=="CD") {
			aTypeIndex=6;
		}
	   setTimeout('objScreen.ViewReportData(' + aTypeIndex + ')',500);
	   obj.LoadReportData(aTypeIndex);
	  
  	};
	
	//显示报告信息
	obj.ViewReportData = function(aTypeIndex)
	{
		if (aTypeIndex == -1) {
			obj.RepXTemplate.overwrite("RepXTemplateDIV", obj.RepTypeList);
		} else {
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
			
			if ((objRepType.TypeCate == 'INF')&&(objRepType.TypeCode == '3')) {
				obj.LoadINF3Data(indRepType,'ErrXTemplateDIV');
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
	
	//加载医院感染管理第三版程序
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
			window.showModalDialog(url,"",sFeatures);
			obj.btnRepType_OnClick(obj.CurrTypeIndex);
			//var oWin = window.open(url,'',"height=" + (window.screen.availHeight - 50) + ",width=" + (window.screen.availWidth - 200) + ",top=0,left=100,resizable=no");
		}
	}
	
	obj.WindowRefresh_Handler = function()
	{
		obj.btnRepType_OnClick(obj.CurrTypeIndex);
	}
}
