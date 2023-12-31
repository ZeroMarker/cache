/**
 * 科室人员考勤
 * @author yongyang 2019-01-24
 */

var dailyAttendance = {
    CareProviderList: [],
    CareProviderGroups: [],
    ShiftList: [],
    ShiftGroups: [],
    AttendanceList: [],
    ShiftContainer: null,
    CareProviderContainer: null,
    SavingAttendanceList: []
}

$(document).ready(function() {
    dailyAttendance.ShiftContainer = $('#shift_container');
    dailyAttendance.CareProviderContainer = $('#careprovider_container');

    /// 加载人员
    /// -> 按首字母分组
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: CLCLS.BLL.Admission,
        QueryName: 'FindCareProvByLoc',
        Arg1: '',
        Arg2: session.DeptID,
        ArgCnt: 2
    }, 'json', true, function(data) {
        dailyAttendance.CareProviderList = data;
        dailyAttendance.CareProviderGroups = groupingData(data, 'FirstChar');
        initCareProviderView();
    });

    /// 加载班次
    ///  ->按楼层分组
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: 'FindCrewShift',
        Arg1: session.DeptID,
        ArgCnt: 1
    }, 'json', false, function(data) {
        dailyAttendance.ShiftList = data;
        dailyAttendance.ShiftGroups = groupingData(data, 'FloorDesc');
        initShiftView();
    });

    /// 设置为当天日期
    /// 修改日期后重新加载考勤信息
    $('#AttendDate').datebox({
        value: new Date().format('yyyy-MM-dd'),
        onChange: function(newValue, oldValue) {
            loadAttendance();
            dailyAttendance.SavingAttendanceList=[];
        }
    });

    var operDate=dhccl.getQueryString("operDate");
    if(operDate){
        $('#AttendDate').datebox("setValue",operDate);
    }

    initSearchBox();

    /// 加载当天的考勤信息
    loadAttendance();

    /// 改变人员卡片状态

    /// 提交后不能随意修改
    /// 不能修改昨天的考勤记录
    /// 可以补提交

    $(dailyAttendance.ShiftContainer).delegate('.attendance-remove', 'click', function() {
        var element = $(this).parent();
        var attendance = $(element).data('data');
        attendance.isRemoved = 'Y';
        if (attendance.RowId) dailyAttendance.SavingAttendanceList.push(attendance);
        element.remove();
    });

    //adjustContainerSize();
});

/**
 * 调整班次和人员容器大小
 */
function adjustContainerSize() {
    var container = $('#attend_all_container');
    var totalWidth = window.innerWidth;
    var width = totalWidth - 360;
    container.width(width);

    var height = window.innerHeight - 130;

    var container = $('#shift_container');
    container.height(height);

    var container = $('#careprovider_container');
    container.height(height - 35);
}
/*
window.onresize = function() {
    //console.log("resize");
    setTimeout(function() {
        adjustContainerSize();
    }, 500);
};*/

/**
 * 初始化搜索框
 */
function initSearchBox() {
    var searchBox = $('#careprovider_search');
    $(searchBox).siblings().find('input.searchbox-text').keyup(function() {
        event.preventDefault();
        event.stopPropagation();
        var text = $(this).val();
        filterCareProvider(text);
    });

    $(searchBox).siblings().find('.searchbox-button').click(function() {
        var text = $(this).parent().parent().find('input.searchbox-text').val();
        filterCareProvider(text);
    })
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

/**
 * 加载考勤信息
 */
function loadAttendance() {
    clearAttendances();
    showLoadingMask(); //显示加载中遮罩

    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.Attendance,
        QueryName: 'FindAttendance',
        Arg1: $('#AttendDate').datebox('getValue'),
        Arg2: session.DeptID,
        ArgCnt: 2
    }, 'json', true, function(data) {
        dailyAttendance.AttendanceList = data;
        clearAttendances();
        showAttendances(data);
        hideLoadingMask(); //隐藏加载中遮罩
    });
}

/**
 * 清空显示的考勤信息
 */
function clearAttendances() {
    $('.attendance-container .shift-item-content').empty();
}

