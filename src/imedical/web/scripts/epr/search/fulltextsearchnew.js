//全局
var FullTextSearch = FullTextSearch || {
	FQGroupIDs: '',
	FavorMREpisodeID: '',
	FavorMRVerItemID: '',
	QueryInput: ''
};

(function (win) {
	$(function () {
		//solr连接
		Manager = new AjaxSolr.Manager({
			solrUrl: solrUrl
		});
		
		//添加返回结果
		Manager.addWidget(new AjaxSolr.ResultWidget({
			id: 'docs',
			target: '#docs'
		}));
		
		//添加分页
		Manager.addWidget(new AjaxSolr.PagerWidget({
			id: 'pager',
			target: '#pager',
			prevLabel: '上一页',
			nextLabel: '下一页',
			innerWindow: 5
		}));
		
		function enter4Request(inputQueryString) {
			Manager.init();
			Manager.store.remove('fq');
			
			//q - 待查询语句
			//hl - 高亮开关
			//hl.fl - 要高亮的filed
			//hl.simple.pre - 高亮文本的前置标签
			//hl.simple.post - 高亮文本的后置标签
			//hl.fragsize - 高亮文本所在前后的字符数，比如搜索北京，则这个设置返回北京这个词前100个字符和后100个字符 为结果
			//hl.snippets - 一个field中同一个高亮词高亮的数，比如搜索北京，在一个field中一共有10个北京要是snippets设 为3，只显示前3个
			var params = null;
			params = {
				'q': inputQueryString,
				'q.op': queryOption,
				'hl': 'true',
				'hl.fl': '*',
				'hl.simple.pre': '<span class="highlighting"><font color="red">',
				'hl.simple.post': '</font></span>',
				'hl.fragsize': '300',
				'hl.snippets': '100'
			};
			
			for (var name in params) {
				Manager.store.addByValue(name, params[name]);
			}
			
			var strs = new Array();
			strs = FullTextSearch.FQGroupIDs.split('|');
			for (var i=0;i<strs.length;i++) {
				var fq = '';
				var groupID = strs[i].split('^')[0];
				var nodes = $('#fqpgTree' + groupID).tree('getChecked');    // 获取所有选中的行
				if (nodes&&nodes.length>0) {
					var node = null;
					for (var j=0;j<nodes.length;j++) {
						var node = nodes[j];
						var itemID = node.id;
						var nodeStrs = new Array();
						nodeStrs = itemID.split('_');
						if (nodeStrs[0] == 'SG') {
							continue;
						}
						var group = node.attributes.groupName;
						if (fq == '') {
							fq = group + ':' + itemID;
						}
						else {
							fq = fq + ' || ' + group + ':' + itemID;
						}
					}
				}
				if (fq != '') {
					Manager.store.addByValue('fq', fq);
				}
			}
			
			var ret = '';
			var obj = $.ajax({ url: '../DHCEPRSearch.web.eprajax.AjaxExportQuery.cls?Action=getmrepisodeids&UserID=' + userID, async: false });
			var ret = obj.responseText;
			if ((ret != '') || (ret != null)) {
				Manager.store.addByValue('fq', ret);
			}
			if (wordCollect == 'Y') {
				if ((inputQueryString != '' )|| (inputQueryString != null)) {
					var objAddWord = $.ajax({ url: '../DHCEPRSearch.web.eprajax.AjaxCustomWordDic.cls?Action=addword&Word=' + encodeURI(inputQueryString) + '&CTLocID=' + ctLocID + '&SSGroupID=' + ssGroupID + '&UserID=' + userID, async: false });
				}
			}
			
			Manager.doRequest();
		}
		
		$('#query').searchbox({
			width: 500,
			prompt: '请输入查询关键字',
			searcher: function(value) {
				FullTextSearch.QueryInput = value;
				doSearch(value);
			}
		});
		
		function doSearch(qValue) {
			$('#saveQuery').val(qValue);
			if (qValue != '') {
				enter4Request(qValue);
			}
			else {
				enter4Request('*:*');
			}
		}
		
		$('#fqpg').accordion({
			width: 340,
			border: false,
			multiple: true
		});
		
		initFilter();  //初始化过滤条件
		
		function initFilter() {
			var obj = $.ajax({ url: '../DHCEPRSearch.web.eprajax.AjaxFilterQueryItem.cls?Action=group', async: false });
			var ret = obj.responseText;
			FullTextSearch.FQGroupIDs = ret;
			var arrFQGroup = ret.split('|');
			for(var i=0;i<arrFQGroup.length;i++) {
				var arrOneGroup = arrFQGroup[i].split('^');
				var groupID = arrOneGroup[0];
				var groupName = arrOneGroup[1];
				var groupDesc = arrOneGroup[2];
				$('#fqpg').accordion('add', {
					id: 'accPanel-' + groupID,
					title: groupDesc,
					selected: false
				});
				$('#accPanel-' + groupID).html('<ul id="fqpgTree' + groupID + '" class = "hisui-tree"></ul>');
				$('#fqpgTree' + groupID).tree({
					url: '../DHCEPRSearch.web.eprajax.AjaxFilterQueryItem.cls?Action=treebyhosp&FQCategoryID=' + groupID+"&HospID="+hospID,
					checkbox: 'true'
				});
			}
		}
		
		$('#myDocWin').dialog({
			title: '我的文库',
			iconCls: 'icon-w-star',
			closed: true,
			modal: true,
			onOpen: function() {
				$('#myDocTable').datagrid('reload');
			}
		});
		
		$('#myDocTable').datagrid({
			fit: true,
			fitColumns: true,
			toolbar: [{
				iconCls: 'icon-cancel',
				text: '取消收藏',
				handler: deleteFavorites
			}],
			rownumbers: true,
			singleSelect: true,
			pagination: true,
			sortName: 'AddDateTime',
			remoteSort: false,
			url: '../DHCEPRSearch.web.eprajax.AjaxFavorites.cls',
			queryParams: {
				Action: 'getmydoc',
				UserID: userID
			},
			columns: [[
				{field:'ck',checkbox:true},
				{field:'DocName',title:'文档名',width:80},
				{field:'Tags',title:'标签',width:80},
				{field:'Notes',title:'备注',width:80},
				{field:'AddDateTime',title:'收藏日期时间',width:80}
			]],
			onDblClickRow: function(rowIndex,rowData) {
				var url = cspBaseUrl + 'dhc.epr.search.pdfview4chrome.csp?DataServiceUrl=' + dataServiceUrl + '&MREpisodeID=' + rowData["MREpisodeID"] + '&MRVerItemsIDs=' + rowData["MRVerItemID"];
				window.open(url);
			}
		});
		
		$('#myDocButton').on('click',function() {
			$('#myDocWin').dialog('open');
		});
		
		function deleteFavorites() {
			var row = $('#myDocTable').datagrid('getSelected');
			if (row) {
				$.messager.confirm("取消收藏","是否取消当前收藏记录",function(r){
					if (r) {
						$.ajax({
							url: '../DHCEPRSearch.web.eprajax.AjaxFavorites.cls',
							data: {
								Action: 'delete',
								FavoritesID: row.FavoritesID
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
			else {
				$.messager.alert('错误','请先选择一条收藏记录！','error');
				return;
			}
		}
		
		//获取选中行
		function getOperListID(operType) {
			var retListID = '';
			var rows = $('#mrlist').datagrid('getSelections');
			if (rows.length == 0) {
				$.messager.alert('提示','选中0行','info');
			}
			else if ((rows.length > 1)&&(operType == 'back')) {
				$.messager.alert('提示','选中多行','info');
			}
			else {
				var arrOperList = [];
				for(var i=0;i<rows.length;i++) {
					arrOperList.push(rows[i].MREpisodeID);
				}
				retListID = arrOperList.join('^');
			}
			return retListID;
		}
		
		//审核通过
		$('#btnPass').on('click',function(){
			var strListID = getOperListID('pass');
			if (strListID != '') {
				$.m({
					ClassName: 'DHCEPRFS.BL.BLReview',
					MethodName: 'BatchReviewPass',
					AMREpisodeIDList: strListID,
					AUserID: userID
				},function(txtData) {
					if (parseInt(txtData)<1) {
						$.messager.popover({
							msg: '审核操作失败！',
							type: 'error',
							timeout: 2000
						});
						return;
					}
					else {
						$.messager.popover({
							msg: '审核操作成功！',
							type: 'success',
							timeout: 2000
						});
						searchReviewList();
					}
				});
			}
		});
		
		$('#importWin').dialog({
			title: '导入结果',
			iconCls: 'icon-w-find',
			closed: true,
			modal: true,
			onOpen: function() {
				$('#importTable').datagrid('reload');
			},
			onClose: function() {
				doSearch(FullTextSearch.QueryInput);
			}
		});
		
		$('#importTable').datagrid({
			fit: true,
			fitColumns: true,
			toolbar: [{
				iconCls: 'icon-import',
				text: '导入搜索范围',
				handler: importData
			},{
				iconCls: 'icon-remove',
				text: '去除搜索范围',
				handler: removeImport
			}],
			rownumbers: true,
			singleSelect: true,
			pagination: true,
			sortName: 'exportDateTime',
			remoteSort: false,
			url: '../DHCEPRSearch.web.eprajax.AjaxExportQuery.cls',
			queryParams: {
				UserID: userID
			},
			columns: [[
				{field:'ck',checkbox:true},
				{field:'exportDateTime',title:'导入时间',width:80},
				{field:'disLocName',title:'出院科室',width:80},
				{field:'startDisDate',title:'出院起始日期',width:80},
				{field:'endDisDate',title:'出院结束日期',width:80}
			]],
			view: detailview,
			detailFormatter: function(index,row) {
				return '<div style="padding:2px"><table class="ddv" id="ddv' + row["exportID"] + '"></table></div>';
			},
			onExpandRow: function(index,row) {
				var ddv = $(this).datagrid('getRowDetail',index).find('table.ddv');
				ddv.datagrid({
					weight: 'auto',
					height: 'auto',
					fitColumns: true,
					rownumbers: true,
					singleSelect: false,
					url: '../DHCEPRSearch.web.eprajax.AjaxExportQuery.cls',
					queryParams: {
						Action: 'detail',
						ExportID: row['exportID']
					},
					columns: [[
						{field:'MrEpisode',title:'MrEpisode',width:200}
					]],
					onResize: function() {
						$('#importTable').datagrid('fixDetailRowHeight',index);
					},
					onLoadSuccess: function() {
						setTimeout(function() {
							$('#importTable').datagrid('fixDetailRowHeight',index);
						}, 0);
					}
				});
				$('#importTable').datagrid('fixDetailRowHeight',index);
			}
		});
		
		$('#importButton').on('click',function() {
			$('#importWin').dialog('open');
		});
		
		function importData() {
			var rows = $('#importTable').datagrid('getChecked');
			var exportID = rows[0]['exportID'];
			var obj = $.ajax({ url: '../DHCEPRSearch.web.eprajax.AjaxExportQuery.cls?Action=update&ExportID=' + exportID + '&UserID=' + userID, async: false });
			var ret = obj.responseText;
			$('#importWin').dialog('close');
		}
		
		function removeImport() {
			var obj = $.ajax({ url: '../DHCEPRSearch.web.eprajax.AjaxExportQuery.cls?Action=remove&UserID=' + userID, async: false });
			var ret = obj.responseText;
			$('#importWin').dialog('close');
		}
		
		$('#saveWin').dialog({
			title: '添加收藏',
			iconCls: 'icon-w-add',
			closed: true,
			modal: true,
			buttons: [{
				text: '保存',
				handler: function() {
					var docName = $('#name').val();
					var notes = $('#notes').val();
					var tags = $('#tags').val();
					$.ajax({
						url: '../DHCEPRSearch.web.eprajax.AjaxFavorites.cls',
						data: {
							Action: 'add',
							MREpisodeID: FullTextSearch.FavorMREpisodeID,
							MRVerItemsID: FullTextSearch.FavorMRVerItemID,
							UserID: userID,
							DocName: docName,
							Notes: notes,
							Tags: tags
						},
						method: 'post',
						async: false,
						success: function(data) {
							if (parseInt(data) >= 1) {
								$.messager.alert('提示','收藏成功','info',function(data) {
									$('#saveWin').dialog('close');
								});
							}
							else {
								$.messager.alert('提示','收藏失败，请重新尝试','error',function(data) {
									$('#saveWin').dialog('close');
								});
							}
						}
					});
				}
			},{
				text: '清空',
				handler: function() {
					$('#name').val('');
					$('#notes').val('');
					$('#tags').val('');
					$('#category').val('');
				}
			},{
				text: '关闭',
				handler: function() {
					$('#saveWin').dialog('close');
				}
			}]
		});
	});
}(window));