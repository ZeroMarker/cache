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
            }/*,
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
            }*/
        });

        var editPluginManager = new EditPluginManager({
            sheetContext: sheetContext,
            readonly: readonly
        });


        //editPluginManager.setEditPluginList(displaySheet.getEditPluginArea());
        var pageNoArr = displaySheet.getPageNoArray();
        for (var i = pageNoArr.length - 1; i >= 0; i--) {
            var pageNo = pageNoArr[i];
            displaySheet.setCurrentPage(pageNo);
            editPluginManager.setEditPluginList(displaySheet.getEditPluginArea());
            editPluginManager.showCurrentPageEditPlugin(pageNo);
        }

        /*
        SignTool.loadSignature(function(){
            return editPluginManager.sheetContext.getUserFillData();
        });
        */
        SignTool.initSignatureBox();
        setSubmitState();

        loadPageMethod();
		
		function loadPageMethod(){
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

        $("#btnSubmit").linkbutton({
            onClick: function () {
                editPluginManager.saveOperDatas();

                var signCode = "";
                if (!signCode){
                    $('.signature').each(function (index, item) {
                        var code = $(this).attr('id');
                        if(!signCode) signCode = code;
                    });
                }
                if(!signCode){
                    $.messager.alert("提示","无签名代码","error");
                    return;
                }

                var operDatas = getOperDatas();
                if(!(operDatas && operDatas.length && operDatas.length>0)){
                    $.messager.alert("提示","未填写数据, 请填写保存后再提交!","error");
                    return;
                }
                
                var valueObject = editPluginManager.getValueObject();
                // 待签名数据
                var toSignData = JSON.stringify(operDatas);
                // 用户填写数据
                var archiveDataStr = dhccl.formatObjects(operDatas);
                // 表单打印数据
                var drawData = archiveRecordManager.getDrawData(valueObject, operDatas);

                archiveRecordManager.signAndRecordArchive(signCode, toSignData, archiveDataStr, drawData, "", function(){  
                    setSubmitState();
                });

                function getOperDatas(){
                    var targetOperDatas = [];
                    var operDatas = editPluginManager.getFormOperDatas();
                    for (let i = 0; i < operDatas.length; i++) {
                        var data = operDatas[i];
                        targetOperDatas.push({
                            DataItem: data.code,
                            DataItemDesc: data.desc,
                            DataValue: data.value,
                            DataNote: data.dataNote,
                            DataScore: data.score,
                            UpdateUserID: session.UserID
                        });
                    }
                    return targetOperDatas;
                }
            }
        });

        $("#btnRevokeSubmit").linkbutton({
            onClick: function () {
                var signCode = "";
                $('.signature').each(function (index, item) {
                    var code = $(this).attr('id');
                    if(!signCode) signCode = code;
                });
                if(!signCode){
                    $.messager.alert("提示","无签名代码","error");
                    return;
                }
                $.messager.confirm('确定', '你是否要撤销提交表单?', function(r){
                    if (r){
                        archiveRecordManager.revokeRecordArchive(signCode, function(){
                            SignTool.clearSignatureBoxList();
                            setSubmitState();
                        });
                    }
                });
            }
        });

        $("#btnPrint").linkbutton({
            onClick: function () {
                archiveRecordManager.print();
            }
        });

        $("#btnArchive").linkbutton({
            onClick: function () {
                archiveRecordManager.archive();
            }
        });

        function setSubmitState(){
            var archiveCodeStr = "";
            $('.signature').each(function (index, item) {
                var code = $(this).attr('id');
                if(!archiveCodeStr) archiveCodeStr = code;
            });
            SignTool.setSignatureBoxList();
            var recordSheetId = session.RecordSheetID;
            var isSubmited = dhccl.runServerMethodNormal(ANCLS.BLL.ArchiveRecord, "CheckAllSubmitState", recordSheetId, archiveCodeStr);
            if(isSubmited === "Y"){
                editPluginManager.disableAllPlugin();
                SignTool.disableAll();

                $('#btnSave').css("background","gray")
                $('#btnSave').linkbutton('disable');
                $('#btnSubmit').linkbutton('disable');
                $('#btnRevokeSubmit').linkbutton('enable');
                $('#btnPrint').linkbutton('enable');
                $('#btnArchive').linkbutton('enable');

                var archiveRecordList = dhccl.getDatas(ANCSP.DataQuery, {
                    ClassName: ANCLS.BLL.ArchiveRecord,
                    QueryName: "FindArchiveRecordList",
                    Arg1: recordSheetId,
                    ArgCnt: 1
                }, "json");
                if(archiveRecordList && archiveRecordList.length && archiveRecordList.length > 0){
                    for (var i = 0; i < archiveRecordList.length; i++) {
                        var archiveRecord = archiveRecordList[i];
                        var archiveRecordId = archiveRecord.RowId;
                        //加载签名信息
                        var signatureList = dhccl.getDatas(ANCSP.DataQuery, {
                            ClassName: ANCLS.BLL.ArchiveRecord,
                            QueryName: "FindArchiveSignatureList",
                            Arg1: archiveRecordId,
                            ArgCnt: 1
                        }, "json");
                        SignTool.setSignatureBoxList(signatureList);

                        //加载归档数据
                        var archiveDataList = dhccl.getDatas(ANCSP.DataQuery, {
                            ClassName: ANCLS.BLL.ArchiveRecord,
                            QueryName: "FindArchiveDataList",
                            Arg1: archiveRecordId,
                            ArgCnt: 1
                        }, "json");
                        if(archiveDataList && archiveDataList.length && archiveDataList.length > 0){
                            for (let i = 0; i < archiveDataList.length; i++) {
                                var targetPlugin = editPluginManager.getEditPluginByCode(archiveDataList[i].DataItem);
                                if (targetPlugin) {
                                    targetPlugin.setValue(archiveDataList[i].DataValue);
                                }
                            }
                        }
                    }
                }
            }else{
                editPluginManager.enableAllPlugin();
                SignTool.enableAll();

                $('#btnSave').css("background","#21ba45")
                $('#btnSave').linkbutton('enable');
                $('#btnSubmit').linkbutton('enable');
                $('#btnRevokeSubmit').linkbutton('disable');
                $('#btnPrint').linkbutton('disable');
                $('#btnArchive').linkbutton('disable');
            }
        }

        
        $("#btnLocalPrint").linkbutton({
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

        /*
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
        */

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

        window.getIfNeedSaveData = function(){
            return false;
        }

    }, false);
}

