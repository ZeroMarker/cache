/// Modfied by zc 2015-07-30 ZC0027
/// ����:����checkchangeeditflag����
function checkchangeeditflag(TEditCheckbox,rowIndex)
{
		var rows = $('#DHCEQCNoticeCat').datagrid('getRows');
		var row=rows[rowIndex];
		if (row) {
			if(TEditCheckbox.checked==true) 
			{
				row.TEditFlag="Y";
			}
			else 
			{
				row.TEditFlag="N";
			}
    		$('#DHCEQCNoticeCat').datagrid('updateRow',{	//�ڱ����ĳ�������а���ͬ�¼�ʱ������Ӧ�������¼�������ִ��updateRow���������±��onclick�¼�ʧЧ
			index:rowIndex,
			row:row})
			$('#DHCEQCNoticeCat').datagrid('selectRow',rowIndex)
		}
}
$(document).ready(function () {
	$HUI.datagrid('#DHCEQCNoticeCat',{   
    url:$URL, 
    queryParams:{
        ClassName:"web.DHCEQ.Plat.CTGroupNoticeCat",
        QueryName:"GetGroupNoticeCat",
        Group:getElementValue("GroupDR")
    },
    fitColumns:true,   //add by lmm 2020-06-05 UI
    fit:true,   //add by lmm 2020-06-05 UI
    border:'true',
    toolbar:[{          
                iconCls: 'icon-save',
                text:'����',          
                handler: function(){
                     SavegridData();
                }     
                 }] , 
    columns:[[
    	{field:'TRowID',title:'TRowID',width:50,hidden:true},    
        {field:'TGroupDR',title:'TGroupDR',width:150,align:'center',hidden:true},
        {field:'TNoticeCatDR',title:'TPicTypeDR',width:150,align:'center',hidden:true}, 
        {field:'TNoticeCat',title:'�������',width:150,align:'center'}, 
        {field:'TEditFlag',title:'������ʶ',width:100,align:'center',formatter: editflagOperation},
    ]],
    singleSelect: true,
	selectOnCheck: true,
	checkOnSelect: true,
	onLoadSuccess:function(data){                    
       if(data){
            $.each(data.rows, function(index, item){
                if(item.checked){
                   $('#DHCEQCNoticeCat').datagrid('checkRow', index);
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
			$('#DHCEQCNoticeCat').datagrid('beginEdit', getRowIndex(target));
		}
/// Modfied by zc 2015-07-30 ZC0027
/// ����:�޸�defaultflagOperation����		
function editflagOperation(value,row,index){
			if(value=="Y"){
			return '<input type="checkbox" name="DataGridCheckbox1" onclick="checkchangeeditflag(this,'+index+')" checked="checked"  >';
		}
		else{
		return '<input type="checkbox" name="DataGridCheckbox1" onclick="checkchangeeditflag(this,'+index+')"  >';
		}

}

/// Modfied by CSJ 20181023
/// ����:�޸�SavegridData����
function SavegridData()
{	   
	var str=ListData()
	var data = tkMakeServerCall("web.DHCEQ.Plat.CTGroupNoticeCat", "SaveData",getElementValue("GroupDR"),str);
	if (data=="0")
	{
		$.messager.popover({msg:"����ɹ�",type:'success'});
		$('#DHCEQCGroupPicType').datagrid('reload');
	}
	else
	{
		$.messager.popover({msg:"����ʧ��",type:'info'});
	}
}
function ListData()
{
	var ListData=""
	var rows = jQuery("#DHCEQCNoticeCat").datagrid('getRows');    //modify by lmm 2018-11-14
	if(rows.length<=0) return ListData;
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if(rows[i].TNoticeCatDR=="") return -1;
		
		var tmp="";
		tmp=rows[i].TRowID;
		tmp=tmp+"^"+rows[i].TGroupDR;
		tmp=tmp+"^"+rows[i].TNoticeCatDR;
		tmp=tmp+"^"+rows[i].TEditFlag;
		dataList.push(tmp);
	}
	var ListData=dataList.join("#");
	return ListData
}