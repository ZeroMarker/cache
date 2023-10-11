//页面Event
function InitHospSurveryWinEvent(obj){
	//初始化信息
	var runQuery =$cm({
		ClassName:"DHCHAI.DPS.PAAdmSrv",
		QueryName:"QryAdmInfo",
		aEpisodeID:PaadmID
	},false);
    if (runQuery!=''){
    	if (runQuery.total){
        	var AdmInfo = runQuery.rows[0];
        	$('#txtMrNo').val(AdmInfo.MrNo);
        	$('#txtAdmDays').val(AdmInfo.AdmDays+$g("天"))
        	$('#txtAdmTimes').val(AdmInfo.AdmTimes)
        	$('#txtAdmitDiag').val(AdmInfo.AdmitDiag)
        	$('#txtMainDiag').val(AdmInfo.MainDiag)
        	$('#txtOtherDiag').val(AdmInfo.OtherDiag)
        	$('#txtDeathDate').val(AdmInfo.DeathDate)
        	$('#txtDeathTime').val(AdmInfo.DeathTime)
       	}
     }
      //获取弹窗方式 0为窗口 1为csp
	  obj.flg = $m({
		ClassName:"DHCHAI.BT.Config",
		MethodName:"GetValByCode",
		aCode:"IsShowModal"
	},false);
     //摘要
	obj.btnAbstractMsg_Click = function(EpisodeID)
	{	
		var url = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&PageType=WinOpen';
	    //var url = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&1=1';
		if(obj.flg=="1"){
			websys_showModal({
				url:url,
				title:$g("医院感染集成视图"),
				iconCls:'icon-w-epr',
				closable:true,
				width:'95%',
				height:'95%'
			});
		}
		else{
			websys_createWindow(url,"","width=95%,height=95%");
		}	
	};
}

