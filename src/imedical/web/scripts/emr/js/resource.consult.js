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
	$('#consult').datagrid({
		width:'100%',
	    height:'100%',
	    pageSize:10,
	    pageList:[10,20,30], 
	    loadMsg:'数据装载中......',
	    autoRowHeight: true,
	    url:'../EMRservice.Ajax.consult.cls?InterFace='+encodeURI(encodeURI(interface)), 
	    rownumbers:true,
	    pagination:false,
	    singleSelect:false,
	    checkOnSelect:false,
	    queryParams:param,
	    fit:true,
	    nowrap: false,
	    columns:getColumnScheme("scheme>show>item"),
	    view : detailview,
		detailFormatter: function(rowIndex, rowData){
					return  '<div class="detailText" style="font-size:12px;overflow:auto;max-height:150px;">'+
							'<p style="line-height:18px;letter-spacing:1px;">'+'<span>会诊目的:</span>'+'  '+rowData.ConDestination+'</p>'+
							'<p style="line-height:18px;letter-spacing:1px;">'+'<span>会诊意见:</span>'+'  '+rowData.Attitude+'</p>'+
							'</div>';
				}
	});
}

// 查询
function queryData()
{
	var param = getParam();
	$('#consult').datagrid('load',param);
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
	var checkedItems = $('#consult').datagrid('getChecked');
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
	$("#consult").datagrid("uncheckAll");
}
