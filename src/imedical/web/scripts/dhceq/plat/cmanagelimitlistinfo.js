/// 描述:新增checkchange方法
function checkchange(TAccessCheckbox,rowIndex)
{
		var row = $('#tDHCEQCManageLimitListInfo').datagrid('getRows')[rowIndex];
		if (row) {
			if(TAccessCheckbox.checked==true) row.opt="Y"
			else row.opt="N"
    		
    		$('#tDHCEQCManageLimitListInfo').datagrid('updateRow',{	//在表格与某个具体列绑定相同事件时，先响应具体列事件，但是执行updateRow方法将导致表格onclick事件失效
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
//初始化查询头面板
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
                text:'保存',          
                handler: function(){
                     SavegridData();
                }     
                 }] ,
    	columns:[[
    		{field:'TRowID',title:'LRowid',width:50,hidden:true},    
        	{field:'TManageLimitDR',title:'managelimitdr',width:150,align:'center',hidden:true},
        	{field:'TTypeDR',title:'TTypeDR',width:150,align:'center',hidden:true}, 
        	{field:'TValueDR',title:'TValueDR',width:150,align:'center',hidden:true},
        	{field:'TValue',title:'内容',width:200,align:'center'},
        	{field:'opt',title:'操作',width:100,align:'center',formatter: fomartOperation},
    		]],
   
    	pagination:true,
    	pageSize:15,
    	pageNumber:1,
    	pageList:[15,30,45,60,75]
	});
}
/// 描述:修改fomartOperation方法
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

/// 描述:修改SavegridData方法
function SavegridData()
{
	var checkedItems = $('#tDHCEQCManageLimitListInfo').datagrid('getChecked');
	var selectItems = [];
	$.each(checkedItems, function(index, item){
        	selectItems.push(item.TValueDR);
		});
	//modified By QW20210311 BUG:QW0095 测试需求1803601 begin
	/*if(selectItems=="")
	{
		$.messager.popover({msg:"未选择勾选项目！",type:'alert'});
		return false;
	}*/
	//modified By QW20210311 BUG:QW0095 测试需求1803601 end
	var str=""
	for(i=0;i<selectItems.length;i++)//开始循环
	{
		if (str=="")
		{
			str=selectItems[i];//循环赋值	
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
		$.messager.popover({msg:"保存成功",type:'success'});
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
