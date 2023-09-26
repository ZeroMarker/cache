/// Modfied by zc 2015-07-30 ZC0027
/// ����:����checkchangeaccessflag����
function checkchangeaccessflag(TAccessCheckbox,rowIndex)
{
		var row = $('#DHCEQCGroupPicType').datagrid('getRows')[rowIndex];
		if (row) {
			if(TAccessCheckbox.checked==true) row.TAccessFlag="Y"
    		else 
    		{	
    			row.TEditFlag="N";
    			row.TAccessFlag="N";
    		}
    		$('#DHCEQCGroupPicType').datagrid('updateRow',{	//�ڱ����ĳ�������а���ͬ�¼�ʱ������Ӧ�������¼�������ִ��updateRow���������±��onclick�¼�ʧЧ
			index:rowIndex,
			row:row})
			$('#DHCEQCGroupPicType').datagrid('selectRow',rowIndex)
		}
}
/// Modfied by zc 2015-07-30 ZC0027
/// ����:����checkchangeeditflag����
function checkchangeeditflag(TEditCheckbox,rowIndex)
{
		var rows = $('#DHCEQCGroupPicType').datagrid('getRows');
		var row=rows[rowIndex];
		if (row) {
			if(TEditCheckbox.checked==true) 
			{
				row.TEditFlag="Y";
				row.TAccessFlag="Y";
			}
			else 
			{
				row.TEditFlag="N";
				row.TAccessFlag="N";
			}
    		$('#DHCEQCGroupPicType').datagrid('updateRow',{	//�ڱ����ĳ�������а���ͬ�¼�ʱ������Ӧ�������¼�������ִ��updateRow���������±��onclick�¼�ʧЧ
			index:rowIndex,
			row:row})
			$('#DHCEQCGroupPicType').datagrid('selectRow',rowIndex)
		}
}
$(document).ready(function () {
	$HUI.datagrid('#DHCEQCGroupPicType',{   
    url:$URL, 
    queryParams:{
        ClassName:"web.DHCEQ.Plat.CTGroupPicType",
        QueryName:"GetGroupPicType",
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
        {field:'TPicTypeDR',title:'TPicTypeDR',width:150,align:'center',hidden:true}, 
        {field:'TPicType',title:'ͼƬ�ļ�����',width:150,align:'center'}, 
        {field:'TEditFlag',title:'�ɱ༭��ʶ',width:100,align:'center',formatter: editflagOperation},   /// Modfied by zc 2015-07-30 ZC0027   
        {field:'TAccessFlag',title:'����',width:100,align:'center',formatter: accessflagOperation},    /// Modfied by zc 2015-07-30 ZC0027             
    ]],
    singleSelect: true,
	selectOnCheck: true,
	checkOnSelect: true,
	onLoadSuccess:function(data){                    
       if(data){
            $.each(data.rows, function(index, item){
                if(item.checked){
                   $('#DHCEQCGroupPicType').datagrid('checkRow', index);
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
			$('#DHCEQCGroupPicType').datagrid('beginEdit', getRowIndex(target));
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
function SavegridData()
{	   
	var str=ListData()
	//Modefined by zc0060 20200327  �������,��ʾ����
	//alertShow(str)
	var data = tkMakeServerCall("web.DHCEQ.Plat.CTGroupPicType", "SaveData",getElementValue("GroupDR"),str);
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
	var rows = jQuery("#DHCEQCGroupPicType").datagrid('getRows');    //modify by lmm 2018-11-14
	if(rows.length<=0) return ListData;
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if(rows[i].TPicTypeDR=="") return -1;
		var tmp=""
		tmp=rows[i].TRowID
		tmp=tmp+"^"
		tmp=tmp+"^"+rows[i].TPicTypeDR
		tmp=tmp+"^"+rows[i].TEditFlag
		tmp=tmp+"^"+rows[i].TAccessFlag  
		dataList.push(tmp);
	}
	var ListData=dataList.join("#");
	return ListData
}