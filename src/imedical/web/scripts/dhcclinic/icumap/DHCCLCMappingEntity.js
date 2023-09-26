$(document).ready(function () {
InitForm();
var SelectedRowID = 0;
var preRowID=0;
var RowId="";
function entitydatagrid_OnClickRow()
{
	
	var selected=$('#entitydatagrid').datagrid('getSelected');
	if(selected)
	{
		var SelectedRowID=selected.RowId;
		if(preRowID!=SelectedRowID)
		{
			RowId=SelectedRowID;
			$("#CLCMECode").textbox("setValue",selected.Code);
			$("#CLCMEDesc").textbox("setValue",selected.Desc);
			$("#CLCMECLCMS").combogrid("setValue",selected.ClcmsDr);
			$("#CLCMECLCMS").combogrid("setText",selected.ClcmsDesc);
			preRowID=SelectedRowID;
		}
		else{
			RowId="";
			$("#CLCMECode").textbox("setValue","");
			$("#CLCMEDesc").textbox("setValue","");
			$("#CLCMECLCMS").combogrid("setValue","");
			$("#CLCMECLCMS").combogrid("setText","");
            SelectedRowID = 0;
            preRowID=0;			
		}
	}
}
$('#entitydatagrid').datagrid({    
    url:'dhcclinic.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCCLMappingData",
        QueryName:"FindMappingEntity",
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
        {field:'ClcmsDr',title:'����ָ��ID',width:120}, 
        {field:'ClcmsDesc',title:'����ָ��',width:120}, 
        {field:'UDate',title:'��������',width:160}, 
        {field:'UTime',title:'����ʱ��',width:160},
        {field:'RowId',title:'RowId',width:100},
    ]],
    onClickRow : function (rowIndex, rowData) {
        entitydatagrid_OnClickRow();
    }, 
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60]   
});

function AddgridData(){
	var Code=$('#CLCMECode').textbox('getValue');
	var Desc=$('#CLCMEDesc').textbox('getValue');
	var CLCMSDr=$('#CLCMECLCMS').combogrid('getValue');
    if (Code==""){
         $.messager.alert("����", "���벻��Ϊ�գ�", 'error')
         return false;
    }
    if (Desc==""){
         $.messager.alert("����", "��������Ϊ�գ�", 'error')
         return false;
    }
    if (CLCMSDr=="")
    {
         $.messager.alert("����", "����ָ����Ϊ�գ�", 'error')
         return false;	    
    }
    $.ajax({
            url :"dhcclinic.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCCLMappingData",
                MethodName:"SaveMappingEntity",
                Arg1:"",
                Arg2:Code,
                Arg3:Desc,
                Arg4:CLCMSDr,
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
            $('#entitydatagrid').datagrid('reload');
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
	var Code=$('#CLCMECode').textbox('getValue');
	var Desc=$('#CLCMEDesc').textbox('getValue');
	var CLCMSDr=$('#CLCMECLCMS').combogrid('getValue');
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
    if (CLCMSDr=="")
    {
         $.messager.alert("����", "����ָ����Ϊ�գ�", 'error')
         return false;	    
    }
    $.ajax({
            url :"dhcclinic.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCCLMappingData",
                MethodName:"SaveMappingEntity",
                Arg1:RowId,
                Arg2:Code,
                Arg3:Desc,
                Arg4:CLCMSDr,
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
            $('#entitydatagrid').datagrid('reload');
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
    var rows = $('#entitydatagrid').datagrid('getSelections');
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
                MethodName:"RemoveMappingEntity",
                Arg1:RowId,
                ArgCnt:1
            },
            success:function (data, response, status) {
            if (data ==0) {
            $('#entitydatagrid').datagrid('reload');
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
    $("#CLCMECode").textbox({
        width: 160
    });	
    $("#CLCMEDesc").textbox({
        width: 160
    });	
    $("#CLCMECLCMS").combogrid({
	    url:'dhcclinic.jquery.csp',
	    queryParams:{
           ClassName:"web.DHCCLMappingData",
           QueryName:"FindMappingService",
           ArgCnt:0
        },
        panelWidth: 160,
        loadMsg: "���ڼ�����...",
        width: 160,
        rownumbers: true,
        idField: "RowId",
        textField: "Desc",
        method:"post",	
        columns: [[
            { field: "Desc", title: "����ָ��",width:130},
            { field: "RowId", title: "����ָ��Id",width:40,hidden:true}
        ]]
    });				    
}
})