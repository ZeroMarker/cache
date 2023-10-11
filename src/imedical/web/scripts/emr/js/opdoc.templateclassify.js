function initTemplateTree(treeData) {
    TempData = treeData;
    $('#templateTree').tree({
        data : treeData,
        formatter : function (node) {
            var s = emrTrans(node.text);
            if ((node.children)&&(JSON.stringify(node.children) != "[]")) {
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
        onClick : function(node) {
            if (sysOption.isShowTmpBrowse == "Y" ) {
	            if (typeof(loadTemplateTimeOutFunc) != "undefined") clearTimeout(loadTemplateTimeOutFunc);
	            var element = $(this)
	           	loadTemplateTimeOutFunc = setTimeout(function() {
		           	if (element.tree('isLeaf', node.target)) {
	                    if (node) {
	                        loadTemplate(node);
	                    }
	                }
		        },300);
            }
        },
        onDblClick : function (node) {
            //模板预览页面，预览过程中选择模板创建，会导致在浏览器左上角多显示一个编辑器
            if (sysOption.isShowTmpBrowse == "Y" ) {
                if (typeof(loadTemplateTimeOutFunc) != "undefined") clearTimeout(loadTemplateTimeOutFunc);
                if (loadFlag) {
                    parent.showEditorMsg({msg:'模板预览中，请稍后重试...', type:'info'});
                    return;
                }
            }

            if ($(this).tree('isLeaf', node.target)) {
                if (node) {
	                 returnValue = "1";
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
        },
        onLoadSuccess : function (node,data){
            //重设开关状态
	        $("#switch").switchbox("setValue",isCollapse == "1"?false:true)
	        if(isCollapse == "1") {
		        $(this).tree('expandAll');    //全部展开
		    }else if(isCollapse == "0") {
			    $(this).tree('collapseAll');    //全部折叠
			}else if(isCollapse == "2") {
				var root = $(this).tree('getRoot');  //展开到二级目录节点
		        var nodes = $(this).tree('getChildren', root.target);
		        for (var i=0;i<nodes.length;i++)
				{
					if (($(this).tree('getParent',nodes[i].target).id == "")||($(this).tree('getParent',nodes[i].target).id == "0"))
				    {
					    $(this).tree('collapse',nodes[i].target); 
					}
				}
			}
	    }
    });
}

//折叠/展开 开关触发
function switchCollapse(event,value)
{
	if (value.value == true)
	{
		if(isCollapse == "2") 
		{
			var root = $('#templateTree').tree('getRoot');  //展开到二级目录节点
	        var nodes = $('#templateTree').tree('getChildren', root.target);
	        for (var i=0;i<nodes.length;i++)
			{
				if (($('#templateTree').tree('getParent',nodes[i].target).id == "")||($('#templateTree').tree('getParent',nodes[i].target).id == "0"))
			    {
				    $('#templateTree').tree('collapse',nodes[i].target); 
				}
			}
		}
		else
		{
			$('#templateTree').tree('collapseAll');
		}
	}
	else
	{
		$('#templateTree').tree('expandAll');
	}
}

//获取科室模板目录结构
function getTreeData(initTreeFunc) {
    var categoryID = parent.envVar.CategoryID;
    var data = ajaxDATA('Stream', 'EMRservice.BL.BLOPClientCategory', 'GetTemplateClassifyForHISUI', patInfo.EpisodeID, patInfo.UserLocID, patInfo.UserID, patInfo.SsgroupID, categoryID);
    ajaxGET(data, function (ret) {
        initTreeFunc($.parseJSON(ret));
    }, function (ret) {
        alert('GetTemplateClassify ' + ' error:' + ret);
    });
}

//获取个人模板目录结构
function getPersonalTreeData(initTreeFunc) {
	if (isShowAllPersonalTemplate == "Y") {
		var method = "GetPersonalTemplatesForHISUINew";
	} else {
		var method = "GetPersonalTemplatesForHISUI";
	}
    var data = ajaxDATA('Stream', 'EMRservice.BL.BLOPClientCategory', method, patInfo.EpisodeID, patInfo.UserLocID, patInfo.UserID, patInfo.SsgroupID);
    ajaxGET(data, function (ret) {
        initTreeFunc($.parseJSON(ret));
    }, function (ret) {
        alert('GetPersonalTemplates ' + ' error:' + ret);
    });
}
//当前模板树数据,用于查询检索
var TempData = "";
function findTemplate(data,value)
{
    var result = new Array();
    for (var i = 0; i < data.length; i++) 
    { 
        if ((data[i].children)&&(data[i].children.length >0))
        {
            var child = findTemplate(data[i].children,value)
            if ((child != "")&&(child.length >0))
            {
                var tmp = JSON.parse(JSON.stringify(data[i]));
                tmp.children = [];
                tmp.children = child;
                result.push(tmp);
            }
        }
        else
        {
            if (data[i].text.indexOf(value)!=-1){
                result.push(data[i]);
            }else if (data[i].attributes.py){
                value = value.toUpperCase();
                if (data[i].attributes.py.indexOf(value)!=-1){
                    result.push(data[i]);
                }
            }else if (data[i].attributes.SimpleSpel){
                value = value.toUpperCase();
                if (data[i].attributes.SimpleSpel.indexOf(value)!=-1){
                    result.push(data[i]);
                }
            }
        }
    }
    return result;
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
            common.addUserConfigData("OPDEFAULTTEMPLATE", ID.toUpperCase());
        }
    });
    
    $('#searchBox').searchbox({prompt : emrTrans('请输入查询关键字')});
    if (sysOption.OPTempQMode == "RealQuery") {
        $('#searchBox').searchbox("textbox").bind('keyup',function(e){
            if (TempData == ""){
                return;
            }
            var searchVal = $("#searchBox").next().children().val();
            var tmpTemplateData = findTemplate(TempData, searchVal);
            $('#templateTree').tree('loadData',tmpTemplateData);
        });
    }else {
        var SearchBoxOnTree = NewSearchBoxOnTree();
        $('#searchBox').searchbox({
            searcher : function (value, name) {
                if (TempData == ""){
                    return;
                }
                var tmpTemplateData = findTemplate(TempData, value);
                $('#templateTree').tree('loadData',tmpTemplateData);
                SearchBoxOnTree.Search($('#templateTree'), value, function (node, searchCon) {
                    if (node.text.indexOf(searchCon)!=-1){
                        return true;
                    }
                    if (node.attributes.py){
                        searchCon = searchCon.toUpperCase();
                        if (node.attributes.py.indexOf(searchCon)!=-1){
                            return true;
                        }
                    }
                    if (node.attributes.SimpleSpel){
                        searchCon = searchCon.toUpperCase();
                        if (node.attributes.SimpleSpel.indexOf(searchCon)!=-1){
                            return true;
                        }
                    }
                    return false;
                });
            }
        });
    }

    $('#searchPnl').panel({
        onResize : function (width, height) {
            $('#searchBox').searchbox('resize', width - 100);
        }
    });

    var config = common.getUserConfigData("OPDEFAULTTEMPLATE");
    if (config != ""){
        var radioID = config.toLowerCase();
        $HUI.radio("#"+radioID).setValue(true);
    }else{
        if (getPersonalTemplate == "Y")
        {
            $HUI.radio("#personal").setValue(true);
        }else{
            $HUI.radio("#loc").setValue(true);
        }
    }
    
    $('#confirm').click(function () {
        //模板预览页面，预览过程中选择模板创建，会导致在浏览器左上角多显示一个编辑器
        if (sysOption.isShowTmpBrowse == "Y" ) {
            if (loadFlag) {
                parent.showEditorMsg({msg:'模板预览中，请稍后重试...', type:'info'});
                return;
            }
        }
        
        returnValue = "1";
        var node = $('#templateTree').tree('getSelected');
        if (node) {
            //门诊HisUI页面风格改造-模板选择页面 add by niucaicai 2018-06-20
            parent.TempClassifyBtnClick(node);
        } else {
            return;
        }
    });
    $('#cancel').click(function () {
	    returnValue = "-1";
        //门诊HisUI页面风格改造-模板选择页面 add by niucaicai 2018-06-20
        parent.TempClassifyBtnClick("");
    });
    
    if (sysOption.isShowTmpBrowse == "Y" ) {
        // 初始化Plugin
        $('#pluginFrame').attr('src', 'emr.opdoc.templateclassifyEditor.csp?MWToken='+getMWToken());
    }else{
        $('#templateLayout').layout('remove','center');
    }
});