$(function () {
    $HUI.radio("[name='template']",{
        onChecked:function(e,value){
            var radioID = $(e.target).attr("id");
            if (radioID == "Template"){
                tempTreeDataArgs.action = "GET_DOCCATEGORY_DATA";
            }else if(radioID == "LocTemplate"){
                tempTreeDataArgs.action = "GET_LOCCATEGORY_DATA";
            }else if (radioID == "PerTemplate"){
                tempTreeDataArgs.action = "GET_PERCATEGORY_DATA";
            }
            var treeData = getTempTreeData(tempTreeDataArgs);
            initTemplateTree(treeData);
            setUserConfig("DEFAULTTEMPLATE", radioID);
        }
    });
    
    
    $("#searchBox").searchbox({prompt : emrTrans("请输入查询关键字")});
    if (sysOption.searchTempMode == "RealQuery") {
        $("#searchBox").searchbox("textbox").bind("keyup",function(e){
            if (!tempTreeData){
                return;
            }
            var searchVal = $("#searchBox").next().children().val();
            var tmpTemplateData = findTemplate(tempTreeData, searchVal);
            $("#templateTree").tree("loadData",tmpTemplateData);
        });
    }else {
        var SearchBoxOnTree = NewSearchBoxOnTree();
        $("#searchBox").searchbox({
            searcher: function (value, name) {
                if (!tempTreeData){
                    return;
                }
                var tmpTemplateData = findTemplate(tempTreeData, value);
                $("#templateTree").tree("loadData",tmpTemplateData);
                SearchBoxOnTree.Search($("#templateTree"), value, function (node, searchCon) {
                    if (node.text.indexOf(searchCon)!=-1){
                        return true;
                    }
                    if (node.fullFight){
                        searchCon = searchCon.toUpperCase();
                        if (node.fullFight.indexOf(searchCon)!=-1){
                            return true;
                        }
                    }
                    if (node.janeSpell){
                        searchCon = searchCon.toUpperCase();
                        if (node.janeSpell.indexOf(searchCon)!=-1){
                            return true;
                        }
                    }
                    return false;
                });
            }
        });
    }

    $("#searchPnl").panel({
        onResize: function (width, height) {
            $("#searchBox").searchbox("resize", width - 100);
        }
    });

    var config = getUserConfig("DEFAULTTEMPLATE");
    if (config){
        $HUI.radio("#"+config).setValue(true);
    }else{
        $HUI.radio("#"+sysOption.defaultTemplate).setValue(true);
    }
    
    $("#confirm").click(function () {
        var node = $("#templateTree").tree("getSelected");
        if (node) {
            // 是否可以创建，不能给与提示
            createArgs.params.templateID = node.templateID;
            var rtn = isCanCreate(createArgs);
            if ("1" != rtn.canCreate){
                //$.messager.alert("提示", rtn.reason + ",不能再创建！", "info");
                parent.showEditorMsg({msg:rtn.reason + ",不能再创建！",type:"alert"});
                return;
            }
            if (isExistFunc(parent.tempCallBack)){
                parent.tempCallBack(node);
            }
        } else {
            return;
        }
    });
    $("#cancel").click(function () {
        parent.tempCallBack("");
    });
    
    if ("Y" != sysOption.isShowTmpBrowse) {
        $("#templateLayout").layout("remove","center");
    }
});

function initTemplateTree(treeData){
    tempTreeData = treeData;
    $("#templateTree").tree({
        data: treeData,
        formatter: function (node) {
            var text = emrTrans(node.text);
            if ((node.children)&&(JSON.stringify(node.children) != "[]")) {
                if (node.children.length == 0) {
                    node.state = "closed"
                }else {
                    text += '&nbsp;<span style="color:blue">(' + node.children.length + ')</span>';
                }
            }
            return text;
        },
        onClick: function(node) {
            if (sysOption.isShowTmpBrowse == "Y" ) {
                if ($(this).tree("isLeaf", node.target)) {
                    if (node) {
                        loadTemplate(node);
                    }
                } else {
                    $(this).tree("toggle", node.target);
                }
            }
        },
        onDblClick: function (node) {
            if ($(this).tree("isLeaf", node.target)) {
                if (node) {
                    // 是否可以创建，不能给与提示
                    createArgs.params.templateID = node.templateID;
                    var rtn = isCanCreate(createArgs);
                    if ("1" != rtn.canCreate){
                        //$.messager.alert("提示", rtn.reason + ",不能再创建！", "info");
                        parent.showEditorMsg({msg:rtn.reason + ",不能再创建！",type:"alert"});
                        return;
                    }
                    if (isExistFunc(parent.tempCallBack)){
                        parent.tempCallBack(node);
                    }
                }
            } else {
                $(this).tree("toggle", node.target)
            }
        },
        onBeforeSelect: function (node) {
            if (node.id) {
                return true;
            }else {
                return false;
            }
        },
        onLoadSuccess : function (node,data){
            //重设开关状态
            $("#switch").switchbox("setValue",sysOption.isCollapse == "1"?false:true)
            if(sysOption.isCollapse == "1") {
                $(this).tree("expandAll");    //全部展开
            }else if(sysOption.isCollapse == "0") {
                $(this).tree("collapseAll");    //全部折叠
            }else if(sysOption.isCollapse == "2") {
                var root = $(this).tree("getRoot");  //展开到二级目录节点
                var nodes = $(this).tree("getChildren", root.target);
                for (var i=0;i<nodes.length;i++) {
                    if (($(this).tree("getParent",nodes[i].target).id == "")||($(this).tree("getParent",nodes[i].target).id == "0")) {
                        $(this).tree("collapse",nodes[i].target); 
                    }
                }
            }
        }
    });
}

