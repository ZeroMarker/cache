/**
 * 科室月排班
 * @author yongyang 20190619
 */

var crewarrange = {
    Calendar: null,
    roomList: [],
    shiftList: [],
    dailyStaffList:[],
    operStaffList:[],
    statusStaffList:[],
    SavingDailyStaffList:[],
    SavingOperStaffList:[],
    SavingStatusStaffList:[],
    historyArrangeList:[],
    loadingCalendarStatus:false
}

$(document).ready(function() {
    crewarrange.ArrangeContainer = $('#arrange_container');
    crewarrange.CareProviderContainer = $('#careprovider_container');
    crewarrange.RoomContainer = $('#room_container');
    crewarrange.ShiftContainer = $('#status_container');
    crewarrange.HistoryContainer = $('#history_container');
    crewarrange.Calendar = $('#calendar').fullCalendar({
        header:{
            left:'prev',
            center:'title',
            right:'today,next'
        }, 
        events:function(start, end, timezone, callback) {
            crewarrange.loadingCalendarStatus = true;
            $.ajax({
                url: ANCSP.DataQuery,
                type: "post",
                data: {
                    ClassName: 'DHCAN.BLL.CrewArrange',
                    QueryName: 'FindWorkdays',
                    Arg1: start.format(),
                    Arg2: end.format(),
                    ArgCnt: 2
                },
                dataType: "json",
                success: function(data) {
                    renderCalendar(data);
                    crewarrange.loadingCalendarStatus = false;
                    if(crewarrange.renderingDailyStaff)
                        renderDailyStaff();
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    alert("error");
                    crewarrange.loadingCalendarStatus = false;
                }
            });
        }
    });

    crewarrange.editview = editview;
    crewarrange.editview.init();

    initClickHandler();
    loadArrangements();
    loadOperRoom();
    loadCrewShift();
    loadCareproviders();
    initSearchBox();
});

