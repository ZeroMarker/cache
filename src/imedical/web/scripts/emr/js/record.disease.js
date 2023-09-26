//加载病种
function GetDisease()
{
	InitDiseaseTree();
	GetDiseaseZTreeData();
}

//Desc:定义病种树
function InitDiseaseTree()
{
	$('#disease').combo({
		panelWidth: 200,
		panelHeight: 500
	});
	var combopanel = $('#disease').combo('panel');
	combopanel.panel({
		id:'combopanel'
	});
	
	var innerHTMLstr = '<div>';
	innerHTMLstr = innerHTMLstr	+ '<div style="position:absolute;top:2px;width:195px;height:45px;">';
	innerHTMLstr = innerHTMLstr	+ '<span style="float:left;vertical-align:middle;">';
	innerHTMLstr = innerHTMLstr	+ '<div>代码:<input id="diseaseCode" class="easyui-textbox" style="width:80px;height:20px;" /></div>';
	innerHTMLstr = innerHTMLstr	+ '<div>描述:<input id="diseaseDesc" class="easyui-textbox" style="width:80px;height:20px;" /></div>';
	innerHTMLstr = innerHTMLstr	+ '</span>';
	innerHTMLstr = innerHTMLstr	+ '<span style="float:right;vertical-align:middle;">';
	innerHTMLstr = innerHTMLstr	+ '<input type="button" id="diseaseSearch" value="筛选" onclick="diseaseSearch()" style="position:absolute;left:114px;top:7px;height:25px;"></input>';
	innerHTMLstr = innerHTMLstr	+ '</span>';
	innerHTMLstr = innerHTMLstr	+ '</div>';
	innerHTMLstr = innerHTMLstr	+ '<div style="position:absolute;top:45px;width:195px;height:446px;overflow:auto;border-top-style:solid;border-top-width:1px;border-top-color:#C8CAD0;"><ul id="diseasetree"></ul></div>';
	innerHTMLstr = innerHTMLstr	+ '</div>';
	document.getElementById('combopanel').innerHTML = innerHTMLstr
	
	var str = '<iframe frameborder="0" tabindex="-1" src="javascript:false;" style="display:block;position:absolute;z-index:-1;filter:Alpha(Opacity=0);opacity:0;';
	str += 'top:0px;left:0px;width:'+200+';height:'+500+';"/>';
    $("#combopanel").append(str);
}

//Desc:获取病种数据
function GetDiseaseZTreeData()
{
	jQuery.ajax({
		type : "GET",
		dataType : "text",
		url : "../EMRservice.Ajax.kbDisease.cls",
		async : true,
		data : {"EpisodeID":episodeID,"CurAction":"List","KBDiagnos":"","UserLocID":userLocID},
		success : function(d) {
			setZTreeData(eval(d));
		},
		error : function(d) {
			alert("get disease error");
		}
	});
}
//定义tree的具体形态，这里使用zTree
function setZTreeData(data)
{
	//改变全局变量的值，用来存储ZTree从后台获取的病种数据
	diseaseTreeNodesAll = data;
	$('#diseasetree').attr("class","ztree chats_ztree");
	$.fn.zTree.init($('#diseasetree'), ztSetting, data);
}

//ztree显示、回调函数、数据格式配置
var ztSetting =
{
	treeId: "diseasezTreeID",
	view :
	{
		showIcon : true
	},
	callback :
	{
		beforeClick : zTreeBeforeClick,
		onClick : zTreeOnClick,
		onNodeCreated: zTreeOnNodeCreated
	},
	data :
	{
		simpleData :
		{
			enable : false
		}
	}
};

//如果返回 false，zTree 将不会选中节点，也无法触发 onClick 事件回调函数
function zTreeBeforeClick(treeId, treeNode, clickFlag)
{
	//当是父节点 返回false 不让选取
	return !treeNode.isParent;
}

//ztree鼠标左键点击回调函数
function zTreeOnClick(event, treeId, treeNode)
{
	var node = treeNode;
	$('#disease').combo('setValue',node.attributes.rowID);
	$('#disease').combo('setText',node.name);
	$('#disease').combo("hidePanel");
	try
	{
		if (!window.frames["framRecord"]) return;
		window.frames["framRecord"].setDiseaseData();
	} catch(error) {};
}

