$(function(){
    patInfo.ipAddress = getIpAddress();
    $('.hisui-searchbox').searchbox({
        searcher: function (value, name) {
            queryData();
        },
        prompt: emrTrans('请输入...')
    });
    $('#recordDocCodeType').combobox({
        valueField:"DocCode",
        textField:"Desc",
        panelHeight:"auto"
    });
    //设置时间
    $('#startDate').datebox('setValue',dateformatter(setDate(6)));
    $('#endDate').datebox('setValue',dateformatter(setDate(0)));
    initPatientListTable();
    initPnlButton();
    //如果未配置诊断证明模板 增加系统提示
    if(sysOption.diagnoseProofDocCode == ""){
        $.messager.alert("提示信息", "未找到配置模板，请到维护程序中确认！", "info");
    }else{
        initDocCodeType();
    }
    //设置默认光标在regNoSearch输入框里
    $('input',$('#regNoSearch').next('span')).focus();
});

//读卡
function readCardEvent(){
    DHCACC_GetAccInfo7(CardNoKeyDownCallBack);
}

//读卡回调函数，固定入参
function CardNoKeyDownCallBack(myrtn, errMsg){
    var myary=myrtn.split("^");
    var rtn=myary[0];
    switch (rtn){
        case "0": //卡有效有帐户
            //var PatientID=myary[4];
            //var PatientNo=myary[5];
            //var CardNo=myary[1];
            //$("#cardNoSearch").searchbox('setValue',myary[1]);
            $("#regNoSearch").searchbox('setValue',myary[5]);
            queryData();
            break;
        case "-200": //卡无效
            alert("读卡失败，卡无效！");
            return false;
            break;
        case "-201": //卡有效无帐户
            alert("读卡失败，无账户信息！")
            break;
        default:
    }
}

//设置数据
function initPatientListTable()
{
    var param = getParam();
    $('#patientListData').datagrid({
        url:'../EMR.DOC.SRV.RequestCommon.cls?PAGING=Y&MWToken='+getMWToken(),
        pageSize:10,
        pageList:[10,20,30,40,50],
        striped: true,
        pagination: true,
        loadMsg:'数据装载中......',
        autoRowHeight: true,
        singleSelect: true,
        queryParams: param,
        idField:'DocumentID',
        rownumbers:true,
        fit:true,
        remoteSort:false,
        columns: [[
            {field: 'PatientID',title: 'PatientID',hidden: true},
            {field: 'EpisodeID',title: 'EpisodeID',hidden: true},
            {field: 'mradm',title: 'mradm',hidden: true},
            {field: 'DocumentID',title: 'DocumentID',hidden: true},
            {field: 'Log',title: '日志',formatter: function (value,row,index) {
                var html = '<div>';
                var title = emrTrans("日志");
                var style = "display:block;width:100%;";
                if (row["ID"]!="")
                {
                    style += "background:url(../scripts/emr/image/icon/log.png) center center no-repeat;"
                    html = html + '<span title="'+title+'" style="'+style+'" onclick=viewLog("'+row.DocumentID+'");>&nbsp;&nbsp;</span>';
                }
                html = html + '</div>';
                return html;
            },width: 60},
            {field: 'Status',title: '病历状态',width: 70},
            {field: 'AuditStatus',title: '审核状态',width: 70},
            {field: 'Title',title: '病历名称',width: 90},
            {field: 'PAPMIName',title: '姓名',width: 60},
            {field: 'PAPMIIDCard',title: '身份证号',width: 80},
            {field: 'PAAdmDate',title: '就诊日期',width: 90},
            {field: 'PAAdmTime',title: '就诊时间',width: 70},
            {field: 'PAAdmLoc',title: '就诊科室',width: 120},
            {field: 'PAAdmDoc',title: '就诊医师',width: 80},
            {field: 'Diagnosis',title: '门诊诊断',width: 500}
        ]],
        rowStyler: function (index, row) {
            if (row.Status == "已删除") {
                return "color:red";
            }else {}
        },
        onDblClickRow: function (rowIndex, rowData) {
            switchEMRContent(rowData);
        },
        onLoadSuccess:function(data){
            document.getElementById("container").innerHTML = "<div id=\"bsOfficeEditor\" style=\"overflow:hidden;width:100%;height:100%;\"></div>";
            setPnlBtnDisable(true);
        }
    });
}

