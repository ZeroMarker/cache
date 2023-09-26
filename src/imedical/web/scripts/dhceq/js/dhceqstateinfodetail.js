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
			if ((rowObj.EndStateInfo!="")&&(rowObj.EndStateInfo!="����"))
			{
				return 'color:rgb(255,0,0);font-weight:bold;';
			}
		},
		striped:'true',	//�����ƻ�
    	border:'true',
    	singleSelect: false,
		selectOnCheck: false,
		checkOnSelect: false,
    	//multiSort:'true',
    	//sortName:'Name',
    	//sortName:'No',
		//remoteSort:false,	//ҳ������
		//sortOrder : 'desc', //����
		//sortOrder : 'asc', //����
    	//rownumbers:'true',
	    columns:[[
	        {field:'Row',title:'���',width:40,align:'center'},
	        {field:'RowID',title:'RowID',width:50,hidden:true},
	        {field:'EquipDR',title:'EquipDR',width:50,hidden:true},
	        {field:'Name',title:'�豸����',width:120},
	        {field:'FileNo',title:'������',width:60,align:'center'},
	        {field:'No',title:'�豸���',width:100},
	        {field:'Model',title:'����ͺ�',width:120},
	        //{field:'LeaveFactoryNo',title:'�������',width:150},
	        {field:'StoreLoc',title:'��������',width:110},
	        {field:'EquipType',title:'����',width:100,align:'center',hidden:true},
	        {field:'RecordDate',title:'�Ǽ�����',width:100,align:'center',editor:'datebox',hidden:true},
	        {field:'StartDate',title:'��������',width:70,align:'center',editor:'datebox'},
	        {field:'StartTime',title:'����ʱ��',width:70,align:'center',editor:'text'},
	        {field:'EndDate',title:'�ػ�����',width:70,align:'center',editor:'datebox'},
	        {field:'EndTime',title:'�ػ�ʱ��',width:70,align:'center',editor:'text'},
	        {field:'TotalTime',title:'ʹ��ʱ��(Сʱ)',width:100,align:'center'},
	        {field:'UseContent',title:'ʹ������',width:100,editor:'text'},
	        {field:'EndStateInfo',title:'�豸״��',width:100,editor:'text'},
	        {field:'UserDR',title:'UserDR',width:100,align:'center',hidden:true},
			{field:'User',title:'ʹ����',width:70},
	    ]],
    	
    	pagination:true,
   		pageSize:25,
    	pageNumber:1,
    	pageList:[25,50,75,100]
	});
	
	//��ѯ
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