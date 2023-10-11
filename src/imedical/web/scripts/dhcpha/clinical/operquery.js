/// Creator: bianshuai
/// CreateDate: 2015-04-14
//  Descript: 手术项目查询

var url="dhcpha.clinical.action.csp";
if ("undefined"!==typeof(websys_getMWToken)){
	url += "?MWToken="+websys_getMWToken()
	}
$(function(){
	
	var EpisodeID=getParam("EpisodeID");
	
	//定义columns
	var columns=[[
		{field:'EpisodeID',title:'EpisodeID',width:70,align:'left',hidden:true},
	    {field:'OperCode',title:$g('手术编码'),width:120,align:'left'},
	    {field:'OperDesc',title:$g('手术名称'),width:150,align:'left'},
	    {field:'OperStartDate',title:$g('开始时间'),width:130,align:'center'},
	    {field:'OperEndDate',title:$g('结束时间'),width:130,align:'center'},
	    {field:'PreDiag',title:$g('术前诊断'),width:220,align:'left'},
	    {field:'BodsDesc',title:$g('部位'),width:100,align:'left'},
	    {field:'OperPosition',title:$g('身体位置'),width:100,align:'left'},
	    {field:'qktype',title:$g('切口类型'),width:100,align:'left'}
	]];
	
	// 定义datagrid
	$('#operlist').datagrid({
		title:$g('手术列表'),
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: $g('正在加载信息...'),
		pagination:true
	});
    $('#operlist').datagrid({
		url:url+'&action=getPatOperList',	
		queryParams:{
			EpisodeID:EpisodeID}
	});
	initScroll("#operlist");//初始化显示横向滚动条	//sufan 2016/09/12
	$('#operlist').datagrid('loadData', {total:0,rows:[]});
})
