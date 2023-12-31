/**
 * @author yongyang
 * @description 手术排班视图 手术间拖动排班操作
 */

var page = {
    Data: {}
}

var setting = {
    enableAnaestNurse: true
}

$(document).ready(function() {
    //初始化界面元素
    initUnarrangedOperList();
    initNursList();
    initOperRoomList();
    initArrangedOperRoom();
    initNurseSchedule();
    initLoadMask();

    //设置界面元素初始值和事件处理
    setDefaultValue();
    setEventHandler();

    //加载数据
    loadOperRoom();
    loadNurse();
    loadOperSchedule();
    loadNurseSchedule();
    loadDeclineOperList();
});

/**
 * 初始化未排手术列表
 */
function initUnarrangedOperList() {
    page.FilterOperDate = $('#filterOperDate');
    page.UnarrangedOperList = window.OperScheduleList.init($('#unarranged_oper_list'), {
        groupBy: {
            default: {
                key: '',
                textField: '',
                text: 'All',
                exceptedText: '',
                sortable: false,
            },
            dictionary: [{
                key: 'PatDeptID',
                textField: 'PatDeptDesc',
                text: '科室',
                exceptedText: '',
                sortable: true,
                active: true
            }, {
                key: 'PatWardID',
                textField: 'PatWardDesc',
                text: '病区',
                exceptedText: '',
                sortable: true
            }]
        },
        sortBy: {
            default: {
                field: 'PlanSurgeonDesc',
                text: '手术医生',
                direction: 'ASC',
                compareMethod: '',
                ability: {
                    asc: true,
                    desc: true
                }
            },
            dictionary: [{
                field: 'PlanSurgeonDesc',
                text: '手术医生',
                direction: 'ASC',
                compareMethod: 'string',
                active: true,
                ability: {
                    asc: true,
                    desc: true
                }
            }, {
                field: 'PatAge',
                text: '年龄',
                direction: 'ASC',
                compareMethod: 'number',
                ability: {
                    asc: true,
                    desc: true
                }
            }]
        },
        filterForm: {
            items: [{
                id: 'filter_medcareno',
                valueField: 'MedcareNo',
                textField: 'MedcareNo',
                extraFields: ['PatName'],
                value: '',
                text: '',
                label: '',
                desc: '住院号',
                type: 'searchbox',
                prompt: '请输入住院号或姓名'
            }],
            tags: [{
                title: '患者科室',
                valueField: 'PatDeptID',
                textField: 'PatDeptDesc',
                autoConstruct: true,
                data: []
            }, {
                title: '手术类型',
                data: [{
                    text: '择期',
                    value: 'B',
                    field: 'SourceType',
                    exact: true
                }, {
                    text: '急诊',
                    value: 'E',
                    field: 'SourceType',
                    exact: true
                }, {
                    text: '日间',
                    value: 'Y',
                    field: 'DaySurgery',
                    exact: true
                }]
            }, {
                title: '手术位置',
                valueField: 'OperDeptID',
                textField: 'OperDeptDesc',
                autoConstruct: true,
                data: []
            }, {
                title: '特殊标识',
                data: [{
                    text: 'X-ray',
                    value: 'Y',
                    field: 'MechanicalArm',
                    exact: true
                }, {
                    text: 'IMC病区',
                    value: 'IMC',
                    field: 'PatWardDesc',
                    exact: false
                }, {
                    text: '隔离',
                    value: 'Y',
                    field: 'IsoOperation',
                    exact: true
                }, {
                    text: '感染',
                    value: 'Y',
                    field: 'InfectionOper',
                    exact: false,
                    isNotNull: true
                }, {
                    text: '多重耐药',
                    value: '+',
                    field: 'MDROS',
                    exact: true
                }, {
                    text: '冰冻',
                    value: 'Y',
                    field: 'Profrozen',
                    exact: true
                }]
            }]
        },
        operCard: {
            onDblClick: function(operSchedule) {
                var operRoom = page.ArrangedOperRoom.data('data');
                updateOperRoom(operSchedule, operRoom);
                refreshRoomView();
            }
        },
        multipleSelection: true,
        onDrop: function(operSchedule) {
            revokeOperSchedule(operSchedule);
        }
    });
}

/**
 * 初始化全部护士列表
 */
function initNursList() {
    page.NurseList = window.NurseList.init($('#nurse_list'), {
        onDblClick: function(nurse) {
            $.each(page.ArrangedOperList.find('.oper-arranged'), function(index, card) {
                var operSchedule = $(card).data('data');
                var existsInScrub = (operSchedule.ArrScrubNurseDesc.indexOf(nurse.Description) > -1);
                var existsInCir = (operSchedule.ArrCircualNurseDesc.indexOf(nurse.Description) > -1);
                var existsInAnaest = (operSchedule.ArrAnaNurseDesc.indexOf(nurse.Description) > -1);

                if (!existsInScrub && !existsInCir) {
                    if (!operSchedule.ArrScrubNurseDesc ||
                        (operSchedule.ArrScrubNurseDesc && operSchedule.ArrCircualNurseDesc)) {
                        addScrubNurse(operSchedule, nurse, true);
                    } else {
                        addCirNurse(operSchedule, nurse, true);
                    }
                }
            });

            integrateOperSchedules(page.Data.operSchedules);
            refreshRoomView();
            page.NurseList.refreshView();
        }
    });
}

/**
 * 初始化手术间列表
 */
function initOperRoomList() {
    page.OperRoomList = $('#oper_room_list');
}

/**
 * 初始化已安排的手术间
 */
function initArrangedOperRoom() {
    page.ArrangedOperRoom = $('#arranged_oper_room');
    page.ArrangedOperList = $('#arranged_oper_list');
    estimatedOperTimeView.init({
        onClose: function() {
            this.target.text(this.operSchedule.EstimatedOperTime);
        },
        saveHandler: function(time) {
            var operSchedule = this.operSchedule;
            operSchedule.EstimatedOperTime = time;
            saveEstimatedTime([{ RowId: operSchedule.RowId, EstimatedOperTime: operSchedule.EstimatedOperTime }]);
            serializeEstimatedTime(operSchedule);
        }
    });
}

/**
 * 加载科室排班汇总
 */
function initNurseSchedule() {
    page.NurseScheduleToday = window.NurseSchedule.init($('#nurse_schedule_today'), {
        editable: true,
        height: 430,
        callback: showNurseScheduleOfAttendance,
        getCurrentDate: function() {
            return page.FilterOperDate.datebox('getValue');
        }
    });
}

/**
 * 加载mask
 */
function initLoadMask() {
    page.loadmask = $('<div class="window-mask" style="width: 100%; height: 100%; z-index: 9000; text-align: center; display: none;"></div>')
        .append('<i class="fa fa-refresh" style="position:absolute;top:0px;left:100px;display:flex;align-items:center;height:100%;text-align:center;color:#fff;font-size:50px;"></i>')
        .appendTo('body');
}

/**
 * 关闭科室排班弹出页面
 */
function closeAttendance() {
    page.NurseScheduleToday.closeDialog();
}

/**
 * 加载护士排班汇总
 */
function loadNurseSchedule() {
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: "FindCrewShift",
        Arg1: session.DeptID,
        Arg2: "Y",
        ArgCnt: 2
    }, "json", true, function(data) {
        page.Data.CrewShifts = data;
        var length = data.length;
        var nurseScheduleList = [];
        var row;
        for (var i = 0; i < length; i++) {
            row = data[i];
            nurseScheduleList.push({
                Type: 'Attendance',
                RowId: row.RowId,
                Description: row.StatusDesc,
                GroupBy: row.FloorDesc
            });
        }

        page.NurseScheduleToday.loadSchedule(nurseScheduleList, true);
        page.NurseScheduleToday.refresh();
    });

    var data = page.Data.operRooms || [];
    var length = data.length;
    var nurseScheduleList = [];
    var row;
    for (var i = 0; i < length; i++) {
        row = data[i];
        nurseScheduleList.push({
            Type: 'OperRoom',
            RowId: row.RowId,
            Description: row.Description,
            GroupBy: '术间排班汇总'
        });
    }

    page.NurseScheduleToday.loadSchedule(nurseScheduleList);
}

/**
 * 汇总显示科室排班数据
 */
function showNurseScheduleOfAttendance() {
    var nurseScheduleList = [],
        attendances,
        nurseScheduleDic = {};
    var operDate = page.FilterOperDate.datebox("getValue");
    //var data = dhccl.runServerMethod(ANCLS.BLL.Attendance, "GetAttendanceInfo", operDate, session.DeptID);
    dhccl.getDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.Attendance,
        MethodName: "GetAttendanceInfo",
        Arg1: operDate,
        Arg2: session.DeptID,
        ArgCnt: 2
    }, "json", true, function(data) {
        if (data && data.length > 0) {
            attendances = data[0];
            for (var rowId in attendances) {
                nurseScheduleList.push({
                    Type: 'Attendance',
                    RowId: rowId,
                    Value: attendances[rowId]
                });
                nurseScheduleDic[rowId] = attendances[rowId];
            }
        }

        var CrewShifts = page.Data.CrewShifts;
        var length = CrewShifts.length;
        var crewshift;
        for (var i = 0; i < length; i++) {
            crewshift = CrewShifts[i];
            if (!nurseScheduleDic[crewshift.RowId]) {
                nurseScheduleList.push({
                    Type: 'Attendance',
                    RowId: crewshift.RowId,
                    Value: ''
                });
            }
        }

        page.NurseScheduleToday.loadData(nurseScheduleList);
    });
}

/**
 * 汇总显示手术间人员排班信息
 */
function showNurseScheduleOfRooms() {
    var data = page.Data.operRooms;
    var length = data.length;
    var nurseScheduleList = [];
    var row;
    for (var i = 0; i < length; i++) {
        row = data[i];
        nurseScheduleList.push({
            Type: 'OperRoom',
            RowId: row.RowId,
            Value: (row.nurses || []).join(',')
        });
    }

    page.NurseScheduleToday.loadData(nurseScheduleList);
}

/**
 * 设置界面元素默认值
 */
function setDefaultValue() {
    var nextDay = new Date().addDays(1);
    page.FilterOperDate.datebox('setValue', nextDay.format('yyyy-MM-dd'));
}

/**
 * 设置界面事件处理函数
 */
