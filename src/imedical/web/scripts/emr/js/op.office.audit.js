
$(function () {
    $('#patLst').panel('resize', {
        width: (screen.availWidth) * 0.382
    });
    $('body').layout('resize');

    initPatTable();
    $('#patientListData').datagrid('loadData', {total:0,rows:[]});

    $('.easyui-searchbox').searchbox({
        searcher: function (value, name) {
            setQuery();
        },
        prompt: '请输入',
        width: 140
    });
    initCTLoc();
    initPnlButton();
    //处理编辑器
    $('#editorFrame').attr('src', 'emr.op.editor.csp');

    //禁止后退键
    document.onkeypress = forbidBackSpace;
    document.onkeydown = forbidBackSpace;

    //审核日志
    if (!hisLog) {
        hisLog = new HisLogEx(sysOption.IsSetToLog, patInfo);
    }
});

//  emr.op.editor.csp invoke
function initEditor() {
    var sthmsg = '病历正在初始化...';
    setSysMenuDoingSth(sthmsg);    
    try {
        emrEditor.newEmrPlugin();
        emrEditor.initDocument(true);
        if (sthmsg == getSysMenuDoingSth()) {
            setSysMenuDoingSth();
        }            
    } catch (err) {
        setSysMenuDoingSth();
        alert(err.message || err);
    }
}

function initPatTable() {
    $('#patientListData').datagrid({
        width: '100%',
        height: '100%',
        //pageSize:20,
        //pageList:[10,20,30,50,80,100],
        //fitColumns: true,
        striped: true,
        loadMsg: '数据装载中......',
        //autoSizeColumn: true,
        autoRowHeight: true,
        singleSelect: true,
        idField: 'EpisodeID',
        rownumbers: true,
        fit: true,
        remoteSort: false,
        columns: [[{
                    field: 'PatientID',
                    title: 'PatientID',
                    hidden: true
                }, {
                    field: 'EpisodeID',
                    title: 'EpisodeID',
                    hidden: true
                }, {
                    field: 'mradm',
                    title: 'mradm',
                    hidden: true
                }, {
                    field: 'InstanceID',
                    title: '病历ID',
                    hidden: true
                }, {
                    field: 'Status',
                    title: '病历状态',
                    width: 70,
                    sortable: true
                }, {
                    field: 'AuditStatus',
                    title: '审核状态',
                    width: 70,
                    sortable: true
                }, {
                    field: 'PAPMIName',
                    title: '姓名',
                    width: 60,
                    sortable: true
                }, {
                    field: 'PAAdmDate',
                    title: '就诊日期',
                    width: 80,
                    sortable: true
                }, {
                    field: 'PAAdmTime',
                    title: '就诊时间',
                    width: 80,
                    sortable: true
                }, {
                    field: 'PAAdmLoc',
                    title: '就诊科室',
                    width: 120,
                    sortable: true
                }, {
                    field: 'PAAdmDoc',
                    title: '就诊医师',
                    width: 80,
                    sortable: true
                }, {
                    field: 'Diagnosis',
                    title: '门诊诊断',
                    width: 500,
                    sortable: true
                }
            ]],
        rowStyler: function (index, row) {
            if (row.Status == "已删除") {
                return "color:red";
            }else {}
        },
        onDblClickRow: function (rowIndex, rowData) {
            //alert('onDblClickRow');
            switchEMRContent(rowData);
        }
    });
}

// 初始化科室
function initCTLoc()
{
    $('#cbxLoc').combobox({  
        url:'../EMRservice.Ajax.hisData.cls?Action=GetCTLocList',  
        valueField:'Id',  
        textField:'Text',
        onChange: function (n,o) {
            $('#cbxLoc').combobox('setValue',n);
            var newText = $('#cbxLoc').combobox('getText');
            $('#cbxLoc').combobox('reload','../EMRservice.Ajax.hisData.cls?Action=GetCTLocList&LocContain='+encodeURI(newText.toUpperCase()));
        },
        onShowPanel: function(){
            var newText = $('#cbxLoc').combobox('getText');
            if (newText == "" || newText == "undefinded")
            {
                $('#cbxLoc').combobox('setValue',"");
            }
            $('#cbxLoc').combobox('reload','../EMRservice.Ajax.hisData.cls?Action=GetCTLocList&LocContain='+encodeURI(newText.toUpperCase()));
        },
        onLoadSuccess:function(d){},
        onLoadError:function(){
            alert('GetCTLocList error:');
        }
    });
}
// 更新病历页面内容
function switchEMRContent(rowData) {
    //if (envVar.instanceId == rowData.InstanceID) return;
    //全局参数替换
    patInfo.PatientID = rowData.PatientID;
    patInfo.EpisodeID = rowData.EpisodeID;
    patInfo.MRadm = rowData.mradm;
    emrEditor.cleanDoc();
    $('#btnOpOfficeAudit').attr({"disabled":"disabled"});
    if ((rowData.InstanceID == "")||(rowData.Status == "未完成")) return alert("本次就诊无电子病历记录！");

    common.GetRecodeParamByInsIDSync(rowData.InstanceID, function (tempParam) {
        envVar.savedRecords = tempParam;
        if ("" == envVar.savedRecords) {
            alert("本次就诊无电子病历记录！");
            //showEditorMsg("本次就诊无电子病历记录！", 'warning');
        } else {
            //emrEditor.initDocument(false);
            var sthmsg = '病历正在初始化...';
            setSysMenuDoingSth(sthmsg);    
            try {
                //刷新编辑器
                emrEditor.initDocument(false);
                if (sthmsg == getSysMenuDoingSth()) {
                    setSysMenuDoingSth();
                }            
            } catch (err) {
                setSysMenuDoingSth();
                alert(err.message || err);
            }
            if (rowData.Status == "完成") $('#btnOpOfficeAudit').removeAttr("disabled");
        }
    });
}
//查询条件
function setSearchOptions(regNo, name, cardNo){
    var patStatus = "";
    var data = ajaxDATA('String', 'EMRservice.BL.opPrintSearch', 'GetOPPatInfo', regNo, "", name, "", cardNo);
    ajaxPOSTSync(data, function (ret) {
        if ('' != ret) {
            var patInfoData = $.parseJSON(ret);
            $("#regNoSearch").searchbox('setValue', patInfoData.RegNo);
            $("#nameSearch").searchbox('setValue', patInfoData.PatName);
            $("#cardNoSearch").searchbox('setValue', patInfoData.CardNo);
        }else {
            patStatus = "未找到指定患者,请重新输入查询条件!";
            if ("" === regNo) $("#regNoSearch").searchbox('setValue', '');
            if ("" === name) $("#nameSearch").searchbox('setValue', '');
            if ("" === cardNo) $("#cardNoSearch").searchbox('setValue', '');
        }
    }, function (err) {
        alert('GetOPPatInfo error:' + err);
    });
    return patStatus;
}