function loadTemplate(node){
    var args = {
        action: "LOAD_TEMPLATEBYTID",
        params: {
            templateID: node.templateID,
            sourceID: node.sourceID,
            sourceType: node.sourceType
        },
        product: envVar.product
    };
    var switchPluginType = false;
    if (pluginType != node.pluginType){
        switchPluginType = true;
    }
    if (!document.getElementById("bsTempEditor").innerHTML || switchPluginType){
        pluginType = node.pluginType;
        EmrEditor.initEditor({
            rootID: "#bsTempEditor",
            product: envVar.product,
            patInfo: patInfo,
            parameters:{
                status: "browse",
                region: "content",
                revise: {
                    del: {
                        show: "0"
                    },
                    add: {
                        show: "0"
                    },
                    style: {
                        show: "0"
                    }
                }
            },
            pluginType: pluginType,
            MWToken: getMWToken(),
            editorEvent: editorEvent,
            commandJson: args
        });
    }else{
        EmrEditor.execute(args);
    }
}

//折叠/展开 开关触发
function switchCollapse(event,value){
    if (value.value == true) {
        if(sysOption.isCollapse == "2") {
            var root = $("#templateTree").tree("getRoot");  //展开到二级目录节点
            var nodes = $("#templateTree").tree("getChildren", root.target);
            for (var i=0;i<nodes.length;i++) {
                if (($("#templateTree").tree("getParent",nodes[i].target).id == "")||($("#templateTree").tree("getParent",nodes[i].target).id == "0"))
                {
                    $("#templateTree").tree("collapse",nodes[i].target); 
                }
            }
        }
        else
        {
            $("#templateTree").tree("collapseAll");
        }
    }
    else
    {
        $("#templateTree").tree("expandAll");
    }
}

//查询检索
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
            }else{
                value = value.toUpperCase();
                if (data[i].fullFight.indexOf(value)!=-1){
                    result.push(data[i]);
                }else if (data[i].janeSpell.indexOf(value)!=-1){
                    result.push(data[i]);
                }
            }
        }
    }
    return result;
}
// tree检索
function NewSearchBoxOnTree() {
    var SearchBoxOnTree = new Object();
    SearchBoxOnTree.ContinueID = '';
    SearchBoxOnTree.Search = function ($tree, value, isMatchFunc) {
        var searchCon = $('#searchBox').searchbox('getValue');
        if ('' == searchCon)
            return;
        var rootNode = $tree.tree('getRoot');
        if (null == rootNode)
            return false;

        function setContinueID(rootNode) {
            var startNode = $tree.tree('getSelected');

            if (startNode != null && startNode.id != rootNode.id) {
                SearchBoxOnTree.ContinueID = startNode.id;
            } else {
                SearchBoxOnTree.ContinueID = '';
            }
        }

        function selectNode(node) {
            $tree.tree('select', node.target);
        }

        function expandParent(node) {
            var parentNode = node;
            var t = true;
            do {
                parentNode = $tree.tree('getParent', parentNode.target); //获取此节点父节点
                if (parentNode) { //如果存在
                    t = true;
                    $tree.tree('expand', parentNode.target);
                } else {
                    t = false;
                }
            } while (t);
        }

        //查找子节点，查找到了 true， 返回false继续查找
        function searchChild(startNode) {
            var children = $tree.tree('getChildren', startNode.target);
            if (!children)
                return false;
            var flag = false;

            for (var j = 0; j < children.length; j++) {
                //判断节点是否为子节点
                if (!$tree.tree('isLeaf', children[j].target)) { 
                    continue; 
                }    
                if ('' != SearchBoxOnTree.ContinueID) {
                    if (SearchBoxOnTree.ContinueID == children[j].id) {
                        flag = true;
                        continue;
                    }
                    if (!flag) {
                        continue;
                    }
                }
                if (isMatchFunc(children[j], searchCon)) {
                    selectNode(children[j]);
                    expandParent(children[j]);
                    $tree.tree('scrollTo');
                    return true;
                }
            }

            return false;
        }

        if (searchChild(rootNode)) {
            setContinueID(rootNode);
        } else {
            SearchBoxOnTree.ContinueID = '';
            if (searchChild(rootNode)) {
                setContinueID(rootNode);
            }
        }
    }

    return SearchBoxOnTree;
}

