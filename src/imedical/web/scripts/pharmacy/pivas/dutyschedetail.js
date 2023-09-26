/**
 * ģ��:     �Ű����-��θ�λ����
 * ��д����: 2018-08-28
 * ��д��:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var CurDate = "";
$(function() {
    var curDate = new Date();
    var curMonth = curDate.getMonth() + 1;
    CurDate = curDate.getFullYear() + "-" + (curMonth < 10 ? "0" + curMonth : curMonth) + "-" + ((curDate.getDate() < 10) ? ("0" + curDate.getDate()) : curDate.getDate());
    InitGridSchedul();
    InitCalDutySche();
    $('#txtAlias').on('keypress', function(event) {
        if (event.keyCode == "13") {
            Query();
        }
    });
});

function InitGridSchedul() {
    var columns = [
        [{
                field: "psId",
                title: 'psId',
                width: 125,
                hidden: true
            },
            {
                field: "psCode",
                title: '��δ���',
                width: 70
            },
            {
                field: "psDesc",
                title: '�������',
                width: 100
            },
            {
                field: "colorFlag",
                title: '��ɫ��ʶ',
                width: 125,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.DutyScheDetail',
            QueryName: 'PIVASchedul',
            inputStr: SessionLoc
        },
        fitColumns: true,
        columns: columns,
        pagination: false,
        onDblClickRow: function(rowIndex, rowData) {

        },
        rowStyler: function(rowIndex, rowData) {
            var colorFlag = rowData.colorFlag;
            if (colorFlag == 1) {
                //return 'background-color:transparent;';
            } else if (colorFlag == 2) {
                return 'background-color:#e2ffde;color:#3c763d;';
            } else if (colorFlag == 3) {
                return 'background-color:#fff3dd;color:#ff3d2c;';
            }
        },
        onClickRow: function(rowIndex, rowData) {
            // ��ѯ����
            $('#calDutySche').fullCalendar('refetchEvents');
        },
        onLoadSuccess: function() {
            $('#calDutySche').fullCalendar('refetchEvents');
        }
    };
    // ��Ա����,�ѹ�������ʾ������,û�и�λ���м�(��ɫ),������λ�����(ǳ��)
    DHCPHA_HUI_COM.Grid.Init("gridSchedul", dataGridOption);
}

function InitCalDutySche() {
    $('#calDutySche').fullCalendar({
        header: {
            left: 'prev,next',
            center: 'title',
            right: 'month,basicWeek,basicDay', //agendaWeek,agendaDay ��ȷʱ��ε���ͼ
        },
        defaultDate: CurDate,
        editable: false, // �����϶�
        lang: "zh-cn",
        monthNames: ["һ��", "����", "����", "����", "����", "����", "����", "����", "����", "ʮ��", "ʮһ��", "ʮ����"],
        monthNamesShort: ["һ��", "����", "����", "����", "����", "����", "����", "����", "����", "ʮ��", "ʮһ��", "ʮ����"],
        dayNames: ["����", "��һ", "�ܶ�", "����", "����", "����", "����"],
        dayNamesShort: ["����", "��һ", "�ܶ�", "����", "����", "����", "����"],
        today: ["����"],
        eventColor: "#40a2de",
        eventBorderColor: "white",
        height: 500, // ����߶�
        //contentHeight: 50, // �����ݵ��и�
        buttonText: {
            today: '|',
            prev: '<',
            next: '>',
            month: '����ͼ',
            basicWeek: '����ͼ',
            basicDay: '����ͼ'
        },
        // ��̬��ѯ
        events: function(start, end, timezone, callback) {
            var stDate = moment(start).format('YYYY-MM-DD');
            var edDate = moment(end).format('YYYY-MM-DD');
            var gridSelect = $("#gridSchedul").datagrid("getSelected");
            var scheId = "";
            if (gridSelect != null) {
                scheId = gridSelect.psId;
            }
            var locId = SessionLoc;
            var inputStr = stDate + "^" + edDate + "^" + locId + "^" + scheId;
            $.cm({
                ClassName: "web.DHCSTPIVAS.DutyScheDetail",
                QueryName: "DutyCalenSche",
                inputStr: inputStr,
                ResultSetType: 'Array'
            }, function(retData) {
                events = retData;
                callback(events);
            });

        }

    });
}

function Query() {

}