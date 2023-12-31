

EditPluginManager.prototype.init = function () {
	this.operAppData = this.sheetContext.getCommonConstData();
}

EditPluginManager.prototype.addEditPlugin = function (editPlugin) {
    this.pluginList.push(editPlugin);

    if(editPlugin.areaItem.Formula){
        this.formulaData.push({
            FormulaCode: editPlugin.areaItem.Code,
            FormulaDesc: editPlugin.areaItem.Formula
        });
    }

    if(this.readonly){
        editPlugin.disable();
    }

    var value = this.operAppData[editPlugin.code];
    if (this.operAppData.hasOwnProperty(editPlugin.code) && editPlugin.areaItem) {
        editPlugin.dataSource = "OperSchedule";
        editPlugin.setValue(value);
        editPlugin.disable();
    } else if (editPlugin.areaItem && editPlugin.areaItem.ValueFromSchedule) {
        value = this.operAppData[editPlugin.areaItem.ValueFromSchedule];
        if (value) {
            editPlugin.dataSource = "OperData";
            editPlugin.setValue(value);
        }
    }
}

EditPluginManager.prototype.loadScoreValues = function (scoreId) {
    this.clearAllPlugin();

    var data = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: "web.DHCICUScore",
        QueryName: "FindICUScoreData",
        Arg1: scoreId,
        ArgCnt: 1
    }, "json");
    for (var i = 0; i < data.length; i++) {
        var singleData = data[i];
        if (singleData && singleData.ItemCode) {
            var editPlugin = this.getEditPluginByCode(singleData.ItemCode);
            if (editPlugin && editPlugin.areaItem) {
                editPlugin.RowId = singleData.RowId;
                editPlugin.setValue(singleData.ItemValue);
            }
        }
    }
    console.dir(data);
}

EditPluginManager.prototype.saveScoreValues = function (scoreId, onSave) {
    var userId = dhccl.getQueryString("userId");
    var formOperDatas = [];
    for (var i = 0; i < this.pluginList.length; i++) {
        var plugin = this.pluginList[i];
        var nowValue = plugin.getValue();
        if(nowValue.indexOf(String.fromCharCode(2)) >= 0){
            $.messager.alert(plugin.areaItem.Desc+"含有特殊字符！请重新填写！")
            return [];
        }
        
        if (plugin.dataSource == "OperSchedule") continue;
        if (plugin.editType == "imgsign") continue;
        if (plugin.editType == "signature") continue;
        if (plugin.editType == "qrCode") continue;
        if (this.operAppData[plugin.code]) continue;

        var rowId = plugin.RowId;
        var itemDesc = plugin.areaItem.Desc;
        if (itemDesc == "") itemDesc = plugin.code;
        var dataNote = "";
        if (plugin.editType == "combobox") dataNote = plugin.getPrintValue();
        formOperDatas.push({
            RowId: rowId,
            ICUScore: scoreId,
            ItemCode: plugin.code,
            ItemDesc: itemDesc,
            ItemValue: nowValue,
            UpdateUser: userId,
            ItemNote: dataNote
        });
    }

    if (!formOperDatas || !formOperDatas.length || formOperDatas.length <= 0) {
        $.messager.alert("提示", "无需要保存数据!", "info");
        return;
    }

    var $this = this;
    var jsonData = dhccl.formatObjects(formOperDatas);
    dhccl.saveDatas(ANCSP.DataListService, {
        jsonData: jsonData,
        ClassName: "web.DHCICUScore",
        MethodName: "SaveICUScoreDatas"
    }, function (data) {
        $this.loadScoreValues(scoreId);
        dhccl.showMessage(data, "保存", null, null, function () {
            if (onSave) onSave();
        });
    });
}

$(initPage);

