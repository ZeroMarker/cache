//NICU患者日志-科室患者信息-Event
function InitNLocPatientsWinEvent(obj) {
    //是否显示提交按钮
	var IsShowICUSubmit = $m({ 
		ClassName: "DHCHAI.BT.Config",
		MethodName: "GetValByCode",
		aCode: "IsShowICUSubmit"
	}, false);
	if(IsShowICUSubmit=="1"){
		$("#btnNICUSubmit").show();
	}
	else{
		$("#btnNICUSubmit").hide();
	}
	
    //打开摘要
    obj.OpenView = function (aEpisodeID) {
        var t = new Date();
        t = t.getTime();
        var strUrl = "./dhchai.ir.view.main.csp?PaadmID=" + aEpisodeID + "&PageType=WinOpen"+"&LocFlag="+LocFlag+"&t=" + t;
        websys_showModal({
            url: strUrl,
            title: '医院感染集成视图',
            iconCls: 'icon-w-paper',
            width: '95%',
            height: '95%'
        });
    }
    //打开补体重
    obj.OpenWeight = function (aEpisodeID,aWeight) {
        obj.SelectPaadm = aEpisodeID;
        $('#LayerWeight').show();
        $('#txtWeight').val(aWeight);
        $HUI.dialog('#LayerWeight', {
            title: "输入患者体重,并确认",
            iconCls: 'icon-w-paper',
            modal: true,
            isTopZindex: true
        })
    }
    //打开Apgar评分
    obj.OpenApgar = function (aEpisodeID,aApgar) {
        obj.SelectPaadm = aEpisodeID;
		$('#txtApgar').val(aApgar);
        $('#LayerApgar').show();
        $HUI.dialog('#LayerApgar', {
            title: "输入患者Apgar,并确认",
            iconCls: 'icon-w-paper',
            modal: true,
            isTopZindex: true
        })
    }
    //保存补体重
    $("#btnSaveWeight").on('click', function () {
        var PatWeight = $('#txtWeight').val();

        if (!PatWeight)  {
 			$HUI.dialog('#LayerWeight').close();
			return;
        }
        //校验数据格式是否有效
        var reg = new RegExp("^[0-9]*$");  //浮点数 ^(-?\d+)(\.\d+)?$ 两位小数的正实数：^[0-9]+(.[0-9]{2})?$ 
        if (!reg.test(PatWeight)) {
            $.messager.alert("提示", "请输入数字!", 'info');
            return;
        }
        var intPatWeight = parseInt(PatWeight);
        if (intPatWeight < 1) {
            $.messager.alert("提示", "体重必须大于0g!", 'info');
            return;
        }
        if (intPatWeight >= 10000) {
            $.messager.alert("提示", "体重必须小于10kg!", 'info');
            return;
        }
        //后台保存		
        var retval = $m({          //当前页(默认最后一页)
            ClassName: "DHCHAI.DPS.PAAdmSrv",
            MethodName: "UpdateWeight",
            aEpisodeID: obj.SelectPaadm,
            aPatWeight: PatWeight
        }, false)
        if (retval == "1") {
            var retval = $m({
                ClassName: "DHCHAI.IRS.ICULogSrv",
                MethodName: "CreateICULogByOEOrd",
                aDateFrom: SurveryDate,
                aDateTo: SurveryDate,
                aLocDr: LocID,
                aEpisodeDr: obj.SelectPaadm
            }, false)
            var retval = $m({
                ClassName: "DHCHAI.IRS.ICULogSrv",
                MethodName: "CreateICULogByDay",
                aDateFrom: SurveryDate,
                aDateTo: SurveryDate,
                aLocDr: LocID
            }, false)
            //刷新表格
            obj.refreshgridNICULoc();
            $HUI.dialog('#LayerWeight').close();
        }
        else {
            layer.msg("保存体重失败！");
        }
    });
    //保存Apgar评分
    $("#btnSaveApgar").on('click', function () {
        var PatApgar = $('#txtApgar').val();
		if (PatApgar===""){
			$.messager.alert("提示", "请输入数字!", 'info');
			return;
		}
        //校验数据格式是否有效
        var reg = new RegExp("^[0-9]*$");  //浮点数 ^(-?\d+)(\.\d+)?$ 两位小数的正实数：^[0-9]+(.[0-9]{2})?$ 
        if (!reg.test(PatApgar)) {
            $.messager.alert("提示", "请输入0-10之间的整数!", 'info');
            return;
        }
        var PatApgar = parseInt(PatApgar);
        if ((PatApgar < 0) || (PatApgar>10)) {
            $.messager.alert("提示", "Apgar评分一般在0-10之间!", 'info');
            return;
        }
        //后台保存		
        var retval = $m({          //当前页(默认最后一页)
            ClassName: "DHCHAI.DPS.PAAdmSrv",
            MethodName: "UpdateApgar",
            aEpisodeID: obj.SelectPaadm,
            aPatApgar: PatApgar
        }, false)
        if (retval == "1") {
            var retval = $m({
                ClassName: "DHCHAI.IRS.ICULogSrv",
                MethodName: "CreateICULogByOEOrd",
                aDateFrom: SurveryDate,
                aDateTo: SurveryDate,
                aLocDr: LocID,
                aEpisodeDr: obj.SelectPaadm
            }, false)
            var retval = $m({
                ClassName: "DHCHAI.IRS.ICULogSrv",
                MethodName: "CreateICULogByDay",
                aDateFrom: SurveryDate,
                aDateTo: SurveryDate,
                aLocDr: LocID
            }, false)
            //刷新表格
            obj.refreshgridNICULoc();
            $HUI.dialog('#LayerApgar').close();
        }
        else {
           $.messager.alert("提示", "保存Apgar评分失败!", 'info');
        }
    });
    
    //刷新ICU科室患者明细
    obj.refreshgridNICULoc = function () {
        $("#gridNICULoc").datagrid("loading");
        obj.gridNICULoc.load({
            ClassName: "DHCHAI.IRS.ICULogSrv",
            QueryName: "QryICUAdmStr",
            aDate: SurveryDate,
            aLocDr: LocID,
        })
    }
    //NICU科室患者 生成
    $("#btnNICUGreat").on('click', function () {
        //根据医嘱生成插拔管日志
        var Count = 0;
        var aDateFrom = SurveryDate;
        var aDateTo = SurveryDate;
        var aLocDr = LocID;
        var aEpisodeDr = "";
        var rowsdata = $('#gridNICULoc').datagrid('getRows');;
        for (var indRst = 0; indRst < rowsdata.length; indRst++) {
            var data = rowsdata[indRst];
            var retval = $m({
                ClassName: "DHCHAI.IRS.ICULogSrv",
                MethodName: "CreateICULogByOEOrd",
                aDateFrom: aDateFrom,
                aDateTo: aDateTo,
                aLocDr: aLocDr,
                aEpisodeDr: aEpisodeDr
            }, false)
            if (parseInt(retval) > 0) {
                Count++;
            }
        }
        //add 20190513 生成日志明细同时生成日志汇总
        var retval = $m({
            ClassName: "DHCHAI.IRS.ICULogSrv",
            MethodName: "CreateICULogByDay",
            aDateFrom: aDateFrom,
            aDateTo: aDateTo,
            aLocDr: aLocDr
        }, false)
        if (parseInt(retval) > 0) {
            obj.refreshgridNICULoc();
            $.messager.alert("提示", "根据医嘱自动生成插拔管日志(" + Count + "条)成功!", 'info');
        }
    });
    //NICU科室患者 提交
    $("#btnNICUSubmit").on('click', function () {
        var rows = $('#gridNICULoc').datagrid('getRows');

        var total = 0;        //记录条数
        for (var i = 0; i < rows.length; i++) {
            var RowID = rows[i].RowID;
            var Paadm = rows[i].Paadm;
            var ILLocDr = LocID;
            var ILDate = SurveryDate;

            var TubeInfo = Common_CheckboxValue("NICU" + RowID);
            var ILIsVAP = TubeInfo.indexOf("VAP") >= 0 ? 1 : 0;
            var ILIsPICC = TubeInfo.indexOf("PICC") >= 0 ? 1 : 0;
            var ILIsUC = TubeInfo.indexOf("UC") >= 0 ? 1 : 0;
            var ILIsOper = 0

            var InputStr = "";
            InputStr += "^" + Paadm;
            InputStr += "^" + ILLocDr;
            InputStr += "^" + ILDate;
            InputStr += "^" + ILIsVAP;
            InputStr += "^" + ILIsPICC;
            InputStr += "^" + ILIsUC;
            InputStr += "^" + ILIsOper;
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
            $.messager.alert("提示", "NICU日志确认成功!", 'info');

            obj.refreshNICU();    //刷新NICU患者日志
            $HUI.dialog('#LayerNICUExt').close();    //关闭页面
        } else {
            $.messager.alert("提示", "NICU日志确认失败!", 'info');
            return;
        }
    });
    //7->NICU科室患者医嘱明细
    obj.refreshgridNICUOE = function (iPaAdm, iFlag) {
        $("#gridNICUOE").datagrid("loading");
        $cm({
            ClassName: "DHCHAI.IRS.ICULogSrv",
            QueryName: "QryICUAdmOeItem",
            aPaAdm: iPaAdm,
            aFlag: iFlag,
            page: 1,
            rows: 999
        }, function (rs) {
            $('#gridNICUOE').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
        });
    }
    //8->NICU三管医嘱点击
    $("#btnNICUAll").on('click', function () {
        $('#btnNICUAll').css("background-color", "#dbedf9");
        $('#btnNICUPICC').css("background-color", "white");
        $('#btnNICUVAP').css("background-color", " white");
        obj.refreshgridNICUOE(obj.SelectPaadm, 0);
    })
    $("#btnNICUPICC").on('click', function () {
        $('#btnNICUAll').css("background-color", " white");
        $('#btnNICUPICC').css("background-color", "#dbedf9");
        $('#btnNICUVAP').css("background-color", " white");
        obj.refreshgridNICUOE(obj.SelectPaadm, 1);
    })
    $("#btnNICUVAP").on('click', function () {
        $('#btnNICUAll').css("background-color", "white ");
        $('#btnNICUPICC').css("background-color", "white");
        $('#btnNICUVAP').css("background-color", " #dbedf9");
        obj.refreshgridNICUOE(obj.SelectPaadm, 2);
    })
    
}

