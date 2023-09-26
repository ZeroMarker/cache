(function (win) {
	$(function () {
		
		//完整性校验结果列表
		$('#checkRetTable').datagrid({
			url: "../DHCEPRFS.web.eprajax.AjaxIntegrityCheck.cls",
			queryParams: {
				Action: 'showresult',
                EpisodeID: episodeID
            },
			width: 435,
			height: 488,
			title: ruleName,
            method: 'post',
			loadMsg: '数据装载中......',
			rownumbers: true,
			showHeader: true,
            singleSelect: false,
			selectOnCheck: false,
            checkOnSelect: false,
			view: detailview,
            columns: [[
				{ field: 'CategoryCode', title: '类别编码', width: 60, sortable: true, hidden: true},
				{ field: 'CategoryName', title: '质控类别', width: 335, sortable: true},
	            { field: 'CheckResult', checkbox: true},
				{ field: 'IsNeeded', title: '必需项', width: 60, sortable: true, hidden: true}
	        ]],
			rowStyler: function(index,row){
				if (row.CheckResult == "1"){
					return 'background-color:white;color:black;';
				}
				else{
					if(row.IsNeeded == "N"){
						return 'background-color:palegreen;color:black;';
					}
					else{
						return 'background-color:red;color:white;';
					}
				}
			},
			onBeforeLoad: function(){
				var obj = $.ajax({
					url: "../DHCEPRFS.web.eprajax.AjaxIntegrityCheck.cls?Action=saveresult&EpisodeID=" + episodeID + "&UserID=" + userID,
					type: 'post',
					async: false
				});
				var ret = obj.responseText;
				if (ret != "1") {
					alert('完整性校验出现错误!');
					window.close();
					return false;
				}
				else {
					return true;
				}
			},
			onLoadSuccess:function(data){
				$('#checkRetTable').parent().find("div.datagrid-header-check").children("input[type=\"checkbox\"]").eq(0).attr("style", "display:none;");
				if(data){
					$.each(data.rows, function(index, item){
						if(item.CheckResult == "1"){
							$('#checkRetTable').datagrid('checkRow', index);
						}
						$("input[type='checkbox']")[index + 1].disabled = true;
					});
				}
			},
			detailFormatter:function(index,row){
				return '<div style="padding:2px"><table class="detailTable"></table></div>';
			},
			onExpandRow:function(index,row){
				var categoryCode = row.CategoryCode;
				var detailTable = $(this).datagrid('getRowDetail',index).find('table.detailTable');
				detailTable.datagrid({
					url: "../DHCEPRFS.web.eprajax.AjaxIntegrityCheck.cls",
					queryParams: {
						Action: 'showdetail',
						EpisodeID: episodeID,
						CategoryCode: categoryCode
					},
					weight: 'auto',
					height: 'auto',
					method: 'post',
					loadMsg: '数据装载中......',
					rownumbers: true,
					showHeader: false,
					singleSelect: false,
					selectOnCheck: false,
					checkOnSelect: false,
					columns: [[
						{ field: 'MRItemName', title: '子项', width: 302, sortable: true},
						{ field: 'CheckResult', checkbox: true},
						{ field: 'IsNeeded', title: '必需项', width: 60, sortable: true, hidden: true}
					]],
					onResize:function(){
						$('#checkRetTable').datagrid('fixDetailRowHeight',index);
					},
					rowStyler: function(index,row){
						if (row.CheckResult == "1"){
							return 'background-color:#FFE48D;color:black;';
						}
						else{
							if(row.IsNeeded == "N"){
								return 'background-color:palegreen;color:black;';
							}
							else{
								return 'background-color:white;color:black;';
							}
						}
					},
					onLoadSuccess:function(data){
						setTimeout(function(){
							$('#checkRetTable').datagrid('fixDetailRowHeight',index);
						},0);
						detailTable.parent().find("div.datagrid-header-check").children("input[type=\"checkbox\"]").eq(0).attr("style", "display:none;");
						if(data){
							$.each(data.rows, function(index, item){
								if(item.CheckResult == "1"){
									detailTable.datagrid('checkRow',index);
								}							
								detailTable.parent().find("input[type='checkbox']")[index+1].disabled = true;
							});
						}
                    }
				});
				$('#checkRetTable').datagrid('fixDetailRowHeight',index);
			}
		});
	});
}(window));