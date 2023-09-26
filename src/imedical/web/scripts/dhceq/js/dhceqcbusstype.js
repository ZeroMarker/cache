$(document).ready(function () {
    $('#code').validatebox({
        width: 160
    });
    $('#desc').validatebox({
        width: 160
    });
    $('#modletype').validatebox({
        width: 160
    });

var SelectedRowID = 0;
var preRowID=0;  
function busstypedatagrid_OnClickRow()
{	
     var selected=$('#busstypedatagrid').datagrid('getSelected');
     if (selected)
     {       
        var SelectedRowID=selected.rowid;
        if(preRowID!=SelectedRowID)
        {
             $('#Rowid').val(selected.rowid);
             $('#code').val(selected.code);
             $('#desc').val(selected.desc);
             $('#modletype').combobox('setValue',selected.modletypedr);
             $('#InvalidFlag').val(selected.invalidFlag);
             preRowID=SelectedRowID;
         }
         else
         {
             $('#Rowid').val("");
             $('#code').val("");
             $('#desc').val("");
             $('#modletype').combobox('setValue',"");
             $('#InvalidFlag').val("");
             SelectedRowID = 0;
             preRowID=0;
             var rowIndex=$('#busstypedatagrid').datagrid('getRowIndex',selected);  //modified by czf 562047
             $('#busstypedatagrid').datagrid('unselectRow', rowIndex);
         }
     }
} 
$('#busstypedatagrid').datagrid({   
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQCBussType",
        QueryName:"GetBussType",
        ArgCnt:0
    },
    border:'true',
    striped:'true',
    singleSelect:true,
    toolbar:[{  
    			iconCls: 'icon-add', /// Modfied by zc 2015-07-27 ZC0026 新增按钮
                text:'新增',          
                handler: function(){
                     AddgridData();
                }   
                },'------------------------',{         
                iconCls: 'icon-save',
                text:'保存',          
                handler: function(){
                     UpdategridData();
                }   
                },'------------------------',{        
                iconCls: 'icon-cut', 
                text:'删除',      
                 handler: function(){
                     DeleteGridData();
                     }      
                 },'------------------------',{        
                iconCls: 'icon-search', 
                text:'查询',      
                 handler: function(){
                     findGridData();
                     }      
                 }] , 
   
    columns:[[
    	{field:'rowid',title:'Rowid',width:50},    
        {field:'code',title:'代码',width:60,align:'center'},
        {field:'desc',title:'描述',width:100,align:'center'},       
        {field:'modletype',title:'模块',width:100,align:'center'},  
        {field:'invalidFlag',title:'InvalidFlag',width:100,align:'center'},                
    ]],
    onClickRow : function (rowIndex, rowData) {
	    
        busstypedatagrid_OnClickRow();
    },
    onBeforeSelect : function (index,row) {
	    SelectRowColor($('#busstypedatagrid'),row,oldIndex);
    },
     
    rowStyler:function(index,row){   
          if (index%2==1){   
            		return 'background-color:'+EVENCOLOR+';';   
          	}   
     		},
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75]   
});
	
