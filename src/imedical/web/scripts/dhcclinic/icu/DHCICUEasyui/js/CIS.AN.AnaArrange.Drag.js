/**
 * @author yongyang
 * @description 麻醉排班视图 麻醉医生拖动排班操作 仅加载已安排手术间的手术
 */

 var page = {
    Data: {}
}

$(document).ready(function() {
    //初始化界面元素
    initHeader();
    initDoctorList();
    initAnaMethodList();
    initOperScheduleArea();
    initDoctorSchedule();

    //设置界面元素初始值和事件处理
    setDefaultValue();
    setEventHandler();

    //加载数据
    loadDoctor();
    loadAnaMethod();
    loadOperSchedule();
    loadDoctorSchedule();
});

/**
 * 初始化全部医生列表
 */
function initDoctorList() {
    page.DoctorList = window.DoctorList.init($('#doctor_list'), {
        onDblClick: null
    });
}

/**
 * 初始化全部麻醉方法列表
 */
function initAnaMethodList() {
    page.AnaMethodList = window.AnaMethodList.init($('#anamethod_list'), {
        onDblClick: null
    });
}

/**
 * 初始化手术列表
 */
function initOperScheduleArea() {
    page.OperScheduleContainer = $('#oper_schedule_container');
}

/**
 * 初始化头部区域
 */
function initHeader() {
    page.FilterOperDate = $('#filterOperDate');
}

/**
 * 加载科室排班汇总
 */
function initDoctorSchedule() {
    page.DoctorScheduleToday = window.DoctorSchedule.init($('#doctor_schedule_today'), {
        editable: true,
        height: 430,
        callback: showDoctorScheduleOfAttendance,
        getCurrentDate: function() {
            return page.FilterOperDate.datebox('getValue');
        }
    });
}

/**
 * 关闭科室排班弹出页面
 */
function closeAttendance() {
    page.DoctorScheduleToday.closeDialog();
}

/**
 * 加载护士排班汇总
 */
function loadDoctorSchedule() {
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: "FindCrewShift",
        Arg1: session.DeptID,
        Arg2: "Y",
        ArgCnt: 2
    }, "json", true, function(data) {
        page.Data.CrewShifts = data;
        var length = data.length;
        var doctorScheduleList = [];
        var row;
        for (var i = 0; i < length; i++) {
            row = data[i];
            doctorScheduleList.push({
                Type: 'Attendance',
                RowId: row.RowId,
                Description: row.StatusDesc,
                GroupBy: row.FloorDesc
            });
        }

        page.DoctorScheduleToday.loadSchedule(doctorScheduleList, true);
        page.DoctorScheduleToday.refresh();
    });

    var data = page.Data.operRooms || [];
    var length = data.length;
    var doctorScheduleList = [];
    var row;
    for (var i = 0; i < length; i++) {
        row = data[i];
        doctorScheduleList.push({
            Type: 'Doctor',
            RowId: row.RowId,
            Description: row.Description,
            GroupBy: '术间排班汇总'
        });
    }

    page.DoctorScheduleToday.loadSchedule(doctorScheduleList);
}

/**
 * 汇总显示科室排班数据
 */
function showDoctorScheduleOfAttendance() {
    var doctorScheduleList = [],
        attendances,
        doctorScheduleDic = {};
    var operDate = page.FilterOperDate.datebox("getValue");
    var data = dhccl.runServerMethod(ANCLS.BLL.Attendance, "GetAttendanceInfo", operDate, session.DeptID);
    if (data && data.length > 0) {
        attendances = data[0];
        for (var rowId in attendances) {
            doctorScheduleList.push({
                Type: 'Attendance',
                RowId: rowId,
                Value: attendances[rowId]
            });
            doctorScheduleDic[rowId] = attendances[rowId];
        }
    }

    var data = page.Data.CrewShifts;
    var length = data.length;
    var crewshift;
    for (var i = 0; i < length; i++) {
        crewshift = data[i];
        if (!doctorScheduleDic[crewshift.RowId]) {
            doctorScheduleList.push({
                Type: 'Attendance',
                RowId: crewshift.RowId,
                Value: ''
            });
        }
    }

    page.DoctorScheduleToday.loadData(doctorScheduleList);
}

