var pacsSubItems= "";
$(function(){
    strXml = convertToXml(scheme);
    var interface = $(strXml).find("interface").text();
    pageConfig = $(strXml).find("pageConfig").text();
    
    if (pageConfig == "Y") {
        //获取其它资源区的查询按钮配置项数据
        resourceConfig = getResourceConfig();
        var configItem = resourceConfig.Pacs;
        if ((configItem != "")&&(configItem != undefined))
        {
            $HUI.radio("#"+configItem).setValue(true);
        }else{
            $HUI.radio("#oneMonth").setValue(true);
        }
    }else{
        $HUI.radio("#oneMonth").setValue(true);
    }
    //获取医嘱分类数据
    getpacsCategoryData();
    setDataGrid(interface);

    $('#pacsDataPnl').panel('resize', {
        height: $('#dataPnl').height() * 0.60
    });
 
    $('body').layout('resize');
});

//设置数据
function setDataGrid(interface)
{
    var param = getParam();
    $('#pacsData').datagrid({
        pageSize:10,
        pageList:[10,20,30], 
        loadMsg:'数据装载中......',
        autoRowHeight: true,
        url:'../EMRservice.Ajax.pacsData.cls?Action=GetPacsData&InterFace='+encodeURI(encodeURI(interface)),
        rownumbers:true,
        pagination:true,
        singleSelect:false,
        queryParams:param,
        idField:'OEOrdItemDR',
        fit:true,
        columns:getColumnScheme("show>parent>item"),
        onSelect:function(rowIndex,rowData){
            var ordItemId = rowData.OEOrdItemDR;
            quoteData[ordItemId]={};
            getPacsSubData(interface,rowData.EpisodeID,ordItemId);
        },
        onUnselect:function(rowIndex,rowData){
            $("#pacsSubData  tr:not(:first)").empty();
            delete quoteData[rowData.OEOrdItemDR];
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
            $("#pacsSubData tr:not(:first)").empty();
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
			if (pacsSubRefScheme[i].check){
			var code = pacsSubRefScheme[i].code;
			$HUI.checkbox('#'+ code+ " input").setValue(true);
			}
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
    if (param){
        $('#pacsData').datagrid('load',param);
    }
}
//获取查询参数
function getParam()
{
    var param = "";
    var epsodeIds = episodeID;
    var rrtStDate = $("#stDate").datebox("getValue");
    var rrtEndDate = $("#endDate").datebox("getValue");
    if (!$("#currentEpisode")[0].checked)
    {
        epsodeIds = getAllEpisodeIdByPatientId();
    }
    if ("" != rrtStDate){
        rrtStDate = getHISDateTimeFormate("Date",rrtStDate);
    }
    if ("" != rrtEndDate){
        rrtEndDate = getHISDateTimeFormate("Date",rrtEndDate);
    }
    if (("" != rrtStDate)&&("" != rrtEndDate)){
        if (!compareDateTime(rrtStDate+" 00:00:00",rrtEndDate+" 00:00:00"))
        {
            $.messager.alert("提示信息", "报告开始日期大于报告结束日期,请重新选择起始日期!");
            return param;
        }
    }
    var pacscategoryID = "";
    if($("#pacsCategory"))
	{
		pacscategoryID = $("#pacsCategory").combobox('getValue');
	}
    quoteData = {};
    param = {
        EpisodeIDS: epsodeIds,
        StartDateTime: "",
        EndDateTime: "",
        RrtStartDateTime: rrtStDate,
        RrtEndDateTime: rrtEndDate,
        PacscategoryID:pacscategoryID
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
    var checkedItems = $('#pacsData').datagrid('getChecked');
    $.each(checkedItems, function(index, item){
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
                }
            }
            if (checkedItems.length-1 > index)
            {
                result = result + separate;
            }
        }
    });
	//还原后台转义字符
	result = result.split("&lt").join("<");
    result = result.split("&gt").join(">");
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
        var field = $(obj).parent().attr("id");
        var tdNum = $(obj).parent()[0].cellIndex; 
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

//open方式打开报告和图像
function reportOrImageLink(url)
{ 
	var xpwidth=window.screen.width-100;
	var xpheight=window.screen.height-100;
	window.open(url,"","width="+xpwidth+",height="+xpheight+",top=50,left=50");
}

//设置报告日期
function upPacsDate(e,sel,val){
    if(!sel) return;
    if(val==1){
        $HUI.datebox("#stDate").setValue(formatDate(-30));
        $HUI.datebox("#endDate").setValue(formatDate(0));
    }
    
    if(val==2){
        $HUI.datebox("#stDate").setValue(formatDate(-90));
        $HUI.datebox("#endDate").setValue(formatDate(0));
    }
    
    if(val==3){
        $HUI.datebox("#stDate").setValue(formatDate(-180));
        $HUI.datebox("#endDate").setValue(formatDate(0));
    }
    
    if(val==4){
        $HUI.datebox("#stDate").setValue("");
        $HUI.datebox("#endDate").setValue("");
    }
    if (initFlag){
        queryData();
    }else{
        initFlag = true;
    }
    if (pageConfig == "Y") {
        resourceConfig.Pacs = e.target.id;
        saveResourceConfig("Pacs");
    }
    return;
}

/// 格式化日期
function formatDate(t){
    var curr_Date = new Date();  
    curr_Date.setDate(curr_Date.getDate() + parseInt(t)); 
    var Year = curr_Date.getFullYear();
    var Month = curr_Date.getMonth()+1;
    var Day = curr_Date.getDate();
    
    if(typeof(DateFormat)=="undefined"){
        return Year+"-"+Month+"-"+Day;
    }else{
        if(DateFormat=="4"){
            //日期格式 4:"DMY" DD/MM/YYYY
            return Day+"/"+Month+"/"+Year;
        }else if(DateFormat=="3"){
            //日期格式 3:"YMD" YYYY-MM-DD
            return Year+"-"+Month+"-"+Day;
        }else if(DateFormat=="1"){
            //日期格式 1:"MDY" MM/DD/YYYY
            return Month+"/"+Day+"/"+Year;
        }else{
            return Year+"-"+Month+"-"+Day;
        }
    }
}
//通过接口获取医嘱分类数据
function getpacsCategoryData()
{
	var result = "";
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"web.DHCAPPSeePatPacs",
			"Method":"GetOrdType",
			"p1":"2"
		},
		success: function(d) {
			if (d != "")
			{
				result = eval("("+d+")");
				initpacsCategory(result);
			}	
		},
		error: function(d) {alert("error");}
	});	
	return result;	
}
//初始化医嘱分类下拉框
function initpacsCategory(data)
{
	$("#pacsCategory").combobox({
		valueField:"value",
		textField:"text",
		data:data,
		filter: function (q, row) {
            var opts = $(this).combobox('options');
            return (row["text"].toLowerCase().indexOf(q.toLowerCase()) >= 0)||(row[opts.textField].toLowerCase().indexOf(q.toLowerCase()) >= 0);
        }
	});
	
}