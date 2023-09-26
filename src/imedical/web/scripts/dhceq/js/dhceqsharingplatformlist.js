/**************************************
名称: web.DHCEQM.DHCEQSharingPlatform
描述: 经验分享平台明细
编写者：李苗苗 
编写日期:2015-12-28
***************************************/
$(document).ready(function () {
	Request = GetRequest();
	$('#SharingPlatformDR').val(Request["id"]);
	InitializeData();
	GetContent();
	DetermineUser(0);
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
             $('#Rate').val(selected.Rate);
             $('#Content').val(selected.Content);
             $('#UpdateUserName').val(selected.UpdateUserName);
			 $('#UpdateUserDR').val(selected.UpdateUserDR);
			 $('#UpdateDate').val(selected.SPLUpdateDate);
			 $('#UpdateTime').val(selected.SPLUpdateTime);
	         DetermineUser(1);
  			 if(selected.AnonymousFlag=='Y')
  			 {

  				$("input[name='AnonymousFlag'][value='Y']").prop('checked','true');
  			 }
  			 else
  			 {
  				$("input[name='AnonymousFlag'][value='N']").prop('checked','true');
  			 }
             preRowID=SelectedRowID;
         }
         else
         {
             $('#RowID').val("");
             $('#Rate').val("");
             $('#Content').val("");
             $('#UpdateUserName').val("");
			 $('#UpdateUserDR').val("");
			 $('#UpdateDate').val("");
			 $('#UpdateTime').val("");
			 $("input[name='AnonymousFlag'][value='N']").prop('checked','true');
             SelectedRowID = 0;
             preRowID=0;
             DetermineUser(0);
         }
     }
} 
$('#roledatagrid').datagrid(
{ 
    toolbar:[{  
                id:"add",
    			iconCls: 'icon-add', 
                text:'新增',
                disabled:"ture", 
                handler: function(){
                     AddgridData();
                     
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
                iconCls: 'icon-search', 
                text:'查询',      
                 handler: function(){
                     findGridData();
                     }      
                 }] , 
   
    columns:[[
    	{field:'RowID',title:'RowID',width:50,hidden:true},    
        {field:'SharingPlatformDR',title:'SharingPlatformDR',width:60,hidden:true}, 
        {field:'Content',title:'正文',width:50,hidden:true},      
        {field:'Picture',title:'图片',width:60,align:'center',hidden:true},  
        {field:'AnonymousFlag',title:'是否匿名',width:80,align:'center',hidden:true},
        {field:'UpdateUserName',title:'发帖人姓名',width:100,align:'center'}, 
        {field:'Rate',title:'评分',width:100,align:'center'}, 
        {field:'UpdateUserDR',title:'发帖人ID',width:50,hidden:true},    
        {field:'SPLUpdateDate',title:'发帖日期',width:100,align:'center'},       
        {field:'SPLUpdateTime',title:'发帖时间',width:100,align:'center'},               
    ]],
    onClickRow : function (rowIndex, rowData) {
        roledatagrid_OnClickRow();
    }, 
    pagination:true,
    pageSize:12,
    pageNumber:1,
    pageList:[12,24,36,48,60]   
});
///Creator： 李苗苗 
///CreatDate： 2015-12-28 
///Description:： 初始化列表数据
function InitializeData(){
	$('#roledatagrid').datagrid({    
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQM.DHCEQSharingPlatformList",
        QueryName:"GetSharingPlatformLists",
        Arg1:"",
        Arg2:$('#SharingPlatformDR').val(),
        ArgCnt:2
    },
    border:'true',
    singleSelect:true});
}
///Creator： 李苗苗 
///CreatDate： 2015-12-28 
///Description:： 查找按钮的实现
function findGridData(){
	$('#roledatagrid').datagrid({    
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQM.DHCEQSharingPlatformList",
        QueryName:"GetSharingPlatformLists",
        Arg1:$('#UpdateUserName').val(),
        Arg2:$('#SharingPlatformDR').val(),
        ArgCnt:2
    },
    border:'true',
    singleSelect:true});
}
///Creator： 李苗苗 
///CreatDate： 2015-12-28 
///Description:： 添加按钮的实现
function AddgridData(){
    if ($('#Content').val()==""){
        $.messager.alert("错误", "正文不能为空！", 'error')
        return false;
    }
    if ($('#Rate').val()==""){
        $.messager.alert("错误", "评分不能为空！", 'error')
        return false;
    }
    var val=$('#SharingPlatformDR').val()+'^'+$('#Content').val()+'^'+$("input[name='AnonymousFlag']:checked").val()+'^'+$('#Rate').val()+'^'+$('#Picture').val();
    $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{       
                ClassName:"web.DHCEQM.DHCEQSharingPlatformList",
                MethodName:"AddSharingPlatformList",
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
	        SetRate();
            $('#roledatagrid').datagrid('reload'); 
            $.messager.show({
                title: '提示',
                msg: '保存成功'
            });
			Clear();		
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
///Description:： 更新按钮的实现
function SavegridData(){
	if ($('#RowID').val()==""){
           $.messager.alert("错误", "请选中一行！", 'error')
           return false;
    }
    if ($('#Content').val()==""){
            $.messager.alert("错误", "正文不能为空！", 'error')
            return false;
    }
    var val=$('#RowID').val()+'^'+$('#SharingPlatformDR').val()+'^'+$('#Content').val()+'^'+$("input[name='AnonymousFlag']:checked").val()+'^'+$('#Rate').val()+'^';
 $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQM.DHCEQSharingPlatformList",
                MethodName:"SaveSharingPlatformList",
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
	        SetRate();  
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
                ClassName:"web.DHCEQM.DHCEQSharingPlatformList",
                MethodName:"DeleteSharingPlatformList",
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
			DetermineUser(0);	
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
///Description:： 判断登陆人与发帖人是否一致以改变按钮的状态
function DetermineUser(Selected){
 $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQM.DHCEQSharingPlatformList",
                MethodName:"DetermineUser",
                Arg1:$('#UpdateUserDR').val(),
                Arg2:$('#SharingPlatformDR').val(),
                ArgCnt:2
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
            if (data==3) {  
            	$("#add").linkbutton("disable");
            	$("#updata").linkbutton("disable");
            	$("#delete").linkbutton("disable");
            }   
            else {
	         if(Selected==1)
	         {
             if(data==0)
  			 {
	  			$("#add").linkbutton("disable");
	  	    	$("#updata").linkbutton("disable");
            	$("#delete").linkbutton("disable");
	  	     }
	  	     else if(data==2)
	  	     {
		  	    $("#add").linkbutton("disable");
		  	    $("#updata").linkbutton("enable");
            	$("#delete").linkbutton("enable");
		  	 }
		  	 else if(data==1)
	  	     {
		  	    $("#add").linkbutton("disable");
		  	    $("#updata").linkbutton("enable");
            	$("#delete").linkbutton("enable");
		  	 }
	         }
	         else
	         {
		        $("#add").linkbutton("enable");
		  	    $("#updata").linkbutton("disable");
            	$("#delete").linkbutton("disable");
		     }
            return;
             }
           }
        })
}
///Creator： 李苗苗 
///CreatDate： 2015-12-28 
///Description:： 获得主题帖的内容
function GetContent(){
 $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQM.DHCEQSharingPlatformList",
                MethodName:"GetContent",
                Arg1:$('#SharingPlatformDR').val(),
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
            	 var List=data.split("^");
            	 $('#MTitle').text(List[0]);
            	 $('#MAuthorInfo').text(List[1]);
            	 $('#MDateInfo').text(List[2]);
            	 $('#MContent').text(List[3]);
           }
        })
}
///Creator： 李苗苗 
///CreatDate： 2015-12-28 
///Description:： 设置平均分
function SetRate(){
 $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQM.DHCEQSharingPlatformList",
                MethodName:"SetRate",
                Arg1:$('#SharingPlatformDR').val(),
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
	        window.opener.location.reload();
            $.messager.progress('close');            
           }
        })
}
//2015-12-15  JYP
//获取url中"?"符后的字串
function GetRequest() {
  var url = location.search;
   var theRequest = new Object();
   if (url.indexOf("?") != -1) {
      var str = url.substr(1);
      strs = str.split("&");
      for(var i = 0; i < strs.length; i ++) {
         theRequest[strs[i].split("=")[0]]=(strs[i].split("=")[1]);
      }
   }
   return theRequest;
}
/// Modfied by zc 2015-09-11  ZC0029
/// 描述:新增清空函数
function Clear(){
	 $('#RowID').val("");
 	 $('#Rate').val("");
 	 $('#Content').val("");
  	 $('#UpdateUserName').val("");
 	 $('#UpdateUserDR').val("");
 	 $('#UpdateDate').val("");
 	 $('#UpdateTime').val("");
  	 $("input[name='AnonymousFlag'][value='N']").prop("checked",'true');

}
});