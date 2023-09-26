$(function(){
	strXml = convertToXml(scheme);
	getCriticalValue();
	getConfig();
});

//取危机值
function getCriticalValue(data)
{
	$('#criticalvalues').datagrid({
	    loadMsg:'数据装载中......',
	    autoRowHeight: true,
	    url:'../EMRservice.Ajax.eventData.cls?Action=CriticalValue&EpisodeID='+episodeId, 
	    rownumbers:true,
	    singleSelect:false,
	    idField:'CriticalValueID',
	    fit:true,
	    columns:getColumnScheme("show>item")
	});	
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
			"Action": "CriticalValueConfig",
			"EpisodeID": episodeId
		},
		success: function(d) {
			if (d != "")
			{
				var data = eval("("+d+")");
				$("#title").attr({"DocID":data.DocID,"CategoryID":data.CategoryID,"TemplateId":data.TemplateId});
				$("#title").attr({"IsLeadframe":data.IsLeadframe,"IsMutex":data.IsMutex});
				$("#title").attr({"ChartItemType":data.ChartItemType,"PluginType":data.PluginType});
				for (var i=0;i<data.TitleCodes.length;i++)
				{
					$("#title").append('<option value ="'+data.TitleCodes[i].TitleCode+'">'+data.TitleCodes[i].TitleDesc+'</option>');
				}
			}
		},
		error : function(d) { alert(" error");}
	});
}

$("#new").click(function(){
	var result = "";
	var Ids = "";
	var list = getRefScheme("reference>item");
	var checkedItems = $('#criticalvalues').datagrid('getChecked');
	$.each(checkedItems, function(index, item){
		for (var i=0;i<list.length;i++)
		{
			result = result + list[i].desc + item[list[i].code] + list[i].separate;
			Ids = Ids + "," + item["CriticalValueID"];
		}
	})
    var tabParam ={
		"id":"",
		"text":$("#title").text(),
		"pluginType":$("#title").attr("PluginType"),
		"chartItemType":$("#title").attr("ChartItemType"),
		"emrDocId":$("#title").attr("DocID"),
		"templateId":$("#title").attr("TemplateId"),
		"isLeadframe":$("#title").attr("IsLeadframe"),
		"isMutex":$("#title").attr("IsMutex"),
		"categoryId":$("#title").attr("CategoryID"),
		"actionType":"CREATEBYTITLE",
		"status":"NORMAL",
		"closable":true,
		"titleCode":$("#title").val(),
		"content":result,
		"eventType":"CriticalValue",
		"CriticalValueIDs": Ids.substring(1)
	 }; 
	 window.returnValue = tabParam;
	 CloseWindow();
});

//表字段Scheme
function getColumnScheme(path)
{
	var columns = new Array();
	columns.push({field:'ck',checkbox:true})
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
	window.opener=null;
	window.open('','_self');
	window.close();	
}