function setEventHandler() {
    $('#btnExtract').click(function() {
        page.loadmask.show();
        clearCaculateInfo();
        loadOperSchedule();
        showNurseScheduleOfAttendance();
    });

    $('#btnCancelOperList').click(function() {
        var view = getDeclineView();
        view.openListDialog();
    });

    $('#btnSubmit').click(function() {
        submitOperList();
    });

    $("#btnPrint").linkbutton({
        onClick: function() {
            var printDatas = page.Data.operSchedules;
            if (printDatas && printDatas.length > 0) {
                // printList(printDatas, "arrange");
                var LODOP = getLodop();
                printListNew(printDatas, "arrange", LODOP);
                LODOP.PREVIEW();
            } else {
                $.messager.alert("提示", "列表无数据可打印", "warning");
            }
        }
    });

    page.ArrangedOperRoom.droppable({
        disbaled: true,
        accept: '.careprovider-item',
        onDragEnter: function(e, source) {
            if (page.CurrentSelectedRoom) $(this).addClass('droppable-dragenter');
        },
        onDragLeave: function(e, source) {
            $(this).removeClass('droppable-dragenter');
        },
        onDrop: function(e, source) {
            $(this).removeClass('droppable-dragenter');
            var nurse = $(source).data('data');

            $.each(page.ArrangedOperList.find('.oper-arranged'), function(index, card) {
                var operSchedule = $(card).data('data');
                var existsInScrub = (operSchedule.ArrScrubNurseDesc.indexOf(nurse.Description) > -1);
                var existsInCir = (operSchedule.ArrCircualNurseDesc.indexOf(nurse.Description) > -1);
                var existsInAnaest = (operSchedule.ArrAnaNurseDesc.indexOf(nurse.Description) > -1);

                if (!existsInScrub && !existsInCir && !existsInAnaest) {
                    if (!operSchedule.ArrScrubNurseDesc ||
                        (operSchedule.ArrScrubNurseDesc && operSchedule.ArrCircualNurseDesc)) {
                        addScrubNurse(operSchedule, nurse, true);
                    } else if (!operSchedule.ArrCircualNurseDesc) {
                        addCirNurse(operSchedule, nurse, true);
                    } else {
                        addAnaestNurse(operSchedule, nurse, true);
                    }
                }
            });

            integrateOperSchedules(page.Data.operSchedules);
            refreshRoomView();
            page.NurseList.refreshView();
        }
    });

    page.ArrangedOperList.delegate('a.arranged-nurse-switch', 'click', function() {
        var operSchedule = $(this).parent().parent().parent().parent().data('data');
        switchNurse(operSchedule);
    });

    page.ArrangedOperList.delegate('.careprovider-item-arranged a.tagbox-remove', 'click', function() {
        var nurse = $(this).parent().data('data');
        var nurseContainer = $(this).parent().parent();
        var operSchedule = $(nurseContainer).parent().parent().parent().parent().data('data');
        if (nurseContainer.hasClass('scrubnurse-container')) {
            removeScrubNurse(operSchedule, nurse);
        } else if (nurseContainer.hasClass('cirnurse-container')) {
            removeCirNurse(operSchedule, nurse);
        } else if (nurseContainer.hasClass('anaestnurse-container')) {
            removeAnaestNurse(operSchedule, nurse);
        }
    });

    page.ArrangedOperList.delegate('a.oper-arranged-move', 'mouseenter', function() {
        var operarranged = $(this).parent();
        operarranged.draggable('enable');
    });

    page.ArrangedOperList.delegate('a.oper-arranged-revoke', 'click', function() {
        var operarranged = $(this).parent();
        operarranged.tooltip('hide');
        operarranged.tooltip('destroy');
        var operSchedule = operarranged.data('data');
        revokeOperSchedule(operSchedule);
        refreshRoomView();
    });

    page.ArrangedOperList.delegate('.oper-arranged-estimatedtime', 'click', function() {
        if (estimatedOperTimeView.visible) {
            estimatedOperTimeView.save();
        }
        var operSchedule = $(this).parent().parent().data('data');
        if (estimatedOperTimeView.operSchedule != operSchedule) {
            estimatedOperTimeView.bind($(this), operSchedule);
            estimatedOperTimeView.open();
        } else {
            estimatedOperTimeView.close();
        }
    });

    $('.nurse-summary').delegate('.tab-item', 'click', function() {
        if (!$(this).hasClass('tab-item-selected')) {
            var target = $('.tab-item-selected').attr('data-target');
            $(target).hide();

            $('.tab-item-selected').removeClass('tab-item-selected');
            $(this).addClass('tab-item-selected');

            var target = $(this).attr('data-target');
            $(target).show();
        }
    });

    $('.cancel-oper').droppable({
        disbale: true,
        accept: '.oper-card,.oper-arranged',
        onDragEnter: function(e, source) {
            $(this).addClass('droppable-dragenter');
        },
        onDragLeave: function(e, source) {
            $(this).removeClass('droppable-dragenter');
        },
        onDrop: function(e, source) {
            $(this).removeClass('droppable-dragenter');
            var operSchedule = $(source).data('data');
            var opercard = $(source).data('opercard');
            var operScheduleList = [];

            if (opercard && opercard.visible && opercard.selected) {
                var selectedCards = opercard.parent.getAllSelectedCards();
                var card;
                for (var i = 0, length = selectedCards.length; i < length; i++) {
                    card = selectedCards[i];
                    operScheduleList.push(card.bindedData);
                }
            } else {
                operScheduleList.push(operSchedule);
            }

            if (operScheduleList.length > 0) {
                var view = getDeclineView();
                view.proceedDecline(operScheduleList);
                view.openReasonDialog();
            }

            setTimeout(function() {
                $(source).css({ top: 0, left: 0 });
            }, 400);
        }
    });
}

/**
 * 初始化/获取拒绝手术视图
 */
function getDeclineView() {
    var view = window.DeclineView.instance;
    if (!view) {
        view = window.DeclineView.init({
            onLoad: loadDeclineViewData,
            onAfterDecline: onAfterDecline,
            onDeclineHandler: declineOperList,
            onRevokeHandler: revokeDeclineOpers
        });
    }

    return view;
}

/**
 * 加载拒绝手术列表视图数据
 */
function loadDeclineViewData() {
    loadDeclineOperList(function(data) {
        var view = getDeclineView();
        view.loadData(data);
    });
}

/**
 * 加载拒绝手术列表
 */
function loadDeclineOperList(fn) {
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.OperScheduleList,
        QueryName: "FindOperScheduleList",
        Arg1: page.FilterOperDate.datebox("getValue"),
        Arg2: page.FilterOperDate.datebox("getValue"),
        Arg3: session.DeptID,
        Arg4: "",
        Arg5: "",
        Arg6: "",
        Arg7: 'Decline',
        Arg8: "",
        Arg9: "",
        Arg10: "",
        Arg11: "N",
        Arg12: "N",
        Arg13: '',
        Arg14: 'Decline',
        ArgCnt: 14
    }, "json", true, function(data) {
        refreshDeclineBadge(data.length);
        if (fn) fn.call(window, data);
    });
}

/**
 * 刷新拒绝手术例数标签
 */
function refreshDeclineBadge(num) {
    $('#btnCancelOperList').find('.declinedlist-badge').text(num);
}

/**
 * 拒绝手术例数标签+1
 */
function addDeclineNumber() {
    var number = $('#btnCancelOperList').find('.declinedlist-badge').text();
    if (number) number = Number(number);
    else number = 0;
    number++;
    refreshDeclineBadge(number);
}

/**
 * 拒绝手术
 */
function declineOperList(decliningOperList) {
    var operSchedule;
    var opsId, cancelReason, result;
    for (var i = 0, length = decliningOperList.length; i < length; i++) {
        operSchedule = decliningOperList[i];
        opsId = operSchedule.RowId;
        cancelReason = operSchedule.CancelReason;
        result = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "CancelOperForReason", opsId, cancelReason, session.UserID);
        if (result.success) {
            operSchedule.declined = true;
            addDeclineNumber();
        } else {
            dhccl.showMessage("E^数据保存失败：" + result.result, "拒绝手术", null, null);
            return false;
        }
    }
    return true;
}

/**
 * 拒绝手术之后
 */
function onAfterDecline(decliningOperList) {
    var operSchedule;
    var opsId, cancelReason, result;
    for (var i = 0, length = decliningOperList.length; i < length; i++) {
        operSchedule = decliningOperList[i];
        if (operSchedule.ArrOperRoom &&
            (operSchedule.StatusCode == 'Arrange' ||
                operSchedule.StatusCode == 'Receive')) {
            $.extend(operSchedule, {
                ArrOperRoom: '',
                ArrRoomDesc: '',
                ArrScrubNurse: '',
                ArrScrubNurseDesc: '',
                ArrCircualNurse: '',
                ArrCircualNurseDesc: '',
                StatusCode: 'Decline'
            });

            var operRoom = $('.oper-room-selected').data('data');
            if (operRoom) {
                var index = operRoom.operSchedules.indexOf(operSchedule);
                operRoom.operSchedules.splice(index, 1);
                operSchedule.target.remove();
                updateOperSeqs();
                integrateArrangeInfo(operRoom);
                updateSelectedRoom(operRoom);
                refreshRoomView();
                page.NurseList.refreshView();
            }
        } else {
            page.UnarrangedOperList.removeData(operSchedule);
        }
    }
    var view = getDeclineView();
    view.closeReasonDialog();
    view.openListDialog();
}
/**
 * 撤销拒绝手术
 */
function revokeDeclineOpers(selectedRows) {
    var opsIdList = [];
    for (var i = 0; i < selectedRows.length; i++) {
        var selectedRow = selectedRows[i];
        opsIdList.push(selectedRow.RowId);
    }
	if(opsIdList.length==0)
	{
		//dhccl.showMessage("请至少选择一行数据","撤销拒绝手术");
		$.messager.alert("警告","请至少选择一行数据！！！")
		return;
	}
    var view = getDeclineView();
    var result = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "CancelDecline", opsIdList.join(','), session.UserID);
    if (result.success) {
        dhccl.showMessage("S^", "撤销拒绝手术", null, null, function() {
            view.reload();
            loadOperSchedule();
        });
    } else {
        dhccl.showMessage("E^数据保存失败：" + result.result, "撤销拒绝手术", null, null);
    }
}

/**
 * 提交手术（手术排班信息发布）
 */
function submitOperList() {
    $.messager.confirm("提示", "是否要发布所有手术？", function(r) {
        if (r) {
            var operDate = page.FilterOperDate.datebox("getValue");
            var result = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "SubmitOperList", operDate, session.UserID);
            if (result.success) {
                loadOperSchedule();
                $.messager.alert("提示", "发布手术成功！", "info");
            } else {
                $.messager.alert("提示", "发布手术失败，原因：" + result.result, "error");
            }
        }
    });
}

/**
 * 手术返回未排状态
 */
function revokeOperSchedule(operSchedule) {
    var result = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "RevokeArrange", operSchedule.RowId, session.UserID);
    if (result.success) {
        $.extend(operSchedule, {
            ArrOperRoom: '',
            ArrRoomDesc: '',
            ArrScrubNurse: '',
            ArrScrubNurseDesc: '',
            ArrCircualNurse: '',
            ArrCircualNurseDesc: '',
            ArrAnaNurse: '',
            ArrAnaNurseDesc: '',
            StatusCode: 'Application'
        });
        operSchedule.target.remove();
        page.UnarrangedOperList.addData(operSchedule);

        var operRoom = $('.oper-room-selected').data('data');
        if (operRoom) {
            var index = operRoom.operSchedules.indexOf(operSchedule);
            operRoom.operSchedules.splice(index, 1);
            updateOperSeqs();
            integrateArrangeInfo(operRoom);
            integrateNurseArrangement(page.Data.operSchedules);
            updateSelectedRoom(operRoom);
            refreshRoomView();
            page.NurseList.refreshView();
        }
    } else {
        $.messager.alert("提示", "撤回手术失败，原因：" + result.result, "error");
    }
}

