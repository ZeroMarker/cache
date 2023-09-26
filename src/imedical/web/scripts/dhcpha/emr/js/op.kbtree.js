var kbTree = new Object();
kbTree.continueID = '';

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
            }
        }
    }
});


$(function() {
    //debugger;
	
	$('#selectPnl').panel({  
		onResize:function(width, height){ 
			$('#disease').combo('resize', width-6);
			$('#searchBox').searchbox('resize', width-6);
		}   
	});	
 
    function selectNode(node) {
        $('#kbTree').tree('select', node.target);
    };

    function expandParent(node) {
        var parentNode = node;
        var t = true;
        do {
            parentNode = $('#kbTree').tree('getParent', parentNode.target); //获取此节点父节点 
            if (parentNode) { //如果存在 
                t = true;
                $('#kbTree').tree('expand', parentNode.target);
            } else {
                t = false;
            }
        } while (t);
    };

    function isMatch(txt) {
        var searchCon = $('#searchBox').searchbox('getValue');
        return txt.indexOf(searchCon) >= 0;
    }

    //查找子节点，查找到了 true， 返回false继续查找
    function searchChild(startNode) {
        var children = $('#kbTree').tree('getChildren', startNode.target);
        if (!children) return false;
        var flag = false;

        for (var j = 0; j < children.length; j++) {
            if ('' != kbTree.continueID) {
                if (kbTree.continueID == children[j].id) {
                    flag = kbTree.continueID == children[j].id;
                    continue;
                }
                if (!flag) {
                    continue;
                }
            }
            if (isMatch(children[j].text)) {
                selectNode(children[j]);
                expandParent(children[j]);
                $('#kbTree').tree('scrollTo');
                return true;
            }
        }

        return false;
    }
	
	function setContinueID(rootNode) {
		var startNode = $('#kbTree').tree('getSelected');

		if (startNode != null && startNode.id != rootNode.id) {
			kbTree.continueID = startNode.id;
		} else {
			kbTree.continueID = '';
		}		
	}

    function searchTree(value) {
        if ('' == $('#searchBox').searchbox('getValue')) return;
        var rootNode = $('#kbTree').tree('getRoot');
        if (null == rootNode) return false;

        if (searchChild(rootNode)) {
			setContinueID(rootNode);	
		}
		else {
			kbTree.continueID = '';	
	        if (searchChild(rootNode)) {
				setContinueID(rootNode);	
			}
		}
    }

    $('#searchBox').searchbox({
        searcher: function(value, name) {
            searchTree(value);
        },
        prompt: '请输入查询关键字'
    });

    $('#kbTree').tree({
        //双击节点插入知识库
        onDblClick: function(node) {
            if ($('#kbTree').tree('isLeaf', node.target)) {
                var param = {
                    "action": "appendComposite",
                    "NodeID": node.id
                }
                invoker.eventDispatch(param);
            }
        },
        onContextMenu: function(e, node) {
            treeRightClick(e, node);
        },
        onAfterEdit: function(node) {
            updateTree(node.id, node.text);
        }
    });
    //新建知识库目录节点
    $("#addKBTree").click(function() {
        var node = $('#kbTree').tree('getSelected')
        var parentID = node.id;
        var baseID = $('#kbTree').tree('getRoot').id;
        jQuery.ajax({
            type: "GET",
            dataType: "text",
            url: "../EMRservice.Ajax.kbTree.cls",
            async: true,
            data: {
                "ACTION": "CreateKBTree",
                "KnowledgeBaseID": baseID,
                "ParentID": parentID,
                "UserID": userID
            },
            success: function(d) {
                if (d != "") {
                    $('#kbTree').tree('append', {
                        parent: (node ? node.target : null),
                        data: [eval("(" + d + ")")]
                    });
                }
            },
            error: function(d) {
                alert("add kbTree error");
            }
        });
    });

    //增加知识节点
    $("#addKBNode").click(function() {
        var node = $('#kbTree').tree('getSelected')
        var treeId = node.id;
        var baseID = $('#kbTree').tree('getRoot').id;
        jQuery.ajax({
            type: "GET",
            dataType: "text",
            url: "../EMRservice.Ajax.kbTree.cls",
            async: true,
            data: {
                "ACTION": "CreateKBNode",
                "KnowledgeBaseID": baseID,
                "KBTreeID": treeId
            },
            success: function(d) {
                if (d != "") {
                    $('#kbTree').tree('append', {
                        parent: (node ? node.target : null),
                        data: [eval("(" + d + ")")]
                    });
                }
            },
            error: function(d) {
                alert("add kbnode error");
            }
        });
    });

    //编辑知识库内容
    $("#editKBNode").click(function() {
        var node = $('#kbTree').tree('getSelected');
        var array = new Array(2);
        array[0] = node;
        array[1] = {
            "Params": invoker.argConnect,
            "Key": invoker.DECRYPTKEY
        };
        var returnValues = window.showModalDialog("emr.record.edit.knowledgebase.csp", array, "dialogWidth=" + (screen.availWidth - 10) + ";dialogheight=" + (screen.availHeight - 20)+ ";resizable:yes;status:no;center:yes;minimize:yes;maximize:yes");
        if (returnValues && returnValues.NodeText) {
            $('#kbTree').tree('update', {
                target: node.target,
                text: returnValues.NodeText
            });
        }
        if (returnValues && returnValues.NodeStatus) {
            if (returnValues.NodeStatus == "N") $('#kbTree').tree('remove', node.target);
        }

    });

    $("#editTreeName").click(function() {
        var node = $('#kbTree').tree('getSelected');
        $("#kbTree").tree('beginEdit', node.target);
    });

    $('#kbTree').css('font-size', '20px');
	//debugger;
    if (invoker.emrEditor && ''!= invoker.emrEditor.kbtreeCmd) { 
        GetKBNodeByTreeID(invoker.emrEditor.kbtreeCmd); 
    }
	if (isModelDlg) { 
		window.dialogArguments.emrEditor.refreshKBFunc = GetKBNodeByTreeID;
		window.onunload = function(){
			window.dialogArguments.emrEditor.refreshKBFunc = null;
		}
	}
	
    //禁止后退键 作用于Firefox、Opera
    document.onkeypress = forbidBackSpace;
    //禁止后退键  作用于IE、Chrome
    document.onkeydown = forbidBackSpace;	
});

