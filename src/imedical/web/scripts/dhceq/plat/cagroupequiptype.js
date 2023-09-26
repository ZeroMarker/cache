/// ..\scripts\dhceq\plat\cagroupequiptype.js
$(document).ready(function () {
	$HUI.datagrid('#agroupequiptypedatagrid',{
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQCGroupAccessoryType",
	        QueryName:"Codetable",
	        RowID:getElementValue("RowID")
	    },
	    border:'true',
	    //height:'100%',
	    toolbar:[{
		    iconCls: 'icon-save',
	        text:'保存',
	        handler: function(){
		        SavegridData();
	        }
        }],
        columns:[[
        	{field:'TROWID',title:'TROWID',width:50,hidden:true},
	        {field:'TCodetable',title:'类组',width:150},
	        {field:'TDefaultFlag',title:'默认',width:100,align:'center',formatter: defaultflagOperation},
	        {field:'TPutIn',title:'访问',width:100,align:'center',formatter: accessflagOperation},
    	]],
	    singleSelect: true,
		selectOnCheck: true,
		checkOnSelect: true,
		onLoadSuccess:function(data){
	       if(data){
	            $.each(data.rows, function(index, item){
	                if(item.checked){
	                   $('#agroupequiptypedatagrid').datagrid('checkRow', index);
	               }
	         });
	    }},
	    pagination:true,
	    pageSize:15,
	    pageNumber:1,
	    pageList:[15,30,45,60,75]
	});
});
/// 描述:默认
function defaultflagOperation(value,row,index)
{
	if(value=="Y"){
		return '<input type="checkbox" name="DataGridCheckbox1" onclick="checkchangedefaultflag(this,'+index+')" checked="checked"  >';
	}
	else{
		return '<input type="checkbox" name="DataGridCheckbox1" onclick="checkchangedefaultflag(this,'+index+')"  >';
	}
}
/// 描述:新增checkchangedefaultflag方法
function checkchangedefaultflag(TAccessCheckbox,rowIndex)
{
	var rows = $('#agroupequiptypedatagrid').datagrid('getRows');
	var row=rows[rowIndex];
	if (row)
	{
		if(TAccessCheckbox.checked==true)
		{
			row.TDefaultFlag="Y";
			for(var i=0;i<rows.length;i++)
			{
				if ((rows[i].TDefaultFlag="Y")&&(i!=rowIndex))
				{
					rows[i].TDefaultFlag="N"
					$('#agroupequiptypedatagrid').datagrid('updateRow',{	//在表格与某个具体列绑定相同事件时，先响应具体列事件，但是执行updateRow方法将导致表格onclick事件失效
					index:i,
					row:rows[i]})
				}
			}
		}
		else row.TDefaultFlag="N"
    	//var rowIndex = $('#menudatagrid').datagrid('getRowIndex', row);
    	$('#agroupequiptypedatagrid').datagrid('updateRow',{	//在表格与某个具体列绑定相同事件时，先响应具体列事件，但是执行updateRow方法将导致表格onclick事件失效
		index:rowIndex,
		row:row})
		$('#agroupequiptypedatagrid').datagrid('selectRow',rowIndex)
		//$('#groupequiptypedatagrid').datagrid('options').onClickRow(rowIndex,row)
	}
}
/// 描述:访问
function accessflagOperation(value,row,index)
{
	if(value=="Y"){
		return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchangeaccessflag(this,'+index+')" checked="checked"  >';
	}
	else{
		return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchangeaccessflag(this,'+index+')" >';
	}
}
/// 描述:新增checkchangeaccessflag方法
function checkchangeaccessflag(TAccessCheckbox,rowIndex)
{
	var row = $('#agroupequiptypedatagrid').datagrid('getRows')[rowIndex];
	if (row)
	{
		if(TAccessCheckbox.checked==true) row.TPutIn="Y"
    	else row.TPutIn="N"
    	$('#agroupequiptypedatagrid').datagrid('updateRow',{	//在表格与某个具体列绑定相同事件时，先响应具体列事件，但是执行updateRow方法将导致表格onclick事件失效
		index:rowIndex,
		row:row})
		$('#agroupequiptypedatagrid').datagrid('selectRow',rowIndex)
		//$('#groupequiptypedatagrid').datagrid('options').onClickRow(rowIndex,row)
	}
}

function SavegridData()
{	   
	var ListData=""            
	var rows = jQuery("#agroupequiptypedatagrid").datagrid('getRows');
	for(var i=0;i<rows.length;i++)
	{
		var isDel="2";
		if (rows[i].TPutIn=="Y") isDel="1";
		$.ajax({
			url:'dhceq.jquery.method.csp',
			Type:'POST',
			data:{
				ClassName:'web.DHCEQCGroupAccessoryType',
				MethodName:'SaveData',
				Arg1:"",
				Arg2:"",
				Arg3:getElementValue("RowID"),
				Arg4:rows[i].TROWID,
				Arg5:isDel,
				Arg6:rows[i].TDefaultFlag,
				ArgCnt:6
			},
			beforeSend:function(){$.messager.progress({text:'正在更新中'})},
			success:function(data,response,status)
			{
				$.messager.progress('close');
				data=data.replace(/\ +/g,"")	//去掉空格
				data=data.replace(/[\r\n]/g,"")	//去掉回车换行
				data=data.split("^");
				if(data<0)
				{
					$.messager.popover({msg:"更新失败",type:'error'});
				}
				else
					$.messager.popover({msg:"更新成功!",type:'success'});
					$('#agroupequiptypedatagrid').datagrid('reload');
			}
		});
	}
}