function printListNew(printDatas, configCode, LODOP) {
    var arrangeConfig = getArrangeConfig();
    if (!arrangeConfig) {
        $.messager.alert("提示", "排班配置不存在，请联系系统管理员！", "warning");
        return;
    }
    var printConfig = getPrintConfig(arrangeConfig, configCode);
    if (!printConfig) {
        $.messager.alert("提示", "打印配置不存在，请联系系统管理员！", "warning");
        return;
    }
    // 标题信息(手术日期、手术室)
    var titleInfo = {
        OperationDate: page.FilterOperDate.datebox("getValue"),
        OperDeptDesc: session.DeptDesc
    };
    // var LODOP = getLodop();
    var printSetting = operListConfig.print;
    var hospital = getHospital(); //YuanLin 20191210 医院名称自动获取
    //LODOP.PRINT_INIT(printtitle);
    // LODOP.SET_PRINT_PAGESIZE(printSetting.direction, printSetting.paperSize.width, printSetting.paperSize.height, "");
    LODOP.SET_PRINT_PAGESIZE("2", "", "", "SSS");
    LODOP.ADD_PRINT_TEXT(15, 250, 500, 40, hospital[0].HOSP_Desc);
    LODOP.SET_PRINT_STYLEA(0, "FontName", "宋体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 16);
    LODOP.SET_PRINT_STYLEA(0, "Bold",1);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "HOrient", 2);
    LODOP.ADD_PRINT_TEXT(40, 250, 500, 40, "手术排班表");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "宋体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 16);
    LODOP.SET_PRINT_STYLEA(0, "Bold",1);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "HOrient", 2);
    LODOP.ADD_PRINT_TEXT(80, 20, "100%", 28, "科室：" + titleInfo.OperDeptDesc);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(80, 400, "100%", 28, "日期：" + titleInfo.OperationDate);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(80, 700, "100%", 28, "总计：" + printDatas.length + "台手术");
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_HTM(80, 900, "100%", 28, "<span tdata='pageNO'>第##页</span> <span tdata='pageCount'>共##页</span>"); // 设置页码，pageNO和pageCount是Lodop提供的全局变量。
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW", true);
    LODOP.SET_PRINT_MODE("FULL_HEIGHT_FOR_OVERFLOW", false);
    LODOP.SET_SHOW_MODE("LANDSCAPE_DEFROTATED", 1);
    var totalWidth = operListConfig.print.paperSize.rect.width;
    var html = "<style>table,td,th {border: 1px solid black;border-style:solid;border-collapse: collapse;font-size:16px;} table{table-layout:fixed;}</style><table style='" + totalWidth + "pt'><thead><tr>";
    //var totalWidth=0;
    for (var i = 0; i < printConfig.columns.length; i++) {
        var column = printConfig.columns[i];
        //totalWidth+=column.width;
        html += "<th style='width:" + column.width + "pt'>" + column.title + "</th>"; // 使用pt绝对单位，不会造成分辨率变化导致元素显示变动
    }
    html += "</tr></thead><tbody>";
    var curRoom = "",
        preRoom = "";
    for (var i = 0; i < printDatas.length; i++) {
        var printData = printDatas[i];
        curRoom = printData.RoomDesc;
        html += "<tr>";
        for (var j = 0; j < printConfig.columns.length; j++) {
            var column = printConfig.columns[j];
            var printValue = printData[column.field];
            printValue = printValue ? printValue : "";
            if (column.field === "RoomDesc" && curRoom === preRoom) {
                printValue = "";
            }
            html += "<td style='" + (column.style ? column.style : "") + "'>" + printValue + "</td>";
        }
        html += "</tr>";
        preRoom = printData.RoomDesc;
    }
    html += "</tbody></table>";


    LODOP.ADD_PRINT_TABLE(100, 10, totalWidth + "pt", "100%", html); // 高度设置成100%，表示占用剩余整页的高度。

}

function getArrangeConfig() {
    var result = null;
    $.ajaxSettings.async = false;
    $.getJSON("../service/dhcanop/data/operarrange.json?random=" + Math.random(), function(data) {
        result = data;
    }).error(function(message) {
        alert(message);
    });
    $.ajaxSettings.async = true;
    return result;
}

function getPrintConfig(arrangeConfig, configCode) {
    var result = null;
    if (arrangeConfig && arrangeConfig.print && arrangeConfig.print.length > 0) {
        for (var i = 0; i < arrangeConfig.print.length; i++) {
            var element = arrangeConfig.print[i];
            if (element.code == configCode) {
                result = element;
            }
        }
    }
    return result;
}

function getHospital() {
    var result = null;
    $.ajaxSettings.async = false;
    var result = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.CodeQueries,
        QueryName: "FindHospitalDesc",
        ArgCnt: 0
    }, "json");
    $.ajaxSettings.async = true;
    return result;
}

/**
 * 清空界面计算的相关数据
 */
function clearCaculateInfo() {
    var data = page.Data.operRooms;
    var length = data.length;
    var row;
    for (var i = 0; i < length; i++) {
        row = data[i];
        row.operSchedules = [];
        row.surgeons = [];
        row.nurses = [];
        row.scrubNurses = [];
        row.circualNurses = [];
        row.anaestNurses = [];
    }
}

/**
 * 加载手术间
 */
function loadOperRoom() {
    operRooms = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: "FindOperRoom",
        Arg1: session.DeptID,
        Arg2: "R",
        ArgCnt: 2
    }, "json");

    page.Data.operRooms = operRooms;

    var length = operRooms.length;
    var element;
    var container = page.OperRoomList;
    for (var i = 0; i < length; i++) {
        element = $('<div class="oper-room"></div>').appendTo(container);
        roomView.render(element, operRooms[i]);
    }

    $('.oper-room').droppable({
        accept: '.oper-card,.oper-arranged',
        onDragEnter: function(e, source) {
            if ($(source).hasClass('oper-card') || $(source).hasClass('oper-arranged')) $(this).addClass('droppable-dragenter');
        },
        onDragLeave: function(e, source) {
            $(this).removeClass('droppable-dragenter');
        },
        onDrop: function(e, source) {
            $(this).removeClass('droppable-dragenter');
            var operSchedule = $(source).data('data');
            var opercard = $(source).data('opercard');
            var thisRoom = $(this).data('data');
            var selectedRoom = $('.oper-room-selected').data('data');
            var selectedCards =null;
			if(opercard)
				selectedCards = opercard.parent.getAllSelectedCards();
            var warningDetected = false;
            var warningMessages = [];

            /**
             * 错误检测
             */
            // 已安排手术转移至不同的手术室
            if (selectedRoom && thisRoom &&
                selectedRoom.OperDeptDesc != thisRoom.OperDeptDesc &&
                operSchedule.ArrOperRoom) {
                warningMessages.push('该手术原手术间 ' + selectedRoom.Description +
                    ' 位于 <b style="color:red;">' + selectedRoom.OperDeptDesc +
                    '</b>');
                warningDetected = true;
            }

            // 未排手术转移至与申请时不同的手术室
            if (opercard && opercard.visible && opercard.selected) {
                var card, bindedData;
                for (var i = 0, length = selectedCards.length; i < length; i++) {
                    card = selectedCards[i];
                    bindedData = card.bindedData;
                    if (bindedData.OperDeptDesc != thisRoom.OperDeptDesc) {
                        warningMessages.push('<span style="display:inline-block;border-bottom:1px solid #f0f0f0;margin-bottom:3px;">手术（' + bindedData.PatDeptDesc +
                            ' <b>' + bindedData.PatName +
                            ' </b> ' + bindedData.PatGender + ' ' + bindedData.PatAge +
                            '）申请的手术位置位于<b style="color:red;">' + bindedData.OperDeptDesc +
                            '</b></span>');
                        warningDetected = true;
                    }
                }
            } else {
                var bindedData;
				if(opercard)
					bindedData = opercard.bindedData;
				else bindedData=operSchedule;
                if (bindedData.OperDeptDesc != thisRoom.OperDeptDesc) {
                    warningMessages.push('<span style="display:inline-block;border-bottom:1px solid #f0f0f0;margin-bottom:3px;">手术（' + bindedData.PatDeptDesc +
                        ' <b>' + bindedData.PatName +
                        ' </b> ' + bindedData.PatGender + ' ' + bindedData.PatAge +
                        '）申请的手术位置位于 <b style="color:red;">' + bindedData.OperDeptDesc +
                        '</b></span>');
                    warningDetected = true;
                }
            }

            if (warningDetected) {
                warningMessages.push('<br/>即将安排至手术间 <b>' + thisRoom.Description +
                    '</b> 位于 <b style="color:red;">' + thisRoom.OperDeptDesc +
                    '</b>,您确定要继续吗？');

                $.messager.confirm('请确认操作', warningMessages.join('<br/>'), function(confirmed) {
                    if (confirmed) excuteUpdating();
                    else page.UnarrangedOperList.render(true);
                });
                return false;
            } else {
                excuteUpdating();
            }


            function excuteUpdating() {
                /**
                 * 已选中手术间的手术拖动至其他手术间
                 */
                if (selectedRoom && thisRoom != selectedRoom && $(source).hasClass('oper-arranged')) {
                    var index = selectedRoom.operSchedules.indexOf(operSchedule);
                    var length = selectedRoom.operSchedules.length;
                    var seq = 0;
                    for (var i = index + 1; i < length; i++) {
                        seq = selectedRoom.operSchedules[i].ArrOperSeq;
                        if (/\d+/.test(seq)) seq = Number(seq) - 1;
                        else seq = 1;
                        selectedRoom.operSchedules[i].ArrOperSeq = seq;
                    }
                    selectedRoom.operSchedules.splice(index, 1);
                    integrateArrangeInfo(selectedRoom);
                    updateSelectedRoom(selectedRoom);
                    updateOperSeqs();
                }

                /**
                 * 保存数据
                 */
                if (opercard && opercard.visible && opercard.selected) {
                    var card;
                    for (var i = 0, length = selectedCards.length; i < length; i++) {
                        card = selectedCards[i];
                        updateOperRoom(card.bindedData, thisRoom, true);
                    }
                } else {
                    if (thisRoom.RowId !== operSchedule.ArrOperRoom) updateOperRoom(operSchedule, thisRoom, true);
                }

                integrateArrangeInfo(thisRoom);
                refreshRoomView();
                if (selectedRoom && thisRoom == selectedRoom) updateSelectedRoom(selectedRoom);
            }
        }
    });

    $('.oper-room-scrubnurse').droppable({
        disbaled: true,
        accept: '.careprovider-item',
        onDragEnter: function(e, source) {
            if ($(source).hasClass('careprovider-item')) $(this).addClass('droppable-dragenter');
        },
        onDragLeave: function(e, source) {
            $(this).removeClass('droppable-dragenter');
        },
        onDrop: function(e, source) {
            $(this).removeClass('droppable-dragenter');
            var nurse = $(source).data('data');
            var room = $(this).parent().parent().data('data');

            $.each(room.operSchedules || [], function(index, operSchedule) {
                var existsInScrub = (operSchedule.ArrScrubNurseDesc.indexOf(nurse.Description) > -1);
                if (!existsInScrub) {
                    addScrubNurse(operSchedule, nurse, true);
                }
            });

            integrateOperSchedules(page.Data.operSchedules);
            refreshRoomView();
            page.NurseList.refreshView();
        }
    });

    $('.oper-room-circualnurse').droppable({
        disbaled: true,
        accept: '.careprovider-item',
        onDragEnter: function(e, source) {
            $(this).addClass('droppable-dragenter');
        },
        onDragLeave: function(e, source) {
            $(this).removeClass('droppable-dragenter');
        },
        onDrop: function(e, source) {
            $(this).removeClass('droppable-dragenter');
            var nurse = $(source).data('data');
            var room = $(this).parent().parent().data('data');

            $.each(room.operSchedules || [], function(index, operSchedule) {
                var existsInCir = (operSchedule.ArrCircualNurseDesc.indexOf(nurse.Description) > -1);
                if (!existsInCir) {
                    addCirNurse(operSchedule, nurse, true);
                }
            });

            integrateOperSchedules(page.Data.operSchedules);
            refreshRoomView();
            page.NurseList.refreshView();
        }
    });

    if (setting.enableAnaestNurse) {
        $('.oper-room-anaestnurse').droppable({
            disbaled: true,
            accept: '.careprovider-item',
            onDragEnter: function(e, source) {
                $(this).addClass('droppable-dragenter');
            },
            onDragLeave: function(e, source) {
                $(this).removeClass('droppable-dragenter');
            },
            onDrop: function(e, source) {
                $(this).removeClass('droppable-dragenter');
                var nurse = $(source).data('data');
                var room = $(this).parent().parent().data('data');

                $.each(room.operSchedules || [], function(index, operSchedule) {
                    var existsInAnaest = (operSchedule.ArrAnaNurseDesc.indexOf(nurse.Description) > -1);
                    if (!existsInAnaest) {
                        addAnaestNurse(operSchedule, nurse, true);
                    }
                });

                integrateOperSchedules(page.Data.operSchedules);
                refreshRoomView();
                page.NurseList.refreshView();
            }
        });
    }

    $('.oper-room').click(function() {
        $('.oper-room-selected').removeClass('oper-room-selected');
        $(this).addClass('oper-room-selected');
        var operRoom = $(this).data('data');
        updateSelectedRoom(operRoom);
    });
}
/**
 * 刷新手术间显示
 */
