var tmpcategoryId = "";
var tmpnodeId = "";

$(function(){
	if (isAllowEditTextKB == "Y"){
		$("#delete").show();
		$("#modify").show();
		$("#new").show();
	}
	initCbCategory();
});

function initCbCategory()
{
	$('#cbCategory').combobox({  
		width:150, 
	    url:'../EMRservice.Ajax.common.cls?OutputType=String&Class=EMRservice.BL.BLTextKBCategory&Method=GetCategory',  
	    valueField:'id',  
	    textField:'text',
	    onLoadSuccess : function(){  
	    	var data = $('#cbCategory').combobox('getData');
	    	if (data.length > 0)
		  	$('#cbCategory').combobox('select',data[0].id); 
		  	document.getElementById('content').innerHTML="";  
		  	initcbLoc();
		},
	    onSelect: function(rec)
	    {  
	    	var tmpLocId = getUserLocID();
 			getCategory(rec.id,tmpLocId);
 			initcbLoc();
        }
  
	}); 
	 
}

function initcbLoc()
{
	var categoryId = getCagegoryID();
	$('#cbLoc').combobox({ 
		width:150, 
	    url:'../EMRservice.Ajax.common.cls?OutputType=Stream&Class=EMRservice.BL.BLTextKBCategory&Method=GetTextKBLoc&p1='+categoryId+'&p2=',  
	    valueField:'RowID',  
	    textField:'Desc',
	    onLoadSuccess : function(){  
	    	var data = $('#cbLoc').combobox('getData');
	    	if (data.length > 0)
			{
				$.each(data,function(idx,val){
					//默认值为登录科室
					if (val.RowID == userLocID){
						$('#cbLoc').combobox('select',userLocID);
						return;
					}
				});
			}
		},
	    onSelect: function(rec)
	    { 
	    	document.getElementById('content').innerHTML="";
		    var tmpLocId = getUserLocID();
		    var parentId = getCagegoryID();
			getCategory(parentId,tmpLocId);
        },
		filter: function (q, row) {
            var opts = $(this).combobox('options');
            return row["DescJP"].toLowerCase().indexOf(q.toLowerCase())> -1;
        }
  
	}); 	
}

