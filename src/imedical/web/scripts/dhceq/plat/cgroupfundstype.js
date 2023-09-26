/// Mozy0231	��ȫ������ʽ���Դ����
// var url='dhceq.plat.cgroupfundstype.csp?id='+row.TRowid
var str=window.location.search.substr(1);
var list=str.split("&");
var tmp=list[0].split("=");
var GroupID=tmp[1];		// ��ȫ��ID
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
	        text:'����',
	        handler: function(){
		        SavegridData();
	        }
	    }],
	    columns:[[
	    	{field:'GFTid',title:'GFTid',width:50,align:'center',hidden:true},
	        {field:'TRowID',title:'FTRowID',width:200,align:'center',hidden:true},
	        {field:'TCode',title:'����',width:100,align:'center'},
	        {field:'TName',title:'����',width:200},
	        {field:'TRemark',title:'��ע',width:200},
	        {field:'TOpt',title:'����',width:100,align:'center',formatter: fomartOperation},
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

/// ����:SavegridData����
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
		//�ڱ����ĳ�������а���ͬ�¼�ʱ������Ӧ�������¼�������ִ��updateRow���������±��onclick�¼�ʧЧ
    	$('#groupfundstypedatagrid').datagrid('updateRow',{
			index:rowIndex,
			row:row}
			)
		$('#groupfundstypedatagrid').datagrid('selectRow',rowIndex)
		$('#groupfundstypedatagrid').datagrid('options').onClickRow(rowIndex,row)
	}
}