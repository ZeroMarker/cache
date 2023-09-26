$(function(){
	strXml = convertToXml(scheme);
	var interface =$(strXml).find("interface").text();
	init(interface);
	
});
//取每日症状项（查询不大于30项)
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
	setDataGrid(interface);
}
//设置数据
function setDataGrid(interface)
{
	var param = getParam();
	$('#patsympInfo').datagrid({ 
	    width:'100%',
	    height:'100%', 
	    pageSize:10,
	    pageList:[10,20,30], 
	    loadMsg:'数据装载中......',
	    autoRowHeight: true,
	    url:'../EMRservice.Ajax.patsympInfo.cls?Action=GetPatSympInfo&InterFace='+encodeURI(encodeURI(interface))+'&EpisodeID='+episodeID, 
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
	$('#patsympInfo').datagrid('load',param);
}
//获取查询参数
function getParam()
{
	var reqDate = $('#reqDate').datebox('getText');
	var param = {
		Date: reqDate,
		EpisodeID: episodeID
	};
	return param;		
}
//引用数据
function getData()
{
	var refScheme = getRefScheme("scheme>reference>items>item")
	var separate = $(strXml).find("scheme>reference>separate").text();
	separate = separate=="enter"?"\n":separate;
	var checkedItems = $('#patsympInfo').datagrid('getChecked');
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
	$('#patsympInfo').datagrid('unselectAll');        
}

//获取当前日期的前p_count天
function FunGetDateStr(p_count) {
    var dateNow = new Date();
    dateNow.setDate(dateNow.getDate() - p_count);//获取p_count天后的日期 
    var y = dateNow.getFullYear();
    var m = dateNow.getMonth() + 1;//获取当前月份的日期 
    var d = dateNow.getDate();
	return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
   
}

//获取当天的每日症状  
function getCurrent()
{
	var date = FunGetDateStr(0);
	$('#reqDate').datebox('setValue',date);
	queryData();
}

//获取所选时间的前一天的每日症状  
function getBefore()
{
	var date = GetJsDate(1);
	$('#reqDate').datebox('setValue',date);
	queryData();
}

//获取所选时间的后一天的每日症状  
function getAfter()
{
	var date = GetJsDate(-1);
	$('#reqDate').datebox('setValue',date);
	queryData();
}

//获取本次就诊的每日症状  
function getEpisode()
{
	$('#reqDate').datebox("setValue", '');
	queryData();
}

function onSelect(date){
	queryData();
}

//获取所选时间的前p_count天
function GetJsDate(p_count) {
    var s = $('#reqDate').datebox('getText');
    var ss = s.split('-');
	var yy = parseInt(ss[0],10);
	var mm = parseInt(ss[1],10)-1;
	var dd = parseInt(ss[2],10);
    dd = dd - p_count;

	var dateNow = new Date();
    dateNow.setFullYear(yy);
    dateNow.setMonth(mm);
    dateNow.setDate(dd);//获取p_count天后的日期 
    
    var y = dateNow.getFullYear();
    var m = dateNow.getMonth() + 1;//获取当前月份的日期 
    var d = dateNow.getDate();
	return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
   
}