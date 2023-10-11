//全局
var FSStatusQuery = FSStatusQuery || {
    DateStart : "",
    DateEnd : "",
    TypeCode : "B",
	FilterMUID: "",

    //公有方法声明
    SearchEpisode: null
};

//配置和静态
FSStatusQuery.Config = FSStatusQuery.Config || {
    DATESPAN: timeSpan,
    PAGESIZE: 30,
    PAGELIST: [10, 20, 30, 50, 100],
    ERROR_INFO: "错误",
    LOADING_INFO: "数据装载中......"
};

(function (win) {
    $(function () {

        //初始化公有方法
        FSStatusQuery.SearchEpisode = searchEpisode;

        //加载调用设置默认日期
        setDefaultDate();

        //按钮事件
        $('#cbMedUnit').on('click', function () {
            if ($(this).prop("checked") == true) {
                $('#cbDept').attr("checked", false);
            }
			else {
				$('#cbDept').attr("checked", true);
			}
        });

        $('#cbDept').on('click', function () {
            if ($(this).prop("checked") == true) {
                $('#cbMedUnit').attr("checked", false);
            }
			else {
				$('#cbMedUnit').attr("checked", true);
			}
        });

        //查询患者
        $('#searchBtn').on('click', function () {
            searchEpisode();
        });

        $('#inputMedRecord').on('keypress', function (event) {
            if (event.keyCode == "13") {
                searchEpisode();
            }
        });

        $('#inputRegNo').on('keypress', function (event) {
            if (event.keyCode == "13") {
                searchEpisode();
            }
        });

        //置空
        $('#resetBtn').on('click', function () {
            $('#inputType').combogrid('grid').datagrid('selectRow', 0);
            $('#cbMedUnit').attr("checked", true);
            $('#cbDept').attr("checked", false);
            $('#inputMedRecord').val('');
            $('#inputRegNo').val('');
            setDefaultDate();
        });

          //患者查询列表
        var InfoDG = $('#reviewInfoTable').datagrid({
            //url: '../DHCEPRFS.web.eprajax.AjaxReview.cls',
            queryParams: {
                Action: 'statusquery',
                UserID: userID,
                Type: FSStatusQuery.TypeCode,
                StartDate: '',
                EndDate: '',
                MedRecordNo: '',
                RegNo: '',
                FilterLocID: userLocID,
                FilterMUID: ''
            },
            method: 'post',
            loadMsg: FSStatusQuery.Config.LOADING_INFO,
            singleSelect: true,
            showHeader: true,
            nowrap: false,
            //fitColumns: true,
            rownumbers: true,
            columns: [[
				//{ field: 'ck', checkbox: true },
				{ field: 'ReviewStatus', title: '病案室审核', width: 65, sortable: true, styler: cellStyler },
				{ field: 'QCDeptStatus', title: '质控科审核', width: 65, sortable: true, styler: cellStyler },
				{ field: 'DeptStatus', title: '科室审核', width: 55, sortable: true, styler: cellStyler },
				{ field: 'EprDocStatus', title: 'EprDocStatus', width: 60, sortable: true, hidden: true },
				{ field: 'EprDocStatusDesc', title: '医生提交', width: 55, sortable: true, styler: cellStyler },
				{ field: 'EprNurStatus', title: 'EprNurStatus', width: 60, sortable: true, hidden: true },
				{ field: 'EprNurStatusDesc', title: '护士提交', width: 55, sortable: true, styler: cellStyler },
				{ field: 'EprPdfStatus', title: 'EprPdfStatus', width: 60, sortable: true, hidden: true },
				{ field: 'EprPdfStatusDesc', title: '是否生成', width: 56, sortable: true, styler: cellStyler },
				{ field: 'EPRURL', title: '电子病历', width: 60, sortable: true, formatter: eprURLFormatter },
				{ field: 'DisDateTime', title: '出院日期时间', width: 110, sortable: true },
				{ field: 'MedRecordNo', title: '病案号', width: 70, sortable: true },
				{ field: 'RegNo', title: '登记号', width: 80, sortable: true },
				{ field: 'Warddesc', title: '病区', width: 100, sortable: true },
				{ field: 'CTMedUnitDesc', title: '诊疗组', width: 70, sortable: true },
				{ field: 'PAAdmDocCodeDR', title: '主治医生', width: 60, sortable: true },
				{ field: 'Message', title: '复核操作信息', width: 200, sortable: true },
				{ field: 'Remarks', title: '备注信息', width: 260, sortable: true },
				{ field: 'SubmitMessage', title: '历史备注信息', width: 260, sortable: true },
				{ field: 'BackMessage', title: '历史退回原因', width: 260, sortable: true },
				{ field: 'PAPMIName', title: '病人姓名', width: 80, sortable: true },
				{ field: 'EpisodeID', title: '就诊号', width: 70, sortable: true },
	        ]],
            pagination: true,
            pageSize: FSStatusQuery.Config.PAGESIZE,
            pageList: FSStatusQuery.Config.PAGELIST,
            pagePosition: 'bottom',
            toolbar: '#reviewInfoTableTBar'
        });

        //列表类型
        $('#inputType').combogrid({
            idField: 'id',
            textField: 'text',
            data: [{
                id: '0',
                text: '已退回',
                code: 'B'
            }, {
                id: '1',
                text: '科室未复核',
                code: 'Dept||U'
            }, {
                id: '2',
                text: '科室已复核',
                code: 'Dept||F'
            }, {
                id: '3',
                text: '质控科已复核',
                code: 'QC||F'
            }, {
                id: '4',
                text: '病案室已复核',
                code: 'MR||F'
            }],
            panelWidth: 150,
			fitColumns: true,
            showHeader: false,
            singleSelect: true,
            editable: false,
            columns: [[
                { field: 'id', title: 'id', width: 80, hidden: true },
                { field: 'code', title: 'code', width: 80, hidden: true },
                { field: 'text', title: '列表类型', width: 150 }
            ]],
            onSelect: function () {
                var row = $('#inputType').combogrid('grid').datagrid('getSelected');
                FSStatusQuery.TypeCode = row["code"];
                searchEpisode();
            },
            onLoadSuccess: function () {
                $('#inputType').combogrid('grid').datagrid('selectRow', 0);
            }
        });

        //时间过滤 - 起始日期
        $('#inputDateStart').datebox({
            onSelect: function () {
                FSStatusQuery.DateStart = $('#inputDateStart').datebox('getValue');
            },
            onChange: function () {
                //避免不选择日期而采用输入的方式
                FSStatusQuery.DateStart = $('#inputDateStart').datebox('getValue');
            }
        });

        //时间过滤 - 截止日期
        $('#inputDateEnd').datebox({
            onSelect: function () {
                FSStatusQuery.DateEnd = $('#inputDateEnd').datebox('getValue');
            },
            onChange: function () {
                //避免不选择日期而采用输入的方式
                FSStatusQuery.DateEnd = $('#inputDateEnd').datebox('getValue');
            }
        });

        //------------------------------------------------------------------------------------------------------------------

		//电子病历链接
        function eprURLFormatter(value, row, index) {
            var episodeID = row.EpisodeID;
            var url = 'epr.newfw.main.csp?EpisodeID=' + episodeID;
            return '<a style="color:blue" target="_blank" href="' + url + '">电子病历</a>';
        }
		
        //医生确认，护士确认，是否生成单元格染色
        function cellStyler(value, row, index) {
            if (value === "否") {
                return 'background-color:red;color:white;';
            }
            else if (value === "是") {
                return 'background-color:darkgreen;color:white;';
            }
            else {
                return 'background-color:darkblue;color:white;';
            }
        }

        //查询就诊
        function searchEpisode() {
            var url = '../DHCEPRFS.web.eprajax.AjaxReview.cls';
            $('#reviewInfoTable').datagrid('options').url = url;
            var queryParams = $('#reviewInfoTable').datagrid('options').queryParams;
            queryParams.Type = FSStatusQuery.TypeCode;
            queryParams.StartDate = FSStatusQuery.DateStart;
            queryParams.EndDate = FSStatusQuery.DateEnd;
            queryParams.MedRecordNo = $('#inputMedRecord').val(); 
            queryParams.RegNo = $('#inputRegNo').val(); 
			var group = document.getElementsByName("medunit");
			for (var i=0;i<group.length;i++) {
				if(group[i].checked == true) {
					FSStatusQuery.FilterMUID = group[i].value;
				}
			}
			queryParams.FilterMUID = FSStatusQuery.FilterMUID;
            $('#reviewInfoTable').datagrid('options').queryParams = queryParams;
            $('#reviewInfoTable').datagrid('reload');
			$('#reviewInfoTable').datagrid('getPager').pagination('select',1);
        }

        //设置默认时间
        function setDefaultDate() {
            var currDate = new Date();
            $("#inputDateStart").datebox("setValue", myformatter1(currDate, FSStatusQuery.Config.DATESPAN));
            $("#inputDateEnd").datebox("setValue", myformatter(currDate));
            FSStatusQuery.DateStart = $("#inputDateStart").datebox("getValue");
            FSStatusQuery.DateEnd = $("#inputDateEnd").datebox("getValue");
        }

        function myformatter(date) {
            var y = date.getFullYear();
            var m = date.getMonth() + 1;
            var d = date.getDate();
            return y + '-' + (m < 10 ? ('0' + m) : m) + '-' + (d < 10 ? ('0' + d) : d);
        }

        function myformatter1(date, span) {
            var d = date.getDate() - span;
            var tmp = new Date();
            tmp.setDate(d);
            var y = tmp.getFullYear();
            var m = tmp.getMonth() + 1;
            d = tmp.getDate();
            return y + '-' + (m < 10 ? ('0' + m) : m) + '-' + (d < 10 ? ('0' + d) : d);
        }
    });
}(window));
