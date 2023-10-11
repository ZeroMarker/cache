/**
 * @description: 质控主界面
 * @author: ouzilin
 * @date: 2020-04-29 10:28:20
*/
var GV = {
    currentCTLOCID: session['LOGON.CTLOCID'],
    currentUSERID: session['LOGON.USERID'],
    currentUSERNAME: session['LOGON.USERNAME'],
    currentGROUPID: session['LOGON.GROUPID'],
    currentWARDID: (session['LOGON.WARDID'] == undefined) ? "" : session['LOGON.WARDID'],
    currentHOSPID: session['LOGON.HOSPID'],
    tableName: "Nur_IP_Quality.WorkFlowConfig",
    editIndex: undefined,
    roles: "",  //当前用户的权限角色
    statusList: { 'all': $g("全部") }, // 状态
    buttonList: [], // 按钮
    statusConfigList: [],   // 状态
    hiddenAppraise: "", //是否屏蔽评价功能
    hiddenNote: "",  //是否屏蔽备注功能
    statusColor: {}, // 状态对应的颜色代码
    nurseList: []
}
/**
* @description: 初始化状态checkbox
*/
function initStatus() {
    GV.statusConfigList = $cm({
        ClassName: "Nur.Quality.Service.WorkflowConfig",
        MethodName: "getStatusList",
        User: GV.currentUSERID,
        Group: GV.currentGROUPID,
        Loc: GV.currentCTLOCID,
        Hosp: GV.currentHOSPID
    }, false);

    for (var i = 0, length = GV.statusConfigList.length; i < length; i++) {
        var single = GV.statusConfigList[i]
        if ((single.code).indexOf('@') > -1) continue
        GV.statusList[single.code] = single.desc
    }
    var needAddplace = $('.nur_checkbox li')
    for (var item in GV.statusList) {
        needAddplace.append(
            '<input  id="' + item + '"  class="hisui-checkbox" type="checkbox" checked="true" label="' + GV.statusList[item] + '">'
        )
    }
}

initStatus()

$(function () {
    initUI()
})

function initUI() {
    initBeforeLoad();   //加载前初始化
    initAppraiseNote();  //根据配置隐藏或显示功能
    initSearchForm();   //初始化查询条件
    initGrid();         //初始化数据表格
    initAuditDetail(); //初始化 点击状态明细的窗口
    initEmrShowAndHandler(); //初始化 点击文书名称后的窗口
}
/**
* @description: 加载前初始化
*/
function initBeforeLoad() {
    GV.buttonList = $cm({
        ClassName: "Nur.Quality.Service.WorkflowConfig",
        MethodName: "getButtonList",
        User: GV.currentUSERID,
        Group: GV.currentGROUPID,
        Loc: GV.currentCTLOCID,
        Hosp: GV.currentHOSPID
    }, false);

    for (var f = 0, length = GV.buttonList.length; f < length; f++) {
        var single = GV.buttonList[f]
        if ((single.code).indexOf('@') > -1) continue
        if (GV.roles == "") GV.roles = single.code
        else GV.roles = (GV.roles + "^" + single.code)
    }

    GV.hiddenAppraise = $cm({
        ClassName: "Nur.Quality.Service.WorkflowConfig",
        MethodName: "getSingleConfig",
        code: "appraise",
        HospId: GV.currentHOSPID
    }, false);

    GV.hiddenNote = $cm({
        ClassName: "Nur.Quality.Service.WorkflowConfig",
        MethodName: "getSingleConfig",
        code: "note",
        HospId: GV.currentHOSPID
    }, false);

    GV.statusColor = $cm({
        ClassName: "Nur.Quality.Service.WorkflowConfig",
        MethodName: "getAllStatusColor",
        HospId: GV.currentHOSPID
    }, false);
}
/**
* @description:根据配置隐藏或显示功能
*/
function initAppraiseNote() {
    if (GV.hiddenNote) {
        $("#emrNotesBtn").css("visibility", "hidden")

    }
    if (GV.hiddenAppraise) {
        $("#emrAppraiseBtn").css("visibility", "hidden")
        $('#emrAndAppraiseList').tabs("close", 1)
    }
}
/**
* @description: 初始化查询条件
*/
function initSearchForm() {
    function filter(q, row) {
        var opts = $(this).combobox('options');
        var text = row[opts.textField];
        var pyjp = getPinyin(text).toLowerCase();
        if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
            return true;
        }
        return false;
    }
    /**科室 */
    $('#inputWardID').combobox({
        disabled: (GV.currentWARDID != "" ? true : false),
        valueField: 'ID',
        textField: 'desc',
        url: LINK_CSP + '?className=Nur.Quality.Service.Comm&methodName=getLocs&parameter1=W&parameter2=' + GV.currentHOSPID + "&parameter3=" + GV.tableName,
        filter: filter,
        onLoadSuccess: function (params) {
            if (GV.currentWARDID != "") {
                $(this).combobox('setValue', session['LOGON.CTLOCID'])
            }
        }
    })

    /**开关 */
    $HUI.switchbox('#patSwitch', {
        onText: $g('在院病历'),
        offText: $g('转科/出院病历'),
        size: 'small',
        animated: true,
        onClass: 'primary',
        offClass: 'gray',
        style: { height: '30px' },
        onSwitchChange: function (event, obj) {
            if (obj.value) {
                $("#dateInput").css("display", "none")
            } else {
                $("#dateInput").css("display", "")
            }
            searchBtn()
        },
    })

    $("#dateInput").css("display", "none")
    /**出院时间 */
    $('#inputOutHopStartDate').datebox('setValue', (new Date()).Format("yyyy-MM-dd"))
    $('#inputOutHopEndDate').datebox('setValue', (new Date()).Format("yyyy-MM-dd"))

    /**关键字 */
    $('#inputMainSelect').combobox({
        valueField: 'value',
        textField: 'label',
        data: [{
            label: $g('登记号'),
            value: 'regNo'
        }, {
            label: $g('床号'),
            value: 'bedCode'
        }, {
            label: $g('患者姓名'),
            value: 'name'
        }, {
            label: $g('病历等级'),
            value: 'recGrade'
        }]
    })

    $('#inputMainInput').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            searchBtn();
        }
    });

    /**查询 */
    $('#searchBtn').on('click', function () {
        searchBtn()
    })

    /**导出 */
    $('#exportBtn').on('click', function () {
        exportBtn()
    })

    $HUI.checkbox("#all", {
        onCheckChange: function (e, value) {
            allCheckBoxClick(value)
            /*
            if (value)
            {
                allCheckBoxClick(value)
            }
            */
        }
    })

    /*
    for (var item in GV.statusList)
    {
        (function(item){
            if (item != "all")
            {
                $HUI.checkbox('#' + item, {
                    onCheckChange: function(e, value){
                        otherBoxClick(value)
                    }
                })
            }
        }
        )(item)
    }
    */
}

