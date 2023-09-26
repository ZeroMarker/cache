
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
		
		//obj.txtDateFrom.setRawValue("2011-01-01");
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

 
function DeathReportLookUpHeader(ReportID,EpisodeID){
	var t=new Date();
	t=t.getTime();
    var url="dhcmed.dth.report.csp?EpisodeID=" + EpisodeID + "&ReportID=" + ReportID + "&t=" + t;
    var newwindow=window.open(url,'deathreport11','height=700,width=1000,top=5,left=150,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no,status=no')
}

function DeathReportChildLookUpHeader(ReportID,EpisodeID,ChRepID,Status){
	var t=new Date();
	t=t.getTime();
	if( (ReportID == "")||((Status!="待审")&&(Status!="统计室已审")&&(Status!="预防保健科已审"))) 
	{
		ExtTool.alert("提示", "请先报告医学死亡证明书，再报告儿童死亡报告卡！", Ext.MessageBox.ERROR);
		return;
	}
    var url="dhcmed.dth.childreport.csp?EpisodeID=" + EpisodeID + "&ReportID=" + ChRepID + "&DthReportID=" + ReportID + "&t=" + t;
    var newwindow=window.open(url,'childdeathreport11','height=400,width=700,top=5,left=150,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no,status=no')
}

function RefreshRowByReportID(DthRepID){
	if (!DthRepID) return;
	//objStore.load({});
	Common_LoadCurrPage("gridDeathPatient");
}
