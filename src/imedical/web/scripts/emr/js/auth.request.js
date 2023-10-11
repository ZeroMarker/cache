var actionString = '';
var actionNameString = '';



var array=""
initPrivCheckBox()

$(function(){
	$("#TextRequestReason").attr("placeholder",emrTrans("在此录入申请原因"));
	$("#searchInput").validatebox({
		placeholder:emrTrans("输入名称搜索!")
	});
    //var buttons = '申请内容<div class="hisui-layout" style="overflow:hidden;padding:5px;"><a href="#" class="hisui-linkbutton" id="selectall" data-options="iconCls:' + "'" + 'icon-all-select' + "'" + ',plain:true">全选</a></div>';
    /*
    var buttons = '申请内容';
    $HUI.panel("#center",{
        title: buttons,
        headerCls:'panel-header-gray',
        iconCls:'icon-add-note'
    });
    */
	//初始化申请原因
    $('#TextRequestReasonDiv').hide();
	$('#cbxRequestReason').combogrid({
	    width:305,
	    idField:'id',
	    textField:'text',
	    panelHeight:340,
		panelWidth:530,
	    editable:false,
		striped: true,
		data: eval("(" + RequestReasonsData + ")"),
		showHeader: false,
		fitColumns: true,
		mode: 'local',
		columns: [[
			{ field: 'id', title: 'id', width: 80, hidden:true},
			{ field: 'num', title: '序号', width: 20},
			{ field: 'text', title: '描述', width: 250 }
		]],
	    onSelect: function(rowIndex, rowData){
			if (rowData.id == "other")
			{
				$("#TextRequestReasonDiv").show();
			}
			else
			{
				$("#TextRequestReasonDiv").hide();
			}
	    }
	});
	//getEmrTreeData('searchInput');
	getEmrTreeData("searchInput");	
	if(flag == "false"){
    	allActionChange("",false);
	   $('#emrTree').tree({
    		onLoadSuccess: function(){
	    		var nodesChecked = $('#emrTree').tree('getChecked');
	    		for(var i=0;i<nodesChecked.length;i++){
		    		$('#emrTree').tree('uncheck',nodesChecked[i].target)
		   		 }
	   		 }	
    	}) 
	}else{
			allActionChange("",true);
	}
    
    $('#selectall').bind('click', function () {
        selectall();
    });
    
    $('#unselectall').bind('click', function () {
        unselectall();
    });
    
    $('#expandall').bind('click', function () {
        expandall();
    });
    
    $('#collapseall').bind('click', function () {
        collapseall();
    });
    
    $('#btnCommit').bind('click', function () {
        commit();
    });
    
    $('#btnCancel').bind('click', function () {
        cancel();
    });
    
    //打开申请记录
	$("#requestHistory").click(function(){
	
		//returnValues = window.showModalDialog("emr.auth.requesthistory.csp?EpisodeID=" + episodeID + "&UserID=" + userID,window,"dialogHeight:450px;dialogWidth:800px;resizable:no;status:no");
		var content = '<iframe id="requestHistorysFrame" scrolling="auto" frameborder="0" src="emr.auth.requesthistory.csp?EpisodeID='+episodeID+"&UserID="+userID+'" style="width:100%; height:100%;"></iframe>';
		createModalDialog("requestHistorys","申请记录",800,400,'requestHistorysFrame',content,'','');
		});
})

function selectall(){
 	var nodesChecked = $('#emrTree').tree('find', 'INS').children;
	for(var i=0;i<nodesChecked.length;i++)
	{
		$('#emrTree').tree('check',nodesChecked[i].target)
	}
}

function unselectall(){
	var nodesChecked = $('#emrTree').tree('find', 'INS').children;
	for(var i=0;i<nodesChecked.length;i++)
	{
		$('#emrTree').tree('uncheck',nodesChecked[i].target)
	}
}

function expandall(){
	var rootNode = $('#emrTree').tree('find', 'RT00');
    $('#emrTree').tree('expandAll', rootNode.target);
}

