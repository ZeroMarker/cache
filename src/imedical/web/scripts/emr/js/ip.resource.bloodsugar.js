$(function(){
	strXml = convertToXml(scheme);
	var interface =$(strXml).find("interface").text();
	
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
        }
    })
    $HUI.radio("#currentEpisode").setValue(true);	
});

//设置数据
function setDataGrid(interface)
{
	var param = getParam();
	$('#bloodsugar').datagrid({
		width:'100%',
	    height:'100%',
	    pageSize:10,
	    pageList:[10,20,30], 
	    loadMsg:'数据装载中......',
	    autoRowHeight: true,
	    url:'../EMRservice.Ajax.bloodsugar.cls?InterFace='+encodeURI(encodeURI(interface)), 
	    rownumbers:true,
	    pagination:true,
	    singleSelect:false,
	    queryParams:param,
	    fit:true,
	    columns:getColumnScheme("scheme>show>item")
	});
	
}

// 查询
function queryData()
{
	var param = getParam();
	$('#bloodsugar').datagrid('load',param);
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
	var checkedItems = $('#bloodsugar').datagrid('getChecked');
	var separate = $(strXml).find("scheme>reference>separate").text();
	separate = separate=="enter"?"\n":separate;	
	var result = "";
	$.each(checkedItems, function(index, item)
	{
		for (i=0;i<refScheme.length;i++ )
		{
			var value = item[refScheme[i].code];
			result = result + refScheme[i].desc + value.replace(/&nbsp;/g,"") + refScheme[i].separate;
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
	$("#bloodsugar").datagrid("uncheckAll");
}