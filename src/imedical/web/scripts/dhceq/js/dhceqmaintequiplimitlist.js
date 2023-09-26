$(document).ready(function () {
	initDocument();
});
function initDocument()
{
	var SourceType=$('#SourceType').val()
	initCombogrid();
    $('#maintlimitequipdatagrid').datagrid({   
	url:'dhceq.jquery.csp', 
	idField:'RowID', //主键
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
    	{field:'RowID',title:'TRowID',width:50,hidden:true},    
        {field:'Name',title:'名称',width:100,align:'center'},
        {field:'TNo',title:'设备编号',width:100,align:'center'},
        {field:'LeaveFactoryNo',title:'sv码',width:100,align:'center'},
        {field:'TEquipType',title:'类组',width:100,align:'center'},
        {field:'Model',title:'机型',width:100,align:'center'},
        {field:'UseLoc',title:'使用科室',width:100,align:'center'},
        
   		 ]],
	    pagination:true,
	    pageSize:15,
	    pageNumber:1,
	    pageList:[15,30,45,60,75]    
	});
		
			
}

function AddgridData(SourceType)
{
	var rows = $('#maintlimitequipdatagrid').datagrid('getChecked');
	var vallist=""
    var copyrows=[]
	
	if (rows!="")
	{
		for(var i=0;i<rows.length;i++)
		{
			
			copyrows.push(rows[i]);
		}

	}
	else
	{
		alertShow("未勾选数据！")
		return;	
	}
	parent.opener.insertEquipRow(SourceType,copyrows)
	alertShow("添加成功！")
}

function findGridData()
{
	$('#maintlimitequipdatagrid').datagrid({
		url:'dhceq.jquery.csp',
		queryParams:{
	        ClassName:"web.DHCEQEquip",
	        QueryName:"GetEquip",
	        Arg1:$("#EquipName").val(), Arg2:'',Arg3:$("#Model").combogrid('getValue'),Arg4:'',Arg5:$("#UseLoc").combogrid('getValue'),Arg6:'',Arg7:'',Arg8:$("#EquipType").combogrid('getValue'),Arg9:$("#No").val(),
	        ArgCnt:9
		}
	    });
	
}
