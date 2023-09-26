
(function($) {
    $(function() {
		function searchBtnHandle() {
			var episodeListTableDG = $('#episodeListTable').datagrid({
	        url: '../DHCEPRFS.web.eprajax.AjaxEpisodeView.cls',
	        queryParams: {
				Action: 'episodelist',
	            EpisodeID: EpisodeID
	        },
	        method: 'post',
	        loadMsg: '数据装载中......',
	        singleSelect: true,
	        showHeader: true,
	        fitColumns: false,
			rownumbers:false,
	        columns: [[
				{ field: 'PAAdmDate', title: '入院时间', width: 80, sortable: true },
				{ field: 'PADischgeDate', title: '出院时间', width: 80, sortable: true },
				{ field: 'PAAdmLoc', title: '科室', width: 80, sortable: true },
				{ field: 'PAPMIName', title: '姓名', width: 80, sortable: true },
				{ field: 'PAAdmDoc', title: '医生', width: 80, sortable: true },			
				{ field: 'PAAdmWard', title: '病区', width: 80, sortable: true },			
				{ field: 'PAPMINO', title: '登记号', width: 80, sortable: true },
	            { field: 'EpisodeID', title: '就诊号', width: 80, sortable: true },           
	            { field: 'PAPMIDOB', title: '出生日期', width: 100, sortable: true },
	            { field: 'PAPMIAge', title: '年龄', width: 80, sortable: true },
				{ field: 'PAPMISex', title: '性别', width: 80, sortable: true }			
			]],
			sortName: "PAAdmDate",
			sortOrder: "asc",
	        toolbar: '#episodeListTableTBar',
			onClickRow: function(index, rowData){
				 var rowEpisodeID = rowData["EpisodeID"];
				 //var htmlStr = '<iframe src="./dhc.epr.fs.bscheckrecord.csp?EpisodeID=';
			     //htmlStr += rowEpisodeID;
			     //htmlStr += '&SchemeID=';
			     //htmlStr += SchemeID;
				 //htmlStr += '&Count=1';
			     //htmlStr += '" frameBorder=0 scrolling=no style="z-index:-1;height:100%;width:100%;"></iframe>';
			     //$('#iframeDIV').append(htmlStr);	
			 	var url = "dhc.epr.fs.bscheckrecord.csp?EpisodeID="+rowEpisodeID+"&SchemeID="+SchemeID+"&Count=1&MrItemID=";
				$('#contentIFrame').attr("src",url);				 
			},
			onLoadSuccess: function(data){	
				//加载成功，自动选中最近一条出院就诊
				$('#episodeListTable').datagrid('selectRow',0);
			}
	    });
		var c =  $('#episodeDiv');
		var high = $(window).height()
		c.layout('resize',{
				height:high
			});
		
	    $('#episodeListTable').datagrid('reload');
		}
		searchBtnHandle();
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
		
		//初始化---------------------------------------------------------------------------------------------------------------------------------
		//就诊查询-------------------------------------------------------------------------------------------------------------------------------
				
		
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