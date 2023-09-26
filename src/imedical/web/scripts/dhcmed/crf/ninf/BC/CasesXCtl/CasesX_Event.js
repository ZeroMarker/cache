var CHR_1 = String.fromCharCode(1);
var CHR_2 = String.fromCharCode(2);
var CHR_3 = String.fromCharCode(3);
var CHR_4 = String.fromCharCode(4);
var CHR_5 = String.fromCharCode(5);
var CHR_6 = String.fromCharCode(6);
var CHR_7 = String.fromCharCode(7);
var CHR_8 = String.fromCharCode(8);

function InitCasesXCtlEvent(obj){
	obj.LoadEvent = function(args)
	{
		Common_SetValue('cbgViewType','1');
		Common_SetValue('cbgAdmStatus','1');
		Common_SetValue('cbgScreenGrade','3,2');
		//Common_SetValue('cbgHandleGrade','4,3,2,1');
		
		var curDate = new Date();
		var preDate = new Date(curDate.getTime() - 24*60*60*1000);
		var timeYesterday = preDate.format("Y") +"-" +preDate.format("m") + "-"+(preDate.format("d"));
		Common_SetValue('txtDateFrom',timeYesterday);
		Common_SetValue('txtDateTo',timeYesterday);
		
		Common_SetValue('cbgAdmStatusX','1');
		Common_SetValue('cbgHandleGradeX','4,3,2,1');
		Common_SetValue('cbgScreenGradeX','1');
		
		obj.btnQryScreenCases.on("click",obj.btnQryScreenCases_onClick,obj);
		obj.btnQryHandleCases.on("click",obj.btnQryHandleCases_onClick,obj);
		
		//加载页面时自动筛查病例
    	obj.btnQryScreenCases_onClick();
  	};
	
	obj.CheckDays = function(aDateFrom, aDateTo, aDays)
	{
		if ((aDateFrom == '')||(aDateTo == '')) {
			ExtTool.alert('错误提示','开始日期和结束日期不允许为空!');
			return false;
		}
		var arr1 = aDateFrom.split('-');
		var arr2 = aDateTo.split('-');
		var d1=new Date(arr1[0],arr1[1],arr1[2]);
		var d2=new Date(arr2[0],arr2[1],arr2[2]);
		var Days = ((d2.getTime()-d1.getTime())/(1000*3600*24));
		if (Days < 0) {
			ExtTool.alert('错误提示','开始日期不能大于结束日期!');
			return false;
		}
		if (Days > aDays) {
			ExtTool.alert('错误提示','日期间隔不能大于' + aDays + '天!');
			return false;
		}
		return true;
	}
	
	//筛查病例查询
	obj.btnQryScreenCases_onClick = function()
	{
		var DateFrom = Common_GetValue('txtDateFrom');
		var DateTo = Common_GetValue('txtDateTo');
		var flg = obj.CheckDays(DateFrom,DateTo,3);
		if (flg != true) return;
		
		obj.ArgumentData.ViewType = Common_GetValue('cbgViewType');
		obj.ArgumentData.QueryType = "1";
		obj.ArgumentData.DateFrom = Common_GetValue('txtDateFrom');
		obj.ArgumentData.DateTo = Common_GetValue('txtDateTo');
		obj.ArgumentData.AdmStatus = Common_GetValue('cbgAdmStatus');
		obj.ArgumentData.ScreenGrade = Common_GetValue('cbgScreenGrade');
		obj.ArgumentData.HandleGrade = Common_GetValue('cbgHandleGrade');
		obj.ArgumentData.LogonHospID = Common_GetValue('cboSSHosp');
		
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCMed.NINFService.BC.CasesXSrv',
				QueryName : 'QryCasesXPatList',
				Arg1 : SubjectCode,
				Arg2 : obj.ArgumentData.DateFrom,
				Arg3 : obj.ArgumentData.DateTo,
				Arg4 : obj.ArgumentData.AdmStatus,
				Arg5 : obj.ArgumentData.ScreenGrade,
				Arg6 : obj.ArgumentData.HandleGrade,
				Arg7 : obj.ArgumentData.LogonHospID,
				Arg8 : '',
				ArgCnt : 8
			},
			success: function(response, opts) {
				var objData = Ext.decode(response.responseText);
				
				//初始化科室组数据(obj.LocGrpData)
				obj.LocGrpData = new Object();
				//处理科室组数据(obj.LocGrpData)
				obj.ProcLocGrpData(objData,obj.ArgumentData.ViewType);
				
				obj.LocXTemplate.overwrite("LocXTemplateDIV", obj.LocGrpData);
				obj.PatXTemplate.overwrite("PatXTemplateDIV",[]);
				
				if (obj.ArgumentData.DisplayType == 1) {
					obj.LoadLocPatientList(obj.ArgumentData.DisplayLoc);
				}else if (obj.ArgumentData.DisplayType == 2) {
					obj.LoadLocGrpPatientList(obj.ArgumentData.DisplayLoc);
				} else {
					obj.LoadLocPatientList(0);
				}
			},
			failure: function(response, opts) {
				var objTargetElement = document.getElementById("PatXTemplateDIV");
				if (objTargetElement) {
					objTargetElement.innerHTML = response.responseText;
				}
			}
		});
	}
	
	//处置病例查询
	obj.btnQryHandleCases_onClick = function()
	{
		var DateFrom = Common_GetValue('txtDateFromX');
		var DateTo = Common_GetValue('txtDateToX');
		var flg = obj.CheckDays(DateFrom,DateTo,10);
		if (flg != true) return;
		
		obj.ArgumentData.ViewType = Common_GetValue('cbgViewType');
		obj.ArgumentData.QueryType = "2";
		obj.ArgumentData.DateFrom = Common_GetValue('txtDateFromX');
		obj.ArgumentData.DateTo = Common_GetValue('txtDateToX');
		obj.ArgumentData.AdmStatus = Common_GetValue('cbgAdmStatusX');
		obj.ArgumentData.HandleGrade = Common_GetValue('cbgHandleGradeX');
		obj.ArgumentData.ScreenGrade = Common_GetValue('cbgScreenGradeX');
		obj.ArgumentData.LogonHospID = Common_GetValue('cboSSHosp');
		
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCMed.NINFService.BC.CasesXSrv',
				QueryName : 'QryCasesPatList',
				Arg1 : SubjectCode,
				Arg2 : obj.ArgumentData.DateFrom,
				Arg3 : obj.ArgumentData.DateTo,
				Arg4 : obj.ArgumentData.AdmStatus,
				Arg5 : obj.ArgumentData.HandleGrade,
				Arg6 : obj.ArgumentData.ScreenGrade,
				Arg7 : obj.ArgumentData.LogonHospID,
				Arg8 : '',
				ArgCnt : 8
			},
			success: function(response, opts) {
				var objData = Ext.decode(response.responseText);
				
				//初始化科室组数据(obj.LocGrpData)
				obj.LocGrpData = new Object();
				//处理科室组数据(obj.LocGrpData)
				obj.ProcLocGrpData(objData,obj.ArgumentData.ViewType);
				
				obj.LocXTemplate.overwrite("LocXTemplateDIV", obj.LocGrpData);
				obj.PatXTemplate.overwrite("PatXTemplateDIV",[]);
				
				if (obj.ArgumentData.DisplayType == 1) {
					obj.LoadLocPatientList(obj.ArgumentData.DisplayLoc);
				}else if (obj.ArgumentData.DisplayType == 2) {
					obj.LoadLocGrpPatientList(obj.ArgumentData.DisplayLoc);
				} else {
					obj.LoadLocPatientList(0);
				}
			},
			failure: function(response, opts) {
				var objTargetElement = document.getElementById("PatXTemplateDIV");
				if (objTargetElement) {
					objTargetElement.innerHTML = response.responseText;
				}
			}
		});
	}
	
	//处理科室组数据(obj.LocGrpData)
	obj.ProcLocGrpData = function(objData,aViewType)
	{
		obj.LocGrpData.LocGrpList = new Array();
		obj.LocGrpData.LocGrpListI = new Array();
		obj.LocGrpData.HospIPCount = 0;
		obj.LocGrpData.HospCount = 0;
		
		//加载科室在院患者数
		var tmpIPCount=ExtTool.RunServerMethod("DHCMed.NINFService.BC.CasesXSrv", "GetLocIPCount", obj.ArgumentData.DateFrom, obj.ArgumentData.DateTo, '');
		var arrIPCount = new Array();
		arrIPCount = tmpIPCount.split(CHR_1);
		for (var indCount = 0; indCount < arrIPCount.length; indCount++){
			var tmpLocIPCount = arrIPCount[indCount];
			if (tmpLocIPCount == '') continue;
			var arrLocIPCount = tmpLocIPCount.split(CHR_2);
			
			if (aViewType == '1') {
				if (arrLocIPCount[1] != 'E') continue;
				var LocID = arrLocIPCount[0];
				var LocDesc = arrLocIPCount[3];
				var LocGrpDesc = arrLocIPCount[4];
				var LocIPCount = arrLocIPCount[2];
			} else {
				if (arrLocIPCount[1] != 'W') continue;
				var LocID = arrLocIPCount[0];
				var LocDesc = arrLocIPCount[3];
				var LocGrpDesc = arrLocIPCount[4];
				var LocIPCount = arrLocIPCount[2];
			}
			
			if (typeof(obj.LocGrpData.LocGrpListI[LocGrpDesc]) != 'undefined') {
				var ind = obj.LocGrpData.LocGrpListI[LocGrpDesc];
				var objLocGroup = obj.LocGrpData.LocGrpList[ind];
			} else {
				var objLocGroup = {
					LocGrpDesc : LocGrpDesc,
					LocGrpCount : 0,
					LocGrpIPCount : 0,
					LocList : new Array(),
					LocListI : new Array()
				};
				var ind = obj.LocGrpData.LocGrpList.length;
				obj.LocGrpData.LocGrpList[ind] = objLocGroup;
				obj.LocGrpData.LocGrpListI[LocGrpDesc] = ind;
			}
			
			var objLoc = {
				LocID : LocID,
				LocDesc : LocDesc,
				LocGrpDesc : LocGrpDesc,
				LocCount : 0,
				LocIPCount : LocIPCount,
				PatList : new Array()
			};
			var ind = objLocGroup.LocList.length;
			objLocGroup.LocList[ind] = objLoc;
			objLocGroup.LocListI[LocDesc] = ind;
			
			objLocGroup.LocGrpIPCount = parseInt(objLocGroup.LocGrpIPCount) + parseInt(LocIPCount);
			var ind = obj.LocGrpData.LocGrpListI[LocGrpDesc];
			obj.LocGrpData.LocGrpList[ind] = objLocGroup;
			
			obj.LocGrpData.HospIPCount = parseInt(obj.LocGrpData.HospIPCount) + parseInt(LocIPCount);
		}
		
		var objItem = null;
		for(var i = 0; i < objData.total; i ++)
		{
			objItem = objData.record[i];
			if (!objItem) continue;
			var EpisodeID = objItem.EpisodeID;
			
			if (aViewType == '1') {
				var LocID = objItem.LocID;
				var LocDesc = objItem.LocDesc;
				var LocGrpDesc = objItem.LocGrp;
				var InHospLocDesc = objItem.InHospLoc;
				var InLocDate = objItem.InLocDate;
				var InLocTime = objItem.InLocTime;
			} else {
				var LocID = objItem.WardID;
				var LocDesc = objItem.WardDesc;
				var LocGrpDesc = objItem.WardGrp;
				var InHospLocDesc = objItem.InHospWard;
				var InLocDate = objItem.InWardDate;
				var InLocTime = objItem.InWardTime;
			}
			
			if (typeof(obj.LocGrpData.LocGrpListI[LocGrpDesc]) != 'undefined') {
				var ind = obj.LocGrpData.LocGrpListI[LocGrpDesc];
				var objLocGroup = obj.LocGrpData.LocGrpList[ind];
				
				if (typeof(objLocGroup.LocListI[LocDesc]) != 'undefined') {
					var ind = objLocGroup.LocListI[LocDesc];
					var objLoc = objLocGroup.LocList[ind];
				} else {
					var objLoc = {
						LocID : LocID,
						LocDesc : LocDesc,
						LocGrpDesc : LocGrpDesc,
						LocCount : 0,
						LocIPCount : 0,
						PatList : new Array()
					};
					var ind = objLocGroup.LocList.length;
					objLocGroup.LocList[ind] = objLoc;
					objLocGroup.LocListI[LocDesc] = ind;
				}
			} else {
				var objLocGroup = {
					LocGrpDesc : LocGrpDesc,
					LocGrpCount : 0,
					LocGrpIPCount : 0,
					LocList : new Array(),
					LocListI : new Array()
				};
				var objLoc = {
					LocID : LocID,
					LocDesc : LocDesc,
					LocGrpDesc : LocGrpDesc,
					LocCount : 0,
					LocIPCount : 0,
					PatList : new Array()
				};
				var ind = objLocGroup.LocList.length;
				objLocGroup.LocList[ind] = objLoc;
				objLocGroup.LocListI[LocDesc] = ind;
				
				var ind = obj.LocGrpData.LocGrpList.length;
				obj.LocGrpData.LocGrpList[ind] = objLocGroup;
				obj.LocGrpData.LocGrpListI[LocGrpDesc] = ind;
			}
			var ind = objLoc.PatList.length;
			objLoc.PatList[ind] = objItem;
			objLoc.LocCount++;
			var ind = objLocGroup.LocListI[LocDesc];
			objLocGroup.LocList[ind] = objLoc;
			objLocGroup.LocGrpCount++;
			var ind = obj.LocGrpData.LocGrpListI[LocGrpDesc];
			obj.LocGrpData.LocGrpList[ind] = objLocGroup;
			obj.LocGrpData.HospCount++;
		}
		
		//科室排序
		for(var indLocGroup = 0; indLocGroup < obj.LocGrpData.LocGrpList.length; indLocGroup++)
		{
			var objLocGroup = obj.LocGrpData.LocGrpList[indLocGroup];
			obj.bubbleSortLoc(objLocGroup.LocList);
		}
		
		//科室组排序
		obj.bubbleSortLocGrp(obj.LocGrpData.LocGrpList);
		
		if (obj.LocGrpData.HospCount != 0)
		{
			obj.NorthPanel.collapse();			
		}
	}
	
	obj.bubbleSortLoc = function(array)
	{
		var i = 0, len = array.length,j,d;
		for(; i<len; i++){ 
			for(j=0; j<len; j++){
				if(array[i].LocID < array[j].LocID){  
					d = array[j];  
					array[j] = array[i];  
					array[i] = d;  
				}
			}
		}
		return array;
	}
	
	obj.bubbleSortLocGrp = function(array)
	{
		var i = 0, len = array.length,j,d;
		for(; i<len; i++){ 
			for(j=0; j<len; j++){
				if(array[i].LocGrpDesc < array[j].LocGrpDesc){
					d = array[j];
					array[j] = array[i];
					array[i] = d;  
				}
			}
		}
		return array;
	}
	
	obj.LoadLocPatientList = function(aLocID)
	{
		obj.ArgumentData.DisplayType = 1;
		obj.ArgumentData.DisplayLoc = aLocID;
		for (var indLocGrp = 0; indLocGrp < obj.LocGrpData.LocGrpList.length; indLocGrp++) {
			var objLocGroup = obj.LocGrpData.LocGrpList[indLocGrp];
			
			for (var indLoc = 0; indLoc < objLocGroup.LocList.length; indLoc++) {
				var objLoc = objLocGroup.LocList[indLoc];
				
				if ((aLocID == 0)&&(objLoc.LocCount != 0)) {
					obj.PatXTemplate.overwrite("PatXTemplateDIV",[objLoc]);
					for (var indPat = 0; indPat < objLoc.PatList.length; indPat++) {
						var objPatient = objLoc.PatList[indPat];
						obj.LoadAdmCasesX(objPatient);
					}
					return;
				} else {
					if (objLoc.LocID == aLocID) {
						obj.PatXTemplate.overwrite("PatXTemplateDIV",[objLoc]);
						for (var indPat = 0; indPat < objLoc.PatList.length; indPat++) {
							var objPatient = objLoc.PatList[indPat];
							obj.LoadAdmCasesX(objPatient);
						}
						return;
					}
				}
			}
		}
	}
	
	obj.LoadLocGrpPatientList = function(aLocGrpDesc)
	{
		obj.ArgumentData.DisplayType = 2;
		obj.ArgumentData.DisplayLoc = aLocGrpDesc;
		for (var indLocGrp = 0; indLocGrp < obj.LocGrpData.LocGrpList.length; indLocGrp++) {
			var objLocGroup = obj.LocGrpData.LocGrpList[indLocGrp];
			
			if (objLocGroup.LocGrpDesc == aLocGrpDesc) {
				obj.PatXTemplate.overwrite("PatXTemplateDIV",objLocGroup.LocList);
				for (var indLoc = 0; indLoc < objLocGroup.LocList.length; indLoc++) {
					var objLoc = objLocGroup.LocList[indLoc];
					for (var indPat = 0; indPat < objLoc.PatList.length; indPat++) {
						var objPatient = objLoc.PatList[indPat];
						obj.LoadAdmCasesX(objPatient);
					}
				}
				return;
			}
		}
	}
	
	obj.LoadAdmCasesX = function(objPatient)
	{
		if (!objPatient) return;
		var EpisodeID = objPatient.EpisodeID;
		var CasesXDates = objPatient.CasesXDates;
		obj.LoadCasesXDtl("divPatCasesX-" + EpisodeID,SubjectCode,EpisodeID,CasesXDates);
	}
	
	obj.UpLoadCasesXDtl = function(){
		if (obj.ArgumentData.QueryType == '1'){
			obj.btnQryScreenCases_onClick();
		} else {
			obj.btnQryHandleCases_onClick();
		}
	}
}