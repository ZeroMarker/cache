var hospid = session['LOGON.HOSPID'];
var userid = session['LOGON.USERID'];

//创建借款单
addEditFun = function (mainRow, isAudit) {
	//console.log(isAudit)
    if (mainRow == "") {
        mainrowid = "";
    } else {
        mainrowid = mainRow.rowid;
    }

    //初始化借款单窗口
    var $win;
    $win = $('#AddWin').window({
        title: '预报销单申请',
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
                mainrowid = mainRow.rowid;
                $("#AddDescbox").val(mainRow.Desc);
            }

        },
        onClose: function () { //关闭窗口后触发
            $("#Addfm").form("reset");
            $("#AddDescbox").val("");
            $("#AddApplyCbox").val("");
            $("#MainGrid").datagrid("reload"); //关闭窗口，重新加载主表格
            $("#MainGrid").datagrid('selectRecord',mainrowid);
            
        }
    });
    $win.window('open');

    $("#AddClose").unbind('click').click(function () {
        $win.window('close');
    })
    //申请单号
    $("#AddApplyCbox").val(mainRow.BillCode)

    //申请人下拉框
    var AddUserObj = $HUI.combobox("#AddUserbox", {
        url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=UserName",
        mode: 'remote',
        required: true,
        delay: 200,
        valueField: 'rowid',
        textField: 'name',
        onBeforeLoad: function (param) {
            param.hospid = hospid;
            param.userdr = userid;
            param.str = param.q;
        },
        onLoadSuccess: function () {
            $("#AddUserbox").combobox("setValue", mainRow.UserDR);
        },
    });
    // 申请科室的下拉框
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
	        if(!$("#AddMainGrid").datagrid("getSelected")){
		        	var deptida =""
		        }else{
			        var deptida =$("#AddMainGrid").datagrid("getSelected").auDeptId
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
                    billtype: 3 ///预报销单
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
    // 申请年月的下拉框
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
        },
        onLoadSuccess: function () {
            $("#AddYMbox").combobox("setValue", mainRow.YearMonth);
        },
        onSelect: function (rec) {
            ///生成单号
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
            $.m({
                    ClassName: 'herp.budg.hisui.udata.uBudgBillCodeRule',
                    MethodName: 'Getbcode',
                    yearMonth: rec.year,
                    date: monthday,
                    firstName: "",
                    billType: 5 ///预报销单
                },
                function (Data) {
                    $("#AddApplyCbox").val(Data);
                }
            );
            var value = "报销项目";
            $('#itemCodebox').combobox('clear'); //清除原来的数据
            var url = $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlItemCode&ctrlType=" + value + "&yearmonth=" + $("#AddYMbox").combobox("getValue");
            $('#itemCodebox').combobox('reload', url); //联动下拉列表重载  

            $('#ecoCodebox').combobox('clear'); //清除原来的数据
            var url = $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlEcoCode&itemCode=" + $('#itemCodebox').combobox("getValue") + "&yearmonth=" + $("#AddYMbox").combobox("getValue");
            $('#ecoCodebox').combobox('reload', url); //联动下拉列表重载 
            
            if(!$("#AddMainGrid").datagrid("getSelected")){
		        	var deptida =""
		        }else{
			        var deptida =$("#AddMainGrid").datagrid("getSelected").auDeptId
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
                    billtype: 3 ///预报销单
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


    ///控制方式下拉框
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
                            'rowid': "报销项目",
                            'name': "报销项目"
                        },
                        {
                            'rowid': "经济科目",
                            'name': "经济科目"
                        },
                        {
                            'rowid': "采购品目",
                            'name': "采购品目"
                        }
                    ]);
            } else {
                $("#contMethodbox").combobox(
                    "loadData",
                    [{
                        'rowid': "报销项目",
                        'name': "报销项目"
                    }])
            }
        })
    var contMethodObj = $HUI.combobox("#contMethodbox", {
        mode: 'local',
        required: true,
        valueField: 'rowid',
        textField: 'name',
        onSelect: function (rec) {
            if (rec.rowid == "经济科目") {
                $("#ecoCodebox").combobox("enable");
                $("#purCodebox").combobox("disable");
            }
            if (rec.rowid == "采购品目") {
                $("#ecoCodebox").combobox("enable");
                $("#purCodebox").combobox("enable");
            }
            if (rec.rowid == "报销项目") {
                $("#ecoCodebox").combobox("disable");
                $("#purCodebox").combobox("disable");
            }
            $('#ecoCodebox').combobox('clear');
            $('#itemCodebox').combobox('clear'); //清除原来的数据
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
                        billtype: 3 ///预报销单
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

    // 报销项目的下拉框
    var itemCodeboxObj = $HUI.combobox("#itemCodebox", {
        url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlItemCode",
        mode: 'remote',
        delay: 200,
        required: true,
        valueField: 'code',
        textField: 'name',
        onBeforeLoad: function (param) {
            param.ctrlType = "报销项目";
            param.yearmonth = mainRow.YearMonth || $("#AddYMbox").combobox("getValue");
            param.str = param.q;
        },
        onSelect: function (rec) {
            $('#ecoCodebox').combobox('clear'); //清除原来的数据
            var url = $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlEcoCode&itemCode=" + $('#itemCodebox').combobox("getValue") + "&yearmonth=" + $("#AddYMbox").combobox("getValue");
            $('#ecoCodebox').combobox('reload', url); //联动下拉列表重载  
            $('#purCodebox').combobox('clear'); //清除原来的数据
            var url = $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlPurCode&itemCode=" + $('#itemCodebox').combobox("getValue") + "&yearmonth=" + $("#AddYMbox").combobox("getValue") + "&ecoCode=" + $("#ecoCodebox").combobox("getValue");
            $('#purCodebox').combobox('reload', url); //联动下拉列表重载
            ///表格内对应单元格赋值
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
                        billtype: 3 ///预报销单
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

    // 经济科目的下拉框
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
            $('#purCodebox').combobox('clear'); //清除原来的数据
            var url = $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlPurCode&itemCode=" + $('#itemCodebox').combobox("getValue") + "&yearmonth=" + $("#AddYMbox").combobox("getValue") + "&ecoCode=" + $("#ecoCodebox").combobox("getValue");
            $('#purCodebox').combobox('reload', url); //联动下拉列表重载 
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
                        billtype: 3 ///预报销单
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

    // 采购品目的下拉框
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
                        billtype: 3 ///预报销单
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


    //列配置对象
    AddColumns = [
        [{
                field: 'ckbox',
                checkbox: true
            }, //复选框 
            {
                field: 'rowid',
                title: 'ID',
                width: 30,
                hidden: true
            },
            {
                field: 'BillDR',
                title: '借款主表ID',
                width: 80,
                hidden: true
            },
            {
                field: 'fundName',
                title: '申请项',
                align: 'right',
                width: 80,
                editor: {
                    type: 'text'
                }
            },
            {
                field: 'itemCode',
                title: '报销项目',
                align: 'right',
                hidden: true,
                width: 80,
                editor: {
                    type: 'text'
                }
            },
            {
                field: 'ecoCode',
                title: '经济科目',
                hidden: true,
                align: 'right',
                width: 80,
                editor: {
                    type: 'text'
                }
            },
            {
                field: 'purCode',
                title: '采购品目',
                hidden: true,
                align: 'right',
                width: 80,
                editor: {
                    type: 'text'
                }
            },
            {
                field: 'auDeptId',
                title: '归口科室',
                align: 'left',
                width: 120,
                formatter: function (value, row, index) {
                    return row.audeptName;
                },
                editor: {
                    type: 'combobox',
                    options: {
                        required: true,
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
                                    billtype: 3 ///预报销单
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
                title: '结余',
                align: 'right',
                width: 80,
                editor: {
                    type: 'text'
                },
                formatter: dataFormat
            },
            {
                field: 'ReqPay',
                title: '申请额',
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
                title: '审批额',
                align: 'right',
                width: 80,
                formatter: dataFormat
            },
            {
                field: 'Balance1',
                title: '审批后预算结余',
                align: 'right',
                width: 90,
                formatter: dataFormat
            },
            {
                field: 'budgcotrol',
                title: '预算控制',
                align: 'left',
                width: 80,
                styler: function (value, row, index) {
                    var sf = row.budgcotrol;
                    if (sf == "超预算") {
                        return 'background-color:#ee4f38;color:white';
                    }
                }
            },
            {
                field: 'ctrlMeth',
                title: '控制方式',
                align: 'left',
                width: 80,
                editor: {
                    type: 'text',
                }
            }
        ]
    ];


    //定义表格
    var addmainGrid = $HUI.datagrid("#AddMainGrid", {
        url: $URL,
        queryParams: {
            ClassName: "herp.budg.hisui.udata.uBudgCtrlPrePayMng",
            MethodName: "List",
            hospid: hospid,
            yearmonth: mainRow.YearMonth,
            Billid: mainrowid
        },
        checkOnSelect: true, //选中行复选框勾选
        selectOnCheck: true, //选中行复选框勾选        
        fitColumns: true, //列固定
        loadMsg: "正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers: true, //行号
        pageSize: 20,
        singleSelect: true,
        showFooter: true,
        pageList: [10, 20, 30, 50, 100], //页面大小选择列表
        pagination: true, //分页
        fit: true,
        onClickRow: onClickRow,
        columns: AddColumns,
        striped: true,
        toolbar: '#Addnorth'
    });

    ///行点击事件
    var editIndex = undefined;

    function endEditing() {
        ///新增多行或者换行点击html处理显示下拉框改变值
        var ed = $('#AddMainGrid').datagrid('getEditor', {
            index: editIndex,
            field: 'auDeptId'
        });
        if (ed) {
            var auDeptName = $(ed.target).combobox('getText');
            $('#AddMainGrid').datagrid('getRows')[editIndex]['audeptName'] = auDeptName;
        }
        if (editIndex == undefined) {
            return true;
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
        if(row.ctrlMeth=="报销项目"){
	        $("#ecoCodebox").combobox("disable");
	        $("#purCodebox").combobox("disable");
	        }
	    if(row.ctrlMeth=="经济科目"){
	        $("#purCodebox").combobox("disable");
	        $("#ecoCodebox").combobox("enable");
	        }
        ///console.log(isAudit,row.IsCurStep)
        if (row.detailState != 1 && (row.detailState != 4) && (isAudit == 0)) {
            return false;
        }
        if (row.fundName == "合计") {
            return false
        }
        
        ///审核人进行操作时：
        if (isAudit == 1) {
            var ee = $('#AddMainGrid').datagrid('getColumnOption', 'auDeptId');
            ee.editor = {};
            var ff = $('#AddMainGrid').datagrid('getColumnOption', 'ReqPay');
            ff.editor = {};
            var hh = $('#AddMainGrid').datagrid('getColumnOption', 'ActPay');
            hh.editor = {
                type: 'text'
            };
            $('#AddMainGrid').datagrid('beginEdit', index);
        
        ///是否是当前审核人操作
        		$.m({
                    ClassName: 'herp.budg.hisui.udata.uBudgCtrlFundBillMng',
                    MethodName: 'isEdit',
                    billid: mainrowid,
                    userid: userid,
                    billtype: 5,
                    audeptid: row.auDeptId,
                    checkflowid: mainRow.Checkid
                },
                function (rtn) {
	                //console.log(rtn)
                    ///如果没有，那么取消编辑
                    if (rtn == 100) {
                        $('#AddMainGrid').datagrid('cancelEdit', index);
                    }
                })
             }
        ///报销项目下拉框根据所选的归口科室改变动态加载内容
        $('#itemCodebox').combobox('reload', $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlItemCode&audeptid=' + row.auDeptId + '&yearmonth=' + $("#AddYMbox").combobox("getValue"));

        var row = $('#AddMainGrid').datagrid('getSelected')
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
        $('#AddMainGrid').datagrid('endEdit', editIndex);

        if (editIndex != index) {
	        //console.log(111);
            if (endEditing()) {
	            //console.log(222)
                $('#AddMainGrid').datagrid('selectRow', index)
                $('#AddMainGrid').datagrid('beginEdit', index);
                
                //console.log(endEditing());
                editIndex = index;
                //console.log(index+","+editIndex);
                var target = $('#AddMainGrid').datagrid('getEditor', {
                    index: editIndex,
                    field: 'ctrlMeth'
                }).target;
                //console.log(666);
                target.attr("disabled", true);
                //console.log(555);
                target = $('#AddMainGrid').datagrid('getEditor', {
                    index: editIndex,
                    field: 'Balance'
                }).target;
                target.attr("disabled", true);
                target = $('#AddMainGrid').datagrid('getEditor', {
                    index: editIndex,
                    field: 'fundName'
                }).target;
                target.attr("disabled", true);
            } else {
                $('#AddMainGrid').datagrid('selectRow', editIndex)
            }
           // console.log(444)
        }
    }


    ///点击图标新增一行
    $("#addButton").unbind('click').click(function () {
	    if(isAudit==1){
		    return false;}
        if (endEditing()) {
            if (!$('#AddUserbox').combobox('getValue')) {
                $.messager.popover({
                    msg: "请填写申请人!",
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
                    msg: "请填写申请科室!",
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
                    msg: "请填写预算期!",
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
                    msg: "请填写控制方式!",
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
            if (!$('#AddDescbox').val()) {
                    $.messager.popover({
                        msg: '说明不能为空！',
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
            if (!$('#itemCodebox').combobox('getValue')) {
                $.messager.popover({
                    msg: "请填写报销项目!",
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

            if ($('#contMethodbox').combobox('getValue') == "经济科目") {
                var fundName = $('#ecoCodebox').combobox('getText');
            } else if ($('#contMethodbox').combobox('getValue') == "报销项目") {
                var fundName = $('#itemCodebox').combobox('getText');
            } else {
                var fundName = $('#purCodebox').combobox('getText');
            }
            var n = $("#AddMainGrid").datagrid("getRows").length;
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

    ///保存事件
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
                 msg: '说明不能为空！',
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
				 msg: '请添加表格中具体内容后再保存',
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
          if (rows.length == 0) {
	         $.messager.confirm('确定', '确定要保存选定的数据吗？', function (t) {
           		 if (t) {
           $.m({
	           ClassName: 'herp.budg.hisui.udata.uBudgCtrlPrePayMng',
               MethodName: 'updateRec',
               billid:mainrowid,
               billCode:$("#AddApplyCbox").val(),
               yearMonth:$('#AddYMbox').combobox('getValue'),
               deptId: $('#AddDeptbox').combobox('getValue'),
               userId: $('#AddUserbox').combobox('getValue'),
               desc:$('#AddDescbox').val().replace(/(^\s*)|(\s*$)/g, "") ,
               userid:userid
                       },
                       function (rtn) {
                            if (rtn == 0) {
                                $.messager.popover({
                                    msg: '保存成功！',
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
                                    msg: '保存失败' + rtn,
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
                    msg: "请填写控制方式!",
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
                    msg: "请填写报销项目!",
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
                                msg: '报销项目不能为空',
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
                                msg: '申请金额不能为空',
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
                                msg: '归口科室不能为空',
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
                                msg: '控制方式不能为空',
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
                        if (row.ctrlMeth == "经济科目") {
                            if (!row.ecoCode) {
                                $.messager.popover({
                                    msg: '经济科目不能为空',
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
                        if (row.ctrlMeth == "采购品目") {
                            if (!row.ecoCode) {
                                $.messager.popover({
                                    msg: '经济科目不能为空',
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
                                    msg: '采购品目不能为空',
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
                         }}
                      }
        $.messager.confirm('确定', '确定要保存选定的数据吗？', function (t) {
            if (t) {
                $('#AddMainGrid').datagrid('endEdit', editIndex);
                var rows = $('#AddMainGrid').datagrid("getChanges");
                var detaildatas = "";
                if (rows.length == 0) {
                    $.messager.popover({
                        msg: '没有需要保存的记录！',
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
                 if (!$('#AddDescbox').val()) {
                    $.messager.popover({
                        msg: '说明不能为空！',
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
                if (rows.length > 0) {
                    for (var i = 0; i < rows.length; i++) {
                        var row = rows[i];
                        $.messager.progress({
                            title: '提示',
                            msg: '正在保存，请稍候……'
                        })
                        var itemCode = ((row.itemCode == undefined) ? '' : row.itemCode);
                        var ecoCode = ((row.ecoCode == undefined) ? '' : row.ecoCode);
                        var purCode = ((row.purCode == undefined) ? '' : row.purCode);
                        var auDeptId = ((row.auDeptId == undefined) ? '' : row.auDeptId);
                        var ReqPay = ((row.ReqPay == undefined) ? '' : row.ReqPay);
                        var ctrlMeth = ((row.ctrlMeth == undefined) ? '' : row.ctrlMeth);
                        var Balance = ((row.Balance == undefined) ? '' : row.Balance);
                        var detailRowid = ((row.rowid == undefined) ? '' : row.rowid);
                        var ActPay = ((row.ActPay == undefined) ? '' : row.ActPay);
                        if (ActPay == ""||(isAudit==0)) {
                            var ActPay = ReqPay
                        }
						if (isAudit == 1) {
							var userid = 0; 
						}else{
							var userid =session['LOGON.USERID'];
							}
                        var maindata = mainrowid + "|" + $("#AddApplyCbox").val() + "|" +
                            $('#AddYMbox').combobox('getValue') + "|" +
                            $('#AddDeptbox').combobox('getValue') + "|" + $('#AddUserbox').combobox('getValue') + "|" +
                            $('#AddDescbox').val().replace(/(^\s*)|(\s*$)/g, "") + "|" + hospid + "|" + userid

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
                            ClassName: 'herp.budg.hisui.udata.uBudgCtrlPrePayMng',
                            MethodName: 'save',
                            maindata: maindata,
                            detaildatas: detaildatas
                        },
                        function (rtn) {
                            if (rtn == 0) {
                                $.messager.popover({
                                    msg: '保存成功！',
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
                                            ClassName: 'herp.budg.hisui.udata.uBudgCtrlPrePayMng',
                                            MethodName: 'listbillid',
                                            billcode: $("#AddApplyCbox").val()
                                        },
                                        function (data) {
                                            if (data != 0) {
                                                mainrowid = data;
                                                addmainGrid.load({
                                                	ClassName: "herp.budg.hisui.udata.uBudgCtrlPrePayMng",
                                                	MethodName: "List",
                                                	hospid: hospid,
                                                	Billid: data,
                                                	yearmonth: $('#AddYMbox').combobox('getValue'), 	
                                            }) 
                                          }
                                          isAudit=0;
                                        })
                                }
                                $('#AddMainGrid').datagrid("reload");
                                $("#MainGrid").datagrid("reload"); //关闭窗口，重新加载主表格
            					$("#MainGrid").datagrid('selectRecord',mainrowid);
                                editIndex = undefined;
                            } else {
                                $.messager.popover({
                                    msg: '保存失败' + rtn,
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
                    $("#AddMainGrid").datagrid("unselectAll"); //取消选择所有当前页中所有的行
                }
            } else {
                return;
            }
        })
    })

    ///删除
    $("#DelBt").unbind('click').click(function () {
        var rowdetail = $('#AddMainGrid').datagrid('getSelected');
        if (rowdetail == null || (rowdetail == "")) {
            $.messager.popover({
                msg: '请选择所要删除的行！',
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
        } else if (rowdetail.detailState != 1 && (rowdetail.detailState != 4) && (rowdetail.detailState != "")&& (rowdetail.detailState != undefined)) {
            $.messager.popover({
                msg: '该条记录不可删除！',
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
            $.messager.confirm('确定', '确认删除吗？', function (t) {
                if (t) {
                    if (rowdetail.rowid > 0) {
                        $.m({
                                ClassName: 'herp.budg.hisui.udata.uBudgCtrlPrePayMng',
                                MethodName: 'delete',
                                rowid: rowdetail.rowid,
                                billid: mainrowid
                            },
                            function (SQLCODE) {
                                $.messager.progress({
                                    title: '提示',
                                    msg: '正在删除，请稍候……'
                                });
                                if (SQLCODE == 0) {
                                    $.messager.popover({
                                        msg: '删除成功！',
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
	                                    ClassName: 'herp.budg.hisui.udata.uBudgCtrlPrePayMng',
                    					MethodName: 'isNoMain',
                    					billid: mainrowid
                					},
                						function (rtn) {
                    					///如果主表没有记录，则关闭窗口
                    						if (rtn == 0) {
	                    						$win.window('close');
                    					}
                					})   
                                } else {
                                    $.messager.popover({
                                        msg: '删除失败！' + SQLCODE,
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
                        editIndex = $('#AddMainGrid').datagrid('getRows').length - 1;
                        $('#AddMainGrid').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
                    }
                }
            })
        }
    })

    ///清空按钮 
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
        $("#AddDescbox").attr("disabled", true);
        $("#AddNumberbox").val("");
        $("#AddDescbox").val("");
    })
}