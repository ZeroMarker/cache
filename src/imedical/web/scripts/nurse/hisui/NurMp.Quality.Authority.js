$(function() {
    function init(){
        initPatSearch() //��ʼ�����߲�ѯ
        initEmrList() //��ʼ�������б�
        initAuthorityUser() //��ʼ����Ȩ���û�
        $('#treeHistoryWin').window({
            width: 1000,
            height: 500,
            modal: true,
            closed: true,
            collapsible: false,
            minimizable: false,
            maximizable: false,
            closable: true,
            title: '������Ȩ��ʷ',
            iconCls:'icon-w-paper'
         
        });
    }
    // ��ʼ�����߲�ѯ 
    function initPatSearch(){
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
                text: '��Ժʱ��',
                value: 'I'
            }, {
                text: '��Ժʱ��',
                value: 'O'
            }],
            value: 'O'
        })
        //��ʼ��ʱ�䣬Ĭ�ϵ���
        $('#inputStartDate').datebox('setValue', (new Date()).Format("yyyy-MM-dd"))
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
                text: '�ǼǺ�',
                value: 'regNo'
            }, {
                text: '����',
                value: 'bedCode'
            }, {
                text: '����',
                value: 'patName'
            }, {
                text: 'ҽ��',
                value: 'mainDoctor'
            }],
            value: 'regNo'
        })
        $('#inputMainInput').bind('keypress', function(event) {
            if (event.keyCode == "13") {
                searchPatient();
            }
        });
        //��ʼ�� ��ѯ���߱��
        $('#patientListTable').datagrid({
            url: $URL,
            queryParams:{
                ClassName: 'NurMp.Quality.Service.Authority',
                QueryName: 'getOutHopPatList',
                DateType: $('#inputTimeType').combobox('getValue'),
                StartDate: $('#inputStartDate').datebox('getValue'),
                EndDate: $('#inputEndDate').datebox('getValue'),
                CTLoc: $('#inputCtLoc').combobox('getValue'),
                SelectMain: $('#inputMainSelect').combobox('getValue'),
                SelectInput: $('#inputMainInput').val(),
            },
            method: 'post',
            loadMsg: '����װ����......',
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
            onClickRow: function(rowIndex, rowData) {
                //ѡ�л���
                var episodeID = rowData["episodeID"]
                expandEMRRangeTree(episodeID)
                initPatWardList(episodeID)
            }
        });

        //��ѯ����
        $('#patientSearchBtn').on('click', function() {
            searchPatient();
        });

    }

    function initEmrList(){
           //�����������
           $('#inputGivePowerType').combogrid({
            idField: 'id',
            textField: 'text',
            data: [{
                id: '1',
                text: '�޸�',
                value: 'save'
            }, {
                id: '2',
                text: '��ӡ',
                value: 'print'
            }, {
                id: '3',
                text: 'ɾ��',
                value: 'delete'
            }, {
                id: '4',
                text: '�鿴',
                value: 'view'
            }, {
                id: '5',
                text: '�½�',
                value: 'new'
            }],
                panelWidth: 300,
                showHeader: true,
                multiple: true,
                columns: [[
                { field: 'ck', checkbox: true },
                { field: 'id', title: 'id', width: 80, hidden: true },
                { field: 'value', title: 'value', width: 80, hidden: true },
                { field: 'text', title: '��������', width: 250 }
            ]],
                onLoadSuccess: function() {
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
            $('#treeHistoryBtn').on('click', function() {
                $('#historyTable').datagrid('reload');
                $('#treeHistoryWin').window('open');
            });


            var historyDG = $('#historyTable').datagrid({
                url: $URL,
                queryParams:{
                    ClassName: 'NurMp.Quality.Service.Authority',
                    QueryName: 'getAuthorityHistory',
                    AppointCTLocID: appointUserLoc,
                    IsValid: 'all'
                },
                method: 'post',
                loadMsg: '����װ����......',
                showHeader: true,
                multiple: true,
                fitColumns: true,
                columns: [
					[
                        { field: 'ck', checkbox: true },
                        { field: 'authorityID', title: 'authorityID', width: 80, hidden: true },
                        { field: 'status', title: '״̬', width: 70 },
                        { field: 'appointDateTime', title: '��ʼʱ��', width: 140 },
                        { field: 'appointEndDateTime', title: '����ʱ��', width: 140 },
                        { field: 'appointUserID', title: '��Ȩ��ID', width: 80, hidden: true },
                        { field: 'appointUserName', title: '��Ȩ��', width: 70 },
                        { field: 'appointUserCTLocName', title: '��Ȩ����', width: 120 },
			            { field: 'patName', title: '��������', width: 70 },
			            { field: 'regNo', title: '�ǼǺ�', width: 90 },
                        { field: 'episodeID', title: '����ָ��', width: 80, hidden: true },
                        { field: 'requestUserID', title: '����Ȩ��ID', width: 80, hidden: true },
                        { field: 'requestUserName', title: '����Ȩ��', width: 80 },
                        { field: 'requestUserCTLocID', title: '�����ҽ�����ڿ���ID', width: 80, hidden: true },
                        { field: 'requestUserCTLocName', title: '����Ȩ����', width: 120 },
						{ field: 'detailData', title: '����', width: 80, hidden:true },
                    ]
				],
				view:detailview,
				detailFormatter:function(index,row){
					return '<table id="DatagridDetail' + index + '"></table>'
				},
				onExpandRow: function(index,row){
					var o=$('#DatagridDetail'+index);
					$('#DatagridDetail' + index).datagrid({
						autoHeight:250,
						width:940,
						//title:"������ϸ",
						striped:true,
						singleSelect:true,
						columns:[
							[
								{ field: 'emrCode', title: '��Ȩ����', width: 80, hidden: true },
								{ field: 'emrCodeDesc', title: '��Ȩ����', width: 240 },
								{ field: 'actionDescStr', title: '��Ȩ����', width: 250 },
							]
						],
			    		onLoadSuccess:function(){    
			                $('#_list_tj').datagrid('fixDetailRowHeight',index);    
		                    setTimeout(function () {
		                    	  var tr=o.closest('tr');
					                id = tr.prev().attr('id'); //���ӱ���������е�id
			                        id = id.replace(/-2-(\d+)$/, '-1-$1'); 
			                        $('#' + id).next().css('height', tr.height());//����ûչ����ǰ���ֵĸ߶ȣ����������˼�ʱ��������һ��
		                     }, 0);
		                  } 
					})
					InitDatagridDetail(index,row)
				},
                pagination: true,
                pageSize: 20,
                pageList: [10, 20, 50],
                pagePosition: 'bottom',
                toolbar: '#historyTableTBar',
                rowStyler: function(index, row) {
                    if (row["IsValid"] == "��Ч��") {
                        return 'background-color:#c7dafe;';
                    }
                }
            });

            //���˼�¼�Ƿ���Ч
            $('#isCurrentValidSelect').combobox({
                valueField: 'id',
                textField: 'text',
                data: [{
                    id: 'active',
                    text: '��Ч��'
                }, {
                    id: 'past',
                    text: '����'
                }, {
                    id: 'all',
                    text: 'ȫ��'
				}],
                    onSelect: function(record) {
                        var queryParams = $('#historyTable').datagrid('options').queryParams;
                        queryParams.IsValid = record["id"];
                        $('#historyTable').datagrid('options').queryParams = queryParams;
                        $('#historyTable').datagrid('reload');
                    }
                });

                //������Ȩ��ť�¼�
                $('#withdrawBtn').on('click', function() {
                    var appointIDs = [];
                    var gridRows = $('#historyTable').datagrid("getChecked");
                    for (var i = 0; i < gridRows.length; i++) {
                        var gridRow = gridRows[i];
						//���ڵ���Ŀ���ܽ��г�������������ʾ
						if (gridRow["status"] == "����")
						{
							var number = i+1
							var message = '��ѡ�еĵ�' + number + '���ѹ���,���ܳ�����'
							$.messager.alert('��ʾ',message);
							continue;
						}
						else if (gridRow["status"] == "��Ч��")
						{
                            var appointID = gridRow["authorityID"];
                            appointIDs.push(appointID)
						}
                    }
					if (appointIDs.length == 0) {
						$.messager.alert('��ʾ','������ѡ��һ�� ��Ч�� �ļ�¼��');
						return;
					}
					else
						{
						$.messager.confirm('ȷ�ϳ���Ȩ��', 'ȷʵҪ�ջ�ѡ�е� ��Ч�� ��Ȩ��', function(r) {
							if (r) {
                                var ret = ""
                                runClassMethod("NurMp.Quality.Service.Authority", "cancelAuthority",
                                    { 
                                        parameter1 : JSON.stringify(appointIDs) 
                                    },
                                    function(data){
                                        if (data == "0")
                                        {
                                            $.messager.alert('��ʾ','�����ɹ���');
                                            $('#historyTable').datagrid('reload');
                                        }else{
                                            $.messager.alert('����', "����ʧ��:" + data, 'error');
                                        }
                                    }
                                )
							}
						});
					}
                });


    }
    /** ��ʼ�����·����û���Ȩ*/
    function initAuthorityUser(){
        //���ߴ����Ĳ���
        $('#inputDocLoc').combobox({
            valueField: 'id',
            textField: 'text',
            onSelect: function(){
                searchUser()
            }
        })
        $('#docListTable').datagrid({
            method: 'post',
            loadMsg: '����װ����......',
            singleSelect: true,
            showHeader: true,
            //fitColumns: true,
            columns: [[
                { field: 'userCode', title: '����', width: 80, sortable: true },
                { field: 'userName', title: '����', width: 80, sortable: true },
                { field: 'userWard', title: '����', width: 120, sortable: true },
                { field: 'userTitle', title: 'ְ��', width: 80, sortable: true },
                { field: 'userID', title: 'id', width: 80, sortable: true, hidden:true },
                { field: 'userCTLocID', title: 'ctlocId', width: 80, sortable: true, hidden:true },
            ]],
            pagination: true,
            pageSize: 20,
            pageList: [10, 20, 50],
            pagePosition: 'bottom',
            toolbar: '#docListTableTBar',
            onClickRow: function(rowIndex, rowData) {
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
        $('#docSearchBtn').on('click',function(){
            searchUser()
        })

        /**�������ֲ�ѯ�� */
        $('#inputDocName').bind('keypress', function(event) {
            if (event.keyCode == "13") {
                searchUser();
            }
        });


        /**��Ȩ��ť */
        $('#doAuthorityBtn').on('click',function(){
            authorityBtn()
        })

    }

    /**���½ǲ�����Ȩģ�� ��ѯ�û��ķ��� */
    function searchUser(){
        $('#docListTable').datagrid('options').url = $URL
        $('#docListTable').datagrid('options').queryParams = {
            ClassName: 'NurMp.Quality.Service.Authority',
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
        
        $('#emrTree').tree({
            //url: '../web.eprajax.GivePower.cls?Action=tree&EpisodeID=' + episodeID,
            url: LINK_CSP + "?className=NurMp.Quality.Service.Authority&methodName=getTemplatesByEpisodeID&parameter1=" +session['LOGON.HOSPID'] + "&parameter2=" + session['LOGON.CTLOCID'] + "&parameter3=" + episodeID ,
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
    function initPatWardList(episodeID)
    {
        $('#inputDocLoc').combobox('clear')
        $('#inputDocLoc').combobox('reload',LINK_CSP + "?className=NurMp.Quality.Service.Authority&methodName=getPatLocList&parameter1=" + episodeID)
        $('#docListTable').datagrid('loadData',[])
    }
    /** ��Ȩ��ť*/
    function authorityBtn(){
        var record = $('#patientListTable').datagrid("getSelected");    // ��ȡ����ѡ�е���
        if (record == null)
        {
            $.messager.alert("��ʾ","��ѡ��һ�����ߣ�","error")
            return
        }
        var EpisodeID=record["episodeID"]
        var allChecked=$('#emrTree').tree('getChecked')
        //��ȡѡ�еĻ�����ģ��
        var emrCodeList = []
        for (var single in allChecked)
        {
            if (!(allChecked[single].children))
            {
                emrCodeList.push(allChecked[single].id)
            }
        }
        if (emrCodeList.length == 0)
        {
            $.messager.alert("��ʾ","��ѡ������һ����������","error")
            return
        }
        //��ȡѡ�����Ȩ��������
        var givePowerTypeList = []
        var givePowerTypeGridRows = $('#inputGivePowerType').combogrid('grid').datagrid("getChecked");
        for (var curIndex in givePowerTypeGridRows)
        {
            var givePowerTypeGridRow = givePowerTypeGridRows[curIndex]
            var value = givePowerTypeGridRow["value"];
            givePowerTypeList.push(value)
        }
        if (givePowerTypeList.length == 0)
        {
            $.messager.alert("��ʾ","��ѡ������һ���������ͣ�","error")
            return
        }
        //��ȡѡ�����Ȩ��
        var userRecord = $('#docListTable').datagrid("getSelected");    // ��ȡ����ѡ�е���
        if (userRecord == null)
        {
            $.messager.alert("��ʾ","��ѡ��Ҫ��Ȩ���ˣ�","error")
            return
        }
        var authUserID = userRecord["userID"]
        var authUserLocID = userRecord["userCTLocID"]
        runClassMethod("NurMp.Quality.Service.Authority","insertAuthority",
        {
            parameter1: EpisodeID,
            parameter2 : $('#inputGivePowerSpan').val(),
            parameter3 : JSON.stringify(givePowerTypeList),
            parameter4 : JSON.stringify(emrCodeList),
            parameter5 : authUserLocID,
            parameter6 : authUserID,
            parameter7 : appointUserLoc,
            parameter8 : appointUserID
        }, function(data){
            if (data == 0 )
            {
                $.messager.alert("��ʾ","��Ȩ�ɹ�","success")
            }else{
                $.messager.alert("��ʾ",data,"error")
            }
        },'',false)
    }

    function InitDatagridDetail(index,row)
    {
        var DetailJson,DetailData={rows:[],total:0};
        
        if (!!row["detailData"]){
            DetailJson=row["detailData"]
            DetailJson=$.parseJSON(DetailJson)
        }
        
        for (var p in DetailJson){
            //DetailData.rows.push({"key":p,"value":DetailJson[p]});
            DetailData.rows.push(DetailJson[p]);
            DetailData.total++;
        }
        $('#DatagridDetail' + index).datagrid("loadData",DetailData);
    }


    init();
})
