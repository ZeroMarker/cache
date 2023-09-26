var $modelInstanceTree;
var documentContext;
//var onlyone = false;
$(function () {
	$modelInstanceTree = $('#modelInstanceTree');
	var param = {"action":"GET_DOCUMENT_CONTEXT"};
	documentContext = parent.eventDispatch(param);
	initTree(userId,instanceId);
	initContextMenu();
	$('#newName').on('input', function () {
		checkNewname();
	});
});
//去掉特殊字符
function checkNewname(){
	var patrn = /[`~!@#$%^&*()_\-+=<>?:"{}|,.\/;'\\[\]·~！@#￥%……&*（）——\-+={}|《》？：“”【】、；’‘'，。、]/im;
	var newName = $('#newName').val();
	if(patrn.test(newName)){
		for(var i = 0;i<newName.length;i++){
			newName = newName.replace(patrn,"");
		}
		$('#newName').val(newName);
		//提示不允许输入特殊字符
		$("#newName").tooltip({position:'bottom'}).tooltip('show');
		return false;
	}else{
		$("#newName").tooltip({position:'bottom'}).tooltip('hide');
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
	var patInfo = parent.patInfo;

    var data = ajaxDATA('Stream', 'EMRservice.BL.PersonalTemplate', 'GetDataTree', userId, instanceId);
    ajaxGET(data, function (ret) {
        initTreeFunc($.parseJSON(ret));
    }, function (ret) {
        alert('GetTemplateClassify ' + ' error:' + ret);
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
    }).tree('expandAll');
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
	showNameDlg(saveExample);
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
			"p3":name
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
		"action":"SAVE_PERSONAL_SECTION",
		"args":{
			"CategoryID":parentId,
			"UserID":userId,
			"Name":name,
			"isSync":true
		}
	};
	var ret = parent.eventDispatch(param); 
	if (ret.result === 'OK' && ret.params.result === 'OK') 
	{
		initTree(userId,instanceId);
	}
	else
	{
		$.messager.alert('提示','保存失败!', 'info');
	}
	$('#HISUIpersonaldlg').dialog('close');
	$HUI.dialog('#HISUIpersonaldlg').close();
	closeWindow();
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
		jQuery.ajax({
			type: "post",
			dataType: "text",
			url: "../EMRservice.Ajax.common.cls",
			async: true,
			data: {
				"OutputType":"String",
				"Class":"EMRservice.BL.PersonalTemplate",
				"Method":"Share",
				"p1":node.id,
				"p2":userLocId
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
//        var returnValues = window.showModalDialog('emr.opdoc.edit.personal.csp', node, 'dialogHeight:765px;dialogWidth:1360px;resizable:yes;center:yes;minimize:yes;maximize:yes;');
    	
    	//HISUI模态框
		var nodeStr = base64encode(utf16to8(escape(JSON.stringify(node))));
		var iframeContent = '<iframe id="EditPersonal" scrolling="no" frameborder="0" src="emr.opdoc.edit.personal.csp?NodeStr='+nodeStr+'" style="width:100%;height:99%;"></iframe>'
    	parent.createModalDialog("HisUIEditPersonal", "个人模板内容", 1300, 800, "EditPersonal", iframeContent,"","")
    }
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

