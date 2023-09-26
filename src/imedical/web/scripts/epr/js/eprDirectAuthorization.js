var eprDirectAuthorization = new Object();

eprDirectAuthorization.selectPatientLocID = "";
eprDirectAuthorization.selectPatientWardID = "";
eprDirectAuthorization.selectDocLocID = "";
eprDirectAuthorization.selectSSGroupID = "";

(function($) {
    $(function() {
        //默认收起east的授权目录树
        $('body').layout('collapse', 'east');

        //患者查询列表
        var patientDG = $('#patientListTable').datagrid({
            url: '../web.eprajax.GivePower.cls',
            queryParams: {
                PatientName: '',
                PatientLocID: '',
                PatientWardID: '',
                EpisodeID: '',
                PatientID: '',
                RegNo: ''
            },
            method: 'post',
            loadMsg: '数据装载中......',
            singleSelect: true,
            showHeader: true,
            fitColumns: true,
            columns: [[
                { field: 'PAStatusType', title: '在院状态', width: 80, sortable: true },
				{ field: 'MedicareNo', title: '病案号', width: 80, sortable: true },   //增加病案号查询 add by niucaicai 2016-3-31
                { field: 'PAAdmType', title: '就诊类型', width: 80, sortable: true },
                { field: 'PAPMIName', title: '病人姓名', width: 80, sortable: true },
                { field: 'PAPMINO', title: '登记号', width: 80, sortable: true },
                { field: 'PAPMIDOB', title: '出生日期', width: 80, sortable: true },
                { field: 'PAPMIAge', title: '年龄', width: 80, sortable: true },
                { field: 'PAPMISex', title: '性别', width: 80, sortable: true },
                { field: 'PAAdmDateTime', title: '入院时间', width: 80, sortable: true },
                { field: 'PAAdmWard', title: '病区', width: 80, sortable: true },
                { field: 'PAAdmRoom', title: '病房', width: 80, sortable: true },
                { field: 'PAAdmBed', title: '病床', width: 80, sortable: true },
                { field: 'PAAdmLoc', title: '科室', width: 80, sortable: true },
                { field: 'PADischgeDateTime', title: '出院时间', width: 80, sortable: true },
                { field: 'PAAdmDoc', title: '医生', width: 80, sortable: true },
                { field: 'PayMode', title: '付费类型', width: 80, sortable: true },
                { field: 'EpisodeID', title: '就诊号', width: 80, sortable: true },
                { field: 'PatientID', title: '病人号', width: 80, sortable: true }
            ]],
            pagination: true,
            pageSize: 20,
            pageList: [10, 20, 50],
            pagePosition: 'bottom',
            toolbar: '#patientListTableTBar',
            title: '患者查询',
            onClickRow: function(rowIndex, rowData) {
                //选中患者
                var episodeID = rowData["EpisodeID"];
                //获取选中医生
                var rows = $('#docListTable').datagrid("getSelections");    // 获取所有选中的行
                var length = rows.length;
                if (length > 0) {
                    expandEMRRangeTree(episodeID);
                }
            }
        });

        //选择患者就诊科室
        $('#inputPatientLoc').combogrid({
            url: '../web.eprajax.DicList.cls',
            queryParams: {
                DicCode: 'S07',
                Filter: ''
            },
            panelWidth: 300,
            idField: 'ID',
            textField: 'DicDesc',
            method: 'get',
            showHeader: false,
            fitColumns: true,
            columns: [[
                { field: 'ID', title: 'ID', width: 80, hidden: true },
                { field: 'DicAlias', title: 'DicAlias', width: 80, hidden: true },
                { field: 'DicCode', title: 'DicCode', width: 80, hidden: true },
                { field: 'DicDesc', title: 'DicDesc', width: 250 }
            ]],
            pagination: true,
            pageSize: 10,
            pageList: [5, 10, 20],
            keyHandler: {
                query: function(q) {
                    //动态搜索
                    var queryParams = $('#inputPatientLoc').combogrid('grid').datagrid('options').queryParams;
                    queryParams.Filter = q;
                    $('#inputPatientLoc').combogrid('grid').datagrid('options').queryParams = queryParams;
                    $('#inputPatientLoc').combogrid('grid').datagrid('reload');
                    $('#inputPatientLoc').combogrid("setValue", q);
                }
            },
            onSelect: function() {
                eprDirectAuthorization.selectPatientLocID = "";
                var rows = $('#inputPatientLoc').combogrid('grid').datagrid('getSelections');
                var row = rows[0];
                eprDirectAuthorization.selectPatientLocID = row["DicCode"];
                searchPatient();
            }
        });

        //选择患者就诊病区
        $('#inputPatientWard').combogrid({
            url: '../web.eprajax.DicList.cls',
            queryParams: {
                DicCode: 'S10',
                Filter: ''
            },
            panelWidth: 300,
            idField: 'ID',
            textField: 'DicDesc',
            method: 'get',
            showHeader: false,
            fitColumns: true,
            columns: [[
                { field: 'ID', title: 'ID', width: 80, hidden: true },
                { field: 'DicAlias', title: 'DicAlias', width: 80, hidden: true },
                { field: 'DicCode', title: 'DicCode', width: 80, hidden: true },
                { field: 'DicDesc', title: 'DicDesc', width: 250 }
            ]],
            pagination: true,
            pageSize: 10,
            pageList: [5, 10, 20],
            keyHandler: {
                query: function(q) {
                    //动态搜索
                    var queryParams = $('#inputPatientWard').combogrid('grid').datagrid('options').queryParams;
                    queryParams.Filter = q;
                    $('#inputPatientWard').combogrid('grid').datagrid('options').queryParams = queryParams;
                    $('#inputPatientWard').combogrid('grid').datagrid('reload');
                    $('#inputPatientWard').combogrid("setValue", q);
                }
            },
            onSelect: function() {
                eprDirectAuthorization.selectPatientWardID = "";
                var rows = $('#inputPatientWard').combogrid('grid').datagrid('getSelections');
                var row = rows[0];
                eprDirectAuthorization.selectPatientWardID = row["DicCode"];
                searchPatient();
            }
        });

        //查询患者
        $('#patientSearchBtn').on('click', function() {
            //debugger;
            searchPatient();
        });

        //清空患者查询条件
        $('#patientResetBtn').on('click', function() {
            $('#inputPatientName').val('');
            $('#inputPatientEpisodeID').val('');
            $('#inputPatientRegNo').val('');
            $('#inputPatientID').val('');
            $('#inputPatientLoc').combogrid("setValue", '');
            $('#inputPatientWard').combogrid("setValue", '');
            eprDirectAuthorization.selectPatientLocID = "";
            eprDirectAuthorization.selectPatientWardID = "";
        });

        //输入框enter事件
        $('#inputPatientName').bind('keypress', function(event) {
            if (event.keyCode == "13") {
                searchPatient();
            }
        });

        $('#inputPatientEpisodeID').bind('keypress', function(event) {
            if (event.keyCode == "13") {
                searchPatient();
            }
        });

        $('#inputPatientID').bind('keypress', function(event) {
            if (event.keyCode == "13") {
                searchPatient();
            }
        });

        $('#inputPatientRegNo').bind('keypress', function(event) {
            if (event.keyCode == "13") {
                searchPatient();
            }
        });
		//增加病案号查询 add by niucaicai 2016-3-31
		$('#inputMedicareNo').bind('keypress', function(event) {
            if (event.keyCode == "13") {
                searchPatient();
            }
        });

        function searchPatient() {
            var queryParams = $('#patientListTable').datagrid('options').queryParams;
            queryParams.PatientLocID = eprDirectAuthorization.selectPatientLocID;
            queryParams.PatientWardID = eprDirectAuthorization.selectPatientWardID;
            queryParams.PatientName = $('#inputPatientName').val();
            queryParams.EpisodeID = $('#inputPatientEpisodeID').val();
            queryParams.PatientID = $('#inputPatientID').val();
            queryParams.RegNo = $('#inputPatientRegNo').val();
			queryParams.MedicareNo = $('#inputMedicareNo').val();   //增加病案号查询 add by niucaicai 2016-3-31
            $('#patientListTable').datagrid('options').queryParams = queryParams;
            $('#patientListTable').datagrid('reload');
        }

        //医生查询列表
        var docDG = $('#docListTable').datagrid({
            url: '../web.eprajax.GivePower.cls',
            queryParams: {
                Action: 'doclist',
                DocSSGroupID: '',
                DocLocID: '',
                DocUserCode: '',
                DocUserName: ''
            },
            method: 'post',
            loadMsg: '数据装载中......',
            singleSelect: true,
            showHeader: true,
            fitColumns: true,
            columns: [[
                { field: 'SSUserID', title: '用户ID', width: 80, sortable: true },
                { field: 'UserName', title: '医生名字', width: 80, sortable: true },
                { field: 'UserCode', title: '医生用户名', width: 80, sortable: true },
                { field: 'CTLocID', title: '医生所属科室ID', width: 80, sortable: true },
                { field: 'SSGroupID', title: '医生所属安全组ID', width: 80, sortable: true },
                { field: 'CTLoc', title: '医生所属科室', width: 80, sortable: true },
                { field: 'SSGroup', title: '医生所属安全组', width: 80, sortable: true }
            ]],
            pagination: true,
            pageSize: 20,
            pageList: [10, 20, 50],
            pagePosition: 'bottom',
            toolbar: '#docListTableTBar',
            title: '医生查询',
            onClickRow: function(rowIndex, rowData) {
                //获取选中医生
                var rows = $('#patientListTable').datagrid("getSelections");    // 获取所有选中的行
                var length = rows.length;
                if (length > 0) {
                    var row = rows[0];
                    var episodeID = row["EpisodeID"];
                    expandEMRRangeTree(episodeID);
                }
            }
        });


        //选择医生所在科室
        $('#inputDocLoc').combogrid({
            url: '../web.eprajax.DicList.cls',
            queryParams: {
                DicCode: 'S07',
                Filter: ''
            },
            panelWidth: 300,
            idField: 'ID',
            textField: 'DicDesc',
            method: 'get',
            showHeader: false,
            fitColumns: true,
            columns: [[
                { field: 'ID', title: 'ID', width: 80, hidden: true },
                { field: 'DicAlias', title: 'DicAlias', width: 80, hidden: true },
                { field: 'DicCode', title: 'DicCode', width: 80, hidden: true },
                { field: 'DicDesc', title: 'DicDesc', width: 250 }
            ]],
            pagination: true,
            pageSize: 10,
            pageList: [5, 10, 20],
            keyHandler: {
                query: function(q) {
                    //动态搜索
                    var queryParams = $('#inputDocLoc').combogrid('grid').datagrid('options').queryParams;
                    queryParams.Filter = q;
                    $('#inputDocLoc').combogrid('grid').datagrid('options').queryParams = queryParams;
                    $('#inputDocLoc').combogrid('grid').datagrid('reload');
                    $('#inputDocLoc').combogrid("setValue", q);
                }
            },
            onSelect: function() {
                eprDirectAuthorization.selectDocLocID = "";
                var rows = $('#inputDocLoc').combogrid('grid').datagrid('getSelections');
                var row = rows[0];
                eprDirectAuthorization.selectDocLocID = row["DicCode"];
                searchDoc();
            }
        });

        //选择医生所在安全组
        $('#inputDocSSGroup').combogrid({
            url: '../web.eprajax.DicList.cls',
            queryParams: {
                Action: 'ssgroup',
                Filter: ''
            },
            panelWidth: 300,
            idField: 'ID',
            textField: 'DicDesc',
            method: 'get',
            showHeader: false,
            fitColumns: true,
            columns: [[
                { field: 'ID', title: 'ID', width: 80, hidden: true },
                { field: 'DicDesc', title: 'DicDesc', width: 250 }
            ]],
            pagination: true,
            pageSize: 10,
            pageList: [5, 10, 20],
            keyHandler: {
                query: function(q) {
                    //动态搜索
                    var queryParams = $('#inputDocSSGroup').combogrid('grid').datagrid('options').queryParams;
                    queryParams.Filter = q;
                    $('#inputDocSSGroup').combogrid('grid').datagrid('options').queryParams = queryParams;
                    $('#inputDocSSGroup').combogrid('grid').datagrid('reload');
                    $('#inputDocSSGroup').combogrid("setValue", q);
                }
            },
            onSelect: function() {
                eprDirectAuthorization.selectSSGroupID = "";
                var rows = $('#inputDocSSGroup').combogrid('grid').datagrid('getSelections');
                var row = rows[0];
                eprDirectAuthorization.selectSSGroupID = row["ID"];
                searchDoc();
            }
        });

        function searchDoc() {
            var queryParams = $('#docListTable').datagrid('options').queryParams;
            queryParams.DocLocID = eprDirectAuthorization.selectDocLocID;
            queryParams.DocSSGroupID = eprDirectAuthorization.selectSSGroupID;
            queryParams.DocUserCode = $('#inputDocUserCode').val();
            queryParams.DocUserName = $('#inputDocName').val();

            $('#docListTable').datagrid('options').queryParams = queryParams;
            $('#docListTable').datagrid('reload');
        }

        //查询医生
        $('#docSearchBtn').on('click', function() {
            //debugger;
            searchDoc();
        });

        //清空医生查询条件
        $('#docResetBtn').on('click', function() {
            $('#inputDocUserCode').val('');
            $('#inputDocName').val('');
            $('#inputDocLoc').combogrid("setValue", '');
            $('#inputDocSSGroup').combogrid("setValue", '');
            eprDirectAuthorization.selectDocLocID = "";
            eprDirectAuthorization.selectSSGroupID = "";
        });

        //输入框enter事件
        $('#inputDocUserCode').bind('keypress', function(event) {
            if (event.keyCode == "13") {
                searchDoc();
            }
        });

        $('#inputDocName').bind('keypress', function(event) {
            if (event.keyCode == "13") {
                searchDoc();
            }
        });

        function expandEMRRangeTree(episodeID) {
            //展开east的授权目录树
            $('body').layout('expand', 'east');

            //加载树
            $('#emrTree').tree({
                url: '../web.eprajax.GivePower.cls?Action=tree&EpisodeID=' + episodeID,
                method: 'get',
                animate: true,
                checkbox: true,
                cascadeCheck: true
            });
        }

        //给予操作类型
        $('#inputGivePowerType').combogrid({
            idField: 'id',
            textField: 'text',
            data: [{
                id: '1',
                text: '界面模板浏览',
                value: 'view'
            }, {
                id: '2',
                text: '保存',
                value: 'save'
            }, {
                id: '3',
                text: '打印',
                value: 'print'
            }, {
                id: '4',
                text: '提交',
                value: 'commit'
            }, {
                id: '5',
                text: '选择模板',
                value: 'switch'
            }, {
                id: '6',
                text: '更新模板',
                value: 'switchtemplate'
            }, {
                id: '7',
                text: '主任医师签名',
                value: 'chiefcheck'
            }, {
                id: '8',
                text: '主治医生签名',
                value: 'attendingcheck'
            }, {
                id: '9',
                text: '病历浏览',
                value: 'browse'
}],
                panelWidth: 300,
                showHeader: true,
                multiple: true,
                columns: [[
                { field: 'ck', checkbox: true },
                { field: 'id', title: 'id', width: 80, hidden: true },
                { field: 'value', title: 'value', width: 80, hidden: true },
                { field: 'text', title: '操作类型', width: 250 }
            ]],
                onLoadSuccess: function() {
                    //$('#inputGivePowerType').combogrid('grid').datagrid('selectRecord', 2);
                    $('#inputGivePowerType').combogrid('grid').datagrid('selectAll');
                }
            });

            //授权小时
            $('#inputGivePowerSpan').numberbox({
                min: 0,
                max: 72,
                value: 24
            });

            //授权按钮事件
            $('#treeGivePowerBtn').on('click', function() {
                //获取患者episodeID
                var patientGridRows = $('#patientListTable').datagrid("getSelections");
                var patientGridRow = patientGridRows[0];
                var episodeID = ""
                var patientName = "";
                if (patientGridRows.length == 0) {
                    $.messager.alert('错误', '请选择一位患者！', 'error');
                    return;
                }
                else {
                    episodeID = patientGridRow["EpisodeID"];
                    patientName = patientGridRow["PAPMIName"];
                }
                //获取医生信息
                var docGridRows = $('#docListTable').datagrid("getSelections");
                var docGridRow = docGridRows[0];
                var docUserID = "";
                var docCTLocID = "";
                var docName = "";
                if (docGridRows.length == 0) {
                    $.messager.alert('错误', '请选择一名医生！', 'error');
                    return;
                }
                else {
                    docUserID = docGridRow["SSUserID"];
                    docCTLocID = docGridRow["CTLocID"];
                    docName = docGridRow["UserName"];
                }
                //授权人信息
                var userID = appointUserID;
                var userCTLocID = appointUserLoc;
                //授权范围
                var appointCateCharpter = "";
                var appointCateCharpterText = "";
                var nodes = $('#emrTree').tree('getChecked');
                for (var i = 0; i < nodes.length; i++) {
                    if (nodes[i]["type"] == "cc") {
                        if (appointCateCharpter == "") {
                            appointCateCharpter = nodes[i]["id"];
                            appointCateCharpterText = nodes[i]["text"];
                        }
                        else {
                            appointCateCharpter = appointCateCharpter + "^" + nodes[i]["id"];
                            appointCateCharpterText = appointCateCharpterText + "，" + nodes[i]["text"];
                        }
                    }
                }
                if (appointCateCharpter == "") {
                    $.messager.alert('错误', '请至少选择一个授权范围！', 'error');
                    return;
                }
                //授权时间
                var givePowerSpan = "";
                givePowerSpan = $('#inputGivePowerSpan').val();
                if (givePowerSpan == "") {
                    $.messager.alert('错误', '请输入一个有效的授权时间！', 'error');
                    return;
                }
                //授权类型
                var givePowerTypes = "";
                var givePowerTypesText = "";
                var givePowerTypeGridRows = $('#inputGivePowerType').combogrid('grid').datagrid("getChecked");
                for (var j = 0; j < givePowerTypeGridRows.length; j++) {
                    var givePowerTypeGridRow = givePowerTypeGridRows[j];
                    var value = givePowerTypeGridRow["value"];
                    var text = givePowerTypeGridRow["text"];
                    if (givePowerTypes == "") {
                        givePowerTypes = value;
                        givePowerTypesText = text;
                    }
                    else {
                        givePowerTypes = givePowerTypes + "^" + value;
                        givePowerTypesText = givePowerTypesText + "，" + text;
                    }
                }
                if (givePowerTypes == "") {
                    $.messager.alert('错误', '请至少选择一个授权操作！', 'error');
                    return;
                }

                //确认给予权限
                var msg = "<p>确定给予授权？ </p>"
                         + "<p>给予医生： 《" + docName + "》 </p>"
                         + "<p>患者： 《" + patientName + "》 </p>"
                         + "<p>操作： 《" + givePowerTypesText + "》 </p>"
                         + "<p>范围： 《" + appointCateCharpterText + "》 </p>";

                $.messager.confirm('确认给予权限', msg, function(r) {
                    if (r) {
                        var ret = ""
                        var obj = $.ajax({
                            url: "../web.eprajax.GivePower.cls?Action=givepower&AppointSpan=" + givePowerSpan + "&AppointCateCharpter=" + appointCateCharpter + "&AppointUserID=" + userID + "&EPRAcitons=" + givePowerTypes + "&EpisodeID=" + episodeID + "&UserID=" + docUserID + "&DocLocID=" + docCTLocID,
                            type: 'post',
                            async: false
                        });
                        var ret = obj.responseText;
                        if ((ret != "" || (ret != null)) && (ret != "-1")) {
                            $.messager.alert('完成', '授权成功！', 'info');
                        }
                        else {
                            $.messager.alert('错误', '授权失败，请再次尝试！', 'error');
                        }
                    }
                });
            });

            $('#treeHistoryWin').window({
                width: 1000,
                height: 500,
                modal: true,
                closed: true,
                collapsible: false,
                minimizable: false,
                maximizable: false,
                closable: true,
                title: '直接授权历史'
            });

            var historyDG = $('#historyTable').datagrid({
                url: '../web.eprajax.GivePower.cls',
                queryParams: {
                    Action: 'history',
                    IsValid: 'all'
                },
                method: 'post',
                loadMsg: '数据装载中......',
                showHeader: true,
                multiple: true,
                fitColumns: true,
                columns: [[
                        { field: 'ck', checkbox: true },
                        { field: 'AppointID', title: 'AppointID', width: 80, hidden: true },
                        { field: 'IsValid', title: '生效', width: 80 },
                        { field: 'AppointDateTime', title: '授权给予时间', width: 150 },
                        { field: 'AppointEndDateTime', title: '授权结束时间', width: 150 },
                        { field: 'AppointUserID', title: '授权者', width: 80, hidden: true },
                        { field: 'AppointUserName', title: '授权者', width: 80 },
                        { field: 'AppointCateCharpter', title: '授权范围', width: 80, hidden: true },
                        { field: 'AppointCateCharpterText', title: '授权范围', width: 80 },
                        { field: 'EPRAction', title: '授权操作', width: 80, hidden: true },
                        { field: 'EPRActionText', title: '授权操作', width: 80 },
			            { field: 'PAPMIName', title: '患者姓名', width: 80 },
			            { field: 'PatientID', title: '患者号', width: 80 },
			            { field: 'PAPMINO', title: '患者登记号', width: 80 },
			            { field: 'PAAdmType', title: '患者就诊类型', width: 80 },
                        { field: 'EpisodeID', title: '患者就诊号', width: 80 },
                        { field: 'RequestUserID', title: '给予的医生ID', width: 80, hidden: true },
                        { field: 'RequestUserName', title: '给予的医生', width: 80 },
                        { field: 'RequestUserCTLocID', title: '给予的医生所在科室ID', width: 80, hidden: true },
                        { field: 'RequestUserCTLocName', title: '给予的医生所在科室', width: 80 }
                    ]],
                pagination: true,
                pageSize: 20,
                pageList: [10, 20, 50],
                pagePosition: 'bottom',
                toolbar: '#historyTableTBar',
                rowStyler: function(index, row) {
                    if (row["IsValid"] == "生效中") {
                        return 'background-color:#c7dafe;';
                    }
                }
            });

            //过滤记录是否有效
            $('#isCurrentValidSelect').combobox({
                valueField: 'id',
                textField: 'text',
                data: [{
                    id: 'active',
                    text: '生效中'
                }, {
                    id: 'past',
                    text: '已过期'
                }, {
                    id: 'all',
                    text: '全部'
}],
                    onSelect: function(record) {
                        var queryParams = $('#historyTable').datagrid('options').queryParams;
                        queryParams.IsValid = record["id"];
                        $('#historyTable').datagrid('options').queryParams = queryParams;
                        $('#historyTable').datagrid('reload');
                    }
                });

                //授权按钮事件
                $('#treeHistoryBtn').on('click', function() {
                    $('#historyTable').datagrid('reload');
                    $('#treeHistoryWin').window('open');
                });

                //撤销授权按钮事件
                $('#withdrawBtn').on('click', function() {
                    var appointIDs = "";
                    var gridRows = $('#historyTable').datagrid("getChecked");
                    for (var i = 0; i < gridRows.length; i++) {
                        var gridRow = gridRows[i];
                        var appointID = gridRow["AppointID"];
                        if (appointIDs == "") {
                            appointIDs = appointID;
                        }
                        else {
                            appointIDs = appointIDs + "^" + appointID;
                        }
                    }

                    if (appointIDs == "") {
                        $.messager.alert('错误', '请至少选择一条记录！', 'error');
                        return;
                    }

                    $.messager.confirm('确认撤销权限', '确实要收回选中的授权？', function(r) {
                        if (r) {
                            var ret = ""
                            var obj = $.ajax({
                                url: "../web.eprajax.GivePower.cls?Action=withdraw&AppointIDs=" + appointIDs,
                                type: 'post',
                                async: false
                            });
                            var ret = obj.responseText;
                            if ((ret != "" || (ret != null)) && (ret != "-1")) {
                                $.messager.alert('完成', '撤销成功！', 'info');
                                $('#historyTable').datagrid('reload');
                            }
                            else {
                                $.messager.alert('错误', '撤销失败，请再次尝试！', 'error');
                            }
                        }
                    });
                });
            });

        })(jQuery);
