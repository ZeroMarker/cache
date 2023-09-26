$(function(){
	strXml = convertToXml(scheme);
	init();
	$('#seekform').find(':radio').change(function () {
		queryData();
	});
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
function init()
{
	$("#currentDay").attr("checked",true);
	Item = getItems("scheme>show>item");
	setDataGrid();	
	queryData();
}

//设置数据
function setDataGrid()
{
	$('#vitalsigns').datagrid({ 
	    width:'100%',
	    height:'100%', 
	    pageSize:10,
	    pageList:[10,20,30], 
	    loadMsg:'数据装载中......',
	    autoRowHeight: true,
	    url:'../EMRservice.Ajax.vitalsigns.cls', 
	    singleSelect:true,
	    rownumbers:true,
	    pagination:true,
	    singleSelect:false,
	    idField:'Date',
	    fit:true,
	    columns:getColumnScheme("scheme>show>item")
  });
}
// 查询
function queryData()
{
	var stDateTime = "",endDateTime = "";
	if ($('#currentDay')[0].checked)
	{
		stDateTime = new Date().format("yyyy-MM-dd");
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
	$('#vitalsigns').datagrid('load',{
		Item: Item,
		EpisodeID: episodeID,
		StartDateTime: stDateTime,
		EndDateTime: endDateTime
	});		
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
			result = result + refScheme[i].desc + item[refScheme[i].code] + refScheme[i].separate;
		}
		result = result + separate;
	}); 
	var param = {"action":"insertText","text":result};
	invoker.eventDispatch(param);            
}