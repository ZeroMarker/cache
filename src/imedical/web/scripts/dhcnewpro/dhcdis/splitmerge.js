///Creator: zhanghailong
///CreateDate:2017-02-22
 var req=getParam("reqs");
$(document).ready(function() {
	
	//��ʼ��easyui datagrid
	initTable()

});

//��ʼ��datagrid
function initTable(){
	
	var columns = [[
	 {checkbox:'true',align: 'center',title: 'ѡ��',width: 120},
     {field: 'itmdrdesc',align: 'center',title: '������Ŀ',width: 180},
     {field: 'LocDesc',align: 'center',title: 'ȥ�����',width: 180},
     {field: 'num',align: 'center',title: '����',width: 150} 
     ]]
    $('#up').datagrid({
	   
	    url:LINK_CSP+'?ClassName=web.DHCDISSplitMerge&MethodName=GetInfo&mergeid='+req,
	    fit:true,
	    rownumbers:true,
	    columns:columns,
	    pageSize:20, // ÿҳ��ʾ�ļ�¼����
	    pageList:[20,40],   // ��������ÿҳ��¼�������б�
	    loadMsg: '���ڼ�����Ϣ...',
	    pagination:true
	})
	var columns = [[
	 {checkbox:'true',align: 'center',title: 'ѡ��',width: 120},
     {field: 'itmdrdesc',align: 'center',title: '������Ŀ',width: 180},
     {field: 'LocDesc',align: 'center',title: 'ȥ�����',width: 180},
     {field: 'num',align: 'center',title: '����',width: 150} 
     ]]
    
    $('#down').datagrid({
	    url:LINK_CSP+'?ClassName=web.DHCDISSplitMerge&MethodName=GetMerge&mergeid='+req,
	    fit:true,
	    rownumbers:true,
	    columns:columns,
	    pageSize:20, // ÿҳ��ʾ�ļ�¼����
	    pageList:[20,40],   // ��������ÿҳ��¼�������б�
	    loadMsg: '���ڼ�����Ϣ...',
	    pagination:true
	})
}

///���� 
function save(){
	alert(0)
}