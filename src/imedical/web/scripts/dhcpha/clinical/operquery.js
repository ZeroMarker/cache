/// Creator: bianshuai
/// CreateDate: 2015-04-14
//  Descript: ������Ŀ��ѯ

var url="dhcpha.clinical.action.csp";
$(function(){
	
	var EpisodeID=getParam("EpisodeID");
	
	//����columns
	var columns=[[
		{field:'EpisodeID',title:'EpisodeID',width:70,align:'left',hidden:true},
	    {field:'OperCode',title:'��������',width:120,align:'left'},
	    {field:'OperDesc',title:'��������',width:150,align:'left'},
	    {field:'OperStartDate',title:'��ʼʱ��',width:130,align:'center'},
	    {field:'OperEndDate',title:'����ʱ��',width:130,align:'center'},
	    {field:'PreDiag',title:'��ǰ���',width:220,align:'left'},
	    {field:'BodsDesc',title:'��λ',width:100,align:'left'},
	    {field:'OperPosition',title:'����λ��',width:100,align:'left'},
	    {field:'qktype',title:'�п�����',width:100,align:'left'}
	]];
	
	// ����datagrid
	$('#operlist').datagrid({
		title:'�����б�',
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true
	});
    $('#operlist').datagrid({
		url:url+'?action=getPatOperList',	
		queryParams:{
			EpisodeID:EpisodeID}
	});
	initScroll("#operlist");//��ʼ����ʾ���������	//sufan 2016/09/12
	$('#operlist').datagrid('loadData', {total:0,rows:[]});
})
