//
/**
 * 生命体征绘制图层
 * @author yongyang 2021-03-31
 */
(function(global, factory) {
    if (!global.DrawingLayer) factory(global.DrawingLayer = {});
}(this, function(exports) {

    function init(container, opt) {
        var view = new DrawingLayer(container, opt);
        exports.instance = view;
        return view;
    }

    exports.init = init;

    function DrawingLayer(container, opt) {
        this.container = $(container);
        this.options = $.extend({ width: 200, height: 360, offsetY: 50 }, opt);
        this.saveHandler = opt.saveHandler;
        this.init();
    }

    DrawingLayer.prototype = {
        constructor: DrawingLayer,
        init: function() {
            var _this = this;
            var container = this.container;
            this.parentBox = this.container.parent();
            this.mask = $('<div style="display:none;position:absolute;z-index:50;background-color:#fff;opacity:0.8;"></div>').appendTo(container);
            this.dom = $('<div style="display:none;position:absolute;z-index:60;background-color:transparent;"></div>').appendTo(container);
            this.canvas = $('<canvas width="650" height="390">').appendTo(this.dom);
            this.mask.width(this.options.width);
            this.mask.height(this.options.height);
            this.dom.width(this.options.width);
            this.dom.height(this.options.height);
            this.canvas.width(this.options.width);
            this.canvas.height(this.options.height);
            this.canvas.attr('width', this.options.width);
            this.canvas.attr('height', this.options.height);
            this.drawContext = this.canvas[0].getContext("2d");

            this.position = this.options.position;
            this.currentPosition = $.extend({}, this.position);
            this.xOrdinate = this.options.xOrdinate;
            this.color = '#50B2EE';
            this.visible = false;
            this.points = {};
            this.startPos = {};
            this._initEvents();
        },
        _initEvents: function() {
            var _this = this;
            this.container.on('scroll', function() {
                if (_this.visible) _this.refreshPosition();
            });
            //canvas mousedown
            this.canvas.mousedown(function(e) {
                e.preventDefault();
                _this.drawing = true;
                var mouseLoc = _this.canvas[0].windowToCanvas(e);
                _this.setStartLoc(mouseLoc);
            });
            //canvas mousemove
            this.canvas.mousemove(function(e) {
                //forward -- add point, add line
                //backward -- remove point, remove line
                e.preventDefault();
                var mouseLoc = _this.canvas[0].windowToCanvas(e);
                if (_this.drawing) {
                    _this.generatePoint(mouseLoc);
                    _this.drawChartLine(mouseLoc);
                }
            });
            //canvas mouseup
            this.canvas.mouseup(function(e) {
                e.preventDefault();
                _this.drawing = false;
                _this.save();
            });
        },
        /**
         * 设置位置
         * @param {*} pos 
         */
        location: function(pos) {

        },
        /**
         * 设置大小
         * @param {*} size 
         */
        size: function(size) {

        },
        /**
         * 设置起始点
         */
        setStartLoc: function(mouseLoc) {
            this.isSaving = false;
            this.startLoc = mouseLoc;
            var currentPosition = this.currentPosition;
            var xOrdinate = this.xOrdinate;
            var boxLeft = this.parentBox.position().left;
            var ratio = window.devicePixelRatio || 1;
            var coordinateX = mouseLoc.x - (currentPosition.x * (1 - 1 / ratio)) - xOrdinate.start - (boxLeft * (1 - 1 / ratio));
            this.startIndex = Math.ceil(coordinateX / xOrdinate.interval);
            if (this.startIndex < 0) this.startIndex = 0;
            this.points = {};
        },
        /**
         * 生成点
         */
        generatePoint: function(mouseLoc) {
            var points = this.points;
            var options = this.options;
            var xOrdinate = this.xOrdinate;
            var currentPosition = this.currentPosition;
            var boxLeft = this.parentBox.position().left;
            var ratio = window.devicePixelRatio || 1;
            var coordinateX = mouseLoc.x - (currentPosition.x * (1 - 1 / ratio)) - xOrdinate.start - (boxLeft * (1 - 1 / ratio));
            var currentIndex = Math.round(coordinateX / xOrdinate.interval);
            if (currentIndex < 0) currentIndex = 0;
            var startIndex = this.startIndex;
            //删除不在startDT和LocDT之间的数据
            var minIndex = Math.min(startIndex, currentIndex);
            var maxIndex = Math.max(startIndex, currentIndex);

            for (var i = 0; i < minIndex; i++) {
                points[i] = null;
            }
            for (var i = xOrdinate.count; i > maxIndex; i--) {
                points[i] = null;
            }

            //生成或修改新数据
            for (var i = minIndex; i <= maxIndex; i++) {
                if (!points[i]) {
                    points[i] = { x: (i * xOrdinate.interval + xOrdinate.start), y: mouseLoc.y - (currentPosition.y * (1 - 1 / ratio)) };
                }
            }
        },
        /**
         * 绘制折线
         */
        drawChartLine: function(mouseLoc) {
            var _this = this;
            this.drawContext.clearRect(0, 0, $(this.canvas).width(), $(this.canvas).height());
            var points = this.points;
            var color = this.color;
            var lastPoint;

            $.each(points, function(i, point) {
                if (point) {
                    _this.drawContext.drawCircle({
                        x: point.x,
                        y: point.y,
                        radius: 2,
                        eAngle: 2 * Math.PI
                    }, color);
                    if (lastPoint) _this.drawContext.drawLine(lastPoint, point, color);
                    lastPoint = point;
                }
            });
        },
        /**
         * 刷新位置
         */
        refreshPosition: function() {
            var position = this.position;
            var options = this.options;

            var parent = this.container;
            var scrollTop = parent.scrollTop();
            var scrollLeft = parent.scrollLeft();

            this.currentPosition = { x: position.x - scrollLeft, y: position.y - scrollTop + options.offsetY };

            this.mask.css({
                top: this.currentPosition.y,
                left: this.currentPosition.x
            });

            this.dom.css({
                top: this.currentPosition.y,
                left: this.currentPosition.x
            });

            this.canvas.css({
                top: this.currentPosition.y,
                left: this.currentPosition.x
            });
        },
        setOptions: function(opt) {
            $.extend(this.options, opt);
        },
        open: function() {
            this.visible = true;
            this.refreshPosition();
            this.dom.show();
            this.mask.show();
        },
        close: function() {
            this.visible = false;
            this.mask.hide();
            this.dom.hide();
            this.clear();
            if (this.onClose) this.onClose();
        },
        clear: function() {
            this.points = {};
            this.startLoc = {};
            this.startIndex = 0;
            this.isSaving = false;
            this.drawContext.clearRect(0, 0, $(this.canvas).width(), $(this.canvas).height());
        },
        /**
         * 重新校准点的坐标值
         */
        coordinate: function(data) {
            var length = data.length;
            var position = this.position;
            for (var i = 0; i < length; i++) {
                data[i].x = data[i].x + position.x;
                data[i].y = data[i].y + position.y;
            }
        },
        /**
         * 将线变为数据数组
         */
        toData: function() {
            var points = this.points;
            var data = [];
            $.each(points, function(i, point) {
                if (point) data.push(point);
            });

            this.coordinate(data);
            return data;
        },
        /**
         * 保存绘制的线
         */
        save: function() {
            var data = this.toData();
            this.isSaving = true;
            if (this.options.saveHandler) this.options.saveHandler.call(this, data);
        }
    }
}));