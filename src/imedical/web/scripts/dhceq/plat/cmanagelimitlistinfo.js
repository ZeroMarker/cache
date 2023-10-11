/// ����:����checkchange����
function checkchange(TAccessCheckbox,rowIndex)
{
		var row = $('#tDHCEQCManageLimitListInfo').datagrid('getRows')[rowIndex];
		if (row) {
			if(TAccessCheckbox.checked==true) row.opt="Y"
			else row.opt="N"
    		
    		$('#tDHCEQCManageLimitListInfo').datagrid('updateRow',{	//�ڱ����ĳ�������а���ͬ�¼�ʱ������Ӧ�������¼�������ִ��updateRow���������±��onclick�¼�ʧЧ
			index:rowIndex,
			row:row})
			$('#tDHCEQCManageLimitListInfo').datagrid('selectRow',rowIndex)
			$('#tDHCEQCManageLimitListInfo').datagrid('options').onClickRow(rowIndex,row)
		}
}
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
	
);
function initDocument()
{
	initPanel();
}
function initPanel()
{
	initTopPanel();		
}
//��ʼ����ѯͷ���
function initTopPanel()
{
	defindTitleStyle();
	initDHCEQCManageLimitListInfo();			
}
function initDHCEQCManageLimitListInfo(){
	$HUI.datagrid("#tDHCEQCManageLimitListInfo",{   
	    url:$URL,
    	queryParams:{
        	ClassName:"web.DHCEQ.Plat.CTManageLimit",
        	QueryName:"GetManageLimitListinfo",
        	ManageLimitDR:getElementValue("ManageLimitDR"),
        	Type:getElementValue("Type"),
        	Group:getElementValue("Group"),
    	},
        fitColumns:true,   //add by lmm 2020-06-05 UI
    	fit:true,   //add by lmm 2020-06-05 UI
   		border:false,   //modify by lmm 2020-04-09
    	toolbar:[{          
                iconCls: 'icon-save',
                text:'����',          
                handler: function(){
                     SavegridData();
                }     
                 }] ,
    	columns:[[
    		{field:'TRowID',title:'LRowid',width:50,hidden:true},    
        	{field:'TManageLimitDR',title:'managelimitdr',width:150,align:'center',hidden:true},
        	{field:'TTypeDR',title:'TTypeDR',width:150,align:'center',hidden:true}, 
        	{field:'TValueDR',title:'TValueDR',width:150,align:'center',hidden:true},
        	{field:'TValue',title:'����',width:200,align:'center'},
        	{field:'opt',title:'����',width:100,align:'center',formatter: fomartOperation},
    		]],
   
    	pagination:true,
    	pageSize:15,
    	pageNumber:1,
    	pageList:[15,30,45,60,75]
	});
}
/// ����:�޸�fomartOperation����
function fomartOperation(value,row,index)
{
	if(value=="Y")
	{
		return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchange(this,'+index+')" checked="checked" value="" >';
	}
	else
	{
		return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchange(this,'+index+')" value="Y" >';
	}
}

/// ����:�޸�SavegridData����
function SavegridData()
{
	var checkedItems = $('#tDHCEQCManageLimitListInfo').datagrid('getChecked');
	var selectItems = [];
	$.each(checkedItems, function(index, item){
        	selectItems.push(item.TValueDR);
		});
	//modified By QW20210311 BUG:QW0095 ��������1803601 begin
	/*if(selectItems=="")
	{
		$.messager.popover({msg:"δѡ��ѡ��Ŀ��",type:'alert'});
		return false;
	}*/
	//modified By QW20210311 BUG:QW0095 ��������1803601 end
	var str=""
	for(i=0;i<selectItems.length;i++)//��ʼѭ��
	{
		if (str=="")
		{
			str=selectItems[i];//ѭ����ֵ	
		}
		else
		{
			str=str+","+selectItems[i]
		}
	}
	selectItems.splice(0,selectItems.length);
	var data = tkMakeServerCall("web.DHCEQ.Plat.CTManageLimit", "SaveManageLimitListinfo",getElementValue("ManageLimitDR"),getElementValue("Type"),str);
	if (data=="0")
	{
		$.messager.popover({msg:"����ɹ�",type:'success'});
		$('#tDHCEQCManageLimitListInfo').datagrid('reload');
	}
}
$.extend($.fn.datagrid.methods, {

	getChecked: function (jq) {

				var rr = [];

				var rows = jq.datagrid('getRows');

				jq.datagrid('getPanel').find('div.datagrid-cell input:checked').each(function () {

				var index = $(this).parents('tr:first').attr('datagrid-row-index');

				rr.push(rows[index]);

				});

			return rr;

		}

});
