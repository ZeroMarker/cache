//页面加载 
$(function() {
    patInfo.IPAddress = getIpAddress();
    $('#patLst').panel('resize', {
        width: (screen.availWidth) * 0.382
    });
    $('body').layout('resize');
    //设置时间
    $('#startDate').datebox('setValue',myformatter(setDate(6)));
    $('#endDate').datebox('setValue',myformatter(setDate(0)));
    $('#startDate').datebox({  
        formatter: function(date){
            var y = date.getFullYear();
            var m = date.getMonth()+1;
            var d = date.getDate();
            return y + '-' + (m < 10 ? ('0' + m) : m) + '-'
            + (d < 10 ? ('0' + d) : d);
        }  
    });
    $('#endDate').datebox({
        formatter: function(date){
            var y = date.getFullYear();
            var m = date.getMonth()+1;
            var d = date.getDate();
            return y + '-' + (m < 10 ? ('0' + m) : m) + '-'
            + (d < 10 ? ('0' + d) : d);
        }
    });
    
    $('.easyui-searchbox').searchbox({
        searcher: function (value, name) {			
            var regNo = $("#regNoSearch").searchbox('getValue');
            var name = $("#nameSearch").searchbox('getValue');
            var cardNo = $("#cardNoSearch").searchbox('getValue');
            setQuery(regNo, name, cardNo);
        },
        prompt: '请输入...'
    });
    
    $('#readCard').live('click', function () {
        $('#cardNoSearch').searchbox('textbox').focus();;
        //调用读卡接口获取患者信息,入参为设备类型
        var rtn = DHCACC_ReadMagCard("2");
        var myary=rtn.split("^");
        if ("0" == myary[0]) {
            setSearchOptions('','',myary[1]);
            setQuery('','',myary[1]);
        }else {
            alert("读卡失败!");
        }
    });
    /*$('#reset').live('click', function () {
        setQuery('','','');
    });*/
    
    initPatTable();
    initPnlButton();
    //处理编辑器
    $('#editorFrame').attr('src', 'emr.op.editor.csp');
    
    //禁止后退键
    document.onkeypress = forbidBackSpace;
    document.onkeydown = forbidBackSpace;
    
    //todo
    data = ajaxDATA('String', 'EMRservice.BL.opPrintSearch', 'GetOPPatPrintList', '', '', '', '', '');
    ajaxGET(data, function (ret) {
        if ('' != ret) {
            var patData = $.parseJSON(ret);
            $('#patientPrintListData').datagrid('loadData', patData);
        }
    
    }, function (err) {
        alert('GetOPPatPrintList error:' + err);
    });
    //审核日志
    if (!hisLog) {
        hisLog = new HisLogEx(sysOption.IsSetToLog, patInfo);
    }
});

