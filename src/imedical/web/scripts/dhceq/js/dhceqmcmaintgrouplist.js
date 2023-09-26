$(document).ready(function () {
$('#User').combogrid({
	url:'dhceq.jquery.csp',   
	panelWidth:300,    
	idField:'rowid',
	textField:'name',
	method:"post",
	mode:'remote',
	queryParams:{
		ClassName:"web.DHCEQMCMaintGroupList",
		QueryName:"MemberUser",
	        Arg1:$('#User').combogrid('getValue'),
		    ArgCnt:1
	},	
	columns:[[    
        {field:'rowid',title:'rowid',hidden:true},    
        {field:'name',title:'姓名'},
        {field:'initials',title:'工号'}
        ]],
   
	pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75],
	keyHandler: { 
		query: function(q) {
			ReloadGrid("User",q,q); //add by wy 2017-08-02 需求：416779，413137
			}
		}
    });

  
var selectedRowID = 0;
var preRowID=0;  
function maintgrouplistDataGrid_OnClickRow()
{
     var selected=$('#maintgrouplistdatagrid').datagrid('getSelected');
     if (selected)
     {       
        var selectedRowID=selected.RowID;
        if(preRowID!=selectedRowID)
        {
	         $('#Rowid').val(selected.RowID);
		     //$('#Maintgroup').combogrid('setValue',selected.Maintgroup);        
		     $('#User').combogrid('setValue',selected.userdr);  
		     $('#User').combogrid('setText',selected.User);
		     $('#ManagerFlag').val(selected.ManagerFlag); 
		     if(selected.ManagerFlag=="Y") 
		     {
			     $('#ManagerFlag').prop("checked",true);//打勾
		     }
		     else
		     {
			     $('#ManagerFlag').prop("checked",false);//打勾
		     }
		     preRowID=selectedRowID;
	     }
         else
         {
             $('#Rowid').val("");
            // $('#Maintgroup').combogrid('setValue',"");
             $('#User').combogrid('setValue',"");
             $('#ManagerFlag').prop("checked",false);//打勾
             SelectedRowID = 0;
             preRowID=0;
         }
     }
} 
$('#maintgrouplistdatagrid').datagrid({   
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQMCMaintGroupList",
        QueryName:"GetMaintGroupList",
        Arg1:"",
        Arg2:jQuery("#MGroupDR").val(),
        ArgCnt:2
    },
    border:'true',
    singleSelect:true,
    toolbar:[{  
                iconCls: 'icon-add',
                text:'新增',          
                handler: function(){
                     AddGridData();
                }   
                },'------------------------',
                {         
                iconCls: 'icon-save',
                text:'保存',          
                handler: function(){
                     UpdateGridData();
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
                     FindGridData();
                     }      
                 }] , 
   
    columns:[[
    	{field:'RowID',title:'Rowid',width:50,hidden:true},
        {field:'MaintGroupDR',title:'MaintGroupDR',width:100,align:'center',hidden:true},
        {field:'MaintGroup',title:'维修组',width:100,align:'center'},   
        {field:'User',title:'成员',width:90,align:'center'},
        {field:'userdr',title:'UserDR',width:100,align:'center',hidden:true},
        {field:'ManagerFlag',title:'管理者',width:100,align:'center'},
    ]],
    onClickRow : function (rowIndex, rowData) {
        maintgrouplistDataGrid_OnClickRow();
    }, 
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75]   
});