// op.disease.js
function setDiseaseData(_diseaseID)
{
    //diseaseID = invoker.$("#disease").combotree("getValue");
	//alert('diseaseID:'+diseaseID);
	diseaseID = _diseaseID;
    if (undefined == diseaseID) diseaseID = "";
	 
    if ($("#dispalyAll").attr("checked") == "checked") {
        titleCode = "";
        diseaseID = "";
    }
	
	getBindKBNode("EMRservice.BL.BLKBNode","GetBindKBNode",kbBseId,userLocID,diseaseID,episodeID,userID,titleCode,true);	
}

var kbBseId = '';
var titleCode = '';
var diseaseID = '';

//传入kbTree的id查找权限下的kbNode节点
function GetKBNodeByTreeID(kbParam) {
	if (!kbParam) return;
	
    kbBseId = kbParam["bindKBBaseID"];
    titleCode = kbParam["titleCode"];
	if (invoker.$("#disease").length >0) {
		diseaseID = invoker.$("#disease").combotree('getValue');
	}
    if (undefined == diseaseID) diseaseID = '';
	 
    if ($("#dispalyAll").attr("checked") == "checked") {
        titleCode = "";
        diseaseID = "";
    }		
    //alert('diseaseID:'+diseaseID);
    getBindKBNode("EMRservice.BL.BLKBNode","GetBindKBNode",kbBseId,userLocID,diseaseID,episodeID,userID,titleCode,true);
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
            if (d != "")
            {
                if (isCollapse =="1")
				{
					$('#kbTree').tree({data: [eval("("+d+")")]}).tree('expandAll');
				}
				else
				{
					$('#kbTree').tree({data: [eval("("+d+")")]}).tree();
				}
				setTimeout("invoker.collapse(false)",300);  
            }
			else
			{
				invoker.collapse(true);				
			}
			   

        },
        error : function(d) { alert("获取知识库节点错误！");}
    });
}

