function initUseContextMonth()
{
	$('#tDHCEQUseContextMonth').datagrid({
		url:'dhceq.jquery.csp',
		queryParams:{
			ClassName:"web.DHCEQUseContext",
			QueryName:"GetUseContext",
			Arg1:GlobalObj.EquipDR,
			Arg2:"0",
			ArgCnt:2
			},
    	border:'true',
		rownumbers: true,  //如果为true，则显示一个行号列。
		singleSelect:true,
		fit:true,
		toolbar:GlobalObj.UseContextMonth_toolbar,
		columns:[[
			{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true},
			{field:'TYear',title:'年度',width:60,align:'center'},
			{field:'TMonth',title:'月份',width:60,align:'center'},
			{field:'TIncome',title:'收入',width:80,align:'center',editor:texteditor},
			{field:'TPersonTime',title:'检查人次',width:80,align:'center',editor:texteditor},
			{field:'TActualWorkLoad',title:'实际工作量',width:80,align:'center',editor:texteditor},
			{field:'TPositiveCases',title:'阳性例数',width:80,align:'center',editor:texteditor},
			{field:'TRunTime',title:'开机时间',width:80,align:'center',editor:texteditor},
			{field:'TFailureTimes',title:'故障次数',width:80,align:'center',editor:texteditor},
			{field:'TMaintTimes',title:'维修次数',width:80,align:'center',editor:texteditor},
			{field:'TPMTimes',title:'保养次数',width:80,align:'center',editor:texteditor},
			{field:'TDetectionTimes',title:'检测次数',width:80,align:'center',editor:texteditor},
			{field:'TWaitingTimes',title:'预约等待时间',width:80,align:'center',editor:texteditor},
			{field:'TAverageWorkHour',title:'平均工作小时/日',width:80,align:'center',editor:texteditor},
			{field:'TActualWorkDays',title:'实际工作天数',width:80,align:'center',editor:texteditor},
			{field:'TFailureDays',title:'故障天数',width:80,align:'center',editor:texteditor},
			{field:'TUseEvaluation',title:'使用评价',width:80,align:'center',editor:texteditor},
		]],
		//onClickRow:function(rowIndex,rowData){OnclickRow();},
		pagination:true,
		loadMsg: '正在加载信息...',
		pageSize:15,
		pageNumber:15,
		pageList:[15,30,45,60,75],
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
		    	if (editFlag!="undefined")
		    	{
	                $('#tDHCEQUseContextMonth').datagrid('endEdit', editFlag);
	                editFlag="undefined"
	            }
	            else
	            {
		            $('#tDHCEQUseContextMonth').datagrid('beginEdit', rowIndex);
		            editFlag =rowIndex;
		        }
	        }

	});
}
function AddUseContextMonthData()
{
	if(editFlag>="0"){
		$('#tDHCEQUseContextMonth').datagrid('endEdit', editFlag);//结束编辑，传入之前编辑的行
	}
	//在指定行添加数据，appendRow是在最后一行添加数据
	$('#tDHCEQUseContextMonth').datagrid('appendRow', 
	{	TRowID: '',
		TYear:'',
		TMonth: '',
		TIncome:'',
		TPersonTime:'',
		TActualWorkLoad:'',
		TPositiveCases:'',
		TRunTime:'',
		TFailureTimes:'',
		TMaintTimes:'',
		TPMTimes:'',
		TDetectionTimes:'',
		TWaitingTimes:'',
		TAverageWorkHour:'',
		TActualWorkDays:'',
		TFailureDays:"",
		TUseEvaluation:""
	});
	editFlag=0;
}
function SaveUseContextMonthData()
{
	if(editFlag>="0"){
		$('#tDHCEQUseContextMonth').datagrid('endEdit', editFlag);
	}
	var rows = $('#tDHCEQUseContextMonth').datagrid('getChanges');
	if(rows.length<=0){
		jQuery.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		var tmp=rows[i].TRowID+"^^"+GlobalObj.EquipDR+"^"+rows[i].TYear+"^"+rows[i].TMonth+"^^^^^^^^^^^^"+rows[i].TUseEvaluation+"^^^"+rows[i].TIncome+"^"+rows[i].TPersonTime+"^"+rows[i].TActualWorkLoad+"^"+rows[i].TPositiveCases+"^"+rows[i].TRunTime+"^"+rows[i].TFailureTimes+"^"+rows[i].TMaintTimes+"^"+rows[i].TPMTimes+"^"+rows[i].TDetectionTimes+"^"+rows[i].TWaitingTimes+"^"+rows[i].TAverageWorkHour+"^"+rows[i].TActualWorkDays+"^"+rows[i].TFailureDays;
		//            1          2           3                4                    5         678910111213141516  17                1819           20                  21                      22                          23                        24                   25                        26                     27                    28                         29                         30                           31                          32                                           
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
			Arg2:0,
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
				$('#tDHCEQUseContextMonth').datagrid('reload');
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
function DeleteUseContextMonthData()
{
	var rows = $('#tDHCEQUseContextMonth').datagrid('getSelections'); //选中要删除的行
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
								$('#tDHCEQUseContextMonth').datagrid('reload');
							}
							else
								$.messager.alert('删除失败！','错误代码:'+data, 'warning');
							}	
						});
				
						}
			});
		//Add by JYP 20160901
		}else{  
			var index = $('#tDHCEQUseContextMonth').datagrid('getRowIndex',rows[0]);
			$('#tDHCEQUseContextMonth').datagrid('deleteRow',index);
        }
        //End by JYP 20160901
	}else{
		 jQuery.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
