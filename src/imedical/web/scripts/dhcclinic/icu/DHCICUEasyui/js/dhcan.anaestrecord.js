/**
 * 麻醉监护对象
 * @author chenchangqing 20170907
 */
var record = {
    /**
     * 麻醉表单对象
     * @author chenchangqing 20170907
     */
    sheet: null,
    /**
     * 麻醉监护数据上下文对象
     * @author chenchangqing 20170907
     */
    context: null,

    /**
     * 高分辨率屏幕缩放因子
     */
    ratio: window.devicePixelRatio || 1,

    /**
     * 上次刷新界面时间
     */
    lastRefreshTime: new Date()
};

/**
 * 存储一些方法供动态调用
 */
var methods = {
    /**
     * 打开安全核查编辑界面
     */
    openSafetyChecklist: function() {
        window.parent.selectTab('安全核查');
    },
    /**
     * 提示安全核查编辑界面
     */
    alertSafetyChecklist: function() {
        var originalDefaults = $.extend({}, $.messager.defaults);
        $.extend($.messager.defaults, {
            ok: '打开安全核查',
            cancel: '取消'
        });
        $.messager.confirm('提示', '安全核查未完成,是否打开安全核查？', function(confirmed) {
            if (confirmed) window.parent.selectTab('安全核查');
        });
        $.extend($.messager.defaults, originalDefaults);
        return false;
    },
    /**
     * 打开事件编辑界面
     */
    openEventEditor: function(procedure) {
        var editor = window.EventEditor.instance;
        var paraItem = record.context.getEventParaItem();
        editor.setParaItem(paraItem);
        var displayDatas = procedure.datas || [];
        editor.render(procedure.eventItem);
        editor.loadData(displayDatas[0] || {
            StartDT: new Date()
        });
        editor.open();
    }
}

function HIDPI() {
    var ratio = window.devicePixelRatio || 1;
    var canvas = document.getElementById("canvas");
    var context = canvas.getContext("2d");
    var oldWidth = canvas.width;
    var oldHeight = canvas.height;
    canvas.width = oldWidth * ratio;
    canvas.height = oldHeight * ratio;
    canvas.style.width = oldWidth + "px";
    canvas.style.height = oldHeight + "px";
    //ratio=2;
    context.scale(ratio, ratio);
}

/**
 * 初始化麻醉监护
 * @author chenchangqing 20170907
 */
function initialRecord() {
    HIDPI();
    // 初始化数据上下文对象
    record.context = new RecordContext({
        /**
         * 加载手术排班记录时调用
         */
        onLoadSchedule: function(schedule) {
            $('#current_room').text(schedule.RoomDesc);
            if (schedule.OperStatusCode === 'Cancel') {
                $.messager.alert("此手术已被取消，不能开始监护", "此手术已被取消，如需监护，请联系手术护士恢复手术后再进行监护操作！");
            }
            if (schedule.OperStatusCode === 'Application') {
                $.messager.alert("此手术未安排，不能开始监护", "此手术未安排，如需监护，请重新安排手术间后再进行监护操作！");
            }
        },
        /**
         * 加载麻醉记录数据时调用
         */
        onLoadAnaDatas: function() {

        },
        /**
         * 流程数据更新时调用
         */
        onRefreshProcedures: function() {
            var board = window.ProcedureBoard.instance;
            loadAnaestSafetyCheck();
            if (board) board.loadData(record.context.procedures);
        }
    });
    record.context.initialContext();

    record.onBeforeSaveEvent = function(savingDatas) {
        var length = savingDatas.length;
        var context = record.context;
        var board = window.ProcedureBoard.instance;
        var hasUnfinishedPrecondition = false;

        for (var i = 0; i < length; i++) {
            var data = savingDatas[i];
            if (data.DataItem && data.EditFlag === 'N') {
                var procedure = context.getProcedure(null, data.DataItem);
                if (procedure &&
                    procedure.preconditionProcedure &&
                    !procedure.preconditionProcedure.finished) {
                    hasUnfinishedPrecondition = true;
                    if (procedure.preconditionProcedure.alertMethod) {
                        hasUnfinishedPrecondition = methods[procedure.preconditionProcedure.alertMethod]();
                    } else board.trigger(procedure.preconditionProcedure);
                }
            }
        }

        if (hasUnfinishedPrecondition) {
            record.delaySavingDatas = savingDatas;
        }

        return !hasUnfinishedPrecondition;
    }

    record.onAfterSaveEvent = function(savingDatas) {
        var length = savingDatas.length;
        var context = record.context;
        var savedProcedureTime = false;

        for (var i = 0; i < length; i++) {
            var data = savingDatas[i];
            if (data.DataItem && data.EditFlag === 'N') {
                var procedure = context.getProcedure(null, data.DataItem);
                if (procedure) {
                    savedProcedureTime = true;
                    break;
                }
            }
        }

        if (savedProcedureTime) refreshKeyTimeline();
    }

    /**
     * 重新加载实施手术
     */
    record.reloadOperList = function() {
        record.context.reloadOperList();
    }

    /**
     * 重新加载拟施手术
     */
    record.reloadPlanOperList = function() {
        record.context.reloadPlanOperList();
    }

    // 初始化麻醉表单对象
    record.sheet = new AnaestSheet({
        canvas: document.getElementById("canvas"),
        dataContext: record.context
    });
    refreshPage();

    // 绘制麻醉监护界面
    record.sheet.drawPage();

    // record.sheet.countAllPages(record.context.dataMaxDT);
    // record.sheet.drawPageNo();

    initiateCanvas();
    initiateProcedureBoard();
    //initiateDeviceUsageView();
    initiateButtonGroups();
    //initiateVitalSignEditView();
    //initiateDrugEditView();
    //initiateSpeedChangeView();
    //initiateDrugGroupEditView();
    initiateTimeLineEditView();
    //initiateEventEditView();
    //initiateIntrmiDrugEditView();
    initiateCollectView();
    initiateTextHistoryView();

    //refreshDeviceInUsage();
    refreshProcedureBoard();
    adjustProcedureBoardSize();
    adjustToolkitSize();
    loadPublicPreferedData();
    //initEditorPreferedDataView();

    setInterval(function() {
        if (new TimeSpan(new Date(), record.lastRefreshTime).totalMinutes > 3)
            refreshPage(); //界面距离上次刷新数据超过5分钟则自动刷新
    }, 60000); //每隔1分钟自动刷新界面

    setTimeout(initiateDrugEditView, 2000);
    setTimeout(initiateEventEditView, 2000);
    setTimeout(initiateVitalSignEditView, 4000);
    setTimeout(initiateIntrmiDrugEditView, 4000);
    setTimeout(initiateDeviceUsageView, 5000);
    setTimeout(refreshDeviceInUsage, 5000);
    setTimeout(initiateDrugGroupEditView, 9000);
    setTimeout(initiateSpeedChangeView, 9000);
    setTimeout(initEditorPreferedDataView, 9000);

    $('#btnAnaDoctorSign').click(function() {
        var signCode = $(this).attr("data-signcode");
        var originalData = JSON.stringify({
            OperSchedule: {
                PatDeptDesc: '',
                PatBedCode: '',
                MedcareNo: ''
            },
            Datas: {

            }
        });
        var signView = new SignView({
            originalData: originalData,
            signCode: signCode,
            printCallBack: function() {},
            saveCallBack: function(signedData, successfn) {
                signedData.ClassName = ANCLS.Model.Signature;
                signedData.RecordSheet = session.RecordSheetID;

                var signedDatas = [];
                signedDatas.push(signedData);

                var jsonData = dhccl.formatObjects(signedDatas);
                dhccl.saveDatas(ANCSP.DataListService, {
                    jsonData: jsonData
                }, function(data) {
                    if (successfn) {
                        successfn({
                            signImage: signedData.SignImageData
                        });
                    }
                })
                return true;
            }
        });
        signView.open();
    });

    //signCommon.loadSignature();
    SignTool.loadSignature();
    $('#btn_west_collapse').click(function() {
        $('body').layout('collapse', 'west');
    });
    $('#vitalsign_warning').click(openAbnormalView);
    $('#event_timereminder').click(openTimeReminder);

    var canvas = record.sheet.canvas;
    // canvas容器滚动时调整编辑插件的位置
    $(canvas).parent().scroll(function() {
        if (record.editPlugin &&
            !record.editPlugin.isClosed) {
            record.editPlugin.refreshPosition();
        }
    });
}

function msg(value, name) {
    var signCode = $(this).attr("id");
    var originalData = JSON.stringify({
        OperSchedule: {
            PatDeptDesc: '',
            PatBedCode: '',
            MedcareNo: ''
        },
        Datas: {

        }
    });
    var signView = new SignView({
        container: "#signContainer",
        originalData: originalData,
        signCode: signCode
    });
    signView.initView();
    signView.open();
    signCommon.loadSignature();
}

/**
 * 初始化麻醉监护绘图对象
 * @author chenchangqing 20170906
 */
function initiateCanvas() {
    var canvas = record.sheet.canvas;
    // 初始化Canvas提示信息
    $(canvas).tooltip({
        content: "",
        trackMouse: true,
        showDelay: 0,
        hideDelay: 0
    });
    $(canvas).tooltip("hide");
    // Canvas鼠标点击事件
    $(canvas).mousedown(canvasMouseDown);
    // Canvas鼠标移动事件
    $(canvas).mousemove(canvasMouseMove);
    // Canvas右键上下文菜单
    $(canvas).bind("contextmenu", canvasContextMenu);
    //$(canvas).contextmenu(canvasContextMenu);
    // Canvas鼠标双击事件
    $(canvas).dblclick(canvasDBLClick);
    // Canvas鼠标释放事件
    $(canvas).mouseup(canvasMouseUp);
    // Canvas鼠标单击事件
    $(canvas).click(canvasMouseClick);
}

/**
 * 加载流程面板
 */
function initiateProcedureBoard() {
    var board = window.ProcedureBoard.instance;
    if (!board) {
        board = window.ProcedureBoard.init($('#procedure_board'), {
            onClick: function(procedure) {
                if (permissions.editable && procedure.clickMethod) {
                    var method = methods[procedure.clickMethod];
                    if (method) method.call(record, procedure);
                }
            }
        });
    }
    loadAnaestSafetyCheck();
    board.loadData(record.context.procedures);
}

/**
 * 调整流程区域大小
 */
function adjustProcedureBoardSize() {
    var currentRoom = $('#current_room');
    var deviceUsage = $('#device_usage');
    var procedureBoard = $('#procedure_board');

    var totalHeight = $(procedureBoard.parent()).height();
    procedureBoard.height(totalHeight - currentRoom.height() - deviceUsage.height() - 25);
}

/**
 * 刷新流程区域
 */
function refreshProcedureBoard() {
    var procedure = record.context.getProcedure('RoomOut');
    if (procedure) {
        if (record.context.schedule.TheatreOutDT) {
            procedure.finished = true;
            procedure.finishDT = record.context.recordEndDT.format(constant.dateTimeFormat);
            procedure.finishTime = record.context.recordEndDT.format(constant.timeFormat);
        } else {
            procedure.finished = false;
            procedure.finishDT = "";
            procedure.finishTime = "";
        }
    }

    var board = window.ProcedureBoard.instance;
    if (board) board.loadData(record.context.procedures);
}

/**
 * 加载安全核查是否完成
 */
function loadAnaestSafetyCheck() {
    var opsId = "";
    if (record.context.schedule) {
        opsId = record.context.schedule.RowId;
        dhccl.getDatas(ANCSP.MethodService, {
            ClassName: ANCLS.BLL.AnaestRecord,
            MethodName: 'GetAnaestSafetyCheck',
            Arg1: opsId,
            ArgCnt: 1
        }, 'text', false, function(data) {
            var data = $.trim(data);
            var data = $.parseJSON(data);
            var context = record.context;
            var procedure = context.getProcedure('PreAnSafetyChecklist');
            if (procedure) {
                procedure.finished = data.PreAN.Checked;
                //procedure.finishDT = data.PreAN.DateTime;
                //procedure.finishTime = data.PreAN.Time;
            }
            var procedure = context.getProcedure('PreOperSafetyChecklist');
            if (procedure) {
                procedure.finished = data.PreOP.Checked;
                //procedure.finishDT = data.PreOP.DateTime;
                //procedure.finishTime = data.PreOP.Time;
            }
            var procedure = context.getProcedure('FinalSafetyChecklist');
            if (procedure) {
                procedure.finished = data.PreOut.Checked;
                //procedure.finishDT = data.PreOut.DateTime;
                //procedure.finishTime = data.PreOut.Time;
            }
        });
    }
}

/**
 * 调整工具栏大小
 */
function adjustToolkitSize() {
    var toolkit = $('#toolkit');

    if (toolkit.hasClass('seperated-area')) {
        var currentRoom = $('#current_room');
        var deviceUsage = $('#device_usage');
        var totalHeight = $(toolkit.parent()).height();
        toolkit.height(totalHeight - currentRoom.height() - deviceUsage.height() - 25);
    } else {
        var totalWidth = $(toolkit.parent()).width();
        toolkit.width(totalWidth - 23);
    }
}

window.onresize = function() {
    //console.log("resize");
    setTimeout(function() {
        adjustProcedureBoardSize();
        adjustToolkitSize();
    }, 500);
};

/**
 * 初始化设备使用显示
 */
function initiateDeviceUsageView() {
    var editor = window.DeviceUsageEditor.instance;
    if (!editor) {
        editor = window.DeviceUsageEditor.init({
            saveHandler: saveDeviceUsage
        });
    }
    var view = $('#device_usage');
    view.click(function() {
        //加载模拟数据
        /*$.ajax({
            url: '../service/dhcanop/data/test.device.json',
            method: 'GET',
            async: false,
            success: function(data) {
                editor.loadData(data);
            }
        });
        editor.open();*/
        refreshDeviceInUsage();
        var editor = window.DeviceUsageEditor.instance
        editor.setDefaultDT(record.context.schedule.TheatreInDT);
        if (permissions.editable) {
            dhccl.getDatas(ANCSP.DataQuery, {
                ClassName: ANCLS.BLL.AnaestRecord,
                QueryName: 'FindDeptEquips',
                Arg1: session['DeptID'],
                ArgCnt: 1
            }, 'json', true, function(data) {
                var editor = window.DeviceUsageEditor.instance
                editor.loadData(data);
                editor.open();
            });
        }
    });
}

function refreshDeviceInUsage() {
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.DataQueries,
        QueryName: 'FindEquipRecord',
        Arg1: record.context.recordSheetID,
        ArgCnt: 1
    }, 'json', false, function(data) {
        record.usingDevices = [];
        if (data && data.length) {
            record.usingDevices = data;
            var editor = window.DeviceUsageEditor.instance
            editor.setCurrentUsage(data);
            var length = data.length;
            var container = $('#device_usage');
            container.empty();
            var statusCode = record.context.schedule.OperStatusCode;
            if (statusCode === "RoomOut" || statusCode === "Finished") container.addClass('device-usage-stopped');

            for (var i = 0; i < length; i++) {
                var usage = data[i];
                if (usage.EndDate) continue;
                $('<span class="device"></span>')
                    .attr('title', usage.EquipTypeDesc + '：' + usage.EquipDesc + '\n' + (usage.TcpipAddress || ''))
                    .text(usage.EquipTypeDesc + ':')
                    .append('<span class="badge">' + usage.EquipDesc + '</span>')
                    .appendTo(container);
            }
            container.data('data', data);
            adjustProcedureBoardSize();
        }
    });
}

/**
 * 保存正在使用的设备
 * @param {Array} deviceUsages 
 */
function saveDeviceUsage(deviceUsages) {
    if (!deviceUsages || deviceUsages.length <= 0) {
        refreshDeviceInUsage();
        return;
    }

    var extend = {
        ClassName: ANCLS.Model.EquipRecord,
        RecordSheet: session['RecordSheetID'],
        UpdateUser: session['UserID']
    };

    var length = deviceUsages.length;
    for (var i = 0; i < length; i++) {
        var usage = deviceUsages[i];
        $.extend(usage, extend);
    }

    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.AnaestRecord,
        MethodName: "SaveDeviceUsage",
        Arg1: record.context.opsId,
        Arg2: dhccl.formatObjects(deviceUsages),
        Arg3: session.UserID,
        ArgCnt: 3
    }, function(data) {
        refreshDeviceInUsage();
    });
}

/**
 * 初始化功能按钮组
 * @author chenchangqing 20170906
 */
function initiateButtonGroups() {
    var toolkit = window.Toolkit.init($('#toolkit'), {
        data: record.context.operActions,
        judgeMethods: {
            isNotFirstPage: function() {
                return !record.sheet.isFirstPage();
            },
            isNotLastPage: function() {
                return !record.sheet.isLastPage();
            },
            isStarted: function() {
                return record.context.isStarted();
            },
            isNotStarted: function() {
                return !record.context.isStarted();
            },
            isNotEnded: function() {
                return !record.context.isEnded();
            }
        }
    });
    resetToolkit();
}

/**
 * 重置工具栏
 */
function resetToolkit() {
    permissionManager.setCurrentPermissions();
    var toolkit = window.Toolkit.instance;
    var actionPermissions = record.context.getActionPermissions();
    if (toolkit) {
        toolkit.loadPermission(permissions);
        toolkit.loadData(actionPermissions || []);
    }
}

/**
 * 初始化文本描述历史选择界面
 */
