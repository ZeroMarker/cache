
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
        },
        onLoadSuccess : function (node,data){
	        if(isCollapse == "1") {
		        $(this).tree('expandAll');    //全部展开
		    }else if(isCollapse == "0") {
			    $(this).tree('collapseAll');    //全部折叠
			}else if(isCollapse == "2") {
				var root = $(this).tree('getRoot');  //展开到目录节点
		        var nodes = $(this).tree('getChildren', root.target);
		        for (var i=0;i<nodes.length;i++)
				{
					if ($(this).tree('getParent',nodes[i].target).id == "")
				    {
					    $(this).tree('collapse',nodes[i].target); 
					}
				}
			}
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
                var attr = node.attributes || {};
                var py = attr.py || '';
                var flag = (node.text.indexOf(searchCon) >= 0 || py.indexOf(searchCon.toUpperCase()) >= 0);
                
                return flag;
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
