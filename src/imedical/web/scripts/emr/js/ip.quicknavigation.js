///////////////////////////////导航操作////////////////////////////////////////////////////
function initquickNav()
{
    $('#quicknav').keywords({
        singleSelect:true,
        labelCls:'red',
        items:[
            {text:emrTrans('病历目录'),id:'navList'},
            {text:emrTrans('已删病历'),id:'navDelete'}
        ],
        onClick:function(v){
            toggleNav(v.id);
        }
    });	
    $("#quicknav").keywords("select","navList");
        
    var displayConfig = getUserConfigData(userID,userLocID,"RecordType");
    displayConfig = displayConfig || EditRecordDisplayType;
    $HUI.radio("[name='NavType']",{
        onChecked:function(e,value){
            var type = $(e.target).attr("value");
            var recordtype = $("#quicknav").keywords("getSelected");
            if (recordtype[0].id == "navList")
            {
                if (type == "Tree")
                {
                    getTreeRecord("");
                }
                else
                {
                    getListRecord("");
                }
            }
            else
            {
                initDeleteRecord(type);
            }
        }
    });
    
    if (displayConfig.toUpperCase() == "TREE")
    {
        $HUI.radio("#Tree").setValue(true);
    }
    else
    {
        $HUI.radio("#List").setValue(true);
    }
    
    $('#InstanceTree,#deleteTree').on('mouseenter', 'li', function() {
        $(this).find('#dot').addClass("hoverdot");
    });
    $('#InstanceTree,#deleteTree').on('mouseleave', 'li', function() {
       $(this).find('#dot').removeClass("hoverdot");
    });    
}

///切换页签
function toggleNav(tabId)
{
    if (tabId == "navList")
    {
        $("#recordlist").css("display","block");
        $("#deletelist").css("display","none");
        initListRecord();
    }
    else
    {
        $("#recordlist").css("display","none");
        $("#deletelist").css("display","block");
        initDeleteRecord();
    }
}
//加载目录////////////////////////////////////////////////////////

function initListRecord()
{
    var checked = $("input[name='NavType']:checked");
    
    var type = checked.val() || "";
    if (type == "") {
        type = getUserConfigData(userID,userLocID,"RecordType");
        type = type || EditRecordDisplayType;
    }
    if (type.toUpperCase() == "TREE")
    {
        getTreeRecord("");
    }
    else
    {
        getListRecord("");
    }
}
///按列表加载取数据
function getListRecord(instanceId)
{
	var data = { 
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLClientCategory",
			"Method":"GetRecordCatalogByHappenDate",
			"p1":episodeID,
			"p2":"save",
			"p3":"List",
			"p4":"",
			"p5":docID,
			"p6":recordShowType	
		};
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: data,
		success: function(d) {
			setRecordList(eval("["+d+"]"),instanceId);
		},
		error : function(d) { alert("GetInstance error");}
	});		
}

//加载目录
function setRecordList(data,instanceId)
{
    $('#InstanceTree').empty();
    $('#InstanceTree').addClass('instance-item');
    $('#InstanceTree').append('<div class="head"></div>');
    for (var i=0;i<data.length;i++)
    {
        $('#InstanceTree').append(setlistdata(data[i]));
    }
    $('#InstanceTree').append('<div class="foot"></div>');
    if (instanceId != "")
    {
        selectListRecord(instanceId);
    }
}