//修改目录名称
function updateTree(treeId, treeName) {
    jQuery.ajax({
        type: "GET",
        dataType: "text",
        url: "../EMRservice.Ajax.kbTree.cls",
        async: true,
        data: {
            "ACTION": "UpdateKBTree",
            "KBTreeID": treeId,
            "Name": treeName
        },
        success: function(d) {
            if (1==d) {
                //alert('修改目录名称成功');
            } else {
                alert('修改目录名称失败!', 'info');
            }
        },
        error: function(d) {
            alert("add kbTree error");
        }
    });
}

//右键菜单
function treeRightClick(e, node) {

    if (node.attributes.type == "KBBase") return;
    var pType = $('#kbTree').tree('getParent', node.target).attributes.type;
    if (node.attributes.type == "KBNode") {
        $('#mm').menu('disableItem', $("#addKBTree")[0]);
        $('#mm').menu('disableItem', $("#addKBNode")[0]);
        $('#mm').menu('disableItem', $("#editTreeName")[0]);
        if (isCanEdit == "Y" || (isPersonEdit == "Y" && pType == "PersonalKBTree")) {
            $('#mm').menu('enableItem', $("#editKBNode")[0]);
        } else {
            $('#mm').menu('disableItem', $("#editKBNode")[0]);
        }

    } else if (isPersonEdit == "Y" && pType == "KBBase") {
        $('#mm').menu('enableItem', $("#addKBTree")[0]);
        $('#mm').menu('disableItem', $("#addKBNode")[0]);
        $('#mm').menu('disableItem', $("#editKBNode")[0]);
        $('#mm').menu('disableItem', $("#editTreeName")[0]);
    } else if (isPersonEdit == "Y" && node.attributes.type == "PersonalKBTree") {
        var childLength = $('#kbTree').tree('getChildren', node.target).length;
        if (childLength <= 0) {
            $('#mm').menu('enableItem', $("#addKBTree")[0]);
            $('#mm').menu('enableItem', $("#addKBNode")[0]);
            $('#mm').menu('disableItem', $("#editKBNode")[0]);
        } else {
            var cType = $('#kbTree').tree('getChildren', node.target)[0].attributes.type;
            if (cType == "KBNode") {
                $('#mm').menu('disableItem', $("#addKBTree")[0]);
                $('#mm').menu('enableItem', $("#addKBNode")[0]);
                $('#mm').menu('disableItem', $("#editKBNode")[0]);
            } else {
                $('#mm').menu('enableItem', $("#addKBTree")[0]);
                $('#mm').menu('disableItem', $("#addKBNode")[0]);
                $('#mm').menu('disableItem', $("#editKBNode")[0]);
            }
        }
        $('#mm').menu('enableItem', $("#editTreeName")[0]);
    }
    e.preventDefault();
    $('#kbTree').tree('select', node.target);
    $('#mm').menu('show', {
        left: e.pageX,
        top: e.pageY
    });
}

///折叠所有节点
$("#collapseAll").click(function() {
    $('#kbTree').tree('collapseAll');
})

///显示全部
$("#dispalyAll").change(function() {
	
    var kbParam = "";
    if ($("#dispalyAll").attr("checked") == "checked") {
        kbParam = {
            "bindKBBaseID": curKbParam.bindKBBaseID,
            "titleCode": "",
            "diseaseID": ""
        };
    } else {
        kbParam = curKbParam;
    }
    GetKBNodeByTreeID(kbParam);
});