function initiateTextHistoryView() {
    var view = window.textHistoryView.instance;
    if (!view) {
        view = window.textHistoryView.init($('#text_history_view'), {});
    }

    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.DataQueries,
        QueryName: 'FindTextHistory',
        Arg1: session['ModuleID'],
        ArgCnt: 1
    }, 'json', true, function(data) {
        view.loadData(data);
    })
}

/**
 * 保存开始监护时间
 * @param {object} data 
 */
function saveRecordStartDT(data) {
    var recordStartDT = data.startDT;
    var schedule = {
        RowId: record.context.schedule.RowId,
        StatusCode: "RoomIn",
        Status: "",
        TheatreInDT: recordStartDT,
        isStarting: data.isStarting ? 'Y' : 'N',
        ClassName: ANCLS.Model.OperSchedule,
        UpdateUser: session['UserID']
    };
    dhccl.saveDatas(ANCSP.DataListService, {
        ClassName: ANCLS.BLL.AnaestRecord,
        MethodName: "StartRecord",
        jsonData: dhccl.formatObjects(schedule)
    }, function(ret) {
        if (ret.indexOf("S^") === 0) {
            record.context.loadSchedule();
            record.context.loadParaItems();
            refreshPage();
            resetToolkit();
            var view = window.StartRecordView.instance;
            view.close();
            refreshDeviceInUsage();
            refreshOperScheduleList();
            refreshKeyTimeline();
        } else {
            dhccl.showMessage(ret, "开始监护");
        }
    });
}

/**
 * 更新手术列表
 */
function refreshOperScheduleList() {
    window.parent.reloadOperSchedule();
    //.SyncCollectData
}

/**
 * 更新手术Banner关键事件时间
 */
function refreshKeyTimeline() {
    window.parent.refreshKeyTimeline();
}

/**
 * 保存结束监护时间
 * @param {object} data 
 */
function saveRecordEndDT(data) {
    var recordStopDT = data.stopDT;
    var schedule = {
        RowId: record.context.schedule.RowId,
        StatusCode: "RoomOut",
        Status: "",
        TheatreOutDT: recordStopDT,
        TheatreOutTransLoc: data.theatreOutTransLoc,
        ClassName: ANCLS.Model.OperSchedule,
        UpdateUser: session['UserID']
    };

    var anEvaluation = {
        ClassName: ANCLS.Model.AnaestEvaluation,
        RowId: '',
        OperSchedule: record.context.schedule.RowId,
        GeneralAnInduction: data.generalAnaesthesiaInductionEffect || '',
        GeneralAnMaintain: data.generalAnaesthesiaMaintainEffect || '',
        GeneralAnEnding: data.generalAnaesthesiaEndingEffect || '',
        IntraspinalAn: data.intraspinalAnesthesiaEffect || '',
        NerveBlock: data.nerveBlockEffect || '',
        Complication: data.complication || '',
        EvaluateUser: session['UserID']
    };

    dhccl.saveDatas(ANCSP.DataListService, {
        ClassName: ANCLS.BLL.AnaestRecord,
        MethodName: "StopRecord",
        jsonData: dhccl.formatObjects([schedule, anEvaluation])
    }, function(ret) {
        if (ret.indexOf("S^") === 0) {
            record.context.loadSchedule();
            refreshPage();
            resetToolkit();
            var view = window.StopRecordView.instance;
            view.close();
            refreshProcedureBoard();
            refreshOperScheduleList();
            refreshKeyTimeline();
            if (record.printingState) printDocument();
        } else {
            dhccl.showMessage(ret, "结束监护");
        }
    });
}

/**
 * 停止所有连续用药
 */
function stopAllContinousData(endDT) {
    var arr = endDT.split(' ');
    var endDate = endTime = '';
    if (arr.length > 1) {
        endDate = arr[0];
        endTime = arr[1];
    }
    var drugDatas = record.context.getAllDrugDatas();
    var length = drugDatas.length;
    var savingDatas = [];
    for (var i = 0; i < length; i++) {
        var displayData = drugDatas[i];
        if (displayData.DrugData.isContinous === 'Y' && !displayData.EndDate) {
            savingDatas.push({
                RowId: displayData.RowId,
                ClassName: ANCLS.Model.AnaData,
                EndDate: endDate,
                EndTime: endTime,
                EndDT: endDT
            });
        }
    }

    saveAnaDatas(savingDatas);
}

/**
 * 停止所有设备使用
 */
function stopAllDeviceUsage(endDT) {
    var arr = endDT.split(' ');
    var endDate = endTime = '';
    if (arr.length > 1) {
        endDate = arr[0];
        endTime = arr[1];
    }
    var usingDevices = record.usingDevices;
    var length = usingDevices.length;
    var savingUsages = [];
    for (var i = 0; i < length; i++) {
        var usage = usingDevices[i];
        if (!usage.EndDate) {
            savingUsages.push($.extend(usage, {
                EndDate: endDate,
                EndTime: endTime,
                EndDT: endDT
            }));
        }
    }

    saveDeviceUsage(savingUsages);
}

/**
 * 初始化生命体征数据编辑界面
 * @author chenchangqing 20171013
 */
function initiateVitalSignEditView() {
    var editor = window.VitalSignEditor.instance;
    if (!editor) {
        editor = window.VitalSignEditor.init({
            saveHandler: saveAnaDatas,
            onBeforeSave: function(data) {
                var procedure = null // getProcedureFromData();
                if (procedure && procedure.precondition && !procedure.pre.finished) {
                    var board = window.ProcedureBoard.instance;
                    board.trigger(procedure);
                }
            }
        });
    }
}

function initiateDrugEditView() {
    var editor = window.DrugEditor.instance;
    if (!editor) {
        editor = window.DrugEditor.init({
            comboDataSource: {
                DoseUnits: record.context.drugDoseUnits,
                SpeedUnits: record.context.drugSpeedUnits,
                ConcentrationUnits: record.context.drugConcentrationUnits,
                Instructions: record.context.drugInstructions,
                Reasons: record.context.drugReasons,
                InjectionSites: record.context.injectionSites
            },
            saveHandler: saveDrugDatas,
            onBeforeOpen: function() {
                var procedure = null // getProcedureFromData();
                if (procedure && procedure.precondition && !procedure.pre.finished) {
                    var board = window.ProcedureBoard.instance;
                    board.trigger(procedure);
                }
            },
            onAfterSave: function(data) {
                var procedure = null // getProcedureFromData();
                if (procedure && procedure.precondition) {
                    var board = window.ProcedureBoard.instance;
                    board.trigger(procedure);
                }
            }
        });
    }
}

function initiateSpeedChangeView() {
    var editor = window.SpeedChangeEditor.instance;
    if (!editor) {
        editor = window.SpeedChangeEditor.init({
            saveHandler: saveDrugDatas
        });
    }
}

function initiateDrugGroupEditView() {
    var editor = window.DrugGroupEditor.instance;
    if (!editor) {
        editor = window.DrugGroupEditor.init({
            comboDataSource: {
                DoseUnits: record.context.drugDoseUnits,
                SpeedUnits: record.context.drugSpeedUnits,
                ConcentrationUnits: record.context.drugConcentrationUnits,
                Instructions: record.context.drugInstructions,
                Reasons: record.context.drugReasons,
            },
            saveHandler: saveDrugDatas,
            onBeforeOpen: function() {
                var procedure = null // getProcedureFromData();
                if (procedure && procedure.precondition && !procedure.pre.finished) {
                    var board = window.ProcedureBoard.instance;
                    board.trigger(procedure);
                }
            },
            onAfterSave: function(data) {
                var procedure = null // getProcedureFromData();
                if (procedure && procedure.precondition) {
                    var board = window.ProcedureBoard.instance;
                    board.trigger(procedure);
                }
            }
        });
    }
}

/**
 * 初始化数据编辑框
 */
function initiateEventEditView() {
    var editor = window.EventEditor.instance;
    if (!editor) {
        editor = window.EventEditor.init({
            categoryItems: record.context.categoryItems,
            eventCategories: record.context.getEventDataCategories(),
            saveHandler: saveEventDatas,
            createUserDefItemHandler: function(data, callback) {
                var savingData = $.extend(data, {
                    ClassName: ANCLS.Config.UserDefDataItem,
                    CreateUser: session.UserID
                });

                dhccl.saveDatas(ANCSP.DataService, savingData, function(result) {
                    callback(result);
                });
            },
            retrieveUserDefinedItem: function(param) {
                dhccl.getDatas(ANCSP.DataQuery, {
                    ClassName: ANCLS.BLL.ConfigQueries,
                    QueryName: 'FindUserDefDataItem',
                    Arg1: param.dataCategoryId,
                    ArgCnt: 1
                }, 'json', true, function(data) {
                    var editor = window.EventEditor.instance
                    editor.loadUserDefinedItem(data);
                });
            },
            onBeforeOpen: function() {
                var procedure = null // getProcedureFromData();
                if (procedure && procedure.precondition && !procedure.pre.finished) {
                    var board = window.ProcedureBoard.instance;
                    board.trigger(procedure);
                }
            },
            onAfterSave: function(data) {
                var procedure = null // getProcedureFromData();
                if (procedure && procedure.precondition) {
                    var board = window.ProcedureBoard.instance;
                    board.trigger(procedure);
                }
            }
        });
    }
}

/**
 * 初始化间断给药界面
 */
function initiateIntrmiDrugEditView() {
    var editor = window.IntrmiDrugEditor.instance;
    if (!editor) {
        editor = window.IntrmiDrugEditor.init({
            comboDataSource: {
                DoseUnits: record.context.drugDoseUnits,
                SpeedUnits: record.context.drugSpeedUnits,
                ConcentrationUnits: record.context.drugConcentrationUnits,
                Instructions: record.context.drugInstructions,
                Reasons: record.context.drugReasons,
            },
            dataCategories: record.context.getIntrmiDrugDataCategories(),
            saveHandler: saveIntrmiDrugDatas,
            createUserDefItemHandler: function(data, callback) {
                var savingData = $.extend(data, {
                    ClassName: ANCLS.Config.UserDefDataItem,
                    CreateUser: session.UserID
                });

                dhccl.saveDatas(ANCSP.DataService, savingData, function(result) {
                    callback(result);
                });
            },
            retrieveUserDefinedItem: function(param) {
                dhccl.getDatas(ANCSP.DataQuery, {
                    ClassName: ANCLS.BLL.ConfigQueries,
                    QueryName: 'FindUserDefDataItem',
                    Arg1: param.dataCategoryId,
                    ArgCnt: 1
                }, 'json', true, function(data) {
                    var editor = window.IntrmiDrugEditor.instance
                    editor.loadUserDefinedItem(data);
                });
            },
            onBeforeOpen: function() {
                var procedure = null // getProcedureFromData();
                if (procedure && procedure.precondition && !procedure.pre.finished) {
                    var board = window.ProcedureBoard.instance;
                    board.trigger(procedure);
                }
            },
            onAfterSave: function(data) {
                var procedure = null // getProcedureFromData();
                if (procedure && procedure.precondition) {
                    var board = window.ProcedureBoard.instance;
                    board.trigger(procedure);
                }
            }
        });
    }
}

function toggleWarningSign() {
    if (record.context.abnormalVitalSignDatas && record.context.abnormalVitalSignDatas.length > 0) {
        $('#vitalsign_warning').show();
    } else {
        $('#vitalsign_warning').hide();
    }
}

function openAbnormalView() {
    var view = window.AbnormalView.instance;
    if (!view) {
        view = window.AbnormalView.init({});
    }
    view.loadData(record.context.abnormalVitalSignDatas || []);
    view.open();
}

function openTimeReminder() {
    var view = window.TimeReminder.instance;
    if (!view) {
        view = window.TimeReminder.init({});
    }

    var data = [];
    var startProcedure = record.context.getProcedure('RoomIn');
    var endProcedure = record.context.getProcedure('RoomOut');
    data.push({ name: '监护', startDT: startProcedure.finishDT, endDT: endProcedure.finishDT });
    var startProcedure = record.context.getProcedure('AnaestStart');
    var endProcedure = record.context.getProcedure('AnaestEnd');
    data.push({ name: '麻醉', startDT: startProcedure.finishDT, endDT: endProcedure.finishDT });
    var startProcedure = record.context.getProcedure('OperStart');
    var endProcedure = record.context.getProcedure('OperEnd');
    data.push({ name: '手术', startDT: startProcedure.finishDT, endDT: endProcedure.finishDT });

    view.loadData(data);
    view.open();
}

/**
 * 刷新界面
 */
function refreshPage() {
    record.lastRefreshTime = new Date();
    record.context.loadAnaDatas(function() {
        record.context.setDisplayItemDatas();
        permissionManager.setCurrentPermissions();
        loadTotalSummary();
        record.sheet.drawPage();
        record.sheet.countAllPages(record.context.dataMaxDT);
        record.sheet.drawPageNo();
        toggleWarningSign();
    });
}


/**
 * 加载入量总量
 */
function loadTotalSummary() {
    var opsId = "";
    if (record.context.schedule) {
        opsId = record.context.schedule.RowId;
        dhccl.getDatas(ANCSP.MethodService, {
            ClassName: ANCLS.BLL.AnaestRecord,
            MethodName: 'GetInOutSummary',
            Arg1: opsId,
            ArgCnt: 1
        }, 'text', false, function(data) {
            var data = $.trim(data);
            var data = $.parseJSON(data);
            var schedule = record.context.schedule;
            for (var key in data) {
                if (!schedule[key] || schedule[key + "Auto"]) {
                    schedule[key + "Auto"] = true;
                    schedule[key] = data[key];
                }
            }
        });
    }
}

/**
 * 保存麻醉记录事件数据
 * @param {Array<Model.AnaData>} anaDatas - 麻醉记录数据对象集合
 * @author chenchangqing 20171129
 */
function saveEventDatas(anaDatas) {
    if (!anaDatas || anaDatas.length <= 0) {
        refreshPage();
        return;
    }
    if (record.onBeforeSaveEvent && !record.onBeforeSaveEvent(anaDatas)) return;

    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.AnaestRecord,
        MethodName: "SaveEventData",
        Arg1: record.context.opsId,
        Arg2: dhccl.formatObjects(anaDatas),
        Arg3: session.UserID,
        Arg4: record.context.moduleId,
        ArgCnt: 4
    }, function(data) {
        refreshPage();
    });

    if (record.onAfterSaveEvent) record.onAfterSaveEvent(anaDatas);
}

/**
 * 同步采集到的数据
 */
function syncCollectData() {
    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.AnaestRecord,
        MethodName: "SyncCollectData",
        Arg1: record.context.opsId,
        Arg2: record.context.recordSheetID,
        ArgCnt: 2
    }, function(data) {
        refreshPage();
    });
}

/**
 * 保存麻醉记录生命体征、出量、监测项目等数据
 * @param {Array<Model.AnaData>} anaDatas - 麻醉记录数据对象集合
 * @author chenchangqing 20171106
 */
function saveAnaDatas(anaDatas) {
    if (!anaDatas || anaDatas.length <= 0) {
        refreshPage();
        return;
    }
    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.AnaestRecord,
        MethodName: "SaveAnaData",
        Arg1: record.context.opsId,
        Arg2: dhccl.formatObjects(anaDatas),
        Arg3: session.UserID,
        Arg4: record.context.moduleId,
        ArgCnt: 4
    }, function(data) {
        refreshPage();
    });
}

/**
 * 保存麻醉记录药品数据
 * @param {Array<Model.AnaData>} anaDatas - 麻醉记录数据对象集合
 * @author chenchangqing 20171106 
 */
function saveDrugDatas(anaDatas) {
    if (!anaDatas || anaDatas.length <= 0) {
        refreshPage();
        return;
    }
    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.AnaestRecord,
        MethodName: "SaveDrugData",
        Arg1: record.context.opsId,
        Arg2: dhccl.formatObjects(anaDatas),
        Arg3: session.UserID,
        Arg4: record.context.moduleId,
        ArgCnt: 4
    }, function(data) {
        refreshPage();
    });
}

/**
 * 保存麻醉记录间断给药数据
 * @param {Array<Model.AnaData>} anaDatas - 麻醉记录数据对象集合
 * @author chenchangqing 20180109 
 */
function saveIntrmiDrugDatas(anaDatas) {
    if (!anaDatas || anaDatas.length <= 0) {
        refreshPage();
        return;
    }
    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.AnaestRecord,
        MethodName: "SaveIntrmiDrugData",
        Arg1: record.context.opsId,
        Arg2: dhccl.formatObjects(anaDatas),
        Arg3: session.UserID,
        Arg4: record.context.moduleId,
        ArgCnt: 4
    }, function(data) {
        if (data.indexOf("S^") === 0) {
            refreshPage();
            var editor = window.IntrmiDrugEditor.instance;
            editor.close();
        } else {
            dhccl.showMessage(data, "间断给药");
        }

    });
}

// #region canvas鼠标点击事件处理函数
/**
 * Canvas鼠标点击事件处理函数
 * @param {object} e - 鼠标点击参数 
 * @author chenchangqing 20170906
 */