function initClickHandler(){
    $('#btn_new').linkbutton({
        onClick:function(){
            crewarrange.editview.render();
            crewarrange.editview.open();
        }
    });

    $('#btn_add').click(function(){
        crewarrange.editview.render();
        crewarrange.editview.open();
    });

    $('#btn_modify').linkbutton({
        onClick:function(){
            crewarrange.editview.render(crewarrange.currentArrangement);
            crewarrange.editview.open();
        }
    });

    $('#btn_save').linkbutton({
        onClick:function(){
            var savingDataList=[];
            var CrewArrangeId=crewarrange.currentArrangement.RowId;
            $.each(crewarrange.SavingDailyStaffList, function(index, row) {
                row.CrewArrange = CrewArrangeId;
                row.ClassName = 'DHCAN.Model.ArrangedDailyStaff';
                if(row.RowId || !row.isRemoved) savingDataList.push(row);
            });
            $.each(crewarrange.SavingOperStaffList, function(index, row) {
                row.CrewArrange = CrewArrangeId;
                row.ClassName = 'DHCAN.Model.ArrangedOperStaff';
                if(row.RowId || !row.isRemoved) savingDataList.push(row);
            });
            $.each(crewarrange.SavingStatusStaffList, function(index, row) {
                row.CrewArrange = CrewArrangeId;
                row.ClassName = 'DHCAN.Model.ArrangedStatusStaff';
                if(row.RowId || !row.isRemoved) savingDataList.push(row);
            });
            
            savingDataList.push({
                RowId:CrewArrangeId,
                Note:$('#txt_arrange_note').val(),
                ClassName:'DHCAN.Model.CrewArrange'
            });
            crewarrange.currentArrangement.Note = $('#txt_arrange_note').val();

            $('#btn_save').linkbutton('disable');
            dhccl.saveDatas(ANCSP.MethodService, {
                ClassName: 'DHCAN.BLL.CrewArrange',
                MethodName: 'SaveCrewArrange',
                Arg1: dhccl.formatObjects(savingDataList),
                Arg2: session.DeptID,
                Arg3: session.UserID,
                ArgCnt: 3
            }, function(data) {
                if(data.indexOf('S^')>-1){
                    loadArrangeDetails();
                }
                dhccl.showMessage(data,'保存');
                $('#btn_save').linkbutton('enable');
            });
            crewarrange.SavingDailyStaffList=[];
            crewarrange.SavingOperStaffList=[];
            crewarrange.SavingStatusStaffList=[];
        }
    });

    $('#btn_generate').linkbutton({
        onClick:function(){
            var CrewArrangeId=crewarrange.currentArrangement.RowId;
            dhccl.saveDatas(ANCSP.MethodService, {
                ClassName: 'DHCAN.BLL.CrewArrange',
                MethodName: 'GenerateCrewArrange',
                Arg1: CrewArrangeId,
                Arg2: session.UserID,
                ArgCnt: 2
            }, function(data) {
                reloadCurrentArrange();
                loadArrangeDetails();
            });
        }
    });

    crewarrange.ArrangeContainer.delegate('div.arrangement-i','click',function(){
        crewarrange.ArrangeContainer.find('.arrangement-i-selected').removeClass('arrangement-i-selected');
        $(this).addClass('arrangement-i-selected');

        $('#btn_new').hide();
        $('#btn_modify').show();
        $('#btn_save').show();
        $('#btn_generate').show();
        $('#btn_generate').linkbutton('enable');
        var arrangement = $(this).data('data');
        crewarrange.currentArrangement = arrangement;
        loadArrangeDetails();

        $('#txt_arrange_note').val(arrangement.Note);
    });

    crewarrange.Calendar.delegate('.arranged-staff-remove','click',function(){
        var element = $(this).parent();
        var staff = $(element).data('data');
        staff.isRemoved = 'Y';
        if (staff.RowId) crewarrange.SavingDailyStaffList.push(staff);
        element.remove();
    });

    crewarrange.Calendar.delegate('.arranged-staff-i','dblclick',function(){
        var element = $(this);
        var staff = $(element).data('data');
        staff.isRemoved = 'Y';
        if (staff.RowId) crewarrange.SavingDailyStaffList.push(staff);
        element.remove();
    });

    crewarrange.RoomContainer.delegate('.arranged-staff-remove','click',function(){
        var element = $(this).parent();
        var staff = $(element).data('data');
        staff.isRemoved = 'Y';
        if (staff.RowId) crewarrange.SavingOperStaffList.push(staff);
        element.remove();
    });

    crewarrange.RoomContainer.delegate('.arranged-staff-i','dblclick',function(){
        var element = $(this);
        var staff = $(element).data('data');
        staff.isRemoved = 'Y';
        if (staff.RowId) crewarrange.SavingOperStaffList.push(staff);
        element.remove();
    });

    crewarrange.ShiftContainer.delegate('.arranged-staff-remove','click',function(){
        var element = $(this).parent();
        var staff = $(element).data('data');
        staff.isRemoved = 'Y';
        if (staff.RowId) crewarrange.SavingStatusStaffList.push(staff);
        element.remove();
    });

    crewarrange.ShiftContainer.delegate('.arranged-staff-i','dblclick',function(){
        var element = $(this);
        var staff = $(element).data('data');
        staff.isRemoved = 'Y';
        if (staff.RowId) crewarrange.SavingStatusStaffList.push(staff);
        element.remove();
    });

    crewarrange.HistoryContainer.delegate('a.btn-arrange-history','click',function(){
        $(this).toggleClass('btn-arrange-history-on');
        var arrange = $(this).data('data');
        if($(this).hasClass('btn-arrange-history-on')){
            showOperStaffHistory(arrange);
        }
        else{
            hideOperStaffHistory(arrange);
        }
    });
}

/**
 * 编辑框
 */
