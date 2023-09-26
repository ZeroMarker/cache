var pacsSubItems= "";
$(function(){
	strXml = convertToXml(scheme);
	var interface = $(strXml).find("interface").text();
	pageConfig = $(strXml).find("pageConfig").text();
	selectConfig=$(strXml).find("datagridConfig>selectConfig").text();
    	if(selectConfig=="Y"){
	     selectOnCheckFlag=false
   		checkOnSelectFlag=false
	}
	$("#comboxEpisode").hide();
	initEpisodeList("#EpisodeList");
	setDataGrid(interface);
	$HUI.radio("[name='episode']",{
        onChecked:function(e,value){
            var value = $(e.target).attr("value");
            if (value === "allEpisode")
            {
				$("#comboxEpisode").show(); 
	        } 
	        else
	        {
				$("#comboxEpisode").hide();
 				$("#EpisodeList").combogrid('hidePanel');
				queryData();
		    }
		   	if (pageConfig == "Y")
			{
				resourceConfig.Pacs = this.id;
			} 
        }
    });
    
	if (pageConfig == "Y")
	{
		//获取其它资源区的查询按钮配置项数据
		resourceConfig = getResourceConfig();
		var configItem = resourceConfig.Pacs;
		if ((configItem != "")&&(configItem != undefined))
		{
			$HUI.radio("#"+configItem).setValue(true);
		}
		else
		{
			$HUI.radio("#currentEpisode").setValue(true);
		}
	}
	else
	{
		$HUI.radio("#currentEpisode").setValue(true);
	}
		
	$('#pacsDataPnl').panel('resize', {
		height: $('#dataPnl').height() * 0.60
	});
 
	$('body').layout('resize');	
});
//父表选中
function onCheckPar(rowIndex, rowData,interface){
    	var ordItemId = rowData.OEOrdItemDR;
	quoteData[ordItemId]={};
	getPacsSubData(interface,rowData.EpisodeID,ordItemId);	
}
//父表 取消选中
function onUnCheckPar(rowData){
	$("#pacsSubData  tr:not(:first)").empty();
	delete quoteData[rowData.OEOrdItemDR];
}
//设置数据
function setDataGrid(interface)
{
	if ($('#allEpisode')[0].checked)
	{
		var param = {
			EpisodeIDS: getAllEpisodeIdByPatientId(),
			StartDateTime: "",
			EndDateTime: "",
			RrtStartDateTime: "",
			RrtEndDateTime: "",
			RrtedFlag: ""
		};
	}else{
		var param = getParam();
	}
	$('#pacsData').datagrid({
	    pageSize:10,
	    pageList:[10,20,30], 
	    loadMsg:'数据装载中......',
	    autoRowHeight: true,
	    url:'../EMRservice.Ajax.pacsData.cls?Action=GetPacsData&InterFace='+encodeURI(encodeURI(interface)), 
	    rownumbers:true,
	    pagination:true,
	    selectOnCheck: selectOnCheckFlag,
       	    checkOnSelect: checkOnSelectFlag,
	    singleSelect:false,
	    queryParams:param,
	    idField:'OEOrdItemDR',
	    fit:true,
	    columns:getColumnScheme("show>parent>item"),
	    onCheck: function(rowIndex, rowData) {
	        clickFlag=true;
	        if(selectConfig!="Y")return
            onCheckPar(rowIndex, rowData,interface);
        },
        onUncheck:function(rowIndex,rowData){
	        if(selectConfig!="Y")return
           	onUnCheckPar(rowData);
	    },
	    onSelect:function(rowIndex,rowData){
		   clickFlag=false;
	       onCheckPar(rowIndex, rowData,interface);
		},
		onUnselect:function(rowIndex,rowData){
           	onUnCheckPar(rowData);
		},
		onCheckAll:function(rows)
		{
			quoteData = {};
			var length = rows.length; 
			for(i = 0; i < length; i ++){ 
				quoteData[rows[i].OEOrdItemDR] = {};	
				getPacsSubData(interface,rows[i].EpisodeID,rows[i].OEOrdItemDR);			
			}
		},
		onUncheckAll:function(rows)
		{
			$("#pacsSubData  tr:not(:first)").empty();
			quoteData = {};	
		}
	});
	initPacsSubTable();
}
//初始化检查子项
function initPacsSubTable()
{
	var tr = $("<tr></tr>");
	pacsSubItems = getColumnScheme("show>child>item")
	var pacsSubRefScheme = getRefScheme("reference>child>item");
	for (var i=1;i<pacsSubItems[0].length;i++)
	{
		var	td = "";		
		if (pacsSubItems[0][i].hidden)
		{ 
			td= "<th id='" +pacsSubItems[0][i].field+ "' style='display:none;'><input class='hisui-checkbox' type='checkbox' name='SubPacs' label='" + pacsSubItems[0][i].title + "'/></th>"    
		}
		else
		{
			td= "<th id='" +pacsSubItems[0][i].field+ "' style='width:" +pacsSubItems[0][i].width+ ";'><input class='hisui-checkbox' type='checkbox' name='SubPacs' data-options='onCheckChange:function(event,value){checkOnClick(this)}' label='" + pacsSubItems[0][i].title + "'/></th>" 			
		}
		$(tr).append(td);
	}
	$("#pacsSubData").append(tr);
	$.parser.parse('#pacsSubData');
	if(selectConfig=="Y"&&clickFlag==false)return
	for (var i=0;i<pacsSubRefScheme.length; i++)
	{
		if (pacsSubRefScheme[i].check)
		{ 
			var code = pacsSubRefScheme[i].code;
			//$('#'+ code+ " input").attr("checked",true);
			$HUI.checkbox('#'+ code+ " input").setValue(true);
		}
	}
}
// 取检验结果
function getPacsSubData(Interface,EpisodeID,ID)
{
	jQuery.ajax({
		type: "GET",
		dataType: "text",
		url: "../EMRservice.Ajax.pacsData.cls?InterFace="+encodeURI(encodeURI(Interface)),
		async: true,
		data: {
			"Action":"GetSubPacs",
			"EpisodeIDS":EpisodeID,
			"ID":ID
		},
		success: function(d){setPacsSubData(eval("("+d+")"));},
		error: function(d){alert("error");}
	});
}

