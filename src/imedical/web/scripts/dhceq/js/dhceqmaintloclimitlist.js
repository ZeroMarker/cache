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
		    idField:'Hidden', //����
		    border:'true',
		    singleSelect:true,
		    selectOnCheck: false, 
			toolbar:[{  
			    		iconCls: 'icon-search', 
			            text:'��ѯ',          
			            handler: function(){
			                  findGridData();
			            }   
			            },'------------------------',{   
		                id:"add",
			            iconCls: 'icon-add', 
			            text:'���',      
			            handler: function(){
			                 AddgridData(SourceType);
			               }      
			             }] , 
		    columns:[[
	   			{field:'TCheckFlag',title:'TCheckFlag',width:50,align:'center',checkbox:true}, 
		    	{field:'Hidden',title:'TRowID',width:50,hidden:true},    
		        {field:'Code',title:'����',width:100,align:'center'},
		        {field:'Desc',title:'��������',width:300,align:'left'}
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
		alertShow("δ��ѡ���ݣ�")
		return;	
	}
	parent.opener.insertLocRow(SourceType,copyrows)
	alertShow("��ӳɹ���")
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

