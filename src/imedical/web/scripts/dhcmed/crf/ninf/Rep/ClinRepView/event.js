
function InitviewScreenEvent(obj) {
	obj.LoadEvent = function(args)
	{
		obj.loadSummaryList();
		obj.gridInfReportStore.load({});
		obj.btnInfReport.on('click',obj.btnInfReport_click,obj);
		obj.btnICUReport.on('click',obj.btnICUReport_click,obj);
		obj.btnNICUReport.on('click',obj.btnNICUReport_click,obj);
		obj.btnOperReport.on('click',obj.btnOperReport_click,obj);
		obj.gridInfReport.on("rowdblclick", obj.gridInfReport_rowdblclick, obj);
		
		//obj.btnInfReport.setVisible(true);
		//obj.btnOperReport.setVisible(true);
		//obj.btnICUReport.setVisible(true);
		//obj.btnNICUReport.setVisible(true);
		
		//�ṩ���Ӵ������,ˢ�µ�ǰҳ��
		window.WindowRefresh_Handler = obj.WindowRefresh_Handler;
	}
	
	obj.btnInfReport_click = function()
	{
		var lnk="dhcmed.ninf.rep.infreport.csp?1=1&ReportType=COMP&EpisodeID="+EpisodeID+"&TransLoc="+TransLoc+"&AdminPower="+AdminPower+"&2=2";
		obj.viewReportWin('winInfReport',lnk);
	}
	
	obj.btnICUReport_click = function()
	{
		var lnk="dhcmed.ninf.rep.infreport.csp?1=1&ReportType=ICU&EpisodeID="+EpisodeID+"&TransLoc="+TransWard+"&AdminPower="+AdminPower+"&2=2";
		obj.viewReportWin('winICUReport',lnk);
	}
	
	obj.btnNICUReport_click = function()
	{
		var lnk="dhcmed.ninf.rep.infreport.csp?1=1&ReportType=NICU&EpisodeID="+EpisodeID+"&TransLoc="+TransWard+"&AdminPower="+AdminPower+"&2=2";
		obj.viewReportWin('winNICUReport',lnk);
	}
	
	obj.btnOperReport_click = function()
	{
		var lnk="dhcmed.ninf.rep.infreport.csp?1=1&ReportType=OPR&EpisodeID="+EpisodeID+"&TransLoc="+TransLoc+"&AdminPower="+AdminPower+"&2=2";
		obj.viewReportWin('winOperReport',lnk);
	}
	
	obj.gridInfReport_rowdblclick = function(objGrid, rowIndex)
	{
		var record = objGrid.getStore().getAt(rowIndex);
		var ReportID = record.get("ReportID");
		var lnk="dhcmed.ninf.rep.infreport.csp?1=1&ReportID="+ReportID+"&AdminPower="+AdminPower+"&2=2";
		obj.viewReportWin('winInfReport',lnk);
	}
	
	//������ʾ��Ϣ
	obj.loadSummaryList = function()
	{
		var param = new Object();
		param.ClassName = 'DHCMed.CCService.Feedback.FeedBackService';
		param.QueryName = 'QryByEpisodeSubject';
		param.Arg1 = EpisodeID;
		param.Arg2 = SubjectID;
		param.Arg3 = "";
		param.Arg4 = "";
		param.ArgCnt = 4;
		ChartTool.RunQuery(param, 
			function(arryResult){
				for (var indRec = 0; indRec < arryResult.length; indRec++) {
					var objRec = arryResult[indRec];
					if (!objRec) continue;
					if (objRec.Status != '0') continue;
					
					objScreen.FeedBackIDs = objScreen.FeedBackIDs + "," + objRec.FeedbackRowID
				}
				objScreen.objTpl.overwrite(objScreen.pnScreen.body, arryResult);
			}, obj
		);
	}
	
	//ժҪ��Ϣ
	obj.viewPatientInfo = function(EpisodeID, SummaryID)
	{
		var objViewBaseInfo = new InitViewBaseInfo();
		objViewBaseInfo.DisplayDetailInfo(EpisodeID,SubjectID,SummaryID);
		objViewBaseInfo.viewPatientWin.show();
	}
	
	//���ܴ˴ν��
	obj.btnAccept_onclick = function()
	{
		var arrRec = obj.FeedBackIDs.split(",");
		for (var indRec = 0; indRec < arrRec.length; indRec++) {
			var FeedBackID = arrRec[indRec];
			if (!FeedBackID) continue;
			
			var strArg = FeedBackID + "^";
			strArg += "^"; //���������������˾Ͳ���д������
			strArg += session['LOGON.USERID'] + "^"; //������
			strArg += "^^"; //���ں�ʱ��
			strArg += "1^";
			var ret=ExtTool.RunServerMethod("DHCMed.CC.CtlFeedback", "UpdateAllReceiveFeedBack", strArg, "^");
		}
		obj.loadSummaryList();
	}
	
	//�ų��˴ν��
	obj.btnReject_onclick = function()
	{
		if (obj.FeedBackIDs=='') {
			ExtTool.alert("��ʾ", "����δ�Ķ�����Ϣ��");
			return;
		}
		var winReject = new InitwinSendReceiveFeedback(
			obj.FeedBackIDs,
			obj.loadSummaryList,
			obj
		);
		winReject.winReject.show();
	}
	
	obj.viewReportWin = function(winid,url){
		if (ExtWinOpen == 1) {
			/* CS������Ҫ�õ����ַ�ʽ���޷�����ҳ�� */
			var win_report = new Ext.Window({
				id : winid,
				width : (window.screen.availWidth - 100),
				height : (window.screen.availHeight - 100),
				modal : true,
				plain : true,
				html : '<iframe id="' + winid + '" width=100% height=100% frameborder=0 scrolling=auto src="' + url + '"></iframe>'
			});
			win_report.show();
		} else {
			var oWin = window.open(url,'',"height=" + (window.screen.availHeight - 100) + ",width=" + (window.screen.availWidth - 100) + ",top=20,left=50,resizable=no");
		}
	}
	
	obj.WindowRefresh_Handler = function()
	{
		obj.gridInfReportStore.load({});
	}
}