//  emr.op.editor.csp invoke
function initEditor() {
    emrEditor.newEmrPlugin();
    emrEditor.initDocument();
}
// 更新病历页面内容
function switchEMRContent(_patientID, _episodeID, _mradm) {
    if (_episodeID == patInfo.EpisodeID) return;
    //全局参数替换
    patInfo.PatientID = _patientID;
    patInfo.EpisodeID = _episodeID;
    patInfo.MRadm = _mradm;
    
    common.getSavedRecords(function (ret) {
        envVar.savedRecords = $.parseJSON(ret);
        emrEditor.initDocument(false);
        var id = envVar.opEmrButtons.split(':')[0];
        if (0 == envVar.savedRecords) {
            $('#'+id).attr('disabled', true);
            emrEditor.cleanDoc();
            showEditorMsg("本次就诊无电子病历记录！", 'warning');
        } else {
            $('#'+id).attr('disabled', false);
        }     
    });
}
function initPatTable() {
    $('#patientPrintListData').datagrid({
        width: '100%',
        height: '100%',
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
                    width: 80,
                    hidden: true
                }, {
                    field: 'EpisodeID',
                    title: 'EpisodeID',
                    width: 80,
                    hidden: true
                }, {
                    field: 'mradm',
                    title: 'mradm',
                    width: 80,
                    hidden: true
                },/* {
                    field: 'ck',
                    checkbox:true
                }, */{
                    field: 'PAPMIName',
                    title: '姓名',
                    width: 60,
                    sortable: true
                },/* {
                    field: 'PAPMISex',
                    title: '性别',
                    width: 40,
                    sortable: true
                }, {
                    field: 'PAPMIAge',
                    title: '年龄',
                    width: 40,
                    sortable: true
                }, */{
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
        view: detailview,
        detailFormatter: function(rowIndex, rowData){
            //是否有书写门诊病历
            if (rowData.Flag == "Y"){
                var printDesc='';
                $.each(rowData.Children,function(idx,val){
                    var desc="";
                    if (val.PrintedStatus== "已打印"){
                        desc='<p id="'+val.InstanceId+'" style="background-color:#A4D3EE;color:red;">'+val.Text+
                             '已打印|打印日期: '+val.PrintDate+'|打印时间: '+val.PrintTime+
                             '|'+val.PrintIp+'|打印者: '+val.PrintUserName+'</p>';
                    }else{
                        desc='<p id="'+val.InstanceId+'">'+val.Text+'未打印</p>';
                    }
                    printDesc=printDesc+'<tr><td style="border:0">'+desc+'</td></tr>';
                });
                return '<div style="padding:2px"><table id="Sub-'+rowIndex+'">'+printDesc+'</table></div>';
            }
        },
        onExpandRow: function(index,row){
            //是否有书写门诊病历
            if (row.Flag == "Y"){
                $('#patientPrintListData').datagrid('fixDetailRowHeight',index);
            }else{
                $('#patientPrintListData').datagrid('collapseRow',index);
            }
        },
        onDblClickRow: function () {
            var seleRow = $('#patientPrintListData').datagrid('getSelected');
            if (seleRow) {
                switchEMRContent(seleRow.PatientID, seleRow.EpisodeID, seleRow.mradm);
            }
        },
        onLoadSuccess: function(data){
            $.each(data.rows,function(idx,val){
                if (val.Flag == "Y"){
                    $('#patientPrintListData').datagrid('expandRow',idx);
                }
            });
        }
    });
}

//默认获取当前日期范围（七天）
function setDate(n){
    var now = new Date;
    now.setDate(now.getDate() - n);
    return now;
}

function myformatter(date) {
    var y = date.getFullYear();
    var m = date.getMonth() + 1;
    var d = date.getDate();

    return y + '-' + (m < 10 ? ('0' + m) : m) + '-'
            + (d < 10 ? ('0' + d) : d);
}

///Desc:设置登记号长度
function setLength(regNo){
    if (regNo != '') 
    {
        if (regNo.length < 10) 
        {
            for (var i=(10-regNo.length-1); i>=0; i--)
            {
                regNo ="0"+ regNo;
            }
        }
    }
    return regNo;
}

// 设置门诊页面只读与否 传入 true/false 默认为 false
function setReadonly(flag) {
    envVar.readonly = flag || false;
}

function isReadonly() {
    return envVar.readonly;
}

function setSysMenuDoingSth(sthmsg) {
    if ('undefined' != typeof dhcsys_getmenuform) {
        var DoingSth = dhcsys_getmenuform().DoingSth || '';
        if ('' != DoingSth)
            DoingSth.value = sthmsg || '';;
    }
}

function getSysMenuDoingSth() {
    if ('undefined' != typeof dhcsys_getmenuform) {
        var DoingSth = dhcsys_getmenuform().DoingSth || '';
        if ('' != DoingSth)
            return DoingSth.value || '';
    }

    return '';
}

//查询条件
function setSearchOptions(regNo, name, cardNo){
    $("#regNoSearch").searchbox('setValue', regNo);
    $("#nameSearch").searchbox('setValue', name);
    $("#cardNoSearch").searchbox('setValue', cardNo);
}

//查询操作调用
function setQuery(regNo, name, cardNo){
    var startDate = $('#startDate').datebox('getText');
    var endDate = $('#endDate').datebox('getText');
    
    var data = ajaxDATA('String', 'EMRservice.BL.opPrintSearch', 'GetOPPatPrintList', regNo, name, cardNo, startDate, endDate);
    ajaxGET(data, function (ret) {
        if ('' != ret) {
            var patData = $.parseJSON(ret);
            $('#patientPrintListData').datagrid('loadData', patData);
        }else {
            $('#patientPrintListData').datagrid('loadData', {total:0,rows:[]});
        }
    }, function (err) {
        alert('GetOPPatPrintList error:' + err);
    });
}


//以下方法只为兼容书写界面程序
//隐藏进度条
function hideLoadingWinFun() {
}

//显示进度条
function loadingwinshow() {
}
