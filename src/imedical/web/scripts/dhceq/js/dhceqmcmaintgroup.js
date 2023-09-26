$(document).ready(function () {
$('#Code').validatebox({width: 160});
$('#Desc').validatebox({width: 160});
$('#ManageLoc').combogrid({
    url:'dhceq.jquery.csp', 
	panelWidth:300,     
	idField:'Hidden',
	delay:800, 
	textField:'Desc',
	method:"post",
	mode:'remote',
	queryParams:{
		ClassName:"web.DHCEQMCMaintGroup",
		QueryName:"GetEQLoc",
		   Arg1:'',
		   Arg2:$('#ManageLoc').combogrid('getValue'),      //add by mwz 2017-08-01  需求号412969
		ArgCnt:2
		},
		columns:[[    
    {field:'Hidden',title:'rowid',hidden:true},    
    {field:'Code',title:'代码'},
    {field:'Desc',title:'描述'}
    ]],
    keyHandler: { 
		query: function(q) {
			ReloadGrid("ManageLoc",q,"^"+q);}        //add by mwz 2017-08-01  需求号412969
		},      
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75]
    })

$('#User').combogrid({
	url:'dhceq.jquery.csp',   
	panelWidth:300,   
	delay:800, 
	idField:'rowid',
	textField:'name',
	method:"post",
	mode:'remote',
	
	queryParams:{
		ClassName:"web.DHCEQMCMaintGroup",
		QueryName:"LeaderUser",
	        Arg1:$('#User').combogrid('getValue'),
		ArgCnt:1
	},	
	columns:[[    
        {field:'rowid',title:'rowid',hidden:true},    
        {field:'name',title:'姓名'},
        {field:'initials',title:'工号'}
        ]],
    keyHandler: { 
		query: function(q) {
			ReloadGrid("User",q,q);}     //add by mwz 2017-08-01 需求号：412978
		},
	pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75] 	  
    });
    var selectedRowID = 0;
    var preRowID=0;  
   function maintgroupDataGrid_OnClickRow()  
{
     var selected=$('#maintgroupdatagrid').datagrid('getSelected');
     if (selected)
     {     
        var selectedRowID=selected.RowID;
        if(preRowID!=selectedRowID)
        {
         $('#Rowid').val(selected.RowID);
         $('#Code').val(selected.Code);
         $('#Desc').val(selected.Desc);             
	     $('#Remark').val(selected.Remark); 
	     $('#User').combogrid('setValue',selected.userdr);  //add by wy 2017-5-4 需求：371118
         $('#User').combogrid('setText',selected.User);    
	     $('#ManageLoc').combogrid('setValue',selected.ManageLocDR);
	     $('#InvalidFlag').val(selected.InvalidFlag);
         preRowID=selectedRowID;
         }
         else
         {
             $('#Rowid').val("");
             $('#Code').val("");
             $('#Desc').val("");
	     $('#Remark').val("");
             $('#User').combogrid('setValue',"");
             $('#ManageLoc').combogrid('setValue',"");
             $('#InvalidFlag').val("");
             selectedRowID = 0;
             preRowID=0;
              $('#maintgroupdatagrid').datagrid('unselectAll');  //add by mwz 20180313 需求号:550796
         }
     }
} 
$('#maintgroupdatagrid').datagrid({   
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQMCMaintGroup",
        QueryName:"GetMaintGroup",
        ArgCnt:0
    },
    border:'true',
    singleSelect:true,
    toolbar:[{  
                iconCls: 'icon-add',
                text:'新增',          
                handler: function(){
                     AddGridData();
                }   
                },'------------------------',{         
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
        {field:'Code',title:'代码',width:60,align:'center'},
        {field:'Desc',title:'描述',width:150,align:'center'},       
        {field:'Remark',title:'备注',width:100,align:'center'},  
        {field:'InvalidFlag',title:'InvalidFlag',width:100,align:'center',hidden:true},
        {field:'ManageLocDR',title:'ManageLocDR',width:100,align:'center',hidden:true},
        {field:'userdr',title:'userdr',width:100,align:'center',hidden:true},
        {field:'User',title:'组领导',width:100,align:'center'}, 
        {field:'ManageLoc',title:'管理科室',width:100,align:'center'},
        {field:'Check',title:'维修组成员',width:100,align:'center',formatter: CheckMaintGroupList} 
                       
    ]],
    onClickRow : function (rowIndex, rowData) {
        maintgroupDataGrid_OnClickRow();
    }, 
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75]   
});