/**
 * 汇总显示人员排班汇总信息
 */
function showDoctorSchedule() {
    var data = page.Data.careProviders;
    var length = data.length;
    var doctorScheduleList = [];
    var row, count;
    for (var i = 0; i < length; i++) {
        row = data[i];
        count = (row.operSchedules || []).length;
        if (count > 0) doctorScheduleList.push({
            Type: 'Doctor',
            RowId: 'doctor_' + row.RowId,
            Value: count
        });
    }

    page.DoctorScheduleToday.loadData(doctorScheduleList);
}

/**
 * 汇总显示麻醉方法排班汇总信息
 */
function showMethodSchedule() {
    var data = page.Data.anaMethods;
    var length = data.length;
    var methodScheduleList = [];
    var row, count;
    for (var i = 0; i < length; i++) {
        row = data[i];
        count = (row.operSchedules || []).length;
        if (count > 0) methodScheduleList.push({
            Type: 'Method',
            RowId: 'method_' + row.RowId,
            Value: count
        });
    }

    page.DoctorScheduleToday.loadData(methodScheduleList);
}

/**
 * 设置界面元素默认值
 */
function setDefaultValue() {
	dhccl.parseDateFormat();
	dhccl.parseDateTimeFormat();
    var nextDay = new Date().addDays(1);
    page.FilterOperDate.datebox('setValue', nextDay.format('yyyy-MM-dd'));
}

/**
 * 设置界面事件处理函数
 */
