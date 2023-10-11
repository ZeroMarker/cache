var PatholSubItems= "";
$(function(){
	strXml = convertToXml(scheme);
	var interface =$(strXml).find("interface").text();
    $HUI.radio("#oneMonth").setValue(true);
	setDataGrid(interface);
});

//设置数据 
function setDataGrid(interface)
{
	var param = getParam();
	$('#patholData').datagrid({
	    pageSize:10,
	    pageList:[10,20,30], 
	    loadMsg:'数据装载中......',
	    autoRowHeight: true,
	    url:'../EMRservice.Ajax.pathology.cls?Action=GetPatholData&InterFace='+encodeURI(encodeURI(interface)), 
	    rownumbers:true,
	    pagination:true,
	    singleSelect:false,
	    queryParams:param,
	    idField:'tmid',
	    fit:true,
	    columns:getColumnScheme("show>parent>item"),
	   	onSelect:function(rowIndex,rowData){
		    var appTmid = rowData.tmid;
		    quoteData[appTmid]={};
			getPatholSubData(interface,appTmid,rowData.EpisodeID);
		},
		onUnselect:function(rowIndex,rowData){
			$("#patholSubData  tr:not(:first)").detach();
			delete quoteData[rowData.tmid];
		},
		onCheckAll:function(rows)
		{
			quoteData = {};
			var length = rows.length; 
			for(i = 0; i < length; i ++){ 
				quoteData[rows[i].tmid] = {};	
				getPatholSubData(interface,rows[i].tmid,rows[i].EpisodeID);			
			}
		},
		onUncheckAll:function(rows)
		{
			$("#patholSubData  tr:not(:first)").detach();
			quoteData = {};	
		}
	});
	initPatholSubTable();
}
//初始化检查子项
function initPatholSubTable()
{
	var tr = $("<tr></tr>");
	patholSubItems = getColumnScheme("show>child>item")
	var patholSubRefScheme = getRefScheme("reference>child>item");
	var td = "<th style='border-bottom:#999 1px dotted;border-right:#999 1px dotted;background-color:#F5F5F5;width:15px;'></th>"
	$(tr).append(td);
	for (var i=1;i<patholSubItems[0].length;i++)
	{
		var	td = "";		
		if (patholSubItems[0][i].hidden)
		{ 
			td= "<th id='" +patholSubItems[0][i].field+ "' style='display:none;' ><input class='hisui-checkbox' type='checkbox' name='SubPathol' label='" + patholSubItems[0][i].title + "'/></th>"    
		}
		else
		{
			td= "<th id='" +patholSubItems[0][i].field+ "' style='width:" +patholSubItems[0][i].width+ ";'><input class='hisui-checkbox' type='checkbox' name='SubPathol' data-options='onCheckChange:function(event,value){checkOnClick(this)}' label='" + patholSubItems[0][i].title + "'/></th>" 			
		}
		$(tr).append(td);
	}
	$("#patholSubData").append(tr);
	$.parser.parse('#patholSubData');
	for (var i=1;i<patholSubItems[0].length; i++)
	{
		if (patholSubItems[0][i].check)
		{ 
			var code = patholSubItems[0][i].field;
			$HUI.checkbox('#'+ code+ " input").setValue(true);
		}
	}
}
// 取检验结果
function getPatholSubData(Interface,ID,EpisodeID)
{
	jQuery.ajax({
		type: "GET",
		dataType: "text",
		url: "../EMRservice.Ajax.pathology.cls?InterFace="+encodeURI(encodeURI(Interface)),
		async: true,
		data: {"Action":"GetSubPathol","ID":ID,"EpisodeID":EpisodeID},
		success: function(d){setPatholSubData(eval("("+d+")"));},
		error: function(d){alert("error");}
	});
}

//检查子项赋值
function setPatholSubData(data)
{
	$("#patholSubData  tr:not(:first)").detach();
	for (var i=0;i<data.rows.length;i++)
	{
		var tr = $("<tr></tr>");
		$(tr).attr("id",data.rows[i].Tmrowid);
		var td = "";
		if (data.rows.length>1)
		{
			td = "<td id='" +data.rows[i].Tmrowid+ "' name='"+i+"'><input type='checkbox' name='rowcheck' checked='true' onclick='rowcheckOnClick(this)' />" + "</td>"
		}
		else
		{
			td = "<td></td>";
		}
		$(tr).append(td);
		var td = ""; 
		for (var j=1;j<patholSubItems[0].length;j++)
		{
			if (patholSubItems[0][j].hidden)
			{
				td = "<td style='display:none;'>" + data.rows[i][patholSubItems[0][j].field] +"</td>";	
			}
			else
			{
				td = "<td>" + data.rows[i][patholSubItems[0][j].field] +"</td>";	
			}
			$(tr).append(td);
		}
		$("#patholSubData").append(tr);
		quoteData[data.rows[i].Tmrowid][i] = {};
		quoteData[data.rows[i].Tmrowid].length = i+1;
		$("#patholSubData tr th:not(:first)").each(function(){
			if ($(this).find("input")[0].checked)
			{
				var field = $(this).attr("id");
				quoteData[data.rows[i].Tmrowid][i][field] = data.rows[i][field];	
			}
		});
	}
}

