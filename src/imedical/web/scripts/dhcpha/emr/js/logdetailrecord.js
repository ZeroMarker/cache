$(function()
{
	if ('getAllLog'==action) {
		var getdata_url = '../EMRservice.Ajax.logdetailrecord.cls?Action=getAllLog&EpisodeID=' + episodeId;
	}
	else {
		var getdata_url = '../EMRservice.Ajax.logdetailrecord.cls?Action=getDetialLog&EpisodeID=' + episodeId + '&EMRDocID=' + emrDocId + '&EMRNum=' + emrNum;
	}
	showLogDetail(getdata_url);
	
});
///日志操作记录明细
function showLogDetail(getdata_url)
{
	$("#detailGrid").datagrid({
		fitColumns:true,
		loadMsg:'数据装载中......',
		autoRowHeight:true,
		url:getdata_url,
		singleSelect:true,
		idField:'OrderID',
		columns:[[
			{field:'OrderID',title:'顺序号',width:55,sortable:true,type:'int'},
			{field:'LoginUserName',title:'登录医师',width:75,sortable:true},
			{field:'OperUserName',title:'操作医师',width:75,sortable:true},
			{field:'OperDate',title:'操作日期',width:75,sortable:true},
			{field:'OperTime',title:'操作时间',width:70,sortable:true},
			{field:'MachineIP',title:'IP地址',width:85,sortable:true},
			{field:'Action',title:'操作名称',width:95,sortable:true},
			{field:'TplName',title:'模板名称',width:120,sortable:true,resizable: true},
			{field:'TplCreateDate',title:'创建日期',width:75,sortable:true},
			{field:'TplCreateTime',title:'创建时间',width:75,sortable:true}
		]]
	});
}