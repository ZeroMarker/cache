/// Modfied by zc 2015-07-30 ZC0027
/// ����:����checkchangeaccessflag����
function checkchangeaccessflag(TAccessCheckbox,rowIndex)
{
		//var row = $('#menudatagrid').datagrid('getSelected');
		var row = $('#groupequiptypedatagrid').datagrid('getRows')[rowIndex];
		if (row) {
			//messageShow("","","",row.ck.checked);
			if(TAccessCheckbox.checked==true) row.TAccessFlag="Y"
    		else row.TAccessFlag="N"
    		$('#groupequiptypedatagrid').datagrid('updateRow',{	//�ڱ����ĳ�������а���ͬ�¼�ʱ������Ӧ�������¼�������ִ��updateRow���������±��onclick�¼�ʧЧ
			index:rowIndex,
			row:row})
			$('#groupequiptypedatagrid').datagrid('selectRow',rowIndex)
			//$('#groupequiptypedatagrid').datagrid('options').onClickRow(rowIndex,row)
		}
}
/// Modfied by zc 2015-07-30 ZC0027
/// ����:����checkchangedefaultflag����
function checkchangedefaultflag(TAccessCheckbox,rowIndex)
{
		//var row = $('#menudatagrid').datagrid('getSelected');
		var rows = $('#groupequiptypedatagrid').datagrid('getRows');
		var row=rows[rowIndex];
		if (row) {
			//messageShow("","","",row.ck.checked);
			if(TAccessCheckbox.checked==true) 
			{
				row.TDefaultFlag="Y";
				for(var i=0;i<rows.length;i++) {
					if ((rows[i].TDefaultFlag="Y")&&(i!=rowIndex))
					{
						rows[i].TDefaultFlag="N"
						$('#groupequiptypedatagrid').datagrid('updateRow',{	//�ڱ����ĳ�������а���ͬ�¼�ʱ������Ӧ�������¼�������ִ��updateRow���������±��onclick�¼�ʧЧ
						index:i,
						row:rows[i]})
					}  
				}
			}
			else row.TDefaultFlag="N"
    		//var rowIndex = $('#menudatagrid').datagrid('getRowIndex', row);
    		$('#groupequiptypedatagrid').datagrid('updateRow',{	//�ڱ����ĳ�������а���ͬ�¼�ʱ������Ӧ�������¼�������ִ��updateRow���������±��onclick�¼�ʧЧ
			index:rowIndex,
			row:row})
			$('#groupequiptypedatagrid').datagrid('selectRow',rowIndex)
			//$('#groupequiptypedatagrid').datagrid('options').onClickRow(rowIndex,row)
		}
}
$(document).ready(function () {
   var str=window.location.search.substr(1);
   var list=str.split("&");
   var tmp=list[0].split("=");
   var tid=tmp[1];
   //messageShow("","","",tid);
$HUI.datagrid('#groupequiptypedatagrid',{   
    url:$URL, 
    queryParams:{
        ClassName:"web.DHCEQ.Plat.CTGroupEquipType",
        QueryName:"GetGroupEquipType",
        Group:tid
    },
    border:'true',
    fitColumns:true,   //add by lmm 2020-06-05 UI
    fit:true,   //add by lmm 2020-06-05 UI
    //height:'100%',
    toolbar:[{          
                iconCls: 'icon-save',
                text:'����',          
                handler: function(){
                     SavegridData();
                }     
                 }] , 
   
    columns:[[
    	{field:'TRowid',title:'TRowid',width:50,hidden:true},    
        {field:'TGroupDR',title:'TGroupDR',width:150,align:'center',hidden:true},
        {field:'TEquipTypeDR',title:'TEquipTypeDR',width:150,align:'center',hidden:true}, 
        {field:'TEquipType',title:'����',width:150,align:'center'}, 
        {field:'TDefaultFlag',title:'Ĭ��',width:100,align:'center',formatter: defaultflagOperation},   /// Modfied by zc 2015-07-30 ZC0027   
        {field:'TAccessFlag',title:'����',width:100,align:'center',formatter: accessflagOperation},    /// Modfied by zc 2015-07-30 ZC0027             
    ]],
    singleSelect: true,
	selectOnCheck: true,
	checkOnSelect: true,
	onLoadSuccess:function(data){                    
       if(data){
            $.each(data.rows, function(index, item){
                if(item.checked){
                   $('#groupequiptypedatagrid').datagrid('checkRow', index);
               }
 
           });

        }},
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75]    
});
});
function editrow(target){
			$('#groupequiptypedatagrid').datagrid('beginEdit', getRowIndex(target));
		}
/// Modfied by zc 2015-07-30 ZC0027
/// ����:�޸�defaultflagOperation����		
function defaultflagOperation(value,row,index){
			if(value=="Y"){
			return '<input type="checkbox" name="DataGridCheckbox1" onclick="checkchangedefaultflag(this,'+index+')" checked="checked"  >';
		}
		else{
		return '<input type="checkbox" name="DataGridCheckbox1" onclick="checkchangedefaultflag(this,'+index+')"  >';
		}

}
/// Modfied by zc 2015-07-30 ZC0027
/// ����:�޸�accessflagOperation����	
function accessflagOperation(value,row,index)
{
	if(value=="Y"){
			return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchangeaccessflag(this,'+index+')" checked="checked"  >';
		}
		else{
		return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchangeaccessflag(this,'+index+')" >';
	}
}
/// Modfied by CSJ 20181023
/// ����:�޸�SavegridData����
function SavegridData(){	   
	var ListData=""            
	var rows = jQuery("#groupequiptypedatagrid").datagrid('getRows');
	//messageShow("","","",JSON.stringify(rows))
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		//rowid_"^"_groupdr_"^"_equiptypedr_"^"_defaultflag_"^"_accessflag
		var PTData="";
		PTData=rows[i].TRowid;
		PTData=PTData+"^"+rows[i].TGroupDR;
		PTData=PTData+"^"+rows[i].TEquipTypeDR;
		PTData=PTData+"^"+rows[i].TDefaultFlag;
		PTData=PTData+"^"+rows[i].TAccessFlag;
		$.ajax({
			url:'dhceq.jquery.method.csp',
			Type:'POST',
			data:{
				ClassName:'web.DHCEQ.Plat.CTGroupEquipType',
				MethodName:'SaveGroupEquipType',
				Arg1:PTData,
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
					$('#groupequiptypedatagrid').datagrid('reload');
			}
		});

	}
}