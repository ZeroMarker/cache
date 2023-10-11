$(function(){
	if(typeof obj == undefined){
		obj=window.parent;
	}
	strXml = convertToXml(scheme);
	getData();
	getConfig();
	setHtmlTitle();
});

function setHtmlTitle()
{
	if (eventType == "BloodTransfusion")
	{
		document.title = "输血记录"; 
	}
	else if (eventType == "CriticalValue")
	{
		document.title = "危机值";
	}
	else if (eventType == "Operation")
	{
		document.title = "手术记录";
	}
	else if (eventType == "Rescue")
	{
		document.title = "抢救记录";
	}
	else if (eventType == "Manipulate")
	{
		document.title = "操作记录";
	} 
	else if (eventType == "Consult")
	{
		document.title = "会诊";
	} 	
	else if (eventType == "MDTConsult")
	{
		document.title = "MDT会诊";
	}
	else if (eventType == "DischargeRecord")
	{
		document.title = "出院记录";
	}
	else if (eventType == "InformedConsent")
	{
		document.title = "特殊治疗知情同意书";
	}	
}

//取危机值
function getData(data)
{
	$('#eventValues').datagrid({
		fit:true,
		headerCls:'panel-header-gray',
	    loadMsg:'数据装载中......',
	    url:'../EMRservice.Ajax.eventData.cls?Action=GetData&EventType='+eventType+'&EpisodeID='+episodeId, 
	    singleSelect:false,
	    idField:'ID',
	    fitColumns:false,
	    checkOnSelect:true,
	    columns:getColumnScheme("show>item"),
	    rowStyler: function(index,row){
			if (row.IsActive != "提示")
			{
				return 'color:#CCCCCC;';
			}
		},
	    onClickRow: function(rowIndex, rowData){
	    	//如果当前的复选框不可选，则不让其选中
		if (rowData.IsActive != "提示") {
	            $('#eventValues').datagrid('unselectRow', rowIndex);
	        }
	    },
		onDblClickRow: function(rowIndex, rowData){
	    	//如果当前的复选框不可选，则不让其选中
		if (rowData.IsActive != "提示") {
	            $('#eventValues').datagrid('unselectRow', rowIndex);
	        }
	    },
	    onLoadSuccess:function(data){
			if (data.rows.length > 0) {
				for (var i = 0; i < data.rows.length; i++) {
					if (data.rows[i].IsActive != "提示") {
						
						$("input[type='checkbox']").eq(i + 1).attr("disabled",'disabled');
					}
				}
			}
			if ((obj != undefined)&&(obj.rowIndex != undefined)&&!isNaN(obj.rowIndex))
			{
				$('#eventValues').datagrid("checkRow",obj.rowIndex);
			} 
		},
        onCheckAll: function(rows) {
            var length = rows.length;
            if (length == 0) return;
            for (i = 0; i < length; i++) {
                if (rows[i].IsActive != "提示") {
	            	$('#eventValues').datagrid('unselectRow', i);
	        	}
            }
        }  
	});	
	$(".datagrid-header-check").attr("disabled","disabled"); 
	if (eventType == "Operation")
	{
		$('#eventValues').datagrid({singleSelect:true});
		$('#eventValues').datagrid('hideColumn','ck');
	}
}

//脚本权限
function getConfig()
{
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: '../EMRservice.Ajax.eventData.cls',
		async: true,
		data: {
			"Action": "GetConfig",
			"EpisodeID": episodeId,
			"EventType": eventType
		},
		success: function(d) {
			if (d != "")
			{
				var data = eval("("+d+")");
				$("#path").val(data.Location);
				$("#title").attr({"DocID":data.DocID,"CategoryID":data.CategoryID,"TemplateId":data.TemplateId});
				$("#title").attr({"IsLeadframe":data.IsLeadframe,"IsMutex":data.IsMutex});
				$("#title").attr({"ChartItemType":data.ChartItemType,"PluginType":data.PluginType});
				
				$("#title").combobox({  
					width:227,
				    data:data.TitleCodes,  
				    valueField:'TitleCode',  
				    textField:'TitleDesc',
				    onLoadSuccess:function(){
					var data= $(this).combobox("getData");
					if (data.length > 0) $("#title").combobox('select', data[0].TitleCode);
					}  
				});  
			}
		},
		error : function(d) { alert(" error");}
	});
}

