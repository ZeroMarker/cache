$(function(){
	strXml = convertToXml(scheme);
	var interface =$(strXml).find("interface").text();
	//$('#currentEpisode').attr("checked",true);
	$("#comboxEpisode").hide();
	initEpisodeList("#EpisodeList");
	setDataGird(interface);
		
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
    });	
    
    $HUI.radio("#currentEpisode").setValue(true);
});
	
///初始化界面
function setDataGird(interface)
{
	var columns = getColumnScheme("scheme>show>item");
	var param = getParam();
	$("#zorders").datagrid({ 
	    headerCls:'panel-header-gray',
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
	    sortName:'OrdCreateDate,OrdCreateTime',
	    sortOrder:'desc',
	    view: detailview,
	    detailFormatter: function(rowIndex, rowData){
	        var strs = new Array(); //定义一数组
			strs = rowData.ArcimDesc.split(","); //字符分割
			var content = "";
			for (i=0;i<strs.length;i++ )
			{
				content = content + '<p>' + strs[i] + '</p>'
			}
	        return '<table><tr><td rowspan=1 style="border:0;font-size:13px;">' +
	                content + '</td>' + '</tr></table>';
	    }
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
	var resultItems = new Array();
	var refScheme = getRefScheme("scheme>reference>items>item")
	var separate = $(strXml).find("scheme>reference>separate").text();
	separate = separate=="enter"?"\n":separate;
	var blankspace = $(strXml).find("scheme>reference>space").text();
	var rowlength = $(strXml).find("scheme>reference>rowlength").text();
	if (rowlength == "") {rowlength = 15;}
	var checkedItems = $("#zorders").datagrid('getChecked');
	var result = "";
	$.each(checkedItems, function(index, item){
		for (i=0;i<refScheme.length;i++ ){ 
			//判断引用字段是否为空
			if (item[refScheme[i].code] != "")
			{
				var str = "";
				if (refScheme[i].code == "ArcimDesc")
				{
					str = item[refScheme[i].code].split(",");
					for (var j=0;j<str.length;j++)
					{
						var strlength = str[j].split(" ")[0].replace(/[^\x00-\xff]/g,"ab").length + str[j].split(" ")[1].length;
						if (typeof(str[j].split(" ")[2]) !== 'undefined') strlength = strlength + str[j].split(" ")[2].replace(/[^\x00-\xff]/g,"ab").length;
						var strDesc = "";
						if (blankspace == "Y")
						{
							if (str[j].split(" ")[0].replace(/[^\x00-\xff]/g,"ab").length == 4)
							{
								strDesc = str[j].charAt(0) + "    " + str[j].charAt(1);
								strlength = strlength + 4;
							}
							else if (str[j].split(" ")[0].replace(/[^\x00-\xff]/g,"ab").length == 6)
							{
								strDesc = str[j].charAt(0) + " " + str[j].charAt(1) + " " + str[j].charAt(2);
								strlength = strlength + 2;
							}
							else
							{
								strDesc = str[j].split(" ")[0];
							}
								
							if (typeof(str[j].split(" ")[2]) !== 'undefined')
							{
								
								if (Remarks == "Y")
								{
									result = result + strDesc + str[j].split(" ")[1];
									resultItems.push({"TEXT":result});
									resultItems.push({"STYLE":["SUPER"],"TEXT":str[j].split(" ")[2]});
									strDesc = "";
								}
								else
								{
									result = result + strDesc;
									resultItems.push({"TEXT":result});
									resultItems.push({"STYLE":["SUPER"],"TEXT":str[j].split(" ")[2]});
									strDesc = " " + str[j].split(" ")[1];
								}	
							}
							else 
							{
								strDesc = result + strDesc + " " + str[j].split(" ")[1];
							}
							
							var space = rowlength - strlength;
							if (strlength<rowlength){
								for(var n=0;n<space;n++){
									strDesc = strDesc + " ";
								}
							}else{
								strDesc = strDesc + " ";
							}
							result = strDesc;
							if (!((j+1)%4) && (j!=str.length-1)) result = result.substring(0,result.length-space) + separate;
							if (j == str.length-1) result = result.substring(0,result.length-space);
						}
						else if(blankspace == "N")
						{
							if (j == 0) result = result + "        ";
							if (typeof(str[j].split(" ")[2]) !== 'undefined')
							{
								
								if (Remarks == "Y")
								{
									result = result + strDesc + str[j].split(" ")[1];
									resultItems.push({"TEXT":result});
									resultItems.push({"STYLE":["SUPER"],"TEXT":str[j].split(" ")[2]});
									strDesc = "";
								}
								
								else
								{
									result = result + strDesc;
									resultItems.push({"TEXT":result});
									resultItems.push({"STYLE":["SUPER"],"TEXT":str[j].split(" ")[2]});
									strDesc = " " + str[j].split(" ")[1];
								}
							}
							else 
							{
								strDesc = result + strDesc + " " + str[j].split(" ")[1];
							}
							var space = rowlength - strlength;
							if (strlength<rowlength)
							{
								for(var n=0;n<space;n++){
									strDesc = strDesc + " ";
								}
							}
							else
							{
								strDesc = strDesc + "  ";
							}
							result = strDesc;
							if (!((j+1)%4) && (j!=str.length-1)) result = result.substring(0,result.length-space) + separate + "        ";
							if (j == str.length-1) result = result.substring(0,result.length-space);
						}
					}
					if (blankspace == "Y")
					{
						result = result + separate;
					}
					else if(blankspace == "N")
					{
						result = result + separate + "        ";
					}
				}
				else
				{
					result = result + refScheme[i].desc + item[refScheme[i].code] + refScheme[i].separate;	
				}
			}
			else if (i == refScheme.length-1)
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
	resultItems.push({"TEXT":result});
	var param = {"action":"INSERT_STYLE_TEXT_BLOCK","args":{"items":resultItems}};
	parent.eventDispatch(param);            
	//去掉选择
	$("#zorders").datagrid("uncheckAll");         
}
