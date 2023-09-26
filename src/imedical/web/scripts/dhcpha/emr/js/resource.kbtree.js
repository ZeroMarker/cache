var SearchBoxOnTree = NewSearchBoxOnTree();

function NewSearchBoxOnTree(){

	var SearchBoxOnTree = new Object();
	SearchBoxOnTree.ContinueID = '';
	SearchBoxOnTree.Search = function ($tree, value, isMatchFunc) {
		var searchCon = $("#searchBox").val();
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
			var flag = true;
			do {
				parentNode = $tree.tree('getParent', parentNode.target); //获取此节点父节点
				if (parentNode) { //如果存在
					flag = true;
					$tree.tree('expand', parentNode.target);
				} else {
					flag = false;
				}
			} while (flag);
		}

		//查找子节点，查找到了 true， 返回false继续查找
		function searchChild(startNode) {
			var children = $tree.tree('getChildren', startNode.target);
			if (!children)
				return false;
			var flag = false;

			for (var j = 0; j < children.length; j++) {
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

/*
门诊病历中知识库自动伸缩功能，
要求第一次进去界面的时候，不展示知识库
但是在初始时，编辑器会激活两次，
所以在传入参数的时候，要减2
*/
function collapseParent(flag) 
{
	if (flagFirst<2) 
	{
		flagFirst=flagFirst+1;
		return;
	}
	
	if (undefined===invoker.collapse) return;
	setTimeout("invoker.collapse("+flag+")",300);
}

//双击节点插入知识库
$(function(){
	if($.browser.version == '11.0')
	{
		document.documentElement.className ='ie11';
	}
	$('.easyui-layout').layout('resize');
	$('#kbTree').tree({
		onClick: function(node){
			if(node.attributes.type == "KBNode"){
				GetKBNodeTextByKBNodeID(node.id);
			}else{
				$("#kbNodeText").css("overflow-y","hidden");
				$("#kbNodeText").empty();
			}
		},
		onDblClick: function(node){
			if(node.attributes.type == "KBNode"){
				var param = {"action":"appendComposite","NodeID":node.id}
				invoker.eventDispatch(param);
			} else {
				$(this).tree(node.state === 'closed' ? 'expand' : 'collapse', node.target);  
				node.state = node.state === 'closed' ? 'open' : 'closed';  
			}
		},
		onContextMenu: function(e, node){
			treeRightClick(e,node);
		},
		onAfterEdit: function(node){
			updateTree(node.id,node.text);
		}
	});
	
	//新建知识库目录节点
	document.getElementById("addKBTree").onclick = function(){
		var node = $('#kbTree').tree('getSelected');
		var parentID = node.id;
		var baseID = $('#kbTree').tree('getRoot').id;
		jQuery.ajax({
			type : "GET",
			dataType : "text",
			url : "../EMRservice.Ajax.kbTree.cls",
			async : true,
			data : {"ACTION":"CreateKBTree","KnowledgeBaseID":baseID,"ParentID":parentID,"UserID":userID},
			success : function(d) {
	           if ( d != "") 
			   {
					$('#kbTree').tree('append', {
						parent: (node?node.target:null),
						data: [eval("("+d+")")]
					});
					$('#kbTree').tree("collapse",node.target);
					$('#kbTree').tree("expand",node.target);
			   }
			},
			error : function(d) { alert("add kbTree error");}
		});	
	}
		
	//删除个人知识库节点
	document.getElementById("deleteKBNode").onclick = function(){ 
		var node = $('#kbTree').tree('getSelected');
		var nodeparent = $('#kbTree').tree('getParent',node.target);
		jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : true,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLKBNode",
					"Method":"StopOrStartKBNode",			
					"p1":node.id,
					"p2":"N"
				},
			success : function(d) {
	           if ( d == 1) 
			   {
					
					$('#kbTree').tree('remove', node.target);
					if ($('#kbTree').tree('getChildren',nodeparent.target).length<=0)
				    {
					   $('#kbTree').tree('update', {
           					 target: nodeparent.target,
           					 iconCls: 'user-folder-open'
      					  });
				    }
			   }
			},
			error : function(d) { alert("delete KBNode error");}
		});	
	}
	
	///删除空个人知识库目录
	document.getElementById("deleteKBTree").onclick = function(){ 
		var node = $('#kbTree').tree('getSelected');
		if ($('#kbTree').tree('getChildren',node.target).length>0)
		{
			return;
		}
		var nodeparent = $('#kbTree').tree('getParent',node.target);
		jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : true,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLKBTree",
					"Method":"StopOrStartKBTree",			
					"p1":node.id,
					"p2":"N"
				},
			success : function(d) {
	           if ( d == 1) 
			   {
					$('#kbTree').tree('remove', node.target);
					if ($('#kbTree').tree('getChildren',nodeparent.target).length<=0)
				    {
					   $('#kbTree').tree('update', {
           					 target: nodeparent.target,
           					 iconCls: 'user-folder-open'
      					  });
				    }
			   }
			},
			error : function(d) { alert("delete KBTree error");}
		});	
	}
		
	//替换知识库节点
	document.getElementById("replaceKBNode").onclick = function(){ 
		var tipMsg = "是否确定替换该知识库?";
		if (window.confirm(tipMsg))
		{
			var node = $('#kbTree').tree('getSelected');
			var param = {"action":"replaceComposite","NodeID":node.id}
			invoker.eventDispatch(param);
		}
	}	
	
	//增加知识节点
	document.getElementById("addKBNode").onclick = function(){
		var node = $('#kbTree').tree('getSelected')
		var treeId = node.id;
		var baseID = $('#kbTree').tree('getRoot').id;
		jQuery.ajax({
			type : "GET",
			dataType : "text",
			url : "../EMRservice.Ajax.kbTree.cls",
			async : true,
			data : {"ACTION":"CreateKBNode","KnowledgeBaseID":baseID,"KBTreeID":treeId},
			success : function(d) {
	           if ( d != "") 
			   {
					$('#kbTree').tree('append', {
						parent: (node?node.target:null),
						data: [eval("("+d+")")]
					});
					$('#kbTree').tree("collapse",node.target);
					$('#kbTree').tree("expand",node.target);
			   }
			},
			error : function(d) { alert("add kbnode error");}
		});	
	}
	
	//追加知识库节点
	document.getElementById("appendKBNode").onclick = function(){
		var node = $('#kbTree').tree('getSelected')
		var nodeId = node.id;
		var treeId = $('#kbTree').tree('getParent',node.target).id;
		var baseID = $('#kbTree').tree('getRoot').id; 
		jQuery.ajax({
			type : "GET",
			dataType : "text",
			url : "../EMRservice.Ajax.kbTree.cls",
			async : true,
			data : {"ACTION":"CreateKBNode","KnowledgeBaseID":baseID,"KBTreeID":treeId},
			success : function(d) {
	           if ( d != "") 
			   {
					if (node){
						$('#kbTree').tree('insert', {
							after: node.target,
							data: eval("("+d+")")
						});
					}
					//追加知识库节点之后，调整知识库节点的sequence
					updateKbnodeSeq(node.id,eval("("+d+")").id,treeId);
			   }
			},
			error : function(d) { alert("append kbnode error");}
		});	
	}
	
	//编辑知识库内容
	document.getElementById("editKBNode").onclick = function(){
		var node = $('#kbTree').tree('getSelected');
        var array = new Array(2);
		array[0] = node;
		array[1] = invoker.argConnect;
		array[2] = visitType;
		var returnValues = window.showModalDialog("emr.record.edit.knowledgebase.csp",array,"dialogHeight:765px;dialogWidth:1360px;resizable:yes;center:yes;minimize:yes;maximize:yes;");
		if (returnValues && returnValues.NodeText)
		{
			$('#kbTree').tree('update', {
				target: node.target,
				text: returnValues.NodeText
			});
			if (returnValues.TextData != ""){
				$("#kbNodeText").css("overflow-y","auto");
				returnValues.TextData = returnValues.TextData.replace(/\s/g,"&nbsp");
				returnValues.TextData = returnValues.TextData.replace(/\\n/g,"<br/>");
				document.getElementById("kbNodeText").innerHTML = returnValues.TextData;
			}
		}
		if (returnValues && returnValues.NodeStatus)
		{
			if ( returnValues.NodeStatus == "N") $('#kbTree').tree('remove', node.target);
		}
	
	}
	//修改目录名称
	document.getElementById("editTreeName").onclick = function(){
		var node = $('#kbTree').tree('getSelected');
		$("#kbTree").tree('beginEdit',node.target);

	}
	
	//flag = 0： 向前  1：向后
	function getSibling(node, flag) {
		
		var parentNode = $('#kbTree').tree('getParent', node.target);
		var nodes = $('#kbTree').tree('getLeafChildren',parentNode.target);
		if (2 > nodes.length) return '';
		for(var i = 0; i< nodes.length; i++){
			if (node.id == nodes[i].id){	
				var tmpNode = '';
				if (0==flag) {
					tmpNode = nodes[i-1];
				} else {
					tmpNode = nodes[i+1];
				}
				if ((tmpNode != '')&&(tmpNode != undefined))
				{
					if ((node.attributes.type != "KBNode")&&(tmpNode.attributes.type == "KBNode"))
					{
						return ''
					}
					if ($('#kbTree').tree('isLeaf', tmpNode.target)) {
						//移动知识库模板节点
						SwapNode(node, tmpNode);
					}
					else
					{
						//移动知识库目录节点
						SwapTreeNode(node, tmpNode, flag);
					}
				}
				
				return '';
			}
		}	
		return '';
	}
	
	//移动知识库目录节点
	function SwapTreeNode(node1, node2, flag) {
		function refreshNode() {
			var changeData = $('#kbTree').tree('getData',node1.target);
			$('#kbTree').tree('remove',node1.target);
			if (flag == 0)
			{
				//上移
				$('#kbTree').tree('insert', {
						before: node2.target,
						data: changeData
				});
			}
			else
			{
				//下移
				$('#kbTree').tree('insert', {
						after: node2.target,
						data: changeData
				});
			}


		}
	
		//交换知识库目录的排序Sequence
		jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : true,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLKBTree",
					"Method":"SwapSequence",			
					"p1":node1.id,
					"p2":node2.id
				},
			success : function(d) {
	           if ( d == 1) {
					refreshNode();
			   }
			},
			error : function(d) { alert("Swap Tree Sequence error!");}
		});				
	}
	
	//交换知识库模板节点
	function SwapNode(node1, node2) {
		function swap() {
			var id = node2.id;
			var txt = node2.text;
			$('#kbTree').tree('update', {
				target: node2.target,
				id: node1.id,
				text: node1.text
			});	
			$('#kbTree').tree('update', {
				target: node1.target,
				id: id,
				text: txt
			});				
		}
	
		jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : true,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLKBNode",
					"Method":"SwapSequence",			
					"p1":node1.id,
					"p2":node2.id
				},
			success : function(d) {
	           if ( d == 1) {
					swap();
			   }
			},
			error : function(d) { alert("Swap Sequence error!");}
		});				
	}
	
	//上移
	document.getElementById("moveUpKBNode").onclick = function(){ 
		var node = $('#kbTree').tree('getSelected');
		getSibling(node, 0);
		
	}
	//下移
	document.getElementById("moveDownKBNode").onclick = function(){ 
		var node = $('#kbTree').tree('getSelected');
		getSibling(node, 1);
				
	}	
	
    if (invoker.emrEditor && ''!= invoker.emrEditor.kbtreeCmd) { 
        GetKBNodeByTreeID(invoker.emrEditor.kbtreeCmd); 
    }

	if (isModelDlg) {
		invoker.emrEditor.refreshKBFunc = GetKBNodeByTreeID;
		window.onunload = function(){
			invoker.emrEditor.refreshKBFunc = null;
		}
	}
	
	//共享个人知识库节点
	document.getElementById("shareKBNode").onclick = function(){ 
		var node = $('#kbTree').tree('getSelected');
		jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : true,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLKBTree",
					"Method":"ShareKBNode",			
					"p1":node.id
				},
			success : function(d) {
	           if ( d == 1) 
			   {
					alert("共享个人知识库成功");
			   }
			},
			error : function(d) { alert("delete KBNode error");}
		});	
	}
});

