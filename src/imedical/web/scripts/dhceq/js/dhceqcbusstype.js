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
    			iconCls: 'icon-add', /// Modfied by zc 2015-07-27 ZC0026 ������ť
                text:'����',          
                handler: function(){
                     AddgridData();
                }   
                },'------------------------',{         
                iconCls: 'icon-save',
                text:'����',          
                handler: function(){
                     UpdategridData();
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
    	{field:'rowid',title:'Rowid',width:50},    
        {field:'code',title:'����',width:60,align:'center'},
        {field:'desc',title:'����',width:100,align:'center'},       
        {field:'modletype',title:'ģ��',width:100,align:'center'},  
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
	var modletype=$('#modletype').combobox('getText')   //add by mwz 2017-08-10 ����ţ�396554
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
   if ($('#modletype').combobox('getValue')==""){
            $.messager.alert("����", "ģ�鲻��Ϊ�գ�", 'error')
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
            $('#busstypedatagrid').datagrid('reload'); 
            $.messager.show({
                title: '��ʾ',
                msg: '����ɹ�'
            });
			Clear(); 	/// Modfied by zc 2015-09-11 ZC0029  �����ɹ���Ӧ���������е�����	
            }   
            else {
               $.messager.alert('����ʧ�ܣ�',data, 'warning')
               return;
               }
           }
           
  
        })
}
function UpdategridData(){
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
   if ($('#modletype').combobox('getValue')==""){
            $.messager.alert("����", "ģ�鲻��Ϊ�գ�", 'error')
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
            if (data==0) { /// Modfied by zc 2015-07-27 ZC0026 ���ݷ���ֵ�ж��Ƿ�ɹ�
            $('#busstypedatagrid').datagrid('reload'); 
            $.messager.show({
                title: '��ʾ',
                msg: '����ɹ�'
            }); 
			Clear();  /// Modfied by zc 2015-09-11 ZC0029  ���³ɹ���Ӧ���������е�����
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
    var rows = $('#busstypedatagrid').datagrid('getSelections');
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
                title: '��ʾ',
                msg: 'ɾ���ɹ�'
            });
			Clear();	/// Modfied by zc 2015-09-11 ZC0029  ɾ���ɹ���Ӧ���������е�����
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
/// Modfied by zc 2015-09-11 ZC0029
/// ����:������պ���
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