//检查子项赋值
function setPacsSubData(data)
{
	var pacsSubRefScheme = getRefScheme("reference>child>item");
	for (var i=0;i<pacsSubRefScheme.length; i++)
	{
		if (selectConfig=="Y"&&clickFlag==false)
		{ 
			var code = pacsSubRefScheme[i].code;
			$HUI.checkbox('#'+ code+ " input").setValue(false);
		}
		else{
			var code = pacsSubRefScheme[i].code;
			$HUI.checkbox('#'+ code+ " input").setValue(true);
		}
	}
	$("#pacsSubData  tr:not(:first)").remove();
	var tr = $("<tr></tr>");
	for (var i=0;i<data.rows.length;i++)
	{
		$(tr).attr("id",data.rows[i].OEItemRowID);
		var td = ""; 
		for (var j=1;j<pacsSubItems[0].length;j++)
		{
			if (pacsSubItems[0][j].hidden)
			{
				td = "<td style='display:none;'>" + data.rows[i][pacsSubItems[0][j].field] +"</td>";	
			}
			else
			{
				td = "<td>" + data.rows[i][pacsSubItems[0][j].field] +"</td>";	
			}
			$(tr).append(td);
		}
		
		$("#pacsSubData tr th").each(function(){
			if ($(this).find("input")[0].checked)
			{
				var field = $(this).attr("id");
				quoteData[data.rows[i].OEItemRowID][field]= data.rows[i][field];	
			}
		});
		$("#pacsSubData").append(tr);
	}
}

