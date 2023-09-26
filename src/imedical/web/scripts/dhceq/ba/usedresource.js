var columns=new Array();
function initUsedResource()
{
	initUsedResourceDataGrid();
	$('#tDHCEQUsedResource').datagrid({
	    url:'dhceq.jquery.csp',
	    queryParams:{
			ClassName:"web.DHCEQUsedResource",
			QueryName:"GetUsedResourceFee",
			Arg1:"1",
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
				handler:function(){AddUsedResourceData();}
			}/*
			,'-----------------------------------',
			{
				iconCls:'icon-cut',
				text:'删除',
				handler:function(){DeleteUsedResourceData();}
			}*/
		],
		columns:[
				columns
			],
			pageSize:20,  // 每页显示的记录条数
			pageList:[20],   // 可以设置每页记录条数的列表
	        singleSelect:true,
			loadMsg: '正在加载信息...',
			pagination:true,
		    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	        	var url='dhceq.process.usedresourcedetail.csp?Year='+rowData.TYear+'&Month='+rowData.TMonth+'&EquipDR='+GlobalObj.EquipDR;
				OpenNewWindow(url);
	        },
	         onLoadSuccess: function (data) {//双击选择行编辑
	         for(i=0;i<data.total;i++)
	         {
		     $('#tDHCEQUsedResource').datagrid('beginEdit',i);
	         listinfo=data.rows[i].TTypeFee.split('&');
	         for(j=0;j<listinfo.length;j++)
	         {
		         list=listinfo[j].split('^');
		     	 var ed=$('#tDHCEQUsedResource').datagrid('getEditor',{index:i,field:'Type'+list[0]});
			 	 jQuery(ed.target).val(list[1]);  //设置ID
	         }
			 $('#tDHCEQUsedResource').datagrid('endEdit', i);
	         }
	        }
	});
}
function initUsedResourceDataGrid()
{
	var column={};
	column["title"]='年份';
    column["field"]='TYear';
    column["align"]='center';
    column["width"]=50;	
    columns.push(column);
    var column={};
    column["title"]='月份';
    column["field"]='TMonth';
    column["align"]='center';
    column["width"]=50;	
    columns.push(column);
    $.ajax({
	    async: false,
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQCResourceType',
			MethodName:'GetAllResourceType',
			ArgCnt:0
		},
		error:function(XMLHttpRequest,textStatus,errorThrown){
			alertShow(XMLHttpRequest.status);
			alertShow(XMLHttpRequest.readyState);
			alertShow(textStatus);
		},
		success:function(data,response,status)
		{
			data=data.replace(/\ +/g,"")	//去掉空格
			data=data.replace(/[\r\n]/g,"")	//去掉回车换行
			var listInfo=data.split('&')
			for(i=0;i<listInfo.length;i++)
			{
				var column={};
				list=listInfo[i].split('^')
				column["title"]=list[2];
                column["field"]='Type'+list[0];
                column["align"]='center';
                column["width"]=80;	
                column["editor"]=texteditor;
                columns.push(column);
			}
		}
	});
	 var column={};
    column["title"]='TTypeFee';
    column["field"]='TTypeFee';
    column["align"]='center';
    column["width"]=50;	
    //column["formatter"]=SetTTypeFee;	
    column["hidden"]='ture';
    columns.push(column);
}
// 保存编辑行
function SaveUsedResourceData()
{
	if(editFlag>="0"){
		$('#tDHCEQUsedResource').datagrid('endEdit', editFlag);
	}
	var rows = $('#tDHCEQUsedResource').datagrid('getChanges');
	if(rows.length<=0){
		jQuery.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		var tmp=rows[i].TRowID+"^"+rows[i].Year+"^"+rows[i].Month+"^2^"+GlobalObj.EquipDR+"^"+rows[i].TTypeRowID+"^"+rows[i].TAmount;
		dataList.push(tmp);
	}
	var CombineData=dataList.join("&");
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQUsedResource',
			MethodName:'SaveAllUsedResource',
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
			if(data==0)
			{
				$.messager.show({title: '提示',msg: '保存成功'});
				$('#tDHCEQUsedResource').datagrid('reload');
			}
			else
				$.messager.alert('保存失败！','错误代码:'+data, 'warning');
		}
	});
}
// 插入新行
function AddUsedResourceData()
{
	var url='dhceq.process.usedresourcedetail.csp?Year=&Month=&EquipDR='+GlobalObj.EquipDR;
	OpenNewWindow(url);
}
function SetTTypeFee(value,row,index)
{
	list=value.split('&')
	 $('#tDHCEQUsedResource').datagrid('beginEdit', index);
	for(i=0;i<list.length;i++)
	{
		listinfo=list[i].split('^');
		var ed=$('#tDHCEQUsedResource').datagrid('getEditor',{index:row,field:'Type'+listinfo[0]});
		jQuery(ed.target).val(listinfo[1]);  //设置ID
	}
	$('#tDHCEQUsedResource').datagrid('endEdit', editFlag);
	var ed=$('#tDHCEQUsedResource').datagrid('getEditor',{index:editFlag,field:'TDevelopStatus'});
	return value;
}
//******************************************/
// 删除选中行
// 修改人：JYP
// 修改时间：2016-9-1
// 修改描述：添加了判断，使其可以删除空行
//******************************************/
function DeleteUsedResourceData()
{
	var rows = $('#tDHCEQUsedResource').datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		if(rows[0].TRowID!=""){//Add by JYP 20160901
			jQuery.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
				if (res) {
					$.ajax({
						url:'dhceq.jquery.method.csp',
						Type:'POST',
						data:{
							ClassName:'web.DHCEQPC.DHCEQPCCCertInfo',
							MethodName:'DelCertInfo',
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
								$('#tDHCEQUsedResource').datagrid('reload');
							}
							else
								$.messager.alert('删除失败！','错误代码:'+data, 'warning');
							}	
						});
				
						}
			});
		//Add by JYP 20160901
		}else{  
			var index = $('#tDHCEQUsedResource').datagrid('getRowIndex',rows[0]);
			$('#tDHCEQUsedResource').datagrid('deleteRow',index);
        }
        //End by JYP 20160901
	}else{
		 jQuery.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
