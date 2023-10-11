var FSSearchMyDoc = FSSearchMyDoc || {
	DeleteFavorites: null
};

(function($) {
	$(function() {
		FSSearchMyDoc.DeleteFavorites = deleteFavorites;
		
		//我的文库列表
		$('#myDocTable').datagrid({
			url: '../DHCEPRSearch.web.eprajax.AjaxFavorites.cls',
			queryParams: {
				Action: 'getmydoc',
				UserID: userID
			},
			method: 'post',
			loadMsg: '数据装载中......',
			singleSelect: true,
			showHeader: true,
			fitColumns: true,
			sortName: 'AddDateTime',
			remoteSort: false,
			columns: [[
				{ field: 'ck', checkbox: true },
				{ field: 'DocName', title: '文档名', width: 80 },
				{ field: 'Tags', title: '标签', width: 80 },
				{ field: 'Notes', title: '备注', width: 80 },
				{ field: 'MREpisodeID', title: 'MREpisodeID', width: 80, hidden: true },
				{ field: 'MRVerItemID', title: 'MRVerItemID', width: 80, hidden: true },
				{ field: 'AddDateTime', title: '收藏日期时间', width: 80 },
				{ field: 'DelFavoritesURL', title: '取消收藏', width: 80, align: 'center', formatter: DelFavoritesURLFormatter }
			]],
			onDblClickRow: function(rowIndex, rowData) {
				var url = cspBaseUrl + 'dhc.epr.search.pdfview.csp?DataServiceUrl=' + dataServiceUrl + '&MREpisodeID=' + rowData["MREpisodeID"] + '&MRVerItemsIDs=' + rowData["MRVerItemID"];
				window.open(url);
			}
		});
		
		//取消收藏
		function DelFavoritesURLFormatter(value,row,index) {
			return '<a href="javascript:void(0)" onclick="FSSearchMyDoc.DeleteFavorites(\''+row.FavoritesID+'\');">取消收藏</a>';
		}
		
		function deleteFavorites(favoritesID) {
			$.messager.confirm("取消收藏","是否取消当前收藏记录",function(r){
				if (r) {
					$.ajax({
						url: '../DHCEPRSearch.web.eprajax.AjaxFavorites.cls',
						data: {
							Action: 'delete',
							FavoritesID: favoritesID
						},
						type: 'post',
						async: false,
						success: function(data) {
							if (data == '1') {
								$('#myDocTable').datagrid('reload');
							}
							else {
								$.messager.alert('错误','取消收藏操作失败！','error');
								return;
							}
						},
						error: function(data) {
							$.messager.alert('错误','取消收藏操作错误，请重新尝试或联系管理员！','error');
							return;
						}
					});
				}
			});
		}
	});
})(jQuery);
