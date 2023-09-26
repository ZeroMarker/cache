/**************************************
名称: web.DHCEQM.DHCEQSharingPlatform
描述: 经验分享平台
编写者：李苗苗 
编写日期:2015-12-28
***************************************/
$(document).ready(function () {
var SelectedRowID = 0;
var preRowID=0; 
///Creator： 李苗苗 
///CreatDate： 2015-12-28 
///Description:： 点击列表项
function roledatagrid_OnClickRow()
{
     var selected=$('#roledatagrid').datagrid('getSelected');
     if (selected)
     {       
        var SelectedRowID=selected.RowID;
        if(preRowID!=SelectedRowID)
        {
             $('#RowID').val(selected.RowID);
             $('#Type').combobox('setValue',selected.Type);
             $('#Rate').val(selected.Rate);
             $('#Status').combobox('setValue',selected.Status);
             $('#Content').val(selected.Content);
             $('#UpdateUserName').val(selected.UpdateUserName);
			 $('#UpdateUserDR').val(selected.UpdateUserDR);
			 $('#UpdateDate').val(selected.SPUpdateDate);
			 $('#UpdateTime').val(selected.SPUpdateTime);
  			 $('#Title').val(selected.Title);
  			 if(selected.AnonymousFlag=='Y')
  			 {

  				$("input[name='AnonymousFlag'][value='Y']").prop('checked','true');
  			 }
  			 else
  			 {
  				$("input[name='AnonymousFlag'][value='N']").prop('checked','true');
  			 }

  			 DetermineUser(selected.Status);
             $("#add").linkbutton("disable");
             preRowID=SelectedRowID;
         }
         else
         {
             $('#RowID').val("");
             $('#Type').combobox('setValue',"");
             $('#Rate').val("");
             $('#Status').combobox('setValue',"");;
             $('#Content').val("");
             $('#UpdateUserName').val("");
			 $('#UpdateUserDR').val("");
			 $('#UpdateDate').val("");
			 $('#UpdateTime').val("");
  			 $('#Title').val("");
  			 $('#AnonymousFlag').val("");
  	         $("input[name='AnonymousFlag'][value='N']").prop('checked','true');
             SelectedRowID = 0;
             preRowID=0;
             $("#add").linkbutton("enable");
             DetermineUser();
         }
     }
} 

$('#roledatagrid').datagrid({ 
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQM.DHCEQSharingPlatform",
        QueryName:"GetSharingPlatforms",
        ArgCnt:0
    },
    border:'true',
    singleSelect:true,
    toolbar:[{  
                id:"add",
    			iconCls: 'icon-add', 
                text:'新增',
                handler: function(){
                     AddgridData();
                     SelectedRowID = 0;
                     preRowID=0;
                }   
                },'------------------------',{ 
                id:"updata",        
                iconCls: 'icon-save',
                text:'保存', 
                disabled:"ture",        
                handler: function(){
                     SavegridData();
                }   
                },'------------------------',{ 
                id:"delete",       
                iconCls: 'icon-cut', 
                text:'删除',
                disabled:"ture",      
                 handler: function(){
                     DeleteGridData();
                     }      
                 },'------------------------',{ 
                 id:"submit",
                 iconCls: 'icon-ok', 
                 text:'提交',
                 disabled:"ture",      
                 handler: function(){
                    Submit();
                    $("#updata").linkbutton("enable");
            	    $("#unsubmit").linkbutton("enable");
            		$("#submit").linkbutton("disable");
            		$("#delete").linkbutton("disable");
            		$("#aduit").linkbutton("enable");
            		$('#Status').combobox('setValue',1);
                     }
                 },'------------------------',{
	            id:"unsubmit",       
                iconCls: 'icon-no', 
                text:'取消提交',
                disabled:"ture",      
                 handler: function(){
                    UnSubmit();
                    $("#updata").linkbutton("enable");
            	    $("#unsubmit").linkbutton("disable");
            		$("#submit").linkbutton("enable");
            		$("#delete").linkbutton("enable");
            		$("#aduit").linkbutton("disable");
            		$('#Status').combobox('setValue',0);
                     }       
                 },'------------------------',{ 
                id:"aduit",       
                iconCls: 'icon-edit',
                text:'审核',
                disabled:"ture",      
                 handler: function(){
                    Aduit();
                    $("#updata").linkbutton("disable");
            	    $("#unsubmit").linkbutton("disable");
            		$("#submit").linkbutton("disable");
            		$("#delete").linkbutton("disable");
            		$("#aduit").linkbutton("disable");
            		$('#Status').combobox('setValue',2);
                     }       
                 },'------------------------',{        
                iconCls: 'icon-search', 
                text:'查询',      
                 handler: function(){
                     findGridData();
                     }      
                 }] , 
   
    columns:[[
        {field:'Detail',title:'详细',width:50,align:'center',formatter: fomartOperation},  
    	{field:'RowID',title:'RowID',width:50,hidden:true},    
        {field:'Type',title:'类型',width:60,align:'center'},
        {field:'Title',title:'标题',width:500,align:'center'}, 
        {field:'Content',title:'正文',width:50,hidden:true},      
        {field:'Status',title:'状态',width:60,align:'center'},  
        {field:'AnonymousFlag',title:'是否匿名',width:80,align:'center',hidden:true}, 
        {field:'Rate',title:'平均分',width:100,align:'center'}, 
        {field:'UpdateUserDR',title:'发帖人ID',width:50,hidden:true},    
        {field:'UpdateUserName',title:'发帖人姓名',width:100,align:'center'},
        {field:'SPUpdateDate',title:'发帖日期',width:100,align:'center'},       
        {field:'SPUpdateTime',title:'发帖时间',width:100,align:'center'},                 
    ]],
    onClickRow : function (rowIndex, rowData) 
    {
        roledatagrid_OnClickRow();
    }, 
    pagination:true,
    pageSize:12,
    pageNumber:1,
    pageList:[12,24,36,48,60]   
});
///Creator： 李苗苗 
///CreatDate： 2015-12-28 
///Description:： 跳转到明细页面
function fomartOperation(value,row,index)
 {
	var str=row.RowID;
	var str="id="+str;
	var url='dhceqsharingplatformlist.csp?'+str;
	var btn='<A onclick="OpenNewWindow(&quot;'+url+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/detail.png" /></A>' /// Modfied by zc 2015-07-27 ZC0026
	return btn;
 }
 ///Creator： 李苗苗 
///CreatDate： 2015-12-28 
///Description:： 查找按钮的实现
function findGridData(){
	$('#roledatagrid').datagrid({    
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQM.DHCEQSharingPlatform",
        QueryName:"GetSharingPlatforms",
        Arg1:$('#Status').combobox('getValue'),
        Arg2:"",	//$('#UpdateUserName').val(),
        Arg3:$('#Title').val(),
        ArgCnt:3
    },
    border:'true',
    singleSelect:true});
}
///Creator： 李苗苗 
///CreatDate： 2015-12-28 
///Description:： 添加按钮的实现
function AddgridData(){
	if ($('#Title').val()==""){
           $.messager.alert("错误", "标题不能为空！", 'error')
           return false;
    }
    if ($('#Content').val()==""){
            $.messager.alert("错误", "正文不能为空！", 'error')
            return false;
    }
    if ($('#Type').combobox('getValue')==""){
            $.messager.alert("错误", "类型不能为空！", 'error')
            return false;
    }
    var val='^'+$('#Title').val()+'^'+$('#Content').val()+'^'+$('#Type').combobox('getValue')+'^'+$("input[name='AnonymousFlag']:checked").val();
    $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{       
                ClassName:"web.DHCEQM.DHCEQSharingPlatform",
                MethodName:"AddSharingPlatform",
                Arg1:val,
                ArgCnt:1
            },
            beforeSend: function () {
                $.messager.progress({
                text: '正在保存中...'
                });
            },
           	error:function(XMLHttpRequest, textStatus, errorThrown)
           	{
            	messageShow("","","",XMLHttpRequest.status);
                messageShow("","","",XMLHttpRequest.readyState);
                messageShow("","","",textStatus);
             },
            success:function (data, response, status) {
            	$.messager.progress('close');
            	if (data==0) 
            	{
            		$('#roledatagrid').datagrid('reload'); 
            		$.messager.show(
            		{
                		title: '提示',
               			msg: '保存成功'
                    });
					Clear();			
            	}   
            else 
            {
               $.messager.alert('保存失败！',data, 'warning')
               return;
            }
           }
        })
}
///Creator： 李苗苗 
///CreatDate： 2015-12-28 
///Description:： 更新按钮的实现
function SavegridData(){
	if ($('#RowID').val()==""){
           $.messager.alert("错误", "请选中一行！", 'error') 
           return false;
    }
	if ($('#Title').val()==""){
           $.messager.alert("错误", "标题不能为空！", 'error')
           return false;
    }
    if ($('#Content').val()==""){
            $.messager.alert("错误", "正文不能为空！", 'error')
            return false;
    }
    if ($('#Type').combobox('getValue')==""){
            $.messager.alert("错误", "类型不能为空！", 'error')
            return false;
    }
    var val=$('#RowID').val()+'^'+$('#Title').val()+'^'+$('#Content').val()+'^'+$('#Type').combobox('getValue')+'^'+$("input[name='AnonymousFlag']:checked").val();
 $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQM.DHCEQSharingPlatform",
                MethodName:"SaveSharingPlatform",
                Arg1:val,
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
            if (data==0) {  
            $('#roledatagrid').datagrid('reload'); 
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
///Creator： 李苗苗 
///CreatDate： 2015-12-28 
///Description:： 删除按钮的实现
function DeleteGridData(){
    if ($('#RowID').val()==""){
            $.messager.alert("错误", "请选中一行！", 'error') 
            return false;
    } 
    var rows = $('#roledatagrid').datagrid('getSelections');
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
                ClassName:"web.DHCEQM.DHCEQSharingPlatform",
                MethodName:"DeleteSharingPlatform",
                Arg1:$('#RowID').val(),
                ArgCnt:1
            },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data ==0) {
            $('#roledatagrid').datagrid('reload');
            $.messager.show({
                title: '提示',
                msg: '删除成功'
            });
			Clear(); 	
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
///Creator： 李苗苗 
///CreatDate： 2015-12-28 
///Description:： 提交按钮的实现
function Submit(){
	if ($('#RowID').val()==""){
           $.messager.alert("错误", "请选中一行！", 'error') 
           return false;
    }
 $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQM.DHCEQSharingPlatform",
                MethodName:"Submit",
                Arg1:$('#RowID').val(),
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
            if (data==0) {  
            $('#roledatagrid').datagrid('reload'); 
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
///Creator： 李苗苗 
///CreatDate： 2015-12-28 
///Description:： 取消提交按钮的实现
function UnSubmit(){
	if ($('#RowID').val()==""){
           $.messager.alert("错误", "请选中一行！", 'error') 
           return false;
    }
 $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQM.DHCEQSharingPlatform",
                MethodName:"UnSubmit",
                Arg1:$('#RowID').val(),
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
            if (data==0) {  
            $('#roledatagrid').datagrid('reload'); 
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
///Creator： 李苗苗 
///CreatDate： 2015-12-28 
///Description:： 审核按钮的实现
function Aduit(){
	if ($('#RowID').val()==""){
           $.messager.alert("错误", "请选中一行！", 'error') 
           return false;
    }
 $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQM.DHCEQSharingPlatform",
                MethodName:"Aduit",
                Arg1:$('#RowID').val(),
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
            if (data==0) {  
            $('#roledatagrid').datagrid('reload'); 
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
///Creator： 李苗苗 
///CreatDate： 2015-12-28 
///Description:： 判断登陆人与发帖人是否一致以改变按钮的状态
function DetermineUser(Status){
 $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQM.DHCEQSharingPlatform",
                MethodName:"DetermineUser",
                Arg1:$('#UpdateUserDR').val(),
                ArgCnt:1
            },
            beforeSend: function () {
            },
           	error:function(XMLHttpRequest, textStatus, errorThrown){
                        messageShow("","","",XMLHttpRequest.status);
                        messageShow("","","",XMLHttpRequest.readyState);
                        messageShow("","","",textStatus);
                    },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data==0) { 
            	$("#updata").linkbutton("disable");
            	$("#unsubmit").linkbutton("disable");
            	$("#submit").linkbutton("disable");
            	$("#delete").linkbutton("disable");
           		$("#aduit").linkbutton("disable");
            }   
            else {
             if(Status=="审核")
  			 {
	  	    	$("#updata").linkbutton("disable");
            	$("#unsubmit").linkbutton("disable");
            	$("#submit").linkbutton("disable");
            	$("#delete").linkbutton("disable");
            	$("#aduit").linkbutton("disable");
	  	     }
	  	     else if(Status=="提交")
	  	     {
		  	    $("#updata").linkbutton("enable");
            	$("#unsubmit").linkbutton("enable");
            	$("#submit").linkbutton("disable");
            	$("#delete").linkbutton("disable");
            	$("#aduit").linkbutton("enable");
		  	 }
		  	 else if(Status=="新增")
	  	     {
		  	    $("#updata").linkbutton("enable");
            	$("#unsubmit").linkbutton("disable");
            	$("#submit").linkbutton("enable");
            	$("#delete").linkbutton("enable");
            	$("#aduit").linkbutton("disable");
		  	 }
            return;
             }
           }
        })
}
/// Modfied by zc 2015-09-11  ZC0029
/// 描述:新增清空函数
function Clear(){
	 $('#RowID').val("");
	 $('#Type').combobox('setValue',"");
 	 $('#Rate').val("");
	 $('#Status').combobox('setValue',"");;
 	 $('#Content').val("");
  	 $('#UpdateUserName').val("");
 	 $('#UpdateUserDR').val("");
 	 $('#UpdateDate').val("");
 	 $('#UpdateTime').val("");
  	 $('#Title').val("");
     $("input[name='AnonymousFlag'][value='N']").prop("checked",true);
}
});