//根据kbNodeID查找该kbNode节点相关的知识库文本内容
function GetKBNodeTextByKBNodeID(kbnodeID){
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLKBNode",
			"Method":"GetKBNodeTextByKBNodeID",
			"p1":kbnodeID
		},
		success : function(d) {
			var data = d;
			if (data != ""){
				$("#kbNodeText").css("overflow-y","auto");
				data = data.replace(/\s/g,"&nbsp");
				data = data.replace(/\\n/g,"<br/>");
				document.getElementById("kbNodeText").innerHTML = data;
				
			}else{
				$("#kbNodeText").css("overflow-y","hidden");
				$("#kbNodeText").empty();
			}
		},
		error : function(d) { alert("获取知识库节点文本内容错误！");}
	});
}

//传入kbTree的id查找权限下的kbNode节点
function GetKBNodeByTreeID(kbParam){	
    curKbParam = kbParam;
	
	if (typeof kbParam === "undefined" || kbParam === "")
		return;
	var kbBseId = kbParam["bindKBBaseID"];
	if (kbBseId==undefined) kbBseId="";
	var titleCode = kbParam["titleCode"];
	if (titleCode==undefined) titleCode="";
	var diseaseID = kbParam["diseaseID"];
	if (diseaseID==undefined){ var diseaseID=""};
    if ($("#dispalyAll").attr("checked") == "checked")
    {
        titleCode = "";
        diseaseID = "";
    }
    
    getBindKBNode("EMRservice.BL.BLKBNode","GetBindKBNode",kbBseId,userLocID,diseaseID,episodeID,userID,titleCode,true);

}

