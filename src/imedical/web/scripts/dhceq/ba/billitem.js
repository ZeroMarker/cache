function initBillItem()
{
	$('#tDHCEQBillItem').datagrid({
	    url:'dhceq.jquery.csp',
	    queryParams:{
			ClassName:"web.DHCEQBillItem",
			QueryName:"GetBillItem",
			Arg1:"2",
			Arg2:GlobalObj.EquipDR,
			ArgCnt:2
	    },
		fit:true,
		border:'true',
		rownumbers: true,  //如果为true，则显示一个行号列。
		singleSelect:true,
		toolbar:[
			{
				iconCls:'icon-add',
				text:'新增',
				handler:function(){AddBillItemData();}
			},'-----------------------------------',
			{
				iconCls:'icon-save',
				text:'保存',
				handler:function(){SaveBillItemData();}
			},'-----------------------------------',
			{
				iconCls:'icon-cut',
				text:'删除',
				handler:function(){DeleteBillItemData();}
			}
		],
		columns:[[
				{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true},
				{field:'TCode',title:'代码',width:100,align:'center',editor:texteditor},
				{field:'TDesc',title:'描述',width:100,align:'center',editor:texteditor},
				{field:'TSourceType',title:'来源类型',width:100,align:'center',hidden:true},
				{field:'TSourceID',title:'来源',width:100,align:'center',hidden:true},
				{field:'TPrice',title:'收费价格',width:100,align:'center',editor:texteditor},
				{field:'TCost',title:'成本',width:100,align:'center',editor:texteditor},
				{field:'TWorkLoadNum',title:'预计工作量',width:100,align:'center',editor:texteditor},
				{field:'TDevelopStatusDR',title:'TDevelopStatusDR',width:100,align:'center',hidden:true,editor:texteditor},
				{field:'TDevelopStatus',title:'新开发功能标记',width:100,align:'center',editor:comboboxeditor},
				{field:'TUsedFlag',title:'使用标记',width:60,align:'center',formatter:function(value,row,index){return checkBox(value,"checkboxChange",this,index)}},
			]],
			pageSize:20,  // 每页显示的记录条数
			pageList:[20],   // 可以设置每页记录条数的列表
	        singleSelect:true,
			loadMsg: '正在加载信息...',
			pagination:true,
		    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
		    	if (editFlag!="undefined")
		    	{
	                $('#tDHCEQBillItem').datagrid('endEdit', editFlag);
	                editFlag="undefined"
	            }
	            else
	            {
		            $('#tDHCEQBillItem').datagrid('beginEdit', rowIndex);
		            editFlag =rowIndex;
		        }
	        }
	});
}
// 保存编辑行
function SaveBillItemData()
{
	if(editFlag>="0"){
		$('#tDHCEQBillItem').datagrid('endEdit', editFlag);
	}
	var rows = $('#tDHCEQBillItem').datagrid('getChanges');
	if(rows.length<=0){
		jQuery.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		var tmp=rows[i].TRowID+"^"+rows[i].TCode+"^"+rows[i].TDesc+"^2^"+GlobalObj.EquipDR+"^"+rows[i].TPrice+"^"+rows[i].TCost+"^"+rows[i].TWorkLoadNum+"^"+rows[i].TDevelopStatusDR+"^"+rows[i].TUsedFlag;
		dataList.push(tmp);
	}
	var CombineData=dataList.join("&");
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQBillItem',
			MethodName:'SaveBillItem',
			Arg1:CombineData,
			ArgCnt:1
		},
		beforeSend:function(){$.messager.progress({text:'正在保存中'})},
		error:function(XMLHttpRequest,textStatus,errorThrown){
			alertShow(XMLHttpRequest.status);
			alertShow(XMLHttpRequest.readyState);
			alertShow(textStatus);
		},
		success:function(data,response,status)
		{
			$.messager.progress('close');
			data=data.replace(/\ +/g,"")	//去掉空格
			data=data.replace(/[\r\n]/g,"")	//去掉回车换行
			var list=data.split("^");
			if(list[0]==0)
			{
				$.messager.show({title: '提示',msg: '保存成功'});
				$('#tDHCEQBillItem').datagrid('reload');
			}
			else
				$.messager.alert('保存失败！','错误代码:'+list[0]+",原因:"+list[1], 'warning');
		}
	});
}
// 插入新行
function AddBillItemData()
{
	var SourceType=$("#SourceType").val();
	var SourceID=$("#SourceID").val();
	if(editFlag>="0"){
		$('#tDHCEQBillItem').datagrid('endEdit', editFlag);//结束编辑，传入之前编辑的行
	}
	//在指定行添加数据，appendRow是在最后一行添加数据
	$('#tDHCEQBillItem').datagrid('appendRow', 
	{
		TRowID: '',
		TCode:'',
		TDesc: '',
		TPrice:'',
		TCost:'',
		TWorkLoadNum:'',
		TDevelopStatusDR:'',
		TDevelopStatus:'',
		TUsedFlag:''
	});
	editFlag=0;
}
//******************************************/
// 删除选中行
// 修改人：JYP
// 修改时间：2016-9-1
// 修改描述：添加了判断，使其可以删除空行
//******************************************/
function DeleteBillItemData()
{
	var rows = $('#tDHCEQBillItem').datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		if(rows[0].TRowID!=""){//Add by JYP 20160901
			jQuery.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
				if (res) {
					$.ajax({
						url:'dhceq.jquery.method.csp',
						Type:'POST',
						data:{
							ClassName:'web.DHCEQBillItem',
							MethodName:'DeleteBillItem',
							Arg1:rows[0].TRowID,
							ArgCnt:1
						},
						beforeSend:function(){$.messager.progress({text:'正在删除中'})},
						error:function(XMLHttpRequest,textStatus,errorThrown){
							alertShow(XMLHttpRequest.status);
							alertShow(XMLHttpRequest.readyState);
							alertShow(textStatus);
						},
						success:function(data,response,status)
						{
							$.messager.progress('close');
							data=data.replace(/\ +/g,"")	//去掉空格
							data=data.replace(/[\r\n]/g,"")	//去掉回车换行
							if(data==0)
							{
								$.messager.show({title: '提示',msg: '删除成功'});
								$('#tDHCEQBillItem').datagrid('reload');
							}
							else
								$.messager.alert('删除失败！','错误代码:'+data, 'warning');
							}	
						});
				
						}
			});
		//Add by JYP 20160901
		}else{  
			var index = $('#tDHCEQBillItem').datagrid('getRowIndex',rows[0]);
			$('#tDHCEQBillItem').datagrid('deleteRow',index);
        }
        //End by JYP 20160901
	}else{
		 jQuery.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
var comboboxeditor={
	type: 'combobox',//设置编辑格式
	options: {
		panelHeight:"auto",  //设置容器高度自动增长
		    	valueField:'id', 
	    	url:null,   
	    	textField:'text',
			data: [{
				id: '0',
				text: '原有功能'
			},{
				id: '1',
				text: '可开发功能'
			},{
				id: '2',
				text: '已开发功能'
			}],
		onSelect:function(option){
			var ed=$('#tDHCEQBillItem').datagrid('getEditor',{index:editFlag,field:'TDevelopStatusDR'});
			jQuery(ed.target).val(option.id);  //设置ID
			var ed=$('#tDHCEQBillItem').datagrid('getEditor',{index:editFlag,field:'TDevelopStatus'});
			jQuery(ed.target).combobox('setValue', option.text);  //设置科室Desc
		}
	}
}
function checkboxChange(TUsedFlag,rowIndex)
{
	var row = $('#tDHCEQBillItem').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
		if (TUsedFlag==key)
			{
				if (((val=="N")||val=="")) row.TUsedFlag="Y"
				else row.TUsedFlag="N"
			}
		})
	}
}