var editview = {
    init: function(callback) {
        this.callback = callback;
        var _this = this;
        this.dom = $('<div></div>').appendTo('body');
        this.initForm();

        var buttons = $('<div></div>');
        var btn_save = $('<a href="#"></a>').linkbutton({
            text: '保存',
            iconCls: 'icon-save',
            onClick: function() {
                _this.save();
            }
        }).appendTo(buttons);
        var btn_cancel = $('<a href="#"></a>').linkbutton({
            text: '取消',
            iconCls: 'icon-cancel',
            onClick: function() {
                _this.close();
            }
        }).appendTo(buttons);
        this.dom.dialog({
            left: 360,
            top: 120,
            height: 230,
            width: 340,
            title: '排班记录',
            modal: true,
            closed: true,
            buttons: buttons,
            onOpen: function() {

            },
            onClose: function() {
                _this.clear();
            }
        });
    },
    initForm: function() {
        this.form = $('<form class="editview-form"></form>').appendTo(this.dom);
        this.form.form({});

        this.RowId = $('<input type="hidden" name="RowId">').appendTo(this.form);

        var row = $('<div class="editview-f-r"></div>').appendTo(this.form);
        var label = $('<div class="label">显示名称：</div>').appendTo(row);
        this.Description = $('<input class="textbox" type="text" name="Description" style="width:173px;">').appendTo(row);
        this.Description.validatebox({
            width: 180,
            required:true,
            label: label
        });

        var row = $('<div class="editview-f-r"></div>').appendTo(this.form);
        var label = $('<div class="label">开始日期：</div>').appendTo(row);
        this.StartDate = $('<input class="textbox" type="text" name="StartDate" style="">').appendTo(row);
        this.StartDate.datebox({
            width: 180,
            required:true,
            label: label
        });

        var row = $('<div class="editview-f-r"></div>').appendTo(this.form);
        var label = $('<div class="label">结束日期：</div>').appendTo(row);
        this.EndDate = $('<input class="textbox" type="text" name="EndDate" style="">').appendTo(row);
        this.EndDate.datebox({
            width: 180,
            required:true,
            label: label
        });
    },
    render: function(data) {
        if (data) {
            this.dom.dialog('setTitle', '编辑排班记录-' + data.Description);
            this.originalData = data;
            this.RowId.val(data.RowId);
            this.Description.val(data.Description);
            this.StartDate.datebox("setValue",data.StartDate);
            this.EndDate.datebox("setValue",data.EndDate);
        } else {
            this.dom.dialog('setTitle', '新建排班记录');
        }
    },
    open: function() {
        this.dom.dialog('open');
    },
    close: function() {
        this.dom.dialog('close');
    },
    clear: function() {
        this.form.form('clear');
        this.originalData=null;
    },
    setDefaultValues: function(params) {

    },
    save: function() {
        var data = this.toData();
        if (this.originalData) $.extend(this.originalData, data);
        dhccl.saveDatas(ANCSP.MethodService, {
            ClassName: 'DHCAN.BLL.CrewArrange',
            MethodName: 'SaveCrewArrange',
            Arg1: dhccl.formatObject(data),
            Arg2: session.DeptID,
            Arg3: session.UserID,
            ArgCnt: 3
        }, function(ret) {
            if (ret.indexOf("S^") === 0) {
                loadArrangements(function(data){
                    var length = data.length;
                    if(length>0 && !crewarrange.currentArrangement){
                        data[length-1].target.trigger('click');
                    }
                });
            } else {
                dhccl.showMessage(ret, "保存排班记录");
            }
        });
        this.close();
    },
    /**
     * 转换为数据
     */
    toData: function() {
        return {
            Dept:session.DeptID,
            Description: this.Description.val(),
            StartDate: this.StartDate.datebox("getValue"),
            EndDate: this.EndDate.datebox("getValue"),
            CreateUser:session.UserID,
            ClassName:'DHCAN.Model.CrewArrange'
        }
    }
}

/**
 * 加载排班历史列表
 */
function loadArrangements(callback){
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: 'DHCAN.BLL.DataQueries',
        QueryName: 'FindCrewArrange',
        Arg1: session.DeptID,
        ArgCnt: 1
    }, 'json', true, function(data) {
        crewarrange.arrangeList = data;
        var length = data.length;
        var element = null;
        var container = crewarrange.ArrangeContainer;
        container.empty();
        for (var i = 0; i < length; i++) {
            element = $('<div class="arrangement-i"></div>')
                .text(data[i]['Description'])
                .attr('data-value', data[i].RowId)
                .data('data', data[i])
                .appendTo(container);
            data[i].target = element;
        }

        if(callback) callback(data);
    });
}

/**
 * 重新加载当前排班历史
 */
function reloadCurrentArrange(){
    var arrangement = crewarrange.currentArrangement;
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: 'DHCAN.BLL.DataQueries',
        QueryName: 'FindCrewArrange',
        Arg1: session.DeptID,
        Arg2: '',
        Arg3: arrangement.RowId,
        ArgCnt: 3
    }, 'json', true, function(data) {
        var row = data[0];
        $.extend(arrangement,row);
        $('#txt_arrange_note').val(arrangement.Note);
    });
}

/**
 * 加载安排明细
 */
