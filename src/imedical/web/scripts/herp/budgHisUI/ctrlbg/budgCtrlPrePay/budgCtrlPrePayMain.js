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
        textField: 'billcode',
        onBeforeLoad: function (param) {
            param.userdr = userid;
            param.str = param.q;
        },
        onSelect:FindBtn
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
            'name': "ͨ��"
        }, {
            'rowid': 4,
            'name': "����"
        }, {
            'rowid': 5,
            'name': "��ͨ��"
        }, {
            'rowid': 6,
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
                width: 130,
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
                width: 140,
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
                    if (row.BillState == "�½�" || (row.BillState == "����")) {
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
        rownumbers: true, //�к�
        singleSelect: true, //ֻ����ѡ��һ��
        pageSize: 20,
        pageList: [10, 20, 30, 50, 100], //ҳ���Сѡ���б�
        pagination: true, //��ҳ
        fit: true,
        idField: 'rowid',
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
                EditFun(mainRow, 0);
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
    //���Ӱ�ť
    $("#AddBn").click(function () {
        addFun(); //��������������

    })
    //��Ԫ����»���--��ɫ
    function formatblue(value, row, index) {
        return '<span class="grid-td-text">' + value + '</span>';
    }
    //��ѡ���и�ʽ������
    function formatselect(value, row, index) {
        return '<a href="#" id="aa" class="SpecialClass" title="�ύ" data-options="iconCls:\'icon-submit\'" onclick=submits(' + index + ') ></a>' +
            '<a href="#" class="SpecialClass" title="����" data-options="iconCls:\'icon-arrow-left-top\'" onclick=back(' + index + ') ></a>' +
            '<a href="#"  class="SpecialClass" title="ɾ��" data-options="iconCls:\'icon-cancel\'" onclick=del(' + index + ')></a>' +
            '<a href="#"  class="SpecialClass" title="����" data-options="iconCls:\'icon-attachment\'" ></a>'
    }
    //�����ѯ��ť 
    $("#FindBn").click(FindBtn);
	//$("#aa").addClass("grayscale");
    //�ύ����
    submits = function (index) {
        onClickRow(index);
        var selectedRow = $('#MainGrid').datagrid("getSelected");
        var billid = selectedRow.rowid;
        var BillState = selectedRow.BillState;
        if (BillState != "����" && (BillState != "�½�")) {
            var message = "�õ��ݲ����ύ!"
            $.messager.popover({
                msg: message,
                type: 'alert',
                style: {
                    "position": "absolute",
                    "z-index": "9999",
                    left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                    top: 1
                }
            });
            return
        } else {
            $.messager.confirm('��ʾ', '�ύ�󲻿��ٱ༭���Ƿ��ύ��', function (r) {
                if (r) {
                    //console.log(billid, selectedRow.YearMonth, selectedRow.Checkid, userid);
                    $.m({
                            ClassName: 'herp.budg.hisui.udata.uBudgCtrlPrePay',
                            MethodName: 'prePaySubmit',
                            billid: billid,
                            yearMonth: selectedRow.YearMonth,
                            checkFlowMainDr: selectedRow.Checkid,
                            userid: userid
                        },

                        function (Data) {
                            if (Data == 0) {
                                $.messager.popover({
                                    msg: '�ύ�ɹ���',
                                    type: 'success',
                                    style: {
                                        "position": "absolute",
                                        "z-index": "9999",
                                        left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                        top: 1
                                    }
                                });
                            } else {
                                $.messager.popover({
                                    msg: '������Ϣ:' + Data,
                                    type: 'error',
                                    style: {
                                        "position": "absolute",
                                        "z-index": "9999",
                                        left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                        top: 1
                                    }
                                });
                            }
                        }
                    );
                    $('#MainGrid').datagrid("reload");
                    $("#MainGrid").datagrid("selectRecord",billid);
                }
            });
        }
    };
    //��������   
    back = function (index) {
        onClickRow(index);
        var selectedRow = $('#MainGrid').datagrid("getSelected");
        var billid = selectedRow.rowid;
        var BillState = selectedRow.BillState;
        if (BillState == "����" || (BillState == "���") || (BillState == "�½�")) {
            var message = "�����뵥���ܳ���!"
            $.messager.popover({
                msg: message,
                type: 'alert',
                style: {
                    "position": "absolute",
                    "z-index": "9999",
                    left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                    top: 1
                }
            });
            return;

        } else {
            $.m({
                    ClassName: 'herp.budg.hisui.udata.uBudgCtrlPrePay',
                    MethodName: 'getCheckStep',
                    BillDR: billid,
                    Chercker: userid
                },
                function (Data) {
                    var arr = Data.split(",");
                    //console.log(arr);
                    if (arr[0] != 1) {
                        //console.log(arr[1]);
                        var message = "�����뵥���ܳ���!"
                        $.messager.popover({
                            msg: message,
                            type: 'alert',
                            style: {
                                "position": "absolute",
                                "z-index": "9999",
                                left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                top: 1
                            }
                        });
                        return;
                    }
                    if ((arr[1] == 1) && (BillState != "�ύ")) {
                        var message = "�����뵥���ܳ���!"
                        $.messager.popover({
                            msg: message,
                            type: 'alert',
                            style: {
                                "position": "absolute",
                                "z-index": "9999",
                                left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                top: 1
                            }
                        });
                        return;
                    }

                    $.messager.confirm('��ʾ', '�Ƿ�����', function (r) {
                        if (r) {
                            $.m({
                                    ClassName: 'herp.budg.hisui.udata.uBudgCtrlPrePay',
                                    MethodName: 'prePayBack',
                                    billid: billid,
                                    yearMonth: selectedRow.YearMonth,
                                    checkFlowMainDr: selectedRow.Checkid,
                                    userid: userid
                                },
                                function (Data) {
                                    if (Data == 0) {
                                        $.messager.popover({
                                            msg: '�����ɹ���',
                                            type: 'success',
                                            style: {
                                                "position": "absolute",
                                                "z-index": "9999",
                                                left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                                top: 1
                                            }
                                        });
                                    } else {
                                        $.messager.popover({
                                            msg: '������Ϣ:' + Data,
                                            type: 'error',
                                            style: {
                                                "position": "absolute",
                                                "z-index": "9999",
                                                left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                                top: 1
                                            }
                                        });
                                    }
                                }
                            );
                            $('#MainGrid').datagrid("reload");
                            $("#MainGrid").datagrid("selectRecord",billid);
                        }
                    });
                })
        }
    };
    //ɾ������
    del = function (index) {
        onClickRow(index);
        var selectedRow = $('#MainGrid').datagrid("getSelected");
        var rowid = selectedRow.rowid;
        var BillState = selectedRow.BillState;
        sig = 1; //  ����Ƿ���ɾ����ϸ��
        //console.log(BillState)
        if (BillState != "�½�" && (BillState != "����")) {
            var message = "���뵥���ύ����ˣ�������ɾ��!"
            $.messager.popover({
                msg: message,
                type: 'alert',
                style: {
                    "position": "absolute",
                    "z-index": "9999",
                    left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                    top: 1
                }
            });
            return
        } else {
            $.messager.confirm('��ʾ', '�Ƿ�ɾ����', function (r) {
                if (r) {
                    var sig = 0;
                    $.messager.confirm('��ʾ', '�Ƿ���ɾ����ϸ����Ϣ', function (r) {
                        if (r) {
                            sig = 1; //  ����Ƿ���ɾ����ϸ��
                            $.m({
                                    ClassName: 'herp.budg.hisui.udata.uBudgCtrlPrePay',
                                    MethodName: 'delPrePay',
                                    rowid: rowid,
                                    sig: sig
                                },
                                function (Data) {
                                    if (Data == 0) {
                                        $.messager.popover({
                                            msg: 'ɾ���ɹ���',
                                            type: 'success',
                                            style: {
                                                "position": "absolute",
                                                "z-index": "9999",
                                                left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                                top: 1
                                            }
                                        });
                                    } else {
                                        $.messager.popover({
                                            msg: '������Ϣ:' + Data,
                                            type: 'error',
                                            style: {
                                                "position": "absolute",
                                                "z-index": "9999",
                                                left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                                top: 1
                                            }
                                        });
                                    }
                                }
                            );
                            $('#MainGrid').datagrid("reload");
                            
                        }
                    });
                }
            });

        }
    };

}