/**
 * 显示加载中遮罩
 */
function showLoadingMask() {

}

/**
 * 隐藏加载中遮罩
 */
function hideLoadingMask() {

}

/**
 * 保存考勤数据
 */
function saveAttendance() {
    $.each(dailyAttendance.SavingAttendanceList, function(index, row) {
        row.ClassName = ANCLS.Model.Attendance;
    });
    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.Attendance,
        MethodName: 'SaveAttendance',
        Arg1: dhccl.formatObjects(dailyAttendance.SavingAttendanceList),
        Arg2: session.DeptID,
        Arg3: session.UserID,
        ArgCnt: 3
    }, function(data) {
		var ret=$.trim(data);
		if(ret.indexOf("S^")==0){
			$.messager.alert("提示","保存考勤数据成功","info");
			loadAttendance();
		}else{
			$.messager.alert("提示","保存考勤数据失败，原因："+ret,"error");
		}
        
    });
    dailyAttendance.SavingAttendanceList=[];
}

/**
 * 提交考勤数据
 */
function auditAttendance() {
    $.messager.confirm('提交考勤数据', '提交之后将不允许删除考勤数据,您确定提交吗？', function(confirmed) {
        if (confirmed) {
            var userId = session.UserID;
            var auditDate = new Date().format('yyyy-MM-dd');
            var auditTime = new Date().format('HH:mm:ss');
            $.each(dailyAttendance.SavingAttendanceList, function(index, row) {
                if (!row.AuditUser && !row.isRemoved) {
                    row.AuditUser = userId;
                    row.AuditDate = auditDate;
                    row.AuditTime = auditTime;
                }
            });
            $.each(dailyAttendance.AttendanceList, function(index, row) {
                if (!row.AuditUser) {
                    row.AuditUser = userId;
                    row.AuditDate = auditDate;
                    row.AuditTime = auditTime;
                    dailyAttendance.SavingAttendanceList.push(row);
                }
            });
            saveAttendance();
        }
    });
}

/**
 * 筛选科室人员
 */
function filterCareProvider(text) {
    var groups = dailyAttendance.CareProviderGroups || [];
    var filterFields = ['Description', 'ShortDesc'];
    var upperText = text.toUpperCase();

    var length = groups.length;
    var group, itemLength, item, ifMatch,
        ifGroupMatch, fieldLength, field;
    for (var i = 0; i < length; i++) {
        group = groups[i];
        itemLength = group.items.length;
        ifGroupMatch = false;
        for (var j = 0; j < itemLength; j++) {
            item = group.items[j];
            ifMatch = false;
            fieldLength = filterFields.length;
            for (var k = 0; k < fieldLength; k++) {
                field = filterFields[k];
                if (item[field].indexOf(text) > -1 || item[field].indexOf(upperText) > -1) {
                    ifMatch = true;
                    break;
                }
            }
            if (ifMatch) {
                item.target.show();
            } else {
                item.target.hide();
            }
            ifGroupMatch = ifGroupMatch || ifMatch;
        }

        if (ifGroupMatch) {
            group.target.show();
        } else {
            group.target.hide();
        }
    }
}

/**
 * 显示考勤信息
 */
function showAttendances(data) {
    var shifts = dailyAttendance.ShiftList;
    var length = shifts.length;
    var shiftDic = {};
    for (var i = 0; i < length; i++) {
        shiftDic[shifts[i].RowId] = shifts[i];
    }

    var length = data.length;
    var element = null,
        row, matchedShift;
    for (var i = 0; i < length; i++) {
        row = data[i];
        matchedShift = shiftDic[row.Shift];
        element = $('<div class="attendance"></div>')
            .appendTo(matchedShift.content);
        attendanceview.render(element, row);
    }
}

/**
 * 初始化整个班次视图
 */