function canvasMouseDown(e) {
    e.preventDefault();
    if (!permissions.editable) return;

    // 右键终止绘制折线图
    if (e.button == 2 &&
        record.sheet.chartInfo.item) {
        record.sheet.clearTemperaryData(record.sheet.chartInfo);
        record.sheet.clearChartInfo();
        record.sheet.drawPage();
        $(record.sheet.canvas).removeClass('drawing');
    }

    if (record.sheet) {
        record.sheet.captureClick(e);
        if (record.isCtrlDown && record.sheet.clickInfo &&
            record.sheet.clickInfo.displayData) {
            toggleDataSelection();
        }
    }

    record.sheet.isMouseDown = true;

    if (record.sheet.clickInfo &&
        record.sheet.clickInfo.dataItem &&
        record.editPlugin &&
        !record.editPlugin.isClosed &&
        record.sheet.clickInfo.dataItem != record.editPlugin.dataItem) {
        try {
            record.editPlugin.confirmAndSave();
        } catch (exp) {
            record.editPlugin.close();
        }
    }

    if (record.sheet.clickInfo &&
        record.sheet.clickInfo.locDT) {
        var view = window.shortcutView.instance;
        if (view) view.setDateTime(record.sheet.clickInfo.locDT);
    }
}

/**
 * Canvas鼠标移动事件处理函数
 * @param {object} e - 鼠标移动参数
 * @author chenchangqing 20170908
 */
function canvasMouseMove(e) {
    e.preventDefault();
    if (record.sheet) {
        record.sheet.captureMove(e);
        var moveInfo = record.sheet.moveInfo;
        var clickInfo = record.sheet.clickInfo;
        var chartInfo = record.sheet.chartInfo;
        if (moveInfo && moveInfo.locDT) {
            $(canvas).tooltip("update", moveInfo.locDT.format("HH:mm") + " " + (moveInfo.value || ""));
            $(canvas).tooltip("show");
            var item = clickInfo.item;
            if (clickInfo && clickInfo.button === 0 && clickInfo.displayData && record.sheet.isMouseDown) {
                record.isMovingData = true;
                if (!moveInfo.startDT) {
                    moveInfo.startDT = new Date(moveInfo.locDT);
                }
                var clickData = clickInfo.displayData;
                if (item && item.vitalSignItem && item.vitalSignItem.legendItem) {
                    clickData.DataValue = moveInfo.value;
                } else {
                    if (clickData.Continuous === "Y") {
                        if (!clickData.OriginalStartDT) {
                            clickData.OriginalStartDT = new Date(clickData.StartDT);
                            clickData.OriginalEndDT = new Date(clickData.EndDT);
                        }
                        if (clickInfo.isSelectedStartIcon) {
                            clickData.StartDT = moveInfo.locDT;
                            clickData.StartDate = clickData.StartDT.format(constant.dateFormat);
                            clickData.StartTime = clickData.StartDT.format(constant.timeFormat);
                        } else if (clickInfo.isSelectedEndIcon) {
                            clickData.EndDT = moveInfo.locDT;
                            clickData.EndDate = clickData.EndDT.format(constant.dateFormat);
                            clickData.EndTime = clickData.EndDT.format(constant.timeFormat);
                        } else if (clickInfo.isSelectedWhole) {
                            var timeSpan = new TimeSpan(moveInfo.locDT, moveInfo.startDT);
                            console.log(timeSpan.totalMinutes);
                            clickData.StartDT = clickData.OriginalStartDT.addMinutes(Math.round(timeSpan.totalMinutes));
                            clickData.StartDate = clickData.StartDT.format(constant.dateFormat);
                            clickData.StartTime = clickData.StartDT.format(constant.timeFormat);
                            clickData.EndDT = clickData.OriginalEndDT.addMinutes(Math.round(timeSpan.totalMinutes));
                            clickData.EndDate = clickData.EndDT.format(constant.dateFormat);
                            clickData.EndTime = clickData.EndDT.format(constant.timeFormat);
                        }
                    } else {
                        clickData.StartDT = moveInfo.locDT;
                        clickData.StartDate = clickData.StartDT.format(constant.dateFormat);
                        clickData.StartTime = clickData.StartDT.format(constant.timeFormat);
                        clickData.EndDT = moveInfo.locDT;
                        clickData.EndDate = clickData.StartDT.format(constant.dateFormat);
                        clickData.EndTime = clickData.StartDT.format(constant.timeFormat);
                    }
                }
                record.sheet.drawPage();
            }
        } else {
            $(canvas).tooltip("hide");
        }

        if (moveInfo && clickInfo) {
            //console.log(chartInfo);
            if (chartInfo && chartInfo.item && chartInfo.item.vitalSignItem && !record.sheet.isMouseDown && record.isDrawing) {
                record.isMovingData = true;
                generateTemperaryChartData(chartInfo, moveInfo.locDT, moveInfo.value);
                record.sheet.drawPage();
                record.sheet.drawDataIcon({
                    x: moveInfo.location.x,
                    y: moveInfo.location.y
                }, chartInfo.item.vitalSignItem.legendItem, chartInfo.item.vitalSignItem.Color)
            }
            if (clickInfo.eventLegendItem) {
                record.sheet.drawPage();
                record.sheet.drawItemIcon({
                        x: moveInfo.location.x - 4,
                        y: moveInfo.location.y - 4
                    }, clickInfo.eventLegendItem.legendItem,
                    clickInfo.eventLegendItem.LegendColor);
            }
        }
    }
}

/**
 * 生成临时图表数据
 */
function generateTemperaryChartData(chartInfo, locDT, dataValue) {
    if (!(locDT && dataValue)) return;

    var displayItem = chartInfo.item;
    if (!displayItem.temperaryChartDatas) displayItem.temperaryChartDatas = {};
    var temperaryChartDatas = displayItem.temperaryChartDatas;
    var startDT = chartInfo.startLineDT;
    var minDT = startDT;
    var maxDT = locDT;
    if (!minDT || maxDT <= minDT) return;
    if (new TimeSpan(maxDT, minDT).totalMinutes < 1) return;
    var excludeTimeList = [];
    var index = -1;
    var anaData = null;

    if (!startDT) return;

    //取消不在startDT和LocDT之间的数据
    for (var time in temperaryChartDatas) {
        anaData = temperaryChartDatas[time];
        if (anaData && (anaData.StartDT < minDT || anaData.StartDT > maxDT)) {
            if (anaData) {
                index = displayItem.displayDatas.indexOf(temperaryChartDatas[time]);
                excludeTimeList.push(time);
                if (index > -1) displayItem.displayDatas.splice(index, 1);
            }
        }
    }

    //删除临时数据
    var length = excludeTimeList.length;
    for (var i = 0; i < length; i++) {
        temperaryChartDatas[excludeTimeList[i]] = null;
    }

    //生成或修改新数据
    var columnTime = record.sheet.isColumnTime(locDT);
    if (columnTime && dataValue) {
        if (temperaryChartDatas[columnTime]) {
            temperaryChartDatas[columnTime].DataValue = dataValue;
            temperaryChartDatas[columnTime].DisplayName = dataValue;
        } else {
            var startDateTime = columnTime.format(constant.dateTimeFormat);
            var startDate = columnTime.format(constant.dateFormat);
            var startTime = columnTime.format(constant.timeFormat);
            temperaryChartDatas[columnTime] = {
                RowId: "",
                SheetRecord: "",
                ParaItem: chartInfo.item.RowId,
                CategoryItem: chartInfo.item.CategoryItem,
                DataItem: chartInfo.item.DataItem,
                StartDate: startDate,
                StartTime: startTime,
                EndDate: startDate,
                EndTime: startTime,
                DataValue: dataValue,
                EditFlag: "N",
                ItemCategory: "V",
                ClassName: ANCLS.Model.AnaData,
                CreateUserID: session.UserID,
                StartDT: columnTime,
                StartDateTime: startDateTime,
                EndDT: columnTime,
                EndDateTime: startDateTime,
                DisplayName: dataValue
            };
            if (!displayItem.displayDatas) displayItem.displayDatas = [];
            displayItem.displayDatas.push(displayItem.temperaryChartDatas[columnTime]);
        }
    }
}

/**
 * Canvas鼠标点击释放事件处理函数
 * @param {object} e - 鼠标点击参数 
 * @author chenchangqing 20171106
 */
function canvasMouseUp(e) {
    e.preventDefault();
    if (!permissions.editable) return;
    record.sheet.isMouseDown = false;

    if (e.button === 2) return; // 鼠标右键点击时，不进行移动
    var clickInfo = record.sheet.clickInfo;
    if (clickInfo && clickInfo.displayData && record.isMovingData) {
        var chartDatas = [];
        var chartData = null;
        if (clickInfo.item.temperaryChartDatas) {
            for (var time in clickInfo.item.temperaryChartDatas) {
                chartData = clickInfo.item.temperaryChartDatas[time];
                if (chartData) chartDatas.push(chartData);
            }
            clickInfo.item.temperaryChartDatas = null;
        }
        if (chartDatas.length > 0) {
            var length = chartDatas.length;
            var savingDatas = [];
            for (var i = 0; i < length; i++) {
                savingDatas.push({
                    RowId: chartDatas[i].RowId || "",
                    SheetRecord: "",
                    ClassName: ANCLS.Model.AnaData,
                    ParaItem: chartDatas[i].ParaItem,
                    StartDate: chartDatas[i].StartDate,
                    StartTime: chartDatas[i].StartTime,
                    EndDate: chartDatas[i].EndDate,
                    EndTime: chartDatas[i].EndTime,
                    DataValue: chartDatas[i].DataValue,
                    EditFlag: "N",
                    FromData: "",
                    CreateUserID: "",
                    CreateDT: "",
                    StartDT: chartDatas[i].StartDT,
                    EndDT: chartDatas[i].EndDT,
                    CategoryItem: chartDatas[i].CategoryItem,
                    DataItem: chartDatas[i].DataItem,
                    DataItemDesc: chartDatas[i].DataItemDesc || "",
                    ItemCategory: "V",
                    Continuous: 'N',
                    FromData: "",
                    CategoryItem: chartDatas[i].CategoryItem,
                    DataItem: chartDatas[i].DataItem,
                    DataItemDesc: chartDatas[i].DataItemDesc,
                    ItemCategory: chartDatas[i].ItemCategory
                });
            }
            saveAnaDatas(savingDatas);
            record.sheet.chartInfo.startLineDT = null;
        } else {
            var displayData = record.sheet.clickInfo.displayData;
            saveAnaDatas({
                RowId: displayData.RowId || "",
                ClassName: ANCLS.Model.AnaData,
                ParaItem: displayData.ParaItem,
                StartDate: displayData.StartDate,
                StartTime: displayData.StartTime,
                EndDate: displayData.EndDate,
                EndTime: displayData.EndTime,
                DataValue: displayData.DataValue,
                EditFlag: "N",
                FromData: "",
                CreateUserID: "",
                CreateDT: "",
                StartDT: displayData.StartDT,
                EndDT: displayData.EndDT,
                CategoryItem: displayData.CategoryItem,
                DataItem: displayData.DataItem,
                DataItemDesc: displayData.DataItemDesc || "",
                ItemCategory: displayData.ItemCategory || "V",
                Continuous: displayData.Continuous || 'N',
                FromData: "",
                CategoryItem: displayData.CategoryItem,
                DataItem: displayData.DataItem,
                DataItemDesc: displayData.DataItemDesc,
                ItemCategory: displayData.ItemCategory
            });
        }
        record.sheet.clearClickInfo();
        record.sheet.moveInfo.startDT = null;
        record.isMovingData = false;
        record.isDrawing = false;
        $(record.sheet.canvas).removeClass('drawing');
    } else {
        record.sheet.drawPage();
    }

    if (record.sheet &&
        record.sheet.clickInfo &&
        record.sheet.clickInfo.dataItem &&
        (!record.editPlugin || record.editPlugin.isClosed)) {
        record.editPlugin = new EditPlugin({
            dataItem: record.sheet.clickInfo.dataItem,
            target: record.sheet.canvas
        });
    }

    if (record.sheet &&
        record.sheet.clickInfo &&
        record.sheet.clickInfo.dataItem &&
        record.sheet.clickInfo.dataItem.relatedProcedure) {
        var procedure = record.sheet.clickInfo.dataItem.relatedProcedure;
        if (permissions.editable && procedure.clickMethod) {
            var method = methods[procedure.clickMethod];
            if (method) method.call(record, procedure);
        }
    }
}

/**
 * Canvas上下文菜单处理函数
 * @author chenchangqing 20170908
 */
function canvasContextMenu(e) {
    e.preventDefault();
    if (!permissions.editable) return;
    if (!record.sheet) return;
    record.sheet.captureClick(e);
    setItemMenus(record.sheet, e);
}

/**
 * Canvas鼠标双击事件处理函数
 * @param {object} e - 鼠标点击信息对象
 * @author chenchangqing 20171013 
 */
function canvasDBLClick(e) {
    e.preventDefault();
    if (!permissions.editable) return;
    if (!record.sheet) return;
    record.sheet.captureClick(e);
    editData();
    var clickInfo = record.sheet.clickInfo;
    var chartInfo = record.sheet.chartInfo;
    if (chartInfo.item) {
        record.isDrawing = true;
        $(record.sheet.canvas).addClass('drawing');
    }
    record.sheet.clearClickInfo();
}

function canvasMouseClick(e) {
    if (!permissions.editable) return;
    if (!record.sheet || !record.sheet.clickInfo) return;
    var clickInfo = record.sheet.clickInfo;
    var chartInfo = record.sheet.chartInfo;
    if (clickInfo.area !== record.context.displayAreas.data ||
        clickInfo.category !== record.context.displayAreas.item.displayCategories.VitalSignCategory) return;
    if (!chartInfo.lineDT) return;

    var lineData = record.sheet.getLineData(); //此列线上有数据则不新增数据
    if (lineData != null) {
        record.sheet.chartInfo.startLineDT = null;
        return;
    }

    var canvasLoc = record.sheet.canvas.windowToCanvas(e);
    var dataValue = record.sheet.getValueByAxis(canvasLoc.y);
    var startDate = chartInfo.lineDT.format(constant.dateFormat);
    var startTime = chartInfo.lineDT.format(constant.timeFormat);

    if (chartInfo.categoryItem && chartInfo.categoryItem.eventItem) {
        var eventDetailItems = chartInfo.categoryItem.eventDetailItems;
        if (eventDetailItems && eventDetailItems.length > 0) { // 有事件明细属性项时打开编辑框
            var editor = window.EventEditor.instance;
            editor.setParaItem(chartInfo.item);
            editor.render(chartInfo.categoryItem);
            editor.open();
        } else {
            var eventData = {
                RowId: "",
                SheetRecord: "",
                ParaItem: chartInfo.item.RowId,
                CategoryItem: chartInfo.categoryItem.RowId,
                DataItem: chartInfo.categoryItem.DataItem,
                StartDate: startDate,
                StartTime: startTime,
                EndDate: startDate,
                EndTime: startTime,
                DataValue: '',
                Guid: '',
                EditFlag: "N",
                ItemCategory: "E",
                ClassName: ANCLS.Model.AnaData,
                CreateUserID: session.UserID,
                EventDetailDatas: []
            };
            saveEventDatas([eventData]);
        }
    } else if (dataValue && record.isDrawing) {
        var categoryItem = chartInfo.item.CategoryItem;
        var anaData = {
            RowId: "",
            SheetRecord: "",
            ParaItem: chartInfo.item.RowId,
            CategoryItem: categoryItem,
            DataItem: chartInfo.item.DataItem || '',
            StartDate: startDate,
            StartTime: startTime,
            EndDate: startDate,
            EndTime: startTime,
            DataValue: dataValue,
            EditFlag: "N",
            ItemCategory: "V",
            ClassName: ANCLS.Model.AnaData,
            CreateUserID: session.UserID
        };
        saveAnaDatas([anaData]);
    }
}
// #endregion

// #region 时间轴缩放
/**
 * 初始化时间轴缩放编辑界面
 * @author chenchangqing 20170906
 */
function initiateTimeLineEditView() {
    $("#timeLineDialog").dialog({
        onClose: function() {
            record.context.loadTimeLines();
            record.sheet.setTimeLines();
            record.sheet.drawPage();
        }
    });

    $("#timeLineBox").datagrid({
        singleSelect: true,
        rownumbers: true,
        url: ANCSP.DataQuery,
        queryParams: {
            ClassName: ANCLS.BLL.AnaestRecord,
            QueryName: "FindTimeLines",
            Arg1: record.context.recordSheetID,
            ArgCnt: 1
        },
        columns: [
            [
                { field: "StartDT", title: "开始时间", width: 200 },
                { field: "EndDT", title: "结束时间", width: 200 },
                { field: "ColumnMinutes", title: "列分钟数", width: 160 }
            ]
        ]
    });

    $("#btnAddTimeLine").linkbutton({
        onClick: addTimeLine
    });

    $("#btnDelTimeLine").linkbutton({
        onClick: delTimeLine
    });
}

/**
 * 添加时间轴缩放信息
 * @author chenchangqing 20170908
 */
function addTimeLine() {
    var startDTStr = $("#startDT").datetimebox("getValue"),
        startDT = dhccl.toDateTime(startDTStr),
        startDate = startDT.format(constant.dateFormat),
        startTime = startDT.format(constant.timeFormat),
        endDTStr = $("#endDT").datetimebox("getValue"),
        endDT = dhccl.toDateTime(endDTStr),
        endDate = endDT.format(constant.dateFormat),
        endTime = endDT.format(constant.timeFormat),
        columnMinutes = $("#columnMinutes").numberspinner("getValue");
    var timeLine = {
        RecordSheet: record.context.recordSheetID,
        StartDate: startDate,
        StartTime: startTime,
        EndDate: endDate,
        EndTime: endTime,
        ColumnMinutes: columnMinutes,
        ClassName: ANCLS.Model.TimeLine
    };
    dhccl.saveDatas(ANCSP.DataListService, {
        jsonData: dhccl.formatObjects(timeLine)
    }, function(ret) {
        if (ret.indexOf(constant.successFlag) === 0) {
            $("#timeLineBox").datagrid("reload");
        } else {
            dhccl.showMessage(ret, "保存");
        }
    });
}