$.extend($.fn.tree.methods, {
    getLeafChildren: function(jqTree, params) {
        var nodes = [];
        $(params).next().children().children("div.tree-node").each(function() {
            nodes.push($(jqTree[0]).tree('getNode', this));
        });
        return nodes;
    },
    /** 
     * 将滚动条滚动到指定的节点位置，使该节点可见（如果有滚动条才滚动，没有滚动条就不滚动） 
     * @param param { 
     *    treeContainer: easyui tree的容器（即存在滚动条的树容器）。如果为null，则取easyui tree的根UL节点的父节点。 
     *    targetNode:  将要滚动到的easyui tree节点。如果targetNode为空，则默认滚动到当前已选中的节点，如果没有选中的节点，则不滚动 
     * }  
     */
    scrollTo: function(jqTree, param) {
        //easyui tree的tree对象。可以通过tree.methodName(jqTree)方式调用easyui tree的方法  
        var tree = this;
        //如果node为空，则获取当前选中的node  
        var targetNode = param && param.targetNode ? param.targetNode : tree.getSelected(jqTree);

        if (targetNode != null) {
            //判断节点是否在可视区域
            var root = tree.getRoot(jqTree);
            var $targetNode = $(targetNode.target);
            var container = param && param.treeContainer ? param.treeContainer : jqTree.parent();
            var containerH = container.height();
            var nodeOffsetHeight = $targetNode.offset().top - container.offset().top;
            if (nodeOffsetHeight > (containerH - 30)) {
                var scrollHeight = container.scrollTop() + nodeOffsetHeight - containerH + 30;
                container.scrollTop(scrollHeight);
            }else {
                container.scrollTop(0);
            }
        }
    }
});

var editorEvent = {
    eventloadglobalparameters: function(commandJson){
        if ("fail" === commandJson.result){
            console.log(commandJson);
        }
    },
    eventloadtemplateByID: function(commandJson){
        if ("fail" === commandJson.result){
            //parent.showEditorMsg({msg:"加载模板失败！具体原因请查看F12输出",type:"error"});
            $("#bsTempEditor").css("display","none");
            console.log(commandJson);
            return;
        }
        var display = $("#bsTempEditor").css("display");
        if ("none" === display){
            $("#bsTempEditor").css("display","block");
        }
    }
};

function setUserConfig(configType,configData){
    var data = {
        action: "SET_USER_CONFIG",
        params:{
            userID: patInfo.userID,
            userLocID: patInfo.userLocID,
            configType: configType,
            configData: configData
        },
        product: envVar.product
    };
    ajaxPOSTCommon(data, function(ret){
        if (!ret){
            console.log("保存用户配置数据失败！");
        }
    }, function (error) {
        $.messager.alert("发生错误", "setUserConfig error:"+error, "error");
    }, true);
}

function getUserConfig(configType){
    var rtn = "";
    var data = {
        action: "GET_USER_CONFIG",
        params:{
            userID: patInfo.userID,
            userLocID: patInfo.userLocID,
            configType: configType
        },
        product: envVar.product
    };
    ajaxGETCommon(data, function(ret){
        if (ret){
            rtn = ret;
        }
    }, function (error) {
        $.messager.alert("发生错误", "getUserConfig error:"+error, "error");
    }, false);
    return rtn;
}

function getTempTreeData(data){
    var rtn = "";
    ajaxGETCommon(data, function(ret){
        rtn = ret;
    }, function (error) {
        $.messager.alert("发生错误", "getTempTreeData error:"+error, "error");
    }, false);
    return rtn;
}

function isCanCreate(data){
    var rtn = "";
    ajaxGETCommon(data, function(ret){
        rtn = ret;
    }, function (error) {
        $.messager.alert("发生错误", "isCanCreate error:"+error, "error");
    }, false);
    return rtn;
}