function getBindKBNode(className,methodName,nodeBaseID,userLocID,diseaseID,episodeID,userId,titleCode,async)
{
	if (nodeBaseID == "")
	{
		var rootNode = $('#kbTree').tree('getRoot');
		if (rootNode)
		{
			$('#kbTree').tree('remove',rootNode.target);
		}
		//清空知识库节点区域的文本内容 add by Lina 2016-11-07
		$("#kbNodeText").css("overflow-y","hidden");
		$("#kbNodeText").empty();
		collapseParent(true);
		return;
	}
	
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: async,
		data: {
			"OutputType":"Stream",
			"Class":className,
			"Method":methodName,
			"p1":nodeBaseID,
			"p2":userLocID,
			"p3":diseaseID,
			"p4":episodeID,
			"p5":userID,
			"p6":titleCode
		},
		success : function(d) {
			//alert(methodName+  ' '+d+'  '+userLocID);
			var rootNode = $('#kbTree').tree('getRoot');
			if (rootNode)
			{
				$('#kbTree').tree('remove',rootNode.target);
			}
			//清空知识库节点区域的文本内容 add by Lina 2016-11-07
			$("#kbNodeText").css("overflow-y","hidden");
			$("#kbNodeText").empty();
			if (d != "")
			{
				//debugger;
				if ((isCollapse =="1")||($("#dispalyAll").attr("checked") == "checked"))
				{
			   		$('#kbTree').tree({data: [eval("("+d+")")]}).tree('expandAll');
				}
				else
				{
			   		$('#kbTree').tree({data: [eval("("+d+")")]}).tree();
				}
				collapseParent(false);
			}
			else
			{
				collapseParent(true);
			}

		},
		error : function(d) { alert("获取知识库节点错误！");}
	});
}

