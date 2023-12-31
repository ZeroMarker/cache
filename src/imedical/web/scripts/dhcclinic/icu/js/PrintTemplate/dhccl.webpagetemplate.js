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
                var OnLoadedMethod = sheet.OnLoadedMethod;
                if(scriptPath){
                    loadJS(scriptPath, function(){});
                }
                if(OnLoadedMethod){
                    try {
                        eval(OnLoadedMethod+"()");
                    } catch (err) {
                        console.error(err);
                    }
                }
            }
        });

        var editPluginManager = new EditPluginManager({
            sheetContext: sheetContext,
            readonly: readonly
        });
        editPluginManager.setEditPluginList(displaySheet.getEditPluginArea());

        SignTool.loadSignature(function(){
            return editPluginManager.sheetContext.getUserFillData();
        });


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

        $("#btnSave").linkbutton({
            onClick: function () {
                editPluginManager.saveOperDatas();
                var OnSavedMethod = sheet.OnSavedMethod;
                if(OnSavedMethod){
                    try {
                        eval(OnSavedMethod+"()");
                    } catch (err) {
                        console.error(err);
                    }
                }
            }
        });

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

        $("#btnPrintWithoutPreview").linkbutton({
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
                lodopPrintView.print(true);
            }
        });

        $("#btnSaveAndPrint").linkbutton({
            onClick: function () {
                if (displaySheet.getPageSetting().PrintCheckRequired) {
                    if (!editPluginManager.checkRequired()) return;
                }

                editPluginManager.saveOperDatas(function (msg) {
                    if (msg.indexOf("S^") === 0) {
                        $.messager.confirm('提示', "保存成功，是否打印？", function (r) {
                            if (r) {
                                $("#btnPrint").click();
                            }
                        });
                    } else {
                        $.messager.alert("提示", "保存失败:" + msg, "error");
                    }
                });
            }
        });

        $("#btnArchive").linkbutton({
            onClick: function () {
                if (displaySheet.getPageSetting().ArchiveCheckRequired) {
                    if (!editPluginManager.checkRequired()) return;
                }

                var curOperSchedule = editPluginManager.operAppData;
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
                lodopPrintView.archive({
                    ip: session.ArchiveServerIP,
                    port: session.ArchiveServerPort,
                    type: "AN",
                    id: curOperSchedule.OPSID,
                    date: curOperSchedule.OperDate,
                    filename: session.ModuleDesc + ".pdf",
                    patName: curOperSchedule.PatName,
                    moduleName: session.ModuleDesc
                });
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

    }, false);
}