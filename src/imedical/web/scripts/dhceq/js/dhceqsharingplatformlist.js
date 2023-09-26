/**************************************
����: web.DHCEQM.DHCEQSharingPlatform
����: �������ƽ̨��ϸ
��д�ߣ������� 
��д����:2015-12-28
***************************************/
$(document).ready(function () {
	Request = GetRequest();
	$('#SharingPlatformDR').val(Request["id"]);
	InitializeData();
	GetContent();
	DetermineUser(0);
var SelectedRowID = 0;
var preRowID=0; 
///Creator�� ������ 
///CreatDate�� 2015-12-28 
///Description:�� ����б���
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
                text:'����',
                disabled:"ture", 
                handler: function(){
                     AddgridData();
                     
                }   
                },'------------------------',{ 
                id:"updata",        
                iconCls: 'icon-save',
                text:'����', 
                disabled:"ture",        
                handler: function(){
                     SavegridData();
                }   
                },'------------------------',{ 
                id:"delete",       
                iconCls: 'icon-cut', 
                text:'ɾ��',
                disabled:"ture",      
                 handler: function(){
                     DeleteGridData();
                     }      
                 },'------------------------',{        
                iconCls: 'icon-search', 
                text:'��ѯ',      
                 handler: function(){
                     findGridData();
                     }      
                 }] , 
   
    columns:[[
    	{field:'RowID',title:'RowID',width:50,hidden:true},    
        {field:'SharingPlatformDR',title:'SharingPlatformDR',width:60,hidden:true}, 
        {field:'Content',title:'����',width:50,hidden:true},      
        {field:'Picture',title:'ͼƬ',width:60,align:'center',hidden:true},  
        {field:'AnonymousFlag',title:'�Ƿ�����',width:80,align:'center',hidden:true},
        {field:'UpdateUserName',title:'����������',width:100,align:'center'}, 
        {field:'Rate',title:'����',width:100,align:'center'}, 
        {field:'UpdateUserDR',title:'������ID',width:50,hidden:true},    
        {field:'SPLUpdateDate',title:'��������',width:100,align:'center'},       
        {field:'SPLUpdateTime',title:'����ʱ��',width:100,align:'center'},               
    ]],
    onClickRow : function (rowIndex, rowData) {
        roledatagrid_OnClickRow();
    }, 
    pagination:true,
    pageSize:12,
    pageNumber:1,
    pageList:[12,24,36,48,60]   
});
///Creator�� ������ 
///CreatDate�� 2015-12-28 
///Description:�� ��ʼ���б�����
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
///Creator�� ������ 
///CreatDate�� 2015-12-28 
///Description:�� ���Ұ�ť��ʵ��
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
///Creator�� ������ 
///CreatDate�� 2015-12-28 
///Description:�� ��Ӱ�ť��ʵ��
function AddgridData(){
    if ($('#Content').val()==""){
        $.messager.alert("����", "���Ĳ���Ϊ�գ�", 'error')
        return false;
    }
    if ($('#Rate').val()==""){
        $.messager.alert("����", "���ֲ���Ϊ�գ�", 'error')
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
                text: '���ڱ�����...'
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
                title: '��ʾ',
                msg: '����ɹ�'
            });
			Clear();		
            }   
            else {
               $.messager.alert('����ʧ�ܣ�',data, 'warning')
               return;
               }
           }
        })
}
///Creator�� ������ 
///CreatDate�� 2015-12-28 
///Description:�� ���°�ť��ʵ��
function SavegridData(){
	if ($('#RowID').val()==""){
           $.messager.alert("����", "��ѡ��һ�У�", 'error')
           return false;
    }
    if ($('#Content').val()==""){
            $.messager.alert("����", "���Ĳ���Ϊ�գ�", 'error')
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
                text: '���ڱ�����...'
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
///Creator�� ������ 
///CreatDate�� 2015-12-28 
///Description:�� ɾ����ť��ʵ��
function DeleteGridData(){
    if ($('#RowID').val()==""){
            $.messager.alert("����", "��ѡ��һ�У�", 'error') 
            return false;
    } 
    var rows = $('#roledatagrid').datagrid('getSelections');
    var ids = [];
    var unSaveIndexs = [];
    if (rows.length > 0) {
        $.messager.confirm('��ȷ��', '��ȷ��Ҫɾ����ѡ���У�', function (b) { 
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
                title: '��ʾ',
                msg: 'ɾ���ɹ�'
            });
			Clear();  
			DetermineUser(0);	
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
///Creator�� ������ 
///CreatDate�� 2015-12-28 
///Description:�� �жϵ�½���뷢�����Ƿ�һ���Ըı䰴ť��״̬
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
///Creator�� ������ 
///CreatDate�� 2015-12-28 
///Description:�� ���������������
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
///Creator�� ������ 
///CreatDate�� 2015-12-28 
///Description:�� ����ƽ����
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
//��ȡurl��"?"������ִ�
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
/// ����:������պ���
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