/**
* @description: 表格
*/
function initGrid() {
    /*获取配置的列*/
    var configColumns = $cm({
        ClassName: "Nur.Quality.Service.AuditPageColumn",
        MethodName: "getConfig",
        HospId: GV.currentHOSPID
    }, false);

    var columns = [
        { field: 'ck', checkbox: true },
        {
            field: 'status', title: $g('状态'), width: 110, align: 'center',
            styler: function (value, row, index) {
                return 'background-color:' + GV.statusColor[value];
            },
            formatter: function(data)
            {
	            return $g(data)
	        }
        },
        { field: 'statusDetail', title: $g('状态明细'), width: 70, formatter: showImg, align: 'center' }
    ]
    columns = columns.concat(configColumns)

    columns = columns.concat([{ field: 'recDesc', title: $g('文书名称'), width: 240, align: 'center', formatter: showRecDesc },
    { field: 'evaluation', title: $g('评价结果'), width: 80, align: 'center', formatter: showEvalution, hidden: (GV.hiddenAppraise ? true : false) },
    { field: 'recGrade', title: $g('病历等级'), width: 80, align: 'center', formatter: showGrade, hidden: (GV.hiddenAppraise ? true : false) },
    { field: 'auditMainID', title: 'ID', width: 80, align: 'center', hidden: true },
    { field: 'episodeID', title: 'episodeID', width: 80, align: 'center', hidden: true }])

    var toolbar = []
    for (var i = 0, length = GV.buttonList.length; i < length; i++) {
        var single = GV.buttonList[i];
        (function (single) {
            toolbar.push({
                iconCls: (single.code.indexOf("@") > -1) ? 'icon-back' : 'icon-ok',
                text: single.desc,
                handler: function () {
                    changeStatus(single.code)
                }
            })
        })(single)
    }

    $('#patEmrDataListTable').datagrid({
        url: $URL,
        queryParams: {
            ClassName: 'Nur.Quality.Service.Audit',
            QueryName: 'getAuditRec',
            WardID: GV.currentCTLOCID,
            Type: "I",
            MainSelect: $('#inputMainSelect').combobox('getValue'),
            MainInput: $('#inputMainInput').val(),
            Status: getAllChecked(),
            StartDate: $('#inputOutHopStartDate').datebox('getValue'),
            EndDate: $('#inputOutHopEndDate').datebox('getValue'),
            Roles: GV.roles,
            HospId: GV.currentHOSPID
        },
        method: 'post',
        loadMsg: $g('数据装载中......'),
        nowrap: false,
        striped: true,
        //fitColumns: true,
        autoRowHeight: true,
        singleSelect: false,
        showHeader: true,
        columns: [columns],
        pagination: true,
        pageSize: 10,
        pageList: [10, 20, 50, 200],
        pagePosition: 'bottom',
        toolbar: toolbar
        // onClickCell: function(rowIndex, field, value){
        //     if (field == "recDesc")
        //     {
        //         var rows = $(this).datagrid('getRows')
        //         var currentRow = rows[rowIndex]
        //         initEmrAndAppraiseList()
        //         getEmrList(currentRow['episodeID']) //获取文书列表
        //         getAppraiseList("55") //获取评价列表 就诊号、主表ID
        //         $('#showAndAppraiseEmr').window('open')
        //     }
        // }
    })
}
/**
* @description:初始化点击状态明细的窗口
*/
function initAuditDetail() {
    $('#auditDetailsWin').window({
        width: 620,
        height: 500,
        modal: true,
        closed: true,
        collapsible: false,
        minimizable: false,
        maximizable: false,
        closable: true,
        title: $g('审核明细'),
        iconCls: 'icon-w-paper'
    })
}

