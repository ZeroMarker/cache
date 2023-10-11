var userid = session['LOGON.USERID'];
var hospid = session['LOGON.HOSPID'];
$(function () { //��ʼ��
    Init();
});

function Init() {

    var YMboxObj = $HUI.combobox("#YMbox", {
        url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode: 'remote',
        delay: 200,
        valueField: 'year',
        textField: 'year',
        onBeforeLoad: function (param) {
            param.flag = 1;
            param.str = param.q;
        },
        onSelect:FindBtn
    });
    // }                
    // ���뵥�ŵ�������
    var ApplyCboxObj = $HUI.combobox("#ApplyCbox", {
        url: $URL + "?ClassName=herp.budg.hisui.udata.uBudgCtrlPrePay&MethodName=GetBillCode",
        mode: 'remote',
        delay: 200,
        valueField: 'billcode',
        textField: 'displayinfo',
        onBeforeLoad: function (param) {
            param.userdr = userid;
            param.str = param.q;
        }
    });
    // �����˵�������
    var ApplyerObj = $HUI.combobox("#Applyerbox", {
        url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=UserName",
        mode: 'remote',
        delay: 200,
        valueField: 'rowid',
        textField: 'name',
        onBeforeLoad: function (param) {
            param.hospid = hospid;
            param.userdr = userid;
            param.str = param.q;
        },
        onSelect:FindBtn
    });
    // ��ڿ��ҵ�������
    var OwnDeptboxObj = $HUI.combobox("#OwnDeptbox", {
        url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode: 'remote',
        delay: 200,
        valueField: 'rowid',
        textField: 'name',
        onBeforeLoad: function (param) {
            param.hospid = hospid;
            param.userdr = userid;
            param.flag = 1;
            param.str = param.q;
        },
        onSelect:FindBtn
    });

    // ������ҵ�������
    var ApplyDboxObj = $HUI.combobox("#ApplyDbox", {
        url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode: 'remote',
        delay: 200,
        valueField: 'rowid',
        textField: 'name',
        onSelect:FindBtn,
        onBeforeLoad: function (param) {
            param.hospid = hospid;
            param.userdr = userid;
            param.flag = 1;
            param.str = param.q;
        },
        onSelect:FindBtn
    });
    // ����״̬��������
    var StateboxObj = $HUI.combobox("#Statebox", {
        mode: 'local',
        valueField: 'rowid',
        textField: 'name',
        onSelect:FindBtn,
        data: [{
            'rowid': 1,
            'name': "�½�"
        }, {
            'rowid': 2,
            'name': "�ύ"
        }, {
            'rowid': 3,
            'name': "���"
        }]
    });
    MainColumns = [
        [{
                field: 'rowid',
                title: 'ID',
                width: 80,
                hidden: true
            },
            {
                field: 'CompName',
                title: 'ҽ�Ƶ�λ',
                width: 80,
                hidden: true
            },
            {
                field: 'select',
                title: 'ѡ��',
                align: 'center',
                width: 70,
                formatter: formatselect
            },
            {
                field: 'filedesc',
                title: '����',
                align: 'left',
                width: 120,
                formatter: formatblue
            },
            {
                field: 'YearMonth',
                title: '����',
                align: 'left',
                width: 80
            },
            {
                field: 'BillCode',
                title: '���뵥��',
                width: 130,
                formatter: formatblue
            },
            {
                field: 'audname',
                title: '��ڿ���',
                align: 'left',
                width: 120,
                hidden: true
            },
            {
                field: 'audeprdr',
                title: '��ڿ���dr',
                align: 'left',
                width: 120,
                hidden: true
            },
            {
                field: 'deptID',
                title: '�������ID',
                width: 100,
                hidden: true
            },
            {
                field: 'dName',
                title: '�������',
                align: 'left',
                width: 120
            },
            {
                field: 'UserDR',
                title: '������ID',
                align: 'left',
                width: 100,
                hidden: true
            },
            {
                field: 'uName',
                title: '������',
                align: 'left',
                width: 120
            },
            {
                field: 'ReqPay',
                title: '������',
                align: 'right',
                width: 120
            },
            {
                field: 'ReqPayRes',
                title: '�������',
                align: 'right',
                width: 120
            },
            {
                field: 'BillDate',
                title: '����ʱ��',
                align: 'left',
                width: 150
            },
            {
                field: 'BillState',
                title: '����״̬',
                align: 'center',
                width: 70,
                formatter: function (value, row, index) {
                    var rowid = row.rowid;
                    var BillCode = row.BillCode;
                    if (row.BillState == "�½�"||(row.BillState == "����")) {
                        return '<a href="#" class="grid-td-text-red" onclick=billstatefun(' + rowid + ',\'' + BillCode + '\',\'5\')>' + value + '</a>';
                    } else if (row.BillState == "�ύ") {
                        return '<a href="#" class="grid-td-text" onclick=billstatefun(' + rowid + ',\'' + BillCode + '\',\'5\')>' + value + '</a>';
                    } else {
                        return '<a href="#" class="grid-td-text-gray" onclick=billstatefun(' + rowid + ',\'' + BillCode + '\',\'5\')>' + value + '</a>';
                    }
                }
            },
            {
                field: 'Desc',
                title: '�ʽ�����˵��',
                align: 'left',
                width: 200
            },
            {
                field: 'BudgBal',
                title: '���������',
                align: 'right',
                width: 120
            },
            {
                field: 'budgcotrol',
                title: 'Ԥ�����',
                align: 'center',
                width: 80,
                styler: function (value, row, index) {
                    var sf = row.budgcotrol;
                    if (sf != "Ԥ����") {
                        return 'background-color:#ee4f38;color:white';
                    }
                }
            },
            {
                field: 'sOver',
                title: '��˹���',
                align: 'left',
                width: 120,
                hidden: true
            },
            {
                field: 'Checkid',
                title: '������ID',
                align: 'left',
                width: 100,
                hidden: true
            },
            {
                field: 'CheckDR',
                title: '����������',
                align: 'left',
                width: 100,
                hidden: true
            },
            {
                field: 'ChkSatte',
                title: '���״̬',
                align: 'left',
                width: 120,
                hidden: true
            },
            {
                field: 'CurStepNO',
                title: '��ǰ������',
                align: 'left',
                width: 120,
                hidden: true
            },
            {
                field: 'StepNO',
                title: '��¼��˳���',
                align: 'left',
                width: 120,
                hidden: true
            },
            {
                field: 'CheckDesc',
                title: '�����������',
                align: 'left',
                width: 100,
                hidden: true
            }
        ]
    ];
    var MainGridObj = $HUI.datagrid("#MainGrid", {
        url: $URL,
        queryParams: {
            ClassName: "herp.budg.hisui.udata.uBudgCtrlPrePay",
            MethodName: "List",
            hospid: hospid,
            userdr: userid,
            data: ""
        },
        fitColumns: false, //�й̶�
        loadMsg: "���ڼ��أ����Եȡ�",
        autoRowHeight: true,
        singleSelect: true,
        idField: 'rowid',
        rownumbers: true, //�к�
        singleSelect: true, //ֻ����ѡ��һ��
        pageSize: 20,
        pageList: [10, 20, 30, 50, 100], //ҳ���Сѡ���б�
        pagination: true, //��ҳ
        fit: true,
        columns: MainColumns,
        onClickRow: onClickRow, //���û����һ�е�ʱ�򴥷�
        onLoadSuccess: function (data) {
            if (data) {
                $('.SpecialClass').linkbutton({
                    plain: true
                })
                $('#MainGrid').datagrid('getPanel').removeClass('panel-body');

            }
        },
        onClickCell: function (index, field, value) { //���û����һ����Ԫ���ʱ�򴥷�
            if ((field == "BillCode")) {
                $('#MainGrid').datagrid('selectRow', index);
                var mainRow = $('#MainGrid').datagrid('getSelected');
                EditFun(mainRow, 1);
            }
        },
        striped: true,
        toolbar: '#tb'
    });

    //���һ��ʱ������
    function onClickRow(index) {
        $('#MainGrid').datagrid('selectRow', index);
    }
    //��ѯ����
    function FindBtn() {
        var yearmonth = $('#YMbox').combobox('getValue'); // ��������
        var billcode = $('#ApplyCbox').combobox('getValue'); // ���ݵ���
        var Applyer = $('#Applyerbox').combobox('getValue'); // ������
        var OwnDept = $('#OwnDeptbox').combobox('getValue'); // ��ڿ���
        var ApplyD = $('#ApplyDbox').combobox('getValue'); // �������
        var State = $('#Statebox').combobox('getValue'); // ����״̬
        if (State == undefined) {
            State = "";
        }
        var StPrice = $('#StPricebox').val(); // ������Χ-��Сֵ
        var EdPrice = $('#EdPricebox').val(); // ������Χ-���ֵ
        var data = yearmonth + "^" + billcode + "^" + Applyer + "^" + OwnDept + "^" + ApplyD + "^" + State + "^" + StPrice + "^" + EdPrice;
        // alert(data)
        MainGridObj.load({
            ClassName: "herp.budg.hisui.udata.uBudgCtrlPrePay",
            MethodName: "List",
            hospid: hospid,
            userdr: userid,
            data: data
        })
    }
    //��Ԫ����»���--��ɫ
    function formatblue(value, row, index) {
        return '<span class="grid-td-text">' + value + '</span>';
    }
    //��ѡ���и�ʽ������
    function formatselect(value, row, index) {
        return '<a href="#" class="SpecialClass" title="���" data-options="iconCls:\'icon-stamp\'" onclick=checks(' + index + ')></a>'
    }
    //�����ѯ��ť 
    $("#FindBn").click(FindBtn);
    // ��˹���
    checks = function (index) {
        $('#MainGrid').datagrid('selectRow', index);
        var itemGrid = $('#MainGrid').datagrid('getSelected');
        checkFun(itemGrid)
    }

}