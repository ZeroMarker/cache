$(document).ready(function () {
	initDocument();
});
function initDocument()
{
	var SourceType=$('#SourceType').val()
	initCombogrid();
    $('#maintlimitequipdatagrid').datagrid({   
	url:'dhceq.jquery.csp', 
	idField:'RowID', //����
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
    	{field:'RowID',title:'TRowID',width:50,hidden:true},    
        {field:'Name',title:'����',width:100,align:'center'},
        {field:'TNo',title:'�豸���',width:100,align:'center'},
        {field:'LeaveFactoryNo',title:'sv��',width:100,align:'center'},
        {field:'TEquipType',title:'����',width:100,align:'center'},
        {field:'Model',title:'����',width:100,align:'center'},
        {field:'UseLoc',title:'ʹ�ÿ���',width:100,align:'center'},
        
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
		alertShow("δ��ѡ���ݣ�")
		return;	
	}
	parent.opener.insertEquipRow(SourceType,copyrows)
	alertShow("��ӳɹ���")
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
