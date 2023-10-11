$(function(){
    if (flag == "config"){
        //flag为config标识配置界面
        userLocID = "";
    }
    if (typeof setResize == "function"){
        setResize();
    }
    getDPCategory();
    initMenu();
    $("#searchNode").searchbox({
        searcher: function(value, name){
            if (TempData == ""){
                return;
            }
            var tmpTemplateData = findTemplate(TempData, value);
            $("#dpCategory").tree("loadData",tmpTemplateData);
        },
        prompt: emrTrans("请输入您要查找的节点名称!")
    });
    $("#dpCategory").tree({
        onClick: function(node){
            if(node.attributes.type.indexOf("DPNode")!= -1){
                //展示个人节点内容
                var textData = node.attributes.textData;
                if (textData != ""){
                    $("#content").css("overflow-y","auto");
                    textData = textData.replace(/\n/g,"<br/>");
                    textData = textData.replace(/\s/g,"&nbsp");
                    textData = textData.replace(/\\n/g,"<br/>");
                    document.getElementById("content").innerHTML = textData;
                    
                }else{
                    $("#content").css("overflow-y","hidden");
                    $("#content").empty();
                }
            }else{
                $("#content").css("overflow-y","hidden");
                $("#content").empty();
            }
            initConfigButton(node);
        },
        onDblClick: function(node){
            if ((userLocID != "")&&(node.attributes.type.indexOf("DPNode")!= -1)){
                var param = {"action":"appendComposite","KBNodeID":node.attributes.DPNodeID,"Type":"DP"}
                parent.eventDispatch(param);
            } else {
                $(this).tree(node.state === "closed" ? "expand" : "collapse", node.target);
                node.state = node.state === "closed" ? "open" : "closed";
            }
        },
        onContextMenu: function(e, node){
            treeRightClick(e,node);
            initConfigButton(node);
        }
    });
    $("#insert").click(function (){
        getInsertText();
    });
    $HUI.dialog("#dlg",{ 
        title: emrTrans("提示"),
        buttons: [{
            text: emrTrans("确认"),
            handler: function() {
                var newName = $("#newName").val();
                if ("" == newName) {
                    top.$.messager.alert("提示",emrTrans("目录名称不能为空，请重新输入"));
                    return;
                }
                updateName(newName);
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
});
//当前科室短语树数据,用于查询检索
var TempData = "";
// 加载科室短语
function getDPCategory(){
    jQuery.ajax({
        type: "get",
        dataType: "json",
        url: "../EMRservice.Ajax.common.cls",
        async: true,
        data: {
            "OutputType":"Stream",
            "Class":"EMRservice.BL.BLDPCategory",
            "Method":"getDPCategory",
            "p1":userLocID,
            "p2":userID
        },
        success: function(d) {
            TempData = d;
            $("#dpCategory").tree({data:d});
        },
        error: function(d) {
            alert("getDPCategory error");
        }
    });
}
function initMenu()
{
    //新建目录
    document.getElementById("addDPTree").onclick = function(){
        var node = $("#dpCategory").tree("getSelected");
        var nodeDesc = userName + "的个人短语";
        var nodeType = "PersonalDPTree";
        var personalDPUserID = userID;
        if (userLocID == ""){
            nodeDesc = "新建目录";
            nodeType = "DPTree";
            personalDPUserID = "";
        }
        newDP(node,nodeDesc,nodeType,personalDPUserID);
    }
    //新建节点
    document.getElementById("addDPNode").onclick = function(){
        var node = $("#dpCategory").tree("getSelected");
        var nodeDesc = "新建个人节点";
        var nodeType = "PersonalDPNode";
        var personalDPUserID = userID;
        if (userLocID == ""){
            nodeDesc = "新建节点";
            nodeType = "DPNode";
            personalDPUserID = "";
        }
        newDP(node,nodeDesc,nodeType,personalDPUserID);
    }
    //修改目录名称
    document.getElementById("editDPTreeName").onclick = function(){
        var node = $("#dpCategory").tree("getSelected");
        if (userLocID == ""){
            $("#cateName").val(node.text);
        }
        $("#newName").val(node.text);
        $("#dlg").dialog("open");
    }
    //删除目录
    document.getElementById("deleteDPTree").onclick = function(){
        deleteDP();
    }
    //编辑节点
    document.getElementById("editDPNode").onclick = function(){
        editDPNode();
    }
    //删除节点
    document.getElementById("deleteDPNode").onclick = function(){
        deleteDP();
    }
    //分享个人节点
    document.getElementById("shareDPNode").onclick = function(){
        shareDPNode();
    }
    //取消分享个人节点
    document.getElementById("cancelshareDPNode").onclick = function(){
        cancelShareDPNode();
    }
    //目录上移
    document.getElementById("moveUpDPTree").onclick = function(){
        var node = $("#dpCategory").tree("getSelected");
        getSibling(node, 0);
    }
    //目录下移
    document.getElementById("moveDownDPTree").onclick = function(){
        var node = $("#dpCategory").tree("getSelected");
        getSibling(node, 1);
    }
    //节点上移
    document.getElementById("moveUpDPNode").onclick = function(){
        var node = $("#dpCategory").tree("getSelected");
        getSibling(node, 0);
    }
    //节点下移
    document.getElementById("moveDownDPNode").onclick = function(){
        var node = $("#dpCategory").tree("getSelected");
        getSibling(node, 1);
    }
}
//新建操作
function newDP(node,nodeDesc,nodeType,personalDPUserID)
{
    jQuery.ajax({
        type: "get",
        dataType: "json",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType":"Stream",
            "Class":"EMRservice.BL.BLDPCategory",
            "Method":"newDP",
            "p1":node.id,
            "p2":nodeDesc,
            "p3":nodeType,
            "p4":personalDPUserID
        },
        success: function(d) {
           if (d != "") 
           {
                if (node.attributes.isLeaf){
                    node.attributes.isLeaf = "N";
                }
                $("#dpCategory").tree("append", {
                    parent: (node?node.target:null),
                    data: d
                });
                $("#dpCategory").tree("collapse",node.target);
                $("#dpCategory").tree("expand",node.target);
           }
        },
        error: function(d) {
            alert("newDP error");
        }
    });
}
//修改名称
function updateName(name)
{
    var node = $("#dpCategory").tree("getSelected");
    var id = node.id;
    if (!id) return;
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: true,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLDPCategory",
            "Method":"updateDPCateName",
            "p1":id,
            "p2":name
        },
        success: function(d) {
            if (d == "1")
            {
                $("#dpCategory").tree("update", {
                    target: node.target,
                    text: name
                });
                if (userLocID != ""){
                    top.parent.parent.$.messager.alert("提示",emrTrans("修改目录名称成功!"));
                }else{
                    top.$.messager.alert("提示",emrTrans("修改目录名称成功"));
                }
            }
            else
            {
                if (userLocID != ""){
                    top.parent.parent.$.messager.alert("提示",emrTrans("修改目录名称失败!"));
                }else{
                    top.$.messager.alert("提示",emrTrans("修改目录名称失败"));
                }
            }
        },
        error: function(d) {
            alert("updateDPCateName error");
        }
    });
}
//删除操作
function deleteDP()
{
    var node = $("#dpCategory").tree("getSelected");
    jQuery.ajax({
        type: "get", 
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: true,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLDPCategory",
            "Method":"stopDPCategory",
            "p1":node.id,
            "p2":"N"
        },
        success : function(d) {
            if (d == "1"){
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
                    parentNode.attributes.isLeaf = "Y";
                }
            }
        },
        error: function(d) {
            alert("stopDPCategory error");
        }
    });
}

