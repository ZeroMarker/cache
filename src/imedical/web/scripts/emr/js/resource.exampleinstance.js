var $modelInstanceTree;
var documentContext;
var retDiagnos;
//当前模板树数据,用于查询检索
var TempData = "";
$(function () {
	
    //判断编辑器是否已初始化完毕
	if (parent.getSysMenuDoingSth() == ""){
		initInstanceTree();
	}

	var SearchBoxOnTree = NewSearchBoxOnTree();
	$('#searchBox').searchbox({
		searcher: function (value, name) {
            if (TempData == ""){
                return;
            }
            var tmpTemplateData = findTemplate(TempData, value);
            $modelInstanceTree.tree('loadData',tmpTemplateData);
			SearchBoxOnTree.Search($modelInstanceTree, value, function (node, searchCon) {
				return (node.text.indexOf(searchCon) >= 0) || (node.attributes.py.indexOf(searchCon.toUpperCase()) >= 0);
			});
		},
		prompt: '请输入查询关键字'
	});
	$('#exampleInstance').layout('panel','north').panel('resize',{width:parent.$('#dataTabs').width()});
	$('#searchPnl').panel('resize',{width:$('#exampleInstance').layout('panel','north').width()-6});
	$('#exampleInstance').layout('resize');
	$('#searchPnl').panel({
		onResize: function (width, height) {
			$('#searchBox').searchbox('resize', width - 6);
		}
	});
	$('#searchBox').searchbox('resize', $('#searchPnl').width() - 6);	

	$(document).on("click","#sections li",function(){

        $(this).siblings('li').removeClass('selected');  
        $(this).addClass('selected');  
        var exampleId = $("#sections ul").attr("id"); 
        var nodeId = $(this).find("a input").attr("id");                       
		//getSectionText(exampleId,nodeId);
    });
});

///设置目录权限
function onContextMenu(e, node) {
	e.preventDefault();
	var node = $modelInstanceTree.tree('getSelected');
	$('#mm').menu('disableItem', $('#newCategory')[0]);
	$('#mm').menu('disableItem', $('#toModelIns')[0]);
	$('#mm').menu('disableItem', $('#modifyit')[0]);
	$('#mm').menu('disableItem', $('#renameit')[0]);
	$('#mm').menu('disableItem', $('#removeit')[0]);
	$('#mm').menu('disableItem', $('#moveUpNode')[0]);
	$('#mm').menu('disableItem', $('#moveDownNode')[0]);
	$('#mm').menu('disableItem', $('#shareNode')[0]);
	$('#mm').menu('disableItem', $('#cancelShare')[0]);
	//根节点
	if (node.attributes.type == "root") 
	{ 
		$('#mm').menu('enableItem', $('#newCategory')[0]);
		$('#mm').menu('enableItem', $('#toModelIns')[0]);
	} 
	// 文件夹
	else if ((node.attributes.type == "category")&&(node.attributes.isShare != "1")) 
	{ 
		$('#mm').menu('enableItem', $('#newCategory')[0]);
		$('#mm').menu('enableItem', $('#toModelIns')[0]);
		$('#mm').menu('enableItem', $('#renameit')[0]);
		$('#mm').menu('enableItem', $('#removeit')[0]);
		$('#mm').menu('enableItem', $('#moveUpNode')[0]);
		$('#mm').menu('enableItem', $('#moveDownNode')[0]);
	} 
	//范例节点
	else if (node.attributes.type == "node")
	{ 
		if (node.attributes.isShare != "1")
		{
		$('#mm').menu('enableItem', $('#modifyit')[0]);
			$('#mm').menu('enableItem', $('#renameit')[0]);
			$('#mm').menu('enableItem', $('#removeit')[0]);
			$('#mm').menu('enableItem', $('#moveUpNode')[0]);
			$('#mm').menu('enableItem', $('#moveDownNode')[0]);
			$('#mm').menu('enableItem', $('#shareNode')[0]);
		}
		else
		{
			$('#mm').menu('enableItem', $('#cancelShare')[0]);
		}
	}

	$('#mm').menu('show', {
		left: e.pageX,
		top: e.pageY
	});
}
//根据value筛选病历模板树
function findTemplate(data,value)
{
    var result = new Array();
    for (var i = 0; i < data.length; i++) 
    { 
        if ((data[i].children)&&(data[i].children.length >0))
        {
            var child = findTemplate(data[i].children,value)
            if ((child != "")&&(child.length >0))
            {
                var tmp = JSON.parse(JSON.stringify(data[i]));
                tmp.children = [];
                tmp.children = child;
                result.push(tmp);
            }
        }
        else
        {
            if (data[i].text.indexOf(value)!=-1) {
                result.push(data[i]);
            }
        }
    }
    return result;
}
function initTree(userId,instanceId)
{
    jQuery.ajax({
        type: 'GET',
        dataType: 'text',
        url: '../EMRservice.Ajax.common.cls',
        async: true,
        cache: false,
        data: {
            "OutputType":"Stream",
            "Class":"EMRservice.BL.BLExampleInstance",
            "Method":"GetDataTree",
            "p1":userId,
            "p2":instanceId,
            "p3":userLocID
        },
        success: function (d) {
            if (d != ""){
                TempData = jQuery.parseJSON(d);
                initModelInstanceTree(TempData);
            }
        },
        error : function(d) {
            alert("GetDataTree error");
        }
    });
}
function initModelInstanceTree(treeData){
	$modelInstanceTree.tree({
		dnd: true,
		lines:true,
		data : treeData,
		formatter: function (node) {
			var s = node.text;
			if (node.children) {
				s += '&nbsp;<span style="color:blue">(' + node.children.length + ')</span>';
			}
			return s;
		},
		onDblClick: function (node) {
			if ($(this).tree('isLeaf', node.target)) 
			{
				if (node.attributes.type != "node") return;
				if(checkFlag==="N"){
					$(".tree").css("display","none");
					$(".select").css("display","block");
				}
				getExampleSections(node)
			}
		},
		onContextMenu: function (e, node) {
			$(this).tree('select', node.target);
			onContextMenu(e, node);				
		},
        onBeforeDrag: function (node) {
            //根节点、共享目录没有拖拽功能
            if ((node.attributes.type == "root")||("1" == node.attributes.isShare)) return false;
        },
        onDrop: function (targetNode, source, point) {
            var tNode = $modelInstanceTree.tree('getNode', targetNode);
            var sNode = source;
            var action;
            if (isCategory(sNode)) {
                action = 'MoveCategory';
            } else {
                action = 'MoveNode';
            }
            var isBottom = 1;
            if (point == 'top' || point == 'bottom') {
                var parentNode = $modelInstanceTree.tree('getParent', tNode.target);
                if (tNode.attributes.type == "root") parentNode = tNode;
                if (point == 'top') {
                    isBottom = 0;
                }
                if (forbidMove(tNode, sNode)) {
                    getTreeData();
                    return;
                }
                moveit(action, parentNode, sNode, isBottom, tNode);
            } else { //'append'
                if (!isCategory(tNode)) {
                    alert('不可放至范例病历下级');
                    getTreeData();
                    return;
                }
                moveit(action, tNode, sNode, 1, '');
            }
        }
	}).tree('expandAll');		
}

