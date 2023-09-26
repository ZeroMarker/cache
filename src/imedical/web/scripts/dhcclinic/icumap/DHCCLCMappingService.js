$(document).ready(function () {
InitForm();
var SelectedRowID = 0;
var preRowID=0;
var RowId="";
function servicedatagrid_OnClickRow()
{
	
	var selected=$('#servicedatagrid').datagrid('getSelected');
	if(selected)
	{
		var SelectedRowID=selected.RowId;
		if(preRowID!=SelectedRowID)
		{
			RowId=SelectedRowID;
			$("#CLCMSCode").textbox("setValue",selected.Code);
			$("#CLCMSDesc").textbox("setValue",selected.Desc);
			$("#CLCMSType").combogrid("setValue",selected.Type);
			preRowID=SelectedRowID;
		}
		else{
			RowId="";
			$('#CLCMSCode').textbox('setValue',"");
			$('#CLCMSDesc').textbox('setValue',"");
			$('#CLCMSType').combogrid('setValue',"");
            SelectedRowID = 0;
            preRowID=0;			
		}
	}
}
$('#servicedatagrid').datagrid({    
    url:'dhcclinic.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCCLMappingData",
        QueryName:"FindMappingService",
        ArgCnt:0
    },
    border:'true',
    singleSelect:true,
    toolbar:[{          
                iconCls: 'icon-add',
                text:'����',          
                handler: function(){
                     AddgridData();
                }   
                },'----',{         
                iconCls: 'icon-edit', 
                text:'�޸�',      
                 handler: function(){
                     UpdategridData();
                     }      
                 },'----',{        
                iconCls: 'icon-cut', 
                text:'ɾ��',      
                 handler: function(){
                     DeleteGridData();
                     }      
                 }],
    columns:[[    
        {field:'Code',title:'����',width:120},    
        {field:'Desc',title:'����',width:120},    
        {field:'Type',title:'����',width:120},  
        {field:'UDate',title:'��������',width:160}, 
        {field:'UTime',title:'����ʱ��',width:160},
        {field:'RowId',title:'RowId',width:100},
    ]],
    onClickRow : function (rowIndex, rowData) {
        servicedatagrid_OnClickRow();
    }, 
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60]   
});

function AddgridData(){
	var Code=$('#CLCMSCode').textbox('getValue');
	var Desc=$('#CLCMSDesc').textbox('getValue');
	var Type=$('#CLCMSType').combogrid('getValue');
    if (Code==""){
         $.messager.alert("����", "���벻��Ϊ�գ�", 'error')
         return false;
    }
    if (Desc==""){
         $.messager.alert("����", "��������Ϊ�գ�", 'error')
         return false;
    }
    if (Type=="")
    {
         $.messager.alert("����", "���Ͳ���Ϊ�գ�", 'error')
         return false;	    
    }
    $.ajax({
            url :"dhcclinic.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCCLMappingData",
                MethodName:"SaveMappingService",
                Arg1:"",
                Arg2:Code,
                Arg3:Desc,
                Arg4:Type,
                ArgCnt:4
            },
            beforeSend: function () {
                $.messager.progress({
                text: '���ڱ�����...'
                });
            },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data >0) {
            $('#servicedatagrid').datagrid('reload');
            $.messager.show({
                title: '��ʾ',
                msg: '����ɹ�'
            }); 
            }   
            else {
               $.messager.alert('����ʧ�ܣ�',data, 'warning')
               return;
               }
           }
            
        })
}
function UpdategridData(){
	var Code=$('#CLCMSCode').textbox('getValue');
	var Desc=$('#CLCMSDesc').textbox('getValue');
	var Type=$('#CLCMSType').combogrid('getValue');
	if (RowId=="")
    {
         $.messager.alert("����", "RowId����Ϊ�գ�", 'error')
         return false;	    
    }
    if (Code==""){
         $.messager.alert("����", "���벻��Ϊ�գ�", 'error')
         return false;
    }
    if (Desc==""){
         $.messager.alert("����", "��������Ϊ�գ�", 'error')
         return false;
    }
    if(Type=="")
    {
         $.messager.alert("����", "������������Ϊ�գ�", 'error')
         return false;	    
    }
    $.ajax({
            url :"dhcclinic.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCCLMappingData",
                MethodName:"SaveMappingService",
                Arg1:RowId,
                Arg2:Code,
                Arg3:Desc,
                Arg4:Type,
                ArgCnt:4
            },
            beforeSend: function () {
                $.messager.progress({
                text: '���ڱ�����...'
                });
            },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data >0) {
            $('#servicedatagrid').datagrid('reload');
            $.messager.show({
                title: '��ʾ',
                msg: '���³ɹ�'
            }); 
            }   
            else {
               $.messager.alert('����ʧ�ܣ�',data, 'warning')
               return;
               }
           }
            
        })
}
function DeleteGridData(){
    if (RowId==""){
            $.messager.alert("����", "RowId����Ϊ�գ�", 'error')
            return false;
    } 
    var rows = $('#servicedatagrid').datagrid('getSelections');
    if (rows.length > 0) {
        $.messager.confirm('��ȷ��', '��ȷ��Ҫɾ����ѡ���У�', function (b) { 
        if (b==false)
        {
             return;
        }
        else
        {
        $.ajax({
            url :"dhcclinic.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCCLMappingData",
                MethodName:"RemoveMappingService",
                Arg1:RowId,
                ArgCnt:1
            },
            success:function (data, response, status) {
            if (data ==0) {
            $('#servicedatagrid').datagrid('reload');
            $.messager.show({
                title: '��ʾ',
                msg: 'ɾ���ɹ�'
            }); 
            }   
            else {
               $.messager.alert('ɾ��ʧ�ܣ�',data, 'warning')
               return;
               }
           }
            
        })
        }       
        })
       
    }
    else
    {
        $.messager.alert("����","��ѡ��һ�У�",'err')
    }
}
function InitForm()
{
    $("#CLCMSCode").textbox({
        width: 160
    });	
    $("#CLCMSDesc").textbox({
        width: 160
    });	
    $("#CLCMSType").combogrid({
	    url:null,
        panelWidth: 160,
        loadMsg: "���ڼ�����...",
        width: 160,
        rownumbers: true,
        idField: "code",
        textField: "desc",	
        columns: [[
            { field: "desc", title: "��������",width:130},
            { field: "code", title: "����",width:40,hidden:true}
        ]]
    });		
	var type=[
	    {desc:"View",code:"V"},
		{desc:"WebService",code:"W"}
		];
	$("#CLCMSType").combogrid("grid").datagrid("loadData",type);		    
}
})