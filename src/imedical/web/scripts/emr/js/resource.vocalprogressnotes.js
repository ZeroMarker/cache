var NotesSubItems= "";
$(function(){
	strXml = convertToXml(scheme);
	var interface = $(strXml).find("interface").text();
	pageConfig = $(strXml).find("pageConfig").text();
	$("#comboxEpisode").hide();
	$("#resourceConfig").hide();
	debugger;
	if (pageConfig == "Y")
	{
		$("#resourceConfig").show();
		//获取其它资源区的查询按钮配置项数据
		resourceConfig = getResourceConfig();
		var configItem = resourceConfig.Notes;
		if ((configItem != "")&&(configItem != undefined))
		{
			$('#'+configItem).attr("checked",true);
			if (configItem == "allEpisode")
			{
				$("#comboxEpisode").show();
			}
		}else{
			$('#currentEpisode').attr("checked",true);
		}
	}else{
		$('#currentEpisode').attr("checked",true);
	}
	initEpisodeList("#EpisodeList");
	setDataGrid(interface);
	$('#seekform').find(':radio').change(function () {
		if (this.id == "allEpisode")
		{
			$("#comboxEpisode").show();
		}
		else
		{
			$("#comboxEpisode").hide();
			queryData();
		}
		if (pageConfig == "Y")
		{
			resourceConfig.Notes = this.id;
		}
	});
	
	$('#NotesDataPnl').panel('resize', {
		height: $('#dataPnl').height() * 0.60
	});
 
	$('body').layout('resize');	
});

//设置数据
function setDataGrid(interface)
{
	debugger;
	if ($('#allEpisode')[0].checked)
	{
		var param = {
			EpisodeIDS: getAllEpisodeIdByPatientId()
		};
	}else{
		var param = getParam();
	}
	$('#NotesData').datagrid({
	    pageSize:10,
	    pageList:[10,20,30], 
	    loadMsg:'数据装载中......',
	    autoRowHeight: true,
	    url:'../EMRservice.Ajax.VocalProgressNotes.cls?Action=GetPostResult&InterFace='+encodeURI(encodeURI(interface)), 
	    rownumbers:true,
	    pagination:true,
	    singleSelect:false,
	    queryParams:param,
	    fit:true,
	    columns:getColumnScheme("show>parent>item"),
	    onSelect:function(rowIndex,rowData){
		    var ordItemId = rowData.id;
		    quoteData[ordItemId]={};
			getNotesSubData(interface,ordItemId);
		},
		onUnselect:function(rowIndex,rowData){
			$("#NotesSubData  tr:not(:first)").empty();
			delete quoteData[rowData.id];
		},
		onCheckAll:function(rows)
		{
			quoteData = {};
			var length = rows.length; 
			for(i = 0; i < length; i ++){ 
				quoteData[rows[i].id] = {};	
				getNotesSubData(interface,rows[i].id);		
			}
		},
		onUncheckAll:function(rows)
		{
			$("#NotesSubData  tr:not(:first)").empty();
			quoteData = {};	
		}
	});
	initNotesSubTable();
}

//初始化子项(病程内容)
function initNotesSubTable()
{
	debugger;
	var tr = $("<tr></tr>");
	NotesSubItems = getColumnScheme("show>child>item")
	var NotesSubRefScheme = getRefScheme("reference>child>item");
	for (var i=1;i<NotesSubItems[0].length;i++)
	{
		var	td = "";		
		if (NotesSubItems[0][i].hidden)
		{ 
			td= "<th id='" +NotesSubItems[0][i].field+ "' style='display:none;' ><input type='checkbox' name='SubNotes'/>" + NotesSubItems[0][i].title + "</th>"    
		}
		else
		{
			td= "<th id='" +NotesSubItems[0][i].field+ "' style='border-bottom:#999 1px dotted;border-right:#999 1px dotted;background-color:#F5F5F5;width:" +NotesSubItems[0][i].width+ ";'><input type='checkbox' name='SubNotes' onclick='checkOnClick(this)' />" + NotesSubItems[0][i].title + "</th>" 			
		}
		$(tr).append(td);
	}
	$("#NotesSubData").append(tr);
    
    for (var i=0;i<NotesSubRefScheme.length; i++)
	{
		if (NotesSubRefScheme[i].check)
		{ 
			var code = NotesSubRefScheme[i].code;
			$('#'+ code+ " input").attr("checked",true);
		}
	}
}
// 取病程内容
function getNotesSubData(Interface,ID)
{
	jQuery.ajax({
		type: "GET",
		dataType: "text",
		url: "../EMRservice.Ajax.VocalProgressNotes.cls?InterFace="+encodeURI(encodeURI(Interface)),
		async: true,
		data: {
			"Action":"GetPostResultDetailed",
			"DocID":ID
		},
		success: function(d){setNotesSubData(eval("("+d+")"));},
		error: function(d){alert("error");}
	});
}

