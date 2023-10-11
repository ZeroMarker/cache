//全局
var FSCorrelation = FSCorrelation || {
	DateStart: "",
	DateEnd: "",
	SelectEpisode: ""
};

(function(win) {
	$(function() {
		$('#inputStartDate').datebox ({
			onSelect: function() {
				FSCorrelation.DateStart = $('#inputStartDate').datebox('getValue');
			},
			onChange: function() {
				FSCorrelation.DateStart = $('#inputStartDate').datebox('getValue');
			}
		});
		
		$('#inputEndDate').datebox ({
			onSelect: function() {
				FSCorrelation.DateEnd = $('#inputEndDate').datebox('getValue');
			},
			onChange: function() {
				FSCorrelation.DateEnd = $('#inputEndDate').datebox('getValue');
			}
		});
		
		setDefaultDate();
		
		$('#episodeListTable').datagrid({
			url: '../DHCEPRFS.web.eprajax.AjaxCorrelationEpisode.cls',
			queryParams: {
				Action: 'GetEpisodeList',
				EpisodeID: episodeID,
				StartDate: FSCorrelation.DateStart,
				EndDate: FSCorrelation.DateEnd
			},
			method: 'post',
			title: '就诊查询',
			toolbar: '#episodeListTableToolbar',
			fit: true,
			rownumbers: true,
			singleSelect: true,
			checkOnSelect: false,
			selectOnCheck: false,
			columns: [[
				{ field: 'IsCorrelation', title: '是否关联', width: 70, hidden: true},
				{ field: 'PAAdmDate', title: '就诊日期', width: 70, sortable: true},
				{ field: 'PAPMIName', title: '姓名', width: 70, sortable: true},
				{ field: 'PAAdmLoc', title: '就诊科室', width: 70, sortable: true},
				{ field: 'IsCreated', title: '是否生成', width: 70, sortable: true},
				{ field: 'PAStatusType', title: '就诊状态', width: 70, sortable: true},
				{ field: 'PAAdmType', title: '就诊类型', width: 70, sortable: true},
				{ field: 'EpisodeID', title: '就诊号', width: 70, sortable: true},
				{ field: 'PAPMINO', title: '登记号', width: 70, sortable: true},
				{ field: 'PAPMIDOB', title: '出生日期', width: 70},
				{ field: 'PAPMIAge', title: '年龄', width: 70},
				{ field: 'PAPMISex', title: '性别', width: 70},
				{ field: 'PAAdmWard', title: '病区', width: 70},
				{ field: 'PAAdmRoom', title: '病房', width: 70},
				{ field: 'PAAdmBed', title: '床位', width: 70},
				{ field: 'PatientID', title: '病人号', width: 70}
			]],
			rowStyler: function(index,row) {
				if (row.IsCorrelation == "Y"){
					return 'background-color:lightgreen;color:black;';
				}
			},
			onClickRow: function(index, row) {
				FSCorrelation.SelectEpisode = row.EpisodeID;
				getCategoryList(FSCorrelation.SelectEpisode);
			}
		});
		
		$('#btnSearch').on('click', function(){
			searchEpisode();
		});
		
		$('#btnComplete').on('click', function () {
			if (episodeID !== "") {
				var obj = $.ajax({
				url: "../DHCEPRFS.web.eprajax.AjaxCorrelationEpisode.cls?Action=Complete&EpisodeID=" + episodeID+"&UserID="+userID,
				type: 'post',
				async: false
				});

				var ret = obj.responseText;
				if (ret == "1")
				{
					$.messager.alert('提示', '提交成功！', 'info');
				}
				else
				{
					$.messager.alert('提示', '提交失败！', 'info');
				}
			}
		});
		
		$('#btnCorrelation').on('click', function () {
			if (episodeID !== "") {
				var obj = $.ajax({
				url: "../DHCEPRFS.web.eprajax.AjaxCorrelationEpisode.cls?Action=Correlation&EpisodeID=" + episodeID + "&SubEpisodeID=" + FSCorrelation.SelectEpisode,
				type: 'post',
				async: false
				});

				var ret = obj.responseText;
				if (ret == "1")
				{
					$.messager.alert('提示', '关联成功！', 'info', function() {
						searchEpisode();
					});
				}
				else
				{
					$.messager.alert('提示', '关联失败！', 'info');
				}
			}
		});
		
		$('#btnUnCorrelation').on('click', function () {
			if (episodeID !== "") {
				var obj = $.ajax({
					url: "../DHCEPRFS.web.eprajax.AjaxCorrelationEpisode.cls?Action=UnCorrelation&EpisodeID=" + episodeID + "&SubEpisodeID=" + FSCorrelation.SelectEpisode,
					type: 'post',
					async: false
				});
				var ret = obj.responseText;
				if (ret == "1")
				{
					$.messager.alert('提示', '取消关联成功！', 'info', function() {
						searchEpisode();
					});
				}
				else
				{
					$.messager.alert('提示', '取消关联失败！', 'info');
				}
			}
		});
		
		$('#categoryListTable').datagrid({
			title: '项目列表',
			toolbar: '#categoryListTableToolbar',
			fit: true,
			rownumbers: true,
			columns: [[
				{ field: 'CategoryCode', title: '编码', width: 70, hidden: true},
				{ field: 'CategoryName', title: '项目名称', width: 420}
			]],
			view: detailview,
			detailFormatter: function(index, row) {
				return '<div style="padding:2px"><table class="detailTable"></table></div>';
			},
			onExpandRow: function(index, row) {
				var categoryCode = row.CategoryCode;
				var detailTable = $(this).datagrid('getRowDetail',index).find('table.detailTable');
				detailTable.datagrid({
					url: "../DHCEPRFS.web.eprajax.AjaxCorrelationEpisode.cls",
					queryParams: {
						Action: 'GetOrderList',
						SubEpisodeID: FSCorrelation.SelectEpisode,
						CategoryCode: categoryCode
					},
					weight: 'auto',
					height: 'auto',
					method: 'post',
					loadMsg: '数据装载中......',
					rownumbers: true,
					showHeader: false,
					columns: [[
						{ field: 'OrderID', title: '医嘱ID', width: 100, sortable: true},
						{ field: 'OrderDesc', title: '医嘱名称', width: 260}
					]],
					onResize:function(){
						$('#categoryListTable').datagrid('fixDetailRowHeight',index);
					},
					onLoadSuccess:function(data){
						setTimeout(function(){
							$('#categoryListTable').datagrid('fixDetailRowHeight',index);
						},0);
                    }
				});
				$('#categoryListTable').datagrid('fixDetailRowHeight',index);
			}
		});
		
		function getCategoryList(episodeID) {
			var url = '../DHCEPRFS.web.eprajax.AjaxCorrelationEpisode.cls';
			$('#categoryListTable').datagrid('options').url = url;
			var queryParams = $('#categoryListTable').datagrid('options').queryParams;
			queryParams.Action = 'GetCategory';
			queryParams.SubEpisodeID = episodeID;
			$('#categoryListTable').datagrid('options').queryParams = queryParams;
			$('#categoryListTable').datagrid('reload');
		}
		
		function searchEpisode() {
			var url = '../DHCEPRFS.web.eprajax.AjaxCorrelationEpisode.cls';
			$('#episodeListTable').datagrid('options').url = url;
			var queryParams = $('#episodeListTable').datagrid('options').queryParams;
			queryParams.EpisodeID = episodeID;
			queryParams.StartDate = FSCorrelation.DateStart;
			queryParams.EndDate = FSCorrelation.DateEnd;
			$('#episodeListTable').datagrid('options').queryParams = queryParams;
			$('#episodeListTable').datagrid('reload');
		}
		
        //设置默认时间
        function setDefaultDate() {
            var currDate = new Date();
            $("#inputStartDate").datebox("setValue", myformatter1(currDate, 7));
            $("#inputEndDate").datebox("setValue", myformatter(currDate));
            FSCorrelation.DateStart = $("#inputStartDate").datebox("getValue");
            FSCorrelation.DateEnd = $("#inputEndDate").datebox("getValue");
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