/**
 * 删除时间轴缩放信息
 */
function delTimeLine() {
    if (dhccl.hasRowSelected($("#timeLineBox"), true)) {
        $.messager.confirm("提示", "是否删除选中的时间轴缩放信息？", function(result) {
            if (!result) return;
            var selectedRow = $("#timeLineBox").datagrid("getSelected");
            var ret = dhccl.removeData(ANCLS.Model.TimeLine, selectedRow.RowId);
            dhccl.showMessage(ret, "删除", null, null, function(data) {
                $("#timeLineBox").datagrid("reload");
            });
        });
    }
}
// #endregion

$(document).ready(initialRecord);

/**
 * 开始监护
 * @author chenchangqing 20170908
 */
function startRecord() {
    var view = window.StartRecordView.instance;
    if (!view) {
        view = window.StartRecordView.init({
            saveHandler: saveRecordStartDT
        });
    }
    view.loadData({
        startDT: new Date().format("yyyy-MM-dd HH:mm"),
        isStarting: true,
        title: '开始监护'
    });
    view.open();
}

/**
 * 修改开始时间
 * @author chenchangqing 20170908
 */
function editRecordStartDT() {
    var view = window.StartRecordView.instance;
    if (!view) {
        view = window.StartRecordView.init({
            saveHandler: saveRecordStartDT
        });
    }
    view.loadData({
        startDT: record.context.recordStartDT.format("yyyy-MM-dd HH:mm"),
        title: '修改开始时间'
    });
    view.open();
}

/**
 * 结束监护
 * @author chenchangqing 20170908
 */
function stopRecord() {
    var view = window.StopRecordView.instance;
    if (!view) {
        view = window.StopRecordView.init({
            saveHandler: saveRecordEndDT
        });
    }

    var operSchedule = record.context.schedule;

    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.DataQueries,
        QueryName: 'FindAnaestEvaluation',
        Arg1: operSchedule.RowId,
        ArgCnt: 1
    }, 'json', true, function(data) {
        if (data.length > 0) {
            var evaluation = data[0];
            view.loadData({
                generalAnaesthesiaInductionEffect: evaluation.GeneralAnInduction,
                generalAnaesthesiaMaintainEffect: evaluation.GeneralAnMaintain,
                generalAnaesthesiaEndingEffect: evaluation.GeneralAnEnding,
                intraspinalAnesthesiaEffect: evaluation.IntraspinalAn,
                nerveBlockEffect: evaluation.NerveBlock,
                complication: evaluation.Complication
            });
        }
    });

    view.open();

    var stopDT = null;
    stopDT = record.context.recordEndDT.format("yyyy-MM-dd HH:mm");
    if (operSchedule.StatusCode === 'RoomIn') stopDT = null;

    view.loadData({
        stopDT: stopDT,
        theatreOutTransLoc: operSchedule.TheatreOutTransLoc
    });
}

/**
 * 撤销监护，当用户选错手术时可以撤销监护将麻醉单上已填内容删除
 */
function revokeMonitoring() {
    var originalDefaults = $.extend({}, $.messager.defaults);
    $.extend($.messager.defaults, {
        ok: '继续撤销',
        cancel: '取消',
        icon: 'warning'
    });
    var e = $.messager.confirm('撤销监护：警告', '<span style="color:red;">风险操作：</span><br/>撤销监护将删除麻醉单上已填写的所有数据，并返回初始状态，您确定吗？', function(confirmed) {
        if (confirmed) {
            revokeRecord();
            window.location.reload();
        }
    });
    e.css({ 'text-align': 'center' });
    e.find('.messager-icon')
        .addClass('messager-warning')
        .removeClass('messager-question')
        .css({ position: 'absolute' });
    $.extend($.messager.defaults, originalDefaults);
}
/**
 * 同步监护数据
 */
function asynAnaDatas() {
    var opsId = record.context.opsId;
    var sheetId = record.context.recordSheetID;
    var result = dhccl.runServerMethod("DHCAN.BLL.AnaestRecord", "SyncCollectData", opsId, sheetId);
    refreshPage();
}

/**
 * 撤销监护
 */
function revokeRecord() {
    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.AnaestRecord,
        MethodName: "RevokeRecord",
        Arg1: record.context.schedule.RowId,
        Arg2: session.UserID,
        ArgCnt: 2
    }, function(ret) {
        if (ret.indexOf("S^") === 0) {
            record.context.loadSchedule();
            record.context.loadParaItems();
            refreshPage();
            resetToolkit();
            refreshOperScheduleList();
            refreshProcedureBoard();
        } else {
            dhccl.showMessage(ret, "撤销监护");
        }
    });
}

/**
 * 初始化监护数据显示
 */
function initiateCollectView() {
    var view = window.collectView.instance;
    if (!view) {
        view = window.collectView.init($('#collectview'), {
            onQuery: function(callback) {
                dhccl.getDatas(ANCSP.DataQuery, {
                    ClassName: ANCLS.BLL.CollectData,
                    QueryName: 'FindLatestCollectData',
                    Arg1: record.context.schedule.RowId,
                    ArgCnt: 1
                }, 'json', true, callback)
            }
        });
    }

    view.open();
}

/**
 * 前页
 * @author chenchangqing 20170908
 */
function previousPage() {
    if (record.sheet) {
        record.sheet.previousPage();
    }
}

/**
 * 后页
 * @author chenchangqing 20170908
 */
function nextPage() {
    if (record.sheet) {
        record.sheet.nextPage();
    }
}

/**
 * 首页
 * @author chenchangqing 20170908
 */
function firstPage() {
    if (record.sheet) {
        record.sheet.firstPage();
    }
}

/**
 * 尾页
 * @author chenchangqing 20170908
 */
function lastPage() {
    if (record.sheet) record.sheet.lastPage();
}

/**
 * 打印全部
 * @author chenchangqing 20170908
 */
function printAllPage() {
    unselectAllData();
    record.sheet.drawPage();

    record.printingState = true;
    record.sheet.printingState = true;
    if (validateRecord(function() {
            if (isRecordStopped()) printDocument();
        }) && isRecordStopped()) printDocument();
}

function printDocument() {
    firstPage();
    // var canvas = document.getElementById("canvas");
    // var imageWidth = canvas.width,
    //     imageHeight = canvas.height;
    var pageSize = record.sheet.countAllPages(record.context.dataMaxDT);
    var lodop = getLodop();
    lodop.PRINT_INIT("AnaestRecord" + session.OPSID);
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");

    // var imgSrc = $("#AnaDoctorSign").attr("src");
    // imgSrc = (imgSrc && imgSrc !== splitchar.empty) ? imgSrc : splitchar.empty;
    // var signImg = (imgSrc !== splitchar.empty) ? ("<img src='" + imgSrc + "' width=70>") : "<img>";
    var lodopContext = new LodopContext({
        lodop: lodop,
        ratio: {
            x: 0.73,
            y: 0.76
        },
        offset: {
            x: 10,
            y: 5
        }
    });
    var prtConfig = sheetPrintConfig;
    //lodop.ADD_PRINT_IMAGE("15mm",prtConfig.logo.imgLeft,prtConfig.logo.imgWidth,prtConfig.logo.imgHeight,"<img src='"+prtConfig.logo.imgSrc+"'>");
    // lodop.SET_PRINT_STYLEA(0, "HOrient", 2);
    //lodop.SET_PRINT_STYLEA(0, "Stretch", 2);

    record.sheet.drawContext = lodopContext;
    for (var i = 0; i < pageSize; i++) {
        // var dataURL = canvas.toDataURL("image/png");
        // var image = "<img src='" + dataURL + "' width='" + imageWidth + "' height='" + imageHeight + "' style='background:#FFF'/>";
        //lodop.NEWPAGE();
        if (i > 0) {
            lodop.NEWPAGE();
            //    lodop.ADD_PRINT_IMAGE("15mm",prtConfig.logo.imgLeft,prtConfig.logo.imgWidth,prtConfig.logo.imgHeight,"<img src='"+prtConfig.logo.imgSrc+"'>");
            //    lodop.SET_PRINT_STYLEA(0, "Stretch", 2);
        }

        record.sheet.drawPage();
        lodop.ADD_PRINT_TEXT(1040, 580, "100%", 20, "麻醉医生签名：");
        lodop.ADD_PRINT_TEXT(1040, 660, "100%", 20, $("#AnaDoctorSign").triggerbox("getValue"));

        // lodop.ADD_PRINT_IMAGE(0, 40, "100%", "100%", image);
        // lodop.SET_PRINT_STYLEA(0, "Stretch", 2);
        // lodop.ADD_PRINT_IMAGE(1015, 350, 70, 70, signImg);
        //lodop.SET_PRINT_STYLEA(0, "Stretch", 2);
        // if (i == 0) printBackPage(lodop);
        // else lodop.NEWPAGE();
        //record.sheet.drawContext=record.sheet.canvasContext;
        //nextPage();
        record.sheet.currentPageNo++;
    }

    record.sheet.drawContext = record.sheet.canvasContext;
    firstPage();

    lodop.SET_PREVIEW_WINDOW(1, 2, 0, 0, 0, "");
    lodop.SET_PRINT_STYLEA(0, "Stretch", 2);
    //lodop.SET_PRINT_MODE("PRINT_DUPLEX", 2);
    lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1); //打印后自动关闭预览窗口
    var printedCount = lodop.PREVIEW();
    record.sheet.printingState = true;
    if (printedCount > 0) savePrintDT();
}

function archiveAllPages() {
    firstPage();
    var archiveContext = new ArchiveContext({
        ratio: {
            x: 0.545,
            y: 0.535
        },
        offset: {
            x: 0,
            y: 0
        }
    });

    record.sheet.drawContext = archiveContext;
    var pageSize = record.sheet.countAllPages(record.context.dataMaxDT);
    if (pageSize < 1) {
        record.sheet.drawPage();
    } else {
        for (var i = 0; i < pageSize; i++) {
            if (i > 0) {
                archiveContext.addPage();
            }
            record.sheet.drawPage();
            record.sheet.currentPageNo++;
        }
    }

    record.sheet.drawContext = record.sheet.canvasContext;
    firstPage();
    var ip = session.ArchiveServerIP;
    var port = session.ArchiveServerPort;
    var type = "AN";
    var id = record.context.opsId;
    var date = record.context.schedule.OperDate;
    var filename = "麻醉记录单.pdf";
    var patName = record.context.schedule.PatName;
    var moduleName = "麻醉记录单";
    archiveContext.archives({
        archiveServerUrl: "http://" + ip + ":" + port + "/archives",
        type: type,
        id: id,
        date: date,
        filename: filename,
        onSuccess: function(successMsg) {
            if (successMsg.indexOf("S^") === 0) {
                $.messager.alert("提示", "归档成功", "info", function() {
                    var pdfViewerUrl = "http://" + ip + ":" + port + "/pdfviewer?type=" + type + "&id=" + id + "&date=" + date + "&filename=" + encodeURIComponent(filename);
                    var saveResult = saveArchive(pdfViewerUrl);
                    var saveLogResult = saveArchiveLog(pdfViewerUrl);
                    //var url = "../service/dhcanop/lib/pdfjs/web/viewer.html?file=" + encodeURIComponent(pdfViewerUrl);
                    //var content = '<iframe src=" '+ url +' " style="width:100%; height:100%;" frameborder="0"></iframe> ';
                    //$("<div></div>").appendTo("body").dialog({
                    //    width: "800",
                    //    height: "600",
                    //    title: "归档-麻醉记录单",
                    //    closed: false,
                    //    modal: true,
                    //    content: content
                    //});
                    var recordBrowser = new RecordBrowser({
                        title: patName + "的" + moduleName,
                        href: pdfViewerUrl,
                        width: 1280,
                        height: 800
                    });
                    recordBrowser.open();
                });
            } else {
                $.messager.alert("错误", "归档失败:" + successMsg, "error");
            }
        },
        onError: function(params) {
            $.messager.alert("错误", "归档失败:" + errorMsg, "error");
        }
    });
}

function CaseBrow() {
    var pdfViewerUrl = dhccl.runServerMethodNormal(ANCLS.BLL.RecordSheet, "GetSheetFilePath", session.RecordSheetID);
    if (pdfViewerUrl.indexOf("E^") == 0) $.messager.alert("错误", pdfViewerUrl, "error");
    else window.open(pdfViewerUrl);

}

function saveArchive(filePath) {
    var saveDatas = [{
        ClassName: ANCLS.Model.RecordSheet,
        RowId: session.RecordSheetID,
        FileUser: session.UserID,
        FileDate: "today",
        FileTime: "now",
        FilePath: filePath
    }];

    var saveStr = dhccl.formatObjects(saveDatas);
    var saveResult = dhccl.saveDatas(ANCSP.DataListService, {
        jsonData: saveStr
    });

    return saveResult;
}

function saveArchiveLog(filePath) {
    var saveDatas = [{
        ClassName: "CIS.AN.ArchiveLog",
        RecordSheet: session.RecordSheetID,
        ArchiveUser: session.UserID,
        ArchiveDate: "today",
        ArchiveTime: "now",
        Url: filePath
    }];

    var saveStr = dhccl.formatObjects(saveDatas);
    var saveResult = dhccl.saveDatas(ANCSP.DataListService, {
        jsonData: saveStr
    });

    return saveResult;
}
/**
 * 打印时未结束监护则弹出
 */
function isRecordStopped() {
    if (!record.context.schedule.TheatreOutDT) {
        var originalDefaults = $.extend({}, $.messager.defaults);
        $.extend($.messager.defaults, {
            ok: '继续',
            cancel: '取消',
            icon: 'warning'
        });
        var e = $.messager.confirm('警告', '您尚未结束监护，需结束监护之后再打印', function(confirmed) {
            if (confirmed) {
                stopRecord();
            }
        });
        e.css({ 'text-align': 'center' });
        e.find('.messager-icon')
            .addClass('messager-warning')
            .removeClass('messager-question')
            .css({ position: 'absolute' });
        $.extend($.messager.defaults, originalDefaults);
        return false;
    }

    return true;
}

/**
 * 校验界面数据是否完成
 */
function validateRecord(callback) {
    var areas = record.context.displayAreas;
    var area;
    var incompletedItems = [];
    for (var key in areas) {
        area = areas[key];
        if (area.dataItems) varifyItems(area.dataItems);
    }

    if (incompletedItems.length > 0) {
        var length = incompletedItems.length;
        var itemNameList = [];
        for (var i = 0; i < length; i++) {
            itemNameList.push("<strong>" + incompletedItems[i].title + "</strong>");
        }

        var originalDefaults = $.extend({}, $.messager.defaults);
        $.extend($.messager.defaults, {
            ok: '继续',
            cancel: '取消',
            icon: 'warning'
        });
        var e = $.messager.confirm('警告', itemNameList.join('<br/>') + '<br/>以上内容未完成填写，是否继续打印？', function(confirmed) {
            if (confirmed) {
                if (callback) callback();
            }
        });
        e.css({ 'text-align': 'center' });
        e.find('.messager-icon')
            .removeClass('messager-question')
            .addClass('messager-warning')
            .css({ position: 'absolute' });
        $.extend($.messager.defaults, originalDefaults);
        return false;
    }

    return true;

    function varifyItems(dataItems) {
        if ($.isArray(dataItems)) {
            var length = dataItems.length;
            for (var i = 0; i < length; i++) {
                var subLength = dataItems[i].length;
                for (var j = 0; j < subLength; j++) {
                    varifyItem(dataItems[i][j]);
                }
            }
        }
    }

    function varifyItem(dataItem) {
        if (dataItem.required && !dataItem.value) {
            incompletedItems.push(dataItem);
        }
    }
}

/**
 * 打印麻醉单背面
 */
