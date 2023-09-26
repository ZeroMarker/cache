$(function(){
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
	else if (eventType == "ModDiagnosis")
	{
		document.title = "诊断记录";
	} 		
}

//取危机值
function getData(data)
{
	$('#eventValues').datagrid({
	    loadMsg:'数据装载中......',
	    url:'../EMRservice.Ajax.eventData.cls?Action=GetData&EventType='+eventType+'&EpisodeID='+episodeId, 
	    singleSelect:true,
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
			if (!isNaN(obj.rowIndex)&&(obj.rowIndex != undefined))
			{
				$('#eventValues').datagrid("checkRow",obj.rowIndex);
			}     
		} 
	});	
	$(".datagrid-header-check").attr("disabled","disabled"); 
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
				for (var i=0;i<data.TitleCodes.length;i++)
				{
					$("#title").append('<option value ="'+data.TitleCodes[i].TitleCode+'">'+data.TitleCodes[i].TitleDesc+'</option>');
				}
			}
		},
		error : function(d) { alert(" error");}
	});
	if (eventType != "CriticalValue"){
		$(".isManage").css("display","none");
  
	}else{
		$(".isManage").css("display","inline");	
	}
}

function create(){
	var result = "";
	var Ids = "";
	var text = "";
	var OEordItemDesc = "";
	var self = $(this);
	var title = self.attr("title");
	var list = getRefScheme("reference>item");
	var checkedItems = $('#eventValues').datagrid('getChecked');
	if (checkedItems.length == 0) return;
	$.each(checkedItems, function(index, item){
		for (var i=0;i<list.length;i++)
		{
			if(title == "unManageCreate"){
				if(list[i].code !== "OEordItemDesc")
				{
					result = result + list[i].desc + item[list[i].code] + list[i].separate;
				}
				else
				{
					OEordItemDesc = item[list[i].code]
					text = list[i].defaultDesc;
					text = text.replace(/x{2}/gi, OEordItemDesc);	
					result = result+text;
				}
			}else
			{
				if(list[i].code !== "OEordItemDesc")
				{
					result = result + list[i].desc + item[list[i].code] + list[i].separate;
				}
				else
				{
					return;	
				}
			}
		}
		Ids = Ids + "," + item["ID"];
	})
	Ids = Ids.substring(1);
	var titlecode = $("#title").val();
	var actiontype = (titlecode == "" || titlecode == undefined || titlecode == null )?"CREATE":"CREATEBYTITLE";
    
    
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
	 
	 window.returnValue = JSON.stringify(tabParam);
	 CloseWindow();
};
$("#new").click(create);
$("#unManage").click(create);

$("#unActive").click(function(){
	
	var Ids = "";
	var checkedItems = $('#eventValues').datagrid('getChecked');
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
				window.dialogArguments.getEvent();
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
	    var defaultDesc = $(this).find("default").text();
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
	    refScheme.push({code:code,desc:desc,separate:separate,check:check,defaultDesc:defaultDesc});
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