/// Modfied by zc 2015-07-30 ZC0027
/// 描述:新增checkchange方法
function checkchange(TAccessCheckbox,rowIndex)
{
		//var row = $('#menudatagrid').datagrid('getSelected');
		var row = $('#rolebussdatagrid').datagrid('getRows')[rowIndex];
		if (row) {
			if(TAccessCheckbox.checked==true) row.opt="Y"
			else row.opt="N"
    		//var rowIndex = $('#menudatagrid').datagrid('getRowIndex', row);
    		$('#rolebussdatagrid').datagrid('updateRow',{	//在表格与某个具体列绑定相同事件时，先响应具体列事件，但是执行updateRow方法将导致表格onclick事件失效
			index:rowIndex,
			row:row})
			$('#rolebussdatagrid').datagrid('selectRow',rowIndex)
			$('#rolebussdatagrid').datagrid('options').onClickRow(rowIndex,row)
		}
}
$(document).ready(function () {
	var str=window.location.search.substr(1);
   	var list=str.split("=");
   	var tid=list[1]
   	//messageShow("","","",list[1]);
$('#rolebussdatagrid').datagrid({    
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQCRoleBuss",
        QueryName:"GetRoleBuss",
        Arg1:tid,
        ArgCnt:1
    },
    border:'true',
    singleSelect:true,
    toolbar:[{          
                iconCls: 'icon-save',
                text:'保存',          
                handler: function(){
                     SavegridData();
                }     
                 }] , 
   
    columns:[[
    	{field:'rowid',title:'Rowid',width:50,align:'center',hidden:true},
    	{field:'roledr',title:'roledr',width:200,align:'center',hidden:true},   
    	{field:'role',title:'角色',width:200,align:'center',hidden:true},
    	{field:'busstypedr',title:'busstypedr',width:200,align:'center',hidden:true},    
        {field:'busstype',title:'业务',width:200,align:'center'},
        {field:'modletype',title:'模块',width:200,align:'center'},
        {field:'opt',title:'操作',width:100,align:'center',formatter: fomartOperation},                  
    ]],
    singleSelect: true, 
	selectOnCheck: true,
	checkOnSelect: true,
	onLoadSuccess:function(data){                    
       if(data){
            $.each(data.rows, function(index, item){
                if(item.checked){
                   $('#rolebussdatagrid').datagrid('checkRow', index);
               }
 
           });

        }}, 
    pagination:true,
    pageSize:10,
    pageNumber:1,
    pageList:[10,20,30,40,50]       
});
/// Modfied by zc 2015-07-30 ZC0027
/// 描述:修改fomartOperation方法
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
 	{
	 	return '<input type="checkbox" id="ck" checked="checked">';
	}
	else{
 	return '<input type="checkbox" id="ck">'; }
}*/
/// Modfied by zc 2015-07-30 ZC0027
/// 描述:修改SavegridData方法
function SavegridData(){
	/*DeletegridData();
    var checkedItems = $('#rolebussdatagrid').datagrid('getChecked');
   messageShow("","","",checkedItems.length);
   if (checkedItems.length==0){
           $.messager.alert("错误", "请至少选择选择一项！", 'error')
           return false;
    }
    var names = [];
    $.each(checkedItems, function(index, item){
	        var id=item.busstypedr; 
	        $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQCRoleBuss",
                MethodName:"SaveRoleBuss",
                Arg1:tid,
        		Arg2:id,
                ArgCnt:2
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
            //messageShow("","","",data);
            if (data >0) {
            $('#rolebussdatagrid').datagrid('reload'); 
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
        }); */ 
        var effectRow = new Object();    
   effectRow["data"]=JSON.stringify($('#rolebussdatagrid').datagrid('getRows'))
   //messageShow("","","",effectRow["data"]); 
   eval(" effectRow[\"data\"] = '"+effectRow["data"]+"';");
  $.post("dhceq.jquery.operationtype.csp?&action=updaterolebuss", effectRow, function(text, status) {
                            if(status=="success"){
                                $.messager.alert("提示", "保存成功!");
                                $('#rolebussdatagrid').datagrid('reload');
                            }
                        }, "text").error(function() { //JSON返回类型需要设置Content-Type属性？
                            $.messager.alert("提示", "提交错误了！");
                            $('#rolebussdatagrid').datagrid('reload');
                        })
                           
}
/// Modfied by zc 2015-07-30 ZC0027
/*function DeletegridData(){
	$.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQCRoleBuss",
                MethodName:"DeleteRoleBuss",
                Arg1:tid,
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
            //messageShow("","","",data);
            if (data ==0) {
            $('#rolebussdatagrid').datagrid('reload'); 
            $.messager.show({
                title: '提示',
                msg: '删除成功'
            }); 
            }   
            else {
               $.messager.alert('删除失败！',data, 'warning')
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