function printBackPage(lodop) {
    var imgSrc = $("#AnaDoctorSign").attr("src");
    imgSrc = (imgSrc && imgSrc !== splitchar.empty) ? imgSrc : splitchar.empty;
    var signImg = (imgSrc !== splitchar.empty) ? ("<img src='" + imgSrc + "' width=70>") : "<img>";

    var data = getBackPageData();
    lodop.NEWPAGE();
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    lodop.SET_PRINT_STYLE("FontName", "微软雅黑");
    lodop.SET_PRINT_STYLE("FontSize", 10);
    lodop.ADD_PRINT_TEXT(20, 150, 500, 30, "山 西 省 肿 瘤 医 院");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 16); //设置字体
    //lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1) //两端对齐，居中

    lodop.ADD_PRINT_TEXT(60, 60, 680, 20, "全麻患者术中血气、电解质、糖及代谢物等检测申请单");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 14); //设置字体
    //lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1) //两端对齐，居中

    lodop.ADD_PRINT_TEXT(110, 80, 660, 15, "请在需要检测的指标左侧白框中划钩，确定检测的指标。");

    lodop.ADD_PRINT_TEXT(150, 80, 340, 15, "如果需要全部检测指标，请在此处签字确定");
    lodop.ADD_PRINT_IMAGE(150, 350, 70, 70, signImg);
    //lodop.SET_PRINT_STYLEA(0, "Stretch", 2);
    //lodop.ADD_PRINT_LINE(165, 340, 165, 460, 0, 1);
    //lodop.ADD_PRINT_TEXT(150, 460, 30, 15, "。");

    lodop.ADD_PRINT_HTM(190, 40, 400, 20, '<input type="checkbox">血气分析');
    lodop.ADD_PRINT_HTM(230, 40, 400, 20, '<input type="checkbox">钾测定（干化学法）');
    lodop.ADD_PRINT_HTM(270, 40, 400, 20, '<input type="checkbox">钠测定（干化学法）');
    lodop.ADD_PRINT_HTM(310, 40, 400, 20, '<input type="checkbox">氯测定（干化学法）');
    lodop.ADD_PRINT_HTM(350, 40, 400, 20, '<input type="checkbox">钙测定（干化学法）');
    lodop.ADD_PRINT_HTM(390, 40, 400, 20, '<input type="checkbox">血清碳酸氢盐测定');
    lodop.ADD_PRINT_HTM(430, 40, 400, 20, '<input type="checkbox">血一氧化碳分析');
    lodop.ADD_PRINT_HTM(470, 40, 400, 20, '<input type="checkbox">血红蛋白测定');
    lodop.ADD_PRINT_HTM(510, 40, 400, 20, '<input type="checkbox">红细胞比积测定');

    lodop.ADD_PRINT_HTM(230, 460, 300, 20, '<input type="checkbox">葡萄糖测定（干化学法）');
    lodop.ADD_PRINT_HTM(270, 460, 300, 20, '<input type="checkbox">血浆乳酸测定');
    lodop.ADD_PRINT_HTM(310, 460, 300, 20, '<input type="checkbox">血浆游离血红蛋白测定');
    lodop.ADD_PRINT_HTM(350, 460, 300, 20, '<input type="checkbox">高铁血红蛋白还原测定');
    lodop.ADD_PRINT_HTM(390, 460, 300, 20, '<input type="checkbox">还原型血红蛋白溶解测定');
    lodop.ADD_PRINT_HTM(430, 460, 300, 20, '<input type="checkbox">抗碱血红蛋白测定');
    lodop.ADD_PRINT_HTM(470, 460, 300, 20, '<input type="checkbox">血氧饱和度测定');
    lodop.ADD_PRINT_HTM(510, 460, 300, 20, '<input type="checkbox">血清渗透压测定');

    lodop.ADD_PRINT_TEXT(710, 220, 340, 30, "PACU患者回房交接单");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 16); //设置字体
    //lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1) //两端对齐，居中

    lodop.ADD_PRINT_LINE(750, 40, 750, 770, 0, 1);
    lodop.ADD_PRINT_LINE(750, 40, 950, 40, 0, 1);
    lodop.ADD_PRINT_LINE(950, 40, 950, 770, 0, 1);
    lodop.ADD_PRINT_LINE(750, 770, 950, 770, 0, 1);

    lodop.ADD_PRINT_TEXT(760, 50, 100, 15, "术后送回：");
    lodop.ADD_PRINT_HTM(755, 160, 80, 20, '<input type="checkbox" class="PostShiftLoc" value="病房"' + (getDataValue(data, "PostShiftLoc") == "病房") + '>病房');
    lodop.ADD_PRINT_HTM(755, 260, 80, 20, '<input type="checkbox" class="PostShiftLoc" value="ICU"' + (getDataValue(data, "PostShiftLoc") == "ICU") + '>ICU');
    lodop.ADD_PRINT_HTM(755, 360, 80, 20, '<input type="checkbox" class="PostShiftLoc" value="其他"' + (getDataValue(data, "PostShiftLoc") == "其他") + '>其他');

    lodop.ADD_PRINT_TEXT(790, 50, 50, 15, "意识：");
    lodop.ADD_PRINT_LINE(805, 90, 805, 150, 0, 1);
    lodop.ADD_PRINT_TEXT(790, 95, 40, 15, getDataValue(data, "Consciousness"));

    lodop.ADD_PRINT_TEXT(790, 160, 50, 15, "血压：");
    lodop.ADD_PRINT_LINE(805, 200, 805, 290, 0, 1);
    lodop.ADD_PRINT_TEXT(790, 205, 70, 15, getDataValue(data, "BloodPressure"));
    lodop.ADD_PRINT_TEXT(790, 290, 60, 15, "mmHg");

    lodop.ADD_PRINT_TEXT(790, 345, 50, 15, "心率：");
    lodop.ADD_PRINT_LINE(805, 385, 805, 435, 0, 1);
    lodop.ADD_PRINT_TEXT(790, 390, 40, 15, getDataValue(data, "Pulse"));
    lodop.ADD_PRINT_TEXT(790, 435, 60, 15, "次/分");

    lodop.ADD_PRINT_TEXT(790, 485, 50, 15, "呼吸：");
    lodop.ADD_PRINT_LINE(805, 525, 805, 575, 0, 1);
    lodop.ADD_PRINT_TEXT(790, 530, 40, 15, getDataValue(data, "Respiration"));
    lodop.ADD_PRINT_TEXT(790, 575, 60, 15, "次/分");

    lodop.ADD_PRINT_TEXT(790, 625, 80, 15, "穿刺部位：");
    lodop.ADD_PRINT_LINE(805, 690, 805, 765, 0, 1);
    lodop.ADD_PRINT_TEXT(790, 695, 80, 15, getDataValue(data, "PunctureSite"));

    lodop.ADD_PRINT_TEXT(830, 50, 60, 15, "引流：");
    lodop.ADD_PRINT_LINE(845, 90, 845, 240, 0, 1);
    lodop.ADD_PRINT_TEXT(830, 95, 130, 15, getDataValue(data, "Drainage"));

    lodop.ADD_PRINT_TEXT(830, 240, 60, 15, "皮肤：");
    lodop.ADD_PRINT_HTM(825, 285, 60, 20, '<input type="checkbox" class="PostSkin" value="完整"' + (getDataValue(data, "PostSkin") == "完整") + '>完整');
    lodop.ADD_PRINT_HTM(825, 345, 60, 20, '<input type="checkbox" class="PostSkin" value="破损"' + (getDataValue(data, "PostSkin") == "破损") + '>破损');
    lodop.ADD_PRINT_TEXT(830, 400, 50, 15, '（部位');
    lodop.ADD_PRINT_LINE(845, 450, 845, 565, 0, 1);
    lodop.ADD_PRINT_TEXT(830, 455, 100, 15, getDataValue(data, "PostSkinOther"));
    lodop.ADD_PRINT_TEXT(830, 570, 30, 15, '）');

    lodop.ADD_PRINT_TEXT(830, 600, 50, 15, "其他：");
    lodop.ADD_PRINT_LINE(845, 640, 845, 765, 0, 1);
    lodop.ADD_PRINT_TEXT(830, 645, 120, 15, getDataValue(data, "Other"));

    lodop.ADD_PRINT_TEXT(870, 50, 80, 15, "病历片子：");
    lodop.ADD_PRINT_LINE(885, 120, 885, 310, 0, 1);
    lodop.ADD_PRINT_TEXT(870, 125, 200, 15, getDataValue(data, "Picture"));

    lodop.ADD_PRINT_TEXT(870, 340, 60, 15, "备注：");
    lodop.ADD_PRINT_LINE(885, 385, 885, 765, 0, 1);
    lodop.ADD_PRINT_TEXT(870, 390, 370, 15, getDataValue(data, "Note"));

    lodop.ADD_PRINT_TEXT(910, 50, 120, 15, "病房护士签名：");
    lodop.ADD_PRINT_LINE(925, 150, 925, 300, 0, 1);
    lodop.ADD_PRINT_TEXT(910, 155, 140, 15, getDataValue(data, "WardNurseSign"));

    lodop.ADD_PRINT_TEXT(910, 310, 120, 15, "PACU护士签名：");
    lodop.ADD_PRINT_LINE(925, 410, 925, 560, 0, 1);
    lodop.ADD_PRINT_TEXT(910, 415, 140, 15, getDataValue(data, "PACUNurseSign"));

    lodop.ADD_PRINT_TEXT(910, 570, 80, 15, "交接时间：");
    lodop.ADD_PRINT_LINE(925, 640, 925, 765, 0, 1);
    lodop.ADD_PRINT_TEXT(910, 645, 120, 15, getDataValue(data, "PostHandoverTime"));
}

function getDataValue(data, Code) {
    return data[Code] || '';
}

/**
 * 获取背面打印数据
 */
function getBackPageData() {
    var opsId = record.context.schedule.RowId;
    var operDataList = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.OperData,
        QueryName: 'FindOperData',
        Arg1: opsId,
        Arg2: 'PACUTransaction',
        ArgCnt: 2
    }, 'json', false);

    var backPageData = {};
    var length = operDataList.length;
    for (var i = 0; i < length; i++) {
        backPageData[operDataList[i].DataItem] = operDataList[i].DataValue;
    }

    return backPageData;
}

/**
 * 保存打印时间
 */
function savePrintDT() {
    var now = new Date();
    var data = {
        ClassName: ANCLS.Model.RecordSheet,
        RowId: session.RecordSheetID,
        PrintUser: session.UserID,
        PrintDate: now.format(constant.dateFormat),
        PrintTime: now.format(constant.timeFormat)
    }

    dhccl.saveDatas(ANCSP.DataService, data, function(data) {});
}

/**
 * 打印当前页
 * @author chenchangqing 20170908
 */
function printCurrentPage() {
    unselectAllData();

    record.printingState = true;
    record.sheet.printingState = true;
    if (validateRecord(function() {
            if (isRecordStopped()) print();
        }) && isRecordStopped()) print();
    record.printingState = true;
    record.sheet.printingState = false;

    function print() {
        var lodop = getLodop();
        lodop.PRINT_INIT("AnaestRecord" + session.OPSID);
        lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
        var prtConfig = sheetPrintConfig;
        var lodopContext = new LodopContext({
            lodop: lodop,
            ratio: {
                x: 0.73,
                y: 0.76
            },
            offset: {
                x: 10,
                y: 5
            }
        });
        record.sheet.drawContext = lodopContext;
        record.sheet.drawPage();
        //lodop.ADD_PRINT_TEXT(1080,580,"100%",20,"麻醉医生签名：");
        var printCount = lodop.PREVIEW();
        record.sheet.drawContext = record.sheet.canvasContext;
        record.sheet.drawPage();
    }
}

/**
 * 抢救模式
 * @author chenchangqing 20170908
 */
function changeRescueMode() {
    var currentDT = record.context.recordStartDT.format("yyyy-MM-dd HH:mm");
    $("#startDT,#endDT").datetimebox("setValue", currentDT);
    $("#timeLineDialog").dialog("open");
}

/**
 * 打开生命体征数据总览
 * @author yongyang 20180420
 */
function openVitalSignDataManager() {
    var manager = window.vitalSignDataManager.instance;
    if (!manager) {
        manager = window.vitalSignDataManager.init({
            saveHandler: saveAnaDatas
        });
    }
    dhccl.getDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.AnaestRecord,
        MethodName: 'GetVitalSignGroupedData',
        Arg1: record.context.opsId,
        Arg2: record.context.moduleId,
        ArgCnt: 2
    }, 'json', true, function(data) {
        manager.loadData(data);
    })
    manager.open();
}

/**
 * 打开生命体征批量删除对话框
 * @author yongyang 20200325
 */
function openVitalSignBatchView() {
    if (!record.sheet) return;
    var clickInfo = record.sheet.clickInfo;
    if (!clickInfo || !clickInfo.item) return;
    if (clickInfo.area !== record.context.displayAreas.data &&
        clickInfo.area !== record.context.displayAreas.event) return;
    if (!clickInfo.item) return;

    var view = window.vitalSignBatchView.instance;
    if (!view) {
        view = window.vitalSignBatchView.init({
            saveHandler: removeBatchData
        });
    }

    var startDT = clickInfo.locDT.format(constant.dateTimeFormat);
    view.loadData({
        paraItem: clickInfo.item.Description,
        paraItemRowId: clickInfo.item.RowId,
        startDT: startDT,
        endDT: startDT,
        title: '批量删除' + clickInfo.item.Description + '数据',
    });
    view.open();
}

/**
 * 批量删除数据
 * @author yongyang 20200325
 */
function removeBatchData(data) {
    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.AnaestRecord,
        MethodName: "RemoveBatchData",
        Arg1: record.context.opsId,
        Arg2: data.paraItem || '',
        Arg3: data.startDT || '',
        Arg4: data.endDT || '',
        ArgCnt: 4
    }, function(data) {
        refreshPage();
    });
}

/**
 * 打开药品数据总览
 * @author yongyang 20180420
 */
function openDrugDataManager() {
    var manager = window.drugDataManager.instance;
    if (!manager) {
        manager = window.drugDataManager.init({
            categoryItems: record.context.categoryItems,
            dataCategories: record.context.getDrugDataCategories(),
            comboDataSource: {
                DoseUnits: record.context.drugDoseUnits,
                SpeedUnits: record.context.drugSpeedUnits,
                ConcentrationUnits: record.context.drugConcentrationUnits,
                Instructions: record.context.drugInstructions,
                Reasons: record.context.drugReasons,
            },
            saveHandler: saveDrugDatas
        });
    }
    var drugParaItems = record.context.getDrugParaItems();
    var drugDatas = record.context.getAllDrugDatas();
    manager.setParaItems(drugParaItems);
    manager.loadData(drugDatas);
    //加载模拟数据
    /*$.ajax({
        url: '../service/dhcanop/data/test.drugdata.json',
        method: 'GET',
        async: false,
        success: function(data) {
            manager.loadData(data);
        }
    });*/
    //manager.loadData(record.context.getDrugAnaDatas());
    manager.open();
}

/**
 * 打开事件数据总览
 * @author yongyang 20180417
 */
function openEventDataManager() {
    var manager = window.eventDataManager.instance;
    if (!manager) {
        manager = window.eventDataManager.init({
            categoryItems: record.context.categoryItems,
            eventCategories: record.context.getEventDataCategories(),
            saveHandler: saveEventDatas
        });
    }
    var eventParaItem = record.context.getEventParaItem();
    var eventDatas = record.context.getAnaDatas(eventParaItem.RowId);
    manager.setParaItem(eventParaItem);
    manager.loadData(eventDatas);
    //加载模拟数据
    /*$.ajax({
        url: '../service/dhcanop/data/test.eventdata.json',
        method: 'GET',
        async: false,
        success: function(data) {
            manager.loadData(data);
        }
    });*/

    manager.open();
}

/**
 * 打开快捷方式管理界面
 * @author yongyang 20181118
 */
function openShortcutView() {
    var view = window.shortcutView.instance;
    if (!view) {
        view = window.shortcutView.init({
            comboDataSource: {
                DoseUnits: record.context.drugDoseUnits,
                SpeedUnits: record.context.drugSpeedUnits,
                ConcentrationUnits: record.context.drugConcentrationUnits,
                Instructions: record.context.drugInstructions,
                Reasons: record.context.drugReasons,
            },
            drugCategories: record.context.getDrugDataCategories(),
            eventCategories: record.context.getEventDataCategories(),
            intrmiDrugCategories: record.context.getIntrmiDrugDataCategories(),
            saveHandler: saveUserPreferedData,
            removeHandler: removeUserPreferedData,
            applyHandler: applyUserPreferedData,
            getPageDataHandler: function() {
                return record.context.anaDatas;
            }
        });
        loadUserPreferedData();
        retrieveUserDefinedItem('', function(items) {
            view.loadUserDefinedItems(items);
        });
    }

    view.setDateTime(record.context.recordStartDT);
    view.open();
}

/**
 * 加载用户偏好数据，仅用户个人添加的数据
 */
function loadUserPreferedData() {
    var view = window.shortcutView.instance;

    var datas = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: 'FindUserPreferedData',
        Arg1: session['ModuleID'],
        Arg2: session['UserID'],
        Arg3: 'Private',
        ArgCnt: 2
    }, 'json', false, null);

    var drugDatas = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: 'FindUserPreferedDrug',
        Arg1: session['ModuleID'],
        Arg2: session['UserID'],
        Arg3: 'Private',
        ArgCnt: 2
    }, 'json', false, null);

    if (datas && drugDatas) {
        var length = datas.length;
        var dataDic = {};
        for (var i = 0; i < length; i++) {
            dataDic[datas[i].RowId] = datas[i];
        }

        var length = drugDatas.length;
        var drugData, data;
        for (var i = 0; i < length; i++) {
            drugData = drugDatas[i];
            data = dataDic[drugData.UserPreferedData];
            if (data) {
                data.DrugData = drugData;
                if (!data.DrugDataList) data.DrugDataList = [];
                data.DrugDataList.push(drugData);
            }
        }
    }

    view.loadData(datas);
}

/**
 * 加载用户偏好数据，用户个人添加的数据以及科室公用数据
 */