function getInsertText()
{
    var txt = "";
    if (window.getSelection)
    {
	    var userSelection = window.getSelection();
	    var range = userSelection.getRangeAt(0);
	    var container = document.createElement('div');
    	container.appendChild(range.cloneContents());
		txt = container.innerText;
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

function reloadTextKbTree(){
	var categoryId = getCagegoryID();
	var locID = getUserLocID();
	getCategory(categoryId,locID);
    document.getElementById('content').innerHTML="";
}

$("#insert").click(function(){
	  getInsertText();
})

$("#insertclose").click(function(){
	  getInsertText();
	  parent.foldResource("close");
})

$("#close").click(function(){
	  parent.foldResource("close");
})

$("#new").click(function(){
	if (tmpcategoryId == ""){
        $.messager.alert("提示信息", "请先选择目录节点!");
	} else {
        var xpwidth=window.screen.width-200;
        var xpheight=window.screen.height-100;
        //HISUI模态框
        var nodeID = base64encode(utf16to8(escape(tmpcategoryId)));
        var nodeName = "";
        var isModify = "";
        var iframeContent = '<iframe id="KnowledgebaseText" scrolling="no" frameborder="0" src="emr.ip.record.edit.kbtext.csp?nodeID='+nodeID+'&nodeName='+nodeName+'&isModify='+isModify+'" style="width:100%;height:100%;"></iframe>'
        var callback = reloadTextKbTree;
        parent.parent.createModalDialog("HisUIKnowledgebaseText", "知识库内容", xpwidth-150, xpheight-250, "KnowledgebaseText", iframeContent,callback,"") 
    }
})

$("#modify").click(function(){
	if (tmpnodeId == ""){
		$.messager.alert("提示信息", "请先选择要修改的节点!");
		return;
	}
	
	var createUsrInfo = getCreateUsrInfo(tmpnodeId);
	if (createUsrInfo == "")
	{
		$.messager.alert("提示信息", "获取当前节点创建者相关信息失败，不允许修改此节点");
		return;
	}
	createUsrInfo = eval("("+createUsrInfo+")");
	if (createUsrInfo.createUser != userCode)
	{
		$.messager.alert("提示信息", "非本人创建节点不允许修改，当前节点创建人["+createUsrInfo.createUserName+"];工号["+createUsrInfo.createUser+"]")
		return;
	}
    var xpwidth=window.screen.width-200;
    var xpheight=window.screen.height-100;
    //HISUI模态框
    var nodeID = base64encode(utf16to8(escape(tmpnodeId)));
    var nodeName = base64encode(utf16to8(escape(createUsrInfo.name)));
    var isModify = base64encode(utf16to8(escape("Y")));
    var iframeContent = '<iframe id="KnowledgebaseText" scrolling="no" frameborder="0" src="emr.ip.record.edit.kbtext.csp?nodeID='+nodeID+'&nodeName='+nodeName+'&isModify='+isModify+'" style="width:100%;height:99%;"></iframe>'
    var callback = reloadTextKbTree;
    parent.parent.createModalDialog("HisUIKnowledgebaseText", "知识库内容", xpwidth-100, xpheight-200, "KnowledgebaseText", iframeContent,callback,"") 
})

$("#delete").click(function(){
	if (tmpnodeId == ""){
		$.messager.alert("提示信息", "请先选择要删除的节点");
		return;
	}
	
	var createUsrInfo = getCreateUsrInfo(tmpnodeId);
	if (createUsrInfo == "")
	{
		$.messager.alert("提示信息", "获取当前节点创建者相关信息失败，不允许删除此节点");
		return;
	}
	createUsrInfo = eval("("+createUsrInfo+")");
	if (createUsrInfo.createUser != userCode)
	{
		$.messager.alert("提示信息", "非本人创建节点不允许删除，当前节点创建人["+createUsrInfo.createUserName+"];工号["+createUsrInfo.createUser+"]")
		return;
	}
    $.messager.confirm("删除", "是否确认要删除?", function (r) {
        if (r) {
            jQuery.ajax({
                type: "get",
                dataType: "text",
                url: "../EMRservice.Ajax.common.cls",
                async: false,
                data: {
                    "OutputType":"string",
                    "Class":"EMRservice.BL.BLTextKBContent",
                    "Method":"DeleteCategory",
                    "p1":tmpnodeId
                },
                success: function(d) {
                    if (d == "1")
                    {
                        reloadTextKbTree();
                    }
                    else
                    {
                        $.messager.alert("提示信息","删除节点失败，请联系系统管理员")	
                    }
                },
                error : function(d) { alert("DeleteCategory error");}
            });
        }
    });
})

///获取创建者信息，用于判断是否有权限删除修改节点
function getCreateUsrInfo(nodeID)
{ 
	var result = "";
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"string",
			"Class":"EMRservice.BL.BLTextKBContent",
			"Method":"GetCreateUsrInfo",
			"p1":nodeID
		},
		success: function(d) {
			result = d;
		},
		error : function(d) { alert("GetCreateUsrInfo error");}
	});	
	return result;
}

///加载目录
function getCategory(parentId,paramLoc)
{	 
	jQuery.ajax({
		type: "get",
		dataType: "json",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLTextKBCategory",
			"Method":"GetData",
			"p1":parentId,
			"p2":paramLoc,
			"p3":"hisui"
		},
		success: function(d) {
			$('#kbCategory').tree({
				data:d,
				onClick:function(node){
					ztOnClick(node);
				}
			});
			/*
			$.fn.zTree.init($('#kbCategory'),ztSetting,d);
        	var treeObj = $.fn.zTree.getZTreeObj('kbCategory');
        	treeObj.expandAll(true);
        	*/
	
		},
		error : function(d) { alert("getCategory error");}
	});	
}


//ztree鼠标左键点击回调函数
function ztOnClick(treeNode)
{
	if (treeNode.attributes.type != "leaf") 
	{
		$("#new").linkbutton('enable');
		tmpnodeId = "";
		tmpcategoryId = treeNode.id;
        document.getElementById('content').innerHTML="";
		return;
	}
	$("#new").linkbutton('disable');
	tmpcategoryId = "";
	tmpnodeId = treeNode.id;
	setContent(treeNode.id);
}

///加载内容
function setContent(categoryId)
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLTextKBContent",
			"Method":"GetContent",
			"p1":categoryId
		},
		success: function(d) {
			document.getElementById('content').innerHTML=d; 
		},
		error : function(d) { alert("GetContent error");}
	});		
}
 
 function getUserLocID()
 {
	var tmpLocId = $('#cbLoc').combobox('getValue');
	return tmpLocId;	 
 }
 
 function getCagegoryID()
 {
	 var categoryId = $('#cbCategory').combobox('getValue');
	 return categoryId;
 }