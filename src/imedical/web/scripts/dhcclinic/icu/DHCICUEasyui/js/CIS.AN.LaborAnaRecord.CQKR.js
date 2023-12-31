var laborAnaRecord={
    opts:{},
    initPage:function(){
        var _this=laborAnaRecord;
        operDataManager.initFormData(_this.loadAppData);
        _this.initOperActions();
        operDataManager.setCheckChange();
        SignTool.initSignature();
    },

    initOperActions:function(){
        var _this=laborAnaRecord;
        $("#btnSave").linkbutton({
            onClick:function(){
                operDataManager.saveOperDatas();
            }
        });

        $("#btnRefresh").linkbutton({
            onClick:function(){
                window.location.reload();
            }
        });

        $("#btnPrint").linkbutton({
            onClick:function(){
                var operDataList=operDataManager.getFormOperDatas(".operdata");
                var operDatas={};
                if(operDataList && operDataList.length>0){
                    for(var i=0;i<operDataList.length;i++){
                        var operData=operDataList[i];
                        operDatas[operData.DataItem]=operData.DataValue;
                    }
                }
                _this.print(_this.opts.appData,operDatas);
            }
        });
    },

    loadAppData:function(appData){
        var _this=laborAnaRecord;
        _this.opts.appData=appData;
        $("#PrevDiagnosis").val(appData.PrevDiagnosis);
    },

    print:function(appData,operDatas){
        var lodop = getLodop();
        lodop.PRINT_INIT("LaborAnaRecord");
        lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
        lodop.ADD_PRINT_IMAGE("1.5cm","4cm",985,124,"<img src='../service/dhcanop/img/logo.cqkr.png'>");
        lodop.SET_PRINT_STYLEA(0, "Stretch", 2);

        var htmlArr=[
            "<style> .line-textbox {border:none;border-bottom:1px solid #000;}",
                "table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size: 10.5pt;}",
                ".patinfo-title {margin-right:5px;}",
                ".patinfo-item {margin-right:10px;}",
                ".patinfo-title-right {display:inline-block;width:140px;text-align:right;}",
                ".line-textbox-center {border:none;border-bottom:1px solid #000;text-align:center}",
                ".print-row {padding:10px 10px 0 10px;}",
                ".print-title-row {padding:10px;}",
                "td .print-row:last-child {padding-bottom:10px;}",
            "</style>",
            "<div style='text-align:center;font-size:18pt;width:490pt;padding:10px 0;'>分娩镇痛记录及随访单</div>",
            "<div class='print-title-row' style='padding-bottom:0;'>",
                "<span class='patinfo-title'>患者姓名：</span>",
                "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:150pt;' value='"+appData.PatName+"'></span>",
                "<span class='patInfo-title'>性别：</span>",
                "<span class='patInfo-item'><input type='text' class='line-textbox' style='width:75pt;' value='"+appData.PatGender+"'></span>",
                "<span class='patInfo-title'>年龄：</span>",
                "<span class='patInfo-item'><input type='text' class='line-textbox' style='width:75pt;' value='"+appData.PatAge+"'></span>",
            "</div>",
            "<div class='print-title-row'>",
                "<span class='patinfo-title'>科&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;室：</span>",
                "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:150pt;' value='"+appData.PatDeptDesc+"'></span>",
                "<span class='patInfo-title'>床号：</span>",
                "<span class='patInfo-item'><input type='text' class='line-textbox' style='width:63pt;' value='"+appData.PatBedCode+"'></span>",
                "<span class='patInfo-title'>住院号：</span>",
                "<span class='patInfo-item'><input type='text' class='line-textbox' style='width:75pt;' value='"+appData.MedcareNo+"'></span>",
            "</div>",
            "<table style='width:490pt'>",
                "<tr>",
                    "<td style='width:15pt;text-align:center;'>一般情况</td>",
                    "<td colspan='2'>",
                        "<div class='print-row'>",
                            "<span class='patinfo-title'>术前诊断：</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox' style='min-width:390pt;' value='"+(appData.PrevDiagnosis || '')+"'></span>",
                        "</div>",
                        "<div class='print-row'>",
                            "<span class='patinfo-title'>ASA分级：</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox-center' style='width:60pt;' value='"+(operDatas.ASAClass || '')+"'></span>",
                            "<span class='patinfo-title'>NYHA分级：</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox-center' style='width:60pt;' value='"+(operDatas.NYHAClass || '')+"'></span>",
                            "<span class='patinfo-title'>阜外病人：</span>",
                            "<span class='patinfo-item'><input type='checkbox' "+(operDatas.FuwaiPatient==="否"?"checked":"")+">否</span>",
                            "<span class='patinfo-item'><input type='checkbox' "+(operDatas.FuwaiPatient==="是"?"checked":"")+">是</span>",
                        "</div>",
                        "<div class='print-row'>",
                            "<span class='patinfo-title'>麻醉前特殊情况：</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:330pt;' value='"+(operDatas.PreANCondition || '')+"'></span>",
                        "</div>",
                    "</td>",
                "</tr>",
                "<tr>",
                    "<td style='width:15pt;text-align:center;' rowspan='3'>操作记录</td>",
                    "<td colspan='2'>",
                        "<div class='print-row'>",
                            "<span class='patinfo-title'>宫口开大程度：</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox-center' style='width:60pt;' value='"+(operDatas.UterineMouthDegree || '')+"'> cm</span>",
                            "<span class='patinfo-title'>穿刺间隙：</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox-center' style='width:60pt;' value='"+(operDatas.PunctureSpace || '')+"'></span>",
                            "<span class='patinfo-title'>置管深度：</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox-center' style='width:60pt;' value='"+(operDatas.CatheterDepth || '')+"'> cm</span>",
                        "</div>",
                        "<div class='print-row'>",
                            "<span class='patinfo-title'>试探剂量：</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox-center' style='width:60pt;' value='"+(operDatas.TestVolume || '')+"'> ml</span>",
                            "<span class='patinfo-title'>时间：</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox-center' style='width:60pt;' value='"+(operDatas.TestTime || '')+"'></span>",
                            "<span class='patinfo-title'>麻醉平面：</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox-center' style='width:60pt;' value='"+(operDatas.AnaPlane || '')+"'></span>",
                        "</div>",
                        "<div class='print-row'>",
                            "<span class='patinfo-title'>操作过程顺利：</span>",
                            "<span class='patinfo-item'><input type='checkbox' "+(operDatas.ProcessSmooth==="是"?"checked":"")+">是</span>",
                            "<span class='patinfo-item'><input type='checkbox' "+(operDatas.ProcessSmooth==="否"?"checked":"")+">否</span>",
                            "<span class='patinfo-title'>生命体征：</span>",
                            "<span class='patinfo-item'><input type='checkbox' "+(operDatas.VitalSign==="平稳"?"checked":"")+">平稳</span>",
                            "<span class='patinfo-item'><input type='checkbox' "+(operDatas.VitalSign==="不平稳"?"checked":"")+">不平稳</span>",
                        "</div>",
                        "<div class='print-row'>",
                            "<span class='patinfo-title'>PCEA配方：</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox-center' style='width:240pt;' value='"+(operDatas.PCEA || '')+"'></span>",
                            "<span class='patinfo-title'>总药液量：</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox-center' style='width:60pt;' value='"+(operDatas.LiquidVolume || '')+"'> ml</span>",
                        "</div>",
                        "<div class='print-row'>",
                            "<span class='patinfo-title'>PCEA设置：负荷量：</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox-center' style='width:24pt;' value='"+(operDatas.LoadVolume || '')+"'> ml</span>",
                            "<span class='patinfo-title'>持续量：</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox-center' style='width:24pt;' value='"+(operDatas.ContinueVolume || '')+"'> ml</span>",
                            "<span class='patinfo-title'>按压量：</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox-center' style='width:24pt;' value='"+(operDatas.PressVolume || '')+"'> ml</span>",
                            "<span class='patinfo-title'>锁定时间：</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox-center' style='width:24pt;' value='"+(operDatas.LockTime || '')+"'> min</span>",
                        "</div>",
                    "</td>",
                "</tr>",
                "<tr>",
                    "<td style='width:15pt;text-align:center;'>生命体征</td>",
                    "<td>",
                        "<div class='print-row'>",
                            "<span class='patinfo-title-right'>麻醉前： BP</span>",
                            "<span class='patinfo-item'>",
                                "<input type='text' class='line-textbox-center' style='width:45pt;' value='"+(operDatas.PreANNBPS || '')+"'> / ",
                                "<input type='text' class='line-textbox-center' style='width:45pt;' value='"+(operDatas.PreANNBPD || '')+"'> mmHg",
                            "</span>",
                            "<span class='patinfo-title'>HR</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox-center' style='width:45pt;' value='"+(operDatas.PreANHR || '')+"'> 次/分</span>",
                            "<span class='patinfo-title'>SpO2</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox-center' style='width:45pt;' value='"+(operDatas.PreANSPO2 || '')+"'> %</span>",
                        "</div>",
                        "<div class='print-row'>",
                            "<span class='patinfo-title-right'>麻醉后五分钟： BP</span>",
                            "<span class='patinfo-item'>",
                                "<input type='text' class='line-textbox-center' style='width:45pt;' value='"+(operDatas.PostAN5NBPS || '')+"'> / ",
                                "<input type='text' class='line-textbox-center' style='width:45pt;' value='"+(operDatas.PostAN5NBPD || '')+"'> mmHg",
                            "</span>",
                            "<span class='patinfo-title'>HR</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox-center' style='width:45pt;' value='"+(operDatas.PostAN5HR || '')+"'> 次/分</span>",
                            "<span class='patinfo-title'>SpO2</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox-center' style='width:45pt;' value='"+(operDatas.PostAN5SPO2 || '')+"'> %</span>",
                        "</div>",
                        "<div class='print-row'>",
                            "<span class='patinfo-title-right'>麻醉后三十分钟： BP</span>",
                            "<span class='patinfo-item'>",
                                "<input type='text' class='line-textbox-center' style='width:45pt;' value='"+(operDatas.PostAN30NBPS || '')+"'> / ",
                                "<input type='text' class='line-textbox-center' style='width:45pt;' value='"+(operDatas.PostAN30NBPD || '')+"'> mmHg",
                            "</span>",
                            "<span class='patinfo-title'>HR</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox-center' style='width:45pt;' value='"+(operDatas.PostAN30HR || '')+"'> 次/分</span>",
                            "<span class='patinfo-title'>SpO2</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox-center' style='width:45pt;' value='"+(operDatas.PostAN30SPO2 || '')+"'> %</span>",
                        "</div>",
                    "</td>",
                "</tr>",
                "<tr>",
                    "<td colspan='2'>",
                        "<div class='print-row'>",
                            "<span class='patinfo-title'>麻醉前VAS评分：</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox-center' style='width:45pt;' value='"+(operDatas.PreANVAS || '')+"'> </span>",
                            "<span class='patinfo-title'>麻醉后VAS评分：</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox-center' style='width:45pt;' value='"+(operDatas.PostANVAS || '')+"'></span>",
                            "<span class='patinfo-title'>Bromage评分：</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox-center' style='width:45pt;' value='"+(operDatas.BromageScore || '')+"'></span>",
                        "</div>",
                        "<div class='print-row'>",
                            "<span class='patinfo-title'>备注：</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox' style='min-width:390pt;' value='"+(operDatas.OperationNote || '')+"'> </span>",
                        "</div>",
                    "</td>",
                "</tr>",
                "<tr>",
                    "<td colspan='3'>",
                        "<div class='print-row'>",
                            "<span class='patinfo-title'>麻醉医生：</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:180pt;' value=''> </span>",
                            "<span class='patinfo-title'>日期：</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:120pt;' value='"+(operDatas.LaborAnaSignDT || '')+"'> </span>",
                        "</div>",
                    "</td>",
                "</tr>",
                "<tr>",
                    "<td style='width:15pt;text-align:center;'>随访记录</td>",
                    "<td colspan='2'>",
                        "<div class='print-row'>",
                            "<span class='patinfo-title'>一般情况：</span>",
                            "<span class='patinfo-item'><input type='checkbox' "+(operDatas.LVGeneralCondition==="好"?"checked":"")+">好</span>",
                            "<span class='patinfo-item'><input type='checkbox' "+(operDatas.LVGeneralCondition==="欠佳"?"checked":"")+">欠佳</span>",
                            "<span class='patinfo-item'><input type='checkbox' "+(operDatas.LVGeneralCondition==="差"?"checked":"")+">差</span>",
                        "</div>",
                        "<div class='print-row'>",
                            "<span class='patinfo-title'>生命体征：</span>",
                            "<span class='patinfo-item'><input type='checkbox' "+(operDatas.LVVitalSign==="稳定"?"checked":"")+">稳定</span>",
                            "<span class='patinfo-item'><input type='checkbox' "+(operDatas.LVVitalSign==="不稳定"?"checked":"")+">不稳定</span>",
                        "</div>",
                        "<div class='print-row'>",
                            "<span class='patinfo-title'>是否已拔出硬膜外导管：</span>",
                            "<span class='patinfo-item'><input type='checkbox' "+(operDatas.LVTubeOut==="已拔管"?"checked":"")+">已拔管</span>",
                            "<span class='patinfo-item'><input type='checkbox' "+(operDatas.LVTubeOut==="未拔管"?"checked":"")+">未拔管</span>",
                        "</div>",
                        "<div class='print-row'>",
                            "<span class='patinfo-title'>是否有并发症：</span>",
                            "<span class='patinfo-item'><input type='checkbox' "+(operDatas.AnaComplication==="否"?"checked":"")+">否</span>",
                            "<span class='patinfo-item'><input type='checkbox' "+(operDatas.AnaComplication==="是"?"checked":"")+">是</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:180pt;' value='"+(operDatas.AnaComplicationNote || '')+"'> </span>",
                        "</div>",
                    "</td>",
                "</tr>",
                "<tr>",
                    "<td colspan='3'>",
                        "<div class='print-row'>",
                            "<span class='patinfo-title'>麻醉医生：</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:180pt;' value=''></span>",
                            "<span class='patinfo-title'>日期：</span>",
                            "<span class='patinfo-item'><input type='text' class='line-textbox' style='width:120pt;' value='"+(operDatas.LaborVisitSignDT || '')+"'> </span>",
                        "</div>",
                    "</td>",
                "</tr>",
            "</table>"
        ];

        lodop.ADD_PRINT_HTM("3cm","1.5cm","490pt",1000,htmlArr.join(""));
        lodop.SET_PREVIEW_WINDOW(1, 2, 0, 0, 0, "");
        lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1); //打印后自动关闭预览窗口
        lodop.PREVIEW();
    }
}

$(document).ready(laborAnaRecord.initPage);