// 更新病历页面内容
function switchEMRContent(rowData){
    if (rowData.DocumentID == envVar.documentID){
        return;
    }
    // 全局参数替换
    patInfo.patientID = rowData.PatientID;
    patInfo.episodeID = rowData.EpisodeID;
    patInfo.mradm = rowData.mradm;
    setPnlBtnDisable(true);
    $('#btnViewRevision').linkbutton({
        text : emrTrans('显示留痕')
    });
    if ((rowData.DocumentID == "")||(rowData.Status == "未保存")){
        $("#bsOfficeEditor").css("display","none");
        return $.messager.alert("提示信息", "本次就诊无电子病历记录！", "info");
    }
    envVar.documentID = rowData.DocumentID;
    var sthmsg = "病历正在初始化...";
    setSysMenuDoingSth(sthmsg);
    try {
        loadDocument(rowData);
        if (sthmsg == getSysMenuDoingSth()) {
            setSysMenuDoingSth("");
        }
        $('#btnViewRevision').linkbutton('enable');
        $('#btnBrowse').linkbutton('enable');
        if (rowData.Status == "已签名") {
            //刷新病历后解锁按钮
            if (rowData.AuditStatus == "已拒绝"){
                return;
            }
            $('#btnAuditAndPrint').linkbutton('enable');
            $('#btnOpOfficeAudit').linkbutton('enable');
            if (rowData.AuditStatus == "已审核"){
                $('#btnPrint').linkbutton('enable');
            }
            if (rowData.AuditStatus == "未审核"){
                $('#btnRefuse').linkbutton('enable');
            }
        }
    } catch (error) {
        setSysMenuDoingSth("");
        $.messager.alert("发生错误","病历初始化失败：" + error.message || error,"error");
    }
}

// 加载文档
function loadDocument(rowData){
    var args = {
        action: "LOAD_DOCUMENT",
        params: {
            documentID: rowData.DocumentID,
            pluginType: rowData.PluginType
        },
        type: {
            serial: rowData.serial,
            leadframe: rowData.isLeadframe
        },
        product: envVar.product
    };
    var switchPluginType = false;
    if (pluginType != rowData.PluginType){
        switchPluginType = true;
    }
    if (!document.getElementById("bsOfficeEditor").innerHTML || switchPluginType){
        pluginType = rowData.PluginType;
        EmrEditor.initEditor({
            rootID: "#bsOfficeEditor",
            product: envVar.product,
            patInfo: patInfo,
            parameters:{
                status: "browse",
                region: "content",
                revise: {
                    del: {
                        show: "0"
                    },
                    add: {
                        show: "0"
                    },
                    style: {
                        show: "0"
                    }
                }
            },
            pluginType: pluginType,
            MWToken: getMWToken(),
            editorEvent: editorEvent,
            commandJson: args
        });
    }else{
        setSysMenuDoingSth('病历加载中...');
        EmrEditor.execute(args);
    }
}

var editorEvent = {
    eventloadglobalparameters: function(commandJson){
        if ("fail" === commandJson.result){
            console.log(commandJson);
        }
    },
    eventloaddocument: function(commandJson){
        setSysMenuDoingSth("");
        if ("fail" === commandJson.result){
            $.messager.alert("发生错误", "加载病历失败！", "error");
            $("#bsOfficeEditor").css("display","none");
            setPnlBtnDisable(true);
            console.log(commandJson);
            return;
        }
        var display = $("#bsOfficeEditor").css("display");
        if ("none" === display){
            $("#bsOfficeEditor").css("display","block");
        }
    },
    eventPrintDocument: function(commandJson){
        console.log(commandJson);
        //记录打印日志
        var data = {
            action: "PRINT_DOCUMENT",
            params: {
                documentID: commandJson.args.documentID,
                userID: patInfo.userID,
                userLocID: patInfo.userLocID,
                printType: "EMR",
                pmdType: patInfo.pmdType,
                pmdCode: patInfo.pmdCode,
                ipAddress: patInfo.ipAddress
            },
            product: envVar.product
        };
        ajaxGETCommon(data, function(ret){
            if (ret != "1"){
                $.messager.alert("提示信息", "打印日志保存失败！","error");
            }
        }, function (error) {
            $.messager.alert("发生错误", "printDcoument error:"+error, "error");
        }, true);
    }
};

// 查询
function queryData()
{
    var param = getParam();
    if (param){
        $.messager.progress({
            title: '提示',
            msg: '数据查询中，请稍候……',
            text: '查询中……'
        });
        $('#patientListData').datagrid('load',param);
        $.messager.progress('close');
    }
}

