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
                text:'增加',          
                handler: function(){
                     AddgridData();
                }   
                },'----',{         
                iconCls: 'icon-edit', 
                text:'修改',      
                 handler: function(){
                     UpdategridData();
                     }      
                 },'----',{        
                iconCls: 'icon-cut', 
                text:'删除',      
                 handler: function(){
                     DeleteGridData();
                     }      
                 }],
    columns:[[    
        {field:'Code',title:'代码',width:120},    
        {field:'Desc',title:'描述',width:120},    
        {field:'Type',title:'类型',width:120},  
        {field:'UDate',title:'更新日期',width:160}, 
        {field:'UTime',title:'更新时间',width:160},
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
         $.messager.alert("错误", "代码不能为空！", 'error')
         return false;
    }
    if (Desc==""){
         $.messager.alert("错误", "描述不能为空！", 'error')
         return false;
    }
    if (Type=="")
    {
         $.messager.alert("错误", "类型不能为空！", 'error')
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
                text: '正在保存中...'
                });
            },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data >0) {
            $('#servicedatagrid').datagrid('reload');
            $.messager.show({
                title: '提示',
                msg: '保存成功'
            }); 
            }   
            else {
               $.messager.alert('保存失败！',data, 'warning')
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
         $.messager.alert("错误", "RowId不能为空！", 'error')
         return false;	    
    }
    if (Code==""){
         $.messager.alert("错误", "代码不能为空！", 'error')
         return false;
    }
    if (Desc==""){
         $.messager.alert("错误", "描述不能为空！", 'error')
         return false;
    }
    if(Type=="")
    {
         $.messager.alert("错误", "类型描述不能为空！", 'error')
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
                text: '正在保存中...'
                });
            },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data >0) {
            $('#servicedatagrid').datagrid('reload');
            $.messager.show({
                title: '提示',
                msg: '更新成功'
            }); 
            }   
            else {
               $.messager.alert('更新失败！',data, 'warning')
               return;
               }
           }
            
        })
}
function DeleteGridData(){
    if (RowId==""){
            $.messager.alert("错误", "RowId不能为空！", 'error')
            return false;
    } 
    var rows = $('#servicedatagrid').datagrid('getSelections');
    if (rows.length > 0) {
        $.messager.confirm('请确认', '您确定要删除所选的行？', function (b) { 
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
                title: '提示',
                msg: '删除成功'
            }); 
            }   
            else {
               $.messager.alert('删除失败！',data, 'warning')
               return;
               }
           }
            
        })
        }       
        })
       
    }
    else
    {
        $.messager.alert("错误","请选择一行！",'err')
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
        loadMsg: "正在加载中...",
        width: 160,
        rownumbers: true,
        idField: "code",
        textField: "desc",	
        columns: [[
            { field: "desc", title: "服务类型",width:130},
            { field: "code", title: "代码",width:40,hidden:true}
        ]]
    });		
	var type=[
	    {desc:"View",code:"V"},
		{desc:"WebService",code:"W"}
		];
	$("#CLCMSType").combogrid("grid").datagrid("loadData",type);		    
}
})