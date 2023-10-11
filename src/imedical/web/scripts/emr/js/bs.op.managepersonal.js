$(function () {
    if ("" == documentID){
        documentID = parent.emrService.getCurrentDocumentID();
        if ("" === documentID){
            $.messager.alert("提示", "请先打开病历，再操作个人模板管理页面！", "info");
            return;
        }
    }
    $("#perTemplateTree").tree({
        dnd: true,
        formatter: function (node) {
            var s = node.text;
            if (node.children) {
                s += '&nbsp;<span style="color:blue">(' + node.children.length + ')</span>';
            }
            return s;
        },
        onContextMenu: function(e, node){
            treeRightClick(e,node);
        },
        onLoadSuccess: function(node,data){
            //updateIcon(data);
        },
        onBeforeSelect : function (node) {
            if (node.id){
                return true;
            }else{
                return false;
            }
        },
        onBeforeDrag: function (node) {
            if (node.type == "root"){
                return false;
            }
        },
        onBeforeDrop: function (targetNode, source, point) {
            //拖动节点
            var sNode = $("#perTemplateTree").tree('getNode', targetNode);
            //释放节点
            var tNode = source;
            //拖动目录
            if (tNode.type == "category") 
            {
                //释放在根目录
                if (sNode.type == "root")
                {
                    if((point == "top")||(point == "bottom"))
                    {
                        $.messager.alert('提示','不可放至此位置', 'info');
                        return false;
                    }else{
                        swapParentNode = $("#perTemplateTree").tree("getParent",tNode.target);
                    }
                }
                //释放在目录
                else if (sNode.type == "category")
                {
                    swapParentNode = $("#perTemplateTree").tree("getParent",tNode.target);
                }
                //释放在节点
                else if(sNode.type == "node")
                {
                    $.messager.alert('提示','不可放至此位置', 'info');
                    return false;
                }
            }
            //拖动节点
            else 
            {
                //释放在根目录
                if (sNode.type == "root")
                {
                    if((point == "top")||(point == "bottom"))
                    {
                        $.messager.alert('提示','不可放至此位置', 'info');
                        return false;
                    }else{
                        swapParentNode = $("#perTemplateTree").tree("getParent",tNode.target);
                    }
                }
                //释放在目录
                else if (sNode.type == "category")
                {
                    if((point == "top")||(point == "bottom"))
                    {
                        $.messager.alert('提示','不可放至此位置', 'info');
                        return false;
                    }else{
                        swapParentNode = $("#perTemplateTree").tree("getParent",tNode.target);
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
            var sNode = $("#perTemplateTree").tree('getNode', targetNode);
            //释放节点
            var tNode = source;
            //拖动目录
            if (tNode.type == "category") 
            {
                //释放在根目录
                if (sNode.type == "root")
                {
                    if(point == "append")
                    {
                        updatePerCategoryID(tNode, sNode, "category");
                        return;
                    }
                }
                //释放在目录
                else if (sNode.type == "category")
                {
                    if (point == "append")
                    {
                        if (sNode.isLeaf == "Y"){
                            sNode.isLeaf = "N";
                        }
                        updatePerCategoryID(tNode, sNode, "category");
                        return;
                    }
                    else if(point == "top")
                    {
                        swapSequence(tNode, sNode, "category");
                        return;
                    }
                    else  ///bottom
                    {
                        swapSequence(tNode, sNode, "category");
                        return;
                        
                    }
                }
            }
            //拖动节点
            else 
            {
                //释放在根目录
                if (sNode.type == "root")
                {
                    if(point == "append")
                    {
                        updatePerCategoryID(tNode, sNode, "node");
                        return;
                    }
                }
                //释放在目录
                else if (sNode.type == "category")
                {
                    if(point == "append")
                    {
                        if (sNode.isLeaf == "Y"){
                            sNode.isLeaf = "N";
                        }
                        updatePerCategoryID(tNode, sNode, "node");
                        return;
                    }
                }
                //释放在节点
                else
                {
                    if(point == "top")
                    {
                        swapSequence(tNode, sNode, "node");
                        return;
                    }
                    else if(point == "bottom")
                    {
                        swapSequence(tNode, sNode, "node");
                        return;
                    }
                }
            }
        }
    });
    
    initTree();
    initMenu();
    $("#newName").on("input", function () {
        checkNewname();
    });
});

$.extend($.fn.tree.methods, {
    getLeafChildren: function(jqTree, params) {
        var nodes = [];
        $(params).next().children().children("div.tree-node").each(function() {
            nodes.push($(jqTree[0]).tree('getNode', this));
        });
        return nodes;
    }
});

//去掉特殊字符
function checkNewname(){
    //var patrn = /[`~!@#$%^&*()_\-+=<>?:"{}|,.\/;\\[\]·~！@#￥%……&*（）——\-+={}|《》？：“”【】、；’‘，。、]/im;
    var patrn = /[`~!@#$%^&*_\-+=<>?:"{}|,.\/;\\[\]·~！@#￥%……&*——\-+={}|《》？：“”【】、；’‘，。、]/im;
    var newName = $("#newName").val();
    //正则表达式中的test方法，用于检测字符串是否有匹配的文本
    if(patrn.test(newName)){
        //提示不允许输入特殊字符
        $.messager.popover({
            msg:"不允许输入特殊字符",
            timeout:2000,
            type:"error"
        });
        for(var i = 0;i<newName.length;i++){
            newName = newName.replace(patrn,"");
        }
        $("#newName").val(newName);
        return false;
    }else{
        return true;
    }
}

function updateIcon(data){
    for (var i = 0; i < data.length; i++){
        var node = $("#perTemplateTree").tree("find", data[i].id);
        if (node.type.indexOf("category")!= -1){
            if (node.isLeaf == "Y"){
                $(node.target).find("span.tree-file").removeClass("tree-file");
                $("#perTemplateTree").tree("update", {target: node.target, iconCls:node.iconCls});
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
    var length = $("#perTemplateTree").tree("getChildren",swapParentNode.target).length;
    if (length > 0){
        swapParentNode.isLeaf = "N";
    }else{
        $(swapParentNode.target).find("span.tree-icon").removeClass("tree-folder-open");
        $(swapParentNode.target).find("span.tree-file").removeClass("tree-file");
        $("#perTemplateTree").tree("update", {
            target: swapParentNode.target,
            iconCls: "tree-folder"
        });
        swapParentNode.isLeaf = "Y";
    }
    swapParentNode = "";
}

//右键菜单
function treeRightClick(e,node)
{
    e.preventDefault();
    $("#perTemplateTree").tree("select", node.target);
    $("#menu").menu("disableItem", $("#newCategory")[0]);
    $("#menu").menu("disableItem", $("#addPerTemplate")[0]);
    $("#menu").menu("disableItem", $("#updateName")[0]);
    $("#menu").menu("disableItem", $("#editPerTemplate")[0]);
    $("#menu").menu("disableItem", $("#remove")[0]);
    $("#menu").menu("disableItem", $("#sharePerTemplate")[0]);
    $("#menu").menu("disableItem", $("#moveUp")[0]);
    $("#menu").menu("disableItem", $("#moveDown")[0]);
    var type = node.type;
    if (type == "root"){ 
        $("#menu").menu("enableItem", $("#newCategory")[0]);
        $("#menu").menu("enableItem", $("#addPerTemplate")[0]);
    }else if (type == "category"){
        $("#menu").menu("enableItem", $("#newCategory")[0]);
        $("#menu").menu("enableItem", $("#addPerTemplate")[0]);
        $("#menu").menu("enableItem", $("#updateName")[0]);
        if (node.isLeaf == "Y"){
            $("#menu").menu("enableItem", $("#remove")[0]);
        }
        var childrenTree = $("#perTemplateTree").tree("getParent",node.target).children;
        var length = childrenTree.length;
        if (length > 1) {
            if (node.id == childrenTree[0].id){
                $("#menu").menu("enableItem", $("#moveDown")[0]);
            }else if (node.id == childrenTree[length-1].id){
                $("#menu").menu("enableItem", $("#moveUp")[0]);
            }else{
                $("#menu").menu("enableItem", $("#moveUp")[0]);
                $("#menu").menu("enableItem", $("#moveDown")[0]);
            }
        }
    }else if (type == "node"){
        $("#menu").menu("enableItem", $("#updateName")[0]);
        $("#menu").menu("enableItem", $("#editPerTemplate")[0]);
        $("#menu").menu("enableItem", $("#remove")[0]);
        $("#menu").menu("enableItem", $("#sharePerTemplate")[0]);
        var childrenNode = $("#perTemplateTree").tree("getParent",node.target).children;
        var length = childrenNode.length;
        if (length > 1) {
            if (node.id == childrenNode[0].id){
                $("#menu").menu("enableItem", $("#moveDown")[0]);
            }else if (node.id == childrenNode[length-1].id){
                $("#menu").menu("enableItem", $("#moveUp")[0]);
            }else{
                $("#menu").menu("enableItem", $("#moveUp")[0]);
                $("#menu").menu("enableItem", $("#moveDown")[0]);
            }
        }
    }
    $("#menu").menu("show", {left: e.pageX, top: e.pageY});
}

//更改节点的父目录
function updatePerCategoryID(node1, node2, type)
{
    var args = {
        action: "UP_PERCATEGORYID",
        params:{
            id: node1.nodeID,
            categoryID: node2.nodeID,
            type: type
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
        if (data != "1"){
            $.messager.alert("提示", "移动失败!", "info");
        }else{
            updateCategoryIcon();
        }
    }, function (error) {
        $.messager.alert("发生错误", "updatePerCategoryID error:"+error, "error");
    }, false);
}

// 加载个人短语
function initTree(){
    var args = {
        action: "GET_PERCATEGORYBYID",
        params:{
            documentID: documentID,
            userID: userID,
            episodeID: episodeID
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
        if (data){
            $("#perTemplateTree").tree({data:data});
        }
    }, function (error) {
        $.messager.alert("发生错误", "getDPCategory error:"+error, "error");
    }, false);
}

// 右键菜单
function initMenu()
{
    document.getElementById("newCategory").onclick = function(){
        var node = $("#perTemplateTree").tree("getSelected");
        if (node){
            $('#newName').val("");
            showNameDlg(newCategory);
        }
    }
    document.getElementById("addPerTemplate").onclick = function(){
        var docStatus = parent.emrService.getCurrentDocStatus(documentID);
        if (!docStatus || (docStatus.curStatus === "") || (docStatus.curStatus === "created")){
            $.messager.alert("提示", "请先保存当前病历后，再转存为个人模板！", "info");
            return;
        }
        var commandJson = parent.emrService.getCurrentDocument(documentID);
        if (!commandJson){
            return;
        }
        $("#newName").val(commandJson.title.name.value);
        var node = $("#perTemplateTree").tree("getSelected");
        if (node){
            showNameDlg(addPerTemplate);
        }
    }
    document.getElementById("updateName").onclick = function(){
        var node = $("#perTemplateTree").tree("getSelected");
        if (node){
            $('#newName').val(node.text);
            showNameDlg(updateName);
        }
    }
    document.getElementById("editPerTemplate").onclick = function(){
        editPerTemplate();
    }
    document.getElementById("remove").onclick = function(){
        remove();
    }
    document.getElementById("sharePerTemplate").onclick = function(){
        sharePerTemplate();
    }
    document.getElementById("moveUp").onclick = function(){
        getPrev(getCurr());
        //getSibling(0);
    }
    document.getElementById("moveDown").onclick = function(){
        getNext(getCurr());
        //getSibling(1);
    }
}

function showNameDlg(fnOnComfirmed){
    $("#dlg").dialog({ 
        title: emrTrans("请填写名称"),
        buttons: [{
            text: emrTrans("确认"),
            handler: function() {
                var newName = $("#newName").val();
                if ("" == newName) {
                    top.$.messager.alert("提示", "名称不能为空，请重新输入", "info");
                    return;
                }
                if (isExistFunc(fnOnComfirmed)) {
                    fnOnComfirmed(newName);
                }
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
    }).dialog("open");
    $("#newName").focus();
}

//新建文件夹
function newCategory(nodeDesc)
{
    var node = $("#perTemplateTree").tree('getSelected');
    var nodeID = node.nodeID;
    if (nodeID == "" || nodeDesc == ""){
        return;
    }
    var args = {
        action: "CREATE_PERCATEGORY",
        params:{
            documentID: documentID,
            userID: userID,
            parentID: nodeID,
            name: nodeDesc
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
        if (data){
            if (node.isLeaf == "Y"){
                node.isLeaf = "N";
            }
            $("#perTemplateTree").tree("append", {
                parent: (node?node.target:null),
                data: data
            });
        }else{
            $.messager.alert("提示", "新建文件夹失败!", "info");
        }
    }, function (error) {
        $.messager.alert("发生错误", "newCategory error:"+error, "error");
    }, false);
}

//将当前病历转存为个人模板
function addPerTemplate(nodeDesc){
    var node = $("#perTemplateTree").tree("getSelected");
    var nodeID = node.nodeID;
    if (nodeID == ""){
        return;
    }
    var args = {
        action: "ADD_PERTEMPLATE",
        params:{
            documentID: documentID,
            userID: userID,
            parentID: nodeID,
            name: nodeDesc
        },
        args:{
            inherit: "0"
        },
        product: product
    };
    var commandJson = parent.EmrEditor.syncExecute(args);
    if ("fail" === commandJson.result){
        $.messager.alert("发生错误", "保存为个人模板失败:"+commandJson.error, "error");
        console.log(commandJson);
    }else{
        if (node.isLeaf == "Y"){
            node.isLeaf = "N";
        }
        $("#perTemplateTree").tree("append", {
            parent: (node?node.target:null),
            data: commandJson.params
        });
    }
}

//重命名
function updateName(nodeDesc)
{
    var node = $("#perTemplateTree").tree("getSelected");
    var nodeID = node.nodeID;
    if (nodeID == "" || nodeDesc == ""){
        return;
    }
    var args = {
        action: "UP_PERCATEGORY",
        params:{
            id: nodeID,
            name: nodeDesc,
            type: node.type
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
        if (data == "1"){
            $("#perTemplateTree").tree("update", {
                target: node.target,
                text: nodeDesc
            });
        }else{
            $.messager.alert("提示", "重命名失败!", "info");
        }
    }, function (error) {
        $.messager.alert("发生错误", "updateName error:"+error, "error");
    }, true);
}

//修改内容
function editPerTemplate(){
    width = window.screen.availWidth - 250;
    height = window.screen.availHeight - 250;
    var node = $("#perTemplateTree").tree("getSelected");
    parent.modalDialogArgs = {
        node: {
            id: node.nodeID,
            status: node.status,
            templateId: node.templateID
        },
        product: product,
        userCode: userCode,
        safeGroupId: "OP_TEMP_Admin"
    };
    parent.createModalDialog("PerTemplateModal","个人模板内容",width,height,"iframePerTemplate",'<iframe id="iframePerTemplate" scrolling="auto" frameborder="0" src="emr.bs.op.pertemplate.edit.csp?MWToken='+getMWToken()+'" style="width:100%;height:100%;display:block;"></iframe>',refreshPerTemplate);
}

function refreshPerTemplate(returnValue){
    parent.modalDialogArgs = "";
}

//删除操作
function remove()
{
    var node = $("#perTemplateTree").tree("getSelected");
    /*if (node.type === "category") {
        if ($("#perTemplateTree").tree('getChildren', node.target).length > 0) 
        {
            $.messager.alert("提示","存在下级节点，不允许删除", "info");
            return;
        }
    }*/
    var tipMsg = "确定删除【" + node.text + "】?"
    parent.$.messager.confirm("操作提示", tipMsg, function (data) {
        if (data){
            var args = {
                action: "DEL_PERCATEGORY",
                params:{
                    id: node.nodeID,
                    type: node.type
                },
                product: product
            };
            ajaxGETCommon(args, function(data){
                if (data == "1"){
                    var parentNode = $("#perTemplateTree").tree("getParent",node.target);
                    var length = $("#perTemplateTree").tree("getChildren",parentNode.target).length;
                    $("#perTemplateTree").tree("remove", node.target);
                    if (length == 1){
                        $(parentNode.target).find("span.tree-icon").removeClass("tree-folder-open");
                        $(parentNode.target).find("span.tree-file").removeClass("tree-file");
                        $("#perTemplateTree").tree("update", {
                            target: parentNode.target,
                            iconCls: "tree-folder",
                            state: "closed"
                        });
                        parentNode.isLeaf = "Y";
                    }
                }else{
                    $.messager.alert("提示", "删除失败!", "info");
                }
            }, function (error) {
                $.messager.alert("发生错误", "remove error:"+error, "error");
            }, true);
        }else{
            return;
        }
    });
}

//分享个人模板
function sharePerTemplate()
{
    var node = $("#perTemplateTree").tree("getSelected");
    if (node){
        var id = node.nodeID;
        if (isShareToLoc(id)){
            var tipMsg = '您已分享过该个人模板【' + node.text + '】，是否再次分享?'
            parent.$.messager.confirm("操作提示", tipMsg, function (data) {
                if (data){
                    share(id);
                }else{
                    return;
                }
            });
        }else{
            share(id);
        }
    }
}

//判断个人模板是否已分享过
function isShareToLoc(nodeID)
{
    var result = false;
    var args = {
        action: "PERIS_SHARETOLOC",
        params:{
            id: nodeID,
            userLocID: userLocID
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
        if (data == "1"){
            result = true;
        }
    }, function (error) {
        $.messager.alert("发生错误", "isShareToLoc error:"+error, "error");
    }, false);
    return result;
}

//分享
function share(nodeID)
{
    var args = {
        action: "PER_SHARETOLOC",
        params:{
            id: nodeID,
            userLocID: userLocID
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
        if (data == "1"){
            $.messager.alert("提示", "分享个人模板成功，等待审核后即可在科室模板中进行使用!", "info");
        }else{
            $.messager.alert("提示", "分享失败，失败原因:"+data, "info");
        }
    }, function (error) {
        $.messager.alert("发生错误", "share error:"+error, "error");
    }, true);
}

function getCurr(){
    var n = $("#perTemplateTree").find(".tree-node-hover");
    if (!n.length){
        n = $("#perTemplateTree").find(".tree-node-selected");
    }
    return n;
}

//下移(同级别)
function getNext(curr){
    var currnode = $("#perTemplateTree").tree("getNode", curr[0]);
    var n = curr.parent().next().children("div.tree-node");
    if (n.length)
    {
        var node = $("#perTemplateTree").tree("getNode", n[0]);
        var type = node.type;
        if (type != currnode.type){
            //同级排序，文件夹和节点不能移动互换，给与提示，由于后台是设计的两个表
            $.messager.alert("提示", "移动类型不同，不能下移", "info");
            return;
        }
        if (swapSequence(currnode,node,type) == "1")
        {
            var tempnode = $("#perTemplateTree").tree("pop", currnode.target)
            $("#perTemplateTree").tree("insert", {
                after: node.target,
                data: tempnode
            });
        }else{
            $.messager.alert("提示", "移动失败", "info");
        }
    }else{
        $.messager.alert("提示", "不能下移", "info");
    }
}

//上移(同级别)
function getPrev(curr){
    var currnode = $("#perTemplateTree").tree("getNode", curr[0]);
    var n = curr.parent().prev().children("div.tree-node");
    if (n.length)
    {
        var node = $("#perTemplateTree").tree("getNode", n[0]);
        var type = node.type;
        if (type != currnode.type){
            $.messager.alert("提示", "移动类型不同，不能上移", "info");
            return;
        }
        if (swapSequence(currnode,node,type) == "1")
        {
            var tempnode = $("#perTemplateTree").tree("pop", currnode.target)
            $("#perTemplateTree").tree("insert", {
                before: node.target,
                data: tempnode
            });
        }else{
            $.messager.alert("提示", "移动失败", "info");
        }
    }else{
        $.messager.alert("提示", "不能上移", "info");
    }
}

//flag = 0：向上  1：向下
function getSibling(flag)
{
    var node = $("#perTemplateTree").tree("getSelected");
    var parentNode = $("#perTemplateTree").tree("getParent", node.target);
    var nodes = $("#perTemplateTree").tree("getLeafChildren",parentNode.target);
    if (2 > nodes.length){
        return "";
    }
    for(var i = 0; i< nodes.length; i++){
        if (node.id == nodes[i].id){
            var tmpNode = "";
            if (0 == flag) {
                tmpNode = nodes[i-1];
            }else{
                tmpNode = nodes[i+1];
            }
            if ((tmpNode != "") && isExistVar(tmpNode)){
                //移动目录节点
                if (swapSequence(node, tmpNode, node.type)){
                    var changeData = $("#perTemplateTree").tree("getData",node.target);
                    $("#perTemplateTree").tree("remove",node.target);
                    if (flag == 0){
                        //上移
                        $("#perTemplateTree").tree("insert", {
                            before: tmpNode.target,
                            data: changeData
                        });
                    }else{
                        //下移
                        $("#perTemplateTree").tree("insert", {
                            after: tmpNode.target,
                            data: changeData
                        });
                    }
                }
            }
            return "";
        }
    }
    return "";
}

//交换同级别目录或节点的上移、下移排序Sequence
function swapSequence(node1, node2, type)
{
    var result = false;
    var args = {
        action: "SWAP_PERSEQUENCE",
        params:{
            id1: node1.nodeID,
            id2: node2.nodeID,
            type: type
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
        if (data != "1"){
            $.messager.alert("提示", "移动失败!", "info");
        }else{
            result = true;
        }
    }, function (error) {
        $.messager.alert("发生错误", "swapSequence error:"+error, "error");
    }, false);
    return result;
}
