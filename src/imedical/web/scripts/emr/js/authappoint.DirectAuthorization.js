var eprDirectAuthorization = new Object();

eprDirectAuthorization.selectPatientLocID = appointUserLoc;
eprDirectAuthorization.selectPatientWardID = "";
eprDirectAuthorization.selectDocLocID = "";
eprDirectAuthorization.selectSSGroupID = "";

(function($) {
    $(function() {
        //默认收起east的授权目录树
        $('body').layout('collapse', 'east');

        //患者查询列表
        var patientDG = $('#patientListTable').datagrid({
            url: '../EMRservice.Ajax.AuthDirectAppoint.cls',
            queryParams: {
                PatientName: '',
                PatientLocID: '',
                PatientWardID: '',
                EpisodeID: '',
                PatientID: '',
                RegNo: '',
                onlyCurrentDept: onlyCurrentDept
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
            title: titltObjName,
            onClickRow: function(rowIndex, rowData) {
                //选中患者
                var episodeID = rowData["EpisodeID"];
                //获取选中医生
                var rows = $('#docListTable').datagrid("getSelections");    // 获取所有选中的行
                var length = rows.length;
                if (length > 0) {
                    expandEMRRangeTree(episodeID);
                }
            },
			onBeforeLoad: function(param){
				$('#patientListTable').datagrid('loadData',{total:0,rows:[]});
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
			$('#inputMedicareNo').val('');
			//默认值查询当前登录科室的患者  add by niucaicai 2016-8-5 去掉科室下拉框、患者病区下拉框
            //$('#inputPatientLoc').combogrid("setValue", '');
            //$('#inputPatientWard').combogrid("setValue", '');  
            eprDirectAuthorization.selectPatientLocID = appointUserLoc;
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
			//默认值查询当前登录科室的患者  add by niucaicai 2016-8-5 去掉科室下拉框、患者病区下拉框
			//queryParams.PatientLocID = $('#inputPatientLoc').combobox('getValue');
            //queryParams.PatientWardID = $('#inputPatientWard').combobox('getValue');
			queryParams.PatientLocID = appointUserLoc;
			queryParams.PatientWardID = "";
            queryParams.PatientName = $('#inputPatientName').val();
            queryParams.EpisodeID = $('#inputPatientEpisodeID').val();
            queryParams.PatientID = $('#inputPatientID').val();
            queryParams.RegNo = $('#inputPatientRegNo').val();
			queryParams.MedicareNo = $('#inputMedicareNo').val();   //增加病案号查询 add by niucaicai 2016-3-31
            $('#patientListTable').datagrid('options').queryParams = queryParams;
            $('#patientListTable').datagrid('load');
        }
		searchPatient();  //默认值查询当前登录科室的患者  add by niucaicai 2016-8-5 去掉科室下拉框、患者病区下拉框
        //医生查询列表
        var docDG = $('#docListTable').datagrid({
            url: '../EMRservice.Ajax.AuthDirectAppoint.cls',
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
            },
			onBeforeLoad: function(param){
				$('#docListTable').datagrid('loadData',{total:0,rows:[]});
			}
        });


        //选择医生所在科室
        $('#inputDocLoc').combogrid({
            //url: '../web.eprajax.DicList.cls',
			url: '../EMRservice.Ajax.AuthDirectAppoint.cls',
            queryParams: {
				Action: 'getdiclist',
                DicCode: 'S07',
                Filter: ''
            },
            panelWidth: 300,
            idField: 'ID',
            textField: 'DicDesc',
            method: 'get',
			mode: 'remote',
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
				/*
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
			*/
            onSelect: function() {
                eprDirectAuthorization.selectDocLocID = "";
                var rows = $('#inputDocLoc').combogrid('grid').datagrid('getSelections');
                var row = rows[0];
                eprDirectAuthorization.selectDocLocID = row["ID"];
                searchDoc();
            },
			onBeforeLoad:function(param){
				param = $.extend(param,{Filter:param.q});
				return true;
			},
			onShowPanel:function(){
				$('#inputDocLoc').combogrid('grid').datagrid('load');
			}
        });

        //选择医生所在安全组
        $('#inputDocSSGroup').combogrid({
            //url: '../web.eprajax.DicList.cls',
			url: '../EMRservice.Ajax.AuthDirectAppoint.cls',
            queryParams: {
                Action: 'ssgroup',
                Filter: ''
            },
            panelWidth: 300,
            idField: 'ID',
            textField: 'DicDesc',
            method: 'get',
			mode: 'remote',
            showHeader: false,
            fitColumns: true,
            columns: [[
                { field: 'ID', title: 'ID', width: 80, hidden: true },
                { field: 'DicDesc', title: 'DicDesc', width: 250 }
            ]],
            pagination: true,
            pageSize: 10,
            pageList: [5, 10, 20],
			/*
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
			*/
            onSelect: function() {
                eprDirectAuthorization.selectSSGroupID = "";
                var rows = $('#inputDocSSGroup').combogrid('grid').datagrid('getSelections');
                var row = rows[0];
                eprDirectAuthorization.selectSSGroupID = row["ID"];
                searchDoc();
            },
			onBeforeLoad:function(param){
				param = $.extend(param,{Filter:param.q});
				return true;
			},
			onShowPanel:function(){
				$('#inputDocSSGroup').combogrid('grid').datagrid('load');
			}
        });

        function searchDoc() {
            var queryParams = $('#docListTable').datagrid('options').queryParams;
            //queryParams.DocLocID = eprDirectAuthorization.selectDocLocID;
            //queryParams.DocSSGroupID = eprDirectAuthorization.selectSSGroupID;
			queryParams.DocLocID = $('#inputDocLoc').combobox('getValue');
            queryParams.DocSSGroupID = $('#inputDocSSGroup').combobox('getValue');
            queryParams.DocUserCode = $('#inputDocUserCode').val();
            queryParams.DocUserName = $('#inputDocName').val();

            $('#docListTable').datagrid('options').queryParams = queryParams;
            $('#docListTable').datagrid('load');
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
			//获取选中医生,根据被授权的医生能够看到的病历展现结构进行授权
            var rows = $('#docListTable').datagrid("getSelections");
			var selectedDocID = rows[0]["SSUserID"];
			var selecteddocCTLocID= rows[0]["CTLocID"];
			var selecteddocSSGroupID= rows[0]["SSGroupID"];
			
            $('#emrTree').tree({
                //url: '../web.eprajax.GivePower.cls?Action=tree&EpisodeID=' + episodeID,
				url: '../EMRservice.Ajax.AuthDirectAppoint.cls?Action=gettree&EpisodeID=' + episodeID + '&selectedDocID=' + selectedDocID + '&selecteddocCTLocID=' + selecteddocCTLocID + '&selecteddocSSGroupID=' + selecteddocSSGroupID,
                method: 'get',
                animate: true,
                checkbox: true,
		checked: false,
                cascadeCheck: true
            });
        }

        //给予操作类型
        $('#inputGivePowerType').combogrid({
            idField: 'id',
            textField: 'text',
            data: [{
                id: '1',
                text: '保存',
                value: 'save'
            }, {
                id: '2',
                text: '打印',
                value: 'print'
            }, {
                id: '3',
                text: '删除',
                value: 'delete'
            }, {
                id: '4',
                text: '查看病历',
                value: 'view'
            }, {
                id: '5',
                text: '创建病历',
                value: 'new'
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
                    //$('#inputGivePowerType').combogrid('grid').datagrid('selectAll');
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
				var msgGridDataArray = new Array();
                var nodes = $('#emrTree').tree('getChecked');
                for (var i = 0; i < nodes.length; i++) {
                    if (nodes[i]["attributes"]["type"] == "cc" || nodes[i]["attributes"]["type"] == "ct") {
                        if (appointCateCharpter == "") {
                            appointCateCharpter = nodes[i]["id"];
                            appointCateCharpterText = nodes[i]["text"];
                        }
                        else {
                            appointCateCharpter = appointCateCharpter + "^" + nodes[i]["id"];
                            appointCateCharpterText = appointCateCharpterText + "，" + nodes[i]["text"];
                        }
						var msgGridData = {"recordName":nodes[i]["text"]};
						msgGridDataArray.push(msgGridData);
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
                        givePowerTypes = givePowerTypes + "," + value;
                        givePowerTypesText = givePowerTypesText + "," + text;
                    }
                }
                if (givePowerTypes == "") {
                    $.messager.alert('错误', '请至少选择一个授权操作！', 'error');
                    return;
                }
				
				//liuzhongwan检查是否为实例授予了创建权限
				if ((appointCateCharpter.indexOf("||") != -1) && (givePowerTypes == "new")) {
					$.messager.alert('错误', '不能为实例病历授予创建权限，请重新选择！', 'error');
                    return;
				}
				//end liuzhongwan
				
                
				//modify by niucaicai 2016-5-25
				/*
				var msg = "<p>给予医生： 《" + docName + "》 </p>"
                         + "<p>患者： 《" + patientName + "》 </p>"
                         + "<p>操作： 《" + givePowerTypesText + "》 </p>"
						 + "<div style='height:300px;overflow-y:auto'>"
                         + "<p>范围： 《" + appointCateCharpterText + "》 </p></div>";
                $.messager.confirm('确认给予权限', msg, function(r) {
                    if (r) {
                        var ret = ""
                        var obj = $.ajax({
                            url: "../EMRservice.Ajax.AuthDirectAppoint.cls?Action=givepower&AppointSpan=" + givePowerSpan + "&AppointCateCharpter=" + appointCateCharpter + "&AppointUserID=" + userID + "&EPRAcitons=" + givePowerTypes + "&EpisodeID=" + episodeID + "&UserID=" + docUserID + "&DocLocID=" + docCTLocID,
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
				*/
				$('#MessageWin').window({
					width: 350,
					height: 550,
					modal: true,
					closed: true,
					collapsible: false,
					minimizable: false,
					maximizable: false,
					closable: true,
					title: '确认给予权限'
				});
				$('#MessageWin').window('open');
				$('#MsgDocName').html(docName);
				$('#MsgPatName').html(patientName);
				$('#actionsName').html(givePowerTypesText);
				var MessageWinCount = 0;
				$('#MsgWinTable').datagrid({
					data:msgGridDataArray,
					showHeader: true,
					striped: true,
					fitColumns: true,
					columns: [[
						{ field: 'recordName', title: '给予病历范围', width: 80}
					]]
				});
				
				$('#MsgBtnOK').on('click', function() {
					//alert("num:" + MessageWinCount);
					if (MessageWinCount > 0)
					{
						$('#MessageWin').window('close');
						return;
					}
					
					var ret = "";
					var obj = $.ajax({
						url: "../EMRservice.Ajax.AuthDirectAppoint.cls?Action=givepower&AppointSpan=" + givePowerSpan + "&AppointCateCharpter=" + appointCateCharpter + "&AppointUserID=" + userID + "&EPRAcitons=" + givePowerTypes + "&EpisodeID=" + episodeID + "&UserID=" + docUserID + "&DocLocID=" + docCTLocID,
						type: 'post',
						async: false
					});
					var ret = obj.responseText;
					//alert("houtai:"+ret);
					if ((ret != "" || (ret != null)) && (ret != "-1")) {
						$.messager.alert('完成', '授权成功！', 'info');
						$('#MessageWin').window('close');
					}
					else {
						$.messager.alert('错误', '授权失败，请再次尝试！', 'error');
					}
					MessageWinCount = MessageWinCount + 1;
				});
            });
			
			$('#MsgBtnCancel').on('click', function() {
				$('#MessageWin').window('close');
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
                url: '../EMRservice.Ajax.AuthDirectAppoint.cls',
                queryParams: {
                    Action: 'history',
                    IsValid: 'all'
                },
                method: 'post',
                loadMsg: '数据装载中......',
                showHeader: true,
                multiple: true,
                fitColumns: true,
                columns: [
					[
                        { field: 'ck', checkbox: true },
                        { field: 'AppointID', title: 'AppointID', width: 80, hidden: true },
                        { field: 'IsValid', title: '生效类型', width: 70 },
                        { field: 'AppointDateTime', title: '授权给予时间', width: 135 },
                        { field: 'AppointEndDateTime', title: '授权结束时间', width: 135 },
                        { field: 'AppointUserID', title: '授权者', width: 80, hidden: true },
                        { field: 'AppointUserName', title: '授权者', width: 70 },
                        //{ field: 'AppointCateCharpter', title: '授权范围', width: 80, hidden: true },
                        //{ field: 'AppointCateCharpterText', title: '授权范围', width: 80 },
                        //{ field: 'EPRAction', title: '授权操作', width: 80, hidden: true },
                        //{ field: 'EPRActionText', title: '授权操作', width: 80 },
			            { field: 'PAPMIName', title: '患者姓名', width: 70 },
			            { field: 'PatientID', title: '患者号', width: 70 },
			            { field: 'PAPMINO', title: '登记号', width: 70 },
			            { field: 'PAAdmType', title: '就诊类型', width: 70 },
                        { field: 'EpisodeID', title: '就诊指针', width: 80, hidden: true },
                        { field: 'RequestUserID', title: '给予的医生ID', width: 80, hidden: true },
                        { field: 'RequestUserName', title: '给予的医生', width: 80 },
                        { field: 'RequestUserCTLocID', title: '给予的医生所在科室ID', width: 80, hidden: true },
                        { field: 'RequestUserCTLocName', title: '给予的医生所在科室', width: 120 },
						{ field: 'DetailData', title: '详情', width: 80, hidden: true },
                    ]
				],
				view:detailview,
				detailFormatter:function(index,row){
					return '<table id="DatagridDetail' + index + '"></table>'
				},
				onExpandRow: function(index,row){
					$('#DatagridDetail' + index).datagrid({
						autoHeight:250,
						width:940,
						//title:"操作明细",
						striped:true,
						singleSelect:true,
						columns:[
							[
								{ field: 'CateCharpter', title: '授权病历', width: 80, hidden: true },
								{ field: 'CCDesc', title: '授权病历', width: 240 },
								{ field: 'CCDateTime', title: '书写日期', width: 150 },
								{ field: 'CCCreator', title: '创建者', width: 70 },
								{ field: 'ActionStr', title: '授权操作', width: 80, hidden: true },
								{ field: 'ActionDescStr', title: '授权操作', width: 150 },
							]
						]
					}),
					InitDatagridDetail(index,row)
				},
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
                    text: '过期'
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
						//过期的条目不能进行撤销，并给予提示
						if (gridRow["IsValid"] == "过期")
						{
							var number = i+1
							var message = '您选中的第' + number + '条已过期,不能撤销！'
							alert( message);
							continue;
						}
						else if (gridRow["IsValid"] == "生效中")
						{
							var appointID = gridRow["AppointID"];
							if (appointIDs == "") {
								appointIDs = appointID;
							}
							else {
								appointIDs = appointIDs + "^" + appointID;
							}
						}
                    }
					if (appointIDs == "") {
						alert('请至少选择一条 生效中 的记录！');
						return;
					}
					else
						{
						$.messager.confirm('确认撤销权限', '确实要收回选中的 生效中 授权？', function(r) {
							if (r) {
								var ret = ""
								var obj = $.ajax({
									url: "../EMRservice.Ajax.AuthDirectAppoint.cls?Action=withdraw&AppointIDs=" + appointIDs,
									type: 'post',
									async: false
								});
								var ret = obj.responseText;
								if ((ret != "" || (ret != null)) && (ret != "-1")) {
									//采用$.messager.alert()的方式提示，会出现datagrid不去reload的情况！
									alert("撤销成功！");
									$('#historyTable').datagrid('reload');
								}
								else {
									$.messager.alert('错误', '撤销失败，请再次尝试！', 'error');
								}
							}
						});
					}
                });
            });

        })(jQuery);
function InitDatagridDetail(index,row)
{
	var DetailJson,DetailData={rows:[],total:0};
	
	if (!!row["DetailData"]){
		DetailJson=row["DetailData"]
		try{
			eval(DetailJson);
		}catch(e){}
	}
	
	for (var p in DetailJson){
		//DetailData.rows.push({"key":p,"value":DetailJson[p]});
		DetailData.rows.push(DetailJson[p]);
		DetailData.total++;
	}
	$('#DatagridDetail' + index).datagrid("loadData",DetailData);
}