function refreshRoomView() {
    var operRooms = page.Data.operRooms;

    var length = operRooms.length;
    var element;
    for (var i = 0; i < length; i++) {
        element = operRooms[i].target;
        roomView.refresh(element, operRooms[i]);
    }

    // $('.oper-room-scrubnurse').droppable('disbale');
    // $('.oper-room-circualnurse').droppable('disbale');
    // $('.oper-room-arranged .oper-room-scrubnurse').droppable('enable');
    // $('.oper-room-arranged .oper-room-circualnurse').droppable('enable');

    showNurseScheduleOfRooms();
}

/**
 * 更改手术间
 */
function updateOperRoom(operSchedule, operRoom, delayRender) {
    var date = page.FilterOperDate.datebox('getValue');
    var opsId = operSchedule.RowId;
    var roomId = operRoom.RowId;

    result = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "UpdateOperRoom", opsId, roomId, session.UserID);

    if (result.success) {
        operSchedule.ArrOperRoom = operRoom.RowId;
        operSchedule.ArrRoomDesc = operRoom.Description;
        operRoom.operSchedules.sort(numericCompare("ArrOperSeq"));
        if (!operRoom.operSchedules) operRoom.operSchedules = [];
        var length = operRoom.operSchedules.length;
        var lastSeq = 0;
        if (length > 0) {
            lastSeq = operRoom.operSchedules[length - 1].ArrOperSeq;
            if (/\d+/.test(lastSeq)) lastSeq = Number(lastSeq);
            else lastSeq = 0;
        }
        operSchedule.ArrOperSeq = lastSeq + 1;
        operSchedule.EstimatedOperTime = getNextEstimatedTime(operRoom);
        saveEstimatedTime([{ RowId: operSchedule.RowId, EstimatedOperTime: operSchedule.EstimatedOperTime }]);

        operRoom.operSchedules.push(operSchedule);
        page.UnarrangedOperList.removeData(operSchedule);

        if (!delayRender) {
            integrateArrangeInfo(operRoom);
            roomView.refresh(operRoom.target, operRoom);

            $('.oper-room-selected').removeClass('oper-room-selected');
            $(operRoom.target).addClass('oper-room-selected');
            updateSelectedRoom(operRoom);
        }
    }

    hideAllTooltip();
}

function updateOperSeqs() {
    var operSchedules = [];
    var cards = page.ArrangedOperList.find('.oper-arranged');
    var modifies = [];
    var seq = 0;
    $.each(cards, function(index, card) {
        var operSchedule = $(card).data('data');
        if (operSchedule) {
            seq++;
            if (Number(operSchedule.ArrOperSeq) != seq) {
                modifies.push({ RowId: operSchedule.RowId, ArrOperSeq: seq });
            }
            operSchedule.ArrOperSeq = seq;
            arrangedOperView.renderSeq($(card));
            operSchedules.push(operSchedule);
        }
    });

    page.CurrentSelectedRoom.operSchedules = operSchedules;
    if (modifies.length > 0) { result = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "UpdateOperSeqList", dhccl.formatObjects(modifies), session.UserID); }

    adjustEstimatedTime();
}

/**
 * 选中手术间
 */
function updateSelectedRoom(operRoom) {
    page.ArrangedOperRoom.data('data', operRoom);
    page.ArrangedOperRoom.text(operRoom.Description);
    page.ArrangedOperList.empty();
    page.CurrentSelectedRoom = operRoom;

    var operSchedules = operRoom.operSchedules || [];
    var length = operSchedules.length;
    var element;
    for (var i = 0; i < length; i++) {
        element = $('<div class="oper-arranged"></div>').appendTo(page.ArrangedOperList);
        arrangedOperView.render(element, operSchedules[i]);
    }

    page.ArrangedOperRoom.droppable('enable');
}

/**
 * 添加一个器械护士
 */
function addScrubNurse(operSchedule, nurse, delayRender) {
    var opsId = operSchedule.RowId;
    var nurseId = nurse.RowId;

    result = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "AddScrubNurse", opsId, nurseId, session.UserID);

    if (result.success) {
        var idArray = operSchedule.ArrScrubNurse ? operSchedule.ArrScrubNurse.split(',') : [];
        var descArray = operSchedule.ArrScrubNurse ? operSchedule.ArrScrubNurseDesc.split(',') : [];
        idArray.push(nurse.RowId);
        descArray.push(nurse.Description);
        operSchedule.ArrScrubNurse = idArray.join(',');
        operSchedule.ArrScrubNurseDesc = descArray.join(',');
        if (operSchedule.target && operSchedule.target.parent().length > 0) arrangedOperView.renderNurses(operSchedule.target);

        if (!delayRender) {
            integrateOperSchedules(page.Data.operSchedules);
            refreshRoomView();
            page.NurseList.refreshView();
        }
    }
}

/**
 * 移除一个器械护士
 */
function removeScrubNurse(operSchedule, nurse) {
    var opsId = operSchedule.RowId;
    var nurseId = nurse.RowId;

    result = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "RemoveScrubNurse", opsId, nurseId, session.UserID);

    if (result.success) {
        var idArray = operSchedule.ArrScrubNurse.split(',');
        var descArray = operSchedule.ArrScrubNurseDesc.split(',');
        var index = idArray.indexOf(nurse.RowId);
        if (index > -1) idArray.splice(index, 1);
        var index = descArray.indexOf(nurse.Description);
        if (index > -1) descArray.splice(index, 1);
        operSchedule.ArrScrubNurse = idArray.join(',');
        operSchedule.ArrScrubNurseDesc = descArray.join(',');
        integrateOperSchedules(page.Data.operSchedules);
        if (operSchedule.target && operSchedule.target.parent().length > 0) arrangedOperView.renderNurses(operSchedule.target);
        refreshRoomView();
        page.NurseList.refreshView();
    }
}

/**
 * 添加一个巡回护士
 */
function addCirNurse(operSchedule, nurse, delayRender) {
    var opsId = operSchedule.RowId;
    var nurseId = nurse.RowId;

    result = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "AddCirNurse", opsId, nurseId, session.UserID);

    if (result.success) {
        var idArray = operSchedule.ArrCircualNurse ? operSchedule.ArrCircualNurse.split(',') : [];
        var descArray = operSchedule.ArrCircualNurse ? operSchedule.ArrCircualNurseDesc.split(',') : [];
        idArray.push(nurse.RowId);
        descArray.push(nurse.Description);
        operSchedule.ArrCircualNurse = idArray.join(',');
        operSchedule.ArrCircualNurseDesc = descArray.join(',');
        if (operSchedule.target && operSchedule.target.parent().length > 0) arrangedOperView.renderNurses(operSchedule.target);

        if (!delayRender) {
            integrateOperSchedules(page.Data.operSchedules);
            refreshRoomView();
            page.NurseList.refreshView();
        }
    }
}

/**
 * 添加一个巡回护士
 */
function removeCirNurse(operSchedule, nurse) {
    var opsId = operSchedule.RowId;
    var nurseId = nurse.RowId;

    result = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "RemoveCirNurse", opsId, nurseId, session.UserID);

    if (result.success) {
        var idArray = operSchedule.ArrCircualNurse.split(',');
        var descArray = operSchedule.ArrCircualNurseDesc.split(',');
        var index = idArray.indexOf(nurse.RowId);
        if (index > -1) idArray.splice(index, 1);
        var index = descArray.indexOf(nurse.Description);
        if (index > -1) descArray.splice(index, 1);
        operSchedule.ArrCircualNurse = idArray.join(',');
        operSchedule.ArrCircualNurseDesc = descArray.join(',');
        integrateOperSchedules(page.Data.operSchedules);
        if (operSchedule.target && operSchedule.target.parent().length > 0) arrangedOperView.renderNurses(operSchedule.target);
        refreshRoomView();
        page.NurseList.refreshView();
    }
}


/**
 * 添加一个麻醉护士
 */
function addAnaestNurse(operSchedule, nurse, delayRender) {
    var opsId = operSchedule.RowId;
    var nurseId = nurse.RowId;

    result = dhccl.runServerMethod(ANCLS.BLL.AnaArrange, "AddAnaNurse", opsId, nurseId, session.UserID);

    if (result.success) {
        var idArray = operSchedule.ArrAnaNurse ? operSchedule.ArrAnaNurse.split(',') : [];
        var descArray = operSchedule.ArrAnaNurse ? operSchedule.ArrAnaNurseDesc.split(',') : [];
        idArray.push(nurse.RowId);
        descArray.push(nurse.Description);
        operSchedule.ArrAnaNurse = idArray.join(',');
        operSchedule.ArrAnaNurseDesc = descArray.join(',');
        if (operSchedule.target && operSchedule.target.parent().length > 0) arrangedOperView.renderNurses(operSchedule.target);

        if (!delayRender) {
            integrateOperSchedules(page.Data.operSchedules);
            refreshRoomView();
            page.NurseList.refreshView();
        }
    }
}