function FindGridData()  // 查询
{
	$('#maintgrouplistdatagrid').datagrid({    
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQMCMaintGroupList",
        QueryName:"GetMaintGroupList", 
        Arg1:$('#User').combogrid('getText'),	//需求号:264283		Mozy	2016-10-8
        Arg2:jQuery("#MGroupDR").val(),
        Arg3:$('#ManagerFlag').is(':checked'),	//需求号:264283		Mozy	2016-10-13
        ArgCnt:3
    },
    border:'true',
    singleSelect:true});
    //EmptyInput();
}
function AddGridData(){	
	 if ($('#User').combogrid('getValue')==""){
            $.messager.alert("错误", "成员不能为空！", 'error')
            return false;
	        }
     
     if($('#ManagerFlag').is(':checked') ==true)
	{
		$('#ManagerFlag').val("Y"); 
	}
	else
	{
		$('#ManagerFlag').val("N"); 
	} 
       var MaintGroupListInfo="^"+getUrlParam('MGroupDR')+"^"+$('#User').combogrid('getValue')+"^"+$('#ManagerFlag').val()+$('#InvalidFlag').val()
    $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQMCMaintGroupList",
                MethodName:"SaveMaintGroupList",
                Arg1:MaintGroupListInfo,
                ArgCnt:1
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
            if (data ==0) {
            $('#maintgrouplistdatagrid').datagrid('reload'); 
            $.messager.show({
                title: '提示',
                msg: '保存成功'
            });
			EmptyInput();	///新增后输入框应清空		
            }   
            else {
               $.messager.alert('保存失败！',data, 'warning')
               return;
               }
           }
        })
}
function getUrlParam(MGroupDR) 
{
	var reg = new RegExp("(^|&)" + MGroupDR + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
	var r = window.location.search.substr(1).match(reg);  //匹配目标参数
	if (r != null) return unescape(r[2]); return null; //返回参数值
}
function UpdateGridData(){
	if ($('#Rowid').val()==""){
		$.messager.alert("错误", "请选中一行！", 'error') 
            return false;
	}
    if ($('#User').combogrid("getValue")==""){
            $.messager.alert("错误", "成员不能为空！", 'error')
            return false;
    }
    if($('#ManagerFlag').is(':checked') ==true)
	{
		$('#ManagerFlag').val("Y"); 
	}
	else
	{
		$('#ManagerFlag').val("N"); 
	} 
    var MaintGroupInfoListInfo=$('#Rowid').val()+"^"+getUrlParam('MGroupDR')+"^"+$('#User').combogrid("getValue")+"^"+$('#ManagerFlag').val()
   $.ajax({            
     url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQMCMaintGroupList",
                MethodName:"SaveMaintGroupList",
                Arg1:MaintGroupInfoListInfo,
		        ArgCnt:1
            },
            beforeSend: function () {
                $.messager.progress({
                text: '正在更新中...'
                });
            },
           	error:function(XMLHttpRequest, textStatus, errorThrown){
                        messageShow("","","",XMLHttpRequest.status);
                        messageShow("","","",XMLHttpRequest.readyState);
                        messageShow("","","",textStatus);
                    },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data==0) {  /// 根据返回值判断是否成功
            $('#maintgrouplistdatagrid').datagrid('reload'); 
            $.messager.show({
                title: '提示',
                msg: '更新成功'
            });
            EmptyInput(); 
            }   
            else {
               $.messager.alert('更新失败！',data, 'warning')
               return;
               }
           }
        })
}
function DeleteGridData(){
    if ($('#Rowid').val()==""){
            $.messager.alert("错误", "请选中一行！", 'error') 
            return false;
    } 
    var rows = $('#maintgrouplistdatagrid').datagrid('getSelections');
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
                ClassName:"web.DHCEQMCMaintGroupList",
                MethodName:"DeleteMaintGroupList",
                Arg1:$('#Rowid').val(),
                ArgCnt:1
            },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data ==0) {
            $('#maintgrouplistdatagrid').datagrid('reload');
            $.messager.show({
                title: '提示',
                msg: '删除成功'
            });
			EmptyInput();  ///  删除后输入框应清空	
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
/// 描述:清空函数
function EmptyInput(){
	$('#Rowid').val("");
    $('#User').combogrid('setValue',"");
    $('#userdr').combogrid('setValue',"");
    $('#MaintGroupDR').combogrid('setValue',"");
    $('#ManagerFlag').prop("checked",false);//打勾
}
});