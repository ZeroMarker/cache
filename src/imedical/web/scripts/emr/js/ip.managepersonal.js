var $modelInstanceTree;
var documentContext;
//var onlyone = false;
$(function () {
	$modelInstanceTree = $('#modelInstanceTree');
	documentContext = parent.getDocumentContext();
	initTree(userId,instanceId);
	initContextMenu();
	$('#newName').on('input', function () {
		checkNewname();
	});
});

//去掉特殊字符
function checkNewname(){
	var patrn = /[`~!@#$%^&*()_\-+=<>?:"{}|,.\/;\\[\]·~！@#￥%……&*（）——\-+={}|《》？：“”【】、；’‘，。、]/im;
	var newName = $('#newName').val();
	//正则表达式中的test方法，用于检测字符串是否有匹配的文本
	if(patrn.test(newName)){
		//提示不允许输入特殊字符
		$.messager.popover({
			msg:'不允许输入特殊字符',
			timeout:2000,
			type:'error'
		});
		for(var i = 0;i<newName.length;i++){
			newName = newName.replace(patrn,"");
		}
		$('#newName').val(newName);
		return false;
	}else{
		return true;
	}
}

///设置目录权限
function onContextMenu(e, node) {
	e.preventDefault();
	var node = $modelInstanceTree.tree('getSelected');
	$('#mm').menu('disableItem', $('#newCategory')[0]);
	$('#mm').menu('disableItem', $('#toModelIns')[0]);
	$('#mm').menu('disableItem', $('#renameit')[0]);
	$('#mm').menu('disableItem', $('#removeit')[0]);
	$('#mm').menu('disableItem', $('#moveUpNode')[0]);
	$('#mm').menu('disableItem', $('#moveDownNode')[0]);
	$('#mm').menu('disableItem', $('#shareit')[0]);
	$('#mm').menu('disableItem', $('#modifyit')[0]);
	//根节点
	if (node.attributes.type == "root") 
	{ 
		$('#mm').menu('enableItem', $('#newCategory')[0]);
		$('#mm').menu('enableItem', $('#toModelIns')[0]);
	} 
	//文件夹
	else if (node.attributes.type == "category")  
	{ 
		$('#mm').menu('enableItem', $('#newCategory')[0]);
		$('#mm').menu('enableItem', $('#toModelIns')[0]);
		$('#mm').menu('enableItem', $('#renameit')[0]);
		$('#mm').menu('enableItem', $('#removeit')[0]);
		$('#mm').menu('enableItem', $('#moveUpNode')[0]);
		$('#mm').menu('enableItem', $('#moveDownNode')[0]);
	} 
	//个人模板节点
	else if (node.attributes.type == "node") 
	{ 
		$('#mm').menu('enableItem', $('#renameit')[0]);
		$('#mm').menu('enableItem', $('#removeit')[0]);
		$('#mm').menu('enableItem', $('#moveUpNode')[0]);
		$('#mm').menu('enableItem', $('#moveDownNode')[0]);
		$('#mm').menu('enableItem', $('#shareit')[0]);
		$('#mm').menu('enableItem', $('#modifyit')[0]);
	}

	$('#mm').menu('show', {
		left: e.pageX,
		top: e.pageY
	});
}

function initTree(userId,instanceId)
{
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.PersonalTemplate",
			"Method":"GetDataTree",
			"p1":userId,
			"p2":instanceId
		},
		success: function(d){
			var ret = d;
			initTreeFunc($.parseJSON(ret));
		},
		error: function(d) {alert("GetTemplateClassify error");}
	});		

}

function initTreeFunc(data)
{
	$modelInstanceTree.tree({
        data : data,
        dnd: true,
		lines:true,
        formatter: function (node) {
			var s = node.text;
			if (node.children) {
				s += '&nbsp;<span style="color:blue">(' + node.children.length + ')</span>';
			}
			return s;
		},
		onContextMenu: function (e, node) {
			$(this).tree('select', node.target);
			onContextMenu(e, node);				
		},
		onLoadSuccess:function(node,data){
			/*if (!onlyone){
				var rootnode = $modelInstanceTree.tree('getRoot');
				$modelInstanceTree.tree('select',rootnode.target);
			
				savetemplate();	
				onlyone = true;
			}*/
			if (isCollapse =="0")
			{
				$modelInstanceTree.tree('collapseAll');
			}
			else if (isCollapse =="1")
			{
				$modelInstanceTree.tree('expandAll');
			}
			else if(isCollapse =="2")
			{
				$modelInstanceTree.tree('collapseAll');
				var rootnode = $modelInstanceTree.tree('getRoot');
				$modelInstanceTree.tree("expand",rootnode.target);
			}
		},
        onBeforeSelect : function (node) {
            if (node.id)
                return true;
            else
                return false;
        },
        onBeforeDrag: function (node) {
	        if (node.attributes.type == "root") return false;
	    },
	    onBeforeDrop: function (targetNode, source, point) {
	        //释放节点
            var sNode = $modelInstanceTree.tree('getNode', targetNode);
            //拖动节点
            var tNode = source;
            //拖动目录
            if (getNodeType(tNode) == "category") 
            {
	            //释放在根目录
	            if (getNodeType(sNode) == "root")
	            {
		            if((point == "top")||(point == "bottom"))
		            {
			            $.messager.alert('提示','不可放至此位置', 'info');
			            return false;
			        }
		        }
			    //释放在节点
			    else if(getNodeType(sNode) == "node")
			    {
				    $.messager.alert('提示','不可放至此位置', 'info');
			        return false;
				}
	        }
	        //拖动节点
	        else 
	        {
	            //释放在根目录
	            if (getNodeType(sNode) == "root")
	            {
			 		if((point == "top")||(point == "bottom"))
		            {
			            $.messager.alert('提示','不可放至此位置', 'info');
			            return false;
			        }
		        }
		        //释放在目录
		        else if (getNodeType(sNode) == "category")
		        {
			 		if((point == "top")||(point == "bottom"))
		            {
			           	$.messager.alert('提示','不可放至此位置', 'info');
			            return false;
			        }
                    if (sNode.state == "closed") { 
			        	$modelInstanceTree.tree('expand', targetNode);
			        	$modelInstanceTree.tree('collapse', targetNode);
			        } else {
				        $modelInstanceTree.tree('collapse', targetNode);
				        $modelInstanceTree.tree('expand', targetNode);
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
            var sNode = $modelInstanceTree.tree('getNode', targetNode);
            //释放节点
            var tNode = source;
            //拖动目录
            if (getNodeType(tNode) == "category") 
            {
	            //释放在根目录
	            if (getNodeType(sNode) == "root")
	            {
		            if(point == "append")
		            {
			            if (updateCategoryID(tNode.id,sNode.id,"category") !== "1")
						{
							$.messager.alert('提示','移动失败', 'info');
							return;
						}
			        }
		        }
		        //释放在目录
		        else if (getNodeType(sNode) == "category")
		        {
			        if(point == "append")
		            {
			            if (updateCategoryID(tNode.id,sNode.id,"category") !== "1")
						{
							$.messager.alert('提示','移动失败', 'info');
							return;
						}
			        }
		            else if(point == "top")  
		            {
			            if (swapSequence(tNode.id,sNode.id,"category") !== "1")
			            {
							$.messager.alert('提示','移动失败', 'info');
							return;	
						}
			        }
			        else  ///bottom
			        {
				        if (swapSequence(sNode.id,tNode.id,"category") !== "1")
			            {
							$.messager.alert('提示','移动失败', 'info');
							return;	
						}
				        
				    }
			    }
	        }
	        //拖动节点
	        else 
	        {
	            //释放在根目录
	            if (getNodeType(sNode) == "root")
	            {
		            if(point == "append")
		            {
			            if (updateCategoryID(tNode.id,sNode.id,"node") !== "1")
						{
							$.messager.alert('提示','移动失败', 'info');
							return;	
						}
			        }
		        }
		        //释放在目录
		        else if (getNodeType(sNode) == "category")
		        {
			        if(point == "append")
		            {
			            if (updateCategoryID(tNode.id,sNode.id,"node") !== "1")
						{
							$.messager.alert('提示','移动失败', 'info');
							return;
						}
			        }
			    }
			    //释放在节点
			    else
			    {
					if(point == "top")  
		            {
			            if (swapSequence(tNode.id,sNode.id,"node") !== "1")
			            {
							$.messager.alert('提示','移动失败', 'info');
							return;	
						}
			        }
			        else if(point == "bottom")
			        {
				        if (swapSequence(sNode.id,tNode.id,"node") !== "1")
			            {
							$.messager.alert('提示','移动失败', 'info');
							return;	
						}
				        
				    }
				}
		    }
        }
    });
}

function getNodeType(node) {
    return node.attributes.type;   ///root、category、node
}

///交换节点/目录排序
function swapSequence(id1,id2,action)
{
	var result = "";
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.PersonalTemplate",
			"Method":"SwapSequence",
			"p1":id1,
			"p2":id2,
			"p3":action
		},
		success: function(d){
			result = d
		},
		error: function(d) {alert("error");}
	});		
	return result;
}

///更改节点的父目录
function updateCategoryID(id1,id2,action)
{
	var result = "";
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.PersonalTemplate",
			"Method":"UpdateCategoryID",
			"p1":id1,
			"p2":id2,
			"p3":action
		},
		success: function(d){
			result = d
		},
		error: function(d) {alert("error");}
	});		
	return result;
}

///工具栏
function initContextMenu()
{
	document.getElementById("newCategory").onclick = function(){
		var node = $modelInstanceTree.tree('getSelected');
		if (node) 
		{
			$('#newName').val("");
			showNameDlg(newCategory);
		}
	}
	document.getElementById("toModelIns").onclick = function(){
		savetemplate();
	}
	document.getElementById("renameit").onclick = function(){
		var node = $modelInstanceTree.tree('getSelected');
		if (node) {
			$('#newName').val(node.text);
			showNameDlg(RenameIt);
		}
	}
	document.getElementById("removeit").onclick = function(){
		Delete();
	}
	document.getElementById("modifyit").onclick = function(){
		Modifyit();
	}
	document.getElementById("moveUpNode").onclick = function(){
		getPrev(getCurr());
		
	}
	document.getElementById("moveDownNode").onclick = function(){
		getNext(getCurr());
	}	
	document.getElementById("shareit").onclick = function(){
		//分享个人模板到科室模板
		shareit();
	}	
}

function showNameDlg(fnOnComfirmed) {
	$('#HISUIpersonaldlg').dialog({
		buttons: [{
				text: '确认',
				handler: function () {					
					var newName = $('#newName').val();
                    newName = newName.replace(/'/g,"");
					if ('' == newName){
						$.messager.alert('提示','保存失败!', 'info');
						return;
					}
					$HUI.dialog('#HISUIpersonaldlg').close();
					if (typeof (fnOnComfirmed) === 'function') {
						fnOnComfirmed(newName);
					}
					return false;
				}
			}, {
				text: '取消',
				handler: function () {
					$('#HISUIpersonaldlg').dialog('close');
					return false;
				}
			}
		]
	}).dialog('open');	
}

function savetemplate()
{
	$('#newName').val(documentContext.Title.DisplayName);
	var node = $modelInstanceTree.tree('getSelected');

	if (node) 
	{
		var modifyparam = {
			"action":"CHECK_DOCUMENT_MODIFY",
			"args":{
				"InstanceID":documentContext.InstanceID,
				"isSync":true
			}
	};
	//showNameDlg(saveExample);
	saveExample(documentContext.Title.DisplayName);
	}	
}
///增加树节点
function appendTreeNode(parentNode,data) 
{
	$modelInstanceTree.tree('append', {
		parent: parentNode.target,
		data:data
	})
}

///增加目录
function newCategory(name) 
{
	var node = $modelInstanceTree.tree('getSelected');
	var parentId = node.id;
	if (parentId == "" || name == "") return;
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.PersonalTemplate",
			"Method":"AddCategory",
			"p1":userId,
			"p2":parentId,
			"p3":name,
            "p4":instanceId
		},
		success: function(d){
			if (d != "")
			{
				var childData = [{
					id: d,
					text: name,
					children: [],
					attributes: {
							type: 'category'
						}				
					}]
				appendTreeNode(node,childData);
				$('#HISUIpersonaldlg').dialog('close');
			}
		},
		error: function(d) {alert("error");}
	});		
}

///保存个人模板
function saveExample(name)
{
	var node = $modelInstanceTree.tree('getSelected');
	var parentId = node.id;
	if (parentId == "") return;
	var param = {
			"CategoryID":parentId,
			"UserID":userId,
			"Name":name,
			"isSync":true
		};
	var ret = parent.savePersonalTemplate(param); 
	if (ret.result === 'OK' && ret.params.result === 'OK') 
	{
		var exampleID = ret.params.ExampleID;
		if (exampleID != "")
		{
			jQuery.ajax({
				type: "post",
				dataType: "text",
				url: "../EMRservice.Ajax.common.cls",
				async: false,
				data: {
					"OutputType":"String",
					"Class":"EMRservice.BL.PersonalTemplate",
					"Method":"GetExampleInfo",
					"p1":exampleID
				},
				success: function(d){
					if (d != '') 
					{
						var exampleInfo = eval("("+d+")");
						var xpwidth=window.screen.width-200;
						var xpheight=window.screen.height-100;
				    	//HISUI模态框
				    	var nodeObj = {"id":exampleID,"documentType":exampleInfo.DocumentType,"name":exampleInfo.Name}
						var nodeStr = base64encode(utf16to8(escape(JSON.stringify(nodeObj))));
						var iframeContent = '<iframe id="EditPersonal" scrolling="no" frameborder="0" src="emr.ip.edit.personal.csp?NodeStr='+nodeStr+'" style="width:100%;height:99%;"></iframe>'
				    	parent.parent.createModalDialog("HisUIEditPersonal", "个人模板内容", xpwidth-100, xpheight-200, "EditPersonal", iframeContent,createCallback,"")
					} 
				
				},
				error: function(d) {alert("error");}
			}); 	
			
		}
		
	}
	else
	{
		$.messager.alert('提示','保存失败!', 'info');
	}
	$('#HISUIpersonaldlg').dialog('close');
	$HUI.dialog('#HISUIpersonaldlg').close();
	closeWindow();
}

function createCallback(returnValue,arr)
{
	initTree(userId,instanceId);
}

///重命名
function RenameIt(newName) {
	var node = $modelInstanceTree.tree('getSelected');
	var id = node.id;
	if (node.attributes.type == "root") return;
	var action = node.attributes.type ;
	if (newName == "") return;
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.PersonalTemplate",
			"Method":"ReName",
			"p1":id,
			"p2":newName,
			"p3":action
		},
		success: function(d){
			if (d == '1') 
			{
				node.text = newName;
				$modelInstanceTree.tree('update', node);
				$('#HISUIpersonaldlg').dialog('close');
			} 
			else 
			{
				$.messager.alert('提示','重命名失败', 'info');
			}
		
		},
		error: function(d) {alert("error");}
	}); 	
}

///删除节点
function Delete()
{
	var node = $modelInstanceTree.tree('getSelected');
	if (node.attributes.type === "category") {
		if ($modelInstanceTree.tree('getChildren', node.target).length > 0) 
		{
			$.messager.alert('提示','存在下级节点，不允许删除', 'info');
			return;
		}
	}
    if (node.attributes.type == "root") return;
	var tipMsg = '确定删除【' + node.text + '】?'
	parent.$.messager.confirm("操作提示", tipMsg, function (data) {
				if (data)
				{   
					var action = node.attributes.type ;
					jQuery.ajax({
						type: "post",
						dataType: "text",
						url: "../EMRservice.Ajax.common.cls",
						async: true,
						data: {
							"OutputType":"String",
							"Class":"EMRservice.BL.PersonalTemplate",
							"Method":"DeleteData",
							"p1":node.id,
							"p2":action
						},
						success: function(d){
							if (d == '1') 
							{
								$modelInstanceTree.tree('remove', node.target);			
							} 
							else 
							{
								$.messager.alert('提示','删除失败', 'info');
							}
						
						},
						error: function(d) {alert("error");}
					});	
				   
				}
				else 
				{   
					return ;
				}
			});
	
}

///分享到科室
function shareit(){
	var node = $modelInstanceTree.tree('getSelected');
    if (node.attributes.type !== "node") 
    {
	    $.messager.alert('提示','请选择个人模板节点进行分享', 'info');
		return;   
	}
	
    if (node) {
        var id = node.id;
        var titleCode = node.attributes.titleCode;
        var emrdocId = node.attributes.emrdocId;
        var templateId = node.attributes.templateId;
        getUserTempGroupData(emrdocId,templateId);
        //判断是否已分享过，如分享过给予提示
		if (IsShareToLoc(id))
		{
			var tipMsg = '您已分享过该个人模板【' + node.text + '】，是否再次分享?'
			parent.$.messager.confirm("操作提示", tipMsg, function (data) {
				if (data)
				{   
					sharePerTemp(id,titleCode);
				}
				else 
				{   
					return ;
				}
			});
		}
		else
		{
			sharePerTemp(id,titleCode);
		}
    }
}

//根据emrdocId获取分类数据
function getUserTempGroupData(emrdocId,templateId)
{
    jQuery.ajax({
        type: "post",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType":"Stream",
            "Class":"EMRservice.BL.BLUserTemplateGroup",
            "Method":"GetUserTempGroupData",
            "p1":userLocId,
            "p2":emrdocId,
            "p3":0,
            "p4":templateId
        },
        success: function(d){
            if (d)
            {
                $("#userTempGroup").css("display","none");
                $("#categoryTree").css("display","block");
                var categorydata = $.parseJSON("["+d+"]");
                $("#categoryTree").tree("loadData",categorydata);
            }else{
                $("#userTempGroup").css("display","block");
                $("#categoryTree").css("display","none");
            }
        },
        error: function(d) {
            $.messager.alert('提示', "获取分类数据error", 'info');
        }
    });
}

function sharePerTemp(id,titleCode)
{
    $('#categorydlg').dialog({
        buttons: [{
                text: '确认',
                handler: function () {
                    var groupID = "";
                    var categoryNode = $('#categoryTree').tree('getSelected');
                    if (categoryNode){
                        groupID = categoryNode.id;
                    }
                    share(id,titleCode,groupID);
                    $HUI.dialog('#categorydlg').close();
                    return false;
                }
            }, {
                text: '取消',
                handler: function () {
                    $('#categorydlg').dialog('close');
                    return false;
                }
            }
        ]
    }).dialog('open');
}

function share(id,titleCode,groupID)
{
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.PersonalTemplate",
			"Method":"Share",
			"p1":id,
			"p2":userLocId,
			"p3":titleCode,
			"p4":groupID
		},
		success: function(d){
			if (d == '1') 
			{
				$.messager.alert('提示','分享个人模板成功，等待审核后即可在科室模板中进行使用', 'info');		
			} 
			else 
			{
				$.messager.alert('提示', '分享失败，失败原因:'+d, 'info');
			}
		
		},
		error: function(d) {
			$.messager.alert('提示', "分享个人模板error", 'info');
		}
	});
}

///编辑个人模板
function Modifyit()
{
	var node = $modelInstanceTree.tree('getSelected');
    if (node.attributes.type !== "node") 
    {
		$.messager.alert('提示', "请选择节点再进行编辑!", 'info');
		return;
	}
    if (node) {
	    //以前的模态框
        //var returnValues = window.showModalDialog('emr.opdoc.edit.personal.csp', node, 'dialogHeight:765px;dialogWidth:1360px;resizable:yes;center:yes;minimize:yes;maximize:yes;');
    	
        var xpwidth=window.screen.width-200;
		var xpheight=window.screen.height-100;
    	//HISUI模态框
    	var nodeObj = {"id":node.id,"documentType":node.attributes.documentType,"name":node.text}
		var nodeStr = base64encode(utf16to8(escape(JSON.stringify(nodeObj))));
		var iframeContent = '<iframe id="EditPersonal" scrolling="no" frameborder="0" src="emr.ip.edit.personal.csp?NodeStr='+nodeStr+'" style="width:100%;height:99%;"></iframe>'
    	parent.parent.createModalDialog("HisUIEditPersonal", "个人模板内容", xpwidth-100, xpheight-200, "EditPersonal", iframeContent,createCallback,"")
    }
}

///判断是否已分享过
function IsShareToLoc(nodeID)
{
	var result = false;
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.PersonalTemplate",
			"Method":"IsShareToLoc",
			"p1":nodeID,
			"p2":userLocId
		},
		success: function(d){
			if (d == "1"){
				result = true;		
			}
		},
		error: function(d) {
			$.messager.alert('提示', "获取个人模板是否已分享数据error", 'info');
		}
	});	
	return result;
}

function getCurr(){
    var n = $modelInstanceTree.find('.tree-node-hover');
    if (!n.length){
        n = $modelInstanceTree.find('.tree-node-selected');
    }
    return n;
}

///下移(同级别)
function getNext(curr){
	var currnode = $modelInstanceTree.tree('getNode', curr[0]);
	var n = curr.parent().next().children('div.tree-node');
	if (n.length)
	{
		var node = $modelInstanceTree.tree('getNode', n[0]);
		var action = node.attributes.type;
		if (swapSequence(node.id,currnode.id,action) == "1")
		{
			var tempnode = $modelInstanceTree.tree('pop', currnode.target)
			$modelInstanceTree.tree('insert', {
				after: node.target,
				data: tempnode
			});
		}
		else
		{	$.messager.alert('提示', "移动失败", 'info');
			
		}
	}
	else
	{	$.messager.alert('提示', "不能下移", 'info');
	
	}
}

///上移(同级别)
function getPrev(curr){
	var currnode = $modelInstanceTree.tree('getNode', curr[0]);
	var n = curr.parent().prev().children('div.tree-node');
	if (n.length)
	{
		var node = $modelInstanceTree.tree('getNode', n[0]);
		var action = node.attributes.type;
		if (swapSequence(node.id,currnode.id,action) == "1")
		{
			var tempnode = $modelInstanceTree.tree('pop', currnode.target)
			$modelInstanceTree.tree('insert', {
				before: node.target,
				data: tempnode
			});
		}
		else
		{	$.messager.alert('提示', "移动失败", 'info');
			
		}
	}
	else
	{	$.messager.alert('提示', "不能上移", 'info');
		
	}
}

///关闭窗口
function closeWindow() {
    window.opener = null;
    window.open('', '_self');
    window.close();
}

