$(function(){
	setdatabindPage();
	setButtonStatus("0");
	initEmrTree();
	initContextMenu();
	setElementEvent();
	setFontData();
	setFontSizeData();
	initKBCateTree();
	initKBTreeMenu();
})

///设置新增、保存、审核按钮不可用状态
function setButtonStatus(flag)
{
	if (flag == "0")
	{
		$("#btnAdd").linkbutton('disable');
		$("#btnSave").linkbutton('disable');
		$("#btnCommit").linkbutton('disable');
	}
	else if (flag == "1")
	{
		$("#btnAdd").linkbutton('enable');
		$("#btnSave").linkbutton('enable');
	}
}

///初始化模板目录树
function initEmrTree(openFlag)
{
	if (openFlag == undefined) openFlag = "0";
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLIEUserTemplate",
			"Method":"GetTemplateTreeJson",
			"p1":userLocId,
			"p2":ssgroupId
		},
		success: function(d){
			data = eval("["+d+"]");
			initTreeFunc(data[0],openFlag);
		},
		error: function(d){
			alert("initEmrTree error");
		}
	});
}

//设置右键菜单权限
function onContextMenu(e,node)
{
	e.preventDefault();
	var node = $("#emrTree").tree('getSelected');
	
	$('#mm').menu('disableItem', $('#newFlod')[0]);
	$('#mm').menu('disableItem', $('#renameit')[0]);
	$('#mm').menu('disableItem', $('#removeit')[0]);
	$('#mm').menu('disableItem', $('#moveUpNode')[0]);
	$('#mm').menu('disableItem', $('#moveDownNode')[0]);
	//根节点
	if (node.attributes.nodetype == "root")
	{} 
	//category层
	else if (node.attributes.nodetype == "category")
	{} 
	//基础模板层
	else if (node.attributes.nodetype == "basisTemplate")
	{ 
		if (node.attributes.documentType == "GRID") return;
		$('#mm').menu('enableItem', $('#newFlod')[0]);
	}
	//自建文件夹层
	else if (node.attributes.nodetype == "flod")
	{ 
		$('#mm').menu('enableItem', $('#newFlod')[0]);
		$('#mm').menu('enableItem', $('#renameit')[0]);
		$('#mm').menu('enableItem', $('#removeit')[0]);
		$('#mm').menu('enableItem', $('#moveUpNode')[0]);
		$('#mm').menu('enableItem', $('#moveDownNode')[0]);
		if (node.children.length !== 0) $('#mm').menu('disableItem', $('#removeit')[0]);
	}
	//科室模板层
	else if (node.attributes.nodetype == "leaf")
	{
		$('#mm').menu('enableItem', $('#renameit')[0]);
		$('#mm').menu('enableItem', $('#removeit')[0]);
		$('#mm').menu('enableItem', $('#moveUpNode')[0]);
		$('#mm').menu('enableItem', $('#moveDownNode')[0]);
	}

	$('#mm').menu('show', {
		left: e.pageX,
		top: e.pageY
	});
}

