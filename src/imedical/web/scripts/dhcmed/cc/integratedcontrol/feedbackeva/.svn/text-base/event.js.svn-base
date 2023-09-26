
function InitwinFeedbackEvaEvent(obj) {
	obj.LoadEvent = function(args)
	{
		obj.CurrentFeedBackID = args[0];
		obj.LnkFeedBackIDs = args[1];
		obj.SrcElement = args[2];
		
		obj.cboInCorrectReasonStore.load({
			callback : function(){
				ExtTool.SelectFirstItem(obj.cboInCorrectReason);
				var objEva = ExtTool.RunServerMethod("DHCMed.CC.CtlFeedbackEva","GetObjByFeedBackID", obj.CurrentFeedBackID);
				if(objEva != "")
				{
					obj.rdoCorrect.setValue(objEva.IsCorrect == 1);
					obj.rdoInCorrect.setValue(objEva.IsCorrect != 1);
					
					obj.rdoReportOnTime.setValue(objEva.ReportOnTime == 1);
					obj.rdoReportLate.setValue(objEva.ReportOnTime == 2);
					obj.rdoNotReport.setValue(objEva.ReportOnTime == 3);
					
					obj.cboInCorrectReason.setValue(objEva.InCorrectReason);
					
					obj.txtResumeText.setValue(objEva.ResumeText);
				}
			}
		});
	};
	
	obj.Save = function(){
		var delimiter = "^";
		var strArg = "" + delimiter;
		strArg += obj.CurrentFeedBackID + delimiter;
		strArg += (obj.rdoCorrect.getValue() ? 1 : 0) + delimiter;
		strArg += obj.cboInCorrectReason.getValue() + delimiter;
		if(obj.rdoReportOnTime.getValue())
			strArg += 1 + delimiter;
		if(obj.rdoReportLate.getValue())
			strArg += 2 + delimiter;	
		if(obj.rdoNotReport.getValue())
			strArg += 3 + delimiter;				
		strArg += obj.txtResumeText.getValue() + delimiter;
		//var ret = ExtTool.RunServerMethod("DHCMed.CC.CtlFeedbackEva", "Update", strArg, delimiter);
		var ret = ExtTool.RunServerMethod("DHCMed.CC.CtlFeedbackEva", "ProcessFeedbackEva", strArg, delimiter, obj.LnkFeedBackIDs);
		return ret;
	}
	
	obj.btnOK_click = function()
	{
		var ret = obj.Save();
		if(ret > 0)
		{
			ExtTool.alert("提示", "保存成功！", Ext.MessageBox.INFO);
			obj.winFeedbackEva.close();
			if(obj.SrcElement)
			{
				obj.SrcElement.innerHTML = '<img src="../scripts/dhcmed/img/sysconfig.gif"/>已评估';
				obj.SrcElement.disabled = true;
			}
		}else
		{
			ExtTool.alert("错误", "保存失败！返回代码：" + ret, Ext.MessageBox.INFO);
		}
	};
	obj.btnCancel_click = function()
	{
		obj.winFeedbackEva.close();
	};
/*winFeedbackEva新增代码占位符*/}

