/**
 * creator:		yunhaibao
 * createdate:	2018-04-13
 * description: 配液状态时间轴
 * div 等命名固定
 */
var PIVASTIMELINE = ({
    /**配液状态时间轴显示窗口创建
     * _options.Params:     条码
     * _options.Field:      定义点击哪一列弹出分析窗口
     * _options.ClickField: 当前点击列
     */
    Init: function(_options) {
        var Field = _options.Field;
        var ClickField = _options.ClickField;
        if (Field != ClickField) {
            if ($('#TimeLineWin')) {
                $('#TimeLineWin').window('close');
            }
            return;
        }
        if ($("#TimeLineWin").text() != "") {
            $("#TimeLineWin").html("");
        } else {
            var winDiv = '<div id="TimeLineWin"></div>'
            $("body").append(winDiv);
        }
        // 指标计算
        $.cm({
            ClassName: "web.DHCSTPIVAS.Dictionary",
            QueryName: "LabelExeRecords",
            inputStr: _options.Params
        }, function(retJson) {
            var timeLineHtml = PIVASTIMELINE.TimeLineHtml(retJson);
            if (timeLineHtml == "") {
                if ($('#TimeLineWin')) {
                    $('#TimeLineWin').window('close');
                }
                return;
            };
            $("#TimeLineWin").append(timeLineHtml);
            PIVASTIMELINE.Show();

        })
    },
    Show: function() {
        $('#TimeLineWin').window({
            title: ' 配液时间轴',
            collapsible: false,
            iconCls: "icon-history-rec",
            border: false,
            closed: true,
            modal: false,
            width: $(window).width() - 10,
            height: 180,
            left: 5,
            top: 5,
            onBeforeClose: function() {
                $("#TimeLineWin").remove();
            }
        });
        $('#TimeLineWin').window('open');
    },
    TimeLineHtml: function(jsonData) {
        var jsonRows = jsonData.rows;
        var jsonLen = jsonRows.length;
        var timeI = 0;
        var timeLineHtml = '<div style="width:100%;height:100%;">' +
            '<ul>';
        for (var i = 0; i < jsonLen; i++) {
            var iJson = jsonRows[i];
            if (iJson.userName == "") {
                // continue;
            }
            timeI = timeI + 1;
            var oneCellHtml = this.OneCellHtml(iJson, timeI);
            timeLineHtml += oneCellHtml;
        }
        if (timeI == 0) {
            return "";
        }
        timeLineHtml += '</ul></div>';
        var line = '<div style="position: absolute; top: 150px; height: 1px; width: 100%; border-bottom: 2px dashed #7E899D;"></div>';
        timeLineHtml += line;
        return timeLineHtml;

    },
    OneCellHtml: function(_json, _num) {
        var _left = 10 + (_num - 1) * 100;
        var _bgColor = '#1A84CE';
        if (_json.userName == "") {
            _bgColor = '#F89782';
        }
        var _dateTime = _json.dateTime;
        var _date = "";
        var _time = "";
        if (_dateTime.trim() != "") {
            _dateTimeArr = _dateTime.split(" ");
            _time = _dateTimeArr[1];
            var _dateArr = _dateTimeArr[0].split("-");
            _date = _dateArr[1] + "-" + _dateArr[2];
        }
        var _html = '<li style="position:absolute;left:' + _left + 'px;top:50px;list-style:none;width:80px">';
        var _html = _html +
            '<div style="height:100px;border-left:2px solid ' + _bgColor + ';">' +
            '  <div style="background: ' + _bgColor + ';" class="pivas_tml_title">' +
            _json.pivasState +
            '   </div>' +
            '   <div class="pivas_tml_content" style="padding-top:5px;padding-left:5px">' +
            _json.userName +
            '       <div>' + _date + '</div>' +
            '       <div>' + _time + '</div>' +
            '   </div>' +
            '</div>' +
            '</li>';
        return _html;
    }
});