function isCategory(node) {
    return ('category' == node.attributes.type);
}

function forbidMove(tNode, sNode) {
    if (isCategory(tNode) && !isCategory(sNode)) {
        return true;
    }
    if (!isCategory(tNode) && isCategory(sNode)) {
        return true;
    }
    return false;
}

function moveit(action, parentNode, curNode, isBottom, siblingNode) {
    var siblingNodeId = '';
    if ('' != siblingNode) {
        siblingNodeId = siblingNode.id;
    }

    jQuery.ajax({
        type: "post",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: true,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLExampleInstance",
            "Method":action,
            "p1":parentNode.id,
            "p2":curNode.id,
            "p3":isBottom,
            "p4":siblingNodeId,
            "p5":userID
        },
        success: function(d){
            if ('1' == d) {
                getTreeData();
            }
        },
        error: function (d) {alert(action + ' error!');}
    });
}

function getTreeData() {
    jQuery.ajax({
        type: "post",
        dataType: "json", //"text",
        url: "../EMRservice.Ajax.common.cls",
        async: true,
        data: {
            "OutputType":"Stream",
            "Class":"EMRservice.BL.BLExampleInstance",
            "Method":"GetDataTree",
            "p1":userID,
            "p2":documentContext.InstanceID,
            "p3":userLocID
        },
        success: function(d){
            $modelInstanceTree.tree({
                data: d
            }).tree('expandAll');
        },
        error: function(d) {alert("get Tree Data error!");}
    });
}