//按分类加载目录
function getTreeRecord(instanceId)
{
	$('#InstanceTree').empty();
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLClientCategory",
			"Method":"GetInstanceByCategory",
			"p1":userLocID,
			"p2":ssgroupID,
			"p3":episodeID,
			"p4":"Tree",
			"p5":"",
			"p6":"Save",
			"p7":docID,
			"p8":recordShowType				
		},
		success: function(d) {
			setTreeData(eval("["+d+"]"),instanceId);
		},
		error : function(d) { alert("GetInstanceJson error");}
	});	
	
}
//用tree方法加载目录
function setTreeData(data,instanceId)
{
    $('#InstanceTree').removeClass("instance-item");
    $('#InstanceTree').tree({  
        lines:true,
        data:data,
        onSelect:function(node){
           opendDocument(node,"NORMAL","Tree");
        },
        formatter:function(node){
            if (node.children){
                return node.text;
            }else{
                var print = "<span class='treeleft'><span class='printed'></span>";
                if (node.attributes.printstatus != "")
                {
                    print = "<span class='treeleft'><span class='printed'>"+emrTrans(node.attributes.printstatus)+"</span>";
                }
                else if (IsHasPrinted(node.id) != "0")
                {
                    print = "<span class='treeleft' style='width:90px;'><span class='printed'>"+emrTrans("打印后修改")+"</span>";
                }
                return "<div data-id='"+node.id+"'>"
                    +print+"<span type='image' class='treelog' onclick='showTreeLog("+'"'+node.id+'","#InstanceTree")'+"'/></span>"
                    +"<div class='treedate'>"+node.attributes.happendate+" "+node.attributes.happentime+"</div>"
                    +"<div class='treetitle'>"+node.attributes.specialtext+"</div>"
                    +"</div>";
                return string
            }
            
        },
        lines:true,autoNodeHeight:true	 
    });
}
///List类型打开病历
$(document).on('click',"#InstanceTree.instance-item li",function(){
    opendDocument($(this),"NORMAL","List");
});

//新增或修改病历目录列表
function modifyInstanceTree(commandJson)
{
    var checked = $("input[name='NavType']:checked");
    if (checked.val()== "Tree")
    {
        modifyZTreeRecord(commandJson);
    }
    else
    {
        modifyListRecord(commandJson);
    }	
}

///增加或修改病历列表导航条数据
function modifyListRecord(commandJson)
{
    var instanceId = commandJson.InstanceID;	
    if (instanceId == "GuideDocument") return;
    if ((commandJson.status.createDateCache != commandJson.status.happenDateCache)||(Math.abs(commandJson.status.createTimeCache - commandJson.status.happenTimeCache) > 120))
    {
        getListRecord(instanceId);
        return;
    }
    var creator = commandJson.status.Creator;
    var operator = commandJson.status.Operator;
    var happendate = commandJson.status.HappenDate;
    var happentime = commandJson.status.HappenTime; 
    var statusCode = commandJson.status.curStatus;
    var status = commandJson.status.curStatusDesc;
    var text = commandJson["Title"]["NewDisplayName"];
    var formatHappenDate=getHISDateTimeFormate("Date",happendate)
    var formatHappenTime=getHISDateTimeFormate("Time",happentime)

    var data ={
        "id":instanceId,
        "text":text,
        "isLeadframe":param.isLeadframe,
        "chartItemType":param.chartItemType,
        "documentType":param.pluginType,
        "emrDocId":param.emrDocId,
        "isMutex":param.isMutex,
        "categoryId":param.categoryId,
        "templateId":param.templateId,
        "characteristic":param.characteristic,
        "itemTitle":param.itemTitle,
        "happendate":formatHappenDate,
        "happentime":formatHappenTime,
        "creator":creator,
        "operator":operator,
        "statusCode":statusCode,
        "status":status,
        "printstatus":""
    }
    var li = setlistdata(data);
    var data = document.getElementById(instanceId);
    if (data)
    {
        data.innerHTML = li[0].innerHTML;
    }
    else
    {
        $("#InstanceTree .foot").before(li);
    }	
}

