$(document).ready(function () {
    $('#moduletype').combogrid({
                onSelect: function (rec) {
                    $('#parentmenu').combogrid('clear');
                    var sid = $("#moduletype").combogrid('getValue');
                    if (sid !="") {
					$('#parentmenu').combogrid({
						url:'dhceq.jquery.csp',
						panelWidth:350,     
						idField:'rowid',
						textField:'name',
						method:"post",
						mode:'remote',
						queryParams:{
						ClassName:"web.DHCEQCSysMenus",
						QueryName:"GetMenu",
						Arg1:$("#moduletype").combogrid('getValue'),
						ArgCnt:1
						},
					onChange: function(newValue, oldValue){
					$('#parentmenu').combogrid("grid").datagrid("reload",{
					ClassName:"web.DHCEQCSysMenus",
					QueryName:"GetMenu",
					Arg1:$("#moduletype").combogrid('getValue'),
					Arg2:$('#parentmenu').combogrid('getText'),
					ArgCnt:2
					})
    				},		
					columns:[[    
        			{field:'rowid',title:'RowId',hidden:true},    
        			{field:'name',title:'名称'},
        			{field:'caption',title:'说明'},
        			{field:'clienttype',title:'客户端类型'}  /// Modfied by zc 2015-07-30 ZC0027
        			]],
        			singleSelect:'true',
        			pagination:true,
        			pageSize:10,
        			pageNumber:1,
        			pageList:[10,20,30,40,50] 
                        });
                	}
                }
            });
    $('#name').validatebox({
        width: 160
    });
    $('#caption').validatebox({
        width: 160
    });
    $('#menutype').validatebox({
        width: 160
    });
    $('#clienttype').combogrid({
        width: 160
    });
    $('#busstype').combogrid({
	url:'dhceq.jquery.csp',
	panelWidth:350,       
	idField:'rowid',
	textField:'desc',  /// Modfied by zc 2015-07-30 ZC0027
	method:"post",
	mode:'remote',
	queryParams:{
		ClassName:"web.DHCEQCBussType",
		QueryName:"GetBussType",
		ArgCnt:0
	},
	onChange: function(newValue, oldValue){$('#busstypedr').val(newValue);},
	columns:[[    
        {field:'rowid',title:'rowid',hidden:true},    
        {field:'desc',title:'业务'},
        {field:'modletype',title:'模块'}
        ]],
     singleSelect:'true',
     pagination:true,
     pageSize:10,
     pageNumber:1,
     pageList:[10,20,30,40,50]   /// Modfied by zc 2015-07-30 ZC0027    
    });
var SelectedRowID = 0;
var preRowID=0;  
function menudatagrid_OnClickRow()
{
     var selected=$('#menudatagrid').datagrid('getSelected');
     if (selected)
     {       
        var SelectedRowID=selected.rowid;
        if(preRowID!=SelectedRowID)
        {
             $('#Rowid').val(selected.rowid);
             $('#moduletype').combogrid('setValue',selected.moduledr);
             $('#busstype').combogrid('setText',selected.busstype);
             $('#busstypedr').val(selected.busstypedr);
             $('#name').val(selected.name);
             $('#caption').val(selected.caption);
             $('#menutype').val(selected.menutype);
             $('#clienttype').combogrid('setValue',selected.clienttypedr);
             $('#parentmenu').combogrid('setValue',selected.parentmenudr);
             $('#image').val(selected.image);
             $('#linkurl').val(selected.linkurl);
             $('#sequence').val(selected.sequence);
             $('#shortcutkey').val(selected.shortcutkey);
             $('#showinnew').combobox('setValue',selected.showinnew);  //modified by czf 518845
             $('#remark').val(selected.remark);
             $('#date').val(selected.date);
             $('#time').val(selected.time);
             $('#user').val(selected.user);
             preRowID=SelectedRowID;
         }
         else
         {
             $('#Rowid').val("");
             $('#moduletype').combogrid('setValue',"");
             $('#busstype').combogrid('setValue',"");
             $('#busstypedr').val("");
             $('#name').val("");
             $('#caption').val("");
             $('#menutype').val("");
             $('#clienttype').combogrid('setValue',"");
             $('#parentmenu').combogrid('setValue',"");
             $('#image').val("");
             $('#linkurl').val("");
             $('#sequence').val("");
             $('#shortcutkey').val("");
             $('#showinnew').combobox('setValue',"");  //modified by czf 518845
             $('#remark').val("");
             $('#date').val("");
             $('#time').val("");
             $('#user').val("");
             SelectedRowID = 0;
             preRowID=0;
             $('#menudatagrid').datagrid('unselectAll');  //add by mwz 20180313 需求号:554658
         }
     }
} 
$('#menudatagrid').datagrid({   
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQCSysMenus",
        QueryName:"GetModulemenu",
        ArgCnt:0
    },
    border:'true',
    singleSelect:true,
    toolbar:[{   
    			iconCls: 'icon-add',
                text:'新增',          
                handler: function(){  /// Modfied by zc 2015-07-30 ZC0027
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
    	{field:'Rowid',title:'Rowid',width:50,hidden:true},    
        {field:'moduletype',title:'模块',width:60,align:'center'},
        {field:'busstype',title:'业务',width:95,align:'center'},
        {field:'busstypedr',title:'业务dr',width:50,hidden:true},
        {field:'name',title:'名称',width:100,align:'center'},    
        {field:'caption',title:'说明',width:100,align:'center'},
        {field:'menutype',title:'菜单类型',width:100,align:'center'},    
        {field:'clienttype',title:'客户端类型',width:70,align:'center'},    
        {field:'parentmenu',title:'父菜单',width:100,align:'center'},
        {field:'image',title:'图标',width:100,align:'center'},    
        {field:'linkurl',title:'链接',width:100,align:'center'},    
        {field:'sequence',title:'顺序',width:50,align:'center'},
        {field:'shortcutkey',title:'快捷键',width:60,align:'center'},    
        {field:'showinnew',title:'新窗口打开',width:100,align:'center'},    
        {field:'remark',title:'备注',width:100,align:'center'},
        {field:'date',title:'date',width:100,align:'center',hidden:true},    
        {field:'time',title:'time',width:100,align:'center',hidden:true},    
        {field:'user',title:'操作人',width:100,align:'center',hidden:true}            
    ]],
    onClickRow : function (rowIndex, rowData) {
        menudatagrid_OnClickRow();
    }, 
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75]    
});
//add by mwz 2018-03-13 需求号：553564
//查询前检查各下拉框内容
function CheckValue(){
	
	var moduletype=$('#moduletype').combobox('getText')   
	var busstype=$('#busstype').combobox('getText')
	var clienttype=$('#clienttype').combobox('getText')
	var parentmenu=$('#parentmenu').combobox('getText')
	 if (moduletype=="")
	 {
		 $('#moduletype').combogrid('setValue',"");
	 }
	 if (busstype=="")
	 {
		 $('#busstype').combogrid('setValue',"");
	 }
	 if (clienttype=="")
	 {
		 $('#clienttype').combogrid('setValue',"");
	 }
	 if (parentmenu=="")
	 {
		 $('#parentmenu').combogrid('setValue',"");
	 }
	}

function findGridData(){
	CheckValue();   //add by mwz 2018-03-13 需求号：553564
	$('#menudatagrid').datagrid({    
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQCSysMenus",
        QueryName:"GetModulemenu",
        Arg1:$('#moduletype').combogrid('getValue'),
        Arg2:$('#busstypedr').val(),
        Arg3:$('#name').val(),
        Arg4:$('#caption').val(),
        Arg5:$('#menutype').val(),
        Arg6:$('#clienttype').combogrid('getValue'),
       	Arg7:$('#parentmenu').combogrid('getValue'),
        Arg8:$('#shortcutkey').val(),
        Arg9:$('#showinnew').combobox('getValue'),  //modified by czf 518845
        Arg10:$('#image').val(),    //modified by czf 518867,518867,518981
        Arg11:$('#linkurl').val(),
        Arg12:$('#sequence').val(),
        ArgCnt:12
    },
    border:'true',
    singleSelect:true});
}
/// Modfied by zc 2015-07-30 ZC0027
/// 描述:新增AddgridData方法
function AddgridData(){
	if ($('#moduletype').combogrid('getValue')==""){
            $.messager.alert("错误", "菜单模块不能为空！", 'error')
            return false;
    }
    if ($('#name').val()==""){
           $.messager.alert("错误", "菜单名称不能为空！", 'error')  //add by wy 2017-5-4 需求：371028 
           return false;
    }
    if ($('#caption').val()==""){
            $.messager.alert("错误", "菜单说明不能为空！", 'error')//add by wy 2017-5-4 需求：371028
            return false;
    }
    if ($('#menutype').val()==""){
           $.messager.alert("错误", "菜单类型不能为空！", 'error')
           return false;
    }
    if ($('#clienttype').combogrid('getValue')==""){
            $.messager.alert("错误", "客户单类型不能为空！", 'error')
            return false;
    }
   
    $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQCSysMenus",
                MethodName:"AddModulemenu",
                Arg1:$('#moduletype').combogrid('getValue'), 
                Arg2:$('#busstypedr').val(),
                Arg3:$('#name').val(),
                Arg4:$('#caption').val(),
                Arg5:$('#menutype').val(),
				Arg6:$('#clienttype').combogrid('getValue'),
				Arg7:$('#parentmenu').combogrid('getValue'),
				Arg8:$('#image').val(),
				Arg9:$('#linkurl').val(),
				Arg10:$('#sequence').val(),
				Arg11:$('#shortcutkey').val(),
				Arg12:$('#showinnew').combobox('getValue'),   //modified by czf 518845
				Arg13:$('#remark').val(),
				Arg14:$('#date').val(),
				Arg15:$('#time').val(),
				Arg16:$('#user').val(),
                ArgCnt:16
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
            $('#menudatagrid').datagrid('reload'); 
            $.messager.show({
                title: '提示',
                msg: '保存成功'
            }); 
			Clear();  /// Modfied by zc 2015-09-11 ZC0029  新增成功后输入框中的内容应清空
            }   
            else {
               $.messager.alert('保存失败！',data, 'warning')
               return;
               }
           }
           
  
        })
	
}
function SavegridData(){
	if ($('#Rowid').val()==""){  /// Modfied by zc 2015-07-30 ZC0027
            $.messager.alert("错误", "请选择一行！", 'error')
            return false;
    } 
    if ($('#moduletype').combogrid('getValue')==""){
            $.messager.alert("错误", "菜单模块不能为空！", 'error')
            return false;
    }
    if ($('#name').val()==""){
           $.messager.alert("错误", "菜单名称不能为空！", 'error')
           return false;
    }
    if ($('#caption').val()==""){
            $.messager.alert("错误", "菜单说明不能为空！", 'error')
            return false;
    }
    if ($('#menutype').val()==""){
           $.messager.alert("错误", "菜单类型不能为空！", 'error')
           return false;
    }
    if ($('#clienttype').combogrid('getValue')==""){
            $.messager.alert("错误", "客户单类型不能为空！", 'error')
            return false;
    }
    $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQCSysMenus",
                MethodName:"SaveModulemenu",
                Arg1:$('#Rowid').val(),
                Arg2:$('#moduletype').combogrid('getValue'), 
                Arg3:$('#busstypedr').val(),
                Arg4:$('#name').val(),
                Arg5:$('#caption').val(),
                Arg6:$('#menutype').val(),
				Arg7:$('#clienttype').combogrid('getValue'),
				Arg8:$('#parentmenu').combogrid('getValue'),
				Arg9:$('#image').val(),
				Arg10:$('#linkurl').val(),
				Arg11:$('#sequence').val(),
				Arg12:$('#shortcutkey').val(),
				Arg13:$('#showinnew').combobox('getValue'),   //modified by czf 518845
				Arg14:$('#remark').val(),
				Arg15:$('#date').val(),
				Arg16:$('#time').val(),
				Arg17:$('#user').val(),
                ArgCnt:17
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
            $('#menudatagrid').datagrid('reload'); 
            $.messager.show({
                title: '提示',
                msg: '保存成功'
            });
			Clear();  /// Modfied by zc 2015-09-11 ZC0029  更新成功后输入框中的内容应清空
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
            $.messager.alert("错误", "请选择一行！", 'error')  /// Modfied by zc 2015-07-30 ZC0027
            return false;
    } 
    var rows = $('#menudatagrid').datagrid('getSelections');
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
                ClassName:"web.DHCEQCSysMenus",
                MethodName:"DeleteModulemenu",
                Arg1:$('#Rowid').val(),
                ArgCnt:1
            },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data ==0) {
            $('#menudatagrid').datagrid('reload');
            $.messager.show({
                title: '提示',
                msg: '删除成功'
            }); 
			Clear();  /// Modfied by zc 2015-09-11 ZC0029  删除成功后输入框中的内容应清空
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
/// 描述:新增Clear方法
function Clear(){
	$('#Rowid').val("");
    $('#moduletype').combogrid('setValue',"");
    $('#busstype').combogrid('setValue',"");
    $('#busstypedr').val("");
    $('#name').val("");
    $('#caption').val("");
    $('#menutype').val("");
    $('#clienttype').combogrid('setValue',"");
    $('#parentmenu').combogrid('setValue',"");
    $('#image').val("");
    $('#linkurl').val("");
    $('#sequence').val("");
    $('#shortcutkey').val("");
    $('#showinnew').combobox('setValue',"");   //modified by czf 518845
    $('#remark').val("");
    $('#date').val("");
    $('#time').val("");
    $('#user').val("");
}
//$('#menudatagrid').datagrid('hideColumn', 'Rowid'),
//$('#menudatagrid').datagrid('hideColumn', 'date'),
//$('#menudatagrid').datagrid('hideColumn', 'time'),
//$('#menudatagrid').datagrid('hideColumn', 'user') 
});