function setEventHandler() {
    $('#btnExtract').click(function() {
        loadOperSchedule();
        showDoctorScheduleOfAttendance();
    });

    $('#filterText').keyup(function() {
        var text = $(this).val();
        filterOperSchedule(text);
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

    page.OperScheduleContainer.delegate('.careprovider-item-arranged a.tagbox-remove', 'click', function(e) {
        var doctor = $(this).parent().data('data');
        var doctorContainer = $(this).parent().parent();
        var operSchedule = $(doctorContainer).parent().parent().parent().parent().data('data');
        if (doctorContainer.hasClass('anaexpert-container')) {
            removeAnaExpert(operSchedule, doctor);
        } else if (doctorContainer.hasClass('anesthesiologist-container')) {
            removeAnaDoctor(operSchedule, doctor);
        } else if (doctorContainer.hasClass('anaassistant-container')) {
            removeAnaAssistant(operSchedule, doctor);
        }
        e.stopPropagation();
        return false;
    });

    page.OperScheduleContainer.delegate('.anamethod-item-arranged a.tagbox-remove', 'click', function(e) {
        var anaMethod = $(this).parent().data('data');
        var methodContainer = $(this).parent().parent();
        var operSchedule = $(methodContainer).parent().parent().parent().parent().data('data');
        removeAnaMethod(operSchedule, anaMethod);
        e.stopPropagation();
        return false;
    });

    page.OperScheduleContainer.delegate('.oper-arranged-group-header .header-text', 'dblclick', function(e) {
        var group = $(this).parent().parent();
        group.toggleClass('oper-arranged-group-selected');
        if (group.hasClass('oper-arranged-group-selected')) group.find('.oper-arranged').addClass('oper-arranged-selected');
        else group.find('.oper-arranged').removeClass('oper-arranged-selected');
        e.stopPropagation();
        return false;
    });

    page.OperScheduleContainer.delegate('.oper-arranged', 'click', function(e) {
        $(this).toggleClass('oper-arranged-selected');
    });

    $('.doctor-summary').delegate('.tab-item', 'click', function() {
        if (!$(this).hasClass('tab-item-selected')) {
            var target = $('.tab-item-selected').attr('data-target');
            $(target).hide();

            $('.tab-item-selected').removeClass('tab-item-selected');
            $(this).addClass('tab-item-selected');

            var target = $(this).attr('data-target');
            $(target).show();
        }
    });
}

/**
 * 筛选手术
 */
function filterOperSchedule(filterText) {
    var operSchedules = page.Data.operSchedules;
    var length = operSchedules.length;

    var element, operSchedule;
    for (var i = 0; i < length; i++) {
        operSchedule = operSchedules[i];
        element = operSchedule.target;
        if (!filterText) {
            element.show();
        } else if (operSchedule.PatName.indexOf(filterText) > -1 ||
            operSchedule.RegNo.indexOf(filterText) > -1 ||
            operSchedule.ArrScrubNurseDesc.indexOf(filterText) > -1 ||
            operSchedule.ArrCircualNurseDesc.indexOf(filterText) > -1 ||
            operSchedule.ArrAnesthesiologistDesc.indexOf(filterText) > -1) {
            element.show();
        } else element.hide();
    }

    $('.oper-arranged-group').show();
    $('.oper-arranged-group').each(function(i, e) {
        if ($(this).find('.oper-arranged:visible').length <= 0) $(this).hide();
    });

    if ($('#oper_schedule_container').find('.oper-arranged-group:visible').length <= 0) $('#oper_schedule_container').addClass('oper-schedule-filtered-null');
    else $('#oper_schedule_container').removeClass('oper-schedule-filtered-null');
}

/**
 * 提交手术（手术排班信息发布）
 */
function submitOperList() {
    $.messager.confirm("提示", "是否要发布所有手术？", function(r) {
        if (r) {
            var operDate = page.FilterOperDate.datebox("getValue");
            var result = dhccl.runServerMethod(ANCLS.BLL.AnaArrange, "SubmitArrange", operDate, session.UserID);
            if (result.success) {
                loadOperSchedule();
                $.messager.alert("提示", "发布手术成功！", "info");
            } else {
                $.messager.alert("提示", "发布手术失败，原因：" + result.result, "error");
            }
        }
    });
}

function printListNew(printDatas, configCode,LODOP) {
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
    var printtitle = hospital[0].HOSP_Desc + "手术排班表";
    //LODOP.PRINT_INIT(printtitle);
    // LODOP.SET_PRINT_PAGESIZE(printSetting.direction, printSetting.paperSize.width, printSetting.paperSize.height, "SSS");
    LODOP.SET_PRINT_PAGESIZE("2", "", "", "A4");
    LODOP.ADD_PRINT_TEXT(10, 250, 500, 40, hospital[0].HOSP_Desc);
    LODOP.SET_PRINT_STYLEA(0, "FontName", "宋体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 16);
    LODOP.SET_PRINT_STYLEA(0, "Bold",1);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "HOrient", 2);
    LODOP.ADD_PRINT_TEXT(40, 250, 500, 40, "麻醉排班表");
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
    LODOP.ADD_PRINT_TEXT(80, 700, "100%", 28, "总计：" + printDatas.length+"台手术");
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_HTM(80, 900, "100%", 28, "<span tdata='pageNO'>第##页</span> <span tdata='pageCount'>共##页</span>");
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW",true);
    LODOP.SET_SHOW_MODE("LANDSCAPE_DEFROTATED", 1);
    var totalWidth = operListConfig.print.paperSize.rect.width;
    var html = "<style>table,td,th {border: 1px solid black;border-style:solid;border-collapse:collapse;font-size:16px;} table{table-layout:fixed;}</style><table style='" + totalWidth + "pt'><thead><tr>";
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

    
    LODOP.ADD_PRINT_TABLE(105, 20, totalWidth+"pt", "100%", html);
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
 * 安排麻醉医生
 */
function arrangeAnaDoctor(operSchedule, doctor) {
    var opsId = operSchedule.RowId;
    var doctorId = doctor.RowId;

    result = dhccl.runServerMethod(ANCLS.BLL.AnaArrange, "UpdateAnesthesiologist", opsId, doctorId, session.UserID);

    if (result.success) {
        operSchedule.ArrAnesthesiologist = doctorId;
        operSchedule.ArrAnesthesiologistDesc = doctor.Description;
        if (operSchedule.target && operSchedule.target.parent().length > 0) arrangedOperView.refresh(operSchedule.target);

        integrateOperSchedules(page.Data.operSchedules);
        page.DoctorList.refreshView();
    }
}

/**
 * 移除麻醉医生
 */
function removeAnaDoctor(operSchedule, doctor) {
    var opsId = operSchedule.RowId;
    var doctorId = doctor.RowId;

    result = dhccl.runServerMethod(ANCLS.BLL.AnaArrange, "UpdateAnesthesiologist", opsId, '', session.UserID);

    if (result.success) {
        operSchedule.ArrAnesthesiologist = '';
        operSchedule.ArrAnesthesiologistDesc = '';
        if (operSchedule.target && operSchedule.target.parent().length > 0) arrangedOperView.refresh(operSchedule.target);

        integrateOperSchedules(page.Data.operSchedules);
        page.DoctorList.refreshView();
    }
}

/**
 * 安排麻醉指导
 */
function arrangeAnaExpert(operSchedule, doctor) {
    var opsId = operSchedule.RowId;
    var doctorId = doctor.RowId;

    result = dhccl.runServerMethod(ANCLS.BLL.AnaArrange, "UpdateAnaExpert", opsId, doctorId, session.UserID);

    if (result.success) {
        operSchedule.ArrAnaExpert = doctorId;
        operSchedule.ArrAnaExpertDesc = doctor.Description;
        if (operSchedule.target && operSchedule.target.parent().length > 0) arrangedOperView.refresh(operSchedule.target);

        integrateOperSchedules(page.Data.operSchedules);
        page.DoctorList.refreshView();
    }
}

/**
 * 移除麻醉指导
 */
function removeAnaExpert(operSchedule, doctor) {
    var opsId = operSchedule.RowId;
    var doctorId = doctor.RowId;

    result = dhccl.runServerMethod(ANCLS.BLL.AnaArrange, "UpdateAnaExpert", opsId, '', session.UserID);

    if (result.success) {
        operSchedule.ArrAnaExpert = '';
        operSchedule.ArrAnaExpertDesc = '';
        if (operSchedule.target && operSchedule.target.parent().length > 0) arrangedOperView.refresh(operSchedule.target);

        integrateOperSchedules(page.Data.operSchedules);
        page.DoctorList.refreshView();
    }
}

/**
 * 添加一个麻醉助手
 */
function addAnaAssistant(operSchedule, doctor) {
    var opsId = operSchedule.RowId;
    var doctorId = doctor.RowId;

    result = dhccl.runServerMethod(ANCLS.BLL.AnaArrange, "AddAnaAssistant", opsId, doctorId, session.UserID);

    if (result.success) {
        var idArray = operSchedule.ArrAnaAssistant ? operSchedule.ArrAnaAssistant.split(',') : [];
        var descArray = operSchedule.ArrAnaAssistant ? operSchedule.ArrAnaAssistantDesc.split(',') : [];
        idArray.push(doctor.RowId);
        descArray.push(doctor.Description);
        operSchedule.ArrAnaAssistant = idArray.join(',');
        operSchedule.ArrAnaAssistantDesc = descArray.join(',');
        if (operSchedule.target && operSchedule.target.parent().length > 0) arrangedOperView.refresh(operSchedule.target);

        integrateOperSchedules(page.Data.operSchedules);
        page.DoctorList.refreshView();
    }
}

/**
 * 移除一个麻醉助手
 */
function removeAnaAssistant(operSchedule, doctor) {
    var opsId = operSchedule.RowId;
    var doctorId = doctor.RowId;

    result = dhccl.runServerMethod(ANCLS.BLL.AnaArrange, "RemoveAnaAssistant", opsId, doctorId, session.UserID);

    if (result.success) {
        var idArray = operSchedule.ArrAnaAssistant.split(',');
        var descArray = operSchedule.ArrAnaAssistantDesc.split(',');
        var index = idArray.indexOf(doctor.RowId);
        if (index > -1) idArray.splice(index, 1);
        var index = descArray.indexOf(doctor.Description);
        if (index > -1) descArray.splice(index, 1);
        operSchedule.ArrAnaAssistant = idArray.join(',');
        operSchedule.ArrAnaAssistantDesc = descArray.join(',');
        if (operSchedule.target && operSchedule.target.parent().length > 0) arrangedOperView.refresh(operSchedule.target);

        integrateOperSchedules(page.Data.operSchedules);
        page.DoctorList.refreshView();
    }
}

/**
 * 安排麻醉方法
 */
function arrangeAnaMethod(operSchedule, anaMethod) {
    var opsId = operSchedule.RowId;
    var anaMethodId = anaMethod.RowId;

    result = dhccl.runServerMethod(ANCLS.BLL.AnaArrange, "UpdateArrAnaMethod", opsId, anaMethodId, session.UserID);

    if (result.success) {
        operSchedule.ArrAnaMethod = anaMethodId;
        operSchedule.ArrAnaMethodDesc = anaMethod.Description;
        if (operSchedule.target && operSchedule.target.parent().length > 0) arrangedOperView.refresh(operSchedule.target);

        integrateOperSchedules(page.Data.operSchedules);
        page.AnaMethodList.refreshView();
    }
}

/**
 * 移除麻醉方法
 */
function removeAnaMethod(operSchedule, anaMethod) {
    var opsId = operSchedule.RowId;
    var anaMethodId = anaMethod.RowId;

    result = dhccl.runServerMethod(ANCLS.BLL.AnaArrange, "UpdateArrAnaMethod", opsId, '', session.UserID);

    if (result.success) {
        operSchedule.ArrAnaMethod = '';
        operSchedule.ArrAnaMethodDesc = '';
        if (operSchedule.target && operSchedule.target.parent().length > 0) arrangedOperView.refresh(operSchedule.target);

        integrateOperSchedules(page.Data.operSchedules);
        page.AnaMethodList.refreshView();
    }
}

/**
 * 加载医生
 */
function loadDoctor() {
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: CLCLS.BLL.Admission,
        QueryName: 'FindCareProvByLoc',
        Arg1: '',
        Arg2: session.DeptID,
        Arg3: 'Y',
        ArgCnt: 3
    }, 'json', true, function(data) {
        page.Data.careProviders = data;
        page.DoctorList.loadData(data);
        if (page.Data.operSchedules) {
            integrateDoctorArrangement(page.Data.operSchedules);
            page.DoctorList.refreshView();
        }
    });
}

/**
 * 加载麻醉方法
 */
function loadAnaMethod() {
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.CodeQueries,
        QueryName: 'FindAnaestMethod',
        Arg1: '',
        Arg2: '',
        ArgCnt: 2
    }, 'json', true, function(data) {
        page.Data.anaMethods = data;
        page.AnaMethodList.loadData(data);
        if (page.Data.operSchedules) {
            integrateDoctorArrangement(page.Data.operSchedules);
            page.DoctorList.refreshView();
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
        Arg7: "Arrange",
        Arg8: '',
        Arg9: '',
        Arg10: '',
        Arg11: 'N',
        Arg12: '',
        Arg13: '',
        Arg14: 'Arrange',
        ArgCnt: 14
    }, "json", true, function(data) {
        if (data) {
            page.Data.operSchedules = data;
            showOperSchedule();

            if (page.Data.careProviders) {
                integrateDoctorArrangement(data);
                page.DoctorList.refreshView();
            }
            if (page.Data.anaMethods) {
                integrateMethodArrangement(data);
                page.AnaMethodList.refreshView();
            }
        }
    });
}

