///Creator: zhanghailong
///CreateDate:2017-02-22
 var req=getParam("reqs");
$(document).ready(function() {
	
	//初始化easyui datagrid
	initTable()

});

//初始化datagrid
function initTable(){
	
	var columns = [[
	 {checkbox:'true',align: 'center',title: '选择',width: 120},
     {field: 'itmdrdesc',align: 'center',title: '配送项目',width: 180},
     {field: 'LocDesc',align: 'center',title: '去向科室',width: 180},
     {field: 'num',align: 'center',title: '数量',width: 150} 
     ]]
    $('#up').datagrid({
	   
	    url:LINK_CSP+'?ClassName=web.DHCDISSplitMerge&MethodName=GetInfo&mergeid='+req,
	    fit:true,
	    rownumbers:true,
	    columns:columns,
	    pageSize:20, // 每页显示的记录条数
	    pageList:[20,40],   // 可以设置每页记录条数的列表
	    loadMsg: '正在加载信息...',
	    pagination:true
	})
	var columns = [[
	 {checkbox:'true',align: 'center',title: '选择',width: 120},
     {field: 'itmdrdesc',align: 'center',title: '配送项目',width: 180},
     {field: 'LocDesc',align: 'center',title: '去向科室',width: 180},
     {field: 'num',align: 'center',title: '数量',width: 150} 
     ]]
    
    $('#down').datagrid({
	    url:LINK_CSP+'?ClassName=web.DHCDISSplitMerge&MethodName=GetMerge&mergeid='+req,
	    fit:true,
	    rownumbers:true,
	    columns:columns,
	    pageSize:20, // 每页显示的记录条数
	    pageList:[20,40],   // 可以设置每页记录条数的列表
	    loadMsg: '正在加载信息...',
	    pagination:true
	})
}

///保存 
function save(){
	alert(0)
}