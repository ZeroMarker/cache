/**
 * ģ��:     �Ű����-��Ա�Ű�����
 * ��д����: 2018-08-27
 * ��д��:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var CurDate = '';
$(function () {
    var curDate = new Date();
    var curMonth = curDate.getMonth() + 1;
    CurDate = curDate.getFullYear() + '-' + (curMonth < 10 ? '0' + curMonth : curMonth) + '-' + (curDate.getDate() < 10 ? '0' + curDate.getDate() : curDate.getDate());
    InitGridUser();
    InitCalUserSche();
    $('#txtAlias').on('keypress', function (event) {
        if (event.keyCode == '13') {
            Query();
        }
    });
    $('.dhcpha-win-mask').remove();
});

function InitGridUser() {
    var columns = [
        [
            {
                field: 'userId',
                title: 'userId',
                width: 125,
                hidden: true
            },
            {
                field: 'userCode',
                title: '��Ա����',
                width: 70,
                hidden: true
            },
            {
                field: 'userName',
                title: '��Ա����',
                width: 70
            },
            {
                field: 'colorFlag',
                title: '��ɫ��ʶ',
                width: 125,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.UserSchedul',
            QueryName: 'PIVAScheUser',
            inputStr: SessionLoc
        },
        fitColumns: true,
        toolbar: '#gridUserBar',
        columns: columns,
        pagination: false,
        onDblClickRow: function (rowIndex, rowData) {},
        rowStyler: function (rowIndex, rowData) {
            var colorFlag = rowData.colorFlag;
            if (colorFlag == 1) {
                //return 'background-color:transparent;';
            } else if (colorFlag == 2) {
                return 'background-color:#e2ffde;color:#3c763d;';
            } else if (colorFlag == 3) {
                return 'background-color:#fff3dd;color:#ff3d2c;';
            }
        },
        onClickRow: function (rowIndex, rowData) {
            // ��ѯ����
            $('#calUserSche').fullCalendar('refetchEvents');
        },
        onLoadSuccess: function () {
            $('#calUserSche').fullCalendar('refetchEvents');
        }
    };
    // ��Ա����,�ѹ�������ʾ������,û�и�λ���м�(��ɫ),������λ�����(ǳ��)
    DHCPHA_HUI_COM.Grid.Init('gridUser', dataGridOption);
}

function InitCalUserSche() {
    $('#calUserSche').fullCalendar({
        header: {
            left: 'prev',
            center: 'title',
            right: 'next' //,basicWeek' // basicDay', //agendaWeek,agendaDay ��ȷʱ��ε���ͼ
        },
        defaultDate: CurDate,
        editable: false, // �����϶�
        lang: 'zh-cn',
        monthNames: ['һ��', '����', '����', '����', '����', '����', '����', '����', '����', 'ʮ��', 'ʮһ��', 'ʮ����'],
        monthNamesShort: ['һ��', '����', '����', '����', '����', '����', '����', '����', '����', 'ʮ��', 'ʮһ��', 'ʮ����'],
        dayNames: ['����', '��һ', '�ܶ�', '����', '����', '����', '����'],
        dayNamesShort: ['����', '��һ', '�ܶ�', '����', '����', '����', '����'],
        today: ['����'],
        eventColor: '#40a2de',
        eventBorderColor: 'white',
        height: 500, // ����߶�
        views: {
            dayGridMonth: {
                // name of view
                titleFormat: { year: 'numeric', month: '2-digit', day: '2-digit' }
                // other view-specific options here
            }
        },
        //contentHeight: 50, // �����ݵ��и�
        /*
        buttonText: {
            today: '|',
            prev: '<',
            next: '>',
            month: '����ͼ',
            basicWeek: '����ͼ',
            basicDay: '����ͼ'
        },*/
        // ��̬��ѯ
        events: function (start, end, timezone, callback) {
            var stDate = moment(start).format('YYYY-MM-DD');
            var edDate = moment(end).format('YYYY-MM-DD');
            var gridSelect = $('#gridUser').datagrid('getSelected');
            var userId = '';
            if (gridSelect != null) {
                userId = gridSelect.userId;
            }
            var locId = SessionLoc;
            var inputStr = stDate + '^' + edDate + '^' + locId + '^' + userId;
            $.cm(
                {
                    ClassName: 'web.DHCSTPIVAS.UserSchedul',
                    QueryName: 'UserCalenSche',
                    inputStr: inputStr,
                    ResultSetType: 'Array'
                },
                function (retData) {
                    events = retData;
                    callback(events);
                }
            );
        }
    });
}

function Query() {
    var txtAlias = $('#txtAlias').val();
    $('#gridUser').datagrid('query', {
        inputStr: SessionLoc + '^' + txtAlias
    });
    $('#txtAlias').val('');
}