//工具栏
function initContextMenu()
{
	//给范例病历命名时 屏蔽特殊字符
	$('#newName').live('input', function () {
		checkNewname();
	});
	
	document.getElementById("newCategory").onclick = function(){
		var node = $modelInstanceTree.tree('getSelected');
		if (node) 
		{
			$('#newName').val(node.text);
			showNameDlg(newCategory);
		}
	}
	document.getElementById("toModelIns").onclick = function(){
		getDiagnos();
		var node = $modelInstanceTree.tree('getSelected');
		if (node) 
		{
			
			documentContext=documentGet();
			var modifyparam = {
				"action":"CHECK_DOCUMENT_MODIFY",
				"args":{
					"InstanceID":documentContext.InstanceID,
					"isSync":true
				}
			};
			var modifyResult = parent.eventDispatch(modifyparam);
			if (typeof documentContext === "undefined" || documentContext.status.curStatus === "" || modifyResult.Modified === "True") {
				alert("请先保存当前病历后，再创建！");
				return;
			}
			showNameDlg(saveExample);
		}
	}
	document.getElementById("modifyit").onclick = function(){
		var node = $modelInstanceTree.tree('getSelected');
		if (node) {
			var returnValues = window.showModalDialog('emr.record.edit.exampleinstance.csp', node, 'dialogHeight:765px;dialogWidth:1360px;resizable:yes;center:yes;minimize:yes;maximize:yes;');
		}
	}
	document.getElementById("shareNode").onclick = function(){
		ShareNode();
	}
	document.getElementById("cancelShare").onclick = function(){
		CancelShareNode();
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
	document.getElementById("moveUpNode").onclick = function(){
		getPrev(getCurr());
		
	}
	document.getElementById("moveDownNode").onclick = function(){
		getNext(getCurr());
	}	
}

function showNameDlg(fnOnComfirmed) {
	$('#dlg').dialog({
		buttons: [{
				text: '确认',
				handler: function () {
					if(!checkNewname())return;						
					var newName = $('#newName').val();
					if ('' == newName)
						return;
					if (typeof (fnOnComfirmed) === 'function') {
						fnOnComfirmed(newName);
					}
					return false;
				}
			}, {
				text: '取消',
				handler: function () {
					$('#dlg').dialog('close');
					return false;
				}
			}
		]
	}).dialog('open');	
}
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
		$.messager.show({
			msg:'不允许输入特殊字符',
			timeout:2000,
			showType:'slide'
		});
		return false;
	}else{
		return true;
	}
}
$("#lbSectionSure").click(function(){
	var exampleId = $("#sections ul").attr("id");
	replaceSections(exampleId);
	$(".tree").css("display","block");
	$(".select").css("display","none");
});

$("#lbSectionCancel").click(function(){
	$(".tree").css("display","block");
	$(".select").css("display","none");
});



//增加树节点
function appendTreeNode(parentNode,data) 
{
	$modelInstanceTree.tree('append', {
		parent: parentNode.target,
		data:data
	})
}
///获取诊断
function getDiagnos(){
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.HISInterface.PatientInfoAssist",
			"Method":"DiagnosInfo",
			"p1":episodeID
			},
			success:function(d){	
				if(d!=""){
					 retDiagnos=d;
					 $('#newName').val(retDiagnos);
					}
					
			},
			error: function(d) {alert("error");}
	});	
			
	
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
			"Class":"EMRservice.BL.BLExampleInstance",
			"Method":"AddCategory",
			"p1":userID,
			"p2":parentId,
			"p3":name
		},
		success: function(d){
			if (d != "")
			{
				var childData = [{
					id: d,
					text: name,
					iconCls:"user-folder-open",
					children: [],
					attributes: {
							type: 'category'
						}				
					}]
				appendTreeNode(node,childData);
				$('#dlg').dialog('close');
			}
		},
		error: function(d) {alert("error");}
	});		
}