function findGridData(){
	var modletype=$('#modletype').combobox('getText')   //add by mwz 2017-08-10 需求号：396554
	 if (modletype=="")
	 {
		 $('#modletype').combobox('setValue',"");
		 }
	$('#busstypedatagrid').datagrid({    
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQCBussType",
        QueryName:"GetBussType",
        Arg1:$('#code').val(),
        Arg2:$('#desc').val(),
        Arg3:$('#modletype').combobox('getValue'),
        ArgCnt:3
    },
    border:'true',
    singleSelect:true});
}
/// Modfied by zc 2015-07-27 ZC0026
/// 描述:新增AddgridData方法
function AddgridData(){
	if ($('#code').val()==""){
           $.messager.alert("错误", "代码不能为空！", 'error')
           return false;
    }
    if ($('#desc').val()==""){
            $.messager.alert("错误", "描述不能为空！", 'error')
            return false;
    }
   if ($('#modletype').combobox('getValue')==""){
            $.messager.alert("错误", "模块不能为空！", 'error')
            return false;
    }
    $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQCBussType",
                MethodName:"AddBussType",
                Arg1:$('#code').val(),
                Arg2:$('#desc').val(),
                Arg3:$('#modletype').combobox('getValue'),
				Arg4:$('#InvalidFlag').val(),
                ArgCnt:4
            },
            beforeSend: function () {
                $.messager.progress({
                text: '正在保存中...'
                });
            },
           	error:function(XMLHttpRequest, textStatus, errorThrown){
                        messageShow("","","",XMLHttpRequest.status);
                        messageShow("","","",XMLHttpRequest.readyState);
                        messageShow("","","",textStatus);
                    },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data >0) {
            $('#busstypedatagrid').datagrid('reload'); 
            $.messager.show({
                title: '提示',
                msg: '保存成功'
            });
			Clear(); 	/// Modfied by zc 2015-09-11 ZC0029  新增成功后应清空输入框中的内容	
            }   
            else {
               $.messager.alert('保存失败！',data, 'warning')
               return;
               }
           }
           
  
        })
}
function UpdategridData(){
	if ($('#Rowid').val()==""){
            $.messager.alert("错误", "请选择一行！", 'error')  /// Modfied by zc 2015-07-27 ZC0026
            return false;
    } 
    if ($('#code').val()==""){
           $.messager.alert("错误", "代码不能为空！", 'error')
           return false;
    }
    if ($('#desc').val()==""){
            $.messager.alert("错误", "描述不能为空！", 'error')
            return false;
    }
   if ($('#modletype').combobox('getValue')==""){
            $.messager.alert("错误", "模块不能为空！", 'error')
            return false;
    }
    $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQCBussType",
                MethodName:"SaveBussType",
                Arg1:$('#Rowid').val(),
                Arg2:$('#code').val(),
                Arg3:$('#desc').val(),
                Arg4:$('#modletype').combobox('getValue'),
				Arg5:$('#InvalidFlag').val(),
                ArgCnt:5
            },
            beforeSend: function () {
                $.messager.progress({
                text: '正在保存中...'
                });
            },
           	error:function(XMLHttpRequest, textStatus, errorThrown){
                        messageShow("","","",XMLHttpRequest.status);
                        messageShow("","","",XMLHttpRequest.readyState);
                        messageShow("","","",textStatus);
                    },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data==0) { /// Modfied by zc 2015-07-27 ZC0026 根据返回值判断是否成功
            $('#busstypedatagrid').datagrid('reload'); 
            $.messager.show({
                title: '提示',
                msg: '保存成功'
            }); 
			Clear();  /// Modfied by zc 2015-09-11 ZC0029  更新成功后应清空输入框中的内容
            }   
            else {
               $.messager.alert('保存失败！',data, 'warning')
               return;
               }
           }
           
  
        })
}
function DeleteGridData(){
    if ($('#Rowid').val()==""){
            $.messager.alert("错误", "请选择一行！", 'error') /// Modfied by zc 2015-07-27 ZC0026
            return false;
    } 
    var rows = $('#busstypedatagrid').datagrid('getSelections');
    var ids = [];
    var unSaveIndexs = [];
    if (rows.length > 0) {
        $.messager.confirm('请确认', '您确定要删除所选的行？', function (b) { 
        if (b==false)
        {
             return;
        }
        else
        {
        $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQCBussType",
                MethodName:"DeleteBussType",
                Arg1:$('#Rowid').val(),
                ArgCnt:1
            },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data ==0) {
            $('#busstypedatagrid').datagrid('reload');
            $.messager.show({
                title: '提示',
                msg: '删除成功'
            });
			Clear();	/// Modfied by zc 2015-09-11 ZC0029  删除成功后应清空输入框中的内容
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
/// Modfied by zc 2015-09-11 ZC0029
/// 描述:新增清空函数
function Clear(){
	 $('#Rowid').val("");
     $('#code').val("");
     $('#desc').val("");
     $('#modletype').combobox('setValue',"");
     $('#InvalidFlag').val("");
}
$('#busstypedatagrid').datagrid('hideColumn', 'rowid'),
$('#busstypedatagrid').datagrid('hideColumn', 'invalidFlag')
});