function loadArrangeDetails(){
    clearDetails();

    setArrangeHistory();
    setCalendar();
    loadDailyStaff();
    loadRoomStaff();
    loadStatusStaff();
}

/**
 * 清空明细
 */
function clearDetails(){
    $('.arrange-crewcontainer').empty();
    $('.room-i-staffcontainer').empty();
    $('.shift-i-content').empty();
    
    crewarrange.dailyStaffList=[];
    crewarrange.operStaffList=[];
    crewarrange.statusStaffList=[];

    crewarrange.SavingDailyStaffList=[];
    crewarrange.SavingOperStaffList=[];
    crewarrange.SavingStatusStaffList=[];
}

/**
 * 设置日历
 */
function setCalendar(){
    var startDate = crewarrange.currentArrangement.StartDate;
    crewarrange.Calendar.fullCalendar('gotoDate',startDate);
}

/**
 * 重新渲染日历视图
 */
function renderCalendar(workdays){
    var cellList = {};
    $.each($('.fc-bg td.fc-day'),function(index,dayCell){
        var date = $(dayCell).attr('data-date');
        cellList[date] = $(dayCell);
    });

    var length = workdays.length;
    var cell,workday;
    for(var i=0;i<length;i++){
        workday = workdays[i];
        cell = cellList[workday.DayDate];
        if(cell) {
            calendarview.render(cell,workday);
        }
    }

    $('.arrange-crewcontainer').droppable({
        accept: '.careprovider-item',
        onDragEnter: function(e, source) {
            $(this).addClass('event-container-dragenter');
        },
        onDragLeave: function(e, source) {
            $(this).removeClass('event-container-dragenter');
        },
        onDrop: function(e, source) {
            var date = $(this).attr('data-date');
            var type = $(this).attr('data-type');
            var careprovider;
            var data = {};

            if ($(source).hasClass('arranged-staff-i')){
                data = $(source).data('data');
                $.extend(data,{
                    DayDate:date,
                    Type:type
                });
                $(source).remove();
            }
            else {
                careprovider = $(source).data('data');
                data = {
                    RowId:'',
                    DayDate:date,
                    Member:careprovider.RowId,
                    Type:type,
                    Shift: '',
                    CreateUser: session.UserID,
                    MemberName: careprovider.Description
                }
                if(hasExistedMember($(this),data.Member)) return;
            }

            
            var element = $('<span class="careprovider-item arranged-staff-i"></span>').appendTo($(this));
            arrangedStaffView.render(element,data);

            if(crewarrange.SavingDailyStaffList.indexOf(data)<0)
                crewarrange.SavingDailyStaffList.push(data);
            if(crewarrange.dailyStaffList.indexOf(data)<0)
                crewarrange.dailyStaffList.push(data);
            $(this).removeClass('event-container-dragenter');
        }
    });
}

/**
 * 判断是否重复
 */
function hasExistedMember(container,member){
    var result = false;
    var memberId;
    $(container).find('.arranged-staff-i').each(function(index,e){
        memberId = $(e).attr('data-member');
        if(memberId==member){
            result = true;
            return false;
        }
    });

    return result;
}

var calendarview = {
    /**
     * 渲染日历视图
     * @param {*} cell     单元格
     * @param {*} workday  工作日对象
     */
    render: function(cell, workday) {
        $('<div class="arrange-dayheader"></div>')
        .text(workday.Description)
        .addClass(workday.DayType=='ON'?'arrange-workday':'arrange-holiday')
        .appendTo(cell);

        if(workday.DayType=='ON'){
            $('<div class="arrange-crewcontainer"></div>')
            .addClass('arrange-crewcontainer-workday')
            .attr('data-date',workday.DayDate)
            .attr('data-type','N')
            .appendTo(cell);
        }
        else{
            $('<div class="arrange-crewcontainer"></div>')
            .addClass('arrange-crewcontainer-holiday')
            .attr('data-date',workday.DayDate)
            .attr('data-type','D')
            .appendTo(cell);

            $('<div class="arrange-crewcontainer"></div>')
            .addClass('arrange-crewcontainer-holiday')
            .attr('data-date',workday.DayDate)
            .attr('data-type','N')
            .appendTo(cell);
        }
    }
}

/**
 * 已安排人员
 */
