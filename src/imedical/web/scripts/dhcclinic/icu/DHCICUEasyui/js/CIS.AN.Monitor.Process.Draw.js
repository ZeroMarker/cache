/**
 *  过程监控的绘制对象
 */

function RecordSheet(canvasEl, context) {
    this.canvasEl = canvasEl;
    this.canvas = canvasEl.getContext("2d");
    this.context = context;
    this.init();
}

RecordSheet.prototype = {
    constructor: RecordSheet,
    init: function() {
        // 鼠标点击对象
        this.clickInfo = {
            location: null,
            area: null,
            operSchedule: null,
            locDT: null,
            button: 0
        };
    },
    adjustWidth: function(width) {
        var element = $(this.canvasEl);
        element.attr('width', width);
        element.width(width);
    },
    adjustHeight: function() {
        var element = $(this.canvasEl);
        var height = element.attr('height');
        if (this.context.size.height > height) height = this.context.size.height;
        element.attr('height', height);
        element.height(height);
    },
    drawPage: function() {
        this.adjustHeight();
        this.drawAreas();
        this.drawCurrentTime();
    },
    /**
     * 绘制显示区域
     */
    drawAreas: function() {
        if (!this.context.displayAreas) return;
        // 根据显示区域布局，设置显示区域的起始坐标以及绘制显示区域的边框
        var layouts = this.context.arealayout;
        if (layouts && layouts.length > 0) {
            var startPos = { x: this.context.location.x, y: this.context.location.y };
            for (var i = 0; i < layouts.length; i++) {
                var layoutRow = layouts[i];
                startPos.x = this.context.location.x;
                for (var j = 0; j < layoutRow.length; j++) {
                    var layoutItem = layoutRow[j];
                    var area = this.getDisplayArea(layoutItem.code);
                    if (!area) continue;
                    area.rect = new Rectangle(startPos, area.size);
                    if (area.border) this.canvas.drawRectangle(area.rect, area.borderColor);
                    if (area.fillColor) this.canvas.fillRectangle(area.rect, area.fillColor);
                    startPos.x += area.rect.width;
                }
                var rowHeight = this.getAreaRowHeight(layoutRow);
                startPos.y += rowHeight;
            }
        }

        // 绘制显示区域的内容
        var areas = this.context.displayAreas;
        for (var key in areas) {
            var area = this.context.displayAreas[key];
            if (!area.drawMethods) continue;
            for (var i = 0; i < area.drawMethods.length; i++) {
                var drawMethod = area.drawMethods[i];
                if (this[drawMethod]) this[drawMethod](area);
            }
        }
    },
    getDisplayArea: function(code) {
        return this.context.displayAreas[code];
    },
    /**
     * 获取显示区域行的高度
     * @param {Object} areaRow - 显示区域项
     * @returns {Float} 显示区域行的高度
     */
    getAreaRowHeight: function(areaRow) {
        var height = 0;
        if (areaRow && areaRow.length > 0) {
            for (var i = 0; i < areaRow.length; i++) {
                var areaRowItem = areaRow[i];
                var area = this.getDisplayArea(areaRowItem.code);
                if (areaRowItem.subAreas && areaRowItem.subAreas.length > 0) {
                    var subTotalHeight = this.getAreaRowHeight(areaRowItem.subAreas);
                    height = height < subTotalHeight ? subTotalHeight : height;
                } else if (area != null) {
                    height = height < area.size.height ? area.size.height : height;
                }
            }
        }
        return height;
    },
    /**
     * 绘制时间区域
     */
    drawTimeArea: function(area) {
        var startTime = this.context.startDateTime;
        var endTime = this.context.endDateTime;

        var font = area.font,
            color = area.color,
            borderColor = area.borderColor;

        var roomArea = this.context.displayAreas.roomArea;
        var width = area.size.width;
        var roomWidth = roomArea.size.width;

        var hours = new TimeSpan(endTime, startTime).totalHours;
        var startPos = {
                x: area.rect.left + roomWidth,
                y: area.rect.bottom
            },
            endPos = {
                x: area.rect.right,
                y: area.rect.bottom
            };
        var drawLocation = {
            x: startPos.x,
            y: area.rect.top + 20
        };

        this.canvas.drawLine(startPos, endPos, borderColor);

        var distance = (width - roomWidth) / 24,
            time = '',
            date = '',
            lastDate = '';
        newTime = null;
        for (var i = 0; i <= hours; i++) {
            drawLocation.x = startPos.x + i * distance;
            newTime = startTime.addHours(i);
            time = newTime.format('HH:mm');
            date = newTime.format('yyyy-MM-dd');
            if (lastDate != date) {
                this.canvas.drawString(date, {
                    x: drawLocation.x - 14,
                    y: drawLocation.y - 18
                }, color, font);
            }
            this.canvas.drawString(time, {
                x: drawLocation.x - 14,
                y: drawLocation.y - 5
            }, color, font);
            this.canvas.drawLine({
                x: drawLocation.x,
                y: area.rect.bottom - 5
            }, {
                x: drawLocation.x,
                y: area.rect.bottom
            }, color, 1);
            lastDate = date;
        }
    },
    /**
     * 绘制项目区域
     */
    drawRoomArea: function(area) {
        var roomGroups = this.context.roomGroups;
        var operArea = this.context.displayAreas.operArea;

        var font = area.font,
            color = area.color,
            lineColor = area.lineColor,
            borderColor = area.borderColor;
        var startPos = {
                x: area.rect.left,
                y: area.rect.top
            },
            endPos = {
                x: area.rect.right,
                y: area.rect.bottom
            };

        var length = roomGroups.length;
        var floor = null,
            roomLength = 0,
            room = null;

        var drawLocation = {
            x: startPos.x + area.floorWidth,
            y: startPos.y
        };

        var rowHeight = area.rowHeight;
        var startY, endY, textWidth;
        var roomWidth = area.size.width - area.floorWidth - area.floorWidth + operArea.size.width;
        for (var i = 0; i < length; i++) {
            floor = roomGroups[i];
            roomLength = floor.rows.length;
            startY = drawLocation.y;

            for (var j = 0; j < roomLength; j++) {
                room = floor.rows[j];
                drawLocation.y += rowHeight;
                this.canvas.drawString(room.Description, {
                    x: drawLocation.x + area.floorWidth + 20,
                    y: drawLocation.y - 3 - (rowHeight / 2)
                }, color, font);

                room.rect = new Rectangle({
                    x: drawLocation.x + area.floorWidth,
                    y: drawLocation.y - rowHeight
                }, {
                    width: roomWidth,
                    height: rowHeight
                });

                this.canvas.drawLine({
                    x: drawLocation.x + area.floorWidth,
                    y: drawLocation.y
                }, {
                    x: drawLocation.x + area.floorWidth + roomWidth,
                    y: drawLocation.y
                }, lineColor);
            }

            endY = drawLocation.y;

            textWidth = this.canvas.measureChineseWidth(floor.text, color, font);

            this.canvas.drawVerticalString(floor.text, {
                x: drawLocation.x - 5,
                y: (endY + startY - textWidth) / 2
            }, color, font, 16);

            this.canvas.drawLine({
                x: startPos.x + area.floorWidth + area.floorWidth,
                y: startY
            }, {
                x: startPos.x + area.floorWidth + area.floorWidth,
                y: endY
            }, lineColor);

            this.canvas.drawLine({
                x: startPos.x,
                y: drawLocation.y
            }, {
                x: startPos.x + 920,
                y: drawLocation.y
            }, lineColor);
        }
    },
    /**
     * 绘制数据区域
     */
    drawOperArea: function(area) {
        var roomArea = this.context.displayAreas.roomArea;
        var statusColors = area.statusColors;
        var color;

        var schedules = area.schedules;
        var length = schedules.length;
        var schedule;
        var padding = 5;
        var startPosX, startPosY, endPosX, width, height = roomArea.rowHeight - (padding * 2);
        for (var i = 0; i < length; i++) {
            schedule = schedules[i];
            color = statusColors[schedule.CurrentStatus] || statusColors['default'];
            startPosX = this.getAxisXByTime(schedule.TheatreInDT);
            startPosY = this.getAxisYByOperRoom(schedule.OperRoom);
            endPosX = this.getAxisXByTime(schedule.TheatreOutDT);
            width = endPosX - startPosX;
            schedule.rect = new Rectangle({ x: startPosX, y: startPosY + padding }, { width: width, height: height });

            this.canvas.fillRoundRectangle(schedule.rect, color, color, 5);
        }
    },
    /**
     * 绘制当前时间
     */
    drawCurrentTime: function() {
        var now = new Date();
        var startPosX = this.getAxisXByTime(now);
        var operArea = this.context.displayAreas.operArea;
        var startPosY = operArea.rect.top;
        var endPosY = operArea.rect.bottom;

        this.canvas.drawLine({
            x: startPosX,
            y: startPosY
        }, {
            x: startPosX,
            y: endPosY
        }, "Red", 2);
    },
    /**
     * 设置显示时间范围
     */
    setDisplayTimeDuration: function() {

    },
    /**
     * 获取坐标
     */
    getAxis: function() {

    },
    /**
     * 根据坐标获取时间
     * @param {*} axisX 
     */
    getTimeByAxisX: function(axisX) {
        var operArea = this.context.displayAreas.operArea,
            timeArea = this.context.displayAreas.timeArea,
            result = null;

        var startPosX = operArea.rect.left,
            endPosX = operArea.rect.left + operArea.rect.width;
        var recordDistance = axisX - startPosX;
        var totalSecs = new TimeSpan(timeArea.EndDT, timeArea.StartDT).totalSeconds;
        var recordSecs = totalSecs * recordDistance / (endPosX - startPosX);
        result = timeArea.StartDT.addSeconds(recordSecs);

        return result;
    },
    /**
     * 获取x坐标
     */
    getAxisXByTime: function(recordDT) {
        if (!(recordDT instanceof Date)) {
            recordDT = dhccl.toDateTime(recordDT);
        }
        if (!(recordDT instanceof Date) || !(recordDT.isValidDate())) {
            recordDT = new Date();
        }
        var operArea = this.context.displayAreas.operArea,
            timeArea = this.context.displayAreas.timeArea,
            result = -1;

        var startPosX = operArea.rect.left,
            endPosX = operArea.rect.left + operArea.rect.width;

        if (recordDT < timeArea.StartDT) recordDT = timeArea.StartDT;
        if (recordDT > timeArea.EndDT) recordDT = timeArea.EndDT;

        var totalSecs = new TimeSpan(timeArea.EndDT, timeArea.StartDT).totalSeconds,
            recordSecs = new TimeSpan(recordDT, timeArea.StartDT).totalSeconds
        var recordDistance = (endPosX - startPosX) * (recordSecs / totalSecs);
        result = startPosX + recordDistance;

        if (recordDT > timeArea.EndDT) result = 9999999;
        if (recordDT < timeArea.StartDT) result = -1;
        return result;
    },
    /**
     * 获取y坐标
     */
    getAxisYByOperRoom: function(operRoomId) {
        var area = this.context.displayAreas.roomArea;
        var operRoom = area.operRoomDic[operRoomId];
        return operRoom.rect.top;
    },
    /**
     * 通过坐标获取手术
     */
    getOperScheduleByAxis: function(axis) {
        var data = this.context.operSchedules;
        var length = data.length;

        var row;
        for (var i = 0; i < length; i++) {
            row = data[i];
            if (row.rect.contains(axis)) return row;
        }

        return null;
    },
    /**
     * 通过坐标获取手术间
     */
    getOperRoomByAxis: function(axis) {
        var data = this.context.rooms;
        var length = data.length;

        var row;
        for (var i = 0; i < length; i++) {
            row = data[i];
            if (row.rect.contains(axis)) return row;
        }

        return null;
    },
    /**
     * 获取点击位置相关信息
     */
    captureClick: function(clickLoc) {
        var canvasLoc = this.canvasEl.windowToCanvas(clickLoc);
        var clickArea = null;
        var areas = this.context.displayAreas;
        var area;
        for (var key in areas) {
            area = areas[key];
            if (area.rect.contains(canvasLoc.x, canvasLoc.y)) {
                clickArea = area;
                break;
            }
        }

        var data = [],
            type;
        if (clickArea == areas.roomArea) {
            data = clickArea.operRooms;
            type = 'room';
        } else if (clickArea == areas.operArea) {
            data = clickArea.schedules;
            type = 'oper';
        }

        var length = data.length;
        var row, clickData;
        for (var i = 0; i < length; i++) {
            row = data[i];
            if (row.rect.contains(canvasLoc.x, canvasLoc.y)) {
                clickData = row;
                break;
            }
        }

        return {
            type: type,
            clickArea: clickArea,
            clickData: clickData
        }
    },
    /**
     * 获取鼠标位置信息
     */
    captureMove: function(mouseLoc) {
        var canvasLoc = this.canvasEl.windowToCanvas(mouseLoc);
        var time = this.getTimeByAxisX(canvasLoc.x);

        return {
            locDT: time
        }
    }
}