function initPage() {

    var sheetContext = new SheetContext({});
    sheetContext.loadSheetData(function(data){
        var sheet = data.Sheet;
        var valueObject = sheetContext.getCommonConstData();

        var readonly = dhccl.getQueryString("readonly") == "true"?true:false;
        var canvas = document.getElementById("myCanvas");
        var displaySheet = new DisplaySheet({
            canvas: canvas,
            sheet: sheet,
            editMode: true,
            valueObject: valueObject,
            ratio: {
                x: 14 / 12,
                y: 14 / 12,
                fontRatio: 14 / 12
            },
            onPageResize: function () {
                HIDPI();
            },
            onPageLoaded: function(){
                var scriptPath = sheet.ScriptPath;
                if(scriptPath){
                    loadJS(scriptPath, function(){});
                }
            }
        });

        var editPluginManager = new EditPluginManager({
            sheetContext: sheetContext,
            readonly: readonly
        });
        editPluginManager.setEditPluginList(displaySheet.getEditPluginArea());


        $("#pageNoTabs").PageNoTabs({
            pages: displaySheet.getPageNoArray(),
            hideAddNewButton: true,
            hideRemoveButton: true,
            onPageNoTabSelected: function (pageNo) {
                displaySheet.setCurrentPage(pageNo);
                editPluginManager.setEditPluginList(displaySheet.getEditPluginArea());
                editPluginManager.showCurrentPageEditPlugin(pageNo);
            }
        });

        $(canvas).data("displaySheet",displaySheet);

        $("#btnPrint").linkbutton({
            onClick: function () {
                if (displaySheet.getPageSetting().PrintCheckRequired) {
                    if (!editPluginManager.checkRequired()) return;
                }

                var valueObject = editPluginManager.getValueObject();
                var tableValuesArray = null;
                var lodopPrintView = window.LodopPrintView.instance;
                if (!lodopPrintView) {
                    lodopPrintView = window.LodopPrintView.init({
                        sheetData: sheet,
                        valueObject: valueObject
                    });
                } else {
                    lodopPrintView.setPrintData(valueObject, tableValuesArray);
                }
                lodopPrintView.print();
            }
        });

        $("#btnRefresh").linkbutton({
            onClick: function () {
                window.location.reload();
            }
        });

        function HIDPI() {
            var ratio = window.devicePixelRatio || 1;
            var canvas = document.getElementById("myCanvas");
            var context = canvas.getContext("2d");
            var oldWidth = canvas.width;
            var oldHeight = canvas.height;
            canvas.width = oldWidth * ratio;
            canvas.height = oldHeight * ratio;
            canvas.style.width = oldWidth + "px";
            canvas.style.height = oldHeight + "px";
            context.scale(ratio, ratio);
        }

        function loadJS(url, onJsLoaded) {
            var script = document.createElement('script');
            script.type = 'text/javascript';
            script.src = url;
            //IE
            if (script.readyState) {
                script.onreadystatechange = function () {
                    if (script.readyState == 'loaded' || script.readyState == 'complete') {
                        script.onreadystatechange = null;
                        if(onJsLoaded) onJsLoaded();
                    }
                };
            } else {
                //其他浏览器
                script.onload = function () {
                    if(onJsLoaded) onJsLoaded();
                };
            }
            document.getElementsByTagName('head')[0].appendChild(script);
        }


        $('#dataView').datagrid({
            singleSelect: true,
            idField: "RowId",
            fit:true,
            columns: [
                [{
                        field: 'RowId',
                        title: 'RowId',
                        width: 150,
                        hidden: true
                    },
                    {
                        field: 'SubmitDT',
                        title: '评分时间',
                        width: 150
                    },
                    {
                        field: 'TotalScore',
                        title: '分数',
                        width: 80
                    },
                    {
                        field: 'SubmitUserDesc',
                        title: '评分人',
                        width: 80
                    },
                    {
                        field: 'StatusDesc',
                        title: '状态',
                        width: 60,
                        styler: function (value, row, index) {
                            if (row.StatusDesc == "新建") {
                                return "background-color:pink;";
                            } else {
                                return "background-color:LimeGreen;";
                            }
                        }
                    }
                ]
            ],
            toolbar: [{
                text: '增加',
                iconCls: 'icon-add',
                handler: function () {
                    addScore();
                }
            }, {
                text: '删除',
                iconCls: 'icon-remove',
                handler: function () {
                    deleteScore();
                }
            }],
            onClickRow: function (rowIndex, rowData) {
                var scoreId = rowData.RowId;
                editPluginManager.loadScoreValues(scoreId);
                var assessDateTimePlugin = editPluginManager.getEditPluginByCode("AssessDateTime");
                if (assessDateTimePlugin) {
                    assessDateTimePlugin.setValue(rowData.SubmitDT);
                }
            }
        });


        function initChart(data) {
            var scoreDatetimeArr = [];
            var scoreValueArr = [];
            for (var i = 0; i < data.length; i++) {
                if (data[i].SubmitDT !== "" && data[i].TotalScore !== ""){
                    var submitDate= data[i].SubmitDT.split(" ")[0];
                    var submitTime= data[i].SubmitDT.split(" ")[1];
                    scoreDatetimeArr.push(submitDate+ "\r\n" + submitTime);
                    scoreValueArr.push(data[i].TotalScore);
                }
            }
    
            var myChart = echarts.init(document.getElementById('scoreChart'));
    
            var option = {
                xAxis: {
                    type: 'category',
                    data: scoreDatetimeArr
                },
                yAxis: {
                    type: 'value'
                },
                grid: {
                    x: 30,
                    y: 8
                },
                series: [{
                    data: scoreValueArr,
                    type: 'line'
                }]
            };
            myChart.setOption(option);
        }

        $("#btnSave").linkbutton({
            onClick: function () {
                var totalScorePlugin = editPluginManager.getEditPluginByCode("TotalScore");
                if (totalScorePlugin) {
                    var value = totalScorePlugin.getValue();
                    if (value == "" || value == null) {
                        $.messager.alert("提示", "请评估总评分！", "error");
                        return;
                    }
                }
                var scoreId = "";
                var row = $('#dataView').datagrid('getSelected');
                if(row) {
                    scoreId = row.RowId;
                }else{
                    var icuaId = dhccl.getQueryString("icuaId");
                    var userId = dhccl.getQueryString("userId");
                    var moduleId = dhccl.getQueryString("moduleId");
    
                    var ret = dhccl.runServerMethodNormal("web.DHCICUScore", "CreateScore", icuaId, moduleId, userId);
                    var retArray = ret.split("^");
                    if(retArray[0] == "S"){
                        scoreId = retArray[1];
                    }else{
                        $.messager.alert("提示", "保存评分失败:" + ret);
                        return;
                    }
                }
                if(scoreId){
                    editPluginManager.saveScoreValues(scoreId, function () {
                        loadScoreData();
                        $('#dataView').datagrid("selectRecord", scoreId);
                    });
                }else{
                    $.messager.alert("提示", "评分Id为空");
                    return;
                }
                
            }
        });

        loadScoreData();
    
        function loadScoreData() {
            var icuaId = dhccl.getQueryString("icuaId");
            var moduleId = dhccl.getQueryString("moduleId");
    
            dhccl.getDatas(ANCSP.DataQuery, {
                ClassName: "web.DHCICUScore",
                QueryName: "FindICUScore",
                Arg1: icuaId,
                Arg2: moduleId,
                ArgCnt: 2
            }, "json", true, function (data) {
                initChart(data);
                $('#dataView').datagrid("loadData", data);
            })
        }
    
        
    
        function addScore() {
            var icuaId = dhccl.getQueryString("icuaId");
            var userId = dhccl.getQueryString("userId");
            var moduleId = dhccl.getQueryString("moduleId");
    
            var ret = dhccl.runServerMethodNormal("web.DHCICUScore", "CreateScore", icuaId, moduleId, userId);
            dhccl.showMessage(ret, "新增", null, null, function () {
                loadScoreData();
            });
        }
    
        function deleteScore() {
            var row = $('#dataView').datagrid('getSelected');
            if (row) {
                $.messager.confirm('询问', '你确定要删除数据么?', function (r) {
                    if (r) {
                        var scoreId = row.RowId;
                        var ret = dhccl.runServerMethodNormal("web.DHCICUScore", "DeleteScore", scoreId);
                        dhccl.showMessage(ret, "删除", null, null, function () {
                            loadScoreData();
                            editPluginManager.clearAllPlugin();
                        });
                    }
                });
    
            } else {
                $.messager.alert("提示", "请选择要删除的行！");
            }
        }


    }, false);
}