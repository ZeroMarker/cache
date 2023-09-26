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
        {field:'name',title:'����'},
        {field:'initials',title:'����'}
        ]],
   
	pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75],
	keyHandler: { 
		query: function(q) {
			ReloadGrid("User",q,q); //add by wy 2017-08-02 ����416779��413137
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
			     $('#ManagerFlag').prop("checked",true);//��
		     }
		     else
		     {
			     $('#ManagerFlag').prop("checked",false);//��
		     }
		     preRowID=selectedRowID;
	     }
         else
         {
             $('#Rowid').val("");
            // $('#Maintgroup').combogrid('setValue',"");
             $('#User').combogrid('setValue',"");
             $('#ManagerFlag').prop("checked",false);//��
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
                text:'����',          
                handler: function(){
                     AddGridData();
                }   
                },'------------------------',
                {         
                iconCls: 'icon-save',
                text:'����',          
                handler: function(){
                     UpdateGridData();
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
                     FindGridData();
                     }      
                 }] , 
   
    columns:[[
    	{field:'RowID',title:'Rowid',width:50,hidden:true},
        {field:'MaintGroupDR',title:'MaintGroupDR',width:100,align:'center',hidden:true},
        {field:'MaintGroup',title:'ά����',width:100,align:'center'},   
        {field:'User',title:'��Ա',width:90,align:'center'},
        {field:'userdr',title:'UserDR',width:100,align:'center',hidden:true},
        {field:'ManagerFlag',title:'������',width:100,align:'center'},
    ]],
    onClickRow : function (rowIndex, rowData) {
        maintgrouplistDataGrid_OnClickRow();
    }, 
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75]   
});

function FindGridData()  // ��ѯ
{
	$('#maintgrouplistdatagrid').datagrid({    
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQMCMaintGroupList",
        QueryName:"GetMaintGroupList", 
        Arg1:$('#User').combogrid('getText'),	//�����:264283		Mozy	2016-10-8
        Arg2:jQuery("#MGroupDR").val(),
        Arg3:$('#ManagerFlag').is(':checked'),	//�����:264283		Mozy	2016-10-13
        ArgCnt:3
    },
    border:'true',
    singleSelect:true});
    //EmptyInput();
}
function AddGridData(){	
	 if ($('#User').combogrid('getValue')==""){
            $.messager.alert("����", "��Ա����Ϊ�գ�", 'error')
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
            if (data ==0) {
            $('#maintgrouplistdatagrid').datagrid('reload'); 
            $.messager.show({
                title: '��ʾ',
                msg: '����ɹ�'
            });
			EmptyInput();	///�����������Ӧ���		
            }   
            else {
               $.messager.alert('����ʧ�ܣ�',data, 'warning')
               return;
               }
           }
        })
}
function getUrlParam(MGroupDR) 
{
	var reg = new RegExp("(^|&)" + MGroupDR + "=([^&]*)(&|$)"); //����һ������Ŀ�������������ʽ����
	var r = window.location.search.substr(1).match(reg);  //ƥ��Ŀ�����
	if (r != null) return unescape(r[2]); return null; //���ز���ֵ
}
function UpdateGridData(){
	if ($('#Rowid').val()==""){
		$.messager.alert("����", "��ѡ��һ�У�", 'error') 
            return false;
	}
    if ($('#User').combogrid("getValue")==""){
            $.messager.alert("����", "��Ա����Ϊ�գ�", 'error')
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
                text: '���ڸ�����...'
                });
            },
           	error:function(XMLHttpRequest, textStatus, errorThrown){
                        messageShow("","","",XMLHttpRequest.status);
                        messageShow("","","",XMLHttpRequest.readyState);
                        messageShow("","","",textStatus);
                    },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data==0) {  /// ���ݷ���ֵ�ж��Ƿ�ɹ�
            $('#maintgrouplistdatagrid').datagrid('reload'); 
            $.messager.show({
                title: '��ʾ',
                msg: '���³ɹ�'
            });
            EmptyInput(); 
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
            $.messager.alert("����", "��ѡ��һ�У�", 'error') 
            return false;
    } 
    var rows = $('#maintgrouplistdatagrid').datagrid('getSelections');
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
                title: '��ʾ',
                msg: 'ɾ���ɹ�'
            });
			EmptyInput();  ///  ɾ���������Ӧ���	
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
/// ����:��պ���
function EmptyInput(){
	$('#Rowid').val("");
    $('#User').combogrid('setValue',"");
    $('#userdr').combogrid('setValue',"");
    $('#MaintGroupDR').combogrid('setValue',"");
    $('#ManagerFlag').prop("checked",false);//��
}
});