function initTreeFunc(data,openFlag)
{
	$("#emrTree").tree({
        data: data,
        dnd: true,
		lines:true,
		onContextMenu: function (e, node) {
			$(this).tree('select', node.target);
			onContextMenu(e, node);
		},
		onLoadSuccess:function(node,data){
			if (openFlag == "1")
			{
				var node = $("#emrTree").tree('find', "user^"+tempUserTemplateID);
				$("#emrTree").tree('select', node.target);
				setButtonStatus("1");
				model = {
					"id":node.attributes.Code,
					"TemplateVersionId":node.attributes.TemplateVersionId,
					"TemplateType":"department",
					"node":node
				};
				openTemplate();
			}
			$("#setPropty").accordion('select', '章节属性');
		},
        onBeforeSelect : function (node) {
            if (node.id)
                return true;
            else
                return false;
        },
        onBeforeDrag: function (node) {
	        if (node.attributes.nodetype !== "leaf") return false;
	        if (node.attributes.Type == "全院通用") return false;
			tParentNode = $("#emrTree").tree('getParent',node.target);
	    },
		onBeforeDrop: function (targetNode, source, point) {
			//目标节点
			var sNode = $("#emrTree").tree('getNode', targetNode);
			//选中节点
			var tNode = source;
			if (tNode.attributes.nodetype == "leaf")
			{
				if (tNode.attributes.Status !== "1")
				{
					top.$.messager.alert('提示','未审核模板不可移动', 'info');
					return false;
				}
				else if (tNode.attributes.Type == "全院通用")
				{
					top.$.messager.alert('提示','全院通用科室模板不可移动', 'info');
					return false;
				}
				else
				{
					//释放在基础模板或者在自建文件夹
					if ((sNode.attributes.nodetype == "basisTemplate")||(sNode.attributes.nodetype == "flod"))
					{
						var tempsNode = sNode;
						while (tempsNode.attributes.nodetype !== "basisTemplate")
						{
							tempsNode = $("#emrTree").tree('getParent',tempsNode.target);
						}
						var temptNode = tNode;
						while (temptNode.attributes.nodetype !== "basisTemplate")
						{
							temptNode = $("#emrTree").tree('getParent',temptNode.target);
						}
						if (tempsNode == temptNode)
						{}
						else
						{
							top.$.messager.alert('提示','不可放至此位置', 'info');
							return false;
						}
						
					}
					else
					{
						top.$.messager.alert('提示','不可放至此位置', 'info');
						return false;
					}
				}
			}
			else 
			{
				top.$.messager.alert('提示','不可放至此位置', 'info');
				return false;
			}
		},
        onDrop: function (targetNode, source, point) {
	        //目标节点
            var sNode = $("#emrTree").tree('getNode', targetNode);
            //选中节点
            var tNode = source;
			if (tNode.attributes.nodetype == "leaf")
			{
				if (tNode.attributes.Status !== "1")
				{
					top.$.messager.alert('提示','未审核模板不可移动', 'info');
					return false;
				}
				else if (tNode.attributes.Type == "全院通用")
				{
					top.$.messager.alert('提示','全院通用科室模板不可移动', 'info');
					return false;
				}
				else
				{
					//释放在基础模板或者在自建文件夹
					if ((sNode.attributes.nodetype == "basisTemplate")||(sNode.attributes.nodetype == "flod"))
					{
						if (updateNodeLocation(tNode,sNode) !== "1")
						{
							top.$.messager.alert('提示','移动失败', 'info');
							return false;
						}
					}
					else
					{
						top.$.messager.alert('提示','不可放至此位置', 'info');
						return false;
					}
				}
			}
			else 
			{
				top.$.messager.alert('提示','不可放至此位置', 'info');
				return false;
			}
		},
		onDblClick:function()
		{
			var node = $("#emrTree").tree('getSelected');
			//如果是双击文件夹 直接返回
			if ((node.attributes.nodetype == "root")||(node.attributes.nodetype == "category")||(node.attributes.nodetype == "flod")) return;
			if (node.attributes.documentType == "GRID")
			{
				top.$.messager.alert("提示","该模板为GRID类型模板，不可使用",'info');
				return;
			}
			if (!loadTempFlag) return;
			loadTempFlag = false;
			if ((node.attributes.nodetype == "basisTemplate")||(node.attributes.nodetype == "leaf"))
			{
				if (plugin() != undefined)
				{
					var strJson = {
						"action" : "CLEAN_DOCUMENT",
						"args" : ""
					};
				    cmdDoExecute(strJson);
				}
				setButtonStatus("0");
				tempUserTemplateID = checkNewId(node.id);
				var tempId = "";
				var TemplateType = "basis";
				if (node.attributes.nodetype == "leaf")	//科室模板
				{
					tempId = node.attributes.Code;
					TemplateType = "department"
				}
				model = {
					"id":tempId,
					"TemplateVersionId":node.attributes.TemplateVersionId,
					"TemplateType":TemplateType,
					"node":node
				};
				openTemplate();
			}
		}
    });	//.tree('expandAll')
}