//节点被创建之后，去判断该节点是否是病历已绑定的病种，是:下拉框选中显示该节点;否:继续下一个节点判断
function zTreeOnNodeCreated(event, treeId, treeNode) {
	if (treeNode.attributes.type == "root" && treeNode.attributes.isUsed == "1")
	{
		$('#disease').combo('setValue',treeNode.attributes.rowID);
		$('#disease').combo('setText',treeNode.name);	
	}
	else if(treeNode.attributes.type == "disease" && treeNode.attributes.isUsed == "1")
	{
		$('#disease').combo('setValue',treeNode.attributes.rowID);
		$('#disease').combo('setText',treeNode.name);
	}
	else
	{
		SetTree(treeNode);
	}
};
//选中关联诊断病种
function SetTree(treeNode)
{
	var node = treeNode;
	if (node.isParent)
	{
		var children = node.children;
		for (var j=0;j<children.length;j++)
		{
			if (children[j].attributes.type == "disease" && children[j].attributes.isUsed == "1")
			{
				$('#disease').combo('setValue',children[j].attributes.rowID);
				$('#disease').combo('setText',children[j].name);
				return;
			}
			SetTree(children[j]);
		}
	}
}

function diseaseSearch(){
	ParentNodesIDs = "";
	var treeObj = $.fn.zTree.getZTreeObj("diseasetree");
	//搜索前删除掉目前展现的所有节点，然后加载全部节点数据，保证搜索时是在全部数据上做的检索
	var allNodes = treeObj.getNodes();
	for (i=0;i<allNodes.length;)
	{
		treeObj.removeNode(allNodes[i]);
	}
	treeObj.addNodes(null, diseaseTreeNodesAll);
	
	var diseaseCodeValue = $('#diseaseCode').val();
	var diseaseCodeDesc = $('#diseaseDesc').val();
	if (diseaseCodeValue == "" && diseaseCodeDesc == "")
	{
		return;  //如果代码和描述同时为空，则显示全部数据
	}
	//获取筛选出来的节点
	var getedNodes = treeObj.getNodesByFilter(filter); // 查找节点集合

	//搜索动作完成后，删除掉目前展现的所有节点，只展现搜索结果
	var allNodesTwo = treeObj.getNodes();
	for (i=0;i<allNodesTwo.length;)
	{
		treeObj.removeNode(allNodesTwo[i]);
	}
	treeObj.addNodes(null, getedNodes);
}

//根据检索条件，得到符合条件的节点
function filter(node)
{
	var diseaseCodeValue = $('#diseaseCode').val();
	var diseaseCodeDesc = $('#diseaseDesc').val();
	//return (node.id.indexOf(diseaseCodeValue)>-1 && node.name.indexOf(diseaseCodeDesc)>-1);
	
	if (node.id.indexOf(diseaseCodeValue)>-1 && node.name.indexOf(diseaseCodeDesc)>-1 && node.id !== "0")
	{
		var ret = true;
		//如果当前节点为符合条件的父节点，保留
		if (node.isParent)
		{
			if (ParentNodesIDs == "")
			{
				ParentNodesIDs = node.id;
			}
			else
			{
				ParentNodesIDs = ParentNodesIDs + "^" + node.id;
			}
		}
		else
		{
			//如果当前节点为符合条件的叶子节点，判断其父节点是否已保留，若父节点已保留则该子节点不保留，若父节点没有保留，则该叶子节点保留
			var ParentNode = node.getParentNode();
			//有可能病种维护时，没有分组目录，只有具体病种，此情况下获取到的父节点为null，不去做判断
			if (ParentNode !== null)
			{
				var ParentNodesIDsLength = ParentNodesIDs.split("^").length;
				for (i=0;i<ParentNodesIDsLength;i++)
				{
					if (ParentNode.id == ParentNodesIDs.split("^")[i])
					{
						ret = false;
					}
				}
			}
		}
		return ret;
	}
}

//Desc:获取病种数据
function GetDiseaseTreeData()
{
	jQuery.ajax({
		type : "GET",
		dataType : "text",
		url : "../EMRservice.Ajax.kbDisease.cls",
		async : true,
		data : {"EpisodeID":episodeID,"CurAction":"List","KBDiagnos":"","UserLocID":userLocID},
		success : function(d) {
			$('#disease').combotree('loadData',eval(d));
		},
		error : function(d) {
			alert("get disease error");
		}
	});
}

//保存选择病种
function SaveDiseaseToAdmPatType(kbDiagnos)
{
    jQuery.ajax({
		type : "GET",
		dataType : "text",
		url : "../EMRservice.Ajax.kbDisease.cls",
		async : true,
		data : {"EpisodeID":episodeID,"CurAction":"Select","KBDiagnos":kbDiagnos},
		success : function(d) { if(d == "failed") alert("save disease failed") },
		error : function(d) {
			alert("save disease failed");
		}
	});
}
//光标定位到 病种文本框内 自动展开下拉树 add by niucaicai 2016-4-15
$(function(){
	$('#disease').combo("textbox").click(function(){
		$('#disease').combo("showPanel");
	})
	//定义一个全局变量，用来存储ZTree从后台获取的病种数据
	var diseaseTreeNodesAll = "";
	var ParentNodesIDs = "";
})