//获取查询参数
function getParam()
{
    var param = "";
    var regNo = $("#regNoSearch").searchbox('getValue');
    var name = $("#nameSearch").searchbox('getValue');
    var cardNo = $("#cardNoSearch").searchbox('getValue');
    var startDate = $("#startDate").datebox('getValue');
    var endDate = $("#endDate").datebox('getValue');
    var auditStatus = $("#auditStatus").combobox('getValue');
    var docType = $('#recordDocCodeType').combobox('getValue') || "ALL";
    if (sysOption.patientNoLength != "") {
       //登记号
       regNo = setLength(regNo,"regNoLength");
       //就诊卡号
       cardNo = setLength(cardNo,"cardNoLength");
    }
    var patStatus = setSearchOptions(regNo, name, cardNo);
    if (patStatus != "") {
        //showEditorMsg({msg: patStatus,type: "info"});
        $.messager.alert("提示信息", patStatus, "info");
        return param;
    }
    
    if ("" != startDate){
        startDate = getHISDateTimeFormate("Date",startDate);
    }
    if ("" != endDate){
        endDate = getHISDateTimeFormate("Date",endDate);
    }
    if (("" != startDate)&&("" != endDate)){
        var startDateTime = new Date(startDate);
        var endDateTime = new Date(endDate);
        var timeInterval = endDateTime.getTime()-startDateTime.getTime();
        var days = Math.floor(timeInterval/(24*3600*1000));
        if (days < 0){
            $.messager.alert("提示信息", "开始日期大于结束日期,请重新选择起始日期!", "info");
            return param;
        }else if (days >= 7){
            $.messager.alert("提示信息", "查询时间范围要在7天之内!", "info");
            return param;
        }
    }
    
    param = {
        paramdata: JSON.stringify({
            action: "GET_OPPATLIST",
            params: {
                langID: langID,
                papmiNo: regNo,
                name: name,
                cardID: cardNo,
                startDate: startDate,
                endDate: endDate,
                checkStatus: auditStatus,
                docType: docType
            },
            product: envVar.product
        })
    };
    return param;
}

//补0方法 默认不满length位的补0
function setLength(val, type){
    if ((""!=val)&&isExistVar(sysOption.patientNoLength[type])) {
        if (sysOption.patientNoLength[type] != "") {
            var num = sysOption.patientNoLength[type];
            return Array(num>(num.toString()).split('').length?(num-(''+val).length+1):0).join(0)+val;
        }
    }
    return val;
}

//查询条件
function setSearchOptions(regNo, name, cardNo){
    var patStatus = "";
    if ((regNo == "")&&(name == "")&&(cardNo =="")){
        return patStatus;
    }
    var data = {
        action: "GET_OPPATINFO",
        params:{
            papmiNo: regNo,
            name: name,
            cardID: cardNo
        },
        product: envVar.product
    };
    ajaxGETCommon(data, function(patInfoData){
        if (patInfoData){
            $("#regNoSearch").searchbox('setValue', patInfoData[0].RegNo);
            $("#nameSearch").searchbox('setValue', patInfoData[0].PatName);
            $("#cardNoSearch").searchbox('setValue', patInfoData[0].CardNo);
        }else{
            patStatus = "未找到指定患者,请重新输入查询条件!";
            $("#regNoSearch").searchbox('setValue', regNo);
            $("#nameSearch").searchbox('setValue', name);
            $("#cardNoSearch").searchbox('setValue', cardNo);
        }
    }, function (error) {
        $.messager.alert("发生错误", "getPatInfo error:"+error, "error");
    }, false);
    return patStatus;
}

//将HISUI系统日期或时间配置转为YYYY-MM-DD或HH:MM:SS格式
function getHISDateTimeFormate(type,value){
    var retvalue = "";
    var data = {
        action: "GET_STANDARD_DATE",
        params:{
            type: type,
            value: value
        },
        product: envVar.product
    };
    ajaxGETCommon(data, function(ret){
        if (ret){
            retvalue = ret;
        }
    }, function (error) {
        $.messager.alert("发生错误", "getHISDateTimeFormate error:"+error, "error");
    }, false);
    return retvalue; 
}

//默认获取当前日期范围（七天）
function setDate(n){
    var now = new Date;
    now.setDate(now.getDate() - n);
    return now;
}