///保存范例
function saveExample(name)
{
	var node = $modelInstanceTree.tree('getSelected');
	var parentId = '0';
	if (node.attributes.type == "category") parentId = node.id;
	var param = {
		"action":"SAVE_SECTION",
		"args":{
			"CategoryID":parentId,
			"UserID":userID,
			"Name":name,
			"isSync":true
		}
	};
	var ret = parent.eventDispatch(param); 
	if (ret.result === 'OK' && ret.params.result === 'OK') 
	{
		$modelInstanceTree.tree('reload');
	}
	else
	{
		alert('保存失败!','info');
	}
	$('#dlg').dialog('close');
}
//用范例创建病历
function getExampleSections(node)
{
	var exampleId = node.id;
    jQuery.ajax({
		type: "post",
		dataType: "json",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLExampleInstance",
			"Method":"GetSectionData",
			"p1":exampleId
		},
		success: function(d){
			$("#sections").empty();
			var ul = $('<ul id="'+exampleId+'"></ul>');
			
			if (d&&d != "")
			{
				if(checkFlag==="Y"){	
					clickInsert(d,exampleId);	
				}else{
					getCheckPage(d,ul);
				}
			}
		},
		error: function(d) {alert("error");}
	}); 
	return node
}
function clickInsert(d,exampleId){
	var CheckCode = [];
	var flag = true;
	for (var i = 0; i < d.length; i++) {
		flag = true;
		for (var j = 0, len = choiceArr.length; j < len; j++) {
		  optionName = choiceArr[j].replace(/\s*/g, "");
		  sectionName = d[i].text.replace(/\s*/g, "");
		  if (sectionName.match(optionName)) {
			flag = false;
		    break;
		  } 
		}
		if(flag){
			CheckCode.push(d[i].attributes.sectionCode);
		}
	}
	replaceSections(exampleId, CheckCode);
}
function getCheckPage(d,ul){
	var checkCode=[];
	for (var i=0;i < d.length; i++)
	{
		//判断d[i].text是否存在,如果存在就不渲染dom
		var showflag = true,optionName,sectionName;
		if(hiddenArr.length>0){
			for(var k = 0,lenk =hiddenArr.length;k<lenk;k++ ){
				optionName = hiddenArr[k].replace(/\s*/g,"");
				sectionName = d[i].text.replace(/\s*/g,"");
				if(sectionName.match(optionName)){
					showflag=false;
					break;
					}
				}
			}
		if(!showflag) continue;
		var checkbox = "<li><a href='#'><input type='checkbox' name='section' id='"+d[i].attributes.sectionCode+"'> "+ d[i].text+"</a></li>";	
		$(ul).append(checkbox);
		if(choiceArr.length>0)
		{
			for(var j = 0,len=choiceArr.length; j <len ; j++)
			 {
				optionName = choiceArr[j].replace(/\s*/g,"");
				sectionName = d[i].text.replace(/\s*/g,"");
				if(sectionName.match(optionName)){
					checkCode.push( d[i].attributes.sectionCode);
					}
			 }	
		}
	}
	$("#sections").append(ul);
	if(choiceArr.length===0){
		//不配置默认全选
		$("input:checkbox").attr("checked","true");
	}else if(checkCode&&checkCode.length>0)
	{
		$("input:checkbox").attr("checked","true");
		for(var i = 0; i < checkCode.length; i++)
		{
			$("#"+checkCode[i]).attr("checked",false);
		}
	}
}
function getSectionText(exampleId,sectionCode)
{
	$("#sectiontext").empty();
    jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLExampleInstance",
			"Method":"GetSectionText",
			"p1":exampleId,
			"p2":sectionCode
		},
		success: function(d){
			
			$("#sectiontext").text(d);
		}
    });	
}

$("#selectchkbx").on("change",function () {
	if ($("#selectchkbx").is(":checked"))
	{
		$("input[name='section']").attr("checked","true"); 
	}
	else
	{
		$("input[name='section']").removeAttr("checked");
	}
});

//替换章节
function replaceSections(exampleId,CheckCode)
{
	if(insertControl() === false) return;
	var param ={
		"action":"INSERT_SECTION",
		"args":	{
			"actionType":"Replace",
			"params":{
			"ExampleInstanceID":exampleId,
			"SectionList":[]}
		}
	};
	if(CheckCode&&checkFlag==="Y"){
		for (var i = 0; i < CheckCode.length; i++) {
    		param.args.params.SectionList.push({ Code: CheckCode[i] });
  		}
	}else if(checkFlag==="N"){
	 	$.each($("input[name='section']:checked"),function(){
	 		param.args.params.SectionList.push({"Code":$(this).context.id});
		});
	}else{
		$.messager.alert("error","未知错误","error");
		return;	
	}	
	var ret = parent.eventDispatch(param);
	return;
}

//创建病历
function createDocument(node)
{
	var exampleId = node.id;
	var param ={
		"action":"CREATE_DOCUMENT_BY_INSTANCE",
		"args":{
			"CreateMode":"ReplaceSection",
	        "exampleId":exampleId,
	       	"pluginType":node.attributes.documentType,
			"chartItemType":node.attributes.chartItemType,
			"emrDocId":node.attributes.emrdocId,
			"templateId":node.attributes.templateId,
			"isLeadframe":node.attributes.docCharacteristic,
			"isMutex":"",
			"categoryId":node.attributes.emrcategoryId,
			"actionType":"CREATEBYEXAMPLE",
			"status":"NORMAL",
			"closable":true,
	        "sectionList":[]
		}
    };
        
	$.each($("input[name='section']:checked"),function(){
		 param.args.sectionList.push({"Code":$(this).context.id});
	})	
	var ret = parent.eventDispatch(param);
}

