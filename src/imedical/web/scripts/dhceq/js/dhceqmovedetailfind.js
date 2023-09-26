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
		striped:'true',	//行条纹化
    	border:'true',
    	singleSelect: 'true',
		//selectOnCheck: 'false',
		//checkOnSelect: 'false',
    	//multiSort:'true',
    	//sortName:'Name',
    	//sortName:'No',
		//remoteSort:false,	//页面排序
		//sortOrder : 'desc', //升序
		//sortOrder : 'asc', //降序
    	//rownumbers:'true',
    	toolbar:[{  
                iconCls: 'icon-search',
                text:'查询',
                handler: function(){
                     FindGridData();
                }
    	}],
	    columns:[[
	        {field:'TRow',title:'序号',width:40,align:'center'},
	        {field:'TMoveDR',title:'RowID',width:50,hidden:true},
	        {field:'TNo',title:'配送单号',width:100},
	        {field:'TSourceType',title:'业务类型',width:60,align:'center'},
	        {field:'TEventType',title:'事件类型',width:60,align:'center'},
	        {field:'TMoveReason',title:'移动事由',width:200},
	        {field:'TStatus',title:'状态',width:50,align:'center'},
	        {field:'TEQNo',title:'设备编号',width:100,align:'center'},
	        {field:'TEQFileNo',title:'档案号',width:80,align:'center'},
	        {field:'TEQName',title:'设备名称',width:150},
	        {field:'TFromDeptType',title:'原单位类型',width:70,hidden:true},
	        {field:'TFromDept',title:'来源单位',width:120},
	        {field:'TFromLocation',title:'来源位置',width:100},
	        {field:'TStartDate',title:'移动开始日期',width:100,align:'center'},
	        {field:'TToLocation',title:'目的位置',width:100,align:'center'},
	        {field:'TToDeptType',title:'目的单位类型',width:70,hidden:true},
	        {field:'TToDept',title:'目的单位',width:120,editor:'text'},
	        {field:'TEndDate',title:'移动完成日期',width:100,align:'center'},
	        {field:'TSendUser',title:'送出负责人',width:80,align:'center'},
	        {field:'TAcceptUser',title:'接收负责人',width:80,align:'center'},
	        {field:'TRemark',title:'备注',width:120},
	    ]],
    	
    	pagination:true,
   		pageSize:25,
    	pageNumber:1,
    	pageList:[25,50,75,100]
	});
	
	//查询
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