function collapseall(){
	var nodes = $('#emrTree').tree('getChildren', 'RT00');
	for (var i = 0; i < nodes.length; i++) {
		if ((nodes[i]["attributes"]["type"] == "cg")||(nodes[i]["attributes"]["type"] == "zdy"))
		{
	    	$('#emrTree').tree('collapse', nodes[i].target);
		}
	}
	//var rootNode = $('#emrTree').tree('find', 'RT00');
    //$('#emrTree').tree('collapseAll', rootNode.target);
    //$('#emrTree').tree('expand', rootNode.target);
}

function allActionChange(event,value){
    if (value == true)
    {
        array.forEach(privChecked)
    }
    else
    {
        array.forEach(privUnChecked)
    }
}
function privChecked(obj, index)
{
	$('#'+obj.id).checkbox('check');
}
function privUnChecked(obj, index)
{
	$('#'+obj.id).checkbox('uncheck');
}
function initPrivCheckBox()
{
	jQuery.ajax({
		type: "GET",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLAuthPrivRuleKey",
			"Method":"GetAllPrivRuleKey"
		},
		success: function(d){
			array = eval("["+d+"]");
			array.forEach(privCheckBox)
		},
		error: function(d){
			alert("error");
		}
	});
	
	
}
function privCheckBox(obj,index,arr)
{
	var div=$("<div class='checkBoxDiv'></div>")
	var input = $('<input class="hisui-checkbox" type="checkbox" data-options="onCheckChange:function(event,value){selectCheckBox(event,value)}">')
	$(input).attr("id",obj.id);
	$(input).attr("label",obj.name);
	$(div).append(input)
	
	
	$("#privColumn"+(obj.seq%3==0?3:obj.seq%3) ).append(div)
	

}
function isselectall(){
    return $('#save').checkbox('getValue')&&$('#print').checkbox('getValue')&&$('#delete').checkbox('getValue')&&$('#new').checkbox('getValue')&&$('#view').checkbox('getValue')
}

function selectCheckBox(event,value){
    //alert(event.target.id);
    var checkBoxID = event.target.id;
    var checkBoxDesc = $('#'+checkBoxID).checkbox('options').label;
    
    if(value == true){
		if(actionString.length==0){
			actionString = checkBoxID;
			actionNameString = checkBoxDesc;
		}
		else{
			if(actionString.indexOf(checkBoxID)<0){
				actionString = actionString + ',' + checkBoxID;
				actionNameString = actionNameString + ',' + checkBoxDesc;
			}
		}
	}
	else{
		actionString = actionString.replace(checkBoxID,'');
		actionString = actionString.replace(',,',',');
		actionNameString = actionNameString.replace(checkBoxDesc,'');
		actionNameString = actionNameString.replace(',,',',');
		if(actionString.charAt(0)==','){			
			actionString=actionString.substr(1, actionString.length);
			actionNameString = actionNameString.substr(1, actionNameString.length);
		}
		if(actionString.charAt(actionString.length-1)==','){
			actionString=actionString.substr(0, actionString.length-1);
			actionNameString = actionNameString.substr(0, actionNameString.length-1);
		}
	}
}