function modifyZTreeRecord(commandJson)
{
    //修改病历目录分类列表
    var instanceId = commandJson.InstanceID;	
    if (instanceId == "GuideDocument") return;
    if ((commandJson.status.createDateCache != commandJson.status.happenDateCache)||(Math.abs(commandJson.status.createTimeCache - commandJson.status.happenTimeCache) > 120))
    {
        getTreeRecord(instanceId);
        return;
    }	
    var creator = commandJson.status.Creator;
    var happendate = commandJson.status.HappenDate;
    var happentime = commandJson.status.HappenTime;
    var status = commandJson.status.curStatusDesc;
    var name = commandJson["Title"]["NewDisplayName"];
    var node = $('#InstanceTree').tree('find',instanceId);
    var specialtext = name+" "+creator+" "+status;
    
    var formatHappenDate = getHISDateTimeFormate("Date",happendate)
    var formatHappenTime = getHISDateTimeFormate("Time",happentime)
    
    
    var text = name;			
    if (node != null) 
    {
        var attributes = node.attributes;
        //更新病历状态显示内容specialtext,其他的不做更新，时间日期用户名均为创建时的
        attributes.status = status;
		attributes.specialtext = specialtext;
        attributes.printstatus = "";
        $('#InstanceTree').tree('update', {
            target: node.target,
            text: text,
            "attributes":attributes
        });	
    }
    else
    {
        var newNode = {
            "id":instanceId,
            "text":text,
            "attributes":{
                "chartItemType":param.chartItemType,
                "documentType":param.pluginType,
                "specialtext":specialtext,
                "categoryId":param.categoryId,
                "emrDocId":param.emrDocId,
                "emrNum":instanceId.substr(instanceId.indexOf("||")+2),
                "templateId":param.templateId,
                "isLeadframe":param.isLeadframe,
                "isMutex":param.isMutex,
                "happendate":formatHappenDate,
                "happentime":formatHappenTime,
				"characteristic":param.characteristic,
				"printstatus":""
            }
        }
        var parentNode = null;
		parentNode = $('#InstanceTree').tree("find", param.categoryId);
		if (parentNode == null)
		{ 
		//同时添加病历目录和病历实例节点
		var tempArry = instanceId.split("||");
		var recordId = tempArry[0];
		var subId = tempArry[1];
		var instanceJson = getInstanceJsonByID(recordId,subId,'ZTree');
		$('#InstanceTree').tree('append', {
		    parent: null,
		    data:[{
				id:param.categoryId,
				text:instanceJson[0].attributes.categoryName,
				children:[newNode]
				}]
		});	
		}else{
			$('#InstanceTree').tree('append', {
			parent: parentNode.target,
			data:[newNode]
			})
		}
    }	
}
function getInstanceJsonByID(recordId,subId,type)
{
	var retvalue = ""
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLClientCategory",
			"Method":"GetInstanceJsonByID",
			"p1":recordId,
			"p2":subId,
			"p3":type
		},
		success: function(d) 
		{
			if (d != "") 
			{
				retvalue = eval("["+d+"]");
			}
		},
		error : function() 
		{ 
			retvalue = value;
		}

	});	
	return retvalue;
	
}
function getHISDateTimeFormate(valuetype,value)
{
    var retvalue = ""
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.Tools.Tool",
            "Method":"GetHISStandardDateTimeFormat",
            "p1":"ChangeToFormat",
            "p2":valuetype,
            "p3":value
        },
        success: function(d) 
        {
            if (d != "") 
            {
                retvalue = d;
            }
        },
        error : function() 
        { 
            retvalue = value;
        }

    });	
    return retvalue;
    
}

function setPrinted(id)
{
    var checked = $("input[name='NavType']:checked");
    if (checked.val()== "Tree")
    {
        setTreePrinted(id);
    }
    else
    {
        setListPrinted(id);
    }	
}

//修改病历操作记录明细的显示颜色
function setListPrinted(ids)
{
    var printArray = ids.split(",");
    $.each(printArray,function(idx, id){
        var li = $("#InstanceTree li[id='"+id+"']");
        $(li).find(".fleft").css({width:67});
        $(li).find(".fleft .printed").html(emrTrans("医生打印"));
    });
}