/**
 * 手术列表显示
 */
function showOperSchedule() {
    var data = page.Data.operSchedules;
    var groups = groupingData(data, 'RoomDesc');
    var container = page.OperScheduleContainer;

    container.empty();

    var nullCardsTip = $('<div style="padding:5px;">未查到满足条件的手术</div>');
    if (data.length == 0) container.append(nullCardsTip);

    var length = groups.length;
    var element;
    for (var i = 0; i < length; i++) {
        element = $('<div class="oper-arranged-group"></div>').appendTo(container);
        groupView.render(element, groups[i]);
    }
}

function integrateOperSchedules(data) {
    integrateDoctorArrangement(data);
}

function integrateDoctorArrangement(data) {
    var careProviders = page.Data.careProviders;
    var length = careProviders.length;
    var doctorDic = {};
    for (var i = 0; i < length; i++) {
        careProviders[i].operSchedules = [];
        doctorDic[careProviders[i].RowId] = careProviders[i];
    }

    var length = data.length;
    var row, doctor, doctors;
    for (var i = 0; i < length; i++) {
        row = data[i];

        doctors = [].concat(row.ArrAnaExpert.split(','));
        doctors = doctors.concat(row.ArrAnesthesiologist.split(','));
        doctors = doctors.concat(row.ArrAnaAssistant.split(','));
        $.each(doctors, function(index, e) {
            doctor = doctorDic[e];
            if (doctor) {
                if (doctor.operSchedules.indexOf(row) < 0) doctor.operSchedules.push(row);
            }
        });
    }
}

