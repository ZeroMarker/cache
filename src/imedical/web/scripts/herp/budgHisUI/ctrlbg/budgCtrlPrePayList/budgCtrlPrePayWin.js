var hospid = session['LOGON.HOSPID'];
var userid = session['LOGON.USERID'];

//������
addEditFun = function (mainRow) {
	if(mainRow == ""){
		var mainrowid = "";
		}else{
	    var mainrowid = mainRow.rowid;
	    }

    //��ʼ��������
    var $win;
    $win = $('#AddWin').window({
        title: 'Ԥ����������',
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
        onBeforeOpen: function(){
	        if(mainRow != ""){
				var mainrowid = mainRow.rowid;
	  			$("#AddDescbox").val(mainRow.Desc);
				}

	        },
        onClose: function () { //�رմ��ں󴥷�
            $("#Addfm").form("reset");
            $("#AddApplyCbox").val("");
            $("#MainGrid").datagrid("reload"); //�رմ��ڣ����¼��������
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
        required:true,
        delay: 200,
        valueField: 'rowid',
        textField: 'name',
        onBeforeLoad: function (param) {
            param.hospid = hospid;
            param.userdr = userid;
            param.str = param.q;
        },
        onLoadSuccess: function(){
	        $("#AddUserbox").combobox("setValue",mainRow.UserDR);
	        },
    });
    // ������ҵ�������
    var AddDeptboxObj = $HUI.combobox("#AddDeptbox", {
        url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode: 'remote',
        required:true,
        delay: 200,
        valueField: 'rowid',
        textField: 'name',
        onBeforeLoad: function (param) {
            param.hospid = hospid;
            param.userdr = $('#AddUserbox').combobox('getValue');
            param.flag = 1;
            param.str = param.q;
        },
        onLoadSuccess: function(){
	        $("#AddDeptbox").combobox("setValue",mainRow.deptID);
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
                    deptid: $('#AddDeptbox').combobox('getValue'),
                    billtype: 3 ///Ԥ������
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
        required:true,
        delay: 200,
        valueField: 'year',
        textField: 'year',
        onBeforeLoad: function (param) {
            param.flag = 1;
            param.str = param.q;
        },
        onLoadSuccess: function(){
	        $("#AddYMbox").combobox("setValue",mainRow.YearMonth);
	        },
        onSelect: function (rec) {
            $.m({
                    ClassName: 'herp.budg.hisui.udata.uBudgCtrlFundBillMng',
                    MethodName: 'Getbcode',
                    yearmonth: rec.year
                },
                function (Data) {
                    var array = Data.split("^");
                    if (array[0] != "") {
                        $("#AddApplyCbox").val(array[0]);
                        addmainGrid.load({
                            ClassName: "herp.budg.hisui.udata.uBudgCtrlFundBillMng",
                            MethodName: "List",
                            hospid: hospid,
                            BillCode: array[0]
                        })
                    }
                }
            );
            var value = "������Ŀ";
            $('#itemCodebox').combobox('clear'); //���ԭ��������
            var url = $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlItemCode&ctrlType=" + value + "&yearmonth=" + $("#AddYMbox").combobox("getValue");
            $('#itemCodebox').combobox('reload', url); //���������б�����  

            $('#ecoCodebox').combobox('clear'); //���ԭ��������
            var url = $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlEcoCode&itemCode=" + $('#itemCodebox').combobox("getValue") + "&yearmonth=" + $("#AddYMbox").combobox("getValue");
            $('#ecoCodebox').combobox('reload', url); //���������б�����  
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
                    deptid: $('#AddDeptbox').combobox('getValue'),
                    billtype: 3 ///Ԥ������
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
        required:true,
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
                    ctrltype: rec.rowid,
                    deptid: row.auDeptId,
                    billtype: 3 ///Ԥ������
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
            param.ctrlType = "������Ŀ";
            param.yearmonth = $("#AddYMbox").combobox("getValue");
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
                target.combobox("setValue","")
                var url = $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlAudeptid&itemCode="+rec.rowid+"&yearmonth="+ $("#AddYMbox").combobox("getValue")+"&hospid="+hospid;
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
                    billtype: 3 ///Ԥ������
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
                if(!$('#purCodebox').combobox('getValue')){
	                var target = $('#AddMainGrid').datagrid('getEditor', {
                    'index': editIndex,
                    'field': 'fundName'
                    }).target;
                    target.val(rec.name);
	                }
 			}
 			if (editIndex != undefined){
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
 			if (editIndex != undefined){
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
                    billtype: 3 ///Ԥ������
                },
                function (Data) {
                        var target = $('#AddMainGrid').datagrid('getEditor', {
                            'index': editIndex,
                            'field': 'Balance'
                        }).target;
                        target.attr("disabled", true);
                        target.val(Data);
                    })
        }}

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
            },
            {
                field: 'itemCode',
                title: '������Ŀ',
                align: 'right',
                hidden: true,
                width: 80,

            },
            {
                field: 'ecoCode',
                title: '���ÿ�Ŀ',
                hidden: true,
                align: 'right',
                width: 80,
            },
            {
                field: 'purCode',
                title: '�ɹ�ƷĿ',
                hidden: true,
                align: 'right',
                width: 80,
            },
            {
                field: 'auDeptId',
                title: '��ڿ���',
                align: 'left',
                width: 120,
                formatter:function(value,row,index){
	                return row.audeptName;
				},
            },
            {
                field: 'Balance',
                title: '����',
                align: 'right',
                width: 80,
                formatter: dataFormat
            },
            {
                field: 'ReqPay',
                title: '�����',
                align: 'right',
                width: 80,
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
                width: 90
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
            }
        ]
    ];


    //������
    var addmainGrid = $HUI.datagrid("#AddMainGrid", {
        url: $URL,
        queryParams: {
            ClassName: "herp.budg.hisui.udata.uBudgCtrlPrePayMng",
            MethodName: "List",
            hospid: hospid,
            yearmonth: mainRow.YearMonth,
            BillCode: mainRow.BillCode
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
    });

}