/**
 * 字体构造函数
 * @param {Object} options - 字体构造选项
 * @author chenchangqing 20170711
 */
function Font(options) {
    this.family = options.family;
    this.size = options.size;
    this.weight = options.weight;
    this.style = this.weight + " " + this.size + " " + this.family;
    this.height = Number(this.size.replace("px", ""));
}

/**
 * 点构造函数
 * @param {Number} x - 点的X坐标
 * @param {Number} y - 点的Y坐标
 * @author chenchangqing 20170711
 */
function Point(x, y) {
    this.x = x;
    this.y = y;
}

/**
 * 矩形构造函数
 * @param {object} location - 矩形的起始点坐标
 * @param {object} size - 矩形的大小
 * @author chenchangqing 20170711
 */
function Rectangle(location, size) {
    this.location = location;
    this.left = this.location.x;
    this.top = this.location.y;
    this.width = size.width;
    this.height = size.height;
    this.right = this.left + this.width;
    this.bottom = this.top + this.height;
    this.centre = { x: (this.left + this.right) / 2, y: (this.top + this.bottom) / 2 };
    this.border = {
        top: {
            start: location,
            end: {
                x: location.x + this.width,
                y: location.y
            }
        },
        bottom: {
            start: {
                x: location.x,
                y: location.y + this.height
            },
            end: {
                x: location.x + this.width,
                y: location.y + this.height
            }
        },
        left: {
            start: location,
            end: {
                x: location.x,
                y: location.y + this.height
            }
        },
        right: {
            start: {
                x: location.x + this.width,
                y: location.y
            },
            end: {
                x: location.x + this.width,
                y: location.y + this.height
            }
        }
    }
}

/**
 * 矩形的原型对象
 * @author chenchangqing 20170711
 */
Rectangle.prototype = {
    constructor: Rectangle,
    /**
     * 判断矩形是否包含坐标为(x,y)的点
     * @param {Number} - 点的X坐标
     * @param {Number} - 点的Y坐标
     * @returns {Boolean} 如果点包含在矩形内返回true，否则返回false
     * @author chenchangqing 20170711
     */
    contains: function(x, y) {
        if (x - this.left < 0 || x - this.right > 0) {
            return false;
        }
        if (y - this.top < 0 || y - this.bottom > 0) {
            return false;
        }
        return true;
    }
};