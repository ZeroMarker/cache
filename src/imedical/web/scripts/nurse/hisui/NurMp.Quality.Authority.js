$(function() {
    function init(){
        initPatSearch() //初始化患者查询
        initEmrList() //初始化病历列表
        initAuthorityUser() //初始化授权的用户
        $('#treeHistoryWin').window({
            width: 1000,
            height: 500,
            modal: true,
            closed: true,
            collapsible: false,
            minimizable: false,
            maximizable: false,
            closable: true,
            title: '病历授权历史',
            iconCls:'icon-w-paper'
         
        });
    }
    // 初始化患者查询 
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
        // 时间类型
        $('#inputTimeType').combobox({
            idField: 'value',
            textField: 'text',
            data: [{
                text: '入院时间',
                value: 'I'
            }, {
                text: '出院时间',
                value: 'O'
            }],
            value: 'O'
        })
        //初始化时间，默认当天
        $('#inputStartDate').datebox('setValue', (new Date()).Format("yyyy-MM-dd"))
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
                text: '登记号',
                value: 'regNo'
            }, {
                text: '床号',
                value: 'bedCode'
            }, {
                text: '姓名',
                value: 'patName'
            }, {
                text: '医生',
                value: 'mainDoctor'
            }],
            value: 'regNo'
        })
        $('#inputMainInput').bind('keypress', function(event) {
            if (event.keyCode == "13") {
                searchPatient();
            }
        });
        //初始化 查询患者表格
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
            loadMsg: '数据装载中......',
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
            onClickRow: function(rowIndex, rowData) {
                //选中患者
                var episodeID = rowData["episodeID"]
                expandEMRRangeTree(episodeID)
                initPatWardList(episodeID)
            }
        });

        //查询患者
        $('#patientSearchBtn').on('click', function() {
            searchPatient();
        });

    }

    function initEmrList(){
           //给予操作类型
           $('#inputGivePowerType').combogrid({
            idField: 'id',
            textField: 'text',
            data: [{
                id: '1',
                text: '修改',
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
                text: '查看',
                value: 'view'
            }, {
                id: '5',
                text: '新建',
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

            
            //授权历史事件
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
                loadMsg: '数据装载中......',
                showHeader: true,
                multiple: true,
                fitColumns: true,
                columns: [
					[
                        { field: 'ck', checkbox: true },
                        { field: 'authorityID', title: 'authorityID', width: 80, hidden: true },
                        { field: 'status', title: '状态', width: 70 },
                        { field: 'appointDateTime', title: '开始时间', width: 140 },
                        { field: 'appointEndDateTime', title: '结束时间', width: 140 },
                        { field: 'appointUserID', title: '授权人ID', width: 80, hidden: true },
                        { field: 'appointUserName', title: '授权人', width: 70 },
                        { field: 'appointUserCTLocName', title: '授权科室', width: 120 },
			            { field: 'patName', title: '患者姓名', width: 70 },
			            { field: 'regNo', title: '登记号', width: 90 },
                        { field: 'episodeID', title: '就诊指针', width: 80, hidden: true },
                        { field: 'requestUserID', title: '被授权人ID', width: 80, hidden: true },
                        { field: 'requestUserName', title: '被授权人', width: 80 },
                        { field: 'requestUserCTLocID', title: '给予的医生所在科室ID', width: 80, hidden: true },
                        { field: 'requestUserCTLocName', title: '被授权科室', width: 120 },
						{ field: 'detailData', title: '详情', width: 80, hidden:true },
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
						//title:"操作明细",
						striped:true,
						singleSelect:true,
						columns:[
							[
								{ field: 'emrCode', title: '授权病历', width: 80, hidden: true },
								{ field: 'emrCodeDesc', title: '授权病历', width: 240 },
								{ field: 'actionDescStr', title: '授权操作', width: 250 },
							]
						],
			    		onLoadSuccess:function(){    
			                $('#_list_tj').datagrid('fixDetailRowHeight',index);    
		                    setTimeout(function () {
		                    	  var tr=o.closest('tr');
					                id = tr.prev().attr('id'); //此子表格父行所在行的id
			                        id = id.replace(/-2-(\d+)$/, '-1-$1'); 
			                        $('#' + id).next().css('height', tr.height());//设置没展开的前部分的高度，由于启用了计时器，会闪一下
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

                //撤销授权按钮事件
                $('#withdrawBtn').on('click', function() {
                    var appointIDs = [];
                    var gridRows = $('#historyTable').datagrid("getChecked");
                    for (var i = 0; i < gridRows.length; i++) {
                        var gridRow = gridRows[i];
						//过期的条目不能进行撤销，并给予提示
						if (gridRow["status"] == "过期")
						{
							var number = i+1
							var message = '您选中的第' + number + '条已过期,不能撤销！'
							$.messager.alert('提示',message);
							continue;
						}
						else if (gridRow["status"] == "生效中")
						{
                            var appointID = gridRow["authorityID"];
                            appointIDs.push(appointID)
						}
                    }
					if (appointIDs.length == 0) {
						$.messager.alert('提示','请至少选择一条 生效中 的记录！');
						return;
					}
					else
						{
						$.messager.confirm('确认撤销权限', '确实要收回选中的 生效中 授权？', function(r) {
							if (r) {
                                var ret = ""
                                runClassMethod("NurMp.Quality.Service.Authority", "cancelAuthority",
                                    { 
                                        parameter1 : JSON.stringify(appointIDs) 
                                    },
                                    function(data){
                                        if (data == "0")
                                        {
                                            $.messager.alert('提示','撤销成功！');
                                            $('#historyTable').datagrid('reload');
                                        }else{
                                            $.messager.alert('错误', "撤销失败:" + data, 'error');
                                        }
                                    }
                                )
							}
						});
					}
                });


    }
    /** 初始化右下方的用户授权*/
    function initAuthorityUser(){
        //患者待过的病区
        $('#inputDocLoc').combobox({
            valueField: 'id',
            textField: 'text',
            onSelect: function(){
                searchUser()
            }
        })
        $('#docListTable').datagrid({
            method: 'post',
            loadMsg: '数据装载中......',
            singleSelect: true,
            showHeader: true,
            //fitColumns: true,
            columns: [[
                { field: 'userCode', title: '工号', width: 80, sortable: true },
                { field: 'userName', title: '姓名', width: 80, sortable: true },
                { field: 'userWard', title: '病区', width: 120, sortable: true },
                { field: 'userTitle', title: '职称', width: 80, sortable: true },
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
        $('#docSearchBtn').on('click',function(){
            searchUser()
        })

        /**输入名字查询框 */
        $('#inputDocName').bind('keypress', function(event) {
            if (event.keyCode == "13") {
                searchUser();
            }
        });


        /**授权按钮 */
        $('#doAuthorityBtn').on('click',function(){
            authorityBtn()
        })

    }

    /**右下角病人授权模块 查询用户的方法 */
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
     * 点击患者加载患者待过的科室
     * @param {string} episodeID 
     */
    function initPatWardList(episodeID)
    {
        $('#inputDocLoc').combobox('clear')
        $('#inputDocLoc').combobox('reload',LINK_CSP + "?className=NurMp.Quality.Service.Authority&methodName=getPatLocList&parameter1=" + episodeID)
        $('#docListTable').datagrid('loadData',[])
    }
    /** 授权按钮*/
    function authorityBtn(){
        var record = $('#patientListTable').datagrid("getSelected");    // 获取所有选中的行
        if (record == null)
        {
            $.messager.alert("提示","请选中一个患者！","error")
            return
        }
        var EpisodeID=record["episodeID"]
        var allChecked=$('#emrTree').tree('getChecked')
        //获取选中的护理病历模板
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
            $.messager.alert("提示","请选择至少一个护理病历！","error")
            return
        }
        //获取选择的授权操作类型
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
            $.messager.alert("提示","请选择至少一个操作类型！","error")
            return
        }
        //获取选择的授权人
        var userRecord = $('#docListTable').datagrid("getSelected");    // 获取所有选中的行
        if (userRecord == null)
        {
            $.messager.alert("提示","请选择要授权的人！","error")
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
                $.messager.alert("提示","授权成功","success")
            }else{
                $.messager.alert("提示",data,"error")
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
