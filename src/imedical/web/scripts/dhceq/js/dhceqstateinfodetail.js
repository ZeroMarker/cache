jQuery(document).ready(function ()
{
	initComboGridPanel();
	jQuery('#FileNo').validatebox({width: 160});
	jQuery('#No').validatebox({width: 160});
	jQuery('#Name').validatebox({width: 160});
	jQuery("#BFind").on("click", FindGridData);
	
	jQuery('#stateinfodatagrid').datagrid(
	{
    	url:'dhceq.jquery.csp',
    	queryParams:{
	        ClassName:"web.DHCEQStateInfo",
	        QueryName:"GetStateInfo",
	        Arg1:jQuery('#FileNo').val(),
	        Arg2:jQuery('#No').val(),
	        Arg3:jQuery('#Name').val(),
	        Arg4:"",
	        Arg5:1,
	        ArgCnt:5
    	},
    	rowStyler:function(index,rowObj)
		{
			if ((rowObj.EndStateInfo!="")&&(rowObj.EndStateInfo!="正常"))
			{
				return 'color:rgb(255,0,0);font-weight:bold;';
			}
		},
		striped:'true',	//行条纹化
    	border:'true',
    	singleSelect: false,
		selectOnCheck: false,
		checkOnSelect: false,
    	//multiSort:'true',
    	//sortName:'Name',
    	//sortName:'No',
		//remoteSort:false,	//页面排序
		//sortOrder : 'desc', //升序
		//sortOrder : 'asc', //降序
    	//rownumbers:'true',
	    columns:[[
	        {field:'Row',title:'序号',width:40,align:'center'},
	        {field:'RowID',title:'RowID',width:50,hidden:true},
	        {field:'EquipDR',title:'EquipDR',width:50,hidden:true},
	        {field:'Name',title:'设备名称',width:120},
	        {field:'FileNo',title:'档案号',width:60,align:'center'},
	        {field:'No',title:'设备编号',width:100},
	        {field:'Model',title:'规格型号',width:120},
	        //{field:'LeaveFactoryNo',title:'出厂编号',width:150},
	        {field:'StoreLoc',title:'所属科室',width:110},
	        {field:'EquipType',title:'类组',width:100,align:'center',hidden:true},
	        {field:'RecordDate',title:'登记日期',width:100,align:'center',editor:'datebox',hidden:true},
	        {field:'StartDate',title:'开机日期',width:70,align:'center',editor:'datebox'},
	        {field:'StartTime',title:'开机时间',width:70,align:'center',editor:'text'},
	        {field:'EndDate',title:'关机日期',width:70,align:'center',editor:'datebox'},
	        {field:'EndTime',title:'关机时间',width:70,align:'center',editor:'text'},
	        {field:'TotalTime',title:'使用时间(小时)',width:100,align:'center'},
	        {field:'UseContent',title:'使用内容',width:100,editor:'text'},
	        {field:'EndStateInfo',title:'设备状况',width:100,editor:'text'},
	        {field:'UserDR',title:'UserDR',width:100,align:'center',hidden:true},
			{field:'User',title:'使用人',width:70},
	    ]],
    	
    	pagination:true,
   		pageSize:25,
    	pageNumber:1,
    	pageList:[25,50,75,100]
	});
	
	//查询
	function FindGridData()
	{
		jQuery('#stateinfodatagrid').datagrid({    
	    url:'dhceq.jquery.csp', 
	    queryParams:{
	        ClassName:"web.DHCEQStateInfo",
	        QueryName:"GetStateInfo",
	        Arg1:jQuery('#FileNo').val(),
	        Arg2:jQuery('#No').val(),
	        Arg3:jQuery('#Name').val(),
	        Arg4:"",
	        Arg5:1,
	        Arg6:jQuery('#Loc').combogrid('getValue'),
	        Arg7:jQuery('#User').combogrid('getValue'),
	        Arg8:jQuery('#StartDate').combogrid('getValue'),
	        Arg9:jQuery('#EndDate').combogrid('getValue'),
	        ArgCnt:9
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