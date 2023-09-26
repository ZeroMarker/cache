jQuery(document).ready(function ()
{
	initComboGridPanel();
	jQuery('#movedetaildatagrid').datagrid(
	{
    	url:'dhceq.jquery.csp',
    	queryParams:{
	        ClassName:"web.DHCEQMoveNew",
	        QueryName:"GetMoveDetail",
	        Arg1:SessionObj.GGROURPID,
	        ArgCnt:1
    	},
		striped:'true',	//�����ƻ�
    	border:'true',
    	singleSelect: 'true',
		//selectOnCheck: 'false',
		//checkOnSelect: 'false',
    	//multiSort:'true',
    	//sortName:'Name',
    	//sortName:'No',
		//remoteSort:false,	//ҳ������
		//sortOrder : 'desc', //����
		//sortOrder : 'asc', //����
    	//rownumbers:'true',
    	toolbar:[{  
                iconCls: 'icon-search',
                text:'��ѯ',
                handler: function(){
                     FindGridData();
                }
    	}],
	    columns:[[
	        {field:'TRow',title:'���',width:40,align:'center'},
	        {field:'TMoveDR',title:'RowID',width:50,hidden:true},
	        {field:'TNo',title:'���͵���',width:100},
	        {field:'TSourceType',title:'ҵ������',width:60,align:'center'},
	        {field:'TEventType',title:'�¼�����',width:60,align:'center'},
	        {field:'TMoveReason',title:'�ƶ�����',width:200},
	        {field:'TStatus',title:'״̬',width:50,align:'center'},
	        {field:'TEQNo',title:'�豸���',width:100,align:'center'},
	        {field:'TEQFileNo',title:'������',width:80,align:'center'},
	        {field:'TEQName',title:'�豸����',width:150},
	        {field:'TFromDeptType',title:'ԭ��λ����',width:70,hidden:true},
	        {field:'TFromDept',title:'��Դ��λ',width:120},
	        {field:'TFromLocation',title:'��Դλ��',width:100},
	        {field:'TStartDate',title:'�ƶ���ʼ����',width:100,align:'center'},
	        {field:'TToLocation',title:'Ŀ��λ��',width:100,align:'center'},
	        {field:'TToDeptType',title:'Ŀ�ĵ�λ����',width:70,hidden:true},
	        {field:'TToDept',title:'Ŀ�ĵ�λ',width:120,editor:'text'},
	        {field:'TEndDate',title:'�ƶ��������',width:100,align:'center'},
	        {field:'TSendUser',title:'�ͳ�������',width:80,align:'center'},
	        {field:'TAcceptUser',title:'���ո�����',width:80,align:'center'},
	        {field:'TRemark',title:'��ע',width:120},
	    ]],
    	
    	pagination:true,
   		pageSize:25,
    	pageNumber:1,
    	pageList:[25,50,75,100]
	});
	
	//��ѯ
	function FindGridData()
	{
		jQuery('#movedetaildatagrid').datagrid({    
	    url:'dhceq.jquery.csp', 
	    queryParams:{
	        ClassName:"web.DHCEQMoveNew",
	        QueryName:"GetMoveDetail",
	        Arg1:SessionObj.GGROURPID,
	        Arg2:jQuery('#No').val(),
	        Arg3:jQuery("#SourceType").combogrid("getValue"),
	        Arg4:jQuery("#EventType").combogrid("getValue"),
	        Arg5:jQuery("#Status").combogrid("getValue"),
	        Arg6:jQuery('#FileNo').val(),
	        Arg7:jQuery('#Name').val(),
	        Arg8:"",	//jQuery('#EQNo').val(),
	        Arg9:jQuery('#FromLoc').combogrid('getValue'),
	        Arg10:jQuery('#ToLoc').combogrid('getValue'),
	        Arg11:jQuery('#SendStartDate').combogrid('getValue'),
	        Arg12:jQuery('#SendEndDate').combogrid('getValue'),
	        Arg13:jQuery('#SendUserdr').val(),
	        Arg14:jQuery('#AcceptStartDate').combogrid('getValue'),
	        Arg15:jQuery('#AcceptEndDate').combogrid('getValue'),
	        Arg16:jQuery('#AcceptUserdr').val(),
	        ArgCnt:16
	    },
	    border:'true',
	    singleSelect:true});
	}
});
function initComboGridPanel()
{
	jQuery("input[name='combogrid']").each(function() { 
		var options=eval('(' + jQuery(this).attr("data-options") + ')');
		jQuery(this).initComboGrid(options);
	});
}