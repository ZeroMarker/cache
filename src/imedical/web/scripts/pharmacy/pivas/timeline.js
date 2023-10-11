/**
 * creator:		yunhaibao
 * createdate:	2018-04-13
 * description: 配液状态时间轴
 * div 等命名固定
 */

var PIVASTIMELINE = {
    Init: function (_opts) {
        var field = _opts.Field;
        var clickField = _opts.ClickField;
        var barCode = _opts.Params;
        // 医嘱闭环在改造后使用此方式 start, yunhaibao 20230116, 还是先用本组的时间轴, 有针对性
        websys_showModal({
            url: 'dhc.orderview.csp?ordViewType=PIVAEXEC&hideSensitiveInfo=1&ordViewBizId=' + barCode.replace(/-/g, '||'),
            title: '配液时间轴',
            width: document.body.clientWidth - 40,
            height: 265,
            iconCls: 'icon-w-list'
        });
        return;
        // 医嘱闭环在改造后使用此方式 end
        if (field !== clickField) {
            if ($('#PIVAS_TimeLine')) {
                $('#PIVAS_TimeLine').window('close');
            }
            return;
        }
        var winId = 'PIVAS_TimeLine';
        var lineId = winId + '_Line';
        var existHtml = $('#' + winId).html() || '';
        if (existHtml === '') {
            var winDiv = '<div id=' + winId + ' style="padding:10px"><div id=' + lineId + '></div></div>';
            $('body').append(winDiv);
            var winOpts = {
                title: ' 配液时间轴',
                collapsible: false,
                iconCls: 'icon-w-clock',
                border: false,
                resizable: true,
                minimizable: false,
                maximizable: false,
                closed: true,
                modal: true,
                width: $('body').width() - 40,
                height: 165,
                //top: 20,
                //left: 20,
                toolbar: null,
                onBeforeClose: function () {}
            };

            $('#' + winId).window($.extend({}, winOpts));
        }
        $('#' + winId).window('open');

        var retData = $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.Dictionary',
                QueryName: 'LabelExeRecords',
                inputStr: _opts.Params
            },
            false
        );
        var itemsArr = [];
        var rowsData = retData.rows;
        for (var i = 0; i < rowsData.length; i++) {
            var rowData = rowsData[i];
            var contextArr = [];
            contextArr.push('<div style="font-weight:normal;">');
            contextArr.push(rowData.dateTime);
            contextArr.push('</div>');
            contextArr.push('<div style="font-weight:normal;">');
            contextArr.push(rowData.userName);
            contextArr.push('</div>');
            var item = {};
            item.title = rowData.pivasState;
            item.context = contextArr.join('');
            itemsArr.push(item);
        }
        $('.hstep').children().remove();
        $('#' + lineId).hstep({
            showNumber: false,
            stepWidth: 200,
            currentInd: rowsData.length,
            items: itemsArr
        });
        $('#PIVAS_TimeLine').scrollLeft(10000);
    }
};
var PIVASTIMELINE_V83 = {
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
        $('#atimeline').animate(
            {
                left: 25
            },
            500
        );
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
        $('#atimeline').animate(
            {
                left: needLeft
            },
            aniFlag == 1 ? 0 : 500
        );
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