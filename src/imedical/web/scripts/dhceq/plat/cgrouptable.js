var str=window.location.search.substr(1);
var list=str.split("&");
var tmp=list[0].split("=");
var tid=tmp[1];

$(document).ready(function () {
$HUI.datagrid('#grouptabledatagrid',{    
    url:$URL, 
    queryParams:{
        ClassName:"web.DHCEQ.Plat.CTGroupCTable",
        QueryName:"CodeTable",
        RowID:tid,
    },
    border:false,  //modify by lmm 2020-04-09
    columns:[[
        {field:'TRow',title:'���',width:50,align:'center'},
        {field:'TRowid',title:'TRowid',width:200,align:'center',hidden:true},   
    	{field:'TCodeTable',title:'����',width:200,align:'center'}, 
        {field:'TPutIn',title:'�ύ',width:50,align:'center',formatter:formatOperation}
    ]],
    singleSelect: true, 
	fitColumns:true,   //add by lmm 2020-06-05 UI
    fit:true,   //add by lmm 2020-06-05 UI
	selectOnCheck: true,
	checkOnSelect: true,
	onLoadSuccess:function(data){                  
       if(data){
            $.each(data.rows, function(index, item){
                if(item.checked){
                   $('#grouptabledatagrid').datagrid('checkRow', index);
               }
 
           });
        }},
    pagination:true,
    pageSize:25,
    pageNumber:1,
    pageList:[25,50,75,100,125] 
	});
	$("#BUpdate").on("click",SavegridData);
});
/// Modfied by CSJ 20181023
/// ����:�޸�SavegridData����
function SavegridData(){      
	var rows = jQuery("#grouptabledatagrid").datagrid('getRows');
	for(var i=0;i<rows.length;i++)
	{
		var TRowid=rows[i].TRowid;
		var TPutIn=rows[i].TPutIn;
		if(TPutIn=="Y") 
		{
			TPutIn="1"
		}else
		{
			TPutIn="2"
		}
		$.ajax({
			url:'dhceq.jquery.method.csp',
			Type:'POST',
			data:{
				ClassName:'web.DHCEQ.Plat.CTGroupCTable',
				MethodName:'SaveData',
				Arg1:tid,
				Arg2:TRowid,
				Arg3:TPutIn,
				ArgCnt:3
			},
			beforeSend:function(){$.messager.progress({text:'���ڸ�����'})},
			success:function(data,response,status)
			{
				$.messager.progress('close');
				data=data.replace(/\ +/g,"")	//ȥ���ո�
				data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
				data=data.split("^");
				if(data<0)
				{
					$.messager.popover({msg:"����ʧ��",type:'error'});	
				}
				else
					$.messager.popover({msg:"���³ɹ�!",type:'success'});
					$('#grouptabledatagrid').datagrid('reload');
			}
		});

	}
}
	
function formatOperation(value,row,index){
	if(value=="Y"){
		return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchange(this,'+index+')" checked="checked" value="" >';
	}
	else{
	return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchange(this,'+index+')" value="N" >';
	}
}
/// Modfied by zc 2015-07-30 ZC0027
/// ����:����checkchange����
function checkchange(TAccessCheckbox,rowIndex)
{
		//var row = $('#menudatagrid').datagrid('getSelected');
		var row = $('#grouptabledatagrid').datagrid('getRows')[rowIndex];
		if (row) {
			if(TAccessCheckbox.checked==true) row.TPutIn="Y"
			else row.TPutIn="N"
    		//var rowIndex = $('#menudatagrid').datagrid('getRowIndex', row);
    		$('#grouptabledatagrid').datagrid('updateRow',{	//�ڱ����ĳ�������а���ͬ�¼�ʱ������Ӧ�������¼�������ִ��updateRow���������±��onclick�¼�ʧЧ
			index:rowIndex,
			row:row})
			$('#grouptabledatagrid').datagrid('selectRow',rowIndex)
			$('#grouptabledatagrid').datagrid('options').onClickRow(rowIndex,row)
		}
}