function loadPublicPreferedData() {
    var datas = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: 'FindUserPreferedData',
        Arg1: session['ModuleID'],
        Arg2: session['UserID'],
        Arg3: 'All',
        Arg4: session['DeptID'],
        ArgCnt: 4
    }, 'json', false, null);

    var drugDatas = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: 'FindUserPreferedDrug',
        Arg1: session['ModuleID'],
        Arg2: session['UserID'],
        Arg3: 'All',
        Arg4: session['DeptID'],
        ArgCnt: 4
    }, 'json', false, null);

    var eventDatas = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: 'FindUserPreferedEventDetail',
        Arg1: session['ModuleID'],
        Arg2: session['UserID'],
        Arg3: 'All',
        Arg4: session['DeptID'],
        ArgCnt: 4
    }, 'json', false, null);

    var publicPreferedDataDic = {};
    if (datas && drugDatas) {
        var length = datas.length;
        var dataDic = {};
        var preferedData;
        for (var i = 0; i < length; i++) {
            preferedData = datas[i];
            dataDic[datas[i].RowId] = preferedData;
            if (preferedData.CategoryItem) {
                if (!publicPreferedDataDic[preferedData.CategoryItem])
                    publicPreferedDataDic[preferedData.CategoryItem] = [];

                publicPreferedDataDic[preferedData.CategoryItem].push(preferedData);
            }
        }

        var detailInfoDics = [];
        var length = drugDatas.length;
        var drugData, data;
        for (var i = 0; i < length; i++) {
            drugData = drugDatas[i];
            data = dataDic[drugData.UserPreferedData];
            if (data) {
                if (!data.DrugData) data.DrugData = drugData;
                if (!data.DrugDataList) data.DrugDataList = [];
                data.DrugDataList.push(drugData);
            }
        }

        var length = eventDatas.length;
        var eventData, data;
        for (var i = 0; i < length; i++) {
            eventData = eventDatas[i];
            data = dataDic[eventData.UserPreferedData];
            if (data) {
                if (!data.EventDetailDatas) data.EventDetailDatas = [];
                data.EventDetailDatas.push(eventData);
                if (!detailInfoDics[eventData.UserPreferedData]) detailInfoDics[eventData.UserPreferedData] = [];
                detailInfoDics[eventData.UserPreferedData].push(eventData.EventDetailDesc + ' : ' + eventData.DataValue + eventData.DataUnit);
            }
        }

        var length = datas.length;
        for (var i = 0; i < length; i++) {
            datas[i].DetailInfo = (detailInfoDics[datas[i].RowId] || []).join('\n');
        }

    }

    record.publicPreferedDataDic = publicPreferedDataDic;
}

function initEditorPreferedDataView() {
    var editor = window.EventEditor.instance;
    if (editor) {
        editor.loadPreferedData(record.publicPreferedDataDic);
    }
}

/**
 * 保存用户偏好数据
 */
function saveUserPreferedData(savingDatas) {
    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.AnaestRecord,
        MethodName: "SaveUserPreferedData",
        Arg1: session.ModuleID,
        Arg2: dhccl.formatObjects(savingDatas),
        Arg3: session.UserID,
        ArgCnt: 3
    }, function(data) {
        loadUserPreferedData();
    });
}

/**
 * 删除用户偏好数据
 */
function removeUserPreferedData(removingData) {
    removingData.isRemoved = "Y";
    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.AnaestRecord,
        MethodName: "SaveUserPreferedData",
        Arg1: session.ModuleID,
        Arg2: dhccl.formatObject(removingData),
        Arg3: session.UserID,
        ArgCnt: 3
    }, function(data) {});
}

/**
 * 应用用户偏好数据
 * @param {*} userPreferedDatas 
 */
function applyUserPreferedData(userPreferedDatas, startDateTime) {
    var idStr = "";
    if (userPreferedDatas.length) {
        var idArr = [];
        var length = userPreferedDatas.length;
        for (var i = 0; i < length; i++) {
            idArr.push(userPreferedDatas[i].RowId);
        }
        idStr = idArr.join(',');
    } else if (userPreferedDatas) {
        idStr = userPreferedDatas.RowId;
    }

    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.AnaestRecord,
        MethodName: "ApplyUserPreferedData",
        Arg1: record.context.recordSheetID,
        Arg2: session.UserID,
        Arg3: idStr,
        Arg4: startDateTime,
        ArgCnt: 4
    }, function(data) {
        if (data.indexOf('S^') > -1) {
            refreshPage();
        } else {

        }
    });
}


/**
 * 打开个人偏好设置界面
 * @author yongyang 20181217
 */
function openPersonalSettingView() {
    var view = window.PersonalSettingView.instance;
    if (!view) {
        view = window.PersonalSettingView.init({
            saveHandler: savePersonalSetting
        });
    }

    if (!record.context.templates || record.context.templates.length == 0) loadTemplate(function() {
        view.setComboDataSource({
            templates: record.context.templates
        });
    });
    else {
        view.setComboDataSource({
            templates: record.context.templates
        });
    }

    if (!view.loaded) {
        record.context.loadPersonalSetting(function(data) {
            view.loadData(data);
        });
    }

    view.open();
}

/**
 * 保存个人偏好设置
 */
function savePersonalSetting(data) {
    $.extend(data, {
        ClassName: ANCLS.Config.PersonalSetting
    });
    dhccl.saveDatas(ANCSP.DataService, data, function(result) {
        record.context.loadPersonalSetting(function(data) {
            var view = window.PersonalSettingView.instance;
            view.loadData(data);
        });
    });
}

/**
 * 打开用户模板管理界面
 * @author yongyang 20180420
 */
function openUsersTemplateManager() {
    var manager = window.usersTemplateManager.instance;
    if (!manager) {
        manager = window.usersTemplateManager.init({
            categoryItems: record.context.categoryItems,
            displayCategories: record.context.displayCategories,
            drugCategories: record.context.getDrugDataCategories(),
            eventCategories: record.context.getEventDataCategories(),
            intrmiDrugCategories: record.context.getIntrmiDrugDataCategories(),
            units: record.context.units,
            concentrationUnits: record.context.drugConcentrationUnits,
            instructions: record.context.drugInstructions,
            groupSetting: (record.context.groupSettings || [])[0],
            comboDataSource: {
                DoseUnits: record.context.drugDoseUnits,
                SpeedUnits: record.context.drugSpeedUnits,
                ConcentrationUnits: record.context.drugConcentrationUnits,
                Instructions: record.context.drugInstructions,
                Reasons: record.context.drugReasons,
            },
            saveHandler: saveTemplate,
            applyHandler: applyTemplate,
            removeHandler: removeTemplate,
            getPageDataHandler: function() {
                return record.context.anaDatas;
            },
            clearEventDataHandler: function() {
                dhccl.saveDatas(ANCSP.MethodService, {
                    ClassName: ANCLS.BLL.AnaestRecord,
                    MethodName: "ClearEventData",
                    Arg1: session.RecordSheetID,
                    Arg2: session.UserID,
                    ArgCnt: 2
                }, function(data) {});
            }
        });
    }

    if (!manager.userDefinedItemLoaded) {
        retrieveUserDefinedItem('', function(data) {
            manager.loadUserDefinedItems(data);
        });
    }

    if (!manager.loaded) loadTemplate();
    manager.setRecordStartDT(record.context.recordStartDT);
    manager.open();
}

/**
 * 加载模板数据
 */
function loadTemplate(fn) {
    record.context.loadTemplate(function() {
        var manager = window.usersTemplateManager.instance;
        if (manager) manager.loadData(record.context.templates || []);
        if (fn) fn.call(this);
    });
}

/**
 * 保存模板及模板项
 */
function saveTemplate(template) {
    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.AnaestRecord,
        MethodName: "SaveTemplate",
        Arg1: session.ModuleID,
        Arg2: dhccl.formatObjects(template),
        Arg3: session.UserID,
        ArgCnt: 3
    }, function(data) {
        loadTemplate();
    });
}

/**
 * 应用模板及模板项
 */
function applyTemplate(templateId) {
    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.AnaestRecord,
        MethodName: "ApplyTemplate",
        Arg1: record.context.recordSheetID,
        Arg2: templateId,
        Arg3: session.UserID,
        ArgCnt: 3
    }, function(data) {
        record.context.loadParaItems();
        refreshPage();
    });
}

function removeTemplate(template) {
    dhccl.removeData(ANCLS.Config.ModuleTemplate, template.RowId);
}
/**
 * 打开记费登记
 */
function openChargeView() {
    var view = window.chargeView.instance;
    if (!view) {
        var doseUnits = record.context.drugDoseUnits || [];
        var length = doseUnits.length;
        var orderDoseUnits = [];
        for (var i = 0; i < length; i++) {
            if (doseUnits[i].ExternalID) orderDoseUnits.push(doseUnits[i]);
        }

        view = window.chargeView.init({
            operSchedule: record.context.schedule,
            saveHandler: saveChargeDetails,
            retrieveHandler: loadChargeDetails,
            savePrintLogHandler: savePrintLog,
            auditHandler: auditChargeDetails,
            generateHandler: generateChargeDetails,
            comboDataSource: {
                DoseUnits: orderDoseUnits,
                SpeedUnits: record.context.drugSpeedUnits,
                ConcentrationUnits: record.context.drugConcentrationUnits,
                Instructions: record.context.drugInstructions,
                Reasons: record.context.drugReasons
            }
        })
    }

    if (!view.isItemLoaded) {
        dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: ANCLS.BLL.ConfigQueries,
            QueryName: "FindChargeItemFront",
            Arg1: session.DeptID,
            ArgCnt: 1
        }, 'json', true, function(data) {
            view.loadItem(data);
        });
    }

    loadChargeDetails(function(data) {
        view.loadData(data);
    });

    dhccl.getDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.PrintLog,
        MethodName: "GetPrintCount",
        Arg1: session.RecordSheetID,
        Arg2: "ChargeRecord",
        ArgCnt: 2
    }, 'text', true, function(data) {
        view.setPrintCount(Number(data));
    });

    view.open();
}

/**
 * 保存计费登记明细项
 */
function saveChargeDetails(datas, callback) {
    dhccl.saveDatas(ANCSP.DataListService, {
        ClassName: ANCLS.BLL.ChargeRecord,
        MethodName: 'SaveChargeRecordDetails',
        jsonData: dhccl.formatObjects(datas)
    }, function(data) {
        if (callback) callback(data);
        if (data.indexOf('S^')) {

        } else {

        }
    });
}

/**
 * 系统自动生成医嘱（根据用药数据、麻醉方法等自动生成）
 */
function generateChargeDetails(callback) {
    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.ChargeRecord,
        MethodName: 'GenerateChargeDetail',
        Arg1: session.OPSID,
        Arg2: session.DeptID,
        Arg3: session.UserID,
        ArgCnt: 3
    }, function(data) {
        if (callback) callback(data);
        if (data.indexOf('S^')) {

        } else {

        }
    });
}


/**
 * 审核记费明细项（生成医嘱到HIS）
 */
function auditChargeDetails(datas, callback) {
    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.ChargeRecord,
        MethodName: 'AuditChargeDetails',
        Arg1: dhccl.formatObjects(datas),
        Arg2: session.UserID,
        Arg3: session.DeptID,
        ArgCnt: 3
    }, function(data) {
        if (callback) callback(data);
        if (data.indexOf('S^')) {

        } else {

        }
    });
}

/**
 * 加载记费记录明细
 * @param {*} callback 
 */
function loadChargeDetails(callback) {
    var opsId = record.context.schedule.RowId;
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ChargeRecord,
        QueryName: "FindChargeRecordDetails",
        Arg1: session.DeptID,
        Arg2: opsId,
        ArgCnt: 2
    }, 'json', true, function(data) {
        if (callback) callback(data);
    });
}

/**
 * 保存打印操作记录
 */
function savePrintLog(data, callback) {
    var param = $.extend({
        ClassName: ANCLS.Model.PrintLog,
        RecordSheet: session.RecordSheetID,
        PrintUser: session.UserID
    }, data);

    dhccl.saveDatas(ANCSP.DataService, param, function(data) {
        if (callback) callback(data);
        if (data.indexOf('S^')) {

        } else {

        }
    });
}

// #region 鼠标右键上下文菜单设置函数
/**
 * 设置麻醉记录表单的上下文菜单
 * @param {AnaestSheet} anaestSheet - 麻醉记录表单对象
 * @param {Object} menuLoc - 上下文菜单的起始坐标
 * @author chenchangqing 20170806
 */
function setItemMenus(anaestSheet, menuLoc) {
    if (anaestSheet && anaestSheet.clickInfo) {
        if (record.itemMenus) record.itemMenus.menu('destroy');
        var itemMenus = $('<div class="hisui-menu" style="width:140px;"></div>').appendTo('body');
        itemMenus.menu({});
        var itemArea = record.context.displayAreas.item,
            dataArea = record.context.displayAreas.data;
        var contextMenuItems = record.context.getContextMenuItems(anaestSheet.clickInfo);
        var categoryMenuItems = [];
        if (anaestSheet.clickInfo.area === itemArea && !anaestSheet.clickInfo.item) {
            categoryMenuItems = record.context.getCategoryMenus(anaestSheet.clickInfo.category);
        }
        var menuItems = categoryMenuItems.concat(contextMenuItems);
        if (menuItems && menuItems.length > 0) {
            setContextMenu(itemMenus, menuItems);
            itemMenus.menu("show", {
                left: menuLoc.pageX,
                top: menuLoc.pageY
            });
        } else {
            itemMenus.menu("hide");
        }
        record.itemMenus = itemMenus;
    }
}

/**
 * 生成麻醉记录表单上下文菜单
 * @param {object} contextMenu - 菜单容器
 * @param {Array} menuItems - 菜单项数组 
 * @author chenchangqing 20170806
 */
function setContextMenu(contextMenu, menuItems) {
    for (var i = 0; i < menuItems.length; i++) {
        var menuItem = menuItems[i],
            menuItemClick = window[menuItem.onclick];
        if (menuItem['separator']) {
            contextMenu.menu("appendItem", {
                separator: true
            });
        } else {
            contextMenu.menu("appendItem", {
                text: menuItem.title,
                onclick: menuItemClick,
                menuItem: menuItem,
                disabled: menuItem.disable && window[menuItem.disable]()
            });
            var parentMenu = contextMenu.menu("findItem", menuItem.title);
            if (menuItem.subMenuItems && menuItem.subMenuItems.length > 0) {
                for (var j = 0; j < menuItem.subMenuItems.length; j++) {
                    var subMenuItem = menuItem.subMenuItems[j];
                    contextMenu.menu("appendItem", {
                        text: subMenuItem.title,
                        parent: parentMenu.target,
                        onclick: addDisplayItem,
                        menuItem: subMenuItem
                    });
                }
            }
        }
    }
}
// #endregion


// #region 鼠标右键上下文菜单点击处理函数

function addDisplayCategory() {
    var menu = record.itemMenus.menu("getItem", this);
    if (menu && menu.menuItem && menu.menuItem.dataCategory) {
        var paraList = [],
            category = menu.menuItem.dataCategory;
        paraList.push({
            ClassName: ANCLS.Model.RecParaItem,
            Code: category.Code,
            Description: category.Description,
            RecordSheet: record.context.recordSheetID,
            RowId: "",
            DataCategory: category.RowId,
            Seq: getDisplayItemSeq()
        });
        dhccl.saveDatas(ANCSP.DataListService, {
            ClassName: ANCLS.BLL.RecordPara,
            MethodName: "SaveRecordPara",
            jsonData: dhccl.formatObjects(paraList)
        }, function(result) {
            if (result.indexOf("S^") === 0) {
                record.context.loadParaItems();
                record.sheet.drawPage();
            }
        });
    }
}

/**
 * 在显示项区域添加显示项目
 * @author chenchangqing 20170825
 */
function addDisplayItem() {
    var menu = record.itemMenus.menu("getItem", this);
    if (menu && menu.menuItem && menu.menuItem.categoryItem) {
        var paraList = [],
            categoryItem = menu.menuItem.categoryItem,
            recordSheetID = record.context.recordSheetID;
        paraList.push({
            ClassName: ANCLS.Model.RecParaItem,
            Code: categoryItem.ItemCode,
            Description: categoryItem.ItemDesc,
            RecordSheet: recordSheetID,
            RowId: "",
            CategoryItem: categoryItem.RowId,
            DataCategory: categoryItem.DataCategory,
            Seq: getDisplayItemSeq()
        });
        dhccl.saveDatas(ANCSP.DataListService, {
            ClassName: ANCLS.BLL.RecordPara,
            MethodName: "SaveRecordPara",
            jsonData: dhccl.formatObjects(paraList)
        }, function(result) {
            if (result.indexOf("S^") === 0) {
                record.context.loadParaItems();
                record.sheet.drawPage();
            }
        });
    }
}


/**
 * 新增自定义项目
 */
function addUserDefinedItem() {
    var editor = window.UserDefinedItemView.instance;
    if (!editor) {
        editor = window.UserDefinedItemView.init({
            doQuery: retrieveUserDefinedItem,
            saveHandler: saveUserDefinedItem,
            createItemHandler: createUserDefinedItem
        });
    }
    var category = record.sheet.clickInfo.category.dataCategory;
    editor.setDataCategory(category);

    var itemCategory = record.sheet.clickInfo.category.itemCategory;
    editor.setItemCategory(itemCategory);

    retrieveUserDefinedItem({
        dataCategoryId: category.RowId
    }, function(data) {
        var editor = window.UserDefinedItemView.instance
        editor.loadData(data);
    });
    editor.open();
}

/**
 * 获取自定义项目数据
 * @param {*} param 
 */
function retrieveUserDefinedItem(param, callback) {
    var dataCategoryId = '';
    if (typeof param === 'string') {
        dataCategoryId = param;
    } else {
        dataCategoryId = param.dataCategoryId;
    }
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: 'FindUserDefDataItem',
        Arg1: dataCategoryId,
        ArgCnt: 1
    }, 'json', true, function(data) {
        if (callback) callback(data);
    });
}

/**
 * 保存自定义项目
 * @param {*} data 
 */
