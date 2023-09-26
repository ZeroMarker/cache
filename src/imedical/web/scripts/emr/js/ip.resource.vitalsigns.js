$(function(){
	strXml = convertToXml(scheme);
	var interface =$(strXml).find("interface").text();
	init(interface);
	$HUI.radio("[name='episode']",{
        onChecked:function(e,value){
     		queryData();
        }
    });	
    $HUI.radio("#currentDay").setValue(true);
});
//取生命体征项（查询不大于30项)
function getItems(path)
{
	var codes = ""
	var count = 0;
    var showparent = $(strXml).find(path).each(function(){
	    codes = (count != 0)? codes + "^":codes;
		codes = codes  + $(this).find("code").text();
	    count = count + 1;
    });	
    if (count > 30) {codes = "";}
    return codes
}

//初始化
function init(interface)
{
	Item = getItems("scheme>show>item");
	setDataGrid(interface);
}
//设置数据
function setDataGrid(interface)
{
	var param = getParam();
	$('#vitalsigns').datagrid({ 
		headerCls:'panel-header-gray',
	    pageSize:10,
	    pageList:[10,20,30], 
	    loadMsg:'数据装载中......',
	    autoRowHeight: true,
	    url:'../EMRservice.Ajax.vitalsigns.cls?InterFace='+encodeURI(encodeURI(interface)), 
	    singleSelect:true,
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
	$('#vitalsigns').datagrid('load',param);
}
//获取查询参数
function getParam()
{
	var stDateTime = "",endDateTime = "";
	if ($('#currentDay')[0].checked)
	{
		stDateTime = new Date().format("yyyy-MM-dd");
		endDateTime = new Date().format("yyyy-MM-dd"); 
	}
	else if ($('#fiveDays')[0].checked)
	{
		var start = new Date();
		start.setDate(start.getDate() - 4);
		stDateTime = start.getFullYear() + "-" + (start.getMonth()+1) + "-" + start.getDate()   
		endDateTime = new Date().format("yyyy-MM-dd");
	}
	else if ($('#sevenDays')[0].checked)
	{
		var start = new Date();
		start.setDate(start.getDate() - 6);
		stDateTime = start.getFullYear() + "-" + (start.getMonth()+1) + "-" + start.getDate()   
		endDateTime = new Date().format("yyyy-MM-dd");
	}
	else if ($('#currentWeek')[0].checked)
	{
		var now = new Date();  
		var start = new Date();  
		var n = now.getDay();  
		start.setDate(now.getDate()-n+1);  
		stDateTime = start.getFullYear() + "-" + (start.getMonth()+1) + "-" + start.getDate();   
		endDateTime = new Date().format("yyyy-MM-dd"); 
	}
	else
	{
		stDateTime = ""
		endDateTime = "";		
	}
	var param = {
		Item: Item,
		EpisodeID: episodeID,
		StartDateTime: stDateTime,
		EndDateTime: endDateTime
	};
	return param;		
}
//引用数据
function getData()
{
	var refScheme = getRefScheme("scheme>reference>items>item")
	var separate = $(strXml).find("scheme>reference>separate").text();
	separate = separate=="enter"?"\n":separate;
	var checkedItems = $('#vitalsigns').datagrid('getChecked');
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
	$('#vitalsigns').datagrid('unselectAll');        
}