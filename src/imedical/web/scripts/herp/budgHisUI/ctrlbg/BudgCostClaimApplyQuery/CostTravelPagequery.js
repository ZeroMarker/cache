var hospid = session['LOGON.HOSPID'];
var userid = session['LOGON.USERID'];
//新建时调用窗口，isAudit传参为100
//修改时调用窗口，isAudit传参为0
//审核时调用窗口，isAudit传参为1
//maingridid为报销主表选中行数据，detailgridid为报销明细表id,isEdit是否具有可以修改权限，isEdit为1是有，0没有
CostTravelPage = function (maingrid, detailgridid, isAudit, isEdit) {
    //初始化报销单窗口
    var $winTravel;
    $winTravel = $('#AddTravel').window({
        title: '差旅费报销单申请',
        width: 1155,
        height: 620,
        top: ($(window).height() - 620) * 0.5,
        left: ($(window).width() - 1155) * 0.5,
        shadow: true,
        modal: true,
        iconCls: 'icon-w-new',
        closed: true,
        minimizable: false,
        maximizable: false,
        collapsible: false,
        resizable: true,
        onBeforeOpen: function () {
	        //console.log(isEdit);
            $("#TrPayCode").attr("disabled", true);
            $("#TrPrePayCode").attr("disabled", true);
            if(maingrid!=""){
	            maingridid = maingrid.rowid
	        }else{
		        maingridid = ""
		        }
            if(isAudit!=100){
	            //console.log(maingrid);
	            $("#TrPrePayCode").val(maingrid.PreBillCode);
	            $("#TrApplyCbox").val(maingrid.billcode);
	            $("#TrBalancebox").val(maingrid.Balance);
	            $("#TrBankbox").val(maingrid.BKName);
	            $("#TrNumberbox").val(maingrid.BKCardNo);
	            $("#TrPayCode").val(maingrid.applycode);
	            $("#TrDescbox").val(maingrid.applydecl);		       
	            }
        },
        onClose: function () { //关闭窗口后触发
        	$("#TrBalancebox").val("");
            $("#TrPayCode").val("");
            $("#TrPrePayCode").val("");
            $("#TrBankbox").val("");
            $("#TrNumberbox").val("");
            $("#TrApplyCbox").val("");
            $("#TrDescbox").val("");
            $("#reqfee").val("");
            $("#supplyfee").val("");
            $("#backfee").val("");
            $("#spartmoney").numberbox("setValue", ""); //其他费用合计值
            $("#sumnumber").numberbox("setValue", ""); //其他费用票据合计值
            $("#reqpay").numberbox("setValue", "");
            $("#sumcost").numberbox("setValue", "");
            $("#MainGrid").datagrid("reload"); //关闭窗口，重新加载主表格
        }
    });
    $winTravel.window('open');

    $("#TravelClose").unbind('click').click(function () {
        $winTravel.window('close');
    })

    //出差人下拉框
    var AddUserObj = $HUI.combobox("#TrUserbox", {
        url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=UserName",
        mode: 'remote',
        required: true,
        delay: 200,
        valueField: 'rowid',
        textField: 'name',
        onBeforeLoad: function (param) {
            param.hospid = hospid;
            param.str = param.q;
        },
        onLoadSuccess: function () {
	        $("#TrUserbox").combobox("setValue",userid);
	        if(maingrid!=""){
	        	$("#TrUserbox").combobox("setValue",maingrid.applyerdr);
	        }
        },
        onSelect: function (rec) {
            $("#TrBankbox").val(""); //清空银行
            $("#TrNumberbox").val(""); //清空银行卡号          
            if ($('#TrPaybox').combobox('getValue') == 2) {
                $('#TrBankbox').attr("disabled", false);
                $('#TrNumberbox').attr("disabled", false);
                $.m({
                        ClassName: 'herp.budg.hisui.udata.uBudgCtrlFundBillMng',
                        MethodName: 'GetBankInfo',
                        userID: rec.rowid
                    },
                    function (Data) {
                        var arr = Data.split("^");
                        $("#TrBankbox").val(arr[0]);
                        $("#TrNumberbox").val(arr[1]);
                    }
                );
            }
        }
    });
    // 申请科室的下拉框
    var AddDeptboxObj = $HUI.combobox("#TrDeptbox", {
        url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode: 'remote',
        required: true,
        delay: 200,
        valueField: 'rowid',
        textField: 'name',
        onLoadSuccess: function(){
	        if(maingrid!=""){
	        	$("#TrDeptbox").combobox("setValue",maingrid.deprdr);
	        }},
        onBeforeLoad: function (param) {
            param.hospid = hospid;
            param.userdr = $('#TrUserbox').combobox('getValue');
            param.flag = 1;
            param.str = param.q;
        }
    });
    
     // 归口科室的下拉框
    var AddAuDeptboxObj = $HUI.combobox("#TrAuDeptbox", {
        url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlAudeptid",
        mode: 'remote',
        required: true,
        delay: 100,
        valueField: 'rowid',
        textField: 'name',
        onLoadSuccess: function(){
	        if(maingrid!=""){
	        	$("#TrAuDeptbox").combobox("setValue",maingrid.auDeptId);
	        }},
        onBeforeLoad: function (param) {
	        param.str = param.q;
            param.hospid = hospid;
            param.yearmonth = $('#TrYMbox').combobox('getValue')||maingrid.yearmonth;
            param.itemCode = $('#TritemCodebox').combobox('getValue')||maingrid.itemCode;
            
        },
        onSelect: function(rec){
	         $.m({
                    ClassName: 'herp.budg.hisui.udata.uBudgSurplus',
                    MethodName: 'FinalBudg',
                    compdr: hospid,
                    yearmonth: $('#TrYMbox').combobox('getValue'),
                    itemcode: $('#TritemCodebox').combobox('getValue'),
                    billid: maingrid.rowid,
                    ecocode: $('#TrecoCodebox').combobox('getValue'),
                    purcode: $('#TrpurCodebox').combobox('getValue'),
                    ctrltype: $('#TrcontMethodbox').combobox('getValue'),
                    deptid: $('#TrAuDeptbox').combobox('getValue'),
                    billtype: 2 ///报销单
                },
                function (Data) {
	                $("#TrBalancebox").val(Data);
	                })}
    });


    // 预算期的下拉框
    var AddYMboxObj = $HUI.combobox("#TrYMbox", {
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
		onLoadSuccess: function(){
	        if(maingrid!=""){
	        	$("#TrYMbox").combobox("setValue",maingrid.yearmonth);
	        }},
        onSelect: function (rec) {
            ///生成单号
            $("#TrApplyCbox").val()
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
                    $("#TrApplyCbox").val(Data);
                }
            );
            $('#TritemCodebox').combobox('clear'); //清除原来的数据
            var url = $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlItemCode&yearmonth=" + $("#TrYMbox").combobox("getValue");
            $('#TritemCodebox').combobox('reload', url); //联动下拉列表重载  

            $('#TrecoCodebox').combobox('clear'); //清除原来的数据
            var url = $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlEcoCode&itemCode=" + $('#TritemCodebox').combobox("getValue") + "&yearmonth=" + $("#TrYMbox").combobox("getValue");
            $('#TrecoCodebox').combobox('reload', url); //联动下拉列表重载 
        }
    });

    // 支付方式的下拉框
    var AddPayboxObj = $HUI.combobox("#TrPaybox", {
        mode: 'local',
        valueField: 'rowid',
        textField: 'name',
        required: true,
        data: [{
            'rowid': 1,
            'name': "现金"
        }, {
            'rowid': 2,
            'name': "银行"
        }],
        onLoadSuccess: function () {
	        $("#TrPaybox").combobox("setValue",1);
	        if(maingrid!=""){
		        //console.log(maingrid.PayMeth);
	        	$("#TrPaybox").combobox("setValue",maingrid.PayMeth);
	        }
            if ($("#TrPaybox").combobox("getValue") == 1) {
                //alert("sss")
                $('#TrBankbox').attr("disabled", true);
                $('#TrNumberbox').attr("disabled", true);
                //alert("ssssss")
            } else {
                $('#TrBankbox').attr("disabled", false);
                $('#TrNumberbox').attr("disabled", false);
            }
        },
        onSelect: function (rec) {
            $("#TrBankbox").val(""); //清空银行
            $("#TrNumberbox").val(""); //清空银行卡号   
            if (rec.rowid == 1) {
                $('#TrBankbox').attr("disabled", true);
                $('#TrNumberbox').attr("disabled", true);
            }
            if ($('#TrUserbox').combobox('getValue')) {
                if (rec.rowid == 2) {
                    $('#TrBankbox').attr("disabled", false);
                    $('#TrNumberbox').attr("disabled", false);
                    $.m({
                            ClassName: 'herp.budg.hisui.udata.uBudgCtrlFundBillMng',
                            MethodName: 'GetBankInfo',
                            userID: $('#TrUserbox').combobox('getValue')
                        },
                        function (Data) {
                            var arr = Data.split("^");
                            $("#TrBankbox").val(arr[0]);
                            $("#TrNumberbox").val(arr[1]);
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
                $("#TrcontMethodbox").combobox(
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
                $("#TrcontMethodbox").combobox(
                    "loadData",
                    [{
                        'rowid': "报销项目",
                        'name': "报销项目"
                    }])
            }
        })
    var contMethodObj = $HUI.combobox("#TrcontMethodbox", {
        mode: 'local',
        required: true,
        valueField: 'rowid',
        textField: 'name',
        onLoadSuccess: function () {
	        $("#TrcontMethodbox").combobox("setValue","报销项目");
	        if(maingrid!=""){
	        	$("#TrcontMethodbox").combobox("setValue",maingrid.ctrlMeth);
	        }
	        if ($("#TrcontMethodbox").combobox("getValue") == "经济科目") {
                $("#TrpurItembox").combobox("enable");
                $("#TrecoCodebox").combobox("disable");
            }
            if ($("#TrcontMethodbox").combobox("getValue") == "采购品目") {
                $("#TrpurCodebox").combobox("enable");
                $("#TrecoCodebox").combobox("enable");
            }
            if ($("#TrcontMethodbox").combobox("getValue")== "报销项目") {
                $("#TrpurCodebox").combobox("disable");
                $("#TrecoCodebox").combobox("disable");
            }},
        onSelect: function (rec) {
	          $.m({
                    ClassName: 'herp.budg.hisui.udata.uBudgSurplus',
                    MethodName: 'FinalBudg',
                    compdr: hospid,
                    yearmonth: $('#TrYMbox').combobox('getValue'),
                    itemcode: $('#TritemCodebox').combobox('getValue'),
                    billid: maingrid.rowid,
                    ecocode: $('#TrecoCodebox').combobox('getValue'),
                    purcode: $('#TrpurCodebox').combobox('getValue'),
                    ctrltype: $('#TrcontMethodbox').combobox('getValue'),
                    deptid: $('#TrAuDeptbox').combobox('getValue'),
                    billtype: 2 ///报销单
                },
                function (Data) {
	                $("#TrBalancebox").val(Data);
	                })
            if (rec.rowid == "经济科目") {
                $("#TrpurItembox").combobox("disable");
                $("#TrecoCodebox").combobox("enable");
            }
            if (rec.rowid == "采购品目") {
                $("#TrpurCodebox").combobox("enable");
                $("#TrecoCodebox").combobox("enable");
            }
            if (rec.rowid == "报销项目") {
                $("#TrpurCodebox").combobox("disable");
                $("#TrecoCodebox").combobox("disable");
            }
            $('#TrecoCodebox').combobox('clear');
            $('#TritemCodebox').combobox('clear'); //清除原来的数据
            $('#TrpurCodebox').combobox('clear');
        }
    })


    // 报销项目的下拉框
    var itemCodeboxObj = $HUI.combobox("#TritemCodebox", {
        url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlItemCode",
        mode: 'remote',
        delay: 200,
        required: true,
        valueField: 'code',
        textField: 'name',
        onBeforeLoad: function (param) {
            param.str = param.q;
            param.yearmonth = $("#TrYMbox").combobox("getValue")||maingrid.yearmonth;
        },
        onLoadSuccess: function () {
	        if(maingrid!=""){
	        	$("#TritemCodebox").combobox("setValue",maingrid.itemCode);
	        }},
        onSelect: function (rec) {
	          $.m({
                    ClassName: 'herp.budg.hisui.udata.uBudgSurplus',
                    MethodName: 'FinalBudg',
                    compdr: hospid,
                    yearmonth: $('#TrYMbox').combobox('getValue'),
                    itemcode: $('#TritemCodebox').combobox('getValue'),
                    billid: maingrid.rowid,
                    ecocode: $('#TrecoCodebox').combobox('getValue'),
                    purcode: $('#TrpurCodebox').combobox('getValue'),
                    ctrltype: $('#TrcontMethodbox').combobox('getValue'),
                    deptid: $('#TrAuDeptbox').combobox('getValue'),
                    billtype: 2 ///报销单
                },
                function (Data) {
	                $("#TrBalancebox").val(Data);
	                })
            $('#TrecoCodebox').combobox('clear'); //清除原来的数据
            var url = $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlEcoCode&itemCode=" + $('#TritemCodebox').combobox("getValue") + "&yearmonth=" + $("#TrYMbox").combobox("getValue");
            $('#TrecoCodebox').combobox('reload', url); //联动下拉列表重载  
            $('#TrpurCodebox').combobox('clear'); //清除原来的数据
            var url = $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlPurCode&itemCode=" + $('#TritemCodebox').combobox("getValue") + "&yearmonth=" + $("#TrYMbox").combobox("getValue") + "&ecoCode=" + $("#TrecoCodebox").combobox("getValue");
            $('#TrpurCodebox').combobox('reload', url); //联动下拉列表重载
            $('#TrAuDeptbox').combobox('clear'); //清除原来的数据
            var url = $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlAudeptid&itemCode=" + $('#TritemCodebox').combobox("getValue") + "&yearmonth=" + $("#TrYMbox").combobox("getValue") + "&hospid=" + hospid;
            $('#TrAuDeptbox').combobox('reload', url); //联动下拉列表重载
        }
    });

    // 经济科目的下拉框
    var ecoCodeboxObj = $HUI.combobox("#TrecoCodebox", {
        url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlEcoCode",
        mode: 'remote',
        delay: 200,
        valueField: 'code',
        textField: 'name',
        onBeforeLoad: function (param) {
            param.itemCode = $("#TritemCodebox").combobox("getValue");
            param.yearmonth = $("#TrYMbox").combobox("getValue");
            param.str = param.q;
        },
        onLoadSuccess: function () {
	        if(maingrid!=""){
	        	$("#TrecoCodebox").combobox("setValue",maingrid.ecoCode);
	        }},
	    onSelect: function(){
		      $.m({
                    ClassName: 'herp.budg.hisui.udata.uBudgSurplus',
                    MethodName: 'FinalBudg',
                    compdr: hospid,
                    yearmonth: $('#TrYMbox').combobox('getValue'),
                    itemcode: $('#TritemCodebox').combobox('getValue'),
                    billid: maingrid.rowid,
                    ecocode: $('#TrecoCodebox').combobox('getValue'),
                    purcode: $('#TrpurCodebox').combobox('getValue'),
                    ctrltype: $('#TrcontMethodbox').combobox('getValue'),
                    deptid: $('#TrAuDeptbox').combobox('getValue'),
                    billtype: 2 ///报销单
                },
                function (Data) {
	                $("#TrBalancebox").val(Data);
	                })
	                }
    });

    // 采购品目的下拉框
    var purCodeboxObj = $HUI.combobox("#TrpurCodebox", {
        url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=getCtlPurCode",
        mode: 'remote',
        delay: 200,
        valueField: 'code',
        textField: 'name',
        onBeforeLoad: function (param) {
            param.itemCode = $("#TritemCodebox").combobox("getValue");
            param.yearmonth = $("#TrYMbox").combobox("getValue");
            param.ecoCode = $("#TrecoCodebox").combobox("getValue");
            param.str = param.q
        },
        onLoadSuccess: function () {
	        if(maingrid!=""){
	        	$("#TrpurCodebox").combobox("setValue",maingrid.purCode);
	        }},
	    onSelect: function(){
		      $.m({
                    ClassName: 'herp.budg.hisui.udata.uBudgSurplus',
                    MethodName: 'FinalBudg',
                    compdr: hospid,
                    yearmonth: $('#TrYMbox').combobox('getValue'),
                    itemcode: $('#TritemCodebox').combobox('getValue'),
                    billid: maingrid.rowid,
                    ecocode: $('#TrecoCodebox').combobox('getValue'),
                    purcode: $('#TrpurCodebox').combobox('getValue'),
                    ctrltype: $('#TrcontMethodbox').combobox('getValue'),
                    deptid: $('#TrAuDeptbox').combobox('getValue'),
                    billtype: 2 ///报销单
                },
                function (Data) {
	                $("#TrBalancebox").val(Data);
	                })
	              }
    });

    //冲抵借款单
    $("#ChargePay").checkbox({
        onCheckChange: function (event, value) {
            if (!value) {
                $("#TrPayCode").attr("disabled", true);
                $("#TrPayCode").val("");
            } else {
                $("#TrPayCode").attr("disabled", false);
            }
        },
        onLoadSuccess: function () {
	        if(maingrid!=""&&(maingrid.applycode!="")){
	        	$("#ChargePay").checkbox("checked",true);
	        }}
    })
    $("#TrPayCode").focus(function(){
        //检查主表信息
        var UserDR= $('#TrUserbox').combobox('getValue');
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
            var fundApplyNo =$("#TrPayCode");
            AddReqFun(fundApplyNo, data,1);
        }
        
    }); 

    //冲抵预报销单
    $("#ChargePrePay").checkbox({
        onCheckChange: function (event, value) {
            if (!value) {
                $("#TrPrePayCode").attr("disabled", true);
                $("#TrPrePayCode").val("");
            } else {
                $("#TrPrePayCode").attr("disabled", false);
            }
        },
        onLoadSuccess: function () {
	        if(maingrid!=""&&(maingrid.PreBillCode!="")){
	        	$("#ChargePrePay").checkbox("checked",true);
	        }}
    })
    $("#TrPrePayCode").focus(function(){
        //检查主表信息
        var UserDR= $('#TrUserbox').combobox('getValue');
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
            var PrePayBillNo =$("#TrPrePayCode");
            AddReqFun(PrePayBillNo, data,2);
        }
        
    }); 
    ////////////////////////////////////分割线----travelgrid表格//////////////////////////////

    //打开窗口自动获取数据
    $(document).ready(function () {
        if (isAudit == 100) {
            $.ajax({
                type: 'post',
                url: $URL + '?ClassName=herp.budg.hisui.udata.ubudgcostclaimapplytravel&MethodName=List',
                data: {
                    paybilldeid: '',
                    hospid: hospid
                },
                success: function (rtn) {
                    $("#traveltbody tr").remove();
                    var rtn = $.parseJSON(rtn)
                    //console.log(rtn)
                    for (var i = 0; i < rtn.total; i++) {
                        addRow(i, rtn.rows[i])
                        initRow(i);
                    }
                    addblankRow(i);
                    initRow(i)
                }
            });
        } else {
	        //console.log(detailgridid);
            $.ajax({
                type: 'post',
                url: $URL + '?ClassName=herp.budg.hisui.udata.ubudgcostclaimapplytravel&MethodName=ListRecord',
                data: {
                    paybilldeid: detailgridid,
                    hospid: hospid
                },
                success: function (rtn) {
                    $("#traveltbody tr").remove();
                    var rtn = $.parseJSON(rtn);
                    
                    //console.log(rtn)
                    for (var i = 0; i < rtn.total; i++) {
                        addRow(i, rtn.rows[i]);
                        initRow(i);
                        }
                        var sumcost=0, sumnumber=0, sumsmoney=0;
                        var rows = $('#TravelGrid').find('tbody').find('tr');
                        for (var g = 0; g < rows.length; g++) { //遍历表格的行
                        	var sumcost = Number(sumcost) + Number($("#sumfee" + g + "").val());
                        	var sumnumber = Number(sumnumber) + Number($("#trnumber" + g + "").val());
                        	var sumsmoney = Number(sumsmoney) + Number($("#summoney" + g + "").val());
                    		
                    	                       
                        if (isEdit == 0) { //非当前审核人
                            $("#traveltbody input").attr("disabled", true);
                            $("#transport" + g + "").combogrid("disable");
                            $("#arrdate" + g + "").datetimebox({
                                disabled: true
                            })
                            $("#leadate" + g + "").datetimebox({
                                disabled: true
                            })
                            $("#TrUserbox").combobox("disable");
                            $("#TrPaybox").combobox("disable");
                            $("#TrBankbox").attr("disabled", true);
                            $("#TrNumberbox").attr("disabled", true);
                            $("#TrYMbox").combobox("disable");
                            $("#TrcontMethodbox").combobox("disable");
                            $("#TritemCodebox").combobox("disable");
                            $("#TrecoCodebox").combobox("disable");
                            $("#TrpurCodebox").combobox("disable");
                            $("#TrDeptbox").combobox("disable");
                            $("#ChargePay").checkbox("disable");
                            $("#ChargePrePay").checkbox("disable");
                            $("#TrAuDeptbox").combobox("disable");
                            $("#TrPayCode").attr("disabled", true);
                            $("#TrDescbox").attr("disabled", true);
                            $("#TrPrePayCode").attr("disabled", true);
                            $("#TrAddBt").linkbutton("disable");
                            $("#TrDelBt").linkbutton("disable");
                            $("#TrClearBt").linkbutton("disable");
                            $("#TrPrintShow").linkbutton("disable");
                            $("#TrPrintBt").linkbutton("disable");
                            $("#TravelSave").linkbutton("disable");
                        }else{
	                        //$("#traveltbody input").attr("disabled", false)
                            //$("#transport" + i + "").combogrid("enable")
                            $("#arrdate" + g + "").datetimebox({
                                disabled: false
                            })
                            $("#leadate" + g + "").datetimebox({
                                disabled: false
                            })
                            $("#TrUserbox").combobox("enable");
                            $("#TrPaybox").combobox("enable");
                            $("#TrYMbox").combobox("enable");
                            $("#ChargePrePay").checkbox("enable");
                            $("#TrAuDeptbox").combobox("enable");
                            $("#TrcontMethodbox").combobox("enable");
                            $("#TritemCodebox").combobox("enable");
                            $("#TrecoCodebox").combobox("enable");
                            $("#TrpurCodebox").combobox("enable");
                            $("#TrDeptbox").combobox("enable");
                            $("#ChargePay").checkbox("enable");
                            $("#TrDescbox").attr("disabled", false);
                            $("#TrAddBt").linkbutton("enable");
                            $("#TrDelBt").linkbutton("enable");
                            $("#TrClearBt").linkbutton("enable");
                            $("#TrPrintShow").linkbutton("enable");
                            $("#TrPrintBt").linkbutton("enable");
                            $("#TravelSave").linkbutton("enable");
	                        }
                        }
                        //console.log(sumcost)
                    $("#sumcost").numberbox("setValue", sumcost) //交通费用合计值
                    $("#spartmoney").numberbox("setValue", sumsmoney) //其他费用合计值
                    $("#sumnumber").numberbox("setValue", sumnumber) //其他费用票据合计值
                    $("#reqpay").numberbox("setValue", Number($("#sumcost").val()) + Number($("#spartmoney").val())) //表格总计值
                    inputPayCode();
                }
            })

        }
    })

    //根据查询传来的数据增加tbody中的内容，对应的tr以及td元素
    function addRow(ind, row) {
        var rowHtm = "";
        rowHtm += "<tr id='row" + ind + "'>";
        rowHtm += '<td><input type="radio" name = "rowselected" id="check' + ind + '"/></td>'
        rowHtm += '<td style="display:none"><input type="text" id="rowid' + ind + '"  style="width:175px" value="' + row.rowid + '"/ ></td>'
        rowHtm += '<td><input type="text" class="partdata1" id="arrdate' + ind + '" style="width:175px" value="' + row.arrdate + '" /></td>';
        rowHtm += '<td><input type="text" class="partdata2" id="arrlocation' + ind + '" style="width:70px" value="' + row.arrlocation + '" onblur="inputBlur(this.id)"/></td>';
        rowHtm += '<td><input type="text" class="partdata3" id="leadate' + ind + '" style="width:175px" value="' + row.leadate + '"/></td>';
        rowHtm += '<td><input type="text" class="partdata4" id="lealocation' + ind + '" style="width:70px" value="' + row.lealocation + '" onblur="inputBlur(this.id)"/></td>';
        rowHtm += '<td><input type="text" class="partdata5" id="transport' + ind + '" style="width:90px" value="' + row.transport + '"/></td>';
        rowHtm += '<td><input disabled type="text" class="partdata6" id="standardfee' + ind + '" style="width:70px" value="' + row.standardfee + '" /></td>';
        rowHtm += '<td><input type="text" class="partdata7" id="ticketnum' + ind + '" style="width:70px" value="' + row.ticketnum + '"  onKeyUp="keyUpInput(this.id)"/></td>';
        rowHtm += '<td><input type="text" class="partdata8" id="sumfee' + ind + '" style="width:70px" value="' + row.sumfee + '" disabled/></td>';
        rowHtm += '<td><select class="partdata9 " id="itemname' + ind + '" style="width:80px" disabled><option value=' + row.item + '>' + row.itemname + '</select></td>';
        /*rowHtm += '<td><input type="text" class="partdata9" id="itemname' + ind + '" style="width:80px" value="' + row.item + '" disabled/></td>';*/
        rowHtm += '<td><input type="text" class="partdata10" id="trnumber' + ind + '" style="width:70px" value="' + row.trnumber + '" onKeyUp="keyUpInput(this.id)"/></td>';
        rowHtm += '<td style="border-right-width:0px"><input type="text" class="partdata11" id="summoney' + ind + '" style="width:70px" value="' + row.summoney + '" onKeyUp="keyUpInput(this.id)"/></td>';
        rowHtm += "</tr>";
        //console.log("row.item:" + row.item + "row.itemname:" + row.itemname)
        $("#TravelGrid> tbody").append(rowHtm);
    }

    //增加空白行
    function addblankRow(ind) {
        var rowHtm = "";
        rowHtm += "<tr id='row" + ind + "'>";
        rowHtm += '<td><input type="radio" name = "rowselected" id="check' + ind + '"/></td>'
        rowHtm += '<td style="display:none"><input type="text" id="rowid' + ind + '" style="width:175px"/></td>'
        rowHtm += '<td rowspan=1 ><input type="text" class="partdata1" id="arrdate' + ind + '" style="width:175px"/></td>';
        rowHtm += '<td rowspan=1><input type="text" class="partdata2" id="arrlocation' + ind + '" style="width:70px" onblur="inputBlur(this.id)"/></td>';
        rowHtm += '<td rowspan=1><input type="text" class="partdata3" id="leadate' + ind + '" style="width:175px"/></td>';
        rowHtm += '<td rowspan=1><input type="text" class="partdata4" id="lealocation' + ind + '" style="width:70px" onblur="inputBlur(this.id)"/></td>';
        rowHtm += '<td rowspan=1><input type="text" class="partdata5" id="transport' + ind + '" style="width:90px"/></td>';
        rowHtm += '<td rowspan=1><input type="text" class="partdata6" id="standardfee' + ind + '" style="width:70px" disabled/></td>';
        rowHtm += '<td rowspan=1><input type="text" class="partdata7" id="ticketnum' + ind + '" style="width:70px" onKeyUp="keyUpInput(this.id)"/></td>';
        rowHtm += '<td rowspan=1><input type="text" class="partdata8" id="sumfee' + ind + '" style="width:70px" disabled/></td>';
        rowHtm += '<td rowspan=1><input type="text" class="partdata9" id="itemname' + ind + '" style="width:80px" disabled/></td>';
        rowHtm += '<td rowspan=1><input type="text" class="partdata10" id="trnumber' + ind + '" style="width:70px"  disabled/></td>';
        rowHtm += '<td rowspan=1 style="border-right-width:0px"><input type="text" class="partdata11" id="summoney' + ind + '" style="width:70px" disabled/></td>';
        rowHtm += "</tr>";
        $("#TravelGrid>tbody").append(rowHtm)
    }

    //新增数据
    $("#TrAddBt").click(function () {
        var rows = $('#TravelGrid').find('tbody').find('tr');
        addblankRow(rows.length);
        initRow(rows.length)
    })

    //初始化使用easyui各个组件
    function initRow(rownum) {
        //日期时间框的初始化
        $("#arrdate" + rownum + ", #leadate" + rownum + "").datetimebox({
            showSeconds: false
        });
        //combogrid的初始化
        $("#transport" + rownum + "").combogrid({
            panelWidth: 300,
            idField: 'tool',
            textField: 'tool',
            url: $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetTransport',
            onBeforeLoad: function (param) {
                param.hospid = hospid;
                param.lealocation = $("#lealocation" + rownum + "").val();
                param.arrlocation = $("#arrlocation" + rownum + "").val();
                param.str = param.q;
            },
            columns: [
                [{
                        field: 'tool',
                        title: '工具',
                        width: 100
                    },
                    {
                        field: 'standardfee',
                        title: '标准费用',
                        width: 100
                    },
                    {
                        field: 'FDesc',
                        title: '人员类别',
                        width: 100
                    }
                ]
            ],
            onSelect: function (rec, row) {
                $("#standardfee" + rownum + "").numberbox("setValue", row.standardfee);
                $("#ticketnum" + rownum + "").val("");
                $("#sumfee" + rownum + "").val("");
            }
        });
        //numberbox的初始化
        $("#standardfee" + rownum + ", #sumfee" + rownum + ", #summoney" + rownum + ", #summoney" + rownum + "").numberbox({
            min: 0,
            precision: 2
        });
        $("#ticketnum" + rownum + ", #trnumber" + rownum + "").numberbox({
            min: 0,
            precision: 0
        });
        $("#sumcost, #spartmoney, #reqpay, #reqfee, #supplyfee, #backfee").numberbox({
            precision: 2
        });
        $("#sumnumber").numberbox({
            min: 0,
            precision: 0
        });
    }

    //清空事件以及函数
    $("#TrClearBt").click(function () {
        var rows = $('#TravelGrid').find('tbody').find('tr');
        for (var i = 0; i < rows.length; i++) { //遍历表格的行
            for (var j = 0; j < rows[i].cells.length; j++) { //遍历每行的列
                if (j != 10) {
                    rows[i].cells[j].getElementsByTagName("input")[0].value = "" //清空每个input框的值
                }
            }
            //清空easyui组件的值  
            $("#arrdate" + i + ", #leadate" + i + "").datetimebox("clear");
            $("#transport" + i + "").combogrid("clear");
            $("#standardfee" + i + ", #sumfee" + i + ", #summoney" + i + ", #summoney" + i + "").numberbox("clear");
            $("#ticketnum" + i + ", #trnumber" + i + "").numberbox("clear");
            $("#sumcost, #spartmoney, #reqpay, #reqfee, #supplyfee, #backfee").numberbox("clear");
            $("#sumnumber").numberbox("clear");
        }
    })

    //键盘监听事件
    keyUpInput = function (id) {
        //交通费用单据张数以及标准费用列键盘监听
        if (id.indexOf("ticketnum") != -1 || (id.indexOf("standardfee") != -1)) {
            var rowindex = id.indexOf("ticketnum") != -1 ? id.split("ticketnum") : id.split("standardfee"); //获取行索引
            var sumfee = $("#ticketnum" + rowindex[1] + "").val() * $("#standardfee" + rowindex[1] + "").val()
            $("#sumfee" + rowindex[1] + "").numberbox("setValue", sumfee); //行金额赋值
            var sumcost = 0
            var rows = $('#TravelGrid').find('tbody').find('tr'); //获取表格的行
            for (var m = 0; m < rows.length; m++) { //遍历表格的行
                var sumcost = Number(sumcost) + Number($("#sumfee" + m + "").val())
            }
            $("#sumcost").numberbox("setValue", sumcost) //交通费用合计值
            $("#reqpay").numberbox("setValue", Number($("#sumcost").val()) + Number($("#spartmoney").val())) //表格总计值
            inputPayCode();
        }
        //其他费用票据张数以及合计列监听事件
        if (id.indexOf("trnumber") != -1 || (id.indexOf("summoney") != -1)) {
            var sumnumber = 0;
            var sumsmoney = 0;
            var rows = $('#TravelGrid').find('tbody').find('tr'); //获取表格的行
            for (var n = 0; n < rows.length; n++) { //遍历表格的行
                var sumnumber = Number(sumnumber) + Number($("#trnumber" + n + "").val())
                var sumsmoney = Number(sumsmoney) + Number($("#summoney" + n + "").val())
            }
            $("#spartmoney").numberbox("setValue", sumsmoney) //其他费用合计值
            $("#sumnumber").numberbox("setValue", sumnumber) //其他费用票据合计值
            $("#reqpay").numberbox("setValue", Number($("#sumcost").val()) + Number($("#spartmoney").val())) //表格总计值
        }
    }

    //失去焦点事件更新combogrid
    inputBlur = function (colid) {
        //console.log(colid)
        var rindex = colid.indexOf("arrlocation") != -1 ? colid.split("arrlocation") : colid.split("lealocation"); //获取行索引
        $("#transport" + rindex[1] + "").combogrid("clear");
        $("#transport" + rindex[1] + "").combogrid("grid").datagrid("reload")
    }

    //借款单号的失去焦点事件，生成予借旅费，补领金额和退还金额
    inputPayCode = function () {
        $.m({
                ClassName: 'herp.budg.hisui.udata.ubudgcostclaimapplytravel',
                MethodName: 'Genfee',
                applycode: $("#TrPayCode").val(),
                curreqfee: Number($("#reqpay").val())

            },
            function (Data) {
                var arrayData = Data.split("^");
                $("#reqfee").numberbox("setValue", arrayData[0]);
                $("#supplyfee").numberbox("setValue", arrayData[1]);
                $("#backfee").numberbox("setValue", arrayData[2]);
            }
        );
    }
    //保存
    $("#TravelSave").unbind("click").click(function () {
        if ($("#TrApplyCbox").val() == "" || ($('#TrYMbox').combobox('getValue') == "")) {
            var message = "请选择预算期!";
            $.messager.popover({
                msg: message,
                type: 'info',
                showType: 'show',
                style: {
                    "position": "absolute",
                    "z-index": "9999",
                    left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                    top: 10
                }
            });
            return false;
        }
        if ($('#TrDeptbox').combobox('getValue') == "") {
            var message = "请选择报销科室!";
            $.messager.popover({
                msg: message,
                type: 'info',
                showType: 'show',
                style: {
                    "position": "absolute",
                    "z-index": "9999",
                    left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                    top: 10
                }
            });
            return false;
        }
        if ($('#TrUserbox').combobox('getValue') == "") {
            var message = "请选择申请人!";
            $.messager.popover({
                msg: message,
                type: 'info',
                showType: 'show',
                style: {
                    "position": "absolute",
                    "z-index": "9999",
                    left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                    top: 10
                }
            });
            return false;
        }
        if ($('#TrDescbox').val() == "") {
            var message = "请填写说明!";
            $.messager.popover({
                msg: message,
                type: 'info',
                showType: 'show',
                style: {
                    "position": "absolute",
                    "z-index": "9999",
                    left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                    top: 10
                }
            });
            return false;
        }
        if ($("#ChargePay").checkbox("getValue") == 1 && ($("#TrPayCode").val() == "")) {
            var message = "请填写借款单号!";
            $.messager.popover({
                msg: message,
                type: 'info',
                showType: 'show',
                style: {
                    "position": "absolute",
                    "z-index": "9999",
                    left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                    top: 10
                }
            });
            return false;
        }
        if ($('#TrPaybox').combobox('getValue') == "") {
            var message = "请选择支付方式!";
            $.messager.popover({
                msg: message,
                type: 'info',
                showType: 'show',
                style: {
                    "position": "absolute",
                    "z-index": "9999",
                    left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                    top: 10
                }
            });
            return false;
        }
        if ($('#TrPaybox').combobox('getValue') == "2") {
            if (!$('#TrBankbox').val()) {
                $.messager.popover({
                    msg: "请填写银行!",
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
            if (!$('#TrNumberbox').val()) {
                $.messager.popover({
                    msg: "请填写账号!",
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
        if ($('#TritemCodebox').combobox('getValue') == "") {
            var message = "请选择报销项目!";
            $.messager.popover({
                msg: message,
                type: 'info',
                showType: 'show',
                style: {
                    "position": "absolute",
                    "z-index": "9999",
                    left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                    top: 10
                }
            });
            return false;
        }
        $.messager.confirm('确定', '确定要保存选定的数据吗？', function (t) {
            if (t) {
                //主表数据获取
                var mainData = maingridid 
                    + "|" + $("#TrApplyCbox").val() //报销单号
                    + "|" + $('#TrYMbox').combobox('getValue') //预算期
                    + "|" + $('#TrDeptbox').combobox('getValue') //报销科室
                    + "|" + $('#TrUserbox').combobox('getValue') //申请人
                    + "|" + $('#TrDescbox').val().replace(/(^\s*)|(\s*$)/g, "") //报销说明
                    + "|" + $("#TrPayCode").val() //借款单号
                    + "|" + "" //预报销单号
                    + "|" + userid + "|" + $('#TrPaybox').combobox('getValue') //支付方式
                    + "|" + $("#TrBankbox").val() //银行
                    + "|" + $("#TrNumberbox").val() //银行卡号
                    + "|" + hospid; //医院id

                //需要处理一下，审核时reqpay和新建情况下的reqpay更新的地方不一样 

                //明细表数据获取                    
                var detailData = detailgridid + "|" + $('#TritemCodebox').combobox('getValue') +
                    "|" + $('#TrecoCodebox').combobox('getValue') +
                    "|" + $('#TrpurCodebox').combobox('getValue') +
                    "|" + $('#TrcontMethodbox').combobox('getValue') +
                    "|" + document.getElementById("reqpay").value //总计
                    + "|" + document.getElementById("reqpay").value +
                    "|" + $('#TrDescbox').val().replace(/(^\s*)|(\s*$)/g, "") +
                    "|" + $('#TrBalancebox').val() + "|" + $('#TrAuDeptbox').combobox('getValue');
				//console.log("detailData:"+detailData);
                //费用获取               
                var someFee = $("#reqfee").val() //予借旅费
                    + "|" + $("#backfee").val() //退还金额
                    + "|" + $("#supplyfee").val() //补给金额

                //获取表格内tbody部分的数据
                var dataInfos = ""
                var rows = $('#TravelGrid').find('tbody').find('tr'); //获取表格的行
                for (var j = 0; j < rows.length; j++) { //遍历表格的行
                    var dataInfo = $("#rowid" + j + "").val() + "|" +
                        $("#arrdate" + j + "").datetimebox("getValue") + "|" +
                        $("#arrlocation" + j + "").val() + "|" +
                        $("#leadate" + j + "").datetimebox("getValue") + "|" +
                        $("#lealocation" + j + "").val() + "|" +
                        $("#transport" + j + "").combogrid("getValue") + "|" +
                        $("#standardfee" + j + "").numberbox("getValue") + "|" +
                        $("#ticketnum" + j + "").numberbox("getValue") + "|" +
                        $("#sumfee" + j + "").numberbox("getValue") + "|" +
                        $("#itemname" + j + "").val() + "|" +
                        $("#trnumber" + j + "").numberbox("getValue") + "|" +
                        $("#summoney" + j + "").numberbox("getValue")
                    if (dataInfos == "") {
                        var dataInfos = dataInfo
                    } else {
                        var dataInfos = dataInfos + "^" + dataInfo
                    }
                }
                //console.log("dataInfos:"+dataInfos);
                $.m({
                        ClassName: 'herp.budg.hisui.udata.ubudgcostclaimapplytravel',
                        MethodName: 'Save',
                        maindata: mainData,
                        detaildata: detailData,
                        traveldatas: dataInfos,
                        somefee: someFee
                    },
                    function (Data) {
                        //console.log(isAudit)
                        if (Data == 0) {
                            $.messager.popover({
                                msg: '保存成功！',
                                type: 'success',
                                timeout: 5000,
                                style: {
                                    "position": "absolute",
                                    "z-index": "9999",
                                    left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
                                    top: 1
                                }
                            });
                            if (isAudit == 100) {
                                $.m({
                                        ClassName: 'herp.budg.hisui.udata.ubudgcostclaimapplytravel',
                                        MethodName: 'ListDetid',
                                        paybillcode: $("#TrApplyCbox").val()
                                    },
                                    function (data) {
                                        //console.log(data)
                                        var arryids = data.split("^");
                                        detailgridid = arryids[1];
                                        maingridid = arryids[0];
                                        isAudit = 0;
                                        $.ajax({
                                            type: 'post',
                                            url: $URL + '?ClassName=herp.budg.hisui.udata.ubudgcostclaimapplytravel&MethodName=ListRecord',
                                            data: {
                                                paybilldeid: detailgridid,
                                                hospid: hospid
                                            },
                                            success: function (rtn) {
                                                $("#traveltbody tr").remove();
                                                var rtn = $.parseJSON(rtn)
                                                //console.log(rtn)
                                                for (var i = 0; i < rtn.total; i++) {
                                                    addRow(i, rtn.rows[i])
                                                    initRow(i)
                                                }
                                                addblankRow(i);
                                                initRow(i)
                                            }
                                        });
                                    })
                            }
                        } else {
                            $.messager.popover({
                                msg: '保存失败！' + Data,
                                type: 'error',
                                timeout: 5000,
                                style: {
                                    "position": "absolute",
                                    "z-index": "9999",
                                    left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
                                    top: 1
                                }
                            });
                        }
                    })
            }
        })
    })


    //删除功能
    $("#TrDelBt").click(function () {
        //console.log($('#traveltbody input[name="rowselected"]:checked').attr("id"));
        var gridrowid = $('#traveltbody input[name="rowselected"]:checked').attr("id");
        var rowindex = gridrowid.split("check")[1];
        var travelid = $("#rowid" + rowindex + "").val()
        if ($("#itemname" + rowindex + "").val() != "") {
            $.messager.popover({
                msg: "该行数据不可删除",
                type: 'error',
                timeout: 5000,
                style: {
                    "position": "absolute",
                    "z-index": "9999",
                    left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
                    top: 1
                }
            });
            return;
            //未保存过的数据进行删除操作
        } else {
            $.messager.confirm('确定', '确定要删除选定的数据吗？', function (t) {
                if (t) {
                    var lastrowid = $('#traveltbody tr:last').attr("id");
                    var lastindex = lastrowid.split("row")[1]; //最后一行序号
                    $("#row" + rowindex + "").remove();
                    //如果所删除的为最后一行，则不需要进行后续列重新排序的操作，否则是需要的
                    if (rowindex != lastindex) {
                        for (var h = Number(rowindex) + 1; h < Number(lastindex) + 1; h++) {
                            //alert(h);
                            $("#row" + h + "").attr("id", "row" + (h - 1) + "");
                            $("#rowid" + h + "").attr("id", "rowid" + (h - 1) + "");
                            $("#arrdate" + h + "").attr("id", "arrdate" + (h - 1) + "");
                            $("#arrlocation" + h + "").attr("id", "arrlocation" + (h - 1) + "");
                            $("#leadate" + h + "").attr("id", "leadate" + (h - 1) + "");
                            $("#lealocation" + h + "").attr("id", "lealocation" + (h - 1) + "");
                            $("#transport" + h + "").attr("id", "transport" + (h - 1) + "");
                            $("#standardfee" + h + "").attr("id", "standardfee" + (h - 1) + "");
                            $("#ticketnum" + h + "").attr("id", "ticketnum" + (h - 1) + "");
                            $("#sumfee" + h + "").attr("id", "sumfee" + (h - 1) + "");
                            $("#itemname" + h + "").attr("id", "itemname" + (h - 1) + "");
                            $("#trnumber" + h + "").attr("id", "trnumber" + (h - 1) + "");
                            $("#summoney" + h + "").attr("id", "summoney" + (h - 1) + "");
                        }
                    }
                    var sumcost = 0,
                        sumnumber = 0,
                        sumsmoney = 0
                    var rows = $('#TravelGrid').find('tbody').find('tr');
                    for (var b = 0; b < rows.length; b++) { //遍历表格的行
                        var sumcost = Number(sumcost) + Number($("#sumfee" + b + "").val());
                        var sumnumber = Number(sumnumber) + Number($("#trnumber" + b + "").val());
                        var sumsmoney = Number(sumsmoney) + Number($("#summoney" + b + "").val());
                    }
                    $("#sumcost").numberbox("setValue", sumcost) //交通费用合计值
                    $("#spartmoney").numberbox("setValue", sumsmoney) //其他费用合计值
                    $("#sumnumber").numberbox("setValue", sumnumber) //其他费用票据合计值
                    $("#reqpay").numberbox("setValue", Number($("#sumcost").val()) + Number($("#spartmoney").val())) //表格总计值
                    inputPayCode();
                    //如果是之前保存过的数据，需要调用后台删除方法
                    if (travelid != "") {
                        $.m({
                                ClassName: 'herp.budg.hisui.udata.ubudgcostclaimapplytravel',
                                MethodName: 'Delete',
                                travelid: travelid
                            },
                            function (Data) {
                                if (Data == 0) {
                                    $.messager.popover({
                                        msg: '删除成功！',
                                        type: 'success',
                                        timeout: 5000,
                                        style: {
                                            "position": "absolute",
                                            "z-index": "9999",
                                            left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
                                            top: 1
                                        }
                                    });
                                } else {
                                    $.messager.popover({
                                        msg: '删除失败！' + Data,
                                        type: 'error',
                                        timeout: 5000,
                                        style: {
                                            "position": "absolute",
                                            "z-index": "9999",
                                            left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
                                            top: 1
                                        }
                                    });
                                }
                            })
                    }
                }
            })
        }

    })




}