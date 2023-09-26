$(document).ready(function () {
	initDocument();
});
function initDocument()
{
    $('#maintlimitequipdatagrid').datagrid({   
	url:'dhceq.jquery.csp', 
	idField:'RowID', //主键
	border:'true',
	singleSelect:true,
	selectOnCheck: false,
	queryParams:{
	     ClassName:"web.DHCEQEquip",
	     QueryName:"GetEquip",
	     Arg1:'', Arg2:$("#EquipStr").val(),Arg3:'',Arg4:'',Arg5:$("#LocStr").val(),Arg6:'',Arg7:'',Arg8:$("#EquipTypeStr").val(),Arg9:'',Arg10:$("#StatCatStr").val(),Arg11:$("#MastitemStr").val(),
	     ArgCnt:11
	},
	    columns:[[
    	{field:'RowID',title:'TRowID',width:50,hidden:true},    
        {field:'Name',title:'名称',width:100,align:'center'},
        {field:'TNo',title:'设备编号',width:100,align:'center'},
        {field:'LeaveFactoryNo',title:'sv码',width:100,align:'center'},
        {field:'TEquipType',title:'类组',width:100,align:'center'},
        {field:'Model',title:'机型',width:100,align:'center'},
        {field:'UseLoc',title:'使用科室',width:100,align:'center'},
        
   		 ]],
	    onClickRow : function (rowIndex, rowData) {
	        managelimitlistdatagrid_OnClickRow();
	    }, 
	    pagination:true,
	    pageSize:15,
	    pageNumber:1,
	    pageList:[15,30,45,60,75]    
	});
		
			
}