/**
 * 移除一个麻醉护士
 */
function removeAnaestNurse(operSchedule, nurse) {
    var opsId = operSchedule.RowId;
    var nurseId = nurse.RowId;

    result = dhccl.runServerMethod(ANCLS.BLL.AnaArrange, "RemoveAnaNurse", opsId, nurseId, session.UserID);

    if (result.success) {
        var idArray = operSchedule.ArrAnaNurse.split(',');
        var descArray = operSchedule.ArrAnaNurseDesc.split(',');
        var index = idArray.indexOf(nurse.RowId);
        if (index > -1) idArray.splice(index, 1);
        var index = descArray.indexOf(nurse.Description);
        if (index > -1) descArray.splice(index, 1);
        operSchedule.ArrAnaNurse = idArray.join(',');
        operSchedule.ArrAnaNurseDesc = descArray.join(',');
        integrateOperSchedules(page.Data.operSchedules);
        if (operSchedule.target && operSchedule.target.parent().length > 0) arrangedOperView.renderNurses(operSchedule.target);
        refreshRoomView();
        page.NurseList.refreshView();
    }
}

/**
 * 交换已安排的器械和巡回护士
 */
function switchNurse(operSchedule) {
    var opsId = operSchedule.RowId;

    result = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "SwitchNurse", opsId, session.UserID);

    if (result.success) {
        var circualNurse = operSchedule.ArrCircualNurse;
        var circualNurseDesc = operSchedule.ArrCircualNurseDesc;
        operSchedule.ArrCircualNurse = operSchedule.ArrScrubNurse;
        operSchedule.ArrCircualNurseDesc = operSchedule.ArrScrubNurseDesc;
        operSchedule.ArrScrubNurse = circualNurse;
        operSchedule.ArrScrubNurseDesc = circualNurseDesc;
        arrangedOperView.renderNurses(operSchedule.target);
		integrateOperSchedules(page.Data.operSchedules);
		refreshRoomView();
		page.NurseList.refreshView();
    }
}

/**
 * 获取某手术间下次手术的预计开始时间
 */
function getNextEstimatedTime(room) {
    var operSchedules = [];
    if (room) operSchedules = room.operSchedules || [];
    var length = operSchedules.length;
    var result, operSchedule;
    if (length > 0) {
        operSchedule = operSchedules[length - 1];
        result = calculateEstimatedTime(operSchedule.EstimatedOperTime, operSchedule.OperDuration);
    } else {
        result = '08:30';
    }

    return result;
}

/**
 * 调整预计手术时间
 * 顺序排列完成后调用
 */
function adjustEstimatedTime() {
    var savingDatas = [];
    var operSchedules = page.CurrentSelectedRoom.operSchedules;
    var operSchedule, estimatedTime, lastTime, firstTime;
    for (var i = 0, length = operSchedules.length; i < length; i++) {
        operSchedule = operSchedules[i];
        if (firstTime && operSchedule.EstimatedOperTime) firstTime = firstTime.localeCompare(operSchedule.EstimatedOperTime) < 0 ? firstTime : operSchedule.EstimatedOperTime;
        if (!firstTime && operSchedule.EstimatedOperTime) firstTime = operSchedule.EstimatedOperTime;
    }
    lastTime = firstTime;
    for (var i = 0, length = operSchedules.length; i < length; i++) {
        operSchedule = operSchedules[i];
        if (lastTime && operSchedule.EstimatedOperTime != lastTime) {
            operSchedule.EstimatedOperTime = lastTime;
            savingDatas.push({
                RowId: operSchedule.RowId,
                EstimatedOperTime: operSchedule.EstimatedOperTime
            });
            arrangedOperView.refreshEstimatedTime(operSchedule.target);
        }
        lastTime = calculateEstimatedTime(operSchedule.EstimatedOperTime, operSchedule.OperDuration);
    }

    saveEstimatedTime(savingDatas);
}

/**
 * 按序列调整预计手术时间，修改前一台次的预计手术时间后调用
 */
function serializeEstimatedTime(currentOperSchedule) {
    var savingDatas = [];
    var operSchedules = page.CurrentSelectedRoom.operSchedules;
    var index = operSchedules.indexOf(currentOperSchedule);
    var length = operSchedules.length;
    var operSchedule, estimatedTime, lastTime;
    if (index > -1 && index < length - 1) {
        for (var i = index; i < length; i++) {
            operSchedule = operSchedules[i];
            if (lastTime && operSchedule.EstimatedOperTime != lastTime) {
                operSchedule.EstimatedOperTime = lastTime;
                savingDatas.push({
                    RowId: operSchedule.RowId,
                    EstimatedOperTime: operSchedule.EstimatedOperTime
                });
                arrangedOperView.refreshEstimatedTime(operSchedule.target);
            }
            lastTime = calculateEstimatedTime(operSchedule.EstimatedOperTime, operSchedule.OperDuration);
        }
    }

    saveEstimatedTime(savingDatas);
}

/**
 * 计算预计手术时间
 */
function calculateEstimatedTime(time, duration) {
    duration = Number(duration);
    duration = duration ? duration : 2;
    var originalHour = Number(time.split(':')[0]);
    var originalMinute = Number(time.split(':')[1]);
    var hour = originalHour;
    var minute = originalMinute;
    var estimatedTime = (minute / 60) + hour + duration;
    hour = Math.floor(estimatedTime);
    if (hour > 23) {
        hour = hour - 24;
    }
    minute = Math.floor((estimatedTime - Math.floor(estimatedTime)) * 60);
    var timeStr = (hour > 9 ? hour : '0' + hour) + ':' + (minute > 9 ? minute : '0' + minute);
    return timeStr;
}

/**
 * 保存预计手术时间
 */
function saveEstimatedTime(data) {
    if (data.length > 0) {
        result = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "UpdateEstimatedTimeList", dhccl.formatObjects(data), session.UserID);
        if (result.success) {
            // do noting?
        } else {
            $.messager.alert('错误', '预计手术时间保存错误！', 'error');
        }
    }
}

var roomView = {
    render: function(container, room) {
        container.empty();
        container.data('data', room);
        room.target = container;

        if ((room.operSchedules || []).length > 0) {
            container.addClass('oper-room-arranged');
        } else {
            container.removeClass('oper-room-arranged');
        }

        var header = $('<div class="oper-room-header"></div>').appendTo(container);
        header.text(room.Description);

        var content = $('<div class="oper-room-content"></div>').appendTo(container);

        var totalOperDuration = 0,
            hasEMOper = false;
        $.each(room.operSchedules || [], function(i, el) {
            totalOperDuration += Number(el.OperDuration);
            if (el.SourceType == 'E') hasEMOper = true;
        });
        var row = $('<div style="text-align:center;"></div>').html('<span class="oper-room-badge">' + (room.operSchedules || []).length + '</span>台 <span class="oper-room-duration">' + totalOperDuration + '</span>小时').appendTo(content);

        if (totalOperDuration > 8) {
            container.addClass('oper-room-overloaded');
        } else {
            container.removeClass('oper-room-overloaded');
        }

        if (hasEMOper) container.addClass('oper-room-emergency');
        else container.removeClass('oper-room-emergency');

        var row = $('<div style="padding:0 3px;"></div>').appendTo(content);
        $('<span class="oper-room-c-surgeon-label">主刀医生：</span>').appendTo(row);
        $('<span class="oper-room-c-surgeon"></span>').text((room.surgeons || []).join(',')).attr('title', (room.surgeons || []).join(',')).appendTo(row);

        // var row = $('<div style="padding:0 3px;"></div>').appendTo(content);
        // $('<span class="oper-room-c-nurse-label">手术护士：</span>').appendTo(row);
        // $('<span class="oper-room-c-nurse"></span>').text((room.nurses || []).join(',')).appendTo(row);

        var row = $('<div class="oper-room-c-r oper-room-scrubnurse" style="padding:0 3px;"></div>').appendTo(content);
        $('<span class="oper-room-c-nurse-label">器械护士：</span>').appendTo(row);
        $('<span class="oper-room-c-nurse"></span>').text((room.scrubNurses || []).join(',')).attr('title', (room.scrubNurses || []).join(',')).appendTo(row);

        var row = $('<div class="oper-room-c-r oper-room-circualnurse" style="padding:0 3px;"></div>').appendTo(content);
        $('<span class="oper-room-c-nurse-label">巡回护士：</span>').appendTo(row);
        $('<span class="oper-room-c-nurse"></span>').text((room.circualNurses || []).join(',')).attr('title', (room.circualNurses || []).join(',')).appendTo(row);

        if (setting.enableAnaestNurse) {
            container.addClass('oper-room-additionalrow');
            var row = $('<div class="oper-room-c-r oper-room-anaestnurse" style="padding:0 3px;"></div>').appendTo(content);
            $('<span class="oper-room-c-nurse-label">麻醉护士：</span>').appendTo(row);
            $('<span class="oper-room-c-nurse"></span>').text((room.anaestNurses || []).join(',')).attr('title', (room.anaestNurses || []).join(',')).appendTo(row);
        }
        var title = ['<b>' + room.Description + '</b>',
            (room.operSchedules || []).length + '台',
            '主刀医生：' + (room.surgeons || []).join(','),
            '器械护士：' + (room.scrubNurses || []).join(','),
            '巡回护士：' + (room.circualNurses || []).join(','),
            '麻醉护士：' + (room.anaestNurses || []).join(',')
        ].join('<br/>');
        //container.attr('title', title);
        container.tooltip({ position: 'top', content: title });
    },
    refresh: function(container, room) {
        container.data('data', room);
        room.target = container;

        if ((room.operSchedules || []).length > 0) {
            container.addClass('oper-room-arranged');
        } else {
            container.removeClass('oper-room-arranged');
        }

        container.find('.oper-room-badge').text((room.operSchedules || []).length);

        var totalOperDuration = 0,
            hasEMOper = false;
        $.each(room.operSchedules || [], function(i, el) {
            totalOperDuration += Number(el.OperDuration);
            if (el.SourceType == 'E') hasEMOper = true;
        });
        container.find('.oper-room-duration').text(totalOperDuration);

        if (totalOperDuration > 8) {
            container.addClass('oper-room-overloaded');
        } else {
            container.removeClass('oper-room-overloaded');
        }

        if (hasEMOper) container.addClass('oper-room-emergency');
        else container.removeClass('oper-room-emergency');

        container.find('.oper-room-c-surgeon').text((room.surgeons || []).join(',')).attr('title', (room.surgeons || []).join(','));
        //container.find('.oper-room-c-nurse').text((room.nurses || []).join(','));
        container.find('.oper-room-scrubnurse span.oper-room-c-nurse').text((room.scrubNurses || []).join(',')).attr('title', (room.scrubNurses || []).join(','));
        container.find('.oper-room-circualnurse span.oper-room-c-nurse').text((room.circualNurses || []).join(',')).attr('title', (room.circualNurses || []).join(','));
        container.find('.oper-room-anaestnurse span.oper-room-c-nurse').text((room.anaestNurses || []).join(',')).attr('title', (room.anaestNurses || []).join(','));

        var title = ['<b style="line-height:25px">' + room.Description + '</b>'+'&nbsp&nbsp&nbsp&nbsp<span style="float:right;font-weight:bold;font-size:larger;margin-top:0px">' +" "+(room.operSchedules || []).length + '台'+ '</span>',
            '主刀医生：' + (room.surgeons || []).join(','),
            '器械护士：' + (room.scrubNurses || []).join(','),
            '巡回护士：' + (room.circualNurses || []).join(','),
            '麻醉护士：' + (room.anaestNurses || []).join(',')
        ].join('<br/>');
        //container.attr('title', title);
        container.tooltip('update', title);
    }
}

