/**
 * 过程监控
 * @author yongyang  2019-04-02
 */

function ProcessMonitor() {
    this.context = new RecordContext();
    this.canvasEl = document.getElementById("canvas_pm");;
    this.sheet = new RecordSheet(this.canvasEl, this.context);
    this.init();
}

ProcessMonitor.prototype = {
    constructor: ProcessMonitor,
    /**
     * 初始化
     */
    init: function() {
        this.operInfoWindow = $('<div class="pm-operinfo-window"></div>').appendTo('body');
        this.operInfoContainer = $('<div class="pm-operinfo-window-container"></div>').appendTo(this.operInfoWindow);
        this.operInfoWindow.hide();
        this.initCanvas();
    },
    /**
     * 初始化绘图对象
     */
    initCanvas: function() {
        var canvas = this.canvasEl;
        // 初始化Canvas提示信息
        $(canvas).tooltip({
            content: "",
            trackMouse: true,
            showDelay: 0,
            hideDelay: 0
        });
        $(canvas).tooltip("hide");
        // Canvas鼠标移动事件
        $(canvas).mousemove(canvasMouseMove);
        // Canvas鼠标单击事件
        $(canvas).click(canvasMouseClick);
    },
    /**
     * 刷新界面
     */
    refreshPage: function() {
        var _this = this;
        this.context.loadOperSchedules(function() {
            _this.sheet.drawPage();
        });
    },
    /**
     * 放大
     */
    zoomIn: function() {

    },
    /**
     * 缩小
     */
    zoomOut: function() {

    },
    /**
     * 显示手术信息
     * @param {*} operSchedule 
     * @param {*} pos 
     */
    showOperSchedule: function(operSchedule, pos) {
        if (operSchedule) {
            this.operInfoWindow.css({
                top: pos.y + 30,
                left: pos.x - 20
            });
            operview.render(this.operInfoContainer, operSchedule);
            this.operInfoWindow.show();
        } else {
            this.operInfoWindow.hide();
        }
    },
    adjustWidth: function() {
        var width = window.innerWidth - 25;
        this.sheet.adjustWidth(width);
        this.context.adjustWidth(width);
    }
}

var operview = {
    render: function(dom, operSchedule) {
        dom.empty();
        $('<div></div>')
            .append('<span>' + operSchedule.Patient + '</span>')
            .append('<span>' + operSchedule.MedcareNo + '</span>').appendTo(dom);

        $('<div></div>').append('<span>' + operSchedule.PatDeptDesc + '</span>').appendTo(dom);
        $('<div></div>').append('<span>' + operSchedule.OperationDesc + '</span>').appendTo(dom);
        $('<div></div>').append('<span>' + operSchedule.AnaestMethod + '</span>').appendTo(dom);
        $('<div></div>').append('<span>主刀：</span>')
            .append('<span>' + operSchedule.SurgeonDesc + '</span>')
            .appendTo(dom);
        $('<div></div>').append('<span>麻醉：</span>')
            .append('<span>' + operSchedule.AnesthesiologistDesc + '</span>').appendTo(dom);
        $('<div></div>').append('<span>器械：</span>')
            .append('<span>' + operSchedule.ScrubNurseDesc + '</span>')
            .appendTo(dom);
        $('<div></div>').append('<span>巡回：</span>')
            .append('<span>' + operSchedule.CircualNurseDesc + '</span>')
            .appendTo(dom);
    }
}

var processmonitor = null;
$(document).ready(function() {
    processmonitor = new ProcessMonitor();
    processmonitor.adjustWidth();
    processmonitor.sheet.drawPage();
    autoRefresh();
});


/**
 * 鼠标点击事件
 */
function canvasMouseClick(e) {
    var canvasLoc = processmonitor.canvasEl.windowToCanvas(e);
    var clickInfo = processmonitor.sheet.captureClick(e);
    if (clickInfo.type == 'oper') {
        processmonitor.showOperSchedule(clickInfo.clickData, canvasLoc);
    }
}

/**
 * 鼠标移动事件，显示时间
 */
function canvasMouseMove(e) {
    var canvasLoc = processmonitor.canvasEl.windowToCanvas(e);
    var moveInfo = processmonitor.sheet.captureMove(e);
    if (moveInfo) {
        $(processmonitor.canvasEl).tooltip("update", moveInfo.locDT.format("HH:mm"));
        $(processmonitor.canvasEl).tooltip("show");
    }
}


/**
 * 定时刷新任务
 */
function autoRefresh() {
    setInterval(function() {
        processmonitor.refreshPage();
    }, 300000); //每隔5分钟自动刷新界面
}