/**
* @description: 初始化 点击文书名称后的窗口
*/
function initEmrShowAndHandler() {
    $('#showAndAppraiseEmr').window({
        width: 1400,
        height: 800,
        modal: true,
        closed: true,
        collapsible: false,
        minimizable: false,
        maximizable: false,
        closable: true,
        title: $g('护理文书'),
        iconCls: 'icon-w-paper'
    })
    //备注按钮
    $('#emrNotesBtn').on('click', function () {
        clickBtnEvent('emrNotesBtn')
    })
    //评价按钮
    $('#emrAppraiseBtn').on('click', function () {
        clickBtnEvent('emrAppraiseBtn')
    })
    //切换tab
    $('#emrAndAppraiseList').tabs({
        onSelect: function (title, index) {
            if (index == 0) {
                $('#emrAndAppraiseDetails').removeAttr("hidden")
                $('#showAppraiseDetails').attr("hidden", "true")
                $('#showEmrScoreList').html("")
                hiddenBtnAndNotes()
            } else {
                $('#emrAndAppraiseDetails').attr("hidden", "true")
                $('#showAppraiseDetails').removeAttr("hidden")
                $('#inputEmrScoreList').html("")
                $('#appraiseListTable').datagrid('reload');
                hiddenBtnAndNotes()
            }
        }
    })

    initShowInputEmrNote(); //初始化 点击护理文书窗口上面的备注按钮 初始化备注弹框
    initShowInputEmrScore(); //初始化 点击护理文书窗口上面的评价按钮 初始化评价弹框
}
/**初始化备注模块*/
function initShowInputEmrNote() {

    function filter(q, row) {
        var opts = $(this).combobox('options');
        var text = row[opts.textField];
        var pyjp = getPinyin(text).toLowerCase();
        if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
            return true;
        }
        return false;
    }
    $('#showInputEmrNote').window({
        width: 800,
        height: 400,
        modal: false,
        closed: true,
        collapsible: false,
        minimizable: false,
        maximizable: false,
        closable: true,
        title: $g('备注')
    })

    $('#showInputEmrNote').window({
        "onClose": function () {
            $('#emrTree').tree("reload")
        }
    })

    $('#searchNoteBtn').on('click', function () {
        clickBtnEvent('searchNoteBtn')
    })
    $('#inputEmrNoteTable').datagrid({
        url: $URL,
        queryParams: {
            ClassName: 'Nur.Quality.Service.Audit',
            QueryName: 'getAuditNoteRec',
            AuditMainID: "",
            StartDate: "",
            EndData: ""
        },
        method: 'post',
        loadMsg: $g('数据装载中......'),
        striped: true,
        fitColumns: true,
        autoRowHeight: true,
        singleSelect: true,
        rownumbers: true,
        showHeader: true,
        nowrap: false,
        columns: [[
            { field: 'content', title: '备注内容', width: 280, editor: { type: 'textarea' } },
            { field: 'addUser', title: '备注人', width: 70, align: 'center' },
            { field: 'addDateTime', title: '备注日期', width: 180, align: 'center' },
            {
                field: 'responsible', title: '责任人', width: 180, align: 'center',
                formatter: function (value, row, index) {
                    var targetArr = GV.nurseList
                    if (value == undefined) {
                        return value;
                    } else {
                        var tmpVal = value.toString().split(",")
                        var resault = [];
                        for (var i = 0; i < targetArr.length; i++) {
                            tmpVal.forEach(function (item) {
                                if (parseInt(targetArr[i].Id) == parseInt(item)) {
                                    resault.push(targetArr[i].Desc)
                                }
                            })
                        }
                        return resault.join(",");
                    }
                },
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'Id',
                        textField: 'Desc',
                        data: GV.nurseList,
                        multiple: true,
                        filter: filter
                    }
                }
            },
            {
                field: 'ifAdajust', title: '是否调整', width: 80, align: 'center', editor: 'text',
                formatter: function (value) {
                    if (value == 0) {
                        return $g("否")
                    } else {
                        return $g("是")
                    }
                },
                editor: {
                    type: 'checkbox',
                    options: {
                        on: "1",
                        off: "0",
                    }
                }
            },
            { field: 'adajustUser', title: '调整人', width: 70, align: 'center' },
            { field: 'adajustDateTime', title: '调整日期', width: 180, align: 'center' },
            { field: 'auditMainNoteSubID', title: 'ID', width: 70, align: 'center' }
        ]],
        pagination: true,
        pageSize: 20,
        pageList: [10, 20, 50],
        pagePosition: 'bottom',
        toolbar: [{
            iconCls: 'icon-add',
            text: $g('新增'),
            handler: function () {
                $('#inputEmrNoteTable').datagrid("rejectChanges");
                $('#inputEmrNoteTable').datagrid("unselectAll");
                $('#inputEmrNoteTable').datagrid('insertRow', {
                    index: 0,	// index start with 0
                    row: {
                        addUser: GV.currentUSERNAME
                    }
                });
                GV.editIndex = 0
                $('#inputEmrNoteTable').datagrid('beginEdit', 0)
            }
        }, {
            iconCls: 'icon-cancel',
            text: $g('删除'),
            handler: function () {
                emrNoteHandler('delete')
            }
        }, {
            iconCls: 'icon-save',
            text: $g('保存'),
            handler: function () {
                emrNoteHandler('save')
            }
        }
        ],
        onDblClickRow: function (rowIndex, rowData) {
            $('#inputEmrNoteTable').datagrid("rejectChanges");
            $('#inputEmrNoteTable').datagrid("unselectAll");
            $('#inputEmrNoteTable').datagrid("selectRow", rowIndex)
            $('#inputEmrNoteTable').datagrid("beginEdit", rowIndex);
            GV.editIndex = rowIndex
            // if (endEdit())
            // {
            //     GV.editIndex=rowIndex
            //     $('#inputEmrNoteTable').datagrid("beginEdit", rowIndex);
            // }
        }
    })
}
/**
* @description: 初始化病历评分模块
*/
function initShowInputEmrScore() {
    $('#showInputEmrScore').window({
        width: 970,
        height: 650,
        modal: false,
        closed: true,
        collapsible: false,
        minimizable: false,
        maximizable: false,
        closable: true,
        title: $g('评价')
    })
}
/***********************点击状态明细************************** */
/**
 * 点击状态明细
 * @param {*} auditMainID 
 * @param {*} episodeID 
 */
function showEmrAuditDetails(auditMainID, episodeID) {
    getBannerPatInfo(episodeID)
    runClassMethod("Nur.Quality.Service.Audit", "getAuditMainDetails",
        {
            parameter1: JSON.stringify(eval(auditMainID))

        }, function (data) {
            data = eval(data)
            var details = data['details']
            var currentStatus = data['status']
            $('#selectEmrDesc').text($g(currentStatus['emrDesc']))
            $('#selectStatusInfo_status').text($g(currentStatus['status']))
            $('#selectStatusInfo_detaTime').text(currentStatus['Date'])
            $('.auditRecDetailsProcess').html('')
            for (var item in details) {
                var currentItem = details[item]
                var auditDateTime = currentItem['auditDateTime']
                var auditUser = currentItem['auditUser']
                var status = currentItem['status']
                var needHTML =
                    '<div class="processBar">' +
                    ((item == (details.length - 1)) ? '<div class="processStepSingle ' + ((item == 0) ? "processSelect" : "") + '"></div>' : '<div class="processLine ' + ((item == 0) ? "processLineSelect" : "") + '"><div class="processStep ' + ((item == 0) ? "processSelect" : "") + '"></div></div>') +
                    '<div class="processBarText">' +
                    '<div><span style="width: 100px;float: left;">' + $g(status) + '</span><span class="processBarTextDate">' + auditDateTime + $g('   操作人: ') + auditUser + '</span></div>' +
                    // '<div>审核意见:审核通过</div>' +
                    '</div>' +
                    '</div>'
                $('.auditRecDetailsProcess').append(needHTML)
            }
            $('#auditDetailsWin').window('open');
        })
}
/**
 * 获取状态明细窗口的头部患者信息
 * @param {*} episodeID 
 */
function getBannerPatInfo(episodeID) {
    runClassMethod("Nur.Quality.Service.Audit", "getBannerPatInfo", {
        parameter1: episodeID
    }, function (data) {
        var data = eval(data)
        var sex = data["sex"]
        if (sex == $g('男')) {
            $('#sex').removeClass('unman man woman').addClass('man');
        } else if (sex == $g('女')) {
            $('#sex').removeClass('unman man woman').addClass('woman');
        } else {
            $('#sex').removeClass('unman man woman').addClass('unman');
        }
        $('#regNo').text(data["regNo"]);
        $('#bedCode').text(data["bedCode"]);
        $('#patName').text(data["patName"]);
        $('#sex2').text(data["sex"]);
        $('#age').text(data["age"]);
    })
}
/************************************************* */

/***********************点击文书名称************************** */
/**
 * 点击文书名称
 * @param {*} episodeID  就诊号
 * @param {*} auditMainID  审核主表
 */
function clickRecDesc(episodeID, auditMainID) {
    getEmrList(episodeID, auditMainID) //获取文书列表
    getAppraiseList(auditMainID) //获取评价列表 就诊号、主表ID
    $('#emrAndAppraiseList').tabs("select", 0)  //默认选择列表页签
    hiddenBtnAndNotes()  //隐藏评分模块的按钮
    $('#showAndAppraiseEmr').window('open')
}
/**
 * 获取病人保存过的病历
 * @param {*} episodeID 
 */