// 格式化日期
function dateformatter(date){
    var year = date.getFullYear();
    var month = date.getMonth()+1;
    var day = date.getDate();
    
    if(!isExistVar(dateFormat)){
        return year+"-"+(month<10?("0"+month):month)+"-"+(day<10?("0"+day):day);
    }else{
        if(dateFormat=="4"){
            //日期格式 4:"DMY" DD/MM/YYYY
            return (day<10?("0"+day):day)+"/"+(month<10?("0"+month):month)+"/"+year;
        }else if(dateFormat=="3"){
            //日期格式 3:"YMD" YYYY-MM-DD
            return year+"-"+(month<10?("0"+month):month)+"-"+(day<10?("0"+day):day);
        }else if(dateFormat=="1"){
            //日期格式 1:"MDY" MM/DD/YYYY
            return (month<10?("0"+month):month)+"/"+(day<10?("0"+day):day)+"/"+year;
        }else{
            return year+"-"+(month<10?("0"+month):month)+"-"+(day<10?("0"+day):day);
        }
    }
}

//初始化类型下拉框
function initDocCodeType(){
    var data = {
        action: "GET_DOCTYPEDATA",
        params:{},
        product: envVar.product
    };
    ajaxGETCommon(data, function(ret){
        if (ret){
            $("#recordDocCodeType").combobox({data:ret});
        }
    }, function (error) {
        $.messager.alert("发生错误", "initDocCodeType error:"+error, "error");
    }, true);
}

//查看日志
function viewLog(documentID){
    var data = {
        action: "GET_DIAGAUDITANDPRINTLOG",
        params:{
            documentID: documentID
        },
        product: envVar.product
    };
    ajaxGETCommon(data, function(ret){
        if (ret.length > 0){
            $("#dialogLog").dialog({closed: false});
            initLogDataGrid(ret);
        }
    }, function (error) {
        $.messager.alert("发生错误", "viewLog error:"+error, "error");
    }, true);
}

//日志
function initLogDataGrid(data){
    $("#officeLog").datagrid({
        loadMsg:'数据装载中......',
        autoSizeColumn:false,
        fit:true,
        fitColumns:true,
        pagination:false,
        columns:[[
            {field:'OrderID',title:'顺序号',width:60,sortable:true,type:'int'},
            {field:'LoginUserName',title:'登录医师',width:80,sortable:true},
            {field:'OperUserName',title:'操作医师',width:80,sortable:true},
            {field:'OperDate',title:'操作日期',width:100,sortable:true},
            {field:'OperTime',title:'操作时间',width:90,sortable:true},
            {field:'MachineIP',title:'IP地址',width:100,sortable:true},
            {field:'Action',title:'操作名称',width:90,sortable:true},
            {field:'ProductSource',title:'产品模块',width:110,sortable:true}
        ]],
        data:data
    });
}

// 提示消息
function showEditorMsg(obj) {
    if (isExistVar(obj.msg)) {
        var msgTimeOut = 3000;
        if (isExistVar(sysOption.infoMessage[obj.type])) {
            if (sysOption.infoMessage[obj.type] != "") {
                msgTimeOut = sysOption.infoMessage[obj.type];
            }
        }
        var msgStyle = {};
        if (isExistVar(sysOption.infoMessage.style)) {
            if (sysOption.infoMessage.style != "") {
                msgStyle = sysOption.infoMessage.style;
                if (isExistVar(sysOption.infoMessage.style.left)) {
                    if (sysOption.infoMessage.style.left == "center") {
                        msgStyle.left = document.documentElement.clientWidth/2; // 居中显示
                    }
                }
            }
        }
        $.messager.popover({
            msg: obj.msg,
            type: obj.type,
            timeout: msgTimeOut,
            style: msgStyle
        });
    }
}

function setSysMenuDoingSth(sthmsg) {
    if ("undefined" != typeof dhcsys_getmenuform) {
        if ("undefined" != typeof dhcsys_getmenuform()) {
            var DoingSth = dhcsys_getmenuform().DoingSth || "";
            if ("" != DoingSth)
                DoingSth.value = sthmsg || "";
        }
    }
}

function getSysMenuDoingSth() {
    if ("undefined" != typeof dhcsys_getmenuform) {
        if ("undefined" != typeof dhcsys_getmenuform()) {
            var DoingSth = dhcsys_getmenuform().DoingSth || "";
            if ("" != DoingSth)
                return DoingSth.value || "";
        }
    }
    return "";
}