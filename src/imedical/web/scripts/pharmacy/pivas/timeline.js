/**
 * creator:		yunhaibao
 * createdate:	2018-04-13
 * description: 配液状态时间轴
 * div 等命名固定
 */
var PIVASTIMELINE = {
    /**配液状态时间轴显示窗口创建
     * _options.Params:     条码
     * _options.Field:      定义点击哪一列弹出分析窗口
     * _options.ClickField: 当前点击列
     */
    Init: function (_options) {
        var Field = _options.Field;
        var ClickField = _options.ClickField;
        if (Field != ClickField) {
            if ($('#TimeLineWin')) {
                $('#TimeLineWin').window('close');
            }
            return;
        }
        if ($('#TimeLineWin').text() != '') {
            $('#TimeLineWin').html('');
        } else {
            var winDiv = '<div id="TimeLineWin" style="overflow:hidden"></div>';
            $('body').append(winDiv);
        }

        $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.Dictionary',
                QueryName: 'LabelExeRecords',
                inputStr: _options.Params
            },
            function (retJson) {
                var timeLineHtml = PIVASTIMELINE.TimeLineHtml(retJson);
                if (timeLineHtml == '') {
                    if ($('#TimeLineWin')) {
                        $('#TimeLineWin').window('close');
                    }
                    return;
                }
                $('#TimeLineWin').append(timeLineHtml);
                $('#aPrev').linkbutton();
                $('#aNext').linkbutton();
                $('#aNext').on('click', function () {
                    PIVASTIMELINE.Next();
                });
                $('#aPrev').on('click', function () {
                    PIVASTIMELINE.Prev();
                });
                PIVASTIMELINE.Show();
                var liLen = $('li').length;
                var liWidth = $('li').width();
                var bodyWidth = $('.dhcpha-tm-body').width();
                if (bodyWidth < liLen * liWidth) {
                    PIVASTIMELINE.Next(1);
                } else {
                    PIVASTIMELINE.Prev();
                }
            }
        );
    },
    Prev: function () {
        var curLeft = parseInt($('#atimeline').css('left'));
        $('#atimeline').animate({ left: 25 }, 500);
    },
    Next: function (aniFlag) {
        var liLen = $('li').length;
        var liWidth = $('li').width();
        var bodyWidth = $('.dhcpha-tm-body').width();
        var needLeft = bodyWidth - liLen * liWidth;
        var curLeft = parseInt($('#atimeline').css('left'));
        if (curLeft < 0) {
            return;
        }
        $('#atimeline').animate({ left: needLeft }, aniFlag == 1 ? 0 : 500);
    },
    Show: function () {
        $('#TimeLineWin').window({
            title: ' 配液时间轴',
            collapsible: false,
            iconCls: 'icon-w-clock',
            border: false,
            closed: true,
            modal: false,
            maximizable: false,
            width: $(window).width() - 10,
            left: 5,
            top: 5,
            onClose: function () {
                $('#TimeLineWin').window('destroy');
            }
        });
        $('#TimeLineWin').window('open');
        $('.dhcpha-tm-body').css('width', $(window).width() - 50);
    },
    TimeLineHtml: function (jsonData) {
        var jsonRows = jsonData.rows;
        var jsonLen = jsonRows.length;
        var timeI = 0;
        var timeLineHtml =
            '<div class="dhcpha-tm-containter">' +
            '   <div class="dhcpha-tm-lr dhcpha-tm-lr-l">' +
            '       <a id="aPrev" class="hisui-linkbutton"></a>' +
            '   </div>' +
            '   <div class="dhcpha-tm-body">' +
            '   <div class="dhcpha-tm-line"></div>' +
            '   <ul id="atimeline">';
        for (var i = 0; i < jsonLen; i++) {
            var iJson = jsonRows[i];
            if (iJson.userName == '') {
                // continue;
            }
            timeI = timeI + 1;
            var oneCellHtml = this.OneCellHtml(iJson);
            timeLineHtml += oneCellHtml;
        }
        if (timeI == 0) {
            return '';
        }
        timeLineHtml += ' </ul>' + '</div>' + '<div class="dhcpha-tm-lr dhcpha-tm-lr-r">' + '<a id="aNext" class="hisui-linkbutton"></a>' + '</div>' + '</div>';
        return timeLineHtml;
    },
    OneCellHtml: function (_json, _num) {
        var _dateTime = _json.dateTime || ' ';
        var _userName = _json.userName || '';
        var _psState = _json.pivasState || '';
        var colorCls = 'dhcpha-tm-bus-default';
        switch (_psState) {
            case '开医嘱':
                colorCls = 'dhcpha-tm-bus-kd';
                break;
            case '护士审核':
                colorCls = 'dhcpha-tm-bus-pw';
                break;
            case '配伍审核':
                colorCls = 'dhcpha-tm-bus-pw';
                break;
            case '审核通过':
                colorCls = 'dhcpha-tm-bus-pw';
                break;
            case '排批':
                colorCls = 'dhcpha-tm-bus-pp';
                break;
            case '打签':
                colorCls = 'dhcpha-tm-bus-dq';
                break;
            case '分签':
                colorCls = 'dhcpha-tm-bus-fq';
                break;
            case '排药':
                colorCls = 'dhcpha-tm-bus-py';
                break;
            case '贴签':
                colorCls = 'dhcpha-tm-bus-tq';
                break;
            case '核对':
                colorCls = 'dhcpha-tm-bus-hd';
                break;
            case '配置':
                colorCls = 'dhcpha-tm-bus-pz';
                break;
            case '复核':
                colorCls = 'dhcpha-tm-bus-fh';
                break;
            case '装车':
                colorCls = 'dhcpha-tm-bus-db';
                break;
            case '病区接收':
                colorCls = 'dhcpha-tm-bus-bqjs';
                break;
            case '开始输液':
                colorCls = 'dhcpha-tm-bus-kssy';
                break;
            case '结束输液':
                colorCls = 'dhcpha-tm-bus-jssy';
                break;
            case '停止执行':
                colorCls = 'dhcpha-tm-bus-tzzx';
                break;
            case '退药':
                colorCls = 'dhcpha-tm-bus-return';
                break;
            default:
                colorCls = 'dhcpha-tm-bus-default';
                break;
        }
        if (_dateTime == '') {
            colorCls = 'dhcpha-tm-bus-default';
        }
        var _html = '';
        _html += '<li>';
        _html += '  <div class="dhcpha-tm-bus ' + colorCls + '">';
        _html += '      <div>' + _psState + '</div>';
        _html += '      <div class="dhcpha-tm-tri"></div>';
        _html += '      <div style="height:15px">';
        _html += '          <div class="dhcpha-tm-circle"></div>';
        _html += '      </div>';
        _html += '      <div>';
        _html += '          <div>' + _dateTime.split(' ')[0] + '</div>';
        _html += '          <div>' + _dateTime.split(' ')[1] + '</div>';
        _html += '          <div>' + _userName + '</div>';
        _html += '      </div>';
        _html += '  </div>';
        _html += '</li>';
        return _html;
    }
};