/**
 * 加载护士
 */
function loadNurse() {
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: CLCLS.BLL.Admission,
        QueryName: 'FindCareProvByLoc',
        Arg1: '',
        Arg2: session.DeptID,
        Arg3: '',
        ArgCnt: 3
    }, 'json', true, function(data) {
        page.Data.careProviders = data;
        page.NurseList.loadData(data);
        if (page.Data.operSchedules) {
            integrateNurseArrangement(page.Data.operSchedules);
            page.NurseList.refreshView();
        }
    });
}

/**
 * 加载手术
 */
function loadOperSchedule() {
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.OperScheduleList,
        QueryName: 'FindOperScheduleList',
        Arg1: page.FilterOperDate.datebox("getValue"),
        Arg2: page.FilterOperDate.datebox("getValue"),
        Arg3: session.DeptID,
        Arg4: '',
        Arg5: '',
        Arg6: '',
        Arg7: "Application^Audit^Receive^Arrange",
        Arg8: '',
        Arg9: '',
        Arg10: '',
        Arg11: 'N',
        Arg12: '',
        Arg13: '',
        Arg14: 'Application^Audit^Receive^Arrange',
        ArgCnt: 14
    }, "json", true, function(data) {
        if (data) {
            page.Data.operSchedules = data;
            integrateData(data);
            refreshRoomView();

            if (page.Data.careProviders) {
                integrateNurseArrangement(data);
                page.NurseList.refreshView();
            }
        }
        if ($('.oper-room-selected').length > 0) {
            var operRoom = $('.oper-room-selected').data('data');
            updateSelectedRoom(operRoom);
        }

        setTimeout(function() {
            page.loadmask.hide();
        }, 500);
    });
}

function integrateData(data) {
    var unarrangedOperSchedules = [],
        arrangedOperSchedules = [];

    var length = data.length;
    var operSchedule;
    for (var i = 0; i < length; i++) {
        operSchedule = data[i];
        if (operSchedule.ArrOperRoom &&
            (operSchedule.StatusCode == 'Arrange' ||
                operSchedule.StatusCode == 'Receive')) {
            arrangedOperSchedules.push(operSchedule);
        } else {
            unarrangedOperSchedules.push(operSchedule);
        }
    }

    page.UnarrangedOperList.loadData(unarrangedOperSchedules);
    integrateArrangedOperRoom(arrangedOperSchedules);
}

function integrateOperSchedules(data) {
    integrateArrangedOperRoom(data);
    integrateNurseArrangement(data);
}

function integrateArrangedOperRoom(data) {
    var operRooms = page.Data.operRooms;
    var length = operRooms.length;
    var roomDic = {};
    for (var i = 0; i < length; i++) {
        operRooms[i].operSchedules = [];
        roomDic[operRooms[i].RowId] = operRooms[i];
    }

    var length = data.length;
    var row, room, nurse, nurses;
    for (var i = 0; i < length; i++) {
        row = data[i];
        room = roomDic[row.ArrOperRoom];
        if (room && (row.StatusCode == 'Arrange' ||
                row.StatusCode == 'Receive' || row.StatusCode == "Application" || row.StatusCode == "Audit")) {
            if (!room.operSchedules) room.operSchedules = [];
            room.operSchedules.push(row);
        }
    }

    var length = operRooms.length;
    for (var i = 0; i < length; i++) {
        operRooms[i].operSchedules.sort(numericCompare("ArrOperSeq"));
        integrateArrangeInfo(operRooms[i]);
    }
}

function integrateNurseArrangement(data) {
    var careProviders = page.Data.careProviders;
    var length = careProviders.length;
    var nurseDic = {};
    for (var i = 0; i < length; i++) {
        careProviders[i].operSchedules = [];
        nurseDic[careProviders[i].RowId] = careProviders[i];
    }

    var length = data.length;
    var row, nurse, nurses;
    for (var i = 0; i < length; i++) {
        row = data[i];

        nurses = [].concat(row.ArrScrubNurse.split(','));
        nurses = nurses.concat(row.ArrCircualNurse.split(','));
        nurses = nurses.concat(row.ArrAnaNurse.split(','));
        $.each(nurses, function(index, e) {
            nurse = nurseDic[e];
            if (nurse) {
                if (nurse.operSchedules.indexOf(row) < 0) nurse.operSchedules.push(row);
            }
        });
    }
}

function integrateArrangeInfo(room) {
    var data = room.operSchedules || [];
    var length = data.length;
    room.surgeons = [];
    room.nurses = [];
    room.scrubNurses = [];
    room.circualNurses = [];
    room.anaestNurses = [];
    var row, room, surgeon, nurses;
    var anesthetist;
    for (var i = 0; i < length; i++) {
        row = data[i];
        surgeon = row.SurgeonDesc;
        if (!room.surgeons) room.surgeons = [];
        if (room.surgeons.indexOf(surgeon) < 0) room.surgeons.push(surgeon);

        if (!room.nurses) room.nurses = [];
        if (!room.scrubNurses) room.scrubNurses = [];
        if (!room.circualNurses) room.circualNurses = [];
        if (!room.anaestNurses) room.anaestNurses = [];

        nurses = [];
        if (row.ArrScrubNurseDesc != '') {
            nurses = row.ArrScrubNurseDesc.split(',');
            for (var j = 0; j < nurses.length; j++) {
                if (room.scrubNurses.indexOf(nurses[j]) < 0) room.scrubNurses.push(nurses[j]);
                if (room.nurses.indexOf(nurses[j]) < 0) room.nurses.push(nurses[j]);
            }
        }

        if (row.ArrCircualNurseDesc != '') {
            nurses = row.ArrCircualNurseDesc.split(',');
            for (var j = 0; j < nurses.length; j++) {
                if (room.circualNurses.indexOf(nurses[j]) < 0) room.circualNurses.push(nurses[j]);
                if (room.nurses.indexOf(nurses[j]) < 0) room.nurses.push(nurses[j]);
            }
        }

        if (row.ArrAnaNurseDesc != '') {
            nurses = row.ArrAnaNurseDesc.split(',');
            for (var j = 0; j < nurses.length; j++) {
                if (room.anaestNurses.indexOf(nurses[j]) < 0) room.anaestNurses.push(nurses[j]);
                if (room.nurses.indexOf(nurses[j]) < 0) room.nurses.push(nurses[j]);
            }
        }

        // 手术间麻醉医生 by ccq 20200914
        anesthetist = row.AnesthesiologistDesc
        if (!room.anesthetists) room.anesthetists = [];
        if (room.anesthetists.indexOf(anesthetist) < 0) room.anesthetists.push(anesthetist);
    }
}

function numericCompare(propertyName) {
    return function(object1, object2) {
        var value1 = object1[propertyName];
        var value2 = object2[propertyName];

        if (value1 == '' || value1 == 'All') {
            return -1;
        } else if (value2 == '' || value2 == 'All') {
            return 1;
        } else if (Number(value1) > Number(value2)) {
            return 1;
        } else {
            return -1;
        }
    };
}

