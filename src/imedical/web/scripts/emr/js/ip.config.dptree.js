$(function(){
    if (userLocID != ""){
        // 在个人用户书写端没有科室配置界面
        return;
    }
    initUnSelCTLoc();
    initSelCTLoc();
    $("#save").on("click", function(){
        var node = $("#dpCategory").tree("getSelected");
        var cateText = $("#cateName").val();
        var data = $("#selLoc").datagrid("getData").rows;
        if (node.attributes.parentID == "0"){
            saveDPCTLoc(node.id,cateText,data);
        }else {
            updateName(node.id,cateText);
        }
        $("#dpCategory").tree("update", {
            target: node.target,
            text: cateText
        });
    });
    //移除
    $("#removeChecked").on("click", function(){
        var selData = $("#selLoc").datagrid("getData");
        var checkedItems = $("#selLoc").datagrid("getChecked").slice();
        if (checkedItems.length == selData.total){
            $("#selLoc").datagrid("loadData",{total:0,rows:[]});
        }else{
            if (checkedItems.length > 0){
                $.each(checkedItems, function(idx,item){
                    var nowIdx = $("#selLoc").datagrid("getRowIndex",item.id);
                    if (nowIdx != -1){
                        $("#selLoc").datagrid("deleteRow",nowIdx);
                    }
                });
            }
        }
        $("#selLoc").datagrid("clearChecked");
    });
    //增加
    $("#addChecked").on("click", function(){
        var unselData = $("#unselLoc").datagrid("getData");
        var checkedItems = $("#unselLoc").datagrid("getChecked").slice();
        if (checkedItems.length == unselData.total){
            $("#selLoc").datagrid("loadData",unselData);
        }else{
            if (checkedItems.length > 0){
                $.each(checkedItems, function(idx,item){
                    var nowIdx = $("#selLoc").datagrid("getRowIndex",item.id);
                    if (nowIdx == -1){
                        $("#selLoc").datagrid("appendRow",item);
                    }
                });
            }
        }
        $("#unselLoc").datagrid("clearChecked");
    });
});
//已选科室
function initSelCTLoc(){
    $HUI.datagrid("#selLoc",{
        fit:true,
        border:true,
        url:"../EMRservice.Ajax.common.cls?OutputType=Stream&Class=EMRservice.BL.BLDPCategory&Method=getSelCTLocData",
        queryParams:{
            p1:""
        },
        columns:[[
            {field:"ck",checkbox:true},
            {filed:"id",hidden:true},
            {field:"text",width:"220",title:"科室"}
        ]],
        idField:"id",
        toolbar:"#selLoc-tb"
    });
    $("#selLoc").datagrid("loadData", {total:0,rows:[]});
}
//科室字典表
function initUnSelCTLoc()
{
    $HUI.datagrid("#unselLoc",{
        fit:true,
        border:true,
        url:"../EMRservice.Ajax.common.cls?OutputType=Stream&Class=EMRservice.BL.BLDPCategory&Method=getAllLocData",
        queryParams:{
            p1:""
        },
        columns:[[
            {field:"ck",checkbox:true},
            {filed:"id",hidden:true},
            {field:"text",width:"220",title:"科室"}
        ]],
        idField:"id",
        toolbar:"#unselLoc-tb"
    });
    $("#unselLoc-search").searchbox({
        searcher: function(value, name){
            $("#unselLoc").datagrid("unselectAll").datagrid("load",{p1:value});
        },
        prompt: emrTrans("请输入您要查找的科室名称!")
    });
}
//当前节点的科室短语
function saveDPCTLoc(id,name,data){
    jQuery.ajax({
        type: "post",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: true,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLDPCategory",
            "Method":"saveDPCTLoc",
            "p1":id,
            "p2":name,
            "p3":JSON.stringify(data)
        },
        success: function(d){
            if (d == "0") {
                top.$.messager.alert("提示",emrTrans("保存科室短语配置失败!"));
            }else{
                top.$.messager.alert("提示",emrTrans("保存科室短语配置成功!"));
            }
        },
        error: function(d) {
            alert("saveDPCTLoc error");
        }
    });
}
//设置页面布局
function setResize(){
    if (userLocID != ""){
        $("#dpLayout").layout("remove","center");
        //读配置文本显示在右边还是下边
        if (contentLocation == "east"){
            $("#treeLayout").layout("remove","south");
            var options = {border:false,split:true,id:"contentRegion",region:contentLocation};
            $("#treeLayout").layout("add", options);
            $("#contentRegion").panel("resize", {
                width: 200
            });
            $("#contentRegion").append('<div class="hisui-layout" data-options="fit:true,border:false" style="height:100%;border-left:1px solid #E8E8E8;overflow:hidden;"><div data-options="region:'+"center"+',border:false" style="height:94%;padding-top:3px;overflow:auto;"><div id="content" readonly="readonly" ondragstart="return false;" style="padding-left:10px;"></div></div><div data-options="region:'+"south"+',border:false" style="height:40px;padding:3px 0px 3px 10px;"><a class="hisui-linkbutton l-btn l-btn-small" id="insert" href="#" group=""><span class="l-btn-left"><span class="l-btn-text">'+emrTrans("插入纯文本")+'</span></span></a></div></div>');
        }
        var content = $("#dpLayout").layout("panel","west").context;
        var options = $("#dpLayout").layout("panel","west").panel("options");
        options.fit = true;
    }else{
        $("#contentLayout").layout("remove","south");
        document.getElementById("config").style.display = "none";
        document.getElementById("edit").style.display = "none";
        $("#dpLayout").layout("panel","west").panel("resize",{
            width: 400
        });
    }
    $("body").layout("resize");
}
//配置按钮
function initConfigButton(node){
    if (userLocID != ""){
        // 在个人用户书写端没有科室配置界面
        return;
    }
    document.getElementById("config").style.display = "none";
    document.getElementById("edit").style.display = "none";
    if(node.attributes.type.indexOf("DPNode")!= -1){
        $("#dpLayout").layout("panel","center").panel("setTitle","科室短语节点内容");
        document.getElementById("edit").style.display = "block";
        refresh(node.id);
    }else{
        $("#dpLayout").layout("panel","center").panel("setTitle","科室关联");
        document.getElementById("config").style.display = "block";
        document.getElementById("ctlocConfig").style.display = "none";
        $("#cateName").val(node.text);
        $("#cateName").attr("disabled",false);
        $("#save").linkbutton("enable");
        if(node.attributes.type == "DPTreeBase"){
            $("#cateName").attr("disabled",true);
            $("#save").linkbutton("disable");
        }else if (node.attributes.parentID == "0"){
            document.getElementById("ctlocConfig").style.display = "block";
            $("#unselLoc-search").searchbox("setValue","");
            $("#unselLoc").datagrid("unselectAll").datagrid("load",{p1:""});
            $("#selLoc").datagrid("unselectAll").datagrid("load",{p1:node.id});
        }
    }
}
//刷新节点内容
function refreshDPTreeNode(returnValues){
    if (returnValues)
    {
        var node = $("#dpCategory").tree("getSelected");
        if (returnValues.IsValid == "N"){
            var parentNode = $("#dpCategory").tree("getParent",node.target);
            var length = $("#dpCategory").tree("getChildren",parentNode.target).length;
            if (length == 1){
                $("#dpCategory").tree("remove", node.target);
                $("#dpCategory").tree("update", {
                    target: parentNode.target,
                    iconCls: "tree-folder-open"
                });
                parentNode.attributes.isLeaf = "N";
            }
            return;
        }
        $("#dpCategory").tree("update", {
            target: node.target,
            text: returnValues.NodeText
        });
        node.attributes.textData = returnValues.TextData;
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