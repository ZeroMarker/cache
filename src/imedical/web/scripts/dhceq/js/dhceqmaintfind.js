$(document).ready(function () {
	initDocument();
});
function initDocument()
{
	initCombogrid();
	jQuery("#BFind").linkbutton({iconCls: 'icon-search'});
	jQuery("#BFind").on("click", BFind_Clicked);
	jQuery("#BAdd").linkbutton({iconCls: 'icon-add'});
	jQuery("#BAdd").on("click", BAdd_Clicked);
	
	
			$('#maintfinddatagrid').datagrid({   
		    url:'dhceq.jquery.csp', 
		    queryParams:{
		        ClassName:"web.DHCEQMaintNew",
		        QueryName:"GetMaint",
		        Arg1:$("#BussType").val(),
		        Arg2:$("#Equip").combogrid('getValue'),
		        Arg3:$("#MaintLoc").combogrid('getValue'),
		        Arg4:$("#MaintUser").combogrid('getValue'),
		        Arg5:$("#MaintType").combogrid('getValue'),
		        Arg6:$("#StartDate").datebox('getValue'),
		        Arg7:$("#EndDate").datebox('getValue'),
		        Arg8:$("#Status").combobox('getValue'),
		        Arg9:$("#QXType").val(),
		        Arg10:'',
		        Arg11:'',
		        ArgCnt:11
        
		    },
		    idField:'TRowID', //����
		    border:'true',
		    singleSelect:true,
		    fit:true,
		    columns:[[
	   			{field:'TRow',title:'���',width:50,align:'center'}, 
		    	{field:'TRowID',title:'RowID',width:50,hidden:true},    
	   			{field:'TDetail',title:'��ϸ',width:50,align:'center',formatter: mainOperation}, 
	   			{field:'TMaintPlan',title:'�ƻ�����',width:70,align:'center',formatter: mainplanOperation}, 
	   			{field:'TMaintPlanDR',title:'TMaintPlanDR',width:120,align:'center',hidden:true}, 
	   			{field:'TEquipDR',title:'TEquipDR',width:120,align:'center',hidden:true}, 
	   			{field:'TEquipNo',title:'�豸���',width:120,align:'center'}, 
	   			{field:'TEquip',title:'�豸����',width:100,align:'center'}, 
	   			{field:'TModel',title:'����ͺ�',width:70,align:'center'}, 
	   			{field:'TUseLoc',title:'ʹ�ÿ���',width:180,align:'center'}, 
	   			{field:'TMaintDate',title:'��������',width:100,align:'center'}, 
	   			{field:'TMaintLoc',title:'��������',width:180,align:'center'}, 
	   			{field:'TMaintLocDR',title:'TMaintLocDR',align:'center',hidden:true}, 
	   			{field:'TMaintMode',title:'ά�޷�ʽ',width:70,align:'center'}, 
	   			{field:'TMaintType',title:'��������',width:70,align:'center'}, 
	   			{field:'TMaintUser',title:'������',width:70,align:'center'}, 
	   			{field:'TOtherFee',title:'��������',width:70,align:'center'}, 
	   			{field:'TTotalFee',title:'�ܷ���',width:70,align:'center'}, 
	   			{field:'TRemark',title:'��ע',width:100,align:'center'}, 
	   			{field:'TStatus',title:'״̬',width:80,align:'center'}
		    ]],
		    pagination:true,
		    pageSize:15,
		    pageNumber:1,
		    pageList:[15,30,45,60,75]    
		});
    
}

function BAdd_Clicked()
{
	url="dhceqmaint.csp?"+"&BussType=1";
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}	
    window.open(url,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}

function BFind_Clicked()
{
	$('#maintfinddatagrid').datagrid({
		url:'dhceq.jquery.csp',
		queryParams:{
		        Arg1:$("#BussType").val(),
		        Arg2:$("#Equip").combogrid('getValue'),
		        Arg3:$("#MaintLoc").combogrid('getValue'),
		        Arg4:$("#MaintUser").combogrid('getValue'),
		        Arg5:$("#MaintType").combogrid('getValue'),
		        Arg6:$("#StartDate").datebox('getValue'),
		        Arg7:$("#EndDate").datebox('getValue'),
		        Arg8:$("#Status").combobox('getValue'),
		        Arg9:$("#QXType").val(),
		        Arg10:'',
		        Arg11:'',
		        ArgCnt:11
		}
	    });
	
}
function mainplanOperation(value,row,index)
{
	var btn=""
		var para="&ReadOnly=1&BussType=1&SourceType=2&QXType=1&MaintLocDR="+row.TMaintLocDR+"&RowID="+row.TMaintPlanDR;
		var url="dhceq.process.maintplan.csp?";
		url=url+para;		
		btn='<A onclick="OpenNewWindow(&quot;'+url+'&quot;)" href="#">'+row.TMaintPlan+'</A>';
	return btn;
	
}
function mainOperation(value,row,index)
{
	var btn=""
		var para="&BussType=1&EquipDR="+row.TEquipDR+"&RowID="+row.TRowID;
		var url="dhceqmaint.csp?";
		url=url+para;		
		btn='<A onclick="OpenNewWindow(&quot;'+url+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/detail.png" /></A>';
	return btn;
}