//设置登记号长度
function setregNoLength(regNo,PatientNoLength){
    if (regNo != '') 
    {
        if (regNo.length < Number(PatientNoLength)) 
        {
            for (var i=(Number(PatientNoLength)-regNo.length-1); i>=0; i--)
            {
                regNo ="0"+ regNo;
            }
        }
    }
    $("#regNoSearch").searchbox('setValue', regNo);
    return regNo;
}

//查询操作调用
function setQuery() {
    var tregNo = $("#regNoSearch").searchbox('getValue');
    var tname = $("#nameSearch").searchbox('getValue');
    var tcardNo = $("#cardNoSearch").searchbox('getValue');
    if (('' != tregNo)||('' != tname)||('' != tcardNo)) {
        if (sysOption.PatientNoLength != "N") {
            tregNo = setregNoLength(tregNo,sysOption.PatientNoLength);
        }
        var patStatus = setSearchOptions(tregNo, tname, tcardNo);
        if (patStatus != "") {
            return showEditorMsg(patStatus, 'alert');
        }else {
            tregNo = $("#regNoSearch").searchbox('getValue');
            tname = $("#nameSearch").searchbox('getValue');
            tcardNo = $("#cardNoSearch").searchbox('getValue');
        }
    }

    var expectedLocId = $('#cbxLoc').combobox('getValue');
    var startDate = $('#startDate').datebox('getText');
    var endDate = $('#endDate').datebox('getText');
    //IE11中，利用下拉框中的“叉号”去掉下拉框内容时，实际上下拉框的值没有去掉，所以查询时需要手动根据下拉框的文本内容判断一下下拉框的值是否应该为空；
    var expectedLocText = $('#cbxLoc').combobox('getText');
    if (expectedLocText == "" || expectedLocText == "undefinded") {
        expectedLocId = "";
    }

    var data = ajaxDATA('Stream', 'EMRservice.BL.opInterface', 'GetOPPatList', tregNo, tname, tcardNo, expectedLocId, startDate, endDate);
    ajaxGET(data, function (ret) {
        if ('' != ret) {
            var patData = $.parseJSON(ret);
            $('#patientListData').datagrid('loadData', patData);
        }else {
            $('#patientListData').datagrid('loadData', {total:0,rows:[]});
        }
    }, function (err) {
        alert('GetOPPatList error:' + err);
    });
}

// 查询
$("#PatientListQuery").click(function () {
    setQuery();
});

function setSysMenuDoingSth(sthmsg) {
    if ('undefined' != typeof dhcsys_getmenuform) {
        if ('undefined' != typeof dhcsys_getmenuform()) {
            var DoingSth = dhcsys_getmenuform().DoingSth || '';
            if ('' != DoingSth)
                DoingSth.value = sthmsg || '';
        }
    }
}

function getSysMenuDoingSth() {
    if ('undefined' != typeof dhcsys_getmenuform) {
        if ('undefined' != typeof dhcsys_getmenuform()) {
            var DoingSth = dhcsys_getmenuform().DoingSth || '';
            if ('' != DoingSth)
                return DoingSth.value || '';
        }
    }
    return '';
}

var intervalidHideMsg;
function showEditorMsg(msg, msgType) {
    if (isExistVar(msg)) {
        clearInterval(intervalidHideMsg);
        var millisec = 3000;
        if (isExistVar(msgType)) {
            millisec = sysOption.messageScheme[msgType];
        }

        $('#msgtd').html('');
        if (msgType === 'alert') {
            $('#msgtd').css('background-color', '#E7F0FF');
        } else if (msgType === 'warning') {
            $('#msgtd').css('background-color', '##008B8B');
        } else if (msgType === 'forbid') {
            $('#msgtd').css('background-color', 'red');
        } else {
            $('#msgtd').css('background-color', '#E7F0FF');
        }
        $('#msgtd').append(msg);
        $('#msgTable').show();
        intervalidHideMsg = setInterval("$('#msgTable').hide();", millisec);
    }
}

function Dateformatter(date)
{
    var y = date.getFullYear();
    var m = date.getMonth()+1;
    var d = date.getDate();
    return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function Dateparser(s)
{
    if (!s) return new Date();
    var ss = s.split('-');
    var y = parseInt(ss[0],10);
    var m = parseInt(ss[1],10);
    var d = parseInt(ss[2],10);
    if (!isNaN(y) && !isNaN(m) && !isNaN(d))
    {
        return new Date(y,m-1,d);
    } else {
        return new Date();
    }
}