$("#new").click(function(){
	var result = "";
	var Ids = "";
	var list = getRefScheme("reference>item");
	var checkedItems = $('#eventValues').datagrid('getChecked');
	if (checkedItems.length == 0) {
        $.messager.popover({msg: "请先选择数据",type:"info",timeout:"2000",style:{top:20,left:document.documentElement.clientWidth/2}});
        return;
    }
	$.each(checkedItems, function(index, item){
		for (var i=0;i<list.length;i++)
		{
			result = result + list[i].desc + item[list[i].code] + list[i].separate;
		}
		Ids = Ids + "@" + item["ID"];
	})
	Ids = Ids.substring(1);
	var titlecode = $('#title').combobox('getValue');
	var actiontype = (titlecode == "" || titlecode == undefined || titlecode == null )?"CREATE":"CREATEBYTITLE";
	if ($("#path").val() == "")
	{
		result = "";
	}
    var tabParam ={
		"id":"",
		"text":$("#title").find("option:selected").text()==""?$("#title").combobox('getText'):$("#title").find("option:selected").text(),
		"pluginType":$("#title").attr("PluginType"),
		"chartItemType":$("#title").attr("ChartItemType"),
		"emrDocId":$("#title").attr("DocID"),
		"templateId":$("#title").attr("TemplateId"),
		"isLeadframe":$("#title").attr("IsLeadframe"),
		"isMutex":$("#title").attr("IsMutex"),
		"categoryId":$("#title").attr("CategoryID"),
		"IsActive":"Y",
		"actionType":actiontype,
		"status":"NORMAL",
		"closable":true,
		"titleCode":titlecode,
		"args":{
			"event":{
				"EventType":eventType,
				"EventID":Ids
			}
		},
		"insert":{
			"content":result,
			"path":$("#path").val()
		}
	 };
	 var tmpDateTime = new Date().format("yyyy-MM-dd hh:mm:ss");
	 if (!compareDateTimeByFisrtRecord(tmpDateTime,tabParam.emrDocId,tabParam.titleCode)) return;	 
	 returnValue = JSON.stringify(tabParam);
	 CloseWindow();
});

$("#unActive").click(function(){
	
	var Ids = "";
	var checkedItems = $('#eventValues').datagrid('getChecked');
	if (checkedItems.length == 0) {
        $.messager.popover({msg: "请先选择数据",type:"info",timeout:"2000",style:{top:20,left:document.documentElement.clientWidth/2}});
        return;
    }
	$.each(checkedItems, function(index, item){
		Ids = Ids + "," + item["ID"];
	})
	Ids = Ids.substring(1);
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: '../EMRservice.Ajax.eventData.cls',
		async: true,
		data: {
			"Action": "setUnActive",
			"EventType": eventType,
			"SelectIds": Ids
		},
		success: function(d) {
			if (d == "1")
			{
				$('#eventValues').datagrid('reload'); 
				window.parent.getEvent();
			}
		},
		error : function(d) { alert(" error");}
	});
	
});

//表字段Scheme
function getColumnScheme(path)
{
	var columns = new Array();
	columns.push({field:'ck',checkbox:true});
	columns.push({field:'ID',hidden:true});
    var showparent = $(strXml).find(path).each(function(){
	    var code = $(this).find("code").text();
	    var desc = $(this).find("desc").text();
	    var sortable = $(this).find("sortable").text()=="Y"?true:false;
	    var hidden = $(this).find("hidden").text()=="Y"?true:false; 
	    var colwidth = $(this).find("width").text();
	        colwidth = (colwidth=="")?80:colwidth;     
	    columns.push({field:code,title:desc,width:colwidth,hidden:hidden,sortable:sortable});
    });
    return [columns];
}
//引用Scheme
function getRefScheme(path)
{
	var refScheme = new Array();
    var showparent = $(strXml).find(path).each(function(){
	    var code = $(this).find("code").text();
	    var desc = $(this).find("desc").text();
	    var separate = $(this).find("separate").text(); 
	    if (separate == "enter")
	    {
		    separate = "\n";
		}
		else if (separate == "blackspace")
		{
			separate = " "
		}
		var check = $(this).find("check").text()=="N"?false:true; 
	    refScheme.push({code:code,desc:desc,separate:separate,check:check});
    });
    return refScheme;
}

//关闭窗口
function CloseWindow()
{
	parent.closeDialog("dialogEvent");
}

//与首次病程日期比较
function compareDateTimeByFisrtRecord(dateTime,docId,titleCode)
{
	var result = true;
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLTitleConfig",
			"Method":"CanCreateTitle",
			"p1":episodeId,
			"p2":docId,
			"p3":titleCode,
			"p4":dateTime
		},
		success: function(d) {
			if (d != "1")
			{
				result = false;
				$.messager.alert("提示",d.substring(2));
			}
		},
		error : function(d) { 
			alert("compareDateTimeByFisrtRecord error");
		}
	});	
	return result
}