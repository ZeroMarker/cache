//
/**
 * 采集数据即时显示
 * @author yongyang 2018-10-22
 */
(function(global, factory) {
    if (!global.collectView) factory(global.collectView = {});
}(this, function(exports) {

    function init(dom, opt) {
        var view = new CollectView(dom, opt);
        exports.instance = view;
        return view;
    }

    exports.init = init;

    var items = [
        { ChannelNo: 'HR', ItemDesc: '心率', UomDesc: '次/分', DataValue: '--', Threshold: '60-100' },
        { ChannelNo: 'RR', ItemDesc: '呼吸', UomDesc: '次/分', DataValue: '--', Threshold: '5-20' },
        { ChannelNo: 'SpO2', ItemDesc: 'SPO2', UomDesc: '%', DataValue: '--', Threshold: '90-100' },
        { ChannelNo: 'NBP', ItemDesc: '无创血压', UomDesc: 'mmHg', DataValue: '--/--', Threshold: '90-140/60-90' },
        { ChannelNo: 'ABP', ItemDesc: '有创血压', UomDesc: 'mmHg', DataValue: '--/--', Threshold: '90-140/60-90' },
        { ChannelNo: 'ETCO2', ItemDesc: 'ETCO2', UomDesc: 'mmHg', DataValue: '--', Threshold: '30-45' }
    ];

    function CollectView(dom, opt) {
        this.dom = dom;
        this.options = $.extend(opt);
        this.items = items;
        this.elements = {};
        this.onQuery = opt.onQuery;
        this.init();
    }

    CollectView.prototype = {
        constructor: CollectView,
        init: function() {
            var _this = this;
            this.dataContainer = $('<div class="collectview-datacontainer"></div>').appendTo(this.dom);
            this.initItem();
        },
        initItem: function() {
            this.dataContainer.hide();
            this.dataContainer.empty();
            var data = this.items;
            var length = data.length;
            for (var i = 0; i < length; i++) {
                var row = data[i];
                var element = $('<div class="collectview-row"></div>').appendTo(this.dataContainer);
                $('<div class="collectview-r-item"></div>')
                    .text(row.ItemDesc)
                    .append('<span class="collectview-r-uom">' + row.UomDesc + '</span>')
                    .appendTo(element);
                $('<div class="collectview-r-value"></div>')
                    .text(row.DataValue)
                    .appendTo(element);
                $('<div class="collectview-r-threshold"></div>')
                    .text(row.Threshold)
                    .appendTo(element);
                this.elements[row.ChannelNo] = element;
            }

            this.dataContainer.show();
        },
        render: function(data) {
            var length = data.length;
            for (var i = 0; i < length; i++) {
                var row = data[i];
                var element = this.elements[row.ChannelNo];
                if (element) {
                    element.find('.collectview-r-value').text(row.DataValue);
                    if (row.Warning === 'Y') {
                        element.addClass('collectview-row-warning');
                        element.removeClass('collectview-row-normal');
                    } else {
                        element.removeClass('collectview-row-warning');
                        element.addClass('collectview-row-normal');
                    }
                }
            }
        },
        query: function() {
            var _this = this;
            if (this.onQuery) this.onQuery(function(data) {
                _this.render(data);
            })
        },
        open: function() {
            if (this.query) {
                this.query();
            }
            startAutoRefresh();
            //this.dom.show();
        },
        close: function() {
            //this.dom.hide();
            endAutoRefresh();
        },
    }


    function startAutoRefresh() {
        exports.intervalFunction = setInterval(function() {
            if (exports.instance && exports.instance.query) {
                exports.instance.query();
            }
        }, 60000);
    }

    function endAutoRefresh() {
        clearInterval(exports.intervalFunction);
    }

}));