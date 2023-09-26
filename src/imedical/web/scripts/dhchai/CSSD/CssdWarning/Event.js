//器械预警
//页面Event
function InitAssRateWinEvent(obj) {
    obj.LoadEvent = function (args) {
        $('#btnQuery').on('click', function () {
            obj.btnQuery_click();
        });

        $HUI.combogrid('#AssessRate', {
            onSelect: function (index, row) {
                var ModelID = row.ID;
                var AdmStatus = row.AdmStatus;
                if (AdmStatus) {
                    $HUI.radio('#radAdmStatus-' + AdmStatus).setValue(true);
                }
                objSttDate = row.SttDate;
                objEndDate = row.EndDate;

                $('#StartDate').datebox('setValue', objSttDate);
                $('#EndDate').datebox('setValue', objEndDate);

                obj.btnQuery_click();
            }
        });
        //打印
        obj.btnPrint = function () {
            $('#AssessRate').datagrid('print', '器械追溯预警');
        }
        //导出
        obj.btnexport = function () {
            $('#AssessRate').datagrid('toExcel', '器械追溯预警.xls');
        }
        //查询
        obj.btnQuery_click = function () {
            var DateFrom = $('#StartDate').datebox('getValue');    //开始时间
            var DateTo = $('#EndDate').datebox('getValue');    //结束时间
            var TextBatchNum = $("#txtRegNo").val();   //灭菌批次
             //时间条件判断
   	        //获取当前时间
   	        var now = new Date();
   	        var year = now.getFullYear();       //年
   	        var month = now.getMonth() + 1;     //月
   	        var day = now.getDate();            //日
   	        if (day < 10) { day="0"+day}
		    var NowDate = year + "-" + month + "-" + day;
		    if((DateFrom=='')||(DateTo=='')){
		        $.messager.alert("提示", "开始日期或结束日期不能为空", 'info');
		        return;
		    }
		    else {
		        if (DateTo > NowDate) {
		            $.messager.alert("提示", "开始日期或结束日期不能大于当前日期", 'info');
		            return;
		        }
		        if (DateFrom > DateTo) {
		            $.messager.alert("提示", "开始日期不能晚于结束日期！", 'info');
		            return;
		        }
		    }
            obj.gridAssRate.load({
                ClassName: 'DHCHAI.DI.DHS.SyncCSSDInfo',
                QueryName: 'QryCssdListLoc',
                iDateFrom: DateFrom,
                iDateTo: DateTo,
                iBatchNumberS: TextBatchNum,
            });
        }
        //打开科室人员信息
        obj.OpenLocDr = function (LocDr) {
            var DateFrom = $('#StartDate').datebox('getValue');    //开始时间
            var DateTo = $('#EndDate').datebox('getValue');    //结束时间
            var TextBatchNum = $("#txtRegNo").val();   //灭菌批次

            var strUrl = "./dhchai.cssd.Localtracking.csp?LocInfo=" + LocDr +
                "&DateFrom=" + DateFrom + "&DateTo=" + DateTo + "&BatNumS=" + TextBatchNum;
            websys_showModal({
                url: strUrl,
                title: '科室消毒人员信息',
                iconCls: 'icon-w-paper',
                width: '95%',
                height: '95%'
            });
        }
    }
}