function getEmrList(EpisodeID, auditMainID) {

    var tabs = $('#emrAndAppraiseDetails').tabs('tabs')
    for (var i = 0, tabLength = tabs.length; i < tabLength; i++) {
        $('#emrAndAppraiseDetails').tabs('close', 0)
    }

    $('#emrTree').tree({
        //url: '../web.eprajax.GivePower.cls?Action=tree&EpisodeID=' + episodeID,
        url: LINK_CSP + "?className=Nur.Quality.Service.Audit&methodName=getAuditEmrByEpisodeID&parameter1=" + EpisodeID + "&parameter2=" + $('#inputWardID').combobox('getValue') + "&parameter3=" + auditMainID,
        method: 'get',
        animate: true,
        onClick: openRecord,
        onLoadSuccess: function (node, data) {
            /*默认选中病历*/
            var rootNode = data[0]
            rootNode.children.forEach(function (single) {
                if ((single.checked) && ($('#emrAndAppraiseDetails').tabs('tabs').length == 0)) {
                    var node = $('#emrTree').tree('find', single.id);
                    $('#emrTree').tree('select', node.target);
                    openRecord(node)
                }
            })
        }

    });


    var currentTab = $('#emrAndAppraiseDetails').tabs('getSelected');
    if (currentTab != null) {
        setTimeout(function () {
            var iframe = $(currentTab.panel('options').content);
            var src = iframe.attr('src');
            var jsonUrl = serilizeURL(src);
            if (jsonUrl["EpisodeID"] != EpisodeID) {
                var tabUrl = jsonUrl["csp"] + "?EpisodeID=" + EpisodeID + "&EmrCode=" + jsonUrl["EmrCode"];
                var frameId = "iframetab" + jsonUrl["EmrCode"];
                var content = '<iframe id="' + frameId + '" scrolling="auto" width="100%" height="100%" frameborder="0" src="' + tabUrl + '"></iframe>';
                $('#emrAndAppraiseDetails').tabs('update', {
                    tab: currentTab,
                    options: {
                        content: content
                    }
                });
            }
        }, 200);
    }
}
/**
 * 初始化评价列表
 * @param {*} auditMainID 
 */
function getAppraiseList(auditMainID) {
    $('#appraiseListTable').datagrid({
        url: $URL,
        queryParams: {
            ClassName: 'Nur.Quality.Service.Audit',
            QueryName: 'getAppraiseList',
            AuditMainID: auditMainID
        },
        method: 'post',
        loadMsg: $g('数据装载中......'),
        striped: true,
        fitColumns: true,
        autoRowHeight: true,
        singleSelect: true,
        showHeader: true,
        nowrap: false,
        idField: 'appraiseID',
        columns: [[
            { field: 'appraiseScore', title: $g('评价结果'), width: 150, align: 'center' },
            { field: 'appraiseUser', title: $g('评价人'), width: 150, align: 'center' },
            { field: 'appraiseDateTime', title: $g('评价日期'), width: 230, align: 'center' },
            { field: 'appraiseID', title: 'ID', width: 30, hidden: true }
        ]],
        onClickRow: function (rowIndex, rowData) {
            $('#showAppraiseBtns').removeAttr("hidden")
            showEmrScoreDataList("", rowData['appraiseID'], "showEmrScoreList")
        }
    })
}

/**
 * 点击病历列表
 * @param {*} node
 */
function openRecord(node) {
    if (node.type == 'leaf') {
        var EpisodeID = $('#emrTree').tree('getParent', node.target).id
        if ((node.id == "TEMP") || (node.id == "ORDER")) {
            setEprMenuForm(EpisodeID,"","","");
            switch (node.id) {
                case "TEMP":
                    window.open("./nur.hisui.temperature.linux.csp?EpisodeID=" + EpisodeID, "tempWindow", "height=700, width=1386, top=30, left=30, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no");
                    break;
                case "ORDER":
                    window.open("./nur.hisui.ordersheet.csp?EpisodeID=" + EpisodeID, "tempWindow", "height=700, width=1386, top=30, left=30, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no");
                    //orderSheetWindow(EpisodeID)
                    break;
            }

        } else {
            $m({
                ClassName: "NurMp.NursingRecords",
                MethodName: "getCodeByGuid",
                Guid: node.id
            }, function (emrCode) {
                if ($('#emrAndAppraiseDetails').tabs('exists', node.text)) {
                    $('#emrAndAppraiseDetails').tabs('select', node.text);
                } else {
                    //var tabUrl = emrCode + ".csp?EpisodeID=" + EpisodeID + "&EmrCode=" + node.id;
                    //2.3.2版护理病历改了csp的名字
                    var tabUrl = "nur.emr." + emrCode.toLowerCase() + ".csp?EpisodeID=" + EpisodeID + "&EmrCode=" + node.id;
                    var frameId = "iframetab" + node.id;
                    var content = '<iframe id="' + frameId + '" scrolling="auto" width="100%" height="100%" frameborder="0" src="' + tabUrl + '"></iframe>';
                    $('#emrAndAppraiseDetails').tabs('add', {
                        title: node.text,
                        content: content,
                        fit: true,
                        closable: true,
                        episodeId: EpisodeID
                    });
                }
                // $HUI.window('#windowMore','close');
            });
        }
    }
}
/************************************************* */

/***********************事件定义************************** */
/**
* @description: 主界面查询按钮
*/
function searchBtn() {
    var queryParams = $('#patEmrDataListTable').datagrid('options').queryParams
    queryParams.WardID = $('#inputWardID').combobox('getValue')
    queryParams.Type = $HUI.switchbox('#patSwitch').getValue() ? "I" : "D"
    queryParams.MainSelect = $('#inputMainSelect').combobox('getValue')
    queryParams.MainInput = $('#inputMainInput').val()
    queryParams.Status = getAllChecked()
    queryParams.StartDate = $('#inputOutHopStartDate').datebox('getValue')
    queryParams.EndDate = $('#inputOutHopEndDate').datebox('getValue')
    queryParams.roles = GV.roles
    $('#patEmrDataListTable').datagrid('options').queryParams = queryParams;
    $('#patEmrDataListTable').datagrid('load');
    $(".datagrid-header-check").children().prop("checked", false);
}

