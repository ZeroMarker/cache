function initUseContextYear()
{
	$('#tDHCEQUseContextYear').datagrid({
		url:'dhceq.jquery.csp',
		queryParams:{
			ClassName:"web.DHCEQUseContext",
			QueryName:"GetUseContext",
			Arg1:GlobalObj.EquipDR,
			Arg2:"1",
			ArgCnt:2
			},
    	border:'true',
		//rownumbers: true,  //如果为true，则显示一个行号列。
		singleSelect:true,
		fit:true,
		toolbar:[
			{
				iconCls:'icon-add',
				text:'新增',
				handler:function(){AddUseContextYearData();}
			},'-----------------------------------',
			{
				iconCls:'icon-save',
				text:'保存',
				handler:function(){SaveUseContextYearData();}
			},'-----------------------------------',
			{
				iconCls:'icon-cut',
				text:'删除',
				handler:function(){DeleteUseContextYearData();}
			}
		],
		columns:[[
			{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true},
			{field:'TYear',title:'年度',width:100,align:'center',editor:texteditor},
			{field:'TExpectedSatis',title:'预期满意度',width:100,align:'center',editor:texteditor},
			{field:'TActualSatis',title:'实际满意度',width:100,align:'center',editor:texteditor},
			{field:'TPatientSatis',title:'患者满意度',width:100,align:'center',editor:texteditor},
			{field:'TBenefitAnalysis',title:'经济效益分析',width:200,align:'center',editor:texteditor},
		]],
		//onClickRow:function(rowIndex,rowData){OnclickRow();},
		pagination:true,
		pageSize:15,
		pageNumber:15,
		pageList:[15,30,45,60,75],
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
		    	if (editFlag!="undefined")
		    	{
	                $('#tDHCEQUseContextYear').datagrid('endEdit', editFlag);
	                editFlag="undefined"
	            }
	            else
	            {
		            $('#tDHCEQUseContextYear').datagrid('beginEdit', rowIndex);
		            editFlag =rowIndex;
		        }
	        }

	});
}

function AddUseContextYearData()
{
	if(editFlag>="0"){
		$('#tDHCEQUseContextYear').datagrid('endEdit', editFlag);//结束编辑，传入之前编辑的行
	}
	//在指定行添加数据，appendRow是在最后一行添加数据
	$('#tDHCEQUseContextYear').datagrid('appendRow', 
	{
		TRowID: '',
		TYear:'',
		TExpectedSatis: '',
		TActualSatis:'',
		TPatientSatis:'',
		TBenefitAnalysis:''
	});
	editFlag=0;
}
function SaveUseContextYearData()
{
	if(editFlag>="0"){
		$('#tDHCEQUseContextYear').datagrid('endEdit', editFlag);
	}
	var rows = $('#tDHCEQUseContextYear').datagrid('getChanges');
	if(rows.length<=0){
		jQuery.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		var tmp=rows[i].TRowID+"^^"+GlobalObj.EquipDR+"^"+rows[i].TYear+"^^"+rows[i].TExpectedSatis+"^"+rows[i].TActualSatis+"^"+rows[i].TPatientSatis+"^^^^^^^^"+rows[i].TBenefitAnalysis+"^^^^^^^^^^^^^^^^";
		//            1          2           3                4           5               6                    7                            8            9101112131415         16          17181920212223242526272829303132                                           
		dataList.push(tmp);
	}
	var CombineData=dataList.join("&");
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQUseContext',
			MethodName:'SaveUseContext',
			Arg1:CombineData,
			Arg2:1,
			ArgCnt:2
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
				$('#tDHCEQUseContextYear').datagrid('reload');
			}
			else if(data=="-1000")
			{
				$.messager.alert('保存失败！','错误代码:'+data+',已有当期数据', 'warning');
				}
			else
				$.messager.alert('保存失败！','错误代码:'+data, 'warning');
		}
	});
}

//******************************************/
// 删除选中行
// 修改人：JYP
// 修改时间：2016-9-1
// 修改描述：添加了判断，使其可以删除空行
//******************************************/
function DeleteUseContextYearData()
{
	var rows = $('#tDHCEQUseContextYear').datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		if(rows[0].TRowID!=""){//Add by JYP 20160901
			jQuery.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
				if (res) {
					$.ajax({
						url:'dhceq.jquery.method.csp',
						Type:'POST',
						data:{
							ClassName:'web.DHCEQUseContext',
							MethodName:'DeleteUseContextMonth',
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
								$('#tDHCEQUseContextYear').datagrid('reload');
							}
							else
								$.messager.alert('删除失败！','错误代码:'+data, 'warning');
							}	
						});
				
						}
			});
		//Add by JYP 20160901
		}else{  
			var index = $('#tDHCEQUseContextYear').datagrid('getRowIndex',rows[0]);
			$('#tDHCEQUseContextYear').datagrid('deleteRow',index);
        }
        //End by JYP 20160901
	}else{
		 jQuery.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

/*
function DeleteUseContextYearData()
{
	if(getJQValue($("#RowID"))==""){$.messager.alert('提示','请选择一条数据！','warning');return;}
	var RowID=getJQValue($("#RowID"))
	$.messager.confirm('确认', '您确定要删除所选的行吗？', function(b)
	{
		if (b==false){return;}
        else
        {
		$.ajax({
			url:'dhceq.jquery.method.csp',
			type:'POST',
			data:{
					ClassName:'web.DHCEQUseContext',
					MethodName:'DeleteUseContextMonth',
					Arg1:rows[0].TRowID,
					ArgCnt:1
			},
			beforeSend:function(){$.messager.progress({text:'正在删除中'})},
			success:function(data,response,status)
			{
				$.messager.progress('close');
				if(data==0)
				{
					$.messager.show({title: '提示',msg: '删除成功'});
					$('#tDHCEQUseContextYear').datagrid('reload');
				}
				else
					$.messager.alert('删除失败！','错误代码:'+data, 'warning');
			}
		});
        }
	});
}
*/