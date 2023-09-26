
function InitwinSendFeedbackEvent(obj) {
	obj.LoadEvent = function(args)
	{
		var SummaryID = args[0];
		var LnkSummaryIDs = args[1];
		obj.callback = args[2];
		obj.callbackScope = args[3];
		obj.objCurrentSummary = ExtTool.RunServerMethod("DHCMed.CC.CtlSummary", "GetObjById", SummaryID);
		obj.objCurrentAdm = ExtTool.RunServerMethod("DHCMed.Base.PatientAdm", "GetObjById", obj.objCurrentSummary.EpisodeID);
		obj.cboToDepartmentStore.load({
			callback : function(){
				obj.cboToDepartment.setValue(obj.objCurrentAdm.DepartmentID);
			}
		});
		obj.cboToDoctor.setValue(obj.objCurrentAdm.DoctorName);
		var strDoctor = ExtTool.RunServerMethod("DHCMed.Base.SSUser", "GetByCTPCP", obj.objCurrentAdm.DoctorID, "^");
		var arryField = strDoctor.split("^");
		obj.cboToDoctorStore.load({
			callback : function(){
				obj.cboToDoctor.setValue(arryField[0]);
			}
		});
		//Add By LiYang 2013-03-27
		obj.cboRepTypeStore.load({});
	};
	
	obj.cboMarkColor_beforeselect = function(objCbo, objRec)
	{
		obj.txtNotice.setValue(objRec.get("Description"));
		return true;
	};

	obj.cboRepTypeStore.load({
			callback : function(){
				if(obj.cboRepTypeStore.getCount() == 0)
					return;
				//Modified By LiYang 2013-04-07根据报告筛选报告类别
				if((RepType == "")||(RepType == null))
				{
					var objRec = obj.cboRepTypeStore.getAt(0);
					obj.cboRepType.setValue(objRec.get("Code"));
				}
				else
				{
					obj.cboRepType.setValue(RepType);
				}
				
			}
	});

	
	obj.SaveFeedBack = function()
	{
		var strArg = "";
		var delimiter = "^";
		strArg += "" + delimiter;
		strArg += obj.objCurrentSummary.EpisodeID + delimiter;
		strArg += obj.objCurrentSummary.RowID + delimiter;
		strArg += obj.objCurrentSummary.SubjectID + delimiter;
		strArg += obj.cboToDepartment.getValue() + delimiter;
		strArg += obj.cboToDoctor.getValue() + delimiter;
		strArg += obj.txtNotice.getValue() + delimiter;
		strArg += session['LOGON.USERID'] + delimiter;
		strArg += delimiter; //Date
		strArg += delimiter; //time
		strArg += obj.cboRepType.getValue();
		var ret = ExtTool.RunServerMethod("DHCMed.CC.CtlFeedback", "RecordNewFeedback", strArg, delimiter);
		if (parseInt(ret)>0) {
			//处理关联Summary状态
			var flg = ExtTool.RunServerMethod("DHCMed.CC.CtlSummary", "ProcessLnkSummary", obj.objCurrentSummary.RowID, obj.LnkSummaryIDs);
		}
		return ret;
	}
	
	obj.SaveMsg = function()
	{
		var strArg = "";
		strArg += "^";
		strArg += obj.objCurrentSummary.EpisodeID + "^";
		strArg += obj.objCurrentSummary.SubjectID  + "^";
		strArg += obj.txtNotice.getValue() + "^";
		strArg += session['LOGON.USERID'] + "^";
		strArg += "^";
		strArg += "^";
		strArg += "" + "^";
		var ret = ExtTool.RunServerMethod("DHCMed.CC.CtlMessage", "Update", strArg, "^");
		return ret;
	}	
	
	obj.SendMsgToUser = function()
	{
		var CHR_1 = String.fromCharCode(1);
		var objMess = ExtTool.StaticServerObject("DHCMed.SSService.MessageSrv");
		obj.objCurrentPat = ExtTool.RunServerMethod("DHCMed.Base.Patient", "GetObjById", obj.objCurrentAdm.PatientID);
		var PatientName=obj.objCurrentPat.PatientName
		if (PatientName=="") return;
		
		var strArg = session['LOGON.USERID'] + "^";
		strArg += "感控科提示：患者 " + PatientName + " " + obj.txtNotice.getValue() + CHR_1;
		strArg += obj.cboToDoctor.getValue() ;
	
    	var ret=objMess.SendMessageToUser(strArg);
    	return ret;
	}
	
	obj.btnOK_click = function()
	{
		if(obj.cboToDepartment.getValue() == "")
		{
			ExtTool.alert("提示", "请填写【目标科室】信息!", Ext.MessageBox.INFO);
			return ;
		}
		if(obj.cboToDoctor.getValue() == "")
		{
			ExtTool.alert("提示", "请填写【目标医师】信息!", Ext.MessageBox.INFO);
			return ;
		}		
		if(obj.cboRepType.getValue() == "")
		{
			ExtTool.alert("提示", "请填写【提示报告类别】信息!", Ext.MessageBox.INFO);
			return ;			
		}
		var ret = obj.SaveFeedBack();
		var ret1 = obj.SaveMsg();
		var ret2 = obj.SendMsgToUser();
		if(ret > 0)
		{
			ExtTool.alert("提示", "反馈发送成功!", Ext.MessageBox.INFO);
			if(obj.callback != null) //刷新显示结果
				obj.callback.call(null, null, null, null, null, null ,true, obj.callbackScope); //Modified By LiYang 2013-03-20 显示详细列表页签
			obj.btnCancel_click();
		}
		else
			ExtTool.alert("提示", "反馈发送失败,返回值：" + ret + "!", Ext.MessageBox.ERROR);
		
	};
	obj.btnCancel_click = function()
	{
		obj.winSendFeedback.close();
	};
/*winSendFeedback新增代码占位符*/}

