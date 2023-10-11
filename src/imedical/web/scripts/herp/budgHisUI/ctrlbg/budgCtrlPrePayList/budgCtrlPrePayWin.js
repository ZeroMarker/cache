var hospid = session['LOGON.HOSPID'];
var userid = session['LOGON.USERID'];

//创建借款单
addEditFun = function (mainRow) {
	if(mainRow == ""){
		var mainrowid = "";
		}else{
	    var mainrowid = mainRow.rowid;
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
        onBeforeOpen: function(){
	        if(mainRow != ""){
				var mainrowid = mainRow.rowid;
	  			$("#AddDescbox").val(mainRow.Desc);
				}

	        },
        onClose: function () { //关闭窗口后触发
            $("#Addfm").form("reset");
            $("#AddApplyCbox").val("");
            $("#MainGrid").datagrid("reload"); //关闭窗口，重新加载主表格
        }
    });
    $win.window('open');
    
    $("#AddClose").unbind('click').click(function () {
		$win.window('close');
	})

    //申请人下拉框
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
    // 申请科室的下拉框
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
            var value = "报销项目";
            $('#itemCodebox').combobox('clear'); //清除原来的数据
            var url = $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlItemCode&ctrlType=" + value + "&yearmonth=" + $("#AddYMbox").combobox("getValue");
            $('#itemCodebox').combobox('reload', url); //联动下拉列表重载  

            $('#ecoCodebox').combobox('clear'); //清除原来的数据
            var url = $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlEcoCode&itemCode=" + $('#itemCodebox').combobox("getValue") + "&yearmonth=" + $("#AddYMbox").combobox("getValue");
            $('#ecoCodebox').combobox('reload', url); //联动下拉列表重载  
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
        required:true,
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
            param.yearmonth = $("#AddYMbox").combobox("getValue");
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
                    billtype: 1 ///借款单
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
        }}

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
            },
            {
                field: 'itemCode',
                title: '报销项目',
                align: 'right',
                hidden: true,
                width: 80,

            },
            {
                field: 'ecoCode',
                title: '经济科目',
                hidden: true,
                align: 'right',
                width: 80,
            },
            {
                field: 'purCode',
                title: '采购品目',
                hidden: true,
                align: 'right',
                width: 80,
            },
            {
                field: 'auDeptId',
                title: '归口科室',
                align: 'left',
                width: 120,
                formatter:function(value,row,index){
	                return row.audeptName;
				},
            },
            {
                field: 'Balance',
                title: '结余',
                align: 'right',
                width: 80,
                formatter: dataFormat
            },
            {
                field: 'ReqPay',
                title: '申请额',
                align: 'right',
                width: 80,
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
                width: 90
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
            BillCode: mainRow.BillCode
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
    });

}