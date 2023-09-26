//页面Event
function InitAdmHistoryWinEvent(obj){
	obj.gridAdmHistory.on('select', function(e, dt, type, indexes) {
		if ( type === 'row' ) {
	        var data = obj.gridAdmHistory.rows(indexes).data();
	        var EpisodeID = data[0].EpisodeID;
	        InitAdmInfo(EpisodeID);
	    }
	});
	InitAdmInfo(PaadmID);
	function InitAdmInfo(EpisodeID){
		var runQuery = $.Tool.RunQuery('DHCHAI.DPS.PAAdmSrv','QryAdmInfo',EpisodeID)
        if (runQuery!=''){
        	if (runQuery.total){
        		var AdmInfo = runQuery.record[0];
        		$.form.SetValue('txtMrNo',AdmInfo.MrNo)
        		$.form.SetValue('txtAdmDays',AdmInfo.AdmDays+'天')
        		$.form.SetValue('txtAdmTimes',AdmInfo.AdmTimes)
        		$.form.SetValue('txtAdmitDiag',AdmInfo.AdmitDiag)
        		$.form.SetValue('txtMainDiag',AdmInfo.MainDiag)
        		$.form.SetValue('txtOtherDiag',AdmInfo.OtherDiag)
        		$.form.SetValue('txtDeathDate',AdmInfo.DeathDate)
        		$.form.SetValue('txtDeathTime',AdmInfo.DeathTime)
        	}
        }
	}
	$("#txtAdmitDiag").mouseover(function(){
		var AdmitDiag = $.form.GetValue("txtAdmitDiag");
		if (AdmitDiag!='') {
	 		layer.tips(AdmitDiag, '#txtAdmitDiag', {
	  			tips: [1, '#3595CC'],
	  			time: 2000
			});
		}
	});
	$("#txtMainDiag").mouseover(function(){
		var MainDiag = $.form.GetValue("txtMainDiag");
		if (MainDiag!='') {
	 		layer.tips(MainDiag, '#txtMainDiag', {
	  			tips: [1, '#3595CC'],
	  			time: 2000
			});
		}
	});
	$("#txtOtherDiag").mouseover(function(){
		var OtherDiag = $.form.GetValue("txtOtherDiag");
		if (OtherDiag!='') {
	 		layer.tips(OtherDiag, '#txtOtherDiag', {
	  			tips: [1, '#3595CC'],
	  			time: 2000
			});
		}
	});
}

