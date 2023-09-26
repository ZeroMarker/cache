function InitFormQryEvent(obj){
	obj.LoadEvent = function(args)
	{
		obj.btnQuery.on("click",obj.btnQuery_onClick,obj);
		obj.btnExport.on("click", obj.btnExport_onClick, obj);
		
		obj.CurrTypeIndex = -1;
		obj.btnRepType_OnClick(-1);
  	};
	
	//报告列表导出
	obj.btnExport_onClick = function()
	{
		if (obj.CurrTypeIndex == -1) return;
		var objRepType = obj.RepTypeList[obj.CurrTypeIndex];
		if (!objRepType) return;
		var objForm = ExtTool.RunServerMethod("DHCMed.CR.PO.Form", "GetObjById", objRepType.TypeCode);
		if (!objForm) return;
		FormExport.TemplateFileName = "../../med/Results/Template/" + objForm.ESchema + "." + objForm.Type + "." + objForm.EName + ".xlt";
		FormExport.LoadDataToArray(
			objForm.ESchema + "." + objForm.Type + "." + objForm.EName
			,objRepType.ReportList //obj.GridStore
			,FormExport.ExportToExcel
			,FormExport
		);
	}
	
	//报告类型单击事件
	obj.btnRepType_OnClick = function(aTypeIndex)
	{
		obj.CurrTypeIndex = aTypeIndex;
		if (obj.CurrTypeIndex == -1) {
			if (obj.RepTypeList.length > 0) {
				obj.CurrTypeIndex = 0;
			}
		}
		if (obj.CurrTypeIndex == -1) return;
		obj.LoadReportData(obj.CurrTypeIndex);
		//setTimeout('objScreen.ViewReportData(' + obj.CurrTypeIndex + ')',1000);
	}
	
	//查询按钮单击事件
	obj.btnQuery_onClick = function()
	{
		if (obj.CurrTypeIndex == -1) return;
		obj.LoadReportData(obj.CurrTypeIndex);
		//setTimeout('objScreen.ViewReportData(' + obj.CurrTypeIndex + ')',1000);
	}
	
	//显示报告信息
	obj.ViewReportData = function(aTypeIndex)
	{
		if (aTypeIndex == -1) {
			obj.RepXTemplate.overwrite("RepXTemplateDIV", obj.RepTypeList);
		} else {
			obj.RepXTemplate.overwrite("RepXTemplateDIV", [obj.RepTypeList[aTypeIndex]]);
		}
	}
	
	//加载报告数据
	obj.LoadReportData = function(aTypeIndex)
	{
		for (var indRepType = 0; indRepType < obj.RepTypeList.length; indRepType++) {
			if ((aTypeIndex != -1)&&(aTypeIndex != indRepType)) continue;
			
			var objRepType = obj.RepTypeList[indRepType];
			if (objRepType.TypeCate == 'CRF') {
				obj.LoadCRFData(indRepType,'ErrXTemplateDIV');
			}
		}
	}
	
	obj.GetStatusList = function() {
		var StatusList = "*";
		var objStatusList = obj.cbgRepStatus.getValue();
		for (var statusIndex = 0; statusIndex < objStatusList.length; statusIndex++) {
			StatusList = StatusList + objStatusList[statusIndex].inputValue + "*";
		}
		return StatusList;
	};
	
	//加载自定义表单数据
	obj.LoadCRFData = function(indType)
	{
		obj.ArgumentData = new Object();
		obj.ArgumentData.DateFrom = obj.txtDateFrom.getRawValue();
		obj.ArgumentData.DateTo = obj.txtDateTo.getRawValue();
		if (document.getElementById('cboRepLoc')) {
			obj.ArgumentData.RepLocID = obj.cboRepLoc.getValue();
		} else {
			obj.ArgumentData.RepLocID = '';
		}
		obj.ArgumentData.StatusList = obj.GetStatusList();
		obj.ArgumentData.FormId = obj.RepTypeList[indType].TypeCode;
		if (IsHospitalGroup == 1) {
			obj.ArgumentData.HospitalID = LogonHospID;
		} else {
			if (document.getElementById('cboHospital')) {
				obj.ArgumentData.HospitalID = obj.cboHospital.getValue();
			} else {
				obj.ArgumentData.HospitalID = '';
			}
		}
		
		obj.RepTypeList[indType].ReportList.length = 0;
		obj.RepTypeList[indType].ReportCount = 0;
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCMed.CR.BO.FormQry',
				QueryName : 'QueryCRFReport',
				Arg1 : obj.ArgumentData.DateFrom,
				Arg2 : obj.ArgumentData.DateTo,
				Arg3 : obj.ArgumentData.RepLocID,     //报告科室
				Arg4 : obj.ArgumentData.StatusList,   //报告状态
				Arg5 : obj.ArgumentData.FormId,
				Arg6 : obj.ArgumentData.HospitalID,
				ArgCnt : 6
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
				
				obj.ViewReportData(obj.CurrTypeIndex);
			},
			failure: function(response, opts) {
				var objTargetElement = document.getElementById(errDiv);
				if (objTargetElement) {
					objTargetElement.innerHTML = response.responseText;
				}
			}
		});
	}
	
	obj.LnkRepOnClick = function(aTypeCate,aTypeCode,aDataId){
		if (aTypeCate == 'CRF'){
			var strClassName = ExtTool.RunServerMethod("DHCMed.CR.PO.Form", "GetClassNameById",aTypeCode);
			if (!strClassName) return;
			var LocFlag="";
			if(aDataId!=""){
				LocFlag=tDHCMedMenuOper['AllowAudit'];
			}
			var lnk = "dhcmed.crf.reportfrom.csp?a=a"
				+ "&EpisodeID=" + ''
				+ "&PatientID=" + ''
				+ "&GoalUserID=" + session['LOGON.USERID']
				+ "&FormCode=" + strClassName
				+ "&Caption=" + ''
				+ "&DataID=" + aDataId
				+ "&LocFlag=" + LocFlag;
			var ret=window.showModalDialog(lnk, null, "dialogHeight:600px;dialogWidth:850px;center:yes;scroll:no;toolbar=no;menubar=no;location=no;");	
			if (ret>0) obj.btnRepType_OnClick(obj.CurrTypeIndex);
		}
	}
}