
function InitViewport1Event(obj) {
	obj.ClsInfUncountSrv = ExtTool.StaticServerObject("DHCMed.NINF.Rep.InfUncount");

	obj.LoadEvent = function(args)
    	{
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.gridInfUncount.on("rowclick",obj.gridInfUncount_rowclick,obj);
		obj.gridInfUncountStore.load({});
		
		var objs=document.getElementById("txtRegNo");
		if (objs){
			objs.onkeydown=obj.txtRegNo_click;
		}
  	};
	
	obj.txtRegNo_click = function()
	{
		if(window.event.keyCode != 13)
		return;
		obj.txtAdmInfoStore.load({});
	}
	obj.ClearFormItem = function()
	{
		obj.RecRowID = "";
		Common_SetValue("txtUser","");
		Common_SetValue("txtRegNo","");
		Common_SetValue("txtResume","");
		Common_SetValue("cboLoc","");
		Common_SetValue("chkIsActive",false);
		Common_SetValue("txtAdmInfo","");
		obj.txtAdmInfoStore.removeAll();
	}
	
	obj.btnUpdate_click = function()
	{
		var errinfo = "";
		var EpisodeID = obj.txtAdmInfo.getValue();
		var cboLoc = obj.cboLoc.getValue();
		var txtUser = obj.txtUser.getValue();
		var IsActive = Common_GetValue("chkIsActive");
		var Resume = Common_GetValue("txtResume");
		if (!EpisodeID) {
			errinfo = errinfo + "就诊信息!<br>";
		}
		if (!cboLoc) {
			errinfo = errinfo + "报告科室!<br>";
		}
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + EpisodeID;
		inputStr = inputStr + CHR_1 + cboLoc;
		inputStr = inputStr + CHR_1 + txtUser;
		inputStr = inputStr + CHR_1 + (IsActive ? '1' : '0');
		inputStr = inputStr + CHR_1 + Resume;
		var flg = obj.ClsInfUncountSrv.Update(inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == -100) {
				ExtTool.alert("错误提示","数据重复!Error=" + flg);
			} else {
				ExtTool.alert("错误提示","更新数据错误!Error=" + flg);
			}
			return;
		}
		
		obj.ClearFormItem();
		obj.gridInfUncountStore.load({});
	}
	obj.gridInfUncount_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridInfUncount.getStore().getAt(index);
		if (objRec.get("RepID") == obj.RecRowID) {
			obj.ClearFormItem();
		} else {
			obj.RecRowID = objRec.get("RepID");
			Common_SetValue("txtRegNo",objRec.get("PapmiNo"));
			Common_SetValue("txtUser",objRec.get("ReportUser"),objRec.get("UserName"));
			Common_SetValue("cboLoc",objRec.get("ReportLoc"),objRec.get("DescStr"));
			Common_SetValue("txtAdmInfo",objRec.get("EpisodeID"),objRec.get("AdmInfo"));
			Common_SetValue("chkIsActive",(objRec.get("Active")=='1'));
			Common_SetValue("txtResume",objRec.get("ResumeText"));
		}
	};
}