//子项(病程内容)赋值
function setNotesSubData(data)
{
	$("#NotesSubData  tr:not(:first)").remove();
	var tr = $("<tr></tr>");
	for (var i=0;i<data.rows.length;i++)
	{
		$(tr).attr("id",data.rows[i].OEItemRowID);
		var td = ""; 
		for (var j=1;j<NotesSubItems[0].length;j++)
		{
			if (NotesSubItems[0][j].hidden)
			{
				td = "<td style='border:#999 1px dotted;display:none;'>" + data.rows[i][NotesSubItems[0][j].field] +"</td>";	
			}
			else
			{
				td = "<td valign='top' style='border-bottom:#999 1px dotted;border-right:#999 1px dotted;white-space:normal;word-break:break-all;'>" + data.rows[i][NotesSubItems[0][j].field] +"</td>";	
			}
			$(tr).append(td);
		}
		
		$("#NotesSubData tr th").each(function(){
			if ($(this).find("input")[0].checked)
			{
				var field = $(this).attr("id");
				quoteData[data.rows[i].OEItemRowID][field]= data.rows[i][field];	
			}
		});
		$("#NotesSubData").append(tr);
	}
}

// 查询
function queryData()
{
	var param = getParam();
	$('#NotesData').datagrid('load',param);
}
//获取查询参数
function getParam()
{
	quoteData = {};

	var epsodeIds = episodeID;
	if ($('#allEpisode')[0].checked)
	{
		epsodeIds = "";
		var values = $('#EpisodeList').combogrid('getValues');
		for (var i=0;i< values.length;i++)
		{
			epsodeIds = (i==0)?"":epsodeIds + ",";
			epsodeIds = epsodeIds + values[i];
		}	
	}
	
	var param = {
		EpisodeIDS: epsodeIds
	};
	return param;	
}
//引用数据
function getData()
{
	var result = "";
	var parentList = getRefScheme("reference>parent>item");
	var childList = getRefScheme("reference>child>item");
	var separate = $(strXml).find("reference>separate").text();
	separate = (separate=="enter")?"\n":separate	
	var checkedItems = $('#NotesData').datagrid('getChecked');
	
	var param = {"action":"GET_DOCUMENT_CONTEXT"};
	documentContext = parent.eventDispatch(param);
	
	$.each(checkedItems, function(index, item)
	{
		if (quoteData[item.id])
		{
			//收集父内容
			for (var i=0;i<parentList.length;i++)
			{
				result = result + parentList[i].desc + item[parentList[i].code] + parentList[i].separate;
			}
			//收集子表内容
			for (var j=0;j<childList.length;j++)
			{
				if (quoteData[item.id][childList[j].code] != undefined)
				{
					result = result + childList[j].desc + quoteData[item.id][childList[j].code].replace(/\n/g,"") + childList[j].separate;
				}
			}
			if (checkedItems.length-1 > index)
			{
				result = result + separate;
			}
		}
	}); 	
	var param = {"action":"insertText","text":result}
	parent.eventDispatch(param);            
	
	//去掉选择
	UnCheckAll();
}

//选择子项目，改变缓存内容
function checkOnClick(obj)
{
	try
	{
		if (!$("#NotesSubData tr td")) return;
		var ordItemId = $("#NotesSubData tr:eq(1)").attr("id");
		if (!ordItemId) return;
		var field = $(obj).parent().attr("id");
		var tdNum = $(obj).parent()[0].cellIndex; 
		var context = "";
		$("#NotesSubData tr td").each(function() {
			if ($(this)[0].cellIndex == tdNum)
			{
				context = $(this).text();
			}	
		});
		if (obj.checked)
		{
			quoteData[ordItemId][field] = context;
		}
		else
		{
			if (quoteData[ordItemId][field])
			{
				delete quoteData[ordItemId][field];
			}
		}
	}
	catch(err)
	{
	}	
}

//去掉选择
function UnCheckAll()
{
	$("#NotesData").datagrid("uncheckAll");
}