// 查询
function queryData()
{
	var param = getParam();
    if (param){
        $('#patholData').datagrid('load',param);
    }
}
//获取查询参数
function getParam()
{
    var param = "";
    var epsodeIds = episodeID;
    var appStDate = $("#stDate").datebox('getValue');
    var appEndDate = $("#endDate").datebox('getValue');
    if (!$('#currentEpisode')[0].checked)
    {
        epsodeIds = getAllEpisodeIdByPatientId();
    }
    if ("" != appStDate){
        appStDate = getHISDateTimeFormate("Date",appStDate);
    }
    if ("" != appEndDate){
        appEndDate = getHISDateTimeFormate("Date",appEndDate);
    }
    if (("" != appStDate)&&("" != appEndDate)){
        if (!compareDateTime(appStDate+" 00:00:00",appEndDate+" 00:00:00"))
        {
            $.messager.alert("提示信息", "申请开始日期大于申请结束日期,请重新选择起始日期!");
            return param;
        }
    }
    quoteData = {};
    param = {
        EpisodeIDS: epsodeIds,
        AppStDate: appStDate,
        AppEndDate: appEndDate
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
	var checkedItems = $('#patholData').datagrid('getChecked');
	$.each(checkedItems, function(index, item){
		if (quoteData[item.tmid])
		{
			//收集父内容
			for (var i=0;i<parentList.length;i++)
			{
				result = result + parentList[i].desc + item[parentList[i].code] + parentList[i].separate;
			}
			if (result!="")
			{
				result = result + ",";
			}
			//收集子表内容
			for (i=0;i<quoteData[item.tmid].length;i++)
			{
				for (var j=0;j<childList.length;j++)
				{
					if (quoteData[item.tmid][i][childList[j].code])
					{
						result = result + childList[j].desc + quoteData[item.tmid][i][childList[j].code].replace(/\n/g,"") + childList[j].separate;
					}
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

//选择列的子项目，改变缓存内容
function checkOnClick(obj)
{
	try
	{	
		if (!$("#patholSubData tr td")) return;
		var ordItemId = $("#patholSubData tr:eq(1)").attr("id");
		if (!ordItemId) return;
		var field = $(obj).parents('th').attr("id");
		var tdNum = $(obj).parents('th')[0].cellIndex;
		var context = {};
		var number = 0;
		$("#patholSubData tr td:not(:first)").each(function() {
			if ($(this)[0].cellIndex == tdNum)
			{
				context[number] = $(this).text();
				number = number + 1;
			}	
		});
		if (obj.checked)
		{
			var rownumber = 0 ;
			if (quoteData[ordItemId].length > 1)
			{
				$("#patholSubData tr").find("td:eq(0)").each(function(){
					if ($(this).find("input")[0].checked)
					{
						quoteData[ordItemId][rownumber][field] = context[rownumber];	
					}
					rownumber = rownumber + 1;
				});
			}
			else
			{
				quoteData[ordItemId][0][field] = context[0];
			}
		}
		else
		{
			for (i=0;i<quoteData[ordItemId].length;i++)
			{
				if (quoteData[ordItemId][i][field])
				{
					delete quoteData[ordItemId][i][field];
				}
			}
		}
	}
	catch(err)
	{
	}	
}

//选择行的子项目，改变缓存内容
function rowcheckOnClick(obj)
{
	try
	{
		var thistr = obj.parentNode.parentNode;
		var rownum = thistr.rowIndex - 1;
		var rowItemId = $(obj).parent().attr("id");
		var contend = {};
		var number = 0;
		
		var showChildList = getColumnScheme("show>child>item")
		
		$(obj).parent().parent().find("td").each(function() {
			contend[showChildList[0][number].field] = $(this).text();
			number = number + 1;
		});
		var childList = getRefScheme("reference>child>item");
		if (obj.checked)
		{
			$("#patholSubData tr th:not(:first)").each(function(){
			if ($(this).find("input")[0].checked)
			{
				var field = $(this).attr("id");
				quoteData[rowItemId][rownum][field] = contend[field];	
			}
			});
		}
		else
		{
			for (var j=0;j<childList.length;j++)
			{
				if (quoteData[rowItemId][rownum][childList[j].code])
				{
					delete quoteData[rowItemId][rownum][childList[j].code]
				}
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
	$("#patholData").datagrid("uncheckAll");
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
