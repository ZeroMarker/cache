var KbID=""
$.extend($.fn.tree.methods, {
    getLeafChildren: function(jqTree, params) {
        var nodes = [];
        $(params).next().children().children("div.tree-node").each(function() {
            nodes.push($(jqTree[0]).tree('getNode', this));
        });
        return nodes;
    },
    /** 
     * ��������������ָ���Ľڵ�λ�ã�ʹ�ýڵ�ɼ�������й������Ź�����û�й������Ͳ������� 
     * @param param { 
     *    treeContainer: easyui tree�������������ڹ��������������������Ϊnull����ȡeasyui tree�ĸ�UL�ڵ�ĸ��ڵ㡣 
     *    targetNode:  ��Ҫ��������easyui tree�ڵ㡣���targetNodeΪ�գ���Ĭ�Ϲ�������ǰ��ѡ�еĽڵ㣬���û��ѡ�еĽڵ㣬�򲻹��� 
     * }  
     */
    scrollTo: function(jqTree, param) {
        //easyui tree��tree���󡣿���ͨ��tree.methodName(jqTree)��ʽ����easyui tree�ķ���  
        var tree = this;
        //���nodeΪ�գ����ȡ��ǰѡ�е�node  
        var targetNode = param && param.targetNode ? param.targetNode : tree.getSelected(jqTree);

        if (targetNode != null) {
            //�жϽڵ��Ƿ��ڿ�������                 
            var root = tree.getRoot(jqTree);
            var $targetNode = $(targetNode.target);
            var container = param && param.treeContainer ? param.treeContainer : jqTree.parent();
            var containerH = container.height();
            var nodeOffsetHeight = $targetNode.offset().top - container.offset().top;
            if (nodeOffsetHeight > (containerH - 30)) {
                var scrollHeight = container.scrollTop() + nodeOffsetHeight - containerH + 30;
                container.scrollTop(scrollHeight);
            }
        }
    }
});

var flagFirst = 0;
/*
���ﲡ����֪ʶ���Զ��������ܣ�
Ҫ���һ�ν�ȥ�����ʱ�򣬲�չʾ֪ʶ��
�����ڳ�ʼʱ���༭���ἤ�����Σ�
��������һ����־����������ʼ����
*/
function collapseParent(flag) 
{
	if (flagFirst<2) 
	{
		flagFirst=flagFirst+1;
		return;
	}

	if (undefined==invoker.collapse) return;
	setTimeout("invoker.collapse("+flag+")",300);
}

//˫���ڵ����֪ʶ��
$(function(){
	$('.easyui-layout').layout('resize');
	$('#kbTree').tree({
		onClick: function(node){
			if(node.attributes.type == "KBNode"){
				if (node.attributes.textData != ""){
					$("#kbNodeText").css("overflow-y","auto");
					$("#kbNodeText").text(node.attributes.textData);
				
				}else{
					$("#kbNodeText").css("overflow-y","hidden");
					$("#kbNodeText").empty();
				}
			}else{
				$("#kbNodeText").css("overflow-y","hidden");
				$("#kbNodeText").empty();
			}
		},
		onDblClick: function(node){
			if(node.attributes.type == "KBNode"){
				var param = {"action":"appendComposite","NodeID":node.id}
				parent.eventDispatch(param);
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
	
	//�½�֪ʶ��Ŀ¼�ڵ�
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
			   }
			},
			error : function(d) { alert("add kbTree error");}
		});	
	}
		
	//ɾ������֪ʶ��ڵ�
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
	
	///ɾ���ո���֪ʶ��Ŀ¼
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
		
	//�滻֪ʶ��ڵ�
	document.getElementById("replaceKBNode").onclick = function(){ 
		var tipMsg = "�Ƿ�ȷ���滻��֪ʶ��?";
		if (window.confirm(tipMsg))
		{
			var node = $('#kbTree').tree('getSelected');
			var param = {"action":"replaceComposite","NodeID":node.id}
			parent.eventDispatch(param);
		}
	}	
	
	//����֪ʶ�ڵ�
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
			   }
			},
			error : function(d) { alert("add kbnode error");}
		});	
	}
	
	//׷��֪ʶ��ڵ�
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
					//׷��֪ʶ��ڵ�֮�󣬵���֪ʶ��ڵ��sequence
					updateKbnodeSeq(node.id,eval("("+d+")").id,treeId);
			   }
			},
			error : function(d) { alert("append kbnode error");}
		});	
	}
	
	//�༭֪ʶ������
	document.getElementById("editKBNode").onclick = function(){
		var node = $('#kbTree').tree('getSelected');
        var array = new Array(2);
		array[0] = node;
		array[1] = invoker.argConnect;
		var returnValues = window.showModalDialog("emr.record.edit.knowledgebase.csp",array,"dialogHeight:765px;dialogWidth:1360px;resizable:yes;center:yes;minimize:yes;maximize:yes;");
		if (returnValues && returnValues.NodeText)
		{
			$('#kbTree').tree('update', {
				target: node.target,
				text: returnValues.NodeText
			});
			if (returnValues.TextData != ""){
				node.attributes.textData = returnValues.TextData;
				$("#kbNodeText").css("overflow-y","auto");
				$("#kbNodeText").text(node.attributes.textData);
			}
		}
		if (returnValues && returnValues.NodeStatus)
		{
			if ( returnValues.NodeStatus == "N") $('#kbTree').tree('remove', node.target);
		}
	
	}
	//�޸�Ŀ¼����
	document.getElementById("editTreeName").onclick = function(){
		var node = $('#kbTree').tree('getSelected');
		$("#kbTree").tree('beginEdit',node.target);

	}
	
	//flag = 0�� ��ǰ  1�����
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
						//�ƶ�֪ʶ��ģ��ڵ�
						SwapNode(node, tmpNode);
					}
					else
					{
						//�ƶ�֪ʶ��Ŀ¼�ڵ�
						SwapTreeNode(node, tmpNode, flag);
					}
				}
				
				return '';
			}
		}	
		return '';
	}
	
	//�ƶ�֪ʶ��Ŀ¼�ڵ�
	function SwapTreeNode(node1, node2, flag) {
		function refreshNode() {
			var changeData = $('#kbTree').tree('getData',node1.target);
			$('#kbTree').tree('remove',node1.target);
			if (flag == 0)
			{
				//����
				$('#kbTree').tree('insert', {
						before: node2.target,
						data: changeData
				});
			}
			else
			{
				//����
				$('#kbTree').tree('insert', {
						after: node2.target,
						data: changeData
				});
			}


		}
	
		//����֪ʶ��Ŀ¼������Sequence
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
	
	//����֪ʶ��ģ��ڵ�
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
	
	//����
	document.getElementById("moveUpKBNode").onclick = function(){ 
		var node = $('#kbTree').tree('getSelected');
		getSibling(node, 0);
		
	}
	//����
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
});