///工具栏
function initContextMenu()
{
	//新建文件夹
	document.getElementById("newFlod").onclick = function(){
		var node = $("#emrTree").tree('getSelected');
		if (node)
		{
			if ((node.attributes.nodetype == "basisTemplate")||(node.attributes.nodetype == "flod"))	//基础模板层和自建文件夹层下可以新建文件夹
			{
				newUserFlod();
			}
		}
	}
	//重命名
	document.getElementById("renameit").onclick = function(){
		var node = $("#emrTree").tree('getSelected');
		if (node) {
			modifyNodeName();
		}
	}
	//删除
	document.getElementById("removeit").onclick = function(){
		Delete();
	}
	//上移
	document.getElementById("moveUpNode").onclick = function(){
		MoveNode("UP",getCurr());
	}
	//下移
	document.getElementById("moveDownNode").onclick = function(){
		MoveNode("DOWN",getCurr())
	}
}

//新建文件夹
function newUserFlod() {
	top.$.messager.prompt('新建文件夹', '设置文件夹名称为:', function(val){
		if (val){
			var node = $("#emrTree").tree('getSelected');
			var tempNode = node;
			while (tempNode.attributes.nodetype !== "basisTemplate")
			{
				tempNode = $("#emrTree").tree('getParent',tempNode.target);
			}
			var templateID = tempNode.id;
			jQuery.ajax({
				type: "post",
				dataType: "text",
				url: "../EMRservice.Ajax.common.cls",
				async: true,
				data: {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLIEUserTemplate",
					"Method":"AddUserTemplateGroup",
					"p1":userLocId,
					"p2":val,
					"p3":checkNewId(node.id),
					"p4":checkNewId(templateID)
				},
				success: function(d){
					if (d !== "0") initEmrTree();
				},
				error: function(d) {alert("newUserFlod error");}
			});
		}
	});
}

//删除（自建文件夹或科室模板）
function Delete()
{
	var node = $("#emrTree").tree('getSelected');
	if (node.attributes.nodetype == "flod")	//自建文件夹
	{
		if (node.children.length !== 0) 
		{
			top.$.messager.alert("提示","该节点存在子节点,不可删除",'info');
			return;
		}
		jQuery.ajax({
			type: "post",
			dataType: "text",
			url: "../EMRservice.Ajax.common.cls",
			async: true,
			data:{
				"OutputType":"String",
				"Class":"EMRservice.BL.BLIEUserTemplate",
				"Method":"DeleteUserTemplateGroup",
				"p1":checkNewId(node.id)
			},
			success: function(d){
				if (d == '1')
				{
					$("#emrTree").tree('remove', node.target);
				} 
				else 
				{
					top.$.messager.alert('提示','删除失败','info');
				}
			},
			error: function(d) {alert("delete error");}
		});
	}
	else if (node.attributes.nodetype == "leaf")	//科室模板
	{
		if (node.attributes.Status == "1") 
		{
			top.$.messager.confirm("删除科室模板", "该科室模板已通过审核，是否确认删除", function (r) {
				if (r)
				{
					deleteUserTemp(node);
				}
			});
		}
		else
		{
			deleteUserTemp(node);
		}
	}
	else
	{
		top.$.messager.alert("提示","基础数据不允许删除",'info');
		return;
	}
}
//删除模板公共方法
function deleteUserTemp(node){
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data:{
			"OutputType":"String",
			"Class":"EMRservice.BL.BLIEUserTemplate",
			"Method":"DeleteUserTemplate",
			"p1":node.attributes.Code
		},
		success: function(d){
			if (d == '1')
			{
				$("#emrTree").tree('remove', node.target);
				if (plugin() != undefined)
				{
					var strJson = {
						"action" : "CLEAN_DOCUMENT",
						"args" : ""
					};
				    cmdDoExecute(strJson);
				}
				setButtonStatus("0");
			} 
			else 
			{
				top.$.messager.alert('提示','删除失败','info');
			}
		},
		error: function(d) {alert("delete error");}
	});
}

function getCurr(){
    var n = $("#emrTree").find('.tree-node-hover');
    if (!n.length){
        n = $("#emrTree").find('.tree-node-selected');
    }
    return n;
}

