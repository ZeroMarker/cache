/// Mozy0231	安全组访问资金来源类型
// var url='dhceq.plat.cgroupfundstype.csp?id='+row.TRowid
var str=window.location.search.substr(1);
var list=str.split("&");
var tmp=list[0].split("=");
var GroupID=tmp[1];		// 安全组ID
$(document).ready(function () {
	$('#groupfundstypedatagrid').datagrid({
		url:'dhceq.jquery.csp',
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.CTFundsType",
	        QueryName:"FundsType",
	        Arg1:"",
	        Arg2:"",
	        Arg3:GroupID,
	        ArgCnt:3
	    },
	    border:'true',
	    fitColumns:true,   //add by lmm 2020-06-05 UI
    	fit:true,   //add by lmm 2020-06-05 UI
	    toolbar:[{
		    iconCls: 'icon-save',
	        text:'保存',
	        handler: function(){
		        SavegridData();
	        }
	    }],
	    columns:[[
	    	{field:'GFTid',title:'GFTid',width:50,align:'center',hidden:true},
	        {field:'TRowID',title:'FTRowID',width:200,align:'center',hidden:true},
	        {field:'TCode',title:'编码',width:100,align:'center'},
	        {field:'TName',title:'类型',width:200},
	        {field:'TRemark',title:'备注',width:200},
	        {field:'TOpt',title:'操作',width:100,align:'center',formatter: fomartOperation},
	    ]],
	    singleSelect: true,
		selectOnCheck: true,
		checkOnSelect: true,
		onLoadSuccess:function(data){
			if(data){
				$.each(data.rows, function(index, item){
					if(item.checked) $('#groupfundstypedatagrid').datagrid('checkRow', index);
				});
			}
		},
	    pagination:true,
	    pageSize:10,
	    pageNumber:1,
	    pageList:[10,20,30,40,50] 
	});
});
function fomartOperation(value,row,index)
{
	if(value=="Y")
	{
		return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchange(this,'+index+')" checked="checked" value="" >';
	}
	else
	{
		return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchange(this,'+index+')" value="N" >';
	}
}

/// 描述:SavegridData方法
function SavegridData()
{
	var rows = jQuery("#groupfundstypedatagrid").datagrid('getRows');
	//messageShow("","","",JSON.stringify(rows))
	for(var i=0;i<rows.length;i++)
	{
		var Data=rows[i].GFTid+"^"+GroupID+"^"+rows[i].TRowID+"^"+rows[i].TOpt;
		$.ajax({
			url:'dhceq.jquery.method.csp',
			Type:'POST',
			data:{
				ClassName:'web.DHCEQ.Plat.CTFundsType',
				MethodName:'SaveData',
				Arg1:Data,
				ArgCnt:1
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
					$('#groupfundstypedatagrid').datagrid('reload');
			}
		});
	}
}
function checkchange(TAccessCheckbox,rowIndex)
{
	var row = $('#groupfundstypedatagrid').datagrid('getRows')[rowIndex];
	if (row)
	{
		if(TAccessCheckbox.checked==true)
			row.TOpt="Y"
		else
			row.TOpt="N"
		//在表格与某个具体列绑定相同事件时，先响应具体列事件，但是执行updateRow方法将导致表格onclick事件失效
    	$('#groupfundstypedatagrid').datagrid('updateRow',{
			index:rowIndex,
			row:row}
			)
		$('#groupfundstypedatagrid').datagrid('selectRow',rowIndex)
		$('#groupfundstypedatagrid').datagrid('options').onClickRow(rowIndex,row)
	}
}