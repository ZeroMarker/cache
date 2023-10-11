var hospid = session['LOGON.HOSPID'];
var userid = session['LOGON.USERID'];
//������
//isAudit=0 Ϊ�����ʱ���ã�Ϊ1ʱΪ���ʱ����,����ʱisAuditΪ100
addEditFun = function (mainRow, isAudit) {
    if (mainRow == "") {
        mainrowid = "";
    } else {
        mainrowid = mainRow.rowid;
    }

    //��ʼ��������
    var $win;
    $win = $('#AddWin').window({
        title: '������',
        width: 950,
        height: 500,
        top: ($(window).height() - 500) * 0.5,
        left: ($(window).width() - 950) * 0.5,
        shadow: true,
        modal: true,
        iconCls: 'icon-w-new',
        closed: true,
        minimizable: false,
        maximizable: false,
        collapsible: false,
        resizable: true,
        onBeforeOpen: function () {
            if (mainRow != "") {
                mainrowid = mainrowid;
                $("#AddApplyCbox").val(mainRow.BillCode);
                $("#AddNumberbox").val(mainRow.BKCardNo);
                $("#AddBankbox").val(mainRow.BKName);
                $("#AddDescbox").val(mainRow.Desc);
            }

        },
        onClose: function () { //�رմ��ں󴥷�
            $("#Addfm").form("reset");
            $("#AddApplyCbox").val("");
            $("#AddDescbox").val("");
            $("#AddNumberbox").val("");
            $("#AddBankbox").val("");
            $("#MainGrid").datagrid("reload"); //�رմ��ڣ����¼��������
            $("#MainGrid").datagrid("selectRecord",mainrowid);
            //console.log(mainrowid);
            
            //console.log(mainrowid);
        }
    });
    $win.window('open');

    $("#AddClose").unbind('click').click(function () {
        $win.window('close');
    })

    //������������
    var AddUserObj = $HUI.combobox("#AddUserbox", {
        url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=UserName",
        mode: 'remote',
        required: true,
        delay: 200,
        valueField: 'rowid',
        textField: 'name',
        onBeforeLoad: function (param) {
            param.hospid = hospid;
            //param.userdr = userid;
            param.str = param.q;
        },
        onLoadSuccess: function () {
            $("#AddUserbox").combobox("setValue", mainRow.UserDR);
        },
        onSelect: function (rec) {
            $("#AddBankbox").val(""); //�������
            $("#AddNumberbox").val(""); //������п���          
            if ($('#AddPaybox').combobox('getValue') == 2) {
                $('#AddBankbox').attr("disabled", false);
                $('#AddNumberbox').attr("disabled", false);
                $.m({
                        ClassName: 'herp.budg.hisui.udata.uBudgCtrlFundBillMng',
                        MethodName: 'GetBankInfo',
                        userID: rec.rowid
                    },
                    function (Data) {
                        var arr = Data.split("^");
                        $("#AddBankbox").val(arr[1]);
                        $("#AddNumberbox").val(arr[0]);
                    }
                );
            }
        }
    });
    // ������ҵ�������
    var AddDeptboxObj = $HUI.combobox("#AddDeptbox", {
        url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode: 'remote',
        required: true,
        delay: 200,
        valueField: 'rowid',
        textField: 'name',
        onBeforeLoad: function (param) {
            param.hospid = hospid;
            param.userdr = $('#AddUserbox').combobox('getValue');
            param.flag = 1;
            param.str = param.q;
        },
        onLoadSuccess: function () {
            $("#AddDeptbox").combobox("setValue", mainRow.deptID);
        },
        onSelect: function (rec) {
            if (!$("#AddMainGrid").datagrid("getSelected")) {
                var deptida = ""
            } else {
                var deptida = $("#AddMainGrid").datagrid("getSelected").auDeptId
            }
            $.m({
                    ClassName: 'herp.budg.hisui.udata.uBudgSurplus',
                    MethodName: 'FinalBudg',
                    compdr: hospid,
                    yearmonth: $('#AddYMbox').combobox('getValue'),
                    itemcode: $('#itemCodebox').combobox('getValue'),
                    billid: mainrowid,
                    ecocode: $('#ecoCodebox').combobox('getValue'),
                    purcode: $('#purCodebox').combobox('getValue'),
                    ctrltype: $('#contMethodbox').combobox('getValue'),
                    deptid: deptida,
                    billtype: 1 ///��
                },
                function (Data) {
                    if (editIndex != undefined) {
                        var target = $('#AddMainGrid').datagrid('getEditor', {
                            'index': editIndex,
                            'field': 'Balance'
                        }).target;
                        target.attr("disabled", true);
                        target.val(Data);
                    }
                })
        }
    });
    // �������µ�������
    var AddYMboxObj = $HUI.combobox("#AddYMbox", {
        url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode: 'remote',
        required: true,
        delay: 200,
        valueField: 'year',
        textField: 'year',
        onBeforeLoad: function (param) {
            param.flag = 1;
            param.str = param.q;
            $("#AddYMbox").combobox("setValue", mainRow.YearMonth);
        },

        onSelect: function (rec) {
            ///���ɵ���
            $("#AddApplyCbox").val()
            var date = new Date();
            var month = date.getMonth() + 1;
            if (month < 10) {
                var month = "0" + month.toString();
            }
            var day = date.getDate();
            if (day < 10) {
                var day = "0" + day.toString();
            }
            var monthday = month.toString() + day.toString();
            ///console.log(monthday);
            $.m({
                    ClassName: 'herp.budg.hisui.udata.uBudgBillCodeRule',
                    MethodName: 'Getbcode',
                    yearMonth: rec.year,
                    date: monthday,
                    firstName: "",
                    billType: 4
                },
                function (Data) {
                    $("#AddApplyCbox").val(Data);
                }
            );
            $('#itemCodebox').combobox('clear'); //���ԭ��������
            var url = $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlItemCode&yearmonth=" + $("#AddYMbox").combobox("getValue");
            $('#itemCodebox').combobox('reload', url); //���������б�����  

            $('#ecoCodebox').combobox('clear'); //���ԭ��������
            var url = $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlEcoCode&itemCode=" + $('#itemCodebox').combobox("getValue") + "&yearmonth=" + $("#AddYMbox").combobox("getValue");
            $('#ecoCodebox').combobox('reload', url); //���������б����� 

            if (!$("#AddMainGrid").datagrid("getSelected")) {
                var deptida = ""
            } else {
                var deptida = $("#AddMainGrid").datagrid("getSelected").auDeptId
            }
            $.m({
                    ClassName: 'herp.budg.hisui.udata.uBudgSurplus',
                    MethodName: 'FinalBudg',
                    compdr: hospid,
                    yearmonth: rec.year,
                    itemcode: $('#itemCodebox').combobox('getValue'),
                    billid: mainrowid,
                    ecocode: $('#ecoCodebox').combobox('getValue'),
                    purcode: $('#purCodebox').combobox('getValue'),
                    ctrltype: $('#contMethodbox').combobox('getValue'),
                    deptid: deptida,
                    billtype: 1 ///��
                },
                function (Data) {
                    if (editIndex != undefined) {
                        var target = $('#AddMainGrid').datagrid('getEditor', {
                            'index': editIndex,
                            'field': 'Balance'
                        }).target;
                        target.attr("disabled", true);
                        target.val(Data);
                    }
                })
        }
    });

    // ֧����ʽ��������
    var AddPayboxObj = $HUI.combobox("#AddPaybox", {
        mode: 'local',
        valueField: 'rowid',
        textField: 'name',
        required: true,
        data: [{
            'rowid': 1,
            'name': "�ֽ�"
        }, {
            'rowid': 2,
            'name': "����"
        }],
        onLoadSuccess: function () {
            $("#AddPaybox").combobox("setValue", mainRow.PayMeth);
            if ($("#AddPaybox").combobox("getValue") == 1) {
	            //alert("sss")
                $('#AddBankbox').attr("disabled", true);
                $('#AddNumberbox').attr("disabled", true);
                //alert("ssssss")
            }else{
	            $('#AddBankbox').attr("disabled", false);
                $('#AddNumberbox').attr("disabled", false);
	            }
        },
        onSelect: function (rec) {
            $("#AddBankbox").val(""); //�������
            $("#AddNumberbox").val(""); //������п���   
            if (rec.rowid == 1) {
                $('#AddBankbox').attr("disabled", true);
                $('#AddNumberbox').attr("disabled", true);
            }
            if ($('#AddUserbox').combobox('getValue')) {
                if (rec.rowid == 2) {
                    $('#AddBankbox').attr("disabled", false);
                    $('#AddNumberbox').attr("disabled", false);
                    $.m({
                            ClassName: 'herp.budg.hisui.udata.uBudgCtrlFundBillMng',
                            MethodName: 'GetBankInfo',
                            userID: $('#AddUserbox').combobox('getValue')
                        },
                        function (Data) {
                            var arr = Data.split("^");
                            $("#AddBankbox").val(arr[1]);
                            $("#AddNumberbox").val(arr[0]);
                        }
                    );
                }
            }
        }
    });

    ///���Ʒ�ʽ������
    $.m({
            ClassName: 'herp.budg.hisui.common.CommMethod',
            MethodName: 'isControl'
        },
        function (Data) {
            var arr = Data.split("^");
            if (arr[1] == 1) {
                $("#contMethodbox").combobox(
                    "loadData",
                    [{
                            'rowid': "������Ŀ",
                            'name': "������Ŀ"
                        },
                        {
                            'rowid': "���ÿ�Ŀ",
                            'name': "���ÿ�Ŀ"
                        },
                        {
                            'rowid': "�ɹ�ƷĿ",
                            'name': "�ɹ�ƷĿ"
                        }
                    ]);
            } else {
                $("#contMethodbox").combobox(
                    "loadData",
                    [{
                        'rowid': "������Ŀ",
                        'name': "������Ŀ"
                    }])
            }
        })
    var contMethodObj = $HUI.combobox("#contMethodbox", {
        mode: 'local',
        required: true,
        valueField: 'rowid',
        textField: 'name',
        onSelect: function (rec) {
            if (rec.rowid == "���ÿ�Ŀ") {
                $("#ecoCodebox").combobox("enable");
                $("#purCodebox").combobox("disable");
            }
            if (rec.rowid == "�ɹ�ƷĿ") {
                $("#ecoCodebox").combobox("enable");
                $("#purCodebox").combobox("enable");
            }
            if (rec.rowid == "������Ŀ") {
                $("#ecoCodebox").combobox("disable");
                $("#purCodebox").combobox("disable");
            }
            $('#ecoCodebox').combobox('clear');
            $('#itemCodebox').combobox('clear'); //���ԭ��������
            $('#purCodebox').combobox('clear');
            if (editIndex != undefined) {
                var target = $('#AddMainGrid').datagrid('getEditor', {
                    'index': editIndex,
                    'field': 'ecoCode'
                }).target;
                target.val('');
                var target = $('#AddMainGrid').datagrid('getEditor', {
                    'index': editIndex,
                    'field': 'purCode'
                }).target;
                target.val('');
                var target = $('#AddMainGrid').datagrid('getEditor', {
                    'index': editIndex,
                    'field': 'ctrlMeth'
                }).target;
                target.val(rec.rowid);
                var row = $("#AddMainGrid").datagrid("getSelected")
                $.m({
                        ClassName: 'herp.budg.hisui.udata.uBudgSurplus',
                        MethodName: 'FinalBudg',
                        compdr: hospid,
                        yearmonth: $('#AddYMbox').combobox('getValue'),
                        itemcode: $('#itemCodebox').combobox('getValue'),
                        billid: mainrowid,
                        ecocode: $('#ecoCodebox').combobox('getValue'),
                        purcode: $('#purCodebox').combobox('getValue'),
                        ctrltype: $('#contMethodbox').combobox('getValue'),
                        deptid: row.auDeptId,
                        billtype: 1 ///��
                    },
                    function (Data) {
                        var target = $('#AddMainGrid').datagrid('getEditor', {
                            'index': editIndex,
                            'field': 'Balance'
                        }).target;
                        target.attr("disabled", true);
                        target.val(Data);
                    })
            }
        }
    })

    // ������Ŀ��������
    var itemCodeboxObj = $HUI.combobox("#itemCodebox", {
        url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlItemCode",
        mode: 'remote',
        delay: 200,
        required: true,
        valueField: 'code',
        textField: 'name',
        onBeforeLoad: function (param) {
            param.yearmonth = mainRow.YearMonth || $("#AddYMbox").combobox("getValue");
            param.str = param.q;
        },
        onSelect: function (rec) {
            $('#ecoCodebox').combobox('clear'); //���ԭ��������
            var url = $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlEcoCode&itemCode=" + $('#itemCodebox').combobox("getValue") + "&yearmonth=" + $("#AddYMbox").combobox("getValue");
            $('#ecoCodebox').combobox('reload', url); //���������б�����  
            $('#purCodebox').combobox('clear'); //���ԭ��������
            var url = $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlPurCode&itemCode=" + $('#itemCodebox').combobox("getValue") + "&yearmonth=" + $("#AddYMbox").combobox("getValue") + "&ecoCode=" + $("#ecoCodebox").combobox("getValue");
            $('#purCodebox').combobox('reload', url); //���������б�����
            ///����ڶ�Ӧ��Ԫ��ֵ
            if (editIndex != undefined) {
                var target = $('#AddMainGrid').datagrid('getEditor', {
                    'index': editIndex,
                    'field': 'fundName'
                }).target;
                target.val(rec.name);
                var target = $('#AddMainGrid').datagrid('getEditor', {
                    'index': editIndex,
                    'field': 'itemCode'
                }).target;
                target.val(rec.code);
                var target = $('#AddMainGrid').datagrid('getEditor', {
                    'index': editIndex,
                    'field': 'ecoCode'
                }).target;
                target.val('');
                var target = $('#AddMainGrid').datagrid('getEditor', {
                    'index': editIndex,
                    'field': 'purCode'
                }).target;
                target.val('');
                var target = $('#AddMainGrid').datagrid('getEditor', {
                    'index': editIndex,
                    'field': 'auDeptId'
                }).target;
                target.combobox("setValue", "")
                var url = $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlAudeptid&itemCode=" + rec.rowid + "&yearmonth=" + $("#AddYMbox").combobox("getValue") + "&hospid=" + hospid;
                target.combobox('reload', url);
                var row = $("#AddMainGrid").datagrid("getSelected");
                $.m({
                        ClassName: 'herp.budg.hisui.udata.uBudgSurplus',
                        MethodName: 'FinalBudg',
                        compdr: hospid,
                        yearmonth: $('#AddYMbox').combobox('getValue'),
                        itemcode: $('#itemCodebox').combobox('getValue'),
                        billid: mainrowid,
                        ecocode: $('#ecoCodebox').combobox('getValue'),
                        purcode: $('#purCodebox').combobox('getValue'),
                        ctrltype: $('#contMethodbox').combobox('getValue'),
                        deptid: row.auDeptId,
                        billtype: 1 ///��
                    },
                    function (Data) {
                        var target = $('#AddMainGrid').datagrid('getEditor', {
                            'index': editIndex,
                            'field': 'Balance'
                        }).target;
                        target.attr("disabled", true);
                        target.val(Data);
                    })
            }
        }
    });

    // ���ÿ�Ŀ��������
    var ecoCodeboxObj = $HUI.combobox("#ecoCodebox", {
        url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlEcoCode",
        mode: 'remote',
        delay: 200,
        valueField: 'code',
        textField: 'name',
        onBeforeLoad: function (param) {
            param.itemCode = $("#itemCodebox").combobox("getValue");
            param.yearmonth = $("#AddYMbox").combobox("getValue");
            param.str = param.q;
        },
        onSelect: function (rec) {
            $('#purCodebox').combobox('clear'); //���ԭ��������
            var url = $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlPurCode&itemCode=" + $('#itemCodebox').combobox("getValue") + "&yearmonth=" + $("#AddYMbox").combobox("getValue") + "&ecoCode=" + $("#ecoCodebox").combobox("getValue");
            $('#purCodebox').combobox('reload', url); //���������б����� 
            if (editIndex != undefined) {
                var target = $('#AddMainGrid').datagrid('getEditor', {
                    'index': editIndex,
                    'field': 'ecoCode'
                }).target;
                target.val(rec.code);
                var target = $('#AddMainGrid').datagrid('getEditor', {
                    'index': editIndex,
                    'field': 'purCode'
                }).target;
                target.val('');
                if (!$('#purCodebox').combobox('getValue')) {
                    var target = $('#AddMainGrid').datagrid('getEditor', {
                        'index': editIndex,
                        'field': 'fundName'
                    }).target;
                    target.val(rec.name);
                }
            }
            if (editIndex != undefined) {
                var row = $("#AddMainGrid").datagrid("getSelected")
                $.m({
                        ClassName: 'herp.budg.hisui.udata.uBudgSurplus',
                        MethodName: 'FinalBudg',
                        compdr: hospid,
                        yearmonth: $('#AddYMbox').combobox('getValue'),
                        itemcode: $('#itemCodebox').combobox('getValue'),
                        billid: mainrowid,
                        ecocode: $('#ecoCodebox').combobox('getValue'),
                        purcode: $('#purCodebox').combobox('getValue'),
                        ctrltype: $('#contMethodbox').combobox('getValue'),
                        deptid: row.auDeptId,
                        billtype: 1 ///��
                    },
                    function (Data) {
                        var target = $('#AddMainGrid').datagrid('getEditor', {
                            'index': editIndex,
                            'field': 'Balance'
                        }).target;
                        target.attr("disabled", true);
                        target.val(Data);
                    })
            }
        }
    });

    // �ɹ�ƷĿ��������
    var purCodeboxObj = $HUI.combobox("#purCodebox", {
        url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlPurCode",
        mode: 'remote',
        delay: 200,
        valueField: 'code',
        textField: 'name',
        onBeforeLoad: function (param) {
            param.itemCode = $("#itemCodebox").combobox("getValue");
            param.yearmonth = $("#AddYMbox").combobox("getValue");
            param.ecoCode = $("#ecoCodebox").combobox("getValue");
            param.str = param.q
        },
        onSelect: function (rec) {
            if (editIndex != undefined) {
                var target = $('#AddMainGrid').datagrid('getEditor', {
                    'index': editIndex,
                    'field': 'purCode'
                }).target;
                target.val(rec.code);
                var target = $('#AddMainGrid').datagrid('getEditor', {
                    'index': editIndex,
                    'field': 'fundName'
                }).target;
                target.val(rec.name);
            }
            if (editIndex != undefined) {
                var row = $("#AddMainGrid").datagrid("getSelected")
                $.m({
                        ClassName: 'herp.budg.hisui.udata.uBudgSurplus',
                        MethodName: 'FinalBudg',
                        compdr: hospid,
                        yearmonth: $('#AddYMbox').combobox('getValue'),
                        itemcode: $('#itemCodebox').combobox('getValue'),
                        billid: mainrowid,
                        ecocode: $('#ecoCodebox').combobox('getValue'),
                        purcode: $('#purCodebox').combobox('getValue'),
                        ctrltype: $('#contMethodbox').combobox('getValue'),
                        deptid: row.auDeptId,
                        billtype: 1 ///��
                    },
                    function (Data) {
                        var target = $('#AddMainGrid').datagrid('getEditor', {
                            'index': editIndex,
                            'field': 'Balance'
                        }).target;
                        target.attr("disabled", true);
                        target.val(Data);
                    })
            }
        }

    });


    //�����ö���
    AddColumns = [
        [{
                field: 'ckbox',
                checkbox: true
            }, //��ѡ�� 
            {
                field: 'rowid',
                title: 'ID',
                width: 30,
                hidden: true
            },
            {
                field: 'BillDR',
                title: '�������ID',
                width: 80,
                hidden: true
            },
            {
                field: 'fundName',
                title: '������',
                align: 'right',
                width: 80,
                editor: {
                    type: 'text'
                }
            },
            {
                field: 'itemCode',
                title: '������Ŀ',
                align: 'right',
                hidden: true,
                width: 80,
                editor: {
                    type: 'text'
                }
            },
            {
                field: 'ecoCode',
                title: '���ÿ�Ŀ',
                hidden: true,
                align: 'right',
                width: 80,
                editor: {
                    type: 'text'
                }
            },
            {
                field: 'purCode',
                title: '�ɹ�ƷĿ',
                hidden: true,
                align: 'right',
                width: 80,
                editor: {
                    type: 'text'
                }
            },
            {
                field: 'auDeptId',
                title: '��ڿ���',
                align: 'left',
                width: 120,
                formatter: function (value, row, index) {
                    return row.audeptName;
                },
                editor: {
                    type: 'combobox',
                    options: {
                        mode: 'remote',
                        url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlAudeptid",
                        delay: 200,
                        valueField: 'rowid',
                        textField: 'name',
                        onBeforeLoad: function (param) {
                            param.itemCode = $("#itemCodebox").combobox("getValue");
                            param.yearmonth = $("#AddYMbox").combobox("getValue");
                            param.str = param.q;
                            param.hospid = hospid;
                        },
                        onSelect: function (rec) {
                            $.m({
                                    ClassName: 'herp.budg.hisui.udata.uBudgSurplus',
                                    MethodName: 'FinalBudg',
                                    compdr: hospid,
                                    yearmonth: $('#AddYMbox').combobox('getValue'),
                                    itemcode: $('#itemCodebox').combobox('getValue'),
                                    billid: mainrowid,
                                    ecocode: $('#ecoCodebox').combobox('getValue'),
                                    purcode: $('#purCodebox').combobox('getValue'),
                                    ctrltype: $('#contMethodbox').combobox('getValue'),
                                    deptid: rec.rowid,
                                    billtype: 1 ///��
                                },
                                function (Data) {
                                    if (editIndex != undefined) {
                                        var target = $('#AddMainGrid').datagrid('getEditor', {
                                            'index': editIndex,
                                            'field': 'Balance'
                                        }).target;
                                        target.attr("disabled", true);
                                        target.val(Data);
                                    }
                                })
                        }
                    }
                }
            },
            {
                field: 'Balance',
                title: '����',
                align: 'right',
                width: 80,
                editor: {
                    type: 'text'
                },
                formatter: dataFormat
            },
            {
                field: 'ReqPay',
                title: '�����',
                align: 'right',
                width: 80,
                editor: {
                    type: 'text',
                    option: {
                        required: true
                    }
                },
                formatter: dataFormat
            },
            {
                field: 'ActPay',
                title: '������',
                align: 'right',
                width: 80,
                formatter: dataFormat
            },
            {
                field: 'Balance1',
                title: '������Ԥ�����',
                align: 'right',
                width: 90,
                formatter: dataFormat
            },
            {
                field: 'budgcotrol',
                title: 'Ԥ�����',
                align: 'left',
                width: 80,
                styler: function (value, row, index) {
                    var sf = row.budgcotrol;
                    if (sf == "��Ԥ��") {
                        return 'background-color:#ee4f38;color:white';
                    }
                }
            },
            {
                field: 'ctrlMeth',
                title: '���Ʒ�ʽ',
                align: 'left',
                width: 80,
                editor: {
                    type: 'text',
                }
            }
        ]
    ];


    //������
    var addmainGrid = $HUI.datagrid("#AddMainGrid", {
        url: $URL,
        queryParams: {
            ClassName: "herp.budg.hisui.udata.uBudgCtrlFundBillMng",
            MethodName: "List",
            hospid: hospid,
            yearmonth: mainRow.YearMonth,
            Billid: mainrowid
        },
        checkOnSelect: true, //ѡ���и�ѡ��ѡ
        selectOnCheck: true, //ѡ���и�ѡ��ѡ        
        fitColumns: true, //�й̶�
        loadMsg: "���ڼ��أ����Եȡ�",
        autoRowHeight: true,
        rownumbers: true, //�к�
        pageSize: 20,
        singleSelect: true,
        showFooter: true,
        pageList: [10, 20, 30, 50, 100], //ҳ���Сѡ���б�
        pagination: true, //��ҳ
        fit: true,
        onClickRow: onClickRow,
        columns: AddColumns,
        striped: true,
        toolbar: '#Addnorth'
    });

    ///�е���¼�
    var editIndex = undefined;

    function endEditing() {
        ///�������л��߻��е��html������ʾ������ı�ֵ
        //console.log("editIndex:"+ editIndex)
        var ed = $('#AddMainGrid').datagrid('getEditor', {
            index: editIndex,
            field: 'auDeptId'
        });
        if (ed) {
            var auDeptName = $(ed.target).combobox('getText');
            $('#AddMainGrid').datagrid('getRows')[editIndex]['audeptName'] = auDeptName;
        }
        //console.log("auDeptName:"+auDeptName)
        if (editIndex == undefined) {
            return true
        }
        if ($('#AddMainGrid').datagrid('validateRow', editIndex)) {
            $('#AddMainGrid').datagrid('endEdit', editIndex);
            editIndex = undefined;
            return true;
        } else {
            return false;
        }
    }

    function onClickRow(index) {
        var row = $('#AddMainGrid').datagrid('getSelected');
        if (row.ctrlMeth == "������Ŀ") {
            $("#ecoCodebox").combobox("disable");
            $("#purCodebox").combobox("disable");
        }
        if (row.ctrlMeth == "���ÿ�Ŀ") {
            $("#purCodebox").combobox("disable");
            $("#ecoCodebox").combobox("enable");
        }

        ///console.log(isAudit, row.detailState)
        if (row.detailState != 1 && (row.detailState != 4) && (isAudit == 0)) {
            return false;
        }
        if (row.fundName == "�ϼ�") {
            return false
        }
        ///�˴��ڱ���˽������ʱ��
        if (isAudit == 1) {
            ///���״̬��ȥ����Щ�еı༭
            var ee = $('#AddMainGrid').datagrid('getColumnOption', 'auDeptId');
            ee.editor = {};
            var ff = $('#AddMainGrid').datagrid('getColumnOption', 'ReqPay');
            ff.editor = {};
            var hh = $('#AddMainGrid').datagrid('getColumnOption', 'ActPay');
            hh.editor = {
                type: 'text'
            };
            $('#AddMainGrid').datagrid('beginEdit', index);
            ///�жϵ�ǰ�������ܷ�༭����ǰ������Ϊ��ǰ��ڿ��ҵĲ����ˣ�
            //alert(mainRow.Checkdr)
            $.m({
                    ClassName: 'herp.budg.hisui.udata.uBudgCtrlFundBillMng',
                    MethodName: 'isEdit',
                    billid: mainrowid,
                    userid: userid,
                    billtype: 4,
                    audeptid: row.auDeptId,
                    checkflowid: mainRow.Checkdr
                },
                function (rtn) {
                    ///���û�У���ôȡ���༭
                    if (rtn == 100) {
                        $('#AddMainGrid').datagrid('cancelEdit', index);
                    }
                })
            ///������Ŀ�����������ѡ�Ĺ�ڿ��Ҹı䶯̬��������
            $('#itemCodebox').combobox('reload', $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlItemCode&audeptid=' + row.auDeptId + '&yearmonth=' + $("#AddYMbox").combobox("getValue"));


        }
        var row = $('#AddMainGrid').datagrid('getSelected');
        $('#itemCodebox').combobox('setValue', row.itemCode);
        $('#ecoCodebox').combobox('setValue', row.ecoCode);
        $('#purCodebox').combobox('setValue', row.purCode);
        $('#contMethodbox').combobox('setValue', row.ctrlMeth);
        if (editIndex) {
            var target = $('#AddMainGrid').datagrid('getEditor', {
                index: editIndex,
                field: 'fundName'
            }).target;
            if ($('#purCodebox').combobox("getValue")) {
                target.attr("setValue", $('#purCodebox').combobox("getText"));
            } else if ($('#ecoCodebox').combobox("getValue")) {
                target.attr("setValue", $('#ecoCodebox').combobox("getText"));
            } else {
                target.attr("setValue", $('#itemCodebox').combobox("getText"));
            }
        }
        var ed = $('#AddMainGrid').datagrid('getEditor', {
            index: editIndex,
            field: 'auDeptId'
        });
        if (ed) {
            var auDeptName = $(ed.target).combobox('getText');
            $('#AddMainGrid').datagrid('getRows')[editIndex]['audeptName'] = auDeptName;
        }
        $('#AddMainGrid').datagrid('endEdit', editIndex);

        if (endEditing()) {
            $('#AddMainGrid').datagrid('selectRow', index)
            $('#AddMainGrid').datagrid('beginEdit', index);
            editIndex = index;
            var target = $('#AddMainGrid').datagrid('getEditor', {
                index: editIndex,
                field: 'ctrlMeth'
            }).target;
            target.attr("disabled", true);
            var target = $('#AddMainGrid').datagrid('getEditor', {
                index: editIndex,
                field: 'Balance'
            }).target;
            target.attr("disabled", true);
            var target = $('#AddMainGrid').datagrid('getEditor', {
                index: editIndex,
                field: 'fundName'
            }).target;
            target.attr("disabled", true);
        } else {
            $('#AddMainGrid').datagrid('selectRow', editIndex)
        }
    }


    ///���ͼ������һ��
    $("#addButton").unbind('click').click(function () {
	     if (isAudit==1) {
		     return false;
			}
        if (endEditing()) {
            if (!$('#AddUserbox').combobox('getValue')) {
                $.messager.popover({
                    msg: "����д������!",
                    type: 'info',
                    showType: 'show',
                    style: {
                        "position": "absolute",
                        "z-index": "9999",
                        left: document.body.scrollLeft / 2 + document.documentElement.scrollLeft / 2,
                        top: 1
                    }
                });
                return false;
            }
            if (!$('#AddDeptbox').combobox('getValue')) {
                $.messager.popover({
                    msg: "����д�������!",
                    type: 'info',
                    showType: 'show',
                    style: {
                        "position": "absolute",
                        "z-index": "9999",
                        left: document.body.scrollLeft / 2 + document.documentElement.scrollLeft / 2,
                        top: 1
                    }
                });
                return false;
            }
            if (!$('#AddYMbox').combobox('getValue')) {
                $.messager.popover({
                    msg: "����дԤ����!",
                    type: 'info',
                    showType: 'show',
                    style: {
                        "position": "absolute",
                        "z-index": "9999",
                        left: document.body.scrollLeft / 2 + document.documentElement.scrollLeft / 2,
                        top: 1
                    }
                });
                return false;
            }
            if (!$('#contMethodbox').combobox('getValue')) {
                $.messager.popover({
                    msg: "����д���Ʒ�ʽ!",
                    type: 'info',
                    showType: 'show',
                    style: {
                        "position": "absolute",
                        "z-index": "9999",
                        left: document.body.scrollLeft / 2 + document.documentElement.scrollLeft / 2,
                        top: 1
                    }
                });
                return false;
            }
            if (!$('#itemCodebox').combobox('getValue')) {
                $.messager.popover({
                    msg: "����д������Ŀ!",
                    type: 'info',
                    showType: 'show',
                    style: {
                        "position": "absolute",
                        "z-index": "9999",
                        left: document.body.scrollLeft / 2 + document.documentElement.scrollLeft / 2,
                        top: 1
                    }
                });
                return false;
            }
            if (!$('#AddPaybox').combobox('getValue')) {
                $.messager.popover({
                    msg: "����д֧����ʽ!",
                    type: 'info',
                    showType: 'show',
                    style: {
                        "position": "absolute",
                        "z-index": "9999",
                        left: document.body.scrollLeft / 2 + document.documentElement.scrollLeft / 2,
                        top: 1
                    }
                });
                return false;
            }
            if ($("#AddDescbox").val() == "") {
                $.messager.popover({
                    msg: '˵������Ϊ�գ�',
                    timeout: 2000,
                    type: 'alert',
                    showType: 'show',
                    style: {
                        "position": "absolute",
                        "z-index": "9999",
                        left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                        top: 1
                    }
                })
                return;
            }
            if ($('#AddPaybox').combobox('getValue') == "2") {
                if (!$('#AddBankbox').val()) {
                    $.messager.popover({
                        msg: "����д����!",
                        type: 'info',
                        showType: 'show',
                        style: {
                            "position": "absolute",
                            "z-index": "9999",
                            left: document.body.scrollLeft / 2 + document.documentElement.scrollLeft / 2,
                            top: 1
                        }
                    });
                    return false;
                }
                if (!$('#AddNumberbox').val()) {
                    $.messager.popover({
                        msg: "����д�˺�!",
                        type: 'info',
                        showType: 'show',
                        style: {
                            "position": "absolute",
                            "z-index": "9999",
                            left: document.body.scrollLeft / 2 + document.documentElement.scrollLeft / 2,
                            top: 1
                        }
                    });
                    return false;
                }
            }
            if ($('#contMethodbox').combobox('getValue') == "���ÿ�Ŀ") {
                var fundName = $('#ecoCodebox').combobox('getText');
            } else if ($('#contMethodbox').combobox('getValue') == "������Ŀ") {
                var fundName = $('#itemCodebox').combobox('getText');
            } else {
                var fundName = $('#purCodebox').combobox('getText');
            }
            var n = $("#AddMainGrid").datagrid("getRows").length;
            //console.log(n)
            $('#AddMainGrid').datagrid('insertRow', {
                index: (n - 1),
                row: {
                    fundName: fundName,
                    ctrlMeth: $('#contMethodbox').combobox('getValue'),
                    itemCode: $('#itemCodebox').combobox('getValue'),
                    ecoCode: $('#ecoCodebox').combobox('getValue'),
                    purCode: $('#purCodebox').combobox('getValue')
                }
            });
            editIndex = (n - 1);
            $('#AddMainGrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
            var target = $('#AddMainGrid').datagrid('getEditor', {
                index: editIndex,
                field: 'ctrlMeth'
            }).target;
            target.attr("disabled", true);
            var target = $('#AddMainGrid').datagrid('getEditor', {
                index: editIndex,
                field: 'fundName'
            }).target;
            target.attr("disabled", true);
        }
    })

    ///�����¼�
    $("#AddSave").unbind('click').click(function () {
        var indexs = $('#AddMainGrid').datagrid('getEditingRowIndexs');
        if (indexs.length > 0) {
            for (j = 0; j < indexs.length; j++) {
                var ed = $('#AddMainGrid').datagrid('getEditor', {
                    index: indexs[j],
                    field: 'auDeptId'
                });
                if (ed) {
                    var auDeptName = $(ed.target).combobox('getText');
                    $('#AddMainGrid').datagrid('getRows')[indexs[j]]['audeptName'] = auDeptName;
                }
                $('#AddMainGrid').datagrid('endEdit', indexs[j]);
            }
        }
        var rows = $('#AddMainGrid').datagrid("getChanges");
        
        if ($("#AddDescbox").val() == "") {
            $.messager.popover({
                msg: '˵������Ϊ�գ�',
                timeout: 2000,
                type: 'alert',
                showType: 'show',
                style: {
                    "position": "absolute",
                    "z-index": "9999",
                    left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                    top: 1
                }
            })
            return;
        }
		if ((rows.length == 0)&&(isAudit == 100)) {
			 $.messager.popover({
				 msg: '����ӱ���о������ݺ��ٱ���',
				 type: 'alert',
				 style: {
					 "position": "absolute",
					 "z-index": "9999",
					 left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
					 top: 1
					 }
			    })
					 return;
					 }
        if ((rows.length == 0)) {
            $.messager.confirm('ȷ��', 'ȷ��Ҫ����ѡ����������', function (t) {
                if (t) {
                    $.m({
                            ClassName: 'herp.budg.hisui.udata.uBudgCtrlFundBillMng',
                            MethodName: 'updateRec',
                            billid: mainrowid,
                            billCode: $("#AddApplyCbox").val(),
                            yearMonth: $('#AddYMbox').combobox('getValue'),
                            deptId: $('#AddDeptbox').combobox('getValue'),
                            userId: $('#AddUserbox').combobox('getValue'),
                            desc: $('#AddDescbox').val().replace(/(^\s*)|(\s*$)/g, ""),
                            bank: $("#AddBankbox").val(),
                            accountNum: $("#AddNumberbox").val(),
                            fundSourse: $('#AddPaybox').combobox('getValue'),
                            userid: userid
                        },
                        function (rtn) {
                            if (rtn == 0) {
                                $.messager.popover({
                                    msg: '����ɹ���',
                                    type: 'success',
                                    style: {
                                        "position": "absolute",
                                        "z-index": "9999",
                                        left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                        top: 1
                                    }
                                });
                                $.messager.progress('close');
                                $("#AddMainGrid").datagrid('reload');
                                editIndex = undefined;
                                return;
                            } else {
                                $.messager.popover({
                                    msg: '����ʧ��' + rtn,
                                    type: 'error',
                                    style: {
                                        "position": "absolute",
                                        "z-index": "9999",
                                        left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                        top: 1
                                    }
                                })
                                $.messager.progress('close');
                                return;
                            }
                        })
                    return;
                }
            })
            return;
        }
        if (rows.length > 0) {
	        if (!$('#contMethodbox').combobox('getValue')) {
            $.messager.popover({
                msg: "����д���Ʒ�ʽ!",
                type: 'info',
                showType: 'show',
                style: {
                    "position": "absolute",
                    "z-index": "9999",
                    left: document.body.scrollLeft / 2 + document.documentElement.scrollLeft / 2,
                    top: 1
                }
            });
            return false;
        }
        if (!$('#itemCodebox').combobox('getValue')) {
            $.messager.popover({
                msg: "����д������Ŀ!",
                type: 'info',
                showType: 'show',
                style: {
                    "position": "absolute",
                    "z-index": "9999",
                    left: document.body.scrollLeft / 2 + document.documentElement.scrollLeft / 2,
                    top: 1
                }
            });
            return false;
        }
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                if (!row.itemCode) {
                    $.messager.popover({
                        msg: '������Ŀ����Ϊ��',
                        type: 'alert',
                        style: {
                            "position": "absolute",
                            "z-index": "9999",
                            left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                            top: 1
                        }
                    })
                    return;
                }
                if (!row.ReqPay) {
                    $.messager.popover({
                        msg: '�������Ϊ��',
                        type: 'alert',
                        style: {
                            "position": "absolute",
                            "z-index": "9999",
                            left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                            top: 1
                        }
                    })
                    return;
                }
                if (!row.auDeptId) {
                    $.messager.popover({
                        msg: '��ڿ��Ҳ���Ϊ��',
                        type: 'alert',
                        style: {
                            "position": "absolute",
                            "z-index": "9999",
                            left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                            top: 1
                        }
                    })
                    return;
                }
                if (!row.ctrlMeth) {
                    $.messager.popover({
                        msg: '���Ʒ�ʽ����Ϊ��',
                        type: 'alert',
                        style: {
                            "position": "absolute",
                            "z-index": "9999",
                            left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                            top: 1
                        }
                    })
                    return;
                }
                if (row.ctrlMeth == "���ÿ�Ŀ") {
                    if (!row.ecoCode) {
                        $.messager.popover({
                            msg: '���ÿ�Ŀ����Ϊ��',
                            type: 'alert',
                            style: {
                                "position": "absolute",
                                "z-index": "9999",
                                left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                top: 1
                            }
                        })
                        return;
                    }
                }
                if (row.ctrlMeth == "�ɹ�ƷĿ") {
                    if (!row.ecoCode) {
                        $.messager.popover({
                            msg: '���ÿ�Ŀ����Ϊ��',
                            type: 'alert',
                            style: {
                                "position": "absolute",
                                "z-index": "9999",
                                left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                top: 1
                            }
                        })
                        return;
                    }
                    if (!row.purCode) {
                        $.messager.popover({
                            msg: '�ɹ�ƷĿ����Ϊ��',
                            type: 'alert',
                            style: {
                                "position": "absolute",
                                "z-index": "9999",
                                left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                top: 1
                            }
                        })
                        return;
                    }
                }
            }
        }
        $.messager.confirm('ȷ��', 'ȷ��Ҫ����ѡ����������', function (t) {
            if (t) {
                $('#AddMainGrid').datagrid('endEdit', editIndex);
                var rows = $('#AddMainGrid').datagrid("getChanges");
                var detaildatas = "";
                if (rows.length > 0) {
                    for (var i = 0; i < rows.length; i++) {
                        var row = rows[i];
                        $.messager.progress({
                            title: '��ʾ',
                            msg: '���ڱ��棬���Ժ򡭡�'
                        })
                        var itemCode = ((row.itemCode == undefined) ? '' : row.itemCode);
                        var ecoCode = ((row.ecoCode == undefined) ? '' : row.ecoCode);
                        var purCode = ((row.purCode == undefined) ? '' : row.purCode);
                        var auDeptId = ((row.auDeptId == undefined) ? '' : row.auDeptId);
                        var ReqPay = ((row.ReqPay == undefined) ? '' : row.ReqPay);
                        var ActPay = ((row.ActPay == undefined) ? '' : row.ActPay);
                        if (ActPay == "" || (isAudit == 0)) {
                            var ActPay = ReqPay
                        }
                        var ctrlMeth = ((row.ctrlMeth == undefined) ? '' : row.ctrlMeth);
                        var Balance = ((row.Balance == undefined) ? '' : row.Balance);
                        var detailRowid = ((row.rowid == undefined) ? '' : row.rowid);
                        if (isAudit == 1) {
                            var userid = 0;
                        } else {
                            var userid = session['LOGON.USERID'];
                        }
                        ///alert(userid);
                        var maindata = mainrowid + "|" + $("#AddApplyCbox").val() + "|" +
                            $('#AddYMbox').combobox('getValue') + "|" +
                            $('#AddDeptbox').combobox('getValue') + "|" + $('#AddUserbox').combobox('getValue') + "|" +
                            $('#AddDescbox').val().replace(/(^\s*)|(\s*$)/g, "") + "|" +
                            $("#AddBankbox").val() + "|" + $("#AddNumberbox").val() + "|" + $('#AddPaybox').combobox('getValue') + "|" + hospid + "|" + userid

                        var detaildata = detailRowid + "|" + itemCode + "|" + ecoCode +
                            "|" + purCode + "|" + ctrlMeth +
                            "|" + ReqPay + "|" + ActPay + "|" + $('#AddDescbox').val().replace(/(^\s*)|(\s*$)/g, "") +
                            "|" + Balance + "|" + auDeptId;
                        ///console.log(detaildata);  
                        if (detaildatas == "") {
                            var detaildatas = detaildata;
                        } else {
                            var detaildatas = detaildatas + "^" + detaildata;
                        }
                    }
                    $.m({
                            ClassName: 'herp.budg.hisui.udata.uBudgCtrlFundBillMng',
                            MethodName: 'save',
                            maindata: maindata,
                            detaildatas: detaildatas
                        },
                        function (rtn) {
                            if (rtn == 0) {
                                $.messager.popover({
                                    msg: '����ɹ���',
                                    type: 'success',
                                    style: {
                                        "position": "absolute",
                                        "z-index": "9999",
                                        left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                        top: 1
                                    }
                                });
                                $.messager.progress('close');
                                if (isAudit == 100) {
                                    $.m({
                                            ClassName: 'herp.budg.hisui.udata.uBudgFundApply',
                                            MethodName: 'listbillid',
                                            billcode: $("#AddApplyCbox").val()
                                        },
                                        function (data) {
                                            if (data != 0) {
	                                            //console.log(mainrowid+"wei1")
                                                mainrowid = data;
                                                //console.log(mainrowid+"wei2")
                                                //console.log(mainrowid+"wei4")
                                                //alert(mainrowid);
                                                //console.log(mainrowid); 
                                                addmainGrid.load({
                                                	ClassName: "herp.budg.hisui.udata.uBudgCtrlFundBillMng",
                                                	MethodName: "List",
                                                	hospid: hospid,
                                                	Billid: data,
                                                	yearmonth: $('#AddYMbox').combobox('getValue'), 	
                                            }) 
                                          }
                                          isAudit=0;
                                        })
                                }
                                $("#AddMainGrid").datagrid('reload');
                                $("#MainGrid").datagrid("reload"); //�رմ��ڣ����¼��������
            					$("#MainGrid").datagrid("selectRecord",mainrowid);
                                //console.log(mainrowid+"wei3")
                                
                                editIndex = undefined;
                            } else {
                                $.messager.popover({
                                    msg: '����ʧ��' + rtn,
                                    type: 'error',
                                    style: {
                                        "position": "absolute",
                                        "z-index": "9999",
                                        left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                        top: 1
                                    }
                                })
                                $.messager.progress('close');
                            }
                        })
                    editIndex = undefined;
                    $("#AddMainGrid").datagrid("unselectAll"); //ȡ��ѡ�����е�ǰҳ�����е���
                }
            } else {
                return;
            }
        })

    })

    ///ɾ��
    $("#DelBt").unbind('click').click(function () {
        var rowdetail = $('#AddMainGrid').datagrid('getSelected');
        if (rowdetail == null || (rowdetail == "")) {
            $.messager.popover({
                msg: '��ѡ����Ҫɾ�����У�',
                timeout: 2000,
                type: 'alert',
                showType: 'show',
                style: {
                    "position": "absolute",
                    "z-index": "9999",
                    left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                    top: 1
                }
            });
            return;
        } else if (rowdetail.detailState != 1 && (rowdetail.detailState != 4) && (rowdetail.detailState != "") && (rowdetail.detailState != undefined)) {
            //alert(rowdetail.detailState)
            $.messager.popover({
                msg: '������¼����ɾ����',
                timeout: 2000,
                type: 'alert',
                showType: 'show',
                style: {
                    "position": "absolute",
                    "z-index": "9999",
                    left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                    top: 1
                }
            });
            return;
        } else {
            $.messager.confirm('ȷ��', 'ȷ��ɾ����', function (t) {
                if (t) {
                    if (rowdetail.rowid > 0) {
                        $.m({
                                ClassName: 'herp.budg.hisui.udata.uBudgCtrlFundBillMng',
                                MethodName: 'delete',
                                rowid: rowdetail.rowid,
                                billid: mainrowid
                            },
                            function (SQLCODE) {
                                $.messager.progress({
                                    title: '��ʾ',
                                    msg: '����ɾ�������Ժ򡭡�'
                                });
                                if (SQLCODE == 0) {
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
                                    $.messager.progress('close');
                                    $("#AddMainGrid").datagrid("reload");
                                    $("#MainGrid").datagrid("reload");
                                    $.m({
                                            ClassName: 'herp.budg.hisui.udata.uBudgCtrlFundBillMng',
                                            MethodName: 'isNoMain',
                                            billid: mainrowid
                                        },
                                        function (rtn) {
                                            ///�������û�м�¼����رմ���
                                            if (rtn == 0) {
                                                $win.window('close');
                                            }
                                        })
                                } else {
                                    $.messager.popover({
                                        msg: 'ɾ��ʧ�ܣ�' + SQLCODE,
                                        type: 'error',
                                        style: {
                                            "position": "absolute",
                                            "z-index": "9999",
                                            left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                            top: 1
                                        }
                                    })
                                    $.messager.progress('close');
                                }
                            })
                    } else {
                        editIndex = $('#AddMainGrid').datagrid('getRows').length - 2;
                        $('#AddMainGrid').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
                    }
                }
            })
        }
    })

    ///��հ�ť 
    $("#ClearBt").unbind('click').click(function () {
        $("#AddApplyCbox").val("");
        $("#AddUserbox").combobox("setValue", "");
        $("#AddDeptbox").combobox("setValue", "");
        $("#AddYMbox").combobox("setValue", "");
        $("#AddPaybox").combobox("setValue", "");
        $("#contMethodbox").combobox("setValue", "");
        $("#itemCodebox").combobox("setValue", "");
        $("#ecoCodebox").combobox("setValue", "");
        $("#purCodebox").combobox("setValue", "");
        $("#AddNumberbox").attr("disabled", true);
        $("#AddBankbox").attr("disabled", true);
        $("#AddDescbox").attr("disabled", true);
        $("#AddNumberbox").val("");
        $("#AddBankbox").val("");
        $("#AddDescbox").val("");
    })
}