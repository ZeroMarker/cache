$(function () {
    setResize();
    var SearchBoxOnTree = NewSearchBoxOnTree();
    $("#searchBox").searchbox({
        searcher: function(value, name){
            if (dpCategoryData == ""){
                return;
            }
            var tmpData = findDPCategoryData(dpCategoryData, value);
            $("#dpCategory").tree("loadData",tmpData);
            SearchBoxOnTree.Search($("#dpCategory"), value, function (node, searchCon) {
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
        prompt: emrTrans("输入个人短语节点名称索")
    });
    $("#dpCategory").tree({
        dnd: true,
        onClick: function(node){
            //展示节点内容
            if(node.type == "DPNode"){
                var args = {
                    action: "DPFRAGMENT_TO_TEXT",
                    params:{
                        id: node.contentID
                    },
                    product: product
                };
                var commandJson = parent.EmrEditor.syncExecute(args);
                if ("fail" === commandJson.result){
                    $.messager.alert("发生错误", "获取知识库节点文本内容失败:"+commandJson.error, "error");
                    console.log(commandJson);
                }else{
                    var DPNodeText = commandJson.params;
                    if (DPNodeText){
                        $("#content").css("overflow-y","auto");
                        document.getElementById("content").innerHTML = DPNodeText;
                    }else{
                        if (document.getElementById("content").innerHTML){
                            $("#content").css("overflow-y","hidden");
                            $("#content").empty();
                        }
                    }
                }
            }else{
                $("#content").css("overflow-y","hidden");
                $("#content").empty();
            }
        },
        onDblClick: function(node){
            if (node.type.indexOf("DPNode")!= -1){
                var args = {
                    action: "APPEND_DPFRAGMENT",
                    params:{
                        id: node.contentID
                    },
                    product: product
                };
                parent.EmrEditor.execute(args);
            } else {
                $(this).tree("toggle", node.target);
            }
        },
        onContextMenu: function(e, node){
            treeRightClick(e,node);
        },
        onLoadSuccess: function(node,data){
            updateIcon(data);
        },
        onBeforeSelect : function (node) {
            if (node.id){
                return true;
            }else{
                return false;
            }
        },
        onBeforeDrag: function (node) {
            if (node.type == "DPTreeBase"){
                return false;
            }
        },
        onBeforeDrop: function (targetNode, source, point) {
            //拖动节点
            var sNode = $("#dpCategory").tree('getNode', targetNode);
            //释放节点
            var tNode = source;
            //拖动目录
            if (tNode.type == "DPTree") 
            {
                //释放在根目录
                if (sNode.type == "DPTreeBase")
                {
                    if((point == "top")||(point == "bottom"))
                    {
                        $.messager.alert('提示','不可放至此位置', 'info');
                        return false;
                    }else{
                        swapParentNode = $("#dpCategory").tree("getParent",tNode.target);
                    }
                }
                //释放在目录
                else if (sNode.type == "DPTree")
                {
                    swapParentNode = $("#dpCategory").tree("getParent",tNode.target);
                }
                //释放在节点
                else if(sNode.type == "DPNode")
                {
                    $.messager.alert('提示','不可放至此位置', 'info');
                    return false;
                }
            }
            //拖动节点
            else 
            {
                //释放在根目录
                if (sNode.type == "DPTreeBase")
                {
                    if((point == "top")||(point == "bottom"))
                    {
                        $.messager.alert('提示','不可放至此位置', 'info');
                        return false;
                    }else{
                        swapParentNode = $("#dpCategory").tree("getParent",tNode.target);
                    }
                }
                //释放在目录
                else if (sNode.type == "DPTree")
                {
                    if((point == "top")||(point == "bottom"))
                    {
                        $.messager.alert('提示','不可放至此位置', 'info');
                        return false;
                    }else{
                        swapParentNode = $("#dpCategory").tree("getParent",tNode.target);
                    }
                }
                //释放在节点
                else
                {
                    if(point == "append")
                    {
                        $.messager.alert('提示','不可放至此位置', 'info');
                        return false;
                    }
                }
            }
        },
        onDrop: function (targetNode, source, point) {
            //拖动节点
            var sNode = $("#dpCategory").tree('getNode', targetNode);
            //释放节点
            var tNode = source;
            //拖动目录
            if (tNode.type == "DPTree") 
            {
                //释放在根目录
                if (sNode.type == "DPTreeBase")
                {
                    if(point == "append")
                    {
                        updateCategoryIcon();
                        swapDPCategoryID(tNode.id, sNode.id);
                        return;
                    }
                }
                //释放在目录
                else if (sNode.type == "DPTree")
                {
                    if (point == "append")
                    {
                        if (sNode.isLeaf == "Y"){
                            sNode.isLeaf = "N";
                        }
                        updateCategoryIcon();
                        swapDPCategoryID(tNode.id, sNode.id);
                        return;
                    }
                    else if(point == "top")
                    {
                        swapDPCategoryID(tNode.id, sNode.id);
                        return;
                    }
                    else  ///bottom
                    {
                        swapDPCategoryID(tNode.id, sNode.id);
                        return;
                        
                    }
                }
            }
            //拖动节点
            else 
            {
                //释放在根目录
                if (sNode.type == "DPTreeBase")
                {
                    if(point == "append")
                    {
                        updateCategoryIcon();
                        swapDPCategoryID(tNode.id, sNode.id);
                        return;
                    }
                }
                //释放在目录
                else if (sNode.type == "DPTree")
                {
                    if(point == "append")
                    {
                        if (sNode.isLeaf == "Y"){
                            sNode.isLeaf = "N";
                        }
                        updateCategoryIcon();
                        swapDPCategoryID(tNode.id, sNode.id);
                        return;
                    }
                }
                //释放在节点
                else
                {
                    if(point == "top")
                    {
                        swapDPCategoryID(tNode.id, sNode.id);
                        return;
                    }
                    else if(point == "bottom")
                    {
                        swapDPCategoryID(tNode.id, sNode.id);
                        return;
                    }
                }
            }
        }
    });
    /*$("#insert").click(function (){
        getInsertText();
    });*/
    $HUI.dialog("#dlg",{ 
        title: emrTrans("提示"),
        buttons: [{
            text: emrTrans("确认"),
            handler: function() {
                var newName = $("#newName").val();
                var type = $("#newName").attr("type");
                if ("" == newName) {
                    var info = "目录名称不能为空，请重新输入";
                    if (type != "DPTree"){
                        info = "节点名称不能为空，请重新输入";
                    }
                    top.$.messager.alert("提示", info, "info");
                    return;
                }
                updateDPCateName(newName, type);
                $("#dlg").dialog("close");
                return false;
            }
        }, {
            text: emrTrans("取消"),
            handler: function() {
                $("#dlg").dialog("close");
                return false;
            }
        }]
    });
    getDPCategory();
    initMenu();
});

function updateIcon(data){
    for (var i = 0; i < data.length; i++){
        var node = $("#dpCategory").tree("find", data[i].id);
        if (node.type.indexOf("DPTree")!= -1){
            if (node.isLeaf == "Y"){
                $(node.target).find("span.tree-file").removeClass("tree-file");
                $("#dpCategory").tree("update", {target: node.target, iconCls:node.iconCls});
            }else if (node.children && (node.children.length > 0)){
                updateIcon(node.children);
            }
        }
    }
}

function updateCategoryIcon(){
    if (!swapParentNode){
        return;
    }
    var length = $("#dpCategory").tree("getChildren",swapParentNode.target).length;
    if (length > 0){
        swapParentNode.isLeaf = "N";
    }else{
        $(swapParentNode.target).find("span.tree-icon").removeClass("tree-folder-open");
        $(swapParentNode.target).find("span.tree-file").removeClass("tree-file");
        $("#dpCategory").tree("update", {
            target: swapParentNode.target,
            iconCls: "tree-folder"
        });
        swapParentNode.isLeaf = "Y";
    }
    swapParentNode = "";
}

//设置页面布局
function setResize(){
    //读配置文本显示在右边还是下边
    if (sysOption.contentLocation == "east"){
        //$("#dpLayout").layout("panel","south");
        $("#dpLayout").layout("remove","south");
        var options = {border:false,split:true,id:"contentRegion",region:sysOption.contentLocation};
        $("#dpLayout").layout("add", options);
        $("#contentRegion").panel("resize", {
            width: 200
        });
        $("#contentRegion").append('<div id="content" readonly="readonly" ondragstart="return false;" style="border-left:1px solid #E8E8E8;padding-left:10px;"></div>');
        //$("#contentRegion").append('<div class="hisui-layout" data-options="fit:true,border:false" style="height:100%;border-left:1px solid #E8E8E8;overflow:hidden;"><div data-options="region:'+"center"+',border:false" style="height:94%;padding-top:3px;overflow:auto;"><div id="content" readonly="readonly" ondragstart="return false;" style="padding-left:10px;"></div></div><div data-options="region:'+"south"+',border:false" style="height:40px;padding:3px 0px 3px 10px;"><a class="hisui-linkbutton l-btn l-btn-small" id="insert" href="#" group=""><span class="l-btn-left"><span class="l-btn-text">'+emrTrans("插入纯文本")+'</span></span></a></div></div>');
        $("body").layout("resize");
    }
}

//查询检索
function findDPCategoryData(data,value)
{
    var result = new Array();
    for (var i = 0; i < data.length; i++){
        if ((data[i].children)&&(data[i].children.length >0)){
            var child = findDPCategoryData(data[i].children,value)
            if ((child != "")&&(child.length >0)){
                var tmp = JSON.parse(JSON.stringify(data[i]));
                tmp.children = [];
                tmp.children = child;
                result.push(tmp);
            }
        }else{
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
            if (!children){
                return false;
            }
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

//右键菜单
function treeRightClick(e,node)
{
    e.preventDefault();
    $("#dpCategory").tree("select", node.target);
    var type = node.type;
    if (type.indexOf("DPTree")!= -1)
    {
        // 共享目录
        /*if (type == "ShareDPTree"){
            return;
        }*/
        $("#treemenu").menu("disableItem",$("#addDPTree")[0]);
        $("#treemenu").menu("disableItem",$("#addDPNode")[0]);
        $("#treemenu").menu("disableItem",$("#editDPTreeName")[0]);
        $("#treemenu").menu("disableItem",$("#deleteDPTree")[0]);
        $("#treemenu").menu("disableItem",$("#moveUpDPTree")[0]);
        $("#treemenu").menu("disableItem",$("#moveDownDPTree")[0]);
        if (type == "DPTreeBase")
        {
            $("#treemenu").menu("enableItem",$("#addDPTree")[0]);
        }else if (type == "DPTree"){
            $("#treemenu").menu("enableItem",$("#addDPTree")[0]);
            $("#treemenu").menu("enableItem",$("#addDPNode")[0]);
            $("#treemenu").menu("enableItem",$("#editDPTreeName")[0]);
            if (node.isLeaf == "Y"){
                $("#treemenu").menu("enableItem",$("#deleteDPTree")[0]);
            }
            var childrenTree = $("#dpCategory").tree("getParent",node.target).children;
            var length = childrenTree.length;
            if (length > 1) {
                if (node.id == childrenTree[0].id){
                    $("#treemenu").menu("enableItem",$("#moveDownDPTree")[0]);
                }else if (node.id == childrenTree[length-1].id){
                    $("#treemenu").menu("enableItem",$("#moveUpDPTree")[0]);
                }else{
                    $("#treemenu").menu("enableItem",$("#moveUpDPTree")[0]);
                    $("#treemenu").menu("enableItem",$("#moveDownDPTree")[0]);
                }
            }
        }
        $("#dpCategory").tree("select", node.target);
        $("#treemenu").menu("show", {left: e.pageX, top: e.pageY});
        return;
    }else if (type.indexOf("DPNode")!= -1){
        $("#nodemenu").menu("disableItem",$("#editDPNodeName")[0]);
        $("#nodemenu").menu("disableItem",$("#editDPNode")[0]);
        $("#nodemenu").menu("disableItem",$("#deleteDPNode")[0]);
        //$("#nodemenu").menu("disableItem",$("#shareDPNode")[0]);
        //$("#nodemenu").menu("disableItem",$("#cancelshareDPNode")[0]);
        $("#nodemenu").menu("disableItem",$("#moveUpDPNode")[0]);
        $("#nodemenu").menu("disableItem",$("#moveDownDPNode")[0]);
        
        if (type == "DPNode"){
            $("#nodemenu").menu("enableItem",$("#editDPNodeName")[0]);
            $("#nodemenu").menu("enableItem",$("#editDPNode")[0]);
            $("#nodemenu").menu("enableItem",$("#deleteDPNode")[0]);
            //$("#nodemenu").menu("enableItem",$("#shareDPNode")[0]);
            var childrenNode = $("#dpCategory").tree("getParent",node.target).children;
            var length = childrenNode.length;
            if (length > 1) {
                if (node.id == childrenNode[0].id){
                    $("#nodemenu").menu("enableItem",$("#moveDownDPNode")[0]);
                }else if (node.id == childrenNode[length-1].id){
                    $("#nodemenu").menu("enableItem",$("#moveUpDPNode")[0]);
                }else{
                    $("#nodemenu").menu("enableItem",$("#moveUpDPNode")[0]);
                    $("#nodemenu").menu("enableItem",$("#moveDownDPNode")[0]);
                }
            }
        }/*else {
            // 共享节点ShareDPNode
            if (node.personalDPUserID == userID){
                $("#nodemenu").menu("enableItem",$("#cancelshareDPNode")[0]);
            }
        }*/
        $("#dpCategory").tree('select', node.target);
        $("#nodemenu").menu('show', {left: e.pageX, top: e.pageY});
        return;
    }
}

// 加载个人短语
function getDPCategory(){
    var args = {
        action: "GET_DPCATEGORY",
        params:{
            userLocID: userLocID,
            userID: userID
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
        if (data){
            $("#dpCategory").tree({data:data});
            dpCategoryData = new Array($("#dpCategory").tree('getData',$("#dpCategory").tree("getRoot").target));
        }
    }, function (error) {
        $.messager.alert("发生错误", "getDPCategory error:"+error, "error");
    }, false);
}

// 右键菜单
function initMenu()
{
    //新建目录
    document.getElementById("addDPTree").onclick = function(){
        var node = $("#dpCategory").tree("getSelected");
        var nodeDesc = userName + "的个人短语";
        var nodeType = "DPTree";
        var personalDPUserID = userID;
        newDP(node,nodeDesc,nodeType,personalDPUserID);
    }
    //新建节点
    document.getElementById("addDPNode").onclick = function(){
        var node = $("#dpCategory").tree("getSelected");
        var nodeDesc = "新建个人节点";
        var nodeType = "DPNode";
        var personalDPUserID = userID;
        newDP(node,nodeDesc,nodeType,personalDPUserID);
    }
    //修改目录名称
    document.getElementById("editDPTreeName").onclick = function(){
        var node = $("#dpCategory").tree("getSelected");
        $("#editNameDPTree").css("display","block");
        $("#editNameDPNode").css("display","none");
        $("#newName").val(node.text);
        $("#newName").attr("type","DPTree");
        $("#dlg").dialog("open");
    }
    //删除目录
    document.getElementById("deleteDPTree").onclick = function(){
        deleteDP();
    }
    //修改节点名称
    document.getElementById("editDPNodeName").onclick = function(){
        var node = $("#dpCategory").tree("getSelected");
        $("#editNameDPTree").css("display","none");
        $("#editNameDPNode").css("display","block");
        $("#newName").val(node.text);
        $("#newName").attr("type","DPNode");
        $("#dlg").dialog("open");
    }
    //编辑节点
    document.getElementById("editDPNode").onclick = function(){
        editDPNode();
    }
    //删除节点
    document.getElementById("deleteDPNode").onclick = function(){
        deleteDP();
    }
    /*
    //分享个人节点
    document.getElementById("shareDPNode").onclick = function(){
        shareDPNode();
    }
    //取消分享个人节点
    document.getElementById("cancelshareDPNode").onclick = function(){
        cancelShareDPNode();
    }*/
    //目录上移
    document.getElementById("moveUpDPTree").onclick = function(){
        getSibling(0);
    }
    //目录下移
    document.getElementById("moveDownDPTree").onclick = function(){
        getSibling(1);
    }
    //节点上移
    document.getElementById("moveUpDPNode").onclick = function(){
        getSibling(0);
    }
    //节点下移
    document.getElementById("moveDownDPNode").onclick = function(){
        getSibling(1);
    }
}

//新建操作
function newDP(node,nodeDesc,nodeType,personalDPUserID)
{
    var args = {
        action: "CREATE_DPDATA",
        params:{
            userID: personalDPUserID,
            parentID: node.id,
            name: nodeDesc,
            type: nodeType
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
        if (data){
            if (node.isLeaf == "Y"){
                node.isLeaf = "N";
            }
            $("#dpCategory").tree("append", {
                parent: (node?node.target:null),
                data: data
            });
            dpCategoryData = new Array($("#dpCategory").tree('getData',$("#dpCategory").tree("getRoot").target));
        }
    }, function (error) {
        $.messager.alert("发生错误", "newDP error:"+error, "error");
    }, false);
}

//修改名称
function updateDPCateName(name, type)
{
    var node = $("#dpCategory").tree("getSelected");
    var id = node.id;
    if (!id){
        return;
    }
    var args = {
        action: "UP_DPCATENAME",
        params:{
            id: id,
            name: name
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
        if (data == "1"){
            $("#dpCategory").tree("update", {
                target: node.target,
                text: name
            });
            if (type != "DPTree"){
                top.parent.$.messager.alert("提示", "修改节点名称成功!", "info");
            }else{
                top.parent.$.messager.alert("提示", "修改目录名称成功!", "info");
            }
            dpCategoryData = new Array($("#dpCategory").tree('getData',$("#dpCategory").tree("getRoot").target));
        }else{
            if (type != "DPTree"){
                top.parent.$.messager.alert("提示", "修改节点名称失败!", "info");
            }else{
                top.parent.$.messager.alert("提示", "修改目录名称失败!", "info");
            }
        }
    }, function (error) {
        $.messager.alert("发生错误", "updateDPCateName error:"+error, "error");
    }, true);
}

//删除操作
function deleteDP()
{
    var node = $("#dpCategory").tree("getSelected");
    var args = {
        action: "STOP_DPDATA",
        params:{
            id:node.id,
            isValid:"N"
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
        if (data == "1"){
            var parentNode = $("#dpCategory").tree("getParent",node.target);
            var length = $("#dpCategory").tree("getChildren",parentNode.target).length;
            $("#dpCategory").tree("remove", node.target);
            if (length == 1){
                $(parentNode.target).find("span.tree-icon").removeClass("tree-folder-open");
                $(parentNode.target).find("span.tree-file").removeClass("tree-file");
                $("#dpCategory").tree("update", {
                    target: parentNode.target,
                    iconCls: "tree-folder",
                    state: "closed"
                });
                parentNode.isLeaf = "Y";
            }
            dpCategoryData = new Array($("#dpCategory").tree('getData',$("#dpCategory").tree("getRoot").target));
        }
    }, function (error) {
        $.messager.alert("发生错误", "deleteDP error:"+error, "error");
    }, true);
}

//编辑节点
function editDPNode(){
    width = window.screen.availWidth - 250;
    height = window.screen.availHeight - 250;
    var node = $("#dpCategory").tree("getSelected");
    parent.modalDialogArgs = {
        node: {
            id: node.contentID,
            status: node.dpState,
        },
        product: product,
        userCode: userCode,
        safeGroupId: "OP_KB_Admin"
    };
    parent.createModalDialog("DPNodeContentModal","个人短语内容",width,height,"iframeDPNodeContent",'<iframe id="iframeDPNodeContent" scrolling="auto" frameborder="0" src="emr.bs.op.dpnode.edit.csp?MWToken='+getMWToken()+'" style="width:100%;height:100%;display:block;"></iframe>',refreshDFPNodeContent);
}

function refreshDFPNodeContent(returnValue){
    var args = {
        action: "DPFRAGMENT_TO_TEXT",
        params:{
            id: returnValue.node.id
        },
        product: product
    };
    parent.modalDialogArgs = "";
    var commandJson = parent.EmrEditor.syncExecute(args);
    if ("fail" === commandJson.result){
        $.messager.alert("发生错误", "获取知识库节点文本内容失败:"+commandJson.error, "error");
        console.log(commandJson);
    }else{
        var DPNodeText = commandJson.params;
        if (DPNodeText){
            $("#content").css("overflow-y","auto");
            document.getElementById("content").innerHTML = DPNodeText;
        }else{
            if (document.getElementById("content").innerHTML){
                $("#content").css("overflow-y","hidden");
                $("#content").empty();
            }
        }
    }
}

/*
//分享个人节点
function shareDPNode(){
    var node = $("#dpCategory").tree("getSelected");
    var args = {
        action: "SharePersonalDPNode",
        params:{
            nodeID:id,
            userLocID:userLocID,
            userID:userID
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
        if (data == "-1"){
            top.parent.$.messager.alert("提示",emrTrans("该科室短语在本科室已分享过!"));
        }else if(data == "0") {
            top.parent.$.messager.alert("提示",emrTrans("共享个人科室短语失败!"));
        }else {
            top.parent.$.messager.alert("提示",emrTrans("共享个人科室短语成功!"));
            var nodeData = JSON.parse(JSON.stringify(node));
            nodeData.id = data;
            delete nodeData.attributes.parentID;
            nodeData.attributes.CategoryID = node.id;
            nodeData.attributes.type = "ShareDPNode";
            var shareDPTree = $("#dpCategory").tree("find","ShareDPTree");
            if (shareDPTree) {
                $("#dpCategory").tree("append", {
                    parent: shareDPTree.target,
                    data: nodeData
                });
            }else{
                var rootNode = $("#dpCategory").tree("getRoot");
                if (rootNode){
                    var shareData = getAllShareDPTree();
                    $("#dpCategory").tree("append", {
                        parent: rootNode.target,
                        data: (shareData?shareData:[])
                    });
                }
            }
            $("#content").css("overflow-y","hidden");
            $("#content").empty();
        }
    }, function (error) {
        $.messager.alert("发生错误", "shareDPNode error:"+error, "error");
    }, true);
}

//获取共享目录数据
function getAllShareDPTree()
{
    var result = "";
    var args = {
        action: "getAllShareDPTree",
        params:{
            userLocID:userLocID
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
        if (data){
            result = data;
        }
    }, function (error) {
        $.messager.alert("发生错误", "getAllShareDPTree error:"+error, "error");
    }, false);
    return result;
}
//取消分享个人节点
function cancelShareDPNode()
{
    var node = $("#dpCategory").tree("getSelected");
    var id = node.id;
    var type = node.attributes.type;
    if (type == "ShareDPNode"){
        id = node.attributes.CategoryID;
    }
    var args = {
        action: "CancelSharePersonalDPNode",
        params:{
            nodeID:id,
            userLocID:userLocID,
            userID:userID
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
        if (data == 1){
            top.parent.$.messager.alert("提示",emrTrans("取消共享个人科室短语成功!"));
            var parentNode = $("#dpCategory").tree("getParent",node.target);
            var length = $("#dpCategory").tree("getChildren",parentNode.target).length;
            $("#dpCategory").tree("remove", node.target);
            if (length == 1){
                if (parentNode.id == "ShareDPTree"){
                    $("#dpCategory").tree("remove", parentNode.target);
                    return;
                }
                $(parentNode.target).find("span.tree-icon").removeClass("tree-folder-open");
                $(parentNode.target).find("span.tree-file").removeClass("tree-file");
                $("#dpCategory").tree("update", {
                    target: parentNode.target,
                    iconCls: "tree-folder",
                    state: "closed"
                });
            }
        }
    }, function (error) {
        $.messager.alert("发生错误", "cancelShareDPNode error:"+error, "error");
    }, true);
}
*/
//flag = 0：向上  1：向下
function getSibling(flag)
{
    var node = $("#dpCategory").tree("getSelected");
    var parentNode = $("#dpCategory").tree("getParent", node.target);
    var nodes = $("#dpCategory").tree("getLeafChildren",parentNode.target);
    if (2 > nodes.length){
        return "";
    }
    for(var i = 0; i< nodes.length; i++){
        if (node.id == nodes[i].id){
            var tmpNode = "";
            if (0 == flag) {
                tmpNode = nodes[i-1];
            } else {
                tmpNode = nodes[i+1];
            }
            if ((tmpNode != "")&&(tmpNode != undefined))
            {
                //移动目录节点
                swapDP(node, tmpNode, flag);
            }
            return "";
        }
    }
    return "";
}

//交换同级别目录或节点的上移、下移排序Sequence
function swapDP(node1, node2, flag)
{
    var args = {
        action: "SWAP_DPSEQUENCE",
        params:{
            id1:node1.id,
            id2:node2.id
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
        if (data == "1"){
            var changeData = $("#dpCategory").tree("getData",node1.target);
            $("#dpCategory").tree("remove",node1.target);
            if (flag == 0){
                //上移
                $("#dpCategory").tree("insert", {
                    before: node2.target,
                    data: changeData
                });
            }else{
                //下移
                $("#dpCategory").tree("insert", {
                    after: node2.target,
                    data: changeData
                });
            }
            dpCategoryData = new Array($("#dpCategory").tree('getData',$("#dpCategory").tree("getRoot").target));
        }else{
            $.messager.alert('提示','保存移动失败', 'info');
        }
    }, function (error) {
        $.messager.alert("发生错误", "swapDP error:"+error, "error");
    }, true);
}

function swapDPCategoryID(id, categoryID)
{
    var args = {
        action: "UP_DPCATEGORYID",
        params:{
            id: id,
            categoryID: categoryID
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
        if (data == "1"){
            dpCategoryData = new Array($("#dpCategory").tree('getData',$("#dpCategory").tree("getRoot").target));
        }else{
            $.messager.alert('提示','保存移动失败', 'info');
        }
    }, function (error) {
        $.messager.alert("发生错误", "swapDPCategoryID error:"+error, "error");
    }, true);
}

//插入选中的节点阅览内容
function getInsertText()
{
    var txt = "";
    if (window.getSelection)
    {
        var userSelection = window.getSelection();
        if (userSelection.rangeCount > 0) {
            var range = userSelection.getRangeAt(0);
            var container = document.createElement('div');
            container.appendChild(range.cloneContents());
            txt = container.innerText;
        }
    }
    else
    {
        txt = document.selection.createRange().htmlText;
    }
    if (txt == "" || txt == undefined)
    {
        txt = document.getElementById('content').innerHTML;
    }
    //txt = txt.replace(/<br\s*\/?>/g, "\n");
    txt = txt.replace(/&nbsp;/g," ");
    return;
    //var param = {"action":"insertText","text":txt}
    //parent.eventDispatch(param);
    txt = txt.split("\n");
    var resultItems = new Array();
    $.each(txt,function(index, item){
        resultItems.push([{text:item}]);
    });
    var commandJson = parent.EmrEditor.syncExecute({
        action:"COMMAND",
        params:{
            text: resultItems
        },
        product: product
    });
    if ("fail" != commandJson.result) {
        parent.eventSave("insertText","",false);
    }
}