function commit(){
    //授权范围
    var HasSealed = "N";
    var RequestCateCharpter = "";
    var RequestCateCharpterText = "";
    var msgGridDataArray = new Array();
    var nodes = $('#emrTree').tree('getChecked');
    for (var i = 0; i < nodes.length; i++) {
        if (nodes[i]["attributes"]["type"] == "cc" || nodes[i]["attributes"]["type"] == "ct") {
            if (RequestCateCharpter == "") {
                RequestCateCharpter = nodes[i]["id"];
                RequestCateCharpterText = nodes[i]["text"];
            }
            else {
                RequestCateCharpter = RequestCateCharpter + "^" + nodes[i]["id"];
                RequestCateCharpterText = RequestCateCharpterText + "，" + nodes[i]["text"];
            }
            var msgGridData = {"recordName":nodes[i]["text"]};
            msgGridDataArray.push(msgGridData);
        }
        
        if (nodes[i]["IsSealed"] == "Y")
        {
	        HasSealed = "Y";
	    }
    }
    
    //已封存病历不能进行权限申请
    if (HasSealed == "Y") {
        $.messager.alert('操作提示', '不能对已封存病历进行权限申请！');
        return;
    }
    
    //没有勾选任何范围
    if (RequestCateCharpter == "") {
        $.messager.alert('操作提示', '请至少选择一个授权范围！');
        return;
    }
    
    //没有勾选任何操作
    if (actionString == "") {
        $.messager.alert('操作提示', '请选择一种权限类型再提交申请！');
        return;
    }
    
    //只对实例病历进行 创建病历 操作申请，给出提示; add by niucaicai 2018-03-13
	var ActionHasNew = "0";
	if (actionString.indexOf("new") >= 0)
	{
		ActionHasNew = "1";
	}
	
	var CharpterOnlyHasRecord = "1"
	for (var j=0;j<RequestCateCharpter.split("^").length ;j++ )
	{
		//alert(RequestCateCharpter.split("^")[j].indexOf("||"));
		if (RequestCateCharpter.split("^")[j].indexOf("||") < 0)
		{
			CharpterOnlyHasRecord = "0"
		}
	}

	if ((ActionHasNew == "1")&&(CharpterOnlyHasRecord == "1"))
	{
		$.messager.alert('操作提示', '不能只对实例病历进行 新建 操作申请!');
		return;
	}
	
	//对空模板申请操作时，必须带有“新建”操作
	if ((ActionHasNew == "0")&&(CharpterOnlyHasRecord == "0"))
	{
		$.messager.alert('操作提示', '对空模板申请操作权限时，必须带有 新建 操作！');
		return;
	}
    
    //没有申请原因
	var requestReason = "";
    var requestReasonID = $('#cbxRequestReason').combobox('getValue');
	if (requestReasonID == "other")
	{
		requestReason = $('#TextRequestReason').val();
	}
	else
	{
		requestReason = $('#cbxRequestReason').combobox('getText');
	}
	
    var beforeRequestContent = $('#beforeRequestContent').val();
    var afterRequestContent = $('#afterRequestContent').val();
    var requestNumber = $('#requestNumber').val();
    if (EditMust[0] == "Y" && requestReason == "") {
        $.messager.alert('操作提示', '请填写 申请的原因 再提交申请');
        return;
    }
	if (EditMust[0] == "Y" && LimitMust[0] > 0 && requestReason.length < LimitMust[0] ) {
        $.messager.alert('操作提示', '申请的原因 至少' + LimitMust[0] + '个字');
        return;
    }
	if (EditMust[1] == "Y" && beforeRequestContent == "") {
        $.messager.alert('操作提示', '请填写 修改前内容 再提交申请');
        return;
    }
	if (EditMust[1] == "Y" && LimitMust[1] > 0 && beforeRequestContent.length < LimitMust[1] ) {
        $.messager.alert('操作提示', '修改前内容 至少' + LimitMust[1] + '个字');
        return;
    }
	if (EditMust[2] == "Y" && afterRequestContent == "") {
        $.messager.alert('操作提示', '请填写 修改后内容 再提交申请');
        return;
    }
	if (EditMust[2] == "Y" && LimitMust[2] > 0 && afterRequestContent.length < LimitMust[2] ) {
        $.messager.alert('操作提示', '修改后内容 至少' + LimitMust[2] + '个字');
        return;
    }
    if (requestReason.length>1000){
        $.messager.alert('操作提示', '请将申请原因控制在1000字以内');
        return;	    
	}
    if (beforeRequestContent.length>1000){
        $.messager.alert('操作提示', '请将修改前内容控制在1000字以内');
        return;	    
	}
    if (afterRequestContent.length>1000){
        $.messager.alert('操作提示', '请将修改后内容控制在1000字以内');
        return;	    
	}
    if (requestNumber.length>1000){
        $.messager.alert('操作提示', '请将申请人电话控制在1000字以内');
        return;	    
	}
    //增加对特殊字符的过滤，不允许填写特殊字符  add by niucaicai 2016-12-27
	if (requestReason.indexOf("@") != -1 || requestReason.indexOf("#") != -1 || requestReason.indexOf("$") != -1 || requestReason.indexOf("%") != -1 || requestReason.indexOf("^") != -1 || requestReason.indexOf("&") != -1 || requestReason.indexOf("*") != -1 || requestReason.indexOf("-") != -1 || requestReason.indexOf("/") != -1 || requestReason.indexOf("\\") != -1)
	{
		$.messager.alert('操作提示','申请的原因 含有非法字符，请重新输入！');
		return;
	}
	if (beforeRequestContent.indexOf("@") != -1 || beforeRequestContent.indexOf("#") != -1 || beforeRequestContent.indexOf("$") != -1 || beforeRequestContent.indexOf("%") != -1 || beforeRequestContent.indexOf("^") != -1 || beforeRequestContent.indexOf("&") != -1 || beforeRequestContent.indexOf("*") != -1 || beforeRequestContent.indexOf("-") != -1 || beforeRequestContent.indexOf("/") != -1 || beforeRequestContent.indexOf("\\") != -1)
	{
		$.messager.alert('操作提示','修改前内容 含有非法字符，请重新输入！');
		return;
	}
	if (afterRequestContent.indexOf("@") != -1 || afterRequestContent.indexOf("#") != -1 || afterRequestContent.indexOf("$") != -1 || afterRequestContent.indexOf("%") != -1 || afterRequestContent.indexOf("^") != -1 || afterRequestContent.indexOf("&") != -1 || afterRequestContent.indexOf("*") != -1 || afterRequestContent.indexOf("-") != -1 || afterRequestContent.indexOf("/") != -1 || afterRequestContent.indexOf("\\") != -1)
	{
		$.messager.alert('操作提示','修改后内容 含有非法字符，请重新输入！');
		return;
	}
	//检查是否有申请的权限
	var authPrivilege = getPrivilege(RequestCateCharpter,actionString);
	if (authPrivilege != "")
	{
		$.messager.alert('操作提示',authPrivilege);
		return;
	}
    
//病历已打印 申请权限时提示
jQuery.ajax({
    	type: "POST",
    	dataType: "text",
    	async: true,
   		url: '../EMRservice.Ajax.auth.request.cls',
    	data: {
        	"Action": "getRequestPriv",
        	"EpisodeID": episodeID,
			"RequestCateCharpter": RequestCateCharpter
    },
    success: function(response, opts){
            if (response !== "0"){
                $.messager.confirm("操作提示", response, function (data){
	                if(!data){
	                    cancel();
					}else{
						jQuery.ajax({
							type: "post",
							dataType: "text",
							url: '../EMRservice.Ajax.auth.request.cls',
							async: true,
							data: {
								"Action": "request",
								"EpisodeID": episodeID,
								"PatientID": patientID,
								"RequestCateCharpter": RequestCateCharpter,
								"RequestUserID": userID,
								"RequestDept": userLocID,
								"EPRAction": actionString,
								"RequestReason": requestReason,
								"BeforeRequestContent": beforeRequestContent,
								"AfterRequestContent": afterRequestContent,
								"RequestNumber": requestNumber
							},
							success:function(d) {
							if (d === "-2") {
								$.messager.alert('操作提示','已经申请过权限，请联系管理科室处理！');
							}
							else if ((d !== "-1")||(d !== "0")) {
								 $.messager.alert('操作提示','权限申请已成功！','info',function(){
										cancel();
									});
							}
						},
							error:function(d) {
								$.messager.alert('操作提示', '申请权限操作提交失败！')
							}
						});
					}
				});
            }else{
                jQuery.ajax({
                    type: "post",
                    dataType: "text",
                    url: '../EMRservice.Ajax.auth.request.cls',
                    async: true,
                    data: {
	                    "Action": "request",
						"EpisodeID": episodeID,
                        "PatientID": patientID,
                        "RequestCateCharpter": RequestCateCharpter,
                        "RequestUserID": userID,
                        "RequestDept": userLocID,
                        "EPRAction": actionString,
                        "RequestReason": requestReason,
                        "BeforeRequestContent": beforeRequestContent,
                        "AfterRequestContent": afterRequestContent,
                        "RequestNumber": requestNumber
                    },
                    success:function(d) {
                        if (d === "-2") {
	                    	$.messager.alert('操作提示','已经申请过权限，请联系管理科室处理！');
	                    }
                        else if ((d !== "-1")||(d !== "0")) {
	                        
                            $.messager.alert('操作提示','权限申请已成功！','info',function(){
	                           		cancel();
	                            });
                            
                        }
                    },
                    error:function(d) {
                        $.messager.alert('操作提示', '申请权限操作提交失败！')
                    }
                });
            }
    },
   		 error: function(response, opts){
        	$.messager.alert('提示', response.responseText);
    	}
	});
    /*jQuery.ajax({
		type: "post",
		dataType: "text",
		url: '../EMRservice.Ajax.auth.request.cls',
		async: true,
		data: {
			"Action": "request",
			"EpisodeID": episodeID,
			"PatientID": patientID,
			"RequestCateCharpter": RequestCateCharpter,
			"RequestUserID": userID,
			"RequestDept": userLocID,
			"EPRAction": actionString,
			"RequestReason": requestReason,
			"BeforeRequestContent": beforeRequestContent,
			"AfterRequestContent": afterRequestContent，
			"RequestNumber": requestNumber
		},
		success: function(d) {
			if ((d !== "-1")||(d !== "0")) {
		        $.messager.alert('操作提示','权限申请已成功！');
		        cancel();
		    }
		},
		error : function(d) {
			$.messager.alert('操作提示', '申请权限操作提交失败！')	
		}
	});*/
}