var arrangedStaffView={
    render:function(container,item){
        container.empty();
        container.data('data',item);
        item.target = container;

        container.text(item.MemberName).attr('data-member',item.Member);
        container.append('<span class="tagbox-remove arranged-staff-remove" title="删除人员安排信息">×</span>');

        $(container).draggable({
            edge: 5,
            revert: true,
            proxy: proxy,
            cursor: 'pointer',
            onBeforeDrag: function(e) {},
            onStartDrag: function(e) {
                $(this).addClass('arranged-staff-dragging');
            },
            onStopDrag: function(e) {
                $(this).css({ left: 0, top: 0 });
            },
            onEndDrag: function(e) {
                $(this).css({ left: 0, top: 0 });
                $(this).removeClass('arranged-staff-dragging');
            }
        });
    }
}

/**
 * 加载每日值班表
 */
function loadDailyStaff(){
    var arrangeId=crewarrange.currentArrangement.RowId;
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: 'DHCAN.BLL.DataQueries',
        QueryName: 'FindArrangedDailyStaff',
        Arg1: arrangeId,
        ArgCnt: 1
    }, 'json', true, function(data) {
        crewarrange.dailyStaffList = data;
        crewarrange.renderingDailyStaff = true;
        if(!crewarrange.loadingCalendarStatus) renderDailyStaff();
        if(data.length>0){
            $('#btn_generate').linkbutton('disable');
        }
    });
}

function renderDailyStaff(){
    crewarrange.renderingDailyStaff = false;
    var cellList = {};
    $.each($('.fc-bg td.fc-day'),function(index,dayCell){
        var date = $(dayCell).attr('data-date');
        cellList[date] = $(dayCell);
    });

    var data = crewarrange.dailyStaffList;
    var length = data.length;
    var row,cell,date,container,element;
    for(var i=0;i<length;i++){
        row = data[i];
        date = row.DayDate;
        cell = cellList[date];
        if(cell){
            container = cell.find('.arrange-crewcontainer[data-type="'+row.Type+'"]');
            if(container) {
                element = $('<span class="careprovider-item arranged-staff-i"></span>').appendTo(container);
                arrangedStaffView.render(element,row);
            }
        }
    }
}

/**
 * 加载手术间人员
 */
function loadRoomStaff(){
    var arrangeId=crewarrange.currentArrangement.RowId;
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: 'DHCAN.BLL.DataQueries',
        QueryName: 'FindArrangedOperStaff',
        Arg1: arrangeId,
        ArgCnt: 1
    }, 'json', true, function(data) {
        crewarrange.operStaffList = data;
        renderOperStaff();
        if(data.length>0){
            $('#btn_generate').linkbutton('disable');
        }
    });
}

function renderOperStaff(){
    var roomList = {}, flexList = {};
    $.each(crewarrange.RoomContainer.find('.room-i'),function(index,room){
        var rowId = $(room).attr('data-rowid');
        var type = $(room).attr('data-type');
        var seq = $(room).attr('data-seq');
        if (type=='R') roomList[rowId] = $(room);
        else if(type=='F') flexList[seq] = $(room);
    });

    var data = crewarrange.operStaffList;
    var length = data.length;
    var row,room,roomId,container,element;
    for(var i=0;i<length;i++){
        row = data[i];
        roomId = row.OperRoom;
        type = row.Type;
        seq = row.Sequence;

        room = null;
        if (type=='R') room = roomList[roomId];
        else if(type=='F') room = flexList[seq];
        
        if(room){
            container = room.find('.room-i-staffcontainer');
            if(container) {
                element = $('<span class="careprovider-item arranged-staff-i"></span>').appendTo(container);
                arrangedStaffView.render(element,row);
            }
        }
    }
}

/**
 * 加载其它外围人员
 */
function loadStatusStaff(){
    var arrangeId=crewarrange.currentArrangement.RowId;
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: 'DHCAN.BLL.DataQueries',
        QueryName: 'FindArrangedStatusStaff',
        Arg1: arrangeId,
        ArgCnt: 1
    }, 'json', true, function(data) {
        crewarrange.statusStaffList = data;
        renderStatusStaff();
        if(data.length>0){
            $('#btn_generate').linkbutton('disable');
        }
    });
}

