/*
模块:		静脉配液中心
子模块:		静脉配液中心-配液类别关联收费项维护
Creator:	hulihua
CreateDate:	2016-12-20
*/
var editRow = ""; editDRow = ""; polid = "";
var url = "DHCST.PIVA.SETRULE.ACTION.csp";
$(function(){
	///初始化配液类别列表
	InitPivaCatList()		
	///初始化收费项列表
	InitPIVAcatOrderList();
	///初始化关联收费项医嘱列表
	$('#pivacatlist').datagrid('loadData',{total:0,rows:[]});
})

///配液类别列表
function InitPivaCatList(){
	//定义columns
	var columns=[[
	    {field:"PolId",title:'ID',width:20,align:'center',hidden:true},
	    {field:"PolDesc",title:'配液分类描述',width:360,align:'center'}
	]];  
    //定义datagrid	
    $('#pivacatlist').datagrid({    
        url:url+'?action=GetPHCPivaCatList',
        fit:true,
	    border:false,
	    singleSelect:true,
	    rownumbers:true,
	    nowrap:false,
        columns:columns,
        pageSize:10,  // 每页显示的记录条数
	    pageList:[10,20,30,50],   // 可以设置每页记录条数的列表
	    singleSelect:true,
	    loadMsg: '正在加载信息...',
	    pagination:true,
	    onLoadError:function(data){
			$.messager.alert("错误","加载数据失败,请查看错误日志!","warning");
			$('#pivacatlist').datagrid('loadData',{total:0,rows:[]});
		},
		onClickRow:function(rowIndex, rowData){
	        polid=rowData.PolId;
	        Query();		
	    }
    });
}

///收费项列表
function InitPIVAcatOrderList(){
	
	/**
	 * 文本编辑格
	 */
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	//设置其为可编辑
	var tempEditor={
		type: 'combobox',     //设置编辑格式
		options: {
			valueField: "value",
			textField: "text",
			mode:'remote',  // yunhaibao20170205,大数据量的combo采用异步,并传参至后台,queryname is q
			delay:500,
			url: url+'?action=GetAllDrugOrderList',  
			onSelect:function(option){
				var ed=$("#pivacatorderlist").datagrid('getEditor',{index:editRow,field:'OrderDescDr'});
				$(ed.target).val(option.value);  					
				var ed=$("#pivacatorderlist").datagrid('getEditor',{index:editRow,field:'OrderDesc'});
				$(ed.target).combobox('setValue', option.text);  
			}
		}
	}
	
	//定义columns
	var columns=[[
	    {field:'ID',title:'ID',width:100,editor:textEditor,hidden:true},
		{field:'OrderDescDr',title:'InstrucDr',width:100,editor:textEditor,hidden:true},
		{field:"OrderDesc",title:'收费项医嘱',width:360,align:'center',editor:tempEditor},
		{field:"OrderQty",title:'数量',width:100,align:'right',editor:textEditor}
	]];  
	/**
	 * 定义datagrid
	 */
	$('#pivacatorderlist').datagrid({
		title:'',
		url:url+'?action=GetPHCPivaLinkOrder&params='+polid,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:10,  // 每页显示的记录条数
		pageList:[10,20,30],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != ""||editRow == 0) { 
                $("#pivacatorderlist").datagrid('endEdit', editRow); 
            } 
            $("#pivacatorderlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	});
}

/// 保存编辑行
function saveRow(){
	
	if(polid==""){		
		$.messager.alert('提示','请选择需要维护的配液分类！')
		return;	
	}
	
	if(editRow>="0"){
		$("#pivacatorderlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#pivacatorderlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].OrderDesc=="")||(rowsData[i].OrderDesc==null)){
			$.messager.alert("提示","需要关联的收费项医嘱不能为空!"); 
			return false;
		}
		if((rowsData[i].OrderQty=="")||(rowsData[i].OrderQty==null)||(rowsData[i].OrderQty==0)||(rowsData[i].OrderQty==undefined)){
			$.messager.alert("提示","需要关联的收费项医嘱数量不能为空或为0!"); 
			return false;
		}

		var tmp=polid+"^"+rowsData[i].ID+"^"+rowsData[i].OrderDescDr+"^"+rowsData[i].OrderQty;
		dataList.push(tmp);
	} 
	var params=dataList.join("$$");
	//保存数据
	var data=tkMakeServerCall("web.DHCSTPIVASETPIVACAT","SavePIVALinkOrder",params)
	if(data!=""){
		if(data==-1){
			$.messager.alert("提示","需要关联的收费项为空,不能保存!"); 
		}else if(data==-2){	
			$.messager.alert('提示','更新失败!');		
		}else if(data==-11){	
			$.messager.alert('提示','该收费项已存在!');		
		}else{	
			$.messager.alert('提示','更新成功!');
			$("#pivacatorderlist").datagrid('reload');		
		}
	}
}

/// 插入新行
function insertRow(){
	if(polid==""){		
		$.messager.alert('提示','请选择需要维护的配液分类！')
		return;	
	}
	
	if(editRow>="0"){
		$("#pivacatorderlist").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#pivacatorderlist").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {ID:'', OrderDescDr:'', OrderDesc:'',OrderQty:''}
	});
	$("#pivacatorderlist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

/// 删除选中行
function deleteRow(){			
	if ($("#pivacatorderlist").datagrid('getSelections').length != 1) {		
		$.messager.alert('提示','请选一个删除');
		return;
	}
	
	var rowsData = $("#pivacatorderlist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除所选的数据吗？", function (res) {//提示是否删除
			if (res) {
				if (rowsData.ID!=""){
					var data=tkMakeServerCall("web.DHCSTPIVASETPIVACAT","DeletePIVALinkOrder",rowsData.ID)
					if(data!=""){
						if(data==-1){
							$.messager.alert("提示","没有选中需要删除的记录!"); 
						}else if(data==-2){	
							$.messager.alert('提示','删除失败!');		
						}else{	
							$.messager.alert('提示','删除成功!');		
						}
						$("#pivacatorderlist").datagrid('reload');
					}
				}else{
					var rowIndex = $('#pivacatorderlist').datagrid('getRowIndex', rowsData);
     				$('#pivacatorderlist').datagrid('deleteRow', rowIndex);  
				}
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

///关联收费项医嘱查询
function Query(){
	var params=polid;
	$('#pivacatorderlist').datagrid('load',{params:params}); 	 
}