function CheckMaintGroupList(value,row)  //查看维修组成员
{
	var str=row.RowID;
	var str="MGroupDR="+str;
	var btn='<A onclick="window.open(&quot;dhceqmcmaintgrouplist.csp?'+str+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/detail.png" /></A>'
	return btn;
}
 //查询		需求号:264231
function FindGridData()
{
	$('#maintgroupdatagrid').datagrid({    
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQMCMaintGroup",
        QueryName:"GetMaintGroup",
        Arg1:$('#Code').val(),
        Arg2:$('#Desc').val(),
	    Arg3:$('#User').combogrid('getValue'),
        Arg4:$('#ManageLoc').combogrid('getValue'),
        Arg5:$('#Remark').val(),
        ArgCnt:5
    },
    border:'true',
    singleSelect:true});
    //EmptyInput();		需求号:264241	Mozy	2016-10-08
}
/// 新增AddGridData方法
    function AddGridData(){
	if ($('#Code').val()==""){
           $.messager.alert("错误", "代码不能为空！", 'error')
           return false;
    }
    if ($('#Desc').val()==""){
            $.messager.alert("错误", "描述不能为空！", 'error')
            return false;
    }
       if ($('#User').combogrid('getValue')==""){
            $.messager.alert("错误", "组领导不能为空！", 'error')
            return false;
	        }
   /* if ($('#ManageLoc').combogrid('getValue')==""){
            $.messager.alert("错误", "管理科室不能为空！", 'error')
            return false; }
            */
    var MaintGroupInfo="^"+$('#Code').val()+"^"+$('#Desc').val()+"^"+$('#Remark').val()+"^"+$('#User').combogrid('getValue')+"^"+$('#InvalidFlag').val()+"^"+$('#ManageLoc').combogrid('getValue')
    $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQMCMaintGroup",
                MethodName:"SaveMaintGroup",
                Arg1:MaintGroupInfo,
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
            $('#maintgroupdatagrid').datagrid('reload'); 
            $.messager.show({
                title: '提示',
                msg:'保存成功'
            });
		EmptyInput();	
            }   
            else {
               $.messager.alert('保存失败！',data, 'warning')
               return;
               }
           }
        })
}
function UpdateGridData() //更新
{
	if ($('#Rowid').val()==""){
		$.messager.alert("错误", "请选中一行！", 'error')  
            return false;
	}
    if ($('#Code').val()==""){
           $.messager.alert("错误", "代码不能为空！", 'error')
           return false;
    }
    if ($('#Desc').val()==""){
            $.messager.alert("错误", "描述不能为空！", 'error')
            return false;
    }
    if ($('#User').combogrid('getValue')==""){
            $.messager.alert("错误", "组领导不能为空！", 'error')
            return false;
	        }
     /* 
       if ($('#ManageLoc').combogrid('getValue')==""){
            $.messager.alert("错误", "管理科室不能为空！", 'error')
            return false; }
	    */
      var MaintGroupInfo=$('#Rowid').val()+"^"+$('#Code').val()+"^"+$('#Desc').val()+"^"+$('#Remark').val()+"^"+$('#User').combogrid('getValue')+"^"+$('#InvalidFlag').val()+"^"+$('#ManageLoc').combogrid('getValue')
    $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQMCMaintGroup",
                MethodName:"SaveMaintGroup",
                Arg1:MaintGroupInfo,
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
            if (data==0) {   ///根据返回值判断是否成功
            $('#maintgroupdatagrid').datagrid('reload'); 
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
    if ($('#Rowid').val()==""){
            $.messager.alert("错误", "请选中一行！", 'error') 
            return false;
    } 
    var rows = $('#maintgroupdatagrid').datagrid('getSelections');
    var ids = [];
    var unSaveIndexs = [];
    if (rows.length > 0) {
        $.messager.confirm('请确认','您确定要删除所选的行？', function (b) { 
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
                ClassName:"web.DHCEQMCMaintGroup",
                MethodName:"DeleteMaintGroup",
                Arg1:$('#Rowid').val(),
                ArgCnt:1
            },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data ==0) {
            $('#maintgroupdatagrid').datagrid('reload');
            $.messager.show({
                title: '提示',
                msg: '删除成功'
            });
		EmptyInput();  /// 删除后输入框应清空	
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
/// 描述:新增清空函数
function EmptyInput()
{
    $('#Rowid').val("");
    $('#Code').val("");
    $('#Desc').val("");
    $('#Remark').val(""); 
    $('#User').combogrid('setValue',"");
    $('#Manageloc').combogrid('setValue',""); //add by wy 2017-5-3 需求:371377,371328
}
});