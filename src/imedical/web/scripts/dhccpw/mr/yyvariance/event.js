function InitVarSubWindowEvent(obj) {
	obj.LoadEvent = function(args){
		obj.cboVarCateg.on("expand", obj.cboVarCateg_OnExpand, obj);
		obj.cboVarCateg.on("collapse", obj.cboVarCateg_OnCollapse, obj);
		obj.cboVarReason.on("expand", obj.cboVarReason_OnExpand, obj);
		obj.cboVarEp.on("expand", obj.cboVarEp_OnExpand, obj);
		obj.cboVarEp.on("collapse", obj.cboVarEp_OnCollapse, obj);
		obj.cboVarEpStep.on("expand", obj.cboVarEpStep_OnExpand, obj);
		obj.btnUpdateCPWV.on("click", obj.btnUpdateCPWV_OnClick, obj);
		obj.gpVarianceRst.on("rowclick", obj.gpVarianceRst_OnRowClick, obj);
	};
	obj.cboVarEp_OnExpand = function(){
		obj.cboVarEp.clearValue();
		obj.cboVarEpStore.load({});
	}
	obj.cboVarEp_OnCollapse = function(){
		obj.cboVarEpStep.clearValue();
	}
	obj.cboVarEpStep_OnExpand = function(){
		obj.cboVarEpStep.clearValue();
		obj.cboVarEpStepStore.load({});
	}
	obj.cboVarCateg_OnExpand = function(){
		obj.cboVarCateg.clearValue();
		obj.cboVarCategStore.load({});
	}
	obj.cboVarCateg_OnCollapse = function(){
		obj.cboVarReason.clearValue();
		obj.cboVarReasonStore.load({}); //Add By LiYang 2011-06-03 FixBug:76 选择类别后无法选择变异原因
	}
	obj.cboVarReason_OnExpand = function(){
		obj.cboVarReason.clearValue();
		obj.cboVarReasonStore.load({});
	}
	obj.btnUpdateCPWV_OnClick = function(){
		var InputErr="",InputSign="";
		var VarID="",VarEp="",VarEpStep="",VarCateg="",VarReason="",VarUserID="",VarDate="",VarTime="",VarDoctorID="",VarResume="";
		if (obj.cboVarEp.getValue()&&obj.cboVarEp.getRawValue()){
			VarEp=obj.cboVarEp.getValue();
		}else{
			InputErr = InputErr + "临床路径阶段为空,请认真填写!" + CHR_ER;
		}
		if (obj.cboVarEpStep.getValue()&&obj.cboVarEpStep.getRawValue()){
			VarEpStep=obj.cboVarEpStep.getValue();
		}else{
			InputErr = InputErr + "临床路径步骤为空,请认真填写!" + CHR_ER;
		}
		if (obj.cboVarCateg.getValue()&&obj.cboVarCateg.getRawValue()){
			VarCateg = obj.cboVarCateg.getValue();
		}else{
			InputErr = InputErr + "变异类型为空,请认真填写!" + CHR_ER;
		}
		if (obj.cboVarReason.getValue()&&obj.cboVarReason.getRawValue()){
			VarReason = obj.cboVarReason.getValue();
		}else{
			InputErr = InputErr + "变异原因为空,请认真填写!" + CHR_ER;
		}
		VarResume=obj.txtaVarResume.getValue();
		if (obj.CurrVarID){
			VarID=obj.CurrVarID;
			VarUserID=obj.CurrVarUserID;
			VarDate=obj.CurrVarDate;
			VarTime=obj.CurrVarTime;
			VarDoctorID=obj.CurrVarDoctorID;
		}else{
			VarID=obj.PathWayID
			VarUserID=obj.UserID;
			VarDate="";
			VarTime="";
			var objCTCareProvSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.CTCareProvSrv");
			var strDoctor=objCTCareProvSrv.GetCareProvByUserID(VarUserID);
			VarDoctorID=strDoctor.split("^")[0];
		}
		
		if (InputErr) {
			ExtTool.alert("提示",InputErr+InputSign);
			return;
		}else if (InputSign){
			ExtTool.alert("提示",InputSign);
		}
		
		//1:Rowid 2:VEpisodeDR 3:VCategoryDR 4:VReasonDR 5:VUserDR 6:VDate 7:VTime 8:VDoctorDR 9:VNote
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
			return;
		}
		obj.gpVarianceRstStore.load({});
		obj.ConditionSubPanel_ClearValue();
	}
	obj.ConditionSubPanel_ClearValue = function(){
		obj.CurrVarID="";
		obj.CurrVarUserID="";
		obj.CurrVarDate="";
		obj.CurrVarTime="";
		obj.CurrVarDoctorID="";
		obj.cboVarEp.setValue("");
		obj.cboVarEp.setRawValue("");
		obj.cboVarEpStep.setValue("");
		obj.cboVarEpStep.setRawValue("");
		obj.cboVarCateg.clearValue();
		obj.cboVarReason.clearValue();
		obj.txtaVarResume.setValue("");
	}
	obj.ConditionSubPanel_SetValue = function(objTableRow){
		obj.CurrVarID=objTableRow.get("VID");
		obj.CurrVarUserID=objTableRow.get("VUserDR");
		obj.CurrVarDate=objTableRow.get("VDate");
		obj.CurrVarTime=objTableRow.get("VTime");
		obj.CurrVarDoctorID=objTableRow.get("VDoctorDR");
		obj.cboVarEp.setValue(objTableRow.get("VEpisodeDR"));
		obj.cboVarEp.setRawValue(objTableRow.get("VEpisodeDesc"));
		obj.cboVarEpStep.setValue(objTableRow.get("VEpStepDR"));
		obj.cboVarEpStep.setRawValue(objTableRow.get("VEpStepDesc"));
		obj.cboVarCateg.clearValue();
		obj.cboVarCateg.setValue(objTableRow.get("VCategoryDR"));
		obj.cboVarCateg.setRawValue(objTableRow.get("VCategoryDesc"));
		obj.cboVarReason.clearValue();
		obj.cboVarReason.setValue(objTableRow.get("VReasonDR"));
		obj.cboVarReason.setRawValue(objTableRow.get("VReasonDesc"));
		obj.txtaVarResume.setValue(objTableRow.get("VNote"));
	}
	obj.gpVarianceRst_OnRowClick = function(){
		var rowIndex = arguments[1];
		var objRec = obj.gpVarianceRstStore.getAt(rowIndex);
		if (objRec.get("VID")==obj.CurrVarID){
			obj.ConditionSubPanel_ClearValue();
		}else{
			obj.ConditionSubPanel_SetValue(objRec);
		}
	}
}

function VarianceRecordHeader(PathWayID,UserID)
{
	var objVarSubWindow = new InitVarSubWindow(PathWayID,UserID);
	objVarSubWindow.VarSubWindow.show();
	var numTop=(screen.availHeight-objVarSubWindow.VarSubWindow.height)/2;
	var numLeft=(screen.availWidth-objVarSubWindow.VarSubWindow.width)/2;
	objVarSubWindow.VarSubWindow.setPosition(numLeft,numTop);
	ExtDeignerHelper.HandleResize(objVarSubWindow);
}