function saveUserDefinedItem(selectedItem) {
    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.AnaestRecord,
        MethodName: 'SaveUserDefDataItem',
        Arg1: record.context.recordSheetID,
        Arg2: selectedItem.DataCategory,
        Arg3: selectedItem.RowId,
        ArgCnt: 3
    }, function(result) {
        record.context.loadParaItems();
        refreshPage();
    });
}

/**
 * 新创建自定义项目
 * @param {*} data 
 */
function createUserDefinedItem(data, callback) {
    var savingData = $.extend(data, {
        ClassName: ANCLS.Config.UserDefDataItem,
        CreateUser: session.UserID
    });

    dhccl.saveDatas(ANCSP.DataService, savingData, function(result) {
        callback(result);
    });
}

/**
 * 从显示项区域删除显示项目
 * @author chenchangqing 20170825
 */
function delDisplayItem() {
    var anaestSheet = record.sheet;
    if (anaestSheet.clickInfo && anaestSheet.clickInfo.item) {
        var result = dhccl.removeData(ANCLS.Model.RecParaItem, anaestSheet.clickInfo.item.RowId);
        if (result.indexOf("S^") === 0) {
            record.context.loadParaItems();
            anaestSheet.drawPage();
        }
    }
}

/**
 * 获取显示项目序号
 * @returns {Number} 显示项目的序号
 * @author chenchangqing 20170825
 */
function getDisplayItemSeq() {
    var anaestSheet = record.sheet;
    var result = 1; // 默认序号为1
    if (anaestSheet.clickInfo && anaestSheet.clickInfo.category) {
        var category = anaestSheet.clickInfo.category;
        if (category.displayItems && category.displayItems.length > 0) {
            var count = category.displayItems.length,
                lastItem = category.displayItems[count - 1];
            result = Number(lastItem.Seq) + 1;
        }
    }
    return result;
}

function clickMenuItem() {

}

/**
 * 上移显示项目
 * @author chenchangqing 20170826
 */
function moveItemUp() {
    moveItem("up");
}
/**
 * 下移显示项目
 * @author chenchangqing 20170826
 */
function moveItemDown() {
    moveItem("down");
}

/**
 * （上下）移动显示项目
 * @param {string} orientation - 显示项目的移动方向
 * @author chenchangqing 20170826
 */
function moveItem(orientation) {
    if (orientation != "up" && orientation != "down") return;
    var anaestSheet = record.sheet;
    if (anaestSheet.clickInfo && anaestSheet.clickInfo.category && anaestSheet.clickInfo.item) {
        var sourceItem = anaestSheet.clickInfo.item,
            displayItems = anaestSheet.clickInfo.category.displayItems;
        if (displayItems && displayItems.length > 0) {
            var sourceItemIndex = displayItems.indexOf(sourceItem);
            // 向上移时，如果显示项是第一个，则不移动。
            if (orientation === "up" && sourceItemIndex < 1) return;
            // 向下移时，如果显示项是最后一个，则不移动
            if (orientation === "down" && sourceItemIndex >= displayItems.length - 1) return;

            // 交换源项目和目标项目序号
            var targetItemIndex = orientation === "up" ? sourceItemIndex - 1 : sourceItemIndex + 1;
            var targetItem = displayItems[targetItemIndex],
                targetItemSeq = targetItem.Seq;
            targetItem.Seq = sourceItem.Seq;
            sourceItem.Seq = targetItemSeq;

            var recordParaItems = [];
            recordParaItems.push({
                ClassName: ANCLS.Model.RecParaItem,
                RowId: sourceItem.RowId,
                Seq: sourceItem.Seq
            });
            recordParaItems.push({
                ClassName: ANCLS.Model.RecParaItem,
                RowId: targetItem.RowId,
                Seq: targetItem.Seq
            });
            dhccl.saveDatas(ANCSP.DataListService, {
                jsonData: dhccl.formatObjects(recordParaItems)
            }, function(ret) {
                if (ret.indexOf("S^") === 0) {
                    record.context.loadParaItems();
                    anaestSheet.drawPage();
                }
            });
        }
    }
}

/**
 * 禁用新增，生命体征折现图部分禁用新增
 */
function disableAddItem() {
    var clickInfo = record.sheet.clickInfo;
    if (clickInfo && clickInfo.category) {
        if (clickInfo.category.yaxises) return true;
    }

    return false;
}

/**
 * 禁用上移
 */
function disableMoveItemUp() {
    var clickInfo = record.sheet.clickInfo;
    if (clickInfo && clickInfo.category && clickInfo.item) {
        var sourceItem = clickInfo.item,
            displayItems = clickInfo.category.displayItems;
        if (displayItems.indexOf(sourceItem) <= 0) return true;
    }

    return false;
}

/**
 * 禁用下移
 */
function disableMoveItemDown() {
    var clickInfo = record.sheet.clickInfo;
    if (clickInfo && clickInfo.category && clickInfo.item) {
        var sourceItem = clickInfo.item,
            displayItems = clickInfo.category.displayItems;
        if (displayItems.indexOf(sourceItem) >= (displayItems.length - 1)) return true;
    }

    return false;
}

/**
 * 禁用删除按键
 */
function disableDeleteItem() {
    var clickInfo = record.sheet.clickInfo;
    var category = clickInfo.category;
    var sourceItem = clickInfo.item;
    if (sourceItem.displayDatas && sourceItem.displayDatas.length > 0) return true;
    if (typeof category.removable === 'boolean' && !category.removable) return true;
    return false;
}

/**
 * 设置属性
 */
function setItemAttrs() {
    var editor = window.ItemAttributeView.instance;
    if (!editor) {
        editor = window.ItemAttributeView.init({
            comboDataSource: {
                Units: record.context.units,
                ConcentrationUnits: record.context.drugConcentrationUnits,
                Instructions: record.context.drugInstructions
            },
            saveHandler: saveItemAttr
        });
    }
    editor.setParaItem(record.sheet.clickInfo.item);
    editor.open();
}

/**
 * 保存显示项目属性
 * @param {*} data 
 */
function saveItemAttr(data) {
    var savingData = $.extend(data, {
        ClassName: ANCLS.Model.ParaItemAttr
    });

    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.AnaestRecord,
        MethodName: 'SaveParaItemAttr',
        Arg1: record.context.opsId,
        Arg2: dhccl.formatObject(savingData),
        Arg3: session.UserID,
        ArgCnt: 3
    }, function(data) {
        refreshPage();
    });
}

/**
 * 复制数据
 */
function copyData() {
    if (!record.sheet) return;
    var clickInfo = record.sheet.clickInfo;
    if (!clickInfo || !clickInfo.item) return;
    if (clickInfo.area !== record.context.displayAreas.data &&
        clickInfo.area !== record.context.displayAreas.event) return;
    if (!clickInfo.displayData.selected) {
        unselectAllData();
        selectData();
        clickInfo.displayData.cutted = false;
        clickInfo.displayData.copied = true;
        clickInfo.pastingData = true;
    } else {
        var length = record.selectedDatas ? record.selectedDatas.length : 0;
        for (var i = 0; i < length; i++) {
            record.selectedDatas[i].cutted = false;
            record.selectedDatas[i].copied = true;
        }
        clickInfo.pastingData = true;
    }
}

/**
 * 粘贴数据
 */
function pasteData() {
    if (!record.sheet) return;
    var clickInfo = record.sheet.clickInfo;
    if (!clickInfo || !clickInfo.item) return;
    if (clickInfo.area !== record.context.displayAreas.data &&
        clickInfo.area !== record.context.displayAreas.event) return;

    if (record.selectedDatas && record.selectedDatas.length > 0) {
        var length = record.selectedDatas.length;
        var earliestTime = null;
        $.each(record.selectedDatas, function(index, row) {
            if (!earliestTime || earliestTime > row.StartDT) {
                earliestTime = row.StartDT;
            }
        });
        var timeSpan = new TimeSpan(clickInfo.locDT, earliestTime);
        var addMinutes = Math.round(timeSpan.totalMinutes);
        var displayData = null;
        var savingAnaDatas = [],
            savingDrugDatas = [],
            savingEventDatas = [];
        var cuttedDatas = [];
        for (var i = 0; i < length; i++) {
            displayData = record.selectedDatas[i];
            if (displayData.cutted) {
                cuttedDatas.push(displayData);
                pasteCuttedData(displayData);
            } else if (displayData.copied) {
                displayData.pasted = true;
                pasteCopiedData(displayData);
            }
        }

        if (savingAnaDatas.length > 0) saveAnaDatas(savingAnaDatas);
        if (savingDrugDatas.length > 0) saveDrugDatas(savingDrugDatas);
        if (savingEventDatas.length > 0) saveEventDatas(savingEventDatas);

        length = cuttedDatas.length;
        var index = -1;
        for (var i = 0; i < length; i++) {
            displayData = cuttedDatas[i];
            index = record.selectedDatas.indexOf(displayData);
            if (index > -1) {
                record.selectedDatas.splice(index, 1);
            }
        }

        if (!record.selectedDatas || record.selectedDatas.length <= 0)
            clickInfo.pastingData = false;
    }

    function pasteCuttedData(displayData) {
        var startDT = displayData.StartDT.addMinutes(addMinutes);
        var startDateTime = startDT.format(constant.timeStampFormat);
        var timeArr = startDateTime.split(' ');
        var startDate = timeArr[0];
        var startTime = timeArr[1];

        var endDT = startDT;
        if (displayData.Continuous === 'Y') {
            if (displayData.EndDT >= MAXDATE) {
                endDT = MAXDATE;
            } else {
                var span = new TimeSpan(displayData.EndDT, displayData.StartDT);
                endDT = startDT.addMinutes(span.totalMinutes);
            }
        }

        var endDateTime = endDT.format(constant.timeStampFormat);
        var timeArr = endDateTime.split(' ');
        var endDate = timeArr[0];
        var endTime = timeArr[1];

        var data = $.extend({
            RowId: displayData.RowId || "",
            ClassName: ANCLS.Model.AnaData,
            ParaItem: displayData.ParaItem,
            StartDate: displayData.StartDate,
            StartTime: displayData.StartTime,
            EndDate: displayData.EndDate,
            EndTime: displayData.EndTime,
            DataValue: displayData.DataValue,
            EditFlag: displayData.EditFlag,
            FromData: "",
            CreateUserID: "",
            CreateDT: "",
            StartDT: displayData.StartDT,
            EndDT: displayData.EndDT,
            CategoryItem: displayData.CategoryItem,
            DataItem: displayData.DataItem,
            DataItemDesc: displayData.DataItemDesc || "",
            ItemCategory: displayData.ItemCategory,
            Continuous: displayData.Continuous,
            FromData: "",
            CategoryItem: displayData.CategoryItem,
            DataItem: displayData.DataItem,
            DataItemDesc: displayData.DataItemDesc,
            ItemCategory: displayData.ItemCategory
        }, {
            ClassName: ANCLS.Model.AnaData,
            StartDT: startDT,
            StartDate: startDate,
            StartTime: startTime,
            StartDateTime: startDateTime,
            EndDT: endDT,
            EndDate: endDate,
            EndTime: endTime,
            EndDateTime: endDateTime
        });

        savingAnaDatas.push(data);
    }

    function pasteCopiedData(displayData) {
        var startDT = displayData.StartDT.addMinutes(addMinutes);
        var startDateTime = startDT.format(constant.timeStampFormat);
        var timeArr = startDateTime.split(' ');
        var startDate = timeArr[0];
        var startTime = timeArr[1];

        var endDT = startDT;
        if (displayData.Continuous === 'Y') {
            if (displayData.EndDT >= MAXDATE) {
                endDT = MAXDATE;
            } else {
                var span = new TimeSpan(displayData.EndDT, displayData.StartDT);
                endDT = startDT.addMinutes(span.totalMinutes);
            }
        }

        var endDateTime = endDT.format(constant.timeStampFormat);
        var timeArr = endDateTime.split(' ');
        var endDate = timeArr[0];
        var endTime = timeArr[1];

        var data = $.extend({
            RowId: displayData.RowId || "",
            ClassName: ANCLS.Model.AnaData,
            ParaItem: displayData.ParaItem,
            StartDate: displayData.StartDate,
            StartTime: displayData.StartTime,
            EndDate: displayData.EndDate,
            EndTime: displayData.EndTime,
            DataValue: displayData.DataValue,
            EditFlag: displayData.EditFlag,
            FromData: "",
            CreateUserID: "",
            CreateDT: "",
            StartDT: displayData.StartDT,
            EndDT: displayData.EndDT,
            CategoryItem: displayData.CategoryItem,
            DataItem: displayData.DataItem,
            DataItemDesc: displayData.DataItemDesc || "",
            ItemCategory: displayData.ItemCategory,
            Continuous: displayData.Continuous,
            FromData: "",
            CategoryItem: displayData.CategoryItem,
            DataItem: displayData.DataItem,
            DataItemDesc: displayData.DataItemDesc,
            ItemCategory: displayData.ItemCategory
        }, {
            ClassName: ANCLS.Model.AnaData,
            RowId: '',
            StartDT: startDT,
            StartDate: startDate,
            StartTime: startTime,
            StartDateTime: startDateTime,
            EndDT: endDT,
            EndDate: endDate,
            EndTime: endTime,
            EndDateTime: endDateTime
        });

        if (displayData.DrugDataList && displayData.DrugDataList.length > 0) {
            data.Guid = dhccl.guid();
            savingDrugDatas.push(data);
            var length = displayData.DrugDataList.length;
            for (var i = 0; i < length; i++) {
                savingDrugDatas.push($.extend({}, displayData.DrugDataList[i], {
                    ClassName: ANCLS.Model.DrugData,
                    RowId: '',
                    AnaData: '',
                    AnaDataGuid: data.Guid
                }));
            }
        } else if (displayData.EventDetailDatas && displayData.EventDetailDatas.length > 0) {
            data.Guid = dhccl.guid();
            savingEventDatas.push(data);
            var length = displayData.EventDetailDatas.length;
            for (var i = 0; i < length; i++) {
                savingEventDatas.push($.extend({}, displayData.EventDetailDatas[i], {
                    ClassName: ANCLS.Model.EventData,
                    RowId: '',
                    AnaData: '',
                    AnaDataGuid: data.Guid
                }));
            }
        } else {
            savingAnaDatas.push(data);
        }
    }

}

function addData() {
    editData();
}

function editData() {
    if (!record.sheet) return;
    var clickInfo = record.sheet.clickInfo;
    if (!clickInfo || !clickInfo.item) return;
    if (clickInfo.area !== record.context.displayAreas.data &&
        clickInfo.area !== record.context.displayAreas.event) return;

    //修改为通过全局变量获取编辑框对象，而不采用id检索打开的方式
    if (clickInfo.category) {
        var editor = null;
        if (typeof clickInfo.category.dataEditors === "object") {
            var dataEditors = clickInfo.category.dataEditors;
            if (dataEditors && dataEditors.length > 0) {
                for (var i = 0; i < dataEditors.length; i++) {
                    var dataEditor = dataEditors[i];
                    if (dataEditor.item === clickInfo.item.Code) {
                        editor = window[dataEditor.editor];
                    }
                }
            }
        } else if (clickInfo.categoryItem && clickInfo.categoryItem.eventItem) {
            editor = window[clickInfo.category.eventEditor];
        } else {
            editor = window[clickInfo.category.editor];
        }
        if (editor) {
            var instance = editor.instance;
            if (!instance) {
                //未初始化，不能使用
                return;
            }
            instance.setParaItem(clickInfo.item);
            instance.loadData(clickInfo.displayData || {
                StartDT: clickInfo.locDT
            });
            instance.open();
        }
    }
}

function delData() {
    if (!record.sheet) return;
    var clickInfo = record.sheet.clickInfo;
    if (!clickInfo || !clickInfo.item) return;
    if (clickInfo.area !== record.context.displayAreas.data &&
        clickInfo.area !== record.context.displayAreas.event) return;

    if (clickInfo && clickInfo.displayData) {
        if (!clickInfo.displayData.selected) {
            unselectAllData();
            selectData();
            clickInfo.displayData.cutted = false;
            clickInfo.displayData.copied = false;
        } else {
            var length = record.selectedDatas ? record.selectedDatas.length : 0;
            for (var i = 0; i < length; i++) {
                record.selectedDatas[i].cutted = false;
                record.selectedDatas[i].copied = false;
            }
        }
        var originalDefaults = $.extend({}, $.messager.defaults);
        $.extend($.messager.defaults, {
            ok: '删除',
            cancel: '取消'
        });
        $.messager.confirm("删除操作确认", "您确定需要删除已选中的数据吗？删除之后不能撤销此操作", function(result) {
            if (result) {
                var length = record.selectedDatas.length;
                var savingDatas = [];
                for (var i = 0; i < length; i++) {
                    record.selectedDatas[i].EditFlag = "D";
                    savingDatas.push({
                        RowId: record.selectedDatas[i].RowId,
                        EditFlag: "D",
                        ClassName: ANCLS.Model.AnaData
                    });
                }
                saveAnaDatas(savingDatas);
                clickInfo.pastingData = false;
            }
        });
        $.extend($.messager.defaults, originalDefaults);
    }
}

