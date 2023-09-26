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
        {field:'desc',title:'����'},
		{field:'remark',title:'����'}
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
                text:'����',          
                handler: function(){   /// Modfied by zc 2015-07-30 ZC0027
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
    	{field:'rowid',title:'LRowid',width:50,hidden:true},    
        {field:'managelimitdr',title:'managelimitdr',width:150,align:'center',hidden:true},
        {field:'type',title:'����',width:100,align:'center'},
        {field:'value',title:'����',width:300,align:'left'},
		{field:'accessflag',title:'���ʱ�ʶ',width:60,align:'center',formatter: accessOperation}
    ]],
    onClickRow : function (rowIndex, rowData) {
        managelimitlistdatagrid_OnClickRow();
    }, 
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75]    
});
/// Modfied by wy 2017-06-19 ����394351
///�޶���ϸ�޷���ѯ
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
/// ����:����AddgridData����
function AddgridData(){
	if ($('#value').combogrid('getValue')==""){
            $.messager.alert("����", "���ݲ���Ϊ�գ�", 'error')
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
            //messageShow("","","",data);
            if (data >0) {
            $('#managelimitlistdatagrid').datagrid('reload'); 
            $.messager.show({
                title: '��ʾ',
                msg: '����ɹ�'
            }); 
			Clear();      /// Modfied by zc 2015-09-11 ZC0029 �����ɹ���������е�����Ӧ���
            }   
            else {
               $.messager.alert('����ʧ�ܣ�',data, 'warning')
               return;
               }
           }         
        })
}
function SavegridData(){
	if ($('#LRowid').val()==""){
            $.messager.alert("����", "��ѡ��һ�У�", 'error')  /// Modfied by zc 2015-07-30 ZC0027
            return false;
    }
    if ($('#value').combogrid('getValue')==""){
            $.messager.alert("����", "���ݲ���Ϊ�գ�", 'error')
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
            //messageShow("","","",data);
            if (data==0) {  /// Modfied by zc 2015-07-30 ZC0027
            $('#managelimitlistdatagrid').datagrid('reload'); 
            $.messager.show({
                title: '��ʾ',
                msg: '����ɹ�'
            }); 
			Clear();    /// Modfied by zc 2015-09-11 ZC0029 ���³ɹ���������е�����Ӧ���
            }   
            else {
               $.messager.alert('����ʧ�ܣ�',data, 'warning')
               return;
               }
           }         
        })
}
function DeleteGridData(){
    if ($('#LRowid').val()==""){
            $.messager.alert("����", "��ѡ��һ�У�", 'error')  /// Modfied by zc 2015-07-30 ZC0027
            return false;
    } 
    var rows = $('#managelimitlistdatagrid').datagrid('getSelections');
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
                title: '��ʾ',
                msg: 'ɾ���ɹ�'
            }); 
			Clear();    /// Modfied by zc 2015-09-11 ZC0029 ɾ���ɹ���������е�����Ӧ���
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
        $.messager.alert("����","��ѡ��һ�У�",'error')
    }
}
/// Modfied by zc 2015-09-11 ZC0029
/// ����:������պ���
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