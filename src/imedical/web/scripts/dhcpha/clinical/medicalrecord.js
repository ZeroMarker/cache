/// Creator:bianshuai
/// CreateDate;2014-09-09
/// Descript:药历撰写js、参考电子病历书写界面

//定义Url
var url="dhcpha.clinical.action.csp";

$(function(){
	InitPatList();  //初始化病人列表
});

//初始化病人列表
function InitPatList()
{
	//定义columns
	var columns=[[
		{field:'Bed',title:'床号',width:80},
		{field:'PatNo',title:'登记号',width:80},
		{field:'PatName',title:'姓名',width:80},
		{field:'PatientID',title:'PatientID',width:80},
		{field:'AdmDr',title:'AdmDr',width:80}
	]];
	
	//定义datagrid
	$('#patList').datagrid({
		//title:'病人列表',    
		url:'',
		fit:true,
		//fitColumns:true,
		rownumbers:true,
		columns:columns,
		pageSize:30,  // 每页显示的记录条数
		pageList:[30,45],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
		onDblClickRow:function(rowIndex, rowData){ 
			var EpisodeID=rowData.AdmDr;
			var PatientID=rowData.PatientID;;
			InvokeMedReacord(PatientID,EpisodeID);
		}
	});
	
	initScroll("#patList");//初始化显示横向滚动条
	var params=LgWardID;
	$('#patList').datagrid({
		url:'dhcpha.clinical.action.csp?action=QueryWardPatList',	
		queryParams:{
			params:params}
	});
}
/*
/// 调用药历模板
function InvokeMedReacord(patientID,episodeID)
{
	var InsVal="";
	var EpisodeVal=episodeID;
	var CategoryVal="";
	var content = '<iframe width=100% height=100% src=dhcst.episodebrowser.csp?EpisodeID='+ EpisodeVal+' frameborder=0 framespacing=0></iframe>';
	$('#mainpanel').html(content);
}*/
/// 调用药历模板
function InvokeMedReacord(patientID,episodeID)
{
	var InsVal="";
	var EpisodeVal=episodeID;
	var PatientVal=patientID;
	var CategoryVal="";
	var content = '<iframe width=100% height=100% src=dhcmed.epr.newfw.centertablistdetial.csp?PatientID='+PatientVal+'&EpisodeID='+EpisodeVal+'&TemplateID=525&CategoryID=337&CategoryType=Group&ChartItemID=ML315&ProfileID=ML315&TemplateName=药历&TemplateDocID=765 frameborder=0 framespacing=0></iframe>';
	$('#mainpanel').html(content);
}