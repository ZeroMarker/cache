/// Modfied by zc 2015-07-30 ZC0027
/// ����:����checkchange����
function checkchange(TAccessCheckbox,rowIndex)
{
		//var row = $('#menudatagrid').datagrid('getSelected');
		var row = $('#groupmenudatagrid').datagrid('getRows')[rowIndex];
		if (row) {
			if(TAccessCheckbox.checked==true) row.opt="Y"
			else row.opt="N"
    		//var rowIndex = $('#menudatagrid').datagrid('getRowIndex', row);
    		$('#groupmenudatagrid').datagrid('updateRow',{	//�ڱ����ĳ�������а���ͬ�¼�ʱ������Ӧ�������¼�������ִ��updateRow���������±��onclick�¼�ʧЧ
			index:rowIndex,
			row:row})
			$('#groupmenudatagrid').datagrid('selectRow',rowIndex)
			$('#groupmenudatagrid').datagrid('options').onClickRow(rowIndex,row)
		}
}
$(document).ready(function () { 
/*$('#menu').combogrid({ 
	url:'dhceq.jquery.csp',      
	idField:'rowid',
	textField:'name',
	method:"post",
	mode:'remote',
	queryParams:{
		ClassName:"web.DHCEQCSysMenus",
		QueryName:"GetMenu",
		ArgCnt:0
	},
	onChange: function(newValue, oldValue){
		//messageShow("","","",newValue);
		 $('#menu').combogrid("grid").datagrid("reload",{
		ClassName:"web.DHCEQCSysMenus",
		QueryName:"GetMenu",
		Arg1:$('#Rowid').val(),
		Arg2:$('#menu').combogrid('getText'),
		ArgCnt:2
		})
    },	
	columns:[[    
        {field:'rowid',title:'rowid',hidden:true},    
        {field:'name',title:'�˵�'}
        ]]   
    });
    $('#group').validatebox({    
  		width: 160
    }); 
var SelectedRowID = 0;
var preRowID=0;  */  /// Modfied by zc 2015-07-30 ZC0027
 var str=window.location.search.substr(1);
   var list=str.split("&");
   var tmp=list[0].split("=");
   var tid=tmp[1];
   //messageShow("","","",tid);
/// Modfied by zc 2015-07-30 ZC0027   
/*function groupmenudatagrid_OnClickRow()
{
     var selected=$('#groupmenudatagrid').datagrid('getSelected');
     if (selected)
     {       
        var SelectedRowID=selected.rowid;
        if(preRowID!=SelectedRowID)
        {
             $('#Rowid').val(selected.rowid);
             $('#group').val(selected.groupdr);
             $('#menu').combogrid('setValue',selected.menu);
             preRowID=SelectedRowID;
         }
         else
         {
             $('#Rowid').val("");
             //$('#group').combogrid('setValue',"");
             $('#menu').combogrid('setValue',""); 
             SelectedRowID = 0; 
             preRowID=0;
         }
     }
} */   
$('#groupmenudatagrid').datagrid({    
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQCSysGroupMenu",
        QueryName:"GetGroupmenu",
        Arg1:tid,  /// Modfied by zc 2015-07-30 ZC0027
        ArgCnt:1
    },
    border:'true',
    toolbar:[{          
                iconCls: 'icon-save',
                text:'����',          
                handler: function(){
                     SavegridData();}
                } /*,'-',{        
                iconCls: 'icon-cut', 
                text:'ɾ��',      
                 handler: function(){
                     DeleteGridData();
                     }      /// Modfied by zc 2015-07-30 ZC0027
                 },'-',{        
                iconCls: 'icon-search', 
                text:'��ѯ',      
                 handler: function(){
                     findGridData();
                     }        
                 }*/] , 
   
    columns:[[
    	{field:'rowid',title:'rowid',width:50,align:'center',hidden:true},    
        {field:'groupdr',title:'groupdr',width:200,align:'center',hidden:true}, /// Modfied by zc 2015-07-30 ZC0027
        {field:'menudr',title:'menudr',width:200,align:'center',hidden:true}, /// Modfied by zc 2015-07-30 ZC0027
        {field:'menucode',title:'����',width:50,align:'center'},    //Modified by HHM 2016-04-06
        {field:'menu',title:'�˵�',width:200,align:'center'}, 
        {field:'opt',title:'����',width:100,align:'center',formatter: fomartOperation},  /// Modfied by zc 2015-07-30 ZC0027              
    ]],
    singleSelect: true, 
	selectOnCheck: true,
	checkOnSelect: true,
	onLoadSuccess:function(data){                    
       if(data){
            $.each(data.rows, function(index, item){
                if(item.checked){
                   $('#groupmenudatagrid').datagrid('checkRow', index);
               }
 
           });

        }},
    /*onClickRow : function (rowIndex, rowData) {
        groupmenudatagrid_OnClickRow();  /// Modfied by zc 2015-07-30 ZC0027
    },*/  
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75]      
});
/// Modfied by zc 2015-07-30 ZC0027
/// ����:����fomartOperation����
function fomartOperation(value,row,index){
			if(value=="Y"){
			return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchange(this,'+index+')" checked="checked" value="" >';
		}
		else{
		return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchange(this,'+index+')" value="Y" >';
		}
}
/*function fomartOperation(value,row,index)
{
	if(row.rowid!="")
	{ return '<input type="checkbox" id="ck" checked="checked">'; 	}
	else{
 	return '<input type="checkbox" id="ck">'; }
}*/
/// Modfied by zc 2015-07-30 ZC0027
/// ����:�޸�SavegridData����
function SavegridData(){
	/*DeletegridData();
   var checkedItems = $('#groupmenudatagrid').datagrid('getChecked');
   messageShow("","","",checkedItems.length);
   if (checkedItems.length==0){
           $.messager.alert("����", "������ѡ��ѡ��һ�", 'error')
           return false;
    }
    var names = [];
    $.each(checkedItems, function(index, item){
	        var id=item.menudr; 
	        $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQCSysGroupMenu",
                MethodName:"SaveGroupmenu",
                Arg1:tid,
        		Arg2:id,
                ArgCnt:2
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
            $('#groupmenudatagrid').datagrid('reload'); 
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
		
        });*/
        var effectRow = new Object();    
   effectRow["data"]=JSON.stringify($('#groupmenudatagrid').datagrid('getRows'))
   //messageShow("","","",effectRow["data"]); 
   eval(" effectRow[\"data\"] = '"+effectRow["data"]+"';");
  $.post("dhceq.jquery.operationtype.csp?&action=updategroupmenu", effectRow, function(text, status) {
                            if(status=="success"){
                                $.messager.alert("��ʾ", "���³ɹ�!");
                                $('#groupmenudatagrid').datagrid('reload');
                            }
                        }, "text").error(function() { //JSON����������Ҫ����Content-Type���ԣ�
                            $.messager.alert("��ʾ", "�ύ�����ˣ�");
                            $('#groupmenudatagrid').datagrid('reload');
                        })
               
}
/// Modfied by zc 2015-07-30 ZC0027
/*function DeletegridData(){
	$.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQCSysGroupMenu",
                MethodName:"DeleteGroupmenu",
                Arg1:tid,
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
            //messageShow("","","",data);
            if (data ==0) {
            $('#groupmenudatagrid').datagrid('reload'); 
            $.messager.show({
                title: '��ʾ',
                msg: 'ɾ���ɹ�'
            }); 
            }   
            else {
               $.messager.alert('ɾ��ʧ�ܣ�',data, 'warning')
               return;
               }
            }
            })        
}*/
});
/*$.extend($.fn.datagrid.methods, {
   getChecked: function (jq) {
        var rr = [];
       var rows = jq.datagrid('getRows'); 
       jq.datagrid('getPanel').find('div.datagrid-cell input:checked').each(function () {
           var index = $(this).parents('tr:first').attr('datagrid-row-index');
           rr.push(rows[index]);
       });
       return rr;
    }
});*/