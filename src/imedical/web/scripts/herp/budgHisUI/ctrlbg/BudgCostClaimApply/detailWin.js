var hospid = session['LOGON.HOSPID'];
var userid = session['LOGON.USERID'];
var mainrowid = "";
//创建报销单
addEditFun = function (mainRow) {
	if(mainRow != ""){		
	    mainrowid = mainRow.rowid;
    }else{
        mainrowid = "";
    }
    //初始化报销单窗口
    var $win;
    $win = $('#AddWin').window({
        title: '报销单申请',
        width: 1110,
        height: 560,
        top: ($(window).height() - 560) * 0.5,
        left: ($(window).width() - 1110) * 0.5,
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
                var tmpapply=false;
                if (mainRow.applydr){
                    tmpapply=true;       
                }
                var tmppre=false;
                if (mainRow.PreBillCode){
                    tmppre=true;   
                }
                $("#ChargeAgst").checkbox("setValue",tmpapply);
                $("#PrePaybox").checkbox("setValue",tmppre);
                $("#FundApplybox").val(mainRow.applycode);
                $("#PrePayBillbox").val(mainRow.PreBillCode);
				$("#AddApplyCbox").val(mainRow.billcode);
	  			$("#AddNumberbox").val(mainRow.BKCardNo);
	  			$("#AddBankbox").val(mainRow.BKName);
	  			$("#AddDescbox").val(mainRow.applydecl);
			}

        },
        onClose: function () { //关闭窗口后触发
            $("#MainGrid").datagrid("reload"); //关闭窗口，重新加载主表格
        }
    });
    $win.window('open');
    $("#AddClose").unbind('click').click(function () {
		$win.window('close');
	})
    //冲抵借款单
    $("#ChargeAgst").checkbox({
        onCheckChange:function(event,value){
            if(!value){
                $("#FundApplybox").attr("disabled",true);
                $("#FundApplybox").val("");
            }else{
                $("#FundApplybox").attr("disabled",false);
            }
        }
    })
    $("#FundApplybox").focus(function(){
        //检查主表信息
        var UserDR= $('#AddUserbox').combobox('getValue');
        if (!UserDR) {
            var message = "请选择申请人!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:-document.body.scrollTop - document.documentElement.scrollTop/2,
                    top:10
                }               
            });
           return false;
        }
        if(UserDR){
            //弹出待冲抵借款单
            var data = UserDR;
            var fundApplyNo =$("#FundApplybox");
            AddReqFun(fundApplyNo, data,1);
        }
        
    }); 
    //关联预报销单
    $("#PrePaybox").checkbox({
        onCheckChange:function(event,value){
            if(!value){
                $("#PrePayBillbox").attr("disabled",true);
                $("#PrePayBillbox").val("");
            }else{
                $("#PrePayBillbox").attr("disabled",false);
            }
        }
    })
    $("#PrePayBillbox").focus(function(){
        //检查主表信息
        var UserDR= $('#AddUserbox').combobox('getValue');
        if (!UserDR) {
            var message = "请选择申请人!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:-document.body.scrollTop - document.documentElement.scrollTop/2,
                    top:10
                }               
            });
           return false;
        }
        if(UserDR){
            //弹出待冲抵预报销单
            var data = UserDR;
            var PrePayBillNo =$("#PrePayBillbox");
            AddReqFun(PrePayBillNo, data,2);
        }
        
    }); 
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
            if(mainRow==''){
                $('#AddUserbox').combobox('setValue',userid);
            }else{
                $("#AddUserbox").combobox("setValue",mainRow.applyerdr);
            }
        },
        onSelect: function (rec) {
            $("#AddBankbox").val(""); //清空银行
            $("#AddNumberbox").val(""); //清空银行卡号          
            if ($('#AddPaybox').combobox('getValue') == 2) {
                $('#AddBankbox').attr("disabled", false);
                $('#AddNumberbox').attr("disabled", false);
                $.m({
                    ClassName:'herp.budg.hisui.udata.uBudgCtrlFundBillMng',MethodName:'GetBankInfo',userID:rec.rowid},
                    function(Data){
                        if(Data==0){
                            
                            var message = "银行账户信息不全!";
                            $.messager.popover({
                                msg: message,
                                type:'info',
                                showType:'show',
                                style:{
                                    "position":"absolute", 
                                    "z-index":"9999",
                                    left:-document.body.scrollTop - document.documentElement.scrollTop/2,
                                    top:10
                                }               
                            });
                            return false;
                        }else {
                            $("#AddBankbox").val(Data.split("^")[0]);
                            $("#AddNumberbox").val(Data.split("^")[1]);
                        }
                    }
                );
            }
        }
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
            param.userdr = userid;
            param.flag = 1;
            param.str = param.q;
        },
        onLoadSuccess: function(){
            if(mainRow!=""){
                $("#AddDeptbox").combobox("setValue",mainRow.deprdr);
            }
	        
        },
        onSelect: function (rec) {
            $("#FundApplybox").val(""); //清空借款单号
            /**$.m({
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
                    billtype: 2 ///报销单
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
            })**/
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
	        if(mainRow!=""){
                $("#AddYMbox").combobox("setValue",mainRow.yearmonth);
            }
        },
        onSelect: function (rec) {
            //远程数据访问，返回非json格式
            // $.m({
            //     ClassName:'herp.budg.hisui.udata.uExpenseAccountDetail',MethodName:'GetClaimCode',yearmonth:rec.year},
            //     function(Data){
            //         var array=Data.split("^");
            //         if(array[0]!=""){                       
            //             $("#AddApplyCbox").val(array[0]);
            //             addmainGrid.load({
            //                 ClassName: "herp.budg.hisui.udata.ubudgcostclaimapply",
            //                 MethodName: "DetailList",
            //                 hospid: hospid,
            //                 userid:userid,
            //                 billID: mainrowid
            //             })
            //         }                                       
            //     }
            // );
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
            ///console.log(monthday);
            $.m({
                    ClassName: 'herp.budg.hisui.udata.uBudgBillCodeRule',
                    MethodName: 'Getbcode',
                    yearMonth: rec.year,
                    date: monthday,
                    firstName: "",
                    billType: 3
                },
                function (Data) {
                    $("#AddApplyCbox").val(Data);
                    addmainGrid.load({
                         ClassName: "herp.budg.hisui.udata.ubudgcostclaimapply",
                         MethodName: "DetailList",
                         hospid: hospid,
                         userid:userid,
                         billID: mainrowid
                    })
                }
            );
            $('#itemCodebox').combobox('clear'); //清除原来的数据
            var url = $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlItemCode&yearmonth=" + $("#AddYMbox").combobox("getValue");
            $('#itemCodebox').combobox('reload', url); //联动下拉列表重载  

            $('#ecoCodebox').combobox('clear'); //清除原来的数据
            var url = $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlEcoCode&itemCode=" + $('#itemCodebox').combobox("getValue") + "&yearmonth=" + $("#AddYMbox").combobox("getValue");
            $('#ecoCodebox').combobox('reload', url); //联动下拉列表重载 
             
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
                    deptid: $('#AddDeptbox').combobox('getValue'),
                    billtype: 2 ///报销单
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

    // 支付方式的下拉框
    var AddPayboxObj = $HUI.combobox("#AddPaybox", {
        mode: 'local',
        valueField: 'rowid',
        textField: 'name',
        required:true,
        data: [{
            'rowid': 1,
            'name': "现金"
        }, {
            'rowid': 2,
            'name': "银行"
        }],
        onLoadSuccess: function(){
            if(mainRow!=""){
                $("#AddPaybox").combobox("setValue",mainRow.PayMeth);
            }	        
	        if($("#AddPaybox").combobox("getValue") == 1){
		        $('#AddBankbox').attr("disabled", true);
                $('#AddNumberbox').attr("disabled", true);
	        }
        },
        onSelect: function (rec) {
            $("#AddBankbox").val(""); //清空银行
            $("#AddNumberbox").val(""); //清空银行卡号   
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
                            if(Data==0){                            
                                var message = "银行账户信息不全!";
                                $.messager.popover({
                                    msg: message,
                                    type:'info',
                                    showType:'show',
                                    style:{
                                        "position":"absolute", 
                                        "z-index":"9999",
                                        left:-document.body.scrollTop - document.documentElement.scrollTop/2,
                                        top:10
                                    }               
                                });
                                return false;
                            }else {
                                $("#AddBankbox").val(Data.split("^")[0]);
                                $("#AddNumberbox").val(Data.split("^")[1]);
                            }
                        }
                    );
                }
            }
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
        value: "报销项目",
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
                if(row!=null){
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
                        billtype: 2 ///报销单
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
            var AddYM="";
            if(mainRow!=""||$("#AddYMbox").combobox("getValue")==""){
                AddYM=mainRow.yearmonth;
            }else{
                AddYM=$("#AddYMbox").combobox("getValue");
            }
            param.ctrlType = "报销项目";
            param.yearmonth = AddYM;
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
                    'field': 'payName'
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
            }
            var row = $("#AddMainGrid").datagrid("getSelected")
            if(row!=null){
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
                    billtype: 2 ///报销单
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
            var AddYM="";
            if(mainRow!=""||$("#AddYMbox").combobox("getValue")==""){
                AddYM=mainRow.yearmonth;
            }else{
                AddYM=$("#AddYMbox").combobox("getValue");
            }
            param.itemCode = $("#itemCodebox").combobox("getValue");
            param.yearmonth = AddYM;
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
                    'field': 'payName'
                    }).target;
                    target.val(rec.name);
                    }
            }
            var row = $("#AddMainGrid").datagrid("getSelected")
            if(row!=null){
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
                    billtype: 2 ///报销单
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
            var AddYM="";
            if(mainRow!=""||$("#AddYMbox").combobox("getValue")==""){
                AddYM=mainRow.yearmonth;
            }else{
                AddYM=$("#AddYMbox").combobox("getValue");
            }
            param.itemCode = $("#itemCodebox").combobox("getValue");
            param.yearmonth = AddYM;
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
                    'field': 'payName'
                    }).target;
                    target.val(rec.name);
            }
            var row = $("#AddMainGrid").datagrid("getSelected")
            if(row!=null){
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
                    billtype: 2 ///报销单
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
                title: '报销主表ID',
                width: 80,
                hidden: true
            },
            {
                field: 'payName',
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
                formatter:function(value,row,index){
	                return row.audeptName;
				},
                editor: {
                    type: 'combobox',
                    options: {
	                    required:true,
	                    mode:'remote',
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
                        onSelect:function(rec){ 
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
                    		billtype: 2 ///报销单
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
                }}
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
                    option:{
	                    required:true}
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
            ClassName: "herp.budg.hisui.udata.ubudgcostclaimapply",
            MethodName: "DetailList",
            hospid: hospid,
            userid:userid,
            billID: mainrowid
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
        onCheck: function(index){ //在用户勾选一行的时候触发
            onCheckfun(index)
        }, 
        columns: AddColumns,
        striped: true,
        onBeforeEdit:function(rowIndex, rowData){
            if (checkBefEdit() == false) {
                return false;
            } else {
                return true;
            }            
        },
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
	    var rowdetail = $('#AddMainGrid').datagrid('getSelected');
        if(rowdetail!=null){
            if(rowdetail.payName=="合计"){
               $('#AddMainGrid').datagrid('unselectRow', index);  //取消选择一行。合计行不可选
            }
        }
	    if(!(rowdetail.detailState==1||rowdetail.detailState==4||rowdetail.detailState==""))
	    { 
		    return false;
		 }
	    var row= $('#AddMainGrid').datagrid('getSelected')
        $('#contMethodbox').combobox('setValue',rowdetail.ctrlMeth);
        $('#itemCodebox').combobox('reload');
        $('#itemCodebox').combobox('setValue',rowdetail.itemCode);
        $('#ecoCodebox').combobox('reload');
        $('#ecoCodebox').combobox('setValue',rowdetail.ecoCode);
        $('#purCodebox').combobox('reload');
        $('#purCodebox').combobox('setValue',rowdetail.purCode);        
        if(editIndex){
        var target = $('#AddMainGrid').datagrid('getEditor', {
	        			index: editIndex,
                        field: 'payName'
                    }).target;
        if($('#purCodebox').combobox("getValue")){
	        target.attr("setValue", $('#purCodebox').combobox("getText"));
	    }else if($('#ecoCodebox').combobox("getValue")){
		    target.attr("setValue", $('#ecoCodebox').combobox("getText"));
		}else {
			target.attr("setValue", $('#itemCodebox').combobox("getText"));
			}
		}
        $('#AddMainGrid').datagrid('endEdit', editIndex);
        
        if (editIndex != index) {
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
                        field: 'payName'
                    }).target;
                    target.attr("disabled", true);
            } else {
                $('#AddMainGrid').datagrid('selectRow', editIndex)
            }
        }
    }
    //用户勾选一行的时候触发，如果为合计行，则不可编辑；否则可编辑。
    var onCheckfun = function(rowIndex){ //在用户勾选一行的时候触发
        var rowsData = $('#AddMainGrid').datagrid('getRows');
            if(rowsData[rowIndex].payName=="合计"){
               $('#AddMainGrid').datagrid('unselectRow', rowIndex);  //取消选择一行。合计行不可选
            }
    }

    /*增加前检查主表信息是否完整*/
    function checkBefAdd(){
        //检查主表信息
        if (!$("#AddApplyCbox").val()) {
           return false;
        }
        if (!$('#AddYMbox').combobox('getValue')) {
           return false;
        }
        if (!$('#AddUserbox').combobox('getValue')) {
           return false;
        }
        if (!$('#AddDeptbox').combobox('getValue')) {
           return false;
        }
        if (!$('#itemCodebox').combobox('getValue')) {
           return false;
        }
        if ($('#contMethodbox').combobox('getValue')=="经济科目"&&!$('#ecoCodebox').combobox('getValue')) {
           return false;
        }
        if ($('#contMethodbox').combobox('getValue')=="采购品目"&&!$('#purCodebox').combobox('getValue')) {
           return false;
        }
        if (!$('#AddPaybox').combobox('getValue')) {
           return false;
        }
        if($('#AddPaybox').combobox('getValue')==2&&(!$("#AddBankbox").val()||!$("#AddNumberbox").val())) {
           return false;
        }
        if (!$('#AddDescbox').val()) {
           return false;
        }
        if (($('#ChargeAgst').checkbox('getValue')==true)&&(!$("#FundApplybox").val())) {
          return false;
        }
        if (($('#PrePaybox').checkbox('getValue')==true)&&(!$("#PrePayBillbox").val())) {
          return false;
        }
        return true;
        
    } 
    /*编辑前检查主表信息是否完整*/
    function checkBefEdit(){
        //检查主表信息
        if (!$("#AddApplyCbox").val()) {
            var message = "请选择预算期生成报销单号!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
        if (!$('#AddYMbox').combobox('getValue')) {
            var message = "请选择预算期!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
            return false;
        }
        if (!$('#AddUserbox').combobox('getValue')) {
           var message = "请选择申请人!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
        if (!$('#AddDeptbox').combobox('getValue')) {
            var message = "请选择报销科室!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }              
            }); 
           return false;
        }
        if (!$('#itemCodebox').combobox('getValue')) {
            var message = "请选择报销项目!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
        if ($('#contMethodbox').combobox('getValue')=="经济科目"&&!$('#ecoCodebox').combobox('getValue')) {
            var message = "请选择经济科目!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
        if ($('#contMethodbox').combobox('getValue')=="采购品目"&&!$('#purCodebox').combobox('getValue')) {
            var message = "请选择采购品目科目!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
        if (!$('#AddPaybox').combobox('getValue')) {
            var message = "请选择支付方式!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
        if($('#AddPaybox').combobox('getValue')==2&&(!$("#AddBankbox").val()||!$("#AddNumberbox").val())) {
            var message = "请维护好银行信息!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
        if (!$('#AddDescbox').val()) {
            var message = "请填写报销说明!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
        if (($('#ChargeAgst').checkbox('getValue')==true)&&(!$("#FundApplybox").val())) {
            var message = "请选择对应冲抵借款单!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
        if (($('#PrePaybox').checkbox('getValue')==true)&&(!$("#PrePayBillbox").val())) {
            var message = "请选择对应预报销单!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
          return false;
        }
        return true;
    } 
    ///点击图标新增一行
    $("#addButton").unbind('click').click(function () {
        if (endEditing()&&(checkBefEdit()==true)) {
            if ($('#contMethodbox').combobox('getValue') == "经济科目") {
                var itemName=$('#ecoCodebox').combobox('getText');
            } else if ($('#contMethodbox').combobox('getValue') == "报销项目") {
                var itemName=$('#itemCodebox').combobox('getText');
            }else{
	            var itemName=$('#purCodebox').combobox('getText');
	            }
	        var n = $("#AddMainGrid").datagrid("getRows").length;
            $('#AddMainGrid').datagrid('insertRow', {
	            index: (n-1),
	            row: {	
                	rowid:'',
                    BillDR:'',
                    payName: itemName,
                	itemCode: $('#itemCodebox').combobox('getValue'),
                	ecoCode: $('#ecoCodebox').combobox('getValue'),
                	purCode: $('#purCodebox').combobox('getValue'),
                    auDeptId:'',
                    Balance:'',
                    ReqPay:'',
                    ActPay:'',
                    Balance1:'',
                    budgcotrol:'',
                    ctrlMeth:$('#contMethodbox').combobox('getValue')
                }
            });
			editIndex = (n-1);
            $('#AddMainGrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
            var target = $('#AddMainGrid').datagrid('getEditor', {
	        			index: editIndex,
                        field: 'ctrlMeth'
                    }).target;
                    target.attr("disabled", true);
            var target = $('#AddMainGrid').datagrid('getEditor', {
	        			index: editIndex,
                        field: 'payName'
                    }).target;
                    target.attr("disabled", true);
        }
    })

    ///保存事件
    $("#AddSave").unbind('click').click(function() {
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
			     }}
        $.messager.confirm('确定', '确定要保存选定的数据吗？', function (t) {
            if (t) {
	            $('#AddMainGrid').datagrid('endEdit', editIndex);
                var rows = $('#AddMainGrid').datagrid("getChanges");
                var detaildatas="";
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
                if (rows.length > 0) {
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
                        }
                        $.messager.progress({
                            title: '提示',
                            msg: '正在保存，请稍候……'
                        })
                        var itemCode = ((row.itemCode == undefined) ? '' : row.itemCode);
                        var ecoCode  = ((row.ecoCode == undefined) ? '' :row.ecoCode);
                        var purCode  = ((row.purCode == undefined) ? '' : row.purCode);
                        var auDeptId = ((row.auDeptId == undefined) ? '' : row.auDeptId);
                        var ReqPay   = ((row.ReqPay == undefined) ? '' : row.ReqPay);
                        var ctrlMeth = ((row.ctrlMeth == undefined) ? '' : row.ctrlMeth);
                        var Balance  = ((row.Balance == undefined) ? '' : row.Balance);
                        var detailRowid    = ((row.rowid == undefined) ? '' : row.rowid);
                        
                        /////////////报销主表信息////////////////
                        var maindata = mainrowid
                             + "|" + $("#AddApplyCbox").val() //报销单号
                             + "|" + $('#AddYMbox').combobox('getValue') //预算期
                             + "|" + $('#AddDeptbox').combobox('getValue') //报销科室
                             + "|" + $('#AddUserbox').combobox('getValue') //申请人
                             + "|" + $('#AddDescbox').val().replace(/(^\s*)|(\s*$)/g, "") //报销说明
                             + "|" + $("#FundApplybox").val() //借款单号
                             + "|" + $("#PrePayBillbox").val() //预报销单号
                             + "|" + userid
                             + "|" + $('#AddPaybox').combobox('getValue') //支付方式
                             + "|" + $("#AddBankbox").val() //银行
                             + "|" + $("#AddNumberbox").val() //银行卡号
                             + "|" + hospid; //医院id
                        
                        var detaildata = detailRowid + "|" + itemCode + "|" + ecoCode +
                            "|" + purCode + "|" + ctrlMeth +
                            "|" + ReqPay + "|" + ReqPay + "|" + $('#AddDescbox').val().replace(/(^\s*)|(\s*$)/g, "") +
                            "|" + Balance + "|" + auDeptId;
                        ///console.log(detaildata);  
                        if(detaildatas == ""){
	                        var detaildatas = detaildata;
	                    }else{
		                    var detaildatas = detaildatas + "^" + detaildata;
		                    }
                    }  
                        $.m({
                                ClassName: 'herp.budg.hisui.udata.ubudgcostclaimapply',
                                MethodName: 'Save',
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
                                    $.m({
                                        ClassName: 'herp.budg.hisui.udata.ubudgcostclaimapply',
                                        MethodName: 'BillID',
                                        billcode: $('#AddApplyCbox').val() 
                                        },
                                        function (rtn) {
                                            if (rtn) {
                                                mainrowid=rtn;
                                                addmainGrid.load({
                                                    ClassName: "herp.budg.hisui.udata.ubudgcostclaimapply",
                                                    MethodName: "DetailList",
                                                    hospid: hospid,
                                                    userid:userid,
                                                    billID: mainrowid
                                                })
                                            }
                                        }
                                    )
                                    $.messager.progress('close');
                                    // $('#AddMainGrid').datagrid("reload");
                                    // addmainGrid.load({
                                    //     ClassName: "herp.budg.hisui.udata.ubudgcostclaimapply",
                                    //     MethodName: "DetailList",
                                    //     hospid: hospid,
                                    //     userid:userid,
                                    //     billcode: $('#AddApplyCbox').val() 
                                    // })
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
 $("#DelBt").unbind('click').click(function() {
     var rowdetail = $('#AddMainGrid').datagrid('getSelected');
     if(rowdetail == null|| (rowdetail== "")){
         $.messager.popover({
             msg:'请选择所要删除的行！',
             timeout: 2000,type:'alert',
             showType: 'show',
             style:{"position":"absolute","z-index":"9999",
                      left:-document.body.scrollTop - document.documentElement.scrollTop/2,
                      top:1}}); 
         return;
    }else if(!(rowdetail.detailState==1||rowdetail.detailState==4||rowdetail.detailState=="")){
         $.messager.popover({
               msg:'该条记录不可删除！',
               timeout: 2000,type:'alert',
               showType: 'show',
               style:{"position":"absolute","z-index":"9999",
                      left:-document.body.scrollTop - document.documentElement.scrollTop/2,
                      top:1}}); 
               return;
     }else{
	     $.messager.confirm('确定','确认删除吗？',function(t){
		     if(t){
			     if(rowdetail.rowid>0){
				     $.m({
					     ClassName:'herp.budg.hisui.udata.ubudgcostclaimapply',
             			 MethodName:'DetailDel',
             			 rowid : rowdetail.rowid,
             			 billid: mainrowid
             			},
             			function(SQLCODE){
	             		$.messager.progress({
                		 	title: '提示',
                		 	msg: '正在删除，请稍候……'
                		});
                 		if(SQLCODE==0){
	                 	$.messager.popover({
		                 	msg: '删除成功！',
		                 	type:'success',
                  		 	style:{"position":"absolute","z-index":"9999",
                  				left:-document.body.scrollTop - document.documentElement.scrollTop/2,
                  				top:1}});
                  	 	$.messager.progress('close');
                  	 	$("#AddMainGrid").datagrid("reload");
                  	 	$("#MainGrid").datagrid("reload");                  	 	
                 		}else{
	                 	$.messager.popover({
		                 	msg: '删除失败！'+SQLCODE,
		                 	type:'error',
		                 	style:{"position":"absolute","z-index":"9999",
		                 		left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                 		top:1}})
		             	$.messager.progress('close');
		             	}
		           	})
		           	}else{
                        editIndex= $('#AddMainGrid').datagrid('getRows').length-1;
                        $('#AddMainGrid').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
                    }
                }
                })}  
 })
 
 ///清空按钮 
    $("#ClearBT").unbind('click').click(function() {
         $("#AddApplyCbox").val("");
         $("#AddUserbox").combobox("setValue","");
         $("#AddDeptbox").combobox("setValue","");
         $("#AddYMbox").combobox("setValue","");
         $("#AddPaybox").combobox('setValue',1);
         $("#contMethodbox").combobox("setValue","报销项目");
	  	 $("#itemCodebox").combobox("setValue","");
	  	 $("#ecoCodebox").combobox("setValue","");
         $("#ecoCodebox").combobox({"disabled":true});
	  	 $("#purCodebox").combobox("setValue","");
         $("#purCodebox").combobox({"disabled":true});
	  	 $("#AddNumberbox").attr("disabled",true);
         $("#AddNumberbox").val("");
	  	 $("#AddBankbox").attr("disabled",true);
         $("#AddBankbox").val("");
         $("#AddDescbox").val("");
         $("#FundApplybox").val("");  //借款单号赋值为空
         $("#FundApplybox").attr("disabled",true);  //借款单号 
         $("#PrePayBillbox").val("");  //借款单号赋值为空
         $("#PrePayBillbox").attr("disabled",true);  //借款单号
         $("#ChargeAgst").checkbox("uncheck");//冲抵借款   
         $("#PrePaybox").checkbox("uncheck");//预报销
    })
}