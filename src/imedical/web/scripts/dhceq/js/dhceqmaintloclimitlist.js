$(document).ready(function () {
	initDocument();
});
function initDocument()
{
	/*
$('#search').searchbox({
        searcher: function (value, name) {
            alertShow(value + ',' + name);
        }});	
	*/
	var SourceType=$('#SourceType').val()
	initCombogrid();
			$('#maintloclimitdatagrid').datagrid({   
		    url:'dhceq.jquery.csp', 
		    /*
		    queryParams:{
		        ClassName:"web.DHCEQFind",
		        QueryName:"GetEQLoc",
		        Arg1:'',
		        Arg2:$("#UseLoc").combogrid('getValue'),
		        Arg3:'',
		        Arg4:'0102',
		        ArgCnt:4
        
		    },*/
		    idField:'Hidden', //主键
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
		    	{field:'Hidden',title:'TRowID',width:50,hidden:true},    
		        {field:'Code',title:'代码',width:100,align:'center'},
		        {field:'Desc',title:'科室名称',width:300,align:'left'}
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

function AddgridData(SourceType)
{
	var rows = $('#maintloclimitdatagrid').datagrid('getChecked');
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
	parent.opener.insertLocRow(SourceType,copyrows)
	alertShow("添加成功！")
}

function findGridData()
{
	$('#maintloclimitdatagrid').datagrid({
		url:'dhceq.jquery.csp',
		queryParams:{
		        ClassName:"web.DHCEQFind",
		        QueryName:"GetEQLoc",
		        Arg1:'',
		        Arg2:$("#UseLoc").combogrid('getText'),
		        Arg3:'',
		        Arg4:'0102',
		        ArgCnt:4
		}
	    });
	
}

