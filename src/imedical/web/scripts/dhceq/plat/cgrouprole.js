/// Modfied by zc 2015-07-30 ZC0027
/// ����:����checkchange����
function checkchange(TAccessCheckbox,rowIndex)
{
		//var row = $('#menudatagrid').datagrid('getSelected');
		var row = $('#grouproledatagrid').datagrid('getRows')[rowIndex];
		if (row) {
			if(TAccessCheckbox.checked==true) row.TOpt="Y"
			else row.TOpt="N"
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
$HUI.datagrid('#grouproledatagrid',{    
    url:$URL, 
    queryParams:{
        ClassName:"web.DHCEQ.Plat.CTGroupRole",
        QueryName:"GetGroupRole",
        Group:tid,
    },
    border:'true',
    fitColumns:true,   //add by lmm 2020-06-05 UI
    fit:true,   //add by lmm 2020-06-05 UI
    toolbar:[{          
                iconCls: 'icon-save',
                text:'����',          
                handler: function(){
                     SavegridData();
                }   
                 }] , 
   
    columns:[[
    	{field:'TRowid',title:'TRowid',width:50,align:'center',hidden:true}, 
    	{field:'TGroupDR',title:'TGroupDR',width:200,align:'center',hidden:true},   
        {field:'TRoleDR',title:'TRoleDR',width:200,align:'center',hidden:true}, 
        {field:'TRole',title:'��ɫ',width:200,align:'center'},
        {field:'TOpt',title:'����',width:100,align:'center',formatter: formartOperation},               
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

});
/// Modfied by zc 2015-07-30 ZC0027
/// ����:�޸�fomartOperation����	
function formartOperation(value,row,index){
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
/// Modfied by CSJ 20181023
/// ����:�޸�SavegridData����
function SavegridData(){           
	var rows = jQuery("#grouproledatagrid").datagrid('getRows');
	//messageShow("","","",JSON.stringify(rows))
	for(var i=0;i<rows.length;i++)
	{
		//..s PSTData=rowid_"^"_groupdr_"^"_roledr_"^"_opt
	   // ..s result= ##Class(web.DHCEQCGroupRole).SaveData(PSTData)
		var PSTData="";
		PSTData=rows[i].TRowid;
		PSTData=PSTData+"^"+rows[i].TGroupDR;
		PSTData=PSTData+"^"+rows[i].TRoleDR;
		PSTData=PSTData+"^"+rows[i].TOpt;
		$.ajax({
			url:'dhceq.jquery.method.csp',
			Type:'POST',
			data:{
				ClassName:'web.DHCEQ.Plat.CTGroupRole',
				MethodName:'SaveData',
				Arg1:PSTData,
				ArgCnt:1
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
					$('#grouproledatagrid').datagrid('reload');
			}
		});

	}
}

