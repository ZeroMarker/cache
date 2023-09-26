$(function(){
	strXml = convertToXml(scheme);
	var interface =$(strXml).find("interface").text();
	$('#currentEpisode').attr("checked",true);
	$("#comboxEpisode").hide();
	initEpisodeList("#EpisodeList");
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
	});
	setDataGrid(interface);		
});

//设置数据
function setDataGrid(interface)
{
	var param = getParam();
	$('#cureinfo').datagrid({ 
	    width:'100%',
	    height:'100%', 
	    pageSize:10,
	    pageList:[10,20,30], 
	    loadMsg:'数据装载中......',
	    autoRowHeight: true,
	    url:'../EMRservice.Ajax.patcureinfo.cls?InterFace='+encodeURI(encodeURI(interface)), 
	    queryParams:param,
	    rownumbers:true,
	    pagination:true,
	    singleSelect:false,
	    fit:true,
	    columns:getColumnScheme("scheme>show>item")
  });
}
// 查询
function queryData()
{
	var param = getParam();
	$('#cureinfo').datagrid('load',param);
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
	var separate = $(strXml).find("scheme>reference>separate").text();
	separate = separate=="enter"?"\n":separate;
	var checkedItems = $('#cureinfo').datagrid('getChecked');
	var result = "";
	$.each(checkedItems, function(index, item){
		for (i=0;i<refScheme.length;i++ ){ 
			if (item[refScheme[i].code]!="")
			{
				result = result + refScheme[i].desc + item[refScheme[i].code] + refScheme[i].separate;
			}
		}
		if (checkedItems.length-1 > index)
		{
			result = result + separate;
		}
	}); 
	var param = {"action":"insertText","text":result}
	parent.eventDispatch(param);  
	$('#cureinfo').datagrid('unselectAll');        
}