//修改目录名称
function updateTree(treeId,treeName)
{
	jQuery.ajax({
		type : "GET",
		dataType : "text",
		url : "../EMRservice.Ajax.kbTree.cls",
		async : true,
		data : {"ACTION":"UpdateKBTree","KBTreeID":treeId,"Name":treeName},
		success : function(d) {
			if (d == 1)
			{
				alert('修改目录名称成功');
			}
			else
			{
				alert('修改目录名称失败');
			}
		},
		error : function(d) { alert("add kbTree error");}
	});	
}

//右键菜单
function treeRightClick(e,node)
{
	
	if (node.attributes.type == "KBBase") return;
	var pType = $('#kbTree').tree('getParent',node.target).attributes.type;
	$('#mm').menu('disableItem',$("#addKBTree")[0]);
	$('#mm').menu('disableItem',$("#addKBNode")[0]);
	$('#mm').menu('disableItem',$("#editKBNode")[0]);
	$('#mm').menu('disableItem',$("#editTreeName")[0]);
	$('#mm').menu('disableItem',$("#deleteKBTree")[0]);
	$('#mm').menu('disableItem',$("#deleteKBNode")[0]);
	$('#mm').menu('disableItem',$("#replaceKBNode")[0]);
	$('#mm').menu('disableItem',$("#moveUpKBNode")[0]);
	$('#mm').menu('disableItem',$("#moveDownKBNode")[0]);
	$('#mm').menu('disableItem',$("#appendKBNode")[0]);
	$('#mm').menu('disableItem',$("#shareKBNode")[0]);
	if (node.attributes.type == "KBNode")
	{
		setReplaceKBNodeStatus();
		
		if (isPersonEdit=="Y" && pType == "PersonalKBTree")
		{
			$('#mm').menu('enableItem',$("#editKBNode")[0]);
			$('#mm').menu('enableItem',$("#deleteKBNode")[0]);
			$('#mm').menu('enableItem',$("#moveUpKBNode")[0]);
			$('#mm').menu('enableItem',$("#moveDownKBNode")[0]);
			$('#mm').menu('enableItem',$("#appendKBNode")[0]);
			$('#mm').menu('enableItem',$("#shareKBNode")[0]);
		}
		else if(isCanEdit== "Y" && pType != "PersonalKBTree")
		{
			$('#mm').menu('enableItem',$("#editKBNode")[0]);
		}
	}
	else if (isPersonEdit== "Y" && pType == "KBBase")
	{
		$('#mm').menu('enableItem',$("#addKBTree")[0]);
	}
	else if (isPersonEdit== "Y" && node.attributes.type == "PersonalKBTree")
	{
		$('#mm').menu('enableItem',$("#moveUpKBNode")[0]);
		$('#mm').menu('enableItem',$("#moveDownKBNode")[0]);
		var childLength = $('#kbTree').tree('getChildren',node.target).length;
		if (childLength <=0)
		{
			$('#mm').menu('enableItem',$("#addKBTree")[0]);
			$('#mm').menu('enableItem',$("#addKBNode")[0]);
			$('#mm').menu('enableItem',$("#deleteKBTree")[0]);
		}
		else
		{
			var cType = $('#kbTree').tree('getChildren',node.target)[0].attributes.type;
			if (cType == "KBNode")
			{
				$('#mm').menu('enableItem',$("#addKBNode")[0]);
			}
			else
			{
				$('#mm').menu('enableItem',$("#addKBTree")[0]);
			}
		}
		$('#mm').menu('enableItem',$("#editTreeName")[0]);
	}
	e.preventDefault();
	$('#kbTree').tree('select', node.target);
	$('#mm').menu('show', {left: e.pageX, top: e.pageY});
}