function integrateMethodArrangement(data) {
    var anaMethods = page.Data.anaMethods;
    var length = anaMethods.length;
    var anaMethodDic = {};
    for (var i = 0; i < length; i++) {
        anaMethods[i].operSchedules = [];
        anaMethodDic[anaMethods[i].RowId] = anaMethods[i];
    }

    var length = data.length;
    var row, anaMethod, anaMethodId;
    for (var i = 0; i < length; i++) {
        row = data[i];

        anaMethodId = row.ArrAnaMethod;
        anaMethod = anaMethodDic[anaMethodId];
        if (anaMethod) {
            if (anaMethod.operSchedules.indexOf(row) < 0) anaMethod.operSchedules.push(row);
        }
    }
}

/**
 * 对数据进行分组
 */
function groupingData(data, field) {
    var groupDic = [];
    var groups = [];
    var groupField = field;

    var length = data.length;
    var row, index;
    for (var i = 0; i < length; i++) {
        row = data[i];
        index = groupDic.indexOf(row[groupField]);
        if (index > -1) {
            groups[index].items.push(row);
        } else {
            groupDic.push(row[groupField]);
            groups.push({
                key: row[groupField],
                items: [row]
            })
        }
    }
    return groups;
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

var groupView = {
    render: function(container, group) {
        container.empty();
        container.data('data', group);
        group.target = container;

        $('<div class="oper-arranged-group-header"></div>')
            .append('<span class="header-text">' + group.key + '</span>')
            .appendTo(container);
        var itemsContainer = $('<div class="oper-arranged-group-items"></div>')
            .appendTo(container);
        group.items.sort(numericCompare('ArrOperSeq'));
        var length = group.items.length;
        var element = null;
        for (var i = 0; i < length; i++) {
            element = $('<div class="oper-arranged"></div>').appendTo(itemsContainer);
            arrangedOperView.render(element, group.items[i]);
        }
    }
}

var arrangedOperView = {
    render: function(container, operSchedule) {
        container.empty();
        container.data('data', operSchedule);
        operSchedule.target = container;

        var title = [operSchedule.PatDeptDesc,
            operSchedule.PatWardDesc + ' ' + operSchedule.PatBedCode,
            '<b>' + operSchedule.PatName + '</b> ' + operSchedule.PatGender + ' ' + operSchedule.PatAge,
            operSchedule.RegNo,
            operSchedule.PrevDiagnosisDesc || '',
            operSchedule.PlanOperDesc || '',
            operSchedule.SurgeonDesc || '',
            '器械：' + (operSchedule.ArrScrubNurseDesc || '') +'&nbsp&nbsp&nbsp&nbsp'+ '  巡回：' + (operSchedule.ArrCircualNurseDesc || '')
        ].join('<br/>');
        container.attr('title', title);
        container.tooltip({});

        var content = $('<div class="oper-arranged-content"></div>').appendTo(container);
        $('<span class="oper-arranged-seq" style="font-weight:bold;border-right:1px solid #eee;padding-right:5px;line-height:20px;"></span>').text(operSchedule.ArrOperSeq).appendTo(content);
        $('<span style="padding-right:5px;width:60px;"></span>').text(operSchedule.PatDeptDesc).appendTo(content);
        $('<span style="border-right:1px solid #eee;padding-right:5px;width:50px;"></span>').text(operSchedule.SurgeonDesc).appendTo(content);
        $('<span style="font-weight:bold;"></span>').text(operSchedule.PatName).appendTo(content);
        $('<span></span>').text(operSchedule.PatGender).appendTo(content);
        $('<span></span>').text(operSchedule.PatAge).appendTo(content);
        $('<span></span>').text(operSchedule.RegNo).appendTo(content);
        $('<span class="seperator"></span>').appendTo(content);
        $('<span></span>').text(operSchedule.PrevDiagnosisDesc).appendTo(content);
        $('<span></span>').text(operSchedule.PlanOperDesc).appendTo(content);

        var doctorArea = $('<div class="arranged-doctor-area"></div>').appendTo(content);
        $('<div class="arranged-doctor-container" title="拖动医生到此处"><div style="display:inline-block;vertical-align:middle;"><span style="padding-top:5px">麻醉医生:</span></div><div class="anesthesiologist-container doctor-container"></div></div>').appendTo(doctorArea);
        // $('<div class="arranged-doctor-container" title="拖动医生到此处"><div style="display:inline-block;vertical-align:middle;"><span>麻醉指导:</span></div><div class="anaexpert-container doctor-container"></div></div>').appendTo(doctorArea);
        // $('<div class="arranged-doctor-container" title="拖动医生到此处"><div style="display:inline-block;vertical-align:middle;"><span>麻醉助手:</span></div><div class="anaassistant-container doctor-container"></div></div>').appendTo(doctorArea);

        $('<div class="arranged-method-container" title="拖动麻醉方法到此处"><div style="display:inline-block;vertical-align:middle;"><span style="padding-top:5px">麻醉方法:</span></div><div class="method-container"></div></div>').appendTo(doctorArea);

        this.refresh(container);
        container.find('.arranged-doctor-container').droppable({
            accept: '.careprovider-item',
            onDragEnter: function(e, source) {
                $(this).addClass('arranged-doctor-container-enter');
            },
            onDragLeave: function(e, source) {
                $(this).removeClass('arranged-doctor-container-enter');
            },
            onDrop: function(e, source) {
                var target = $(this).parent().parent().parent();
                var operSchedule = $(target).data('data');
                var doctor = $(source).data('data');
                $(this).removeClass('arranged-doctor-container-enter');

                var existsInAnaDoctor = (operSchedule.ArrAnesthesiologistDesc.indexOf(doctor.Description) > -1);
                if (existsInAnaDoctor) return false;

                if (target.hasClass('oper-arranged-selected')) {
                    var selectedRows = page.OperScheduleContainer.find('.oper-arranged.oper-arranged-selected');
                    $.each(selectedRows, function(index, element) {
                        operSchedule = $(element).data('data');
                        if (operSchedule) arrangeAnaDoctor(operSchedule, doctor);
                    })
                } else {
                    arrangeAnaDoctor(operSchedule, doctor);
                }
            }
        });

        container.find('.arranged-method-container').droppable({
            accept: '.anamethod-item',
            onDragEnter: function(e, source) {
                $(this).addClass('arranged-doctor-container-enter');
            },
            onDragLeave: function(e, source) {
                $(this).removeClass('arranged-doctor-container-enter');
            },
            onDrop: function(e, source) {
                var target = $(this).parent().parent().parent();
                var operSchedule = $(target).data('data');
                var anaMethod = $(source).data('data');
                $(this).removeClass('arranged-doctor-container-enter');

                var existsInAnaMethod = (operSchedule.ArrAnaMethod == anaMethod.RowId);
                if (existsInAnaMethod) return false;

                if (target.hasClass('oper-arranged-selected')) {
                    var selectedRows = page.OperScheduleContainer.find('.oper-arranged.oper-arranged-selected');
                    $.each(selectedRows, function(index, element) {
                        operSchedule = $(element).data('data');
                        if (operSchedule) arrangeAnaMethod(operSchedule, anaMethod);
                    })
                } else {
                    arrangeAnaMethod(operSchedule, anaMethod);
                }
            }
        });
    },
    refresh: function(container) {
        var operSchedule = container.data('data');
        // var doctorContainer = container.find('.arranged-doctor-container .anaexpert-container');
        // doctorContainer.empty();
        // if (operSchedule.ArrAnaExpert) {
        //     var idArray = operSchedule.ArrAnaExpert.split(',');
        //     var descArray = operSchedule.ArrAnaExpertDesc.split(',');
        //     var length = idArray.length;
        //     var element, doctor;
        //     for (var i = 0; i < length; i++) {
        //         doctor = { RowId: idArray[i] || '', Description: descArray[i] || '' }
        //         element = $('<div class="careprovider-item careprovider-item-arranged anaexpert"></div>')
        //             .text(doctor.Description)
        //             .append('<a href="javascript:;" class="tagbox-remove" title="移除医生' + doctor.Description + '"></a>')
        //             .attr('data-value', doctor.RowId)
        //             .data('data', doctor)
        //             .appendTo(doctorContainer);
        //     }
        // }

        var doctorContainer = container.find('.arranged-doctor-container .anesthesiologist-container');
        doctorContainer.empty();
        if (operSchedule.ArrAnesthesiologist) {
            var idArray = operSchedule.ArrAnesthesiologist.split(',');
            var descArray = operSchedule.ArrAnesthesiologistDesc.split(',');
            var length = idArray.length;
            var element, doctor;
            for (var i = 0; i < length; i++) {
                doctor = { RowId: idArray[i] || '', Description: descArray[i] || '' }
                element = $('<div class="careprovider-item careprovider-item-arranged anesthesiologist"></div>')
                    .text(doctor.Description)
                    .append('<a href="javascript:;" class="tagbox-remove" title="移除医生' + doctor.Description + '"></a>')
                    .attr('data-value', doctor.RowId)
                    .data('data', doctor)
                    .appendTo(doctorContainer);
            }
        }

        // var doctorContainer = container.find('.arranged-doctor-container .anaassistant-container');
        // doctorContainer.empty();
        // if (operSchedule.ArrAnaAssistant) {
        //     var idArray = operSchedule.ArrAnaAssistant.split(',');
        //     var descArray = operSchedule.ArrAnaAssistantDesc.split(',');
        //     var length = idArray.length;
        //     var element, doctor;
        //     for (var i = 0; i < length; i++) {
        //         doctor = { RowId: idArray[i] || '', Description: descArray[i] || '' }
        //         element = $('<div class="careprovider-item careprovider-item-arranged anaassistant"></div>')
        //             .text(doctor.Description)
        //             .append('<a href="javascript:;" class="tagbox-remove" title="移除医生' + doctor.Description + '"></a>')
        //             .attr('data-value', doctor.RowId)
        //             .data('data', doctor)
        //             .appendTo(doctorContainer);
        //     }
        // }

        var methodContainer = container.find('.arranged-method-container .method-container');
        methodContainer.empty();
        if (operSchedule.ArrAnaMethod) {
            var idArray = operSchedule.ArrAnaMethod.split(',');
            var descArray = operSchedule.ArrAnaMethodDesc.split(',');
            var length = idArray.length;
            var element, method;
            for (var i = 0; i < length; i++) {
                method = { RowId: idArray[i] || '', Description: descArray[i] || '' }
                element = $('<div class="anamethod-item anamethod-item-arranged anamethod"></div>')
                    .text(method.Description)
                    .append('<a href="javascript:;" class="tagbox-remove" title="移除麻醉方法' + method.Description + '"></a>')
                    .attr('data-value', method.RowId)
                    .data('data', method)
                    .appendTo(methodContainer);
            }
        }
    }
}