/**
* @description: 主界面导出方法
*/
function exportBtn() {
    $('#patEmrDataListTable').datagrid('toExcel',
        {
            name: $g('导出的数据.xls'),
            parseDataFun: function (data) {
                debugger
                var data = $cm({
                    ClassName: 'Nur.Quality.Service.Audit',
                    QueryName: 'getAuditRec',
                    ResultSetType: "array",
                    WardID: $('#inputWardID').combobox('getValue'),
                    Type: $HUI.switchbox('#patSwitch').getValue() ? "I" : "D",
                    MainSelect: $('#inputMainSelect').combobox('getValue'),
                    MainInput: $('#inputMainInput').val(),
                    Status: getAllChecked(),
                    StartDate: $('#inputOutHopStartDate').datebox('getValue'),
                    EndDate: $('#inputOutHopEndDate').datebox('getValue'),
                    Roles: "",
                    exportFlag: "true",
                    HospId: GV.currentHOSPID
                }, false)
                debugger
                return data
            }
        })
    /*
    $cm({
        ClassName: 'Nur.Quality.Service.Audit',
        QueryName: 'getAuditRec',
        ResultSetType: "array",
        WardID: $('#inputWardID').combobox('getValue'),
        Type: $HUI.switchbox('#patSwitch').getValue() ? "I" : "D",
        MainSelect: $('#inputMainSelect').combobox('getValue'),
        MainInput: $('#inputMainInput').val(),
        Status: getAllChecked(),
        StartDate: $('#inputOutHopStartDate').datebox('getValue'),
        EndDate: $('#inputOutHopEndDate').datebox('getValue')
    },function(jsonData){
        var xls = new ActiveXObject ("Excel.Application");
        var xlBook = xls.Workbooks.Add;
        var xlSheet = xlBook.Worksheets(1);
    
        var cols = $('#patEmrDataListTable').datagrid('options').columns[0];
        var colCount = cols.length;
        debugger
    
        for(i=1;i <colCount-2;i++){ 
            xlSheet.Cells(1,i).value =cols[i].title.trim();
            xlSheet.Cells(1,i).Font.Bold = true;
            xlSheet.Cells(1,i).Font.Size = 12;
            xlSheet.Columns(i).ColumnWidth = 10; 
            xlSheet.Cells(1,i).Borders.Weight = 2; 
        }
        

        var row =  2;
        for (var i=0;i<jsonData.length;i++) {
            var column = 1;
            var recDesc = $.parseJSON(jsonData[i].recDesc)
            var rowSpans = recDesc.length
            var evaluation = $.parseJSON(jsonData[i].evaluation)
            var recGrade = $.parseJSON(jsonData[i].recGrade)
            // xlSheet.Range(xlSheet.cells(i+2,j+1),xlSheet.cells(i+2,maxCols)).Select(); //选择该列
            // ExApp.Selection.HorizontalAlignment = 3;                          //居中
            // ExApp.Selection.MergeCells = true;
           // "[{"colSpan":1,"score":97}]"
           
           
           for(var j=1;j <colCount-2;j++){ 
             
                var name = cols[j].field;
                var value = jsonData[i][name]
                
                if (value==undefined)
                {
                    xlSheet.Cells(row,column).Borders.Weight = 2;
                    continue
                }
                
                if ((name == "auditMainID")||(name == "episodeID")){
                   
                }
                else if (name == "recDesc")
                {
                    for (var recIndex in recDesc){
                        recIndex = parseInt(recIndex)
                        xlSheet.Cells(row + recIndex,column).value = recDesc[recIndex].recDesc.split("&nbsp")[0];
                        xlSheet.Cells(row + recIndex,column).Borders.Weight = 2; 
                    }
                }
                else if(name == "evaluation")
                {
                    var curRow = row
                    for(var evaIndex in evaluation){
                        evaIndex = parseInt(evaIndex)
                        var curRowSpans = evaluation[evaIndex].colSpan
                        var curScore = evaluation[evaIndex].score
                        xlSheet.Cells(curRow,column).value = curScore;
                        xlSheet.Cells(curRow,column).Borders.Weight = 2; 
                        if ( curRowSpans > 1 ){
                            xlSheet.Range(xlSheet.cells(curRow, column),xlSheet.cells(curRow + curRowSpans-1, column)).Select();
                            xls.Selection.MergeCells = true;
                            xls.Selection.Borders.Weight = 2;    
                        }
                        curRow += curRowSpans 
                    }
                }
                 else if(name == "recGrade")
                {
                    var curRow = row
                    for(var recGradeIndex in recGrade){
                        recGradeIndex = parseInt(recGradeIndex)
                        var curRowSpans = recGrade[recGradeIndex].colSpan
                        var curGrade = recGrade[recGradeIndex].grade
                        xlSheet.Cells(curRow,column).value = curGrade.split(">")[1].split("<")[0];
                        xlSheet.Cells(curRow,column).Borders.Weight = 2; 
                        if ( curRowSpans > 1 ){
                            xlSheet.Range(xlSheet.cells(curRow, column),xlSheet.cells(curRow + curRowSpans-1, column)).Select();
                            xls.Selection.MergeCells = true;
                            xls.Selection.Borders.Weight = 2;    
                        }
                        curRow += curRowSpans 
                    }
                }
                else
                {
                    xlSheet.Cells(row,column).NumberFormatLocal = "@"
                    xlSheet.Cells(row,column).value = value;
                    xlSheet.Cells(row,column).Borders.Weight = 2; 
                    if (rowSpans>1)
                    {
                        xlSheet.Range(xlSheet.cells(row, column),xlSheet.cells(row + rowSpans-1, column)).Select();
                        xls.Selection.MergeCells = true;
                        xls.Selection.Borders.Weight = 2;     
                    }
                }
                column++;
                
            	
            }
            row += rowSpans
        }
        var fname = xls.Application.GetSaveAsFilename("导出的xlsx", "Excel Spreadsheets (*.xlsx), *.xlsx"); 
        xlBook.SaveAs(fname); 
        xlBook.Close(); 
        xls.Quit();     
        xls=null;
        xlBook=null; 
        xlSheet=null;
    });
    */
}
/**
 * 点击主界面 提交 撤销提交 审核 撤销审核 驳回按钮
 * @param {*} StatusCode
 */
function changeStatus(StatusCode) {
    var record = $('#patEmrDataListTable').datagrid("getSelections");
    var auditMainIDList = []
    for (var i in record) {
        auditMainIDList.push(record[i]["auditMainID"])
    }

    if (auditMainIDList.length == 0) {
        $.messager.popover({ msg: $g('请选中一条'), type: 'error', timeout: 1000 });
        return
    }
    runClassMethod("Nur.Quality.Service.Audit", "changeStatus", {
        parameter1: JSON.stringify(auditMainIDList),
        parameter2: StatusCode,
        parameter3: GV.currentUSERID,
        parameter4: GV.currentHOSPID
    }, function (data) {
        if (data == 0) {
            $.messager.alert($g("提示"), $g("操作成功"), "success")
            searchBtn()
        } else {
            $.messager.alert($g("提示"), data, "error").window({ width: 450 });
            searchBtn()
        }
    }, "", false)

}
/**
 * 备注表格的操作按钮
 * @param {*} action  delete save
 */
