/// Creator:bianshuai
/// CreateDate;2014-09-09
/// Descript:ҩ��׫дjs���ο����Ӳ�����д����

//����Url
var url="dhcpha.clinical.action.csp";

$(function(){
	InitPatList();  //��ʼ�������б�
});

//��ʼ�������б�
function InitPatList()
{
	//����columns
	var columns=[[
		{field:'Bed',title:'����',width:80},
		{field:'PatNo',title:'�ǼǺ�',width:80},
		{field:'PatName',title:'����',width:80},
		{field:'PatientID',title:'PatientID',width:80},
		{field:'AdmDr',title:'AdmDr',width:80}
	]];
	
	//����datagrid
	$('#patList').datagrid({
		//title:'�����б�',    
		url:'',
		fit:true,
		//fitColumns:true,
		rownumbers:true,
		columns:columns,
		pageSize:30,  // ÿҳ��ʾ�ļ�¼����
		pageList:[30,45],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		onDblClickRow:function(rowIndex, rowData){ 
			var EpisodeID=rowData.AdmDr;
			var PatientID=rowData.PatientID;;
			InvokeMedReacord(PatientID,EpisodeID);
		}
	});
	
	initScroll("#patList");//��ʼ����ʾ���������
	var params=LgWardID;
	$('#patList').datagrid({
		url:'dhcpha.clinical.action.csp?action=QueryWardPatList',	
		queryParams:{
			params:params}
	});
}
/*
/// ����ҩ��ģ��
function InvokeMedReacord(patientID,episodeID)
{
	var InsVal="";
	var EpisodeVal=episodeID;
	var CategoryVal="";
	var content = '<iframe width=100% height=100% src=dhcst.episodebrowser.csp?EpisodeID='+ EpisodeVal+' frameborder=0 framespacing=0></iframe>';
	$('#mainpanel').html(content);
}*/
/// ����ҩ��ģ��
function InvokeMedReacord(patientID,episodeID)
{
	var InsVal="";
	var EpisodeVal=episodeID;
	var PatientVal=patientID;
	var CategoryVal="";
	var content = '<iframe width=100% height=100% src=dhcmed.epr.newfw.centertablistdetial.csp?PatientID='+PatientVal+'&EpisodeID='+EpisodeVal+'&TemplateID=525&CategoryID=337&CategoryType=Group&ChartItemID=ML315&ProfileID=ML315&TemplateName=ҩ��&TemplateDocID=765 frameborder=0 framespacing=0></iframe>';
	$('#mainpanel').html(content);
}