///分享范例节点
function ShareNode()
{
	var node = $modelInstanceTree.tree('getSelected');
	if (node.attributes.type != "node") return;
	if (!confirm('确定分享【' + node.text + '】范例到本科室?')) return;
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLExampleInstance",
			"Method":"ShareNode",
			"p1":node.id,
			"p2":userID,
			"p3":userLocID
		},
		success: function(d){
			if (d == '1') 
			{
				alert('分享成功');	
				initInstanceTree();	
			} 
			else if (d == '-1')
			{
				alert('此范例已被分享过');	
			}
			else 
			{
				alert('分享失败');
			}
		
		},
		error: function(d) {alert("error");}
	});	
	
}

///取消分享范例节点
function CancelShareNode()
{
	var node = $modelInstanceTree.tree('getSelected');
	if (node.attributes.type != "node") return;
	if (node.attributes.shareUser != userID)
	{
		alert("只能取消本人分享的范例病历");
		return;
	}
	if (!confirm('确定取消分享【' + node.text + '】范例?')) return;
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLExampleInstance",
			"Method":"CancelShareNode",
			"p1":node.id,
			"p2":userID,
			"p3":userLocID
		},
		success: function(d){
			if (d == '1') 
			{
				initInstanceTree();		
				alert('取消分享成功');		
			} 
			else 
			{
				alert('取消分享失败');
			}
		
		},
		error: function(d) {alert("error");}
	});	
	
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
			"Class":"EMRservice.BL.BLExampleInstance",
			"Method":"ReName",
			"p1":id,
			"p2":newName,
			"p3":action
		},
		success: function(d){
			if (d != '') 
			{
				node.text = newName;
				node.attributes.py = d;
				$modelInstanceTree.tree('update', node);
				$('#dlg').dialog('close');
			} 
			else 
			{
				alert('重命名失败');
			}
		
		},
		error: function(d) {alert("error");}
	}); 	
}

///删除节点
function Delete()
{
	var node = $modelInstanceTree.tree('getSelected');
	if ($modelInstanceTree.tree('getChildren', node.target).length > 0) 
	{
		alert('存在下级节点，不允许删除');
		return;
	}
    if (node.attributes.type == "root") return;
	if (!confirm('确定删除【' + node.text + '】?')) return;
	var action = node.attributes.type ;
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLExampleInstance",
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
				alert('删除失败');
			}
		
		},
		error: function(d) {alert("error");}
	});	
	
}
///交换节点排序
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
			"Class":"EMRservice.BL.BLExampleInstance",
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

function getCurr(){
    var n = $modelInstanceTree.find('.tree-node-hover');
    if (!n.length){
        n = $modelInstanceTree.find('.tree-node-selected');
    }
    return n;
}

//////下移(同级别)
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
		{
			alert("移动失败");
		}
	}
	else
	{
		alert("不能下移");
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
		{
			alert("移动失败");
		}
	}
	else
	{
		alert("不能上移");
	}
}

function initInstanceTree()
{
	documentContext = documentGet();
	$modelInstanceTree = $('#modelInstanceTree');
	initTree(userID,documentContext.InstanceID);
	initContextMenu();
}
 function documentGet() {
	var param = {"action":"GET_DOCUMENT_CONTEXT"};
	Context = parent.eventDispatch(param);
	return Context;
	}
 function insertControl(){
	var flag;
	var documentStatus = checkDocumentStatus();
	if(documentStatus.editEnable==true)
		{
			if(documentStatus.statusText!=""){
				var msgText = '病历状态:【' + documentStatus.statusText + '】，是否覆盖当前章节？';
    	 		flag = confirm(msgText);
			}else
			{
				flag = true;	
			}
    	}else
    	{
	    	var msgText = '病历状态:【' + documentStatus.statusText + '】，不允许引入';
	    	alert(msgText);
    		flag = false;
    	}
	return flag;
	}
/**未保存状态下引入不提示,直接判断是否有保存的权限，保存状态（finished）是提示是否覆盖，签名[有保存权限的]同样，所以不做区分
【操作权限：if($$HasValidSign$$){set save=0}】
*/
function checkDocumentStatus(){
	var documentStatus={};
	var context = documentGet();
	if ((context.status.curStatus === "")||(context.status.curStatus === "unfinished"))
	{
			documentStatus.editEnable = true;
			documentStatus.statusText = "";
			return documentStatus;
		}else
		{
			documentStatus.editEnable = context.privelege.canSave==1?true:false; 
			documentStatus.statusText = context.status.curStatusDesc;//状态描述
			}
	return documentStatus;
	}
	
