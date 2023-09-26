$(function(){
	strXml = convertToXml(scheme);
	var interface =$(strXml).find("interface").text();
	$("#comboxEpisode").hide();
	initEpisodeList("#EpisodeList");
	setDataGrid();
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
        }
    })
    $HUI.radio("#currentEpisode").setValue(true);
});

//设置数据
function setDataGrid()
{			
		var param=getParam();
		$('#nursingReport').datagrid({
			autoSizeColumn:false,
			fitColumns:true,
			loadMsg:'数据装载中......',
			url:'../EMRservice.Ajax.Report.cls',
			queryParams:param,
			autoRowHeight:true,
			rownumbers:true,
	    	pagination:false,
	    	fit:true,
	    	columns:getColumnScheme("scheme>show>item"),
	    	singleSelect:false,
			showFooter:false
			});
}

//获取查询参数
function getParam()
{
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
		EpisodeID: epsodeIds
	};
	return param;	
}

//引用数据
function getData()
{
	var refScheme = getRefScheme("scheme>reference>items>item")
	var checkedItems = $('#nursingReport').datagrid('getChecked');
	var separate = $(strXml).find("scheme>reference>separate").text();
	separate = separate=="enter"?"\n":separate;	
	var result = "";
	$.each(checkedItems, function(index, item)
	{
		for (i=0;i<refScheme.length;i++ )
		{
			var value = item[refScheme[i].code];
			if(value!=""){
			result = result + refScheme[i].desc + value.replace(/&nbsp;/g,"") + refScheme[i].separate;
			}
		}
		if (checkedItems.length-1 > index)
		{
			result = result + "\n";
		}
	});
	var param = {"action":"insertText","text":result}
	parent.eventDispatch(param); 
	UnCheckAll();             
}

//去掉选择
function UnCheckAll()
{
	$("#nursingReport").datagrid("uncheckAll");
}
// 查询
function queryData()
{
	var param = getParam();
    $('#nursingReport').datagrid('load',param);	
}