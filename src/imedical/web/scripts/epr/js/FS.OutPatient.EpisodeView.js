var FSOutPatientEpisodeView = new Object();
FSOutPatientEpisodeView.EPRACTION = "FS";
FSOutPatientEpisodeView.DATASERVICEURL = "http://192.168.0.180/trakcarelive/trak/web/";

(function($) {
	$(function() {
		function setPatInfo() {
			var ret = '';
			var obj = $.ajax({
				url: '../DHCEPRRBAC.web.eprajax.AjaxOutPatientEpisodeView.cls?Action=patinfo&RegNo=' + regNo,
				type: 'post',
				async: false
			});
			var ret = obj.responseText;
			if ((ret != '') && (ret != null) && (ret != '-1')) {
				var arr = new Array();
				arr = ret .split('^');
				var name = arr[1];
				var gender = arr[2];
				var birthday = arr[3];
				
				var splitor = '&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp';
				var htmlStr = '&nbsp';
				htmlStr += '<span style="font-family:微软雅黑;font-size:25px;">登记号：</span><span style="font-family:微软雅黑;color:#008b8b;font-size:25px;">' + regNo + '</span>' + splitor;
				htmlStr += '<span style="font-family:微软雅黑;font-size:25px;">姓名：</span><span style="font-family:微软雅黑;color:#008b8b;font-size:25px;">' + name + '</span>' + splitor;
				htmlStr += '<span style="font-family:微软雅黑;font-size:25px;">性别：</span><span style="font-family:微软雅黑;color:#008b8b;font-size:25px;">' + gender + '</span>' + splitor;
				htmlStr += '<span style="font-family:微软雅黑;font-size:25px;">生日：</span><span style="font-family:微软雅黑;color:#008b8b;font-size:25px;">' + birthday + '</span>' + splitor;
				
				$('#infoPanel').append(htmlStr);
			}
			else {
				$.messager.alert('错误','获取患者信息失败！','error');
			}
		}
		setPatInfo();
		
		function searchBtnHandle() {
			var url = '../DHCEPRRBAC.web.eprajax.AjaxOutPatientEpisodeView.cls';
			$('#episodeListTable').datagrid('options').url = url;
			var queryParams = $('#episodeListTable').datagrid('options').queryParams;
			queryParams.AdmNo = '';
			queryParams.RegNo = regNo;
			queryParams.UserID = userID;
			queryParams.CTLocID = ctLocID;
			queryParams.SSGroupID = ssGroupID;
			$('#episodeListTable').datagrid('options').queryParams = queryParams;
			$('#episodeListTable').datagrid('reload');
		}
		
		var episodeListTableDG = $('#episodeListTable').datagrid({
			queryParams: {
				Action: 'episodelist',
				AdmNo: '',
				RegNo: '',
				UserID: '',
				CTLocID: '',
				SSGroupID: ''
			},
			method: 'post',
			loadMsg: '数据加载中.....',
			singleSelect: false,
			showHeader: true,
			rownumber: false,
			columns: [[
				{ field: 'ck', checkbox: true},
				{ field: 'EpisodeID', title: 'EpisodeID', width: 40, sortable: true, hidden: true },
				{ field: 'IsApply', title: 'IsApply', width: 40, sortable: true, hidden: true },
				{ field: 'IsApplyDesc', title: '权限', width: 40, sortable: true },
				{ field: 'PAType', title: '类型', width: 40, sortable: true },
				{ field: 'PAAdmDate', title: '就诊日期', width: 140, sortable: true },
				{ field: 'PAAdmLoc', title: '科室', width: 80, sortable: true },
				{ field: 'PADischgeDate', title: '出院日期', width: 80, sortable: true },
				{ field: 'PAAdmDoc', title: '主治医师', width: 80, sortable: true, hidden: true }
			]],
			sortName: 'PAAdmDate',
			sortOrder: 'asc',
			pagination: true,
			pageSize: 20,
			pagePosition: 'bottom',
			onDblClickRow: viewRecord
		});
		
		var pagination = $('#episodeListTable').datagrid('getPager').pagination({
			showPageList: false,
			showRefresh: false,
			displayMsg: '',
			buttons: [{
				id: 'applyBtn',
				iconCls: 'icon-edit',
				text: '申请权限'
			}]
		});
		
		searchBtnHandle();
		
		//申请权限
		$('#applyBtn').on('click', function() {
			var episodeString = '';
			var rows = $('#episodeListTable').datagrid('getSelections');
			if (rows.length == 0) {
				$.messager.alert('错误','请先选择一条就诊记录再点击申请权限！','error');
			}
			else {
				for (var i=0;i<rows.length;i++) {
					var row = rows[i];
					var episodeID = row['EpisodeID'];
					if (episodeString == '') {
						episodeString = episodeID;
					}
					else {
						episodeString = episodeString + '^' + episodeID;
					}
				}
				
				//确认申请权限
				var ret = '';
				var obj = $.ajax({
					url: '../DHCEPRRBAC.web.eprajax.ApplyPermission.cls?Action=outpatientview&EPRAction=' + FSOutPatientEpisodeView.EPRACTION  + '&EpisodeString=' + episodeString + '&UserID=' + userID + '&UserLocID=' + ctLocID + '&UserSSGroupID=' + ssGroupID,
					type: 'post',
					async: false
				});
				var ret = obj.responseText;
				if ((ret != '') && (ret != null) && (ret != '-1')) {
					$.messager.alert('完成','添加成功！','info');
					searchBtnHandle();
				}
				else {
					$.messager.alert('错误','添加失败，请再次尝试！','error');
				}
			}
		});
		
		function viewRecord(rowIndex,rowData) {
			var episodeID = rowData.EpisodeID;
			var isApply = rowData.IsApply ;
			if (isApply != '1') {
				$.messager.alert('提示','需要先申请！','info');
				return;
			}
			
			var obj = $.ajax({
				url: '../DHCEPRRBAC.web.eprajax.AjaxOutPatientEpisodeView.cls?Action=getviewparam&AdmNo=' + episodeID, 
				type: 'post',
				async: false
			});
			var retFS = obj.responseText;
			if ((retFS != '') && (retFS != null) && (retFS != '-1')) {
				var strsFS = new Array();
				strsFS = retFS.split('!');
				var mrEpisodeID = strsFS[0];
				var verItems = strsFS[1];
				var url = 'dhc.epr.fs.viewrecord.csp?MREpisodeID=' + mrEpisodeID + '&MRVerItemsIDs=' + verItems + '&DataServiceUrl=' + FSOutPatientEpisodeView.DATASERVICEURL;
				$('#contentIFrame').attr('src',url);
			}
		}
	});
})(jQuery);
