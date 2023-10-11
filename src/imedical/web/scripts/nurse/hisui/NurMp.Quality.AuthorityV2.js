$(function () {

    function init() {
        if (selEpisodeID == "") {
            initPatSearch() //��ʼ�����߲�ѯ
        } else {
            expandEMRRangeTree(selEpisodeID)
            assignPatInfoToTitle(selEpisodeID)
        }
        initEmrList() //��ʼ�������б�
        initAuthorityUser() //��ʼ����Ȩ���û�
        initWindow() //����
        showElemByConfig();
    }
    // ��ʼ�����߲�ѯ 
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
        // ʱ������
        $('#inputTimeType').combobox({
            idField: 'value',
            textField: 'text',
            data: [{
                text: $g('��Ժʱ��'),
                value: 'I'
            }, {
                text: $g('��Ժʱ��'),
                value: 'O'
            }],
            value: 'O'
        })
        //��ʼ��ʱ�䣬Ĭ�ϵ���

        $('#inputStartDate').datebox('setValue', (new Date().before(7)).Format("yyyy-MM-dd"))
        $('#inputEndDate').datebox('setValue', (new Date()).Format("yyyy-MM-dd"))
        //��ʼ������
        $('#inputCtLoc').combobox({
            valueField: 'ID',
            textField: 'desc',
            url: LINK_CSP + "?className=Nur.InService.AppPatRegister&methodName=getLocs&parameter1=W",
            filter: filter,
            onLoadSuccess: function (params) {
                $(this).combobox('setValue', session['LOGON.CTLOCID'])
            }
        })
        //��ʼ���ؼ�������
        $('#inputMainSelect').combobox({
            idField: 'value',
            textField: 'text',
            data: [{
                text: $g('�ǼǺ�'),
                value: 'regNo'
            }, {
                text: $g('����'),
                value: 'bedCode'
            }, {
                text: $g('����'),
                value: 'patName'
            }, {
                text: $g('ҽ��'),
                value: 'mainDoctor'
            }],
            value: 'regNo'
        })
        $('#inputMainInput').bind('keypress', function (event) {
            if (event.keyCode == "13") {
                searchPatient();
            }
        });
        //��ʼ�� ��ѯ���߱��
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
            loadMsg: $g('����װ����......'),
            singleSelect: true,
            showHeader: true,
            //fitColumns: true,
            columns: [[
                { field: 'regNo', title: '�ǼǺ�', width: 100, sortable: true },
                { field: 'bedCode', title: '����', width: 80, sortable: true },
                { field: 'patName', title: '����', width: 80, sortable: true },
                { field: 'sex', title: '����', width: 60, sortable: true },
                { field: 'inHosDateTime', title: '��Ժʱ��', width: 150, sortable: true },
                { field: 'outHosDateTime', title: '��Ժʱ��', width: 150, sortable: true },
                { field: 'ctLocDesc', title: '����', width: 100, sortable: true },
                { field: 'wardDesc', title: '����', width: 100, sortable: true },
                { field: 'mainDoctor', title: 'ҽ��', width: 80, sortable: true },
                { field: 'episodeID', title: '�����', width: 80, sortable: true },
                { field: 'patientID', title: '���˺�', width: 80, sortable: true }
            ]],
            pagination: true,
            pageSize: 20,
            pageList: [10, 20, 50],
            pagePosition: 'bottom',
            toolbar: '#patientListTableTBar',
            title: '��Ժ������Ȩ�����߲�ѯ',
            onClickRow: function (rowIndex, rowData) {
                //ѡ�л���
                var episodeID = rowData["episodeID"]
                selEpisodeID = episodeID
                expandEMRRangeTree(episodeID)
                assignPatInfoToTitle(episodeID)
                initPatWardList(episodeID)
            }
        });

        //��ѯ����
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

        //�����������
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
                { field: 'text', title: '��������', width: 250 }
            ]],
            onLoadSuccess: function () {
                //$('#inputGivePowerType').combogrid('grid').datagrid('selectRecord', 2);
                //$('#inputGivePowerType').combogrid('grid').datagrid('selectAll');
            }
        });

        //��ȨСʱ
        $('#inputGivePowerSpan').numberbox({
            min: 0,
            max: 72,
            value: 24
        });


        //��Ȩ��ʷ�¼�
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
            loadMsg: $g('����װ����......'),
            showHeader: true,
            multiple: true,
            columns: [
                [
                    { field: 'ck', checkbox: true },
                    { field: 'authorityID', title: 'authorityID', hidden: true },
                    { field: 'status', title: '״̬' },
                    { field: 'appointDateTime', title: '��ʼʱ��' },
                    { field: 'appointEndDateTime', title: '����ʱ��'},
                    { field: 'appointUserID', title: '��Ȩ��ID', hidden: true },
                    { field: 'appointUserName', title: '��Ȩ��' },
                    { field: 'appointUserCTLocName', title: '��Ȩ����'},
                    { field: 'ApplyReason', title: '����ԭ��' },
                    { field: 'patName', title: '��������' },
                    { field: 'regNo', title: '�ǼǺ�' },
                    { field: 'CancelDateTime', title: '����ʱ��'},
                    { field: 'CancelUserName', title: '������'},
                    { field: 'CancelReason', title: '����ԭ��'},

                    { field: 'episodeID', title: '����ָ��', hidden: true },
                    { field: 'requestUserID', title: (ApplyFlag == 1) ? '������Id' : '����Ȩ��ID', hidden: true },
                    { field: 'requestUserName', title: (ApplyFlag == 1) ? '������' : '����Ȩ��' },
                    { field: 'requestUserCTLocID', title: '�����ҽ�����ڿ���ID', hidden: true },
                    { field: 'requestUserCTLocName', title: (ApplyFlag == 1) ? '�������' : '����Ȩ����'},
                    { field: 'detailData', title: '����', hidden: true },
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
                    //title:"������ϸ",
                    striped: true,
                    singleSelect: true,
                    columns: [
                        [
                            { field: 'emrCode', title: '��Ȩ����', width: 80, hidden: true },
                            { field: 'emrCodeDesc', title: '��Ȩ����', width: 240 },
                            { field: 'actionDescStr', title: '��Ȩ����', width: 250 },
                        ]
                    ],
                    onLoadSuccess: function () {
                        $('#_list_tj').datagrid('fixDetailRowHeight', index);
                        setTimeout(function () {
                            var tr = o.closest('tr');
                            id = tr.prev().attr('id'); //���ӱ���������е�id
                            id = id.replace(/-2-(\d+)$/, '-1-$1');
                            $('#' + id).next().css('height', tr.height());//����ûչ����ǰ���ֵĸ߶ȣ����������˼�ʱ��������һ��
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
                if (row["IsValid"] == $g("����Ȩ")) {
                    return 'background-color:#c7dafe;';
                }
            }
        });
        var winStatus = [{
            id: 'all',
            text: $g('ȫ��')
        }, {
            id: 'active',
            text: $g('��Ч��')
        }, {
            id: 'past',
            text: $g('����')
        }]
        if (ApplyFlag == 1) {
            winStatus.push({
                id: 'apply',
                text: $g('����')
            })
        }
        //���˼�¼�Ƿ���Ч
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
            if (gridRow["status"] == $g("����")) {
                var number = i + 1
                if (error == "") {
                    error = number;
                } else {
                    error = error + "," + number;
                }
                continue;
            }
            else if (gridRow["status"] == $g("��Ч��") || gridRow["status"] == $g("����")) {
                var appointID = gridRow["authorityID"];
                appointIDs.push(appointID)
            }
        }
        if (appointIDs.length == 0 && error != "") {
            $.messager.alert($g('��ʾ'), $g("ѡ������ݲ���Ҫ������"));
            return;
        } else if (appointIDs.length == 0) {
            $.messager.alert($g('��ʾ'), $g("������ѡ��һ����¼��"));
        } else {
            if (error != "") {
                $.messager.alert($g('��ʾ'), $g('ѡ��ĵ�') + error + $g("����ʧЧ������Ҫ������"));
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
                    $.messager.alert($g('��ʾ'), $g('�����ɹ���'));
                    $('#historyTable').datagrid('reload');
                    $('#CancelDialog').dialog('close');
                } else {
                    $.messager.alert($g('����'), $g("����ʧ��:") + data, 'error');
                }
            }
        )
    }
    /** ��ʼ�����·����û���Ȩ*/
    function initAuthorityUser() {
        //���ߴ����Ĳ���
        $('#inputDocLoc').combobox({
            valueField: 'id',
            textField: 'text',
            onSelect: function () {
                searchUser()
            }
        })
        $('#docListTable').datagrid({
            method: 'post',
            loadMsg: $g('����װ����......'),
            singleSelect: true,
            showHeader: true,
            //fitColumns: true,
            columns: [[
                { field: 'userCode', title: '����', width: 80, sortable: true },
                { field: 'userName', title: '����', width: 80, sortable: true },
                { field: 'userWard', title: '����', width: 120, sortable: true },
                { field: 'userTitle', title: 'ְ��', width: 80, sortable: true },
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
                //��ȡѡ��ҽ��
                var rows = $('#patientListTable').datagrid("getSelections");    // ��ȡ����ѡ�е���
                var length = rows.length;
                if (length > 0) {
                    var row = rows[0];
                    var episodeID = row["EpisodeID"];
                    expandEMRRangeTree(episodeID);
                }
                */
            }
        });

        /**��ѯ��ť */
        $('#docSearchBtn').on('click', function () {
            searchUser()
        })

        /**�������ֲ�ѯ�� */
        $('#inputDocName').bind('keypress', function (event) {
            if (event.keyCode == "13") {
                searchUser();
            }
        });


        /**��Ȩ��ť */
        $('#doAuthorityBtn').on('click', function () {
            authorityBtn()
        })
        /**��Ȩ��ť */
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
    //���ص���
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
            title: '��ʷ��¼',
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


    /**���½ǲ�����Ȩģ�� ��ѯ�û��ķ��� */
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
    /** �����б�����ѯ�ķ���*/
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
     * ��������б��ѯ�������Ѿ���д�Ļ�����
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
     * ������߼��ػ��ߴ����Ŀ���
     * @param {string} episodeID 
     */
    function initPatWardList(episodeID) {
        $('#inputDocLoc').combobox('clear')
        $('#inputDocLoc').combobox('reload', LINK_CSP + "?className=NurMp.Quality.Service.AuthorityV2&methodName=getPatLocList&parameter1=" + episodeID)
        $('#docListTable').datagrid('loadData', [])
    }
    function ApplyBtn() {
	    var allChecked = $('#emrTree').tree('getChecked')
	    //��ȡѡ�еĻ�����ģ��
        var emrCodeList = []
        for (var single in allChecked) {
            if (!(allChecked[single].children)) {
                emrCodeList.push(allChecked[single].id)
            }
        }
        //��ȡѡ�����Ȩ��������
        var givePowerTypeList = []
        var givePowerTypeGridRows = $('#inputGivePowerType').combogrid('grid').datagrid("getChecked");
        for (var curIndex in givePowerTypeGridRows) {
            var givePowerTypeGridRow = givePowerTypeGridRows[curIndex]
            var value = givePowerTypeGridRow["value"];
            givePowerTypeList.push(value)
        }
         if (emrCodeList.length == 0) {
            $.messager.alert($g("��ʾ"), $g("����ģ����б�������ѡ��һ��ģ�壡"), "error")
            return
        }
        else if (givePowerTypeList.length == 0) {
            $.messager.alert($g("��ʾ"), $g("��ѡ������һ���������ͣ�"), "error")
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
            var record = $('#patientListTable').datagrid("getSelected");    // ��ȡ����ѡ�е���
            if (record == null) {
                $.messager.alert($g("��ʾ"), $g("��ѡ��һ�����ߣ�"), "error")
                return
            }
        }
        var allChecked = $('#emrTree').tree('getChecked')
        //��ȡѡ�еĻ�����ģ��
        var emrCodeList = []
        for (var single in allChecked) {
            if (!(allChecked[single].children)) {
                emrCodeList.push(allChecked[single].id)
            }
        }
        if (emrCodeList.length == 0) {
            $.messager.alert($g("��ʾ"), $g("����ģ����б�������ѡ��һ��ģ�壡"), "error")
            return
        }
        //��ȡѡ�����Ȩ��������
        var givePowerTypeList = []
        var givePowerTypeGridRows = $('#inputGivePowerType').combogrid('grid').datagrid("getChecked");
        for (var curIndex in givePowerTypeGridRows) {
            var givePowerTypeGridRow = givePowerTypeGridRows[curIndex]
            var value = givePowerTypeGridRow["value"];
            givePowerTypeList.push(value)
        }
        if (givePowerTypeList.length == 0) {
            $.messager.alert($g("��ʾ"), $g("��ѡ������һ���������ͣ�"), "error")
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
                $.messager.alert($g("��ʾ"), $g("����ɹ�"), "success")
                $('#ApplyDialog').dialog('close');
                $('#emrTree').tree("reload")
            } else {
                $.messager.alert($g("��ʾ"), data, "error")
            }
        })
    }
    /** ��Ȩ��ť*/
    function authorityBtn() {
        var record = $('#patientListTable').datagrid("getSelected");    // ��ȡ����ѡ�е���
        if (record == null) {
            $.messager.alert($g("��ʾ"), $g("��ѡ��һ�����ߣ�"), "error")
            return
        }
        var EpisodeID = record["episodeID"]
        var allChecked = $('#emrTree').tree('getChecked')
        //��ȡѡ�еĻ�����ģ��
        var emrCodeList = []
        for (var single in allChecked) {
            if (!(allChecked[single].children)) {
                emrCodeList.push(allChecked[single].id)
            }
        }
        if (emrCodeList.length == 0) {
            $.messager.alert($g("��ʾ"), $g("����ģ����б�������ѡ��һ��ģ�壡"), "error")
            return
        }
        //��ȡѡ�����Ȩ��������
        var givePowerTypeList = []
        var givePowerTypeGridRows = $('#inputGivePowerType').combogrid('grid').datagrid("getChecked");
        for (var curIndex in givePowerTypeGridRows) {
            var givePowerTypeGridRow = givePowerTypeGridRows[curIndex]
            var value = givePowerTypeGridRow["value"];
            givePowerTypeList.push(value)
        }
        if (givePowerTypeList.length == 0) {
            $.messager.alert($g("��ʾ"), $g("��ѡ������һ���������ͣ�"), "error")
            return
        }
        //��ȡѡ�����Ȩ��
        var userRecord = $('#docListTable').datagrid("getSelected");    // ��ȡ����ѡ�е���
        if (userRecord == null) {
            $.messager.alert($g("��ʾ"), $g("��ѡ��Ҫ��Ȩ���ˣ�"), "error")
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
                    $.messager.alert($g("��ʾ"), $g("��Ȩ�ɹ�"), "success")
                    $('#emrTree').tree("reload")
                } else {
                    $.messager.alert($g("��ʾ"), data, "error")
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
    ///��������Ϣ��ֵ����ͷ
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