//上移/下移
function MoveNode(moveType,curr)
{
	var node = $("#emrTree").tree('getSelected');
	var userTempID = checkNewId(node.id);
	if (node.attributes.nodetype == "flod")		//自建文件夹
	{
		var method = "MoveFlodNode";
	}
	else if (node.attributes.nodetype == "leaf")	//科室模板
	{
		if ($("#emrTree").tree('getParent',node.target).attributes.nodetype =="basisTemplate")
		{
			var basisNode = $("#emrTree").tree('getParent',node.target);
			var upNodeID = "";
			var downNodeID = "";
			for (var i=0;i<basisNode.children.length;i++)
			{
				if (basisNode.children[i].attributes.nodetype == "flod") continue;
				if (node.id == basisNode.children[i].id)
				{
					if (basisNode.children[i+1] != undefined) downNodeID = checkNewId(basisNode.children[i+1].id);
					break;
				}
				upNodeID = checkNewId(basisNode.children[i].id);
			}
			userTempID = userTempID+"#"+upNodeID+"#"+downNodeID;
		}
		var method = "MoveLeafNode";
	}
	else
	{
		top.$.messager.alert("提示","基础数据不允许移动",'info');
		return;
	}
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLIEUserTemplate",
			"Method":method,
			"p1":userTempID,
			"p2":moveType
		},
		success: function(d){
			if (d == '1')
			{
				//initEmrTree();
				var currnode = $("#emrTree").tree('getNode', curr[0]);
				if (moveType == "DOWN")	//下移
				{
					var n = curr.parent().next().children('div.tree-node');
					if (n.length)
					{
						var anothernode = $("#emrTree").tree('getNode', n[0]);
						var tempnode = $("#emrTree").tree('pop', currnode.target)
						$("#emrTree").tree('insert', {
							after: anothernode.target,
							data: tempnode
						});
					}
				}
				else	//上移
				{
					var n = curr.parent().prev().children('div.tree-node');
					if (n.length)
					{
						var anothernode = $("#emrTree").tree('getNode', n[0]);
						var tempnode = $("#emrTree").tree('pop', currnode.target)
						$("#emrTree").tree('insert', {
							before: anothernode.target,
							data: tempnode
						});
					}
				}
				
			} 
			else 
			{
				top.$.messager.alert('提示','移动失败','info');
			}
		},
		error: function(d) {alert("MoveNode error");}
	});
}

//重命名
function modifyNodeName()
{
	top.$.messager.prompt('重命名', '设置新名称为:', function(val){
		if (val){
			var node = $("#emrTree").tree('getSelected');
			if (node.attributes.nodetype == "flod")		//自建文件夹
			{
				var data = {
						"OutputType":"String",
						"Class":"EMRservice.BL.BLIEUserTemplate",
						"Method":"ModifyGroupName",
						"p1":checkNewId(node.id),
						"p2":val
					}
			}
			else if (node.attributes.nodetype == "leaf")	//科室模板
			{
				if (node.attributes.Status == "1")
				{
					top.$.messager.alert('提示','已通过审核不允许重命名','info');
					return;
				}
				var data = {
						"OutputType":"String",
						"Class":"EMRservice.BL.BLIEUserTemplate",
						"Method":"ModifyUserTemplateName",
						"p1":checkNewId(node.id),
						"p2":val,
						"p3":userId
					}
			}
			else
			{
				top.$.messager.alert('提示','基础数据不允许重命名','info');
				return;
			}
			jQuery.ajax({
				type: "post",
				dataType: "text",
				url: "../EMRservice.Ajax.common.cls",
				async: true,
				data: data,
				success: function(d){
					if(d == "1")
					{
						initEmrTree();
					}
				},
				error: function(d) {alert("modifyNodeName error");}
			});
		}
	});
}

//拖动节点位置
function updateNodeLocation(tNode,sNode)
{
	var result = "";
	if (tParentNode == "") return result;
	var oldGroupID = checkNewId(tParentNode.id);
	if (tParentNode.attributes.nodetype == "basisTemplate") oldGroupID = "0";
	var newGroupID = checkNewId(sNode.id);
	if (sNode.attributes.nodetype == "basisTemplate") newGroupID = "0";
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLIEUserTemplate",
			"Method":"UpdateNodeLocation",
			"p1":tNode.attributes.Code,
			"p2":oldGroupID,
			"p3":newGroupID
		},
		success: function(d){
			result = d;
		},
		error: function(d) {alert("updateNodeLocation error");}
	});
	tParentNode = "";
	return result;
}