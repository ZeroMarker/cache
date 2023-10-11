/**
 * creator:		guofa
 * createdate:	2019-08-09
 * description: ��ҩ״̬ʱ����
 */
 var PHADECTIMELINE = ({
    /**��ҩ״̬ʱ������ʾ���ڴ���
     * _options.Params:     ��ҩ����id
     * _options.Field:      ��������һ�е�����������
     * _options.ClickField: ��ǰ�����
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
            var winDiv = '<div id="TimeLineWin" style="overflow:hidden"></div>'
            $("body").append(winDiv);
        }

        $.cm({
            ClassName: "PHA.DEC.Compre.Query",
            QueryName: "getDecStaRecords",
            inputStr: _options.Params
        }, function(retJson) {
            var timeLineHtml = PHADECTIMELINE.TimeLineHtml(retJson);
            if (timeLineHtml == "") {
                if ($('#TimeLineWin')) {
                    $('#TimeLineWin').window('close');
                }
                return;
            };
            $("#TimeLineWin").append(timeLineHtml);
            $("#aPrev").linkbutton();
            $("#aNext").linkbutton();
            $("#aNext").on("click", function() {
                PHADECTIMELINE.Next();
            })
            $("#aPrev").on("click", function() {
                PHADECTIMELINE.Prev();
            })
            PHADECTIMELINE.Show();
            var liLen = $('li').length;
            var liWidth = $('li').width();
            var bodyWidth = $(".dhcpha-tm-body").width();
            if (bodyWidth < (liLen * liWidth)) {
                PHADECTIMELINE.Next(1);
            } else {
                PHADECTIMELINE.Prev();
            }
        })
    },
    Prev: function() {
        var curLeft = parseInt($("#atimeline").css("left"))
        $("#atimeline").animate({ "left": 25 }, 500);
    },
    Next: function(aniFlag) {
        var liLen = $('li').length;
        var liWidth = $('li').width();
        var bodyWidth = $(".dhcpha-tm-body").width();
        var needLeft = bodyWidth - (liLen * liWidth)
        var curLeft = parseInt($("#atimeline").css("left"))
        if (curLeft < 0) {
            return;
        }
        $("#atimeline").animate({ "left": needLeft }, aniFlag == 1 ? 0 : 500);
    },
    Show: function() {
        $('#TimeLineWin').window({
            title: ' ��ҩʱ����',
            collapsible: false,
            iconCls: "icon-clock-record",
            border: false,
            closed: true,
            modal: false,
            maximizable: false,
            width: $(window).width() - 10,
            left: 5,
            top: 5,
            onBeforeClose: function() {
                $("#TimeLineWin").remove();
            }
        });
        $('#TimeLineWin').window('open');
        $(".dhcpha-tm-body").css('width', $(window).width() - 50)
    },
    TimeLineHtml: function(jsonData) {
        var jsonRows = jsonData.rows;
        var jsonLen = jsonRows.length;
        var timeI = 0;
        var timeLineHtml =
            '<div class="dhcpha-tm-containter">' +
            '<div class="dhcpha-tm-lr dhcpha-tm-lr-l">' +
            '<a id="aPrev" class="hisui-linkbutton"></a>' +
            '</div>' +
            '<div class="dhcpha-tm-body">' +
            '<div class="dhcpha-tm-line"></div>' +
            '<ul id="atimeline">';
        for (var i = 0; i < jsonLen; i++) {
            var iJson = jsonRows[i];
            timeI = timeI + 1;
            var oneCellHtml = this.OneCellHtml(iJson);
            timeLineHtml += oneCellHtml;
        }
        if (timeI == 0) {
            return "";
        }
        timeLineHtml +=
            ' </ul>' +
            '</div>' +
            '<div class="dhcpha-tm-lr dhcpha-tm-lr-r">' +
            '<a id="aNext" class="hisui-linkbutton"></a>' +
            '</div>' +
            '</div>'
        return timeLineHtml;

    },
    OneCellHtml: function(_json, _num) {
        var _staDate = _json.staDate || " ";
        var _staUserName = _json.staUserName || "";
        var _staDesc = _json.staDesc || "";
        var colorCls = "dhcpha-tm-bus-default";
        switch (_staDesc) {
            case "�շ�":
                colorCls = "dhcpha-tm-bus-kd";
                break;
            case "����":
                colorCls = "dhcpha-tm-bus-pw";
                break;
            case "�׼�":
                colorCls = "dhcpha-tm-bus-pp";
                break;
            case "����":
                colorCls = "dhcpha-tm-bus-dq";
                break;
            case "�Ƹ�":
                colorCls = "dhcpha-tm-bus-fq";
                break;
            case "��ǩ":
                colorCls = "dhcpha-tm-bus-py";
                break;
            case "��ҩ":
                colorCls = "dhcpha-tm-bus-tq";
                break;
            case "����":
                colorCls = "dhcpha-tm-bus-bqjs";
                break;
            case "�ӹ�":
                colorCls = "dhcpha-tm-bus-hd";
                break;
            case "����":
                colorCls = "dhcpha-tm-bus-pz";
                break;    
            default:
                colorCls = "dhcpha-tm-bus-default";
                break;
        }
        if (_staDate == "") {
            colorCls = "dhcpha-tm-bus-default";
        }
        var _html =
            '<li>' +
            '<div class="dhcpha-tm-bus ' + colorCls + '">' +
            '<div>' + _staDesc + '</div>' +
            '<div class="dhcpha-tm-tri">' +
            '</div>' +
            '<div style="height:15px">' +
            '<div class="dhcpha-tm-circle">' +
            '</div>' +
            '</div>' +
            '<div>' +
            '<div>' + _staDate.split(" ")[0] + '</div>' +
            '<div>' + _staDate.split(" ")[1] + '</div>' +
            '<div>' + _staUserName + '</div>' +
            '</div>' +
            '</div>' +
            '</li>'
        return _html;
    }
});