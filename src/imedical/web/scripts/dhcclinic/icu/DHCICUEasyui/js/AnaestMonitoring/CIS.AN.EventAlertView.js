//
/**
 * 事件持续时间提醒
 * 整体视图（多个事件的提醒一起展示）
 * @author yongyang 2020-06-17
 */
(function(global, factory) {
    if (!global.EventAlertView) factory(global.EventAlertView = {});
}(this, function(exports) {

    function init(opt) {
        var view = new EventAlertView(opt);
        exports.instance = view;
        return view;
    }

    exports.init = init;

    function EventAlertView(opt) {
        this.options = $.extend({ width: 200, height: 'auto', top: 10, right: 10 }, opt);
        this.init();
    }

    EventAlertView.prototype = {
        constructor: EventAlertView,
        init: function() {
            var _this = this;
            var options = this.options;
            this.dom = $('<div class="eav-dialog"></div>').appendTo('body');
            var header = $('<div class="eav-header"></div>').appendTo(this.dom);
            var btn_cancel = $('<a href="javascript:;" class="tagbox-remove" title="关闭"></a>').appendTo(header);
            btn_cancel.click(function() {
                _this.close();
            });
            this.dataContainer = $('<div class="eav-container"></div>').appendTo(this.dom);

            this.dom.on('mousedown', function(e) {
                _this.moving = true;
                var position = _this.dom.position();
                var width = _this.dom.width();
                var totalWidth = $('body').width();
                _this.originalPos = { x: e.pageX, y: e.pageY, top: position.top, right: totalWidth - width - position.left };
                $('body').bind('mousemove', move);
                $('body').bind('mouseup', stopmoving);
            });

            function move(e) {
                if (_this.moving) {
                    movingDistance = { x: e.pageX - _this.originalPos.x, y: e.pageY - _this.originalPos.y };
                    _this.dom.css({ top: _this.originalPos.top + movingDistance.y, right: _this.originalPos.right - movingDistance.x });
                }
            }

            function stopmoving(e) {
                _this.moving = false;
                $('body').unbind('mousemove', move);
                $('body').unbind('mouseup', stopmoving);
            }
        },
        loadData: function(data) {
            this.clear();

            var container = this.dataContainer;
            var alertEventPairs = prepareData(data);
            var element;
            var active = false;
            for (var startEvent in alertEventPairs) {
                for (var endEvent in alertEventPairs[startEvent]) {
                    if (alertEventPairs[startEvent][endEvent]['Start'] &&
                        !alertEventPairs[startEvent][endEvent]['End']) {
                        element = $('<div class="eav-event"></div>').appendTo(container);
                        dataView.render(element, alertEventPairs[startEvent][endEvent]);
                        active = true;
                    }
                }
            }

            if (active && !this.timer) this.addTimer();
        },
        addTimer: function() {
            var _this = this;
            this.timer = setInterval(function() {
                var eventElements = _this.dataContainer.find('.eav-event');
                if (eventElements.length > 0) {
                    var length = eventElements.length;
                    var element;
                    for (var i = 0; i < length; i++) {
                        element = $(eventElements[i]);
                        if (!element.data('complete')) dataView.refreshTime(element);
                    }
                }
            }, 5000);
        },
        setOptions: function(opt) {
            $.extend(this.options, opt);
        },
        open: function() {
            this.dom.show();
        },
        close: function() {
            this.dom.hide();
            clearInterval(this.timer);
            this.timer = null;
        },
        clear: function() {
            this.dataContainer.empty();
        },
        save: function() {}
    }

    /**
     * 提取出需要提醒的事件数据
     * @param {*} data 事件数据
     * DataItem的EventItem中设置有持续事件标识，且设置有关联持续开始事件或关联持续结束事件
     * 未考虑自定义事件
     * @returns
     * {
     *      3:{         //开始事件DataItem
     *          5:{     //结束事件DataItem
     *              Start:{...},
     *              End:{...}
     *          }
     *      }
     * }
     */
    function prepareData(data) {
        var length = data.length;
        var row, eventItem, startEvent, endEvent, thisEvent;
        var eventDic = {};
        for (var i = 0; i < length; i++) {
            row = data[i];
            if (row.categoryItemObj) {
                eventItem = row.categoryItemObj.eventItem;
                thisEvent = row.DataItem;
                if (eventItem &&
                    (eventItem.RelatedStartEvent || eventItem.RelatedEndEvent) &&
                    thisEvent && eventItem.BarColor) {
                    startEvent = eventItem.RelatedStartEvent;
                    endEvent = eventItem.RelatedEndEvent;

                    if (endEvent) {
                        if (!eventDic[thisEvent]) eventDic[thisEvent] = {};
                        if (!eventDic[thisEvent][endEvent]) eventDic[thisEvent][endEvent] = {};
                        if (!eventDic[thisEvent][endEvent]['Start']) eventDic[thisEvent][endEvent]['Start'] = [];
                        eventDic[thisEvent][endEvent]['Start'].push(row);
                        eventDic[thisEvent][endEvent]['BarColor'] = eventItem.BarColor;
                    }
                    if (startEvent) {
                        if (!eventDic[startEvent]) eventDic[startEvent] = {};
                        if (!eventDic[startEvent][thisEvent]) eventDic[startEvent][thisEvent] = {};
                        if (!eventDic[startEvent][thisEvent]['End']) eventDic[startEvent][thisEvent]['End'] = [];
                        eventDic[startEvent][thisEvent]['End'].push(row);
                        eventDic[startEvent][thisEvent]['BarColor'] = eventItem.BarColor;
                    }
                }
            }
        }

        return eventDic;
    };

    var dataView = {
        render: function(container, continuousEventPair) {
            var startEventLength = continuousEventPair.Start.length;
            var endEventLength = (continuousEventPair.End || []).length;
            if (startEventLength >= endEventLength) {
                var eventName = continuousEventPair.Start[startEventLength - 1].DataItemDesc;
                var StartDT = continuousEventPair.Start[startEventLength - 1].StartDT;
                var EndDT = ((continuousEventPair.End || [])[startEventLength - 1] || {}).StartDT;
                var complete = false;
                if (!EndDT) EndDT = new Date();
                else complete = true;

                var totalSeconds = Math.floor(new TimeSpan(EndDT, StartDT).totalSeconds);
                var hours = Math.floor(totalSeconds / 3600);
                var seconds = totalSeconds % 3600;
                var minutes = Math.floor(seconds / 60);
                seconds = seconds % 60;
                // var duration = (hours > 9 ? hours : '0' + hours) + ":" +
                //     (minutes > 9 ? minutes : '0' + minutes) + ":" +
                //     (seconds > 9 ? seconds : '0' + seconds);

                var duration = (hours > 0 ? (hours + 'h ') : '') +
                    (minutes > 0 ? (minutes + 'min ') : '') +
                    (seconds > 0 ? (seconds + 's') : '');

                var timeInfo = StartDT.format('HH:mm');
                if (complete) timeInfo = timeInfo + '-' + EndDT.format('HH:mm');
                container.data('start', StartDT);
                container.data('complete', complete);

                $('<span class="eav-event-name"></span>').text(eventName).appendTo(container);
                if (complete) container.append('时间:');
                else container.append('开始时间:');
                $('<span class="eav-event-timeinfo"></span>').text(timeInfo).appendTo(container);
                if (complete) container.append(',持续 ');
                else container.append(',已持续 ');
                var durationElement = $('<span class="eav-event-duration"></span>').text(duration).appendTo(container);
                if (hours > 0 || minutes > 30) durationElement.addClass('eav-event-alert');
                else durationElement.removeClass('eav-event-alert');
            }
        },
        refreshTime: function(container) {
            var StartDT = container.data('start');
            var totalSeconds = Math.floor(new TimeSpan(new Date(), StartDT).totalSeconds);
            var hours = Math.floor(totalSeconds / 3600);
            var seconds = totalSeconds % 3600;
            var minutes = Math.floor(seconds / 60);
            seconds = seconds % 60;
            // var duration = (hours > 9 ? hours : '0' + hours) + ":" +
            //     (minutes > 9 ? minutes : '0' + minutes) + ":" +
            //     (seconds > 9 ? seconds : '0' + seconds);

            var duration = (hours > 0 ? (hours + 'h ') : '') +
                (minutes > 0 ? (minutes + 'min ') : '') +
                (seconds > 0 ? (seconds + 's') : '');

            var durationElement = container.find('.eav-event-duration');
            durationElement.text(duration);
            if (hours > 0 || minutes > 30) durationElement.addClass('eav-event-alert');
            else durationElement.removeClass('eav-event-alert');
        }
    }
}));