function setTreePrinted(ids)
{
    var printArray = ids.split(",");
    $.each(printArray,function(idx, id){
        var node = $("#InstanceTree").tree('find',id);
        var attributes = node.attributes;
        attributes.printstatus = "print";
        $(node.target).find(".treeleft").css({width:66});
        $('#InstanceTree').tree('update', {
                target: node.target,
                "attributes":attributes
        });
    });
}

///删除病历///////////////////////////////////////////////////////////
function deleteTreeItem(instanceId,treeId)
{
    var result = "";
    var checked = $("input[name='NavType']:checked");
    if (checked.val() == "Tree")
    {
        result = deleteZTreeRecord(instanceId);
    }
    else
    {
        result = deleteListRecord(instanceId,treeId);
        $(result).find("#operator").html(userName); 
        $(result).find("#status").html("已删除");
        $(result).find("#status").removeClass("green");
        $(result).find("#status").addClass("blue");
    }
     return result;		
}

///删除列表病历
function deleteListRecord(instanceId,treeId)
{
    var result = "";
    $('#'+treeId+' li').each(function(){
        if ($(this).attr('id')==instanceId)
        {
            $(this).remove(); 
            result = $(this);
            return false;	
        }
     });
     return result;	
}
///删除Tree病历
function deleteZTreeRecord(instanceId)
{
    var node = $('#InstanceTree').tree('find',instanceId);
    $('#InstanceTree').tree('remove',node.target);
}
function initDeleteRecord()
{
    var checked = $("input[name='NavType']:checked");
    if (checked.val() == "Tree")
    {
        getDeleteTree();
    }
    else
    {
        getDeleteList();
    }
}
///取回收站病历
function getDeleteList()
{
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: true,
        data: {
            "OutputType":"Stream",
            "Class":"EMRservice.BL.BLClientCategory",
            "Method":"GetRecordCatalogByHappenDate",
            "p1":episodeID,
            "p2":"delete",
            "p3":"List"
        },
        success: function(d) 
        {
            if (d == "") return;
            setDeleteRecord(eval("["+d+"]"));
        },
        error : function(d) { 
            alert("GetDeleteData error");
        }
    });		
}

function getDeleteTree()
{
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType":"Stream",
            "Class":"EMRservice.BL.BLClientCategory",
            "Method":"GetInstanceByCategory",
            "p1":userLocID,
            "p2":ssgroupID,
            "p3":episodeID,
            "p4":"Tree",
            "p5":"",
            "p6":"Delete"				
        },
        success: function(d) {
            setDeleteTree(eval("["+d+"]"));
        },
        error : function(d) { alert("getDeleteTree error");}
    });		
}

///加载回收站病历
function setDeleteRecord(data)
{
    $('#deleteTree').empty();
    $('#deleteTree').addClass('instance-item');
    $('#deleteTree').append('<div class="head"></div>');
    for (var i=0;i<data.length;i++)
    {
        $('#deleteTree').append(setlistdata(data[i]));
    }	
    $('#deleteTree').append('<div class="foot"></div>');
}

///回收站tree
function setDeleteTree(data)
{
    $('#deleteTree').empty();
    $('#deleteTree').removeClass("instance-item");
    $('#deleteTree').tree({  
        lines:true,
        data:data,
        onSelect:function(node){
           opendDocument(node,"DELETE","Tree");
        },
        formatter:function(node){
            if (node.children){
                return node.text;
            }else{
                var print = "<span class='treeleft'><span class='printed'></span>";
                if (node.attributes.printstatus != "")
                {
                    print = "<span class='treeleft'><span class='printed'>"+emrTrans(node.attributes.printstatus)+"</span>";
                }
                else if (IsHasPrinted(node.id) != "0")
                {
                    print = "<span class='treeleft' style='width:90px;'><span class='printed'>"+emrTrans("打印后修改")+"</span>";
                }
                return "<div data-id='"+node.id+"'>"
                    +print+"<span type='image' class='treelog' onclick='showTreeLog("+'"'+node.id+'","#deleteTree")'+"'/></span>"
                    +"<div class='treedate'>"+node.attributes.happendate+" "+node.attributes.happentime+"</div>"
                    +"<div class='treetitle'>"+node.attributes.specialtext+"</div>"
                    +"</div>";
                return string
            }
            
        },
        lines:true,autoNodeHeight:true	 
 
    });	
}

