var url="dhceq.jquery.operationtype.csp";
function initResearch()
{
	$('#tDHCEQResearch').datagrid({
		url:'dhceq.jquery.csp',
		queryParams:{
			ClassName:"web.DHCEQResearch",
			QueryName:"GetResearch",
			Arg1:GlobalObj.EquipDR,
			ArgCnt:1
			},
    	border:'true',
		rownumbers: true,  //如果为true，则显示一个行号列。
		singleSelect:true,
		fit:true,
		toolbar:[
			{
				iconCls:'icon-add',
				text:'新增',
				handler:function(){AddResearchGridData();}
			},'-----------------------------------',
			{
				iconCls:'icon-save',
				text:'保存',
				handler:function(){SaveResearchGridData();}
			},'-----------------------------------',
			{
				iconCls:'icon-cut',
				text:'删除',
				handler:function(){DeleteResearchGridData();}
			}
		],
		columns:[[
			{field:'TRowID',title:'TRowID',width:0,align:'center',hidden:true},
			{field:'TName',title:'名字',width:60,align:'center',editor:texteditor},
			{field:'TType',title:'类型',width:80,align:'center',editor:typecomboboxeditor},
			{field:'TTypeDR',title:'TTypeDR',width:'80',align:'center',hidden:true,editor:texteditor},
			{field:'TBeginDate',title:'开始日期',width:100,align:'center',editor:'datebox'},
			{field:'TEndDate',title:'完成日期',width:100,align:'center',editor:'datebox'},
			{field:'TUser',title:'负责人',width:'80',align:'center',editor:usercomboboxeditor},
			{field:'TUserDR',title:'UserDR',width:'80',align:'center',hidden:true,editor:texteditor},
			{field:'TParticipant',title:'参与人',width:'80',align:'center',editor:texteditor},
			{field:'TLevel',title:'级别',width:'60',align:'center',editor:texteditor},
			{field:'TRemark',title:'备注',width:100,align:'center',editor:texteditor},
		]],
		pagination:true,
		pageSize:15,
		pageNumber:15,
		loadMsg: '正在加载信息...',
		pageList:[15,30,45,60,75],
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    	if (editFlag!="undefined")
	    	{
                $('#tDHCEQResearch').datagrid('endEdit', editFlag);
                editFlag="undefined"
            }
            else
            {
	            $('#tDHCEQResearch').datagrid('beginEdit', rowIndex);
	            editFlag =rowIndex;
	        }
        }
	});
}
function AddResearchGridData()
{
	var SourceType=$("#SourceType").val();
	var SourceID=$("#SourceID").val();
	if(editFlag>="0"){
		$('#tDHCEQResearch').datagrid('endEdit', editFlag);//结束编辑，传入之前编辑的行
	}
	$('#tDHCEQResearch').datagrid('appendRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		TRowID: '',TName:'',TType: '',TTypeDR:'',TBeginDate:'',TEndDate:'',TUser:'',TUserDR:'',TParticipant:'',TLevel:'',TRemark:''}
	);
	editFlag=0;
}

function SaveResearchGridData()
{
	if(editFlag>="0"){
		$('#tDHCEQResearch').datagrid('endEdit', editFlag);
	}
	var rows = $('#tDHCEQResearch').datagrid('getChanges');
	if(rows.length<=0){
		jQuery.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		var tmp=rows[i].TRowID+"^"+GlobalObj.EquipDR+"^"+rows[i].TName+"^"+rows[i].TTypeDR+"^"+rows[i].TBeginDate+"^"+rows[i].TEndDate+"^"+rows[i].TUserDR+"^"+rows[i].TParticipant+"^"+rows[i].TLevel+"^"+rows[i].TRemark;
		dataList.push(tmp);
	}
	var CombineData=dataList.join("&");
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQResearch',
			MethodName:'SaveResearch',
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
				$('#tDHCEQResearch').datagrid('reload');
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
function DeleteResearchGridData()
{
	var rows = $('#tDHCEQResearch').datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		if(rows[0].TRowID!=""){//Add by JYP 20160901
			jQuery.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
				if (res) {
					$.ajax({
						url:'dhceq.jquery.method.csp',
						Type:'POST',
						data:{
							ClassName:'web.DHCEQResearch',
							MethodName:'DeleteData',
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
								$('#tDHCEQResearch').datagrid('reload');
							}
							else
								$.messager.alert('删除失败！','错误代码:'+data, 'warning');
							}	
						});
				
						}
			});
		//Add by JYP 20160901
		}else{  
			var index = $('#tDHCEQResearch').datagrid('getRowIndex',rows[0]);
			$('#tDHCEQResearch').datagrid('deleteRow',index);
        }
        //End by JYP 20160901
	}else{
		 jQuery.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

function AddResearchGridData()
{
	if(editFlag>="0"){
		$('#tDHCEQResearch').datagrid('endEdit', editFlag);//结束编辑，传入之前编辑的行
	}
	//在指定行添加数据，appendRow是在最后一行添加数据
	$('#tDHCEQResearch').datagrid('appendRow', 
	{
		TRowID: '',
		TName:'',
		TType: '',
		TTypeDR:'',
		TBeginDate:'',
		TEndDate:'',
		TUser:'',
		TUserDR:'',
		TParticipant:'',
		TLevel:'',
		TRemark:''
	});
	editFlag=0;
}
var typecomboboxeditor={
	type: 'combobox',//设置编辑格式
	options: {
		panelHeight:"auto",  //设置容器高度自动增长
		    valueField:'id', 
	    	url:null,   
	    	textField:'text',
			data: [{
				id: '0',
				text: '科研项目'
			},{
				id: '1',
				text: '论文'
			}],
		onSelect:function(option){
			var ed=$('#tDHCEQResearch').datagrid('getEditor',{index:editFlag,field:'TTypeDR'});
			jQuery(ed.target).val(option.id);  
			var ed=$('#tDHCEQResearch').datagrid('getEditor',{index:editFlag,field:'TType'});
			jQuery(ed.target).combobox('setValue', option.text);  
		}
	}
}
var usercomboboxeditor={
	type: 'combobox',//设置编辑格式
	options: {
		valueField: "id", 
		textField: "text",
		panelHeight:"auto",  //设置容器高度自动增长
		url: url+'?action=GetUser',
		filter: function(q,row){  //modify by JYP20160926
			var opts = $(this).combobox('options');
			return row[opts.textField].indexOf(q)>-1;
			},
		onSelect:function(option){
			var ed=$('#tDHCEQResearch').datagrid('getEditor',{index:editFlag,field:'TUserDR'});
			jQuery(ed.target).val(option.id);  //设置ID
			var ed=$('#tDHCEQResearch').datagrid('getEditor',{index:editFlag,field:'TUser'});
			jQuery(ed.target).combobox('setValue', option.text);  //设置Desc
		}
	}
}