function renderStatusStaff(){
    var shiftList = {};
    $.each(crewarrange.ShiftContainer.find('.shift-i'),function(index,shift){
        var rowId = $(shift).attr('data-rowid');
        shiftList[rowId] = $(shift);
    });

    var data = crewarrange.statusStaffList;
    var length = data.length;
    var row,room,shiftId,container,element;
    for(var i=0;i<length;i++){
        row = data[i];
        shiftId = row.Shift;
        shift = shiftList[shiftId];
        if(shift){
            container = shift.find('.shift-i-content');
            if(container) {
                element = $('<span class="careprovider-item arranged-staff-i"></span>').appendTo(container);
                arrangedStaffView.render(element,row);
            }
        }
    }
}

/**
 * 手术间排班可点击显示历史记录
 */
function setArrangeHistory(){
    if(!crewarrange.currentArrangement) return;

    var currentIndex = crewarrange.arrangeList.indexOf(crewarrange.currentArrangement);
    var container = crewarrange.HistoryContainer;
    var element,arrange;
    container.empty();
    crewarrange.historyArrangeList = [];
    for(var i=currentIndex-2;i<currentIndex;i++){
        if(i<0) continue;
        arrange = crewarrange.arrangeList[i];
        element = $('<a href="#" class="btn-arrange-history"></a>')
        .attr('data-seq',i)
        .data('data',arrange)
        .text(arrange.Description)
        .appendTo(container);

        crewarrange.historyArrangeList.push(arrange);
    }
}

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
 * 加载医护人员
 */
function loadCareproviders(){

    /// 加载人员
    /// -> 按首字母分组
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: 'DHCCL.BLL.Admission',
        QueryName: 'FindCareProvByLoc',
        Arg1: '',
        Arg2: session.DeptID,
        ArgCnt: 2
    }, 'json', true, function(data) {
        crewarrange.CareProviderList = data;
        crewarrange.CareProviderGroups = groupingData(data, 'FirstChar');
        initCareProviderView();
    });
}



/**
 * 筛选科室人员
 */
function filterCareProvider(text) {
    var groups = crewarrange.CareProviderGroups || [];
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
 * 初始化整个科室人员视图
 */
function initCareProviderView() {
    var groups = crewarrange.CareProviderGroups;
    var container = crewarrange.CareProviderContainer;
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
 * 加载手术间
 */
function loadOperRoom() {
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: 'DHCAN.BLL.ConfigQueries',
        QueryName: 'FindOperRoom',
        Arg1: "",
        Arg2: "R",
        ArgCnt: 2
    }, 'json', true, function(data) {
        if (data) {
            crewarrange.roomList = data;
            initRoomView();
        }
    });
}

/**
 * 渲染手术间区域视图
 */
function initRoomView(){
    var data = crewarrange.roomList;
    var container = crewarrange.RoomContainer;

    var floors = groupingData(data, 'OperFloor');
    var floor,room,itemLength;
    var length = floors.length;
    var roomCount = 0, flexSeq = 0, flexData;
    for(var i = 0;i<length;i++){
        floor = floors[i];
        itemLength = floor.items.length;
        for(var j = 0;j<itemLength;j++){
            room = floor.items[j];
            var element = $('<div class="room-i"></div>').appendTo(container);
            if(i%2>0) element.addClass('room-i-alter');
            element.attr('data-type','R');
            roomview.render(element,room);
            roomCount ++;
            if(roomCount%3==0){
                flexSeq ++;
                flexData = {
                    RowId:'',
                    Sequence:flexSeq,
                    Type:'F',
                    Description:'机动',
                    OperFloorDesc:''
                }

                var element = $('<div class="room-i"></div>').appendTo(container);
                if(i%2>0) element.addClass('room-i-alter');
                element.attr('data-type','F');
                element.attr('data-seq',flexSeq);
                roomview.render(element,flexData);
            }
        }
    }

    $('.room-i-staffcontainer').droppable({
        accept: '.careprovider-item',
        onDragEnter: function(e, source) {
            $(this).addClass('event-container-dragenter');
        },
        onDragLeave: function(e, source) {
            $(this).removeClass('event-container-dragenter');
        },
        onDrop: function(e, source) {
            var parent = $($(this).parent().parent());
            var room = parent.data('data');
            var type = parent.attr('data-type');
            var sequence = parent.attr('data-seq');
            var data={};

            if ($(source).hasClass('arranged-staff-i')){
                data = $(source).data('data');
                $.extend(data,{
                    OperRoom:room.RowId,
                    OperRoomDesc: room.Description,
                    Type:type,
                    Sequence:sequence || ''
                });
                $(source).remove();
            }
            else if($(source).hasClass('arranged-staff-i-history')){
                var historyData = $(source).data('data');
                data =  {
                    RowId:'',
                    Member:historyData.Member,
                    OperRoom:room.RowId,
                    OperRoomDesc: room.Description,
                    CreateUser: session.UserID,
                    MemberName: historyData.MemberName,
                    Type:type,
                    Sequence:sequence || ''
                }
                if(hasExistedMember($(this),data.Member)) return;
            }
            else {
                var careprovider = $(source).data('data');
                data =  {
                    RowId:'',
                    Member:careprovider.RowId,
                    OperRoom:room.RowId,
                    OperRoomDesc: room.Description,
                    CreateUser: session.UserID,
                    MemberName: careprovider.Description,
                    Type:type,
                    Sequence:sequence || ''
                }
                if(hasExistedMember($(this),data.Member)) return;
            }

            var element = $('<span class="careprovider-item arranged-staff-i"></span>').appendTo($(this));
            arrangedStaffView.render(element,data);

            if(crewarrange.SavingOperStaffList.indexOf(data)<0) 
                crewarrange.SavingOperStaffList.push(data);
            $(this).removeClass('event-container-dragenter');
        }
    });
}