//打开删除病历
$(document).on('click',"#deleteTree li",function(){
    opendDocument($(this),"DELETE","List")
});

///加载列表样式
function setlistdata(data)
{
    var li = $('<li></li>');
    $(li).attr({"id":data.id,"text":data.text,"isLeadframe":data.isLeadframe});
    $(li).attr({"chartItemType":data.chartItemType,"documentType":data.documentType});           
    $(li).attr({"emrDocId":data.emrDocId,"isMutex":data.isMutex,"categoryId":data.categoryId});			       
    $(li).attr({"templateId":data.templateId,"characteristic":data.characteristic,"emrNum":data.emrNum});
    $(li).attr({"itemTitle":data.itemTitle});
    $(li).append('<div id="dot" class="left"></div>')
    var right = $('<a href="#" class="right"></a>');
    var first = $('<div class="first"></div>');
    $(first).append('<div class="title">'+data.text+'</div>');
    var fleft = $('<div class="fleft"></div>');
    var print = "";
    if (data.printstatus != "")
    {
        print = emrTrans(data.printstatus);
    }
    else if (IsHasPrinted(data.id) != "0")
    {
        print = emrTrans("打印后修改");
        fleft = $('<div class="fleft" style="width:94px;"></div>');
    }
    $(fleft).append('<span class="printed">'+print+'</span>');
    $(fleft).append('<span type="image" class="log" onclick="showListLog(this)"></div>');
    $(first).append(fleft);
    $(right).append(first);
    var second = '<div class="second"><span class="data">'+data.happendate+'</span><span>'+data.happentime+'</span><span>'+data.creator+'</span></div>';
    $(right).append(second);
    var statusClass = "status green";
    if (data.statusCode != "finished") statusClass = "status blue";
    var third = '<div class="third"><span id="operator" class="operator">'+data.operator+'</span><span id="status" class="'+statusClass+'">'+data.status+'</span></div>';
    $(right).append(third);
    $(li).append(right);
    return li;
}

///判断病历是否被打印过
function IsHasPrinted(instanceId)
{
    var retvalue = "0";
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLEMRLogs",
            "Method":"RecHasAction",
            "p1":episodeID,
            "p2":instanceId,
            "p3":"print"
        },
        success: function(d) {
            if (d != "0") 
            {
                retvalue = d;
            }
        },
        error : function(d) { alert("IsHasPrinted error");}
    });
    return retvalue;
}

