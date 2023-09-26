function InitClinRepToUserEvent(obj){
	obj.LoadEvent = function(args)
	{
		obj.btnQuery.on("click",obj.btnQuery_onClick,obj);
		
		obj.CurrTypeIndex = -1;
		obj.btnRepType_OnClick(-1);
  	};
	
	//报告类型单击事件
	obj.btnRepType_OnClick = function(aTypeIndex)
	{
		obj.CurrTypeIndex = aTypeIndex;
		obj.LoadReportData(aTypeIndex);
		setTimeout('objScreen.ViewReportData(' + aTypeIndex + ')',500);
	}
	
	//查询按钮单击事件
	obj.btnQuery_onClick = function()
	{
		var TypeIndex = obj.CurrTypeIndex;
		obj.LoadReportData(TypeIndex);
		setTimeout('objScreen.ViewReportData(' + TypeIndex + ')',500);
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
	
	//加载自定义表单数据
	obj.LoadCRFData = function(indType)
	{
		obj.ArgumentData = new Object();
		obj.ArgumentData.DateFrom = obj.txtDateFrom.getRawValue();
		obj.ArgumentData.DateTo = obj.txtDateTo.getRawValue();
		if (document.getElementById('cboRepLoc')) {
			obj.ArgumentData.RepLocID = cboRepLoc.getValue();
		} else {
			obj.ArgumentData.RepLocID = LogonLocID;
		}
		obj.ArgumentData.StatusList = '';
		obj.ArgumentData.FormId = obj.RepTypeList[indType].TypeCode;
		obj.ArgumentData.LogonHospID = LogonHospID;
		
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
				Arg3 : obj.ArgumentData.RepLocID,    //报告科室
				Arg4 : obj.ArgumentData.StatusList,  //报告状态
				Arg5 : obj.ArgumentData.FormId,
				Arg6 : obj.ArgumentData.LogonHospID,
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
			var lnk = "dhcmed.crf.reportfrom.csp?a=a"
				+ "&EpisodeID=" + ''
				+ "&PatientID=" + ''
				+ "&GoalUserID=" + session['LOGON.USERID']
				+ "&FormCode=" + strClassName
				+ "&Caption=" + ''
				+ "&DataID=" + aDataId
				+ "&LocFlag=";
			var ret=window.showModalDialog(lnk, null, "dialogHeight:600px;dialogWidth:850px;center:yes;scroll:no;toolbar=no;menubar=no;location=no;");	
			if (ret>0) obj.btnRepType_OnClick(obj.CurrTypeIndex);
		}
	}
	
	obj.ExportOnClick = function(aTypeCate,aTypeCode){
		var RepType="";
		if (obj.CurrTypeIndex == -1) //return;
		{
			for (var indRepType = 0; indRepType < obj.RepTypeList.length; indRepType++) {
				var objRepType = obj.RepTypeList[indRepType];
				if(objRepType.TypeCode==aTypeCode)
				{
					RepType = indRepType
					break;
				}
			}
		}
		else{
			RepType = obj.CurrTypeIndex;
		}
		var objRepType = obj.RepTypeList[RepType];
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
}