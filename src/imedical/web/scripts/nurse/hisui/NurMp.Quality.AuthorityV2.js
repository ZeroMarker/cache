$(function () {

    function init() {
        if (selEpisodeID == "") {
            initPatSearch() //初始化患者查询
        } else {
            expandEMRRangeTree(selEpisodeID)
            assignPatInfoToTitle(selEpisodeID)
        }
        initEmrList() //初始化病历列表
        initAuthorityUser() //初始化授权的用户
        initWindow() //弹窗
        showElemByConfig();
    }
    // 初始化患者查询 
    function initPatSearch() {
        function filter(q, row) {
            var opts = $(this).combobox('options');
            var text = row[opts.textField];
            var pyjp = getPinyin(text).toLowerCase();
            if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
                return true;
            }
            return false;
        }
        // 时间类型
        $('#inputTimeType').combobox({
            idField: 'value',
            textField: 'text',
            data: [{
                text: $g('入院时间'),
                value: 'I'
            }, {
                text: $g('出院时间'),
                value: 'O'
            }],
            value: 'O'
        })
        //初始化时间，默认当天

        $('#inputStartDate').datebox('setValue', (new Date().before(7)).Format("yyyy-MM-dd"))
        $('#inputEndDate').datebox('setValue', (new Date()).Format("yyyy-MM-dd"))
        //初始化科室
        $('#inputCtLoc').combobox({
            valueField: 'ID',
            textField: 'desc',
            url: LINK_CSP + "?className=Nur.InService.AppPatRegister&methodName=getLocs&parameter1=W",
            filter: filter,
            onLoadSuccess: function (params) {
                $(this).combobox('setValue', session['LOGON.CTLOCID'])
            }
        })
        //初始化关键字类型
        $('#inputMainSelect').combobox({
            idField: 'value',
            textField: 'text',
            data: [{
                text: $g('登记号'),
                value: 'regNo'
            }, {
                text: $g('床号'),
                value: 'bedCode'
            }, {
                text: $g('姓名'),
                value: 'patName'
            }, {
                text: $g('医生'),
                value: 'mainDoctor'
            }],
            value: 'regNo'
        })
        $('#inputMainInput').bind('keypress', function (event) {
            if (event.keyCode == "13") {
                searchPatient();
            }
        });
        //初始化 查询患者表格
        $('#patientListTable').datagrid({
            url: $URL,
            queryParams: {
                ClassName: 'NurMp.Quality.Service.AuthorityV2',
                QueryName: 'getOutHopPatList',
                DateType: $('#inputTimeType').combobox('getValue'),
                StartDate: $('#inputStartDate').datebox('getValue'),
                EndDate: $('#inputEndDate').datebox('getValue'),
                CTLoc: session['LOGON.CTLOCID'],
                SelectMain: $('#inputMainSelect').combobox('getValue'),
                SelectInput: $('#inputMainInput').val(),
            },
            method: 'post',
            loadMsg: $g('数据装载中......'),
            singleSelect: true,
            showHeader: true,
            //fitColumns: true,
            columns: [[
                { field: 'regNo', title: '登记号', width: 100, sortable: true },
                { field: 'bedCode', title: '床号', width: 80, sortable: true },
                { field: 'patName', title: '姓名', width: 80, sortable: true },
                { field: 'sex', title: '年龄', width: 60, sortable: true },
                { field: 'inHosDateTime', title: '入院时间', width: 150, sortable: true },
                { field: 'outHosDateTime', title: '出院时间', width: 150, sortable: true },
                { field: 'ctLocDesc', title: '科室', width: 100, sortable: true },
                { field: 'wardDesc', title: '病区', width: 100, sortable: true },
                { field: 'mainDoctor', title: '医生', width: 80, sortable: true },
                { field: 'episodeID', title: '就诊号', width: 80, sortable: true },
                { field: 'patientID', title: '病人号', width: 80, sortable: true }
            ]],
            pagination: true,
            pageSize: 20,
            pageList: [10, 20, 50],
            pagePosition: 'bottom',
            toolbar: '#patientListTableTBar',
            title: '出院病历授权—患者查询',
            onClickRow: function (rowIndex, rowData) {
                //选中患者
                var episodeID = rowData["episodeID"]
                selEpisodeID = episodeID
                expandEMRRangeTree(episodeID)
                assignPatInfoToTitle(episodeID)
                initPatWardList(episodeID)
            }
        });

        //查询患者
        $('#patientSearchBtn').on('click', function () {
            searchPatient();
        });
    }

    function initEmrList() {

        $('#saveApply').on('click', function () {
            saveApply();
        });

        var actionList = $cm({
            ClassName: "NurMp.Quality.Service.AuthorityV2",
            MethodName: "getDefaultAction"
        },false)

        //给予操作类型
        $('#inputGivePowerType').combogrid({
            idField: 'id',
            textField: 'text',
            data: actionList,
            panelWidth: 300,
            showHeader: true,
            multiple: true,
            columns: [[
                { field: 'ck', checkbox: true },
                { field: 'id', title: 'id', width: 80, hidden: true },
                { field: 'value', title: 'value', width: 80, hidden: true },
                { field: 'text', title: '操作类型', width: 250 }
            ]],
            onLoadSuccess: function () {
                //$('#inputGivePowerType').combogrid('grid').datagrid('selectRecord', 2);
                //$('#inputGivePowerType').combogrid('grid').datagrid('selectAll');
            }
        });

        //授权小时
        $('#inputGivePowerSpan').numberbox({
            min: 0,
            max: 72,
            value: 24
        });


        //授权历史事件
        $('#treeHistoryBtn').on('click', function () {
            $('#historyTable').datagrid('reload');
            $('#treeHistoryWin').window('open');
        });

        $('#applyHistoryBtn').on('click', function () {
            $('#historyTable').datagrid('reload');
            $('#treeHistoryWin').window('open');
        });
        var historyDG = $('#historyTable').datagrid({
            url: $URL,
            queryParams: {
                ClassName: 'NurMp.Quality.Service.AuthorityV2',
                QueryName: 'getAuthorityHistory',
                AppointCTLocID: (ApplyFlag == 1) ? "" : appointUserLoc,
                IsValid: 'all',
               
                ApplyUser: (ApplyFlag == 1) ? session['LOGON.USERID'] : "",
                selEpisodeID: selEpisodeID
            },
            method: 'post',
            loadMsg: $g('数据装载中......'),
            showHeader: true,
            multiple: true,
            columns: [
                [
                    { field: 'ck', checkbox: true },
                    { field: 'authorityID', title: 'authorityID', hidden: true },
                    { field: 'status', title: '状态' },
                    { field: 'appointDateTime', title: '开始时间' },
                    { field: 'appointEndDateTime', title: '结束时间'},
                    { field: 'appointUserID', title: '授权人ID', hidden: true },
                    { field: 'appointUserName', title: '授权人' },
                    { field: 'appointUserCTLocName', title: '授权科室'},
                    { field: 'ApplyReason', title: '申请原因' },
                    { field: 'patName', title: '患者姓名' },
                    { field: 'regNo', title: '登记号' },
                    { field: 'CancelDateTime', title: '撤销时间'},
                    { field: 'CancelUserName', title: '撤销人'},
                    { field: 'CancelReason', title: '撤销原因'},

                    { field: 'episodeID', title: '就诊指针', hidden: true },
                    { field: 'requestUserID', title: (ApplyFlag == 1) ? '申请人Id' : '被授权人ID', hidden: true },
                    { field: 'requestUserName', title: (ApplyFlag == 1) ? '申请人' : '被授权人' },
                    { field: 'requestUserCTLocID', title: '给予的医生所在科室ID', hidden: true },
                    { field: 'requestUserCTLocName', title: (ApplyFlag == 1) ? '申请科室' : '被授权科室'},
                    { field: 'detailData', title: '详情', hidden: true },
                ]
            ],
            view: detailview,
            detailFormatter: function (index, row) {
                return '<table id="DatagridDetail' + index + '"></table>'
            },
            onExpandRow: function (index, row) {
                var o = $('#DatagridDetail' + index);
                $('#DatagridDetail' + index).datagrid({
                    autoHeight: 250,
                    //title:"操作明细",
                    striped: true,
                    singleSelect: true,
                    columns: [
                        [
                            { field: 'emrCode', title: '授权病历', width: 80, hidden: true },
                            { field: 'emrCodeDesc', title: '授权病历', width: 240 },
                            { field: 'actionDescStr', title: '授权操作', width: 250 },
                        ]
                    ],
                    onLoadSuccess: function () {
                        $('#_list_tj').datagrid('fixDetailRowHeight', index);
                        setTimeout(function () {
                            var tr = o.closest('tr');
                            id = tr.prev().attr('id'); //此子表格父行所在行的id
                            id = id.replace(/-2-(\d+)$/, '-1-$1');
                            $('#' + id).next().css('height', tr.height());//设置没展开的前部分的高度，由于启用了计时器，会闪一下
                        }, 0);
                    }
                })
                InitDatagridDetail(index, row)
            },
            pagination: true,
            pageSize: 20,
            pageList: [10, 20, 50],
            pagePosition: 'bottom',
            toolbar: '#historyTableTBar',
            rowStyler: function (index, row) {
                if (row["IsValid"] == $g("已授权")) {
                    return 'background-color:#c7dafe;';
                }
            }
        });
        var winStatus = [{
            id: 'all',
            text: $g('全部')
        }, {
            id: 'active',
            text: $g('生效中')
        }, {
            id: 'past',
            text: $g('过期')
        }]
        if (ApplyFlag == 1) {
            winStatus.push({
                id: 'apply',
                text: $g('申请')
            })
        }
        //过滤记录是否有效
        $('#isCurrentValidSelect').combobox({
            valueField: 'id',
            textField: 'text',
            data: winStatus,
            onSelect: function (record) {
                var queryParams = $('#historyTable').datagrid('options').queryParams;
                queryParams.IsValid = record["id"];
                $('#historyTable').datagrid('options').queryParams = queryParams;
                $('#historyTable').datagrid('reload');
            }
        });
        $('#isCurrentValidSelect').combobox('select',"all");
    }
    var appointIDs = [];
    function withdrawBtn() {
        appointIDs = [];
        var gridRows = $('#historyTable').datagrid("getChecked");
        var error = ""
        for (var i = 0; i < gridRows.length; i++) {
            var gridRow = gridRows[i];
            if (gridRow["status"] == $g("过期")) {
                var number = i + 1
                if (error == "") {
                    error = number;
                } else {
                    error = error + "," + number;
                }
                continue;
            }
            else if (gridRow["status"] == $g("生效中") || gridRow["status"] == $g("申请")) {
                var appointID = gridRow["authorityID"];
                appointIDs.push(appointID)
            }
        }
        if (appointIDs.length == 0 && error != "") {
            $.messager.alert($g('提示'), $g("选择的数据不需要撤销！"));
            return;
        } else if (appointIDs.length == 0) {
            $.messager.alert($g('提示'), $g("请至少选择一条记录！"));
        } else {
            if (error != "") {
                $.messager.alert($g('提示'), $g('选择的第') + error + $g("条已失效，不需要撤销！"));
            }
            $('#cncelReason').val("")
            $('#CancelDialog').dialog('open');


        }
    }
    function cancel() {
        runClassMethod("NurMp.Quality.Service.AuthorityV2", "cancelAuthority",
            {
                parameter1: JSON.stringify(appointIDs),
                parameter2: session['LOGON.USERID'],
                parameter3: $('#cncelReason').val()
            },
            function (data) {
                if (data == "0") {
                    $.messager.alert($g('提示'), $g('撤销成功！'));
                    $('#historyTable').datagrid('reload');
                    $('#CancelDialog').dialog('close');
                } else {
                    $.messager.alert($g('错误'), $g("撤销失败:") + data, 'error');
                }
            }
        )
    }
    /** 初始化右下方的用户授权*/
    function initAuthorityUser() {
        //患者待过的病区
        $('#inputDocLoc').combobox({
            valueField: 'id',
            textField: 'text',
            onSelect: function () {
                searchUser()
            }
        })
        $('#docListTable').datagrid({
            method: 'post',
            loadMsg: $g('数据装载中......'),
            singleSelect: true,
            showHeader: true,
            //fitColumns: true,
            columns: [[
                { field: 'userCode', title: '工号', width: 80, sortable: true },
                { field: 'userName', title: '姓名', width: 80, sortable: true },
                { field: 'userWard', title: '病区', width: 120, sortable: true },
                { field: 'userTitle', title: '职称', width: 80, sortable: true },
                { field: 'userID', title: 'id', width: 80, sortable: true, hidden: true },
                { field: 'userCTLocID', title: 'ctlocId', width: 80, sortable: true, hidden: true },
            ]],
            pagination: true,
            pageSize: 20,
            pageList: [10, 20, 50],
            pagePosition: 'bottom',
            toolbar: '#docListTableTBar',
            onClickRow: function (rowIndex, rowData) {
                /*
                //获取选中医生
                var rows = $('#patientListTable').datagrid("getSelections");    // 获取所有选中的行
                var length = rows.length;
                if (length > 0) {
                    var row = rows[0];
                    var episodeID = row["EpisodeID"];
                    expandEMRRangeTree(episodeID);
                }
                */
            }
        });

        /**查询按钮 */
        $('#docSearchBtn').on('click', function () {
            searchUser()
        })

        /**输入名字查询框 */
        $('#inputDocName').bind('keypress', function (event) {
            if (event.keyCode == "13") {
                searchUser();
            }
        });


        /**授权按钮 */
        $('#doAuthorityBtn').on('click', function () {
            authorityBtn()
        })
        /**授权按钮 */
        $('#ApplyBtn').on('click', function () {
            ApplyBtn()
        })
        $('#withdrawBtn').on('click', function () {
            withdrawBtn()
        })
        $('#cancel').on('click', function () {
            cancel()
        })

    }
    //加载弹窗
    function initWindow(){
        $('#treeHistoryWin').window({
            width: 1200,
            height: 700,
            modal: true,
            closed: true,
            collapsible: false,
            minimizable: false,
            maximizable: false,
            closable: true,
            title: '历史记录',
            iconCls: 'icon-w-paper'

        });
    }


    function showElemByConfig() {
        if (ApplyFlag == 1) {
            var oriTopHeight = parseInt($("#emrTreeDiv").css("height"));
            var oriBottomHeight = parseInt($("#docListTableTBar").parent().parent().parent().css("height"));
            $("#emrTreeDiv").css("height", oriTopHeight + oriBottomHeight);
            $("#emrTreeDiv").parent().css("height", oriTopHeight + oriBottomHeight);
            var treeHeight = parseInt($("#emrTree").parent().css("height"));
            $("#emrTree").parent().css("height", treeHeight + oriBottomHeight);
            $("#docListTableTBar").parent().parent().parent().parent().hide();
            $("#hourDiv").hide();
            $("#treeHistoryBtn").hide();

        } else {
            $("#ApplyBtn").hide();
            $("#applyHistoryBtn").hide();
        }
    }


    /**右下角病人授权模块 查询用户的方法 */
    function searchUser() {
        $('#docListTable').datagrid('options').url = $URL
        $('#docListTable').datagrid('options').queryParams = {
            ClassName: 'NurMp.Quality.Service.AuthorityV2',
            QueryName: 'getNurseUserList',
            CTLocID: $('#inputDocLoc').combobox('getValue'),
            Name: $('#inputDocName').val()
        }
        $('#docListTable').datagrid('load');
    }
    /** 患者列表点击查询的方法*/
    function searchPatient() {
        var queryParams = $('#patientListTable').datagrid('options').queryParams;
        queryParams.DateType = $('#inputTimeType').combobox('getValue');
        queryParams.StartDate = $('#inputStartDate').datebox('getValue'),
            queryParams.EndDate = $('#inputEndDate').datebox('getValue'),
            queryParams.CTLoc = $('#inputCtLoc').combobox('getValue'),
            queryParams.SelectMain = $('#inputMainSelect').combobox('getValue'),
            queryParams.SelectInput = $('#inputMainInput').val(),
            $('#patientListTable').datagrid('options').queryParams = queryParams;
        $('#patientListTable').datagrid('load');
    }
    /**
     * 点击患者列表查询出患者已经填写的护理病历
     * @param {string} episodeID 
     */
    function expandEMRRangeTree(episodeID) {
        var parameter2 = ""
        if (ApplyFlag == 1) {
            parameter2 = session['LOGON.USERID'];
        }
        $('#emrTree').tree({
            //url: '../web.eprajax.GivePower.cls?Action=tree&EpisodeID=' + episodeID,
            url: LINK_CSP + "?className=NurMp.Quality.Service.AuthorityV2&methodName=getTemplatesByEpisodeID&parameter1=" +
                session['LOGON.HOSPID'] + "&parameter2=" + session['LOGON.CTLOCID'] + "&parameter3=" + episodeID + "&parameter4=" + selGuid,
            method: 'get',
            animate: true,
            checkbox: true,
            checked: false,
            cascadeCheck: true,
        });
    }
    /**
     * 点击患者加载患者待过的科室
     * @param {string} episodeID 
     */
    function initPatWardList(episodeID) {
        $('#inputDocLoc').combobox('clear')
        $('#inputDocLoc').combobox('reload', LINK_CSP + "?className=NurMp.Quality.Service.AuthorityV2&methodName=getPatLocList&parameter1=" + episodeID)
        $('#docListTable').datagrid('loadData', [])
    }
    function ApplyBtn() {
	    var allChecked = $('#emrTree').tree('getChecked')
	    //获取选中的护理病历模板
        var emrCodeList = []
        for (var single in allChecked) {
            if (!(allChecked[single].children)) {
                emrCodeList.push(allChecked[single].id)
            }
        }
        //获取选择的授权操作类型
        var givePowerTypeList = []
        var givePowerTypeGridRows = $('#inputGivePowerType').combogrid('grid').datagrid("getChecked");
        for (var curIndex in givePowerTypeGridRows) {
            var givePowerTypeGridRow = givePowerTypeGridRows[curIndex]
            var value = givePowerTypeGridRow["value"];
            givePowerTypeList.push(value)
        }
         if (emrCodeList.length == 0) {
            $.messager.alert($g("提示"), $g("请在模板板列表中至少选择一个模板！"), "error")
            return
        }
        else if (givePowerTypeList.length == 0) {
            $.messager.alert($g("提示"), $g("请选择至少一个操作类型！"), "error")
            return
        }
        else{
        	$('#applyReason').val("")
        	$('#ApplyDialog').dialog('open');
        }
    }
    function saveApply() {
        var EpisodeID = selEpisodeID
        if (EpisodeID == "") {
            var record = $('#patientListTable').datagrid("getSelected");    // 获取所有选中的行
            if (record == null) {
                $.messager.alert($g("提示"), $g("请选中一个患者！"), "error")
                return
            }
        }
        var allChecked = $('#emrTree').tree('getChecked')
        //获取选中的护理病历模板
        var emrCodeList = []
        for (var single in allChecked) {
            if (!(allChecked[single].children)) {
                emrCodeList.push(allChecked[single].id)
            }
        }
        if (emrCodeList.length == 0) {
            $.messager.alert($g("提示"), $g("请在模板板列表中至少选择一个模板！"), "error")
            return
        }
        //获取选择的授权操作类型
        var givePowerTypeList = []
        var givePowerTypeGridRows = $('#inputGivePowerType').combogrid('grid').datagrid("getChecked");
        for (var curIndex in givePowerTypeGridRows) {
            var givePowerTypeGridRow = givePowerTypeGridRows[curIndex]
            var value = givePowerTypeGridRow["value"];
            givePowerTypeList.push(value)
        }
        if (givePowerTypeList.length == 0) {
            $.messager.alert($g("提示"), $g("请选择至少一个操作类型！"), "error")
            return
        }

        var requsetUserID = appointUserID;
        var requsetUserLoc = appointUserLoc;
        var applyReason = $("#applyReason").val();
        $m({
            ClassName: "NurMp.Quality.Service.AuthorityV2",
            MethodName: "applyAuthority",
            EpisodeID: EpisodeID,
            Actions: JSON.stringify(givePowerTypeList),
            MultDataList: JSON.stringify(emrCodeList),
            requestLocID: requsetUserLoc,
            requestUserID: requsetUserID,
            applyReason: applyReason
        }, function (data) {
            if (data == 0) {
                $.messager.alert($g("提示"), $g("申请成功"), "success")
                $('#ApplyDialog').dialog('close');
                $('#emrTree').tree("reload")
            } else {
                $.messager.alert($g("提示"), data, "error")
            }
        })
    }
    /** 授权按钮*/
    function authorityBtn() {
        var record = $('#patientListTable').datagrid("getSelected");    // 获取所有选中的行
        if (record == null) {
            $.messager.alert($g("提示"), $g("请选中一个患者！"), "error")
            return
        }
        var EpisodeID = record["episodeID"]
        var allChecked = $('#emrTree').tree('getChecked')
        //获取选中的护理病历模板
        var emrCodeList = []
        for (var single in allChecked) {
            if (!(allChecked[single].children)) {
                emrCodeList.push(allChecked[single].id)
            }
        }
        if (emrCodeList.length == 0) {
            $.messager.alert($g("提示"), $g("请在模板板列表中至少选择一个模板！"), "error")
            return
        }
        //获取选择的授权操作类型
        var givePowerTypeList = []
        var givePowerTypeGridRows = $('#inputGivePowerType').combogrid('grid').datagrid("getChecked");
        for (var curIndex in givePowerTypeGridRows) {
            var givePowerTypeGridRow = givePowerTypeGridRows[curIndex]
            var value = givePowerTypeGridRow["value"];
            givePowerTypeList.push(value)
        }
        if (givePowerTypeList.length == 0) {
            $.messager.alert($g("提示"), $g("请选择至少一个操作类型！"), "error")
            return
        }
        //获取选择的授权人
        var userRecord = $('#docListTable').datagrid("getSelected");    // 获取所有选中的行
        if (userRecord == null) {
            $.messager.alert($g("提示"), $g("请选择要授权的人！"), "error")
            return
        }
        var authUserID = userRecord["userID"]
        var authUserLocID = userRecord["userCTLocID"]
        runClassMethod("NurMp.Quality.Service.AuthorityV2", "insertAuthority",
            {
                parameter1: EpisodeID,
                parameter2: $('#inputGivePowerSpan').val(),
                parameter3: JSON.stringify(givePowerTypeList),
                parameter4: JSON.stringify(emrCodeList),
                parameter5: authUserLocID,
                parameter6: authUserID,
                parameter7: appointUserLoc,
                parameter8: appointUserID
            }, function (data) {
                if (data == 0) {
                    $.messager.alert($g("提示"), $g("授权成功"), "success")
                    $('#emrTree').tree("reload")
                } else {
                    $.messager.alert($g("提示"), data, "error")
                }
            }, '', false)
    }

    function InitDatagridDetail(index, row) {
        var DetailJson, DetailData = { rows: [], total: 0 };

        if (!!row["detailData"]) {
            DetailJson = row["detailData"]
            DetailJson = $.parseJSON(DetailJson)
        }

        for (var p in DetailJson) {
            //DetailData.rows.push({"key":p,"value":DetailJson[p]});
            DetailData.rows.push(DetailJson[p]);
            DetailData.total++;
        }
        $('#DatagridDetail' + index).datagrid("loadData", DetailData);
    }
    ///将病人信息赋值给表头
    function assignPatInfoToTitle(EpisodeID)
    {
        $m({
            ClassName: "NurMp.Quality.Service.AuthorityV2",
            MethodName: "getTitlePatInfo",
            EpisodeID: EpisodeID
        },function(data){
            $("#emrListPanel").panel("setTitle", "<font style='font-weight:bold;color:red'>"  + data + "</font>")
        })
        
    }


    init();
})