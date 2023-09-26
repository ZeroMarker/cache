$(document).ready(function () {
    $('#code').validatebox({
        width: 160
    });
    $('#desc').validatebox({
        width: 160
    });
    $('#LocFlag').validatebox({
        width: 160
    });
var SelectedRowID = 0;
var preRowID=0;  
function roledatagrid_OnClickRow()
{
     var selected=$('#roledatagrid').datagrid('getSelected');
     if (selected)
     {       
        var SelectedRowID=selected.rowid;
        if(preRowID!=SelectedRowID)
        {
             $('#Rowid').val(selected.rowid);
             $('#code').val(selected.code);
             $('#desc').val(selected.desc);
             $('#remark').val(selected.remark);
             $('#InvalidFlag').val(selected.invalidFlag);
             $('#LocFlag').combobox('setValue',selected.locFlagdr);
             preRowID=SelectedRowID;
         }
         else
         {
             $('#Rowid').val("");
             $('#code').val("");
             $('#desc').val("");
             $('#remark').val("");
             $('#InvalidFlag').val("");
             $('#LocFlag').combobox('setValue',"");
             SelectedRowID = 0;
             preRowID=0;
         }
     }
} 
$('#roledatagrid').datagrid({   
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQCApproveRole",
        QueryName:"GetRole",
        ArgCnt:0
    },
    border:'true',
    singleSelect:true,
    toolbar:[{  
    			iconCls: 'icon-add', /// Modfied by zc 2015-07-27 ZC0026 ������ť
                text:'����',          
                handler: function(){
                     AddgridData();
                }   
                },'------------------------',{         
                iconCls: 'icon-save',
                text:'����',          
                handler: function(){
                     SavegridData();
                }   
                },'------------------------',{        
                iconCls: 'icon-cut', 
                text:'ɾ��',      
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
    	{field:'rowid',title:'Rowid',width:50,hidden:true},    
        {field:'code',title:'����',width:60,align:'center'},
        {field:'desc',title:'����',width:150,align:'center'},       
        {field:'remark',title:'��ע',width:100,align:'center'},  
        {field:'invalidFlag',title:'InvalidFlag',width:100,align:'center',hidden:true},
        {field:'locFlag',title:'������ҷ�Χ',width:100,align:'center'}, 
        {field:'opt',title:'ҵ��',width:100,align:'center',formatter: fomartOperation},                 
    ]],
    onClickRow : function (rowIndex, rowData) {
        roledatagrid_OnClickRow();
    }, 
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75]   
});
function fomartOperation(value,row,index)
 {
	var str=row.rowid;
	var str="id="+str;
	//var btn="<a  href='dhceqcrolebuss.csp?"+str+"'><img border='0' src='../scripts/dhceq/easyui/themes/icons/detail.png' width='16' height='16'></a>"; 
	var btn='<A onclick="window.open(&quot;dhceqcrolebuss.csp?'+str+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/detail.png" /></A>' /// Modfied by zc 2015-07-27 ZC0026
	return btn;
 }
function findGridData(){
	$('#roledatagrid').datagrid({    
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQCApproveRole",
        QueryName:"GetRole",
        Arg1:$('#code').val(),
        Arg2:$('#desc').val(),
        Arg3:$('#LocFlag').combobox('getValue'),
        Arg4:$('#remark').val(),    //add by czf 519002
        ArgCnt:4
    },
    border:'true',
    singleSelect:true});
}
/// Modfied by zc 2015-07-27 ZC0026
/// ����:����AddgridData����
function AddgridData(){
	if ($('#code').val()==""){
           $.messager.alert("����", "���벻��Ϊ�գ�", 'error')
           return false;
    }
    if ($('#desc').val()==""){
            $.messager.alert("����", "��������Ϊ�գ�", 'error')
            return false;
    }
    /* if ($('#LocFlag').combobox('getValue')==""){
            $.messager.alert("����", "������ҷ�Χ����Ϊ�գ�", 'error')
            return false;
    }*/
    $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQCApproveRole",
                MethodName:"AddRole",
                Arg1:$('#code').val(),
                Arg2:$('#desc').val(),
                Arg3:$('#remark').val(),
				Arg4:$('#InvalidFlag').val(),
				Arg5:$('#LocFlag').combobox('getValue'),
                ArgCnt:5
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
            if (data >0) {
            $('#roledatagrid').datagrid('reload'); 
            $.messager.show({
                title: '��ʾ',
                msg: '����ɹ�'
            });
			Clear();	/// Modfied by zc 2015-09-11  ZC0029 �����������Ӧ���		
            }   
            else {
               $.messager.alert('����ʧ�ܣ�',data, 'warning')
               return;
               }
           }
        })
}
function SavegridData(){
	if ($('#Rowid').val()==""){
		$.messager.alert("����", "��ѡ��һ�У�", 'error')  /// Modfied by zc 2015-07-27 ZC0026
            return false;
	}
    if ($('#code').val()==""){
           $.messager.alert("����", "���벻��Ϊ�գ�", 'error')
           return false;
    }
    if ($('#desc').val()==""){
            $.messager.alert("����", "��������Ϊ�գ�", 'error')
            return false;
    }
    //alertShow($('#LocFlag').combobox('getValue'));
   /* if ($('#LocFlag').combobox('getValue')==""){
            $.messager.alert("����", "������ҷ�Χ����Ϊ�գ�", 'error')
            return false;
    }*/
    $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQCApproveRole",
                MethodName:"SaveRole",
                Arg1:$('#Rowid').val(),
                Arg2:$('#code').val(),
                Arg3:$('#desc').val(),
                Arg4:$('#remark').val(),
				Arg5:$('#InvalidFlag').val(),
				Arg6:$('#LocFlag').combobox('getValue'),
                ArgCnt:6
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
            if (data==0) {  /// Modfied by zc 2015-07-27 ZC0026 ���ݷ���ֵ�ж��Ƿ�ɹ�
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
function DeleteGridData(){
    if ($('#Rowid').val()==""){
            $.messager.alert("����", "��ѡ��һ�У�", 'error') /// Modfied by zc 2015-07-27 ZC0026
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
                ClassName:"web.DHCEQCApproveRole",
                MethodName:"DeleteRole",
                Arg1:$('#Rowid').val(),
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
			Clear();  /// Modfied by zc 2015-09-11  ZC0029 ɾ���������Ӧ���	
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
/// Modfied by zc 2015-09-11  ZC0029
/// ����:������պ���
function Clear(){
	$('#Rowid').val("");
    $('#code').val("");
    $('#desc').val("");
    $('#remark').val("");
    $('#InvalidFlag').val("");
    $('#LocFlag').combobox('setValue',"");
}
});