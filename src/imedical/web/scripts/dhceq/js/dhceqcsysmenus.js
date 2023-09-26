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
        			{field:'name',title:'����'},
        			{field:'caption',title:'˵��'},
        			{field:'clienttype',title:'�ͻ�������'}  /// Modfied by zc 2015-07-30 ZC0027
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
        {field:'desc',title:'ҵ��'},
        {field:'modletype',title:'ģ��'}
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
             $('#menudatagrid').datagrid('unselectAll');  //add by mwz 20180313 �����:554658
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
                text:'����',          
                handler: function(){  /// Modfied by zc 2015-07-30 ZC0027
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
    	{field:'Rowid',title:'Rowid',width:50,hidden:true},    
        {field:'moduletype',title:'ģ��',width:60,align:'center'},
        {field:'busstype',title:'ҵ��',width:95,align:'center'},
        {field:'busstypedr',title:'ҵ��dr',width:50,hidden:true},
        {field:'name',title:'����',width:100,align:'center'},    
        {field:'caption',title:'˵��',width:100,align:'center'},
        {field:'menutype',title:'�˵�����',width:100,align:'center'},    
        {field:'clienttype',title:'�ͻ�������',width:70,align:'center'},    
        {field:'parentmenu',title:'���˵�',width:100,align:'center'},
        {field:'image',title:'ͼ��',width:100,align:'center'},    
        {field:'linkurl',title:'����',width:100,align:'center'},    
        {field:'sequence',title:'˳��',width:50,align:'center'},
        {field:'shortcutkey',title:'��ݼ�',width:60,align:'center'},    
        {field:'showinnew',title:'�´��ڴ�',width:100,align:'center'},    
        {field:'remark',title:'��ע',width:100,align:'center'},
        {field:'date',title:'date',width:100,align:'center',hidden:true},    
        {field:'time',title:'time',width:100,align:'center',hidden:true},    
        {field:'user',title:'������',width:100,align:'center',hidden:true}            
    ]],
    onClickRow : function (rowIndex, rowData) {
        menudatagrid_OnClickRow();
    }, 
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75]    
});
//add by mwz 2018-03-13 ����ţ�553564
//��ѯǰ��������������
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
	CheckValue();   //add by mwz 2018-03-13 ����ţ�553564
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
/// ����:����AddgridData����
function AddgridData(){
	if ($('#moduletype').combogrid('getValue')==""){
            $.messager.alert("����", "�˵�ģ�鲻��Ϊ�գ�", 'error')
            return false;
    }
    if ($('#name').val()==""){
           $.messager.alert("����", "�˵����Ʋ���Ϊ�գ�", 'error')  //add by wy 2017-5-4 ����371028 
           return false;
    }
    if ($('#caption').val()==""){
            $.messager.alert("����", "�˵�˵������Ϊ�գ�", 'error')//add by wy 2017-5-4 ����371028
            return false;
    }
    if ($('#menutype').val()==""){
           $.messager.alert("����", "�˵����Ͳ���Ϊ�գ�", 'error')
           return false;
    }
    if ($('#clienttype').combogrid('getValue')==""){
            $.messager.alert("����", "�ͻ������Ͳ���Ϊ�գ�", 'error')
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
            $('#menudatagrid').datagrid('reload'); 
            $.messager.show({
                title: '��ʾ',
                msg: '����ɹ�'
            }); 
			Clear();  /// Modfied by zc 2015-09-11 ZC0029  �����ɹ���������е�����Ӧ���
            }   
            else {
               $.messager.alert('����ʧ�ܣ�',data, 'warning')
               return;
               }
           }
           
  
        })
	
}
function SavegridData(){
	if ($('#Rowid').val()==""){  /// Modfied by zc 2015-07-30 ZC0027
            $.messager.alert("����", "��ѡ��һ�У�", 'error')
            return false;
    } 
    if ($('#moduletype').combogrid('getValue')==""){
            $.messager.alert("����", "�˵�ģ�鲻��Ϊ�գ�", 'error')
            return false;
    }
    if ($('#name').val()==""){
           $.messager.alert("����", "�˵����Ʋ���Ϊ�գ�", 'error')
           return false;
    }
    if ($('#caption').val()==""){
            $.messager.alert("����", "�˵�˵������Ϊ�գ�", 'error')
            return false;
    }
    if ($('#menutype').val()==""){
           $.messager.alert("����", "�˵����Ͳ���Ϊ�գ�", 'error')
           return false;
    }
    if ($('#clienttype').combogrid('getValue')==""){
            $.messager.alert("����", "�ͻ������Ͳ���Ϊ�գ�", 'error')
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
            $('#menudatagrid').datagrid('reload'); 
            $.messager.show({
                title: '��ʾ',
                msg: '����ɹ�'
            });
			Clear();  /// Modfied by zc 2015-09-11 ZC0029  ���³ɹ���������е�����Ӧ���
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
            $.messager.alert("����", "��ѡ��һ�У�", 'error')  /// Modfied by zc 2015-07-30 ZC0027
            return false;
    } 
    var rows = $('#menudatagrid').datagrid('getSelections');
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
                title: '��ʾ',
                msg: 'ɾ���ɹ�'
            }); 
			Clear();  /// Modfied by zc 2015-09-11 ZC0029  ɾ���ɹ���������е�����Ӧ���
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
/// ����:����Clear����
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