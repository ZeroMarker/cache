var outAnaRecord = {
    opts: {},
    initPage: function() {
        dhccl.parseDateFormat();
        dhccl.parseDateTimeFormat();
        var _this = outAnaRecord;
        _this.loadCommonDatas();
        operDataManager.initFormData(_this.loadAppData);
        _this.initOperDataForm();
        _this.initOperActions();
        operDataManager.setCheckChange();
        SignTool.initSignature();
        SignTool.loadSignature();
        _this.initFormValue();
    },

    initOperDataForm: function() {
        var _this = outAnaRecord;
        $("#ASAClass").combobox({
            editable: false,
            valueField: "RowId",
            textField: "Description",
            data: _this.opts.ASAClass
        });

        $("#AnaMethod").combobox({
            editable: false,
            valueField: "RowId",
            textField: "Description",
            data: _this.opts.AnaMethodList,
            rowStyle: "checkbox",
            multiple: true
        });
    },

    initFormValue: function() {
        var _this = outAnaRecord;
        if (_this.opts.appData) {
            var ASAClass = _this.opts.appData.ASAClass || '';
            var anaMethod = _this.opts.appData.AnaMethod || '';
            if (anaMethod) {
                var anaMethodArr = anaMethod.split(",");
                $("#AnaMethod").combobox("setValues", anaMethodArr);
            }
            if (ASAClass) {
                $("#ASAClass").combobox("setValue", ASAClass);
            }
        }
    },

    initOperActions: function() {
        var _this = outAnaRecord;
        $("#btnSave").linkbutton({
            onClick: function() {
                var anaMethodArr = $("#AnaMethod").combobox("getValues");
                var anaMethod = (anaMethodArr && anaMethodArr.length > 0) ? anaMethodArr.join(",") : "";
                var ASAClass = $("#ASAClass").combobox("getValue");
                var anaesthesia = {
                    RowId: _this.opts.appData.AnaestID,
                    AnaMethod: anaMethod,
                    ASAClass: ASAClass,
                    ClassName: ANCLS.Model.Anaesthesia
                }
                operDataManager.saveOperDatas("", [anaesthesia]);
            }
        });

        $("#btnRefresh").linkbutton({
            onClick: function() {
                window.location.reload();
            }
        });

        $("#btnPrint").linkbutton({
            onClick: function() {
                var appData=operDataManager.getOperAppData();  //重新获取
                //var appData = _this.opts.appData;
                var operDatas = _this.getPageData();
                _this.print(appData, operDatas, session.ExtHospDesc || "东华标准版医院");
            }
        });
    },

    loadAppData: function(appData) {
        var _this = outAnaRecord;
        _this.opts.appData = appData;
        for (var key in appData) {
            $("#" + key).text(appData[key]);
        }
    },

    /**
     * 加载公共数据(新增申请和修改申请都需要用到的基础数据和配置数据)
     */
    loadCommonDatas: function() {
        var _this = outAnaRecord;
        var queryPara = [{
                ListName: "ASAClass",
                ClassName: ANCLS.BLL.CodeQueries,
                QueryName: "FindASAClass",
                ArgCnt: 0
            },
            {
                ListName: "AnaMethodList",
                ClassName: ANCLS.BLL.CodeQueries,
                QueryName: "FindAnaestMethod",
                Arg1: "",
                ArgCnt: 1
            }
        ];

        var queryData = dhccl.getDatas(ANCSP.DataQueries, {
            jsonData: dhccl.formatObjects(queryPara)
        }, "json");
        if (queryData) {
            for (var key in queryData) {
                _this.opts[key] = queryData[key];
            }
        }
    },
    getPageData: function() {
        var opsId = session.OPSID;
        var operDataList = dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: ANCLS.BLL.OperData,
            QueryName: 'FindOperDataBySheet',
            Arg1: session.RecordSheetID,
            ArgCnt: 1
        }, "json", false);

        var pageData = {};
        var length = operDataList.length;
        for (var i = 0; i < length; i++) {
            pageData[operDataList[i].DataItem] = operDataList[i].DataValue;
        }

        return pageData;
    },
    print: function(appData, operDatas, hospDesc) {
        var lodop = getLodop();
        lodop.PRINT_INIT("LaborAnaRecord");
        lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
        //lodop.ADD_PRINT_IMAGE("1.5cm", "4cm", 985, 124, "<img src='../service/dhcanop/img/logo.cqkr.png'>");
        //lodop.SET_PRINT_STYLEA(0, "Stretch", 2);

        var htmlArr = [
            "<style> .line-textbox {border:none;border-bottom:1px solid #000;}",
            "table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size: 10.5pt;}",
            ".patinfo-title {margin-right:5px;}",
            ".patinfo-item {margin-right:10px;}",
            ".patinfo-title-right {display:inline-block;width:140px;text-align:right;}",
            ".line-textbox-center {border:none;border-bottom:1px solid #000;text-align:center}",
            ".print-row {padding:10px 10px 0 10px;}",
            ".print-title-row {padding:10px;}",
            "title-indent {display:inline-block;width:28px;}",
            "td .print-row:last-child {padding-bottom:10px;}",
            "</style>",
            "<div style='text-align:center;font-size:18pt;width:490pt;padding:10px 0;'>" + hospDesc + "</div>",
            "<div style='text-align:center;font-size:18pt;width:490pt;padding:10px 0;'>门诊(日间)手术麻醉记录</div>",
            "<div class='print-title-row' style='padding-bottom:0;'>",
            "<span class='patinfo-title'>姓名：</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:150pt;' value='" + appData.PatName + "'></span>",
            "<span class='patInfo-title'>性别：</span>",
            "<span class='patInfo-item'><input type='text' class='line-textbox' style='width:75pt;' value='" + appData.PatGender + "'></span>",
            "<span class='patInfo-title'>年龄：</span>",
            "<span class='patInfo-item'><input type='text' class='line-textbox' style='width:75pt;' value='" + appData.PatAge + "'></span>",
            "<span class='patInfo-title'>科室：</span>",
            "<span class='patInfo-item'><input type='text' class='line-textbox' style='width:75pt;' value='" + appData.PatDeptDesc + "'></span>",
            "<span class='patInfo-title'>登记号：</span>",
            "<span class='patInfo-item'><input type='text' class='line-textbox' style='width:75pt;' value='" + appData.RegNo + "'></span>",
            "<span class='patInfo-title'>费别：</span>",
            "<span class='patInfo-item'><input type='text' class='line-textbox' style='width:75pt;' value='" + (appData.AdmReason || "") + "'></span>",
            "</div>",
            "<div class='print-title-row'>",
            "<span class='patinfo-title'>术前诊断：</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:150pt;' value='" + (appData.PrevDiagnosisDesc || "") + "'></span>",
            "<span class='patInfo-title'>手术日期：</span>",
            "<span class='patInfo-item'><input type='text' class='line-textbox' style='width:63pt;' value='" + (appData.OperDate || "") + "'></span>",
            "</div>",
            "<div class='print-title-row'>",
            "<span class='patinfo-title'>实施手术：</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:150pt;' value='" + (appData.OperDesc || "") + "'></span>",
            "<span class='patInfo-title'>ASA分级：</span>",
            "<span class='patInfo-item'><input type='text' class='line-textbox' style='width:63pt;' value='" + (appData.ASAClassDesc || "") + "'></span>",
            "</div>",
            "<div class='print-title-row'>",
            "<span class='patinfo-title'>麻醉方法：</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:420pt;' value='" + (appData.AnaMethodDesc || "") + "'></span>",
            "</div>",
            "<div class='print-row'>麻醉过程</div>",
            "<div class='print-title-row'>",
            "<span class='title-indent'></span>",
            "<span class='patinfo-title'>麻醉前：</span>",
            "<span class='patinfo-title'>NBP：</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:20pt;' value='" + (operDatas.PreAnaNBPS || "") + "'></span>",
            "<span class='patinfo-item'>/<input type='text' class='line-textbox' style='width:15pt;' value='" + (operDatas.PreAnaNBPD || "") + "'>mmHg</span>",
            "<span class='patinfo-title'>HR：</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:15pt;' value='" + (operDatas.PreAnaHR || "") + "'>次/分</span>",
            "<span class='patinfo-title'>SPO2：</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:15pt;' value='" + (operDatas.PreAnaSPO2 || "") + "'>%</span>",
            "<span class='patinfo-title'>RR：</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:15pt;' value='" + (operDatas.PreAnaRR || "") + "'>次/分</span>",
            "</div>",
            "<div class='print-title-row'>",
            "<span class='title-indent'></span>",
            "<span class='patinfo-title'>麻醉中：</span>",
            "<span class='patinfo-title'>NBP：</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:20pt;' value='" + (operDatas.AnaNBPS || "") + "'></span>",
            "<span class='patinfo-item'>/<input type='text' class='line-textbox' style='width:15pt;' value='" + (operDatas.AnaNBPD || "") + "'>mmHg</span>",
            "<span class='patinfo-title'>HR：</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:15pt;' value='" + (operDatas.AnaHR || "") + "'>次/分</span>",
            "<span class='patinfo-title'>SPO2：</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:15pt;' value='" + (operDatas.AnaSPO2 || "") + "'>%</span>",
            "<span class='patinfo-title'>RR：</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:15pt;' value='" + (operDatas.AnaRR || "") + "'>次/分</span>",
            "</div>",
            "<div class='print-title-row'>",
            "<span class='title-indent'></span>",
            "<span class='patinfo-title'>术毕：</span>",
            "<span class='patinfo-title'>NBP：</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:20pt;' value='" + (operDatas.PostOperNBPS || "") + "'></span>",
            "<span class='patinfo-item'>/<input type='text' class='line-textbox' style='width:15pt;' value='" + (operDatas.PostOperNBPD || "") + "'>mmHg</span>",
            "<span class='patinfo-title'>HR：</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:15pt;' value='" + (operDatas.PostOperHR || "") + "'>次/分</span>",
            "<span class='patinfo-title'>SPO2：</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:15pt;' value='" + (operDatas.PostOperSPO2 || "") + "'>%</span>",
            "<span class='patinfo-title'>RR：</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:15pt;' value='" + (operDatas.PostOperRR || "") + "'>次/分</span>",
            "</div>",
            "<div class='print-title-row'>",
            "<span class='patinfo-title'></span>",
            "<span class='patinfo-item'><input type='checkbox' " + (operDatas.WakingDurationST === "是" ? "checked" : "") + ">术毕即时清醒</span>",
            "<span class='patinfo-item'>术毕<input type='text' class='line-textbox' style='width:15pt;' value='" + (operDatas.WakingDuration || "") + "'>分钟清醒</span>",
            "</div>",
            "<div class='print-title-row'>",
            "<span class='patinfo-title'>去向：</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:150pt;' value='" + (operDatas.OutLocation || "") + (operDatas.OutLocationOther || "") + "'></span>",
            "</div>",
            "<div class='print-title-row'>",
            "<span class='title-indent'></span>",
            "<span class='patinfo-title'>出恢复室：</span>",
            "<span class='patinfo-title'>NBP：</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:20pt;' value='" + (operDatas.PACUOutNBPS || "") + "'></span>",
            "<span class='patinfo-item'>/<input type='text' class='line-textbox' style='width:15pt;' value='" + (operDatas.PACUOutNBPD || "") + "'>mmHg</span>",
            "<span class='patinfo-title'>HR：</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:15pt;' value='" + (operDatas.PACUOutHR || "") + "'>次/分</span>",
            "<span class='patinfo-title'>SPO2：</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:15pt;' value='" + (operDatas.PACUOutSPO2 || "") + "'>%</span>",
            "<span class='patinfo-title'>RR：</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:15pt;' value='" + (operDatas.PACUOutRR || "") + "'>次/分</span>",
            "</div>",
            "<div class='print-title-row'>",
            "<span class='title-indent'></span>",
            "<span class='patinfo-title'>Steward评分：</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:30pt;' value='" + (operDatas.StewardScore || "") + "'></span>",
            "</div>",
            "</div>",
            "<div class='print-row'>麻醉用药</div>",
            "<div class='print-title-row'>",
            "<span class='patinfo-title'>丙泊酚</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:15pt;' value='" + (operDatas.Propofol || "") + "'>mg</span>",
            "<span class='patinfo-title'>咪达唑仑</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:15pt;' value='" + (operDatas.Midazolam || "") + "'>mg</span>",
            "<span class='patinfo-title'>脱氨司琼</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:15pt;' value='" + (operDatas.Desaminergone || "") + "'>mg</span>",
            "<span class='patinfo-title'>地佐辛</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:15pt;' value='" + (operDatas.Dezocine || "") + "'>mg</span>",
            "<span class='patinfo-title'>多巴胺</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:15pt;' value='" + (operDatas.Dopamine || "") + "'>mg</span>",
            "</div>",
            "<div class='print-title-row'>",
            "<span class='patinfo-title'>芬太尼</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:15pt;' value='" + (operDatas.Fentanyl || "") + "'>mg</span>",
            "<span class='patinfo-title'>舒芬太尼</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:15pt;' value='" + (operDatas.Sufentanil || "") + "'>mg</span>",
            "<span class='patinfo-title'>阿托品</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:15pt;' value='" + (operDatas.Atropine || "") + "'>mg</span>",
            "<span class='patinfo-title'>其他</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:15pt;' value='" + (operDatas.DrugOther || "") + "'></span>",
            "</div>",
            "<div class='print-title-row'>",
            "<span class='patinfo-title'>麻醉开始时间</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:90pt;' value='" + (operDatas.AnaStartDT || "") + "'></span>",
            "<span class='patinfo-title'>麻醉时长</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:30pt;' value='" + (operDatas.AnaDuration || "") + "'>分钟</span>",
            "<span class='patinfo-title'>手术时长</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:30pt;' value='" + (operDatas.OperDuration || "") + "'>分钟</span>",
            "</div>",
            "<div class='print-title-row'>",
            "<span class='patinfo-title'>备注</span>",
            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:260pt;' value='" + (operDatas.DrugNote || "") + "'></span>",
            "</div>",
            "</div>",
        ];

        lodop.ADD_PRINT_HTM("3cm", "1.5cm", "490pt", 1000, htmlArr.join(""));

        lodop.ADD_PRINT_TEXT(1065, 400, 300, 15, "麻醉医生签名：");
        lodop.ADD_PRINT_TEXT(1065, 510, "100%", 20, $("#AnaDocSign").triggerbox("getValue"));
        lodop.ADD_PRINT_TEXT(1065, 600, 300, 15, "日期：");
        lodop.ADD_PRINT_TEXT(1065, 660, "100%", 20, $("#AnaDocSignDT").datetimebox("getValue"));

        lodop.SET_PREVIEW_WINDOW(1, 2, 0, 0, 0, "");
        lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1); //打印后自动关闭预览窗口
        lodop.PREVIEW();
    }
}

$(document).ready(outAnaRecord.initPage);