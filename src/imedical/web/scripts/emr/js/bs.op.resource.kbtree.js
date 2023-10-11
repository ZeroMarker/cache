$(function(){
    if ($("#kbtreeLayout").layout("panel","center").panel('options').width<350)
    {
        $('#kbtreeNorth').panel('resize', {
            height: 75
        });
        $('#searchBox').searchbox({
           width:$("#kbtreeLayout").layout("panel","center").panel('options').width-10  
       });    
    }
    $('body').layout('resize');
    var SearchBoxOnTree = NewSearchBoxOnTree();
    $('#searchBox').searchbox({
        searcher:function(value,name){ 
            SearchBoxOnTree.Search($('#kbTree'), value, function (node, searchCon) {
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
        },
        prompt : emrTrans('输入知识库名称搜索')
    });
    
    $('#kbTree').tree({
        onClick: function(node){
            //展示节点内容
            if (node.type == "KBNode"){
                getKBNodeTextByKBNodeID(node.id);
            }else{
                if (document.getElementById("kbNodeText").innerHTML){
                    $("#kbNodeText").css("overflow-y","hidden");
                    $("#kbNodeText").empty();
                }
            }
        },
        onDblClick: function(node){
            if (node.type == "KBNode"){
                var args = {
                    action: "APPEND_KBFRAGMENT",
                    params:{
                        id: node.id
                    },
                    product: product
                };
                parent.EmrEditor.execute(args);
            } else {
                $(this).tree("toggle", node.target);
            }
        },
        onContextMenu: function(e, node){
            if (node.type != "KBNode"){
                return;
            }
            e.preventDefault();
            $('#kbTree').tree('select', node.target);
            $('#mm').menu('show', {left: e.pageX, top: e.pageY});
        }
    });
    //替换知识库节点
    document.getElementById("replaceKBNode").onclick = function(){ 
        var tipMsg = "是否确定替换该知识库?";
        top.$.messager.confirm("操作提示", tipMsg, function (r) {
            if (r)
            {
                var node = $('#kbTree').tree('getSelected');
                var args = {
                    action: "REPLACE_KBFRAGMENT",
                    params:{
                        id: node.id
                    },
                    product: product
                };
                parent.EmrEditor.execute(args);
            }
            else
            {
                return;
            }
        });
    }
    if (parent.emrService && '' != parent.emrService.sectionArgs){
        getKBNodeByTreeID(parent.emrService.sectionArgs);
        parent.emrService.refreshKBFunc = getKBNodeByTreeID;
    }
    window.onunload = function(){
        parent.emrService.refreshKBFunc = null;
    }
});

function getKBNodeTextByKBNodeID(kbNodeID){
    var args = {
        action: "KBFRAGMENT_TO_TEXT",
        params:{
            id: kbNodeID
        },
        product: product
    };
    var commandJson = parent.EmrEditor.syncExecute(args);
    if ("fail" === commandJson.result){
        $.messager.alert("发生错误", "获取知识库节点文本内容失败:"+commandJson.error, "error");
        console.log(commandJson);
    }else{
        var KBNodeText = commandJson.params;
        if (KBNodeText){
            $("#kbNodeText").css("overflow-y","auto");
            document.getElementById("kbNodeText").innerHTML = KBNodeText;
        }else{
            $("#kbNodeText").css("overflow-y","hidden");
            $("#kbNodeText").empty();
        }
    }
}

//传入kbTree的id查找权限下的kbNode节点
function getKBNodeByTreeID(kbParam){
    if (typeof kbParam === "undefined" || kbParam === ""){
        return;
    }
    var kbBseId = "";
    if (isExistVar(kbParam.bindKBId)){
        kbBseId = kbParam.bindKBId;
    }
    
    var diseaseID = "";
    if (isExistVar(kbParam.diseaseID)){
        diseaseID = kbParam.diseaseID;
    }
    
    var rootNode = $('#kbTree').tree('getRoot');
    if (rootNode){
        $('#kbTree').tree('remove',rootNode.target);
    }
    $("#kbNodeText").css("overflow-y","hidden");
    $("#kbNodeText").empty();
    
    if (kbBseId == ""){
        return;
    }
    getBindKBNode(kbBseId, diseaseID, true);

}

function getBindKBNode(nodeBaseID, diseaseID, isAsync){
    isAsync = isAsync || true;
    var args = {
        action: "GET_BINDKBNODE",
        params:{
            episodeID: episodeID,
            userID: userID,
            userLocID: userLocID,
            nodeBaseID: nodeBaseID,
            diseaseID: diseaseID
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
        if (data){
            $('#kbTree').tree({data: data});
        }
    }, function (error) {
        $.messager.alert("发生错误", "getBindKBNode error:"+error, "error");
    }, isAsync);
}

function SwitchChange(event,value)
{
    if (value.value == true){
        $('#kbTree').tree('collapseAll');
    }else{
        $('#kbTree').tree('expandAll');
    }
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

//tree扩展
$.extend($.fn.tree.methods,{
    getLeafChildren: function(jqTree, params) {
        var nodes = [];
        $(params).next().children().children("div.tree-node").each(function() {
            nodes.push($(jqTree[0]).tree("getNode", this));
        });
        return nodes;
    },
    scrollTo: function(jqTree, param) {
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