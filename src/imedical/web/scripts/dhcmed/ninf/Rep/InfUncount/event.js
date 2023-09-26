
function InitViewport1Event(obj) {
	obj.ClsInfUncountSrv = ExtTool.StaticServerObject("DHCMed.NINF.Rep.InfUncount");

	obj.LoadEvent = function(args)
    	{
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.gridInfUncount.on("rowclick",obj.gridInfUncount_rowclick,obj);
		obj.gridInfUncountStore.load({});
		obj.cboLoc.on("select",obj.cboLoc_select,obj);  //fix bug 120846 by pylian 根据科室过滤主管医生
		
		var objs=document.getElementById("txtRegNo");
		if (objs){
			objs.onkeydown=obj.txtRegNo_click;
		}
		
		//add by pylian 120847 加入监听，输入【登记号】回车不能自动补零 
		//输入框回车事件
		obj.txtRegNoENTER = function ()
		{
			var RegNo = obj.txtRegNo.getValue();
			RegNo=RegNo.replace(/(^\s*)|(\s*$)/g, "");
			var Reglength=RegNo.length
			for(var i=0;i<(10-Reglength);i++)
			{
				RegNo="0"+RegNo;
			}
			obj.txtRegNo.setValue(RegNo);
			
		}
		if (IsSecret!=1) {     //不涉密就隐藏【病人密级】和【病人级别】两列
			var cm = obj.gridInfUncount.getColumnModel();
    			var cfg = null;
    			for(var i=0;i<cm.config.length;++i)
   	 		{
	   	 		cfg = cm.config[i];
	   	 		if ((cfg.id=="Secret1")||(cfg.id=="Secret2")) {
					cm.setHidden(i,true);
	   	 		}
			}
		}
  	};
	
	obj.cboLoc_select = function(combo,record,index){	
		//加载医务人员
		Common_SetValue("txtUser","");
		obj.txtUser.getStore().load({});
	}
	
	
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
		obj.txtAdmInfoStore.load({}); //fix bug 111135 
		var errinfo = "";
		var RegNo=obj.txtRegNo.getValue();
		var EpisodeID = obj.txtAdmInfo.getValue();
		var cboLoc = obj.cboLoc.getValue();
		var txtUser = obj.txtUser.getValue();
		var IsActive = Common_GetValue("chkIsActive");
		var Resume = Common_GetValue("txtResume");
		if (!RegNo) {
			errinfo = errinfo + "登记号不能为空!<br>";
		}
		if (!EpisodeID) {
			errinfo = errinfo + "就诊信息不能为空!<br>";
		}
		if (!cboLoc) {
			errinfo = errinfo + "报告科室不能为空!<br>";
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
			Common_SetValue("chkIsActive",(objRec.get("Active")=='是'));  //fix bug 116579 有效状态的有对勾
			Common_SetValue("txtResume",objRec.get("ResumeText"));
		}
	};
}

