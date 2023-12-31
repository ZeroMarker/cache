/**
 *  过程监控的数据对象
 */

function RecordContext() {
    this.displayAreas = null;

    this.contexturl = "../service/dhcanop/data/realtimemonitor.json";

    this.init();
}


RecordContext.prototype = {
    constructor: RecordContext,
    /**
     * 初始化
     */
    init: function() {

        var context = null;
        $.ajaxSettings.async = false;
        $.getJSON(this.contexturl + "?random=" + Math.random(), function(data) {
            context = data;
        });
        $.ajaxSettings.async = true;

        if (context) {
            for (var key in context) {
                this[key] = context[key];
            }
        }

        this.initStartEndDT();
        this.loadOperRooms();
        this.loadOperSchedules(this.startDateTime, this.endDateTime);
    },
    /**
     * 初始化开始结束时间 当日8点到次日8点
     */
    initStartEndDT: function() {
        var currentTime = new Date();
        var hour = currentTime.getHours();
        var minute = currentTime.getMinutes();
        var second = currentTime.getSeconds();
        currentTime.setHours(8);
        currentTime.setMinutes(0);
        currentTime.setSeconds(0);
        this.startDateTime = currentTime;

        var nextTime = new Date();
        var date = nextTime.getDate();
        var hour = nextTime.getHours();
        var minute = nextTime.getMinutes();
        var second = nextTime.getSeconds();
        nextTime.setDate(date + 1);
        nextTime.setHours(8);
        nextTime.setMinutes(0);
        nextTime.setSeconds(0);
        this.endDateTime = nextTime;

        var timeArea = this.displayAreas.timeArea;
        timeArea.StartDT = this.startDateTime;
        timeArea.EndDT = this.endDateTime;
    },
    /**
     * 加载手术间
     */
    loadOperRooms: function() {
        var _this = this;
        this.operRooms = dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: 'CIS.AN.BL.ConfigQueries',
            QueryName: 'FindOperRoom',
            Arg1: '',
            Arg2: 'R',
            ArgCnt: 2
        }, 'json', false,function(data){
            _this.operRooms = data;
            _this.roomGroups = groupingData(_this.operRooms, {
                key: 'OperFloor',
                textField: 'OperFloorDesc'
            }, '');

            var roomArea = _this.displayAreas.roomArea;
            roomArea.operRoomDic = {};
            $.each(_this.operRooms,function(index,room){
                roomArea.operRoomDic[room.RowId]=room;
            })
        });
    },
    /**
     * 加载手术
     * @param {Date} startDateTime 
     * @param {Date} endDateTime 
     * @param {function} callback 
     */
    loadOperSchedules: function(startDateTime, endDateTime, callback) {
        var _this = this;

        dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: 'DHCAN.BLL.RealTimeMonitor',
            QueryName: 'FindProcessOper',
            Arg1: startDateTime.format('yyyy-MM-dd HH:mm:ss'),
            Arg2: endDateTime.format('yyyy-MM-dd HH:mm:ss'),
            ArgCnt: 2
        }, 'json', false, function(data) {
            _this.operSchedules = data;
            _this.regulateOperSchedules();
            var operArea = _this.displayAreas.operArea;
            operArea.schedules = data;
            if (callback) callback(data);
        });
    },
    /**
     * 处理手术数据
     */
    regulateOperSchedules: function() {
        var roomArea = this.displayAreas.roomArea;
        var roomDic = roomArea.operRoomDic;

        for(var key in roomDic){
            roomDic[key].schedules = [];
        }

        var length = this.operSchedules.length;
        var schedule = null;
        for (var i = 0; i < length; i++) {
            schedule = this.operSchedules[i];
            if (roomDic[schedule.OperRoom]) {
                if (!roomDic[schedule.OperRoom].schedules) roomDic[schedule.OperRoom].schedules = [];
                roomDic[schedule.OperRoom].schedules.push(schedule);
            }
        }
    },
    /**
     * 加载输血相关信息
     */
    loadBloodTransfusion: function() {

    },
    /**
     * 加载感染
     */
    loadInfected: function() {

    },
    /**
     * 加载压疮
     */
    loadPressureSore: function() {

    }
}

/**
 * 对数据进行分组
 * @param {Array<object>} rows 
 * @param {String} groupField 
 * @param {String} sortField 
 */
function groupingData(rows, groupBy, sortField) {
    var groups = {};
    var dataGroups = [];
    var excepted = [];

    var length = rows.length;
    for (var i = 0; i < length; i++) {
        var row = rows[i];
        var groupIndexText = row[groupBy.textField];
        if (groupIndexText) {
            var groupIndex = row[groupBy.key];
            if (!groups[groupIndex]) groups[groupIndex] = [];
            groups[groupIndex].push(row);
        } else {
            excepted.push(row);
        }
    }

    var sortBy = sortField;
    for (var groupIndex in groups) {
        dataGroups.push({
            key: groupIndex,
            text: groups[groupIndex][0][groupBy.textField],
            rows: sortData(groups[groupIndex], sortBy || '')
        });
    }

    if (excepted.length > 0) {
        dataGroups.push({
            key: '',
            text: groupBy.exceptedText,
            rows: excepted
        })
    }

    return dataGroups;
}

/**
 * 排序(简单模式，按数字排序)
 * @param {Array<object>} data
 * @param {string} field 
 */
function sortData(data, field) {
    if (field) {
        var sorts = {};
        var sorted = [];
        var length = data.length;
        sorted = data.sort(compareInstance(field));
        return sorted;
    } else {
        return data;
    }
}

/**
 * 排序实例 
 */
function compareInstance(field) {
    return function(row1, row2) {
        var value1 = row1[field];
        var value2 = row2[field];
        if (value1 == '' || value1 == 'All') {
            return 1;
        } else if (value2 == '' || value2 == 'All') {
            return -1;
        } else if (Number(value1) > Number(value2)) {
            return 1;
        } else {
            return -1;
        }

    }
}