function emrNoteHandler(action) {
    var selectedNote = $('#emrTree').tree('getSelected')
    if (selectedNote == null) {
        $.messager.popover({ msg: $g('请选择一条记录'), type: 'error', timeout: 1000 });
        return
    }
    var auditMainNoteID = "", auditMainID = "", content = "", ifAdajust = "", responsible = ""
    var auditMainID = selectedNote.auditMainID
    if (action != "delete") {
        var ed = $('#inputEmrNoteTable').datagrid('getEditor', { index: GV.editIndex, field: 'content' })
        if (ed == null) {
            $.messager.popover({ msg: $g('没有需要保存的数据'), type: 'error', timeout: 1000 });
            return
        }
        var content = $(ed.target).val();
        if ((content == "") || (content.trim() == "")) {
            $.messager.popover({ msg: $g('备注内容为空'), type: 'error', timeout: 1000 });
            return
        }
        var edAdajust = $('#inputEmrNoteTable').datagrid('getEditor', { index: GV.editIndex, field: 'ifAdajust' })
        var ifAdajust = ($(edAdajust.target).prop("checked") ? 1 : 0)
        var responsibleED = $('#inputEmrNoteTable').datagrid('getEditor', { index: GV.editIndex, field: 'responsible' })
        var responsible = $(responsibleED.target).combobox("getValues")
        var responsible = responsible.join(",")
    } else {
        var selectedNoteRec = $('#inputEmrNoteTable').datagrid('getSelected')
        if (selectedNoteRec == null) {
            $.messager.popover({ msg: $g('请选择一条记录'), type: 'error', timeout: 1000 });
            return
        }
    }
    var auditMainNoteSelected = $('#inputEmrNoteTable').datagrid('getSelected')
    if (auditMainNoteSelected != null) {
        auditMainNoteID = auditMainNoteSelected['auditMainNoteSubID']
    }
    runClassMethod("Nur.Quality.Service.Audit", "auditMainNoteSubHandler",
        {
            parameter1: auditMainID,
            parameter2: auditMainNoteID,
            parameter3: content,
            parameter4: ifAdajust,
            parameter5: GV.currentUSERID,
            parameter6: action,
            parameter7: responsible
        },
        function (data) {
            if (data == "0") {
                $.messager.popover({ msg: $g('操作成功'), type: 'success', timeout: 1000 });
                $('#inputEmrNoteTable').datagrid('reload');
            } else {
                $.messager.popover({ msg: $g('操作失败'), type: 'error', timeout: 1000 });
            }
        })
}


function clickBtnEvent(id) {
    switch (id) {
        case 'emrNotesBtn':
            //点击护理文书弹框上的备注按钮
            emrNotesBtn()
            break;
        case 'emrAppraiseBtn':
            //点击护理文书弹框上的评价按钮
            emrAppraiseBtn()
            break;
        case 'searchNoteBtn':
            //点击备注窗口的查询
            emrNoteSearchBtn()
            break;
    }
}
/**
* @description:点击护理文书弹框上的备注按钮
*/
function emrNotesBtn() {
    var selectedNote = $('#emrTree').tree('getSelected')
    if (selectedNote == null) {
        $.messager.popover({ msg: $g('请选择一个病历'), type: 'error', timeout: 1000 });
        return
    }
    $('#inputEmtNoteStartDate').datebox('setValue', ""),
        $('#inputEmtNoteEndDate').datebox('setValue', ""),
        emrNoteSearchBtn()
    $('#showInputEmrNote').window('open')
}
/**
* @description: 点击护理文书弹框上的评价按钮
*/
function emrAppraiseBtn() {
    var selectedNote = $('#emrTree').tree('getSelected')
    if (selectedNote == null) {
        $.messager.popover({ msg: $g('请选择一个病历'), type: 'error', timeout: 1000 });
        return
    }
    var auditMainID = selectedNote.auditMainID
    showEmrScoreDataList(auditMainID, "", "inputEmrScoreList")
    $('#showInputEmrScore').window('open')
}
/**
* @description: 获取评分表信息
*/
function showEmrScoreDataList(auditMainID, appraiseID, divID) {
    runClassMethod("Nur.Quality.Service.Audit", "getCheckItems",
        {
            parameter1: auditMainID,
            parameter2: appraiseID,
            parameter3: $('#inputWardID').combobox('getValue')
        }, function (data) {
            if (data.appraiseInfo == undefined) {
                $.messager.popover({ msg: $g('没有维护要评价的模板！'), type: 'error', timeout: 1000 });
                $('#showInputEmrScore').window('close')
                return
            }
            initEmrAppraiseHandler(data, appraiseID) //初始化评价 的 保存和提交按钮
            showEmrScoreTable(data, divID)
        })
}
/** 根据得到的评分表信息 初始化 保存和提交按钮 */
function initEmrAppraiseHandler(data, appraiseID) {
    var curStatus = data.appraiseInfo.status
    if (curStatus != "") {
        showHandlerBtn(curStatus)
        if (curStatus == $g("保存")) {
            $('#saveAppraiseShowBtn').unbind()
            $('#saveAppraiseShowBtn').on('click', function () {
                saveAppraiseBtn(data, appraiseID, function () {
                    $('#appraiseListTable').datagrid('reload');
                    $('#appraiseListTable').datagrid('selectRecord', appraiseID);
                })
            })
            $('#submitAppraiseShowBtn').unbind()
            $('#submitAppraiseShowBtn').on('click', function () {
                appraiseStatusChangeBtn(appraiseID, "T", function () {
                    showEmrScoreDataList("", appraiseID, "showEmrScoreList")
                    $('#appraiseListTable').datagrid('reload');
                    $('#appraiseListTable').datagrid('selectRecord', appraiseID);
                })
            })
        } else if (curStatus == $g("提交")) {
            $('#cancelSubmitShowBtn').unbind()
            $('#cancelSubmitShowBtn').on('click', function () {
                appraiseStatusChangeBtn(appraiseID, "S", function () {
                    showEmrScoreDataList("", appraiseID, "showEmrScoreList")
                    $('#appraiseListTable').datagrid('reload');
                    $('#appraiseListTable').datagrid('selectRecord', appraiseID);
                })
            })
        }
    } else {
        $('#saveAppraiseBtn').unbind()
        //评价窗口的按钮初始化 保存
        $('#saveAppraiseBtn').on('click', function () {
            saveAppraiseBtn(data, appraiseID, function () {
                $('#showInputEmrScore').window('close')
                $('#appraiseListTable').datagrid('reload')
            })
        })
        $('#submitAppraiseBtn').unbind()
        //评价窗口的按钮初始化 提交
        $('#submitAppraiseBtn').on('click', function () {
        })
    }
}


function runClassMethodByApp(className, methodName, datas, successHandler, datatype, sync) {
    var _options = {
        url: "dhcnurqualitydata.csp",
        async: true,
        dataType: "json", // text,html,script,json
        type: "POST",
        data: {
            'className': className,
            'methodName': methodName
        }
    };
    $.extend(_options.data, datas);
    var option = { dataType: typeof (datatype) == "undefined" ? "json" : datatype, async: typeof (sync) == "undefined" ? _options.async : sync };
    _options = $.extend(_options, option);
    return $.ajax(_options).done(successHandler).error(successHandler);
}



