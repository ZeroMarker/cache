/// Modfied by zc 2015-07-30 ZC0027
/// ����:����checkchange����
function checkchange(TAccessCheckbox,rowIndex)
{
		//var row = $('#menudatagrid').datagrid('getSelected');
		var row = $('#grouproledatagrid').datagrid('getRows')[rowIndex];
		if (row) {
			if(TAccessCheckbox.checked==true) row.opt="Y"
			else row.opt="N"
    		//var rowIndex = $('#menudatagrid').datagrid('getRowIndex', row);
    		$('#grouproledatagrid').datagrid('updateRow',{	//�ڱ����ĳ�������а���ͬ�¼�ʱ������Ӧ�������¼�������ִ��updateRow���������±��onclick�¼�ʧЧ
			index:rowIndex,
			row:row})
			$('#grouproledatagrid').datagrid('selectRow',rowIndex)
			$('#grouproledatagrid').datagrid('options').onClickRow(rowIndex,row)
		}
}
$(document).ready(function () {
   var str=window.location.search.substr(1);
   var list=str.split("&");
   var tmp=list[0].split("=");
   var tid=tmp[1];
   //messageShow("","","",tid);
$('#grouproledatagrid').datagrid({    
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQCGroupRole",
        QueryName:"GetGroupRole",
        Arg1:tid,
        ArgCnt:1
    },
    border:'true',
    toolbar:[{          
                iconCls: 'icon-save',
                text:'����',          
                handler: function(){
                     SavegridData();
                }   
                 }] , 
   
    columns:[[
    	{field:'rowid',title:'rowid',width:50,align:'center',hidden:true}, 
    	{field:'groupdr',title:'groupdr',width:200,align:'center',hidden:true},   
        {field:'roledr',title:'roledr',width:200,align:'center',hidden:true}, 
        {field:'role',title:'��ɫ',width:200,align:'center'},
        {field:'opt',title:'����',width:100,align:'center',formatter: fomartOperation},               
    ]],
    singleSelect: true, 
	selectOnCheck: true,
	checkOnSelect: true,
	onLoadSuccess:function(data){                    
       if(data){
            $.each(data.rows, function(index, item){
                if(item.checked){
                   $('#grouproledatagrid').datagrid('checkRow', index);
               }
 
           });

        }},
    pagination:true,
    pageSize:10,
    pageNumber:1,
    pageList:[10,20,30,40,50] 
});
/// Modfied by zc 2015-07-30 ZC0027
/// ����:�޸�fomartOperation����	
function fomartOperation(value,row,index){
			if(value=="Y"){
			return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchange(this,'+index+')" checked="checked" value="" >';
		}
		else{
		return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchange(this,'+index+')" value="N" >';
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
   var checkedItems = $('#grouproledatagrid').datagrid('getChecked');
   //messageShow("","","",checkedItems.length);
   if (checkedItems.length==0){
           $.messager.alert("����", "������ѡ��ѡ��һ�", 'error')
           return false;
    }
    var names = [];
    $.each(checkedItems, function(index, item){
	        var id=item.roledr; 
	        $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQCGroupRole",
                MethodName:"SaveGroupRole",
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
            messageShow("","","",data);
            if (data >0) {
            $('#grouproledatagrid').datagrid('reload'); 
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
   effectRow["data"]=JSON.stringify($('#grouproledatagrid').datagrid('getRows'))
   //messageShow("","","",effectRow["data"]); 
   eval(" effectRow[\"data\"] = '"+effectRow["data"]+"';");
  $.post("dhceq.jquery.operationtype.csp?&action=updategrouprole", effectRow, function(text, status) {
                            if(status=="success"){
                                $.messager.alert("��ʾ", "����ɹ�");
                                //$('#menudatagrid').datagrid('acceptChanges');
                                $('#grouproledatagrid').datagrid('reload');
                            }
                        }, "text").error(function() { //JSON����������Ҫ����Content-Type���ԣ�
                            $.messager.alert("��ʾ", "�ύ�����ˣ�");
                            $('#grouproledatagrid').datagrid('reload');
                        })      
}
/// Modfied by zc 2015-07-30 ZC0027
/*function DeletegridData(){
	$.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQCGroupRole",
                MethodName:"DeleteGroupRole",
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
            $('#grouproledatagrid').datagrid('reload'); 
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