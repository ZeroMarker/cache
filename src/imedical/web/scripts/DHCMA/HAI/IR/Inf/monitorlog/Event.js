//ICU患者日志->Event
function InitLogWinEvent(obj) {
	//初始化信息
    obj.LoadEvent = function () {
        //加载日期时间
        obj.date = new Date();
        obj.LogCurrYear = obj.date.getFullYear();
        obj.LogCurrMonth = obj.date.getMonth()+1;	
        obj.aYYMM=obj.LogCurrYear+"-"+obj.LogCurrMonth;
        obj.refreshLog()
    }
    //加载ICU患者日志[表]
    obj.refreshLog = function () {
	    var aLocDr=obj.LocDr;						//科室
	    //加载表[前台加载]
        $("#gridLog").datagrid("loading");
        $cm({
            ClassName: "DHCHAI.IRS.ICULogSrv",
            QueryName: "QryAISByMonth",
            aYYMM: obj.aYYMM,
            aLocDr: aLocDr,
            page: 1,
            rows: 999
        }, function (rs) {
            $('#gridLog').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
        });
      //  $("#gridLog").datagrid("loading");
        //$('#gridLog').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', []);
    }
    //导出(ICU患者日志)
    $("#btnExport").on('click', function () {
		var rows = obj.gridLog.getRows().length;  
		if (rows>0) {
			 $('#gridLog').datagrid('toExcel', obj.LocDesc+'监测日志.xls'); 
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}
    });
    //科室患者明细(ICU)
    obj.OpenICULocExt = function (SurveryDate, LocDesc) {
        var t = new Date();
        t = t.getTime();
        var strUrl = "./dhcma.hai.ir.icu.locpatients.csp?LocID=" + obj.LocDr + "&SurveryDate=" + SurveryDate;
        websys_showModal({
            url: strUrl,
            title: 'ICU插管情况(' + LocDesc +" "+SurveryDate + ')',
            iconCls: 'icon-w-paper',
            width: '90%',
            height: '95%',
            onBeforeClose: function () {
                obj.refreshLog();	//关闭前刷新
            }
        });
    }
    //方法
    //1.指定列求和
    obj.computeICU = function (colName) {
        var rows = $('#gridLog').datagrid('getRows');

        var total = 0;
        for (var i = 0; i < rows.length; i++) {
            if (parseInt(rows[i][colName]) > 0) total = total + parseInt(rows[i][colName]);
        }
        return total;
    }
}

