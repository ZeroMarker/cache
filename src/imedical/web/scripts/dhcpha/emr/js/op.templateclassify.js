
function initTemplateTree(treeData) {

	$('#templateTree').tree({
		data : treeData,
		formatter : function (node) {
			var s = node.text;
			if (node.children) {
				s += '&nbsp;<span style="color:blue">(' + node.children.length + ')</span>';
			}
			return s;
		},
		onDblClick : function (node) {
			//$(this).tree('beginEdit',node.target);
			if ($(this).tree('isLeaf', node.target)) {
				if (node && node.id) {
					window.returnValue = node.id;
					closeWindow();
				}
			} else {
				$(this).tree('toggle', node.target)
			}
		},
		onBeforeSelect : function (node) {
			if (node.id)
				return true;
			else
				return false;
		}
	});
}

function getTreeData(initTreeFunc) {
	//debugger;
	var patInfo = window.dialogArguments;

	var data = ajaxDATA('Stream', 'EMRservice.BL.BLOPClientCategory', 'GetTemplateClassify', patInfo.EpisodeID, patInfo.UserLocID, patInfo.UserID, patInfo.SsgroupID);

	ajaxGET(data, function (ret) {
		initTreeFunc($.parseJSON(ret));
	}, function (ret) {
		alert('GetTemplateClassify ' + ' error:' + ret);
	});
}

$(function () {

	var SearchBoxOnTree = NewSearchBoxOnTree();
	$('#searchBox').searchbox({
		searcher : function (value, name) {
			SearchBoxOnTree.Search($('#templateTree'), value, function (node, searchCon) {
				return (node.text.indexOf(searchCon) >= 0);
			});
		},
		prompt : '请输入查询关键字'
	});

	$('#searchPnl').panel({
		onResize : function (width, height) {
			$('#searchBox').searchbox('resize', width - 6);
		}
	});

	getTreeData(initTemplateTree);

	window.returnValue = 'cancel';

	$('#confirm').live('click', function () {
		var node = $('#templateTree').tree('getSelected');
		if (node && node.id) {
			window.returnValue = node.id;
		} else
			return;
		closeWindow();
	});
	$('#cancel').live('click', function () {
		window.returnValue = 'cancel';
		closeWindow();
	});
});
