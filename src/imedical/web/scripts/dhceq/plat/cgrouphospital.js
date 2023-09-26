/// Modfied by zc 2015-07-30 ZC0027
/// ����:����checkchange����
function checkchange(TAccessCheckbox,rowIndex)
{
		var row = $('#grouphospdatagrid').datagrid('getRows')[rowIndex];
		if (row) {
			if(TAccessCheckbox.checked==true) row.TOpt="Y"
			else row.TOpt="N"
    		$('#grouphospdatagrid').datagrid('updateRow',{	//�ڱ����ĳ�������а���ͬ�¼�ʱ������Ӧ�������¼�������ִ��updateRow���������±��onclick�¼�ʧЧ
			index:rowIndex,
			row:row})
			$('#grouphospdatagrid').datagrid('selectRow',rowIndex)
			$('#grouphospdatagrid').datagrid('options').onClickRow(rowIndex,row)
		}
}
$(document).ready(function () {
   var str=window.location.search.substr(1);
   var list=str.split("&");
   var tmp=list[0].split("=");
   var tid=tmp[1];
$('#grouphospdatagrid').datagrid({    
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQ.Plat.CTGroupHospital",
        QueryName:"GetGroupHospital",
        Arg1:tid,
        ArgCnt:1
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
        {field:'THospitalDR',title:'THospitalDR',width:200,align:'center',hidden:true}, 
        {field:'THospital',title:'Ժ��',width:200,align:'center'},
        {field:'TOpt',title:'����',width:100,align:'center',formatter: fomartOperation},               
    ]],
    singleSelect: true, 
	selectOnCheck: true,
	checkOnSelect: true,
	onLoadSuccess:function(data){                    
       if(data){
            $.each(data.rows, function(index, item){
                if(item.checked){
                   $('#grouphospdatagrid').datagrid('checkRow', index);
               }
 
           });

        }},
    pagination:true,
    pageSize:10,
    pageNumber:1,
    pageList:[10,20,30,40,50] 
});
});
function fomartOperation(value,row,index){
			if(value=="Y"){
			return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchange(this,'+index+')" checked="checked" value="" >';
		}
		else{
		return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchange(this,'+index+')" value="N" >';
		}
}
/// Modfied by CSJ 20181023
/// ����:�޸�SavegridData����
function SavegridData(){           
	var rows = jQuery("#grouphospdatagrid").datagrid('getRows');
	//messageShow("","","",JSON.stringify(rows))
	for(var i=0;i<rows.length;i++)
	{
		var PSTData="";
		PSTData=rows[i].TRowid;
		PSTData=PSTData+"^"+rows[i].TGroupDR;
		PSTData=PSTData+"^"+rows[i].THospitalDR;
		PSTData=PSTData+"^"+rows[i].TOpt;
		$.ajax({
			url:'dhceq.jquery.method.csp',
			Type:'POST',
			data:{
				ClassName:'web.DHCEQ.Plat.CTGroupHospital',
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
					$('#grouphospdatagrid').datagrid('reload');
			}
		});

	}
}