var arrangedOperView = {
    render: function(container, operSchedule) {
        container.empty();
        container.data('data', operSchedule);
        operSchedule.target = container;

        this.renderTooltip(container, operSchedule);

        var content = $('<div class="oper-arranged-content"></div>').appendTo(container);

        if (operSchedule.SourceType === 'E') {
            content.append('<div class="oper-arranged-info-type" style="background-color:#D9001B;">急诊</div>');
        } else if (operSchedule.SourceType === 'B') {
            content.append('<div class="oper-arranged-info-type" style="background-color:#015478;">择期</div>');
        } else if (operSchedule.DaySurgery === 'Y') {
            content.append('<div class="oper-arranged-info-type" style="background-color:#BFBF00;">日间</div>');
        }

        $('<span class="oper-arranged-seq" style="font-weight:bold;border-right:1px solid #eee;padding-right:5px;line-height:20px;"></span>').text(operSchedule.ArrOperSeq).appendTo(content);
        //$('<span style="padding-right:5px;width:60px;"></span>').text(operSchedule.PatDeptDesc).appendTo(content);
        $('<span style="padding-right:5px;width:50px;"></span>').text(operSchedule.SurgeonDesc).appendTo(content);
        $('<span class="oper-arranged-estimatedtime" style="width:60px;" title="预计手术时间"></span>').text(operSchedule.EstimatedOperTime || '08:30').appendTo(content);
        $('<span style="font-weight:bold;border-left:1px solid #eee;padding-left:5px;"></span>').text(operSchedule.PatName).appendTo(content);
        $('<span></span>').text(operSchedule.PatGender).appendTo(content);
        $('<span></span>').text(operSchedule.PatAge).appendTo(content);
        $('<span class="seperator"></span>').appendTo(content);
        $('<span></span>').text(operSchedule.PrevDiagnosisDesc).appendTo(content);
        $('<span></span>').text(operSchedule.PlanOperDesc).appendTo(content);

        var nurseArea = $('<div class="arranged-nurse-area"></div>').appendTo(content);
        var nursesContainer = $('<div class="arranged-nurse-container" title="拖动护士到此处" style="margin-right:16px;"><div style="display:inline-block;vertical-align:middle;"><span>器械:</span></div><div class="scrubnurse-container nurse-container"></div></div>').appendTo(nurseArea);
        $('<a href="javascript:;" class="arranged-nurse-switch" title="交换此手术的器械和巡回护士"><i class="fa fa-arrows-h"></i></a>').appendTo(nursesContainer);
        $('<div class="arranged-nurse-container" title="拖动护士到此处"><div style="display:inline-block;vertical-align:middle;"><span>巡回:</span></div><div class="cirnurse-container nurse-container"></div></div>').appendTo(nurseArea);
        if (setting.enableAnaestNurse) $('<div class="arranged-nurse-container" title="拖动护士到此处"><div style="display:inline-block;vertical-align:middle;"><span>麻醉护士:</span></div><div class="anaestnurse-container nurse-container"></div></div>').appendTo(nurseArea);

        var move = $('<a href="javascript:;" class="oper-arranged-move dragging-starter"><span class="icon icon-blue-move"></span></a>').appendTo(container);
        var revoke = $('<a href="javascript:;" class="oper-arranged-revoke" title="返回未排列表"><i class="fa fa-reply"></i></a>').appendTo(container);

        this.renderNurses(container);
        container.find('.arranged-nurse-container').droppable({
            accept: '.careprovider-item',
            onDragEnter: function(e, source) {
                $(this).addClass('arranged-nurse-container-enter');
            },
            onDragLeave: function(e, source) {
                $(this).removeClass('arranged-nurse-container-enter');
            },
            onDrop: function(e, source) {
                var operSchedule = $(this).parent().parent().parent().data('data');
                var nurse = $(source).data('data');
                $(this).removeClass('arranged-nurse-container-enter');

                var existsInScrub = (operSchedule.ArrScrubNurseDesc.indexOf(nurse.Description) > -1);
                var existsInCir = (operSchedule.ArrCircualNurseDesc.indexOf(nurse.Description) > -1);
                if (existsInScrub || existsInCir) return false;

                if ($(this).find('.scrubnurse-container').length > 0) {
                    addScrubNurse(operSchedule, nurse);
                } else if ($(this).find('.cirnurse-container').length > 0) {
                    addCirNurse(operSchedule, nurse);
                } else if ($(this).find('.anaestnurse-container').length > 0) {
                    addAnaestNurse(operSchedule, nurse);
                }
            }
        });

        container.draggable({
            edge: 5,
            disabled: true,
            revert: true,
            proxy: proxy,
            onBeforeDrag: function(e) {
                $('.cancel-oper-area').addClass('cancel-oper-focus');
                var _this = $(this);
                _this.data('size', {
                    width: _this.width(),
                    height: _this.height()
                });
                restorePosition();
                setPlaceholder($(this));
                setTimeout(function() {
                    if (!_this.data('startedDragging')) {
                        removePlaceholder();
                    }
                }, 400);
            },
            onStartDrag: function(e) {
                $(this).data('startedDragging', true);
                if ($(this).data('draggable') && $(this).data('draggable')['droppables']) {
                    $($(this).data('draggable')['droppables']).addClass('droppable-focus');
                }
            },
            onStopDrag: function(e) {
                var _this = $(this);
                _this.css({ left: 0, top: 0 });
                setTimeout(function() {
                    removePlaceholder();
                }, 400);
                if ($(this).data('draggable') && $(this).data('draggable')['droppables']) {
                    $($(this).data('draggable')['droppables']).removeClass('droppable-focus');
                }
                $('.cancel-oper-area').removeClass('cancel-oper-focus');
                $(this).data('startedDragging', false);
                $('.oper-arranged-dragging').remove();
            },
            onDrag: function(e) {
                if (!$(this).data('draggable') || !$(this).data('draggable')['droppables']) {
                    $('.oper-arranged-dragging').offset({ top: e.pageY - 10, left: e.pageX - 20 });
                }
                if ($(this).data('draggable')) {
                    if (typeof $(this).data('draggable')['droppables'] == 'undefined') {
                        $(this).data('draggable')['droppables'] = [];
                    }
                } else {
                    $(this).data('draggable') = { handle: $(this), options: $(this).data('draggableOptions') };
                }
                coordinatePlaceholder(e.pageY);
            },
            onEndDrag: function(e) {
                if ($(this).data('draggable') && $(this).data('draggable')['droppables']) {
                    $($(this).data('draggable')['droppables']).removeClass('droppable-focus');
                }
                $('.cancel-oper-area').removeClass('cancel-oper-focus');
                $(this).data('startedDragging', false);
                $('.oper-arranged-dragging').remove();
                if ($(this).data('draggable')) $(this).draggable('disable');
            }
        });

        container.data('draggableOptions', container.draggable('options'));
    },
    renderTooltip: function(container, operSchedule) {
        var contentArray = [];
        contentArray.push('<span style="font-size:14px;margin-left:10px;>' + operSchedule.PatDeptDesc+ '</span>');
        contentArray.push('<span style="font-size:14px;margin-left:10px;">' +operSchedule.WardBed+ '</span>');

        var SourceType = '';
        if (operSchedule.SourceType === 'E') {
            SourceType = '急诊手术';
        } else if (operSchedule.SourceType === 'B') {
            SourceType = '择期手术';
        } else if (operSchedule.DaySurgery === 'Y') {
            SourceType = '日间手术';
        }
        contentArray.push('<span style="margin-left:10px;padding:0 5px;font-size:14px;border:1px solid #fff;border-radius:10px;">' + decodeAdmType(operSchedule.AdmType) + '</span><b>' + operSchedule.PatName + '</b> (' + operSchedule.PatGender + ' ' + operSchedule.PatAge + ')' + '<span style="float: right;font-size:14px;border:1px solid #fff;">' + SourceType + '</span>');

        contentArray.push('<span style="font-size:14px;margin-left:10px;">'+'登记号：' + operSchedule.RegNo + '</span>');
        contentArray.push('<span style="margin-left:10px;font-size:14px;">住院号：' + operSchedule.MedcareNo + '</span>');
		contentArray.push('<span style="font-size:14px;margin-left:10px;">'+'医生申请手术位置：' + operSchedule.OperDeptDesc+ '</span>');
        contentArray.push('<span style="font-size:14px;margin-left:10px;">'+'手术日期：' + operSchedule.OperDate+ '</span>');
        contentArray.push('<span style="font-size:14px;margin-left:10px;">'+'手术时间：' + operSchedule.OperTime + '</span>'+ '<span style="margin-left:20px;font-size:14px;">预计持续时间：' + (operSchedule.OperDuration ? operSchedule.OperDuration + 'h' : '') + '</span>');
        contentArray.push('<span style="font-size:14px;margin-left:10px;">'+'手术名称：' + operSchedule.OperDesc+ '</span>');
        if (operSchedule.OperEnglishName) contentArray.push(operSchedule.OperEnglishName);
        contentArray.push('<span style="font-size:14px;margin-left:10px;">'+'麻醉方法：' + operSchedule.AnaMethodDesc+ '</span>');

        contentArray.push('<span style="font-size:14px;margin-left:10px;">'+'主刀医生：' + operSchedule.SurgeonDesc + '</span>'+ '<span style="margin-left:20px;font-size:14px;">专业：' + (operSchedule.Major || '') + '</span></span>');
        contentArray.push('<span style="font-size:14px;margin-left:10px;">' + '手术要求：' + operSchedule.OperRequirement+ '</span>');
		var match = /\d+/.exec(operSchedule.PatAge);
        var age = match ? Number(match[0]) : 30;
        if (age > 70) contentArray.push('<span style="font-size:14px;border:1px solid #fff;">年龄大于70岁</span>');
        if (age < 3) contentArray.push('<span style="font-size:14px;border:1px solid #fff;">年龄小于3岁</span>');

        var tagArray = [];
        if ((operSchedule.OperDuration && Number(operSchedule.OperDuration) > 4)) {
            tagArray.push('<span style="color:#A164F3;margin-left:10px;font-size:14px;">大于4小时</span>');
        }
        if (/IMC/.test(operSchedule.PatWardDesc)) {
            tagArray.push('<span style="color:#6798E9;margin-left:10px;font-size:14px;">IMC病区</span>');
        }
        if (operSchedule.MechanicalArm === 'Y') {
            tagArray.push('<span style="color:#EC808D;margin-left:10px;font-size:14px;">X-ray</span>');
        }
        if (operSchedule.IsoOperation === 'Y') {
            tagArray.push('<span style="color:#008080;margin-left:10px;font-size:14px;">隔离</span>');
        }
        if (operSchedule.InfectionOper) {
            tagArray.push('<span style="color:#D9001B;margin-left:10px;font-size:14px;">感染</span>');
        }
        if (operSchedule.MDROS === '+') {
            tagArray.push('<span style="color:#FC522C;margin-left:10px;font-size:14px;">多重耐药</span>');
        }
        if (operSchedule.Profrozen === 'Y') {
            tagArray.push('<span style="color:#81D3F8;margin-left:10px;font-size:14px;">冰冻</span>');
        }
        if (operSchedule.SpecialConditions) {
            tagArray.push('<span style="white-space:normal;color:#420080;text-align:left;margin-left:10px;font-size:14px;">' + (operSchedule.SpecialConditions || '检查前3小时内禁食禁饮，需要备血，尖头电刀，强生缝合器') + '</span>');
        }
        contentArray.push('<span style="display:inline-block;max-width:300px;">' + tagArray.join('') + '</span>');
        var title = contentArray.join('<br/>');
        container.tooltip({
            content: title
        });

        function decodeAdmType(admType) {
            switch (admType) {
                case 'I':
                    return '住院病人';
                case 'O':
                    return '门诊病人';
                case 'E':
                    return '急诊病人';
                default:
                    return admType;
            }
        }
    },
    refreshEstimatedTime: function(container) {
        var operSchedule = container.data('data');
        container.find('.oper-arranged-estimatedtime').text(operSchedule.EstimatedOperTime || '08:30');
    },
    renderSeq: function(container, operSchedule) {
        var operSchedule = container.data('data');
        container.find('.oper-arranged-seq').text(operSchedule.ArrOperSeq);
    },
    renderNurses: function(container) {
        var operSchedule = container.data('data');
        var nurseContainer = container.find('.arranged-nurse-container .scrubnurse-container');
        nurseContainer.empty();
        if (operSchedule.ArrScrubNurse) {
            var idArray = operSchedule.ArrScrubNurse.split(',');
            var descArray = operSchedule.ArrScrubNurseDesc.split(',');
            var length = idArray.length;
            var element;
            for (var i = 0; i < length; i++) {
                nurse = { RowId: idArray[i] || '', Description: descArray[i] || '' }
                element = $('<div class="careprovider-item careprovider-item-arranged scrubnurse"></div>')
                    .text(nurse.Description)
                    .append('<a href="javascript:;" class="tagbox-remove" title="移除护士' + nurse.Description + '"></a>')
                    .attr('data-value', nurse.RowId)
                    .data('data', nurse)
                    .appendTo(nurseContainer);
            }
        } else {
            nurseContainer.append('&nbsp;');
        }

        var nurseContainer = container.find('.arranged-nurse-container .cirnurse-container');
        nurseContainer.empty();
        if (operSchedule.ArrCircualNurse) {
            var idArray = operSchedule.ArrCircualNurse.split(',');
            var descArray = operSchedule.ArrCircualNurseDesc.split(',');
            var length = idArray.length;
            var element, nurse;
            for (var i = 0; i < length; i++) {
                nurse = { RowId: idArray[i] || '', Description: descArray[i] || '' }
                element = $('<div class="careprovider-item careprovider-item-arranged cirnurse"></div>')
                    .text(nurse.Description)
                    .append('<a href="javascript:;" class="tagbox-remove" title="移除护士' + nurse.Description + '"></a>')
                    .attr('data-value', nurse.RowId)
                    .data('data', nurse)
                    .appendTo(nurseContainer);
            }
        } else {
            nurseContainer.append('&nbsp;');
        }

        var nurseContainer = container.find('.arranged-nurse-container .anaestnurse-container');
        nurseContainer.empty();
        if (operSchedule.ArrAnaNurse) {
            var idArray = operSchedule.ArrAnaNurse.split(',');
            var descArray = operSchedule.ArrAnaNurseDesc.split(',');
            var length = idArray.length;
            var element, nurse;
            for (var i = 0; i < length; i++) {
                nurse = { RowId: idArray[i] || '', Description: descArray[i] || '' }
                element = $('<div class="careprovider-item careprovider-item-arranged cirnurse"></div>')
                    .text(nurse.Description)
                    .append('<a href="javascript:;" class="tagbox-remove" title="移除护士' + nurse.Description + '"></a>')
                    .attr('data-value', nurse.RowId)
                    .data('data', nurse)
                    .appendTo(nurseContainer);
            }
        } else {
            nurseContainer.append('&nbsp;');
        }
    }
}

