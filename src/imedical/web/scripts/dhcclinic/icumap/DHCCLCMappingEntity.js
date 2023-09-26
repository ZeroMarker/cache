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
        {field:'ClcmsDr',title:'服务指向ID',width:120}, 
        {field:'ClcmsDesc',title:'服务指向',width:120}, 
        {field:'UDate',title:'更新日期',width:160}, 
        {field:'UTime',title:'更新时间',width:160},
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
         $.messager.alert("错误", "代码不能为空！", 'error')
         return false;
    }
    if (Desc==""){
         $.messager.alert("错误", "描述不能为空！", 'error')
         return false;
    }
    if (CLCMSDr=="")
    {
         $.messager.alert("错误", "服务指向不能为空！", 'error')
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
                text: '正在保存中...'
                });
            },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data >0) {
            $('#entitydatagrid').datagrid('reload');
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
	var Code=$('#CLCMECode').textbox('getValue');
	var Desc=$('#CLCMEDesc').textbox('getValue');
	var CLCMSDr=$('#CLCMECLCMS').combogrid('getValue');
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
    if (CLCMSDr=="")
    {
         $.messager.alert("错误", "服务指向不能为空！", 'error')
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
                text: '正在保存中...'
                });
            },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data >0) {
            $('#entitydatagrid').datagrid('reload');
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
    var rows = $('#entitydatagrid').datagrid('getSelections');
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
                MethodName:"RemoveMappingEntity",
                Arg1:RowId,
                ArgCnt:1
            },
            success:function (data, response, status) {
            if (data ==0) {
            $('#entitydatagrid').datagrid('reload');
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
        loadMsg: "正在加载中...",
        width: 160,
        rownumbers: true,
        idField: "RowId",
        textField: "Desc",
        method:"post",	
        columns: [[
            { field: "Desc", title: "服务指向",width:130},
            { field: "RowId", title: "服务指向Id",width:40,hidden:true}
        ]]
    });				    
}
})