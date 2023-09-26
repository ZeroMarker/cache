$(function(){
	strXml = convertToXml(scheme);
	var interface =$(strXml).find("interface").text();
	$('#currentEpisode').attr("checked",true);
	$("#comboxEpisode").hide();
	initEpisodeList("#EpisodeList");
	setDataGird(interface);	
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
});


	
///初始化界面
function setDataGird(interface)
{
	var columns = getColumnScheme("scheme>show>item");
	var param = getParam();
	$("#zorders").datagrid({ 
	    width:'100%',
	    height:'100%', 
	    pageSize:10,
	    pageList:[10,20,30], 
	    loadMsg:'数据装载中......',
	    autoRowHeight: true,
	    url:'../EMRservice.Ajax.orderData.cls?Action=GetOrderData&OrderType=Z&InterFace='+encodeURI(encodeURI(interface)),
	    rownumbers:true,
	    pagination:true,
	    singleSelect:false,
	    queryParams:param,
	    idField:'OEItemID',
	    fit:true,
	    columns:columns,
	    remoteSort:false,
	    sortName:['OrdCreateDate','OrdCreateTime'],
	    sortOrder:'desc'
  });
}
// 查询
function queryData()
{
	var param = getParam();
	$('#zorders').datagrid('load',param);
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
		EpisodeID:epsodeIds
	};
	return param;		
}

//引用数据
function getData()
{
	var refScheme = getRefScheme("scheme>reference>items>item")
	var separate = $(strXml).find("scheme>reference>separate").text();
	separate = separate=="enter"?"\n":separate;
	var blankspace = $(strXml).find("scheme>reference>space").text();
	var checkedItems = $("#zorders").datagrid('getChecked');
	var result = "";
	$.each(checkedItems, function(index, item){
		for (i=0;i<refScheme.length;i++ ){ 
			//判断引用字段是否为空
			if (item[refScheme[i].code] != "")
			{
				var str = "";
				if (refScheme[i].code == "ArcimDesc"){
					str = item[refScheme[i].code].split(",");
					for (var j=0;j<str.length;j++)
					{
						var strlength = str[j].split(" ")[0].length*2 + str[j].split(" ")[1].length;
						if (blankspace == "Y"){
							if (str[j].split(" ")[0].length == 2){
								str[j] = str[j].charAt(0) + "    " + str[j].charAt(1) + str[j].substring(2);
								strlength = strlength + 4;
							}
							if (str[j].split(" ")[0].length == 3){
								str[j] = str[j].charAt(0) + " " + str[j].charAt(1) + " " + str[j].charAt(2) + str[j].substring(3);
								strlength = strlength + 2;
							}
							var space = 18 - strlength;
							if (strlength<18){
								for(var n=0;n<space;n++){
									str[j] = str[j] + " ";
								}
							}
							result = result + str[j];
							if (!((j+1)%4) && (j!=str.length-1)) result = result.substring(0,result.length-space) + separate;
							if (j == str.length-1) result = result.substring(0,result.length-space);
						}else if(blankspace == "N"){
							if (j == 0) result = result + "        ";
							var space = 15 - strlength;
							str[j] = str[j].replace(" ","");
							if (strlength<15){
								for(var n=0;n<space;n++){
									str[j] = str[j] + " ";
								}
							}
							result = result + str[j];
							if (!((j+1)%4) && (j!=str.length-1)) result = result.substring(0,result.length-space) + separate + "        ";
							if (j == str.length-1) result = result.substring(0,result.length-space);
						}
					}
					if (blankspace == "Y"){
						result = result + separate;
					}else 
					if(blankspace == "N"){
						result = result + separate + "        ";
					}
				}
				else{
					result = result + refScheme[i].desc + item[refScheme[i].code] + refScheme[i].separate;	
				}
			}else if (i == refScheme.length-1)
			{
				if ((result != "")&&(item[refScheme[i].code] == ""))
				{
					result = result.substring(0,result.length-1);
				}
			}
		}
		if (checkedItems.length-1 > index)
		{
			result = result + separate;
		}
	}); 
	var param = {"action":"insertText","text":result}
	parent.eventDispatch(param);            
	//去掉选择
	$("#zorders").datagrid("uncheckAll");         
}
