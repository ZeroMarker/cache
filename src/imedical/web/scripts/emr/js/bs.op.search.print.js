$(function(){
    patInfo.ipAddress = getIpAddress();
    $('.hisui-searchbox').searchbox({
        searcher: function (value, name) {
            queryData();
        },
        prompt: emrTrans('请输入...')
    });
    //设置时间
    $('#startDate').datebox('setValue',dateformatter(setDate(6)));
    $('#endDate').datebox('setValue',dateformatter(setDate(0)));
    initPatientListTable();
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
        singleSelect: false,
        queryParams: param,
        idField:'DocumentID',
        rownumbers:true,
        fit:true,
        remoteSort:false,
        columns: [[
            {field: 'ck',checkbox:true},
            {field: 'PatientID',title: 'PatientID',hidden: true},
            {field: 'EpisodeID',title: 'EpisodeID',hidden: true},
            {field: 'mradm',title: 'mradm',hidden: true},
            {field: 'DocumentID',title: 'DocumentID',hidden: true},
            {field: 'PAPMIName',title: '姓名',width: 60},
            {field: 'PAPMISex',title: '性别',width: 60},
            {field: 'PAPMIAge',title: '年龄',width: 60},
            {field: 'PAAdmDate',title: '就诊日期',width: 120},
            {field: 'PAAdmTime',title: '就诊时间',width: 120},
            {field: 'PAAdmLoc',title: '就诊科室',width: 120},
            {field: 'PAAdmDoc',title: '就诊医师',width: 120},
            {field: 'Diagnosis',title: '门诊诊断',width: 200},
            {field: 'Text',title: '病历名称',width: 200},
            {field: 'CreateUserName',title: '创建医师',width: 120},
            {field: 'PageNum',title: 'PageNum',width: 20,hidden: true},
            {field: 'IsAllowCheckPrint',title: 'IsAllowCheckPrint',hidden: true},
            {field: 'PrintInfo',title: '打印情况',width: 400,formatter: function(value) {
                if (value != "未打印"){
                    return '<span style="color:red">'+value+'</span>';
                }else{
                    return value;
                }
            }},
            {field: 'browse',title: '浏览病历',width: 80,formatter: function (value,row,index) {
                return '<a href="#" name="browse" class="hisui-linkbutton" onclick="browse('+index +')"></a>';
            }},
            {field: 'print',title: '打印病历',width: 80,formatter: function(value,row,index) {
               return '<a href="#" name="print" class="hisui-linkbutton" onclick="print('+index+')"></a>';
            }}
        ]],
        onLoadSuccess:function(data){
            $("a[name='browse']").linkbutton({text:'浏览',plain:true,iconCls:'icon-add'});
            $("a[name='print']").linkbutton({text:'打印',plain:true,iconCls:'icon-print'});
            $('#patientListData').datagrid('unselectAll');
            $('#patientListData').datagrid('clearChecked');
            $('#patientListData').datagrid('clearSelections');
        }
    });
}

//浏览所选病历
function browse(index){
    var rowData = $('#patientListData').datagrid("getRows")[index];
    var data = {
        action: "GET_OPPRINTBROWSEURL",
        params:{
            documentID: rowData.DocumentID
        },
        product: envVar.product
    };
    ajaxGETCommon(data, function(url){
        if (url){
            patInfo.patientID = rowData.PatientID;
            patInfo.episodeID = rowData.EpisodeID;
            patInfo.mradm = rowData.mradm;
            var width = window.screen.availWidth - 250;
            var height = window.screen.availHeight - 150;
            createModalDialog("browseDialog","浏览病历",width,height,"browseFrame",'<iframe id="browseFrame" scrolling="auto" frameborder="0" src="'+url+"&MWToken="+getMWToken()+'" style="width:100%;height:100%;display:block;"></iframe>',"");
        }
    }, function (error) {
        $.messager.alert("发生错误", "获取浏览相关Url失败:"+error, "error");
    }, true);
}

//打印所选病历
function print(index){
    if (envVar.printDocument.length == 0){
        top.$.messager.progress({
            title: '提示',
            msg: '病历打印中，请稍候……',
            text: '病历打印中……'
        });
    }
    var rowData = $('#patientListData').datagrid("getRows")[index];
    patInfo.patientID = rowData.PatientID;
    patInfo.episodeID = rowData.EpisodeID;
    patInfo.mradm = rowData.mradm;
    var dialogID = "printSelectDialog-"+index;
    createModalDialog(dialogID,"打印病历",10,10,"printSelectFrame",'<iframe id="printSelectFrame" scrolling="auto" frameborder="0" src="emr.bs.op.browse.csp?documentID='+rowData.DocumentID+"&pluginType="+rowData.PluginType+"&serial="+rowData.serial+"&leadframe="+rowData.isLeadframe+"&product="+envVar.product+"&autoPrint=Y&dialogID="+dialogID+"&MWToken="+getMWToken()+'" style="width:100%;height:100%;display:block;"></iframe>',printDocument);
}

//多选打印
function printSelect(returnValue){
    var checkedItems = $('#patientListData').datagrid('getChecked');
    envVar.printMessage = 0;
    envVar.printDocument = new Array();
    var printTipMessage = "";
    $.each(checkedItems, function(index, item) {
        var rowIndex = $('#patientListData').datagrid("getRowIndex",item);
        if (item.IsAllowCheckPrint == "0") {
            printTipMessage += "【"+item.Text+"】";
            $('#patientListData').datagrid('unselectRow', rowIndex);
            //alert("【"+item.Text+"】不允许勾选打印，请重新勾选！");
            return true;
        }
        if (printTipMessage){
            return true;
        }
        envVar.printDocument.push(rowIndex);
    });
    if (printTipMessage){
        $.messager.alert("提示信息", printTipMessage + "不允许勾选打印，请重新勾选！", "info");
        return;
    }
    if (envVar.printDocument.length > 0){
        top.$.messager.progress({
            title: '提示',
            msg: '病历打印中，请稍候……',
            text: '病历打印中……'
        });
        print(envVar.printDocument[0]);
    }
}

//打印回调
function printDocument(returnValue){
    patchLog(returnValue);
    if (envVar.printDocument.length > 0){
        envVar.printDocument.splice(0, 1);
        envVar.printMessage = Number(envVar.printMessage) + Number(returnValue.args.printPageCount);
        if (envVar.printDocument.length > 0){
            print(envVar.printDocument[0]);
        }
    }else{
        envVar.printMessage = Number(returnValue.args.printPageCount);
    }
    if (envVar.printDocument.length == 0){
        top.$.messager.progress('close');
        $.messager.alert("提示信息", "打印完成，此次共打印"+envVar.printMessage+"页！", "info");
        queryData();
    }
}

//打印日志
function patchLog(commandJson){
    var data = {
        action: "PRINT_DOCUMENT",
        params: {
            documentID: commandJson.args.documentID,
            userID: patInfo.userID,
            userLocID: patInfo.userLocID,
            printType: envVar.printType,
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
        $.messager.alert("发生错误", "patchLog error:"+error, "error");
    }, true);
}

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
        }
    }
    
    param = {
        paramdata: JSON.stringify({
            action: "GET_OPPATCHPRINT",
            params: {
                langID: langID,
                papmiNo: regNo,
                name: name,
                cardID: cardNo,
                startDate: startDate,
                endDate: endDate
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
