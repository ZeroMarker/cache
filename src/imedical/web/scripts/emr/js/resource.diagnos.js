$(function(){
	strXml = convertToXml(scheme);
	var interface =$(strXml).find("interface").text();
	init(interface);

	$('#seekform').find(':radio').change(function () {
		if (this.id == "allEpisode")
		{
			$("#comboxEpisode").show();
		}
		else
		{
			$("#comboxEpisode").hide();
 			$("#EpisodeList").combogrid('hidePanel');
			queryData();
		}
	});	 
});

//初始化
function init(interface)
{
	$("#currentEpisode").attr("checked",true);
	$("#layer").attr("checked",true);
	$("#comboxEpisode").hide();
	initEpisodeList("#EpisodeList");
	setDataGrid(interface);	
	queryData();	
}

//设置数据
function setDataGrid(interface)
{
	var param = getParam();
	$('#diagnos').datagrid({ 
	    width:'100%',
	    height:'100%', 
	    pageSize:10,
	    pageList:[10,20,30], 
	    loadMsg:'数据装载中......',
	    autoRowHeight: true,
	    url:'../EMRservice.Ajax.diagnos.cls?InterFace='+encodeURI(encodeURI(interface)), 
	    singleSelect:true,
	    queryParams:param,
	    rownumbers:true,
	    pagination:true,
	    singleSelect:false,
	    idField:'ARowID',
	    fit:true,
	    columns:getColumnScheme("scheme>show>item"),
	    onLoadSuccess:function(data){               
            var rowData = data.rows;
            $.each(rowData,function(idx,val){
	            var space = "";
	            for (var i=1;i<val.ALevel;i++)
	            {
		            space = space + '&nbsp;&nbsp;';
		        }
				$('#diagnos').datagrid('updateRow',{
					index: idx,
					row: {ADiagnosName: space+ val.ADiagnosName}
				});
           });              
        }
  });
}
// 查询
function queryData()
{
	var param = getParam();
	$('#diagnos').datagrid('load',param);
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
			//epsodeIds = epsodeIds +((i==0)?"":",");
			//epsodeIds = epsodeIds + values[i];
			epsodeIds = epsodeIds +((i==0)?"":",") + values[i];
		}
	}
	var param = {
		EpisodeIDs: epsodeIds
	};
	return param;	
}
//引用数据
function getData()
{
	var refScheme = getRefScheme("scheme>reference>items>item")
	var checkedItems = $('#diagnos').datagrid('getChecked');
	if ($('#layer').attr('checked') == "checked")
	{
		var separate = $(strXml).find("scheme>reference>separate>layermode").text();
		separate = separate=="enter"?"\n":separate;
	}
	if ($('#row').attr('checked') == "checked")
	{
		var separate = $(strXml).find("scheme>reference>separate>rowmode").text();
		separate = separate=="enter"?"\n":separate;
	}
	var result = "";
	$.each(checkedItems, function(index, item){
		for (i=0;i<refScheme.length;i++ ){ 
			var desc = refScheme[i].desc;
			var value = item[refScheme[i].code];
			var demo = item["ADemo"]
			if (demo != "") demo = "("+demo+")";
			if (refScheme[i].code == "ADiagnosName")
			{
				if ($('#row')[0].checked)
				{
					value = value.replace(/&nbsp;/g,"");
				}
				else
				{
					value = value.replace(/&nbsp;/g," ");
				}
			}
			value = value + demo;
			result = result + desc + value + refScheme[i].separate;
		}
		if (checkedItems.length-1 > index)
		{
			result = result + separate;
		}
	}); 	
	var param = {"action":"insertText","text":result}
	parent.eventDispatch(param);            
}