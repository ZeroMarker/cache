/// Creator: bianshuai
/// CreateDate: 2015-04-14
//  Descript: ������Ŀ��ѯ

var url="dhcpha.clinical.action.csp";
if ("undefined"!==typeof(websys_getMWToken)){
	url += "?MWToken="+websys_getMWToken()
	}
$(function(){
	
	var EpisodeID=getParam("EpisodeID");
	
	//����columns
	var columns=[[
		{field:'EpisodeID',title:'EpisodeID',width:70,align:'left',hidden:true},
	    {field:'OperCode',title:$g('��������'),width:120,align:'left'},
	    {field:'OperDesc',title:$g('��������'),width:150,align:'left'},
	    {field:'OperStartDate',title:$g('��ʼʱ��'),width:130,align:'center'},
	    {field:'OperEndDate',title:$g('����ʱ��'),width:130,align:'center'},
	    {field:'PreDiag',title:$g('��ǰ���'),width:220,align:'left'},
	    {field:'BodsDesc',title:$g('��λ'),width:100,align:'left'},
	    {field:'OperPosition',title:$g('����λ��'),width:100,align:'left'},
	    {field:'qktype',title:$g('�п�����'),width:100,align:'left'}
	]];
	
	// ����datagrid
	$('#operlist').datagrid({
		title:$g('�����б�'),
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: $g('���ڼ�����Ϣ...'),
		pagination:true
	});
    $('#operlist').datagrid({
		url:url+'&action=getPatOperList',	
		queryParams:{
			EpisodeID:EpisodeID}
	});
	initScroll("#operlist");//��ʼ����ʾ���������	//sufan 2016/09/12
	$('#operlist').datagrid('loadData', {total:0,rows:[]});
})
