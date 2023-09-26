/**************************************
����: web.DHCEQM.DHCEQSharingPlatform
����: �������ƽ̨
��д�ߣ������� 
��д����:2015-12-28
***************************************/
$(document).ready(function () {
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
                text:'����',
                handler: function(){
                     AddgridData();
                     SelectedRowID = 0;
                     preRowID=0;
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
                 id:"submit",
                 iconCls: 'icon-ok', 
                 text:'�ύ',
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
                text:'ȡ���ύ',
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
                text:'���',
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
                text:'��ѯ',      
                 handler: function(){
                     findGridData();
                     }      
                 }] , 
   
    columns:[[
        {field:'Detail',title:'��ϸ',width:50,align:'center',formatter: fomartOperation},  
    	{field:'RowID',title:'RowID',width:50,hidden:true},    
        {field:'Type',title:'����',width:60,align:'center'},
        {field:'Title',title:'����',width:500,align:'center'}, 
        {field:'Content',title:'����',width:50,hidden:true},      
        {field:'Status',title:'״̬',width:60,align:'center'},  
        {field:'AnonymousFlag',title:'�Ƿ�����',width:80,align:'center',hidden:true}, 
        {field:'Rate',title:'ƽ����',width:100,align:'center'}, 
        {field:'UpdateUserDR',title:'������ID',width:50,hidden:true},    
        {field:'UpdateUserName',title:'����������',width:100,align:'center'},
        {field:'SPUpdateDate',title:'��������',width:100,align:'center'},       
        {field:'SPUpdateTime',title:'����ʱ��',width:100,align:'center'},                 
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
///Creator�� ������ 
///CreatDate�� 2015-12-28 
///Description:�� ��ת����ϸҳ��
function fomartOperation(value,row,index)
 {
	var str=row.RowID;
	var str="id="+str;
	var url='dhceqsharingplatformlist.csp?'+str;
	var btn='<A onclick="OpenNewWindow(&quot;'+url+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/detail.png" /></A>' /// Modfied by zc 2015-07-27 ZC0026
	return btn;
 }
 ///Creator�� ������ 
///CreatDate�� 2015-12-28 
///Description:�� ���Ұ�ť��ʵ��
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
///Creator�� ������ 
///CreatDate�� 2015-12-28 
///Description:�� ��Ӱ�ť��ʵ��
function AddgridData(){
	if ($('#Title').val()==""){
           $.messager.alert("����", "���ⲻ��Ϊ�գ�", 'error')
           return false;
    }
    if ($('#Content').val()==""){
            $.messager.alert("����", "���Ĳ���Ϊ�գ�", 'error')
            return false;
    }
    if ($('#Type').combobox('getValue')==""){
            $.messager.alert("����", "���Ͳ���Ϊ�գ�", 'error')
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
                text: '���ڱ�����...'
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
                		title: '��ʾ',
               			msg: '����ɹ�'
                    });
					Clear();			
            	}   
            else 
            {
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
	if ($('#Title').val()==""){
           $.messager.alert("����", "���ⲻ��Ϊ�գ�", 'error')
           return false;
    }
    if ($('#Content').val()==""){
            $.messager.alert("����", "���Ĳ���Ϊ�գ�", 'error')
            return false;
    }
    if ($('#Type').combobox('getValue')==""){
            $.messager.alert("����", "���Ͳ���Ϊ�գ�", 'error')
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
                title: '��ʾ',
                msg: 'ɾ���ɹ�'
            });
			Clear(); 	
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
///Description:�� �ύ��ť��ʵ��
function Submit(){
	if ($('#RowID').val()==""){
           $.messager.alert("����", "��ѡ��һ�У�", 'error') 
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
///Description:�� ȡ���ύ��ť��ʵ��
function UnSubmit(){
	if ($('#RowID').val()==""){
           $.messager.alert("����", "��ѡ��һ�У�", 'error') 
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
///Description:�� ��˰�ť��ʵ��
function Aduit(){
	if ($('#RowID').val()==""){
           $.messager.alert("����", "��ѡ��һ�У�", 'error') 
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
///Description:�� �жϵ�½���뷢�����Ƿ�һ���Ըı䰴ť��״̬
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
             if(Status=="���")
  			 {
	  	    	$("#updata").linkbutton("disable");
            	$("#unsubmit").linkbutton("disable");
            	$("#submit").linkbutton("disable");
            	$("#delete").linkbutton("disable");
            	$("#aduit").linkbutton("disable");
	  	     }
	  	     else if(Status=="�ύ")
	  	     {
		  	    $("#updata").linkbutton("enable");
            	$("#unsubmit").linkbutton("enable");
            	$("#submit").linkbutton("disable");
            	$("#delete").linkbutton("disable");
            	$("#aduit").linkbutton("enable");
		  	 }
		  	 else if(Status=="����")
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
/// ����:������պ���
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