/**
 * 卡片拖动的代理
 * @param {HTMLElement} source 
 */
function proxy(source) {
    var p = $('<div style="z-index:200000;" class="oper-arranged oper-arranged-dragging"></div>');
    var size = $(source).data('size');
    p.css({ width: size.width, height: size.height });
    p.html($(source).clone().html()).appendTo('body');

    return p;
}

function setPlaceholder(card) {
    $('.placeholder').remove();
    var placeholder = $('<div class="oper-arranged placeholder" style="position:absolute;"></div>').appendTo(page.ArrangedOperList);
    placeholder.height(card.height());
    placeholder.width(card.width());
    placeholder.offset(card.offset());

    placeholder.droppable({
        accept: '.oper-arranged',
        onDragEnter: function(e, source) {

        },
        onDragLeave: function(e, source) {

        },
        onDrop: function(e, source) {
            //$(this).before(source);
            var cards = page.currentCards;
            var replaceCardIndex = page.placeholderPos;
            if (page.placeholderIndex > replaceCardIndex) $(cards[replaceCardIndex]).before(source);
            else if (page.placeholderIndex < replaceCardIndex) $(cards[replaceCardIndex]).after(source);

            removePlaceholder();
            updateOperSeqs();
        }
    });

    var cards = page.currentCards;

    page.placeholderIndex = 0;
    $.each(cards, function(index, e) {
        if (e === card[0]) {
            page.placeholderIndex = Number(index);
            return false;
        }
    });

    page.placeholderPos = page.placeholderIndex;
    page.originalIndex = page.placeholderIndex;
    //console.log('originalIndex:' + page.originalIndex);
    page.placeholder = placeholder;
};

/**
 * 保存位置信息
 */
function restorePosition() {
    page.positions = [];
    var cards = page.ArrangedOperList.find('.oper-arranged');
    page.currentCards = cards;
    var positions = page.positions;
    $.each(cards, function(index, card) {
        var position = $(card).offset();
        positions.push({
            top: position.top,
            bottom: position.top + $(card).height()
        });
        //console.log('index:' + index + '  top:' + position.top + '  bottom:' + (position.top + $(card).height()));
    });
};

/**
 * 调整placeholder的位置
 * @param {*} y 
 */
function coordinatePlaceholder(y) {
    var cards = page.currentCards;
    var length = page.positions.length;
    var nextPos = length - 1;
    for (var i = 0; i < length; i++) {
        if (y >= page.positions[i].top && y <= page.positions[i].bottom) {
            nextPos = i;
            break;
        }
    }

    //console.log('yAxies:' + y + '  nextPos:' + nextPos);
    if (nextPos != page.placeholderPos) {
        page.placeholder.offset($(cards[nextPos]).offset());
        page.placeholderPos = nextPos;
    }

};

/**
 * 移除placeholder
 */
function removePlaceholder() {
    if (page.placeholder) page.placeholder.remove();
};

/**
 * 隐藏所有tooltip
 */
function hideAllTooltip() {
    $('body').children('div.tooltip').hide();
}

/**
 * 预计手术时间修改
 */
var estimatedOperTimeView = {
    init: function(opt) {
        this.options = opt;
        this.dom = $('<div class="oper-estimatedtime-view" style="display:none;"></div>').appendTo('body');
        var container = $('<div class="oper-estimatedtime-v-container"></div>').appendTo(this.dom);

        this.timeSelectArea = $('<div class="oper-estimatedtime-v-ts"></div>').appendTo(container);
        this.timeModifyArea = $('<div class="oper-estimatedtime-v-tm"></div>').appendTo(container);

        this.editor = $('<input class="oper-estimatedtime-editor">').appendTo(this.timeModifyArea);
        $('<span class="oper-estimatedtime-minusfive" title="减少5分钟">-5</span>').appendTo(this.timeModifyArea);
        $('<span class="oper-estimatedtime-plusfive" title="增加5分钟">+5</span>').appendTo(this.timeModifyArea);

        this.initEventHandler();
    },
    initEventHandler: function() {
        var _this = this;
        this.dom.delegate('.oper-estimatedtime-s-i', 'click', function() {
            _this.editor.val($(this).text());
            _this.refreshTarget();
        });

        this.dom.delegate('.oper-estimatedtime-minusfive', 'click', function() {
            var time = _this.editor.val();
            var originalHour = Number(time.split(':')[0]);
            var originalMinute = Number(time.split(':')[1]);
            var hour = originalHour;
            var minute = originalMinute;
            var minute = minute - 5;
            if (minute < 0) {
                hour--;
                if (hour < 0) hour = 23;
                minute = 60 + minute
            }
            if (minute >= 60) {
                hour++;
                if (hour > 23) hour = 0;
                minute = minute - 60;
            }
            var timeStr = (hour > 9 ? hour : '0' + hour) + ':' + (minute > 9 ? minute : '0' + minute);
            _this.editor.val(timeStr);
            _this.refreshTarget();
        });

        this.dom.delegate('.oper-estimatedtime-plusfive', 'click', function() {
            var time = _this.editor.val();
            var originalHour = Number(time.split(':')[0]);
            var originalMinute = Number(time.split(':')[1]);
            var hour = originalHour;
            var minute = originalMinute;
            var minute = minute + 5;
            if (minute < 0) {
                hour--;
                if (hour < 0) hour = 23;
                minute = 60 + minute
            }
            if (minute >= 60) {
                hour++;
                if (hour > 23) hour = 0;
                minute = minute - 60;
            }
            var timeStr = (hour > 9 ? hour : '0' + hour) + ':' + (minute > 9 ? minute : '0' + minute);
            _this.editor.val(timeStr);
            _this.refreshTarget();
        });

        this.dom.on('keydown', function(e, args) {
            if (e.keyCode == 13) {
                _this.save();
                _this.close();
            }
        });

        this.editor.on('keydown', function(e, args) {
            if (e.keyCode == 13) {
                _this.save();
                _this.close();
            }
            if (e.keyCode > 57 || e.keyCode < 48) {
                return false;
            }
        });

        this.editor.on('keyup', function(e, args) {
            var text = $(this).val();
            var selectionStart = $(this)[0].selectionStart;
            var selectionEnd = $(this)[0].selectionEnd;

            var number = 0,
                start = selectionStart,
                end = selectionEnd,
                previousStart = 0,
                previousEnd = 0,
                limitMin = 0,
                limitMax = 23,
                isWrongFormat = false;
            if (selectionStart == 2) { // HH->mm
                previousStart = 0;
                previousEnd = 2;
                start = 3;
                end = 5;
                limitMin = 0;
                limitMax = 59;
            }

            if (limitMin != undefined && limitMax != undefined) {
                number = Number(text.substring(previousStart, previousEnd));
                if (!number) number = 0;
                if (number > limitMax) number = limitMax, isWrongFormat = true;
                if (number < limitMin) number = limitMin, isWrongFormat = true;
                if (isWrongFormat) {
                    text = text.slice(0, previousStart) + (number < 10 ? '0' : '') + number + text.slice(previousEnd);
                }
            }

            if (text.length >= 5 && !/^\d\d:\d\d$/.test(text)) {
                text = text.slice(0, 5);
            }

            if (text.length === 2) {
                text = text + ':';
            }

            $(this).val(text);
            _this.refreshTarget();

            $(this)[0].selectionStart = start;
            $(this)[0].selectionEnd = end;
        });

        this.editor.on('mousewheel', function(e, args) {
            var delta = e.originalEvent.wheelDelta || e.originalEvent.detail;
            var direction = delta > 0 ? 1 : -1;
            var text = $(this).val();
            var selectionStart = $(this)[0].selectionStart;
            var selectionEnd = $(this)[0].selectionEnd;

            var number = 0,
                start = 0,
                end = 0,
                limitMin = 0,
                limitMax = 0;
            if (selectionStart >= 0 && selectionStart <= 2) { // HH
                start = 0;
                end = 2;
                limitMin = 0;
                limitMax = 23;
            } else if (selectionStart >= 3 && selectionStart <= 5) { // mm
                start = 3;
                end = 5;
                limitMin = 0;
                limitMax = 59;
            }
            number = Number(text.substring(start, end));

            if (!number) number = 0;

            number = number + direction;

            if (number > limitMax) number = limitMin;
            if (number < limitMin) number = limitMax;

            text = text.slice(0, start) + (number < 10 ? '0' : '') + number + text.slice(end);
            $(this).val(text);
            _this.refreshTarget();

            $(this)[0].selectionStart = selectionStart;
            $(this)[0].selectionEnd = selectionEnd;
        });

        this.editor.on('focus', function(e, args) {
            var text = $(this).val();

            if (text.length > 2) {
                $(this)[0].selectionStart = 0;
                $(this)[0].selectionEnd = 2;
            }
        });
    },
    refreshTarget: function() {
        if (this.target) {
            this.target.text(this.editor.val());
            this.editor.focus();
        }
    },
    bind: function(target, operSchedule) {
        this.target = target;
        this.operSchedule = operSchedule;
        this.position(this.target.offset());
        this.render(this.target.text());
    },
    render: function(time) {
        this.originalTime = time;
        this.editor.val(time);
        var originalHour = Number(time.split(':')[0]);
        var originalMinute = Number(time.split(':')[1]);
        var container = this.timeSelectArea;
        container.empty();

        var hour, minute, timeStr;
        for (var i = -2; i < 3; i++) {
            if (i != 0) {
                hour = originalHour;
                minute = originalMinute;
                minute = minute + (i * 15);
                if (minute < 0) {
                    hour--;
                    if (hour < 0) hour = 23;
                    minute = 60 + minute
                }
                if (minute >= 60) {
                    hour++;
                    if (hour > 23) hour = 0;
                    minute = minute - 60;
                }
                timeStr = (hour > 9 ? hour : '0' + hour) + ':' + (minute > 9 ? minute : '0' + minute);
                $('<span class="oper-estimatedtime-s-i"></span>').text(timeStr).appendTo(container);
            }
        }
    },
    open: function() {
        this.dom.show();
        this.visible = true;
    },
    close: function() {
        if (this.options.onClose) this.options.onClose.call(this);
        this.dom.hide();
        this.visible = false;
        this.target = null;
        this.operSchedule = null;
    },
    position: function(pos) {
        this.dom.css({
            top: pos.top + 26,
            left: pos.left - 20
        });
    },
    save: function() {
        if (this.options.saveHandler) this.options.saveHandler.call(this, this.editor.val());
    }
}