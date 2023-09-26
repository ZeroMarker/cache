function InitwinCpwVarEditEvent(obj)
{
	obj.LoadEvent = function(args)
	{
		//obj.cboCategory.on("expand", obj.cboCategory_OnExpand, obj);
		obj.cboCategory.on("collapse", obj.cboCategory_OnCollapse, obj);
		//obj.cboReason.on("expand", obj.cboReason_OnExpand, obj);
		obj.btnSave.on("click", obj.btnSave_click, obj);
		obj.btnCancel.on("click", obj.btnCancel_click, obj);
		obj.cboCategory.on("select", obj.cboCategory_OnSelect, obj);
		obj.Args = args;
	}
	
	obj.cboCategory_OnExpand = function(){
		obj.cboCategory.clearValue();
		obj.cboCategoryStore.load({});
	}
	obj.cboCategory_OnCollapse = function(){
		obj.cboReason.clearValue();
	}
	obj.cboReason_OnExpand = function(){
		obj.cboReason.clearValue();
		obj.cboReasonStore.load({});
	}
	obj.cboCategory_OnSelect = function(){
		obj.cboReasonStore.load({});
	}
	obj.btnSave_click = function(){
		var InputErr="";
		var VarID="",VarDate="",VarTime="",VarDoctorID="";
		var PathWayID = obj.Args[1];
		var tmpArry = obj.Args[2].split("||");
		var VarEp = tmpArry[0] + "||" + tmpArry[1];
		var VarEpStep = tmpArry[0] + "||" + tmpArry[1] + "||" + tmpArry[2];
		var VarCateg = obj.cboCategory.getValue();
		var VarReason = obj.cboReason.getValue();
		var VarResume = obj.txtNote.getValue();
		var VarUserID = session['LOGON.USERID'];
		if ((!VarEpStep)||(!VarCateg)||(!VarReason)||(!PathWayID))  return false;
		
		if (!VarEpStep){
			InputErr = InputErr + "路径步骤为空,请认真填写!" + CHR_ER;
		}
		if (!VarCateg){
			InputErr = InputErr + "变异类型为空,请认真填写!" + CHR_ER;
		}
		if (!VarReason){
			InputErr = InputErr + "变异原因为空,请认真填写!" + CHR_ER;
		}
		
		if (InputErr) {
			ExtTool.alert("提示",InputErr);
			return false;
		}
		
		VarID=PathWayID;
		var objCTCareProvSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.CTCareProvSrv");
		var strDoctor=objCTCareProvSrv.GetCareProvByUserID(VarUserID);
		VarDoctorID=strDoctor.split("^")[0];
		
		var InputStr=VarID;
		InputStr=InputStr + "^" + VarEp;
		InputStr=InputStr + "^" + VarCateg;
		InputStr=InputStr + "^" + VarReason;
		InputStr=InputStr + "^" + VarUserID;
		InputStr=InputStr + "^" + VarDate;
		InputStr=InputStr + "^" + VarTime;
		InputStr=InputStr + "^" + VarDoctorID;
		InputStr=InputStr + "^" + VarResume;
		InputStr=InputStr + "^" + VarEpStep;
		var objMRClinicalPathWays = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWaysVariance");
		var ret = objMRClinicalPathWays.Update(InputStr);
		if (ret<0){
			ExtTool.alert("提示","更新失败!");
		} else {
			obj.winCpwVarEdit.close();
		}
	}
	
	obj.btnCancel_click = function(){
		obj.winCpwVarEdit.close();
	};
}