/**
 * 手术间视图
 */
var roomview = {
    render: function(container, room) {
        container.empty();
        container.data('data', room);
        container.attr('data-rowid', room.RowId);

        var header = $('<div class="room-i-header"></div>').appendTo(container);
        var content = $('<div class="room-i-content hisui-tooltip" data-options="position:\'top\'"></div>').appendTo(container);
        var staffcontainer = $('<div class="room-i-staffcontainer"></div>').appendTo(content);

        $('<span class="room-header-text"></span>').text(room.Description).appendTo(header);
        $('<span class="room-header-badge"></span>').text(room.OperFloorDesc).appendTo(header);
    }
};

/**
 * 显示手术间排班历史
 */
function showOperStaffHistory(arrange){
    var index = crewarrange.historyArrangeList.indexOf(arrange);
    var nextIndex = index + 1;
    var nextArrange = crewarrange.historyArrangeList[nextIndex];
    var historyWidth = 60;
    $.each(crewarrange.RoomContainer.find('.room-i'),function(index,room){
        var content = $(room).find('.room-i-content');
        var historyContainer = $('<div class="room-i-content-history"></div>')
        .attr('data-rowid',arrange.RowId);
        var staffContainer = $(content).find('.room-i-staffcontainer');
        var nextContainer = staffContainer;
        if(nextArrange){
            nextContainer = $(content).find('.room-i-content-history[data-rowid="'+nextArrange.RowId+'"]');
        }
        if(nextContainer.length<1) nextContainer = staffContainer;

        var width = content.width();
        nextContainer.before(historyContainer);
        historyContainer.width(historyWidth - 10);
        var historyCount = $(content).find('.room-i-content-history').length;
        staffContainer.width(width - (historyWidth*historyCount) - 10 - (2*historyCount));
    });

    loadOperStaffHistory(arrange);
}

/**
 * 加载手术间排班历史
 * @param {*} arrange 
 */
function loadOperStaffHistory(arrange){
    var arrangeId=arrange.RowId;
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: 'DHCAN.BLL.DataQueries',
        QueryName: 'FindArrangedOperStaff',
        Arg1: arrangeId,
        ArgCnt: 1
    }, 'json', true, function(data) {
        renderOperStaffHistory(data);
    });
}

/**
 * 渲染手术间排班历史
 * @param {*} data 
 */
function renderOperStaffHistory(data){
    var roomList = {}, flexList = {};
    $.each(crewarrange.RoomContainer.find('.room-i'),function(index,room){
        var rowId = $(room).attr('data-rowid');
        var type = $(room).attr('data-type');
        var seq = $(room).attr('data-seq');
        if (type=='R') roomList[rowId] = $(room);
        else if(type=='F') flexList[seq] = $(room);
    });

    var length = data.length;
    var row,room,roomId,container,element;
    for(var i=0;i<length;i++){
        row = data[i];
        roomId = row.OperRoom;
        type = row.Type;
        seq = row.Sequence;

        room = null;
        if (type=='R') room = roomList[roomId];
        else if(type=='F') room = flexList[seq];
        
        if(room){
            container = room.find('.room-i-content-history[data-rowid="'+row.CrewArrange+'"]');
            if(container) {
                element = $('<span class="careprovider-item arranged-staff-i-history"></span>').appendTo(container);
                arrangedStaffView.render(element,row);
            }
        }
    }
}

