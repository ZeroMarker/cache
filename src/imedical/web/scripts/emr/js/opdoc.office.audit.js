$(function () {
    initPatTable();
    $('#patientListData').datagrid('loadData', {total:0,rows:[]});
    $('.hisui-searchbox').searchbox({
        searcher: function (value, name) {
            var regNo = $("#regNoSearch").searchbox('getValue');
            var name = $("#nameSearch").searchbox('getValue');
            var cardNo = $("#cardNoSearch").searchbox('getValue');
            setQuery(regNo, name, cardNo);
        },
        prompt: emrTrans('请输入')
    });
    initPnlButton();
    //处理编辑器
    $('#editorFrame').attr('src', 'emr.opdoc.editor.csp');

    //禁止后退键
    document.onkeypress = forbidBackSpace;
    document.onkeydown = forbidBackSpace;

    //审核日志
    if (!hisLog) {
        hisLog = new HisLogEx(sysOption.IsSetToLog, patInfo);
    }
    //如果未配置诊断证明模板 增加系统提示
    if(sysOption.DiagnoseProofDocID==""){
	    alert("未找到配置模板，请到维护程序中确认！");
	}
});

//  emr.opdoc.editor.csp invoke
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
//初始化诊断证明书完成情况表
function initPatTable() {
    $('#patientListData').datagrid({
        width: '100%',
        height: '100%',
        border:0,
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
            switchEMRContent(rowData);
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
    //锁定按钮
    $('#btnOpOfficeAudit').linkbutton('disable');
    $('#btnOpOfficePDFPrev').linkbutton('disable');
    $('#btnOpOfficePDFPrint').linkbutton('disable');
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
            if (rowData.Status == "完成") {
                //刷新病历后解锁按钮
                $('#btnOpOfficeAudit').linkbutton('enable');
            	$('#btnOpOfficePDFPrev').linkbutton('enable');
            	$('#btnOpOfficePDFPrint').linkbutton('enable');
            }
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
            $("#regNoSearch").searchbox('setValue', patInfoData[0].RegNo);
            $("#nameSearch").searchbox('setValue', patInfoData[0].PatName);
            $("#cardNoSearch").searchbox('setValue', patInfoData[0].CardNo);
        }else {
            patStatus = "未找到指定患者,请重新输入查询条件!";
            //if ("" === regNo) $("#regNoSearch").searchbox('setValue', '');
            //if ("" === name) $("#nameSearch").searchbox('setValue', '');
            //if ("" === cardNo) $("#cardNoSearch").searchbox('setValue', '');
            $("#regNoSearch").searchbox('setValue', regNo);
            $("#nameSearch").searchbox('setValue', name);
            $("#cardNoSearch").searchbox('setValue', cardNo);
        }
    }, function (err) {
        alert('GetOPPatInfo error:' + err);
    });
    return patStatus;
}

//补0方法 默认不满10位的补0
function setArgsLength(arg,PatientNoLength){
    if (arg != '') 
    {
        if (arg.length < Number(PatientNoLength)) 
        {
            for (var i=(Number(PatientNoLength)-arg.length-1); i>=0; i--)
            {
                arg ="0"+ arg;
            }
        }
    }
    return arg;
}

//查询操作调用
function setQuery(regNo, name, cardNo) {
    if (sysOption.PatientNoLength != "N") {
       //登记号
       regNo = setArgsLength(regNo,sysOption.PatientNoLength);
       //就诊卡号
       cardNo = setArgsLength(cardNo,sysOption.PatientNoLength);    
    }
    var patStatus = setSearchOptions(regNo, name, cardNo);

     if (patStatus != "") {
        return showEditorMsg(patStatus, 'alert');
    }

    var tregNo = $("#regNoSearch").searchbox('getValue');
    var tname = $("#nameSearch").searchbox('getValue');
    var tcardNo = $("#cardNoSearch").searchbox('getValue');

    var data = ajaxDATA('Stream', 'EMRservice.BL.opInterface', 'GetOPPatList', tregNo, tname, tcardNo);
    ajaxGET(data, function (ret) {
        if ('' != ret) {
            var patData = $.parseJSON(ret);
            //每条数据只显示第一条诊断数据
            for(var i = 0;i<patData.rows.length;i++){
	            var diagnose = patData.rows[i].Diagnosis
	            if (diagnose.indexOf(",")!=-1){
		        	patData.rows[i].Diagnosis = diagnose.substring(0,diagnose.indexOf(","))	
		        }	 
	        }
            $('#patientListData').datagrid('loadData', patData);
        }else {
            $('#patientListData').datagrid('loadData', {total:0,rows:[]});
        }
    }, function (err) {
        alert('GetOPPatList error:' + err);
    });
}

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
