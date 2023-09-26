$(document).ready(function () {
   var str=window.location.search.substr(1);
   var list=str.split("&");
   var tmp=list[0].split("=")
   var temp=list[1].split("=")
   $('#managelimitdr').val(tmp[1]);
   $('#type').val(temp[1]);
   $('#value').combogrid({
	panelWidth:300, 
	url:'dhceq.jquery.csp',      
	idField:'rowid',
	textField:'desc',
	method:"post",
	mode:'remote',
	queryParams:{
		ClassName:"web.DHCEQCManageLimit",
		QueryName:"GetValue",
		Arg1:$('#type').val(),
		Arg2:"",
		ArgCnt:2
	},	
	columns:[[    
        {field:'rowid',title:'rowid',hidden:true},    
        {field:'desc',title:'描述'},
		{field:'remark',title:'代码'}
        ]],
    keyHandler: { 
			query: function(q) {
				ReloadGrid("value",q,$('#type').val()+SplitChar+q);
				}	
		}    
    });
var SelectedRowID = 0;
var preRowID=0;  
function managelimitlistdatagrid_OnClickRow()
{
     var selected=$('#managelimitlistdatagrid').datagrid('getSelected');
     if (selected)
     {
        var SelectedRowID=selected.rowid;
        if(preRowID!=SelectedRowID)
        {
             $('#LRowid').val(selected.rowid);
             $('#managelimitdr').val(selected.managelimitdr);
             $('#type').val(selected.typedr);
             $('#value').combogrid('setValue',selected.valuedr);
             preRowID=SelectedRowID;
         }
         else
         {
             $('#LRowid').val("");
             //$('#managelimitdr').val("");
             //$('#type').val("");
             $('#value').combogrid('setValue',"");
             SelectedRowID = 0;
             preRowID=0;
             $('#managelimitlistdatagrid').datagrid('unselectAll');
         }
     }
} 
$('#managelimitlistdatagrid').datagrid({   
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQCManageLimit",
        QueryName:"GetManageLimitList",
        Arg1:$('#managelimitdr').val(),
        Arg2:$('#type').val(),
        ArgCnt:2
    },
    border:'true',
    singleSelect:true,
    toolbar:[{  
    			iconCls: 'icon-add',
                text:'新增',          
                handler: function(){   /// Modfied by zc 2015-07-30 ZC0027
                     AddgridData();
                }   
                },'------------------------',{         
                iconCls: 'icon-save',
                text:'保存',          
                handler: function(){
                     SavegridData();
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
    	{field:'rowid',title:'LRowid',width:50,hidden:true},    
        {field:'managelimitdr',title:'managelimitdr',width:150,align:'center',hidden:true},
        {field:'type',title:'类型',width:100,align:'center'},
        {field:'value',title:'内容',width:300,align:'left'},
		{field:'accessflag',title:'访问标识',width:60,align:'center',formatter: accessOperation}
    ]],
    onClickRow : function (rowIndex, rowData) {
        managelimitlistdatagrid_OnClickRow();
    }, 
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75]    
});
/// Modfied by wy 2017-06-19 需求：394351
///限定明细无法查询
function findGridData(){
	$('#managelimitlistdatagrid').datagrid({    
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQCManageLimit",
        QueryName:"GetManageLimitList",
        Arg1:$('#managelimitdr').val(),
        Arg2:$('#type').val(),
        Arg3:$('#value').combogrid('getValue'),
        ArgCnt:3
    },
    border:'true',
    singleSelect:true});
}
/// Modfied by zc 2015-07-30 ZC0027
/// 描述:新增AddgridData方法
function AddgridData(){
	if ($('#value').combogrid('getValue')==""){
            $.messager.alert("错误", "内容不能为空！", 'error')
            return false;
    }
    $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQCManageLimit",
                MethodName:"AddManageLimitList",
                Arg1:$('#managelimitdr').val(),
				Arg2:$('#type').val(),
        		Arg3:$('#value').combogrid('getValue'),
				Arg4:"Y",
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
            //messageShow("","","",data);
            if (data >0) {
            $('#managelimitlistdatagrid').datagrid('reload'); 
            $.messager.show({
                title: '提示',
                msg: '保存成功'
            }); 
			Clear();      /// Modfied by zc 2015-09-11 ZC0029 新增成功后输入框中的内容应清空
            }   
            else {
               $.messager.alert('保存失败！',data, 'warning')
               return;
               }
           }         
        })
}
function SavegridData(){
	if ($('#LRowid').val()==""){
            $.messager.alert("错误", "请选择一行！", 'error')  /// Modfied by zc 2015-07-30 ZC0027
            return false;
    }
    if ($('#value').combogrid('getValue')==""){
            $.messager.alert("错误", "内容不能为空！", 'error')
            return false;
    }
    $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQCManageLimit",
                MethodName:"SaveManageLimitList",
                Arg1:$('#LRowid').val(),
                Arg2:$('#managelimitdr').val(),
				Arg3:$('#type').val(),
        		Arg4:$('#value').combogrid('getValue'),
				Arg5:$('#managelimitlistdatagrid').datagrid('getSelected').accessflag,
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
            //messageShow("","","",data);
            if (data==0) {  /// Modfied by zc 2015-07-30 ZC0027
            $('#managelimitlistdatagrid').datagrid('reload'); 
            $.messager.show({
                title: '提示',
                msg: '保存成功'
            }); 
			Clear();    /// Modfied by zc 2015-09-11 ZC0029 更新成功后输入框中的内容应清空
            }   
            else {
               $.messager.alert('保存失败！',data, 'warning')
               return;
               }
           }         
        })
}
function DeleteGridData(){
    if ($('#LRowid').val()==""){
            $.messager.alert("错误", "请选择一行！", 'error')  /// Modfied by zc 2015-07-30 ZC0027
            return false;
    } 
    var rows = $('#managelimitlistdatagrid').datagrid('getSelections');
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
                ClassName:"web.DHCEQCManageLimit",
                MethodName:"DeleteManageLimitList",
                Arg1:$('#LRowid').val(),
                ArgCnt:1
            },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data ==0) {
            $('#managelimitlistdatagrid').datagrid('reload');
            $.messager.show({
                title: '提示',
                msg: '删除成功'
            }); 
			Clear();    /// Modfied by zc 2015-09-11 ZC0029 删除成功后输入框中的内容应清空
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
        $.messager.alert("错误","请选择一行！",'error')
    }
}
/// Modfied by zc 2015-09-11 ZC0029
/// 描述:新增清空函数
function Clear(){
	$('#LRowid').val("");
    $('#value').combogrid('setValue',"");
}
//$('#managelimitlistdatagrid').datagrid('hideColumn', 'rowid'),
//$('#managelimitlistdatagrid').datagrid('hideColumn', 'managelimitdr')
});

function accessOperation(value,row,index)
{
	if(value=="Y")
	{
		return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchange(this,'+index+')" checked="checked" value="" >';
	}
	else
	{
		return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchange(this,'+index+')" value="Y" >';
	}
}
//Add By DJ 2017-02-18
function checkchange(obj,rowIndex)
{
	var row = $('#managelimitlistdatagrid').datagrid('getRows')[rowIndex];
	if (row)
	{
		if (obj.checked)
		{
			row.accessflag ="Y"
		}
		else
		{
			row.accessflag ="N"
		}
	}
}