///打开病历
function opendDocument(obj,status,type)
{
    var tempParam = {};
    var title = "";
    if (type == "Tree")
    {
        tempParam = {
            "id":obj.id,
            "text":obj.attributes.text,
            "pluginType":obj.attributes.documentType,
            "chartItemType":obj.attributes.chartItemType,
            "emrDocId":obj.attributes.emrDocId,
            "templateId":obj.attributes.templateId,
            "isLeadframe":obj.attributes.isLeadframe,
            "characteristic":obj.attributes.characteristic,
            "isMutex":obj.attributes.isMutex,
            "categoryId":obj.attributes.categoryId,
            "actionType":"LOAD",
            "status":status
        };	
    }
    else
    {
        tempParam = {
            "id":obj.attr("id"),
            "text":obj.attr("text"),
            "pluginType":obj.attr("documentType"),
            "chartItemType":obj.attr("chartItemType"),
            "emrDocId":obj.attr("emrDocId"),
            "templateId":obj.attr("templateId"),
            "isLeadframe":obj.attr("isLeadframe"),
            "characteristic":obj.attr("characteristic"),
            "isMutex":obj.attr("isMutex"),
            "categoryId":obj.attr("categoryId"),
            "actionType":"LOAD",
            "status":status
        };
    }
    if(changeFlag) return;
	changeFlag = true;
    if(pluginType !== tempParam.pluginType)
    {
		if(isIE())	//不同类型文档切换，在chrome49需要延时处理
		{
			changeDocument(tempParam);
		}
		else
		{
			setTimeout(function(){
			    changeDocument(tempParam);
		    },2000);
		}
    }
	else
	{
		changeDocument(tempParam);		
	}
}
function changeDocument(tempParam)
{
	var breakState = canBreake();
    if (breakState == "false") return;
    InitDocument(tempParam);
    //自动记录病例操作日志
    openDocumentLog(tempParam,"EMR.Record.RecordNav.RecordDirectory.Open");
    parent.changeCurrentTitle(tempParam.text,tempParam.categoryId);
}
function isIE() { //ie?
	if (!!window.ActiveXObject || "ActiveXObject" in window)
		return true;
	else
		return false;
}
//显示病历操作记录明细
function showListLog(obj)
{
    event.stopPropagation();
    var obj = $(obj).closest("li");
    var instanceId = obj.attr("id");
    var docId = obj.attr("emrDocId");	
    var num = instanceId.split("||")[1];
    showLog(docId,num)	
}
function showTreeLog(nodeId,treeId)
{
    event.stopPropagation();
    var node =$(treeId).tree('find',nodeId);
    var docId = node.attributes.emrDocId;	
    var num = node.attributes.emrNum;
    showLog(docId,num);
}

function showLog(docId,num)
{
    var xpwidth =980;
	var xpheight = 500;
	var tempFrame = "<iframe id='iframeInstanceLog' scrolling='auto' frameborder='0' src='emr.instancelog.csp?EpisodeID="+episodeID+"&EMRDocId="+docId+"&EMRNum="+num+"' style='width:"+xpwidth+"px; height:"+xpheight+"px; display:block;'></iframe>";
	createModalDialog("dialogInstanceLog","操作日志",xpwidth+4,xpheight+40,"iframeInstanceLog",tempFrame,"","");

}

//选中文档目录
function setSelectRecordColor(instanceId)
{
    var checked = $("input[name='NavType']:checked");
    if (checked.val()== "Tree")
    {
        selectZtreeNode(instanceId);
    }
    else
    {
        selectListRecord(instanceId);
    }
}

///列表病历导航条目选中
function selectListRecord(instanceId)
{
    $('#InstanceTree.instance-item li').each(function()
    {
        if($(this).attr('id')==instanceId)
        {
            $(this).addClass("selectli");
            $(this).find('#dot').addClass("selectdot");
            $("#InstanceTree .instance-item").animate({scrollTop: $(this).position().top}, 1000); 
        }
        else
        {
            $(this).removeClass("selectli");
            $(this).find('#dot').removeClass("selectdot");
        }
     });	
}

///选中Ztree节点
function selectZtreeNode(instanceId)
{
	 $('#InstanceTree').find('.tree-node-selected').removeClass('tree-node-selected');
	 $('#InstanceTree .tree-node').each(function()
	 {
		if ((typeof($(this).find('.tree-title')[0]) != "undefined")&&(typeof($(this).find('.tree-title')[0].children) != "undefined")&&($(this).find('.tree-title')[0].children.length > 0))
		{
			if (typeof($(this).find('.tree-title')[0].children[0].dataset) != "undefined")
			{
				if ($(this).find('.tree-title')[0].children[0].dataset.id == instanceId)
				{
					$(this).addClass("tree-node-selected"); 
				}
			}
		}
	 });
}

///目录增加删除病历
function addDeleteTree(data)
{
    $('#deleteTree').append(data);  	
}

//返回所选择的病历导航列表显示样式
function GetRecordTypeValue()
{
    var value = $("input[name='NavType']:checked").val();
    return value
}