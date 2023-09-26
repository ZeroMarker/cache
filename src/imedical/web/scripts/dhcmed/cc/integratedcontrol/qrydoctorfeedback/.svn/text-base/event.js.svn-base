function InitobjFeedBackQryEvent(obj)
{
	obj.LoadEvent = function(args)
	{
		obj.cboDateType.setValue("3");
		obj.CurrentSubjectID = SubjectID;
		obj.btnQryFeedBack_click();
		
		var objPagingToolbar = Ext.getCmp("PagingToolbar");
		if (objPagingToolbar) {
			objPagingToolbar.on('change',function(){
				var arryResult = new Array();
				var objRec = '';
				for (var ind = 0; ind < obj.QryFeedBackStore.getCount(); ind++)
				{
					objRec = obj.QryFeedBackStore.getAt(ind);
					arryResult[arryResult.length] = objRec.data;
				}
				arryResult.totalCount = obj.QryFeedBackStore.getTotalCount();
				obj.displayFeedBackInfo(arryResult);
			},obj);
		}
	}

	
	obj.btnFeedbackEva_onclick = function(FeedbackRowID,LnkFeedBackIDs)
	{
		//if(objBtn.disabled)
		//	return;
		//var arryFields = objBtn.id.split("_");
		var objEvaWin = new InitwinFeedbackEva(FeedbackRowID,LnkFeedBackIDs);
		objEvaWin.winFeedbackEva.show();
		
		
		//objBtn.innerHTML = '<img src="../scripts/dhcmed/img/sysconfig.gif"/>已评估';
		//objBtn.disabled = true;
	}
	
	obj.btnQryFeedBack_click = function()
	{
		obj.waitWin = Ext.MessageBox.wait("数据加载中，请稍后", "Loading");
		
		var start = 0;
		var limit = 20;
		var objPagingToolbar = Ext.getCmp("PagingToolbar");
		if (objPagingToolbar) {
			start = objPagingToolbar.cursor;
			limit = objPagingToolbar.pageSize;
		}
		obj.QryFeedBackStore.load({params:{start:start,limit:limit}});
	}
	
	obj.displayFeedBackInfo = function(arryResult)
	{	
		obj.pnScreen.update(arryResult);
		obj.waitWin.hide();
	}

	obj.viewPatientInfo = function(EpisodeID, SummaryID)
		{
			obj.CurrentEpisodeID = EpisodeID;
			var objViewBaseInfo = new InitViewBaseInfo();
			objViewBaseInfo.DisplayDetailInfo(EpisodeID,SubjectID,SummaryID);
			objViewBaseInfo.viewPatientWin.show();
		}	
	
}