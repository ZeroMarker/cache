var eprMessageSummary = new Object();

eprMessageSummary.selectDocLocID = "";
eprMessageSummary.selectSSGroupID = "";
eprMessageSummary.readFlag = "";
eprMessageSummary.executeFlag = "";
eprMessageSummary.createDateStart = "";
eprMessageSummary.createDateEnd = "";

(function($) {
    $(function() {

        var messageDG = $('#messageListTable').datagrid({
            url: '../web.eprajax.AjaxEPRMessage.cls',
            queryParams: {
                UserID: userID,
				UserType: 'SEND',
				ReadFlag: 'U',
				ExecuteFlag: 'U',
				EffectiveFlag: 'E',
				CreateDateStart: '',
				CreateDateEnd: '',
                Action: 'getmessage'
            },
            method: 'post',
            loadMsg: '加载中......',
            singleSelect: false,
            multiple:true,
            showHeader: true,
            fitColumns: true,
            columns: [[
                { field: 'ck', checkbox: true },
                { field: 'MessageID', title: '消息ID', width: 250, hidden: true },
                { field: 'MessageTitle', title: '消息', width: 250},
                { field: 'Message', title: '消息内容', width: 250, hidden: true },
                { field: 'SenderUserID', title: '发送者ID', width: 80, hidden: true },
                { field: 'SenderUserName', title: '发送者', width: 80, sortable: true, hidden: true },
                { field: 'CreateDateTime', title: '发送日期时间', width: 80, sortable: true},
                { field: 'ReceiverUserID', title: '接收者ID', width: 80, hidden: true },
                { field: 'ReceiverUserName', title: '接收者', width: 80 }, 
				{ field: 'ReadFlag', title: 'ReadFlag', width: 80, hidden: true },
                { field: 'ReadDateTime', title: '阅读日期时间', width: 80},
                { field: 'ExecuteFlag', title: 'ExecuteFlag', width: 80, hidden: true },
                { field: 'ExecuteDateTime', title: '执行日期时间', width: 80},
                { field: 'Effective', title: '生效', width: 80, hidden: true },
                { field: 'EffectiveFlag', title: 'EffectiveFlag', width: 80, hidden: true },
                { field: 'EffectiveDateTime', title: 'EffectiveDateTime', width: 80, hidden: true },
                { field: 'MessageGroupID', title: 'MessageGroupID', width: 80, hidden: true },
                { field: 'MessageType', title: 'MessageType', width: 80, hidden: true },
                { field: 'MessageSource', title: '消息来源', width: 80, sortable: true, hidden: true },
                { field: 'MessagePrioriry', title: 'MessagePrioriry', width: 80, hidden: true },
				{ field: '.,', title: 'EpisodeID', width: 80, hidden: true },
				{ field: '..,', title: 'PatientID', width: 80, hidden: true },
                { field: 'ACKID', title: 'ACKID', width: 80, hidden: true }
            ]],
            pagination: true,
            pageSize: 20,
            pageList: [10, 20, 50],
            pagePosition: 'bottom',
            toolbar: '#messageListTableTBar',
            //title: '消息列表',
            view: detailview,
            detailFormatter: function(rowIndex, rowData){
				var ret = '<div style="font-size:12px;padding:2px;">' +
						  '<div>接收人: ' + rowData.ReceiverUserName + '</div>';

				var readFlag = rowData.ReadFlag
				if (readFlag == "R"){
					ret = ret + '<div><font color="red">已读</font></div>';
					ret = ret + '<div>阅读时间: ' + rowData.ReadDateTime + '</div>';
				}
				else {
					ret = ret + '<div>未读</div>';
				}

				var executeFlag = rowData.ExecuteFlag
				if (executeFlag  == "E"){
					ret = ret + '<div><font color="red">已执行</font></div>';
					ret = ret + '<div>执行时间: ' + rowData.ExecuteDateTime + '</div>';
				}
				else {
					ret = ret + '<div>未执行</div>';
				}

				ret = ret + '<div>消息标题: ' + rowData.MessageTitle + '</div>' +
                            '<div>消息内容: ' + rowData.Message + '</div>' +
                            '</div>';

				return ret;
            },
			onDblClickRow: function(rowIndex, rowData){
				var episodeID = rowData.EpisodeID
				var patientID=rowData.PatientID;
				var url = "dhceprredirect.csp?&EpisodeID="+episodeID+"&PatientID="+patientID;
				window.open (url,'newwindow','height=800,width=1280,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=no') 
				//alert(episodeID);
			}
        });

        //给予操作类型
        $('#inputMessageType').combogrid({
            idField: 'id',
            textField: 'text',
            data: [{
                id: '1',
                text: '未读未执行',
                readFlag: 'U',
				executeFlag: 'U'
            }, {
                id: '2',
                text: '已读',
                readFlag: 'R',
				executeFlag: 'U'
            }, {
                id: '3',
                text: '已执行',
                readFlag: 'R',
				executeFlag: 'E'
			}],
            panelWidth: 300,
            showHeader: false,
			singleSelect: true,
            columns: [[
                { field: 'ck', checkbox: true },
                { field: 'id', title: 'id', width: 80, hidden: true },
                { field: 'value', title: 'value', width: 80, hidden: true },
                { field: 'text', title: '消息类型', width: 250 }
            ]],
			onSelect: function() {
                var rows = $('#inputMessageType').combogrid('grid').datagrid('getChecked');
                var row = rows[0];
                eprMessageSummary.readFlag = row["readFlag"];
                eprMessageSummary.executeFlag = row["executeFlag"];
				eprMessageSummary.createDateStart = $('#inputCreateDateStart').datebox('getValue');
				eprMessageSummary.createDateEnd = $('#inputCreateDateEnd').datebox('getValue');

				refreshGrid();	
            },
			onLoadSuccess: function() {
                $('#inputMessageType').combogrid('grid').datagrid('selectRecord', 1);
            }
        });

		$('#inputCreateDateStart').datebox({    
			onSelect: function() {
				eprMessageSummary.createDateStart = $('#inputCreateDateStart').datebox('getValue');
				refreshGrid();
            }			
		}); 

		$('#inputCreateDateEnd').datebox({    
			onSelect: function() {
				eprMessageSummary.createDateEnd = $('#inputCreateDateEnd').datebox('getValue');
				refreshGrid();
            }			
		}); 		
		
		function refreshGrid(){
			var queryParams = $('#messageListTable').datagrid('options').queryParams;
            queryParams.ReadFlag = eprMessageSummary.readFlag;
            queryParams.ExecuteFlag = eprMessageSummary.executeFlag;
			queryParams.CreateDateStart = eprMessageSummary.createDateStart;
			queryParams.CreateDateEnd = eprMessageSummary.createDateEnd;

            $('#messageListTable').datagrid('options').queryParams = queryParams;
            $('#messageListTable').datagrid('reload');			
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
            //title: '医生查询',
            onClickRow: function(rowIndex, rowData) {
				$('#inputReceiveUserName').val(rowData.UserName);
				$('#inputReceiveUserID').val(rowData.SSUserID);
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
                eprMessageSummary.selectDocLocID = "";
                var rows = $('#inputDocLoc').combogrid('grid').datagrid('getSelections');
                var row = rows[0];
                eprMessageSummary.selectDocLocID = row["DicCode"];
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
                eprMessageSummary.selectSSGroupID = "";
                var rows = $('#inputDocSSGroup').combogrid('grid').datagrid('getSelections');
                var row = rows[0];
                eprMessageSummary.selectSSGroupID = row["ID"];
                searchDoc();
            }
        });

        function searchDoc() {
            var queryParams = $('#docListTable').datagrid('options').queryParams;
            queryParams.DocLocID = eprMessageSummary.selectDocLocID;
            queryParams.DocSSGroupID = eprMessageSummary.selectSSGroupID;
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
            eprMessageSummary.selectDocLocID = "";
            eprMessageSummary.selectSSGroupID = "";
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

        $('#inputPriority').combogrid({
            idField: 'id',
            textField: 'text',
            data: [{
                id: '1',
                text: '重要',
                value: 'E'
            }, {
                id: '2',
                text: '普通',
                value: 'N'
			}],
            panelWidth: 350,
            showHeader: false,
			singleSelect: true,
            columns: [[
                { field: 'ck', checkbox: true },
                { field: 'id', title: 'id', width: 80, hidden: true },
                { field: 'value', title: 'value', width: 80, hidden: true },
                { field: 'text', title: '紧急程度', width: 250 }
            ]],
			onLoadSuccess: function() {
                $('#inputPriority').combogrid('grid').datagrid('selectRecord', 2);
				$('#inputPriorityValue').val("N");
            },
            onSelect: function() {
                var rows = $('#inputPriority').combogrid('grid').datagrid('getChecked');
                var row = rows[0];
                $('#inputPriorityValue').val(row["value"]);
            }
        });	

		$('#sendBtn').on('click', function() {
			var gridRows = $('#docListTable').datagrid("getSelections");
                var gridRow = gridRows[0];
                var receiveUserID = ""
                if (gridRows.length == 0) {
                    $.messager.alert('错误', '请选择一位医生！', 'error');
                    return;
                }
                else {
                    receiveUserID = $('#inputReceiveUserID').val();
                }
				
				var messageHeader = $('#inputMessageHeader').val();
                if (messageHeader == "") {
                    $.messager.alert('错误', '请输入消息标题！', 'error');
                    return;
                }
 
				var message = $('#inputMessage').val();
                if (message == "") {
                    $.messager.alert('错误', '请输入消息内容！', 'error');
                    return;
                }

				var priority = $('#inputPriorityValue').val();

                //确认发送
                var msg = "<p>确定发送消息？ </p>"
                         + "<p>医生： 《" + $('#inputReceiveUserName').val() + "》 </p>"
                         + "<p>消息头： 《" + messageHeader + "》 </p>"
                         + "<p>消息内容： 《" + message + "》 </p>";

                $.messager.confirm('确认发送', msg, function(r) {
                    if (r) {
                        var ret = ""
                        var obj = $.ajax({
                            url: "../web.eprajax.AjaxEPRMessage.cls?Action=send&UserID=" + userID + "&ReceiveUserID=" + receiveUserID + "&MessageHeader=" + encodeURI(messageHeader) + "&Message=" + encodeURI(message) + "&MessageSource=QUALITY&Priority=" + priority,
                            type: 'post',
                            async: false
                        });
                        var ret = obj.responseText;
                        if ((ret != "" || (ret != null)) && (ret != "-1")) {
                            $.messager.alert('完成', '发送成功！', 'info');
                        }
                        else {
							alert(ret);
                            $.messager.alert('错误', '发送失败，请再次尝试！', 'error');
                        }
                    }
                });
            });		
    });
})(jQuery);