/**
 * 隐藏手术间排班历史
 */
function hideOperStaffHistory(arrange){
    var historyWidth = 60;
    $.each(crewarrange.RoomContainer.find('.room-i'),function(index,room){
        var content = $(room).find('.room-i-content');
        var historyContainer = $(content).find('.room-i-content-history[data-rowid="'+arrange.RowId+'"]');
        historyContainer.remove();

        var staffContainer = $(content).find('.room-i-staffcontainer');
        var historyCount = $(content).find('.room-i-content-history').length;
        var width = content.width();
        staffContainer.width(width - (historyWidth*historyCount) - 10 - (2*historyCount));
    });
}

/**
 * 加载其它人员安排
 */
function loadCrewShift(){
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: 'DHCAN.BLL.ConfigQueries',
        QueryName: 'FindCrewShift',
        Arg1:session.DeptID,
        Arg2:'Y',
        Arg3:'M',
        ArgCnt: 3
    }, 'json', true, function(data) {
        if (data) {
            crewarrange.shiftList = data;
            initShiftView();
        }
    });
}

function initShiftView(){
    var data = crewarrange.shiftList;
    var length,group,groupEl,itemsContainer,element,headertext;
    var container = crewarrange.ShiftContainer;
    var shiftgroups = groupingData(data,'Floor');
    var groupLength =shiftgroups.length;

    for(var k=0;k<groupLength;k++){
        group = shiftgroups[k];
        groupEl = $('<div class="shift-group"></div>').appendTo(container);
        headertext = group.items[0].FloorDesc;
        if(!group.key) groupEl.addClass('shift-group-null');
        $('<div class="shift-group-header"></div>')
            .append('<span class="header-text">' + headertext + '</span>')
            .appendTo(groupEl);
        itemsContainer = $('<div class="shift-group-items"></div>')
            .appendTo(groupEl);
        length=group.items.length;
        for(var i = 0;i<length;i++){
            element = $('<div class="shift-i"></div>').appendTo(itemsContainer);
            shiftview.render(element,group.items[i]);
        }
    }

    $('.shift-i-content').droppable({
        accept: '.careprovider-item',
        onDragEnter: function(e, source) {
            $(this).addClass('event-container-dragenter');
        },
        onDragLeave: function(e, source) {
            $(this).removeClass('event-container-dragenter');
        },
        onDrop: function(e, source) {
            var shift = $($(this).parent()).data('data');
            var careprovider;
            var data={};

            if ($(source).hasClass('arranged-staff-i')){
                data = $(source).data('data');
                $.extend(data,{
                    Shift:shift.RowId
                });
                $(source).remove();
            }
            else {
                careprovider = $(source).data('data');
                data = {
                    RowId:'',
                    Member:careprovider.RowId,
                    Shift:shift.RowId,
                    CreateUser: session.UserID,
                    MemberName: careprovider.Description
                }
                if(hasExistedMember($(this),data.Member)) return;
            }

            var element = $('<span class="careprovider-item arranged-staff-i"></span>').appendTo($(this));
            arrangedStaffView.render(element,data);

            if(crewarrange.SavingStatusStaffList.indexOf(data)<0)
                crewarrange.SavingStatusStaffList.push(data);
            $(this).removeClass('event-container-dragenter');
        }
    });
}

/**
 * 其它人员安排渲染
 */
var shiftview = {
    render: function(container, item) {
        item.target = container;
        container.empty();
        container.data('data',item);
        container.attr('data-rowid', item.RowId);

        $('<span class="shift-i-name"></span>')
            .text(item.StatusDesc)
            .appendTo(container);
        item.content = $('<div class="shift-i-content"></div>')
            .appendTo(container);
    }
}

/**
 * 卡片拖动的代理
 * @param {HTMLElement} source 
 */
function proxy(source) {
    var p = $('<div style="z-index:20000;position:absolute;" class="careprovider-item arranged-staff-i"></div>');
    p.css({ 
        top:0,
        left:0
    });
    p.html($(source).clone().html()).appendTo('body');
    return p;
}