// 查询
function queryData()
{
	var param = getParam();
	$('#pacsData').datagrid('load',param);
}
//获取查询参数
function getParam()
{
	quoteData = {};
	var stDateTime = "",endDateTime = "";
	//rrtStDateTime、rrtEndDateTime是按报告日期查询的始末条件
	var rrtStDateTime = "",rrtEndDateTime = "";
	//报告标识rrtedFlag
	var rrtedFlag = "";
	var epsodeIds = "";
	if ($('#currentDay')[0].checked)
	{
		//stDateTime = new Date().format("yyyy-MM-dd");
		//endDateTime = new Date().format("yyyy-MM-dd"); 
		//按报告日期当日查询
		rrtStDateTime = new Date().format("yyyy-MM-dd");
		rrtEndDateTime = new Date().format("yyyy-MM-dd");
		epsodeIds = episodeID;
	}
	else if ($('#ThreeDays')[0].checked)
	{
		var start = new Date();
		start.setDate(start.getDate() - 2);
		//stDateTime = start.getFullYear() + "-" + (start.getMonth()+1) + "-" + start.getDate()   
		//endDateTime = new Date().format("yyyy-MM-dd");
		//按报告日期三日内查询查询
		rrtStDateTime = start.getFullYear() + "-" + (start.getMonth()+1) + "-" + start.getDate();
		rrtEndDateTime = new Date().format("yyyy-MM-dd");
		epsodeIds = episodeID;
	}
	else if ($('#sevenDays')[0].checked)
	{
		var start = new Date();
		start.setDate(start.getDate() - 6);
		//stDateTime = start.getFullYear() + "-" + (start.getMonth()+1) + "-" + start.getDate()   
		//endDateTime = new Date().format("yyyy-MM-dd");
		//按报告日期七日内查询查询
		rrtStDateTime = start.getFullYear() + "-" + (start.getMonth()+1) + "-" + start.getDate();
		rrtEndDateTime = new Date().format("yyyy-MM-dd");
		epsodeIds = episodeID;
	}
	else if ($('#currentWeek')[0].checked)
	{
		var now = new Date();  
		var start = new Date();  
		var n = now.getDay();  
		start.setDate(now.getDate()-n+1);  
		//stDateTime = start.getFullYear() + "-" + (start.getMonth()+1) + "-" + start.getDate();   
		//endDateTime = new Date().format("yyyy-MM-dd");
		//按报告日期一周内查询
		rrtStDateTime = start.getFullYear() + "-" + (start.getMonth()+1) + "-" + start.getDate();
		rrtEndDateTime = new Date().format("yyyy-MM-dd"); 
		epsodeIds = episodeID;
	}
	else if ($('#allEpisode')[0].checked)
	{
		epsodeIds = "";
		var values = $('#EpisodeList').combogrid('getValues');
		for (var i=0;i< values.length;i++)
		{
			epsodeIds = (i==0)?"":epsodeIds + ",";
			epsodeIds = epsodeIds + values[i];
		}	
		rrtedFlag = "";	
	}
	else if ($('#noPacsEpisode')[0].checked)
	{
	    //未报告查询
		rrtedFlag = 0;
		epsodeIds = episodeID;
	}
	else if ($('#currentEpisode')[0].checked)
	{
		//本次就诊
		rrtedFlag = 1;
		epsodeIds = episodeID;
	}
	var param = {
		EpisodeIDS: epsodeIds,
		StartDateTime: stDateTime,
		EndDateTime: endDateTime,
		RrtStartDateTime: rrtStDateTime,
		RrtEndDateTime: rrtEndDateTime,
		RrtedFlag: rrtedFlag
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
	var quality = $(strXml).find("quality").text();
	var checkedItems = $('#pacsData').datagrid('getChecked');
	var param = {"action":"GET_DOCUMENT_CONTEXT"};
	documentContext = parent.eventDispatch(param);

	$.each(checkedItems, function(index, item)
	{
		if (quality == "1")
		{
			var happenDatetime = documentContext.HappenDateTime;
			var tmpDatatime = item.RrtDate + " "+ item.RrtTime
			if (compareDateTime(tmpDatatime,happenDate))
			{
				alert("报告时间大于病历时间,不能引用");
				return false;
			}
		}
		
		if (quoteData[item.OEOrdItemDR])
		{
			//收集父内容
			for (var i=0;i<parentList.length;i++)
			{
				result = result + parentList[i].desc + item[parentList[i].code] + parentList[i].separate;
			}
			//收集子表内容
			for (var j=0;j<childList.length;j++)
			{
				if (quoteData[item.OEOrdItemDR][childList[j].code] != undefined)
				{
					result = result + childList[j].desc + quoteData[item.OEOrdItemDR][childList[j].code].replace(/\n/g,"") + childList[j].separate;
					result=reSense(result);
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
		if (!$("#pacsSubData tr td")) return;
		var ordItemId = $("#pacsSubData tr:eq(1)").attr("id");
		if (!ordItemId) return;
		var field = $(obj).parents('th').attr("id");
		var tdNum = $(obj).parents('th')[0].cellIndex; 
		var context = "";
		$("#pacsSubData tr td").each(function() {
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
	$("#pacsData").datagrid("uncheckAll");
}
///检查引用时< >符号转义后的处理
function reSense(val){
	var result=val
	result=result.replace(/&lt/g, '<');
	result=result.replace(/&gt/g, '>');
	return result
}

//open方式打开报告和图像
function reportOrImageLink(url)
{ 
	var xpwidth=window.screen.width-100;
	var xpheight=window.screen.height-100;
	window.open(url,"","width="+xpwidth+",height="+xpheight+",top=50,left=50");
}