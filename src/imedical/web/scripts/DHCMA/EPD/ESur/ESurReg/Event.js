function InitESurReportWinEvent(obj){
	
	RepTitle = $g('流行病学调查报告');
	obj.LoadEvent = function(args){ 
	   obj.ESurReportQuery();
    }
	
	
	
	
	//点击职业暴露报告
    $('#custtb > a').click(function (e) {
        var RepID = $(this).attr('text');
        //获取职业暴露长度
        var flag = $cm({
            ClassName: "DHCMed.EPDService.ESurRepSrv",
            QueryName: "QryESurTypeExt",
            aTypeID: RepID
        }, false);
        var Length=flag.total;
        if (Length != 0) {
            var aRegTypeID = $(this).attr("text");
            var aReportID = "";
		
            obj.OpenEsurView(aRegTypeID, aReportID);   //打开职业暴露报告
        }
        else {
            $.messager.alert("提示", "流调项目为空!", 'info');   //IE不能运行？
        }
    });
    // 打开流调报告
    obj.OpenEsurView = function (aRegTypeID, aReportID) {
        var url = '../csp/dhcma.epd.esurreport.csp?&RegTypeID=' + aRegTypeID + '&ReportID=' + aReportID + '&EpisodeID=' + EpisodeID;
        websys_showModal({
            url: url,
            title: RepTitle,
            iconCls: 'icon-w-paper',
			closable:true,  
            width: '1320',
            height: '95%',
            onBeforeClose: function () {
                obj.ESurReportQuery();
            }
        });
    }
    obj.ESurReportQuery = function(){
		$("#gridESurReport").datagrid("loading");	
		$cm ({
			ClassName: "DHCMed.EPDService.ESurRepSrv",
            QueryName: "QryRepInfoByPaadm",
            aPatientID: PatientID,
			page:1,
			rows:99999
		},function(rs){
			$('#gridESurReport').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);							
		});
	}
}