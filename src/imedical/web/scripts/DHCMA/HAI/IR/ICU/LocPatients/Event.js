//ICU患者日志-科室患者信息-Event
function InitLocPatientsWinEvent(obj) {
	//是否显示提交按钮
	var IsShowICUSubmit = $m({ 
		ClassName: "DHCHAI.BT.Config",
		MethodName: "GetValByCode",
		aCode: "IsShowICUSubmit"
	}, false);
	if(IsShowICUSubmit=="1"){
		$("#btnICUSubmit").show();
	}
	else{
		$("#btnICUSubmit").hide();
	}
	
    //打开摘要
    obj.OpenView = function (aEpisodeID) {
        var t = new Date();
        t = t.getTime();
        var strUrl = "./dhchai.ir.view.main.csp?PaadmID=" + aEpisodeID + "&PageType=WinOpen"+"&LocFlag="+LocFlag+"&t=" + t;
        websys_showModal({
            url: strUrl,
            title: $g('医院感染集成视图'),
            iconCls: 'icon-w-paper',
            width: '95%',
            height: '95%'
        });
    }
   
    //ICU科室患者 生成
    $("#btnICUGreat").on('click', function () {
        //根据医嘱生成插拔管日志
        var Count = 0;
        var rowsdata = $('#gridICULoc').datagrid('getRows');
        for (var indRst = 0; indRst < rowsdata.length; indRst++) {
            var data = rowsdata[indRst];
            var retval = $m({
                ClassName: "DHCHAI.IRS.ICULogSrv",
                MethodName: "CreateICULogByOEOrd",
                aDateFrom: SurveryDate,
                aDateTo: SurveryDate,
                aLocDr: LocID,
                aLocType:"W",
                aEpisodeDr: ""
            }, false)
            if (parseInt(retval) > 0) {
                Count++;
            }
        }
        //add 20190513 生成日志明细同时生成日志汇总
        var retval = $m({
            ClassName: "DHCHAI.IRS.ICULogSrv",
            MethodName: "CreateICULogByDay",
            aDateFrom: SurveryDate,
            aDateTo: SurveryDate,
            aLocDr: LocID
        }, false)
        if (parseInt(retval) > 0) {
            $.messager.alert("提示", "根据医嘱自动生成插拔管日志(" + Count + "条)成功!", 'info');
            obj.refreshgridICULoc();
        }
    });
    //ICU科室患者 提交
    $("#btnICUSubmit").on('click', function () {
        var rows = $('#gridICULoc').datagrid('getRows');

        var total = 0;        //记录条数
        for (var i = 0; i < rows.length; i++) {
            var RowID = rows[i].RowID;
            var Paadm = rows[i].Paadm;
            var ILLocDr = LocID;
            var ILDate = SurveryDate;

            var TubeInfo = Common_CheckboxValue("ICU" + RowID);
            var ILIsVAP = TubeInfo.indexOf("VAP") >= 0 ? 1 : 0;
            var ILIsPICC = TubeInfo.indexOf("PICC") >= 0 ? 1 : 0;
            var ILIsUC = TubeInfo.indexOf("UC") >= 0 ? 1 : 0;
            var ILIsOper = 0;
            var ILIsCVC = TubeInfo.indexOf("CVC") >= 0 ? 1 : 0;
            var ILIsCRRT = TubeInfo.indexOf("CRRT") >= 0 ? 1 : 0;
            var ILIsPORT = TubeInfo.indexOf("PORT") >= 0 ? 1 : 0;

            var InputStr = "";
            InputStr += "^" + Paadm;
            InputStr += "^" + ILLocDr;
            InputStr += "^" + ILDate;
            InputStr += "^" + ILIsVAP;
            InputStr += "^" + ILIsPICC;
            InputStr += "^" + ILIsUC;
            InputStr += "^" + ILIsOper;
			InputStr += "^" + "";
			InputStr += "^" + ILIsCVC;
			InputStr += "^" + ILIsCRRT;
			InputStr += "^" + ILIsPORT;
            var retval = $m({
                ClassName: "DHCHAI.IR.ICULogDtl",
                MethodName: "Update",
                InStr: InputStr
            }, false);
        }
        var retval = $m({
            ClassName: "DHCHAI.IRS.ICULogSrv",
            MethodName: "CreateICULogByDay",
            aDateFrom: SurveryDate,
            aDateTo: SurveryDate,
            aLocDr: LocID
        }, false);
        if (parseInt(retval) > 0) {
            $.messager.alert("提示", "ICU日志确认成功!", 'info');

            obj.refreshICU();    //刷新ICU患者日志
            $HUI.dialog('#LayerICUExt').close();    //关闭页面
        } else {
            $.messager.alert("提示", "ICU日志确认失败!", 'info');
            return;
        }
    });
    //刷新ICU科室患者明细
    obj.refreshgridICULoc = function () {
        $("#gridICULoc").datagrid("loading");
        obj.gridICULoc.load({
            ClassName: "DHCHAI.IRS.ICULogSrv",
            QueryName: "QryICUAdmStr",
            aDate: SurveryDate,
            aLocDr: LocID,
        })
    }
    //ICU科室患者医嘱明细
    obj.refreshgridICUOE = function (iPaAdm, iFlag) {
        $("#gridICUOE").datagrid("loading");
        $cm({
            ClassName: "DHCHAI.IRS.ICULogSrv",
            QueryName: "QryICUAdmOeItem",
            aPaAdm: iPaAdm,
            aFlag: iFlag,
            page: 1,
            rows: 999
        }, function (rs) {
            $('#gridICUOE').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
        });
    }
    //ICU三管医嘱点击
    $("#btnICUAll").on('click', function () {
        $('#btnICUAll').css("background-color", "#dbedf9");
        $('#btnICUPICC').css("background-color", "white");
        $('#btnICUVAP').css("background-color", "white");
        $('#btnICUUC').css("background-color", "white");
        obj.refreshgridICUOE(obj.SelectPaadm, 0);
    })
    $("#btnICUPICC").on('click', function () {
        $('#btnICUAll').css("background-color", "white");
        $('#btnICUPICC').css("background-color", "#dbedf9");
        $('#btnICUVAP').css("background-color", "white");
        $('#btnICUUC').css("background-color", "white");
        obj.refreshgridICUOE(obj.SelectPaadm, 1);
    })
    $("#btnICUVAP").on('click', function () {
        $('#btnICUAll').css("background-color", "white");
        $('#btnICUPICC').css("background-color", "white");
        $('#btnICUVAP').css("background-color", "#dbedf9");
        $('#btnICUUC').css("background-color", "white");
        obj.refreshgridICUOE(obj.SelectPaadm, 2);
    })
    $("#btnICUUC").on('click', function () {
        $('#btnICUAll').css("background-color", "white");
        $('#btnICUPICC').css("background-color", "white");
        $('#btnICUVAP').css("background-color", "white");
        $('#btnICUUC').css("background-color", "#dbedf9");
        obj.refreshgridICUOE(obj.SelectPaadm, 3);
    })
   
}

