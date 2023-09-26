$(document).ready(function () {
	initDocument();
});
function initDocument()
{
	var SourceType=$('#SourceType').val()
	initCombogrid();
		$('#maintlimitmasteritemdatagrid').datagrid({   
	    url:'dhceq.jquery.csp', 
	    idField:'TRowID', //主键
	    border:'true',
	    singleSelect:true,
	    selectOnCheck: false,
	    toolbar:[{  
	    			iconCls: 'icon-search', 
	                text:'查询',          
	                handler: function(){
	                     findGridData();
	                }   
	                },'------------------------',{   
                 	id:"add",
	                iconCls: 'icon-add', 
	                text:'添加',      
	                 handler: function(){
	                    AddgridData(SourceType);
	                     }      
	                 }] , 
	    columns:[[
	    {field:'TCheckFlag',title:'TCheckFlag',width:50,align:'center',checkbox:true}, 
    	{field:'TRowID',title:'TRowID',width:50,hidden:true},    
        {field:'TDesc',title:'名称',width:300,align:'left'},
        {field:'TEquipType',title:'类组',width:100,align:'center'},
        {field:'TStatCat',title:'类型',width:100,align:'center'},
        {field:'TCat',title:'分类',width:100,align:'center'}
   		 ]],
	    pagination:true,
	    pageSize:15,
	    pageNumber:1,
	    pageList:[15,30,45,60,75]    
	});
		
			
}

function AddgridData(SourceType)
{
	var rows = $('#maintlimitmasteritemdatagrid').datagrid('getChecked');
	var vallist=""
    var copyrows=[]
	
	if (rows!="")
	{
		for(var i=0;i<rows.length;i++)
		{
			
			copyrows.push(rows[i]);
		}

		/*
		$.each(rows, function(rowIndex, rowData){
			if (SourceType==1){ var TRowID=rowData.Hidden}
			else if (SourceType==2){ var TRowID=rowData.TRowID}
			else if (SourceType==3){ var TRowID=rowData.RowID}
			
			if (vallist=="")
			{ 
				vallist=TRowID;
			}
			 else vallist=vallist+","+TRowID; 
		}); */
	}
	else
	{
		alertShow("未勾选数据！")
		return;	
	}
	parent.opener.insertMastitemRow(SourceType,copyrows)
	alertShow("添加成功！")

}

function findGridData()
{
	$('#maintlimitmasteritemdatagrid').datagrid({
		url:'dhceq.jquery.csp',
		queryParams:{
	        ClassName:"web.DHCEQCMasterItem",
	        QueryName:"MasterItem",
	        Arg1:'', Arg2:$("#MasterItem").combogrid('getText'),Arg3:'',Arg4:$("#EquipType").combogrid('getValue'),Arg5:'',Arg6:'',Arg7:'',
	        Arg8:'',Arg9:'',Arg10:'',Arg11:'',Arg12:'',Arg13:'',Arg14:'',Arg15:'',
	        ArgCnt:15
		}
	    });
	
}

