
(function($) {
    $(function() {
		//功能-----------------------------------------------------------------------------------------------------------------------------------
		var footerView = $.extend({}, $.fn.datagrid.defaults.view, {
			renderFooter: function(target, container, frozen){
				var opts = $.data(target, 'datagrid').options;
				var rows = $.data(target, 'datagrid').footer || [];
				var fields = $(target).datagrid('getColumnFields', frozen);
				var table = ['<table class="datagrid-ftable" cellspacing="0" cellpadding="0" border="0"><tbody>'];
         
				for(var i=0; i<rows.length; i++){
					var styleValue = opts.rowStyler ? opts.rowStyler.call(target, i, rows[i]) : '';
					var style = styleValue ? 'style="' + styleValue + '"' : '';
					table.push('<tr class="datagrid-row" datagrid-row-index="' + i + '"' + style + '>');
					table.push(this.renderRow.call(this, target, fields, frozen, i, rows[i]));
					table.push('</tr>');
				}
         
				table.push('</tbody></table>');
				$(container).html(table.join(''));
			}
		});
		
		//初始化-------------------------------------------------------------------------------------------------------------------------------
		$('#inputMedRecordNo').val();
		$('#inputRegNo').val();
		$('#inputAdmNo').val();
		$('#inputName').val();
		
		$('#searchBtn').on('click', function() {
	        searchBtnHandle();
	    });
		
		//查询就诊
	    function searchBtnHandle() {
			var url = '../DHCEPRFS.web.eprajax.AjaxSimpleView.cls';
	        $('#episodeListTable').datagrid('options').url = url;
	        var queryParams = $('#episodeListTable').datagrid('options').queryParams;
	        queryParams.RegNo = $('#inputRegNo').val();
			queryParams.AdmNo = $('#inputAdmNo').val();
			queryParams.Name = $('#inputName').val();
			queryParams.MedRecordID = $('#inputMedRecordNo').val();
	        $('#episodeListTable').datagrid('options').queryParams = queryParams;
	        $('#episodeListTable').datagrid('reload');
	    }
		
		//就诊查询-------------------------------------------------------------------------------------------------------------------------------
		var episodeListTableDG = $('#episodeListTable').datagrid({
	        //url: '',
	        queryParams: {
				Action: 'episodelist',
	            RegNo: '',
				AdmNo:'',
				Name:'',
				MedRecordID:''
	        },
	        method: 'post',
	        loadMsg: '数据装载中......',
	        singleSelect: true,
	        showHeader: true,
	        fitColumns: true,
			rownumbers:false,
	        columns: [[
				{ field: 'PAStatusType', title: '状态', width: 80, sortable: true },
	            { field: 'PAAdmType', title: '就诊类型', width: 80, sortable: true },
				{ field: 'PAPMIName', title: '病人姓名', width: 80, sortable: true },
	            { field: 'PAPMINO', title: '登记号', width: 80, sortable: true },
	            { field: 'PAPMIDOB', title: '出生日期', width: 100, sortable: true },
	            { field: 'PAPMIAge', title: '年龄', width: 80, sortable: true },
				{ field: 'PAPMISex', title: '性别', width: 80, sortable: true },
				{ field: 'PAAdmDateTime', title: '入院时间', width: 150, sortable: true },
				{ field: 'PAAdmWard', title: '病区', width: 80, sortable: true },
				{ field: 'PAAdmRoom', title: '病房', width: 80, sortable: true },
				{ field: 'PAAdmBed', title: '病床', width: 80, sortable: true },
				{ field: 'PAAdmLoc', title: '科室', width: 80, sortable: true },
				{ field: 'PADischgeDateTime', title: '出院时间', width: 150, sortable: true },
				{ field: 'PAAdmDoc', title: '医生', width: 80, sortable: true },
				{ field: 'PayMode', title: '付费类型', width: 80, sortable: true },
				{ field: 'EpisodeID', title: '就诊号', width: 80, sortable: true },
				{ field: 'PatientID', title: '病人号', width: 80, sortable: true }
			]],
			sortName: "PAAdmDateTime",
			sortOrder: "asc",
	        toolbar: '#episodeListTableTBar',
	        title: '就诊查询',
			onClickRow: function(index, rowData){
				 var EpisodeID = rowData["EpisodeID"];
				 $('#inputAdmNo').val(EpisodeID);
				 var htmlStr = '<iframe src="./dhc.epr.fs.bscheckrecord.csp?EpisodeID=';
			     htmlStr += EpisodeID;
			     htmlStr += '&SchemeID=';
			     htmlStr += SchemeID;
				 htmlStr += '&Count=1';
			     htmlStr += '" frameBorder=0 scrolling=no style="z-index:-1;height:100%;width:100%;"></iframe>';
			     $('#iframeDIV').append(htmlStr);				 
			},
			onLoadSuccess: function(data){	
				//加载成功，自动选中最近一条出院就诊
				var rows = $('#episodeListTable').datagrid('getRows');
				for (var i=0;i<rows.length;i++)
				{
					if (rows[i]["PAStatusType"] == "D")
					{
						$('#episodeListTable').datagrid('selectRow',i);
						break;
					}
				}
			}
	    });
		
		
		//清空
		$('#clearBtn').on('click', function() {
			$('#inputMedRecordNo').val("");
			$('#inputRegNo').val("");
			$('#inputAdmNo').val("");
			$('#inputName').val("");
	        $('#itemListTable').datagrid('loadData',{total:0,rows:[]});
	    });
		
		function loadItemList(rowData) {
			var EpisodeID = rowData["EpisodeID"];
			$('#inputAdmNo').val(EpisodeID);
			/*
			var htmlStr = '<iframe src="./dhc.epr.fs.bscheckrecord.csp?EpisodeID=';
			htmlStr += EpisodeID;
			htmlStr += '&SchemeID=';
			htmlStr += SchemeID;
			htmlStr += '" frameBorder=0 scrolling=no style="height:100%,width:100%;"></iframe>';
			$('#iframeDIV').append(htmlStr);*/
		}
		
		
	});
})(jQuery);