//����kbTree��id����Ȩ���µ�kbNode�ڵ�
function GetKBNodeByTreeID(kbParam){
	
	curKbParam = kbParam;
	
	var kbBseId = kbParam["bindKBBaseID"];
	var titleCode = kbParam["titleCode"];
	var diseaseID = kbParam["diseaseID"];
	if (diseaseID==undefined){ var diseaseID=""};
	if ($("#dispalyAll").attr("checked") == "checked")
	{
		titleCode = "";
		diseaseID = "";
	}
	getKbLocId("ҩ����");
	getBindKBNode("EMRservice.BL.BLKBNode","GetBindKBNode",kbBseId,KbID,diseaseID,episodeID,userID,titleCode,true);

}

function getBindKBNode(className,methodName,nodeBaseID,userLocID,diseaseID,episodeID,userId,titleCode,async)
{
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
			var rootNode = $('#kbTree').tree('getRoot');
			if (rootNode)
			{
				$('#kbTree').tree('remove',rootNode.target);
			}
			//���֪ʶ��ڵ�������ı����� add by Lina 2016-11-07
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
		error : function(d) { alert("��ȡ֪ʶ��ڵ����");}
	});
}

//�޸�Ŀ¼����
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
				alert('�޸�Ŀ¼���Ƴɹ�');
			}
			else
			{
				alert('�޸�Ŀ¼����ʧ��');
			}
		},
		error : function(d) { alert("add kbTree error");}
	});	
}

//�Ҽ��˵�
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

///�۵����нڵ�
$("#collapseAll").click(function(){
	$('#kbTree').tree('collapseAll');	
})

///��ʾȫ��
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

///�����滻֪ʶ���Ҽ��˵�״̬
function setReplaceKBNodeStatus()
{	
	var isComposite = invoker.getElementContext("Composite");
	if (isComposite == "NONE")
	{
		$('#mm').menu('disableItem',$("#replaceKBNode")[0]);	
	}
	else
	{
		$('#mm').menu('enableItem',$("#replaceKBNode")[0]);
	}
}

//����Backspace������ֹ����ˢ�����˳������༭����
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

//׷��֪ʶ��ڵ�֮�󣬵���֪ʶ��ڵ��sequence
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

///��ȡҩ���ƿ���id
///dws 2017-04-26
function getKbLocId(kbLocName){
	runClassMethod("web.DHCCM.drugbrowse","getKbLocId",{"kbLocName":kbLocName},function(jsonObj){
		KbID=jsonObj;
	});
}