/**评价保存事件 */
function saveAppraiseBtn(data, appraiseID, callback) {
    var scoreData = data.scoreList
    for (var index in scoreData) {
        scoreData[index].realScore = $('#tr' + index + ' .pa4 input').val()
        scoreData[index].CheckItemRemark = $('#tr' + index + ' .br input').val()
    }
    data.scoreList = scoreData
    data.appraiseInfo['score'] = $('#appScore').val()

    runClassMethodByApp("Nur.Quality.Service.Audit", "appraiseHandler",
        {
            parameter1: appraiseID,
            parameter2: "insert",
            parameter3: "S",
            parameter4: GV.currentUSERID,
            parameter5: JSON.stringify(data),
            parameter6: appraiseID == "" ? $('#inputEmrAppRemarks').val() : $('#showEmrAppRemarks').val(),
            parameter7: GV.currentHOSPID
        }, function (data) {
            if (data == "0") {
                $.messager.popover({ msg: $g('操作成功'), type: 'success', timeout: 1000 });
                $('#emrTree').tree("reload")
                callback()
            } else {
                $.messager.popover({ msg: data, type: 'error', timeout: 1000 });
            }
        })
    /*
    $cm({
       ClassName: 'Nur.Quality.Service.Audit',
       MethodName: 'appraiseHandler',
       ResultSetType: "text",
       ID: appraiseID,
       Action: "insert",
       Status: "S",
       UserID: GV.currentUSERID,
       JsonData: JSON.stringify(data),
       Remarks: appraiseID == "" ? $('#inputEmrAppRemarks').val() : $('#showEmrAppRemarks').val()
    }, function(data){
        if (data=="0")
        {
           $.messager.popover({msg: '操作成功',type:'success',timeout: 1000});
           $('#emrTree').tree("reload")
           callback()
        }else{
           $.messager.popover({msg: data,type:'error',timeout: 1000});
        }
    })
    */
}
/**评价提交或撤销提交事件 */
function appraiseStatusChangeBtn(appraiseID, status, callback) {
    runClassMethod("Nur.Quality.Service.Audit", "appraiseHandler", {
        parameter1: appraiseID,
        parameter2: "changeStatus",
        parameter3: status,
        parameter4: GV.currentUSERID,
        parameter5: '',
        parameter6: ''
    }, function (data) {
        if (data == "0") {
            $.messager.popover({ msg: $g('操作成功'), type: 'success', timeout: 1000 });
            $('#emrTree').tree("reload")
            callback()
        } else {
            $.messager.popover({ msg: data, type: 'error', timeout: 1000 });
        }
    })
}
/**渲染评分表 */
function showEmrScoreTable(data, divID) {
    var appraiseInfo = data.appraiseInfo
    $('#showEmrAppRemarks').val(appraiseInfo.remarks)
    $('#inputEmrAppRemarks').val(appraiseInfo.remarks)
    var html = '<div style="width: 90%; margin: 0px auto;">' +
        '<div style="margin: 0px auto; text-align: center; font-size: 22px; font-weight: bold;">' + appraiseInfo.title + '</div>' +
        '<div style="margin: 10px 0px;">' +
        $g("患者")+':<input value="' + appraiseInfo.patName + '" class="textbox" name="patName" disabled="true" style="width:120px;height:26px;" >' +
        '&nbsp&nbsp'+$g("登记号")+':<input value="' + appraiseInfo.regNo + '" class="textbox" name="RegNo" disabled="true" style="width:120px;height:26px;" >' +
        '&nbsp&nbsp'+$g("评价日期")+':<input value="' + appraiseInfo.appDateTime + '" class="textbox" name="apoDateTime" disabled="true" style="width:140px;height:26px;" >' +
        '&nbsp&nbsp'+$g("成绩")+':<input id="appScore" value="' + appraiseInfo.score + '" class="textbox" name="appScore" disabled="true" style="width:50px;height:26px;" >' +
        '&nbsp&nbsp'+$g("状态")+':<input value="' + appraiseInfo.status + '" class="textbox" name="appStatus" disabled="true" style="width:50px;height:26px;" >' +
        '</div>' +
        '<div style="overflow:hidden">' +
        '<table id="scoredata" border="0" cellspacing="0" cellpadding="0" style="width: 100%;">' +
        '<thead>' +
        '<tr>' +
        '<th width="130" >'+$g("一级指标")+'</th> ' +
        '<th >'+$g("二级指标")+'</th> ' +
        '<th width="50" >'+$g("总分")+'</th>' +
        '<th width="50" >'+$g("得分")+'</th> ' +
        '<th width="140" class="noteTh" >'+$g("备注")+'</th>' +
        '</tr>' +
        '</thead>' +
        '<tbody>'
    for (var index in data.scoreList) {
        var item = data.scoreList[index]
        var trHtml = '<tr id="tr' + index + '">' +
            (item['oneIsShow'] == "1" ? '<td class="pl4" width="100" rowspan="' + item['oneColSpan'] + '">' + item['oneModelDesc'] + '</td>' : '') +
            '<td >' + item['twoModelDesc'] + '</td>' +
            '<td class="pl4" >' + item['Score'] + '</td>' +
            '<td class="pa4" align="center" width="50" >' +
            '<input id="score' + index + '" max="' + item['Score'] + '"  value="' + item['realScore'] + '">' +
            '</td>' +
            '<td class="br" width="140" >' +
            '<input value="' + item['CheckItemRemark'] + '" >' +
            '</td>' +
            '</tr>'
        html = html + trHtml
    }
    html = html + '</tbody>' + '</table>' + '</div>' + '</div>' + '</div>'

    $('#' + divID).html(html)

    for (var scoreIndex in data.scoreList) {
        $('#score' + scoreIndex).on('change', function (event) {
            var scoreObj = $(event.target)
            if (new RegExp(/(^[\-0-9][0-9]*(.[0-9]+)?)$/).test(scoreObj.val())) {
                var num = parseFloat(scoreObj.val())
                var maxNum = parseFloat(scoreObj.attr('max'))
                if ((num < 0) || (num > maxNum)) {
                    scoreObj.val(maxNum)
                }
            }else{
                scoreObj.val(0)
            }
            countScore(data.scoreList.length)
        })
    }
    //inputEmrScoreList
}
/**
* @description: 点击备注窗口的查询
*/
function emrNoteSearchBtn() {
    var selectedNote = $('#emrTree').tree('getSelected')
    if (selectedNote == null) {
        $.messager.popover({ msg: $g('请选择一个病历'), type: 'error', timeout: 1000 });
        return
    }
    var auditMainID = selectedNote.auditMainID
    var queryParams = $('#inputEmrNoteTable').datagrid('options').queryParams;
    queryParams.AuditMainID = auditMainID,
        queryParams.StartDate = $('#inputEmtNoteStartDate').datebox('getValue'),
        queryParams.EndDate = $('#inputEmtNoteEndDate').datebox('getValue'),
        $('#inputEmrNoteTable').datagrid('options').queryParams = queryParams;
    $('#inputEmrNoteTable').datagrid('load');
    changeNurseList(auditMainID)
}


