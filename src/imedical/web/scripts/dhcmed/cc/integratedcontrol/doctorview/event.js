

function InitviewScreenEvent(obj) {
	obj.LoadEvent = function(args)
	{
		document.title = "提示信息列表";
		window.resizeTo(800, 600);
		obj.CurrentSubjectID = document.getElementById("SubjectID").value;
		obj.CurrentEpisodeID = document.getElementById("EpisodeID").value;
		obj.RepType = document.getElementById("RepType").value; // //Add By LiYang 2013-04-07根据报告筛选报告类别
		obj.btnQrySummary_onclick();
		
		Ext.getCmp("rdoStatus1").on("check", obj.btnQrySummary_onclick, obj);
		Ext.getCmp("rdoStatus2").on("check", obj.btnQrySummary_onclick, obj);
	}	

	obj.viewPatientInfo = function(EpisodeID, SummaryID)
		{
			obj.CurrentEpisodeID = EpisodeID;
			var objViewBaseInfo = new InitViewBaseInfo();
			objViewBaseInfo.DisplayDetailInfo(
				EpisodeID,
				document.getElementById("SubjectID").value,
				SummaryID
			);
			objViewBaseInfo.viewPatientWin.show();
		}
	
	obj.btnQrySummary_onclick = function()
	{
		var param = new Object();
		param.ClassName = 'DHCMed.CCService.Feedback.FeedBackService';
		param.QueryName = 'QryByEpisodeSubject';
		param.Arg1 = obj.CurrentEpisodeID;
		param.Arg2 = obj.CurrentSubjectID;
		param.Arg3 = "";
		if(Ext.getCmp("rdoStatus1").getValue())
			param.Arg3 = 0;
		if(Ext.getCmp("rdoStatus2").getValue())
			param.Arg3 = "12";
		param.Arg4 = obj.RepType //Add By LiYang 2013-04-07根据报告筛选报告类别
		param.ArgCnt = 4;
		ChartTool.RunQuery(param, 
			function(arryResult){
				objScreen.objTpl.overwrite(objScreen.pnScreen.body, arryResult);
				//window.alert(objScreen.objTpl.apply(arryResult));
				/*if(Ext.getCmp("rdoStatus1").getValue())
					document.getElementById("FeedBackCnt").innerText = "未处理信息数量：";
				else
					document.getElementById("FeedBackCnt").innerText = "已处理信息数量：";
				*/
			}, obj);
	}
	
	
	//接受此次结果
	obj.btnAccept_onclick = function(feedbackRowID)
	{
		var strArg = feedbackRowID + "^";
		strArg += "^"; //具体描述，接受了就不用写内容了
		strArg += session['LOGON.USERID'] + "^"; //接受人
		strArg += "^^"; //日期和时间
		strArg += "1^";
		var ret=ExtTool.RunServerMethod("DHCMed.CC.CtlFeedback", "UpdateAllReceiveFeedBack", strArg, "^");
		obj.btnQrySummary_onclick();
	}
	
	//排除此次结果
	obj.btnReject_onclick = function(feedbackRowID)
	{
		var winReject = new InitwinSendReceiveFeedback(
			feedbackRowID,
			obj.btnQrySummary_onclick,
			obj
		);
		winReject.winReject.show();
	}
		
/*viewScreen新增代码占位符*/}

