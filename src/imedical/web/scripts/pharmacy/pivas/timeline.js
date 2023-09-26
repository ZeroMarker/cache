/**
 * creator:		yunhaibao
 * createdate:	2018-04-13
 * description: ��Һ״̬ʱ����
 * div �������̶�
 */
var PIVASTIMELINE = {
    /**��Һ״̬ʱ������ʾ���ڴ���
     * _options.Params:     ����
     * _options.Field:      ��������һ�е�����������
     * _options.ClickField: ��ǰ�����
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
            title: ' ��Һʱ����',
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
            case '��ҽ��':
                colorCls = 'dhcpha-tm-bus-kd';
                break;
            case '��ʿ���':
                colorCls = 'dhcpha-tm-bus-pw';
                break;
            case '�������':
                colorCls = 'dhcpha-tm-bus-pw';
                break;
            case '���ͨ��':
                colorCls = 'dhcpha-tm-bus-pw';
                break;
            case '����':
                colorCls = 'dhcpha-tm-bus-pp';
                break;
            case '��ǩ':
                colorCls = 'dhcpha-tm-bus-dq';
                break;
            case '��ǩ':
                colorCls = 'dhcpha-tm-bus-fq';
                break;
            case '��ҩ':
                colorCls = 'dhcpha-tm-bus-py';
                break;
            case '��ǩ':
                colorCls = 'dhcpha-tm-bus-tq';
                break;
            case '�˶�':
                colorCls = 'dhcpha-tm-bus-hd';
                break;
            case '����':
                colorCls = 'dhcpha-tm-bus-pz';
                break;
            case '����':
                colorCls = 'dhcpha-tm-bus-fh';
                break;
            case 'װ��':
                colorCls = 'dhcpha-tm-bus-db';
                break;
            case '��������':
                colorCls = 'dhcpha-tm-bus-bqjs';
                break;
            case '��ʼ��Һ':
                colorCls = 'dhcpha-tm-bus-kssy';
                break;
            case '������Һ':
                colorCls = 'dhcpha-tm-bus-jssy';
                break;
            case 'ִֹͣ��':
                colorCls = 'dhcpha-tm-bus-tzzx';
                break;
            case '��ҩ':
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