function moveForwardData() {
    if (!record.sheet) return;
    var clickInfo = record.sheet.clickInfo;
    if (!clickInfo || !clickInfo.item) return;
    if (clickInfo.area !== record.context.displayAreas.data &&
        clickInfo.area !== record.context.displayAreas.event) return;

    if (clickInfo && clickInfo.displayData && clickInfo.displayData.RowId) {
        var displayData = clickInfo.displayData;
        displayData.StartDT = displayData.StartDT.addMinutes(-5);
        displayData.StartDate = displayData.StartDT.format(constant.dateFormat);
        displayData.StartTime = displayData.StartDT.format(constant.timeFormat);
        if (displayData.EndDT <= MAXDATE) {
            displayData.EndDT = displayData.EndDT.addMinutes(-5);
            displayData.EndDate = displayData.StartDT.format(constant.dateFormat);
            displayData.EndTime = displayData.StartDT.format(constant.timeFormat);
        }
        saveAnaDatas({
            RowId: displayData.RowId,
            ClassName: ANCLS.Model.AnaData,
            StartDate: displayData.StartDate,
            StartTime: displayData.StartTime,
            EndDate: displayData.EndDate,
            EndTime: displayData.EndTime,
            CategoryItem: displayData.CategoryItem,
            DataItem: displayData.DataItem,
            DataItemDesc: displayData.DataItemDesc || "",
            ItemCategory: displayData.ItemCategory || "V",
        });
    }
}

function moveBackwardData() {
    if (!record.sheet) return;
    var clickInfo = record.sheet.clickInfo;
    if (!clickInfo || !clickInfo.item) return;
    if (clickInfo.area !== record.context.displayAreas.data &&
        clickInfo.area !== record.context.displayAreas.event) return;

    if (clickInfo && clickInfo.displayData && clickInfo.displayData.RowId) {
        var displayData = clickInfo.displayData;
        displayData.StartDT = displayData.StartDT.addMinutes(5);
        displayData.StartDate = displayData.StartDT.format(constant.dateFormat);
        displayData.StartTime = displayData.StartDT.format(constant.timeFormat);
        if (displayData.EndDT <= MAXDATE) {
            displayData.EndDT = displayData.EndDT.addMinutes(5);
            displayData.EndDate = displayData.StartDT.format(constant.dateFormat);
            displayData.EndTime = displayData.StartDT.format(constant.timeFormat);
        }
        saveAnaDatas({
            RowId: displayData.RowId,
            ClassName: ANCLS.Model.AnaData,
            StartDate: displayData.StartDate,
            StartTime: displayData.StartTime,
            EndDate: displayData.EndDate,
            EndTime: displayData.EndTime,
            CategoryItem: displayData.CategoryItem,
            DataItem: displayData.DataItem,
            DataItemDesc: displayData.DataItemDesc || "",
            ItemCategory: displayData.ItemCategory || "V",
        });
    }
}

/**
 * 修改速度
 */
function changeSpeed() {
    if (!record.sheet) return;
    var clickInfo = record.sheet.clickInfo;
    if (!clickInfo ||
        clickInfo.area !== record.context.displayAreas.data ||
        !clickInfo.item ||
        !clickInfo.displayData) return;

    var editor = window.SpeedChangeEditor.instance;
    if (!editor) {
        editor = window.SpeedChangeEditor.init({
            saveHandler: saveDrugDatas
        });
    }
    editor.loadData(clickInfo.displayData);
    editor.setStartDT(clickInfo.locDT);
    editor.open();
}

/**
 * 修改浓度
 */
function changeConcentration() {
    if (!record.sheet) return;
    var clickInfo = record.sheet.clickInfo;
    if (!clickInfo ||
        clickInfo.area !== record.context.displayAreas.data ||
        !clickInfo.item ||
        !clickInfo.displayData) return;

    var editor = window.ConcentrationChangeEditor.instance;
    if (!editor) {
        editor = window.ConcentrationChangeEditor.init({
            saveHandler: saveDrugDatas
        });
    }
    editor.loadData(clickInfo.displayData);
    editor.setStartDT(clickInfo.locDT);
    editor.open();
}

function editVSData() {
    editData();
}

function delVSData() {
    delData();
}

/**
 * 恢复连续用药
 */
function recoverContinuousData() {
    if (!record.sheet) return;
    var clickInfo = record.sheet.clickInfo;
    if (!clickInfo.displayData || !clickInfo.displayData.DrugData) return;
    var isContinuousData = clickInfo.displayData.Continuous === 'Y';
    if (!isContinuousData) {
        isContinuousData = (clickInfo.displayData.EndDT > clickInfo.displayData.StartDT);
    }
    if (!isContinuousData) return;
    var anaData = {
        RowId: clickInfo.displayData.RowId,
        ClassName: ANCLS.Model.AnaData,
        EndDate: MAXDATE.format(constant.dateFormat),
        EndTime: MAXDATE.format(constant.timeFormat)
    };
    saveAnaDatas(anaData);
}

/**
 * 停止连续用药
 */
function stopDrugData() {
    if (!record.sheet) return;
    var clickInfo = record.sheet.clickInfo;
    if (!clickInfo.displayData || !clickInfo.displayData.DrugData) return;
    var isContinuousData = clickInfo.displayData.Continuous === 'Y';
    if (!isContinuousData) {
        isContinuousData = (clickInfo.displayData.EndDT > clickInfo.displayData.StartDT);
    }
    if (!isContinuousData) return;
    if (clickInfo.locDT > clickInfo.displayData.StartDT) {
        $.messager.confirm("提示",
            "是否停止该用药于" + clickInfo.locDT.format(constant.timeFormat) + "？",
            function(result) {
                if (result) {
                    var anaData = {
                        RowId: clickInfo.displayData.RowId,
                        ClassName: ANCLS.Model.AnaData,
                        EndDate: clickInfo.locDT.format(constant.dateFormat),
                        EndTime: clickInfo.locDT.format(constant.timeFormat)
                    };
                    saveAnaDatas(anaData);
                }
            });
    }
}

/**
 * 停止生命体征数据
 */
function stopVSData() {
    if (!record.sheet) return;
    var clickInfo = record.sheet.clickInfo;
    if (!clickInfo.displayData) return;
    var isContinuousData = clickInfo.displayData.Continuous === 'Y';
    if (!isContinuousData) {
        isContinuousData = (clickInfo.displayData.EndDT > clickInfo.displayData.StartDT);
    }
    if (!isContinuousData) return;
    if (clickInfo.locDT > clickInfo.displayData.StartDT) {
        $.messager.confirm("提示",
            "是否停止" + clickInfo.displayData.ParaItemDesc + '于' + clickInfo.locDT.format(constant.timeFormat) + '？',
            function(result) {
                if (result) {
                    var anaData = {
                        RowId: clickInfo.displayData.RowId,
                        ClassName: ANCLS.Model.AnaData,
                        EndDate: clickInfo.locDT.format(constant.dateFormat),
                        EndTime: clickInfo.locDT.format(constant.timeFormat)
                    };
                    saveAnaDatas(anaData);
                }
            });
    }
}

/**
 * 术后带回
 */
function takeAwayDrug() {
    if (!record.sheet) return;
    var clickInfo = record.sheet.clickInfo;
    if (!clickInfo.displayData || !clickInfo.displayData.DrugData) return;
    var isContinuousData = clickInfo.displayData.Continuous === 'Y';
    if (!isContinuousData) {
        isContinuousData = (clickInfo.displayData.EndDT > clickInfo.displayData.StartDT);
    }
    if (!isContinuousData) return;
    if (clickInfo.displayData && clickInfo.displayData.DrugData) {
        var guid = dhccl.guid();
        var anaData = {
            RowId: clickInfo.displayData.RowId,
            ClassName: ANCLS.Model.AnaData,
            Guid: guid,
            EndDate: clickInfo.locDT.format(constant.dateFormat),
            EndTime: clickInfo.locDT.format(constant.timeFormat)
        };
        var drugData = {
            RowId: clickInfo.displayData.DrugData.RowId,
            ClassName: ANCLS.Model.DrugData,
            TakingAway: 'Y',
            AnaDataGuid: guid
        }
        saveDrugDatas([anaData, drugData]);
    }
}

/**
 * 取消术后带回
 */
function cancelTakeAwayDrug() {
    if (!record.sheet) return;
    var clickInfo = record.sheet.clickInfo;
    if (!clickInfo.displayData || !clickInfo.displayData.DrugData) return;
    var isContinuousData = clickInfo.displayData.Continuous === 'Y';
    if (!isContinuousData) {
        isContinuousData = (clickInfo.displayData.EndDT > clickInfo.displayData.StartDT);
    }
    if (!isContinuousData) return;
    if (clickInfo.displayData && clickInfo.displayData.DrugData) {
        var guid = dhccl.guid();
        var anaData = {
            RowId: clickInfo.displayData.RowId,
            ClassName: ANCLS.Model.AnaData,
            Guid: guid,
            EndDate: MAXDATE.format(constant.dateFormat),
            EndTime: MAXDATE.format(constant.timeFormat)
        };
        var drugData = {
            RowId: clickInfo.displayData.DrugData.RowId,
            ClassName: ANCLS.Model.DrugData,
            TakingAway: 'N',
            AnaDataGuid: guid
        }
        saveDrugDatas([anaData, drugData]);
    }
}

/**
 * 启动自动生成
 */
function autoGenerate() {
    var view = window.autoGenerateView.instance;
    if (!view) {
        view = window.autoGenerateView.init({
            saveHandler: saveItemAttr,
            generateHandler: generateVitalSignData
        })
    }

    if (!record.sheet) return;
    var clickInfo = record.sheet.clickInfo;
    if (!clickInfo.item) return;

    view.setParaItem(clickInfo.item);
    view.setDateTime(record.context.recordStartDT);
    view.setOptions({
        onClose: function() {
            $('#saveSuccess_dialog').children().text(clickInfo.item.Description + '已启动自动生成');
            $('#saveSuccess_dialog').css({ opacity: 1 });
            setTimeout(function() {
                $('#saveSuccess_dialog').animate({ opacity: 0 }, 3000, 'swing');
            }, 1000);
        }
    });
    view.open();
}

/**
 * 生成生命体征数据
 */
function generateVitalSignData(param) {
    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.AnaestRecord,
        MethodName: 'GenerateVitalSignData',
        Arg1: record.context.opsId,
        Arg2: dhccl.formatObjects(param),
        Arg3: session.UserID,
        ArgCnt: 3
    }, function(data) {
        refreshPage();
    });
}

/**
 * 停止自动生成
 */
function stopAutoGenerate() {
    var clickInfo = record.sheet.clickInfo;
    clickInfo.item.AutoGenerate = 'N';
    saveItemAttr({
        ParaItem: clickInfo.item.RowId,
        AutoGenerate: 'N'
    });
    $('#saveSuccess_dialog').children().text(clickInfo.item.Description + '已停止自动生成');
    $('#saveSuccess_dialog').css({ opacity: 1 });
    setTimeout(function() {
        $('#saveSuccess_dialog').animate({ opacity: 0 }, 3000, 'swing');
    }, 1000);
}

/**
 * 停止采集
 */
function suspendCollect() {
    var clickInfo = record.sheet.clickInfo;
    clickInfo.item.SuspendCollect = 'Y';
    saveItemAttr({
        ParaItem: clickInfo.item.RowId,
        SuspendCollect: 'Y'
    });
    $('#saveSuccess_dialog').children().text(clickInfo.item.Description + '已停止采集');
    $('#saveSuccess_dialog').css({ opacity: 1 });
    setTimeout(function() {
        $('#saveSuccess_dialog').animate({ opacity: 0 }, 3000, 'swing');
    }, 1000);
}

/**
 * 恢复采集
 */
function recoverCollect() {
    var clickInfo = record.sheet.clickInfo;
    clickInfo.item.SuspendCollect = 'N';
    saveItemAttr({
        ParaItem: clickInfo.item.RowId,
        SuspendCollect: 'N'
    });
    $('#saveSuccess_dialog').children().text(clickInfo.item.Description + '已恢复采集');
    $('#saveSuccess_dialog').css({ opacity: 1 });
    setTimeout(function() {
        $('#saveSuccess_dialog').animate({ opacity: 0 }, 3000, 'swing');
    }, 1000);
}

/**
 * 刷新当前页
 */
function reloadDOM() {
    window.location.reload();
}

/**
 * 修改事件详细信息区域数据
 */
function editEventDetail() {
    editData();
}

/**
 * 删除事件详细信息区域数据
 */
function delEventDetail() {
    delData();
}

/**
 * 切换选中状态
 */
function toggleDataSelection() {
    if (!record.sheet) return;
    var clickInfo = record.sheet.clickInfo;
    if (!clickInfo) return;

    if (clickInfo && clickInfo.displayData) {
        if (clickInfo.displayData.selected) unselectData();
        else selectData();
    }
}

/**
 * 选中数据
 */
function selectData() {
    if (!record.sheet) return;
    var clickInfo = record.sheet.clickInfo;
    if (!clickInfo) return;

    if (clickInfo && clickInfo.displayData) {
        clickInfo.displayData.selected = true;
        if (record.selectedDatas) {
            var length = record.selectedDatas.length;
            var index = -1;
            var pastedDatas = [];
            for (var i = 0; i < length; i++) {
                if (record.selectedDatas[i].pasted)
                    pastedDatas.push(record.selectedDatas[i]);
            }

            length = pastedDatas.length;
            for (var i = 0; i < length; i++) {
                index = record.selectedDatas.indexOf(pastedDatas[i]);
                if (index > -1) record.selectedDatas.splice(index, 1);
            }

            if (record.selectedDatas.indexOf(clickInfo.displayData) < 0) {
                record.selectedDatas.push(clickInfo.displayData)
            }
            length = record.selectedDatas.length;
            for (var i = 0; i < length; i++) {
                record.selectedDatas[i].cutted = false;
            }
        } else {
            record.selectedDatas = [clickInfo.displayData];
        }
        record.sheet.drawPage();
    }
}

/**
 * 取消选中数据
 */
function unselectData() {
    if (!record.sheet) return;
    var clickInfo = record.sheet.clickInfo;
    if (!clickInfo) return;

    if (clickInfo && clickInfo.displayData) {
        clickInfo.displayData.selected = false;
        if (record.selectedDatas) {
            var index = record.selectedDatas.indexOf(clickInfo.displayData);
            if (index > -1) {
                record.selectedDatas.splice(index, 1);
            }
        }
        record.sheet.drawPage();
    }
}

/**
 * 取消选中所有数据
 */
function unselectAllData() {
    if (record.sheet && record.sheet.clickInfo) {
        record.sheet.clickInfo.pastingData = false;
    }

    if (record.selectedDatas) {
        var length = record.selectedDatas.length;
        for (var i = 0; i < length; i++) {
            record.selectedDatas[i].selected = false;
        }
        record.selectedDatas = [];
    }
}

/**
 * 剪切数据
 */
function cutData() {
    if (!record.sheet) return;
    var clickInfo = record.sheet.clickInfo;
    if (!clickInfo) return;

    if (clickInfo && clickInfo.displayData) {
        if (!clickInfo.displayData.selected) {
            unselectAllData();
            selectData();
            clickInfo.displayData.cutted = true;
            clickInfo.displayData.copied = false;
            clickInfo.pastingData = true;
        } else {
            var length = record.selectedDatas ? record.selectedDatas.length : 0;
            for (var i = 0; i < length; i++) {
                record.selectedDatas[i].cutted = true;
                record.selectedDatas[i].copied = false;
            }
            clickInfo.pastingData = true;
        }
        record.sheet.drawPage();
    }
}

function openPCATemplate() {
    var eventOptions = [];
    var category = null,
        categoryItem = null,
        dataItemID = "",
        dataItemDesc = "",
        dataItemCode = "";
    if (record.context.eventDetailItems && record.context.eventDetailItems.length > 0) {
        for (var i = 0; i < record.context.eventDetailItems.length; i++) {
            var detailItem = record.context.eventDetailItems[i];
            if (detailItem.DataItemCode === "PCA") {
                eventOptions.push(detailItem);
                category = detailItem.CategoryItem.DataCategory;
                categoryItem = detailItem.CategoryItem.RowId;
                dataItemID = detailItem.DataItem;
                dataItemDesc = detailItem.DataItemDesc;
                dataItemCode = detailItem.DataItemCode;
            }
        }
    }
    if (eventOptions.length <= 0) {
        $.messager.alert("提示", "未找到术后镇痛事件的明细项，请联系系统管理员。", "warning");
        return;
    }
    var template = new PCATemplate({
        DeptID: session.DeptID,
        UserID: session.UserID,
        EventOptions: eventOptions,
        ModuleID: session.ModuleID,
        Category: category,
        CategoryItem: categoryItem,
        DataItemID: dataItemID,
        DataItemDesc: dataItemDesc,
        DataItemCode: dataItemCode
    });
    template.open();
}

function regEventDrugs() {
    var view = window.AnaRegView.instance;
    if (!view) {
        var eventDrugItems = record.context.getEventDrugCategoryItems();
        view = window.AnaRegView.init({
            categoryItems: eventDrugItems,
            paraItems: record.context.paraItems,
            RecordSheetID: session.RecordSheetID,
            uomList: record.context.drugDoseUnits,
            instructionList: record.context.drugInstructions,
            theatreInDT: record.context.schedule.TheatreInDT,
            onClose: function() {
                record.context.loadParaItems();
                refreshPage();
                loadTemplate();
            }
        });
    } else {
        view.reload();
    }
    view.setDateTime(record.context.recordStartDT.format("yyyy-MM-dd HH:mm"));
    view.open();
}

window.addEventListener('keydown', function(e) {
    var event = e || window.event;
    if (event && event.keyCode == 17) {
        record.isCtrlDown = true;
    }
});

window.addEventListener('keyup', function(e) {
    var event = e || window.event;
    if (event && event.keyCode == 17) {
        record.isCtrlDown = false;
    }
});