//编辑节点
function editDPNode(){
    var xpwidth = window.screen.width - 300;
    var xpheight = window.screen.height - 300;
    var node = $("#dpCategory").tree("getSelected");
    var iframeContent = '<iframe id="dpNodeContent" scrolling="no" frameborder="0" src="emr.ip.resource.dptree.edit.csp?NodeID='+node.id+'" style="width:100%;height:99%;"></iframe>';
    var callback = function(returnValues,tmp){
        if (returnValues)
        {
            if (returnValues.IsValid == "N"){
                var parentNode = $("#dpCategory").tree("getParent",tmp.target);
                var length = $("#dpCategory").tree("getChildren",parentNode.target).length;
                $("#dpCategory").tree("remove", tmp.target);
                if (length == 1){
                    $(parentNode.target).find("span.tree-icon").removeClass("tree-folder-open");
                    $(parentNode.target).find("span.tree-file").removeClass("tree-file");
                    $("#dpCategory").tree("update", {
                        target: parentNode.target,
                        iconCls: "tree-folder",
                        state: "closed"
                    });
                    parentNode.attributes.isLeaf = "Y";
                }
                return;
            }
            $("#dpCategory").tree("update", {
                target: tmp.target,
                text: returnValues.NodeText
            });
            tmp.attributes.textData = returnValues.TextData;
            if (returnValues.TextData != ""){
                $("#content").css("overflow-y","auto");
                returnValues.TextData = returnValues.TextData.replace(/\s/g,"&nbsp");
                returnValues.TextData = returnValues.TextData.replace(/\\n/g,"<br/>");
                document.getElementById("content").innerHTML = returnValues.TextData;
            }else{
                $("#content").css("overflow-y","hidden");
                $("#content").empty();
            }
        }
    }
    if (userLocID != ""){
        if (admType =="I"){
            parent.parent.createModalDialog("HisUIDPNodeContent", "科室短语内容", xpwidth, xpheight, "dpNodeContent", iframeContent,callback,node);
        }else{
            parent.createModalDialog("HisUIDPNodeContent", "科室短语内容", xpwidth, xpheight, "dpNodeContent", iframeContent,callback,node);
        }
    }else{
        createModalDialog("HisUIDPNodeContent", "科室短语内容", xpwidth, xpheight, "dpNodeContent", iframeContent,callback,node);
    }
}
//分享个人节点
function shareDPNode(){
    var node = $("#dpCategory").tree("getSelected");
    jQuery.ajax({
        type: "get", 
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: true,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLDPCategory",
            "Method":"SharePersonalDPNode",
            "p1":node.id,
            "p2":userLocID,
            "p3":userID
        },
        success: function(d) {
            if (d == "-1") {
                if (userLocID != ""){
                    top.parent.parent.$.messager.alert("提示",emrTrans("该科室短语在本科室已分享过!"));
                }else{
                    top.$.messager.alert("提示",emrTrans("该科室短语在本科室已分享过"));
                }
            }else if(d == "0") {
                if (userLocID != ""){
                    top.parent.parent.$.messager.alert("提示",emrTrans("共享个人科室短语失败!"));
                }else{
                    top.$.messager.alert("提示",emrTrans("共享个人科室短语失败"));
                }
            }else {
                if (userLocID != ""){
                    top.parent.parent.$.messager.alert("提示",emrTrans("共享个人科室短语成功!"));
                }else{
                    top.$.messager.alert("提示",emrTrans("共享个人科室短语成功"));
                }
                var nodeData = JSON.parse(JSON.stringify(node));
                nodeData.id = d;
                delete nodeData.attributes.parentID;
                nodeData.attributes.CategoryID = node.id;
                nodeData.attributes.type = "ShareDPNode";
                var shareDPTree = $("#dpCategory").tree("find","ShareDPTree-"+userID);
                if (shareDPTree) {
                    $("#dpCategory").tree("append", {
                        parent: shareDPTree.target,
                        data: nodeData
                    });
                }else{
                    var shareDPTreeBase = $("#dpCategory").tree("find","ShareDPTree");
                    $("#dpCategory").tree("remove", shareDPTreeBase.target);
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
        },
        error: function(d) {
            alert("SharePersonalDPNode error");
        }
    });
}
//获取共享目录数据
function getAllShareDPTree()
{
    var result = "";
    jQuery.ajax({
        type: "get", 
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType":"Stream",
            "Class":"EMRservice.BL.BLDPCategory",
            "Method":"getAllShareDPTree",
            "p1":userLocID
        },
        success: function(d) {
            if (d != ""){
                result = JSON.parse(d);
            }
        },
        error: function(d) {
            alert("getAllShareDPTree error");
        }
    });
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
    jQuery.ajax({
        type: "get", 
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: true,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLDPCategory",
            "Method":"CancelSharePersonalDPNode",
            "p1":id,
            "p2":userLocID,
            "p3":userID
        },
        success : function(d) {
           if (d == 1)
           {
                if (userLocID != ""){
                    top.parent.parent.$.messager.alert("提示",emrTrans("取消共享个人科室短语成功!"));
                }else{
                    top.$.messager.alert("提示",emrTrans("取消共享个人科室短语成功!"));
                }
                var parentNode = $("#dpCategory").tree("getParent",node.target);
                var length = $("#dpCategory").tree("getChildren",parentNode.target).length;
                $("#dpCategory").tree("remove", node.target);
                if (length == 1){
                    $("#dpCategory").tree("remove", parentNode.target);
                    var shareDPTreeBase = $("#dpCategory").tree("find","ShareDPTree");
                    if (shareDPTreeBase.children.length == 0){
                        $("#dpCategory").tree("remove", shareDPTreeBase.target);
                        return;
                    }
                }
           }
        },
        error: function(d) {
            alert("CancelSharePersonalDPNode error");
        }
    });
}
//flag = 0：向上  1：向下
function getSibling(node, flag)
{
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
                SwapDP(node, tmpNode, flag);
            }
            return "";
        }
    }
    return "";
}
//交换目录的排序Sequence
function SwapDP(node1, node2, flag)
{
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: true,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLDPCategory",
            "Method":"SwapSequence",
            "p1":node1.id,
            "p2":node2.id
        },
        success: function(d) {
            if (d == 1) {
                var changeData = $("#dpCategory").tree("getData",node1.target);
                $("#dpCategory").tree("remove",node1.target);
                if (flag == 0)
                {
                    //上移
                    $("#dpCategory").tree("insert", {
                        before: node2.target,
                        data: changeData
                    });
                }
                else
                {
                    //下移
                    $("#dpCategory").tree("insert", {
                        after: node2.target,
                        data: changeData
                    });
                }
            }
        },
        error: function(d) {
            alert("SwapTreeNode Sequence error!");
        }
    });
}
//右键菜单
function treeRightClick(e,node)
{
    e.preventDefault();
    $("#dpCategory").tree("select", node.target);
    var type = node.attributes.type;
    if (type.indexOf("DPTree")!= -1)
    {
        // 共享目录
        if (type == "ShareDPTree"){
            return;
        }
        $("#treemenu").menu("disableItem",$("#addDPTree")[0]);
        $("#treemenu").menu("disableItem",$("#addDPNode")[0]);
        $("#treemenu").menu("disableItem",$("#editDPTreeName")[0]);
        $("#treemenu").menu("disableItem",$("#deleteDPTree")[0]);
        $("#treemenu").menu("disableItem",$("#moveUpDPTree")[0]);
        $("#treemenu").menu("disableItem",$("#moveDownDPTree")[0]);
        if (type == "DPTreeBase")
        {
            $("#treemenu").menu("enableItem",$("#addDPTree")[0]);
        }else {
            if (userLocID != ""){
                // 在个人用户书写端科室目录没有右键菜单
                if (type == "DPTree"){
                    return;
                }else if (type == "PersonalDPTree"){
                    $("#treemenu").menu("enableItem",$("#addDPTree")[0]);
                    $("#treemenu").menu("enableItem",$("#addDPNode")[0]);
                    $("#treemenu").menu("enableItem",$("#editDPTreeName")[0]);
                    if (node.attributes.isLeaf == "Y"){
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
            }else{
                // 在配置端科室目录功能
                if (type == "DPTree"){
                    $("#treemenu").menu("enableItem",$("#addDPTree")[0]);
                    $("#treemenu").menu("enableItem",$("#addDPNode")[0]);
                    $("#treemenu").menu("enableItem",$("#editDPTreeName")[0]);
                    if (node.attributes.isLeaf == "Y"){
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
                }else{
                    return;
                }
            }
        }
        $("#dpCategory").tree("select", node.target);
        $("#treemenu").menu("show", {left: e.pageX, top: e.pageY});
        return;
    }else if (type.indexOf("DPNode")!= -1)
    {
        $("#nodemenu").menu("disableItem",$("#editDPNode")[0]);
        $("#nodemenu").menu("disableItem",$("#deleteDPNode")[0]);
        $("#nodemenu").menu("disableItem",$("#shareDPNode")[0]);
        $("#nodemenu").menu("disableItem",$("#cancelshareDPNode")[0]);
        $("#nodemenu").menu("disableItem",$("#moveUpDPNode")[0]);
        $("#nodemenu").menu("disableItem",$("#moveDownDPNode")[0]);
        if (userLocID != ""){
            // 在个人用户书写端科室节点没有右键菜单
            if (type == "DPNode"){
                return;
            }else if (type == "PersonalDPNode"){
                $("#nodemenu").menu("enableItem",$("#editDPNode")[0]);
                $("#nodemenu").menu("enableItem",$("#deleteDPNode")[0]);
                $("#nodemenu").menu("enableItem",$("#shareDPNode")[0]);
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
            }else {
                // 共享节点ShareDPNode
                if (node.attributes.personalDPUserID == userID){
                    $("#nodemenu").menu("enableItem",$("#cancelshareDPNode")[0]);
                }
            }
        }else{
            // 在配置端科室节点功能
            if (type == "DPNode"){
                $("#nodemenu").menu("enableItem",$("#deleteDPNode")[0]);
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
            }else{
                return;
            }
        }
        $("#dpCategory").tree('select', node.target);
        $("#nodemenu").menu('show', {left: e.pageX, top: e.pageY});
        return;
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
            }
        }
    }
    return result;
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
    txt = txt.replace(/<br\s*\/?>/g, "\n");
    txt = txt.replace(/&nbsp;/g," ");
    var param = {"action":"insertText","text":txt}
    parent.eventDispatch(param);  
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

