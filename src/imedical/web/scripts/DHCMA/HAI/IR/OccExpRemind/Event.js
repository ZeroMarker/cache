//页面Event
function InitOccExpQryWinEvent(obj) {
    //导出
    $('#btnExport').click(function (e) {
		var rows 			= obj.gridExpReg.getRows();  //返回当前页的所有行
        if(rows.length==0){
	        $.messager.alert("错误","当前界面没有数据，无法导出!", 'info');
			return;
	    }
        $('#gridExpReg').datagrid('toExcel', '职业暴露登记表.xls');   //导出
    });

    $("#btnQuery").on('click', function () {
        obj.refreshgridExpReg();
    })
    //刷新表
    obj.refreshgridExpReg = function () {
        var aHospID = $('#cboHospital').combobox('getValue');   //院区
        var aRepType = $('#cboRepType').combobox('getValue');   //院区
        var aDateType = $('#cboDateType').combobox('getValue');   //院区 
        var DateFrom = $('#DateFrom').datebox('getValue');
        var DateTo = $('#DateTo').datebox('getValue');
        var aRegLoc = $('#cboLocation').combobox('getValue');   //院区
        if (DateFrom > DateTo) {
            $.messager.alert("提示", "开始日期应小于或等于结束日期!", 'info');   //IE不能运行？
            return;
        }
        obj.gridExpReg.load({
            ClassName: "DHCHAI.IRS.OccExpRegSrv",
            QueryName: "QryOccExpRemind",
            aHospIDs: aHospID,
            aRepType: aRepType,
            aDateType: aDateType,
            aDateFrom: DateFrom,
            aDateTo: DateTo,
            aRegLoc: aRegLoc
        })
    }
    setTimeout(function(){
   		obj.refreshgridExpReg();
	},200);
    //提醒
    obj.OpenOccRemind = function (index) {
        $('#gridExpReg').datagrid('selectRow', index);
        var row = $('#gridExpReg').datagrid('getSelected')

        var ReportID = row.ID;
        var LabTimList = row.LabTimList;

        var StatusDr = $m({          //当前页(默认最后一页)
            ClassName: "DHCHAI.BT.Dictionary",
            MethodName: "GetIDByCode",
            aTypeCode:"OERegStatus",
            aCode: 4
        }, false)
        var Opinion = '已提醒' + "#" + LabTimList;
        var InputRegLog = ReportID;
        InputRegLog = InputRegLog + "^" + '';
        InputRegLog = InputRegLog + "^" + StatusDr;		//状态
        InputRegLog = InputRegLog + "^" + Opinion;
        InputRegLog = InputRegLog + "^" + '';
        InputRegLog = InputRegLog + "^" + '';
        InputRegLog = InputRegLog + "^" + $.LOGON.USERID;

        var retval = $m({          //当前页(默认最后一页)
            ClassName: "DHCHAI.IR.OccExpRegLog",
            MethodName: "Update",
            aInputStr: InputRegLog
        }, false)
        if (parseInt(retval) > 0) {
            obj.refreshgridExpReg();
            $.messager.alert("提示", "提醒成功!", 'info');
            return;
        } else {
            $.messager.alert("提示", "提醒失败!", 'info');
            return;
        }
    }
    //打开操作明细
    obj.OpenOccRepLog = function (aRepID) {
        $('#LayerOccRepLog').show();
        $HUI.dialog('#LayerOccRepLog', {
            title: "操作明细",
            iconCls: 'icon-w-paper',
            width: 800,
            height: 500,
            modal: true,
            isTopZindex: true
        });
        obj.refreshgridExpRepLog(aRepID);
    }
    //刷新操作明细
    obj.refreshgridExpRepLog = function (aRepID) {
        //后台加载刷新
        obj.gridExpRepLog.load({
            ClassName: "DHCHAI.IRS.OccExpRegSrv",
            QueryName: "QryExpRepLog",
            aRepID: aRepID,
            aStatus:4
        })
    }


}