function initShiftView() {
    var groups = dailyAttendance.ShiftGroups;
    var container = dailyAttendance.ShiftContainer;
    var length = groups.length;
    var groupEl = null;
    container.hide();
    for (var i = 0; i < length; i++) {
        groupEl = $('<div class="shift-group"></div>')
            .data('data', groups[i])
            .appendTo(container);
        shiftgroupview.render(groupEl, groups[i]);
    }
    container.show();

    //设置拖拽接收区域
    $('.attendance-container').droppable({
        accept: '.careprovider-item',
        onDragEnter: function(e, source) {
            $(this).addClass('attendance-container-dragenter');
        },
        onDragLeave: function(e, source) {
            $(this).removeClass('attendance-container-dragenter');
        },
        onDrop: function(e, source) {
            var careprovider = $(source).data('data');
            var shift = $(this).data('data');
            var element = $('<div class="attendance"></div>').appendTo($(this).find('.shift-item-content'));
            var attendance = {
                RowId: '',
                AttendDate: $('#AttendDate').datebox('getValue'),
                Dept: session.DeptID,
                Member: careprovider.RowId,
                Shift: shift.RowId,
                CreateUser: session.UserID,
                MemberName: careprovider.Description
            }
            attendanceview.render(element, attendance);
            dailyAttendance.SavingAttendanceList.push(attendance);
            $(this).removeClass('attendance-container-dragenter');
        }
    });
}

/**
 * 初始化整个科室人员视图
 */
function initCareProviderView() {
    var groups = dailyAttendance.CareProviderGroups;
    var container = dailyAttendance.CareProviderContainer;
    var length = groups.length;
    var groupEl = null;
    container.hide();
    var length = groups.length;
    var groupEl;
    for (var i = 0; i < length; i++) {
        groupEl = $('<div class="careprovider-group"></div>').appendTo(container);
        careproviderGroupView.render(groupEl, groups[i]);
    }
    container.show();

    //设置拖拽人员卡片
    $('.careprovider-item').draggable({
        edge: 5,
        revert: true,
        proxy: 'clone',
        cursor: 'pointer',
        onBeforeDrag: function(e) {},
        onStartDrag: function(e) {},
        onStopDrag: function(e) {},
        onEndDrag: function(e) {}
    });
}

/**
 * 班次分组视图
 */
var shiftgroupview = {
    render: function(container, group) {
        container.data('data', group);
        group.target = container;

        $('<div class="shift-group-header"></div>')
            .append('<span class="header-text">' + (group.key || '其它') + '</span>')
            .appendTo(container);
        var itemsContainer = $('<div class="shift-group-items"></div>')
            .appendTo(container);
        var length = group.items.length;
        for (var i = 0; i < length; i++) {
            var element = $('<div class="shift-item attendance-container"></div>')
                .data('data', group.items[i])
                .appendTo(itemsContainer);
            group.items[i].target = element;
            shiftview.render(element, group.items[i]);
        }
    }
}

/**
 * 班次视图
 */
var shiftview = {
    render: function(container, item) {
        item.target = container;
        container.empty();

        $('<span class="shift-item-name"></span>')
            .text(item.StatusDesc)
            .appendTo(container);
        item.content = $('<div class="shift-item-content"></div>')
            .appendTo(container);
    }
}

/**
 * 护士分组视图
 */
var careproviderGroupView = {
    render: function(container, group) {
        container.data('data', group);
        group.target = container;

        $('<div class="careprovider-group-header"></div>')
            .append('<span class="header-text">' + group.key + '</span>')
            .appendTo(container);
        var itemsContainer = $('<div class="careprovider-group-items"></div>')
            .appendTo(container);
        var length = group.items.length;
        var element = null;
        for (var i = 0; i < length; i++) {
            element = $('<div class="careprovider-item"></div>')
                .text(group.items[i]['Description'])
                .attr('data-value', group.items[i].RowId)
                .data('data', group.items[i])
                .appendTo(itemsContainer);
            group.items[i].target = element;
        }
    }
}

/**
 * 考勤信息视图
 */
var attendanceview = {
    render: function(container, item) {
        item.target = container;
        container.data('data', item);

        container.text(item.MemberName);
        if (!item.AuditUser) {
            container.append('<span class="tagbox-remove attendance-remove" title="删除人员考勤信息"></span>');
        } else {
            container.attr('title', '已审核');
        }
    }
}