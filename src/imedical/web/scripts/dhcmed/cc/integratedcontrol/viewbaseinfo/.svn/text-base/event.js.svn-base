

function InitViewBaseInfoEvent(obj) {
	obj.LoadEvent = function(args)
	{
		obj.PatManage = ExtTool.StaticServerObject("DHCMed.Base.Patient");
		obj.AdmManage = ExtTool.StaticServerObject("DHCMed.Base.PatientAdm");
		obj.cboMsgDic.on("select",obj.cboMsgDic_select);
	}
	obj.cboMsgDic_select = function(objCbo, objRec)
	{
		obj.txtMsg.setValue(objRec.get("Description"));
		
	}
	obj.dicList_checked = function()
	{
		obj.OrderTypeList = "*";
		var objStatusList = obj.cbgLabOrderType.getValue();
	
		for (var statusIndex = 0; statusIndex < objStatusList.length; statusIndex++) {
			obj.OrderTypeList = obj.OrderTypeList + objStatusList[statusIndex].getName() + "*";
		}
		obj.gridLabStore.load({});
	}
	obj.gridLab.on("rowdblclick", 
		function()
		{
			var rowIndex = arguments[1];
			var objRec = obj.gridLab.getStore().getAt(rowIndex);
			if(objRec == null)
				return;
			var strLabTestNo = objRec.get("LabTestNo");
			var strOrderID = objRec.get("OrderID");
			var objAdm = obj.AdmManage.GetObjById(obj.paadm);
			var objTestWin = new ShowTestWin(objAdm.PatientID, strOrderID, strLabTestNo);
					
		}, obj);	
	
	obj.msgPanel_active = function()
	{
		if(obj.arryMsgResult == null)
			return;
		obj.pnMsgPanel.update(obj.arryMsgResult);
		var strBody = obj.objMsgTpl.apply(obj.arryMsgResult);
		/*调试用*/
		/*
		var objFSO = new ActiveXObject("Scripting.FileSystemObject");
		var objTxt = objFSO.CreateTextFile("E:\\DTHealth\\app\\dthis\\web\\csp\\a.html", true, true);
		objTxt.WriteLine("<HTML>");
		objTxt.WriteLine("<HEAD>");
		objTxt.WriteLine('<link rel="stylesheet" type="text/css" href="../scripts/dhcmed/css/msglist.css" />');
		objTxt.WriteLine("</HEAD>");
		objTxt.WriteLine("<BODY>");
		objTxt.WriteLine(strBody);
		objTxt.WriteLine("</BODY>");
		objTxt.WriteLine("</HTML>");
		objTxt.Close();
		*/
		
		
		obj.pnMsgPanel.un("activate", obj.msgPanel_active, obj);		
	}
	
	obj.DisplayMsgList = function()
	{
		var param = new Object();
		param.ClassName = 'DHCMed.CC.CtlMessage';
		param.QueryName = 'QryByEpisodeSubject';
		param.Arg1 = obj.CurrentEpisodeID;
		param.Arg2 = obj.CurrentSubjectID;
		param.ArgCnt = 2;
		ChartTool.RunQuery(param,function(arryResult){
			obj.arryMsgResult =  arryResult;
			obj.pnMsgPanel.on("activate",obj.msgPanel_active, obj);
		}, obj);
	}
	
	//显示信息
	obj.DisplayDetailInfo = function(EpisodeID, SubjectID, SummaryID)
	{
		obj.CurrentEpisodeID = EpisodeID;
		obj.CurrentSubjectID = SubjectID;
		obj.CurrentSummaryID = SummaryID;
		
		obj.objCurrentEpisode = obj.AdmManage.GetObjById(EpisodeID);
		Ext.getCmp("dtCtlResultFromDate").setValue(obj.objCurrentEpisode.AdmitDate);
		//Ext.getCmp("dtOrderFromDate").setValue(obj.objCurrentEpisode.AdmitDate);		
		
		obj.gridCtlResultStore.load({params : {start:0,limit:50}});
		obj.gridDiagnoseStore.load({});
		obj.gridLabStore.load({params : {start:0,limit:50}});
		//obj.gridOrderStore.load({params : {start:0,limit:50}});
		obj.DisplayMsgList();
		var infoPanel = new ExtTool.EpisodePanel({EpisodeId:EpisodeID});
		infoPanel.setTitle("基本信息");
		
		//Modified by liuyh 2013-02-28 合并基本信息和诊断信息
		obj.BasePanel = new Ext.Panel({
			id : 'BasePanel'
			,title : '基本信息'
			,region:'north'
			,layout : 'column'
			,height:160
			,items:[
				infoPanel
			]
		});
	
		obj.BaseDiagPanel = new Ext.form.FormPanel({
			id : 'BaseDiagPanel'
			,title : '基本-诊断信息'
			,layout : 'border'
			,frame : true
			,items:[
				obj.BasePanel
				,obj.gridDiagnose
			]
		});
	
		obj.tabDetail.insert(0,	obj.BaseDiagPanel);
		obj.DisplayMsgList();
		
		//Modified by wuqk 2012-10-08 因为timeline中csp路径问题，重新定义dhcmed.cc.timeline.csp，通过转发实现访问，csp/timeline/下的文件不需要再拷贝到csp目录下
		//var strTemplate = "./integrationvisual.csp?queryCode=&EpisodeID={0}&startDate={1}&timeLineId=INFReason&PatientID={2}";
		var strTemplate = "./dhcmed.cc.timeline.csp?queryCode=&EpisodeID={0}&startDate={1}&timeLineId=INFReason&PatientID={2}";
		var strURL = String.format(strTemplate, obj.CurrentEpisodeID, obj.objCurrentEpisode.AdmitDate, obj.objCurrentEpisode.PatientID);
		var fn = function() {
			var objIFrame = document.getElementById("frmTimeLine").src = strURL
			obj.pnTimeLine.un("activate", fn, obj);
		}
		obj.pnTimeLine.on("activate", fn, obj);
		
		var strTemplate = "./epr.newfw.episodelistbrowser.csp?EpisodeID={0}&PatientID={1}";
		var strEPRURL = String.format(strTemplate, obj.CurrentEpisodeID, obj.objCurrentEpisode.PatientID);
		var fn1 = function() {
			var objIFrame = document.getElementById("ifEpr").src = strEPRURL
			obj.pnEpr.un("activate", fn1, obj);				
		}
		obj.pnEpr.on("activate", fn1, obj);
		
		var strTemplate = "./dhcoeordsch.csp?EpisodeID={0}&PatientID={1}";
		var strOrderURL = String.format(strTemplate, obj.CurrentEpisodeID, obj.objCurrentEpisode.PatientID);
		var fn2 = function() {
			var objIFrame = document.getElementById("ifOrder").src = strOrderURL
			obj.pnOrder.un("activate", fn2, obj);
		}
		obj.pnOrder.on("activate", fn2, obj);
		
		var strTemplate = "./dhcmed.cc.risordresult.csp?EpisodeID={0}&PatientID={1}";
		var strOrderURL = String.format(strTemplate, obj.CurrentEpisodeID, obj.objCurrentEpisode.PatientID);
		var fn3= function() {
			var objIFrame = document.getElementById("ifRis").src = strOrderURL
			obj.pnRis.un("activate", fn3, obj);
		}
		obj.pnRis.on("activate", fn3, obj);
		
	}
		
	
	
	obj.gridCtlResultStore.on("load", 
		function(store){
			store.sort('KeyWord', 'ASC');
		}
	)	
	
	
	//保存交互信息
	obj.SaveMsg = function()
	{
		var strArg = "";
		strArg += "^";
		strArg += obj.CurrentEpisodeID + "^";
		strArg += obj.CurrentSubjectID + "^";
		strArg += obj.txtMsg.getValue() + "^";
		strArg += session['LOGON.USERID'] + "^";
		strArg += "^";
		strArg += "^";
		strArg += "" + "^";
		var ret = ExtTool.RunServerMethod("DHCMed.CC.CtlMessage", "Update", strArg, "^");
		return ret;
	}
  
  
	obj.btnSendMsg_click = function()
	{
		obj.CurrentSubjectID = SubjectID;
		if(obj.txtMsg.getValue() == "")
		{
			ExtTool.alert("提示", "请输入要发送的信息！" , Ext.MessageBox.INFO);
			return;
		}
		var ret = obj.SaveMsg();
		if (ret > 0)
		{
			var param = new Object();
			param.ClassName = 'DHCMed.CC.CtlMessage';
			param.QueryName = 'QryByEpisodeSubject';
			param.Arg1 = obj.CurrentEpisodeID;
			param.Arg2 = obj.CurrentSubjectID;
			param.ArgCnt = 2;
			ChartTool.RunQuery(param,function(arryResult){
				obj.arryMsgResult =  arryResult;
				obj.msgPanel_active();
			}, obj);
		} else {
			ExtTool.alert("错误", "保存失败！返回值：" + ret , Ext.MessageBox.INFO);
		}
	};	
	
	
	
	
/*viewScreen新增代码占位符*/}

