var returnValue=""
function initTemplateTree(treeData) {

    $('#templateTree').tree({
        data : treeData,
        formatter : function (node) {
            var s = emrTrans(node.text);
            if (node.children) {
                if (node.children.length == 0)
            	{
  		          	node.state="closed"
            	}
            	else
            	{
	            	s += '&nbsp;<span style="color:blue">(' + node.children.length + ')</span>';
	            }
            }
            return s;
        },
        onDblClick : function (node) {
            if ($(this).tree('isLeaf', node.target)) {
                if (node) {
                    //门诊HisUI页面风格改造-模板选择页面 add by niucaicai 2018-06-20
                    parent.TempClassifyBtnClick(node);
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

//获取科室模板目录结构
function getTreeData(initTreeFunc) {
    var patInfo = parent.patInfo;

    var data = ajaxDATA('Stream', 'EMRservice.BL.BLOPClientCategory', 'GetTemplateClassifyForHISUI', patInfo.EpisodeID, patInfo.UserLocID, patInfo.UserID, patInfo.SsgroupID);
    ajaxGET(data, function (ret) {
        initTreeFunc($.parseJSON(ret));
    }, function (ret) {
        alert('GetTemplateClassify ' + ' error:' + ret);
    });
}

//获取个人模板目录结构
function getPersonalTreeData(initTreeFunc) {
    var patInfo = parent.patInfo;
    
	var data = ajaxDATA('Stream', 'EMRservice.BL.BLOPClientCategory', 'GetPersonalTemplatesForHISUI', patInfo.EpisodeID, patInfo.UserLocID, patInfo.UserID, patInfo.SsgroupID);
    ajaxGET(data, function (ret) {
        initTreeFunc($.parseJSON(ret));
    }, function (ret) {
        alert('GetPersonalTemplates ' + ' error:' + ret);
    });
}

$(function () {
    $HUI.radio("[name='template']",{
	    onChecked:function(e,value){
            var ID = $(e.target).attr("id");
            if (ID == "personal")
			{
				getPersonalTreeData(initTemplateTree);
			}
			else
			{
				getTreeData(initTemplateTree);
			}
	    }
    });	 
    
    var SearchBoxOnTree = NewSearchBoxOnTree();
    $('#searchBox').searchbox({
        searcher : function (value, name) {
            SearchBoxOnTree.Search($('#templateTree'), value, function (node, searchCon) {
                return (node.text.indexOf(searchCon) >= 0);
            });
        },
        prompt : emrTrans('请输入查询关键字')
    });

    $('#searchPnl').panel({
        onResize : function (width, height) {
            $('#searchBox').searchbox('resize', width - 6);
        }
    });

    getTreeData(initTemplateTree);
    
    $('#confirm').click(function () {
        var node = $('#templateTree').tree('getSelected');
        if (node) {
            //门诊HisUI页面风格改造-模板选择页面 add by niucaicai 2018-06-20
            //parent.TempClassifyBtnClick(node);
            returnValue = node;
            clossWindow();
        } else {
	        return;
	    }
    });
    $('#cancel').click(function () {
        //门诊HisUI页面风格改造-模板选择页面 add by niucaicai 2018-06-20
        //parent.TempClassifyBtnClick("cancel");
        clossWindow();
    });
});

function clossWindow()
{
	parent.closeDialog('tempClassifyWin');
}