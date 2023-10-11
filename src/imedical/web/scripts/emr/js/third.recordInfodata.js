$(function(){
	strXml = convertToXml(scheme);
	setDataGrid();
});

//设置数据
function setDataGrid()
{
	$('#appRecordInfoData').datagrid({
        width:'100%',
        height:'100%',
	    loadMsg:'数据装载中......',
	    autoRowHeight: true,
	    url:'../EMRservice.Ajax.appRecordInfoData.cls?Action=GetAppRecordInfoData&EpisodeID='+episodeID, 
	    singleSelect:false,
	    fit:true,
	    columns:getColumnScheme("show>item"),
		onLoadSuccess:function(){
            $('#appRecordInfoData').datagrid('selectAll');
        },
        onLoadError: function (XMLHttpRequest, textStatus, errorThrown) {
            
        }
	});
}

// 查询
function refresh()
{
	$('#appRecordInfoData').datagrid('load');
}

//引用数据
function getData()
{
	var logInfo = new Array();
	var arr = new Array();
	var result = "";
	var checkedItems = $('#appRecordInfoData').datagrid('getChecked');
	$.each(checkedItems, function(index, item){
		var obj = {
			"SectionName" : item.Name,
			"SectionText" : item.Value.split("<xmp>")[1].split("</xmp>")[0].replace(/<br>/g,"\n")
			}
		arr.push(obj);
		
		if (item.RecordID !== "")
		{
			var string = item.RecordID+'^'+item.Name
			logInfo.push(string);
		}
	}); 	
	
	var QuoteInfo = logInfo.join('|');
	if (QuoteInfo !== "")
	{
		var data = ajaxDATA('String', 'EMRservice.Ajax.appRecordInfoData', 'SaveRecordQuoteInfo', episodeID,userID,userLocID,QuoteInfo);
	    ajaxGETSync(data, function (ret) {
		    if (ret == "-1")
		    {
				alert('引用数据日志存储失败，请联系系统管理员查看原因！')    
			}
	    }, function (ret) {
	        alert('saveRecordQuoteInfo error:' + ret);
	    });
	}
	
	var param =  {"action":"INSERT_SECTION_BY_NAME","data":arr}
	parent.eventDispatch(param);
	
	//去掉选择
	UnCheckAll();
}

//去掉选择
function UnCheckAll()
{
	$("#appRecordInfoData").datagrid("uncheckAll");
}