///折叠所有节点
$("#collapseAll").click(function(){
	$('#kbTree').tree('collapseAll');	
})

///显示全部
$("#dispalyAll").change(function() {
    
    var kbParam = "";
    if ($("#dispalyAll").attr("checked") == "checked")
    {
    	kbParam = {"bindKBBaseID":curKbParam.bindKBBaseID,"titleCode":"","diseaseID":""};
    }
    else
    {
	    kbParam = curKbParam;
	}
	GetKBNodeByTreeID(kbParam);
});

///设置替换知识库右键菜单状态
function setReplaceKBNodeStatus()
{	
	var isComposite = invoker.getElementContext("Composite");
	var isReadOnly = invoker.getReadOnlyStatus();
	if ((isComposite != "NONE")&&(isReadOnly != "True"))
	{
		$('#mm').menu('enableItem',$("#replaceKBNode")[0]);	
	}
}

//屏蔽Backspace键，阻止界面刷新与退出病历编辑界面
$(document).keydown(function(e){
	var target = e.target ;
    var tag = e.target.tagName.toUpperCase();
    if(e.keyCode == 8){
	    if((tag == 'INPUT' && !$(target).attr("readonly"))||(tag == 'TEXTAREA' && !$(target).attr("readonly"))){
		    if((target.type.toUpperCase() == "RADIO") || (target.type.toUpperCase() == "CHECKBOX")){
			    return false ;
			}else{
				return true ; 
            }
        }else{
	        return false ;
        }
    }
});

//追加知识库节点之后，调整知识库节点的sequence
function updateKbnodeSeq(kbnodeID1,kbnodeID2,kbtreeID)
{
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls", 
			async : true,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLKBNode",
					"Method":"UpdateKbnodeSeq",			
					"p1":kbnodeID1,
					"p2":kbnodeID2,
					"p3":kbtreeID
				}
		});				
}

//点击控件事件
function my_click(obj, myid)
{
	if (document.getElementById(myid).value == document.getElementById(myid).defaultValue)
	{
		document.getElementById(myid).value = '';
		obj.style.color='#000';
	}
}
//离开控件事件
function my_blur(obj, myid)
{
	if (document.getElementById(myid).value == '')
	{
		document.getElementById(myid).value = document.getElementById(myid).defaultValue;
		obj.style.color='#999'
	}
}
// 回车事件
function my_keyDown()
{
	if(event.keyCode==13)
    {
		serachRecord();                             
    }

}

$("#searchRecord").click(function(){
	serachRecord();
});

//病历检索
function serachRecord()
{
	var SearchValue = $("#searchBox").val();
	if (SearchValue == $("#searchBox")[0].defaultValue)
	{
		SearchValue = "";
	}
	SearchBoxOnTree.Search($('#kbTree'), SearchValue, function (node, searchCon){
		return (node.text.indexOf(searchCon) >= 0);
	});	
}