///脚本权限
function getPrivilege(requestCateCharpter,actionString)
{
	var result = "";
	jQuery.ajax({
		type: "POST",
		dataType: "text",
		url: "../EMRservice.Ajax.privilege.cls",
		async: false,
		data: {
			"EpisodeID":  episodeID,
			"PatientID":  patientID,
			"Type":       "AuthPrivilege",
			"RequestCateCharpter":  requestCateCharpter,
			"ActionString":  actionString
		},
		success: function(d) {
			if (d != "") result = d.replace(/\\n/g,"<br/>");
		},
		error : function(d) { alert("AuthPrivilege error");}
	});
	return result;	
}


function cancel(){
	var id = "dialogAuthRequest";
	parent.closeDialog(id);
}
///查询//////////////////////////////////////////////////////////
$('#searchRecord').searchbox({ 
    searcher:function(value,name){ 
    	getEmrTreeData("searchInput");
    }          
  });
  
///查询//////////////////////////////////////////////////////////
/* $("#searchInput").keydown(function(){
	if(event.keyCode == 13)
	{
		getEmrTreeData("searchInput");
	}	
});
$('#searchRecord').click(function(){ 
	getEmrTreeData("searchInput");
}); */
function getEmrTreeData(myid)
{
	//var selectValue = document.getElementById(myid).value;
	//var defaultValue = document.getElementById(myid).defaultValue;
	//if (selectValue == defaultValue) selectValue = "";
	var selectValue = $('#searchRecord').searchbox('getValue') 
	jQuery.ajax({
		type : "GET",
		dataType : "text",
		url : "../EMRservice.Ajax.auth.request.cls",
		async : true,
		data : {"Action":"gettree","EpisodeID":episodeID,"selectedDocID":userID,"selecteddocCTLocID":userLocID,"selecteddocSSGroupID":userSSGroupID,"Condition":selectValue},
		success : function(d) {
           if ( d != "") 
		   {
			   $('#emrTree').tree({
			        data: eval("("+d+")"),
			        animate: true,
			        checkbox: true,
			        onlyLeafCheck:true,
			        cascadeCheck: false
			    });
		   }
		},
		error : function(d) { alert("add kbTree error");}
	});
}