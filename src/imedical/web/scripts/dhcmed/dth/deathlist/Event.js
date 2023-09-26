
function InitVpInfPatientAdmEvent(obj)
{
	obj.LoadEvent = function(args){
		obj.btnFind.on("click",obj.btnFind_click,obj);
		obj.cboSSHosp.on('select',obj.cboSSHosp_select,obj);
		
		//add by pylian 108577 加入监听，输入【登记号】回车不能自动补零 
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
			var cm = obj.gridDeathPatient.getColumnModel();
    			var cfg = null;
    			for(var i=0;i<cm.config.length;++i)
   	 		{
	   	 		cfg = cm.config[i];
	   	 		if ((cfg.id=="Secret1")||(cfg.id=="Secret2")) {
					cm.setHidden(i,true);
	   	 		}
			}
		}
	}
	obj.cboSSHosp_select = function(){
		Common_SetValue("cboRepLoc","");
		obj.cboRepLoc.getStore().load();
	}
	obj.btnFind_click = function(){
		obj.gridDeathPatientStore.removeAll();
		obj.gridDeathPatientStore.load({});
	}
	obj.GetExamConditions = function(){
		var txtRegNo=obj.txtRegNo.getValue();
		var MrNo=obj.txtMrNo.getValue();
		var txtPatName=obj.txtPatName.getValue();
		var ExamConds=""
		if (txtRegNo){
			if (ExamConds!='') ExamConds += "^"
			ExamConds += "RegNo=" + txtRegNo;
		}
		if (MrNo){
			if (ExamConds!='') ExamConds += "^"
			ExamConds += "MrNo=" + MrNo;
		}
		if (txtPatName){
			if (ExamConds!='') ExamConds += "^"
			ExamConds += "PatName=" + txtPatName;
		}
		return ExamConds;
	}
}

function RefreshRowByReportID(ReportID){
	if (!ReportID) return;
	/*
	var RepStatusInfo = ExtTool.RunServerMethod("DHCMed.DTH.Report","GetStatusInfoByID",ReportID);
	if (RepStatusInfo == '') return;
	var arrStatus = RepStatusInfo.split('^');
	
	var objGrid = Ext.getCmp('gridDeathPatient');
	if (!objGrid) return;
	var objStore = objGrid.getStore();
	if (!objStore) return
	
	
	var SelectIndex = objStore.find('ReportID',ReportID);
	if (SelectIndex > -1){
		var rd = objStore.getAt(SelectIndex);
		rd.set('DthRepStatus',arrStatus[2]);
		rd.commit();
	}
	*/
	//objStore.load({});
	Common_LoadCurrPage("gridDeathPatient");
}