/**
* @description: 改变责任人护士列表
*/
function changeNurseList(auditMainID) {
    GV.nurseList = $cm({
        ClassName: "Nur.Quality.Service.Audit",
        MethodName: "getNurseList",
        auditMainID: auditMainID
    }, false)
    var columns = $("#inputEmrNoteTable").datagrid("getColumnOption", "responsible")
    columns.editor.options.data = GV.nurseList
    /*
     var editor=$("#inputEmrNoteTable").datagrid("getEditor",{field:'responsible'})
     $(editor.target).combobox('loadData',GV.nurseList)
     $(editor.target).combobox('clear')
     */

}
/***************************************************** */


/**图标展示 */
function showImg(value, row, index) {
    return "<a onclick='showEmrAuditDetails(" + row['auditMainID'] + "," + row['episodeID'] + ")'  class='icon icon-paper' href='javascript:;'></a>"
}
/**文书名称展示 */
function showRecDesc(data) {
    var data = $.parseJSON(data)
    var html = '<div class="showEmrList"><ul>'
    for (var index in data) {
	    var desc = data[index].recDesc
        html += '<li  style="cursor:pointer;overflow:hidden;color:blue" onclick="clickRecDesc(' + data[index].episodeID + ',' + data[index].auditMainID + ')" value="' + data[index].auditMainID + '">' + (desc.indexOf("<") > -1 ? ($g(desc.split("<span")[0]) + "<span" + desc.split("<span")[1])  : $g(desc) ) + '</li>'
    }
    html += '</ul></div>'
    return html
}
/**评价结果展示 */
function showEvalution(data) {
    var data = $.parseJSON(data)
    var html = '<div class="showEmrList"><ul>'
    for (var index in data) {
        html += '<li style="height:' + ((data[index].colSpan) * 34 + ((data[index].colSpan) - 1)) + 'px;line-height:' + ((data[index].colSpan) * 34 + ((data[index].colSpan) - 1)) + 'px" >' + data[index].score + '</li>'
    }
    html += '</ul></div>'
    return html
}
/**级别显示 */
function showGrade(data) {
    var data = $.parseJSON(data)
    var html = '<div class="showEmrList"><ul>'
    for (var index in data) {
        html += '<li style="height:' + ((data[index].colSpan) * 34 + ((data[index].colSpan) - 1)) + 'px;line-height:' + ((data[index].colSpan) * 34 + ((data[index].colSpan) - 1)) + 'px" >' + data[index].grade + '</li>'
    }
    html += '</ul></div>'
    return html
}
/**状态点击全部 */
function allCheckBoxClick(flag) {
    for (var item in GV.statusList) {
        if (item != "all") {
            $HUI.checkbox('#' + item).setValue(flag)
        }
    }
}
/**其他状态点击设置全部 */
function otherBoxClick(flag) {
    var ifAllChecked = true
    for (var item in GV.statusList) {
        if (item != "all") {
            if (!$HUI.checkbox('#' + item).getValue()) {
                ifAllChecked = false
            }
        }
    }
    if (ifAllChecked) {
        $HUI.checkbox('#all').setValue(true)
    } else {
        $HUI.checkbox('#all').setValue(false)
    }
}
function getAllChecked() {
    var checkedList = []
    for (var item in GV.statusList) {
        if (item != "all") {
            if ($HUI.checkbox('#' + item).getValue()) {
                checkedList.push(item)
            }
        }
    }
    return checkedList.join(",")
}
function countScore(length) {
    var allScore = 0
    for (var i = 0; i < length; i++) {
        allScore = floatObj.add(allScore, parseFloat($('#score' + i).val()))
        //allScore += parseFloat($('#score' + i ).val())
    }
    $('#appScore').val(allScore)
}
function serilizeURL(url) {
    var rs = url.split("?")[1];
    var arr = rs.split("&");
    var json = {};
    json["csp"] = url.split("?")[0];
    for (var i = 0; i < arr.length; i++) {
        if (arr[i].indexOf("=") != -1) {
            json[arr[i].split("=")[0]] = arr[i].split("=")[1];
        }
        else {
            json[arr[i]] = "undefined";
        }
    }
    return json;
}
function onLoadSuccess(data) {
    var merges = [{
        index: 2,
        rowspan: 3
    }, {
        index: 5,
        rowspan: 2
    }, {
        index: 7,
        rowspan: 2
    }, {
        index: 122,
        rowspan: 3
    }];
    /*
        $(this).datagrid('mergeCells',{
            index: merges[i].index,
            field: 'ck',
            rowspan: merges[i].rowspan
        });
    */
}
function showHandlerBtn(status) {
    if (status == $g("提交")) {
        $('#saveAppraiseShowBtn').css("display", "none")
        $('#submitAppraiseShowBtn').css("display", "none")
        $('#cancelSubmitShowBtn').css("display", "")

    } else if (status == $g("保存")) {
        $('#saveAppraiseShowBtn').css("display", "")
        //$('#submitAppraiseShowBtn').css("display", "")
        $('#cancelSubmitShowBtn').css("display", "none")
    }
}

function hiddenBtnAndNotes() {
    $('#saveAppraiseShowBtn').css("display", "none")
    $('#submitAppraiseShowBtn').css("display", "none")
    $('#cancelSubmitShowBtn').css("display", "none")
    $('#showEmrAppRemarks').val("")
}

var tableToExcel = (function () {
    var uri = 'data:application/vnd.ms-excel;base64,',
        template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head><!--[if gte mso 9]><?xml version="1.0" encoding="UTF-8" standalone="yes"?><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>',
        base64 = function (s) { return window.btoa(unescape(encodeURIComponent(s))) },
        format = function (s, c) {
            return s.replace(/{(\w+)}/g,
                function (m, p) { return c[p]; })
        }
    return function (table, name) {
        if (!table.nodeType) table = document.getElementById(table)
        var ctx = { worksheet: name || 'Worksheet', table: table.innerHTML }
        window.location.href = uri + base64(format(template, ctx))
    }
})()


function setEprMenuForm(adm,papmi,mradm,canGiveBirth){
    var frm = dhcsys_getmenuform();
    if((frm) &&(frm.EpisodeID.value != adm)){
        frm.EpisodeID.value = adm;
        frm.PatientID.value = papmi;
        frm.mradm.value = mradm;
    }
}